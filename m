Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B698319D70F
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390902AbgDCNAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:00:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53769 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390805AbgDCNAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:00:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 23A5F5C039F;
        Fri,  3 Apr 2020 09:00:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 03 Apr 2020 09:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=kiIm554f8o83GORBYEmu41mA19cIuW4kYhoaxZyh6e0=; b=3+PT6XDb
        JZYYzgBRV9S2hBhR5++K84/RXVcQ4tqgTAHvYcMTIG9aKLkmyDI6tHULw5NaP8uo
        W0erm4HjmzElEqSq1xm3IPmGitdrQGpc32wjSgU6aq42eO29bm9diSWXem8nwIcQ
        maCRDcBIkcUOTATbfY6vIXJ2mclGxmhU4+7L2OWDiOPW9RNDTRNs/VqtHvUYhQRn
        rqoo4mb1cmvtpUbzxz+fVT6FsYr+H43BNymimQmCF2pCD5XdaSAVLMmgdSUVSr+l
        kDytkuh+ZjN59WAnALsTdGQ+DPZro6h8AKSGuRvDdw3/RJLFabZApWVuoV/fHurW
        FPz18ZqrWKOB6w==
X-ME-Sender: <xms:dzOHXig9w2JfSe9zXs6nQOvLtAt6Dmafhu_ixtA2tSdmEm0aQlE1eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:dzOHXhaVC94ONBSuYaX2l9SIBQVeIlGySMGddN17VfJDa0fKm4Cdxw>
    <xmx:dzOHXiJKOMooNREv0b5-wbBx40Z-6bIfl3jqJ1mpohCtI7M2o-N76A>
    <xmx:dzOHXgedy3dsFgwZw7P7xZuQ9z2oEWtsMOKOWMiso9DEGcgbt512YA>
    <xmx:eDOHXhmlDLTNKYk1iFLGqQ4pL5OzhWwEvZq4F_e70Vx78-OasrA0YA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 78CC8328006B;
        Fri,  3 Apr 2020 09:00:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_PRIORITY
Date:   Fri,  3 Apr 2020 16:00:09 +0300
Message-Id: <20200403130010.2471710-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200403130010.2471710-1-idosch@idosch.org>
References: <20200403130010.2471710-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The handler for FLOW_ACTION_PRIORITY ends by returning whatever the
lower-level function that it calls returns. If there are more actions lined
up after this action, those are never offloaded. Fix by only bailing out
when the called function returns an error.

Fixes: cc2c43406163 ("mlxsw: spectrum_flower: Offload FLOW_ACTION_PRIORITY")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 2f76908cae73..69f77615c816 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -155,9 +155,12 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 							   proto, prio, extack);
 			}
 		case FLOW_ACTION_PRIORITY:
-			return mlxsw_sp_acl_rulei_act_priority(mlxsw_sp, rulei,
-							       act->priority,
-							       extack);
+			err = mlxsw_sp_acl_rulei_act_priority(mlxsw_sp, rulei,
+							      act->priority,
+							      extack);
+			if (err)
+				return err;
+			break;
 		case FLOW_ACTION_MANGLE: {
 			enum flow_action_mangle_base htype = act->mangle.htype;
 			__be32 be_mask = (__force __be32) act->mangle.mask;
-- 
2.24.1

