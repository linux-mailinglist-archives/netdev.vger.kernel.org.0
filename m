Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F344E4DBC82
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 02:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348637AbiCQBaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 21:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbiCQBaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 21:30:12 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABFDB9D;
        Wed, 16 Mar 2022 18:28:57 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id c11so1496746pgu.11;
        Wed, 16 Mar 2022 18:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGCixHA6fg7y035ihcncWdobFp35i0tw7IkkiWFxznA=;
        b=Y6rSGiOsH4aikeNiovmhjNComtkDxnQ8g5RmELbMaWmWhPFANZSV/EuQUpLqzVUOtD
         TbT4r/CvAkZHGJziWvqifLHG0Eho0IivDvdm9LqZcV7R67OFe9B06qRYaX4UdkdaRffl
         tobPe4bzVISywjWarWD2qneRhU9uhoXcvTz8ZsZSmPeE9p7sEqQKxGdpsOrdhyhnEJKA
         o1gBV5d7qehi5y8xjd9pUlcralw1x6dRXHQ6lGgMgBAuL2MHFVwZhVDB6WPRNAGxYYL0
         Ibxf9XYscyQPbYsYsgwakRSVKhxdR/JrC1GOlPTvzWawkl6iryFgJtdIiyTpYTJ5J090
         NxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGCixHA6fg7y035ihcncWdobFp35i0tw7IkkiWFxznA=;
        b=32WQtV3PTRZO7b90ad95cwPW6KqRYyS9d6TOabPfSarYwlhBSNPtpW+nC7iU3iZxi2
         imYZUvKqRzQMqRqhJLEOQ+hRL2GioRxqpjwAt7UKVEpzPt7PXX2isxaNva4D5AYjPkvl
         tMEEA0nnJBIOrvKdtzQEXm7WTIiABm6FDKwFHQQQv3b1eUjkM/4CxveznjpFQfiSw1JJ
         Q2cgpel14+ZuL34Gc/Om32qTqw89t6ou5svWS2GA0G/RPTVT3I4TSpajBky8f7lvMK0Y
         vqNde/aIxjDIFsAlEwxg0xe4DDst9LnNMAEIVbv6zvzwkOkgtOIeoiyYB/5J8AZYfvlH
         Ajrw==
X-Gm-Message-State: AOAM5311jltnuOleaZuAviDmJ64we4k/LbtRkRQnuLR+qzhmD362RH+s
        +y/5BtFLAetgP6Z1LmuSVjfQJiHm4dk=
X-Google-Smtp-Source: ABdhPJwuHlyPDn0otvZORZ61qmcPWgd3/z6y3WtuIDcokamJISjVZq2j3PEx9NZv7JfQO/LSgattyg==
X-Received: by 2002:a05:6a00:1c5e:b0:4f7:e2a5:50f6 with SMTP id s30-20020a056a001c5e00b004f7e2a550f6mr2243598pfw.78.1647480536564;
        Wed, 16 Mar 2022 18:28:56 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t7-20020a056a0021c700b004f7916d44bcsm4609445pfj.220.2022.03.16.18.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 18:28:56 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net] net: bcmgenet: skip invalid partial checksums
Date:   Wed, 16 Mar 2022 18:28:12 -0700
Message-Id: <20220317012812.1313196-1-opendmb@gmail.com>
X-Mailer: git-send-email 2.25.1
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

The RXCHK block will return a partial checksum of 0 if it encounters
a problem while receiving a packet. Since a 1's complement sum can
only produce this result if no bits are set in the received data
stream it is fair to treat it as an invalid partial checksum and
not pass it up the stack.

Fixes: 810155397890 ("net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 87f1056e29ff..2da804f84b48 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2287,8 +2287,10 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 		dma_length_status = status->length_status;
 		if (dev->features & NETIF_F_RXCSUM) {
 			rx_csum = (__force __be16)(status->rx_csum & 0xffff);
-			skb->csum = (__force __wsum)ntohs(rx_csum);
-			skb->ip_summed = CHECKSUM_COMPLETE;
+			if (rx_csum) {
+				skb->csum = (__force __wsum)ntohs(rx_csum);
+				skb->ip_summed = CHECKSUM_COMPLETE;
+			}
 		}
 
 		/* DMA flags and length are still valid no matter how
-- 
2.25.1

