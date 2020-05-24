Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12AF1E0375
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388480AbgEXVvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54063 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388371AbgEXVvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CA15E5C00A5;
        Sun, 24 May 2020 17:51:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/befF+4nRtNh0MIPha1L6l9pNmXKE0e7h3vGpmZgdP4=; b=kIie7S/E
        Ag9EY7GjIWRNbpmu9CETw4OKTpjoeOSAT2fmEzb7AnvEMshyHfXDSwJO/aZ1gjqk
        G5ADJsQ094Vxrf9an70xH3cO2Jm2xI8R+oGIccsdGpjDOQShmwshCpO55EwxtoNJ
        D74O6zDuHecJtONSKQ7KA5I73qWzWPT9qcStNXfBONdYRo3qcxJlid35/TA9uLdE
        N9zrIyk6GLvdhVMqVJ1FUjoInv9HM06v+flnuD2kAYUp7Td0Vngt7CsPNGgb1SVq
        dOjDQGaktWJgvgv4UYUME0BDpWjzfZ1QOzwBti5TpPcrRl6d5Le4ASayCId0zyTW
        GqPiLB+xF1QqlQ==
X-ME-Sender: <xms:YuzKXmhbCs6TWqpr3b_QKgmNV4EqKNsV6d9JvfjitCsqIQ2lPt0UGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:YuzKXnB3XsQfN2CBlHp0UtI90DvSjpHud2BRFTAoskeAegvc2JBWQw>
    <xmx:YuzKXuHSJ66PYfKabVKsjBCswXSFn9jZlkdAY68kwd1muYa7L9fH0A>
    <xmx:YuzKXvRburjQQaGqY9zM08caRvTzS71GS6KroyEeXhpwmd3icA0qMw>
    <xmx:YuzKXspxvYCNac73zJZn7NpthiBU9eRLl3-P2LWxXLvdXRbjUIqNqQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8233E306651E;
        Sun, 24 May 2020 17:51:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/11] mlxsw: spectrum_buffers: Assign non-zero quotas to TC 0 of the CPU port
Date:   Mon, 25 May 2020 00:51:01 +0300
Message-Id: <20200524215107.1315526-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524215107.1315526-1-idosch@idosch.org>
References: <20200524215107.1315526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

As explained in commit 9ffcc3725f09 ("mlxsw: spectrum: Allow packets to
be trapped from any PG"), incoming packets can be admitted to the shared
buffer and forwarded / trapped, if:

(Ingress{Port}.Usage < Thres && Ingress{Port,PG}.Usage < Thres &&
 Egress{Port}.Usage < Thres && Egress{Port,TC}.Usage < Thres)
||
(Ingress{Port}.Usage < Min || Ingress{Port,PG} < Min ||
 Egress{Port}.Usage < Min || Egress{Port,TC}.Usage < Min)

Trapped packets are scheduled to transmission through the CPU port.
Currently, the minimum and maximum quotas of traffic class (TC) 0 of the
CPU port are 0, which means it is not usable.

Assign non-zero quotas to TC 0 of the CPU port, so that it could be
utilized by subsequent patches.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 968f0902e4fe..21bfb2f6a6f0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -614,7 +614,7 @@ static const struct mlxsw_sp_sb_cm mlxsw_sp2_sb_cms_egress[] = {
 #define MLXSW_SP_CPU_PORT_SB_CM MLXSW_SP_SB_CM(0, 0, MLXSW_SP_SB_POOL_EGR_CPU)
 
 static const struct mlxsw_sp_sb_cm mlxsw_sp_cpu_port_sb_cms[] = {
-	MLXSW_SP_CPU_PORT_SB_CM,
+	MLXSW_SP_SB_CM(1000, 8, MLXSW_SP_SB_POOL_EGR_CPU),
 	MLXSW_SP_SB_CM(1000, 8, MLXSW_SP_SB_POOL_EGR_CPU),
 	MLXSW_SP_SB_CM(1000, 8, MLXSW_SP_SB_POOL_EGR_CPU),
 	MLXSW_SP_SB_CM(1000, 8, MLXSW_SP_SB_POOL_EGR_CPU),
-- 
2.26.2

