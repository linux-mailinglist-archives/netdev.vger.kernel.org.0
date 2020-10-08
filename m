Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8202F287B52
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbgJHSAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 14:00:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbgJHSAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 14:00:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602180046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bjHPKGOfVh6sifK4tgf5EgBctNrQVGMRGH/KZfEsLJA=;
        b=KMICiN/vUtX1P5HjFHSEQMyFXqJvTLsYyzh+jZ+cO8UOLexXarmyzNBW6j4eKl4y0k+Eas
        j5cILR/xBzoau4QNM19wE8SeSa108g5trMmUxYaBQi1WjZZQIvpYMQ0+JCDsESO3zRfsoq
        5/f/tMPnxeYUUkeOElbL15Vizl9hVio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-S2I1I93WPjuEI9ps1H7Yvw-1; Thu, 08 Oct 2020 14:00:42 -0400
X-MC-Unique: S2I1I93WPjuEI9ps1H7Yvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62307101FFA2;
        Thu,  8 Oct 2020 18:00:41 +0000 (UTC)
Received: from [10.10.116.249] (ovpn-116-249.rdu2.redhat.com [10.10.116.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62D2060CD1;
        Thu,  8 Oct 2020 18:00:40 +0000 (UTC)
Subject: Re: [net] tipc: fix NULL pointer dereference in tipc_named_rcv
To:     Jakub Kicinski <kuba@kernel.org>,
        Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     maloy@donjonn.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
References: <20201008073156.116136-1-hoang.h.le@dektech.com.au>
 <20201008102514.1184c315@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <54320213-5b9b-4648-fa6b-553d2acb298e@redhat.com>
Date:   Thu, 8 Oct 2020 14:00:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201008102514.1184c315@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 1:25 PM, Jakub Kicinski wrote:
> On Thu,  8 Oct 2020 14:31:56 +0700 Hoang Huu Le wrote:
>> diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
>> index 2f9c148f17e2..fe4edce459ad 100644
>> --- a/net/tipc/name_distr.c
>> +++ b/net/tipc/name_distr.c
>> @@ -327,8 +327,13 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
>>   	struct tipc_msg *hdr;
>>   	u16 seqno;
>>   
>> +	spin_lock_bh(&namedq->lock);
>>   	skb_queue_walk_safe(namedq, skb, tmp) {
>> -		skb_linearize(skb);
>> +		if (unlikely(skb_linearize(skb))) {
>> +			__skb_unlink(skb, namedq);
>> +			kfree_skb(skb);
>> +			continue;
>> +		}
>>   		hdr = buf_msg(skb);
>>   		seqno = msg_named_seqno(hdr);
>>   		if (msg_is_last_bulk(hdr)) {
>> @@ -338,12 +343,14 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
>>   
>>   		if (msg_is_bulk(hdr) || msg_is_legacy(hdr)) {
>>   			__skb_unlink(skb, namedq);
>> +			spin_unlock_bh(&namedq->lock);
>>   			return skb;
>>   		}
>>   
>>   		if (*open && (*rcv_nxt == seqno)) {
>>   			(*rcv_nxt)++;
>>   			__skb_unlink(skb, namedq);
>> +			spin_unlock_bh(&namedq->lock);
>>   			return skb;
>>   		}
>>   
>> @@ -353,6 +360,7 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
>>   			continue;
>>   		}
>>   	}
>> +	spin_unlock_bh(&namedq->lock);
>>   	return NULL;
>>   }
>>   
>> diff --git a/net/tipc/node.c b/net/tipc/node.c
>> index cf4b239fc569..d269ebe382e1 100644
>> --- a/net/tipc/node.c
>> +++ b/net/tipc/node.c
>> @@ -1496,7 +1496,7 @@ static void node_lost_contact(struct tipc_node *n,
>>   
>>   	/* Clean up broadcast state */
>>   	tipc_bcast_remove_peer(n->net, n->bc_entry.link);
>> -	__skb_queue_purge(&n->bc_entry.namedq);
>> +	skb_queue_purge(&n->bc_entry.namedq);
> Patch looks fine, but I'm not sure why not hold
> spin_unlock_bh(&tn->nametbl_lock) here instead?
>
> Seems like node_lost_contact() should be relatively rare,
> so adding another lock to tipc_named_dequeue() is not the
> right trade off.
Actually, I agree with previous speaker here. We already have the 
nametbl_lock when tipc_named_dequeue() is called, and the same lock is 
accessible from no.c where node_lost_contact() is executed. The patch 
and the code becomes simpler.
I suggest you post a v2 of this one.

///jon

>>   	/* Abort any ongoing link failover */
>>   	for (i = 0; i < MAX_BEARERS; i++) {

