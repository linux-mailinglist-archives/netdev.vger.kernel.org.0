Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E0A6CFDA7
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjC3IDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjC3ID2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:03:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03013728C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:03:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6099F61F47
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48653C433A4;
        Thu, 30 Mar 2023 08:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163391;
        bh=6QOXn7fQw+WrXVKqb7OEl7WXtIBGkBpVPxWJxH+hcs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XI8LBXXAEESfr4NRv/w59ETVSkjBEn1W6wOkwvkNU+k802hXTShs11R6ijZhSgP6r
         22Qb/x9i6TOKaQCH24WAJoUbom+s6IY1ddTknwAY7UXSGUeaN4qdxX8785JtzgOJw4
         IgyzPz5nVoSQOMgmIM7FjWazlZCSncAUm1xlLMd6vQcSyKPKyTDsOWFiOCktApCyuS
         eW/5QQH59XMRYTL+GX6iMYNxvMNQfRX39M/iwhQLiMGRWtlFBg+IJmjL7zedi5vyME
         mKrrweQIsA9a33pYmPWoiy3CRGZxb6R//4Env7J08OTSctM2eAxCrhcT1teaucHGn3
         7D9MIBXi4vaCw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next 05/10] xfrm: don't require advance ESN callback for packet offload
Date:   Thu, 30 Mar 2023 11:02:26 +0300
Message-Id: <9f3dfc3fef2cfcd191f0c5eee7cf0aa74e7f7786.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680162300.git.leonro@nvidia.com>
References: <cover.1680162300.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In packet offload mode, the hardware is responsible to manage
replay window and advance ESN. In that mode, there won't any
call to .xdo_dev_state_advance_esn callback.

So relax current check for existence of that callback.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 95f1436bf6a2..bef28c6187eb 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -287,7 +287,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		return (is_packet_offload) ? -EINVAL : 0;
 	}
 
-	if (x->props.flags & XFRM_STATE_ESN &&
+	if (!is_packet_offload && x->props.flags & XFRM_STATE_ESN &&
 	    !dev->xfrmdev_ops->xdo_dev_state_advance_esn) {
 		NL_SET_ERR_MSG(extack, "Device doesn't support offload with ESN");
 		xso->dev = NULL;
-- 
2.39.2

