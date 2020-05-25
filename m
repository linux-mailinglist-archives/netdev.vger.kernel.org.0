Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60A1E0847
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 09:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgEYHzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 03:55:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:26233 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgEYHzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 03:55:04 -0400
IronPort-SDR: 6n4FYji00a8CfdnOCCZih/lvg96xXuoP5Cq8umscWaPq7D1qGSrV7eiyOjYf76hTLxv6sT0PdF
 eOQGBPLWHe+w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 00:55:03 -0700
IronPort-SDR: ZUU7y0ldhOKcMe47IenOB+zp9EpgfV5RlZRvfH9CA1w+v42aOtaKyQMPCtN7bbVmGKDWy3ICdS
 iQr/7v39W2oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,432,1583222400"; 
   d="scan'208";a="266081316"
Received: from bpawlows-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.40.57])
  by orsmga003.jf.intel.com with ESMTP; 25 May 2020 00:55:00 -0700
Subject: Re: XDP socket DOS bug
To:     =?UTF-8?Q?Minh_B=c3=b9i_Quang?= <minhquangbui99@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <CACtPs=GGvV-_Yj6rbpzTVnopgi5nhMoCcTkSkYrJHGQHJWFZMQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <7770a3cd-f46d-34f8-c0d6-7717dceaff7f@intel.com>
Date:   Mon, 25 May 2020 09:54:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CACtPs=GGvV-_Yj6rbpzTVnopgi5nhMoCcTkSkYrJHGQHJWFZMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-05-20 17:16, Minh Bùi Quang wrote:
> Dear sir,
> In function xdp_umem_reg (net/xdp/xdp_umem.c), there is an initialization
>           //size is u64
>           umem->npgs = size / PAGE_SIZE;
> When look at the definition of xdp_umem struct, I see
>          struct xdp_umem {
>                   .....
>                   u32 npgs;
>                   .....
>          }
> npgs is u32, however the result of division can be bigger than u32
> (there is no limit in size which is u64), so the result can be
> truncated when assigned to npgs. For example, size is 0x1 000 0000
> 8000, result of division is 0x1 0000 0008, and the npgs is truncated
> to 0x8.

Apologies for the slow response.

Nice catch! I'll cook a patch to address the overflow!


Björn

> ======
> In the process of analyzing the consequence of this bug, I found that
> only npgs pages get mapped and the size is used to initialize
> queue->size. queue->size is used to validate the address provided in
> user-supplied xdp_desc in tx path (xdp_generic_xmit). In
> xdp_generic_xmit the address provided passed the size check and reach
> xdp_umem_get_data. That address is then used as and index to
> umem->pages to get real virtual address. This leads to an out of bound
> read in umem->pages and if the attacker spray some addresses, he can
> use this bug to get arbitrary read.
> However, I cannot see any ways to intercept the xdp packet because
> that packet is sent to bpf program by design. Therefore, I cannot get
> info leak using this bug but I can craft a poc to get kernel panic on
> normal user as long as CONFIG_USER_NS=y.
> 
> Regards,
> Bui Quang Minh
> 
