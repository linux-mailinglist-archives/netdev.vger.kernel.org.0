Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA851E1810
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388737AbgEYXGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39323 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387942AbgEYXGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 215555C0114;
        Mon, 25 May 2020 19:06:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=6qjjhLLVb8t1ehBeR7AmpyOiDNnWpRIbExrHUzno17g=; b=36MwkD/r
        LsQaary6kkY5IrfUCOX42zK8xpDpb2OgL/HZNQtWWXf9G63EtNbo8/4o0DXVMjeq
        MN6aPB0ehRDwZagdoWWjCtoQphwi/vAl2F3almSbgF8fiXtKRqvNmHTEhU3PB8hL
        3hIWYJCsFI1TXgFex9ifWjKJ3rFFioAxJqdtoB8esvrAZaCu6fGxVwNwXTjWZ5hy
        CwRErW/YBnjosatCYOnK5/4WJTtjdmFkqeQJ93ZrgH8As8U7xW4mi4nkpyB2j5Qt
        6RSjmD1nmjI+QiE1s6pe4JQ9f4Mrm3wxNgBrtJcnjf0jGoS5qUQ93mPprHjsraOL
        BEB3BOtJBWkutw==
X-ME-Sender: <xms:ak_MXmU4c3Sfq2MysyDfcHHW-FIcrtTyxFcg8N1uSRdBkncBIfrR1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ak_MXindy_SWonyBqS-9f28jTtxf3yYSNYxOG1kJ3CQye2IRkA5Wlw>
    <xmx:ak_MXqZYrMpYtY8AFILUl52bF5fujESMsZYMGz_A_Ih4PG6EIrZtjA>
    <xmx:ak_MXtVO8hSFmaqpB4OpSZ6XVkYVi9LIstIUbu0nr0zXjM3LW_OtbA>
    <xmx:ak_MXst_Uv3oFE9Cii60U9RwqxBlYbFeQxv2TdYg2EFXEV_hih0dMw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1C493280064;
        Mon, 25 May 2020 19:06:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/14] mlxsw: spectrum: Use same switch case for identical groups
Date:   Tue, 26 May 2020 02:05:44 +0300
Message-Id: <20200525230556.1455927-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Trap groups that use the same policer settings can share the same switch
case.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index e0811a7e13b9..e8c9fc4cb6fb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4168,9 +4168,6 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING:
-			rate = 1024;
-			burst_size = 7;
-			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
 			rate = 1024;
 			burst_size = 7;
-- 
2.26.2

