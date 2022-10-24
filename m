Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA64609ED2
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiJXKRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiJXKRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:17:35 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C24696C8
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:31 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f23so8054769plr.6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rgCyTxjLfeJe8llYSesMLp8twRs5USMmlujSMm5YGTY=;
        b=dsKtLfvUH5BwTrs13mZ4f/CpONa5riRizkjBce+Ouqs4b1YC1/T49IPGpxWFrK2UAA
         w64PW0ivItppsfBalSrZWTZUB+jLO+1gjipRHSHjEcbWRuv7UVOxkrQTHTdrcKr+okSR
         lbYxLHn5ySmiLstWRPXVPovXMrlMGiq8aAbTpHQYROpC/kTlWKx+Ie5dXyV1skRq3yxT
         VpSunahWuXOaAA794R/8fv2LMJ/IpJdv2p2Tf31/y/c1mNL/uSW/jmK+arziNxSMA4ai
         nNvHbdySRX+B6fqxcoTl89LDgq3inB4w00MBeLx+Rcsdm5TNCQKzD3Tyx7WNBHCo3z4a
         Zb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rgCyTxjLfeJe8llYSesMLp8twRs5USMmlujSMm5YGTY=;
        b=HdKUyHWiev5KK92RDFMxQ4BrO8ALhDPKjRvWOHzSsvhapumhADl0rahh97w0ELrQVf
         kg5o2egQ+6V+ocglg9MFlJootmKJUzYvzanTAmQuxcp8U+tclE7hqm0ygwdZRSbKomWI
         ffLMAq3xLrIYBL/i3odZxmWZtKGQANJkYAH0otETP+6/8EvFET/FEiUNHImMoBzD/Z4e
         Tw4ui7srTtCZwB/EgSQRbleRJ64gPnUFXd9hfDmvhYpCaL3oqZanrK6hULWYLiWFA2GW
         Oxim3XgxtSwvAWj47g1tusBdyY7SshjvsVltpyC89wipFaKTCrCZfIwKGGp1dpXMt+Tt
         YTfg==
X-Gm-Message-State: ACrzQf2wZrkAYi3Gn4le1a9e3CZIL6KQ+1PtKOR/LlQOlngBMduyjgqQ
        lIJojgtdB0hTKs5PgM55qSnoaw==
X-Google-Smtp-Source: AMsMyM4/b/Ud2vrfaOKUHXOaMB6jbx5a+KU5kaZ0TgKXzSzJ4UnU1GyzTKzuAZg73PD01ZQ4l9meSw==
X-Received: by 2002:a17:902:d54a:b0:186:a43b:8e with SMTP id z10-20020a170902d54a00b00186a43b008emr5449679plf.36.1666606651108;
        Mon, 24 Oct 2022 03:17:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h197-20020a6283ce000000b0056bf6cd44cdsm586290pfe.91.2022.10.24.03.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 03:17:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Neel Patel <neel@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/5] ionic: enable tunnel offloads
Date:   Mon, 24 Oct 2022 03:17:16 -0700
Message-Id: <20221024101717.458-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221024101717.458-1-snelson@pensando.io>
References: <20221024101717.458-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
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
index b5ade86b26a0..cbfa3a9e626e 100644
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

