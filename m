Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5D124D316
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgHUKsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728008AbgHUKrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 06:47:55 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A8E0C061386
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 03:47:53 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7CC7E86BDC;
        Fri, 21 Aug 2020 11:47:43 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598006863; bh=icS+Fhr+7Ys7lrgwhDgYKEQ1SyOPFdsZtnf+E6C3ssY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=204/9]=20l2tp:=20add=20tracepoin
         t=20infrastructure=20to=20core|Date:=20Fri,=2021=20Aug=202020=2011
         :47:23=20+0100|Message-Id:=20<20200821104728.23530-5-tparkin@katal
         ix.com>|In-Reply-To:=20<20200821104728.23530-1-tparkin@katalix.com
         >|References:=20<20200821104728.23530-1-tparkin@katalix.com>;
        b=Bxd8bmDInSMprziz2sF4Prs5YQae0kyFYPAlGjwyjHmylONriIGNBar14SFiUX08t
         RVzyxxpOWGwSi+/KKqJJcL7Zk9hlrMbWQVs5f8VNtCnG0QEvNvNR9aJdeNv5nM5pRu
         1HLGD6V5U6Lbzoat3kyoqe2Km3rY/OKPxg2BxIJaEdOY9Dh/66Y44ASf8tk8dXLnJU
         XPQS+7pcMUy1GRs6fQToqvWp4wj4aXuiJzAo4AfZBzymTkU5cX8P7N/MA2e+3CvZMk
         J33o7lm06J06BEFL97bddkOv66i6aLNpbfwNtHQXtbaWVHu5cTd+RnwAWuKnWg0eR7
         D/qOgq584srqQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 4/9] l2tp: add tracepoint infrastructure to core
Date:   Fri, 21 Aug 2020 11:47:23 +0100
Message-Id: <20200821104728.23530-5-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821104728.23530-1-tparkin@katalix.com>
References: <20200821104728.23530-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The l2tp subsystem doesn't currently make use of tracepoints.

As a starting point for adding tracepoints, add skeleton infrastructure
for defining tracepoints for the subsystem, and for having them build
appropriately whether compiled into the kernel or built as a module.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/Makefile    |  2 ++
 net/l2tp/l2tp_core.c |  3 +++
 net/l2tp/trace.h     | 15 +++++++++++++++
 3 files changed, 20 insertions(+)
 create mode 100644 net/l2tp/trace.h

diff --git a/net/l2tp/Makefile b/net/l2tp/Makefile
index 399a7e5db2f4..cf8f27071d3f 100644
--- a/net/l2tp/Makefile
+++ b/net/l2tp/Makefile
@@ -5,6 +5,8 @@
 
 obj-$(CONFIG_L2TP) += l2tp_core.o
 
+CFLAGS_l2tp_core.o += -I$(src)
+
 # Build l2tp as modules if L2TP is M
 obj-$(subst y,$(CONFIG_L2TP),$(CONFIG_PPPOL2TP)) += l2tp_ppp.o
 obj-$(subst y,$(CONFIG_L2TP),$(CONFIG_L2TP_IP)) += l2tp_ip.o
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a0f982add6ad..a9825724e2f4 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -62,6 +62,9 @@
 
 #include "l2tp_core.h"
 
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
 #define L2TP_DRV_VERSION	"V2.0"
 
 /* L2TP header constants */
diff --git a/net/l2tp/trace.h b/net/l2tp/trace.h
new file mode 100644
index 000000000000..652778291b77
--- /dev/null
+++ b/net/l2tp/trace.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM l2tp
+
+#if !defined(_TRACE_L2TP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_L2TP_H
+
+#endif /* _TRACE_L2TP_H */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
-- 
2.17.1

