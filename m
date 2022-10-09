Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1344A5F931F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbiJIW4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiJIWyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:54:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C541B4A128;
        Sun,  9 Oct 2022 15:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D81460DD5;
        Sun,  9 Oct 2022 22:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209A7C433C1;
        Sun,  9 Oct 2022 22:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354463;
        bh=ghDC2JzNsdRhtz2HD3XyUozmlKJwAlnnnYqKEva3Eh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/BBmtqt1rZNRT+oWMXfnIGnT9atnckCMeIm3jsg5/wt6Uyd3rbM7kL/NLoo34b3M
         WYvPaxt8WZ1q6KDXjiN1HHkWq0l9gVadOOCcfxNhwJFDirMHqsqOFXvPvfYJ9/bMeP
         ApHBmdE6adWSjJ9LqQjyyQp9sn3ObK4/qObhGaMa/o1dV8j9Nmy+F+jjQ2BMbpBxJt
         HEez8qgZZ82MmPsgTP0oZS7z6jCtohhj9MksZPBOv2r0f7T7tQX2KbmCZqHION59/R
         wMZ2mhZ6UKvwTLhbef37xUoxiuslhLV9Yf9T1KJSm5Vq/LG0gkI5SvQATH+yvllB7B
         023DFVgObLhxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com, chi.minghao@zte.com.cn,
        leon@kernel.org, bigunclemax@gmail.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/16] net: ethernet: ti: davinci_emac: Fix return type of emac_dev_xmit
Date:   Sun,  9 Oct 2022 18:27:06 -0400
Message-Id: <20221009222713.1220394-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222713.1220394-1-sashal@kernel.org>
References: <20221009222713.1220394-1-sashal@kernel.org>
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

[ Upstream commit 5972ca946098487c5155fe13654743f9010f5ed5 ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of emac_dev_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20220912195023.810319-1-nhuck@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/davinci_emac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 37162492e263..ebf22429c349 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -955,7 +955,7 @@ static void emac_tx_handler(void *token, int len, int status)
  *
  * Returns success(NETDEV_TX_OK) or error code (typically out of desc's)
  */
-static int emac_dev_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t emac_dev_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct device *emac_dev = &ndev->dev;
 	int ret_code;
-- 
2.35.1

