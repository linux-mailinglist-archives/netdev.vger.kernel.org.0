Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DB224EC1D
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgHWIHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:07:50 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59963 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727064AbgHWIHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:07:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 022E55C0080;
        Sun, 23 Aug 2020 04:07:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 23 Aug 2020 04:07:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=5L7PzGca3ta/+Yg1Wueagt1tuwm7htCtzy0NEoo/fnQ=; b=DPuPCF9N
        LHA/hYl/HNNJhf6asGIqCePxM3LJQPT/T7xEFTo1YanBRYj9QnzJv9O3KSea1vQD
        8cZfPRb/XnQMLi/kexJM6Au5T8UnXNCkzjL++0NWJ1c5THoQAID4YLnYox0pJ7++
        JPztTVswWsql2vbIf9//SXNyZJATJwjSFOUIDGVUIRkGwCUEDwjJAWSUmbEve211
        125w7VJvwiTC2ZZwD7utQC+dmUJA8OBk4OTYOnUcYEkJtQjbCoFWnP7+oeMYgQfG
        WZ4N12wtSXYpfzGF7xCIulNPRRC4yTAr9eD/npcoEewWtjU/HxuKUh/gSAR7MOxz
        ejO7VxNId8dvqA==
X-ME-Sender: <xms:0SNCX1H1DY8FbL1meRo2WMoH6EF97YRvU2w1PfNDK8toqeb94Ezi3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhefgtd
    fftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeekrddufedurdefheenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0SNCX6VV-h_6GJL5Pk5jbLOvwJjO0_aJPtwdThwH7iiF46iDfOlu2Q>
    <xmx:0SNCX3INBYhd7QmQLV2iFb6gX6MLVnycjsyxW0izYCK0Lx1xzBKCWw>
    <xmx:0SNCX7GRNvrsky7DRK5GTyhFxkSxQOjVEq_evSlT60w-NrGh-10HgQ>
    <xmx:0SNCXyfCcT7I0dqDoUWPM0Z0YGJJM1oe6xBHMjnKjZ_FcKYlAjRisg>
Received: from shredder.mtl.com (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2BD3328005A;
        Sun, 23 Aug 2020 04:07:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/7] mlxsw: spectrum_trap: Adjust default policer burst size for Spectrum-{2, 3}
Date:   Sun, 23 Aug 2020 11:06:22 +0300
Message-Id: <20200823080628.407637-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200823080628.407637-1-idosch@idosch.org>
References: <20200823080628.407637-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

On the Spectrum-{2,3} ASICs the minimum burst size of the packet trap
policers needs to be 40% of the configured rate. Otherwise, intermittent
drops are observed even when the incoming packet rate is slightly lower
than the configured policer rate.

Adjust the burst size of the registered packet trap policers so that
they do not violate above mentioned limitation.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 2e41c5519c1b..433f14ade464 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -291,7 +291,7 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 static const struct mlxsw_sp_trap_policer_item
 mlxsw_sp_trap_policer_items_arr[] = {
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(1, 10 * 1024, 128),
+		.policer = MLXSW_SP_TRAP_POLICER(1, 10 * 1024, 4096),
 	},
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(2, 128, 128),
@@ -303,25 +303,25 @@ mlxsw_sp_trap_policer_items_arr[] = {
 		.policer = MLXSW_SP_TRAP_POLICER(4, 128, 128),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(5, 16 * 1024, 128),
+		.policer = MLXSW_SP_TRAP_POLICER(5, 16 * 1024, 8192),
 	},
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(6, 128, 128),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(7, 1024, 128),
+		.policer = MLXSW_SP_TRAP_POLICER(7, 1024, 512),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(8, 20 * 1024, 1024),
+		.policer = MLXSW_SP_TRAP_POLICER(8, 20 * 1024, 8192),
 	},
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(9, 128, 128),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(10, 1024, 128),
+		.policer = MLXSW_SP_TRAP_POLICER(10, 1024, 512),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(11, 360, 128),
+		.policer = MLXSW_SP_TRAP_POLICER(11, 256, 128),
 	},
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(12, 128, 128),
@@ -330,19 +330,19 @@ mlxsw_sp_trap_policer_items_arr[] = {
 		.policer = MLXSW_SP_TRAP_POLICER(13, 128, 128),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(14, 1024, 128),
+		.policer = MLXSW_SP_TRAP_POLICER(14, 1024, 512),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(15, 1024, 128),
+		.policer = MLXSW_SP_TRAP_POLICER(15, 1024, 512),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(16, 24 * 1024, 4096),
+		.policer = MLXSW_SP_TRAP_POLICER(16, 24 * 1024, 16384),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(17, 19 * 1024, 4096),
+		.policer = MLXSW_SP_TRAP_POLICER(17, 19 * 1024, 8192),
 	},
 	{
-		.policer = MLXSW_SP_TRAP_POLICER(18, 1024, 128),
+		.policer = MLXSW_SP_TRAP_POLICER(18, 1024, 512),
 	},
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(19, 1024, 512),
-- 
2.26.2

