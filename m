Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA65D5437DD
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244788AbiFHPq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244773AbiFHPqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:46:50 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72241265E
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:46:49 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s135so3622426pgs.10
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c/jFKJo8dPrv8P1o1Qlvafe9/ckmgvMeT8+RnXzRv0Y=;
        b=WdS8Sv7TT06zfHFW2ujWSgG3v9SIht9OTh+sdSCCQgpEapmRtUxquUCEGBz5z979mD
         sFzuhJkeiALb+iU8SUhpOhd3c9Uh4jUwAjvKa6gGRn8EKs7mjGaV+GqdAtup/O28mWVo
         5aZpX1x7foGBkl50KX6/M01xEwexTGFBUaTJ1Nob9CT6TNqxPtBPW6Zqs/H2cqomKtQ5
         pVjlJv3yRVfskXyqSDTZA4iT3Efq6yJ/o+evNe0BV2mEsOnCxNJqAdsw3gHWS3MtdvVo
         jANdfw63mxf0KwdBL1XijiwL/6aVNTFqIkp/u1+p4ZACz3jFTWbaK5aQxoiinISFNaj7
         13yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c/jFKJo8dPrv8P1o1Qlvafe9/ckmgvMeT8+RnXzRv0Y=;
        b=4O246skE7VHpTKP7gy4HwZ5x7289rNxMp6ErATDGAyvSJnF+p5gu8ShX7T+zViIfE4
         fRSO8mu76qrYHwb/yoKZ9gPv3rxbEA0Xacm7FSB0JdunqytQhdm80nHmY0qZn3xqShp7
         4DJ4gtEgRlhsp4octdO6xR1SwtBqr5NbE1PpGacMURfzgpxs9BYEJcH2HjImNkQ+dpR5
         M8UiicANQn1byRDeuy81+lFt46px6sv5VIrAQKOhkuO9PBNAH1p3x8+urflVVxKnvgOc
         EllqGwzei4jzMbzQjh4mX3txBtajyltKtauFQh4QdpgVwQtLvyjfVeM93ZecG2Wnzcsd
         uBRg==
X-Gm-Message-State: AOAM5321qWlCfhf4i6FT8SJsvyuP6uVXucKagJCl1tb4nQQcfhGK0qpW
        Bd2iYDPL3U3xRw50ODJqB10=
X-Google-Smtp-Source: ABdhPJzcoHdCrE829OQs58Ze4NZdjS1RY4NmiRZlyRuuPdbBdommJndFq6U71vdLD4ZAl6Fj5T+0tA==
X-Received: by 2002:a63:6c7:0:b0:3fe:3d3b:9921 with SMTP id 190-20020a6306c7000000b003fe3d3b9921mr2340323pgg.108.1654703209055;
        Wed, 08 Jun 2022 08:46:49 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm10885973pfx.61.2022.06.08.08.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:46:48 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 3/9] sit: use dev_sw_netstats_rx_add()
Date:   Wed,  8 Jun 2022 08:46:34 -0700
Message-Id: <20220608154640.1235958-4-eric.dumazet@gmail.com>
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
 net/ipv6/sit.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index c0b138c2099256bdcb041caa72407f234963c601..d3254aa80a5251bea50dd061cc437dbf793f96fd 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -686,8 +686,6 @@ static int ipip6_rcv(struct sk_buff *skb)
 	tunnel = ipip6_tunnel_lookup(dev_net(skb->dev), skb->dev,
 				     iph->saddr, iph->daddr, sifindex);
 	if (tunnel) {
-		struct pcpu_sw_netstats *tstats;
-
 		if (tunnel->parms.iph.protocol != IPPROTO_IPV6 &&
 		    tunnel->parms.iph.protocol != 0)
 			goto out;
@@ -724,11 +722,7 @@ static int ipip6_rcv(struct sk_buff *skb)
 			}
 		}
 
-		tstats = this_cpu_ptr(tunnel->dev->tstats);
-		u64_stats_update_begin(&tstats->syncp);
-		tstats->rx_packets++;
-		tstats->rx_bytes += skb->len;
-		u64_stats_update_end(&tstats->syncp);
+		dev_sw_netstats_rx_add(tunnel->dev, skb->len);
 
 		netif_rx(skb);
 
-- 
2.36.1.255.ge46751e96f-goog

