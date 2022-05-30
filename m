Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8779538342
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241241AbiE3OcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241873AbiE3Oai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991DA7C147;
        Mon, 30 May 2022 06:52:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8883560FA9;
        Mon, 30 May 2022 13:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FBDC385B8;
        Mon, 30 May 2022 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918744;
        bh=MCszyBWeUPvnplr+ZVV3l3gdJlhYYG7FczokiuEQy0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QReCy8gkheI2RrPtUBf9TMvBXLV2NrzlGJGisG9JaCvxp5okaFm6NgWzsLqTQhPYd
         sD0KPEbw9b+rcCt1mGzGA0IhDuJyMNMoDiPMQqeX0gzAG49Ler8y9Xsy1pcPxNZqZ1
         zWZ68zIW4z83PQmD7p+UUodycltacqNmi2J2CubDgjjciU1yQxtiaBlformLnqdLh6
         ZJIsYVyYe+S1bM+M9DnthBzphEN+C8WFbRSRxiw45AbQnnsyn3hp7Kz08Nevrw8QjC
         VETILzmzJcj3ah8nfAEmTO74KwtsWs1bwWmyhpeDTjSrqeuC1B5eJfn6ysn/uPAyyq
         YAiqNPomyUdEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haowen Bai <baihaowen@meizu.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stas.yakovlev@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/24] ipw2x00: Fix potential NULL dereference in libipw_xmit()
Date:   Mon, 30 May 2022 09:51:52 -0400
Message-Id: <20220530135211.1937674-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530135211.1937674-1-sashal@kernel.org>
References: <20220530135211.1937674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haowen Bai <baihaowen@meizu.com>

[ Upstream commit e8366bbabe1d207cf7c5b11ae50e223ae6fc278b ]

crypt and crypt->ops could be null, so we need to checking null
before dereference

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1648797055-25730-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
index e8c039879b05..cb30b3b63635 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
@@ -397,7 +397,7 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* Each fragment may need to have room for encryption
 		 * pre/postfix */
-		if (host_encrypt)
+		if (host_encrypt && crypt && crypt->ops)
 			bytes_per_frag -= crypt->ops->extra_mpdu_prefix_len +
 			    crypt->ops->extra_mpdu_postfix_len;
 
-- 
2.35.1

