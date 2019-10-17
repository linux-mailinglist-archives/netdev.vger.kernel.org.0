Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031AFDA600
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 09:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407932AbfJQHLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 03:11:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46429 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390955AbfJQHLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 03:11:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D63A2148D;
        Thu, 17 Oct 2019 03:11:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Oct 2019 03:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jBJ0yFK2jS6wlyrw3
        9rKgZv4y56bf1+GfO2VQ2KY0xE=; b=RGUTENVwAZMSi3j+GJ3/RdKq47BTlRAIV
        PxmbRZBLB4xxx2bE2Xqrzh7RumUdbE1Cr0ZPSN2LFu+Y7WbZo0QXNHot3crFRKo4
        GFl7TylTaYAuq5Sd9ADyY1/ql0XneccieYmFMuxcyWZF9RUUSSNa2AFYVDK8VGR4
        Ib9pBOjPgu5YlwsNtEvcszfSjXc3Dl7i4+d2Pw/uG1/q78NC153tt6aVe2SBRTmd
        TBdFiHtCxoXUKYaKrEJiKSMHgBJ6/nVcqJ8GOF4BZux9EzKPXhqYuZVymfeogeXD
        +LhOyD7nxv6TLKVkYyhhij3m6Uc8ssVO/4JZSKrt9HWSCrA/aeVWw==
X-ME-Sender: <xms:MhSoXYX5ehdEOpR6Dfg26Os_nLnKckRYxmVfyHp5Pg6-XFw0qOqRLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:MhSoXQT9ls8JgWbhPtAfYoPpatOfrUqiU-4l_JwZluP235fh2cVGTg>
    <xmx:MhSoXWOtDgsatyQM0Iazf4zI5vyhZJ7wAhP_rUC6nHD0y3MoIe3fzA>
    <xmx:MhSoXeQ0OHotjfa5UZsevDCqTvcvPuP4ENS9Hau0IdL1nss0fpUebA>
    <xmx:MxSoXaMEDzZF5yKhg7fvj_uERuE9YN3EwI62vTvZGSWfbAhEysT1Ww>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4CBBCD6005B;
        Thu, 17 Oct 2019 03:11:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum_trap: Push Ethernet header before reporting trap
Date:   Thu, 17 Oct 2019 10:11:03 +0300
Message-Id: <20191017071103.28744-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

devlink maintains packets and bytes statistics for each trap. Since
eth_type_trans() was called to set the skb's protocol, the data pointer
no longer points to the start of the packet and the bytes accounting is
off by 14 bytes.

Fix this by pushing the skb's data pointer to the start of the packet.

Fixes: b5ce611fd96e ("mlxsw: spectrum: Add devlink-trap support")
Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Tested-by: Alex Kushnarov <alexanderk@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 899450b28621..7c03b661ae7e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -99,6 +99,7 @@ static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
 	devlink = priv_to_devlink(mlxsw_sp->core);
 	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
 							   local_port);
+	skb_push(skb, ETH_HLEN);
 	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port);
 	consume_skb(skb);
 }
-- 
2.21.0

