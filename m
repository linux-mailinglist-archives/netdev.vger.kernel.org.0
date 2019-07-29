Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4C178950
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfG2KL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40128 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbfG2KLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so28014838pgj.7
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1gWgUjAqrnumP7CTOFnrteZdcQJnHdS5vZWtPgEa8oo=;
        b=GeTyUt0HTnpbrEVH3bwwsGR4inerGP/T8iRA0TacPeWS06eBfznaC34e5X76OZPYWx
         sCm1CMd92ZU2pKeb3aKQdM+nIShG9aWYe5AknL1fMs2D6Cw49OQgjd6HTzEFiG1hm0wX
         2l7TyK4JiYDCP8cGhH3EhANa557c8BN/e2U84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1gWgUjAqrnumP7CTOFnrteZdcQJnHdS5vZWtPgEa8oo=;
        b=d7noFh5vOOpV509wgN2Em63Ejt9JW9XzZt6rO7Gg9Wj2C6E9lOnTCl7HKj8KvYVi0H
         14xtEX+PxFVuZRaiEaM7EEBWzOvfGSIptaKXJewMunekRSCReR1UG5yw0tyRMDobgdFC
         hYVJizMkHGtW+L21jgNTGTZ1obEZKUKTlLmvYfNgOgRh3Hf57JJynoLp34qX51N77OMa
         EeJKo0T8udCjbTtZzoBaG+BZo0qrxOACDlR4vbnO8MRhrINuMv5ehPsAoeqNDuI+6d53
         Ksvl5dRrRT7MxDr89m8lq1ZtAEWo49tAudmafpsI3iXtVOA7vCZ2v1QXG/Lq9wB4zyw/
         ZmVw==
X-Gm-Message-State: APjAAAVmGYCOnokZ3dckTbFVq682bUVccJNrjmV0Wayc30Fmod+9CNCZ
        mHIYicJgd9tW4sKzyUoBg+VvIwxfc90=
X-Google-Smtp-Source: APXvYqyF+Ne7a5yvxzGhGJfefatTq7ISJX2bl4+bSq5ZT9RdnRTn872AJTtGnFe041EVmsGyiU7gHg==
X-Received: by 2002:a63:db45:: with SMTP id x5mr90868332pgi.293.1564395085061;
        Mon, 29 Jul 2019 03:11:25 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:24 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 13/16] bnxt_en: Support TPA counters on 57500 chips.
Date:   Mon, 29 Jul 2019 06:10:30 -0400
Message-Id: <1564395033-19511-14-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the new expanded TPA v2 counters on 57500 B0 chips for
ethtool -S.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 41 +++++++++++++++++------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index a3a7bec..3a3d8a9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -163,6 +163,14 @@ static const char * const bnxt_ring_tpa_stats_str[] = {
 	"tpa_aborts",
 };
 
+static const char * const bnxt_ring_tpa2_stats_str[] = {
+	"rx_tpa_eligible_pkt",
+	"rx_tpa_eligible_bytes",
+	"rx_tpa_pkt",
+	"rx_tpa_bytes",
+	"rx_tpa_errors",
+};
+
 static const char * const bnxt_ring_sw_stats_str[] = {
 	"rx_l4_csum_errors",
 	"missed_irqs",
@@ -461,14 +469,23 @@ static const struct {
 	 ARRAY_SIZE(bnxt_tx_pkts_pri_arr))
 #define BNXT_NUM_PCIE_STATS ARRAY_SIZE(bnxt_pcie_stats_arr)
 
+static int bnxt_get_num_tpa_ring_stats(struct bnxt *bp)
+{
+	if (BNXT_SUPPORTS_TPA(bp)) {
+		if (bp->max_tpa_v2)
+			return ARRAY_SIZE(bnxt_ring_tpa2_stats_str);
+		return ARRAY_SIZE(bnxt_ring_tpa_stats_str);
+	}
+	return 0;
+}
+
 static int bnxt_get_num_ring_stats(struct bnxt *bp)
 {
 	int num_stats;
 
 	num_stats = ARRAY_SIZE(bnxt_ring_stats_str) +
-		    ARRAY_SIZE(bnxt_ring_sw_stats_str);
-	if (BNXT_SUPPORTS_TPA(bp))
-		num_stats += ARRAY_SIZE(bnxt_ring_tpa_stats_str);
+		    ARRAY_SIZE(bnxt_ring_sw_stats_str) +
+		    bnxt_get_num_tpa_ring_stats(bp);
 	return num_stats * bp->cp_nr_rings;
 }
 
@@ -515,10 +532,8 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 {
 	u32 i, j = 0;
 	struct bnxt *bp = netdev_priv(dev);
-	u32 stat_fields = ARRAY_SIZE(bnxt_ring_stats_str);
-
-	if (BNXT_SUPPORTS_TPA(bp))
-		stat_fields += ARRAY_SIZE(bnxt_ring_tpa_stats_str);
+	u32 stat_fields = ARRAY_SIZE(bnxt_ring_stats_str) +
+			  bnxt_get_num_tpa_ring_stats(bp);
 
 	if (!bp->bnapi) {
 		j += bnxt_get_num_ring_stats(bp) + BNXT_NUM_SW_FUNC_STATS;
@@ -609,6 +624,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 {
 	struct bnxt *bp = netdev_priv(dev);
+	static const char * const *str;
 	u32 i, j, num_str;
 
 	switch (stringset) {
@@ -623,10 +639,15 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 			if (!BNXT_SUPPORTS_TPA(bp))
 				goto skip_tpa_stats;
 
-			num_str = ARRAY_SIZE(bnxt_ring_tpa_stats_str);
+			if (bp->max_tpa_v2) {
+				num_str = ARRAY_SIZE(bnxt_ring_tpa2_stats_str);
+				str = bnxt_ring_tpa2_stats_str;
+			} else {
+				num_str = ARRAY_SIZE(bnxt_ring_tpa_stats_str);
+				str = bnxt_ring_tpa_stats_str;
+			}
 			for (j = 0; j < num_str; j++) {
-				sprintf(buf, "[%d]: %s", i,
-					bnxt_ring_tpa_stats_str[j]);
+				sprintf(buf, "[%d]: %s", i, str[j]);
 				buf += ETH_GSTRING_LEN;
 			}
 skip_tpa_stats:
-- 
2.5.1

