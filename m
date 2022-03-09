Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6304D3699
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiCIQ1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiCIQZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:25:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D819151D1C;
        Wed,  9 Mar 2022 08:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B0F6B81EE7;
        Wed,  9 Mar 2022 16:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6D3C36AE2;
        Wed,  9 Mar 2022 16:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842928;
        bh=7OKr3nU3lmnU8/BDZvxuhWPz+5MGZaFGXpqhRXZxc7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jg1qbOZGLgjZxnS1hUWgswlruEeSr9K++TR/zmeml57vo8K0/brASkQW5CvM/7wqR
         TqpDWn4yyYgOPnSbb1Yc8yxV9AfQ2N+RAj/DhmSbdftK029FTIXRpiNs2Oz3QC1qKr
         tMup7MbMENTAv+fxXQPO4qLWkP5dn7f5WDf/wqhwgwcssdAvIpPsV2ej1HZGbxmZB9
         QVUZkPPPshSDMpknf7cj/JTH9S621Nf0kPMDh2UWBJ4BpVlzmzWSbz2IWRGW7jzQeR
         VNp40lzx83yrsm3GjbCB+W+UYsNtOENuOxkQxPQnmReLGSAWcANy6ipzJWf/J5jKMu
         5OUur6GcdZ17g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Yan <evitayan@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/20] xfrm: Fix xfrm migrate issues when address family changes
Date:   Wed,  9 Mar 2022 11:21:40 -0500
Message-Id: <20220309162158.136467-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162158.136467-1-sashal@kernel.org>
References: <20220309162158.136467-1-sashal@kernel.org>
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
index 37fe22b2e843..1befc6db723b 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1542,9 +1542,6 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
 	memcpy(&x->props.smark, &orig->props.smark, sizeof(x->props.smark));
 
-	if (xfrm_init_state(x) < 0)
-		goto error;
-
 	x->props.flags = orig->props.flags;
 	x->props.extra_flags = orig->props.extra_flags;
 
@@ -1631,6 +1628,11 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
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

