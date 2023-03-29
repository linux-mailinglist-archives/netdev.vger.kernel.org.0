Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0808C6CF20D
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjC2SUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2SUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:20:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB604204
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680114003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gQJesUxnFKqgiarOkDz2JwDNpFkGj1zpEAjUJlQpgaY=;
        b=iJzR3FJG9lmn2FLWot74oBzQxL0LMymst4rw13+7d9y/hu4s3H27mtWpR9+m2mkfvTpPb0
        Lw/YxW/+Hq2jmK+m9WXwP6N596DuuYtfQE6C3AfrvkOBvFIBnTJcnlr1oc2ls+klTkssJc
        dBbvEird3bWS6sUXzNzj2UtC57o0M2k=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-rPcZD68DPDCHp2y38E3gjA-1; Wed, 29 Mar 2023 14:20:02 -0400
X-MC-Unique: rPcZD68DPDCHp2y38E3gjA-1
Received: by mail-ed1-f70.google.com with SMTP id m18-20020a50d7d2000000b00501dfd867a4so23718419edj.20
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680114001;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gQJesUxnFKqgiarOkDz2JwDNpFkGj1zpEAjUJlQpgaY=;
        b=1o3bZ7E3bMr5Q/7xXDA/lw6Ue9A//SjcMCckr/hD9QckP6xDLnouHXEx0PyeHgCXuL
         JSuNlv706SfUXRUHRAod79ePd7Dc67GlBAoi4zfD9zKG5JE1TsZlXcZh8B4vaZe//HMI
         bXGu3p6pilalcKszKd+peXMe6inprSOMNtpOd4xxz259OkNcSTZfpmeS9Eh/bzjYCVJr
         yXnnXUYrwfMfNfryMUWChSQx+S9GkB4xuBICv06QLqbKvRDSng+zn/boqJBD+rLTmh6R
         2xIz7XBhur2/3ZVe14xBJ/y7aEr1/LBfF/uKZbSkgxQt6Un70ir77hBX23cSecpsGXs2
         /fzA==
X-Gm-Message-State: AAQBX9fZutz30smFQByBbvjwH3bNpZuXHQSkX81/BBSle1ewJUjCUviw
        /jlLV02BpcM3sMN/wTV1JuCtLbgo89JR7L+4Q/B0Xyj43Q6tyyKFjTx806KRQdUCPPSIgpcD5J+
        eRMTRLrsq2nEbG3A5
X-Received: by 2002:a17:906:d117:b0:93b:a0c8:1cec with SMTP id b23-20020a170906d11700b0093ba0c81cecmr22268591ejz.32.1680114001209;
        Wed, 29 Mar 2023 11:20:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZUWaOjgV1IE1t9AH5dAFmEEVhMdzH2/G4HwhCRXgJx0Hh4qa1/fFlOoCH37s5FCywLH99t6w==
X-Received: by 2002:a17:906:d117:b0:93b:a0c8:1cec with SMTP id b23-20020a170906d11700b0093ba0c81cecmr22268560ejz.32.1680114000870;
        Wed, 29 Mar 2023 11:20:00 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id gx24-20020a170906f1d800b0092d16623eeasm16798089ejb.138.2023.03.29.11.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 11:20:00 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <b9e5077f-fbc4-8904-74a8-cda94d91cfbf@redhat.com>
Date:   Wed, 29 Mar 2023 20:19:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf RFC 1/4] xdp: rss hash types representation
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <168003451121.3027256.13000250073816770554.stgit@firesoul>
 <168003455815.3027256.7575362149566382055.stgit@firesoul>
 <ZCNjHAY81gS02FVW@google.com>
 <811724e2-cdd6-15fe-b176-9dfcdbd98bad@redhat.com>
 <ZCRy2f170FQ+fXsp@google.com>
In-Reply-To: <ZCRy2f170FQ+fXsp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/03/2023 19.18, Stanislav Fomichev wrote:
> On 03/29, Jesper Dangaard Brouer wrote:
> 
>> On 28/03/2023 23.58, Stanislav Fomichev wrote:
>> > On 03/28, Jesper Dangaard Brouer wrote:
>> > > The RSS hash type specifies what portion of packet data NIC hardware used
>> > > when calculating RSS hash value. The RSS types are focused on Internet
>> > > traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
>> > > value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
>> > > primarily TCP vs UDP, but some hardware supports SCTP.
>> >
>> > > Hardware RSS types are differently encoded for each hardware NIC. Most
>> > > hardware represent RSS hash type as a number. Determining L3 vs L4 often
>> > > requires a mapping table as there often isn't a pattern or sorting
>> > > according to ISO layer.
>> >
>> > > The patch introduce a XDP RSS hash type (xdp_rss_hash_type) that can both
>> > > be seen as a number that is ordered according by ISO layer, and can be bit
>> > > masked to separate IPv4 and IPv6 types for L4 protocols. Room is available
>> > > for extending later while keeping these properties. This maps and unifies
>> > > difference to hardware specific hashes.
>> >
>> > Looks good overall. Any reason we're making this specific layout?
> 
>> One important goal is to have a simple/fast way to determining L3 vs L4,
>> because a L4 hash can be used for flow handling (e.g. load-balancing).
> 
>> We below layout you can:
> 
>>   if (rss_type & XDP_RSS_TYPE_L4_MASK)
>>     bool hw_hash_do_LB = true;
> 
>> Or using it as a number:
> 
>>   if (rss_type > XDP_RSS_TYPE_L4)
>>     bool hw_hash_do_LB = true;
> 
> Why is it strictly better then the following?
> 
> if (rss_type & (TYPE_UDP | TYPE_TCP | TYPE_SCTP)) {}
> 

