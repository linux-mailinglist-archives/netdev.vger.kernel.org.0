Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922D460CADC
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiJYLYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiJYLYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:24:41 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9954515202C
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:40 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y1so11516543pfr.3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l6WKZVowwJKx99x52qYH6uDD4EwiMH/OqDvIe+d8MU0=;
        b=j8Ks/d1vMe+7TfnnOQpmhYNmy8lkKZUtJRx36oh8aVL134FgVQ7UnxG2Kt4wKoe1OK
         dSlsaOe0NiWdBpZa/qYVa4DBpeJ36VC0EGxL3wH+UP0T2AcM9XKjN3M2G+LHv9M3n7Q/
         8UhhI8MqrtP0fyOMewKoxDzc4IW6bgS2wZyKnvjZzSzNehc/Wi2y9Q/K/GzdAT4F8zww
         wB0e/GUiFZ2MhBWMUOXmUIHdPb/2pqc9i7NIiYgvcUjQdudlrniQb/SQSvfsRy0eaZLS
         jvpYcYl6ghG32Ik2AuLWN3pTgv/MEbBIoODKiZtgwAodlbFwa3J9hNqEF7ngQHqNdKJd
         8HDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l6WKZVowwJKx99x52qYH6uDD4EwiMH/OqDvIe+d8MU0=;
        b=R0CYRid+Lx2lKX86naZaLJG2tVm79I6HotM847ZH3FLOj6VJwhlvy6XgsYYRtHeq0N
         l09d/aGH87810h9MBGw/ZzPn9u7RWGIjLf9O4gonhtC07ccHN9V0ksDj4ZTU+ZlPUTDL
         u69Pa4dUty+kp7iZXlnuyGjwuz0WkQyMRZzv683KJUeJ1/dYhnF+f0glctHq5Osr6aL0
         3EAeW0GachbBTaZnrDeDwzhMACqK7pIwmvbRNR5TgpwC415InWS7utahWKRx0oJJiNOj
         bGNEovNb+czw/5ZGYh++95hlFksXIwV41FJQ1H0vGT3kAy83YKJd6hZTK8F4GvF435DF
         x0Xw==
X-Gm-Message-State: ACrzQf2oxrq6Z5VuKYKYQmastFhpl09RDvlkmwjhXAYYIwk0EGqH7nDJ
        f0fuDStfZiIgXJejVjtdZvzRtQ==
X-Google-Smtp-Source: AMsMyM61xPRn5JPZS/18kRGZM0AL2MZserjVJAQZZx7wGIXe4yAooDa1IuUGAoj1SQ+uIai6ODLcJQ==
X-Received: by 2002:a63:4461:0:b0:43c:dbdb:90c4 with SMTP id t33-20020a634461000000b0043cdbdb90c4mr31192208pgk.340.1666697080099;
        Tue, 25 Oct 2022 04:24:40 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w20-20020a1709029a9400b00185507b5ef8sm1073425plp.50.2022.10.25.04.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 04:24:39 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Neel Patel <neel@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/5] ionic: enable tunnel offloads
Date:   Tue, 25 Oct 2022 04:24:25 -0700
Message-Id: <20221025112426.8954-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221025112426.8954-1-snelson@pensando.io>
References: <20221025112426.8954-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neel Patel <neel@pensando.io>

Support stateless offloads for GRE, VXLAN, GENEVE, IPXIP4
and IPXIP6 when the FW supports them.

Signed-off-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 8 +++++++-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 8 ++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f5d39594ef54..4dd16c487f2b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1491,7 +1491,13 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 		   NETIF_F_RXCSUM |
 		   NETIF_F_TSO |
 		   NETIF_F_TSO6 |
-		   NETIF_F_TSO_ECN;
+		   NETIF_F_TSO_ECN |
+		   NETIF_F_GSO_GRE |
+		   NETIF_F_GSO_GRE_CSUM |
+		   NETIF_F_GSO_IPXIP4 |
+		   NETIF_F_GSO_IPXIP6 |
+		   NETIF_F_GSO_UDP_TUNNEL |
+		   NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
 	if (lif->nxqs > 1)
 		features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index c03986bf2628..190681aa7187 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -925,8 +925,12 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 
 	len = skb->len;
 	mss = skb_shinfo(skb)->gso_size;
-	outer_csum = (skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM) ||
-		     (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM);
+	outer_csum = (skb_shinfo(skb)->gso_type & (SKB_GSO_GRE |
+						   SKB_GSO_GRE_CSUM |
+						   SKB_GSO_IPXIP4 |
+						   SKB_GSO_IPXIP6 |
+						   SKB_GSO_UDP_TUNNEL |
+						   SKB_GSO_UDP_TUNNEL_CSUM));
 	has_vlan = !!skb_vlan_tag_present(skb);
 	vlan_tci = skb_vlan_tag_get(skb);
 	encap = skb->encapsulation;
-- 
2.17.1

