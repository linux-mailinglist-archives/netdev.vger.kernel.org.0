Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F764E2411
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346217AbiCUKQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240075AbiCUKQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:16:16 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE5F17A92
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:14:50 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id w27so23790961lfa.5
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=sejdDdw0jf50ab8MnHRj9m1lyNL06PYbtFnV1Pbd7hQ=;
        b=d5y2n5HUIMnQcnUa5Lnue8WAoAkMMeSq0DInq9aAFSdheQakyILVmqGf8fiMv6H385
         WrPVaInoDPPGK1RgAYt/egkrjFT/gvUARFvwXI7U3WGKOnND+h0JuzIL0YK+cFWf50Vb
         mQn++8hl5cSRoK3SRV7SdLQA3KsdUXTGqhPkOXf4zHn+v4ZaAnZ6ApFKeUnOQTiaiYKK
         h5CehD589cBvMOUe1btDI/qCmPKPKV6dY7kHA58cFR6g9CMpa3BU1iy8JDxer1U8BpoY
         Lp4H7Dt9sPgqMSA6ni2t6No0UKpeA+y3xNcqbKj2S+l09O99RpGk8xdFVUBnmX4MgtQF
         p2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=sejdDdw0jf50ab8MnHRj9m1lyNL06PYbtFnV1Pbd7hQ=;
        b=l0rbpyHzZEW5IZ6HMWytuvX+JuydiWT9k0yuRy79oCq/f8hCDp/s6Guy+JpDocySHz
         +fE7Iy410pnySotUSf3u4+cLyqd7qABYLzNzJKTucpTPku4JSm7H7IpFGjRfEpAHqhoh
         n63xGgu8lmbuDGk3q23bFB81xnU7AWEvX38kU73MzCfD3vkbLAe1dj2+xS0FFOh9Tu+t
         PajEqiBBymO4doPnN/XcQyaAtmzx7sOa7dvsDbZDmTXnEzulWv70QjQOUKiI8/0kxffU
         xB9jsL3BHph1bjsR7VZVQHvK8ZOXBvC4XyVq1cEMDZkDt9G8Mlxqna8jqX93GMxG4Uez
         Xb0w==
X-Gm-Message-State: AOAM530jeEx1xkdYsdu1LwOF2VgKnHJfWiX0Z9iB1V2AXoEVowAtUKN6
        gAIKTiGYnXdqZj55jjkXZ+aaFugUwu6drg==
X-Google-Smtp-Source: ABdhPJxIVSBtkR4yrkSPQXpcPy1HYjeLRYYbZTqhFJzlOyObTxaDnwy1kpIlAch2ntDjI7k1IVq9ww==
X-Received: by 2002:a05:6512:308d:b0:448:6b44:5dde with SMTP id z13-20020a056512308d00b004486b445ddemr14093060lfd.224.1647857689010;
        Mon, 21 Mar 2022 03:14:49 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f11-20020a0565123b0b00b0044a2809c621sm361598lfv.29.2022.03.21.03.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 03:14:48 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/2] net: sparx5: Add arbiter for managing PGID table
Date:   Mon, 21 Mar 2022 11:14:45 +0100
Message-Id: <20220321101446.2372093-2-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321101446.2372093-1-casper.casan@gmail.com>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PGID (Port Group ID) table holds port masks
for different purposes. The first 72 are reserved
for port destination masks, flood masks, and CPU
forwarding. The rest are shared between multicast,
link aggregation, and virtualization profiles. The
GLAG area is reserved to not be used by anything
else, since it is a subset of the MCAST area.

The arbiter keeps track of which entries are in
use. You can ask for a free ID or give back one
you are done using.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |  2 +-
 .../ethernet/microchip/sparx5/sparx5_main.c   |  3 +
 .../ethernet/microchip/sparx5/sparx5_main.h   | 21 +++++++
 .../ethernet/microchip/sparx5/sparx5_pgid.c   | 60 +++++++++++++++++++
 4 files changed, 85 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index e9dd348a6ebb..4402c3ed1dc5 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
