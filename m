Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F22176D47
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgCCDC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 22:02:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbgCCCqq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:46:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD7942465E;
        Tue,  3 Mar 2020 02:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203605;
        bh=8H8u9Jdm4LXU8U5wy3ICUDTpKOuA7hqVpkDvPwmyKTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLc+uamvuRQ9oBSJfdTOF/HUngnuIC3R21JtXtZv0ZICjH8HZwhRHYEtGrE1hRxP2
         ghe7e41QmJzsOT3VfvAXsSe2udXSKxWBovkeZp3a9bfhhfMS80WjOJVAHAPyg3bY4L
         xWQscB4T57hyr83XgoWgFxpzpkEwdjOnI6Qlvy3w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Egor Pomozov <epomozov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 24/66] net: atlantic: ptp gpio adjustments
Date:   Mon,  2 Mar 2020 21:45:33 -0500
Message-Id: <20200303024615.8889-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

[ Upstream commit f08a464c27ca0a4050333baa271504b27ce834b7 ]

Clock adjustment data should be passed to FW as well, otherwise in some
cases a drift was observed when using GPIO features.

Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h       |  2 ++
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c    |  4 +++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c     | 12 ++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index cc70c606b6ef2..251767c31f7e5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -337,6 +337,8 @@ struct aq_fw_ops {
 
 	void (*enable_ptp)(struct aq_hw_s *self, int enable);
 
+	void (*adjust_ptp)(struct aq_hw_s *self, uint64_t adj);
+
 	int (*set_eee_rate)(struct aq_hw_s *self, u32 speed);
 
 	int (*get_eee_rate)(struct aq_hw_s *self, u32 *rate,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 5784da26f8683..9acdb3fbb750d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1162,6 +1162,8 @@ static int hw_atl_b0_adj_sys_clock(struct aq_hw_s *self, s64 delta)
 {
 	self->ptp_clk_offset += delta;
 
+	self->aq_fw_ops->adjust_ptp(self, self->ptp_clk_offset);
+
 	return 0;
 }
 
@@ -1212,7 +1214,7 @@ static int hw_atl_b0_gpio_pulse(struct aq_hw_s *self, u32 index,
 	fwreq.ptp_gpio_ctrl.index = index;
 	fwreq.ptp_gpio_ctrl.period = period;
 	/* Apply time offset */
-	fwreq.ptp_gpio_ctrl.start = start - self->ptp_clk_offset;
+	fwreq.ptp_gpio_ctrl.start = start;
 
 	size = sizeof(fwreq.msg_id) + sizeof(fwreq.ptp_gpio_ctrl);
 	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 97ebf849695fd..77a4ed64830fd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -30,6 +30,9 @@
 #define HW_ATL_FW3X_EXT_CONTROL_ADDR     0x378
 #define HW_ATL_FW3X_EXT_STATE_ADDR       0x37c
 
+#define HW_ATL_FW3X_PTP_ADJ_LSW_ADDR	 0x50a0
+#define HW_ATL_FW3X_PTP_ADJ_MSW_ADDR	 0x50a4
+
 #define HW_ATL_FW2X_CAP_PAUSE            BIT(CAPS_HI_PAUSE)
 #define HW_ATL_FW2X_CAP_ASYM_PAUSE       BIT(CAPS_HI_ASYMMETRIC_PAUSE)
 #define HW_ATL_FW2X_CAP_SLEEP_PROXY      BIT(CAPS_HI_SLEEP_PROXY)
@@ -475,6 +478,14 @@ static void aq_fw3x_enable_ptp(struct aq_hw_s *self, int enable)
 	aq_hw_write_reg(self, HW_ATL_FW3X_EXT_CONTROL_ADDR, ptp_opts);
 }
 
+static void aq_fw3x_adjust_ptp(struct aq_hw_s *self, uint64_t adj)
+{
+	aq_hw_write_reg(self, HW_ATL_FW3X_PTP_ADJ_LSW_ADDR,
+			(adj >>  0) & 0xffffffff);
+	aq_hw_write_reg(self, HW_ATL_FW3X_PTP_ADJ_MSW_ADDR,
+			(adj >> 32) & 0xffffffff);
+}
+
 static int aq_fw2x_led_control(struct aq_hw_s *self, u32 mode)
 {
 	if (self->fw_ver_actual < HW_ATL_FW_VER_LED)
@@ -633,4 +644,5 @@ const struct aq_fw_ops aq_fw_2x_ops = {
 	.enable_ptp         = aq_fw3x_enable_ptp,
 	.led_control        = aq_fw2x_led_control,
 	.set_phyloopback    = aq_fw2x_set_phyloopback,
+	.adjust_ptp         = aq_fw3x_adjust_ptp,
 };
-- 
2.20.1

