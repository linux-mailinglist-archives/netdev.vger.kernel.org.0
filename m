Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC055F91E0
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiJIWmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiJIWk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:40:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3DF1B9CA;
        Sun,  9 Oct 2022 15:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23D6B60C99;
        Sun,  9 Oct 2022 22:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F301C433D7;
        Sun,  9 Oct 2022 22:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354034;
        bh=PsRNl2Dnj44JpC61qYoBTjVIFR761cattn6nyMPoyPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rR04FjE7yfQyFSW2PimJO1OoWZa+kZlA/+CUAsai5dbNqhoXEcSrxqtEg11yw83e6
         8LNrj6eWjRMA6Tx2BpU0Rh1EMJKIPrE9R5wIpE8uwEUemJd49BLJ8wYZ8N3NihlMcf
         7OK0Li9d6i2Z7YQod7DX1hpgUdV8m6RSdr9fbS5+ZNu2dve6Zn90Ed+701qqagLCMA
         VEHdEt3yQHgdvyNSkfq6Fm9AlfRJA23LUzLsld8DOVwA8p3GlFpHCMfWFWwoqV52oz
         hdCLGCuO6HKfOQxLrQRSkk+qzoZd/isnPPlDgYl4osjHQ4DFnM4b4rYgykGjIo6V1r
         UMK06xljQCyiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com, mkl@pengutronix.de,
        shayagr@amazon.com, chi.minghao@zte.com.cn,
        wsa+renesas@sang-engineering.com, bigunclemax@gmail.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 26/46] net: ethernet: ti: davinci_emac: Fix return type of emac_dev_xmit
Date:   Sun,  9 Oct 2022 18:18:51 -0400
Message-Id: <20221009221912.1217372-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
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
index d243ca5dfde0..4d3bd6e1db55 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -950,7 +950,7 @@ static void emac_tx_handler(void *token, int len, int status)
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

