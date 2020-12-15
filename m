Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28412DAF6D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgLOOwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:52:12 -0500
Received: from www62.your-server.de ([213.133.104.62]:44970 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730081AbgLOOv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:51:59 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kpBfQ-00074i-V3; Tue, 15 Dec 2020 15:51:08 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kpBfQ-0009k5-NV; Tue, 15 Dec 2020 15:51:08 +0100
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, brouer@redhat.com, alexander.duyck@gmail.com,
        saeed@kernel.org
References: <cover.1607794551.git.lorenzo@kernel.org>
 <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
 <20201215123643.GA23785@ranger.igk.intel.com>
 <20201215134710.GB5477@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6886cd02-8dec-1905-b878-d45ee9a0c9b4@iogearbox.net>
Date:   Tue, 15 Dec 2020 15:51:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201215134710.GB5477@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26017/Mon Dec 14 15:33:39 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/20 2:47 PM, Lorenzo Bianconi wrote:
[...]
>>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>>> index 329397c60d84..61d3f5f8b7f3 100644
>>> --- a/drivers/net/xen-netfront.c
>>> +++ b/drivers/net/xen-netfront.c
>>> @@ -866,10 +866,8 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
>>>   
>>>   	xdp_init_buff(xdp, XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
>>>   		      &queue->xdp_rxq);
>>> -	xdp->data_hard_start = page_address(pdata);
>>> -	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
>>> +	xdp_prepare_buff(xdp, page_address(pdata), XDP_PACKET_HEADROOM, len);
>>>   	xdp_set_data_meta_invalid(xdp);
>>> -	xdp->data_end = xdp->data + len;
>>>   
>>>   	act = bpf_prog_run_xdp(prog, xdp);
>>>   	switch (act) {
>>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>>> index 3fb3a9aa1b71..66d8a4b317a3 100644
>>> --- a/include/net/xdp.h
>>> +++ b/include/net/xdp.h
>>> @@ -83,6 +83,18 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
>>>   	xdp->rxq = rxq;
>>>   }
>>>   
>>> +static inline void

nit: maybe __always_inline

>>> +xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
>>> +		 int headroom, int data_len)
>>> +{
>>> +	unsigned char *data = hard_start + headroom;
>>> +
>>> +	xdp->data_hard_start = hard_start;
>>> +	xdp->data = data;
>>> +	xdp->data_end = data + data_len;
>>> +	xdp->data_meta = data;
>>> +}
>>> +
>>>   /* Reserve memory area at end-of data area.
>>>    *

For the drivers with xdp_set_data_meta_invalid(), we're basically setting xdp->data_meta
twice unless compiler is smart enough to optimize the first one away (did you double check?).
Given this is supposed to be a cleanup, why not integrate this logic as well so the
xdp_set_data_meta_invalid() doesn't get extra treatment?

Thanks,
Daniel
