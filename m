Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349126D003E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjC3Jxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjC3JxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:53:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D0D86AE
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680169890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vARvNHeJ+W89AdgUOlKd7JM+FHzR0dOpHriTAosKSAg=;
        b=PyAGQ/0x7HCIiImve6HAF8TlE5EbHXyn2OXw2dDOwlKqhyqI7ow+pShVsrWG6C+KGboVYH
        gNd6XyN3BppqZ8Tg8GMEF9VEEtdSR1FK98eEa00mSD+X0Isaj4iJZ6nioNm1u1i/WBV1l/
        3WJNcqkT594vkK1uxKmI0d8ngMlxNeA=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-_2I245C_MfK4i9JVADHryg-1; Thu, 30 Mar 2023 05:51:28 -0400
X-MC-Unique: _2I245C_MfK4i9JVADHryg-1
Received: by mail-lf1-f69.google.com with SMTP id a11-20020ac2504b000000b004e85d663fa1so7141675lfm.5
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680169887;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vARvNHeJ+W89AdgUOlKd7JM+FHzR0dOpHriTAosKSAg=;
        b=N1IYqfjkRhue3+U2uRFAAV9UduDJ5l+ZokRMbhkp8TCm9fHzjEaXvnhgsMb9WT7H1i
         1TYrgf3OrZDO1JblviwbNBVDruUFriL6OrHmli+wFmi3rp2iZBR1gks8uOkh2yVw7nAv
         HBUjhYstFydf/yvaYmn+FTxR/c6QTvnlRDDNvZ3LNZSHOlMFkSoDWqhqFyql1fnoAntS
         kJOdo/NiAY3v2NhiyG4/YMF20SGEw8eDXdbmkgFeJuZ5T5aBnMFo35f/3Cglz9h0Q1ll
         S5KVxycTAxOI2fCMa8aX0kqrcwamPt3Dwajg8vX3ZtRmai2pp8bmJNZRMqcj8Io8NSxS
         egOg==
X-Gm-Message-State: AAQBX9ecWIv52MNF1tdNVoM0lr8DWu+F1XYZW6bfofp5QFCnVJBj7E4a
        1yekWTTGev1JjehEKCvoi0MhjiqasRBfZHZtXX+VEEvop7mxKRBJKW9uDM8L1Nktdepllgenogg
        5I3cG0bPDKlP9fLlA
X-Received: by 2002:ac2:4422:0:b0:4dd:9da1:aa82 with SMTP id w2-20020ac24422000000b004dd9da1aa82mr7386846lfl.29.1680169887103;
        Thu, 30 Mar 2023 02:51:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350aYAuHqGLXqNcaucK63lT+y4cBQlu/p1fMHtBQbwRMoCVEpXYJBq5CS5/uG7hjHoGpi3exLyw==
X-Received: by 2002:ac2:4422:0:b0:4dd:9da1:aa82 with SMTP id w2-20020ac24422000000b004dd9da1aa82mr7386842lfl.29.1680169886710;
        Thu, 30 Mar 2023 02:51:26 -0700 (PDT)
Received: from [192.168.42.100] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id b16-20020a056512025000b004d85316f2d6sm5790721lfo.118.2023.03.30.02.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 02:51:26 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <7ce10be6-bda2-74fc-371b-9791558af5b5@redhat.com>
Date:   Thu, 30 Mar 2023 11:51:23 +0200
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
 <b9e5077f-fbc4-8904-74a8-cda94d91cfbf@redhat.com>
 <ZCTHc6Dp4RMi1YZ6@google.com>
In-Reply-To: <ZCTHc6Dp4RMi1YZ6@google.com>
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


