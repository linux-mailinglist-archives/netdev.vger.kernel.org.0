Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB96C5F9330
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbiJIW4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiJIWzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256143EA60;
        Sun,  9 Oct 2022 15:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A468460C2A;
        Sun,  9 Oct 2022 22:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2516FC433B5;
        Sun,  9 Oct 2022 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354401;
        bh=SQ58DVirdJBtuXG+MP0LXpsC9Gh1J3QMqhvNTB5ka+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOpwyZntdxTzAPUavpPUYzYh3tGALCZQj8RiPmxGwYBxEIufEMrjDnWhJZDrs1L7D
         NF3v6w62/DilfA48qobHe/FfGNsg/om6dD3Ofnhs9E+sV/1gSRE/LSUuDKadnQNtiM
         aghIkF490YahjvP5XgVckef6T9s+xdW21VQdWSZmBb6Aw92J/+kslbHc8dTwaJabAM
         /IPBa1lilDoEAjsydMbRGVGSvPq+Fwp8q/iaBOIS0huirH0joYQ3KZZYDIbAoc+zDU
         cyNaY3Tf3FYnLetKD/dKJPFXjh78nq1UxOkHALXWK0r7iJx3UYrOTDs386sR27iGZ1
         KvpGcq1SV1UBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com, paul@xen.org,
        grygorii.strashko@ti.com, wsa+renesas@sang-engineering.com,
        chi.minghao@zte.com.cn, bigunclemax@gmail.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/23] net: ethernet: ti: davinci_emac: Fix return type of emac_dev_xmit
Date:   Sun,  9 Oct 2022 18:25:43 -0400
Message-Id: <20221009222557.1219968-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222557.1219968-1-sashal@kernel.org>
References: <20221009222557.1219968-1-sashal@kernel.org>
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
index da536385075a..f226e8f84835 100644
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

