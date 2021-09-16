Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1658840ED48
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 00:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240984AbhIPWV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 18:21:27 -0400
Received: from server.eikelenboom.it ([91.121.65.215]:39750 "EHLO
        server.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240961AbhIPWVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 18:21:24 -0400
X-Greylist: delayed 1871 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 18:21:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=eikelenboom.it; s=20180706; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+kmogzI7kwhnNwR3x3lgp5G8pQBmKvDxMAVeBzIgThY=; b=HzjMEh1Y5BxK04vXaYCv4o0Ryw
        AdEqAi5XN3Zw1SQnlpjMHhQawsYbhR4RISsinSFbSgJ789gyo0C0b9fZP9utaDIGaMp4KqojWkoIl
        RsBM5x1YMbDNG+QkRZ5ctr0ufXOPGTMK42vjt8W5MAL/Ux1fbt/wMhflQwqziHIFr6/k=;
Received: from 76-24-144-85.ftth.glasoperator.nl ([85.144.24.76]:55038 helo=[172.16.1.50])
        by server.eikelenboom.it with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <sander@eikelenboom.it>)
        id 1mQzFN-0005CU-QZ; Thu, 16 Sep 2021 23:48:45 +0200
To:     paul@xen.org, Jan Beulich <jbeulich@suse.com>, Wei Liu <wl@xen.org>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
 <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
 <76c94541-21a8-7ae5-c4c4-48552f16c3fd@suse.com>
 <17e50fb5-31f7-60a5-1eec-10d18a40ad9a@xen.org>
 <57580966-3880-9e59-5d82-e1de9006aa0c@suse.com>
 <a26c1ecd-e303-3138-eb7e-96f0203ca888@xen.org>
 <1a522244-4be8-5e33-77c7-4ea5cf130335@suse.com>
 <9d27a3eb-1d50-64bb-8785-81de1eef3102@suse.com>
 <d4f381e9-6698-3339-1d17-15e3abc71d06@suse.com>
 <0dff83ff-629a-7179-9fef-77bd1fbf3d09@xen.org>
From:   Sander Eikelenboom <sander@eikelenboom.it>
Subject: =?UTF-8?Q?Re=3a_Ping=c2=b2=3a_=5bPATCH=5d_xen-netback=3a_correct_su?=
 =?UTF-8?Q?ccess/error_reporting_for_the_SKB-with-fraglist_case?=
