Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AB363AD7B
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiK1QSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiK1QSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:18:18 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C645F83
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 08:18:17 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id u10so2110943qvp.4
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 08:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QRM45gszMVlwgq/275cJ2cExN1fTFmWezEXKE3Cy7sY=;
        b=dSO3LPYnyhBu26DF0T5VgBRe0ynjh2T9uYnhXWKKPLxq7XYGsXJ6LhAfBT7nbb+Okg
         8z2eVgzuxAI0T9p7zeokAOX+tOiwB2jLQRoToX8xsya0/lt5YvTvyCdxxNxhXP41pMyk
         WZkG8B/xdpCrNdqJjJC3RRzsF52tq6NRDrVObCAn9U3al4WvKGllgV5P5IoRLINFFaML
         yTsN2vRvBUJNGb5x8o5hWQuNTNjQiYana+KB+WQtIF6L+nqcP296+Jy7t46+76/B5jew
         /bp8wN1Y7BGUsPJiMr5gD2MdIrLFOwO3pHPDSMBIM2wRBgejuD8O/x6YF8qBFxUflKPl
         IfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QRM45gszMVlwgq/275cJ2cExN1fTFmWezEXKE3Cy7sY=;
        b=btM5QupZx++FYwy0TpCsc4BaB3h3Lbkoo0YdhgL0euPkGaVtk2lgDGyFtQhdZiHgWK
         Z1y62Nrnk7KdmJnhufCvEDuJpLiUnhYAuypmLEonNzdcsQpL+6p1HM1YLrVcEgpcpyv7
         BPntJ/W6BtgoOTpCHl539DPRLp8H7VxGRz/+gz/oKYp/fx65dztLAw+hTeWEu1Tkd623
         VVv1XoI5af8N0wt+ApIoUlGfHY059X3DFKxYZxgaNevuNRYsSQNlDib0D8mifLu1pjd6
         58XpZgad5yv+qqfjyG/DiwDZCY5wfWl5hv4EGVlVr7Wk3fkTlOaZHraJ0isGWRuwnkBg
         HoFA==
X-Gm-Message-State: ANoB5pmQPB4XsWbOTIsRqAExDKF6yOZEEPSa5/11xA6wfjU/9Pt/VSfJ
        d62/+TJ9r9JezPOYLlhS2b0ZUFhnP5yxGQ==
X-Google-Smtp-Source: AA0mqf4bD8XGTmOZZB/P7eEFi3LrZxrNvf2CzRLPqN4VjQzcFGgGR3jXRQNMwR6ce5Oku3akYiZ8lw==
X-Received: by 2002:a0c:bed2:0:b0:4c6:ac5c:fda3 with SMTP id f18-20020a0cbed2000000b004c6ac5cfda3mr29671338qvj.17.1669652296326;
        Mon, 28 Nov 2022 08:18:16 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id bp34-20020a05620a45a200b006b929a56a2bsm8765209qkb.3.2022.11.28.08.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:18:16 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, al.drozdov@gmail.com, alexanderduyck@fb.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE
Date:   Mon, 28 Nov 2022 11:18:12 -0500
Message-Id: <20221128161812.640098-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

CHECKSUM_COMPLETE signals that skb->csum stores the sum over the
entire packet. It does not imply that an embedded l4 checksum
field has been validated.

Fixes: 682f048bd494 ("af_packet: pass checksum validation status to the user")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/packet/af_packet.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 6ce8dd19f33c..1ab65f7f2a0a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2293,8 +2293,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		status |= TP_STATUS_CSUMNOTREADY;
 	else if (skb->pkt_type != PACKET_OUTGOING &&
-		 (skb->ip_summed == CHECKSUM_COMPLETE ||
-		  skb_csum_unnecessary(skb)))
+		 skb_csum_unnecessary(skb))
 		status |= TP_STATUS_CSUM_VALID;
 
 	if (snaplen > res)
@@ -3520,8 +3519,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			aux.tp_status |= TP_STATUS_CSUMNOTREADY;
 		else if (skb->pkt_type != PACKET_OUTGOING &&
-			 (skb->ip_summed == CHECKSUM_COMPLETE ||
-			  skb_csum_unnecessary(skb)))
+			 skb_csum_unnecessary(skb))
 			aux.tp_status |= TP_STATUS_CSUM_VALID;
 
 		aux.tp_len = origlen;
-- 
2.38.1.584.g0f3c55d4c2-goog

