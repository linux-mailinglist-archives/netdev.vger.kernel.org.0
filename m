Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1266D0E22
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjC3SxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC3SxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:53:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D644E050
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680202340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4YBDK9oa7IRSnGDsV6eC1sZG+Y0J3aQFUW2e3I1262Q=;
        b=TPyzlF64SKTrVky1PJygK378xFWnbmVFgsJKp9p3R86VL61AX3C+9APFPPGTd4Wywk4K46
        mmYA0flS1oZxYOJzDQqE1P4V0EK0B802He7d84nchAw7VhB01yC4vRVTE9uXr1CO+sGTNf
        pelfoo++NYy4Cst2y1Z+e6kaVoEl7bg=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-MOCyyzwhN2CNK9NYzYNfFg-1; Thu, 30 Mar 2023 14:52:19 -0400
X-MC-Unique: MOCyyzwhN2CNK9NYzYNfFg-1
Received: by mail-lf1-f72.google.com with SMTP id z20-20020a195e54000000b004e9609a300cso7703477lfi.2
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680202338;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YBDK9oa7IRSnGDsV6eC1sZG+Y0J3aQFUW2e3I1262Q=;
        b=qFPduNFjLor2lD/1ccgzoIFGa5Wf5BIPsKQJCAKpc/cwn+oOmnLkojEW5wOfDv/2Yn
         b93joHgR6CIqCHTGJPZ0rL9aTNB9dkuzxxtVpYgpT3qy0bPARk9SjEhhyOgqLULOE7qf
         4nFCpsBW0z/v5ckOOCj8S0IIcZZkbUceInT7szocoiU4V6PmSTyOR9to9PM3cbqYLXg2
         SARpttP1TbZnfGHiiSJ2ndPhQX2U331+j5xRt508Ao0B9EE6bN8Oda7AKU33GbbBssbd
         mDgAkXf+lG5Nxhhk+Oqa1DzBSU5C1xYmNNDmkXNyoho+AJdAqlUEIPoNehuyP8ZKpIr9
         GUUA==
X-Gm-Message-State: AAQBX9fImFASOzOpidSouWjoKsjhA3cIakz7EHthVnhAR7KePli7facW
        6/+JM99dgQ9RHZ+gzoDukdgXOB+yWWlrB+WgXU0BLk4k41ikYqIvGf+nxBUuioNcpMTpSz/BkRp
        E8QnF+7KEOPPQw3UZ
X-Received: by 2002:ac2:4219:0:b0:4db:28ce:e5ef with SMTP id y25-20020ac24219000000b004db28cee5efmr6695653lfh.0.1680202337876;
        Thu, 30 Mar 2023 11:52:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZEG6X1LBEENo7FPVYgXURXiHltW2Oz5D1+hNuhYNjG0DAXLBytpTSBkNusr0t4A1SO/5Oneg==
X-Received: by 2002:ac2:4219:0:b0:4db:28ce:e5ef with SMTP id y25-20020ac24219000000b004db28cee5efmr6695639lfh.0.1680202337545;
        Thu, 30 Mar 2023 11:52:17 -0700 (PDT)
Received: from [192.168.42.100] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id d1-20020ac24c81000000b004d85789cef1sm53324lfl.49.2023.03.30.11.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 11:52:16 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d34fe8e9-39de-2b6b-3cce-fe6bc339eb0b@redhat.com>
Date:   Thu, 30 Mar 2023 20:52:15 +0200
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
 <7ce10be6-bda2-74fc-371b-9791558af5b5@redhat.com>
 <ZCXCrWhJqXjHTV54@google.com>
In-Reply-To: <ZCXCrWhJqXjHTV54@google.com>
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



