Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6D35F92D6
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbiJIWwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbiJIWuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:50:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD35244566;
        Sun,  9 Oct 2022 15:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 380BFB80DF3;
        Sun,  9 Oct 2022 22:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2F3C4347C;
        Sun,  9 Oct 2022 22:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354395;
        bh=yqZYWXR6vXSombml3yoWCJDCrW/Il5js3fURJ9axIDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuVVKtJF/dNobkazh9bKRi5qTKTuLHsgAnQPrRtwygLxgSunus1sFZTTNCuDOS4hf
         nnftEMe81uRFs2tcpVfe64BigI2sp7AHouXLgcCwPXN3Ygw2EWIS0ptbnzUyYAOuv2
         7wS8iYO1e2qiHeVzxXek9TeUCkC40K9W594VHYRX/QfekROPNQrivfpLwXP+22a6ME
         +bUA47q2e2haCTJ0qk2yjrhPHZ1044YWRwO4CNnfs7jaB6wRU3D79RodW4SGa2LsVY
         3OePJD+5BwyJnihRq7rasJYSVaHTc06nfAs8zj5Si8MuZPxzVGGBp2WnEPnCYS8LiK
         jbN6uLBhNmgrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        khalasa@piap.pl, thomas.lendacky@amd.com, shayagr@amazon.com,
        wsa+renesas@sang-engineering.com, dmitry.torokhov@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/23] net: davicom: Fix return type of dm9000_start_xmit
Date:   Sun,  9 Oct 2022 18:25:42 -0400
Message-Id: <20221009222557.1219968-12-sashal@kernel.org>
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

[ Upstream commit 0191580b000d50089a0b351f7cdbec4866e3d0d2 ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of dm9000_start_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20220912194722.809525-1-nhuck@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/davicom/dm9000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 8b07890b0b23..833e27ce4a57 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1025,7 +1025,7 @@ static void dm9000_send_packet(struct net_device *dev,
  *  Hardware start transmission.
  *  Send a packet to media from the upper layer.
  */
-static int
+static netdev_tx_t
 dm9000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	unsigned long flags;
-- 
2.35.1

