Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1808D593124
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbiHOO6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243015AbiHOO6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:58:07 -0400
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08BE20F77
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 07:57:52 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 24348 invoked from network); 15 Aug 2022 16:57:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1660575470; bh=bbx1VwhcpzU6gGqpU29j/UW9BkypCjsV6XkTw13EfUc=;
          h=From:To:Subject;
          b=tMLPK3C5RDAgm/+KbVTQBfyk8LkBVyRXI+L9vNmj2Q2bG423iz8wSejwzXwr1lhd8
           dZBUHgpmdq7sJf8FUjGXvt7uqTOa0Bw19vpTnMswT5lSC/VxhJCBKGXTFim/HpYwKA
           UdcD29Bw+Aa56r3QL4k7KLrvMXe4dXzX5GzTa9xg=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 15 Aug 2022 16:57:50 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, olek2@wp.pl,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 3/3] net: lantiq_xrx200: restore buffer if memory allocation failed
Date:   Mon, 15 Aug 2022 16:57:40 +0200
Message-Id: <20220815145740.12075-4-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815145740.12075-1-olek2@wp.pl>
References: <20220815145740.12075-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 1bd63f0328598b10214596221eb3464f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [cXOx]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a situation where memory allocation fails, an invalid buffer address
is stored. When this descriptor is used again, the system panics in the
build_skb() function when accessing memory.

Fixes: 7ea6cd16f159 ("lantiq: net: fix duplicated skb in rx descriptor ring")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 8f9155eacdb3..e817bc545d81 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -193,6 +193,7 @@ static int xrx200_alloc_buf(struct xrx200_chan *ch, void *(*alloc)(unsigned int
 
 	ch->rx_buff[ch->dma.desc] = alloc(priv->rx_skb_size);
 	if (!ch->rx_buff[ch->dma.desc]) {
+		ch->rx_buff[ch->dma.desc] = buf;
 		ret = -ENOMEM;
 		goto skip;
 	}
-- 
2.30.2

