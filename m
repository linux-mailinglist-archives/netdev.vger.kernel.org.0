Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A19B114C56
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 07:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfLFGZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 01:25:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:35040 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfLFGZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 01:25:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Dec 2019 22:25:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,283,1571727600"; 
   d="scan'208";a="209361713"
Received: from amahmed2-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.32.245])
  by fmsmga008.fm.intel.com with ESMTP; 05 Dec 2019 22:25:36 -0800
Subject: Re: Possible race condition on xsk_socket__create/xsk_bind
To:     William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>
References: <CALDO+Sbd82Eqb27PezcUxTOhrD-YEsVw8cGW-abraZCLZ3fEAg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <851ad28e-dc8b-da7c-66fa-ef88d684d7d2@intel.com>
Date:   Fri, 6 Dec 2019 07:25:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CALDO+Sbd82Eqb27PezcUxTOhrD-YEsVw8cGW-abraZCLZ3fEAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-06 00:21, William Tu wrote:
> Hi,
> 
> While testing XSK using OVS, we hit an issue when create xsk,
> destroy xsk, create xsk in a short time window.
> The call to xsk_socket__create returns EBUSY due to
>    xsk_bind
>      xdp_umem_assign_dev
>        xdp_get_umem_from_qid --> return EBUSY
> 
> I found that when everything works, the sequence is
>    <ovs creates xsk>
>    xsk_bind
>      xdp_umem_assign_dev
>    <ovs destroy xsk> ...
>    xsk_release
>    xsk_destruct
>      xdp_umem_release_deferred
>        xdp_umem_release
>          xdp_umem_clear_dev --> avoid the error above
> 
> But sometimes xsk_destruct has not yet called, the
> next call to xsk_bind shows up, ex:
> 
>    <ovs creates xsk>
>    xsk_bind
>      xdp_umem_assign_dev
>    <ovs destroy xsk> ...
>    xsk_release
>    xsk_bind
>      xdp_umem_assign_dev
>        xdp_get_umem_from_qid (failed!)
>    ....
>    xsk_destruct
> 
> Is there a way to make sure the previous xsk is fully cleanup,
> so we can safely call xsk_socket__create()?
>

Yes, the async cleanup is annoying. I *think* it can be done 
synchronous, since the map doesn't linger on a sockref anymore -- 
0402acd683c6 ("xsk: remove AF_XDP socket from map when the socket is 
released").

So, it's not a race, it just asynch. :-(

I'll take a stab at fixing this!


Cheers,
Björn


> The error is reproduced by OVS using:
> ovs-vsctl -- set interface afxdp-p0 options:n_rxq=1 type="afxdp" 
> options:xdp-mode=native
> ovs-vsctl -- set interface afxdp-p0 options:n_rxq=1 type="afxdp" 
> options:xdp-mode=generic
> ovs-vsctl -- set interface afxdp-p0 options:n_rxq=1 type="afxdp" 
> options:xdp-mode=native
> This just keeps create and destroy xsk on the same device.
> 
> Thanks
> William
