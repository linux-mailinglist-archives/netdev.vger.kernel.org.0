Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202EA50785B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356961AbiDSSYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357287AbiDSSXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:23:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D7A433AE;
        Tue, 19 Apr 2022 11:15:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF848B818EE;
        Tue, 19 Apr 2022 18:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1332C385A9;
        Tue, 19 Apr 2022 18:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392137;
        bh=H+7J76yVJjZsQhiXj0f3cOOgJ06vpupY1VOdh3C30xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAfxmvM/pC6FpuomelPAXKLhj2pqjhEhQ4hQAh5TEB0aNCUHxzfNvqzu43kdPz2Lu
         tgsNylF8IytFcpCt8Ud7+Up+DBpEaJSzlBBSl0Cn2qgIib8WN2DqhVLuiXXidxsWxe
         sfXWZGkmZP9SS1wzjd/uAMsFwmfkhGzUW85ImTB/ZHUGzS3vIMccuVUn1OXu+Fkejf
         +tUiwXFpMtrOale7TVy1pn8TsrFXJlzE3dTeR+N/0HbTMSA/m1G4RgGbU4vom5qw2a
         L3Eq1VclciA6WJ9XBefFuwz+usmG9jIvZJ4NM6enwzplY6ZGZjthm6YzNXz/xDqbE5
         X+K+oOOueff3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hongbin Wang <wh_bin@126.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/12] vxlan: fix error return code in vxlan_fdb_append
Date:   Tue, 19 Apr 2022 14:15:18 -0400
Message-Id: <20220419181525.486166-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181525.486166-1-sashal@kernel.org>
References: <20220419181525.486166-1-sashal@kernel.org>
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
index eacc1e32d547..1b98a888a168 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -524,11 +524,11 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 
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

