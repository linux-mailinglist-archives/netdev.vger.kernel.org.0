Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D042C52C50B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242887AbiERU4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242888AbiERU4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:56:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BFC16D485
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF272B821BA
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A04DC385A9;
        Wed, 18 May 2022 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652907408;
        bh=GZU0BeJH9huwYAv3W+vPg4bn9LnDsnsFU+EFq4CR0r4=;
        h=From:To:Cc:Subject:Date:From;
        b=sHZVvsMiPjt3RRrcGjWluX9Xizwv1VKxXqSOexecyv8uFcWN3SkO8A5rMHgVbZ265
         O7prRqOg5XGvrBxFgHyrON2akA0x3GZQV5MUcIp89+sQOl8VlIIxKnp5wpbfzaZBv3
         ovqrXH4BgU2W2eqbmFC1Cleip0qo21qu2VTI+8ksSRbw+4fwt9Qkc9QCZ6M/ygi63O
         A3D4JVaWcF40mPdmEF5Sfj9/4dJBWnnKdw5h0Dyy4pFJuNDYDZ5+7K2R7sPNcKswlH
         htBZ2LxSGBGCZrbAVPT6p2/uc81Dukr1IxnMbZZSoZbiJCSiGhQklSlTfLGU8meb+u
         +jG5aMHQsuxVw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Artem Savkov <asavkov@redhat.com>, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Subject: [PATCH net-next] net: tls: fix messing up lists when bpf enabled
Date:   Wed, 18 May 2022 13:56:44 -0700
Message-Id: <20220518205644.2059468-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Artem points out that skb may try to take over the skb and
queue it to its own list. Unlink the skb before calling out.

Fixes: b1a2c1786330 ("tls: rx: clear ctx->recv_pkt earlier")
Reported-by: Artem Savkov <asavkov@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
CC: daniel@iogearbox.net
---
 net/tls/tls_sw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 939d1673f508..0513f82b8537 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1837,15 +1837,17 @@ int tls_sw_recvmsg(struct sock *sk,
 			bool partially_consumed = chunk > len;
 
 			if (bpf_strp_enabled) {
+				/* BPF may try to queue the skb */
+				__skb_unlink(skb, &ctx->rx_list);
 				err = sk_psock_tls_strp_read(psock, skb);
 				if (err != __SK_PASS) {
 					rxm->offset = rxm->offset + rxm->full_len;
 					rxm->full_len = 0;
-					__skb_unlink(skb, &ctx->rx_list);
 					if (err == __SK_DROP)
 						consume_skb(skb);
 					continue;
 				}
+				__skb_queue_tail(&ctx->rx_list, skb);
 			}
 
 			if (partially_consumed)
-- 
2.34.3

