Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3E15437D4
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbiFHPrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244784AbiFHPq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:46:56 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA8D3B3F3
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:46:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q12-20020a17090a304c00b001e2d4fb0eb4so24145142pjl.4
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EaypB14xKLH/WHSl6QOUJBVM+ha8jwdOhj6eXdaj77M=;
        b=dB/pKAT6K6fGmoFzw52vsE/bqji8iEZX1dO38EpI4oQ6orsquIkaTcPvv9uIpq1LCB
         QPIn2viF4ajVS3/qT3lY4G+GglBu1dPQzbiX7xCPMFAO1XSNS4Ojnem4v/3vrNd6DigP
         dX370BDld1D0hf00j1MUATjajegYLmAbSvuMFwlYOYIU+2p5FR1AUoYw5/Da3NcIOcUW
         JRwsD+Zafbs6jheJh4ElpZxRK01cTiwYFTRIHYG8NrcwX8xqbRWAlH+sMUI0aHa0juvw
         ySB2demOVz1hb3dmFaifq/7pB4GAcBP/wBbWDq5ZNg7hJ/MJ6rrn/nwl0YjwedffgPCS
         QlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EaypB14xKLH/WHSl6QOUJBVM+ha8jwdOhj6eXdaj77M=;
        b=vs1e5BUFzSd8KRoPDxuBlzMn8+MaNK0YlzShopBLlw26dsqQzy988+EUUgfoa8CRFz
         +0778S8U422uBwWT1LKHPDaiIwTa+Us8k1P6+TLRth2CvUo0b2hfyltjRNGu+m26S41t
         tMnA+9W0W/8/tp8qYOu9XdZqS4LKQ8XM2tNtET7b/7NckWA/FdX1g15vLLBjmFoDmKDS
         PX245wf6fstbEEddMnr2zmYUQaIOtsuN4Xl7x6URqDjJmd29Dw9ui9Vv2Xt/q4hC03Yw
         ga1QxVbaTky6ufoq1pGrS/EvoDhrLijhigzC4hnzrW/2NM41y1NpRijr75ZP5V4T870V
         iKCg==
X-Gm-Message-State: AOAM532WT0p7lBhCjbvjoJo3Pq36Qyfp/QrgaQytVIecQ8QQSJqaXuIe
        sb/kGt0hD2vX/az/rN1P97jRnfJuqbU=
X-Google-Smtp-Source: ABdhPJwYdMY3GemtSmzZKbczphGA8vfn2qQ0vOXyf+iKALmFfskFTYKzJIFGaa2y0qHq2+HEzoU85Q==
X-Received: by 2002:a17:903:2287:b0:164:95f:b4d6 with SMTP id b7-20020a170903228700b00164095fb4d6mr34499638plh.140.1654703210285;
        Wed, 08 Jun 2022 08:46:50 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm10885973pfx.61.2022.06.08.08.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:46:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 4/9] ip6_tunnel: use dev_sw_netstats_rx_add()
Date:   Wed,  8 Jun 2022 08:46:35 -0700
Message-Id: <20220608154640.1235958-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608154640.1235958-1-eric.dumazet@gmail.com>
References: <20220608154640.1235958-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We have a convenient helper, let's use it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6_tunnel.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 19325b7600bba3a8c8bd5a41be9d2340186d44aa..ded5b813e21fa28ea3c9c9c10f6b89de893990c2 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -796,7 +796,6 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 						struct sk_buff *skb),
 			 bool log_ecn_err)
 {
-	struct pcpu_sw_netstats *tstats;
 	const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	int err;
 
@@ -856,11 +855,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 		}
 	}
 
-	tstats = this_cpu_ptr(tunnel->dev->tstats);
-	u64_stats_update_begin(&tstats->syncp);
-	tstats->rx_packets++;
-	tstats->rx_bytes += skb->len;
-	u64_stats_update_end(&tstats->syncp);
+	dev_sw_netstats_rx_add(tunnel->dev, skb->len);
 
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(tunnel->dev)));
 
-- 
2.36.1.255.ge46751e96f-goog

