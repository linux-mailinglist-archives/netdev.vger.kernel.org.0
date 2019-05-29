Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22242D729
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfE2IAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:00:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43311 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfE2IAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:00:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D343021FC3;
        Wed, 29 May 2019 04:00:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=MVD1/FKdMdI13eIqVuWLzfN2HQZetoKzVlOYul6v+Ww=; b=IriyolW7
        NHCy90IgvuRtbsovKry7WeW06+G4yWP9j+Lw2C3CHchlUDtn+8NFriTYTxZpeF/+
        QUKDpGYfCiecn7+kMEo65w+JlbG5kTDm4QcMpaDQjan4YA1HlN6LUhvam5p0rZFp
        lp3rkkru9+MZ1J8zaMUZAbZWxmkqvXDV85yp8e7nK2hShJSXbBvQAixB0V+iCMvk
        GcU8JJR5G6Xb2OsDXt+fnV/p9pbpDN/bx0czEs0Eks+L90h9c+/zYrMZaHuOG3UR
        /3tSScCEeBFXJJzTeu/w48b40H+7Grh6Kt40GHqCmtd+llb7ujnsldPEG9kEZKzu
        WcvRh6MFaVw3NA==
X-ME-Sender: <xms:BDzuXENNdrJ_JEYB1pAZKRT5okxjXlV54HYXsdjIWt1nJRoy2fHzRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddviedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:BDzuXHFGL_KPZVgqTnZUsGp68cChgjRwZUmPVY-oKwya7uUXeGg0Ug>
    <xmx:BDzuXHHQ4K3AV_feG6XYfriVYogQc9Hr9LnZ_niUXZ5nXvhbDRqEjA>
    <xmx:BDzuXGDhhr0-05Ah8SSkjBeR8uQ3nfm5NG1-SQ-vsIdlr7D3nLEGMA>
    <xmx:BDzuXDwvghVf_CFp-9I1SnvMw-ZlvlGxJX3wOdRnpgOz6lTkF4PyFQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71B4238008B;
        Wed, 29 May 2019 04:00:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] mlxsw: spectrum: Prevent force of 56G
Date:   Wed, 29 May 2019 10:59:45 +0300
Message-Id: <20190529075945.20050-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529075945.20050-1-idosch@idosch.org>
References: <20190529075945.20050-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Force of 56G is not supported by hardware in Ethernet devices. This
configuration fails with a bad parameter error from firmware.

Add check of this case. Instead of trying to set 56G with autoneg off,
return a meaningful error.

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dbb425717f5e..dfe6b44baf63 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3128,6 +3128,10 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap, NULL, NULL);
 
 	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
+	if (!autoneg && cmd->base.speed == SPEED_56000) {
+		netdev_err(dev, "56G not supported with autoneg off\n");
+		return -EINVAL;
+	}
 	eth_proto_new = autoneg ?
 		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
 		ops->to_ptys_speed(mlxsw_sp, cmd->base.speed);
-- 
2.20.1

