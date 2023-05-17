Return-Path: <netdev+bounces-3475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3144A7075BE
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 01:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 213941C21024
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DFD2A9CE;
	Wed, 17 May 2023 23:00:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019E22A9C0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 23:00:27 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0631A5270
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:00:25 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
	by mail.gandi.net (Postfix) with ESMTPSA id 1938520005;
	Wed, 17 May 2023 23:00:22 +0000 (UTC)
Message-ID: <5f1ef3e1-be8f-4bbc-a877-ec13cdc9254a@ovn.org>
Date: Thu, 18 May 2023 01:00:40 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc: i.maximets@ovn.org, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org
Content-Language: en-US
To: Antoine Tenart <atenart@kernel.org>, Dumitru Ceara <dceara@redhat.com>,
 Eric Dumazet <edumazet@google.com>
References: <20230511093456.672221-1-atenart@kernel.org>
 <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com>
 <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com>
 <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com>
 <e45f3257-dc5c-3bcd-2de4-64f478ebb470@ovn.org>
 <11ece947-a839-0026-b272-7fb07bcaf1bb@redhat.com>
 <168413833063.4854.12088632353537054947@kwain>
 <7c7fc244-012c-7760-a62e-7c31242d489a@ovn.org>
 <168422260272.35976.12561298456115365259@kwain>
 <485035ec-90f2-77fe-a3c5-21a0a40b111e@ovn.org>
 <168432511934.5394.6542526478980736820@kwain>
From: Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
In-Reply-To: <168432511934.5394.6542526478980736820@kwain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/17/23 14:05, Antoine Tenart wrote:
> Quoting Ilya Maximets (2023-05-16 23:25:19)
>> On 5/16/23 09:36, Antoine Tenart wrote:
>>>
>>> What about "indicates hash was set by layer 4 stack and provides a
>>> uniform distribution over flows"? Or/and we should we also add a
>>> disclaimer like "no guarantee on how the hash was computed"?
>>
>> I'm still not sure this is correct.  Is a NIC driver part of layer 4
>> stack?
> 
> Offloading logic with L4 fields for csum, RSS, etc; we can argue it does
> something at L4. What about this: "Provides a uniform distribution over
> L4 flows"? I does look better than the previous proposal IMHO.
> 
>> And there are lots of other inconsistencies around skb hash.  The following
>> is probably the most colorful that I found:
>>
>>    skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);
> 
>>  * Hash types refer to the protocol layer addresses which are used to
>>  * construct a packet's hash. The hashes are used to differentiate or identify
>>  * flows of the protocol layer for the hash type. Hash types are either
>>  * layer-2 (L2), layer-3 (L3), or layer-4 (L4).
>>  *
>>  * Properties of hashes:
>>  *
>>  * 1) Two packets in different flows have different hash values
>>  * 2) Two packets in the same flow should have the same hash value
> 
>> enum pkt_hash_types {
>>         PKT_HASH_TYPE_L4,       /* Input: src_IP, dst_IP, src_port, dst_port */
>> };
>>
>> Here we see that PKT_HASH_TYPE_L4 supposed to use particular fields
>> as an input.
> 
> If we strictly follow the above, do all NIC provide a L4 hash using only
> the above fields (src_IP, dst_IP, src_port, dst_port)? Having a quick
> look I'm pretty sure no, both 4 and 5-tuple can be used. What is
> important is at what level the distribution is.

I would read the above as 'at least these fields'.  In the continuation
of the comment above it's, for example, allowed to set L3 when it is, in
fact, L4.

> 
> So yes strictly speaking the above PKT_HASH_TYPE_L4 use can be a little
> surprising, but to me it's a shortcut or a missing update. For perfect
> correctness we could use
> __skb_set_hash(skb, tcp_rsk(req)->txhash, false, true) FWIW.

Only after the documentation change.

> 
> Even l4_hash w/o taking the rnd case into account does not guarantee a
> stable hash for the lifetime of a flow; what happens if packets from the
> same flow are received on two NICs using different keys and/or algs?

Following the same logic we can't really say that it "provides a uniform
distribution over L4 flows" either.  The fact that L4 fields were used
to calculate the hash, doesn't mean the hash function is any good.
So, the same way as stability can't be part of the definition, the
uniform distribution can't be as well.  And the 'l4' part of the field
name looses the meaning completely.  So, we will end up with:

  *	@l4_hash: Some number is stored in the 'hash' field.

At this point the is no reason to keep the flag at all.

In practice though, such setups are unlikley to be common.  Surely, some
adequate distribution and some stability for hashes is implied.
Not the best possible distribution and not the absolute stability, but
good enough to rely on in many cases.  And that's why the quoted comment
defines "Properties of hashes" this way.

> Being computed from L4 fields does not mean it is stable. If the stable
> property is needed, the hash has to be computed locally. And then comes
> the other topic of caching it for reuse and potential sharing across
> different consumers, sure.
> 
> Now, I'll let some time to give a chance for others to chime in.

Sure.

> 
> Thanks,
> Antoine


