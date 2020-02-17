Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE47160839
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgBQCff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:35:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47824 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgBQCff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:35:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91F9D153808F4;
        Sun, 16 Feb 2020 18:35:34 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:35:34 -0800 (PST)
Message-Id: <20200216.183534.1660526654373190891.davem@davemloft.net>
To:     bpoirier@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        nicolas.dichtel@6wind.com, dsahern@gmail.com
Subject: Re: [PATCH net 2/2] ipv6: Fix nlmsg_flags when splitting a
 multipath route
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200212014107.110066-2-bpoirier@cumulusnetworks.com>
References: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
        <20200212014107.110066-2-bpoirier@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:35:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <bpoirier@cumulusnetworks.com>
Date: Wed, 12 Feb 2020 10:41:07 +0900

> When splitting an RTA_MULTIPATH request into multiple routes and adding the
> second and later components, we must not simply remove NLM_F_REPLACE but
> instead replace it by NLM_F_CREATE. Otherwise, it may look like the netlink
> message was malformed.
> 
> For example,
> 	ip route add 2001:db8::1/128 dev dummy0
> 	ip route change 2001:db8::1/128 nexthop via fe80::30:1 dev dummy0 \
> 		nexthop via fe80::30:2 dev dummy0
> results in the following warnings:
> [ 1035.057019] IPv6: RTM_NEWROUTE with no NLM_F_CREATE or NLM_F_REPLACE
> [ 1035.057517] IPv6: NLM_F_CREATE should be set when creating new route
> 
> This patch makes the nlmsg sequence look equivalent for __ip6_ins_rt() to
> what it would get if the multipath route had been added in multiple netlink
> operations:
> 	ip route add 2001:db8::1/128 dev dummy0
> 	ip route change 2001:db8::1/128 nexthop via fe80::30:1 dev dummy0
> 	ip route append 2001:db8::1/128 nexthop via fe80::30:2 dev dummy0
> 
> Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>

Applied and queued up for -stable.
