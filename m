Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7D5A677B
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiH3Pcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiH3Pcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:32:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADDF132878;
        Tue, 30 Aug 2022 08:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661873566; x=1693409566;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wF2OBDPt2Ft27xCiIuYwAHrKL7uD/dDMqHyZHn/gTDg=;
  b=SbqmP6ly5zp4rABdbaObCQIqiNTAsA987MH/0kgsyoWEmCtf46GfXmPw
   2yvTZ3+wF4Dm6lHGjGvptX/DRHi/c26jaHVvthE4gbczaQAojJZ7Iw/Ct
   fikJ++ngCcpc2LnCDaGAZa67ZpSqqPCDhYpsz2+ldNKhZoPvaE+jC63+G
   OfrZGPm6JAwVJ5gH0+sKr+IbdpzTkpN4cravK351dn+PHMb3OYWkafDeZ
   LNnqzJKvUBerGjZAqcT5/+omy40AJXtQ6lOaVAIw67aGFXNTdoSFVUxMF
   Y51FO21PeKluQoOFe9EkO8OKH9b/bmoN+QK5h4NUfggXcuXoiygrw3KHr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="275607531"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="275607531"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 08:32:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="754070151"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 30 Aug 2022 08:32:36 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 4C64D1C3; Tue, 30 Aug 2022 18:32:51 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Subject: [PATCH 4/5] net: thunderbolt: Enable full end-to-end flow control
Date:   Tue, 30 Aug 2022 18:32:49 +0300
Message-Id: <20220830153250.15496-5-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
References: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB4NET protocol allows the networking drivers to take advantage of
end-to-end flow control supported by the USB4 host interface. This
should prevent the receiving side from dropping network packets.

In adddition add a module parameter that can be used to turn this off
just in case it causes problems.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index ab3f04562980..8e272d2a61e5 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -30,6 +30,7 @@
 #define TBNET_RING_SIZE		256
 #define TBNET_LOGIN_RETRIES	60
 #define TBNET_LOGOUT_RETRIES	10
+#define TBNET_E2E		BIT(0)
 #define TBNET_MATCH_FRAGS_ID	BIT(1)
 #define TBNET_64K_FRAMES	BIT(2)
 #define TBNET_MAX_MTU		SZ_64K
@@ -209,6 +210,10 @@ static const uuid_t tbnet_svc_uuid =
 
 static struct tb_property_dir *tbnet_dir;
 
+static bool tbnet_e2e = true;
+module_param_named(e2e, tbnet_e2e, bool, 0444);
+MODULE_PARM_DESC(e2e, "USB4NET full end-to-end flow control (default: true)");
+
 static void tbnet_fill_header(struct thunderbolt_ip_header *hdr, u64 route,
 	u8 sequence, const uuid_t *initiator_uuid, const uuid_t *target_uuid,
 	enum thunderbolt_ip_type type, size_t size, u32 command_id)
@@ -873,6 +878,7 @@ static int tbnet_open(struct net_device *dev)
 	struct tb_xdomain *xd = net->xd;
 	u16 sof_mask, eof_mask;
 	struct tb_ring *ring;
+	unsigned int flags;
 	int hopid;
 
 	netif_carrier_off(dev);
@@ -897,9 +903,14 @@ static int tbnet_open(struct net_device *dev)
 	sof_mask = BIT(TBIP_PDF_FRAME_START);
 	eof_mask = BIT(TBIP_PDF_FRAME_END);
 
-	ring = tb_ring_alloc_rx(xd->tb->nhi, -1, TBNET_RING_SIZE,
-				RING_FLAG_FRAME, 0, sof_mask, eof_mask,
-				tbnet_start_poll, net);
+	flags = RING_FLAG_FRAME;
+	/* Only enable full E2E if the other end supports it too */
+	if (tbnet_e2e && net->svc->prtcstns & TBNET_E2E)
+		flags |= RING_FLAG_E2E;
+
+	ring = tb_ring_alloc_rx(xd->tb->nhi, -1, TBNET_RING_SIZE, flags,
+				net->tx_ring.ring->hop, sof_mask,
+				eof_mask, tbnet_start_poll, net);
 	if (!ring) {
 		netdev_err(dev, "failed to allocate Rx ring\n");
 		tb_ring_free(net->tx_ring.ring);
@@ -1362,6 +1373,7 @@ static struct tb_service_driver tbnet_driver = {
 
 static int __init tbnet_init(void)
 {
+	unsigned int flags;
 	int ret;
 
 	tbnet_dir = tb_property_create_dir(&tbnet_dir_uuid);
@@ -1371,12 +1383,11 @@ static int __init tbnet_init(void)
 	tb_property_add_immediate(tbnet_dir, "prtcid", 1);
 	tb_property_add_immediate(tbnet_dir, "prtcvers", 1);
 	tb_property_add_immediate(tbnet_dir, "prtcrevs", 1);
-	/* Currently only announce support for match frags ID (bit 1). Bit 0
-	 * is reserved for full E2E flow control which we do not support at
-	 * the moment.
-	 */
-	tb_property_add_immediate(tbnet_dir, "prtcstns",
-				  TBNET_MATCH_FRAGS_ID | TBNET_64K_FRAMES);
+
+	flags = TBNET_MATCH_FRAGS_ID | TBNET_64K_FRAMES;
+	if (tbnet_e2e)
+		flags |= TBNET_E2E;
+	tb_property_add_immediate(tbnet_dir, "prtcstns", flags);
 
 	ret = tb_register_property_dir("network", tbnet_dir);
 	if (ret) {
-- 
2.35.1

