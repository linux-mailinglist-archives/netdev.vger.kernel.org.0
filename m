Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEBA4C07F1
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbiBWC3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236883AbiBWC3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:29:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114A2457A5;
        Tue, 22 Feb 2022 18:28:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87AE56150E;
        Wed, 23 Feb 2022 02:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16BBC36AE2;
        Wed, 23 Feb 2022 02:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583327;
        bh=+oaw10vcsziuPG1r4+KJScrE4s0dXjQd4Jd7dTVsJvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7EB8AByuqCy1VDGoQDvD+D0tZT6GsU8dD5X5rAbgLkJYn6NMxSvPmQG4Kggho9oP
         LiNEXxM6SaR4o0/84bj9DCw7JdbShFHLoMHwDwWEmavXD1p+eXiDRPx+VRv2ENQPtt
         wIGX2yPONSRkrpVLr6qFgsSWAAf/E5yCg7K+EwZ1djAyu0J+EaLzXq0C36b7DWGAjJ
         cJgmWtnQ7rwuuKoly4dRZeIiMgmndZcjDm3EEZ95sr7JCQOCOVgGkQaG53Gowjs/EK
         OFDLvXSiyxOQNvJB2FvYP4c8qrFaeFJGgVwZcaUW//gNXfPa6OoVfz6vuEZ+pVUpRq
         NejGfeBxeQN3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jmaloy@redhat.com,
        ying.xue@windriver.com, kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.16 13/30] tipc: fix a bit overflow in tipc_crypto_key_rcv()
Date:   Tue, 22 Feb 2022 21:28:02 -0500
Message-Id: <20220223022820.240649-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022820.240649-1-sashal@kernel.org>
References: <20220223022820.240649-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 143de8d97d79316590475dc2a84513c63c863ddf ]

msg_data_sz return a 32bit value, but size is 16bit. This may lead to a
bit overflow.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index d293614d5fc65..b5074957e8812 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2287,7 +2287,7 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	struct tipc_crypto *tx = tipc_net(rx->net)->crypto_tx;
 	struct tipc_aead_key *skey = NULL;
 	u16 key_gen = msg_key_gen(hdr);
-	u16 size = msg_data_sz(hdr);
+	u32 size = msg_data_sz(hdr);
 	u8 *data = msg_data(hdr);
 	unsigned int keylen;
 
-- 
2.34.1

