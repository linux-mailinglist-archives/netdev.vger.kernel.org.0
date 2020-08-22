Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C0E24E825
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgHVO7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 10:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbgHVO73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 10:59:29 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABC28C061574
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 07:59:27 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 20D0286BE8;
        Sat, 22 Aug 2020 15:59:20 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598108360; bh=7zGZQRkcAsXhCwXm+MZBHID+WpjvSz8AdzqvBfQBdkM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=20v2=204/9]=20l2tp:=2
         0add=20tracepoint=20infrastructure=20to=20core|Date:=20Sat,=2022=2
         0Aug=202020=2015:59:04=20+0100|Message-Id:=20<20200822145909.6381-
         5-tparkin@katalix.com>|In-Reply-To:=20<20200822145909.6381-1-tpark
         in@katalix.com>|References:=20<20200822145909.6381-1-tparkin@katal
         ix.com>;
        b=2wPOwyJs/sqA6SckUXasmlSF1+wpWOrv8Ml4yXzuZxg0GBlUVVKFW5LI/e++s8kpQ
         l23r2rNJTyJBRsin5E8b8G03a3nttYIyNhLrWuj97Go5gF8grlwSmW9pU81+ccWWO0
         iKF56JZcn6deZPAFm2BZK8GG66bwJDBpvvriAHggHYMwOp2YNDGyul8M+20RX/X0jm
         OItAgrY2o041oDDttQImVe1g1PLkHL1ppJUI4MXL29HxzVC8xY85hmF61ffYDLQ8OR
         T/a+mRrYcUWwJVkXAzXrwTVUneOba2+FCHGF+CjSkSTAXZn+O+qyzPPT11wUMKxwSF
         cpcoztzuYkS7Q==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next v2 4/9] l2tp: add tracepoint infrastructure to core
Date:   Sat, 22 Aug 2020 15:59:04 +0100
Message-Id: <20200822145909.6381-5-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822145909.6381-1-tparkin@katalix.com>
References: <20200822145909.6381-1-tparkin@katalix.com>
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
index 54f46ed97b3d..aee5b230469f 100644
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

