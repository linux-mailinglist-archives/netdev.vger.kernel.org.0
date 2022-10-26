Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8329260E381
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiJZOiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbiJZOiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:38:01 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD8CBA263
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:56 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id io19so9319951plb.8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l6WKZVowwJKx99x52qYH6uDD4EwiMH/OqDvIe+d8MU0=;
        b=NaXhkAMZmdDURVEFF37SK+Ghzq+fXcUzbiLHOXxxaSb+aaMjsAaTGWiZgcZbGe21m5
         ybVraDbzE5T+mQJXuOZhes8bXQ4gRXdZOh6JCI8DmO1/4mxvq/oIUz84Gbyhh3Xvhu6U
         zUuTQXA+VNWXv/8BAP17aJYCsYwHEa+Rav+UVtQHdDTYYdWPR/mePUPw3sZj3b0nuZ4w
         DbTbCEq13Z84lwdrQ2qArkNFItJcPgAJYHGvPp91BHflB2bBwScsc9wNgRy4tYF8349/
         UaY7jBr8kqsEptgI21Ps71eZv2lx1QyQ0Bo/zVFT38li1M+FkVMVMqtn+GO+jU7PbQvv
         zbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l6WKZVowwJKx99x52qYH6uDD4EwiMH/OqDvIe+d8MU0=;
        b=wRQz6Kff/C39vkc/DMxGXWHF0V40ZQpDyAKymjnO/eTnZ5xzP1bAKPhmhcYcVtG/hx
         S4P/TPCkf1WLOPTka6eIsQTuDDmdqn4RUEbyHOZom11B4uleLGLj6FTINTDPmHXyyqLM
         zwG6gRAHmLOBj4in36ZdyW8sJHeJc0lunaCCvWulTDDcU7kp+c0qpgJzq+agUaZvTjGz
         YdPzuB+gam7u2t5+Wa6t5MyqOu/PbujqQBhI0MPL8hGgDflLttFBwhmOzpyR6S2V89kB
         2k6gwgQ2qsfS4QNKVD6M2xPvpAJINSzKiWPkcwHAAkcl05y0JE2JeIYPcN7si7VQXjuz
         3cpQ==
X-Gm-Message-State: ACrzQf3gOznp/FUq1p/5a/wCIIWmvhNARIXrpWcqc0HLu6tRmYb2zDrB
        LczlT70D02AvW3TEskVuD89hvf9igEE9kg==
X-Google-Smtp-Source: AMsMyM7RVhXopdmcF1JVhZfGg+mYRcP7kcfAb7+Ssnl1SiTBs1vWTa22Hn0EwnQtqdlOP++N+4gy4A==
X-Received: by 2002:a17:902:f643:b0:185:50e4:f55e with SMTP id m3-20020a170902f64300b0018550e4f55emr44004775plg.156.1666795075917;
        Wed, 26 Oct 2022 07:37:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id d185-20020a6236c2000000b0056286c552ecsm3060484pfa.184.2022.10.26.07.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 07:37:55 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Neel Patel <neel@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 4/5] ionic: enable tunnel offloads
Date:   Wed, 26 Oct 2022 07:37:43 -0700
Message-Id: <20221026143744.11598-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221026143744.11598-1-snelson@pensando.io>
References: <20221026143744.11598-1-snelson@pensando.io>
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

