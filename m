Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B0116B444
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgBXWms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:42:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbgBXWmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 17:42:47 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 51CF21235830D;
        Mon, 24 Feb 2020 14:42:46 -0800 (PST)
Date:   Mon, 24 Feb 2020 14:42:43 -0800 (PST)
Message-Id: <20200224.144243.1485587034182183004.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.varghese@nokia.com,
        willemb@google.com
Subject: Re: linux-next: build warning after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225092736.137df206@canb.auug.org.au>
References: <20200225092736.137df206@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 14:42:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 25 Feb 2020 09:27:36 +1100

> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/net/bareudp.c: In function 'bareudp_xmit_skb':
> drivers/net/bareudp.c:346:9: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   346 |  return err;
>       |         ^~~
> drivers/net/bareudp.c: In function 'bareudp6_xmit_skb':
> drivers/net/bareudp.c:407:9: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   407 |  return err;
>       |         ^~~
> 
> Introduced by commit
> 
>   571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")

Sorry, my compiler didn't show this.

I've committed the following into net-next, hopefully it does the trick:

====================
[PATCH] bareudp: Fix uninitialized variable warnings.

drivers/net/bareudp.c: In function 'bareudp_xmit_skb':
drivers/net/bareudp.c:346:9: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
  346 |  return err;
      |         ^~~
drivers/net/bareudp.c: In function 'bareudp6_xmit_skb':
drivers/net/bareudp.c:407:9: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
  407 |  return err;

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/bareudp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 77e72477499d..15337e9d4fad 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -320,6 +320,7 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
 	skb_scrub_packet(skb, xnet);
 
+	err = -ENOSPC;
 	if (!skb_pull(skb, skb_network_offset(skb)))
 		goto free_dst;
 
@@ -381,6 +382,7 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 	skb_scrub_packet(skb, xnet);
 
+	err = -ENOSPC;
 	if (!skb_pull(skb, skb_network_offset(skb)))
 		goto free_dst;
 
-- 
2.21.1

