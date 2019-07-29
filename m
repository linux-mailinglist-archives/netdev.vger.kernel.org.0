Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A6978956
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfG2KL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39754 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbfG2KLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so23786109pfn.6
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cFQnNkuuOgcoabB/x9qX+RTqSHvwztcwgiV2kWB1YOo=;
        b=LUWK9P79phXvXrhWyKjAEGZnktPrI/pzGk6OhTgoU8WxzdS1lOORXUb9zgsApqQZzx
         FKAAkUqZyAnXo+ymx1mdkYmeW2Ld0d5yq6oLjYyqCJRDDX5BG2U831Vc+s7YoUxV778Y
         IbdZJzd1P1+HKrIHiXvLKrmtt676b+2BVoV4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cFQnNkuuOgcoabB/x9qX+RTqSHvwztcwgiV2kWB1YOo=;
        b=JAKlUDHuYOuj/J7Uz8jyuVi5wR6iKmLnYZXWvB1zG+Nrkpiaqym7csaYEKBlOybbXD
         s5P2qax/+zBZtbGsNa0gXOGCE2Fh6gt/gsIe/Xmyg/f3SRO4B8uLkyLZvbUKhhrgdcm8
         WycaTUfQBT8ys4MDuzjBi1+rokkBqyAzkdMAxJKbltRmqa3U5kiFH/mVQDTU+WLieMiS
         jIkN6/54CmBIrDFut6REc1nCMVk3urxdzfooC9xi67Gnv8Mh7ZWY1QgOzUJlSb6Da0rD
         ZcTMtk1sHZL7zQXxN7xpitN0w7F5ykZ52WnUeo+moRUdak3tGL4CuAPlxwXMZQa7JuZu
         UtBg==
X-Gm-Message-State: APjAAAV+zMBF3VXdNnS5RhUr/wUa1VXRmxw+fXzZPDSwVpjRvVw9Q2f5
        R42G84W87cY3C1EMKV+ecsNfTTh5ZZE=
X-Google-Smtp-Source: APXvYqxeS3bUuGgHD9Q0fjgJmtL8raRzayKRjCQIzU9o/oEnwVbZBr6cJZ+YFxFUlS0gkzy5QW/ahw==
X-Received: by 2002:aa7:9e9a:: with SMTP id p26mr36553528pfq.25.1564395083604;
        Mon, 29 Jul 2019 03:11:23 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:23 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 11/16] bnxt_en: Refactor ethtool ring statistics logic.
Date:   Mon, 29 Jul 2019 06:10:28 -0400
Message-Id: <1564395033-19511-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code assumes that the per ring statistics counters are
fixed.  In newer chips that support a newer version of TPA, the
TPA counters are also changed.  Refactor the code by defining these
counter names in arrays so that it is easy to add a new array for
a new set of counters supported by the newer chips.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 120 +++++++++++++---------
 1 file changed, 70 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 1eb590e..a3a7bec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -137,7 +137,36 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	return rc;
 }
 
-#define BNXT_NUM_STATS	22
+static const char * const bnxt_ring_stats_str[] = {
+	"rx_ucast_packets",
+	"rx_mcast_packets",
+	"rx_bcast_packets",
+	"rx_discards",
+	"rx_drops",
+	"rx_ucast_bytes",
+	"rx_mcast_bytes",
+	"rx_bcast_bytes",
+	"tx_ucast_packets",
+	"tx_mcast_packets",
+	"tx_bcast_packets",
+	"tx_discards",
+	"tx_drops",
+	"tx_ucast_bytes",
+	"tx_mcast_bytes",
+	"tx_bcast_bytes",
+};
+
+static const char * const bnxt_ring_tpa_stats_str[] = {
+	"tpa_packets",
+	"tpa_bytes",
+	"tpa_events",
+	"tpa_aborts",
+};
+
+static const char * const bnxt_ring_sw_stats_str[] = {
+	"rx_l4_csum_errors",
+	"missed_irqs",
+};
 
 #define BNXT_RX_STATS_ENTRY(counter)	\
 	{ BNXT_RX_STATS_OFFSET(counter), __stringify(counter) }
