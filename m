Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736684B247
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbfFSGl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:41:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34283 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731111AbfFSGl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:41:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4DABF21B84;
        Wed, 19 Jun 2019 02:41:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 02:41:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=YzrHO5TIIPKOPLEdGH310NlF3NQi9OZIb8/7DOvC8dM=; b=iNRetPLp
        /HVc6taIe/E7rhQgDelvH20Pisf9MWx5piZkJTcThjp60Y1Ihkuy5/QAg4d1Mxe6
        Kz+EX/rIyFh+/MqcjE14+7a85bp62K4lO06hKCtdIGJ6R9Kxk+71RSkj4TWNsYgC
        UUqLlLw6mX9wxrESkLXnaauZqzawLeR13adneFRnyj+LbY6ipqOOoG/OEQuJejeQ
        cND5jy+s3PbtZD6XCvqodL1Sp3Brt5tkRD/0GQyJ4pb+IK48NyxNr63ShOeMiuUQ
        XPBO077VHQbWTBFcoR5Ho4Lr66w32Dl9cXlL0/b0KM4fWCZdApwaBDGc6YGagA8F
        7ZLYqecyMRKiVQ==
X-ME-Sender: <xms:NNkJXQS8ejsNzJ4fpADgYOMz0NRwcis--0HezxyD8U-NLlGJJxhOCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddugdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:NNkJXQ2nUpTyU_I8cmyWBIzYftL50oC3i7VxNj7mwczBRZ9MtsAxEw>
    <xmx:NNkJXYemYAsrWgtE2pJoBeiMYIUbb41RnrqQXJ7ehbjzRyuLpRGHnA>
    <xmx:NNkJXQOpOh0wxNWkFj-4t4USvKRE2GtlXhqiStDo-rYtweqRqmPwzg>
    <xmx:NNkJXUqr5SgS7Jm4wG9kKTpoqg-lw6GnkEOfUr3bjhMFS5Xn9jy6fg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C93880059;
        Wed, 19 Jun 2019 02:41:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/8] mlxsw: spectrum_acl: Write RX_ACL_SYSTEM_PORT acl element correctly
Date:   Wed, 19 Jun 2019 09:41:05 +0300
Message-Id: <20190619064109.849-5-idosch@idosch.org>
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

RX_ACL_SYSTEM_PORT is equal to SRC_SYS_PORT - 1. So before write to
block we need to adjust the key value. Introduce new "EXT" helper to
implement this.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.c | 13 +++++++------
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.h | 16 +++++++++++++---
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c      |  2 +-
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index cb3e663b1d37..f6e44ca50cae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -385,12 +385,12 @@ EXPORT_SYMBOL(mlxsw_afk_values_add_buf);
 
 static void mlxsw_sp_afk_encode_u32(const struct mlxsw_item *storage_item,
 				    const struct mlxsw_item *output_item,
-				    char *storage, char *output)
+				    char *storage, char *output, int diff)
 {
 	u32 value;
 
 	value = __mlxsw_item_get32(storage, storage_item, 0);
-	__mlxsw_item_set32(output, output_item, 0, value);
+	__mlxsw_item_set32(output, output_item, 0, value + diff);
 }
 
 static void mlxsw_sp_afk_encode_buf(const struct mlxsw_item *storage_item,
@@ -406,14 +406,14 @@ static void mlxsw_sp_afk_encode_buf(const struct mlxsw_item *storage_item,
 
 static void
 mlxsw_sp_afk_encode_one(const struct mlxsw_afk_element_inst *elinst,
-			char *output, char *storage)
+			char *output, char *storage, int u32_diff)
 {
 	const struct mlxsw_item *storage_item = &elinst->info->item;
 	const struct mlxsw_item *output_item = &elinst->item;
 
 	if (elinst->type == MLXSW_AFK_ELEMENT_TYPE_U32)
 		mlxsw_sp_afk_encode_u32(storage_item, output_item,
-					storage, output);
+					storage, output, u32_diff);
 	else if (elinst->type == MLXSW_AFK_ELEMENT_TYPE_BUF)
 		mlxsw_sp_afk_encode_buf(storage_item, output_item,
 					storage, output);
@@ -446,9 +446,10 @@ void mlxsw_afk_encode(struct mlxsw_afk *mlxsw_afk,
 				continue;
 
 			mlxsw_sp_afk_encode_one(elinst, block_key,
-						values->storage.key);
+						values->storage.key,
+						elinst->u32_key_diff);
 			mlxsw_sp_afk_encode_one(elinst, block_mask,
-						values->storage.mask);
+						values->storage.mask, 0);
 		}
 
 		mlxsw_afk->ops->encode_block(key, i, block_key);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
index 4a625cdf3e7c..78495826ff17 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
@@ -107,9 +107,13 @@ struct mlxsw_afk_element_inst { /* element instance in actual block */
 	const struct mlxsw_afk_element_info *info;
 	enum mlxsw_afk_element_type type;
 	struct mlxsw_item item; /* element geometry in block */
+	int u32_key_diff; /* in case value needs to be adjusted before write
+			   * this diff is here to handle that
+			   */
 };
 
-#define MLXSW_AFK_ELEMENT_INST(_type, _element, _offset, _shift, _size)		\
+#define MLXSW_AFK_ELEMENT_INST(_type, _element, _offset,			\
+			       _shift, _size, _u32_key_diff)			\
 	{									\
 		.info = &mlxsw_afk_element_infos[MLXSW_AFK_ELEMENT_##_element],	\
 		.type = _type,							\
@@ -119,15 +123,21 @@ struct mlxsw_afk_element_inst { /* element instance in actual block */
 			.size = {.bits = _size},				\
 			.name = #_element,					\
 		},								\
+		.u32_key_diff = _u32_key_diff,					\
 	}
 
 #define MLXSW_AFK_ELEMENT_INST_U32(_element, _offset, _shift, _size)		\
 	MLXSW_AFK_ELEMENT_INST(MLXSW_AFK_ELEMENT_TYPE_U32,			\
-			       _element, _offset, _shift, _size)
+			       _element, _offset, _shift, _size, 0)
+
+#define MLXSW_AFK_ELEMENT_INST_EXT_U32(_element, _offset,			\
+				       _shift, _size, _key_diff)		\
+	MLXSW_AFK_ELEMENT_INST(MLXSW_AFK_ELEMENT_TYPE_U32,			\
+			       _element, _offset, _shift, _size, _key_diff)
 
 #define MLXSW_AFK_ELEMENT_INST_BUF(_element, _offset, _size)			\
 	MLXSW_AFK_ELEMENT_INST(MLXSW_AFK_ELEMENT_TYPE_BUF,			\
-			       _element, _offset, 0, _size)
+			       _element, _offset, 0, _size, 0)
 
 struct mlxsw_afk_block {
 	u16 encoding; /* block ID */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index 2a998dea4f39..682c19e220fa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -149,7 +149,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_4[] = {
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_5[] = {
 	MLXSW_AFK_ELEMENT_INST_U32(VID, 0x04, 16, 12),
-	MLXSW_AFK_ELEMENT_INST_U32(SRC_SYS_PORT, 0x04, 0, 8), /* RX_ACL_SYSTEM_PORT */
+	MLXSW_AFK_ELEMENT_INST_EXT_U32(SRC_SYS_PORT, 0x04, 0, 8, -1), /* RX_ACL_SYSTEM_PORT */
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_0[] = {
-- 
2.20.1

