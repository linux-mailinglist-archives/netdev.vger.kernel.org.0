Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1010760B8CF
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiJXTyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbiJXTyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:54:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BC625708A
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BC8E614A4
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C12DC433C1;
        Mon, 24 Oct 2022 17:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666631976;
        bh=NJjrAstxruXUqSEjk/XuL+tXLef5NEMMkb1Ncn2E8GQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Ozb4lrU6cQ1Skh9hn6lp7N+qTdVpBR2/+NQ0JqTk69ea09p0ZwRxK2QZj+4GpKV75
         oe3pdvqLOSdpnKoZnkffy5kNuXDG0am0f9fLEhTcn7lfcX8kFU+R0tWoRfX34lJo26
         FmC1O8pUSOVCRFFzLWGFhXspdgkYeFSrZcNl7+FBzqNJLzi6+PUZ5h2hjXnJUxMo3l
         OVaMQG9ojuLxRXQPqEO4V5yh4UJu2hjxz1qeSRkOW/65ROrVagP6X4FfcDYFSIEa++
         7H/wYbhRSHWP2gtqh+YqoHNRlZODRSybAiK6TNVCRHIMDGcXJENGLYyArehmOXiLLD
         oQYeT/PHh6bkQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH xfrm-next] xfrm: Remove not-used total variable
Date:   Mon, 24 Oct 2022 20:19:31 +0300
Message-Id: <e0669dcaf87163da19d63280c45e924a66817e6a.1666631947.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Total variable is not used in xfrm_byidx_resize() and can
be safely removed.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index aa73e630aef5..405ec6842e04 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -606,7 +606,7 @@ static void xfrm_bydst_resize(struct net *net, int dir)
 	xfrm_hash_free(odst, (hmask + 1) * sizeof(struct hlist_head));
 }
 
-static void xfrm_byidx_resize(struct net *net, int total)
+static void xfrm_byidx_resize(struct net *net)
 {
 	unsigned int hmask = net->xfrm.policy_idx_hmask;
 	unsigned int nhashmask = xfrm_new_hash_mask(hmask);
@@ -684,7 +684,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 			xfrm_bydst_resize(net, dir);
 	}
 	if (xfrm_byidx_should_resize(net, total))
-		xfrm_byidx_resize(net, total);
+		xfrm_byidx_resize(net);
 
 	mutex_unlock(&hash_resize_mutex);
 }
-- 
2.37.3

