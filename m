Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3984D348D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiCIQZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiCIQVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:21:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1221014EF69;
        Wed,  9 Mar 2022 08:17:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A4C261926;
        Wed,  9 Mar 2022 16:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA1DC340EC;
        Wed,  9 Mar 2022 16:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842656;
        bh=UqwiPp2qBmb+7tKFdE0+ShqjTMU9taITEwrPGtd63H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxucHaLffSUSn5RCqXd5Wgrdwvd9eVwYiezZgyJVp6kguh+rkkpxGYxhAkhryLU56
         ue+nHKkpcPT4Gl1Iz86RH8Wzf5OKyGqA23/s5Mt+V4SWdD0oE+ny6m6DYMxf0l5Eur
         QX4tv+BYMia9WySfJnyY/TFVIOrRW4nLi1xFyC1M/vYNjZjRrZwLozYJt451vLAA+E
         BXyvjGGDPZkowRpHjg2/FhdnPbMgrgKnra2xT2gTrCnqV8l7xztTYlM4YD8IxyU3vI
         wAmhv1ZRS/N46emWvHM4qiIMUlxYNKOhOn7TxGQ2tcIqIamDh/4kk/QMcPpKtzAQQW
         4q3BK8xtTQ5Pw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Yan <evitayan@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 04/27] xfrm: Fix xfrm migrate issues when address family changes
Date:   Wed,  9 Mar 2022 11:16:41 -0500
Message-Id: <20220309161711.135679-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yan Yan <evitayan@google.com>

[ Upstream commit e03c3bba351f99ad932e8f06baa9da1afc418e02 ]

xfrm_migrate cannot handle address family change of an xfrm_state.
The symptons are the xfrm_state will be migrated to a wrong address,
and sending as well as receiving packets wil be broken.

This commit fixes it by breaking the original xfrm_state_clone
method into two steps so as to update the props.family before
running xfrm_init_state. As the result, xfrm_state's inner mode,
outer mode, type and IP header length in xfrm_state_migrate can
be updated with the new address family.

Tested with additions to Android's kernel unit test suite:
https://android-review.googlesource.com/c/kernel/tests/+/1885354

Signed-off-by: Yan Yan <evitayan@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 291236d7676f..f7bfa1916968 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1578,9 +1578,6 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
 	memcpy(&x->props.smark, &orig->props.smark, sizeof(x->props.smark));
 
-	if (xfrm_init_state(x) < 0)
-		goto error;
-
 	x->props.flags = orig->props.flags;
 	x->props.extra_flags = orig->props.extra_flags;
 
@@ -1667,6 +1664,11 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 	if (!xc)
 		return NULL;
 
+	xc->props.family = m->new_family;
+
+	if (xfrm_init_state(xc) < 0)
+		goto error;
+
 	memcpy(&xc->id.daddr, &m->new_daddr, sizeof(xc->id.daddr));
 	memcpy(&xc->props.saddr, &m->new_saddr, sizeof(xc->props.saddr));
 
-- 
2.34.1