See V2 I dropped the idea of this being a number (that idea was not a
good idea).

> If we add some new L4 format, the bpf programs can be updated to support
> it?
> 
>> I'm very open to changes to my "specific" layout.  I am in doubt if
>> using it as a number is the right approach and worth the trouble.
> 
>> > Why not simply the following?
>> >
>> > enum {
>> >  ����XDP_RSS_TYPE_NONE = 0,
>> >  ����XDP_RSS_TYPE_IPV4 = BIT(0),
>> >  ����XDP_RSS_TYPE_IPV6 = BIT(1),
>> >  ����/* IPv6 with extension header. */
>> >  ����/* let's note ^^^ it in the UAPI? */
>> >  ����XDP_RSS_TYPE_IPV6_EX = BIT(2),
>> >  ����XDP_RSS_TYPE_UDP = BIT(3),
>> >  ����XDP_RSS_TYPE_TCP = BIT(4),
>> >  ����XDP_RSS_TYPE_SCTP = BIT(5),
> 
>> We know these bits for UDP, TCP, SCTP (and IPSEC) are exclusive, they
>> cannot be set at the same time, e.g. as a packet cannot both be UDP and
>> TCP.  Thus, using these bits as a number make sense to me, and is more
>> compact.
> 
> [..]
> 
>> This BIT() approach also have the issue of extending it later (forward
>> compatibility).  As mentioned a common task will be to check if
>> hash-type is a L4 type.  See mlx5 [patch 4/4] needed to extend with
>> IPSEC. Notice how my XDP_RSS_TYPE_L4_MASK covers all the bits that this
>> can be extended with new L4 types, such that existing progs will still
>> work checking for L4 check.  It can of-cause be solved in the same way
>> for this BIT() approach by reserving some bits upfront in a mask.
> 
> We're using 6 bits out of 64, we should be good for awhile? If there
> is ever a forward compatibility issue, we can always come up with
> a new kfunc.

I want/need store the RSS-type in the xdp_frame, for XDP_REDIRECT and
SKB use-cases.  Thus, I don't want to use 64-bit/8-bytes, as xdp_frame
size is limited (given it reduces headroom expansion).

> 
> One other related question I have is: should we export the type
> over some additional new kfunc argument? (instead of abusing the return
> type) 

Good question. I was also wondering if it wouldn't be better to add
another kfunc argument with the rss_hash_type?

That will change the call signature, so that will not be easy to handle
between kernel releases.


> Maybe that will let us drop the explicit BTF_TYPE_EMIT as well?

Sure, if we define it as an argument, then it will automatically
exported as BTF.

>> > }
>> >
>> > And then using XDP_RSS_TYPE_IPV4|XDP_RSS_TYPE_UDP vs
>> > XDP_RSS_TYPE_IPV6|XXX ?
> 
>> Do notice, that I already does some level of or'ing ("|") in this
>> proposal.  The main difference is that I hide this from the driver, and
>> kind of pre-combine the valid combination (enum's) drivers can select
>> from. I do get the point, and I think I will come up with a combined
>> solution based on your input.
> 
> 
>> The RSS hashing types and combinations comes from M$ standards:
>>   [1] 
>> https://learn.microsoft.com/en-us/windows-hardware/drivers/network/rss-hashing-types#ipv4-hash-type-combinations
> 
> My main concern here is that we're over-complicating it with the masks
> and the format. With the explicit bits we can easily map to that
> spec you mention.

See if you like my RFC-V2 proposal better.
It should go more in your direction.

> 
> For example, for forward compat, I'm not sure we can assume that the people
> will do:
>      "rss_type & XDP_RSS_TYPE_L4_MASK"
> instead of something like:
>      "rss_type & (XDP_RSS_TYPE_L4_IPV4_TCP|XDP_RSS_TYPE_L4_IPV4_UDP)"
> 

This code is allowed in V2 and should be. It is a choice of
BPF-programmer in line-2 to not be forward compatible with newer L4 types.

>> > > This proposal change the kfunc API bpf_xdp_metadata_rx_hash() to  return
>> > > this RSS hash type on success.

This is the real question (as also raised above)...
Should we use return value or add an argument for type?

--Jesper

