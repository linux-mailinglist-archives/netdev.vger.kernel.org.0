Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5A817CC5D
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 07:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgCGGBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 01:01:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40834 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgCGGBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 01:01:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8781814959E9B;
        Fri,  6 Mar 2020 22:01:24 -0800 (PST)
Date:   Fri, 06 Mar 2020 22:01:23 -0800 (PST)
Message-Id: <20200306.220123.221515051483240141.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [PATCH net] bonding/alb: make sure arp header is pulled before
 accessing it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200304173216.98819-1-edumazet@google.com>
References: <20200304173216.98819-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 22:01:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  4 Mar 2020 09:32:16 -0800

> Similar to commit 38f88c454042 ("bonding/alb: properly access headers
> in bond_alb_xmit()"), we need to make sure arp header was pulled
> in skb->head before blindly accessing it in rlb_arp_xmit().
> 
> Remove arp_pkt() private helper, since it is more readable/obvious
> to have the following construct back to back :
> 
> 	if (!pskb_network_may_pull(skb, sizeof(*arp)))
> 		return NULL;
> 	arp = (struct arp_pkt *)skb_network_header(skb);
> 
> syzbot reported :
 ...
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
