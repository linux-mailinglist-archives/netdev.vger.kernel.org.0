Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446A57B9B9
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 08:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfGaGeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 02:34:17 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60467 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387429AbfGaGeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 02:34:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DFA8E22383;
        Wed, 31 Jul 2019 02:34:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 31 Jul 2019 02:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GWek/PZtkLdfciU67w0dnG6TqUU0hG8SFQ7xvDn1k4o=; b=HDs+IhmU
        KatTzgNtmNBUyAW4vlRw/Z6PAb09sXROp0JHssTK2nT4TCnG1ck12a+V2X31iwUp
        JSwnsC8H3fQ/3XjCjlBbqUsMJMveSRqR2LMn0HN8nTP0o3w0eGuvfHEJcf9YVdSL
        wJ+wbPAVfT5Ut7fNvVQwznL5UBf8NXnthXJWeOqTUFiNesNQ+KEJd7r3PgB/OItw
        YWeAKrRxmYbhVBQ2G1W7tFZlqEjffFmcxb08EepHLuLk923fFTbECOZBlkkR0gjh
        Ivu2AnzxPqxaljoGE9+qmozPPBWSOIyqaufCHDzomiZrpR/YaUoUS7uocOGKodQo
        GI54TcUS+1doUw==
X-ME-Sender: <xms:ZTZBXZug2GIpKDPMMyQBIa-0HOb57OEM6lkXkzuhZ27iVlsHtB0nTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleeggddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:ZTZBXd8uM3KK_TxlWH_IGB5ryXH-wePmpNkX5CQG6sNfbUPurZAlpw>
    <xmx:ZTZBXR2enZaNlI7CHC-P-hCm-i6fSd5oXOgQXrNs7gQ4yRD37LDExw>
    <xmx:ZTZBXfIseCdxWdcVcU2fL3a75bqDGvFJGN28R3GOgiEuAWMaNI3ZeA>
    <xmx:ZTZBXWn2Vtnxq7khv2X1vG_e194Ad6xivmm0JYqMR58pNbYV9skA_w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9A3B380076;
        Wed, 31 Jul 2019 02:34:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] mlxsw: spectrum_buffers: Further reduce pool size on Spectrum-2
Date:   Wed, 31 Jul 2019 09:33:15 +0300
Message-Id: <20190731063315.9381-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731063315.9381-1-idosch@idosch.org>
References: <20190731063315.9381-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

In commit e891ce1dd2a5 ("mlxsw: spectrum_buffers: Reduce pool size on
Spectrum-2"), pool size was reduced to mitigate a problem in port buffer
usage of ports split four ways. It turns out that this work around does not
solve the issue, and a further reduction is required.

Thus reduce the size of pool 0 by another 2.7 MiB, and round down to the
whole number of cells.

Fixes: e891ce1dd2a5 ("mlxsw: spectrum_buffers: Reduce pool size on Spectrum-2")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 1537f70bc26d..888ba4300bcc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -437,8 +437,8 @@ static const struct mlxsw_sp_sb_pr mlxsw_sp1_sb_prs[] = {
 			   MLXSW_SP1_SB_PR_CPU_SIZE, true, false),
 };
 
-#define MLXSW_SP2_SB_PR_INGRESS_SIZE	38128752
-#define MLXSW_SP2_SB_PR_EGRESS_SIZE	38128752
+#define MLXSW_SP2_SB_PR_INGRESS_SIZE	35297568
+#define MLXSW_SP2_SB_PR_EGRESS_SIZE	35297568
 #define MLXSW_SP2_SB_PR_CPU_SIZE	(256 * 1000)
 
 /* Order according to mlxsw_sp2_sb_pool_dess */
-- 
2.21.0

