Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCDD5F9148
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiJIWbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiJIW3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BC63C8DB;
        Sun,  9 Oct 2022 15:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7627060AF2;
        Sun,  9 Oct 2022 22:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01BCC433D6;
        Sun,  9 Oct 2022 22:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353942;
        bh=vkat4yOAmBKTohHWR4IO8HDVyG+wngIzOyTOnf5NIBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNF+MKgrZ5E9BGW2s60yT3FTgv73eM+U7lfHb6ECKEvoOb5EaqNYkjIuWfGe5LrOX
         EG8IeXBRUIpgbqT4c4HnlLrUNeOu2Rch6Udu0fvC0fl/xE5MsueZKrE2g02a/SvQlz
         b4QA/5Duc/K35LvUz1BCZr8hA2joudPLmheCBJOEysq1SFr9buBgVRZsFiLGgTOAc8
         ROCK0Lv7MYReWFituWStfrau6QD68SX9USPxKylUbBiLpsimY1azCwTqQ48nzBdbn5
         AMylii/fUTl/980z6RtzQtzmoOi1yqPu/CMTc6iufLkB6tYsKj1EF3LQBWxgnCMM7s
         uoe2PnZ3lAvVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, nathan@kernel.org,
        ndesaulniers@google.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 71/73] net: sparx5: Fix return type of sparx5_port_xmit_impl
Date:   Sun,  9 Oct 2022 18:14:49 -0400
Message-Id: <20221009221453.1216158-71-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit 73ea735073599430818e89b8901452287a15a718 ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of sparx5_port_xmit_impl should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.h   | 2 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index d071ac3b7106..705d8852078f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -291,7 +291,7 @@ struct frame_info {
 void sparx5_xtr_flush(struct sparx5 *sparx5, u8 grp);
 void sparx5_ifh_parse(u32 *ifh, struct frame_info *info);
 irqreturn_t sparx5_xtr_handler(int irq, void *_priv);
-int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev);
+netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev);
 int sparx5_manual_injection_mode(struct sparx5 *sparx5);
 void sparx5_port_inj_timer_setup(struct sparx5_port *port);
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 21844beba72d..83c16ca5b30f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -222,13 +222,13 @@ static int sparx5_inject(struct sparx5 *sparx5,
 	return NETDEV_TX_OK;
 }
 
-int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 {
 	struct net_device_stats *stats = &dev->stats;
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5 *sparx5 = port->sparx5;
 	u32 ifh[IFH_LEN];
-	int ret;
+	netdev_tx_t ret;
 
 	memset(ifh, 0, IFH_LEN * 4);
 	sparx5_set_port_ifh(ifh, port->portno);
-- 
2.35.1

