Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7574C1B93EC
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgDZUZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726375AbgDZUZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 16:25:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABCCC061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d184so7810566pfd.4
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/WCw+Jpve9xXenfDw/dTJTppS0IDBf18pPvN0Ut/Zsg=;
        b=G5mi2xqDitFYs1eJveD5i2hvs8uxMS1aBgs7BTZnn1E6sddqbn8OEpmZMQRQlTFHSJ
         Xb5g2uhqZ3gCWjplLP/mPr1f5iJhItUUIciJke9QNtSbRvcxhYzHAVZ1OID8JST1osvN
         Yg0HzfSNVodgCyDR36axxDEc0c2yxBEz5xkiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/WCw+Jpve9xXenfDw/dTJTppS0IDBf18pPvN0Ut/Zsg=;
        b=Qmf1Nn/YZldzWvVomgudKDExTe5uxeRoaXNiB1zjH1GwfhVnZuAldmG/AQwOwUNLD6
         u4PzQPVwQToZJz6OJUtnqadn/FQV3exWAb1qppmoGK2ydjJrLkOtUOtnXdhdjGDRpGr1
         T60wwzPSNb0H+SBhcVe/IKvARR801IUQzlKl8JEDse8ZAu0WVjNjJov/MpmtpC/5U7/4
         ZpCOix8SwJkC2/bN3GJrE46h/oSQJOCSIcTmtJLiY+fID+iEAJKIMH4CCUQXsjrsaIE6
         sIbQvGHlbyxPMM8RR40SEmupqfg2mcXpbFOMEVhMUHUZP23MNkTOL/DoNGzy61PmxNVQ
         yK4A==
X-Gm-Message-State: AGi0Pub1NxUiC7nImtDjWdEw0X/07P8h4ZpetESPmK5MADvKZa4luZ3R
        hcgnnmqDS2OBUhxXg9rFLwCpwQ==
X-Google-Smtp-Source: APiQypJ4qi501BQndzxcxLgbsLQKAJzO22/IA2ymPtHRwipesdxvcWfHx/OPpYyLTc2d1g8B2mgCpw==
X-Received: by 2002:a62:1ec3:: with SMTP id e186mr20708188pfe.46.1587932712897;
        Sun, 26 Apr 2020 13:25:12 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a136sm10862103pfa.99.2020.04.26.13.25.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 13:25:12 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 5/5] bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().
Date:   Sun, 26 Apr 2020 16:24:42 -0400
Message-Id: <1587932682-1212-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
References: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current logic in bnxt_fix_features() will inadvertently turn on both
CTAG and STAG VLAN offload if the user tries to disable both.  Fix it
by checking that the user is trying to enable CTAG or STAG before
enabling both.  The logic is supposed to enable or disable both CTAG and
STAG together.

Fixes: 5a9f6b238e59 ("bnxt_en: Enable and disable RX CTAG and RX STAG VLAN acceleration together.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 070c42d..d1a8371 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9780,6 +9780,7 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 					   netdev_features_t features)
 {
 	struct bnxt *bp = netdev_priv(dev);
+	netdev_features_t vlan_features;
 
 	if ((features & NETIF_F_NTUPLE) && !bnxt_rfs_capable(bp))
 		features &= ~NETIF_F_NTUPLE;
@@ -9796,12 +9797,14 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
 	 */
-	if ((features & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX)) !=
-	    (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX)) {
+	vlan_features = features & (NETIF_F_HW_VLAN_CTAG_RX |
+				    NETIF_F_HW_VLAN_STAG_RX);
+	if (vlan_features != (NETIF_F_HW_VLAN_CTAG_RX |
+			      NETIF_F_HW_VLAN_STAG_RX)) {
 		if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
 			features &= ~(NETIF_F_HW_VLAN_CTAG_RX |
 				      NETIF_F_HW_VLAN_STAG_RX);
-		else
+		else if (vlan_features)
 			features |= NETIF_F_HW_VLAN_CTAG_RX |
 				    NETIF_F_HW_VLAN_STAG_RX;
 	}
-- 
2.5.1

