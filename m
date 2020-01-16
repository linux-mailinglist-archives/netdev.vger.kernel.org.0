Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F79613F81E
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437663AbgAPTPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733115AbgAPQzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1EE2467E;
        Thu, 16 Jan 2020 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193755;
        bh=jPadxU3bIAKq2rzDSYyu4zF/hz9uIqRi/y4LlM9n1g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMu7F657d7LPT29+n0CAqHT2sstpq86xYDms34bo8KcUAbg+Glq0QAsOxPIzvnhnc
         3X0CmOY+Tk3wG2z2/TCPW+5phjjtRvBq7kAsF+P70ZvbenVxZ1IM1vQo32B9lj6EJ2
         G81bWeEj/5FbKvd+W4v7ECnUMbJlxW0aOs1ZlYLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 043/671] mlxsw: reg: QEEC: Add minimum shaper fields
Date:   Thu, 16 Jan 2020 11:44:34 -0500
Message-Id: <20200116165502.8838-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 8b931821aa04823e2e5df0ae93937baabbd23286 ]

Add QEEC.mise (minimum shaper enable) and QEEC.min_shaper_rate to enable
configuration of minimum shaper.

Increase the QEEC length to 0x20 as well: that's the length that the
register has had for a long time now, but with the configurations that
mlxsw typically exercises, the firmware tolerated 0x1C-sized packets.
With mise=true however, FW rejects packets unless they have the full
required length.

Fixes: b9b7cee40579 ("mlxsw: reg: Add QoS ETS Element Configuration register")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index aee58b3892f2..c9895876a231 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3215,7 +3215,7 @@ static inline void mlxsw_reg_qtct_pack(char *payload, u8 local_port,
  * Configures the ETS elements.
  */
 #define MLXSW_REG_QEEC_ID 0x400D
-#define MLXSW_REG_QEEC_LEN 0x1C
+#define MLXSW_REG_QEEC_LEN 0x20
 
 MLXSW_REG_DEFINE(qeec, MLXSW_REG_QEEC_ID, MLXSW_REG_QEEC_LEN);
 
@@ -3257,6 +3257,15 @@ MLXSW_ITEM32(reg, qeec, element_index, 0x04, 0, 8);
  */
 MLXSW_ITEM32(reg, qeec, next_element_index, 0x08, 0, 8);
 
+/* reg_qeec_mise
+ * Min shaper configuration enable. Enables configuration of the min
+ * shaper on this ETS element
+ * 0 - Disable
+ * 1 - Enable
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qeec, mise, 0x0C, 31, 1);
+
 enum {
 	MLXSW_REG_QEEC_BYTES_MODE,
 	MLXSW_REG_QEEC_PACKETS_MODE,
@@ -3273,6 +3282,17 @@ enum {
  */
 MLXSW_ITEM32(reg, qeec, pb, 0x0C, 28, 1);
 
+/* The smallest permitted min shaper rate. */
+#define MLXSW_REG_QEEC_MIS_MIN	200000		/* Kbps */
+
+/* reg_qeec_min_shaper_rate
+ * Min shaper information rate.
+ * For CPU port, can only be configured for port hierarchy.
+ * When in bytes mode, value is specified in units of 1000bps.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qeec, min_shaper_rate, 0x0C, 0, 28);
+
 /* reg_qeec_mase
  * Max shaper configuration enable. Enables configuration of the max
  * shaper on this ETS element.
-- 
2.20.1

