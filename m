Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76573180BBB
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCJWie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:38:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43400 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgCJWie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:38:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53EA214BEB0D1;
        Tue, 10 Mar 2020 15:38:33 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:38:32 -0700 (PDT)
Message-Id: <20200310.153832.135118780609022737.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, zajec5@gmail.com, yoshfuji@linux-ipv6.org,
        eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru, john@phrozen.org,
        herbert@gondor.apana.org.au
Subject: Re: [PATCHv2 net] ipv6/addrconf: call ipv6_mc_up() for
 non-Ethernet interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310072737.28031-1-liuhangbin@gmail.com>
References: <20200310072044.24313-1-liuhangbin@gmail.com>
        <20200310072737.28031-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 15:38:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 10 Mar 2020 15:27:37 +0800

> Rafa©© found an issue that for non-Ethernet interface, if we down and up
> frequently, the memory will be consumed slowly.
> 
> The reason is we add allnodes/allrouters addressed in multicast list in
> ipv6_add_dev(). When link down, we call ipv6_mc_down(), store all multicast
> addresses via mld_add_delrec(). But when link up, we don't call ipv6_mc_up()
> for non-Ethernet interface to remove the addresses. This makes idev->mc_tomb
> getting bigger and bigger. The call stack looks like:
> 
> addrconf_notify(NETDEV_REGISTER)
> 	ipv6_add_dev
> 		ipv6_dev_mc_inc(ff01::1)
> 		ipv6_dev_mc_inc(ff02::1)
> 		ipv6_dev_mc_inc(ff02::2)
> 
> addrconf_notify(NETDEV_UP)
> 	addrconf_dev_config
> 		/* Alas, we support only Ethernet autoconfiguration. */
> 		return;
> 
> addrconf_notify(NETDEV_DOWN)
> 	addrconf_ifdown
> 		ipv6_mc_down
> 			igmp6_group_dropped(ff02::2)
> 				mld_add_delrec(ff02::2)
> 			igmp6_group_dropped(ff02::1)
> 			igmp6_group_dropped(ff01::1)
> 
> After investigating, I can't found a rule to disable multicast on
> non-Ethernet interface. In RFC2460, the link could be Ethernet, PPP, ATM,
> tunnels, etc. In IPv4, it doesn't check the dev type when calls ip_mc_up()
> in inetdev_event(). Even for IPv6, we don't check the dev type and call
> ipv6_add_dev(), ipv6_dev_mc_inc() after register device.
> 
> So I think it's OK to fix this memory consumer by calling ipv6_mc_up() for
> non-Ethernet interface.
> 
> v2: Also check IFF_MULTICAST flag to make sure the interface supports
>     multicast
> 
> Reported-by: Rafa©© Mi©©ecki <zajec5@gmail.com>
> Fixes: 74235a25c673 ("[IPV6] addrconf: Fix IPv6 on tuntap tunnels")
> Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied and queued up for -stable, thank you.
