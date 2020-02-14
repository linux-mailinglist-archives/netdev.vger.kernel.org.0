Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E71515E9C8
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394601AbgBNRJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392230AbgBNQNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE2C246CE;
        Fri, 14 Feb 2020 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696833;
        bh=37Tl3sdRVJVadsU+L3wETW4srSquGpwjxB81nM98w+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCxEmFam5pfQw4og8DT0logeA36eMH3gMEkp47Gon1S7rvmw6Kizxueh0NIeCphbD
         AqhIJf2KLvLsAw44oaxFa7MVgrK6mUkQ2M2u+QFHH59IjF6t016ysQK0+Jjl+ghB5W
         1t1NxMcF974STTvL09IcPVYgNgqmHKfhk5ahibg0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 098/252] fore200e: Fix incorrect checks of NULL pointer dereference
Date:   Fri, 14 Feb 2020 11:09:13 -0500
Message-Id: <20200214161147.15842-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
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
index 99a38115b0a8f..86aab14872fd0 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1504,12 +1504,14 @@ fore200e_open(struct atm_vcc *vcc)
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
 
@@ -1554,10 +1556,10 @@ fore200e_close(struct atm_vcc* vcc)
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
@@ -1570,9 +1572,18 @@ fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
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