- sparx5_ptp.o
+ sparx5_ptp.o sparx5_pgid.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 5f7c7030ce03..01be7bd84181 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -626,6 +626,9 @@ static int sparx5_start(struct sparx5 *sparx5)
 	/* Init MAC table, ageing */
 	sparx5_mact_init(sparx5);
 
+	/* Init PGID table arbitrator */
+	sparx5_pgid_init(sparx5);
+
 	/* Setup VLANs */
 	sparx5_vlan_init(sparx5);
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index df68a0891029..e97fa091c740 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -66,6 +66,12 @@ enum sparx5_vlan_port_type {
 #define PGID_BCAST	       (PGID_BASE + 6)
 #define PGID_CPU	       (PGID_BASE + 7)
 
+#define PGID_TABLE_SIZE	       3290
+
+#define PGID_MCAST_START 65
+#define PGID_GLAG_START 833
+#define PGID_GLAG_END 1088
+
 #define IFH_LEN                9 /* 36 bytes */
 #define NULL_VID               0
 #define SPX5_MACT_PULL_DELAY   (2 * HZ)
@@ -271,6 +277,8 @@ struct sparx5 {
 	struct mutex ptp_lock; /* lock for ptp interface state */
 	u16 ptp_skbs;
 	int ptp_irq;
+	/* PGID allocation map */
+	u8 pgid_map[PGID_TABLE_SIZE];
 };
 
 /* sparx5_switchdev.c */
@@ -359,6 +367,19 @@ void sparx5_ptp_txtstamp_release(struct sparx5_port *port,
 				 struct sk_buff *skb);
 irqreturn_t sparx5_ptp_irq_handler(int irq, void *args);
 
+/* sparx5_pgid.c */
+enum sparx5_pgid_type {
+	SPX5_PGID_FREE,
+	SPX5_PGID_RESERVED,
+	SPX5_PGID_MULTICAST,
+	SPX5_PGID_GLAG
+};
+
+void sparx5_pgid_init(struct sparx5 *spx5);
+int sparx5_pgid_alloc_glag(struct sparx5 *spx5, u16 *idx);
+int sparx5_pgid_alloc_mcast(struct sparx5 *spx5, u16 *idx);
+int sparx5_pgid_free(struct sparx5 *spx5, u16 idx);
+
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 {
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
new file mode 100644
index 000000000000..90366fcb9958
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include "sparx5_main.h"
+
+void sparx5_pgid_init(struct sparx5 *spx5)
+{
+	int i;
+
+	for (i = 0; i < PGID_TABLE_SIZE; i++)
+		spx5->pgid_map[i] = SPX5_PGID_FREE;
+
+	/* Reserved for unicast, flood control, broadcast, and CPU.
+	 * These cannot be freed.
+	 */
+	for (i = 0; i <= PGID_CPU; i++)
+		spx5->pgid_map[i] = SPX5_PGID_RESERVED;
+}
+
+int sparx5_pgid_alloc_glag(struct sparx5 *spx5, u16 *idx)
+{
+	int i;
+
+	for (i = PGID_GLAG_START; i <= PGID_GLAG_END; i++)
+		if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
+			spx5->pgid_map[i] = SPX5_PGID_GLAG;
+			*idx = i;
+			return 0;
+		}
+
+	return -EBUSY;
+}
+
+int sparx5_pgid_alloc_mcast(struct sparx5 *spx5, u16 *idx)
+{
+	int i;
+
+	for (i = PGID_MCAST_START; i < PGID_TABLE_SIZE; i++) {
+		if (i == PGID_GLAG_START)
+			i = PGID_GLAG_END + 1;
+
+		if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
+			spx5->pgid_map[i] = SPX5_PGID_MULTICAST;
+			*idx = i;
+			return 0;
+		}
+	}
+
+	return -EBUSY;
+}
+
+int sparx5_pgid_free(struct sparx5 *spx5, u16 idx)
+{
+	if (idx <= PGID_CPU || idx >= PGID_TABLE_SIZE)
+		return -EINVAL;
+
+	if (spx5->pgid_map[idx] == SPX5_PGID_FREE)
+		return -EINVAL;
+
+	spx5->pgid_map[idx] = SPX5_PGID_FREE;
+	return 0;
+}
-- 
2.30.2

