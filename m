Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0323C507862
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356689AbiDSSS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356678AbiDSSRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:17:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269CF3D4B9;
        Tue, 19 Apr 2022 11:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8D8760C86;
        Tue, 19 Apr 2022 18:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40507C385AF;
        Tue, 19 Apr 2022 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391987;
        bh=E3YA0VDkKR9MVzQZUwZQbMCrslKr57iOaOn7doSJ9vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzsHibOj0aPGbbpFcroiL6S5N9Hxs9kvQYJNM18vwmIw79RvNXbQRETgpTIAtfm8m
         1q4G9gDD9IW0uxqzrWIi4wOavvT7WwLRpV0ff4MQP94fnkVswYCVcfFu+60vMNilL+
         muRVzXsDxjGgULBJh/m7VhvBcpN9OOMemFOv8zNCM8EwMcDEM9jJxTg7Ny5A5aHvXO
         jnUgFmVWUq/9B5czvHurqBPo7iP6rhMsU1u2SEolPxs+J5wix72eQSdm6Yl8MZpE1/
         OIigrPGaEK2Ldl6REebOpmo5WluNm+mrPNpD+ERJgJLhVEZ7YQetsKvjAvLCGf9cNG
         FAgQl6KhWalfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hongbin Wang <wh_bin@126.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/27] vxlan: fix error return code in vxlan_fdb_append
Date:   Tue, 19 Apr 2022 14:12:23 -0400
Message-Id: <20220419181242.485308-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
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
index 141635a35c28..129e270e9a7c 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -711,11 +711,11 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 
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

