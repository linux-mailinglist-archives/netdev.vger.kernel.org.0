Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBA2989ED
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbfHVDkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:40:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37734 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfHVDkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:40:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9882E151397B0;
        Wed, 21 Aug 2019 20:40:19 -0700 (PDT)
Date:   Wed, 21 Aug 2019 20:40:19 -0700 (PDT)
Message-Id: <20190821.204019.904624122090676066.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, challa@noironetworks.com,
        dsahern@gmail.com, jishi@redhat.com
Subject: Re: [PATCHv2 net] ipv6/addrconf: allow adding multicast addr if
 IFA_F_MCAUTOJOIN is set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820021947.22718-1-liuhangbin@gmail.com>
References: <20190813135232.27146-1-liuhangbin@gmail.com>
        <20190820021947.22718-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 20:40:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 20 Aug 2019 10:19:47 +0800

> In commit 93a714d6b53d ("multicast: Extend ip address command to enable
> multicast group join/leave on") we added a new flag IFA_F_MCAUTOJOIN
> to make user able to add multicast address on ethernet interface.
> 
> This works for IPv4, but not for IPv6. See the inet6_addr_add code.
> 
> static int inet6_addr_add()
> {
> 	...
> 	if (cfg->ifa_flags & IFA_F_MCAUTOJOIN) {
> 		ipv6_mc_config(net->ipv6.mc_autojoin_sk, true...)
> 	}
> 
> 	ifp = ipv6_add_addr(idev, cfg, true, extack); <- always fail with maddr
> 	if (!IS_ERR(ifp)) {
> 		...
> 	} else if (cfg->ifa_flags & IFA_F_MCAUTOJOIN) {
> 		ipv6_mc_config(net->ipv6.mc_autojoin_sk, false...)
> 	}
> }
> 
> But in ipv6_add_addr() it will check the address type and reject multicast
> address directly. So this feature is never worked for IPv6.
> 
> We should not remove the multicast address check totally in ipv6_add_addr(),
> but could accept multicast address only when IFA_F_MCAUTOJOIN flag supplied.
> 
> v2: update commit description
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 93a714d6b53d ("multicast: Extend ip address command to enable multicast group join/leave on")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied and queued up for -stable.
