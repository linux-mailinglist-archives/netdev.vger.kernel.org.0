Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA74538110
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbiE3N72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiE3N5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:57:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A6E8AE5B;
        Mon, 30 May 2022 06:38:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC3C7B80DA9;
        Mon, 30 May 2022 13:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735D5C36AF9;
        Mon, 30 May 2022 13:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917928;
        bh=gam7VJRU5tQrQ47mhnmERO7Bdx+TDXwHG5e3vtQwqLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMRFq6ottsxCatfpGK/guUfTDWzh/PupJpzPrrEtUf9HiNN8kxyVGm8k4eUWOo3cT
         1cMM+CoqfVG+We4xNy+b5Exe07vgO+IeFse1NM3s8sKb+oVae+vRnA3cnA30bY8iu9
         1pfPFCaBXBsgOIQces+jqlXM7wDoqlaSpoPo+QrG8KndWTz7XGyWvXbD9bH0brypi5
         cTyQrVwYB/mD2dPrKVsQk5ioBvu5/AFyGnkSbuumiTUk4anRNoemfaO+hniFcbFs3Q
         ITuS7vLPtceL+xWjwkTRReKf0Bibe1ctE1Mmn9uvOCvq9rtWnYSio4bmPfADQlygUb
         XOcqabg/zLJDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haowen Bai <baihaowen@meizu.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stas.yakovlev@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 009/109] ipw2x00: Fix potential NULL dereference in libipw_xmit()
Date:   Mon, 30 May 2022 09:36:45 -0400
Message-Id: <20220530133825.1933431-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
index 36d1e6b2568d..4aec1fce1ae2 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
@@ -383,7 +383,7 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* Each fragment may need to have room for encryption
 		 * pre/postfix */
-		if (host_encrypt)
+		if (host_encrypt && crypt && crypt->ops)
 			bytes_per_frag -= crypt->ops->extra_mpdu_prefix_len +
 			    crypt->ops->extra_mpdu_postfix_len;
 
-- 
2.35.1

