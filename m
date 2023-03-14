Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4B86B8DFC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjCNI7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjCNI7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:59:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7957E94754
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A96FB818A1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E849C4339C;
        Tue, 14 Mar 2023 08:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784356;
        bh=sxKZFjeDSMLz1eY+eCxOildHyrYZLdZ7lMOpepBIMds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=st48crY+tQ9oEZoANIlE7BwpHwZ8LS3D82DAhD6ioSrabywG0h2MPk7xx517Vm+jq
         sjK9KWBlc2FuxoCUk143XNoDdUhN1n2ogv1Kw6gE2lM3L6zri5tCBDGYxI2FP5utmj
         6vwet/fL/XERAW1ei7hLAgz91CGo3zkuCs9DDYHPPCdSyEdpOmW/9jd2oPz6ukSb6M
         pT50XbuaWVdY3MzHiMuYd/vLnnvzOjr8SuuaJolK+MS/ihTyCm626kqDwWO8o9MuDX
         gkYuw5Acy026sC6cWFc5ns19EOrqjwEU5qxLNBZIB8Iaj/B1sEIGYCEJCrY6Ciu4MR
         MdFfPWIFwo2qA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Raed Salem <raeds@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 5/9] xfrm: copy_to_user_state fetch offloaded SA packets/bytes statistics
Date:   Tue, 14 Mar 2023 10:58:40 +0200
Message-Id: <d90ec74186452b1509ee94875d942cb777b7181e.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
References: <cover.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

Both in RX and TX, the traffic that performs IPsec packet offload
transformation is accounted by HW only. Consequently, the HW should
be queried for packets/bytes statistics when user asks for such
transformation data.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index cf5172d4ce68..5eee905b2450 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -901,6 +901,8 @@ static void copy_to_user_state(struct xfrm_state *x, struct xfrm_usersa_info *p)
 	memcpy(&p->id, &x->id, sizeof(p->id));
 	memcpy(&p->sel, &x->sel, sizeof(p->sel));
 	memcpy(&p->lft, &x->lft, sizeof(p->lft));
+	if (x->xso.dev)
+		xfrm_dev_state_update_curlft(x);
 	memcpy(&p->curlft, &x->curlft, sizeof(p->curlft));
 	put_unaligned(x->stats.replay_window, &p->stats.replay_window);
 	put_unaligned(x->stats.replay, &p->stats.replay);
-- 
2.39.2

