Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226E2305737
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbhA0Jo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:44:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235088AbhA0JnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:43:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611740509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9+XEQO35jpZZz8Kh/TLi8WvBvLuZkLrSVQN0s6A3Egk=;
        b=FCzNx9ZzkwNhl1ULqfB4cG0MWxsjdRAVCPKsld5ZzTytIec1CD5ulpxrBOlvmNZv58EJiS
        fZTWI+mcjjtTQetvrFipsS0JlaqVjx1iMe6yMcE/ajmbNORv8FMqAc4gE4FYjQkG3Pzkxv
        PG+Au72ZDndk/gvBfCR9IGVzXDbpmew=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-_av6lOnRPumeR_PrcGqC7A-1; Wed, 27 Jan 2021 04:41:47 -0500
X-MC-Unique: _av6lOnRPumeR_PrcGqC7A-1
Received: by mail-ed1-f71.google.com with SMTP id j12so1038683edq.10
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 01:41:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9+XEQO35jpZZz8Kh/TLi8WvBvLuZkLrSVQN0s6A3Egk=;
        b=HViqJDYAqf/tH1mx2gt+78XR4J3BrpY11VkwjqquHWXhNJttnf8oG0GFVyIOdV0VTi
         HkeH66qKZIzEoPCGvI0mKif/frIZ3VBaY4+AUn4truJAFDl8AeH1WxnASMWf4j7RVyoE
         2ZhKEaEACQrJdNzUCPJRbLtmoPZSB1dFoieOadVLRO8G4enZ2+ctUB1w8w+LWTkDqc5Q
         IQdupZI7Wyadco7IZ4i4e7J9IJFGIOA6J97Lu0sNnZaF0lgRYxh37HFRfiaFsQtWb3iu
         tVvK11FwcZx6/AVupKE6AVwsHSRozE8XCMMq2AUo+w3s6pTiKrScpcjxMvneuQaadNqm
         GPkg==
X-Gm-Message-State: AOAM530PQzVUdS7RUeuv2ERphyxlfg1cGTUVR52ZFL4y51X8J4IKxF/u
        BQQKgjDrXwG0alASPJgVIGy4huWx/vDk8Thf29NBQufX36nR2idn5wZZMKsYpLiclgnhzyxImL4
        NUNzn32mZsu+xFCFC
X-Received: by 2002:a05:6402:1655:: with SMTP id s21mr7919955edx.360.1611740506163;
        Wed, 27 Jan 2021 01:41:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqloVCA5EZmLQuzmtRrJ4djhPB30wEkBcT01MlV3DYms06LVkAlHmjXH82AFWslFxdbTuO1g==
