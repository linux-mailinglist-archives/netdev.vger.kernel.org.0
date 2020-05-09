Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29691CC461
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgEIUGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48487 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbgEIUGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9836C5C00B6;
        Sat,  9 May 2020 16:06:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=d8SctMkVEGl/aMlOLlf9M07cYCzdNrZ2fcAV4emesFs=; b=K5dMbmGS
        TPMK4cRskJz5WalGe1rv/2wYJPdBGJIV1l2MM047Lwv9x+TrwPmV/tJTXMfarCSA
        TA0/GlXrPyjGpuprcCa7DaqguUX+pnpX8uJIdI03CJ8XptEJ3dvV9efbrT8CKn6y
        J6pEhxvGaG07tmVhZCK/njpaBMZAUMz002+gc6sdYGkn+570waQ8SvDl9rnp8z9F
        QlrNnCBfCNjqBk3cr8BnzEuvp+HusoGXDjWmuip1ga1lZX6diZFB6dbKF62zVYeR
        lgFyHL5UFg9td+gO0h0fp8OY9bqNgcbNvHBBsmpuqzN0dVBcZQnBXP+bPo4FUrje
        sfjDeiP4tjsQKg==
X-ME-Sender: <xms:VQ23XuFcCOAoktLD5hbUSn9UwLrpp1J7gFr8Sh1yr0opf-O4hmImnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VQ23XiL2bGxK7joeRD_QC5_RTmX5VWh82iBjzIlQONE0b3BWS3JAww>
    <xmx:VQ23Xjky0AQHeybGkO2DjmKMk6rov_Xg0FqX66V13EiFKOG4RZ88hw>
    <xmx:VQ23Xjo_uPziStByEms1thQ7l_U3tI86T1Irr_aZFjlLxDDCvPGbjQ>
    <xmx:VQ23XkNfWIVJvsTFRd3w_r3A60iS8T1IOsMqVHJ13u6R9Crdelu45w>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 523A1306612B;
        Sat,  9 May 2020 16:06:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/9] mlxsw: spectrum_flower: Forbid to insert flower rules in collision with matchall rules
Date:   Sat,  9 May 2020 23:06:07 +0300
Message-Id: <20200509200610.375719-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509200610.375719-1-idosch@idosch.org>
References: <20200509200610.375719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

On ingress, the matchall rules doing mirroring and sampling are offloaded
into hardware blocks that are processed before any flower rules.
On egress, the matchall mirroring rules are offloaded into hardware
block that is processed after all flower rules.

Therefore check the priorities of inserted flower rules against
existing matchall rules and ensure the correct ordering.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 18d22217e435..b286fe158820 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -505,6 +505,34 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 					     f->common.extack);
 }
 
+static int mlxsw_sp_flower_mall_prio_check(struct mlxsw_sp_flow_block *block,
+					   struct flow_cls_offload *f)
+{
+	bool ingress = mlxsw_sp_flow_block_is_ingress_bound(block);
+	unsigned int mall_min_prio;
+	unsigned int mall_max_prio;
+	int err;
+
+	err = mlxsw_sp_mall_prio_get(block, f->common.chain_index,
+				     &mall_min_prio, &mall_max_prio);
+	if (err) {
+		if (err == -ENOENT)
+			/* No matchall filters installed on this chain. */
+			return 0;
+		NL_SET_ERR_MSG(f->common.extack, "Failed to get matchall priorities");
+		return err;
+	}
+	if (ingress && f->common.prio <= mall_min_prio) {
+		NL_SET_ERR_MSG(f->common.extack, "Failed to add in front of existing matchall rules");
+		return -EOPNOTSUPP;
+	}
+	if (!ingress && f->common.prio >= mall_max_prio) {
+		NL_SET_ERR_MSG(f->common.extack, "Failed to add behind of existing matchall rules");
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
 int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_flow_block *block,
 			    struct flow_cls_offload *f)
@@ -514,6 +542,10 @@ int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_acl_rule *rule;
 	int err;
 
+	err = mlxsw_sp_flower_mall_prio_check(block, f);
+	if (err)
+		return err;
+
 	ruleset = mlxsw_sp_acl_ruleset_get(mlxsw_sp, block,
 					   f->common.chain_index,
 					   MLXSW_SP_ACL_PROFILE_FLOWER, NULL);
-- 
2.26.2

