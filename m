Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD63161455
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfGGIAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:00:17 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:55093 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:00:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7E9862770;
        Sun,  7 Jul 2019 04:00:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=IaBjeI75X49HyHxIj7D4X98hIWZkwE5IIOUlGh2++/I=; b=NZ+LpI/a
        IBmxofN2cmhNMMw/uVtGe94mztAoJgazUQubIxtBU6QP+iuzwtcKlc9Jc4777jxw
        a+h4HQCy/gWBqY+ZcnaldZ9Os97QHLPnI4tB2Ennf/wXfCdJG7prNw5QmlfVL6i9
        7b292Hil7t0+27Xi3jyOcOOAKCMVXlYhNt8fPq3ucoBQNu6ZAzSX0ERBFPKWoSmd
        VHHr3SnMsWgpv9O6+L4f4bkyvN6tY/wffDygFHEtKH/mrZfU1axSRcNwJubD+OKq
        33EzeF4ysiuBtPWJeYB4uJLzjUdsmETmhbPvsMuT3yAWUT8OYPBIV197/BMplMW1
        HcriOIJrThN9Hw==
X-ME-Sender: <xms:kKYhXU0Zl3yC35iq6aHyE2jIz0356mCzObejDgCltusnWH4ybo-3_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:kKYhXcfqjDwC9vSy08FyiQx_L-5fFJI_Rr0ZPc028rvq5wD46xNG-w>
    <xmx:kKYhXY61RDlYFu3WnI-qh5sTE6NpqcrZ8-cQZg4nIsKFQy_J2LNHcw>
    <xmx:kKYhXRhkEUJ8vjUc7uLEdkB6Xzg-utl-MD3z5c39n3WPIe7LnBO5Bw>
    <xmx:kKYhXWfAMVp9WKwQKTfEHO-g1VjJ8B156VZbkm_QJNJfLaN4mN57nw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0ADE380084;
        Sun,  7 Jul 2019 04:00:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/11] mlxsw: Add trap group for layer 2 discards
Date:   Sun,  7 Jul 2019 10:58:27 +0300
Message-Id: <20190707075828.3315-11-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Discard trap groups are defined in a different enum so that they could
all share the same policer ID: MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 55211218ec1a..22138d15079f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5422,6 +5422,14 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
+
+	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
+	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
+};
+
+enum mlxsw_reg_htgt_discard_trap_group {
+	MLXSW_REG_HTGT_DISCARD_TRAP_GROUP_BASE = MLXSW_REG_HTGT_TRAP_GROUP_MAX,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 };
 
 /* reg_htgt_trap_group
-- 
2.20.1