X-Received: by 2002:a05:6402:1655:: with SMTP id s21mr7919945edx.360.1611740505994;
        Wed, 27 Jan 2021 01:41:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cy13sm939845edb.27.2021.01.27.01.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 01:41:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E1403180349; Wed, 27 Jan 2021 10:41:44 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: RE: [PATCHv17 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
In-Reply-To: <6011183d4628_86d69208ba@john-XPS-13-9370.notmuch>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-2-liuhangbin@gmail.com>
 <6011183d4628_86d69208ba@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 27 Jan 2021 10:41:44 +0100
Message-ID: <87lfcesomf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Hangbin Liu wrote:
>> From: Jesper Dangaard Brouer <brouer@redhat.com>
>> 
>> This changes the devmap XDP program support to run the program when the
>> bulk queue is flushed instead of before the frame is enqueued. This has
>> a couple of benefits:
>> 
>> - It "sorts" the packets by destination devmap entry, and then runs the
>>   same BPF program on all the packets in sequence. This ensures that we
>>   keep the XDP program and destination device properties hot in I-cache.
>> 
>> - It makes the multicast implementation simpler because it can just
>>   enqueue packets using bq_enqueue() without having to deal with the
>>   devmap program at all.
>> 
>> The drawback is that if the devmap program drops the packet, the enqueue
>> step is redundant. However, arguably this is mostly visible in a
>> micro-benchmark, and with more mixed traffic the I-cache benefit should
>> win out. The performance impact of just this patch is as follows:
>> 
>> The bq_xmit_all's logic is also refactored and error label is removed.
>> When bq_xmit_all() is called from bq_enqueue(), another packet will
>> always be enqueued immediately after, so clearing dev_rx, xdp_prog and
>> flush_node in bq_xmit_all() is redundant. Let's move the clear to
>> __dev_flush(), and only check them once in bq_enqueue() since they are
>> all modified together.
>> 
>> By using xdp_redirect_map in sample/bpf and send pkts via pktgen cmd:
>> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
>> 
>> There are about +/- 0.1M deviation for native testing, the performance
>> improved for the base-case, but some drop back with xdp devmap prog attached.
>> 
>> Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
>> 5.10 rc6         | xdp_redirect_map   i40e->i40e  |    2.0M |   9.1M |  8.0M
>> 5.10 rc6         | xdp_redirect_map   i40e->veth  |    1.7M |  11.0M |  9.7M
>> 5.10 rc6 + patch | xdp_redirect_map   i40e->i40e  |    2.0M |   9.5M |  7.5M
>> 5.10 rc6 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  11.6M |  9.1M
>> 
>
> [...]
>
>> +static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
>> +				struct xdp_frame **frames, int n,
>> +				struct net_device *dev)
>> +{
>> +	struct xdp_txq_info txq = { .dev = dev };
>> +	struct xdp_buff xdp;
>> +	int i, nframes = 0;
>> +
>> +	for (i = 0; i < n; i++) {
>> +		struct xdp_frame *xdpf = frames[i];
>> +		u32 act;
>> +		int err;
>> +
>> +		xdp_convert_frame_to_buff(xdpf, &xdp);
>> +		xdp.txq = &txq;
>> +
>> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> +		switch (act) {
>> +		case XDP_PASS:
>> +			err = xdp_update_frame_from_buff(&xdp, xdpf);
>> +			if (unlikely(err < 0))
>> +				xdp_return_frame_rx_napi(xdpf);
>> +			else
>> +				frames[nframes++] = xdpf;
>> +			break;
>> +		default:
>> +			bpf_warn_invalid_xdp_action(act);
>> +			fallthrough;
>> +		case XDP_ABORTED:
>> +			trace_xdp_exception(dev, xdp_prog, act);
>> +			fallthrough;
>> +		case XDP_DROP:
>> +			xdp_return_frame_rx_napi(xdpf);
>> +			break;
>> +		}
>> +	}
>> +	return nframes; /* sent frames count */
>> +}
>> +
>>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>>  {
>>  	struct net_device *dev = bq->dev;
>> -	int sent = 0, drops = 0, err = 0;
>> +	unsigned int cnt = bq->count;
>> +	int drops = 0, err = 0;
>> +	int to_send = cnt;
>> +	int sent = cnt;
>>  	int i;
>>  
>> -	if (unlikely(!bq->count))
>> +	if (unlikely(!cnt))
>>  		return;
>>  
>> -	for (i = 0; i < bq->count; i++) {
>> +	for (i = 0; i < cnt; i++) {
>>  		struct xdp_frame *xdpf = bq->q[i];
>>  
>>  		prefetch(xdpf);
>>  	}
>>  
>> -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
>> +	if (bq->xdp_prog) {
>> +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
>> +		if (!to_send) {
>> +			sent = 0;
>> +			goto out;
>> +		}
>> +		drops = cnt - to_send;
>> +	}
>
> I might be missing something about how *bq works here. What happens when
> dev_map_bpf_prog_run returns to_send < cnt?
>
> So I read this as it will send [0, to_send] and [to_send, cnt] will be
> dropped? How do we know the bpf prog would have dropped the set,
> [to_send+1, cnt]?

Because dev_map_bpf_prog_run() compacts the array:

+		case XDP_PASS:
+			err = xdp_update_frame_from_buff(&xdp, xdpf);
+			if (unlikely(err < 0))
+				xdp_return_frame_rx_napi(xdpf);
+			else
+				frames[nframes++] = xdpf;
+			break;

[...]

>>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>> @@ -489,12 +516,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>>  {
>>  	struct net_device *dev = dst->dev;
>>  
>> -	if (dst->xdp_prog) {
>> -		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
>> -		if (!xdp)
>> -			return 0;
>
> So here it looks like dev_map_run_prog will not drop extra
> packets, but will see every single packet.
>
> Are we changing the semantics subtle here? This looks like
> a problem to me. We should not drop packets in the new case
> unless bpf program tells us to.

It's not a change in semantics (see above), but I'll grant you that it's
subtle :)

-Toke

