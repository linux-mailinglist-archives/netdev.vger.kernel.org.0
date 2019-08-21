Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8912F9733C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 09:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbfHUHU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 03:20:28 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51911 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727537AbfHUHU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 03:20:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BB6BE2205E;
        Wed, 21 Aug 2019 03:20:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 21 Aug 2019 03:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1kYbfER4N+RcH5iGxUOlwAMOkRuRBJd4jl87Mb75+TQ=; b=WcMWiRhV
        1FLGos+S8iu+JfapPofGyJSJV3Rz14Jn1Xzb/pxA/5QEz2NtMyEd43CtCX4rzEdi
        fly22cstsZlqKP43rRXSw6xEkWSKpXkdAy4zLfWmgnxhVBscvFRLrRwCmGR6EX0n
        kQ5c5An6+XFy+2VrV05AjPrYc7TDhOz4vZ1qnmFmoAwvuhsVpRZ9cjraWmHY9uf3
        nuD7GNSVxvaCwbKae6XSeyJFMbEAWcJf2DUE07U/8PByINcn6EyC8Q9cNNuhTMKO
        2WZNASGvg+eJ4dc04BD7dQA0rfJoaSjyEwz+FJkSkgvzaVvqkM7jYUccdjsC5tCA
        w02rNCKBBFUDEg==
X-ME-Sender: <xms:uvBcXZpMma_DiTnntQh20Mi10FS0EWiwsOVCkcZ9FdHiiKK6UHrZrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegvddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:uvBcXS_K1YpvvvVYnSUFBqV63vS1D5vfGZbUqv86bRZeFT9qGR46kQ>
    <xmx:uvBcXa4MsTCvGVj37y8RA1-P-6uafoOQDR5KKFG3QaD6_pvzgIOqOg>
    <xmx:uvBcXd6oznZrYhic4YiAEgzw0PvBPoQwPYNc1i9lHCwSG1ugCs7TxQ>
    <xmx:uvBcXSfLjt2WA6JAIAxVvskUgSVMbj-U6KrqxOrUKDZKpXeuT0dncA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9ECADD60057;
        Wed, 21 Aug 2019 03:20:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/7] mlxsw: reg: Add new trap actions
Date:   Wed, 21 Aug 2019 10:19:32 +0300
Message-Id: <20190821071937.13622-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821071937.13622-1-idosch@idosch.org>
References: <20190821071937.13622-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Subsequent patches will add discard traps support in mlxsw. The driver
cannot configure such traps with a normal trap action, but needs to use
exception trap action, which also increments an error counter.

On the other hand, when these traps are initialized or set to drop
action, they should use the default drop action set by the firmware.
This guarantees that when the feature is disabled we get the exact same
behavior as before the feature was introduced.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index ead36702549a..59e296562b5a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5559,6 +5559,8 @@ enum mlxsw_reg_hpkt_action {
 	MLXSW_REG_HPKT_ACTION_DISCARD,
 	MLXSW_REG_HPKT_ACTION_SOFT_DISCARD,
 	MLXSW_REG_HPKT_ACTION_TRAP_AND_SOFT_DISCARD,
+	MLXSW_REG_HPKT_ACTION_TRAP_EXCEPTION_TO_CPU,
+	MLXSW_REG_HPKT_ACTION_SET_FW_DEFAULT = 15,
 };
 
 /* reg_hpkt_action
@@ -5569,6 +5571,8 @@ enum mlxsw_reg_hpkt_action {
  * 3 - Discard.
  * 4 - Soft discard (allow other traps to act on the packet).
  * 5 - Trap and soft discard (allow other traps to overwrite this trap).
+ * 6 - Trap to CPU (CPU receives sole copy) and count it as error.
+ * 15 - Restore the firmware's default action.
  * Access: RW
  *
  * Note: Must be set to 0 (forward) for event trap IDs, as they are already
-- 
2.21.0

