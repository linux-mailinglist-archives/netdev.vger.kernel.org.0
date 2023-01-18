Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3934672252
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjARQBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjARQAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:00:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2FB366BD
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674057443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPeXXcK1CLj+cNYv/ExZzXS5GW+iGRbyo/9GsYa24Gs=;
        b=Dxvx1iM8f4i1axJvEqkgx+bllOt/O1B45kYzLrbVLo4yWLcFK7TOsTtKCpcjdUgHTNCKsX
        vyeMZQM4ExkWs0fhjD7xRMAZb8qQNKNR5OCXR/1Xt4CiBP/DkoRdo+CMMcl3VQdKeo4PFK
        qfzv3ClmVxtAsTy61voZn8yElKLTOCw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-219-JVNNIUpYOgyitwcOGYqlOg-1; Wed, 18 Jan 2023 10:57:21 -0500
X-MC-Unique: JVNNIUpYOgyitwcOGYqlOg-1
Received: by mail-ed1-f70.google.com with SMTP id l17-20020a056402255100b00472d2ff0e59so23923028edb.19
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:57:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPeXXcK1CLj+cNYv/ExZzXS5GW+iGRbyo/9GsYa24Gs=;
        b=StCPTQbxhJy2p9T4GBV+0CztO6RyqSsFvnntq785Sxgn8ooJ6HEzlDnmy3FbPSo3Yd
         9zP7sfv+IB5175P7l67lTg0Ds/7FjbHydcXPIYmbuRyCHHwot6XdcCfnqiqlAmIjEsWz
         fJMbsscAHzEOxk5MGcPemKVFvMPsd0B7jvBVti4/A8pNXgRShf0O3115Z8Vku/6HGtks
         8zcxJDDr9NJAahNx77T+eT2f3Now52ddtjd9p9wE8fJ4pu/ArBq4u0liAyojztuxEawh
         IS1jZttoJta/T5mS2N3x0UylkLADZu2dvtC4J00eL4nAnzqL5dnww+mTuozv91lBEoN+
         LcKA==
X-Gm-Message-State: AFqh2kq8ArXbXNZuApgS1Spdjdp8wKFUfKncJeRj9HaGiEx7tct9K4z8
        ecnvtXiDIaiVGls/bsa0OVDfh3wm5Hnh7FT8xIPmR3kFU5VBZOnkDllhMcY2dZgPQGW9+QNEIyc
        xYWlJj4i+KhCscEgI
X-Received: by 2002:aa7:d6d7:0:b0:498:3bb9:941 with SMTP id x23-20020aa7d6d7000000b004983bb90941mr7282530edr.19.1674057439527;
        Wed, 18 Jan 2023 07:57:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsRq3jLwOckVMMn3yYawyeZbVTC97znxUv2mZJvnRi+pwMF+wk2kPCOBiFT8hkCauO7cDh/IA==
X-Received: by 2002:aa7:d6d7:0:b0:498:3bb9:941 with SMTP id x23-20020aa7d6d7000000b004983bb90941mr7282498edr.19.1674057439284;
        Wed, 18 Jan 2023 07:57:19 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id ba6-20020a0564021ac600b0045cf4f72b04sm14250683edb.94.2023.01.18.07.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 07:57:18 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <f24074b4-5df2-155f-2c6e-f0078e080b55@redhat.com>
Date:   Wed, 18 Jan 2023 16:57:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
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
Subject: Re: [PATCH bpf-next v7 10/17] veth: Support RX XDP metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-11-sdf@google.com>
 <a5ce7ac4-7901-6146-2c2a-5b4958c14e11@redhat.com>
 <CAKH8qBszqz7Qi=E0=gsF0KDHqw4+QEWYyQvqRyS2_E_UsjNKvw@mail.gmail.com>
