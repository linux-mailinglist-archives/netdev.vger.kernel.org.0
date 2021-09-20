Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16CD410E98
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhITDKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbhITDKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:10:22 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076F9C061764;
        Sun, 19 Sep 2021 20:08:56 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y4so13391202pfe.5;
        Sun, 19 Sep 2021 20:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CSZYljPK5BmsR40LilzCqFqd7paSyf5Uxl0zTke07Q0=;
        b=ffh3PrF217PvyOTAsag6/tfeXqAfuLbxVKK3BFE5f787j9oU/BglJy7o9p0oqMseD8
         iouyhg6TZf5CbVzh1v1jTwfOZaU2+ENUwZwf/hAdN/4wJs22mSj8TWhCuYwWEaFOiC2h
         GXGeOdO7g5eTNJrzFc/ppVeBCBFoLNPEZwEz38TFXhUbxKrW64cd/W5pt/0cvuYDuGSB
         hfs73mO7nXxDzapqfsM2u4uG11Ba2rNIlr1hr4xHr2j0GG6MvnLLU/tjSvlumy3N39Mj
         LVqbbfvQzq+sAtecOtmtUe+ZrcGobutrQfGEFWd+1iT3PFnkOgvYO97Rs22xdz/l2x27
         mQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CSZYljPK5BmsR40LilzCqFqd7paSyf5Uxl0zTke07Q0=;
        b=mF++BV8iAHlI7YutdD0aniNwVDfKigLB2qczx9TZ777Mv1daMUam1w2HjWxZx3Oljg
         jII5uVWxbSodtIU88juV6J+N1KauTbmE2+bw4GXuW44wJvTBNXLi4NFQc+oyr3vBTa0v
         qdlOVDwEmC1htZ/7G18ZWW/X2WzrT6mx6JYVnrEvqyxYowd7oE5W5lPhvIQcUCo82Sv1
         y9CyYw0eTcDArXN9Km72maEhl591N0popfetjjL2zi6LGlIQ9l2pT149ozJiAwY/QCy7
         n/0QOPr8NPnVTSQgjaJTXuDxz8RDPBeHKg7VsrG2K9VjcY2Lfi6NEHgaAZRLdoiOJtOr
         owuA==
X-Gm-Message-State: AOAM5305T7l2dMoWTEWYgxXNMijA6KPXWbXoDVr+7CesGSgdV0EZiXjB
        0Y3i2ROEiILs//phwyd36TM7Z3yD+Li6mEHM
X-Google-Smtp-Source: ABdhPJxhnT1Eg+ZrKnKfahAB9pQhv5N/qQ19L2b4DP0jlV+iZkisksmhkvJzzShXK+T0b+ulY7UnIg==
X-Received: by 2002:a65:4486:: with SMTP id l6mr21782217pgq.145.1632107333987;
        Sun, 19 Sep 2021 20:08:53 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:08:53 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 03/17] net: ipa: Refactor GSI code
Date:   Mon, 20 Sep 2021 08:37:57 +0530
Message-Id: <20210920030811.57273-4-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Lypak <vladimir.lypak@gmail.com>

Perform machine refactor to change "gsi_" with "ipa_" for function which
aren't actually GSI-specific and going to be reused for IPA v2 with BAM
DMA interface.

Also rename "gsi_trans.*" to "ipa_trans.*", gsi.h to ipa_dma.h, gsi_private.h
to "ipa_dma_private.h".

All the changes in this commit is done with this script:

symbols="gsi_trans gsi_trans_pool gsi_trans_info gsi_channel gsi_trans_pool_init
gsi_trans_pool_exit gsi_trans_pool_init_dma gsi_trans_pool_exit_dma
gsi_trans_pool_alloc_common gsi_trans_pool_alloc gsi_trans_pool_alloc_dma
gsi_trans_pool_next gsi_channel_trans_complete gsi_trans_move_pending
gsi_trans_move_complete gsi_trans_move_polled gsi_trans_tre_reserve
gsi_trans_tre_release gsi_channel_trans_alloc gsi_trans_free
gsi_trans_cmd_add gsi_trans_page_add gsi_trans_skb_add gsi_trans_commit
gsi_trans_commit_wait gsi_trans_commit_wait_timeout gsi_trans_complete
gsi_channel_trans_cancel_pending gsi_channel_trans_init gsi_channel_trans_exit
gsi_channel_tx_queued"

git mv gsi.h ipa_dma.h
git mv gsi_private.h ipa_dma_private.h
git mv gsi_trans.c ipa_trans.c
git mv gsi_trans.h ipa_trans.h

sed -i "s/\<gsi\.h\>/ipa_dma.h/g" *
sed -i "s/\<gsi_private\.h\>/ipa_dma_private.h/g" *
sed -i "s/\<gsi_trans\.o\>/ipa_trans.o/g" Makefile
sed -i "s/\<gsi_trans\.h\>/ipa_trans.h/g" *

for i in $symbols; do
    sed -i "s/\<${i}\>/ipa_${i##gsi_}/g" *
done

sed -i "s/\<struct gsi\>/struct ipa_dma/g" *

sed -i "s/\<struct ipa_dma\> \*gsi/struct ipa_dma *dma_subsys/g" ipa_trans.h ipa_dma.h
sed -i "s/\<channel->gsi\>/channel->dma_subsys/g" *
sed -i "s/\<trans->gsi\>/trans->dma_subsys/g" *

sed -i "s/\<struct ipa_dma\> gsi/struct ipa_dma dma_subsys/g" ipa.h ipa_dma.h
sed -i "s/struct ipa, gsi/struct ipa, dma_subsys/g" *
sed -i "s/\<ipa->gsi\>/ipa->dma_subsys/g" *

Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/Makefile                      |   2 +-
 drivers/net/ipa/gsi.c                         | 305 +++++++++---------
 drivers/net/ipa/ipa.h                         |   6 +-
 drivers/net/ipa/ipa_cmd.c                     |  98 +++---
 drivers/net/ipa/ipa_cmd.h                     |  20 +-
 drivers/net/ipa/ipa_data-v3.5.1.c             |   2 +-
 drivers/net/ipa/ipa_data-v4.11.c              |   2 +-
 drivers/net/ipa/ipa_data-v4.2.c               |   2 +-
 drivers/net/ipa/ipa_data-v4.5.c               |   2 +-
 drivers/net/ipa/ipa_data-v4.9.c               |   2 +-
 drivers/net/ipa/{gsi.h => ipa_dma.h}          |  56 ++--
 .../ipa/{gsi_private.h => ipa_dma_private.h}  |  44 +--
 drivers/net/ipa/ipa_endpoint.c                |  60 ++--
 drivers/net/ipa/ipa_endpoint.h                |   6 +-
 drivers/net/ipa/ipa_gsi.c                     |  18 +-
 drivers/net/ipa/ipa_gsi.h                     |  12 +-
 drivers/net/ipa/ipa_main.c                    |  14 +-
 drivers/net/ipa/ipa_mem.c                     |  14 +-
 drivers/net/ipa/ipa_table.c                   |  28 +-
 drivers/net/ipa/{gsi_trans.c => ipa_trans.c}  | 172 +++++-----
 drivers/net/ipa/{gsi_trans.h => ipa_trans.h}  |  74 ++---
 21 files changed, 471 insertions(+), 468 deletions(-)
 rename drivers/net/ipa/{gsi.h => ipa_dma.h} (85%)
 rename drivers/net/ipa/{gsi_private.h => ipa_dma_private.h} (67%)
 rename drivers/net/ipa/{gsi_trans.c => ipa_trans.c} (81%)
 rename drivers/net/ipa/{gsi_trans.h => ipa_trans.h} (72%)

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index bdfb2430ab2c..3cd021fb992e 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -1,7 +1,7 @@
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
 ipa-y			:=	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
-				ipa_table.o ipa_interrupt.o gsi.o gsi_trans.o \
+				ipa_table.o ipa_interrupt.o gsi.o ipa_trans.o \
 				ipa_gsi.o ipa_smp2p.o ipa_uc.o \
 				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index a2fcdb1abdb9..74ae0d07f859 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -15,10 +15,10 @@
 #include <linux/platform_device.h>
 #include <linux/netdevice.h>
 
-#include "gsi.h"
+#include "ipa_dma.h"
 #include "gsi_reg.h"
-#include "gsi_private.h"
-#include "gsi_trans.h"
+#include "ipa_dma_private.h"
+#include "ipa_trans.h"
 #include "ipa_gsi.h"
 #include "ipa_data.h"
 #include "ipa_version.h"
@@ -170,40 +170,41 @@ static void gsi_validate_build(void)
 }
 
 /* Return the channel id associated with a given channel */
-static u32 gsi_channel_id(struct gsi_channel *channel)
+static u32 gsi_channel_id(struct ipa_channel *channel)
 {
-	return channel - &channel->gsi->channel[0];
+	return channel - &channel->dma_subsys->channel[0];
 }
 
 /* An initialized channel has a non-null GSI pointer */
-static bool gsi_channel_initialized(struct gsi_channel *channel)
+static bool gsi_channel_initialized(struct ipa_channel *channel)
 {
-	return !!channel->gsi;
+	return !!channel->dma_subsys;
 }
 
 /* Update the GSI IRQ type register with the cached value */
-static void gsi_irq_type_update(struct gsi *gsi, u32 val)
+static void gsi_irq_type_update(struct ipa_dma *gsi, u32 val)
 {
 	gsi->type_enabled_bitmap = val;
 	iowrite32(val, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
 }
 
-static void gsi_irq_type_enable(struct gsi *gsi, enum gsi_irq_type_id type_id)
+static void gsi_irq_type_enable(struct ipa_dma *gsi, enum gsi_irq_type_id type_id)
 {
 	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | BIT(type_id));
 }
 
-static void gsi_irq_type_disable(struct gsi *gsi, enum gsi_irq_type_id type_id)
+static void gsi_irq_type_disable(struct ipa_dma *gsi, enum gsi_irq_type_id type_id)
 {
 	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap & ~BIT(type_id));
 }
 
+/* Turn off all GSI interrupts initially; there is no gsi_irq_teardown() */
 /* Event ring commands are performed one at a time.  Their completion
  * is signaled by the event ring control GSI interrupt type, which is
  * only enabled when we issue an event ring command.  Only the event
  * ring being operated on has this interrupt enabled.
  */
-static void gsi_irq_ev_ctrl_enable(struct gsi *gsi, u32 evt_ring_id)
+static void gsi_irq_ev_ctrl_enable(struct ipa_dma *gsi, u32 evt_ring_id)
 {
 	u32 val = BIT(evt_ring_id);
 
@@ -218,7 +219,7 @@ static void gsi_irq_ev_ctrl_enable(struct gsi *gsi, u32 evt_ring_id)
 }
 
 /* Disable event ring control interrupts */
