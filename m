Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7793C4E2
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404318AbfFKHUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:20:23 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34079 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404303AbfFKHUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:20:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 504182224B;
        Tue, 11 Jun 2019 03:20:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 03:20:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=aoF34zX84wseBNFOpzhvS00sKopOfZo0E79vJagIvIA=; b=xuj6Xk6W
        QIL3MFzqmCWRysEU0iaVUWOVK+Bm9qgYK3WCrUU9cTKem0GhgkbfoppYL+2SQMJe
        1hyimoGQoPFQ4usFqpYSMU6JT1TrjDTT9ujh/NcJrs/UU/3/ogplZ+0sO7UwfHL5
        NhcO05IIBRHaeHjmwM9o+oDNbNhDTo36VCom+AO15q7nDoTHXfy1Sh4E4GAjofJD
        qcxZQD5+09CtVJ4N1oRC2QSb4DBTc7o0bpKMGwyD4RLlH2Mxf6ssYTGKz5h8LBLa
        gyUuaYJy6vMaA8jPONGV23WHesQJ+6V2riEhCjyD6GOQ/AFmKH10jFEJhvzI0y/Z
        YbSK7Z+oZYc0/g==
X-ME-Sender: <xms:Nlb_XLcTRSol6q8wAP6DzIUuXlRCeeAoa9eVPYOk42pLNqtiMtGfzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:Nlb_XGfisKTkSvRpuMamUIExqjduJIDbBYc5w0H-OsoKrVyvkRVbhA>
    <xmx:Nlb_XHI_-TeSGL6ofCou7-NVK4SJGecnc9wPiGz78P88s9LUT6HYbA>
    <xmx:Nlb_XMqL_96zenlxHiy5KcxWjQQX7EhSasHkzNqO7gZmC_W9l5cXiw>
    <xmx:Nlb_XKn5KlmkvQmNdg_U9ArdbRstQk-4kGp9BXMfiNVc-zmem4hDqw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74B42380084;
        Tue, 11 Jun 2019 03:20:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 7/7] mlxsw: spectrum: Disallow prio-tagged packets when PVID is removed
Date:   Tue, 11 Jun 2019 10:19:46 +0300
Message-Id: <20190611071946.11089-8-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611071946.11089-1-idosch@idosch.org>
References: <20190611071946.11089-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When PVID is removed from a bridge port, the Linux bridge drops both
untagged and prio-tagged packets. Align mlxsw with this behavior.

Fixes: 148f472da5db ("mlxsw: reg: Add the Switch Port Acceptable Frame Types register")
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e8002bfc1e8f..7ed63ed657c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -997,7 +997,7 @@ static inline void mlxsw_reg_spaft_pack(char *payload, u8 local_port,
 	MLXSW_REG_ZERO(spaft, payload);
 	mlxsw_reg_spaft_local_port_set(payload, local_port);
 	mlxsw_reg_spaft_allow_untagged_set(payload, allow_untagged);
-	mlxsw_reg_spaft_allow_prio_tagged_set(payload, true);
+	mlxsw_reg_spaft_allow_prio_tagged_set(payload, allow_untagged);
 	mlxsw_reg_spaft_allow_tagged_set(payload, true);
 }
 
-- 
2.20.1

