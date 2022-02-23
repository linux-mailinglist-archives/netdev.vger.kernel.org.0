Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD894C08D7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbiBWCdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbiBWCdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:33:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D3354695;
        Tue, 22 Feb 2022 18:30:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D3E6B81E16;
        Wed, 23 Feb 2022 02:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D66C340EB;
        Wed, 23 Feb 2022 02:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583454;
        bh=ivWUsLtsVfdwyX3MGqfIjbu4yO7DXDnawmsKBrxyaPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ln+etUpNr5W9YXbUS1lFUX7aN/dtF9mguuOrzF4o6ecDLwCRZNGugyWggjccm3/RN
         L64hRGZUssZHp+Ibg+CtAVjm1+DZIXcnRWzSRiW3nGtHtLBaH5cN0nYPvb2PeBoNun
         vQxdwreA78m3wQ3AfSlkFoOLsKDFI8zKFfNWwnhlURNOUx5442+FENrZS1KFSTyisS
         PpG8SbHSuNg1Voa3z7gna8byj4eNM0CTQwynTfkyuWsstMHb/qxWEbbF3HBByNKRE2
         y7VAeSSp+g/Pn5IzayIwOpRz7RcpbcxJWp79HYNmDBMwai0XS5RULvDE2U/iqVRiZg
         Bn96hQLYE1K1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jmaloy@redhat.com,
        ying.xue@windriver.com, kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.10 09/18] tipc: fix a bit overflow in tipc_crypto_key_rcv()
Date:   Tue, 22 Feb 2022 21:30:26 -0500
Message-Id: <20220223023035.241551-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023035.241551-1-sashal@kernel.org>
References: <20220223023035.241551-1-sashal@kernel.org>
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
index d8a2f424786fc..6f91b9a306dc3 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2280,7 +2280,7 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	struct tipc_crypto *tx = tipc_net(rx->net)->crypto_tx;
 	struct tipc_aead_key *skey = NULL;
 	u16 key_gen = msg_key_gen(hdr);
-	u16 size = msg_data_sz(hdr);
+	u32 size = msg_data_sz(hdr);
 	u8 *data = msg_data(hdr);
 	unsigned int keylen;
 
-- 
2.34.1

