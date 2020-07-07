Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD3221668B
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 08:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgGGGiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 02:38:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57520 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGGiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 02:38:51 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jshFb-0005om-1g; Tue, 07 Jul 2020 06:38:43 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     irusskikh@marvell.com
Cc:     anthony.wong@canonical.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikita Danilov <ndanilov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>,
        netdev@vger.kernel.org (open list:AQUANTIA ETHERNET DRIVER (atlantic)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: atlantic: Add support for firmware v4
Date:   Tue,  7 Jul 2020 14:38:28 +0800
Message-Id: <20200707063830.15645-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a new ethernet card that is supported by the atlantic driver:
01:00.0 Ethernet controller [0200]: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz Ethernet Controller [AQtion] [1d6a:07b1] (rev 02)

But the driver failed to probe the device:
kernel: atlantic: Bad FW version detected: 400001e
kernel: atlantic: probe of 0000:01:00.0 failed with error -95

As a pure guesswork, simply adding the firmware version to the driver
can make it function. Doing iperf3 as a smoketest doesn't show any
abnormality either.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 73c0f41df8d8..0b4cd1c0e022 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -46,6 +46,7 @@
 #define HW_ATL_FW_VER_1X 0x01050006U
 #define HW_ATL_FW_VER_2X 0x02000000U
 #define HW_ATL_FW_VER_3X 0x03000000U
+#define HW_ATL_FW_VER_4X 0x0400001EU
 
 #define FORCE_FLASHLESS 0
 
@@ -81,6 +82,9 @@ int hw_atl_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
 	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_3X,
 					  self->fw_ver_actual) == 0) {
 		*fw_ops = &aq_fw_2x_ops;
+	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_4X,
+					  self->fw_ver_actual) == 0) {
+		*fw_ops = &aq_fw_2x_ops;
 	} else {
 		aq_pr_err("Bad FW version detected: %x\n",
 			  self->fw_ver_actual);
-- 
2.17.1

