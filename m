Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505C75F8FDA
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiJIWQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiJIWQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:16:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F1B6278;
        Sun,  9 Oct 2022 15:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF3BCB80DCE;
        Sun,  9 Oct 2022 22:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC3EC433D6;
        Sun,  9 Oct 2022 22:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353469;
        bh=qgniTSF+OJAJ5oQQqmSqvcCBvyeFINIUvqYDGmh5u6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hf023Bi/MhNYrPGWqUfBwqDskjI7fkkT0n2B/44RTNgoJgsyOwJyowIKFSkmWLzVF
         7DdPcAVvOEaTFTYM6v5e6Xf58VLz1wtZNLUB+QdMJqs6GO8zZ4c8ZN1AjYB5UX2M/3
         9K6QY4hhW/AphSIB8YPYHq2Vj4JTVaAq6SXQ2HF2+HW6q4YUtw876n4BkUVReavPOV
         V32nGufGmtL3bRQgFhpEGgWW0fNiAFDspgpv7MwI3cuaIilama+AmLP8YYZuRxyIFH
         DRSNltJVk4p7NT8FRPV8on562kByGIkhz4/GfAeE7nB8p97Ha58ZhkMqYpHOLozPEB
         fV0JgwXvjTFww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 42/77] wifi: rtw89: free unused skb to prevent memory leak
Date:   Sun,  9 Oct 2022 18:07:19 -0400
Message-Id: <20221009220754.1214186-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit eae672f386049146058b9e5d3d33e9e4af9dca1d ]

This avoid potential memory leak under power saving mode.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220916033811.13862-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index a5880a54812e..8b338e5ce364 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -872,6 +872,7 @@ int rtw89_h2c_tx(struct rtw89_dev *rtwdev,
 		rtw89_debug(rtwdev, RTW89_DBG_FW,
 			    "ignore h2c due to power is off with firmware state=%d\n",
 			    test_bit(RTW89_FLAG_FW_RDY, rtwdev->flags));
+		dev_kfree_skb(skb);
 		return 0;
 	}
 
-- 
2.35.1

