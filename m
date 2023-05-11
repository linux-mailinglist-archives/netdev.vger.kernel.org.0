Return-Path: <netdev+bounces-1920-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E12656FF8DC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A6E428145A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A308F70;
	Thu, 11 May 2023 17:54:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78957443A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:54:10 +0000 (UTC)
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DFB5BB7
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:54:01 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
	by mail.gandi.net (Postfix) with ESMTPSA id 51B1E24000A;
	Thu, 11 May 2023 17:53:57 +0000 (UTC)
Message-ID: <e45f3257-dc5c-3bcd-2de4-64f478ebb470@ovn.org>
Date: Thu, 11 May 2023 19:54:16 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc: i.maximets@ovn.org, Antoine Tenart <atenart@kernel.org>,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org
Content-Language: en-US
To: Dumitru Ceara <dceara@redhat.com>, Eric Dumazet <edumazet@google.com>
References: <20230511093456.672221-1-atenart@kernel.org>
 <20230511093456.672221-5-atenart@kernel.org>
 <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com>
 <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com>
 <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com>
From: Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
In-Reply-To: <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/11/23 15:00, Dumitru Ceara wrote:
> On 5/11/23 14:33, Eric Dumazet wrote:
>> On Thu, May 11, 2023 at 2:10 PM Dumitru Ceara <dceara@redhat.com> wrote:
>>>
>>> Hi Antoine,
>>>
>>> On 5/11/23 11:34, Antoine Tenart wrote:
>>>> Since commit 877d1f6291f8 ("net: Set sk_txhash from a random number")
>>>> sk->sk_txhash is not a canonical 4-tuple hash. sk->sk_txhash is
>>>> used in the TCP Tx path to populate skb->hash, with skb->l4_hash=1.
>>>> With this, skb->l4_hash does not always indicate the hash is a
>>>> "canonical 4-tuple hash over transport ports" but rather a hash from L4
>>>> layer to provide a uniform distribution over flows. Reword the comment
>>>> accordingly, to avoid misunderstandings.
>>>
>>> But AFAIU the hash used to be a canonical 4-tuple hash and was used as
>>> such by other components, e.g., OvS:
>>>
>>> https://elixir.bootlin.com/linux/latest/source/net/openvswitch/actions.c#L1069
>>>
>>> It seems to me at least unfortunate that semantics change without
>>> considering other users.  The fact that we now fix the documentation
>>> makes it seem like OvS was wrong to use the skb hash.  However, before
>>> 877d1f6291f8 ("net: Set sk_txhash from a random number") it was OK for
>>> OvS to use the skb hash as a canonical 4-tuple hash.
>>>
>>
>> I do not think we can undo stuff that was done back in 2015
>>
> 
> I understand.  I guess I was kind of grasping at straws in the hope of
> getting a canonical 4-tuple hash.
> 
>> Has anyone complained ?
>>
> 
> It did go unnoticed for a while but recently we started getting
> (indirect) reports due to the hash changing.
> 
> This one is from an upstream OVN (OvS) user:
> https://github.com/ovn-org/ovn/issues/112
> 
> This is from an OpenShift (also running OVN/OvS) user:
> https://issues.redhat.com/browse/OCPBUGS-7406
> 
>> Note that skb->hash has never been considered as canonical, for obvious reasons.

I guess, the other point here is that it's not an L4 hash either.

It's a random number.  So, the documentation will still not be
correct even after the change proposed in this patch.


One other solution to the problem might be to stop setting l4_hash
flag while it's a random number.

One way to not break everything doing that will be to introduce a
new flag, e.g. 'rnd_hash' that will be a hash that is "not related
to packet fields, but provides a uniform distribution over flows".

skb_get_hash() then may return the current hash if it's any of
l4, rnd or sw.  That should preserve the current logic across
the kernel code.
But having a new flag, we could introduce a new helper, for example
skb_get_stable_hash() or skb_get_hash_nonrandom() or something like
that, that will be equal to the current version of skb_get_hash(),
i.e. not take the random hash into account.

Affected subsystems (OVS, ECMP, SRv6) can be changed to use that
new function.  This way these subsystems will get a software hash
based on the real packet fields, if it was originally random.
This will also preserve ability to use hash provided by the HW,
since it is not normally random.

With that, we'll also not need to have in the API something that has
'L4' in the name and in the docs, but has no relation to packet fields.
It can be argued that the description in the doc doesn't mean that
this hash is computed using L4 packet fields, but it's confusing
regardless and getting overlooked while creating new code, as it
shown by the issues in multiple substystems.

Hope this makes some sense.


Dumitru also had some alternative ideas on how to provide a stable
hash to subsystems that need it, but I'll leave it to him.

Best regards, Ilya Maximets.

>>
>>
>>> Best regards,
>>> Dumitru
>>>
>>>>
>>>> Signed-off-by: Antoine Tenart <atenart@kernel.org>
>>>> ---
>>>>  include/linux/skbuff.h | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>>> index 738776ab8838..f54c84193b23 100644
>>>> --- a/include/linux/skbuff.h
>>>> +++ b/include/linux/skbuff.h
>>>> @@ -791,8 +791,8 @@ typedef unsigned char *sk_buff_data_t;
>>>>   *   @active_extensions: active extensions (skb_ext_id types)
>>>>   *   @ndisc_nodetype: router type (from link layer)
>>>>   *   @ooo_okay: allow the mapping of a socket to a queue to be changed
>>>> - *   @l4_hash: indicate hash is a canonical 4-tuple hash over transport
>>>> - *           ports.
>>>> + *   @l4_hash: indicate hash is from layer 4 and provides a uniform
>>>> + *           distribution over flows.
>>>>   *   @sw_hash: indicates hash was computed in software stack
>>>>   *   @wifi_acked_valid: wifi_acked was set
>>>>   *   @wifi_acked: whether frame was acked on wifi or not
>>>
>>
> 


