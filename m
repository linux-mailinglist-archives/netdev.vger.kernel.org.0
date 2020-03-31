Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 656C8199238
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 11:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgCaJ13 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 31 Mar 2020 05:27:29 -0400
Received: from zimbra.alphalink.fr ([217.15.80.77]:56178 "EHLO
        zimbra.alphalink.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729819AbgCaJ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 05:27:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 0BF8C2B52097;
        Tue, 31 Mar 2020 11:27:26 +0200 (CEST)
Received: from zimbra.alphalink.fr ([127.0.0.1])
        by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id AL4-sRwRDxkl; Tue, 31 Mar 2020 11:27:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 849D92B5209A;
        Tue, 31 Mar 2020 11:27:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mail-2-cbv2.admin.alphalink.fr
Received: from zimbra.alphalink.fr ([127.0.0.1])
        by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ywPb8Ovu2scw; Tue, 31 Mar 2020 11:27:24 +0200 (CEST)
Received: from Simons-MacBook-Pro.local (94-84-15-217.reverse.alphalink.fr [217.15.84.94])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTPSA id 1700A2B52097;
        Tue, 31 Mar 2020 11:27:24 +0200 (CEST)
Subject: Re: [PATCH net-next] pppoe: new ioctl to extract per-channel stats
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
References: <20200326103230.121447-1-s.chopin@alphalink.fr>
 <20200326143806.GA31979@pc-3.home>
From:   Simon Chopin <s.chopin@alphalink.fr>
Message-ID: <629de420-b433-0868-eccc-6feb9b43da7c@alphalink.fr>
Date:   Tue, 31 Mar 2020 11:27:23 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326143806.GA31979@pc-3.home>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Guillaume,

Le 26/03/2020 à 15:38, Guillaume Nault a écrit :
> On Thu, Mar 26, 2020 at 11:32:30AM +0100, Simon Chopin wrote:
>> The PPP subsystem uses the abstractions of channels and units, the
>> latter being an aggregate of the former, exported to userspace as a
>> single network interface.  As such, it keeps traffic statistics at the
>> unit level, but there are no statistics on the individual channels,
>> partly because most PPP units only have one channel.
>>
>> However, it is sometimes useful to have statistics at the channel level,
>> for instance to monitor multilink PPP connections. Such statistics
>> already exist for PPPoL2TP via the PPPIOCGL2TPSTATS ioctl, this patch
>> introduces a very similar mechanism for PPPoE via a new
>> PPPIOCGPPPOESTATS ioctl.
>>
> I'd rather recomment _not_ using multilink PPP over PPPoE (or L2TP, or
> any form of overlay network). But apart from that, I find the
> description misleading. PPPoE is not a PPP channel, it _transports_ a
> channel. PPPoE might not even be associated with a channel at all,
> like in the PPPOX_RELAY case. In short PPPoE stats aren't channel's
> stats. If the objective it to get channels stats, then this needs to be
> implemented in ppp_generic.c. If what you really want is PPPoE stats,
> then see my comments below.

Thank you for your feedback
I indeed want some statistics over PPP channels, notably over L2TP and
PPPoE. Since a mechanism already existed for the former, I thought
it simpler to implement the same for the latter, but your point makes sense:
those subsystems operate below the PPP layer, with extra control packets
and header overhead.

<snip>

>> @@ -549,6 +563,8 @@ static int pppoe_create(struct net *net, struct socket *sock, int kern)
>>  	sk->sk_family		= PF_PPPOX;
>>  	sk->sk_protocol		= PX_PROTO_OE;
>>  
>> +	sk->sk_user_data = kzalloc(sizeof(struct pppoe_stats), GFP_KERNEL);
>> +
> Missing error check.
> 
> But please don't use ->sk_user_data for that. We have enough problems
> with this pointer, let's not add users that don't actually need it.
> See https://lore.kernel.org/netdev/20180117.142538.1972806008716856078.davem@davemloft.net/
> for some details.
> You can store the counters inside the socket instead.

Thank you for the pointers. I'll pay attention to error paths in any further
version, and in any case will drop the sk_user_data use.

Would it be allright to post new patches as RFC before net-next opens in
order to get further feedback, or is that frowned upon ?

Cheers,
Simon
