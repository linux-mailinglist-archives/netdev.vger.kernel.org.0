Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCEF4B248
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbfFSGmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:42:00 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41175 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731111AbfFSGmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:42:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2DD9021B84;
        Wed, 19 Jun 2019 02:41:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 02:41:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=yIoUglq8+/ViaISYhV8oazjuF9rzqsZE+c/BM7gBtyw=; b=vUhsmf9S
        fKZjgUb0sx5wvK358d7qu+NEpsttdbHEBK+rCja4Iq80yEgVdlYQ0G5pglf8EkCO
        fh4+8K9XZmeA0EsmNwG+4VD8QRQt2owZWMcbDygpq6GdE9KT3NIW76urcG1dfIo2
        EgfogvpwZTv0V2ct58/vkQMlGfsAlrN8JSzdXDc51Y8W97jTdrQF/jR9/8fqdGfx
        q+KKNf7GGkcXWuFN6pWk0o4C8OcU5GGXePxfPR1Jw6PFWqYelo4M74lP/FnzzQLE
        xMMTk3dOn5jFbdcNmVz/CcEn+k4HFS0nB/41H95PwkzC9+lyomeqpdWT772MXvdP
        xJM483SNTzwm6g==
X-ME-Sender: <xms:NtkJXf4_Oqav-vybQBlgopWY33McoJmr5E1OW-chh7p_cZkvovF2ew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddugdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:N9kJXb4zosElm1zPM-MXUvd-IXk3JGBWYwmMyLgI9y9yAwoS-iRj6Q>
    <xmx:N9kJXbfJnhGBWscort7uK7MES0ARGGkaamSCjcn52N2yDjodYs3Cpg>
    <xmx:N9kJXfBaqqmF4FjZClpRGJpycGpOBBU5Djle1MZUCqSlWGD-mKnD2w>
    <xmx:N9kJXTjr5sqES4lKpojp4OpBZ-cMA-1Mq5ljHSF803z1djQJNLYpuA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A97280059;
        Wed, 19 Jun 2019 02:41:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/8] mlxsw: spectrum_acl: Avoid size check for RX_ACL_SYSTEM_PORT element
Date:   Wed, 19 Jun 2019 09:41:06 +0300
Message-Id: <20190619064109.849-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619064109.849-1-idosch@idosch.org>
References: <20190619064109.849-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

RX_ACL_SYSTEM_PORT is 8 bit but SRC_SYS_PORT is 16 bits. Internally,
SRC_SYS_PORT is used to carry the value. Relax the checker in case of
RX_ACL_SYSTEM_PORT and allow different size.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.c   |  5 +++--
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.h   | 14 +++++++++-----
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c        |  2 +-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index f6e44ca50cae..feb4672a5ac0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -30,8 +30,9 @@ static bool mlxsw_afk_blocks_check(struct mlxsw_afk *mlxsw_afk)
 
 			elinst = &block->instances[j];
 			if (elinst->type != elinst->info->type ||
-			    elinst->item.size.bits !=
-			    elinst->info->item.size.bits)
+			    (!elinst->avoid_size_check &&
+			     elinst->item.size.bits !=
+			     elinst->info->item.size.bits))
 				return false;
 		}
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
index 78495826ff17..d99a70eec357 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
@@ -110,10 +110,11 @@ struct mlxsw_afk_element_inst { /* element instance in actual block */
 	int u32_key_diff; /* in case value needs to be adjusted before write
 			   * this diff is here to handle that
 			   */
+	bool avoid_size_check;
 };
 
 #define MLXSW_AFK_ELEMENT_INST(_type, _element, _offset,			\
-			       _shift, _size, _u32_key_diff)			\
+			       _shift, _size, _u32_key_diff, _avoid_size_check)	\
 	{									\
 		.info = &mlxsw_afk_element_infos[MLXSW_AFK_ELEMENT_##_element],	\
 		.type = _type,							\
@@ -124,20 +125,23 @@ struct mlxsw_afk_element_inst { /* element instance in actual block */
 			.name = #_element,					\
 		},								\
 		.u32_key_diff = _u32_key_diff,					\
+		.avoid_size_check = _avoid_size_check,				\
 	}
 
 #define MLXSW_AFK_ELEMENT_INST_U32(_element, _offset, _shift, _size)		\
 	MLXSW_AFK_ELEMENT_INST(MLXSW_AFK_ELEMENT_TYPE_U32,			\
-			       _element, _offset, _shift, _size, 0)
+			       _element, _offset, _shift, _size, 0, false)
 
 #define MLXSW_AFK_ELEMENT_INST_EXT_U32(_element, _offset,			\
-				       _shift, _size, _key_diff)		\
+				       _shift, _size, _key_diff,		\
+				       _avoid_size_check)			\
 	MLXSW_AFK_ELEMENT_INST(MLXSW_AFK_ELEMENT_TYPE_U32,			\
-			       _element, _offset, _shift, _size, _key_diff)
+			       _element, _offset, _shift, _size,		\
+			       _key_diff, _avoid_size_check)
 
 #define MLXSW_AFK_ELEMENT_INST_BUF(_element, _offset, _size)			\
 	MLXSW_AFK_ELEMENT_INST(MLXSW_AFK_ELEMENT_TYPE_BUF,			\
-			       _element, _offset, 0, _size, 0)
+			       _element, _offset, 0, _size, 0, false)
 
 struct mlxsw_afk_block {
 	u16 encoding; /* block ID */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index 682c19e220fa..96fc981ed851 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -149,7 +149,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_4[] = {
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_5[] = {
 	MLXSW_AFK_ELEMENT_INST_U32(VID, 0x04, 16, 12),
-	MLXSW_AFK_ELEMENT_INST_EXT_U32(SRC_SYS_PORT, 0x04, 0, 8, -1), /* RX_ACL_SYSTEM_PORT */
+	MLXSW_AFK_ELEMENT_INST_EXT_U32(SRC_SYS_PORT, 0x04, 0, 8, -1, true), /* RX_ACL_SYSTEM_PORT */
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_0[] = {
-- 
2.20.1

