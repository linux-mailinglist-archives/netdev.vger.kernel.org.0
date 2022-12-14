Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6BB64C765
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiLNKsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237750AbiLNKsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:48:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85963257
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671014856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tq0uOhmR/YyxDupH3FaZfNhyG/8fUl3WkRNheJkDueg=;
        b=MCL8PpdEUkUaeCgKJ+M/O1uiQ69nqYU/rHQfIQ12dOgpzPq1hC+m0Qxu4UjepdcR26Faqz
        UmqE3SEETiGyBvkbOOg+F39K/A7kj9I2Spssv8vt41JAj8a6jca8eyvQJ/eS2y9JXwbQFb
        NlcGVo1NViQ5DaN6o0FcO77z+3rGKUg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-141-kFOtciWeOFuPB5T7trspgg-1; Wed, 14 Dec 2022 05:47:34 -0500
X-MC-Unique: kFOtciWeOFuPB5T7trspgg-1
Received: by mail-ej1-f69.google.com with SMTP id jg25-20020a170907971900b007c0e98ad898so11162082ejc.15
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:47:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tq0uOhmR/YyxDupH3FaZfNhyG/8fUl3WkRNheJkDueg=;
        b=jKUgjbvDXnfxVXxzR1fDAdedAui+YR+kzb+J9tjawWpxg/xKxnoeqZJUzzOZNRMwa3
         p3KRid8+v60aXiZuG4+M3oK96o3OQ5zV3u6rY3iElDUPkGb3yyfq+Q7rOjlboktz7/yd
         W+DwuV2vHNSWwx7BAGwJjIXmy4BJt6a/3nIpVoZ7vI+v7Vdg39BA2BkXcOHUoaA/puew
         IB6a2wvQjL3fHRql3M8Ww8WOG6+znsjll93vJtES2XUS9XVN/82dPLACd6/kF3y2yhBE
         1aGWFHpZWG1n+hqg4SofddKVcvQ14sz3B/6yGNwljzp8axHMD131NnWIyS4VdNx5C4P+
         3/hw==
X-Gm-Message-State: ANoB5pmK5cCcUw/ti9AIRc587LqN7ViMJ7RvbSvRpDPZHjcX5gFK70B7
        kPoLTmdHu7Qw50hiLlWMK4soo2pXg8JUin5zqw5R8G/p3ATNH8WLA5XpkMguevJSE0x5gVCyo/l
        akLblt03ygHyVt4V9
X-Received: by 2002:a17:907:80c3:b0:7c4:e7b0:8491 with SMTP id io3-20020a17090780c300b007c4e7b08491mr1973072ejc.61.1671014853522;
        Wed, 14 Dec 2022 02:47:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6yplUS16GxCoprCiNnKQhgP9VpvZb2eTXqgrAj7pyRHF8auUYMLU4DFRl0/+4ebMd/4k9WDg==
X-Received: by 2002:a17:907:80c3:b0:7c4:e7b0:8491 with SMTP id io3-20020a17090780c300b007c4e7b08491mr1973061ejc.61.1671014853245;
        Wed, 14 Dec 2022 02:47:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v2-20020a170906292200b007c09d37eac7sm5603837ejd.216.2022.12.14.02.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 02:47:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A428582F541; Wed, 14 Dec 2022 11:47:31 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v4 08/15] veth: Support RX XDP
 metadata
In-Reply-To: <4bac619d-8767-1364-1924-78c05b1ecf88@redhat.com>
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-9-sdf@google.com>
 <7ca8ac2c-7c07-a52f-ec17-d1ba86fa45ab@redhat.com>
 <CAKH8qBvCxnJ2-5gd9j1HYxMA8CNi6cQM-5WOUBghiZjHUHya3A@mail.gmail.com>
 <4bac619d-8767-1364-1924-78c05b1ecf88@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 14 Dec 2022 11:47:31 +0100
Message-ID: <87a63qgt30.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <jbrouer@redhat.com> writes:

