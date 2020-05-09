Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A45E1CC45A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgEIUGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56885 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728420AbgEIUGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 79BA85C00CC;
        Sat,  9 May 2020 16:06:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jy1ni/kucONnFsJiHBJFs4e9jvuC8/uo19RJwYCXkcU=; b=HtzThquk
        rFLeAMZTr7fc3q/I4wEzeVTOrnoX6Yvbz8nS/dun5FI0X2EWhbnJvc7MxsYQuV35
        3EnkBwaU0ULzDw3jyK0PaYNozGW8KMD7dHnApUe0ksOLybllMe3u+rt592+MP+MV
        BaVPP/tetKSZUOBaj9oxLhRkDSob4giqox+ZcpjxfhZkueY7XRMj4XutmZJW322H
        fuybeM6ApJhiVc+Mds52fu75rmly6zuhHw5JW2j7RFP61hSoCBs6s77Z+Ru7fgKp
        OA1wwEHEPfFrbF4QvQUZNH4H+pDfHvnN7moBH1am3pVx7q9TjMZOqcRsv+dUJeq6
        xHRmoo38JYoneA==
X-ME-Sender: <xms:Tg23XswvCBzwIdz3ngpAIJRXbtbkBv6_uf9IJnLymyDPwFNN5--dxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Tg23Xt-IkUvEnKkJoJioR1gW1NwLS-XJ9t8Jf7F15Fes4Y3MoXmTwQ>
    <xmx:Tg23XgGL9tBjzeg7rJVWY9h-9VJOTSVB6lgW--A8tbLrYb6HTqMD-g>
    <xmx:Tg23XnDOM_hMkpCpGqI2QWUDs5iXJgDV1bc7xdeJWJ1kUHv-EAFUUg>
    <xmx:Tg23XkIGaY-zSaVV5AihnLf9oBCdnHPAbXzFQ0EB3ERy2HY61E1yVA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2FD373066240;
        Sat,  9 May 2020 16:06:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/9] mlxsw: spectrum_matchall: Restrict sample action to be allowed only on ingress
Date:   Sat,  9 May 2020 23:06:02 +0300
Message-Id: <20200509200610.375719-2-idosch@idosch.org>
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

HW supports packet sampling on ingress only. Check and fail if user
is adding sample on egress.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index da1c05f44cec..c75661521bbc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -212,6 +212,11 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
 		mall_entry->mirror.to_dev = act->dev;
 	} else if (act->id == FLOW_ACTION_SAMPLE &&
 		   protocol == htons(ETH_P_ALL)) {
+		if (!mall_entry->ingress) {
+			NL_SET_ERR_MSG(f->common.extack, "Sample is not supported on egress");
+			err = -EOPNOTSUPP;
+			goto errout;
+		}
 		if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
 			NL_SET_ERR_MSG(f->common.extack, "Sample rate not supported");
 			err = -EOPNOTSUPP;
-- 
2.26.2

