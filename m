Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D4722ADC6
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgGWLaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728517AbgGWLaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:30:05 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E0A6C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 04:30:05 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 39DA08AD86;
        Thu, 23 Jul 2020 12:30:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595503804; bh=EbZx09B5dxi58V6jWe5EJQ+csGU3HziezHKnxTLAE7E=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=203/6]=20l2tp:=20check=20socket=
         20address=20type=20in=20l2tp_dfs_seq_tunnel_show|Date:=20Thu,=2023
         =20Jul=202020=2012:29:52=20+0100|Message-Id:=20<20200723112955.198
         08-4-tparkin@katalix.com>|In-Reply-To:=20<20200723112955.19808-1-t
         parkin@katalix.com>|References:=20<20200723112955.19808-1-tparkin@
         katalix.com>;
        b=mwPRNIRtjKmC1lkJ0Wdq6YftzrGLfKTWl9DDKjhlAd8nISU7oUr8SCGizZDQFOV/B
         7c6V0F+jwaRHKo5HmMpjoGBCOpVqQESEzZzOFhjb9HXyuI4G0BfGypo2a0MgM3rGyZ
         pEkFzLqFIiRdISoZ8LYdQoXNZIi4N7IO2hxPh2SKiUhKyP/Sw9FllQ9NbwA5SmIloY
         lnUWTD4iSlT++gk6toXldqjKuVrmTD9n27ANH9viI9YT49xyzXAM0nlNNUajbi7UJe
         2n6FFRrDACSbfQWn//0Txbf87Fyc9zqZlZDH9RU6awoxsAVZYObBIy5Tc18AicxoH8
         H7c9lV6XJWdpQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 3/6] l2tp: check socket address type in l2tp_dfs_seq_tunnel_show
Date:   Thu, 23 Jul 2020 12:29:52 +0100
Message-Id: <20200723112955.19808-4-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200723112955.19808-1-tparkin@katalix.com>
References: <20200723112955.19808-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch warns about indentation and brace balancing around the
conditionally compiled code for AF_INET6 support in
l2tp_dfs_seq_tunnel_show.

By adding another check on the socket address type we can make the code
more readable while removing the checkpatch warning.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_debugfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 117a6697da72..72ba83aa0eaf 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -146,10 +146,12 @@ static void l2tp_dfs_seq_tunnel_show(struct seq_file *m, void *v)
 
 			seq_printf(m, " from %pI6c to %pI6c\n",
 				   &np->saddr, &tunnel->sock->sk_v6_daddr);
-		} else
+		}
 #endif
-		seq_printf(m, " from %pI4 to %pI4\n",
-			   &inet->inet_saddr, &inet->inet_daddr);
+		if (tunnel->sock->sk_family == AF_INET)
+			seq_printf(m, " from %pI4 to %pI4\n",
+				   &inet->inet_saddr, &inet->inet_daddr);
+
 		if (tunnel->encap == L2TP_ENCAPTYPE_UDP)
 			seq_printf(m, " source port %hu, dest port %hu\n",
 				   ntohs(inet->inet_sport), ntohs(inet->inet_dport));
-- 
2.17.1

