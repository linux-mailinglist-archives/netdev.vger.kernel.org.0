Return-Path: <netdev+bounces-3123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA9270596D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 23:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10EF8281315
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC3F271F3;
	Tue, 16 May 2023 21:25:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0224F182A4
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:25:08 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212F861AE
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:25:04 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
	by mail.gandi.net (Postfix) with ESMTPSA id ED7DB4000A;
	Tue, 16 May 2023 21:25:01 +0000 (UTC)
Message-ID: <485035ec-90f2-77fe-a3c5-21a0a40b111e@ovn.org>
Date: Tue, 16 May 2023 23:25:19 +0200
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
 <20230511093456.672221-5-atenart@kernel.org>
 <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com>
 <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com>
 <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com>
 <e45f3257-dc5c-3bcd-2de4-64f478ebb470@ovn.org>
 <11ece947-a839-0026-b272-7fb07bcaf1bb@redhat.com>
 <168413833063.4854.12088632353537054947@kwain>
 <7c7fc244-012c-7760-a62e-7c31242d489a@ovn.org>
 <168422260272.35976.12561298456115365259@kwain>
From: Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
In-Reply-To: <168422260272.35976.12561298456115365259@kwain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/16/23 09:36, Antoine Tenart wrote:
> Quoting Ilya Maximets (2023-05-15 20:23:28)
>> On 5/15/23 10:12, Antoine Tenart wrote:
>>> Quoting Dumitru Ceara (2023-05-11 22:50:32)
>>>> On 5/11/23 19:54, Ilya Maximets wrote:
>>>>>>> Note that skb->hash has never been considered as canonical, for obvious reasons.
>>>>>
>>>>> I guess, the other point here is that it's not an L4 hash either.
>>>>>
>>>>> It's a random number.  So, the documentation will still not be
>>>>> correct even after the change proposed in this patch.
>>>
>>> The proposed changed is "indicate hash is from layer 4 and provides a
>>> uniform distribution over flows", which does not describe *how* the hash
>>> is computed but *where* it comes from. This matches "random number set
>>> by TCP" and changes in how hashes are computed won't affect the comment,
>>> so we'll not end up in the same situation.
>>
>> I respectfully disagree,  "is from layer 4" and "random number" do not
>> match for me.  So, "where it comes from" argument is not applicable.
>> Random numbers come from random number generator, and not "from layer 4".
>>
>> Unless by "from layer 4" you mean "from the code that handles layer 4
>> packet processing".  But that seems very confusing to me.  And it is
>> definitely not the first thing that comes to mind while reading the
>> documentation.
> 
> Yes that is what I meant, but if that is still confusing then this is
> not improving things so let's try something better. I intentionally did
> not mention how the hash is computed because it's easy to forget to
> update the documentation when the exact logic is changed. What's
> important here IMHO is to mention what the hash provides.
> 
> What about "indicates hash was set by layer 4 stack and provides a
> uniform distribution over flows"? Or/and we should we also add a
> disclaimer like "no guarantee on how the hash was computed"?

I'm still not sure this is correct.  Is a NIC driver part of layer 4 stack?
Also it still doesn't make a lot of sense to change to comment without
changing the code.

And there are lots of other inconsistencies around skb hash.  The following
is probably the most colorful that I found:

TCP code in tcp_make_synack() calls:

   skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);

Where 'txhash' is a random number.  But it calls it PKT_HASH_TYPE_L4.

Going to the definition we can find this [1]:

/*
 * Packet hash types specify the type of hash in skb_set_hash.
 *
 * Hash types refer to the protocol layer addresses which are used to
 * construct a packet's hash. The hashes are used to differentiate or identify
 * flows of the protocol layer for the hash type. Hash types are either
 * layer-2 (L2), layer-3 (L3), or layer-4 (L4).
 *
 * Properties of hashes:
 *
 * 1) Two packets in different flows have different hash values
 * 2) Two packets in the same flow should have the same hash value

Now this directly contradicts to the hash being not stable and not being
computed form actual packet fields.

Later in the same file:

enum pkt_hash_types {
	PKT_HASH_TYPE_NONE,	/* Undefined type */
	PKT_HASH_TYPE_L2,	/* Input: src_MAC, dest_MAC */
	PKT_HASH_TYPE_L3,	/* Input: src_IP, dst_IP */
	PKT_HASH_TYPE_L4,	/* Input: src_IP, dst_IP, src_port, dst_port */
};

Here we see that PKT_HASH_TYPE_L4 supposed to use particular fields
as an input.

It's kind of pointless having all that documented if the l4_hash flag
is a random number and none of the kernel subsystems are able to use
it in a way it is documented.

[1] https://elixir.bootlin.com/linux/v6.4-rc1/source/include/linux/skbuff.h#L1419

Best regards, Ilya Maximets.

