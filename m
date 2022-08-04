Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E1F5895A0
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 03:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237444AbiHDBYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 21:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiHDBYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 21:24:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D363422DA
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 18:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72046CE2532
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 01:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D653C433C1;
        Thu,  4 Aug 2022 01:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659576274;
        bh=TVe5s1EJaDcLNxfhUXO7Hwn6qHjCp/TUToBgEEu9mWU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iWP/w8V0kuNH8CGH3ePvUWR6yphY0UG1jYsZi0mxmiAZPhkgUpnZpyKI0H30k+0sf
         LBx63YP7kA6fOtVdsb+so8XvEGBQPD6ceRmXEah26puOFIElqvefZS/kOeFMvpF/Dq
         BvkJAYpdMO5rvf2ZGiiGx6VYxtbYxsp5lefyKbv0uiDEKSqQwH8djQ0nRBrhF9hQn/
         vqFxd/i5zZ0M17c9WV9PLlPh6KlWCZiYq/QUAgsAJtQHfyZrLT3uCfCymaRLxpyEuJ
         ztawEhhD7NGZjP7MY+qkPVQ9zoqV15T1IBGLicBQ92Wz/3Ifk8hmUi+4cF3yfcpmlz
         Lmj7dDwPS3Kuw==
Date:   Wed, 3 Aug 2022 18:24:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Message-ID: <20220803182432.363b0c04@kernel.org>
In-Reply-To: <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
        <20220722235033.2594446-8-kuba@kernel.org>
        <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Aug 2022 17:54:01 +0300 Tariq Toukan wrote:
>   [  407.589886] RIP: 0010:tls_device_decrypted+0x7a/0x2e0

Sorry, got distracted yesterday. This?

--->8--------------------
tls: rx: device: bound the frag walk

We can't do skb_walk_frags() on the input skbs, because
the input skbs is really just a pointer to the tcp read
queue. We need to bound the "is decrypted" check by the
amount of data in the message.

Note that the walk in tls_device_reencrypt() is after a
CoW so the skb there is safe to walk. Actually in the
current implementation it can't have frags at all, but
whatever, maybe one day it will.

Reported-by: Tariq Toukan <tariqt@nvidia.com>
Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_device.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index e3e6cf75aa03..6ed41474bdf8 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -984,11 +984,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
 	int is_decrypted = skb->decrypted;
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
+	int left;
 
+	left = rxm->full_len - skb->len;
 	/* Check if all the data is decrypted already */
-	skb_walk_frags(skb, skb_iter) {
+	skb_iter = skb_shinfo(skb)->frag_list;
+	while (skb_iter && left > 0) {
 		is_decrypted &= skb_iter->decrypted;
 		is_encrypted &= !skb_iter->decrypted;
+
+		left -= skb_iter->len;
+		skb_iter = skb_iter->next;
 	}
 
 	trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - rxm->full_len,
-- 
2.37.1

