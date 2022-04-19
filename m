Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A79750789E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357084AbiDSSZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357572AbiDSSXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:23:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FC843AF8;
        Tue, 19 Apr 2022 11:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C547561444;
        Tue, 19 Apr 2022 18:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDF2C385AD;
        Tue, 19 Apr 2022 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392194;
        bh=k/8eucsA20qaz2LGYTkOnoaj9M7PhP6Q6Ov+oEMP+zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWIju/x7BgALKgsSId/446neml9YQHUtnldRoJUIcn+N7E4ammscjP5HB714gzleJ
         syq4Ndk7kQOtO0AL1fedEXNcxA4BTUAa9xx/Af7VPExiPvadJsrh7lZ5Zh+HFoYqNL
         Y9qi5cW56v6CYnSsOpPf7y+AaDQ+yMRNeRHAKjdmtRsSNJpZXg7bnwiaab2mO8yLpv
         qRTc0SVzJBJClDIpiWNbjwYyoKCPAJup7yjELv+u+K0xnsg74Q7hfQes3Omx1fkhsA
         Qi8uc4hFbfcgCwwvTapShq1xBFoIZGIKJnRd9FUwGSq6LfhinRnsK2KpelNgfDlHjz
         BHdcty5PdGDmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hongbin Wang <wh_bin@126.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/7] vxlan: fix error return code in vxlan_fdb_append
Date:   Tue, 19 Apr 2022 14:16:22 -0400
Message-Id: <20220419181625.486476-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181625.486476-1-sashal@kernel.org>
References: <20220419181625.486476-1-sashal@kernel.org>
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

From: Hongbin Wang <wh_bin@126.com>

[ Upstream commit 7cea5560bf656b84f9ed01c0cc829d4eecd0640b ]

When kmalloc and dst_cache_init failed,
should return ENOMEM rather than ENOBUFS.

Signed-off-by: Hongbin Wang <wh_bin@126.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 0bfadec8b79c..d59cb381e80b 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -490,11 +490,11 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 
 	rd = kmalloc(sizeof(*rd), GFP_ATOMIC);
 	if (rd == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	if (dst_cache_init(&rd->dst_cache, GFP_ATOMIC)) {
 		kfree(rd);
-		return -ENOBUFS;
+		return -ENOMEM;
 	}
 
 	rd->remote_ip = *ip;
-- 
2.35.1

