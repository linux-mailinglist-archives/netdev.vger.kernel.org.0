Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1431000CF
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfKRI5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:57:02 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40415 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRI5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:57:01 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep1so1292149pjb.7
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a8AL3Z15t7EZhvOLjIv6NPUIGTUlK3tbeVWPqilMLNQ=;
        b=PrwMohqG0NLpNURc6X/uP8oPRUV22SFb6G9i6+Qmmjf8W42RefFOOKCqSOiUyuzm9V
         6A2IDuQD5E7KKI6jO5YqGtEFvLSjbdUOH0pSdOyUooSG0Cc5Hh3bYcHUIhFpbp8b3x+Z
         Nya0O0kyfcJnV0bEHgSQRrEaxq4hHojafHRmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a8AL3Z15t7EZhvOLjIv6NPUIGTUlK3tbeVWPqilMLNQ=;
        b=jBdvl7xiT8oVdv1YMXTWvw8OWYJSz4187/uN39UGnT5xijUmRoFBvlz9LbJ/2rKpbR
         ThzxUpXBxXGKTVodlZTR/aR4Fj0FwbHd1owpZEw804x7aNy8+uHr5zBj5zO++AP4xQ06
         6Vsu6fDBuGYsz1906OZR6ewZCtu0mU7oQJ91/6ppNWdMhZdbBwjYWALjU8I1omS4VC8G
         OR0SETywevtLEr/foh0YfKTLFsrYTSqUnanF45/oX4JZgup1NPHWvN8BgYjy8eWQZT5P
         Hzcb/xEplZztLUZDRkxr86xleXJgVuIQ9TJu9st11Kf+RgMb9xWqmb6bLLdXlQDtOiIR
         pOJA==
X-Gm-Message-State: APjAAAUr3HbL6vlgQq6VnT0f3NrvqjSD6Zdb8KWMm7DqPKcrdDXTIydN
        yxJcrXgLHbyXmUnCUKDWjHY4ob+rgrg=
X-Google-Smtp-Source: APXvYqyfCyT7CCcjx0QGYls/tGOqRom0zuOzlv1Z0WqqzKdk74w3pobBb0sg+0DrlrNPTkDLisXW8Q==
X-Received: by 2002:a17:90a:6a0f:: with SMTP id t15mr38408729pjj.48.1574067420595;
        Mon, 18 Nov 2019 00:57:00 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.56.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:57:00 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/9] bnxt_en: Improve RX buffer error handling.
Date:   Mon, 18 Nov 2019 03:56:36 -0500
Message-Id: <1574067403-4344-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hardware reports RX buffer errors, the latest 57500 chips do not
require reset.  The packet is discarded by the hardware and the
ring will continue to operate.

Also, add an rx_buf_errors counter for this type of error.  It can help
the user to identify if the aggregation ring is too small.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 8 ++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 81bb6ce..0e5b5b8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1767,8 +1767,12 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 		rc = -EIO;
 		if (rx_err & RX_CMPL_ERRORS_BUFFER_ERROR_MASK) {
-			netdev_warn(bp->dev, "RX buffer error %x\n", rx_err);
-			bnxt_sched_reset(bp, rxr);
+			bnapi->cp_ring.rx_buf_errors++;
+			if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
+				netdev_warn(bp->dev, "RX buffer error %x\n",
+					    rx_err);
+				bnxt_sched_reset(bp, rxr);
+			}
 		}
 		goto next_rx_no_len;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c260cbb..f2b5da7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -932,6 +932,7 @@ struct bnxt_cp_ring_info {
 	dma_addr_t		hw_stats_map;
 	u32			hw_stats_ctx_id;
 	u64			rx_l4_csum_errors;
+	u64			rx_buf_errors;
 	u64			missed_irqs;
 
 	struct bnxt_ring_struct	cp_ring_struct;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index f2220b8..7a5f6bf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -173,6 +173,7 @@ static const char * const bnxt_ring_tpa2_stats_str[] = {
 
 static const char * const bnxt_ring_sw_stats_str[] = {
 	"rx_l4_csum_errors",
+	"rx_buf_errors",
 	"missed_irqs",
 };
 
@@ -552,6 +553,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		for (k = 0; k < stat_fields; j++, k++)
 			buf[j] = le64_to_cpu(hw_stats[k]);
 		buf[j++] = cpr->rx_l4_csum_errors;
+		buf[j++] = cpr->rx_buf_errors;
 		buf[j++] = cpr->missed_irqs;
 
 		bnxt_sw_func_stats[RX_TOTAL_DISCARDS].counter +=
-- 
2.5.1

