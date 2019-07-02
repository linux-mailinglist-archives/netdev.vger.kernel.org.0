Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439B85D8F2
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfGCAbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:31:22 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:52393 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfGCAbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:31:22 -0400
Received: by mail-ot1-f73.google.com with SMTP id a17so372452otd.19
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6Ba9q3J8H6HNJ2VMBe0ncUd285xO1ZlgfvQTpXqqXBY=;
        b=vmyEPLaV1oNdY6MjmxzjKJIUe32YyxxlSBVKk83KEfEnfR5iG9DCjzdzUp3rHFhNCi
         AcOxe/q8SGOHVLVMnkqXgMzRA0blNWPXA5J5Gvq0wcewSFwXyVg86PKNKgkwuvbGV6L7
         lLx7Lj/3qZmsx4gKtAjfQG1LeXz71fFCw3Vs1l5hJL6X1O4KZvEt4+CH7X8HRRwPCYbm
         561oXHpAv7jR7fcR1GonJfaQzrPH/bhn0/TlpC88kJx8fBQxlINwedekwJp23L691hEk
         TKtVcZDxxKql7UNC0PVYEvEx9iFBkoVJGYG8hO6Zs5RY/mrsrSQ0acWJzT2XZSA+AwI6
         qnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6Ba9q3J8H6HNJ2VMBe0ncUd285xO1ZlgfvQTpXqqXBY=;
        b=Ca2BkcGSmLGm8TrPwhngQJpEiFe+z++fOszk3LsIKs/bwTYhwuqWPX5Y7TKsCz1xHz
         SOJafmPVpC6QtS06VYKYim3FvA2Bizx/R0m2kGRra0SOpLfaPkrVxW81xtVhjaq8G3hF
         Hcsk3NNVR3+F4hC30HecWDQMHjxXmmitY7bOlXNj/ifjoptodTCgkuOmUGVIIzmlAVTV
         bGj/UxEF0apELtJquy0dUJDFtZB0Yw92RQKHZgkxH6CbRus0PjwYPZKuKs+LPcOEvGWF
         JT7RG+vCaV2Imrt8bCtpEV2KtjxPDDbTLsSI/iwnMDVDx0aMbp8UsIcLTSmqV6j4NYmw
         UPzg==
X-Gm-Message-State: APjAAAUVEpFXS7swtdVPFFueI7stsdqmQ8vYQf5xV8BPnWeQQxmEtlfe
        5XfaN20Vfe92SNn+apycR6iytE9cQf97ETblsHw2yFTjc4LdyImvElKeo1x6n5BG3/rKT7egxaM
        MXQqLObTRi7ENMNeCWCf/oeEF5q0ocGmzLQqP3mBbdzMJZ8HDs470eFM32Y/HlA==
X-Google-Smtp-Source: APXvYqwTm1T0UR97KGDKDYrHyaZZ1AEEFtvD1XrHZfGgi1O1VgY2sy6TeTr/io3lJB45wpay3j/GjzDMg8k=
X-Received: by 2002:a63:fa0d:: with SMTP id y13mr32917733pgh.258.1562107620460;
 Tue, 02 Jul 2019 15:47:00 -0700 (PDT)
Date:   Tue,  2 Jul 2019 15:46:57 -0700
Message-Id: <20190702224657.23568-1-csully@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH] gve: Fix u64_stats_sync to initialize start
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

u64_stats_fetch_begin needs to initialize start.

Signed-off-by: Catherine Sullivan <csully@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 6 ++++--
 drivers/net/ethernet/google/gve/gve_main.c    | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 52947d668e6d..26540b856541 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -102,7 +102,8 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	     ring < priv->rx_cfg.num_queues; ring++) {
 		if (priv->rx) {
 			do {
-				u64_stats_fetch_begin(&priv->rx[ring].statss);
+				start =
+				  u64_stats_fetch_begin(&priv->rx[ring].statss);
 				rx_pkts += priv->rx[ring].rpackets;
 				rx_bytes += priv->rx[ring].rbytes;
 			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
@@ -113,7 +114,8 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	     ring < priv->tx_cfg.num_queues; ring++) {
 		if (priv->tx) {
 			do {
-				u64_stats_fetch_begin(&priv->tx[ring].statss);
+				start =
+				  u64_stats_fetch_begin(&priv->tx[ring].statss);
 				tx_pkts += priv->tx[ring].pkt_done;
 				tx_bytes += priv->tx[ring].bytes_done;
 			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 6a147ed4627f..83f65a5a9a3f 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -35,7 +35,8 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 	if (priv->rx) {
 		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
 			do {
-				u64_stats_fetch_begin(&priv->rx[ring].statss);
+				start =
+				  u64_stats_fetch_begin(&priv->rx[ring].statss);
 				s->rx_packets += priv->rx[ring].rpackets;
 				s->rx_bytes += priv->rx[ring].rbytes;
 			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
@@ -45,7 +46,8 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 	if (priv->tx) {
 		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
 			do {
-				u64_stats_fetch_begin(&priv->tx[ring].statss);
+				start =
+				  u64_stats_fetch_begin(&priv->tx[ring].statss);
 				s->tx_packets += priv->tx[ring].pkt_done;
 				s->tx_bytes += priv->tx[ring].bytes_done;
 			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
-- 
2.22.0.410.gd8fdbe21b5-goog

