Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFC7593129
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242690AbiHOO6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242617AbiHOO5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:57:50 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A551B20F7B
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 07:57:46 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 17361 invoked from network); 15 Aug 2022 16:57:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1660575464; bh=nI++WfODD/yYiC7hRLpfGQNbFWOWckb7AI78JuFGSFU=;
          h=From:To:Subject;
          b=OJhdmCql7gYzw+6xEOpJY65Lc7Y7EPEtH8fSPkWTjO63SnxB/76S9/o+ZliX8TnVd
           9yZbPgggOaQep48xPzP6lg+aHdc7oiUx95h6mJDh7tPaPvD/G/iz5bhcAyrp9IBsym
           w0HVm3P4K2d2dWsXYtOr/EDGpJyavFOyh00+AKn8=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 15 Aug 2022 16:57:44 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, olek2@wp.pl,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/3] net: lantiq_xrx200: confirm skb is allocated before using
Date:   Mon, 15 Aug 2022 16:57:38 +0200
Message-Id: <20220815145740.12075-2-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815145740.12075-1-olek2@wp.pl>
References: <20220815145740.12075-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: f46c6734638bb11ccfcfeb7ea0101ceb
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [EZNE]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 drivers/net/ethernet/lantiq_xrx200.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 5edb68a8aab1..6a83a6c19484 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -239,6 +239,13 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	}
 
 	skb = build_skb(buf, priv->rx_skb_size);
+	if (!skb) {
+		skb_free_frag(buf);
+		net_dev->stats.rx_dropped++;
+		netdev_err(net_dev, "failed to build skb\n");
+		return -ENOMEM;
+	}
+
 	skb_reserve(skb, NET_SKB_PAD);
 	skb_put(skb, len);
 
-- 
2.30.2

