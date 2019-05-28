Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D142C68C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfE1Mbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:38 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:59003 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727137AbfE1MbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id ECEED2681;
        Tue, 28 May 2019 08:23:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:23:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=8TPYFfKcg+rg8gyxt30BGw5/ULadK2q8uQaDW/jQW10=; b=EW6LSPG7
        NQXxwr+S89nGrx5Emq5ZcdnGS3Y5i6sVbcaI4eqh0dGMEpsE53yKapMRxCJR0hw+
        +y/pTgxti31nTRfKLW3nqtYWTNot2Gfn5e4sWS7DJ/KThmURpiMc0gscLNa5SvBy
        2sLHKydfPxdN3JfEMIB9F+eBAM5A2YHOSSAIVypqCNKpko5301mpSN0KhoXV3ABP
        nuBKU/UVpez2bjj2mvOBl/06HatA0gImALq/ZLLxgXvKCshRa+z+j+jbX9n+CTjH
        jGxHbyukJwWcxDlwnxpW4R8/QbBwbn+1bUTG9txt+tol6+dj56/9d7qgVAQ1R805
        GZ8+L+kpzrnM4A==
X-ME-Sender: <xms:JSjtXAnXdyU9qRHn4kTLe2O1C_i9BEfrl0kR7HV5ffTfKmOCnyfW4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeel
X-ME-Proxy: <xmx:JSjtXHMbjbc7FO8coJihTGxm-N8155XS_ZMETLU_obWzGblCC3jAMA>
    <xmx:JSjtXEMGkPQxiY780qKU2NbM1LeR2ZhRN9yL1OqpSX3Km9MUmFbXJQ>
    <xmx:JSjtXIi4-lEr0h13UHCJX9tvh9bt4mH-nZb1KlURLJeNQBMiL5tXcA>
    <xmx:JSjtXPtUgZH_OUhIqLCWYTRuPwC-9N8X9JtfZ1ZbZ35_lA7a9ybo3w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5346838008A;
        Tue, 28 May 2019 08:22:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 11/12] mlxsw: Add trap group for layer 2 discards
Date:   Tue, 28 May 2019 15:21:35 +0300
Message-Id: <20190528122136.30476-12-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
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
index b4c9c7edd866..47896f86e057 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5292,6 +5292,14 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_MLD,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR,
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

