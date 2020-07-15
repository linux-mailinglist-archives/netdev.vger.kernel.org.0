Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622D5220724
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgGOI2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:06 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58439 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726396AbgGOI2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CE6C85C00D7;
        Wed, 15 Jul 2020 04:28:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=CLWycuEyKRHMOkKULr2Z+uYd0c/1e24k00mP4j9PPs0=; b=LSMr5kEs
        Oy7Wb2CiO1vDszv4rzHPpLEc3dgTZg3G8xb2tPgjOVkYENPrk+RBcgeM7HvuDOU8
        NoDvKWqFkHB3vR2iDoWdCAZCPg0JYxBqmSykLM+Y+2IWduettkfhdmXU6Af/v2Sw
        FO7IyEBue4jpumwxPZzQSkWp7jJ7ufhQ05OY001zQkW+lGowjOy9bgeB0YQeW8Ml
        hADs27eicUdBKbyoA9gIZJ8/yrvC4fFBgqlOJbayfYYkmxQQjKNB+MqjUq4D+bsL
        vxScUrZZ9tiJP+SOSabiqVUOMmpWE2h4mFqll1+1avlpd4nFWM2P0C4s0MLgAcLt
        lavB232vetMEPw==
X-ME-Sender: <xms:E74OX2evzx_1qUuy8DBLBGd2SeX8X5oKFhGWOCTCjEscz1-xzHlAnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:E74OXwNV7m-24Tn6B0_VaG_vDY_qoJAk2U3icLWJv3wsuU1VXHsZxA>
    <xmx:E74OX3g8_7jjz6JriqT74QgoK2HpobOjlFoCOHOR9nrIWNNyx7e_kQ>
    <xmx:E74OXz_7gyhWaIUZaRK0OH6ij68apWsYrDUFWmnmuImsLwWj_886uw>
    <xmx:E74OX74flPt5LKRVR7H6OlxBaByS1VUN03p-SlWxziy-4haMMHOWIw>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id EFF71328005A;
        Wed, 15 Jul 2020 04:28:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/11] mlxsw: reg: Add policer bandwidth limits
Date:   Wed, 15 Jul 2020 11:27:23 +0300
Message-Id: <20200715082733.429610-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add policer bandwidth limits for both rate and burst size so that they
could be enforced by a later patch.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 408003520602..3c5b25495751 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3405,11 +3405,20 @@ MLXSW_ITEM32(reg, qpcr, violate_action, 0x18, 0, 4);
  */
 MLXSW_ITEM64(reg, qpcr, violate_count, 0x20, 0, 64);
 
+/* Packets */
 #define MLXSW_REG_QPCR_LOWEST_CIR	1
 #define MLXSW_REG_QPCR_HIGHEST_CIR	(2 * 1000 * 1000 * 1000) /* 2Gpps */
 #define MLXSW_REG_QPCR_LOWEST_CBS	4
 #define MLXSW_REG_QPCR_HIGHEST_CBS	24
 
+/* Bandwidth */
+#define MLXSW_REG_QPCR_LOWEST_CIR_BITS		1024 /* bps */
+#define MLXSW_REG_QPCR_HIGHEST_CIR_BITS		2000000000000ULL /* 2Tbps */
+#define MLXSW_REG_QPCR_LOWEST_CBS_BITS_SP1	4
+#define MLXSW_REG_QPCR_LOWEST_CBS_BITS_SP2	4
+#define MLXSW_REG_QPCR_HIGHEST_CBS_BITS_SP1	25
+#define MLXSW_REG_QPCR_HIGHEST_CBS_BITS_SP2	31
+
 static inline void mlxsw_reg_qpcr_pack(char *payload, u16 pid,
 				       enum mlxsw_reg_qpcr_ir_units ir_units,
 				       bool bytes, u32 cir, u16 cbs)
-- 
2.26.2

