Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E911CAA94
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 14:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgEHM11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 08:27:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:41517 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgEHM11 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 08:27:27 -0400
IronPort-SDR: r30gB3sWFP+Mk3OKqg/+SiL/8+GblIzpN76CohnAb0TWF0L6NMMp+5DrBQ3+X9+XlyCEh6/Zku
 yAuKUTADD/zg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 05:27:11 -0700
IronPort-SDR: AUXHGgB/VaXoEvBK+W27rX23aAaOgc+XylFzdpMUqypqjpzeJM/gcju0TOAo7xGR7k0C7kQ26P
 3wBWxz6boOwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,367,1583222400"; 
   d="scan'208";a="305436149"
Received: from aghafar1-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.56.248])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2020 05:27:08 -0700
Subject: Re: [PATCH bpf-next 10/14] mlx5, xsk: migrate to new
 MEM_TYPE_XSK_BUFF_POOL
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
 <20200507104252.544114-11-bjorn.topel@gmail.com>
 <40eb57c7-9c47-87dc-bda9-5a1729352c43@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <3c42954a-8bb3-85b1-8740-a096b0a76a98@intel.com>
Date:   Fri, 8 May 2020 14:27:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <40eb57c7-9c47-87dc-bda9-5a1729352c43@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-08 13:55, Maxim Mikityanskiy wrote:
> On 2020-05-07 13:42, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Use the new MEM_TYPE_XSK_BUFF_POOL API in lieu of MEM_TYPE_ZERO_COPY in
>> mlx5e. It allows to drop a lot of code from the driver (which is now
>> common in AF_XDP core and was related to XSK RX frame allocation, DMA
>> mapping, etc.) and slightly improve performance.
>>
>> rfc->v1: Put back the sanity check for XSK params, use XSK API to get
>>           the total headroom size. (Maxim)
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> 
> I did some functional and performance tests.
> 
> Unfortunately, something is wrong with the traffic: I get zeros in 
> XDP_TX, XDP_PASS and XSK instead of packet data. I set DEBUG_HEXDUMP in 
> xdpsock, and it shows the packets of the correct length, but all bytes 
> are 0 after these patches. It might be wrong xdp_buff pointers, however, 
> I still have to investigate it. Björn, does it also affect Intel 
> drivers, or is it Mellanox-specific?
>

Are you getting zeros for TX, PASS *and* in xdpsock (REDIRECT:ed 
packets), or just TX and PASS?

No, I get correct packet data for AF_XDP zero-copy XDP_REDIRECT,
XDP_PASS, and XDP_TX for Intel.

> For performance, I got +1.0..+1.2 Mpps on RX. TX performance got better 
> after Björn inlined the relevant UMEM functions, however, there is still 
> a slight decrease compared to the old code. I'll try to find the 
> possible reason, but the good thing is that it's not significant anymore.
> 

Ok, so for Rx mlx5 it's the same as for i40e. Good! :-)

How much decrease on Tx?


Björn