Message-ID: <5a8c1f28-eefb-87e2-998b-7cbfb0f0b8dd@eikelenboom.it>
Date:   Thu, 16 Sep 2021 23:48:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0dff83ff-629a-7179-9fef-77bd1fbf3d09@xen.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/09/2021 20:34, Paul Durrant wrote:
> On 16/09/2021 16:45, Jan Beulich wrote:
>> On 15.07.2021 10:58, Jan Beulich wrote:
>>> On 20.05.2021 13:46, Jan Beulich wrote:
>>>> On 25.02.2021 17:23, Paul Durrant wrote:
>>>>> On 25/02/2021 14:00, Jan Beulich wrote:
>>>>>> On 25.02.2021 13:11, Paul Durrant wrote:
>>>>>>> On 25/02/2021 07:33, Jan Beulich wrote:
>>>>>>>> On 24.02.2021 17:39, Paul Durrant wrote:
>>>>>>>>> On 23/02/2021 16:29, Jan Beulich wrote:
>>>>>>>>>> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
>>>>>>>>>> special considerations for the head of the SKB no longer apply. Don't
>>>>>>>>>> mistakenly report ERROR to the frontend for the first entry in the list,
>>>>>>>>>> even if - from all I can tell - this shouldn't matter much as the overall
>>>>>>>>>> transmit will need to be considered failed anyway.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>>>>>>>>
>>>>>>>>>> --- a/drivers/net/xen-netback/netback.c
>>>>>>>>>> +++ b/drivers/net/xen-netback/netback.c
>>>>>>>>>> @@ -499,7 +499,7 @@ check_frags:
>>>>>>>>>>       				 * the header's copy failed, and they are
>>>>>>>>>>       				 * sharing a slot, send an error
>>>>>>>>>>       				 */
>>>>>>>>>> -				if (i == 0 && sharedslot)
>>>>>>>>>> +				if (i == 0 && !first_shinfo && sharedslot)
>>>>>>>>>>       					xenvif_idx_release(queue, pending_idx,
>>>>>>>>>>       							   XEN_NETIF_RSP_ERROR);
>>>>>>>>>>       				else
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I think this will DTRT, but to my mind it would make more sense to clear
>>>>>>>>> 'sharedslot' before the 'goto check_frags' at the bottom of the function.
>>>>>>>>
>>>>>>>> That was my initial idea as well, but
>>>>>>>> - I think it is for a reason that the variable is "const".
>>>>>>>> - There is another use of it which would then instead need further
>>>>>>>>       amending (and which I believe is at least part of the reason for
>>>>>>>>       the variable to be "const").
>>>>>>>>
>>>>>>>
>>>>>>> Oh, yes. But now that I look again, don't you want:
>>>>>>>
>>>>>>> if (i == 0 && first_shinfo && sharedslot)
>>>>>>>
>>>>>>> ? (i.e no '!')
>>>>>>>
>>>>>>> The comment states that the error should be indicated when the first
>>>>>>> frag contains the header in the case that the map succeeded but the
>>>>>>> prior copy from the same ref failed. This can only possibly be the case
>>>>>>> if this is the 'first_shinfo'
>>>>>>
>>>>>> I don't think so, no - there's a difference between "first frag"
>>>>>> (at which point first_shinfo is NULL) and first frag list entry
>>>>>> (at which point first_shinfo is non-NULL).
>>>>>
>>>>> Yes, I realise I got it backwards. Confusing name but the comment above
>>>>> its declaration does explain.
>>>>>
>>>>>>
>>>>>>> (which is why I still think it is safe to unconst 'sharedslot' and
>>>>>>> clear it).
>>>>>>
>>>>>> And "no" here as well - this piece of code
>>>>>>
>>>>>> 		/* First error: if the header haven't shared a slot with the
>>>>>> 		 * first frag, release it as well.
>>>>>> 		 */
>>>>>> 		if (!sharedslot)
>>>>>> 			xenvif_idx_release(queue,
>>>>>> 					   XENVIF_TX_CB(skb)->pending_idx,
>>>>>> 					   XEN_NETIF_RSP_OKAY);
>>>>>>
>>>>>> specifically requires sharedslot to have the value that was
>>>>>> assigned to it at the start of the function (this property
>>>>>> doesn't go away when switching from fragments to frag list).
>>>>>> Note also how it uses XENVIF_TX_CB(skb)->pending_idx, i.e. the
>>>>>> value the local variable pending_idx was set from at the start
>>>>>> of the function.
>>>>>>
>>>>>
>>>>> True, we do have to deal with freeing up the header if the first map
>>>>> error comes on the frag list.
>>>>>
>>>>> Reviewed-by: Paul Durrant <paul@xen.org>
>>>>
>>>> Since I've not seen this go into 5.13-rc, may I ask what the disposition
>>>> of this is?
>>>
>>> I can't seem to spot this in 5.14-rc either. I have to admit I'm
>>> increasingly puzzled ...
>>
>> Another two months (and another release) later and still nothing. Am
>> I doing something wrong? Am I wrongly assuming that maintainers would
>> push such changes up the chain?
>>
> 
> It has my R-b so it ought to go in via netdev AFAICT.
> 
>     Paul

Could it be the missing "net" or "net-next" designation in the subject 
[1] which seems to be used and important within their patchwork 
semi-automated workflow ?

--
Sander

[1] 
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in
