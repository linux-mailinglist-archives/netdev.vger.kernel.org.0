Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F2C21F3C2
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgGNOVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:38 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46647 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgGNOVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E0A4C5C010B;
        Tue, 14 Jul 2020 10:21:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=jteTrdyBZYS6yybaMocQCb9Cc/PUFSfLG/0GbkzJGAM=; b=ctpl2exB
        +whHsK6n1t7VwHs5FrzBEvozZ+nkpOfWlJBcHxADfPCMUfhPpHvgwmcIeruZHJtg
        t+B9+igzsrRZ+U5hy76gWD05ronvuvAP1BbG5078zRf7MLv+9PAz0fnEJQh/Byo+
        yN2ikmAIY396E7y93Oc72QOcecuVfvEnNljXuDY6P+PxhgpQXi4FUZsPC2TqS2cP
        VC/3tEZtNCzq9OmR9Hhxza6LHBCDmVbq4SWYwXUUgTxZGChcXHIUMGCe0U76Ez1o
        Zo83OWTptvQz6IET3YVmlv3K0wOz0dLJxs/enIhdMdGf91PSGEuwKrM5DSY434/A
        Zr2rd2LcqtSkWg==
X-ME-Sender: <xms:br8NX3u2mo9KNRMFHcqo3sJy5Kwg36Gwa8Se3o5fVLkJi9P_2GcmRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:br8NX4dQLFCPocj9_FwzQUJkMnnbhKbkYGd_InpFV958AFnqJfnm-Q>
    <xmx:br8NX6zrCznxG_ZYvsPLIFvoI0YK5uuMkFMO6a-YOS_wtjAUMRgK-g>
    <xmx:br8NX2NMQ6-yfMgo9_sFiqKYkJ_RQTDOx3kIhqvus7KJypJmMI2q-Q>
    <xmx:br8NX6al1XUMlP6BR7OLJKK5nX6xsYgfkIfxqkMeJFdEaikz3c0Ohw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02E1330600B1;
        Tue, 14 Jul 2020 10:21:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/13] mlxsw: reg: Add session_id and pid to MPAT register
Date:   Tue, 14 Jul 2020 17:20:54 +0300
Message-Id: <20200714142106.386354-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Allow setting session_id and pid as part of port analyzer
configurations.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 76f61bef03f8..e460d9d05d81 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8662,6 +8662,13 @@ MLXSW_REG_DEFINE(mpat, MLXSW_REG_MPAT_ID, MLXSW_REG_MPAT_LEN);
  */
 MLXSW_ITEM32(reg, mpat, pa_id, 0x00, 28, 4);
 
+/* reg_mpat_session_id
+ * Mirror Session ID.
+ * Used for MIRROR_SESSION<i> trap.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mpat, session_id, 0x00, 24, 4);
+
 /* reg_mpat_system_port
  * A unique port identifier for the final destination of the packet.
  * Access: RW
@@ -8719,6 +8726,18 @@ enum mlxsw_reg_mpat_span_type {
  */
 MLXSW_ITEM32(reg, mpat, span_type, 0x04, 0, 4);
 
+/* reg_mpat_pide
+ * Policer enable.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mpat, pide, 0x0C, 15, 1);
+
+/* reg_mpat_pid
+ * Policer ID.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mpat, pid, 0x0C, 0, 14);
+
 /* Remote SPAN - Ethernet VLAN
  * - - - - - - - - - - - - - -
  */
-- 
2.26.2

