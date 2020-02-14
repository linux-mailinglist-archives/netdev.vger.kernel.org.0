Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361BA15EDA8
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgBNRfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390264AbgBNQFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64EF3222C2;
        Fri, 14 Feb 2020 16:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696355;
        bh=z70ujt1EqXAZKyx0yyjAuQe/ZW4XhB3+LwH5tlRzWqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ql5q+3kWOPnf9mcHwFBUw7F16QVvqRL6Lg80R+HB9GK3St2qIiocNcn76nF468ydC
         vtMsVhvPpr7EGhenjN4FwFqay1kSrnH+/xgZdG6YbBROttqSzMN7lWH4v26ZdUIth/
         p2rFmdq3+FjYU4bvCPdKLIjecd5I29pcQ3mFWiCA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 188/459] fore200e: Fix incorrect checks of NULL pointer dereference
Date:   Fri, 14 Feb 2020 10:57:18 -0500
Message-Id: <20200214160149.11681-188-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit bbd20c939c8aa3f27fa30e86691af250bf92973a ]

In fore200e_send and fore200e_close, the pointers from the arguments
are dereferenced in the variable declaration block and then checked
for NULL. The patch fixes these issues by avoiding NULL pointer
dereferences.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/fore200e.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index f1a5002053132..8fbd36eb89410 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1414,12 +1414,14 @@ fore200e_open(struct atm_vcc *vcc)
 static void
 fore200e_close(struct atm_vcc* vcc)
 {
-    struct fore200e*        fore200e = FORE200E_DEV(vcc->dev);
     struct fore200e_vcc*    fore200e_vcc;
+    struct fore200e*        fore200e;
     struct fore200e_vc_map* vc_map;
     unsigned long           flags;
 
     ASSERT(vcc);
+    fore200e = FORE200E_DEV(vcc->dev);
+
     ASSERT((vcc->vpi >= 0) && (vcc->vpi < 1<<FORE200E_VPI_BITS));
     ASSERT((vcc->vci >= 0) && (vcc->vci < 1<<FORE200E_VCI_BITS));
 
@@ -1464,10 +1466,10 @@ fore200e_close(struct atm_vcc* vcc)
 static int
 fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
 {
-    struct fore200e*        fore200e     = FORE200E_DEV(vcc->dev);
-    struct fore200e_vcc*    fore200e_vcc = FORE200E_VCC(vcc);
+    struct fore200e*        fore200e;
+    struct fore200e_vcc*    fore200e_vcc;
     struct fore200e_vc_map* vc_map;
-    struct host_txq*        txq          = &fore200e->host_txq;
+    struct host_txq*        txq;
     struct host_txq_entry*  entry;
     struct tpd*             tpd;
     struct tpd_haddr        tpd_haddr;
@@ -1480,9 +1482,18 @@ fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
     unsigned char*          data;
     unsigned long           flags;
 
-    ASSERT(vcc);
-    ASSERT(fore200e);
-    ASSERT(fore200e_vcc);
+    if (!vcc)
+        return -EINVAL;
+
+    fore200e = FORE200E_DEV(vcc->dev);
+    fore200e_vcc = FORE200E_VCC(vcc);
+
+    if (!fore200e)
+        return -EINVAL;
+
+    txq = &fore200e->host_txq;
+    if (!fore200e_vcc)
+        return -EINVAL;
 
     if (!test_bit(ATM_VF_READY, &vcc->flags)) {
 	DPRINTK(1, "VC %d.%d.%d not ready for tx\n", vcc->itf, vcc->vpi, vcc->vpi);
-- 
2.20.1

