Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE37288926
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 14:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbgJIMr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 08:47:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729045AbgJIMr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 08:47:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602247677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YrWAUcIR2z0RjFQce9q0hB+1C0e5vjnATMHr6X69LE8=;
        b=FniPtTp7mJb9oJSN/45cJbZEgrJL6Iz3NuYus317onmZIz0RHQayRS8MBUd1vh8ad1C1Hm
        Q01fKYd3qVJlW+h/4JIo8dujsgbEC5qM6X1mDbjLWlg/TeQMBowWJZH3kOM2VcC2L24NfL
        WRF8lT+REx9zUrRi4Fq96KPUcn8Lj9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-wMjFx77SPV2c9cMOYk_YPQ-1; Fri, 09 Oct 2020 08:47:53 -0400
X-MC-Unique: wMjFx77SPV2c9cMOYk_YPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CE56802B46;
        Fri,  9 Oct 2020 12:47:52 +0000 (UTC)
Received: from [10.10.116.249] (ovpn-116-249.rdu2.redhat.com [10.10.116.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 812C65576D;
        Fri,  9 Oct 2020 12:47:51 +0000 (UTC)
Subject: Re: [net] tipc: fix NULL pointer dereference in tipc_named_rcv
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201008073156.116136-1-hoang.h.le@dektech.com.au>
 <20201008102514.1184c315@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <54320213-5b9b-4648-fa6b-553d2acb298e@redhat.com>
 <VI1PR05MB46058487F5FE43F6ED539355F1080@VI1PR05MB4605.eurprd05.prod.outlook.com>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <c2a9e820-c972-1978-a0b7-e2483fbbca1c@redhat.com>
Date:   Fri, 9 Oct 2020 08:47:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB46058487F5FE43F6ED539355F1080@VI1PR05MB4605.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/9/20 12:12 AM, Hoang Huu Le wrote:
> Hi Jon,  Jakub,
>
> I tried with your comment. But looks like we got into circular locking and deadlock could happen like this:
>          CPU0                    CPU1
>          ----                    ----
>     lock(&n->lock#2);
>                                  lock(&tn->nametbl_lock);
>                                  lock(&n->lock#2);
>     lock(&tn->nametbl_lock);
>
>    *** DEADLOCK ***
>
> Regards,
> Hoang
Ok. So although your solution is not optimal, we know it is safe.
Again:
Acked-by: Jon Maloy <jmaloy@redhat.com>
>> -----Original Message-----
>> From: Jon Maloy <jmaloy@redhat.com>
>> Sent: Friday, October 9, 2020 1:01 AM
>> To: Jakub Kicinski <kuba@kernel.org>; Hoang Huu Le <hoang.h.le@dektech.com.au>
>> Cc: maloy@donjonn.com; ying.xue@windriver.com; tipc-discussion@lists.sourceforge.net; netdev@vger.kernel.org
>> Subject: Re: [net] tipc: fix NULL pointer dereference in tipc_named_rcv
>>
>>
>>
>> On 10/8/20 1:25 PM, Jakub Kicinski wrote:
>>> On Thu,  8 Oct 2020 14:31:56 +0700 Hoang Huu Le wrote:
>>>> diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
>>>> index 2f9c148f17e2..fe4edce459ad 100644
>>>> --- a/net/tipc/name_distr.c
>>>> +++ b/net/tipc/name_distr.c
>>>> @@ -327,8 +327,13 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
>>>>    	struct tipc_msg *hdr;
>>>>    	u16 seqno;
>>>>
>>>> +	spin_lock_bh(&namedq->lock);
>>>>    	skb_queue_walk_safe(namedq, skb, tmp) {
>>>> -		skb_linearize(skb);
>>>> +		if (unlikely(skb_linearize(skb))) {
>>>> +			__skb_unlink(skb, namedq);
>>>> +			kfree_skb(skb);
>>>> +			continue;
>>>> +		}
>>>>    		hdr = buf_msg(skb);
>>>>    		seqno = msg_named_seqno(hdr);
>>>>    		if (msg_is_last_bulk(hdr)) {
>>>> @@ -338,12 +343,14 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
>>>>
>>>>    		if (msg_is_bulk(hdr) || msg_is_legacy(hdr)) {
>>>>    			__skb_unlink(skb, namedq);
>>>> +			spin_unlock_bh(&namedq->lock);
>>>>    			return skb;
>>>>    		}
>>>>
>>>>    		if (*open && (*rcv_nxt == seqno)) {
>>>>    			(*rcv_nxt)++;
>>>>    			__skb_unlink(skb, namedq);
>>>> +			spin_unlock_bh(&namedq->lock);
>>>>    			return skb;
>>>>    		}
>>>>
>>>> @@ -353,6 +360,7 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
>>>>    			continue;
>>>>    		}
>>>>    	}
>>>> +	spin_unlock_bh(&namedq->lock);
>>>>    	return NULL;
>>>>    }
>>>>
>>>> diff --git a/net/tipc/node.c b/net/tipc/node.c
>>>> index cf4b239fc569..d269ebe382e1 100644
>>>> --- a/net/tipc/node.c
>>>> +++ b/net/tipc/node.c
>>>> @@ -1496,7 +1496,7 @@ static void node_lost_contact(struct tipc_node *n,
>>>>
>>>>    	/* Clean up broadcast state */
>>>>    	tipc_bcast_remove_peer(n->net, n->bc_entry.link);
>>>> -	__skb_queue_purge(&n->bc_entry.namedq);
>>>> +	skb_queue_purge(&n->bc_entry.namedq);
>>> Patch looks fine, but I'm not sure why not hold
>>> spin_unlock_bh(&tn->nametbl_lock) here instead?
>>>
>>> Seems like node_lost_contact() should be relatively rare,
>>> so adding another lock to tipc_named_dequeue() is not the
>>> right trade off.
>> Actually, I agree with previous speaker here. We already have the
>> nametbl_lock when tipc_named_dequeue() is called, and the same lock is
>> accessible from no.c where node_lost_contact() is executed. The patch
>> and the code becomes simpler.
>> I suggest you post a v2 of this one.
>>
>> ///jon
>>
>>>>    	/* Abort any ongoing link failover */
>>>>    	for (i = 0; i < MAX_BEARERS; i++) {

