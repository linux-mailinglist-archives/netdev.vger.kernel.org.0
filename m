Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE35F5A0376
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 23:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbiHXVyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 17:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240183AbiHXVyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 17:54:00 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F09A754B0
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 14:53:58 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 4295 invoked from network); 24 Aug 2022 23:53:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1661378036; bh=4OTa75RLpe/v25mpI3TRXaOPqo4ZLnCOlukrrv8iGHU=;
          h=From:To:Subject;
          b=GqGggbVUHNjlcjWKR7lEtgdzHPAFUG1gqPzjjI2dC2GnpV+z/B6D9HnqA76cpmuIt
           BjF1/G17qF0oTv9EWhMrY/5bxSS+X1pYAhaHab+j2a7Gbv51cBAB9/KcfyHhUJN5CJ
           +c9GYhuxoJS6fMtWgBXaLnIH2f/4cAbJ5e044yjo=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 24 Aug 2022 23:53:56 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, olek2@wp.pl,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v3 1/3] net: lantiq_xrx200: confirm skb is allocated before using
Date:   Wed, 24 Aug 2022 23:54:06 +0200
Message-Id: <20220824215408.4695-2-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824215408.4695-1-olek2@wp.pl>
References: <20220824215408.4695-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: da954f5736fb02daf8954bf4042baf0e
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [oVMU]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xrx200_hw_receive() assumes build_skb() always works and goes straight
to skb_reserve(). However, build_skb() can fail under memory pressure.

Add a check in case build_skb() failed to allocate and return NULL.

Fixes: e015593573b3 ("net: lantiq_xrx200: convert to build_skb")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 5edb68a8aab1..89314b645c82 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -239,6 +239,12 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	}
 
 	skb = build_skb(buf, priv->rx_skb_size);
+	if (!skb) {
+		skb_free_frag(buf);
+		net_dev->stats.rx_dropped++;
+		return -ENOMEM;
+	}
+
 	skb_reserve(skb, NET_SKB_PAD);
 	skb_put(skb, len);
 
-- 
2.30.2

