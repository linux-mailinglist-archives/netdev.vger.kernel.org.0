Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D97C507744
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356326AbiDSSOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356281AbiDSSOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:14:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC133D4B1;
        Tue, 19 Apr 2022 11:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C80C660DBC;
        Tue, 19 Apr 2022 18:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BF5C385AB;
        Tue, 19 Apr 2022 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391905;
        bh=+4ERLeMoCDL81mPghiLb5qd2tpOF2FXOnp0KlKj/rdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GICuClnRm+Y5WPB7+8RV6TYXKrmyzYcY4e0aOhOU15yp3J/PUhYB7gB/r/VoREeEO
         iezkMPBrzuyCnhRvViZOr+ZQlOSVGSzzdbKmbSqoHI1TByrOd3bXg+7TJuZofM5TA9
         mmNSSbhHIcahA4ZKNU/zSuQNwDujl7yOcAByUKeVg9zojN1cGb3cM3VtzsFK3QvXR6
         08skMwa8zvRpJ0NIErnq7hLcWn32G9oBf15MjX8y+81IYf2D4GIP6FK6ab4Xrb24qL
         rfmYV6cAvwM3wLbgEuNWy6NX8YQyO28dn9qLuWT77F99WymQjUFMW1A9xkRm2Chp6B
         Fnbb2tQf+dGaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hongbin Wang <wh_bin@126.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 12/34] vxlan: fix error return code in vxlan_fdb_append
Date:   Tue, 19 Apr 2022 14:10:39 -0400
Message-Id: <20220419181104.484667-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
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
index 359d16780dbb..1bf8f7c35b7d 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -712,11 +712,11 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 
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

