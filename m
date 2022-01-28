Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7FD4A04AC
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 00:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344789AbiA1Xxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 18:53:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55626 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344851AbiA1Xxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 18:53:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B5036176B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 23:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA601C340E7;
        Fri, 28 Jan 2022 23:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643414032;
        bh=n/anSoyif3p2CvSANBI7muFScLpc4QzuxttmB0jc33o=;
        h=From:To:Cc:Subject:Date:From;
        b=DAOk4G4gRx032meKow/dwt1G3FNZked1uuHDV0oMxxKQIsXgOKz/Z3VZlLEGnEFx4
         YAwhWEX2ghyao151MfDjSq74DJHFv7Lq9BYaCD/Fc2FX+Yw94NNtbfxeppBqcu+VaH
         ilYYk/NpI5N9oeJ6Tiloq5ibmieKHg8tjygg3qcQF5qkMvf8tYVqrX+CjSe5/mY17Q
         3801cxshy4InK0DRSIJx3N/7kAkmOqQWgSmAAg1SeERvXhUVWuucunz5lssxggZpjN
         1JQlr2ZyPa1q7jc097uLSN3nySVoN4phUtHowAbWpW1+4NY0s7Ve3OlQOY8plawj/+
         KzGgQx2WakylQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next] ipv4: Make ip_idents_reserve static
Date:   Fri, 28 Jan 2022 16:53:47 -0700
Message-Id: <20220128235347.40666-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip_idents_reserve is only used in net/ipv4/route.c. Make it static
and remove the export.

Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
---
 include/net/ip.h | 1 -
 net/ipv4/route.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index b51bae43b0dd..4fcb48598d2d 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -517,7 +517,6 @@ void ip_dst_metrics_put(struct dst_entry *dst)
 		kfree(p);
 }
 
-u32 ip_idents_reserve(u32 hash, int segs);
 void __ip_select_ident(struct net *net, struct iphdr *iph, int segs);
 
 static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e42e283b5515..8b35075088e1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -457,7 +457,7 @@ static u32 *ip_tstamps __read_mostly;
  * if one generator is seldom used. This makes hard for an attacker
  * to infer how many packets were sent between two points in time.
  */
-u32 ip_idents_reserve(u32 hash, int segs)
+static u32 ip_idents_reserve(u32 hash, int segs)
 {
 	u32 bucket, old, now = (u32)jiffies;
 	atomic_t *p_id;
@@ -478,7 +478,6 @@ u32 ip_idents_reserve(u32 hash, int segs)
 	 */
 	return atomic_add_return(segs + delta, p_id) - segs;
 }
-EXPORT_SYMBOL(ip_idents_reserve);
 
 void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
 {
-- 
2.25.1

