Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E068A7102C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbfGWDnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:43:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38500 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbfGWDnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:43:12 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so18390580pfn.5
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 20:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=7IsuEEyOhwTDq0iuccX9QFOhk+ECbXHwEKOsR5YJ4sc=;
        b=Ryz/WY9+yXqz2hqAtR4gqcZ+VMDxXxXkHI0T6f7cJPInZO0evjjXiYnQyB+57nhpat
         GbHFLRi+NVJ5Rz394byQfLCoh0VzUzH3Wkv5PsvW5VBg9UbD5nY9VFvDKTr9Vd80Gkwb
         wSg0gqh2kasls3NPWwypn17tqap8TQaisweMZ9M1ch0GX55h2htKdUytCsR/wgx2S3g3
         BbGe0vuEsG4mfSkqM5Bkp8gq4ecNk/yRysS8GVrrkxZ72PttgO9x2HMeEGDiCJW7wLhI
         jJ4aZFCvDx7wUNsjxt0z1iiAbeBnMn+PG1EYovwrGiREe3/zMJ/9TzmetqCS9sm7SVlG
         qEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=7IsuEEyOhwTDq0iuccX9QFOhk+ECbXHwEKOsR5YJ4sc=;
        b=mT1WKEoKPkNn2ioOf6rWS9bvQKJOULMKt2zIDRxhh39yQD1fe8+wkDgOBwV1lEkcvU
         auc6i4nH5S5h6YM7eaA7wMySOPLH/PJzkyzzX6ykwvBbHNl/xK0FA80bW5evf8xk90b5
         kqnyLbVa8v27rD99xB9BTuqIYoK/e7DYNnhLvdEXcoBjHxjFe+DkHabxNwi/oE9HiGVP
         QkCg1SZhN4We8x+KwWplW/qAgCf6zXH0s2dMpS1yeKGIoI23CW56QUqUKXivQIaNJ9uU
         Vu40/3m6cn7j/ZsiwHpPhigfDUU58Cbx9lOlQOp91yMaEEm49pDdyLxHlXNGJD0x2m3Y
         8EHw==
X-Gm-Message-State: APjAAAUvuSbt/D7I8QJQxiMPnBhVjO9TdC0IY8vC+9U7LsPAUth4iEI1
        rLKniAtL4vIUxjWjp3WwoQY04MaDGjE=
X-Google-Smtp-Source: APXvYqwxKjUX0Bi+PKMc2UR1m4zguIhGqR2Rf5QFgxuulwd/XU10B8RNwdtkST8T3iK2VJfuq/EKfg==
X-Received: by 2002:a62:8344:: with SMTP id h65mr3567530pfe.85.1563853391014;
        Mon, 22 Jul 2019 20:43:11 -0700 (PDT)
Received: from localhost.localdomain (76-14-106-55.rk.wavecable.com. [76.14.106.55])
        by smtp.gmail.com with ESMTPSA id y10sm42364985pfm.66.2019.07.22.20.43.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 20:43:10 -0700 (PDT)
From:   Rosen Penev <rosenp@gmail.com>
To:     netdev@vger.kernel.org
Subject: [PATCH] net-next: ag71xx: Rearrange ag711xx struct to remove holes
Date:   Mon, 22 Jul 2019 20:43:09 -0700
Message-Id: <20190723034309.16492-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed ____cacheline_aligned attribute to ring structs. This actually
causes holes in the ag71xx struc as well as lower performance.

Rearranged struct members to fall within respective cachelines. The RX
ring struct now does not share a cacheline with the TX ring. The NAPI
atruct now takes up its own cachelines and does not share.

According to pahole -C ag71xx -c 32

Before:

struct ag71xx {
	/* size: 384, cachelines: 12, members: 22 */
	/* sum members: 375, holes: 2, sum holes: 9 */

After:

struct ag71xx {
	/* size: 376, cachelines: 12, members: 22 */
	/* last cacheline: 24 bytes */

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/ethernet/atheros/ag71xx.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 8f450a03a885..4699feb4ee31 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -295,17 +295,16 @@ struct ag71xx {
 	/* Critical data related to the per-packet data path are clustered
 	 * early in this structure to help improve the D-cache footprint.
 	 */
-	struct ag71xx_ring rx_ring ____cacheline_aligned;
-	struct ag71xx_ring tx_ring ____cacheline_aligned;
+	struct ag71xx_ring rx_ring;
+	struct ag71xx_ring tx_ring;
 
 	u16 rx_buf_size;
-	u8 rx_buf_offset;
+	u16 rx_buf_offset;
 
+	const struct ag71xx_dcfg *dcfg;
 	struct net_device *ndev;
 	struct platform_device *pdev;
 	struct napi_struct napi;
-	u32 msg_enable;
-	const struct ag71xx_dcfg *dcfg;
 
 	/* From this point onwards we're not looking at per-packet fields. */
 	void __iomem *mac_base;
@@ -313,20 +312,18 @@ struct ag71xx {
 	struct ag71xx_desc *stop_desc;
 	dma_addr_t stop_desc_dma;
 
-	int phy_if_mode;
-
-	struct delayed_work restart_work;
-	struct timer_list oom_timer;
-
-	struct reset_control *mac_reset;
-
 	u32 fifodata[3];
 	int mac_idx;
+	int phy_if_mode;
+	u32 msg_enable;
 
 	struct reset_control *mdio_reset;
 	struct mii_bus *mii_bus;
 	struct clk *clk_mdio;
 	struct clk *clk_eth;
+	struct reset_control *mac_reset;
+	struct delayed_work restart_work;
+	struct timer_list oom_timer;
 };
 
 static int ag71xx_desc_empty(struct ag71xx_desc *desc)
-- 
2.17.1

