Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D115839F70A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhFHMqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:46:51 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59325 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232754AbhFHMqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:46:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 046B35C012E;
        Tue,  8 Jun 2021 08:44:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 08:44:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=XyiVmZ94/r9kpGb4rIJjEKDGdDszulRtzsdlcdStAjU=; b=S1BY2ECs
        HO1fMpK3Fk82Th2Gmh4PNN2HPHH4cW3yY5lEucPUJ2Rwled1vgMvB9kksJjWHysq
        8MPXAkoynspH20uyQnCoF72jignlAKblozvJzi5SOFL1Mrjf0YrCI6reaTvE5AsM
        oCjQO/r8O/MDSoPUySsfJoSgWcgKkaE5bv79X9Vxlk9LsuGXIyjJRLaMCttA4OBh
        RasqdVXta5z/blOvDYbUlFfmmRDImImbPzGkuTNCV/fuRLeMVA/73uxCvBxhypaM
        r8MoKJJ4BR/H6nnIGnfYeigG/J1zIT1bfDHTerh68fCdojz5UlkKVjw1D9FXqEnU
        heCNK7v23F6+0Q==
X-ME-Sender: <xms:Rma_YCCIDh1zPUIKDIrc60VCriWitRf0afv0h0M1FU1YxAIxMkXvCA>
    <xme:Rma_YMjR8vIsbJPRbG9bDWsR0Bernt027Ore68lyBrztuhG6mt1XpdFKEEx3_H-d-
    3TK2HZgr7T3tE0>
X-ME-Received: <xmr:Rma_YFlanWUaRar-Obwoq76qUFhPNPHpB9xlSeIqrRGaiN57acvRoCW5YCfCSY5kRJl3BssfIH0A-2ZWfH6yocJekQXvQTKTVc7c5CcpjeFuWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Rma_YAzaGmCg70n50YCY-JwVK4loVh9g_sKNW2ASulcWD8svPkUggw>
    <xmx:Rma_YHRjqbK8IMwN62EE8NOmIv34t9nfih8DE-r8Q5-dCHaRDdtlMg>
    <xmx:Rma_YLYsUAlfDtY2eLBs6ZvDJcsX_L3rTDYjPto-Z8p-UVf2zBkN6Q>
    <xmx:R2a_YAReVJYOim7ZoIJgFifuI_h2nVnnwTt1-dKO59RmUSFbIAzjlg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:44:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, vadimp@nvidia.com,
        c_mykolak@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: core_env: Read module temperature thresholds using MTMP register
Date:   Tue,  8 Jun 2021 15:44:12 +0300
Message-Id: <20210608124414.1664294-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608124414.1664294-1-idosch@idosch.org>
References: <20210608124414.1664294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mykola Kostenok <c_mykolak@nvidia.com>

Currently, module temperature thresholds are obtained from Management
Cable Info Access (MCIA) register by specifying the thresholds offsets
within module EEPROM layout. This data does not pass validation and in
some cases can be unreliable. For example, due to some problem with the
module.

Add support for a new feature provided by Management Temperature (MTMP)
register for sanitization of temperature thresholds values.

Extend mlxsw_env_module_temp_thresholds_get() to get temperature
thresholds through MTMP field 'max_operational_temperature' - if it is
not zero, feature is supported. Otherwise fallback to old method and get
the thresholds through MCIA.

Signed-off-by: Mykola Kostenok <c_mykolak@nvidia.com>
Acked-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index bcad1327d861..b3ca5bd33a7f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -125,6 +125,7 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 					 int off, int *temp)
 {
+	unsigned int module_temp, module_crit, module_emerg;
 	char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
 	union {
 		u8 buf[MLXSW_REG_MCIA_TH_ITEM_SIZE];
@@ -132,7 +133,6 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	} temp_thresh;
 	char mcia_pl[MLXSW_REG_MCIA_LEN] = {0};
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
-	unsigned int module_temp;
 	bool qsfp, cmis;
 	int page;
 	int err;
@@ -142,12 +142,21 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	err = mlxsw_reg_query(core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err)
 		return err;
-	mlxsw_reg_mtmp_unpack(mtmp_pl, &module_temp, NULL, NULL, NULL, NULL);
+	mlxsw_reg_mtmp_unpack(mtmp_pl, &module_temp, NULL, &module_crit,
+			      &module_emerg, NULL);
 	if (!module_temp) {
 		*temp = 0;
 		return 0;
 	}
 
+	/* Validate if threshold reading is available through MTMP register,
+	 * otherwise fallback to read through MCIA.
+	 */
+	if (module_emerg) {
+		*temp = off == SFP_TEMP_HIGH_WARN ? module_crit : module_emerg;
+		return 0;
+	}
+
 	/* Read Free Side Device Temperature Thresholds from page 03h
 	 * (MSB at lower byte address).
 	 * Bytes:
-- 
2.31.1

