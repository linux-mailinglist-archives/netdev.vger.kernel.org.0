Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4A7542032
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383412AbiFHATK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588583AbiFGXys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE181B175E
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 16:36:28 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so16785224pjt.4
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 16:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EaypB14xKLH/WHSl6QOUJBVM+ha8jwdOhj6eXdaj77M=;
        b=dQbDQNWTdO3M57zJJp14ZF9p8EMYoiTxohrHZyrwIKE8l5T/PMD+2Zi+NFxhQgHtrP
         qpHaqZydS5kMqU7UD6mAblg6v8iM92P8zzCt8Dt5be67NdhoGnWVhcaN/atbNlAf03JS
         Ql2FjocrnZssgllCAmK+rsUt0VZjJg8A4RwZtO98CPVkIC3JE6/Try8ag08gAOGhuyb/
         V3+S9f6WPxK3l90N5uWB6Sa40GQzU8C/GY32Eyah4IX2DP76Bnv3n0WU2nIpY6+IKX4w
         N3WcZ3TBnhXlUwLiNX5RSdVwM5NIxHokxYSBP3y+l6GTOyVE3agvpXs50qLlgksG4x4H
         WtGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EaypB14xKLH/WHSl6QOUJBVM+ha8jwdOhj6eXdaj77M=;
        b=HGdDwqyYU7wFqW94bT1QrjJq5o73q6kRfHVfwNRole5IKkrytJaSzTaQbnLmfdXGTh
         Mf7JTEcY8mmdAx0EhWFOI7k932sDYwDCw/U3yrRL8YQYM1xqMuzcRgtYu9oXCXZhStqC
         rWiygBLLRJL9MUzisjuTHLZoI/vDA5s5faf3Os4Zm7k0/TN3kiVeXnR11huDfF088YBe
         5XsqyLs6zxJrkdJ4WEc3kmnyay8xDqP4G1m5xteLiENeRR4e3M8461rVmal0++yyc4bj
         rmurFZJ9OKbDL+yL5b2ymfN3YaQZKkiFDgOurY958Oo5qCugaY4gRRLJcKNTc9bOp9z8
         DOmg==
X-Gm-Message-State: AOAM531P1rwP1JGJ/xTErU1wVdkCkRygIfn1oh2zpcaIFGygINpRj46/
        inLnZRtKrBloRitGYRz9EQA=
X-Google-Smtp-Source: ABdhPJywoExQQYXNjokBPFGzz1X3wxWLT89jYBo7mh3BCTLTJgWQjKd14rrudzqtTmG1p/zCaLPPVg==
X-Received: by 2002:a17:90a:fb90:b0:1e3:809:9296 with SMTP id cp16-20020a17090afb9000b001e308099296mr34439470pjb.26.1654644988339;
        Tue, 07 Jun 2022 16:36:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id u79-20020a627952000000b0051ba7515e0dsm13550947pfc.54.2022.06.07.16.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:36:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/9] ip6_tunnel: use dev_sw_netstats_rx_add()
Date:   Tue,  7 Jun 2022 16:36:09 -0700
Message-Id: <20220607233614.1133902-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607233614.1133902-1-eric.dumazet@gmail.com>
References: <20220607233614.1133902-1-eric.dumazet@gmail.com>
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

