Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5101151336
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 00:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgBCX3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 18:29:14 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:53530 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgBCX3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 18:29:14 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 6ED7F806B7;
        Tue,  4 Feb 2020 12:29:11 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1580772551;
        bh=buDfqYIxyNT9U/e7X4xOZbuI343v+dj27tNXx3xJJ6g=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=wqajwgvgrYIqgbhzHGiqUsY9MFzKT7t4j7tNxD3Hx6WM91Xxkx3WjOPhFPImbb9de
         ytN4BtvGwEGoWZKacJmnOPUqYPP1uOAbekfi7ZlJNO3uOM7Kskfm3WXD1pPlDky26X
         /KSzjQofmbVQ1OJOsdOe8huOFYqPm7XZWtXEAPlRz5KayUu/uY3rW8uzVTe/mDdA5t
         MjRasuzwYFU8IhUGIsM9SpfpvGaG+QrODkLV/gPgwyVNO9o+jB5wO0/VI03Bjt9X9k
         A7e2ftSy5fENw8xhn9ehsHeHmkrnVzf7Y8gNJEDmerPxYWLd8OjOjgLmxXYT0/1D55
         2O/KE9LFXHzCw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e38acc80000>; Tue, 04 Feb 2020 12:29:12 +1300
Received: from ridgek-dl.ws.atlnz.lc (ridgek-dl.ws.atlnz.lc [10.33.22.15])
        by smtp (Postfix) with ESMTP id 3C58313EED4;
        Tue,  4 Feb 2020 12:29:11 +1300 (NZDT)
Received: by ridgek-dl.ws.atlnz.lc (Postfix, from userid 1637)
        id 57122140303; Tue,  4 Feb 2020 12:29:11 +1300 (NZDT)
Received: from localhost (localhost [127.0.0.1])
        by ridgek-dl.ws.atlnz.lc (Postfix) with ESMTP id 535B91402F3;
        Tue,  4 Feb 2020 12:29:11 +1300 (NZDT)
Date:   Tue, 4 Feb 2020 12:29:11 +1300 (NZDT)
From:   Ridge Kennedy <ridgek@alliedtelesis.co.nz>
X-X-Sender: ridgek@ridgek-dl.ws.atlnz.lc
To:     Guillaume Nault <gnault@redhat.com>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
In-Reply-To: <20200131125814.GC32428@pc-61.home>
Message-ID: <alpine.DEB.2.21.2002041225580.29064@ridgek-dl.ws.atlnz.lc>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz> <20200116123854.GA23974@linux.home> <alpine.DEB.2.21.2001171016080.9038@ridgek-dl.ws.atlnz.lc> <20200131125814.GC32428@pc-61.home>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 31 Jan 2020, Guillaume Nault wrote:

> On Fri, Jan 17, 2020 at 10:26:09AM +1300, Ridge Kennedy wrote:
>> On Thu, 16 Jan 2020, Guillaume Nault wrote:
>>> On Thu, Jan 16, 2020 at 11:34:47AM +1300, Ridge Kennedy wrote:
>>>> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>>>> index f82ea12bac37..0cc86227c618 100644
>>>> --- a/net/l2tp/l2tp_core.c
>>>> +++ b/net/l2tp/l2tp_core.c
>>>> @@ -323,7 +323,9 @@ int l2tp_session_register(struct l2tp_session *session,
>>>>  		spin_lock_bh(&pn->l2tp_session_hlist_lock);
>>>>
>>>>  		hlist_for_each_entry(session_walk, g_head, global_hlist)
>>>> -			if (session_walk->session_id == session->session_id) {
>>>> +			if (session_walk->session_id == session->session_id &&
>>>> +			    (session_walk->tunnel->encap == L2TP_ENCAPTYPE_IP ||
>>>> +			     tunnel->encap == L2TP_ENCAPTYPE_IP)) {
>>>>  				err = -EEXIST;
>>>>  				goto err_tlock_pnlock;
>>>>  			}
>>> Well, I think we have a more fundamental problem here. By adding
>>> L2TPoUDP sessions to the global list, we allow cross-talks with L2TPoIP
>>> sessions. That is, if we have an L2TPv3 session X running over UDP and
>>> we receive an L2TP_IP packet targetted at session ID X, then
>>> l2tp_session_get() will return the L2TP_UDP session to l2tp_ip_recv().
>>>
>>> I guess l2tp_session_get() should be dropped and l2tp_ip_recv() should
>>> look up the session in the context of its socket, like in the UDP case.
>>>
>>> But for the moment, what about just not adding L2TP_UDP sessions to the
>>> global list? That should fix both your problem and the L2TP_UDP/L2TP_IP
>>> cross-talks.
>>
>> I did consider not adding the L2TP_UDP sessions to the global list, but that
>> change looked a little more involved as the netlink interface was also
>> making use of the list to lookup sessions by ifname. At a minimum
>> it looks like this would require rework of l2tp_session_get_by_ifname().
>>
> Yes, you're right. Now that we all agree on this fix, can you please
> repost your patch?
>
> BTW, I wouldn't mind a small comment on top of the conditional to
> explain that IP encap assumes globally unique session IDs while UDP
> doesn't.
>
Thanks all, I have reposted the patch with added comment.
