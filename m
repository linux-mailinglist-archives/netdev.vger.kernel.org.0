Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004C924E826
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgHVO7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 10:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbgHVO7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 10:59:31 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B905AC061755
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 07:59:29 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 816CD86BFD;
        Sat, 22 Aug 2020 15:59:20 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598108360; bh=VoPkmnFc1nwCqpJg17f21N6Q3oMR/TFhQ4XMIOoLvs0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=20v2=207/9]=20l2tp:=2
         0remove=20custom=20logging=20macros|Date:=20Sat,=2022=20Aug=202020
         =2015:59:07=20+0100|Message-Id:=20<20200822145909.6381-8-tparkin@k
         atalix.com>|In-Reply-To:=20<20200822145909.6381-1-tparkin@katalix.
         com>|References:=20<20200822145909.6381-1-tparkin@katalix.com>;
        b=YLob1H5S8p+JMPfuw5ezPaGLbwPTZCgW5J0O75gZvftULSckS1D5tfNGJfyVD7Hsi
         3Y6CGO4KEiY696cwTamDAHVkad6O4O9axIe1GCG6mKNk9MnwMU7uLYYsLvrmXyv5/e
         BiVgERS2D3PU+0MpKJZ++uYCUMUIqcXgGBLeMm1RyZYG0LVL6bExfFYJMya8fbGu+o
         DP2HOUdyxbelUffYulhLn6v+MOS7Q8wGwgZ4nMje1aSci0rvTCFlgle7SdNuAaOp03
         Fc4UMqZCVuiC1h6GKDz4Pgwztw/dCdHf48sDcHGO6Cj/NpzSbWC+bGnoY7CgcJyQPW
         xe+QZav7rSJBg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next v2 7/9] l2tp: remove custom logging macros
Date:   Sat, 22 Aug 2020 15:59:07 +0100
Message-Id: <20200822145909.6381-8-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822145909.6381-1-tparkin@katalix.com>
References: <20200822145909.6381-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All l2tp's informational and warning logging is now carried out using
standard kernel APIs.

Debugging information is now handled using tracepoints.

Now that no code is using the custom logging macros, remove them from
l2tp_core.h.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 835c4645a0ec..7a06ac135a9b 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -339,19 +339,6 @@ static inline int l2tp_v3_ensure_opt_in_linear(struct l2tp_session *session, str
 	return 0;
 }
 
-#define l2tp_printk(ptr, type, func, fmt, ...)				\
-do {									\
-	if (((ptr)->debug) & (type))					\
-		func(fmt, ##__VA_ARGS__);				\
-} while (0)
-
-#define l2tp_warn(ptr, type, fmt, ...)					\
-	l2tp_printk(ptr, type, pr_warn, fmt, ##__VA_ARGS__)
-#define l2tp_info(ptr, type, fmt, ...)					\
-	l2tp_printk(ptr, type, pr_info, fmt, ##__VA_ARGS__)
-#define l2tp_dbg(ptr, type, fmt, ...)					\
-	l2tp_printk(ptr, type, pr_debug, fmt, ##__VA_ARGS__)
-
 #define MODULE_ALIAS_L2TP_PWTYPE(type) \
 	MODULE_ALIAS("net-l2tp-type-" __stringify(type))
 
-- 
2.17.1