On 30/03/2023 19.11, Stanislav Fomichev wrote:
> On 03/30, Jesper Dangaard Brouer wrote:
> 
>> On 30/03/2023 01.19, Stanislav Fomichev wrote:
>> > On 03/29, Jesper Dangaard Brouer wrote:
>> >
>> > > On 29/03/2023 19.18, Stanislav Fomichev wrote:
>> > > > On 03/29, Jesper Dangaard Brouer wrote:
>> > > >
>> > > > > On 28/03/2023 23.58, Stanislav Fomichev wrote:
>> > > > > > On 03/28, Jesper Dangaard Brouer wrote:
>> > > > > > > The RSS hash type specifies what portion of packet data  NIC hardware used
>> > > > > > > when calculating RSS hash value. The RSS types are focused on Internet
>> > > > > > > traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
>> > > > > > > value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
>> > > > > > > primarily TCP vs UDP, but some hardware supports SCTP.
>> > > > > >
>> > > > > > > Hardware RSS types are differently encoded for each  hardware NIC. Most
>> > > > > > > hardware represent RSS hash type as a number. Determining L3 vs L4 often
>> > > > > > > requires a mapping table as there often isn't a pattern or sorting
>> > > > > > > according to ISO layer.
>> > > > > >
[...]
>> > Any reason it's not a XDP_RSS_L3_IPV6_EX within XDP_RSS_L3_MASK?
>> >
> 
>> Hmm... I guess it belongs with L3.
> 
>> Do notice that both IPv4 and IPv6 have a flexible header called either
>> options/extensions headers, after their fixed header. (Mlx4 HW contains this
>> info for IPv4, but I didn't extend xdp_rss_hash_type in that patch).
>> Thus, we could have a single BIT that is valid for both IPv4 and IPv6.
>> (This can help speedup packet parsing having this info).
> 
> A separate bit for both v4/v6 sounds good. But thinking more about it,
> not sure what the users are supposed to do with it. Whether the flow is 
> hashed over the extension header should a config option, not a per-packet signal?
> 

Microsoft defines which part of the IPv6 Extensions headers will be used 
for replacing either the Source (Home address) and Dest 
(Routing-Header-Type-2) IPv6 Addresses, in the hash calc, here[1]:

  [1] 
https://learn.microsoft.com/en-us/windows-hardware/drivers/network/rss-hashing-types#ndis_hash_ipv6_ex

The igc/i225 chip returns per-packet the RSS Type's with _EX added.
Thus, I implemented this per-packet basis.


>> [...]
>> >
>> > > > For example, for forward compat, I'm not sure we can assume that 
>> the people
>> > > > will do:
>> > > >      "rss_type & XDP_RSS_TYPE_L4_MASK"
>> > > > instead of something like:
>> > > >      "rss_type & 
>> (XDP_RSS_TYPE_L4_IPV4_TCP|XDP_RSS_TYPE_L4_IPV4_UDP)"
>> > > >
>> >
>> > > This code is allowed in V2 and should be. It is a choice of
>> > > BPF-programmer in line-2 to not be forward compatible with newer L4
>> > > types.
>> >
> 
>> The above code made me realize, I was wrong and you are right, we should
>> represent the L4 types as BITs (and not as numbers).
>> Even-though a single packet cannot be both UDP and TCP at the same time,
>> then it is reasonable to have a code path that want to match both UDP
>> and TCP.  If L4 types are BITs then code can do a single compare (via
>> ORing), while if they are numbers then we need more compares.
>> Thus, I'll change scheme in V3 to use BITs.
> 
> So you are saying that the following:
>      if (rss_type & (TCP|UDP)
> 
> is much faster than the following:
>      proto = rss_type & L4_MASK;
>      if (proto == TCP || proto == UDP)
> 
> ?

For XDP every instruction/cycle counts.
Just to make sure, I tested it with godbolt.org, 3 vs 4 inst.

> 
> idk, as long as we have enough bits to represent everything, I'm fine
> with either way, up to you. (not sure how much you want to constrain the 
> data
> to fit it into xdp_frame; assuming u16 is fine?)

Yes, u16 is fine.

> 
> 
>> > > > > > > This proposal change the kfunc API
>> > > bpf_xdp_metadata_rx_hash() > > > > to  return this RSS hash type on
>> > > success.
>> >
>> > > This is the real question (as also raised above)...
>> > > Should we use return value or add an argument for type?
>> >
>> > Let's fix the prototype while it's still early in the rc?
> 
>> Okay, in V3 I will propose adding an argument for the type then.
> 
> SG, thx!

> 
>> > Maybe also extend the tests to drop/decode/verify the mask?
> 
>> Yes, I/we obviously need to update the selftests.
> 
>> One problem with selftests is that it's using veth SKB-based mode, and
>> SKB's have lost the RSS hash info and converted this into a single BIT
>> telling us if this was L4 based.  Thus, its hard to do some e.g. UDP
>> type verification, but I guess we can check if expected UDP packet is
>> RSS type L4.
> 
> Yeah, sounds fair.
> 
>> In xdp_hw_metadata, I will add something that uses the RSS type bits.  I
>> was thinking to match against L4-UDP RSS type as program only AF_XDP
>> redirect UDP packets, so we can verify it was a UDP packet by HW info.
> 
> Or maybe just dump it, idk.