@@ -432,9 +461,20 @@ static const struct {
 	 ARRAY_SIZE(bnxt_tx_pkts_pri_arr))
 #define BNXT_NUM_PCIE_STATS ARRAY_SIZE(bnxt_pcie_stats_arr)
 
+static int bnxt_get_num_ring_stats(struct bnxt *bp)
+{
+	int num_stats;
+
+	num_stats = ARRAY_SIZE(bnxt_ring_stats_str) +
+		    ARRAY_SIZE(bnxt_ring_sw_stats_str);
+	if (BNXT_SUPPORTS_TPA(bp))
+		num_stats += ARRAY_SIZE(bnxt_ring_tpa_stats_str);
+	return num_stats * bp->cp_nr_rings;
+}
+
 static int bnxt_get_num_stats(struct bnxt *bp)
 {
-	int num_stats = BNXT_NUM_STATS * bp->cp_nr_rings;
+	int num_stats = bnxt_get_num_ring_stats(bp);
 
 	num_stats += BNXT_NUM_SW_FUNC_STATS;
 
@@ -475,10 +515,13 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 {
 	u32 i, j = 0;
 	struct bnxt *bp = netdev_priv(dev);
-	u32 stat_fields = sizeof(struct ctx_hw_stats) / 8;
+	u32 stat_fields = ARRAY_SIZE(bnxt_ring_stats_str);
+
+	if (BNXT_SUPPORTS_TPA(bp))
+		stat_fields += ARRAY_SIZE(bnxt_ring_tpa_stats_str);
 
 	if (!bp->bnapi) {
-		j += BNXT_NUM_STATS * bp->cp_nr_rings + BNXT_NUM_SW_FUNC_STATS;
+		j += bnxt_get_num_ring_stats(bp) + BNXT_NUM_SW_FUNC_STATS;
 		goto skip_ring_stats;
 	}
 
@@ -566,56 +609,33 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 {
 	struct bnxt *bp = netdev_priv(dev);
-	u32 i;
+	u32 i, j, num_str;
 
 	switch (stringset) {
-	/* The number of strings must match BNXT_NUM_STATS defined above. */
 	case ETH_SS_STATS:
 		for (i = 0; i < bp->cp_nr_rings; i++) {
-			sprintf(buf, "[%d]: rx_ucast_packets", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: rx_mcast_packets", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: rx_bcast_packets", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: rx_discards", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: rx_drops", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: rx_ucast_bytes", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: rx_mcast_bytes", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: rx_bcast_bytes", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tx_ucast_packets", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tx_mcast_packets", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tx_bcast_packets", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tx_discards", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tx_drops", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tx_ucast_bytes", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tx_mcast_bytes", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tx_bcast_bytes", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tpa_packets", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tpa_bytes", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tpa_events", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: tpa_aborts", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: rx_l4_csum_errors", i);
-			buf += ETH_GSTRING_LEN;
-			sprintf(buf, "[%d]: missed_irqs", i);
-			buf += ETH_GSTRING_LEN;
+			num_str = ARRAY_SIZE(bnxt_ring_stats_str);
+			for (j = 0; j < num_str; j++) {
+				sprintf(buf, "[%d]: %s", i,
+					bnxt_ring_stats_str[j]);
+				buf += ETH_GSTRING_LEN;
+			}
+			if (!BNXT_SUPPORTS_TPA(bp))
+				goto skip_tpa_stats;
+
+			num_str = ARRAY_SIZE(bnxt_ring_tpa_stats_str);
+			for (j = 0; j < num_str; j++) {
+				sprintf(buf, "[%d]: %s", i,
+					bnxt_ring_tpa_stats_str[j]);
+				buf += ETH_GSTRING_LEN;
+			}
+skip_tpa_stats:
+			num_str = ARRAY_SIZE(bnxt_ring_sw_stats_str);
+			for (j = 0; j < num_str; j++) {
+				sprintf(buf, "[%d]: %s", i,
+					bnxt_ring_sw_stats_str[j]);
+				buf += ETH_GSTRING_LEN;
+			}
 		}
 		for (i = 0; i < BNXT_NUM_SW_FUNC_STATS; i++) {
 			strcpy(buf, bnxt_sw_func_stats[i].string);
-- 
2.5.1

