Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3DE319D710
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390910AbgDCNAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:00:43 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33197 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390805AbgDCNAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:00:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7FD325C03AE;
        Fri,  3 Apr 2020 09:00:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 03 Apr 2020 09:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3RxEj2Lv1A7TjjUjOh+/y4F/Vhw2l0yzg8UakgCoVd4=; b=RuaGPKZH
        u2L1rj6PTpi6DnKRIspEI21WCsRQUsG2HCxxruLhC0yNRVkE3WTVhRKy6sOoetBU
        68TYYkCbnvQg6NFqWJR+vziuKkuikIhWvsZacFln9JCS67tPm3azT8QtjD7OdCt3
        NGkI6UeQcYIodVtbr1Cs5dlZD0lBY8Xj9R/gNmpJy2452SUxg8PZ7HW9YEisRxWC
        iEhseKtFm6OaPTXDkRozp7JXo6UJv4gPymu9J9T1fWUIbFfdzY6yVw1OYMeBDSTs
        GcT0ZuEy2poSzOggQ+gQg340RNKH39L3HzjnTHWO1hb4l+v4+3ZlfjrkShj5TSxT
        3CrMKP4k5dPk1A==
X-ME-Sender: <xms:eTOHXs0xwb6lQFO_Oc40r4SNYKJzBb8BzFIIK0WDkElYhRWeONkQ_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsthgvrh
    fuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:eTOHXllP5rlHUOVYDjE_a7t0WijOv6mJXqVi_5ekw_At-N3HoRw2xQ>
    <xmx:eTOHXtS0W88K5QRQ8N8apRCImSgmo4ZA7ZKYbbQFAHmlAshsNnUSyw>
    <xmx:eTOHXnqKNZnohgICNxVhXZ-BJ8zIi1S9aVOnd2iVGKpgvsg8NbZrUw>
    <xmx:eTOHXppcQmaZhc2nl7YFWmljyVzpusawwM8xQyclYj0HkmZM3FW27g>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5C2B3280063;
        Fri,  3 Apr 2020 09:00:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE
Date:   Fri,  3 Apr 2020 16:00:10 +0300
Message-Id: <20200403130010.2471710-3-idosch@idosch.org>
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

The handler for FLOW_ACTION_VLAN_MANGLE ends by returning whatever the
lower-level function that it calls returns. If there are more actions lined
up after this action, those are never offloaded. Fix by only bailing out
when the called function returns an error.

Fixes: a150201a70da ("mlxsw: spectrum: Add support for vlan modify TC action")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 69f77615c816..51117a5a6bbf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -150,9 +150,12 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			u8 prio = act->vlan.prio;
 			u16 vid = act->vlan.vid;
 
-			return mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
-							   act->id, vid,
-							   proto, prio, extack);
+			err = mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
+							  act->id, vid,
+							  proto, prio, extack);
+			if (err)
+				return err;
+			break;
 			}
 		case FLOW_ACTION_PRIORITY:
 			err = mlxsw_sp_acl_rulei_act_priority(mlxsw_sp, rulei,
-- 
2.24.1

