Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A399542042
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384790AbiFHAUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588647AbiFGXyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F381B174F
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 16:36:26 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s14so16128787plk.8
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 16:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c/jFKJo8dPrv8P1o1Qlvafe9/ckmgvMeT8+RnXzRv0Y=;
        b=TFn1fsUvGI7DYZIicg8zsHTX8VehAWIJnpGmIrpgPvmAetR8b8qTzoensHpD2+APA7
         x1XQwlKaBQZ/5MqEhw192CfZ2USq4taQQUzBlevKCNiOTAgBAeynT4mWR7i0ewzmMIov
         SSkUqqUUoGX6IbUfZIeNQjl7eLKSj41VbbTXs7PN6Dj+RywDRQK9jSby3NQwExuNfKa1
         q8IO+2lm0qJDrR2700uCMgsybtSoqXV7tZ78NZwq8UhL2Th0piSZB6gIbGLBBa7E4jOX
         nHZPVjkDzF2BqmiECrad88iEkSIg+up879sl0rEsgW/DDbJvIXA8/YGM3BHl9W/RMghp
         GdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c/jFKJo8dPrv8P1o1Qlvafe9/ckmgvMeT8+RnXzRv0Y=;
        b=4FCRbOyHziqCZuQfBi2myJPaLoYS0Cr4eUCQt7WkWrQ1qY/sBIraZ3p5e1Cmbaiyhv
         1JQYatKg5DgbUwzMKr5FsLYm+0N9T7lSJBb/jGgGkevJ14DHNEjXFScjQKhgs7FKpNfm
         vGn97Kw9+E02gXDrtXBpoHVtMhPTE0IcLy5AWaXOTHfyiWhBM9tJvhlMHwbMhOVnwFS0
         OsN990Z27NRs1GP9+foRpUE85xXCGLMnZY/DLcjjfuC8XtStdmoXT6tOVhY66W6knujs
         +wA1AVpM7ZKstl2SScOrRerIzINswaPp6Z96c87ixpHYdRwurJ9XFai3UpuNl2vCKK/w
         claw==
X-Gm-Message-State: AOAM5315XznBLYVSyQ1tU8jv3uNPZHHI9vCOFY2MLho3fW3s9PY8crIO
        OfKEUAsvvZwBNumzR+4Dnlc=
X-Google-Smtp-Source: ABdhPJyY4tz/QnNAeibfl58mjXIlR4NGR+UW1L2NZLnlmHxdBDX4zGweZ/BEfJLdzzm4TU5LRXLCZQ==
X-Received: by 2002:a17:90b:1e46:b0:1e6:826e:73ea with SMTP id pi6-20020a17090b1e4600b001e6826e73eamr34090046pjb.68.1654644986298;
        Tue, 07 Jun 2022 16:36:26 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id u79-20020a627952000000b0051ba7515e0dsm13550947pfc.54.2022.06.07.16.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:36:25 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/9] sit: use dev_sw_netstats_rx_add()
Date:   Tue,  7 Jun 2022 16:36:08 -0700
Message-Id: <20220607233614.1133902-4-eric.dumazet@gmail.com>
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

