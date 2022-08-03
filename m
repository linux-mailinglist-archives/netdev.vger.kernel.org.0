Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3AA58938D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbiHCUuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 16:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238756AbiHCUuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 16:50:09 -0400
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CC55C970
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 13:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W9abrdbE+MIhVndSM8WDw8Cj+HK4RS+lpFK7aUzCaDQ=; b=Fetz+OVgCUtnTj1VaPJ85h5xjZ
        PaPW/H9k5u7pPNAszHGZ973ekdSUOcriwivkDDD8Di5bNcu2qnAdNC+Hhp8hLFfW6CTXixmXbDl1o
        WHC76v2sqtVJix1ERXz0FKT+npROS7om/7wZ2wPEhfMYg5Db4XJTqXiQ31FNf+7bp6v0=;
Received: from 88-117-54-219.adsl.highway.telekom.at ([88.117.54.219] helo=hornet.engleder.at)
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oJLJc-0001TF-If; Wed, 03 Aug 2022 22:50:04 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 4/6] tsnep: Fix tsnep_tx_unmap() error path usage
Date:   Wed,  3 Aug 2022 22:49:45 +0200
Message-Id: <20220803204947.52789-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220803204947.52789-1-gerhard@engleder-embedded.com>
References: <20220803204947.52789-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If tsnep_tx_map() fails, then tsnep_tx_unmap() shall start at the write
index like tsnep_tx_map(). This is different to the normal operation.
Thus, add an additional parameter to tsnep_tx_unmap() to enable start at
different positions for successful TX and failed TX.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 3cae485e8689..9f8ca6d9a010 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -364,7 +364,7 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 	return map_len;
 }
 
-static int tsnep_tx_unmap(struct tsnep_tx *tx, int count)
+static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
 {
 	struct device *dmadev = tx->adapter->dmadev;
 	struct tsnep_tx_entry *entry;
@@ -372,7 +372,7 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int count)
 	int i;
 
 	for (i = 0; i < count; i++) {
-		entry = &tx->entry[(tx->read + i) % TSNEP_RING_SIZE];
+		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
 
 		if (entry->len) {
 			if (i == 0)
@@ -424,7 +424,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 	retval = tsnep_tx_map(skb, tx, count);
 	if (retval < 0) {
-		tsnep_tx_unmap(tx, count);
+		tsnep_tx_unmap(tx, tx->write, count);
 		dev_kfree_skb_any(entry->skb);
 		entry->skb = NULL;
 
@@ -492,7 +492,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		if (skb_shinfo(entry->skb)->nr_frags > 0)
 			count += skb_shinfo(entry->skb)->nr_frags;
 
-		length = tsnep_tx_unmap(tx, count);
+		length = tsnep_tx_unmap(tx, tx->read, count);
 
 		if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
 		    (__le32_to_cpu(entry->desc_wb->properties) &
-- 
2.30.2

