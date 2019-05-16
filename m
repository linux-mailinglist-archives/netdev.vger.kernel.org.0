Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF2320CE7
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 18:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfEPQ01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 12:26:27 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38593 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfEPQ00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 12:26:26 -0400
Received: by mail-pf1-f195.google.com with SMTP id b76so2114635pfb.5
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 09:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=f/KHCvDR+SBKa6qaHAVkNzxGGYoccY4KNMLdYCFmFWo=;
        b=agctd/ms6N4SKZWP+jMIkoBL/WSzvbz40eQE3l4dI2hwRVlm1ok8bilXWymEMgHaXv
         +QAgrGo85kAoukAVYvVGKhxpNrz+S5jccXW+c3q8wFqb6n02Akfjp4GTtnfFN7Bo7HXk
         16pHx24Uncdf8ddVCWBTIfKJrkjeLyNZ0b8Gych7duwnZQWaptWvKLRRAkCZWtGJI8Gh
         UBhTRizblSATbYvNSg59gboed5YyAgAfT3uVWK+ZI9uEJcn49EvGJEWZojIxaQBiYudH
         myv4VyuwYH44EhKgVTBjEED20BftWUT00t23zx/1MSFStbu5fmQe116RDnXhkmzrMPC0
         g5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=f/KHCvDR+SBKa6qaHAVkNzxGGYoccY4KNMLdYCFmFWo=;
        b=n8hCBug6Ji+eKHHjESp3O7F/vO4PXb85TT7s9nATH+yGVgIeW7dhKn+TNW6lWkO3Ww
         MOsxacv2lmzorPjxgMjGcYGRrc3JZ2SKMhP9SOrwjyzlACRw4esMIeAos2D4bhAzFPbL
         shUVErCFlci5n9AUGXlC3+ozBYF+vtwfG1THO6Ht1BuQ9KW2P8ITG3DaQ6eYi8bh+PJ7
         flox5hDt/ITDSWPv9S5HaaOfLzhXTFpes2vjsRbmQckBQhGrh2fBjo9hCaGrhnJrNtlY
         39wNr9RmXJugq4WLlihqyfUKaxa6AYs3MGrzQ6NAs28NXFKRNl2cRyk/QpK8WWVHD6rO
         icyw==
X-Gm-Message-State: APjAAAXUBbNmEEaQTv8OLw1wK6kg3Hb24nFBVmq7nSilN2FwA7zNKQb7
        IgEDo1VzgyiOjDno2OOV40QXnAGlnaM=
X-Google-Smtp-Source: APXvYqzfrgmM9Bv+rjxSNzLKkchPva8apY1JZzgwnOjq1YJGqUPbo4UoyiXF0yK+1UBXwcvC04yQWg==
X-Received: by 2002:aa7:8b12:: with SMTP id f18mr54672173pfd.178.1558023985172;
        Thu, 16 May 2019 09:26:25 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id z7sm6842092pgh.81.2019.05.16.09.26.24
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 16 May 2019 09:26:24 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net] net: ip6_gre: access skb data after skb_cow_head()
Date:   Thu, 16 May 2019 09:25:48 -0700
Message-Id: <1558023948-9428-1-git-send-email-u9012063@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When increases the headroom, skb's pointer might get re-allocated.
Fix it by moving skb_cow_head before accessing the skb->data pointer.

Fixes: 01b8d064d58b4 ("net: ip6_gre: Request headroom in __gre6_xmit()")
Reported-by: Haichao Ma <haichaom@vmware.com>
Signed-off-by: William Tu <u9012063@gmail.com>
---
 net/ipv6/ip6_gre.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 655e46b227f9..90b2b129b105 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -714,6 +714,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	struct ip6_tnl *tunnel = netdev_priv(dev);
 	__be16 protocol;
 
+	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
+		return -ENOMEM;
+
 	if (dev->type == ARPHRD_ETHER)
 		IPCB(skb)->flags = 0;
 
@@ -722,9 +725,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	else
 		fl6->daddr = tunnel->parms.raddr;
 
-	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
-		return -ENOMEM;
-
 	/* Push GRE header. */
 	protocol = (dev->type == ARPHRD_ETHER) ? htons(ETH_P_TEB) : proto;
 
-- 
2.7.4