> On 13/12/2022 21.42, Stanislav Fomichev wrote:
>> On Tue, Dec 13, 2022 at 7:55 AM Jesper Dangaard Brouer
>> <jbrouer@redhat.com> wrote:
>>>
>>>
>>> On 13/12/2022 03.35, Stanislav Fomichev wrote:
>>>> The goal is to enable end-to-end testing of the metadata for AF_XDP.
>>>>
>>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>>> Cc: David Ahern <dsahern@gmail.com>
>>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>> Cc: Willem de Bruijn <willemb@google.com>
>>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>>>> Cc: xdp-hints@xdp-project.net
>>>> Cc: netdev@vger.kernel.org
>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>>> ---
>>>>    drivers/net/veth.c | 24 ++++++++++++++++++++++++
>>>>    1 file changed, 24 insertions(+)
>>>>
>>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>>> index 04ffd8cb2945..d5491e7a2798 100644
>>>> --- a/drivers/net/veth.c
>>>> +++ b/drivers/net/veth.c
>>>> @@ -118,6 +118,7 @@ static struct {
>>>>
>>>>    struct veth_xdp_buff {
>>>>        struct xdp_buff xdp;
>>>> +     struct sk_buff *skb;
>>>>    };
>>>>
>>>>    static int veth_get_link_ksettings(struct net_device *dev,
>>>> @@ -602,6 +603,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
>>>>
>>>>                xdp_convert_frame_to_buff(frame, xdp);
>>>>                xdp->rxq = &rq->xdp_rxq;
>>>> +             vxbuf.skb = NULL;
>>>>
>>>>                act = bpf_prog_run_xdp(xdp_prog, xdp);
>>>>
>>>> @@ -823,6 +825,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>>>>        __skb_push(skb, skb->data - skb_mac_header(skb));
>>>>        if (veth_convert_skb_to_xdp_buff(rq, xdp, &skb))
>>>>                goto drop;
>>>> +     vxbuf.skb = skb;
>>>>
>>>>        orig_data = xdp->data;
>>>>        orig_data_end = xdp->data_end;
>>>> @@ -1601,6 +1604,21 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>>>>        }
>>>>    }
>>>>
>>>> +static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>>>> +{
>>>> +     *timestamp = ktime_get_mono_fast_ns();
>>>
>>> This should be reading the hardware timestamp in the SKB.
>>>
>>> Details: This hardware timestamp in the SKB is located in
>>> skb_shared_info area, which is also available for xdp_frame (currently
>>> used for multi-buffer purposes).  Thus, when adding xdp-hints "store"
>>> functionality, it would be natural to store the HW TS in the same place.
>>> Making the veth skb/xdp_frame code paths able to share code.
>> 
>> Does something like the following look acceptable as well?
>> 
>> *timestamp = skb_hwtstamps(_ctx->skb)->hwtstamp;
>> if (!*timestamp)
>>          *timestamp = ktime_get_mono_fast_ns(); /* sw fallback */
>> 
>
> How can the BPF programmer tell the difference between getting hardware 
> or software timestamp?
>
> This will get really confusing when someone implements a tcpdump feature
> (like/extend xdpdump) and some packets (e.g. PTP packets) have HW
> timestamps and some don't.  The time sequence in the pcap will be strange.
>
>> Because I'd like to be able to test this path in the selftests. As
>> long as I get some number from veth_xdp_rx_timestamp, I can test it.
>> No amount of SOF_TIMESTAMPING_{SOFTWARE,RX_SOFTWARE,RAW_HARDWARE}
>> triggers non-zero hwtstamp for xsk receive path. Any suggestions?
>> 
>
> You could implement the "store" operation I mentioned before.
> For testing you can store an arbitrary value in the timestamp and check
> it later by reading it back.
>
> I can see you have changed the API to send down a pointer. Thus, a
> simple flag could implement the writing the provided timestamp.
>
> Regarding flags for reading the timestamp.  Should we be able to specify
> what clock type we are asking for?
> Have you notice that tcpdump can ask for different types of
> timestamps[1]. e.g. for hardware timestamps it is either
> 'adapter_unsynced' or 'adaptor'. (See semantic in [1])
>
>   # tcpdump -ni eth1 -j adapter_unsynced --time-stamp-precision=nano

I don't think it makes sense for XDP to *ask* for a specific timestamp
(any individual packet probably only has one, right?). But we could add
a way to query which type of timestamp is available, either as a second
argument to the same function, or as a separate one. Same thing for the
hash, BTW (skb_set_hash() also takes a type argument).

I guess the easiest would be to just add a second parameter to both
getter functions for the type, but maybe there's a performance argument
for having it be a separate kfunc (at least for timestamp)?

-Toke