In-Reply-To: <CAKH8qBszqz7Qi=E0=gsF0KDHqw4+QEWYyQvqRyS2_E_UsjNKvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/01/2023 21.33, Stanislav Fomichev wrote:
> On Mon, Jan 16, 2023 at 8:21 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>> On 12/01/2023 01.32, Stanislav Fomichev wrote:
>>> The goal is to enable end-to-end testing of the metadata for AF_XDP.
>>
>> For me the goal with veth goes beyond *testing*.
>>
>> This patch ignores the xdp_frame case.  I'm not blocking this patch, but
>> I'm saying we need to make sure there is a way forward for accessing
>> XDP-hints when handling redirected xdp_frame's.
> 
> Sure, let's work towards getting that other part addressed!
> 
>> I have two use-cases we should cover (as future work).
>>
>> (#1) We have customers that want to redirect from physical NIC hardware
>> into containers, and then have the veth XDP-prog (selectively) redirect
>> into an AF_XDP socket (when matching fastpath packets).  Here they
>> (minimum) want access to the XDP hint info on HW checksum.
>>
>> (#2) Both veth and cpumap can create SKBs based on xdp_frame's.  Here it
>> is essential to get HW checksum and HW hash when creating these SKBs
>> (else netstack have to do expensive csum calc and parsing in
>> flow-dissector).
> 
>  From my PoW, I'd probably have to look into the TX side first (tx
> timestamp) before looking into xdp->skb path. So if somebody on your
> side has cycles, feel free to drive this effort. I'm happy to provide
> reviews/comments/etc. I think we've discussed in the past that this
> will most likely look like another set of "export" kfuncs?
> 

I can use some cycles to look at this and come-up with some PoC code.

Yes, I'm thinking of creating 'another set of "export" kfuncs' as you 
say. I'm no-longer suggesting to add a "store" flag to this patchsets 
kfuncs.

The advantages with another set of store/export kfuncs are that these 
can live in the core-kernel code (e.g. not in drivers), and hopefully we 
can "unroll" these as BPF-prog code (as you did earlier).


> We can start with extending new
> Documentation/networking/xdp-rx-metadata.rst with a high-level design.

Sure, but I'll try to get some code working first.

>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>> Cc: David Ahern <dsahern@gmail.com>
>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: Willem de Bruijn <willemb@google.com>
>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>>> Cc: xdp-hints@xdp-project.net
>>> Cc: netdev@vger.kernel.org
>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>> ---
>>>    drivers/net/veth.c | 31 +++++++++++++++++++++++++++++++
>>>    1 file changed, 31 insertions(+)
>>>
>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>> index 70f50602287a..ba3e05832843 100644
>>> --- a/drivers/net/veth.c
>>> +++ b/drivers/net/veth.c
>>> @@ -118,6 +118,7 @@ static struct {
>>>
>>>    struct veth_xdp_buff {
>>>        struct xdp_buff xdp;
>>> +     struct sk_buff *skb;
>>>    };
>>>
>>>    static int veth_get_link_ksettings(struct net_device *dev,
>>> @@ -602,6 +603,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
>>>
>>>                xdp_convert_frame_to_buff(frame, xdp);
>>>                xdp->rxq = &rq->xdp_rxq;
>>> +             vxbuf.skb = NULL;
>>>
>>>                act = bpf_prog_run_xdp(xdp_prog, xdp);
>>>
>>> @@ -823,6 +825,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>>>        __skb_push(skb, skb->data - skb_mac_header(skb));
>>>        if (veth_convert_skb_to_xdp_buff(rq, xdp, &skb))
>>>                goto drop;
>>> +     vxbuf.skb = skb;
>>>
>>>        orig_data = xdp->data;
>>>        orig_data_end = xdp->data_end;
>>> @@ -1602,6 +1605,28 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>>>        }
>>>    }
>>>
>>> +static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>>> +{
>>> +     struct veth_xdp_buff *_ctx = (void *)ctx;
>>> +
>>> +     if (!_ctx->skb)
>>> +             return -EOPNOTSUPP;
>>> +
>>> +     *timestamp = skb_hwtstamps(_ctx->skb)->hwtstamp;
>>
>> The SKB stores this skb_hwtstamps() in skb_shared_info memory area.
>> This memory area is actually also available to xdp_frames.  Thus, we
>> could store the HW rx_timestamp in same location for redirected
>> xdp_frames.  This could make code path sharing possible between SKB vs
>> xdp_frame in veth.
>>
>> This would also make it fast to "transfer" HW rx_timestamp when creating
>> an SKB from an xdp_frame, as data is already written in the correct place.
>>
>> Performance wise the down-side is that skb_shared_info memory area is in
>> a separate cacheline.  Thus, when no HW rx_timestamp is available, then
>> it is very expensive for a veth XDP bpf-prog to access this, just to get
>> a zero back.  Having an xdp_frame->flags bit that knows if HW
>> rx_timestamp have been stored, can mitigate this.
> 
> That's one way to do it; although I'm not sure about the cases which
> don't use xdp_frame and use stack-allocated xdp_buff.

Above I should have said xdp_buff->flags, to make it more clear that 
this doesn't depend on xdp_frame.  The xdp_buff->flags gets copied to 
xdp_frame->flags, so I see them as equivalent.

The skb_shared_info memory area is also available to xdp_buff's.
(See code #define xdp_data_hard_end in include/net/xdp.h)


>>> +     return 0;
>>> +}
>>> +
>>> +static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
>>> +{
>>> +     struct veth_xdp_buff *_ctx = (void *)ctx;
>>> +
>>> +     if (!_ctx->skb)
>>> +             return -EOPNOTSUPP;
>>
>> For xdp_frame case, I'm considering simply storing the u32 RX-hash in
>> struct xdp_frame.  This makes it easy to extract for xdp_frame to SKB
>> create use-case.
>>
>> As have been mentioned before, the SKB also requires knowing the RSS
>> hash-type.  This HW hash-type actually contains a lot of information,
>> that today is lost when reduced to the SKB hash-type.  Due to
>> standardization from Microsoft, most HW provide info on (L3) IPv4 or
>> IPv6, and on (L4) TCP or UDP (and often SCTP).  Often hardware
>> descriptor also provide info on the header length.  Future work in this
>> area is exciting as we can speedup parsing of packets in XDP, if we can
>> get are more detailed HW info on hash "packet-type".
> 
> Something like the version we've discussed a while back [0]?
> Seems workable overall if we remove it from the UAPI? (not everyone
> was happy about UAPI parts IIRC)
> 
> 0: https://lore.kernel.org/bpf/20221115030210.3159213-7-sdf@google.com/

Yes, somewhat similar to [0].
Except that:

(1) Have a more granular design with more kfuncs for individually 
exporting hints (like this patchset) giving BPF-programmer more 
flexibility. (but unroll BPF-byte code to avoid func-call overhead).

(2) No UAPI, except the kfunc calls, and kernel-code can hide where the 
hints are stored, e.g. as member in struct xdp_frame, in skb_shared_info 
memory area, or somehow in metadata memory area. (Hopefully avoiding too 
much bikesheeting about memory area as we are free to change this later).

--Jesper