-static void gsi_irq_ev_ctrl_disable(struct gsi *gsi)
+static void gsi_irq_ev_ctrl_disable(struct ipa_dma *gsi)
 {
 	gsi_irq_type_disable(gsi, GSI_EV_CTRL);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
@@ -229,7 +230,7 @@ static void gsi_irq_ev_ctrl_disable(struct gsi *gsi)
  * enabled when we issue a channel command.  Only the channel being
  * operated on has this interrupt enabled.
  */
-static void gsi_irq_ch_ctrl_enable(struct gsi *gsi, u32 channel_id)
+static void gsi_irq_ch_ctrl_enable(struct ipa_dma *gsi, u32 channel_id)
 {
 	u32 val = BIT(channel_id);
 
@@ -244,13 +245,13 @@ static void gsi_irq_ch_ctrl_enable(struct gsi *gsi, u32 channel_id)
 }
 
 /* Disable channel control interrupts */
-static void gsi_irq_ch_ctrl_disable(struct gsi *gsi)
+static void gsi_irq_ch_ctrl_disable(struct ipa_dma *gsi)
 {
 	gsi_irq_type_disable(gsi, GSI_CH_CTRL);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
 }
 
-static void gsi_irq_ieob_enable_one(struct gsi *gsi, u32 evt_ring_id)
+static void gsi_irq_ieob_enable_one(struct ipa_dma *gsi, u32 evt_ring_id)
 {
 	bool enable_ieob = !gsi->ieob_enabled_bitmap;
 	u32 val;
@@ -264,7 +265,7 @@ static void gsi_irq_ieob_enable_one(struct gsi *gsi, u32 evt_ring_id)
 		gsi_irq_type_enable(gsi, GSI_IEOB);
 }
 
-static void gsi_irq_ieob_disable(struct gsi *gsi, u32 event_mask)
+static void gsi_irq_ieob_disable(struct ipa_dma *gsi, u32 event_mask)
 {
 	u32 val;
 
@@ -278,13 +279,13 @@ static void gsi_irq_ieob_disable(struct gsi *gsi, u32 event_mask)
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 }
 
-static void gsi_irq_ieob_disable_one(struct gsi *gsi, u32 evt_ring_id)
+static void gsi_irq_ieob_disable_one(struct ipa_dma *gsi, u32 evt_ring_id)
 {
 	gsi_irq_ieob_disable(gsi, BIT(evt_ring_id));
 }
 
 /* Enable all GSI_interrupt types */
-static void gsi_irq_enable(struct gsi *gsi)
+static void gsi_irq_enable(struct ipa_dma *gsi)
 {
 	u32 val;
 
@@ -307,7 +308,7 @@ static void gsi_irq_enable(struct gsi *gsi)
 }
 
 /* Disable all GSI interrupt types */
-static void gsi_irq_disable(struct gsi *gsi)
+static void gsi_irq_disable(struct ipa_dma *gsi)
 {
 	gsi_irq_type_update(gsi, 0);
 
@@ -340,7 +341,7 @@ static u32 gsi_ring_index(struct gsi_ring *ring, u32 offset)
  * or false if it times out.
  */
 static bool
-gsi_command(struct gsi *gsi, u32 reg, u32 val, struct completion *completion)
+gsi_command(struct ipa_dma *gsi, u32 reg, u32 val, struct completion *completion)
 {
 	unsigned long timeout = msecs_to_jiffies(GSI_CMD_TIMEOUT);
 
@@ -353,7 +354,7 @@ gsi_command(struct gsi *gsi, u32 reg, u32 val, struct completion *completion)
 
 /* Return the hardware's notion of the current state of an event ring */
 static enum gsi_evt_ring_state
-gsi_evt_ring_state(struct gsi *gsi, u32 evt_ring_id)
+gsi_evt_ring_state(struct ipa_dma *gsi, u32 evt_ring_id)
 {
 	u32 val;
 
@@ -363,7 +364,7 @@ gsi_evt_ring_state(struct gsi *gsi, u32 evt_ring_id)
 }
 
 /* Issue an event ring command and wait for it to complete */
-static void gsi_evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
+static void gsi_evt_ring_command(struct ipa_dma *gsi, u32 evt_ring_id,
 				 enum gsi_evt_cmd_opcode opcode)
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
@@ -390,7 +391,7 @@ static void gsi_evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 }
 
 /* Allocate an event ring in NOT_ALLOCATED state */
-static int gsi_evt_ring_alloc_command(struct gsi *gsi, u32 evt_ring_id)
+static int gsi_evt_ring_alloc_command(struct ipa_dma *gsi, u32 evt_ring_id)
 {
 	enum gsi_evt_ring_state state;
 
@@ -416,7 +417,7 @@ static int gsi_evt_ring_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 }
 
 /* Reset a GSI event ring in ALLOCATED or ERROR state. */
-static void gsi_evt_ring_reset_command(struct gsi *gsi, u32 evt_ring_id)
+static void gsi_evt_ring_reset_command(struct ipa_dma *gsi, u32 evt_ring_id)
 {
 	enum gsi_evt_ring_state state;
 
@@ -440,7 +441,7 @@ static void gsi_evt_ring_reset_command(struct gsi *gsi, u32 evt_ring_id)
 }
 
 /* Issue a hardware de-allocation request for an allocated event ring */
-static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
+static void gsi_evt_ring_de_alloc_command(struct ipa_dma *gsi, u32 evt_ring_id)
 {
 	enum gsi_evt_ring_state state;
 
@@ -463,10 +464,10 @@ static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 }
 
 /* Fetch the current state of a channel from hardware */
-static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
+static enum gsi_channel_state gsi_channel_state(struct ipa_channel *channel)
 {
 	u32 channel_id = gsi_channel_id(channel);
-	void __iomem *virt = channel->gsi->virt;
+	void __iomem *virt = channel->dma_subsys->virt;
 	u32 val;
 
 	val = ioread32(virt + GSI_CH_C_CNTXT_0_OFFSET(channel_id));
@@ -476,11 +477,11 @@ static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
 
 /* Issue a channel command and wait for it to complete */
 static void
-gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
+gsi_channel_command(struct ipa_channel *channel, enum gsi_ch_cmd_opcode opcode)
 {
 	struct completion *completion = &channel->completion;
 	u32 channel_id = gsi_channel_id(channel);
-	struct gsi *gsi = channel->gsi;
+	struct ipa_dma *gsi = channel->dma_subsys;
 	struct device *dev = gsi->dev;
 	bool timeout;
 	u32 val;
@@ -502,9 +503,9 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 }
 
 /* Allocate GSI channel in NOT_ALLOCATED state */
-static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
+static int gsi_channel_alloc_command(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 	struct device *dev = gsi->dev;
 	enum gsi_channel_state state;
 
@@ -530,9 +531,9 @@ static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 }
 
 /* Start an ALLOCATED channel */
-static int gsi_channel_start_command(struct gsi_channel *channel)
+static int gsi_channel_start_command(struct ipa_channel *channel)
 {
-	struct device *dev = channel->gsi->dev;
+	struct device *dev = channel->dma_subsys->dev;
 	enum gsi_channel_state state;
 
 	state = gsi_channel_state(channel);
@@ -557,9 +558,9 @@ static int gsi_channel_start_command(struct gsi_channel *channel)
 }
 
 /* Stop a GSI channel in STARTED state */
-static int gsi_channel_stop_command(struct gsi_channel *channel)
+static int gsi_channel_stop_command(struct ipa_channel *channel)
 {
-	struct device *dev = channel->gsi->dev;
+	struct device *dev = channel->dma_subsys->dev;
 	enum gsi_channel_state state;
 
 	state = gsi_channel_state(channel);
@@ -595,9 +596,9 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 }
 
 /* Reset a GSI channel in ALLOCATED or ERROR state. */
-static void gsi_channel_reset_command(struct gsi_channel *channel)
+static void gsi_channel_reset_command(struct ipa_channel *channel)
 {
-	struct device *dev = channel->gsi->dev;
+	struct device *dev = channel->dma_subsys->dev;
 	enum gsi_channel_state state;
 
 	/* A short delay is required before a RESET command */
@@ -623,9 +624,9 @@ static void gsi_channel_reset_command(struct gsi_channel *channel)
 }
 
 /* Deallocate an ALLOCATED GSI channel */
-static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
+static void gsi_channel_de_alloc_command(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 	struct device *dev = gsi->dev;
 	enum gsi_channel_state state;
 
@@ -651,7 +652,7 @@ static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
  * we supply one less than that with the doorbell.  Update the event ring
  * index field with the value provided.
  */
-static void gsi_evt_ring_doorbell(struct gsi *gsi, u32 evt_ring_id, u32 index)
+static void gsi_evt_ring_doorbell(struct ipa_dma *gsi, u32 evt_ring_id, u32 index)
 {
 	struct gsi_ring *ring = &gsi->evt_ring[evt_ring_id].ring;
 	u32 val;
@@ -664,7 +665,7 @@ static void gsi_evt_ring_doorbell(struct gsi *gsi, u32 evt_ring_id, u32 index)
 }
 
 /* Program an event ring for use */
-static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
+static void gsi_evt_ring_program(struct ipa_dma *gsi, u32 evt_ring_id)
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 	size_t size = evt_ring->ring.count * GSI_RING_ELEMENT_SIZE;
@@ -707,11 +708,11 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 }
 
 /* Find the transaction whose completion indicates a channel is quiesced */
-static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
+static struct ipa_trans *gsi_channel_trans_last(struct ipa_channel *channel)
 {
-	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct ipa_trans_info *trans_info = &channel->trans_info;
 	const struct list_head *list;
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 
 	spin_lock_bh(&trans_info->spinlock);
 
@@ -737,7 +738,7 @@ static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
 	if (list_empty(list))
 		list = NULL;
 done:
-	trans = list ? list_last_entry(list, struct gsi_trans, links) : NULL;
+	trans = list ? list_last_entry(list, struct ipa_trans, links) : NULL;
 
 	/* Caller will wait for this, so take a reference */
 	if (trans)
@@ -749,26 +750,26 @@ static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
 }
 
 /* Wait for transaction activity on a channel to complete */
-static void gsi_channel_trans_quiesce(struct gsi_channel *channel)
+static void gsi_channel_trans_quiesce(struct ipa_channel *channel)
 {
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 
 	/* Get the last transaction, and wait for it to complete */
 	trans = gsi_channel_trans_last(channel);
 	if (trans) {
 		wait_for_completion(&trans->completion);
-		gsi_trans_free(trans);
+		ipa_trans_free(trans);
 	}
 }
 
 /* Program a channel for use; there is no gsi_channel_deprogram() */
-static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
+static void gsi_channel_program(struct ipa_channel *channel, bool doorbell)
 {
 	size_t size = channel->tre_ring.count * GSI_RING_ELEMENT_SIZE;
 	u32 channel_id = gsi_channel_id(channel);
 	union gsi_channel_scratch scr = { };
 	struct gsi_channel_scratch_gpi *gpi;
-	struct gsi *gsi = channel->gsi;
+	struct ipa_dma *gsi = channel->dma_subsys;
 	u32 wrr_weight = 0;
 	u32 val;
 
@@ -849,9 +850,9 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	/* All done! */
 }
 
-static int __gsi_channel_start(struct gsi_channel *channel, bool resume)
+static int __gsi_channel_start(struct ipa_channel *channel, bool resume)
 {
-	struct gsi *gsi = channel->gsi;
+	struct ipa_dma *gsi = channel->dma_subsys;
 	int ret;
 
 	/* Prior to IPA v4.0 suspend/resume is not implemented by GSI */
@@ -868,9 +869,9 @@ static int __gsi_channel_start(struct gsi_channel *channel, bool resume)
 }
 
 /* Start an allocated GSI channel */
-int gsi_channel_start(struct gsi *gsi, u32 channel_id)
+int gsi_channel_start(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 	int ret;
 
 	/* Enable NAPI and the completion interrupt */
@@ -886,7 +887,7 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 	return ret;
 }
 
-static int gsi_channel_stop_retry(struct gsi_channel *channel)
+static int gsi_channel_stop_retry(struct ipa_channel *channel)
 {
 	u32 retries = GSI_CHANNEL_STOP_RETRIES;
 	int ret;
@@ -901,9 +902,9 @@ static int gsi_channel_stop_retry(struct gsi_channel *channel)
 	return ret;
 }
 
-static int __gsi_channel_stop(struct gsi_channel *channel, bool suspend)
+static int __gsi_channel_stop(struct ipa_channel *channel, bool suspend)
 {
-	struct gsi *gsi = channel->gsi;
+	struct ipa_dma *gsi = channel->dma_subsys;
 	int ret;
 
 	/* Wait for any underway transactions to complete before stopping. */
@@ -923,9 +924,9 @@ static int __gsi_channel_stop(struct gsi_channel *channel, bool suspend)
 }
 
 /* Stop a started channel */
-int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
+int gsi_channel_stop(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 	int ret;
 
 	ret = __gsi_channel_stop(channel, false);
@@ -940,9 +941,9 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 }
 
 /* Reset and reconfigure a channel, (possibly) enabling the doorbell engine */
-void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
+void gsi_channel_reset(struct ipa_dma *gsi, u32 channel_id, bool doorbell)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 
 	mutex_lock(&gsi->mutex);
 
@@ -952,15 +953,15 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
 		gsi_channel_reset_command(channel);
 
 	gsi_channel_program(channel, doorbell);
-	gsi_channel_trans_cancel_pending(channel);
+	ipa_channel_trans_cancel_pending(channel);
 
 	mutex_unlock(&gsi->mutex);
 }
 
 /* Stop a started channel for suspend */
-int gsi_channel_suspend(struct gsi *gsi, u32 channel_id)
+int gsi_channel_suspend(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 	int ret;
 
 	ret = __gsi_channel_stop(channel, true);
@@ -974,27 +975,27 @@ int gsi_channel_suspend(struct gsi *gsi, u32 channel_id)
 }
 
 /* Resume a suspended channel (starting if stopped) */
-int gsi_channel_resume(struct gsi *gsi, u32 channel_id)
+int gsi_channel_resume(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 
 	return __gsi_channel_start(channel, true);
 }
 
 /* Prevent all GSI interrupts while suspended */
-void gsi_suspend(struct gsi *gsi)
+void gsi_suspend(struct ipa_dma *gsi)
 {
 	disable_irq(gsi->irq);
 }
 
 /* Allow all GSI interrupts again when resuming */
-void gsi_resume(struct gsi *gsi)
+void gsi_resume(struct ipa_dma *gsi)
 {
 	enable_irq(gsi->irq);
 }
 
 /**
- * gsi_channel_tx_queued() - Report queued TX transfers for a channel
+ * ipa_channel_tx_queued() - Report queued TX transfers for a channel
  * @channel:	Channel for which to report
  *
  * Report to the network stack the number of bytes and transactions that
@@ -1011,7 +1012,7 @@ void gsi_resume(struct gsi *gsi)
  * provide accurate information to the network stack about how much
  * work we've given the hardware at any point in time.
  */
-void gsi_channel_tx_queued(struct gsi_channel *channel)
+void ipa_channel_tx_queued(struct ipa_channel *channel)
 {
 	u32 trans_count;
 	u32 byte_count;
@@ -1021,7 +1022,7 @@ void gsi_channel_tx_queued(struct gsi_channel *channel)
 	channel->queued_byte_count = channel->byte_count;
 	channel->queued_trans_count = channel->trans_count;
 
-	ipa_gsi_channel_tx_queued(channel->gsi, gsi_channel_id(channel),
+	ipa_gsi_channel_tx_queued(channel->dma_subsys, gsi_channel_id(channel),
 				  trans_count, byte_count);
 }
 
@@ -1050,7 +1051,7 @@ void gsi_channel_tx_queued(struct gsi_channel *channel)
  * point in time.
  */
 static void
-gsi_channel_tx_update(struct gsi_channel *channel, struct gsi_trans *trans)
+gsi_channel_tx_update(struct ipa_channel *channel, struct ipa_trans *trans)
 {
 	u64 byte_count = trans->byte_count + trans->len;
 	u64 trans_count = trans->trans_count + 1;
@@ -1060,12 +1061,12 @@ gsi_channel_tx_update(struct gsi_channel *channel, struct gsi_trans *trans)
 	trans_count -= channel->compl_trans_count;
 	channel->compl_trans_count += trans_count;
 
-	ipa_gsi_channel_tx_completed(channel->gsi, gsi_channel_id(channel),
+	ipa_gsi_channel_tx_completed(channel->dma_subsys, gsi_channel_id(channel),
 				     trans_count, byte_count);
 }
 
 /* Channel control interrupt handler */
-static void gsi_isr_chan_ctrl(struct gsi *gsi)
+static void gsi_isr_chan_ctrl(struct ipa_dma *gsi)
 {
 	u32 channel_mask;
 
@@ -1074,7 +1075,7 @@ static void gsi_isr_chan_ctrl(struct gsi *gsi)
 
 	while (channel_mask) {
 		u32 channel_id = __ffs(channel_mask);
-		struct gsi_channel *channel;
+		struct ipa_channel *channel;
 
 		channel_mask ^= BIT(channel_id);
 
@@ -1085,7 +1086,7 @@ static void gsi_isr_chan_ctrl(struct gsi *gsi)
 }
 
 /* Event ring control interrupt handler */
-static void gsi_isr_evt_ctrl(struct gsi *gsi)
+static void gsi_isr_evt_ctrl(struct ipa_dma *gsi)
 {
 	u32 event_mask;
 
@@ -1106,7 +1107,7 @@ static void gsi_isr_evt_ctrl(struct gsi *gsi)
 
 /* Global channel error interrupt handler */
 static void
-gsi_isr_glob_chan_err(struct gsi *gsi, u32 err_ee, u32 channel_id, u32 code)
+gsi_isr_glob_chan_err(struct ipa_dma *gsi, u32 err_ee, u32 channel_id, u32 code)
 {
 	if (code == GSI_OUT_OF_RESOURCES) {
 		dev_err(gsi->dev, "channel %u out of resources\n", channel_id);
@@ -1121,7 +1122,7 @@ gsi_isr_glob_chan_err(struct gsi *gsi, u32 err_ee, u32 channel_id, u32 code)
 
 /* Global event error interrupt handler */
 static void
-gsi_isr_glob_evt_err(struct gsi *gsi, u32 err_ee, u32 evt_ring_id, u32 code)
+gsi_isr_glob_evt_err(struct ipa_dma *gsi, u32 err_ee, u32 evt_ring_id, u32 code)
 {
 	if (code == GSI_OUT_OF_RESOURCES) {
 		struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
@@ -1139,7 +1140,7 @@ gsi_isr_glob_evt_err(struct gsi *gsi, u32 err_ee, u32 evt_ring_id, u32 code)
 }
 
 /* Global error interrupt handler */
-static void gsi_isr_glob_err(struct gsi *gsi)
+static void gsi_isr_glob_err(struct ipa_dma *gsi)
 {
 	enum gsi_err_type type;
 	enum gsi_err_code code;
@@ -1166,7 +1167,7 @@ static void gsi_isr_glob_err(struct gsi *gsi)
 }
 
 /* Generic EE interrupt handler */
-static void gsi_isr_gp_int1(struct gsi *gsi)
+static void gsi_isr_gp_int1(struct ipa_dma *gsi)
 {
 	u32 result;
 	u32 val;
@@ -1208,7 +1209,7 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 }
 
 /* Inter-EE interrupt handler */
-static void gsi_isr_glob_ee(struct gsi *gsi)
+static void gsi_isr_glob_ee(struct ipa_dma *gsi)
 {
 	u32 val;
 
@@ -1231,7 +1232,7 @@ static void gsi_isr_glob_ee(struct gsi *gsi)
 }
 
 /* I/O completion interrupt event */
-static void gsi_isr_ieob(struct gsi *gsi)
+static void gsi_isr_ieob(struct ipa_dma *gsi)
 {
 	u32 event_mask;
 
@@ -1249,7 +1250,7 @@ static void gsi_isr_ieob(struct gsi *gsi)
 }
 
 /* General event interrupts represent serious problems, so report them */
-static void gsi_isr_general(struct gsi *gsi)
+static void gsi_isr_general(struct ipa_dma *gsi)
 {
 	struct device *dev = gsi->dev;
 	u32 val;
@@ -1270,7 +1271,7 @@ static void gsi_isr_general(struct gsi *gsi)
  */
 static irqreturn_t gsi_isr(int irq, void *dev_id)
 {
-	struct gsi *gsi = dev_id;
+	struct ipa_dma *gsi = dev_id;
 	u32 intr_mask;
 	u32 cnt = 0;
 
@@ -1316,7 +1317,7 @@ static irqreturn_t gsi_isr(int irq, void *dev_id)
 }
 
 /* Init function for GSI IRQ lookup; there is no gsi_irq_exit() */
-static int gsi_irq_init(struct gsi *gsi, struct platform_device *pdev)
+static int gsi_irq_init(struct ipa_dma *gsi, struct platform_device *pdev)
 {
 	int ret;
 
@@ -1330,7 +1331,7 @@ static int gsi_irq_init(struct gsi *gsi, struct platform_device *pdev)
 }
 
 /* Return the transaction associated with a transfer completion event */
-static struct gsi_trans *gsi_event_trans(struct gsi_channel *channel,
+static struct ipa_trans *gsi_event_trans(struct ipa_channel *channel,
 					 struct gsi_event *event)
 {
 	u32 tre_offset;
@@ -1364,12 +1365,12 @@ static struct gsi_trans *gsi_event_trans(struct gsi_channel *channel,
  */
 static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 {
-	struct gsi_channel *channel = evt_ring->channel;
+	struct ipa_channel *channel = evt_ring->channel;
 	struct gsi_ring *ring = &evt_ring->ring;
-	struct gsi_trans_info *trans_info;
+	struct ipa_trans_info *trans_info;
 	struct gsi_event *event_done;
 	struct gsi_event *event;
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 	u32 byte_count = 0;
 	u32 old_index;
 	u32 event_avail;
@@ -1399,7 +1400,7 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 			event++;
 		else
 			event = gsi_ring_virt(ring, 0);
-		trans = gsi_trans_pool_next(&trans_info->pool, trans);
+		trans = ipa_trans_pool_next(&trans_info->pool, trans);
 	} while (event != event_done);
 
 	/* We record RX bytes when they are received */
@@ -1408,7 +1409,7 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 }
 
 /* Initialize a ring, including allocating DMA memory for its entries */
-static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
+static int gsi_ring_alloc(struct ipa_dma *gsi, struct gsi_ring *ring, u32 count)
 {
 	u32 size = count * GSI_RING_ELEMENT_SIZE;
 	struct device *dev = gsi->dev;
@@ -1429,7 +1430,7 @@ static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
 }
 
 /* Free a previously-allocated ring */
-static void gsi_ring_free(struct gsi *gsi, struct gsi_ring *ring)
+static void gsi_ring_free(struct ipa_dma *gsi, struct gsi_ring *ring)
 {
 	size_t size = ring->count * GSI_RING_ELEMENT_SIZE;
 
@@ -1437,7 +1438,7 @@ static void gsi_ring_free(struct gsi *gsi, struct gsi_ring *ring)
 }
 
 /* Allocate an available event ring id */
-static int gsi_evt_ring_id_alloc(struct gsi *gsi)
+static int gsi_evt_ring_id_alloc(struct ipa_dma *gsi)
 {
 	u32 evt_ring_id;
 
@@ -1453,17 +1454,17 @@ static int gsi_evt_ring_id_alloc(struct gsi *gsi)
 }
 
 /* Free a previously-allocated event ring id */
-static void gsi_evt_ring_id_free(struct gsi *gsi, u32 evt_ring_id)
+static void gsi_evt_ring_id_free(struct ipa_dma *gsi, u32 evt_ring_id)
 {
 	gsi->event_bitmap &= ~BIT(evt_ring_id);
 }
 
 /* Ring a channel doorbell, reporting the first un-filled entry */
-void gsi_channel_doorbell(struct gsi_channel *channel)
+void gsi_channel_doorbell(struct ipa_channel *channel)
 {
 	struct gsi_ring *tre_ring = &channel->tre_ring;
 	u32 channel_id = gsi_channel_id(channel);
-	struct gsi *gsi = channel->gsi;
+	struct ipa_dma *gsi = channel->dma_subsys;
 	u32 val;
 
 	/* Note: index *must* be used modulo the ring count here */
@@ -1472,12 +1473,12 @@ void gsi_channel_doorbell(struct gsi_channel *channel)
 }
 
 /* Consult hardware, move any newly completed transactions to completed list */
-static struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
+static struct ipa_trans *gsi_channel_update(struct ipa_channel *channel)
 {
 	u32 evt_ring_id = channel->evt_ring_id;
-	struct gsi *gsi = channel->gsi;
+	struct ipa_dma *gsi = channel->dma_subsys;
 	struct gsi_evt_ring *evt_ring;
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 	struct gsi_ring *ring;
 	u32 offset;
 	u32 index;
@@ -1510,14 +1511,14 @@ static struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
 	else
 		gsi_evt_ring_rx_update(evt_ring, index);
 
-	gsi_trans_move_complete(trans);
+	ipa_trans_move_complete(trans);
 
 	/* Tell the hardware we've handled these events */
-	gsi_evt_ring_doorbell(channel->gsi, channel->evt_ring_id, index);
+	gsi_evt_ring_doorbell(channel->dma_subsys, channel->evt_ring_id, index);
 
-	gsi_trans_free(trans);
+	ipa_trans_free(trans);
 
-	return gsi_channel_trans_complete(channel);
+	return ipa_channel_trans_complete(channel);
 }
 
 /**
@@ -1532,17 +1533,17 @@ static struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
  * completed list and the new first entry is returned.  If there are no more
  * completed transactions, a null pointer is returned.
  */
-static struct gsi_trans *gsi_channel_poll_one(struct gsi_channel *channel)
+static struct ipa_trans *gsi_channel_poll_one(struct ipa_channel *channel)
 {
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 
 	/* Get the first transaction from the completed list */
-	trans = gsi_channel_trans_complete(channel);
+	trans = ipa_channel_trans_complete(channel);
 	if (!trans)	/* List is empty; see if there's more to do */
 		trans = gsi_channel_update(channel);
 
 	if (trans)
-		gsi_trans_move_polled(trans);
+		ipa_trans_move_polled(trans);
 
 	return trans;
 }
@@ -1556,26 +1557,26 @@ static struct gsi_trans *gsi_channel_poll_one(struct gsi_channel *channel)
  *
  * Single transactions completed by hardware are polled until either
  * the budget is exhausted, or there are no more.  Each transaction
- * polled is passed to gsi_trans_complete(), to perform remaining
+ * polled is passed to ipa_trans_complete(), to perform remaining
  * completion processing and retire/free the transaction.
  */
 static int gsi_channel_poll(struct napi_struct *napi, int budget)
 {
-	struct gsi_channel *channel;
+	struct ipa_channel *channel;
 	int count;
 
-	channel = container_of(napi, struct gsi_channel, napi);
+	channel = container_of(napi, struct ipa_channel, napi);
 	for (count = 0; count < budget; count++) {
-		struct gsi_trans *trans;
+		struct ipa_trans *trans;
 
 		trans = gsi_channel_poll_one(channel);
 		if (!trans)
 			break;
-		gsi_trans_complete(trans);
+		ipa_trans_complete(trans);
 	}
 
 	if (count < budget && napi_complete(napi))
-		gsi_irq_ieob_enable_one(channel->gsi, channel->evt_ring_id);
+		gsi_irq_ieob_enable_one(channel->dma_subsys, channel->evt_ring_id);
 
 	return count;
 }
@@ -1595,9 +1596,9 @@ static u32 gsi_event_bitmap_init(u32 evt_ring_max)
 }
 
 /* Setup function for a single channel */
-static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id)
+static int gsi_channel_setup_one(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 	u32 evt_ring_id = channel->evt_ring_id;
 	int ret;
 
@@ -1633,9 +1634,9 @@ static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id)
 }
 
 /* Inverse of gsi_channel_setup_one() */
-static void gsi_channel_teardown_one(struct gsi *gsi, u32 channel_id)
+static void gsi_channel_teardown_one(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 	u32 evt_ring_id = channel->evt_ring_id;
 
 	if (!gsi_channel_initialized(channel))
@@ -1648,7 +1649,7 @@ static void gsi_channel_teardown_one(struct gsi *gsi, u32 channel_id)
 	gsi_evt_ring_de_alloc_command(gsi, evt_ring_id);
 }
 
-static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
+static int gsi_generic_command(struct ipa_dma *gsi, u32 channel_id,
 			       enum gsi_generic_cmd_opcode opcode)
 {
 	struct completion *completion = &gsi->completion;
@@ -1689,13 +1690,13 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	return -ETIMEDOUT;
 }
 
-static int gsi_modem_channel_alloc(struct gsi *gsi, u32 channel_id)
+static int gsi_modem_channel_alloc(struct ipa_dma *gsi, u32 channel_id)
 {
 	return gsi_generic_command(gsi, channel_id,
 				   GSI_GENERIC_ALLOCATE_CHANNEL);
 }
 
-static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
+static void gsi_modem_channel_halt(struct ipa_dma *gsi, u32 channel_id)
 {
 	u32 retries = GSI_CHANNEL_MODEM_HALT_RETRIES;
 	int ret;
@@ -1711,7 +1712,7 @@ static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
 }
 
 /* Setup function for channels */
-static int gsi_channel_setup(struct gsi *gsi)
+static int gsi_channel_setup(struct ipa_dma *gsi)
 {
 	u32 channel_id = 0;
 	u32 mask;
@@ -1729,7 +1730,7 @@ static int gsi_channel_setup(struct gsi *gsi)
 
 	/* Make sure no channels were defined that hardware does not support */
 	while (channel_id < GSI_CHANNEL_COUNT_MAX) {
-		struct gsi_channel *channel = &gsi->channel[channel_id++];
+		struct ipa_channel *channel = &gsi->channel[channel_id++];
 
 		if (!gsi_channel_initialized(channel))
 			continue;
@@ -1781,7 +1782,7 @@ static int gsi_channel_setup(struct gsi *gsi)
 }
 
 /* Inverse of gsi_channel_setup() */
-static void gsi_channel_teardown(struct gsi *gsi)
+static void gsi_channel_teardown(struct ipa_dma *gsi)
 {
 	u32 mask = gsi->modem_channel_bitmap;
 	u32 channel_id;
@@ -1807,7 +1808,7 @@ static void gsi_channel_teardown(struct gsi *gsi)
 }
 
 /* Turn off all GSI interrupts initially */
-static int gsi_irq_setup(struct gsi *gsi)
+static int gsi_irq_setup(struct ipa_dma *gsi)
 {
 	int ret;
 
@@ -1843,13 +1844,13 @@ static int gsi_irq_setup(struct gsi *gsi)
 	return ret;
 }
 
-static void gsi_irq_teardown(struct gsi *gsi)
+static void gsi_irq_teardown(struct ipa_dma *gsi)
 {
 	free_irq(gsi->irq, gsi);
 }
 
 /* Get # supported channel and event rings; there is no gsi_ring_teardown() */
-static int gsi_ring_setup(struct gsi *gsi)
+static int gsi_ring_setup(struct ipa_dma *gsi)
 {
 	struct device *dev = gsi->dev;
 	u32 count;
@@ -1894,7 +1895,7 @@ static int gsi_ring_setup(struct gsi *gsi)
 }
 
 /* Setup function for GSI.  GSI firmware must be loaded and initialized */
-int gsi_setup(struct gsi *gsi)
+int gsi_setup(struct ipa_dma *gsi)
 {
 	u32 val;
 	int ret;
@@ -1930,16 +1931,16 @@ int gsi_setup(struct gsi *gsi)
 }
 
 /* Inverse of gsi_setup() */
-void gsi_teardown(struct gsi *gsi)
+void gsi_teardown(struct ipa_dma *gsi)
 {
 	gsi_channel_teardown(gsi);
 	gsi_irq_teardown(gsi);
 }
 
 /* Initialize a channel's event ring */
-static int gsi_channel_evt_ring_init(struct gsi_channel *channel)
+static int gsi_channel_evt_ring_init(struct ipa_channel *channel)
 {
-	struct gsi *gsi = channel->gsi;
+	struct ipa_dma *gsi = channel->dma_subsys;
 	struct gsi_evt_ring *evt_ring;
 	int ret;
 
@@ -1964,10 +1965,10 @@ static int gsi_channel_evt_ring_init(struct gsi_channel *channel)
 }
 
 /* Inverse of gsi_channel_evt_ring_init() */
-static void gsi_channel_evt_ring_exit(struct gsi_channel *channel)
+static void gsi_channel_evt_ring_exit(struct ipa_channel *channel)
 {
 	u32 evt_ring_id = channel->evt_ring_id;
-	struct gsi *gsi = channel->gsi;
+	struct ipa_dma *gsi = channel->dma_subsys;
 	struct gsi_evt_ring *evt_ring;
 
 	evt_ring = &gsi->evt_ring[evt_ring_id];
@@ -1976,7 +1977,7 @@ static void gsi_channel_evt_ring_exit(struct gsi_channel *channel)
 }
 
 /* Init function for event rings; there is no gsi_evt_ring_exit() */
-static void gsi_evt_ring_init(struct gsi *gsi)
+static void gsi_evt_ring_init(struct ipa_dma *gsi)
 {
 	u32 evt_ring_id = 0;
 
@@ -1987,7 +1988,7 @@ static void gsi_evt_ring_init(struct gsi *gsi)
 	while (++evt_ring_id < GSI_EVT_RING_COUNT_MAX);
 }
 
-static bool gsi_channel_data_valid(struct gsi *gsi,
+static bool gsi_channel_data_valid(struct ipa_dma *gsi,
 				   const struct ipa_gsi_endpoint_data *data)
 {
 	u32 channel_id = data->channel_id;
@@ -2040,11 +2041,11 @@ static bool gsi_channel_data_valid(struct gsi *gsi,
 }
 
 /* Init function for a single channel */
-static int gsi_channel_init_one(struct gsi *gsi,
+static int gsi_channel_init_one(struct ipa_dma *gsi,
 				const struct ipa_gsi_endpoint_data *data,
 				bool command)
 {
-	struct gsi_channel *channel;
+	struct ipa_channel *channel;
 	u32 tre_count;
 	int ret;
 
@@ -2063,7 +2064,7 @@ static int gsi_channel_init_one(struct gsi *gsi,
 	channel = &gsi->channel[data->channel_id];
 	memset(channel, 0, sizeof(*channel));
 
-	channel->gsi = gsi;
+	channel->dma_subsys = gsi;
 	channel->toward_ipa = data->toward_ipa;
 	channel->command = command;
 	channel->tlv_count = data->channel.tlv_count;
@@ -2082,7 +2083,7 @@ static int gsi_channel_init_one(struct gsi *gsi,
 		goto err_channel_evt_ring_exit;
 	}
 
-	ret = gsi_channel_trans_init(gsi, data->channel_id);
+	ret = ipa_channel_trans_init(gsi, data->channel_id);
 	if (ret)
 		goto err_ring_free;
 
@@ -2094,32 +2095,32 @@ static int gsi_channel_init_one(struct gsi *gsi,
 	if (!ret)
 		return 0;	/* Success! */
 
-	gsi_channel_trans_exit(channel);
+	ipa_channel_trans_exit(channel);
 err_ring_free:
 	gsi_ring_free(gsi, &channel->tre_ring);
 err_channel_evt_ring_exit:
 	gsi_channel_evt_ring_exit(channel);
 err_clear_gsi:
-	channel->gsi = NULL;	/* Mark it not (fully) initialized */
+	channel->dma_subsys = NULL;	/* Mark it not (fully) initialized */
 
 	return ret;
 }
 
 /* Inverse of gsi_channel_init_one() */
-static void gsi_channel_exit_one(struct gsi_channel *channel)
+static void gsi_channel_exit_one(struct ipa_channel *channel)
 {
 	if (!gsi_channel_initialized(channel))
 		return;
 
 	if (channel->command)
 		ipa_cmd_pool_exit(channel);
-	gsi_channel_trans_exit(channel);
-	gsi_ring_free(channel->gsi, &channel->tre_ring);
+	ipa_channel_trans_exit(channel);
+	gsi_ring_free(channel->dma_subsys, &channel->tre_ring);
 	gsi_channel_evt_ring_exit(channel);
 }
 
 /* Init function for channels */
-static int gsi_channel_init(struct gsi *gsi, u32 count,
+static int gsi_channel_init(struct ipa_dma *gsi, u32 count,
 			    const struct ipa_gsi_endpoint_data *data)
 {
 	bool modem_alloc;
@@ -2168,7 +2169,7 @@ static int gsi_channel_init(struct gsi *gsi, u32 count,
 }
 
 /* Inverse of gsi_channel_init() */
-static void gsi_channel_exit(struct gsi *gsi)
+static void gsi_channel_exit(struct ipa_dma *gsi)
 {
 	u32 channel_id = GSI_CHANNEL_COUNT_MAX - 1;
 
@@ -2179,7 +2180,7 @@ static void gsi_channel_exit(struct gsi *gsi)
 }
 
 /* Init function for GSI.  GSI hardware does not need to be "ready" */
-int gsi_init(struct gsi *gsi, struct platform_device *pdev,
+int gsi_init(struct ipa_dma *gsi, struct platform_device *pdev,
 	     enum ipa_version version, u32 count,
 	     const struct ipa_gsi_endpoint_data *data)
 {
@@ -2249,7 +2250,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 }
 
 /* Inverse of gsi_init() */
-void gsi_exit(struct gsi *gsi)
+void gsi_exit(struct ipa_dma *gsi)
 {
 	mutex_destroy(&gsi->mutex);
 	gsi_channel_exit(gsi);
@@ -2274,20 +2275,20 @@ void gsi_exit(struct gsi *gsi)
  * maximum number of outstanding TREs allows the number of entries in
  * a pool to avoid crossing that power-of-2 boundary, and this can
  * substantially reduce pool memory requirements.  The number we
- * reduce it by matches the number added in gsi_trans_pool_init().
+ * reduce it by matches the number added in ipa_trans_pool_init().
  */
-u32 gsi_channel_tre_max(struct gsi *gsi, u32 channel_id)
+u32 gsi_channel_tre_max(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 
 	/* Hardware limit is channel->tre_count - 1 */
 	return channel->tre_count - (channel->tlv_count - 1);
 }
 
 /* Returns the maximum number of TREs in a single transaction for a channel */
-u32 gsi_channel_trans_tre_max(struct gsi *gsi, u32 channel_id)
+u32 gsi_channel_trans_tre_max(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 
 	return channel->tlv_count;
 }
diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 9fc880eb7e3a..80a83ac45729 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -12,7 +12,7 @@
 #include <linux/pm_wakeup.h>
 
 #include "ipa_version.h"
-#include "gsi.h"
+#include "ipa_dma.h"
 #include "ipa_mem.h"
 #include "ipa_qmi.h"
 #include "ipa_endpoint.h"
@@ -29,7 +29,7 @@ struct ipa_interrupt;
 
 /**
  * struct ipa - IPA information
- * @gsi:		Embedded GSI structure
+ * @ipa_dma:		Embedded IPA DMA structure
  * @version:		IPA hardware version
  * @pdev:		Platform device
  * @completion:		Used to signal pipeline clear transfer complete
@@ -71,7 +71,7 @@ struct ipa_interrupt;
  * @qmi:		QMI information
  */
 struct ipa {
-	struct gsi gsi;
+	struct ipa_dma dma_subsys;
 	enum ipa_version version;
 	struct platform_device *pdev;
 	struct completion completion;
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index cff51731195a..3db9e94e484f 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -10,8 +10,8 @@
 #include <linux/bitfield.h>
 #include <linux/dma-direction.h>
 
-#include "gsi.h"
-#include "gsi_trans.h"
+#include "ipa_dma.h"
+#include "ipa_trans.h"
 #include "ipa.h"
 #include "ipa_endpoint.h"
 #include "ipa_table.h"
@@ -32,8 +32,8 @@
  * immediate command's opcode.  The payload for a command resides in DRAM
  * and is described by a single scatterlist entry in its transaction.
  * Commands do not require a transaction completion callback.  To commit
- * an immediate command transaction, either gsi_trans_commit_wait() or
- * gsi_trans_commit_wait_timeout() is used.
+ * an immediate command transaction, either ipa_trans_commit_wait() or
+ * ipa_trans_commit_wait_timeout() is used.
  */
 
 /* Some commands can wait until indicated pipeline stages are clear */
@@ -346,10 +346,10 @@ bool ipa_cmd_data_valid(struct ipa *ipa)
 }
 
 
-int ipa_cmd_pool_init(struct gsi_channel *channel, u32 tre_max)
+int ipa_cmd_pool_init(struct ipa_channel *channel, u32 tre_max)
 {
-	struct gsi_trans_info *trans_info = &channel->trans_info;
-	struct device *dev = channel->gsi->dev;
+	struct ipa_trans_info *trans_info = &channel->trans_info;
+	struct device *dev = channel->dma_subsys->dev;
 	int ret;
 
 	/* This is as good a place as any to validate build constants */
@@ -359,50 +359,50 @@ int ipa_cmd_pool_init(struct gsi_channel *channel, u32 tre_max)
 	 * a single transaction can require up to tlv_count of them,
 	 * so we treat them as if that many can be allocated at once.
 	 */
-	ret = gsi_trans_pool_init_dma(dev, &trans_info->cmd_pool,
+	ret = ipa_trans_pool_init_dma(dev, &trans_info->cmd_pool,
 				      sizeof(union ipa_cmd_payload),
 				      tre_max, channel->tlv_count);
 	if (ret)
 		return ret;
 
 	/* Each TRE needs a command info structure */
-	ret = gsi_trans_pool_init(&trans_info->info_pool,
+	ret = ipa_trans_pool_init(&trans_info->info_pool,
 				   sizeof(struct ipa_cmd_info),
 				   tre_max, channel->tlv_count);
 	if (ret)
-		gsi_trans_pool_exit_dma(dev, &trans_info->cmd_pool);
+		ipa_trans_pool_exit_dma(dev, &trans_info->cmd_pool);
 
 	return ret;
 }
 
-void ipa_cmd_pool_exit(struct gsi_channel *channel)
+void ipa_cmd_pool_exit(struct ipa_channel *channel)
 {
-	struct gsi_trans_info *trans_info = &channel->trans_info;
-	struct device *dev = channel->gsi->dev;
+	struct ipa_trans_info *trans_info = &channel->trans_info;
+	struct device *dev = channel->dma_subsys->dev;
 
-	gsi_trans_pool_exit(&trans_info->info_pool);
-	gsi_trans_pool_exit_dma(dev, &trans_info->cmd_pool);
+	ipa_trans_pool_exit(&trans_info->info_pool);
+	ipa_trans_pool_exit_dma(dev, &trans_info->cmd_pool);
 }
 
 static union ipa_cmd_payload *
 ipa_cmd_payload_alloc(struct ipa *ipa, dma_addr_t *addr)
 {
-	struct gsi_trans_info *trans_info;
+	struct ipa_trans_info *trans_info;
 	struct ipa_endpoint *endpoint;
 
 	endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
-	trans_info = &ipa->gsi.channel[endpoint->channel_id].trans_info;
+	trans_info = &ipa->dma_subsys.channel[endpoint->channel_id].trans_info;
 
-	return gsi_trans_pool_alloc_dma(&trans_info->cmd_pool, addr);
+	return ipa_trans_pool_alloc_dma(&trans_info->cmd_pool, addr);
 }
 
 /* If hash_size is 0, hash_offset and hash_addr ignored. */
-void ipa_cmd_table_init_add(struct gsi_trans *trans,
+void ipa_cmd_table_init_add(struct ipa_trans *trans,
 			    enum ipa_cmd_opcode opcode, u16 size, u32 offset,
 			    dma_addr_t addr, u16 hash_size, u32 hash_offset,
 			    dma_addr_t hash_addr)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	enum dma_data_direction direction = DMA_TO_DEVICE;
 	struct ipa_cmd_hw_ip_fltrt_init *payload;
 	union ipa_cmd_payload *cmd_payload;
@@ -433,15 +433,15 @@ void ipa_cmd_table_init_add(struct gsi_trans *trans,
 	payload->flags = cpu_to_le64(val);
 	payload->nhash_rules_addr = cpu_to_le64(addr);
 
-	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
 			  direction, opcode);
 }
 
 /* Initialize header space in IPA-local memory */
-void ipa_cmd_hdr_init_local_add(struct gsi_trans *trans, u32 offset, u16 size,
+void ipa_cmd_hdr_init_local_add(struct ipa_trans *trans, u32 offset, u16 size,
 				dma_addr_t addr)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	enum ipa_cmd_opcode opcode = IPA_CMD_HDR_INIT_LOCAL;
 	enum dma_data_direction direction = DMA_TO_DEVICE;
 	struct ipa_cmd_hw_hdr_init_local *payload;
@@ -464,14 +464,14 @@ void ipa_cmd_hdr_init_local_add(struct gsi_trans *trans, u32 offset, u16 size,
 	flags |= u32_encode_bits(offset, HDR_INIT_LOCAL_FLAGS_HDR_ADDR_FMASK);
 	payload->flags = cpu_to_le32(flags);
 
-	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
 			  direction, opcode);
 }
 
-void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
+void ipa_cmd_register_write_add(struct ipa_trans *trans, u32 offset, u32 value,
 				u32 mask, bool clear_full)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	struct ipa_cmd_register_write *payload;
 	union ipa_cmd_payload *cmd_payload;
 	u32 opcode = IPA_CMD_REGISTER_WRITE;
@@ -521,14 +521,14 @@ void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
 	payload->value_mask = cpu_to_le32(mask);
 	payload->clear_options = cpu_to_le32(options);
 
-	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
 			  DMA_NONE, opcode);
 }
 
 /* Skip IP packet processing on the next data transfer on a TX channel */
-static void ipa_cmd_ip_packet_init_add(struct gsi_trans *trans, u8 endpoint_id)
+static void ipa_cmd_ip_packet_init_add(struct ipa_trans *trans, u8 endpoint_id)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	enum ipa_cmd_opcode opcode = IPA_CMD_IP_PACKET_INIT;
 	enum dma_data_direction direction = DMA_TO_DEVICE;
 	struct ipa_cmd_ip_packet_init *payload;
@@ -541,15 +541,15 @@ static void ipa_cmd_ip_packet_init_add(struct gsi_trans *trans, u8 endpoint_id)
 	payload->dest_endpoint = u8_encode_bits(endpoint_id,
 					IPA_PACKET_INIT_DEST_ENDPOINT_FMASK);
 
-	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
 			  direction, opcode);
 }
 
 /* Use a DMA command to read or write a block of IPA-resident memory */
-void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset, u16 size,
+void ipa_cmd_dma_shared_mem_add(struct ipa_trans *trans, u32 offset, u16 size,
 				dma_addr_t addr, bool toward_ipa)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	enum ipa_cmd_opcode opcode = IPA_CMD_DMA_SHARED_MEM;
 	struct ipa_cmd_hw_dma_mem_mem *payload;
 	union ipa_cmd_payload *cmd_payload;
@@ -586,13 +586,13 @@ void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset, u16 size,
 
 	direction = toward_ipa ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 
-	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
 			  direction, opcode);
 }
 
-static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans)
+static void ipa_cmd_ip_tag_status_add(struct ipa_trans *trans)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	enum ipa_cmd_opcode opcode = IPA_CMD_IP_PACKET_TAG_STATUS;
 	enum dma_data_direction direction = DMA_TO_DEVICE;
 	struct ipa_cmd_ip_packet_tag_status *payload;
@@ -604,14 +604,14 @@ static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans)
 
 	payload->tag = le64_encode_bits(0, IP_PACKET_TAG_STATUS_TAG_FMASK);
 
-	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
 			  direction, opcode);
 }
 
 /* Issue a small command TX data transfer */
-static void ipa_cmd_transfer_add(struct gsi_trans *trans)
+static void ipa_cmd_transfer_add(struct ipa_trans *trans)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	enum dma_data_direction direction = DMA_TO_DEVICE;
 	enum ipa_cmd_opcode opcode = IPA_CMD_NONE;
 	union ipa_cmd_payload *payload;
@@ -620,14 +620,14 @@ static void ipa_cmd_transfer_add(struct gsi_trans *trans)
 	/* Just transfer a zero-filled payload structure */
 	payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
 
-	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
 			  direction, opcode);
 }
 
 /* Add immediate commands to a transaction to clear the hardware pipeline */
-void ipa_cmd_pipeline_clear_add(struct gsi_trans *trans)
+void ipa_cmd_pipeline_clear_add(struct ipa_trans *trans)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	struct ipa_endpoint *endpoint;
 
 	/* This will complete when the transfer is received */
@@ -664,12 +664,12 @@ void ipa_cmd_pipeline_clear_wait(struct ipa *ipa)
 void ipa_cmd_pipeline_clear(struct ipa *ipa)
 {
 	u32 count = ipa_cmd_pipeline_clear_count();
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 
 	trans = ipa_cmd_trans_alloc(ipa, count);
 	if (trans) {
 		ipa_cmd_pipeline_clear_add(trans);
-		gsi_trans_commit_wait(trans);
+		ipa_trans_commit_wait(trans);
 		ipa_cmd_pipeline_clear_wait(ipa);
 	} else {
 		dev_err(&ipa->pdev->dev,
@@ -680,22 +680,22 @@ void ipa_cmd_pipeline_clear(struct ipa *ipa)
 static struct ipa_cmd_info *
 ipa_cmd_info_alloc(struct ipa_endpoint *endpoint, u32 tre_count)
 {
-	struct gsi_channel *channel;
+	struct ipa_channel *channel;
 
-	channel = &endpoint->ipa->gsi.channel[endpoint->channel_id];
+	channel = &endpoint->ipa->dma_subsys.channel[endpoint->channel_id];
 
-	return gsi_trans_pool_alloc(&channel->trans_info.info_pool, tre_count);
+	return ipa_trans_pool_alloc(&channel->trans_info.info_pool, tre_count);
 }
 
 /* Allocate a transaction for the command TX endpoint */
-struct gsi_trans *ipa_cmd_trans_alloc(struct ipa *ipa, u32 tre_count)
+struct ipa_trans *ipa_cmd_trans_alloc(struct ipa *ipa, u32 tre_count)
 {
 	struct ipa_endpoint *endpoint;
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 
 	endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
 
-	trans = gsi_channel_trans_alloc(&ipa->gsi, endpoint->channel_id,
+	trans = ipa_channel_trans_alloc(&ipa->dma_subsys, endpoint->channel_id,
 					tre_count, DMA_NONE);
 	if (trans)
 		trans->info = ipa_cmd_info_alloc(endpoint, tre_count);
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 69cd085d427d..bf3b72d11e9d 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -14,8 +14,8 @@ struct scatterlist;
 
 struct ipa;
 struct ipa_mem;
-struct gsi_trans;
-struct gsi_channel;
+struct ipa_trans;
+struct ipa_channel;
 
 /**
  * enum ipa_cmd_opcode:	IPA immediate commands
@@ -83,13 +83,13 @@ bool ipa_cmd_data_valid(struct ipa *ipa);
  *
  * Return:	0 if successful, or a negative error code
  */
-int ipa_cmd_pool_init(struct gsi_channel *channel, u32 tre_count);
+int ipa_cmd_pool_init(struct ipa_channel *channel, u32 tre_count);
 
 /**
  * ipa_cmd_pool_exit() - Inverse of ipa_cmd_pool_init()
  * @channel:	AP->IPA command TX GSI channel pointer
  */
-void ipa_cmd_pool_exit(struct gsi_channel *channel);
+void ipa_cmd_pool_exit(struct ipa_channel *channel);
 
 /**
  * ipa_cmd_table_init_add() - Add table init command to a transaction
@@ -104,7 +104,7 @@ void ipa_cmd_pool_exit(struct gsi_channel *channel);
  *
  * If hash_size is 0, hash_offset and hash_addr are ignored.
  */
-void ipa_cmd_table_init_add(struct gsi_trans *trans, enum ipa_cmd_opcode opcode,
+void ipa_cmd_table_init_add(struct ipa_trans *trans, enum ipa_cmd_opcode opcode,
 			    u16 size, u32 offset, dma_addr_t addr,
 			    u16 hash_size, u32 hash_offset,
 			    dma_addr_t hash_addr);
@@ -118,7 +118,7 @@ void ipa_cmd_table_init_add(struct gsi_trans *trans, enum ipa_cmd_opcode opcode,
  *
  * Defines and fills the location in IPA memory to use for headers.
  */
-void ipa_cmd_hdr_init_local_add(struct gsi_trans *trans, u32 offset, u16 size,
+void ipa_cmd_hdr_init_local_add(struct ipa_trans *trans, u32 offset, u16 size,
 				dma_addr_t addr);
 
 /**
@@ -129,7 +129,7 @@ void ipa_cmd_hdr_init_local_add(struct gsi_trans *trans, u32 offset, u16 size,
  * @mask:	Mask of bits in register to update with bits from value
  * @clear_full: Pipeline clear option; true means full pipeline clear
  */
-void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
+void ipa_cmd_register_write_add(struct ipa_trans *trans, u32 offset, u32 value,
 				u32 mask, bool clear_full);
 
 /**
@@ -140,14 +140,14 @@ void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
  * @addr:	DMA address of buffer to be read into or written from
  * @toward_ipa:	true means write to IPA memory; false means read
  */
-void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset,
+void ipa_cmd_dma_shared_mem_add(struct ipa_trans *trans, u32 offset,
 				u16 size, dma_addr_t addr, bool toward_ipa);
 
 /**
  * ipa_cmd_pipeline_clear_add() - Add pipeline clear commands to a transaction
  * @trans:	GSI transaction
  */
-void ipa_cmd_pipeline_clear_add(struct gsi_trans *trans);
+void ipa_cmd_pipeline_clear_add(struct ipa_trans *trans);
 
 /**
  * ipa_cmd_pipeline_clear_count() - # commands required to clear pipeline
@@ -177,6 +177,6 @@ void ipa_cmd_pipeline_clear(struct ipa *ipa);
  * Return:	A GSI transaction structure, or a null pointer if all
  *		available transactions are in use
  */
-struct gsi_trans *ipa_cmd_trans_alloc(struct ipa *ipa, u32 tre_count);
+struct ipa_trans *ipa_cmd_trans_alloc(struct ipa *ipa, u32 tre_count);
 
 #endif /* _IPA_CMD_H_ */
diff --git a/drivers/net/ipa/ipa_data-v3.5.1.c b/drivers/net/ipa/ipa_data-v3.5.1.c
index 760c22bbdf70..80ec55ef5ecc 100644
--- a/drivers/net/ipa/ipa_data-v3.5.1.c
+++ b/drivers/net/ipa/ipa_data-v3.5.1.c
@@ -6,7 +6,7 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
+#include "ipa_dma.h"
 #include "ipa_data.h"
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index fea91451a0c3..9db4c82213e4 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -4,7 +4,7 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
+#include "ipa_dma.h"
 #include "ipa_data.h"
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
diff --git a/drivers/net/ipa/ipa_data-v4.2.c b/drivers/net/ipa/ipa_data-v4.2.c
index 2a231e79d5e1..afae3fdbf6d7 100644
--- a/drivers/net/ipa/ipa_data-v4.2.c
+++ b/drivers/net/ipa/ipa_data-v4.2.c
@@ -4,7 +4,7 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
+#include "ipa_dma.h"
 #include "ipa_data.h"
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
diff --git a/drivers/net/ipa/ipa_data-v4.5.c b/drivers/net/ipa/ipa_data-v4.5.c
index e62ab9c3ac67..415167658962 100644
--- a/drivers/net/ipa/ipa_data-v4.5.c
+++ b/drivers/net/ipa/ipa_data-v4.5.c
@@ -4,7 +4,7 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
+#include "ipa_dma.h"
 #include "ipa_data.h"
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index 2421b5abb5d4..e5c20fc080c3 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -4,7 +4,7 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
+#include "ipa_dma.h"
 #include "ipa_data.h"
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/ipa_dma.h
similarity index 85%
rename from drivers/net/ipa/gsi.h
rename to drivers/net/ipa/ipa_dma.h
index 88b80dc3db79..d053929ca3e3 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/ipa_dma.h
@@ -26,8 +26,8 @@ struct device;
 struct scatterlist;
 struct platform_device;
 
-struct gsi;
-struct gsi_trans;
+struct ipa_dma;
+struct ipa_trans;
 struct gsi_channel_data;
 struct ipa_gsi_endpoint_data;
 
@@ -70,7 +70,7 @@ struct gsi_ring {
  * The result of a pool allocation of multiple elements is always
  * contiguous.
  */
-struct gsi_trans_pool {
+struct ipa_trans_pool {
 	void *base;			/* base address of element pool */
 	u32 count;			/* # elements in the pool */
 	u32 free;			/* next free element in pool (modulo) */
@@ -79,13 +79,13 @@ struct gsi_trans_pool {
 	dma_addr_t addr;		/* DMA address if DMA pool (or 0) */
 };
 
-struct gsi_trans_info {
+struct ipa_trans_info {
 	atomic_t tre_avail;		/* TREs available for allocation */
-	struct gsi_trans_pool pool;	/* transaction pool */
-	struct gsi_trans_pool sg_pool;	/* scatterlist pool */
-	struct gsi_trans_pool cmd_pool;	/* command payload DMA pool */
-	struct gsi_trans_pool info_pool;/* command information pool */
-	struct gsi_trans **map;		/* TRE -> transaction map */
+	struct ipa_trans_pool pool;	/* transaction pool */
+	struct ipa_trans_pool sg_pool;	/* scatterlist pool */
+	struct ipa_trans_pool cmd_pool;	/* command payload DMA pool */
+	struct ipa_trans_pool info_pool;/* command information pool */
+	struct ipa_trans **map;		/* TRE -> transaction map */
 
 	spinlock_t spinlock;		/* protects updates to the lists */
 	struct list_head alloc;		/* allocated, not committed */
@@ -105,8 +105,8 @@ enum gsi_channel_state {
 };
 
 /* We only care about channels between IPA and AP */
-struct gsi_channel {
-	struct gsi *gsi;
+struct ipa_channel {
+	struct ipa_dma *dma_subsys;
 	bool toward_ipa;
 	bool command;			/* AP command TX channel or not */
 
@@ -127,7 +127,7 @@ struct gsi_channel {
 	u64 compl_byte_count;		/* last reported completed byte count */
 	u64 compl_trans_count;		/* ...and completed trans count */
 
-	struct gsi_trans_info trans_info;
+	struct ipa_trans_info trans_info;
 
 	struct napi_struct napi;
 };
@@ -140,12 +140,12 @@ enum gsi_evt_ring_state {
 };
 
 struct gsi_evt_ring {
-	struct gsi_channel *channel;
+	struct ipa_channel *channel;
 	struct completion completion;	/* signals event ring state changes */
 	struct gsi_ring ring;
 };
 
-struct gsi {
+struct ipa_dma {
 	struct device *dev;		/* Same as IPA device */
 	enum ipa_version version;
 	struct net_device dummy_dev;	/* needed for NAPI */
@@ -154,7 +154,7 @@ struct gsi {
 	u32 irq;
 	u32 channel_count;
 	u32 evt_ring_count;
-	struct gsi_channel channel[GSI_CHANNEL_COUNT_MAX];
+	struct ipa_channel channel[GSI_CHANNEL_COUNT_MAX];
 	struct gsi_evt_ring evt_ring[GSI_EVT_RING_COUNT_MAX];
 	u32 event_bitmap;		/* allocated event rings */
 	u32 modem_channel_bitmap;	/* modem channels to allocate */
@@ -174,13 +174,13 @@ struct gsi {
  * Performs initialization that must wait until the GSI hardware is
  * ready (including firmware loaded).
  */
-int gsi_setup(struct gsi *gsi);
+int gsi_setup(struct ipa_dma *dma_subsys);
 
 /**
  * gsi_teardown() - Tear down GSI subsystem
  * @gsi:	GSI address previously passed to a successful gsi_setup() call
  */
-void gsi_teardown(struct gsi *gsi);
+void gsi_teardown(struct ipa_dma *dma_subsys);
 
 /**
  * gsi_channel_tre_max() - Channel maximum number of in-flight TREs
@@ -189,7 +189,7 @@ void gsi_teardown(struct gsi *gsi);
  *
  * Return:	 The maximum number of TREs oustanding on the channel
  */
-u32 gsi_channel_tre_max(struct gsi *gsi, u32 channel_id);
+u32 gsi_channel_tre_max(struct ipa_dma *dma_subsys, u32 channel_id);
 
 /**
  * gsi_channel_trans_tre_max() - Maximum TREs in a single transaction
@@ -198,7 +198,7 @@ u32 gsi_channel_tre_max(struct gsi *gsi, u32 channel_id);
  *
  * Return:	 The maximum TRE count per transaction on the channel
  */
-u32 gsi_channel_trans_tre_max(struct gsi *gsi, u32 channel_id);
+u32 gsi_channel_trans_tre_max(struct ipa_dma *dma_subsys, u32 channel_id);
 
 /**
  * gsi_channel_start() - Start an allocated GSI channel
@@ -207,7 +207,7 @@ u32 gsi_channel_trans_tre_max(struct gsi *gsi, u32 channel_id);
  *
  * Return:	0 if successful, or a negative error code
  */
-int gsi_channel_start(struct gsi *gsi, u32 channel_id);
+int gsi_channel_start(struct ipa_dma *dma_subsys, u32 channel_id);
 
 /**
  * gsi_channel_stop() - Stop a started GSI channel
@@ -216,7 +216,7 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id);
  *
  * Return:	0 if successful, or a negative error code
  */
-int gsi_channel_stop(struct gsi *gsi, u32 channel_id);
+int gsi_channel_stop(struct ipa_dma *dma_subsys, u32 channel_id);
 
 /**
  * gsi_channel_reset() - Reset an allocated GSI channel
@@ -230,19 +230,19 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id);
  * GSI hardware relinquishes ownership of all pending receive buffer
  * transactions and they will complete with their cancelled flag set.
  */
-void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell);
+void gsi_channel_reset(struct ipa_dma *dma_subsys, u32 channel_id, bool doorbell);
 
 /**
  * gsi_suspend() - Prepare the GSI subsystem for suspend
  * @gsi:	GSI pointer
  */
-void gsi_suspend(struct gsi *gsi);
+void gsi_suspend(struct ipa_dma *dma_subsys);
 
 /**
  * gsi_resume() - Resume the GSI subsystem following suspend
  * @gsi:	GSI pointer
  */
-void gsi_resume(struct gsi *gsi);
+void gsi_resume(struct ipa_dma *dma_subsys);
 
 /**
  * gsi_channel_suspend() - Suspend a GSI channel
@@ -251,7 +251,7 @@ void gsi_resume(struct gsi *gsi);
  *
  * For IPA v4.0+, suspend is implemented by stopping the channel.
  */
-int gsi_channel_suspend(struct gsi *gsi, u32 channel_id);
+int gsi_channel_suspend(struct ipa_dma *dma_subsys, u32 channel_id);
 
 /**
  * gsi_channel_resume() - Resume a suspended GSI channel
@@ -260,7 +260,7 @@ int gsi_channel_suspend(struct gsi *gsi, u32 channel_id);
  *
  * For IPA v4.0+, the stopped channel is started again.
  */
-int gsi_channel_resume(struct gsi *gsi, u32 channel_id);
+int gsi_channel_resume(struct ipa_dma *dma_subsys, u32 channel_id);
 
 /**
  * gsi_init() - Initialize the GSI subsystem
@@ -275,7 +275,7 @@ int gsi_channel_resume(struct gsi *gsi, u32 channel_id);
  * Early stage initialization of the GSI subsystem, performing tasks
  * that can be done before the GSI hardware is ready to use.
  */
-int gsi_init(struct gsi *gsi, struct platform_device *pdev,
+int gsi_init(struct ipa_dma *dma_subsys, struct platform_device *pdev,
 	     enum ipa_version version, u32 count,
 	     const struct ipa_gsi_endpoint_data *data);
 
@@ -283,6 +283,6 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
  * gsi_exit() - Exit the GSI subsystem
  * @gsi:	GSI address previously passed to a successful gsi_init() call
  */
-void gsi_exit(struct gsi *gsi);
+void gsi_exit(struct ipa_dma *dma_subsys);
 
 #endif /* _GSI_H_ */
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/ipa_dma_private.h
similarity index 67%
rename from drivers/net/ipa/gsi_private.h
rename to drivers/net/ipa/ipa_dma_private.h
index ea333a244cf5..40148a551b47 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/ipa_dma_private.h
@@ -6,38 +6,38 @@
 #ifndef _GSI_PRIVATE_H_
 #define _GSI_PRIVATE_H_
 
-/* === Only "gsi.c" and "gsi_trans.c" should include this file === */
+/* === Only "gsi.c" and "ipa_trans.c" should include this file === */
 
 #include <linux/types.h>
 
-struct gsi_trans;
+struct ipa_trans;
 struct gsi_ring;
-struct gsi_channel;
+struct ipa_channel;
 
 #define GSI_RING_ELEMENT_SIZE	16	/* bytes; must be a power of 2 */
 
 /* Return the entry that follows one provided in a transaction pool */
-void *gsi_trans_pool_next(struct gsi_trans_pool *pool, void *element);
+void *ipa_trans_pool_next(struct ipa_trans_pool *pool, void *element);
 
 /**
- * gsi_trans_move_complete() - Mark a GSI transaction completed
+ * ipa_trans_move_complete() - Mark a GSI transaction completed
  * @trans:	Transaction to commit
  */
-void gsi_trans_move_complete(struct gsi_trans *trans);
+void ipa_trans_move_complete(struct ipa_trans *trans);
 
 /**
- * gsi_trans_move_polled() - Mark a transaction polled
+ * ipa_trans_move_polled() - Mark a transaction polled
  * @trans:	Transaction to update
  */
-void gsi_trans_move_polled(struct gsi_trans *trans);
+void ipa_trans_move_polled(struct ipa_trans *trans);
 
 /**
- * gsi_trans_complete() - Complete a GSI transaction
+ * ipa_trans_complete() - Complete a GSI transaction
  * @trans:	Transaction to complete
  *
  * Marks a transaction complete (including freeing it).
  */
-void gsi_trans_complete(struct gsi_trans *trans);
+void ipa_trans_complete(struct ipa_trans *trans);
 
 /**
  * gsi_channel_trans_mapped() - Return a transaction mapped to a TRE index
@@ -46,19 +46,19 @@ void gsi_trans_complete(struct gsi_trans *trans);
  *
  * Return:	The GSI transaction pointer associated with the TRE index
  */
-struct gsi_trans *gsi_channel_trans_mapped(struct gsi_channel *channel,
+struct ipa_trans *gsi_channel_trans_mapped(struct ipa_channel *channel,
 					   u32 index);
 
 /**
- * gsi_channel_trans_complete() - Return a channel's next completed transaction
+ * ipa_channel_trans_complete() - Return a channel's next completed transaction
  * @channel:	Channel whose next transaction is to be returned
  *
  * Return:	The next completed transaction, or NULL if nothing new
  */
-struct gsi_trans *gsi_channel_trans_complete(struct gsi_channel *channel);
+struct ipa_trans *ipa_channel_trans_complete(struct ipa_channel *channel);
 
 /**
- * gsi_channel_trans_cancel_pending() - Cancel pending transactions
+ * ipa_channel_trans_cancel_pending() - Cancel pending transactions
  * @channel:	Channel whose pending transactions should be cancelled
  *
  * Cancel all pending transactions on a channel.  These are transactions
@@ -69,10 +69,10 @@ struct gsi_trans *gsi_channel_trans_complete(struct gsi_channel *channel);
  * NOTE:  Transactions already complete at the time of this call are
  *	  unaffected.
  */
-void gsi_channel_trans_cancel_pending(struct gsi_channel *channel);
+void ipa_channel_trans_cancel_pending(struct ipa_channel *channel);
 
 /**
- * gsi_channel_trans_init() - Initialize a channel's GSI transaction info
+ * ipa_channel_trans_init() - Initialize a channel's GSI transaction info
  * @gsi:	GSI pointer
  * @channel_id:	Channel number
  *
@@ -80,13 +80,13 @@ void gsi_channel_trans_cancel_pending(struct gsi_channel *channel);
  *
  * Creates and sets up information for managing transactions on a channel
  */
-int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id);
+int ipa_channel_trans_init(struct ipa_dma *gsi, u32 channel_id);
 
 /**
- * gsi_channel_trans_exit() - Inverse of gsi_channel_trans_init()
+ * ipa_channel_trans_exit() - Inverse of ipa_channel_trans_init()
  * @channel:	Channel whose transaction information is to be cleaned up
  */
-void gsi_channel_trans_exit(struct gsi_channel *channel);
+void ipa_channel_trans_exit(struct ipa_channel *channel);
 
 /**
  * gsi_channel_doorbell() - Ring a channel's doorbell
@@ -95,7 +95,7 @@ void gsi_channel_trans_exit(struct gsi_channel *channel);
  * Rings a channel's doorbell to inform the GSI hardware that new
  * transactions (TREs, really) are available for it to process.
  */
-void gsi_channel_doorbell(struct gsi_channel *channel);
+void gsi_channel_doorbell(struct ipa_channel *channel);
 
 /**
  * gsi_ring_virt() - Return virtual address for a ring entry
@@ -105,7 +105,7 @@ void gsi_channel_doorbell(struct gsi_channel *channel);
 void *gsi_ring_virt(struct gsi_ring *ring, u32 index);
 
 /**
- * gsi_channel_tx_queued() - Report the number of bytes queued to hardware
+ * ipa_channel_tx_queued() - Report the number of bytes queued to hardware
  * @channel:	Channel whose bytes have been queued
  *
  * This arranges for the the number of transactions and bytes for
@@ -113,6 +113,6 @@ void *gsi_ring_virt(struct gsi_ring *ring, u32 index);
  * passes this information up the network stack so it can be used to
  * throttle transmissions.
  */
-void gsi_channel_tx_queued(struct gsi_channel *channel);
+void ipa_channel_tx_queued(struct ipa_channel *channel);
 
 #endif /* _GSI_PRIVATE_H_ */
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 29227de6661f..90d6880e8a25 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -11,8 +11,8 @@
 #include <linux/if_rmnet.h>
 #include <linux/dma-direction.h>
 
-#include "gsi.h"
-#include "gsi_trans.h"
+#include "ipa_dma.h"
+#include "ipa_trans.h"
 #include "ipa.h"
 #include "ipa_data.h"
 #include "ipa_endpoint.h"
@@ -224,16 +224,16 @@ static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 }
 
 /* Allocate a transaction to use on a non-command endpoint */
-static struct gsi_trans *ipa_endpoint_trans_alloc(struct ipa_endpoint *endpoint,
+static struct ipa_trans *ipa_endpoint_trans_alloc(struct ipa_endpoint *endpoint,
 						  u32 tre_count)
 {
-	struct gsi *gsi = &endpoint->ipa->gsi;
+	struct ipa_dma *gsi = &endpoint->ipa->dma_subsys;
 	u32 channel_id = endpoint->channel_id;
 	enum dma_data_direction direction;
 
 	direction = endpoint->toward_ipa ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 
-	return gsi_channel_trans_alloc(gsi, channel_id, tre_count, direction);
+	return ipa_channel_trans_alloc(gsi, channel_id, tre_count, direction);
 }
 
 /* suspend_delay represents suspend for RX, delay for TX endpoints.
@@ -382,7 +382,7 @@ void ipa_endpoint_modem_pause_all(struct ipa *ipa, bool enable)
 int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 {
 	u32 initialized = ipa->initialized;
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 	u32 count;
 
 	/* We need one command per modem TX endpoint.  We can get an upper
@@ -422,7 +422,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 	ipa_cmd_pipeline_clear_add(trans);
 
 	/* XXX This should have a 1 second timeout */
-	gsi_trans_commit_wait(trans);
+	ipa_trans_commit_wait(trans);
 
 	ipa_cmd_pipeline_clear_wait(ipa);
 
@@ -938,7 +938,7 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
  */
 int ipa_endpoint_skb_tx(struct ipa_endpoint *endpoint, struct sk_buff *skb)
 {
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 	u32 nr_frags;
 	int ret;
 
@@ -957,17 +957,17 @@ int ipa_endpoint_skb_tx(struct ipa_endpoint *endpoint, struct sk_buff *skb)
 	if (!trans)
 		return -EBUSY;
 
-	ret = gsi_trans_skb_add(trans, skb);
+	ret = ipa_trans_skb_add(trans, skb);
 	if (ret)
 		goto err_trans_free;
 	trans->data = skb;	/* transaction owns skb now */
 
-	gsi_trans_commit(trans, !netdev_xmit_more());
+	ipa_trans_commit(trans, !netdev_xmit_more());
 
 	return 0;
 
 err_trans_free:
-	gsi_trans_free(trans);
+	ipa_trans_free(trans);
 
 	return -ENOMEM;
 }
@@ -1004,7 +1004,7 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 
 static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 {
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 	bool doorbell = false;
 	struct page *page;
 	u32 offset;
@@ -1023,7 +1023,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 	offset = NET_SKB_PAD;
 	len = IPA_RX_BUFFER_SIZE - offset;
 
-	ret = gsi_trans_page_add(trans, page, len, offset);
+	ret = ipa_trans_page_add(trans, page, len, offset);
 	if (ret)
 		goto err_trans_free;
 	trans->data = page;	/* transaction owns page now */
@@ -1033,12 +1033,12 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 		endpoint->replenish_ready = 0;
 	}
 
-	gsi_trans_commit(trans, doorbell);
+	ipa_trans_commit(trans, doorbell);
 
 	return 0;
 
 err_trans_free:
-	gsi_trans_free(trans);
+	ipa_trans_free(trans);
 err_free_pages:
 	__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
 
@@ -1060,7 +1060,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
  */
 static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 {
-	struct gsi *gsi;
+	struct ipa_dma *gsi;
 	u32 backlog;
 
 	if (!endpoint->replenish_enabled) {
@@ -1090,7 +1090,7 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 	 * Receive buffer transactions use one TRE, so schedule work to
 	 * try replenishing again if our backlog is *all* available TREs.
 	 */
-	gsi = &endpoint->ipa->gsi;
+	gsi = &endpoint->ipa->dma_subsys;
 	if (backlog == gsi_channel_tre_max(gsi, endpoint->channel_id))
 		schedule_delayed_work(&endpoint->replenish_work,
 				      msecs_to_jiffies(1));
@@ -1098,7 +1098,7 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 
 static void ipa_endpoint_replenish_enable(struct ipa_endpoint *endpoint)
 {
-	struct gsi *gsi = &endpoint->ipa->gsi;
+	struct ipa_dma *gsi = &endpoint->ipa->dma_subsys;
 	u32 max_backlog;
 	u32 saved;
 
@@ -1320,13 +1320,13 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 
 /* Complete a TX transaction, command or from ipa_endpoint_skb_tx() */
 static void ipa_endpoint_tx_complete(struct ipa_endpoint *endpoint,
-				     struct gsi_trans *trans)
+				     struct ipa_trans *trans)
 {
 }
 
 /* Complete transaction initiated in ipa_endpoint_replenish_one() */
 static void ipa_endpoint_rx_complete(struct ipa_endpoint *endpoint,
-				     struct gsi_trans *trans)
+				     struct ipa_trans *trans)
 {
 	struct page *page;
 
@@ -1344,7 +1344,7 @@ static void ipa_endpoint_rx_complete(struct ipa_endpoint *endpoint,
 }
 
 void ipa_endpoint_trans_complete(struct ipa_endpoint *endpoint,
-				 struct gsi_trans *trans)
+				 struct ipa_trans *trans)
 {
 	if (endpoint->toward_ipa)
 		ipa_endpoint_tx_complete(endpoint, trans);
@@ -1353,7 +1353,7 @@ void ipa_endpoint_trans_complete(struct ipa_endpoint *endpoint,
 }
 
 void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
-				struct gsi_trans *trans)
+				struct ipa_trans *trans)
 {
 	if (endpoint->toward_ipa) {
 		struct ipa *ipa = endpoint->ipa;
@@ -1406,7 +1406,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 {
 	struct device *dev = &endpoint->ipa->pdev->dev;
 	struct ipa *ipa = endpoint->ipa;
-	struct gsi *gsi = &ipa->gsi;
+	struct ipa_dma *gsi = &ipa->dma_subsys;
 	bool suspended = false;
 	dma_addr_t addr;
 	u32 retries;
@@ -1504,7 +1504,7 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 	if (special && ipa_endpoint_aggr_active(endpoint))
 		ret = ipa_endpoint_reset_rx_aggr(endpoint);
 	else
-		gsi_channel_reset(&ipa->gsi, channel_id, true);
+		gsi_channel_reset(&ipa->dma_subsys, channel_id, true);
 
 	if (ret)
 		dev_err(&ipa->pdev->dev,
@@ -1534,7 +1534,7 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 int ipa_endpoint_enable_one(struct ipa_endpoint *endpoint)
 {
 	struct ipa *ipa = endpoint->ipa;
-	struct gsi *gsi = &ipa->gsi;
+	struct ipa_dma *gsi = &ipa->dma_subsys;
 	int ret;
 
 	ret = gsi_channel_start(gsi, endpoint->channel_id);
@@ -1561,7 +1561,7 @@ void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint)
 {
 	u32 mask = BIT(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
-	struct gsi *gsi = &ipa->gsi;
+	struct ipa_dma *gsi = &ipa->dma_subsys;
 	int ret;
 
 	if (!(ipa->enabled & mask))
@@ -1586,7 +1586,8 @@ void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint)
 void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 {
 	struct device *dev = &endpoint->ipa->pdev->dev;
-	struct gsi *gsi = &endpoint->ipa->gsi;
+	struct ipa_dma *gsi = &endpoint->ipa->dma_subsys;
+	bool stop_channel;
 	int ret;
 
 	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
@@ -1606,7 +1607,8 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 {
 	struct device *dev = &endpoint->ipa->pdev->dev;
-	struct gsi *gsi = &endpoint->ipa->gsi;
+	struct ipa_dma *gsi = &endpoint->ipa->dma_subsys;
+	bool start_channel;
 	int ret;
 
 	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
@@ -1651,7 +1653,7 @@ void ipa_endpoint_resume(struct ipa *ipa)
 
 static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
 {
-	struct gsi *gsi = &endpoint->ipa->gsi;
+	struct ipa_dma *gsi = &endpoint->ipa->dma_subsys;
 	u32 channel_id = endpoint->channel_id;
 
 	/* Only AP endpoints get set up */
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 0a859d10312d..7ba06abc1968 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -10,7 +10,7 @@
 #include <linux/workqueue.h>
 #include <linux/if_ether.h>
 
-#include "gsi.h"
+#include "ipa_dma.h"
 #include "ipa_reg.h"
 
 struct net_device;
@@ -110,8 +110,8 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
 void ipa_endpoint_exit(struct ipa *ipa);
 
 void ipa_endpoint_trans_complete(struct ipa_endpoint *ipa,
-				 struct gsi_trans *trans);
+				 struct ipa_trans *trans);
 void ipa_endpoint_trans_release(struct ipa_endpoint *ipa,
-				struct gsi_trans *trans);
+				struct ipa_trans *trans);
 
 #endif /* _IPA_ENDPOINT_H_ */
diff --git a/drivers/net/ipa/ipa_gsi.c b/drivers/net/ipa/ipa_gsi.c
index d323adb03383..d212ca01894d 100644
--- a/drivers/net/ipa/ipa_gsi.c
+++ b/drivers/net/ipa/ipa_gsi.c
@@ -7,29 +7,29 @@
 #include <linux/types.h>
 
 #include "ipa_gsi.h"
-#include "gsi_trans.h"
+#include "ipa_trans.h"
 #include "ipa.h"
 #include "ipa_endpoint.h"
 #include "ipa_data.h"
 
-void ipa_gsi_trans_complete(struct gsi_trans *trans)
+void ipa_gsi_trans_complete(struct ipa_trans *trans)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 
 	ipa_endpoint_trans_complete(ipa->channel_map[trans->channel_id], trans);
 }
 
-void ipa_gsi_trans_release(struct gsi_trans *trans)
+void ipa_gsi_trans_release(struct ipa_trans *trans)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 
 	ipa_endpoint_trans_release(ipa->channel_map[trans->channel_id], trans);
 }
 
-void ipa_gsi_channel_tx_queued(struct gsi *gsi, u32 channel_id, u32 count,
+void ipa_gsi_channel_tx_queued(struct ipa_dma *gsi, u32 channel_id, u32 count,
 			       u32 byte_count)
 {
-	struct ipa *ipa = container_of(gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(gsi, struct ipa, dma_subsys);
 	struct ipa_endpoint *endpoint;
 
 	endpoint = ipa->channel_map[channel_id];
@@ -37,10 +37,10 @@ void ipa_gsi_channel_tx_queued(struct gsi *gsi, u32 channel_id, u32 count,
 		netdev_sent_queue(endpoint->netdev, byte_count);
 }
 
-void ipa_gsi_channel_tx_completed(struct gsi *gsi, u32 channel_id, u32 count,
+void ipa_gsi_channel_tx_completed(struct ipa_dma *gsi, u32 channel_id, u32 count,
 				  u32 byte_count)
 {
-	struct ipa *ipa = container_of(gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(gsi, struct ipa, dma_subsys);
 	struct ipa_endpoint *endpoint;
 
 	endpoint = ipa->channel_map[channel_id];
diff --git a/drivers/net/ipa/ipa_gsi.h b/drivers/net/ipa/ipa_gsi.h
index c02cb6f3a2e1..85df59177c34 100644
--- a/drivers/net/ipa/ipa_gsi.h
+++ b/drivers/net/ipa/ipa_gsi.h
@@ -8,8 +8,8 @@
 
 #include <linux/types.h>
 
-struct gsi;
-struct gsi_trans;
+struct ipa_dma;
+struct ipa_trans;
 struct ipa_gsi_endpoint_data;
 
 /**
@@ -19,7 +19,7 @@ struct ipa_gsi_endpoint_data;
  * This called from the GSI layer to notify the IPA layer that a
  * transaction has completed.
  */
-void ipa_gsi_trans_complete(struct gsi_trans *trans);
+void ipa_gsi_trans_complete(struct ipa_trans *trans);
 
 /**
  * ipa_gsi_trans_release() - GSI transaction release callback
@@ -29,7 +29,7 @@ void ipa_gsi_trans_complete(struct gsi_trans *trans);
  * transaction is about to be freed, so any resources associated
  * with it should be released.
  */
-void ipa_gsi_trans_release(struct gsi_trans *trans);
+void ipa_gsi_trans_release(struct ipa_trans *trans);
 
 /**
  * ipa_gsi_channel_tx_queued() - GSI queued to hardware notification
@@ -41,7 +41,7 @@ void ipa_gsi_trans_release(struct gsi_trans *trans);
  * This called from the GSI layer to notify the IPA layer that some
  * number of transactions have been queued to hardware for execution.
  */
-void ipa_gsi_channel_tx_queued(struct gsi *gsi, u32 channel_id, u32 count,
+void ipa_gsi_channel_tx_queued(struct ipa_dma *gsi, u32 channel_id, u32 count,
 			       u32 byte_count);
 
 /**
@@ -54,7 +54,7 @@ void ipa_gsi_channel_tx_queued(struct gsi *gsi, u32 channel_id, u32 count,
  * This called from the GSI layer to notify the IPA layer that the hardware
  * has reported the completion of some number of transactions.
  */
-void ipa_gsi_channel_tx_completed(struct gsi *gsi, u32 channel_id, u32 count,
+void ipa_gsi_channel_tx_completed(struct ipa_dma *gsi, u32 channel_id, u32 count,
 				  u32 byte_count);
 
 /* ipa_gsi_endpoint_data_empty() - Empty endpoint config data test
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index cdfa98a76e1f..026f5555fa7d 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -31,7 +31,7 @@
 #include "ipa_modem.h"
 #include "ipa_uc.h"
 #include "ipa_interrupt.h"
-#include "gsi_trans.h"
+#include "ipa_trans.h"
 #include "ipa_sysfs.h"
 
 /**
@@ -98,7 +98,7 @@ int ipa_setup(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
-	ret = gsi_setup(&ipa->gsi);
+	ret = gsi_setup(&ipa->dma_subsys);
 	if (ret)
 		return ret;
 
@@ -154,7 +154,7 @@ int ipa_setup(struct ipa *ipa)
 	ipa_endpoint_teardown(ipa);
 	ipa_power_teardown(ipa);
 err_gsi_teardown:
-	gsi_teardown(&ipa->gsi);
+	gsi_teardown(&ipa->dma_subsys);
 
 	return ret;
 }
@@ -179,7 +179,7 @@ static void ipa_teardown(struct ipa *ipa)
 	ipa_endpoint_disable_one(command_endpoint);
 	ipa_endpoint_teardown(ipa);
 	ipa_power_teardown(ipa);
-	gsi_teardown(&ipa->gsi);
+	gsi_teardown(&ipa->dma_subsys);
 }
 
 /* Configure bus access behavior for IPA components */
@@ -716,7 +716,7 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_reg_exit;
 
-	ret = gsi_init(&ipa->gsi, pdev, ipa->version, data->endpoint_count,
+	ret = gsi_init(&ipa->dma_subsys, pdev, ipa->version, data->endpoint_count,
 		       data->endpoint_data);
 	if (ret)
 		goto err_mem_exit;
@@ -781,7 +781,7 @@ static int ipa_probe(struct platform_device *pdev)
 err_endpoint_exit:
 	ipa_endpoint_exit(ipa);
 err_gsi_exit:
-	gsi_exit(&ipa->gsi);
+	gsi_exit(&ipa->dma_subsys);
 err_mem_exit:
 	ipa_mem_exit(ipa);
 err_reg_exit:
@@ -824,7 +824,7 @@ static int ipa_remove(struct platform_device *pdev)
 	ipa_modem_exit(ipa);
 	ipa_table_exit(ipa);
 	ipa_endpoint_exit(ipa);
-	gsi_exit(&ipa->gsi);
+	gsi_exit(&ipa->dma_subsys);
 	ipa_mem_exit(ipa);
 	ipa_reg_exit(ipa);
 	kfree(ipa);
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 4337b0920d3d..16e5fdd5bd73 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -18,7 +18,7 @@
 #include "ipa_cmd.h"
 #include "ipa_mem.h"
 #include "ipa_table.h"
-#include "gsi_trans.h"
+#include "ipa_trans.h"
 
 /* "Canary" value placed between memory regions to detect overflow */
 #define IPA_MEM_CANARY_VAL		cpu_to_le32(0xdeadbeef)
@@ -42,9 +42,9 @@ const struct ipa_mem *ipa_mem_find(struct ipa *ipa, enum ipa_mem_id mem_id)
 
 /* Add an immediate command to a transaction that zeroes a memory region */
 static void
-ipa_mem_zero_region_add(struct gsi_trans *trans, enum ipa_mem_id mem_id)
+ipa_mem_zero_region_add(struct ipa_trans *trans, enum ipa_mem_id mem_id)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
 	dma_addr_t addr = ipa->zero_addr;
 
@@ -76,7 +76,7 @@ int ipa_mem_setup(struct ipa *ipa)
 {
 	dma_addr_t addr = ipa->zero_addr;
 	const struct ipa_mem *mem;
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 	u32 offset;
 	u16 size;
 	u32 val;
@@ -107,7 +107,7 @@ int ipa_mem_setup(struct ipa *ipa)
 	ipa_mem_zero_region_add(trans, IPA_MEM_AP_PROC_CTX);
 	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM);
 
-	gsi_trans_commit_wait(trans);
+	ipa_trans_commit_wait(trans);
 
 	/* Tell the hardware where the processing context area is located */
 	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_PROC_CTX);
@@ -408,7 +408,7 @@ void ipa_mem_deconfig(struct ipa *ipa)
  */
 int ipa_mem_zero_modem(struct ipa *ipa)
 {
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 
 	/* Get a transaction to zero the modem memory, modem header,
 	 * and modem processing context regions.
@@ -424,7 +424,7 @@ int ipa_mem_zero_modem(struct ipa *ipa)
 	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM_PROC_CTX);
 	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM);
 
-	gsi_trans_commit_wait(trans);
+	ipa_trans_commit_wait(trans);
 
 	return 0;
 }
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 96c467c80a2e..d197959cc032 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -21,8 +21,8 @@
 #include "ipa_reg.h"
 #include "ipa_mem.h"
 #include "ipa_cmd.h"
-#include "gsi.h"
-#include "gsi_trans.h"
+#include "ipa_dma.h"
+#include "ipa_trans.h"
 
 /**
  * DOC: IPA Filter and Route Tables
@@ -234,10 +234,10 @@ static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 	return ipa->table_addr + skip * IPA_TABLE_ENTRY_SIZE(ipa->version);
 }
 
-static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
+static void ipa_table_reset_add(struct ipa_trans *trans, bool filter,
 				u16 first, u16 count, enum ipa_mem_id mem_id)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
 	dma_addr_t addr;
 	u32 offset;
@@ -266,7 +266,7 @@ ipa_filter_reset_table(struct ipa *ipa, enum ipa_mem_id mem_id, bool modem)
 {
 	u32 ep_mask = ipa->filter_map;
 	u32 count = hweight32(ep_mask);
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 	enum gsi_ee_id ee_id;
 
 	trans = ipa_cmd_trans_alloc(ipa, count);
@@ -291,7 +291,7 @@ ipa_filter_reset_table(struct ipa *ipa, enum ipa_mem_id mem_id, bool modem)
 		ipa_table_reset_add(trans, true, endpoint_id, 1, mem_id);
 	}
 
-	gsi_trans_commit_wait(trans);
+	ipa_trans_commit_wait(trans);
 
 	return 0;
 }
@@ -326,7 +326,7 @@ static int ipa_filter_reset(struct ipa *ipa, bool modem)
  * */
 static int ipa_route_reset(struct ipa *ipa, bool modem)
 {
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 	u16 first;
 	u16 count;
 
@@ -354,7 +354,7 @@ static int ipa_route_reset(struct ipa *ipa, bool modem)
 	ipa_table_reset_add(trans, false, first, count,
 			    IPA_MEM_V6_ROUTE_HASHED);
 
-	gsi_trans_commit_wait(trans);
+	ipa_trans_commit_wait(trans);
 
 	return 0;
 }
@@ -382,7 +382,7 @@ void ipa_table_reset(struct ipa *ipa, bool modem)
 int ipa_table_hash_flush(struct ipa *ipa)
 {
 	u32 offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 	u32 val;
 
 	if (!ipa_table_hash_support(ipa))
@@ -399,17 +399,17 @@ int ipa_table_hash_flush(struct ipa *ipa)
 
 	ipa_cmd_register_write_add(trans, offset, val, val, false);
 
-	gsi_trans_commit_wait(trans);
+	ipa_trans_commit_wait(trans);
 
 	return 0;
 }
 
-static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
+static void ipa_table_init_add(struct ipa_trans *trans, bool filter,
 			       enum ipa_cmd_opcode opcode,
 			       enum ipa_mem_id mem_id,
 			       enum ipa_mem_id hash_mem_id)
 {
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa *ipa = container_of(trans->dma_subsys, struct ipa, dma_subsys);
 	const struct ipa_mem *hash_mem = ipa_mem_find(ipa, hash_mem_id);
 	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
 	dma_addr_t hash_addr;
@@ -444,7 +444,7 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 
 int ipa_table_setup(struct ipa *ipa)
 {
-	struct gsi_trans *trans;
+	struct ipa_trans *trans;
 
 	trans = ipa_cmd_trans_alloc(ipa, 4);
 	if (!trans) {
@@ -464,7 +464,7 @@ int ipa_table_setup(struct ipa *ipa)
 	ipa_table_init_add(trans, true, IPA_CMD_IP_V6_FILTER_INIT,
 			   IPA_MEM_V6_FILTER, IPA_MEM_V6_FILTER_HASHED);
 
-	gsi_trans_commit_wait(trans);
+	ipa_trans_commit_wait(trans);
 
 	return 0;
 }
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/ipa_trans.c
similarity index 81%
rename from drivers/net/ipa/gsi_trans.c
rename to drivers/net/ipa/ipa_trans.c
index 1544564bc283..b87936b18770 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/ipa_trans.c
@@ -11,9 +11,9 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-direction.h>
 
-#include "gsi.h"
-#include "gsi_private.h"
-#include "gsi_trans.h"
+#include "ipa_dma.h"
+#include "ipa_dma_private.h"
+#include "ipa_trans.h"
 #include "ipa_gsi.h"
 #include "ipa_data.h"
 #include "ipa_cmd.h"
@@ -85,7 +85,7 @@ struct gsi_tre {
 #define TRE_FLAGS_BEI_FMASK	GENMASK(10, 10)
 #define TRE_FLAGS_TYPE_FMASK	GENMASK(23, 16)
 
-int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
+int ipa_trans_pool_init(struct ipa_trans_pool *pool, size_t size, u32 count,
 			u32 max_alloc)
 {
 	void *virt;
@@ -119,7 +119,7 @@ int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
 	return 0;
 }
 
-void gsi_trans_pool_exit(struct gsi_trans_pool *pool)
+void ipa_trans_pool_exit(struct ipa_trans_pool *pool)
 {
 	kfree(pool->base);
 	memset(pool, 0, sizeof(*pool));
@@ -131,7 +131,7 @@ void gsi_trans_pool_exit(struct gsi_trans_pool *pool)
  * (and it can be more than one), we only allow allocation of a single
  * element from a DMA pool.
  */
-int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
+int ipa_trans_pool_init_dma(struct device *dev, struct ipa_trans_pool *pool,
 			    size_t size, u32 count, u32 max_alloc)
 {
 	size_t total_size;
@@ -152,7 +152,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	/* The allocator will give us a power-of-2 number of pages
 	 * sufficient to satisfy our request.  Round up our requested
 	 * size to avoid any unused space in the allocation.  This way
-	 * gsi_trans_pool_exit_dma() can assume the total allocated
+	 * ipa_trans_pool_exit_dma() can assume the total allocated
 	 * size is exactly (count * size).
 	 */
 	total_size = get_order(total_size) << PAGE_SHIFT;
@@ -171,7 +171,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	return 0;
 }
 
-void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool)
+void ipa_trans_pool_exit_dma(struct device *dev, struct ipa_trans_pool *pool)
 {
 	size_t total_size = pool->count * pool->size;
 
@@ -180,7 +180,7 @@ void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool)
 }
 
 /* Return the byte offset of the next free entry in the pool */
-static u32 gsi_trans_pool_alloc_common(struct gsi_trans_pool *pool, u32 count)
+static u32 ipa_trans_pool_alloc_common(struct ipa_trans_pool *pool, u32 count)
 {
 	u32 offset;
 
@@ -199,15 +199,15 @@ static u32 gsi_trans_pool_alloc_common(struct gsi_trans_pool *pool, u32 count)
 }
 
 /* Allocate a contiguous block of zeroed entries from a pool */
-void *gsi_trans_pool_alloc(struct gsi_trans_pool *pool, u32 count)
+void *ipa_trans_pool_alloc(struct ipa_trans_pool *pool, u32 count)
 {
-	return pool->base + gsi_trans_pool_alloc_common(pool, count);
+	return pool->base + ipa_trans_pool_alloc_common(pool, count);
 }
 
 /* Allocate a single zeroed entry from a DMA pool */
-void *gsi_trans_pool_alloc_dma(struct gsi_trans_pool *pool, dma_addr_t *addr)
+void *ipa_trans_pool_alloc_dma(struct ipa_trans_pool *pool, dma_addr_t *addr)
 {
-	u32 offset = gsi_trans_pool_alloc_common(pool, 1);
+	u32 offset = ipa_trans_pool_alloc_common(pool, 1);
 
 	*addr = pool->addr + offset;
 
@@ -217,7 +217,7 @@ void *gsi_trans_pool_alloc_dma(struct gsi_trans_pool *pool, dma_addr_t *addr)
 /* Return the pool element that immediately follows the one given.
  * This only works done if elements are allocated one at a time.
  */
-void *gsi_trans_pool_next(struct gsi_trans_pool *pool, void *element)
+void *ipa_trans_pool_next(struct ipa_trans_pool *pool, void *element)
 {
 	void *end = pool->base + pool->count * pool->size;
 
@@ -231,33 +231,33 @@ void *gsi_trans_pool_next(struct gsi_trans_pool *pool, void *element)
 }
 
 /* Map a given ring entry index to the transaction associated with it */
-static void gsi_channel_trans_map(struct gsi_channel *channel, u32 index,
-				  struct gsi_trans *trans)
+static void gsi_channel_trans_map(struct ipa_channel *channel, u32 index,
+				  struct ipa_trans *trans)
 {
 	/* Note: index *must* be used modulo the ring count here */
 	channel->trans_info.map[index % channel->tre_ring.count] = trans;
 }
 
 /* Return the transaction mapped to a given ring entry */
-struct gsi_trans *
-gsi_channel_trans_mapped(struct gsi_channel *channel, u32 index)
+struct ipa_trans *
+gsi_channel_trans_mapped(struct ipa_channel *channel, u32 index)
 {
 	/* Note: index *must* be used modulo the ring count here */
 	return channel->trans_info.map[index % channel->tre_ring.count];
 }
 
 /* Return the oldest completed transaction for a channel (or null) */
-struct gsi_trans *gsi_channel_trans_complete(struct gsi_channel *channel)
+struct ipa_trans *ipa_channel_trans_complete(struct ipa_channel *channel)
 {
 	return list_first_entry_or_null(&channel->trans_info.complete,
-					struct gsi_trans, links);
+					struct ipa_trans, links);
 }
 
 /* Move a transaction from the allocated list to the pending list */
-static void gsi_trans_move_pending(struct gsi_trans *trans)
+static void ipa_trans_move_pending(struct ipa_trans *trans)
 {
-	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
-	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct ipa_channel *channel = &trans->dma_subsys->channel[trans->channel_id];
+	struct ipa_trans_info *trans_info = &channel->trans_info;
 
 	spin_lock_bh(&trans_info->spinlock);
 
@@ -269,10 +269,10 @@ static void gsi_trans_move_pending(struct gsi_trans *trans)
 /* Move a transaction and all of its predecessors from the pending list
  * to the completed list.
  */
-void gsi_trans_move_complete(struct gsi_trans *trans)
+void ipa_trans_move_complete(struct ipa_trans *trans)
 {
-	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
-	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct ipa_channel *channel = &trans->dma_subsys->channel[trans->channel_id];
+	struct ipa_trans_info *trans_info = &channel->trans_info;
 	struct list_head list;
 
 	spin_lock_bh(&trans_info->spinlock);
@@ -285,10 +285,10 @@ void gsi_trans_move_complete(struct gsi_trans *trans)
 }
 
 /* Move a transaction from the completed list to the polled list */
-void gsi_trans_move_polled(struct gsi_trans *trans)
+void ipa_trans_move_polled(struct ipa_trans *trans)
 {
-	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
-	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct ipa_channel *channel = &trans->dma_subsys->channel[trans->channel_id];
+	struct ipa_trans_info *trans_info = &channel->trans_info;
 
 	spin_lock_bh(&trans_info->spinlock);
 
@@ -299,7 +299,7 @@ void gsi_trans_move_polled(struct gsi_trans *trans)
 
 /* Reserve some number of TREs on a channel.  Returns true if successful */
 static bool
-gsi_trans_tre_reserve(struct gsi_trans_info *trans_info, u32 tre_count)
+ipa_trans_tre_reserve(struct ipa_trans_info *trans_info, u32 tre_count)
 {
 	int avail = atomic_read(&trans_info->tre_avail);
 	int new;
@@ -315,21 +315,21 @@ gsi_trans_tre_reserve(struct gsi_trans_info *trans_info, u32 tre_count)
 
 /* Release previously-reserved TRE entries to a channel */
 static void
-gsi_trans_tre_release(struct gsi_trans_info *trans_info, u32 tre_count)
+ipa_trans_tre_release(struct ipa_trans_info *trans_info, u32 tre_count)
 {
 	atomic_add(tre_count, &trans_info->tre_avail);
 }
 
 /* Allocate a GSI transaction on a channel */
-struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
+struct ipa_trans *ipa_channel_trans_alloc(struct ipa_dma *gsi, u32 channel_id,
 					  u32 tre_count,
 					  enum dma_data_direction direction)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
-	struct gsi_trans_info *trans_info;
-	struct gsi_trans *trans;
+	struct ipa_channel *channel = &gsi->channel[channel_id];
+	struct ipa_trans_info *trans_info;
+	struct ipa_trans *trans;
 
-	if (WARN_ON(tre_count > gsi_channel_trans_tre_max(gsi, channel_id)))
+	if (WARN_ON(tre_count > ipa_channel_trans_tre_max(gsi, channel_id)))
 		return NULL;
 
 	trans_info = &channel->trans_info;
@@ -337,18 +337,18 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	/* We reserve the TREs now, but consume them at commit time.
 	 * If there aren't enough available, we're done.
 	 */
-	if (!gsi_trans_tre_reserve(trans_info, tre_count))
+	if (!ipa_trans_tre_reserve(trans_info, tre_count))
 		return NULL;
 
 	/* Allocate and initialize non-zero fields in the the transaction */
-	trans = gsi_trans_pool_alloc(&trans_info->pool, 1);
-	trans->gsi = gsi;
+	trans = ipa_trans_pool_alloc(&trans_info->pool, 1);
+	trans->dma_subsys = gsi;
 	trans->channel_id = channel_id;
 	trans->tre_count = tre_count;
 	init_completion(&trans->completion);
 
 	/* Allocate the scatterlist and (if requested) info entries. */
-	trans->sgl = gsi_trans_pool_alloc(&trans_info->sg_pool, tre_count);
+	trans->sgl = ipa_trans_pool_alloc(&trans_info->sg_pool, tre_count);
 	sg_init_marker(trans->sgl, tre_count);
 
 	trans->direction = direction;
@@ -365,17 +365,17 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 }
 
 /* Free a previously-allocated transaction */
-void gsi_trans_free(struct gsi_trans *trans)
+void ipa_trans_free(struct ipa_trans *trans)
 {
 	refcount_t *refcount = &trans->refcount;
-	struct gsi_trans_info *trans_info;
+	struct ipa_trans_info *trans_info;
 	bool last;
 
 	/* We must hold the lock to release the last reference */
 	if (refcount_dec_not_one(refcount))
 		return;
 
-	trans_info = &trans->gsi->channel[trans->channel_id].trans_info;
+	trans_info = &trans->dma_subsys->channel[trans->channel_id].trans_info;
 
 	spin_lock_bh(&trans_info->spinlock);
 
@@ -394,11 +394,11 @@ void gsi_trans_free(struct gsi_trans *trans)
 	/* Releasing the reserved TREs implicitly frees the sgl[] and
 	 * (if present) info[] arrays, plus the transaction itself.
 	 */
-	gsi_trans_tre_release(trans_info, trans->tre_count);
+	ipa_trans_tre_release(trans_info, trans->tre_count);
 }
 
 /* Add an immediate command to a transaction */
-void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
+void ipa_trans_cmd_add(struct ipa_trans *trans, void *buf, u32 size,
 		       dma_addr_t addr, enum dma_data_direction direction,
 		       enum ipa_cmd_opcode opcode)
 {
@@ -415,7 +415,7 @@ void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
 	 *
 	 * When a transaction completes, the SGL is normally unmapped.
 	 * A command transaction has direction DMA_NONE, which tells
-	 * gsi_trans_complete() to skip the unmapping step.
+	 * ipa_trans_complete() to skip the unmapping step.
 	 *
 	 * The only things we use directly in a command scatter/gather
 	 * entry are the DMA address and length.  We still need the SG
@@ -433,7 +433,7 @@ void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
 }
 
 /* Add a page transfer to a transaction.  It will fill the only TRE. */
-int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
+int ipa_trans_page_add(struct ipa_trans *trans, struct page *page, u32 size,
 		       u32 offset)
 {
 	struct scatterlist *sg = &trans->sgl[0];
@@ -445,7 +445,7 @@ int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
 		return -EINVAL;
 
 	sg_set_page(sg, page, size, offset);
-	ret = dma_map_sg(trans->gsi->dev, sg, 1, trans->direction);
+	ret = dma_map_sg(trans->dma_subsys->dev, sg, 1, trans->direction);
 	if (!ret)
 		return -ENOMEM;
 
@@ -455,7 +455,7 @@ int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
 }
 
 /* Add an SKB transfer to a transaction.  No other TREs will be used. */
-int gsi_trans_skb_add(struct gsi_trans *trans, struct sk_buff *skb)
+int ipa_trans_skb_add(struct ipa_trans *trans, struct sk_buff *skb)
 {
 	struct scatterlist *sg = &trans->sgl[0];
 	u32 used;
@@ -472,7 +472,7 @@ int gsi_trans_skb_add(struct gsi_trans *trans, struct sk_buff *skb)
 		return ret;
 	used = ret;
 
-	ret = dma_map_sg(trans->gsi->dev, sg, used, trans->direction);
+	ret = dma_map_sg(trans->dma_subsys->dev, sg, used, trans->direction);
 	if (!ret)
 		return -ENOMEM;
 
@@ -539,9 +539,9 @@ static void gsi_trans_tre_fill(struct gsi_tre *dest_tre, dma_addr_t addr,
  * pending list.  Finally, updates the channel ring pointer and optionally
  * rings the doorbell.
  */
-static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
+static void __gsi_trans_commit(struct ipa_trans *trans, bool ring_db)
 {
-	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
+	struct ipa_channel *channel = &trans->dma_subsys->channel[trans->channel_id];
 	struct gsi_ring *ring = &channel->tre_ring;
 	enum ipa_cmd_opcode opcode = IPA_CMD_NONE;
 	bool bei = channel->toward_ipa;
@@ -590,28 +590,28 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 	/* Associate the last TRE with the transaction */
 	gsi_channel_trans_map(channel, ring->index - 1, trans);
 
-	gsi_trans_move_pending(trans);
+	ipa_trans_move_pending(trans);
 
 	/* Ring doorbell if requested, or if all TREs are allocated */
 	if (ring_db || !atomic_read(&channel->trans_info.tre_avail)) {
 		/* Report what we're handing off to hardware for TX channels */
 		if (channel->toward_ipa)
-			gsi_channel_tx_queued(channel);
+			ipa_channel_tx_queued(channel);
 		gsi_channel_doorbell(channel);
 	}
 }
 
 /* Commit a GSI transaction */
-void gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
+void ipa_trans_commit(struct ipa_trans *trans, bool ring_db)
 {
 	if (trans->used)
 		__gsi_trans_commit(trans, ring_db);
 	else
-		gsi_trans_free(trans);
+		ipa_trans_free(trans);
 }
 
 /* Commit a GSI transaction and wait for it to complete */
-void gsi_trans_commit_wait(struct gsi_trans *trans)
+void ipa_trans_commit_wait(struct ipa_trans *trans)
 {
 	if (!trans->used)
 		goto out_trans_free;
@@ -623,11 +623,11 @@ void gsi_trans_commit_wait(struct gsi_trans *trans)
 	wait_for_completion(&trans->completion);
 
 out_trans_free:
-	gsi_trans_free(trans);
+	ipa_trans_free(trans);
 }
 
 /* Commit a GSI transaction and wait for it to complete, with timeout */
-int gsi_trans_commit_wait_timeout(struct gsi_trans *trans,
+int ipa_trans_commit_wait_timeout(struct ipa_trans *trans,
 				  unsigned long timeout)
 {
 	unsigned long timeout_jiffies = msecs_to_jiffies(timeout);
@@ -643,34 +643,34 @@ int gsi_trans_commit_wait_timeout(struct gsi_trans *trans,
 	remaining = wait_for_completion_timeout(&trans->completion,
 						timeout_jiffies);
 out_trans_free:
-	gsi_trans_free(trans);
+	ipa_trans_free(trans);
 
 	return remaining ? 0 : -ETIMEDOUT;
 }
 
 /* Process the completion of a transaction; called while polling */
-void gsi_trans_complete(struct gsi_trans *trans)
+void ipa_trans_complete(struct ipa_trans *trans)
 {
 	/* If the entire SGL was mapped when added, unmap it now */
 	if (trans->direction != DMA_NONE)
-		dma_unmap_sg(trans->gsi->dev, trans->sgl, trans->used,
+		dma_unmap_sg(trans->dma_subsys->dev, trans->sgl, trans->used,
 			     trans->direction);
 
 	ipa_gsi_trans_complete(trans);
 
 	complete(&trans->completion);
 
-	gsi_trans_free(trans);
+	ipa_trans_free(trans);
 }
 
 /* Cancel a channel's pending transactions */
-void gsi_channel_trans_cancel_pending(struct gsi_channel *channel)
+void ipa_channel_trans_cancel_pending(struct ipa_channel *channel)
 {
-	struct gsi_trans_info *trans_info = &channel->trans_info;
-	struct gsi_trans *trans;
+	struct ipa_trans_info *trans_info = &channel->trans_info;
+	struct ipa_trans *trans;
 	bool cancelled;
 
-	/* channel->gsi->mutex is held by caller */
+	/* channel->dma_subsys->mutex is held by caller */
 	spin_lock_bh(&trans_info->spinlock);
 
 	cancelled = !list_empty(&trans_info->pending);
@@ -687,17 +687,17 @@ void gsi_channel_trans_cancel_pending(struct gsi_channel *channel)
 }
 
 /* Issue a command to read a single byte from a channel */
-int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr)
+int gsi_trans_read_byte(struct ipa_dma *gsi, u32 channel_id, dma_addr_t addr)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 	struct gsi_ring *ring = &channel->tre_ring;
-	struct gsi_trans_info *trans_info;
+	struct ipa_trans_info *trans_info;
 	struct gsi_tre *dest_tre;
 
 	trans_info = &channel->trans_info;
 
 	/* First reserve the TRE, if possible */
-	if (!gsi_trans_tre_reserve(trans_info, 1))
+	if (!ipa_trans_tre_reserve(trans_info, 1))
 		return -EBUSY;
 
 	/* Now fill the the reserved TRE and tell the hardware */
@@ -712,18 +712,18 @@ int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr)
 }
 
 /* Mark a gsi_trans_read_byte() request done */
-void gsi_trans_read_byte_done(struct gsi *gsi, u32 channel_id)
+void gsi_trans_read_byte_done(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct ipa_channel *channel = &gsi->channel[channel_id];
 
-	gsi_trans_tre_release(&channel->trans_info, 1);
+	ipa_trans_tre_release(&channel->trans_info, 1);
 }
 
 /* Initialize a channel's GSI transaction info */
-int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
+int ipa_channel_trans_init(struct ipa_dma *gsi, u32 channel_id)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
-	struct gsi_trans_info *trans_info;
+	struct ipa_channel *channel = &gsi->channel[channel_id];
+	struct ipa_trans_info *trans_info;
 	u32 tre_max;
 	int ret;
 
@@ -747,10 +747,10 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 	 * for transactions (including transaction structures) based on
 	 * this maximum number.
 	 */
-	tre_max = gsi_channel_tre_max(channel->gsi, channel_id);
+	tre_max = gsi_channel_tre_max(channel->dma_subsys, channel_id);
 
 	/* Transactions are allocated one at a time. */
-	ret = gsi_trans_pool_init(&trans_info->pool, sizeof(struct gsi_trans),
+	ret = ipa_trans_pool_init(&trans_info->pool, sizeof(struct ipa_trans),
 				  tre_max, 1);
 	if (ret)
 		goto err_kfree;
@@ -765,7 +765,7 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 	 * A transaction on a channel can allocate as many TREs as that but
 	 * no more.
 	 */
-	ret = gsi_trans_pool_init(&trans_info->sg_pool,
+	ret = ipa_trans_pool_init(&trans_info->sg_pool,
 				  sizeof(struct scatterlist),
 				  tre_max, channel->tlv_count);
 	if (ret)
@@ -789,7 +789,7 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 	return 0;
 
 err_trans_pool_exit:
-	gsi_trans_pool_exit(&trans_info->pool);
+	ipa_trans_pool_exit(&trans_info->pool);
 err_kfree:
 	kfree(trans_info->map);
 
@@ -799,12 +799,12 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 	return ret;
 }
 
-/* Inverse of gsi_channel_trans_init() */
-void gsi_channel_trans_exit(struct gsi_channel *channel)
+/* Inverse of ipa_channel_trans_init() */
+void ipa_channel_trans_exit(struct ipa_channel *channel)
 {
-	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct ipa_trans_info *trans_info = &channel->trans_info;
 
-	gsi_trans_pool_exit(&trans_info->sg_pool);
-	gsi_trans_pool_exit(&trans_info->pool);
+	ipa_trans_pool_exit(&trans_info->sg_pool);
+	ipa_trans_pool_exit(&trans_info->pool);
 	kfree(trans_info->map);
 }
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/ipa_trans.h
similarity index 72%
rename from drivers/net/ipa/gsi_trans.h
rename to drivers/net/ipa/ipa_trans.h
index 17fd1822d8a9..b93342414360 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/ipa_trans.h
@@ -18,12 +18,12 @@ struct scatterlist;
 struct device;
 struct sk_buff;
 
-struct gsi;
-struct gsi_trans;
-struct gsi_trans_pool;
+struct ipa_dma;
+struct ipa_trans;
+struct ipa_trans_pool;
 
 /**
- * struct gsi_trans - a GSI transaction
+ * struct ipa_trans - a GSI transaction
  *
  * Most fields in this structure for internal use by the transaction core code:
  * @links:	Links for channel transaction lists by state
@@ -45,10 +45,10 @@ struct gsi_trans_pool;
  * The size used for some fields in this structure were chosen to ensure
  * the full structure size is no larger than 128 bytes.
  */
-struct gsi_trans {
-	struct list_head links;		/* gsi_channel lists */
+struct ipa_trans {
+	struct list_head links;		/* ipa_channel lists */
 
-	struct gsi *gsi;
+	struct ipa_dma *dma_subsys;
 	u8 channel_id;
 
 	bool cancelled;			/* true if transaction was cancelled */
@@ -70,7 +70,7 @@ struct gsi_trans {
 };
 
 /**
- * gsi_trans_pool_init() - Initialize a pool of structures for transactions
+ * ipa_trans_pool_init() - Initialize a pool of structures for transactions
  * @pool:	GSI transaction poll pointer
  * @size:	Size of elements in the pool
  * @count:	Minimum number of elements in the pool
@@ -78,26 +78,26 @@ struct gsi_trans {
  *
  * Return:	0 if successful, or a negative error code
  */
-int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
+int ipa_trans_pool_init(struct ipa_trans_pool *pool, size_t size, u32 count,
 			u32 max_alloc);
 
 /**
- * gsi_trans_pool_alloc() - Allocate one or more elements from a pool
+ * ipa_trans_pool_alloc() - Allocate one or more elements from a pool
  * @pool:	Pool pointer
  * @count:	Number of elements to allocate from the pool
  *
  * Return:	Virtual address of element(s) allocated from the pool
  */
-void *gsi_trans_pool_alloc(struct gsi_trans_pool *pool, u32 count);
+void *ipa_trans_pool_alloc(struct ipa_trans_pool *pool, u32 count);
 
 /**
- * gsi_trans_pool_exit() - Inverse of gsi_trans_pool_init()
+ * ipa_trans_pool_exit() - Inverse of ipa_trans_pool_init()
  * @pool:	Pool pointer
  */
-void gsi_trans_pool_exit(struct gsi_trans_pool *pool);
+void ipa_trans_pool_exit(struct ipa_trans_pool *pool);
 
 /**
- * gsi_trans_pool_init_dma() - Initialize a pool of DMA-able structures
+ * ipa_trans_pool_init_dma() - Initialize a pool of DMA-able structures
  * @dev:	Device used for DMA
  * @pool:	Pool pointer
  * @size:	Size of elements in the pool
@@ -108,11 +108,11 @@ void gsi_trans_pool_exit(struct gsi_trans_pool *pool);
  *
  * Structures in this pool reside in DMA-coherent memory.
  */
-int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
+int ipa_trans_pool_init_dma(struct device *dev, struct ipa_trans_pool *pool,
 			    size_t size, u32 count, u32 max_alloc);
 
 /**
- * gsi_trans_pool_alloc_dma() - Allocate an element from a DMA pool
+ * ipa_trans_pool_alloc_dma() - Allocate an element from a DMA pool
  * @pool:	DMA pool pointer
  * @addr:	DMA address "handle" associated with the allocation
  *
@@ -120,17 +120,17 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
  *
  * Only one element at a time may be allocated from a DMA pool.
  */
-void *gsi_trans_pool_alloc_dma(struct gsi_trans_pool *pool, dma_addr_t *addr);
+void *ipa_trans_pool_alloc_dma(struct ipa_trans_pool *pool, dma_addr_t *addr);
 
 /**
- * gsi_trans_pool_exit_dma() - Inverse of gsi_trans_pool_init_dma()
+ * ipa_trans_pool_exit_dma() - Inverse of ipa_trans_pool_init_dma()
  * @dev:	Device used for DMA
  * @pool:	Pool pointer
  */
-void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool);
+void ipa_trans_pool_exit_dma(struct device *dev, struct ipa_trans_pool *pool);
 
 /**
- * gsi_channel_trans_alloc() - Allocate a GSI transaction on a channel
+ * ipa_channel_trans_alloc() - Allocate a GSI transaction on a channel
  * @gsi:	GSI pointer
  * @channel_id:	Channel the transaction is associated with
  * @tre_count:	Number of elements in the transaction
@@ -139,18 +139,18 @@ void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool);
  * Return:	A GSI transaction structure, or a null pointer if all
  *		available transactions are in use
  */
-struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
+struct ipa_trans *ipa_channel_trans_alloc(struct ipa_dma *dma_subsys, u32 channel_id,
 					  u32 tre_count,
 					  enum dma_data_direction direction);
 
 /**
- * gsi_trans_free() - Free a previously-allocated GSI transaction
+ * ipa_trans_free() - Free a previously-allocated GSI transaction
  * @trans:	Transaction to be freed
  */
-void gsi_trans_free(struct gsi_trans *trans);
+void ipa_trans_free(struct ipa_trans *trans);
 
 /**
- * gsi_trans_cmd_add() - Add an immediate command to a transaction
+ * ipa_trans_cmd_add() - Add an immediate command to a transaction
  * @trans:	Transaction
  * @buf:	Buffer pointer for command payload
  * @size:	Number of bytes in buffer
@@ -158,50 +158,50 @@ void gsi_trans_free(struct gsi_trans *trans);
  * @direction:	Direction of DMA transfer (or DMA_NONE if none required)
  * @opcode:	IPA immediate command opcode
  */
-void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
+void ipa_trans_cmd_add(struct ipa_trans *trans, void *buf, u32 size,
 		       dma_addr_t addr, enum dma_data_direction direction,
 		       enum ipa_cmd_opcode opcode);
 
 /**
- * gsi_trans_page_add() - Add a page transfer to a transaction
+ * ipa_trans_page_add() - Add a page transfer to a transaction
  * @trans:	Transaction
  * @page:	Page pointer
  * @size:	Number of bytes (starting at offset) to transfer
  * @offset:	Offset within page for start of transfer
  */
-int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
+int ipa_trans_page_add(struct ipa_trans *trans, struct page *page, u32 size,
 		       u32 offset);
 
 /**
- * gsi_trans_skb_add() - Add a socket transfer to a transaction
+ * ipa_trans_skb_add() - Add a socket transfer to a transaction
  * @trans:	Transaction
  * @skb:	Socket buffer for transfer (outbound)
  *
  * Return:	0, or -EMSGSIZE if socket data won't fit in transaction.
  */
-int gsi_trans_skb_add(struct gsi_trans *trans, struct sk_buff *skb);
+int ipa_trans_skb_add(struct ipa_trans *trans, struct sk_buff *skb);
 
 /**
- * gsi_trans_commit() - Commit a GSI transaction
+ * ipa_trans_commit() - Commit a GSI transaction
  * @trans:	Transaction to commit
  * @ring_db:	Whether to tell the hardware about these queued transfers
  */
-void gsi_trans_commit(struct gsi_trans *trans, bool ring_db);
+void ipa_trans_commit(struct ipa_trans *trans, bool ring_db);
 
 /**
- * gsi_trans_commit_wait() - Commit a GSI transaction and wait for it
+ * ipa_trans_commit_wait() - Commit a GSI transaction and wait for it
  *			     to complete
  * @trans:	Transaction to commit
  */
-void gsi_trans_commit_wait(struct gsi_trans *trans);
+void ipa_trans_commit_wait(struct ipa_trans *trans);
 
 /**
- * gsi_trans_commit_wait_timeout() - Commit a GSI transaction and wait for
+ * ipa_trans_commit_wait_timeout() - Commit a GSI transaction and wait for
  *				     it to complete, with timeout
  * @trans:	Transaction to commit
  * @timeout:	Timeout period (in milliseconds)
  */
-int gsi_trans_commit_wait_timeout(struct gsi_trans *trans,
+int ipa_trans_commit_wait_timeout(struct ipa_trans *trans,
 				  unsigned long timeout);
 
 /**
@@ -213,7 +213,7 @@ int gsi_trans_commit_wait_timeout(struct gsi_trans *trans,
  * This is not a transaction operation at all.  It's defined here because
  * it needs to be done in coordination with other transaction activity.
  */
-int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr);
+int gsi_trans_read_byte(struct ipa_dma *dma_subsys, u32 channel_id, dma_addr_t addr);
 
 /**
  * gsi_trans_read_byte_done() - Clean up after a single byte read TRE
@@ -223,6 +223,6 @@ int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr);
  * This function needs to be called to signal that the work related
  * to reading a byte initiated by gsi_trans_read_byte() is complete.
  */
-void gsi_trans_read_byte_done(struct gsi *gsi, u32 channel_id);
+void gsi_trans_read_byte_done(struct ipa_dma *dma_subsys, u32 channel_id);
 
 #endif /* _GSI_TRANS_H_ */
-- 
2.33.0

