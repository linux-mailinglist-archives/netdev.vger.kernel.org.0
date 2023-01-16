Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0568166D023
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbjAPUZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbjAPUZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:17 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF0327D56
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8VCVkaSPfeC2T12dnR/hw/GKR366Law7mXjfpQPmMJ8=; b=F230QJxGKJfAwaBRZBp6cihqYZ
        i54BhMxoJCHFh/Xw8dtSVmyTbKNVrrzGqawz/T0EgNvLgd/h4ZAg+aj5WG0g9ccvMCybFKYkil0U7
        lLGAT8PvLRKFVgaTqegxoyIex2LbgMcngkZ4xujSQoAZF1UVa5m4wrRrRgjdz9TMlmTY=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2Y-00018Q-QB; Mon, 16 Jan 2023 21:25:10 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v5 2/9] tsnep: Forward NAPI budget to napi_consume_skb()
Date:   Mon, 16 Jan 2023 21:24:51 +0100
Message-Id: <20230116202458.56677-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230116202458.56677-1-gerhard@engleder-embedded.com>
References: <20230116202458.56677-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NAPI budget must be forwarded to napi_consume_skb(). It is used to
detect non-NAPI context.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index c182c40277dd..8abe65a8c2f1 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -544,7 +544,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 			skb_tstamp_tx(entry->skb, &hwtstamps);
 		}
 
-		napi_consume_skb(entry->skb, budget);
+		napi_consume_skb(entry->skb, napi_budget);
 		entry->skb = NULL;
 
 		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
-- 
2.30.2

