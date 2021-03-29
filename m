Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B3134CDB2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhC2KKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:10:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42213 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231458AbhC2KKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:10:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 116D55C00E4;
        Mon, 29 Mar 2021 06:10:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 06:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=EaPacVoh3hPlgbKrRlCUm3njb1vtkHSZBb0UgoLIRM0=; b=Hvy1DYQg
        N11u40ytGbgSFa1xiPgEg6qZvAKtQP3+evUMntZGd7qu+qdcALh33h02mK9A1lB1
        +an6Xe+wFJtLqVacYtlO7DsnKNDiBZk/5VMUJPHp+BjF1RCvc5AtcdkUXit3xDGG
        i64zpX4NiDWZ/8KQIeZaNhxBTkH2DAn9l7tMNpDUUoTyS2vx3kxN0ygf7etqF1Kg
        tKrzibCyZB4xwFeTRqp7bUHEK3GQoQ8LeeSQeJ4LO/Pe4WXBN+1XVQ76+AvUsluw
        AEtEZwg84bArDTrWcdFOuiwZmKPN4s1CDl/chXgkImjrttABXt+Q1zXc9+jYEoPN
        QCbetrfv9L+42Q==
X-ME-Sender: <xms:l6dhYIyHI1_p4Idz1hg2MFIjVKQuqS1lfTvkiucQgm1eE01G9xWysg>
    <xme:l6dhYMSa7hIjXF25aOS_15F1A1C0-RvaIWge1NFaS62T7IJjExnBrFflPerv1WCV5
    WKFVd_0uEaUWnc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:l6dhYKVVtApfRHRNxKdjxyDnUWTnpMLjBQdJAJKh6pZ-h17-vvaQwQ>
    <xmx:l6dhYGghuuKniib4ULbv9nK3sup1SDVoKYrdr2dskYIwrY_5O7JcKA>
    <xmx:l6dhYKBtZ_sU8DVx6vETlLRuEqt4CVMkuCswG2tSLGF_kkgG1JJZKg>
    <xmx:mKdhYNOOVpqvUzeWvNPj6lfXErZYj0yiNOIywJNFZHL2F6xlFle4BA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3478240054;
        Mon, 29 Mar 2021 06:10:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/6] mlxsw: spectrum: Veto sampling if already enabled on port
Date:   Mon, 29 Mar 2021 13:09:47 +0300
Message-Id: <20210329100948.355486-6-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329100948.355486-1-idosch@idosch.org>
References: <20210329100948.355486-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The per-port sampling triggers (i.e., ingress / egress) cannot be
enabled twice. Meaning, the below configuration will not result in
packets being sampled twice:

 # tc filter add dev swp1 ingress matchall skip_sw action sample rate 100 group 1
 # tc filter add dev swp1 ingress matchall skip_sw action sample rate 100 group 1

Therefore, reject such configurations.

Fixes: 90f53c53ec4a ("mlxsw: spectrum: Start using sampling triggers hash table")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index efc7acb4842c..bca0354482cb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2668,6 +2668,11 @@ mlxsw_sp_sample_trigger_params_set(struct mlxsw_sp *mlxsw_sp,
 		return mlxsw_sp_sample_trigger_node_init(mlxsw_sp, &key,
 							 params);
 
+	if (trigger_node->trigger.local_port) {
+		NL_SET_ERR_MSG_MOD(extack, "Sampling already enabled on port");
+		return -EINVAL;
+	}
+
 	if (trigger_node->params.psample_group != params->psample_group ||
 	    trigger_node->params.truncate != params->truncate ||
 	    trigger_node->params.rate != params->rate ||
-- 
2.30.2

