Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA79B5F9135
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiJIWaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiJIW2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:28:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2562D1C4;
        Sun,  9 Oct 2022 15:19:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7209860C2B;
        Sun,  9 Oct 2022 22:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F446C4347C;
        Sun,  9 Oct 2022 22:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353944;
        bh=79sX76vh9ai+k4JQ7VU0DTX+Fu1WGVzAUgZNp9U+T/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8jnz9g+8PUagMokGYRz7I+VvkHL6ZupWAqAOLUkm/INP6H0CUVXqikvcXSvifSPX
         U50GZ0cizGoJ7OE3cOyqKgY9PfjK35cpgBbJG8ZlhmD7dp4h7L2RgEgUDd1Ix9yAgy
         FMsx1WyS08HMSaT+Se04zUaZULHCMlQhWF6Axm5TVhJCCPpt9RKaUdANUXB4lE9GUo
         tkOhCZ7sUxRcfgo4o6Vb6AyqczCe3WBJVtrT3gliq9FifCFXiIfcihDPxHFX/jNpJq
         N/463UfKWI7OCdjCDGCWRvwm+AISF4Eh8cWcuEeFT8QQcxwhBuqcxdx2L2cdqfSKPp
         ejFGSiHuvmjDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 72/73] net: lan966x: Fix return type of lan966x_port_xmit
Date:   Sun,  9 Oct 2022 18:14:50 -0400
Message-Id: <20221009221453.1216158-72-sashal@kernel.org>
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

[ Upstream commit 450a580fc4b5e7f7fb8d9b1a0208bf0d1efc53a8 ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of lan966x_port_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20220929182704.64438-1-nhuck@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index d928b75f3780..be40c6d3ec68 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -344,7 +344,8 @@ static void lan966x_ifh_set_timestamp(void *ifh, u64 timestamp)
 		IFH_POS_TIMESTAMP, IFH_LEN * 4, PACK, 0);
 }
 
-static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t lan966x_port_xmit(struct sk_buff *skb,
+				     struct net_device *dev)
 {
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x *lan966x = port->lan966x;
-- 
2.35.1