On 30/03/2023 01.19, Stanislav Fomichev wrote:
> On 03/29, Jesper Dangaard Brouer wrote:
> 
>> On 29/03/2023 19.18, Stanislav Fomichev wrote:
>> > On 03/29, Jesper Dangaard Brouer wrote:
>> >
>> > > On 28/03/2023 23.58, Stanislav Fomichev wrote:
>> > > > On 03/28, Jesper Dangaard Brouer wrote:
>> > > > > The RSS hash type specifies what portion of packet data NIC hardware used
>> > > > > when calculating RSS hash value. The RSS types are focused on Internet
>> > > > > traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
>> > > > > value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
>> > > > > primarily TCP vs UDP, but some hardware supports SCTP.
>> > > >
>> > > > > Hardware RSS types are differently encoded for each hardware NIC. Most
>> > > > > hardware represent RSS hash type as a number. Determining L3  vs L4 often
>> > > > > requires a mapping table as there often isn't a pattern or sorting
>> > > > > according to ISO layer.
>> > > >
>> > > > > The patch introduce a XDP RSS hash type (xdp_rss_hash_type) that can both
>> > > > > be seen as a number that is ordered according by ISO layer, and can be bit
>> > > > > masked to separate IPv4 and IPv6 types for L4 protocols. Room is available
>> > > > > for extending later while keeping these properties. This maps and unifies
>> > > > > difference to hardware specific hashes.
>> > > >
>> > > > Looks good overall. Any reason we're making this specific layout?
>> >
>> > > One important goal is to have a simple/fast way to determining L3 vs L4,
>> > > because a L4 hash can be used for flow handling (e.g. load-balancing).
>> >
>> > > We below layout you can:
>> >
>> > >   if (rss_type & XDP_RSS_TYPE_L4_MASK)
>> > >     bool hw_hash_do_LB = true;
>> >
>> > > Or using it as a number:
>> >
>> > >   if (rss_type > XDP_RSS_TYPE_L4)
>> > >     bool hw_hash_do_LB = true;
>> >
>> > Why is it strictly better then the following?
>> >
>> > if (rss_type & (TYPE_UDP | TYPE_TCP | TYPE_SCTP)) {}
>> >
> 
>> See V2 I dropped the idea of this being a number (that idea was not a
>> good idea).
> 
> 👍
> 
>> > If we add some new L4 format, the bpf programs can be updated to support
>> > it?
>> >
>> > > I'm very open to changes to my "specific" layout.  I am in doubt if
>> > > using it as a number is the right approach and worth the trouble.
>> >
>> > > > Why not simply the following?
>> > > >
>> > > > enum {
>> > > >  ����XDP_RSS_TYPE_NONE = 0,
>> > > >  ����XDP_RSS_TYPE_IPV4 = BIT(0),
>> > > >  ����XDP_RSS_TYPE_IPV6 = BIT(1),
>> > > >  ����/* IPv6 with extension header. */
>> > > >  ����/* let's note ^^^ it in the UAPI? */
>> > > >  ����XDP_RSS_TYPE_IPV6_EX = BIT(2),
>> > > >  ����XDP_RSS_TYPE_UDP = BIT(3),
>> > > >  ����XDP_RSS_TYPE_TCP = BIT(4),
>> > > >  ����XDP_RSS_TYPE_SCTP = BIT(5),
>> >
>> > > We know these bits for UDP, TCP, SCTP (and IPSEC) are exclusive, they
>> > > cannot be set at the same time, e.g. as a packet cannot both be UDP and
>> > > TCP.  Thus, using these bits as a number make sense to me, and is more
>> > > compact.

See below, why I'm wrong (in storing this as numbers).

>> >
>> > [..]
>> >
>> > > This BIT() approach also have the issue of extending it later (forward
>> > > compatibility).  As mentioned a common task will be to check if
>> > > hash-type is a L4 type.  See mlx5 [patch 4/4] needed to extend with
>> > > IPSEC. Notice how my XDP_RSS_TYPE_L4_MASK covers all the bits that this
>> > > can be extended with new L4 types, such that existing progs will still
>> > > work checking for L4 check.  It can of-cause be solved in the same way
>> > > for this BIT() approach by reserving some bits upfront in a mask.
>> >
>> > We're using 6 bits out of 64, we should be good for awhile? If there
>> > is ever a forward compatibility issue, we can always come up with
>> > a new kfunc.
> 
>> I want/need store the RSS-type in the xdp_frame, for XDP_REDIRECT and
>> SKB use-cases.  Thus, I don't want to use 64-bit/8-bytes, as xdp_frame
>> size is limited (given it reduces headroom expansion).
> 
>> >
>> > One other related question I have is: should we export the type
>> > over some additional new kfunc argument? (instead of abusing the return
>> > type)
> 
>> Good question. I was also wondering if it wouldn't be better to add
>> another kfunc argument with the rss_hash_type?
> 
>> That will change the call signature, so that will not be easy to handle
>> between kernel releases.
> 
> Agree with Toke on a separate thread; might not be too late to fit it
> into an rc..
> 
>> > Maybe that will let us drop the explicit BTF_TYPE_EMIT as well?
> 
>> Sure, if we define it as an argument, then it will automatically
>> exported as BTF.
> 
>> > > > }
>> > > >
>> > > > And then using XDP_RSS_TYPE_IPV4|XDP_RSS_TYPE_UDP vs
>> > > > XDP_RSS_TYPE_IPV6|XXX ?
>> >
>> > > Do notice, that I already does some level of or'ing ("|") in this
>> > > proposal.  The main difference is that I hide this from the  driver, and
>> > > kind of pre-combine the valid combination (enum's) drivers can select
>> > > from. I do get the point, and I think I will come up with a combined
>> > > solution based on your input.
>> >
>> >
>> > > The RSS hashing types and combinations comes from M$ standards:
>> > >   [1] 
>> https://learn.microsoft.com/en-us/windows-hardware/drivers/network/rss-hashing-types#ipv4-hash-type-combinations
>> >
>> > My main concern here is that we're over-complicating it with the masks
>> > and the format. With the explicit bits we can easily map to that
>> > spec you mention.
> 
>> See if you like my RFC-V2 proposal better.
>> It should go more in your direction.
> 
> Yeah, I like it better. Btw, why have a separate bit for XDP_RSS_BIT_EX?

Yes, we can rename the EX bit define (which is in V2).  I reduced the
name-length, because it allowed to keep code on-one-line when OR'ing.

> Any reason it's not a XDP_RSS_L3_IPV6_EX within XDP_RSS_L3_MASK?
> 

Hmm... I guess it belongs with L3.

Do notice that both IPv4 and IPv6 have a flexible header called either 
options/extensions headers, after their fixed header. (Mlx4 HW contains 
this info for IPv4, but I didn't extend xdp_rss_hash_type in that patch).
Thus, we could have a single BIT that is valid for both IPv4 and IPv6.
(This can help speedup packet parsing having this info).

[...]
> 
>> > For example, for forward compat, I'm not sure we can assume that the people
>> > will do:
>> >      "rss_type & XDP_RSS_TYPE_L4_MASK"
>> > instead of something like:
>> >      "rss_type & (XDP_RSS_TYPE_L4_IPV4_TCP|XDP_RSS_TYPE_L4_IPV4_UDP)"
>> >
> 
>> This code is allowed in V2 and should be. It is a choice of
>> BPF-programmer in line-2 to not be forward compatible with newer L4 
>> types.
> 

The above code made me realize, I was wrong and you are right, we should
represent the L4 types as BITs (and not as numbers).
Even-though a single packet cannot be both UDP and TCP at the same time,
then it is reasonable to have a code path that want to match both UDP
and TCP.  If L4 types are BITs then code can do a single compare (via
ORing), while if they are numbers then we need more compares.
Thus, I'll change scheme in V3 to use BITs.


>> > > > > This proposal change the kfunc API bpf_xdp_metadata_rx_hash() 
>> > > > > to  return this RSS hash type on success.
> 
>> This is the real question (as also raised above)...
>> Should we use return value or add an argument for type?
> 
> Let's fix the prototype while it's still early in the rc?

Okay, in V3 I will propose adding an argument for the type then.

> Maybe also extend the tests to drop/decode/verify the mask?

Yes, I/we obviously need to update the selftests.

One problem with selftests is that it's using veth SKB-based mode, and
SKB's have lost the RSS hash info and converted this into a single BIT
telling us if this was L4 based.  Thus, its hard to do some e.g. UDP
type verification, but I guess we can check if expected UDP packet is
RSS type L4.

In xdp_hw_metadata, I will add something that uses the RSS type bits.  I
was thinking to match against L4-UDP RSS type as program only AF_XDP
redirect UDP packets, so we can verify it was a UDP packet by HW info.

--Jesper

