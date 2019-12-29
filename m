Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F57D12C257
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfL2Lsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 06:48:54 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55125 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbfL2Lsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 06:48:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 01F1621E50;
        Sun, 29 Dec 2019 06:48:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Dec 2019 06:48:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ucY23S/cPAFPu/ZYer2Gd2/y753lCSfnNXfEBZ2NM5U=; b=i1TaSLTM
        a2fUSha4PjsliOBA+MLht3mMIKEaTm5NdkTVsr4B8f04xvxRAk6ww7G2BdBfFAWe
        x52LGu+uyV39h7128L6jhUKuNPgSxCxJaliAK/nLhXoBXLP96onD9Ja7Fc4xrhcZ
        y8cImtLYPJZ2yZ69kTGjTwTMlxX/G8hhYfaH3Ite1fLTPn1KFg+p6T3QIJ6RottF
        FxEEVDR1uWBOtyxh3uWWsy3yrGPf+cJvGcgclXqEl+KdHPcssXH+FQxcq6Hk9uFb
        jWpxICaD4RF6P90C8aJcpRshva91bsLi3qRIiXa7XPe5+rkoa5U6tobdT0LAxKdz
        2Zp95C/dX0/8FA==
X-ME-Sender: <xms:pJIIXgg7LbKzeN7tdxyB1nnc9oL59HLJOWg0EPVwPfuBby-OdYVTQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddriedurdduudejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:pJIIXtRH0Hz52-PiJ_E0GyJJdlLFAVIo_1fEwItPM5eRAjtd1Si2hw>
    <xmx:pJIIXjH6URZx_zBln6Js9CNWCJrKrqFoRDTr568kRZNZY98sK9Wa_Q>
    <xmx:pJIIXlmW2lkSM_AoU_1igOK_YY0VoFa2hI7DmpgXUApD_3u4ajBDkQ>
    <xmx:pJIIXnii6LckgNhU7I0KTBaOb5UIFDG4si92vOLAB2qJmjQpGmS84g>
Received: from splinter.mtl.com (bzq-79-181-61-117.red.bezeqint.net [79.181.61.117])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5FAE93060A32;
        Sun, 29 Dec 2019 06:48:51 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/3] mlxsw: reg: Add QoS Port DSCP to Priority Mapping Register
Date:   Sun, 29 Dec 2019 13:48:27 +0200
Message-Id: <20191229114829.61803-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229114829.61803-1-idosch@idosch.org>
References: <20191229114829.61803-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add QPDP. This register controls the port default Switch Priority and
Color. The default Switch Priority and Color are used for frames where the
trust state uses default values. Currently there are two cases where this
applies: a port is in trust-PCP state, but a packet arrives untagged; and a
port is in trust-DSCP state, but a non-IP packet arrives.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 33 +++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 86a2d575ae73..c343f5203e93 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3748,6 +3748,38 @@ mlxsw_reg_qpdsm_prio_pack(char *payload, unsigned short prio, u8 dscp)
 	mlxsw_reg_qpdsm_prio_entry_color2_dscp_set(payload, prio, dscp);
 }
 
+/* QPDP - QoS Port DSCP to Priority Mapping Register
+ * -------------------------------------------------
+ * This register controls the port default Switch Priority and Color. The
+ * default Switch Priority and Color are used for frames where the trust state
+ * uses default values. All member ports of a LAG should be configured with the
+ * same default values.
+ */
+#define MLXSW_REG_QPDP_ID 0x4007
+#define MLXSW_REG_QPDP_LEN 0x8
+
+MLXSW_REG_DEFINE(qpdp, MLXSW_REG_QPDP_ID, MLXSW_REG_QPDP_LEN);
+
+/* reg_qpdp_local_port
+ * Local Port. Supported for data packets from CPU port.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, qpdp, local_port, 0x00, 16, 8);
+
+/* reg_qpdp_switch_prio
+ * Default port Switch Priority (default 0)
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qpdp, switch_prio, 0x04, 0, 4);
+
+static inline void mlxsw_reg_qpdp_pack(char *payload, u8 local_port,
+				       u8 switch_prio)
+{
+	MLXSW_REG_ZERO(qpdp, payload);
+	mlxsw_reg_qpdp_local_port_set(payload, local_port);
+	mlxsw_reg_qpdp_switch_prio_set(payload, switch_prio);
+}
+
 /* QPDPM - QoS Port DSCP to Priority Mapping Register
  * --------------------------------------------------
  * This register controls the mapping from DSCP field to
@@ -10579,6 +10611,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(qeec),
 	MLXSW_REG(qrwe),
 	MLXSW_REG(qpdsm),
+	MLXSW_REG(qpdp),
 	MLXSW_REG(qpdpm),
 	MLXSW_REG(qtctm),
 	MLXSW_REG(qpsc),
-- 
2.24.1

