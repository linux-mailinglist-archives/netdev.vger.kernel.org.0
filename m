Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D9413FB63
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 22:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbgAPV0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 16:26:14 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:55360 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729476AbgAPV0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 16:26:14 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 0E43E886BF;
        Fri, 17 Jan 2020 10:26:10 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1579209970;
        bh=nlvt+y14rm4i9DFDxSE/w8Ux8cHS3rb7RU/CgXhNaCU=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=c76iweB+ZSnXPObMM5THf0tGfWhnVr3rQYoH4VqYPSqoY6YTli6WieTwOfnlP1g+W
         96WIXTiomJHnfXZCdF/4tR4nRNgVO4WrmHgrADh3bgJKbB/RxRg5lja/YloEmGoQRJ
         ubTuaFtA8GZffgzXZMxqoxALTn2TGnK2hZp4s6Xz3sLm/YZgaBg5uSMWkboX8JgWqd
         /sCdz2HgEyj6mAG5k8RFtJzuXT7nj8cNDujvZYeAF1b2yV+m9ZnH/FhR+QR2zNtlZP
         OflSEpY57LFSnUgko18Yrc4PJ/sQ+vDmvxzXByIt5iWs4rolvOtmX84dRiu1vR8MX2
         VUciBLZ6Wx9YA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e20d4f20000>; Fri, 17 Jan 2020 10:26:10 +1300
Received: from ridgek-dl.ws.atlnz.lc (ridgek-dl.ws.atlnz.lc [10.33.22.15])
        by smtp (Postfix) with ESMTP id B7FC313EEFE;
        Fri, 17 Jan 2020 10:26:09 +1300 (NZDT)
Received: by ridgek-dl.ws.atlnz.lc (Postfix, from userid 1637)
        id F344F1405FD; Fri, 17 Jan 2020 10:26:09 +1300 (NZDT)
Received: from localhost (localhost [127.0.0.1])
        by ridgek-dl.ws.atlnz.lc (Postfix) with ESMTP id EEA591405F0;
        Fri, 17 Jan 2020 10:26:09 +1300 (NZDT)
Date:   Fri, 17 Jan 2020 10:26:09 +1300 (NZDT)
From:   Ridge Kennedy <ridgek@alliedtelesis.co.nz>
X-X-Sender: ridgek@ridgek-dl.ws.atlnz.lc
To:     Guillaume Nault <gnault@redhat.com>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
In-Reply-To: <20200116123854.GA23974@linux.home>
Message-ID: <alpine.DEB.2.21.2001171016080.9038@ridgek-dl.ws.atlnz.lc>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz> <20200116123854.GA23974@linux.home>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 16 Jan 2020, Guillaume Nault wrote:

> On Thu, Jan 16, 2020 at 11:34:47AM +1300, Ridge Kennedy wrote:
>> In the past it was possible to create multiple L2TPv3 sessions with the
>> same session id as long as the sessions belonged to different tunnels.
>> The resulting sessions had issues when used with IP encapsulated tunnels,
>> but worked fine with UDP encapsulated ones. Some applications began to
>> rely on this behaviour to avoid having to negotiate unique session ids.
>>
>> Some time ago a change was made to require session ids to be unique across
>> all tunnels, breaking the applications making use of this "feature".
>>
>> This change relaxes the duplicate session id check to allow duplicates
>> if both of the colliding sessions belong to UDP encapsulated tunnels.
>>
>> Fixes: dbdbc73b4478 ("l2tp: fix duplicate session creation")
>> Signed-off-by: Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
>> ---
>>  net/l2tp/l2tp_core.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>> index f82ea12bac37..0cc86227c618 100644
>> --- a/net/l2tp/l2tp_core.c
>> +++ b/net/l2tp/l2tp_core.c
>> @@ -323,7 +323,9 @@ int l2tp_session_register(struct l2tp_session *session,
>>  		spin_lock_bh(&pn->l2tp_session_hlist_lock);
>>
>>  		hlist_for_each_entry(session_walk, g_head, global_hlist)
>> -			if (session_walk->session_id == session->session_id) {
>> +			if (session_walk->session_id == session->session_id &&
>> +			    (session_walk->tunnel->encap == L2TP_ENCAPTYPE_IP ||
>> +			     tunnel->encap == L2TP_ENCAPTYPE_IP)) {
>>  				err = -EEXIST;
>>  				goto err_tlock_pnlock;
>>  			}
> Well, I think we have a more fundamental problem here. By adding
> L2TPoUDP sessions to the global list, we allow cross-talks with L2TPoIP
> sessions. That is, if we have an L2TPv3 session X running over UDP and
> we receive an L2TP_IP packet targetted at session ID X, then
> l2tp_session_get() will return the L2TP_UDP session to l2tp_ip_recv().
>
> I guess l2tp_session_get() should be dropped and l2tp_ip_recv() should
> look up the session in the context of its socket, like in the UDP case.
>
> But for the moment, what about just not adding L2TP_UDP sessions to the
> global list? That should fix both your problem and the L2TP_UDP/L2TP_IP
> cross-talks.

I did consider not adding the L2TP_UDP sessions to the global list, but 
that change looked a little more involved as the netlink interface was 
also making use of the list to lookup sessions by ifname. At a minimum
it looks like this would require rework of l2tp_session_get_by_ifname().


