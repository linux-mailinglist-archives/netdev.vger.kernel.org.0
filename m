Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F023566040
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 02:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiGEAp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 20:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiGEApz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 20:45:55 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B7B6562;
        Mon,  4 Jul 2022 17:45:53 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b2so10125259pfb.8;
        Mon, 04 Jul 2022 17:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=1pCsgComZ4DfQ2oX2SabKyL8P0YNKoNG/OIXPGIB+oE=;
        b=k72DfXsMBx3EnVUFLw2v6KbtpirguIQDcsEwswez4MncxC8zVFdDCSR8rPu1Jzd078
         ByUtgZ6Y9CRbp1dQsuvT3/Tsgbn11KNokmNCmcBRogZ3dczRRdaLyV4/TUF2pghujZ+C
         sJC5yAuNQ7s4llO7ek9XWW+7CeNFY6dYa/HxWZPuA+0MpgUZKfpiTFSZXGay5nyP0LGO
         PBP0UGzf2+O0uD/xuu72/94c6QXREYm1fYC2BgBEh0wJRC1RI1u9a4Yjhl2SqN0cevkt
         O4rmJm2svY/d6qDOfHXiPJCX+hr/ibLgBcGw1fWbpmlXXZ7kBwUCxDQJuXpuWK0uGno4
         MW6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1pCsgComZ4DfQ2oX2SabKyL8P0YNKoNG/OIXPGIB+oE=;
        b=djHYOtpykIDTlMZO1KHQXSIJ3mCpqj/SabMg6a3SRYk7/6Po4TsrMOHqvJheMculvH
         jeahMtzVuBRDrRdPreKjn5aR6Diq5qAuYxm08SXP+7OZfrgt03QwX1MPu33cqmwGdEVz
         rZVxKFxD63mkjxvf/L3mD0BU+ac5NgTnvglhn8kYFc7+FSur7hUec/G4MQ9+5wJjI7pF
         LaXjpXj8m3/yB4mECkUmVIPS03Wskvq86aJgFnmsGmijAm7ezV6CgtF/yZgH/lYm9cmZ
         c6FNDBzkgKdcRWjOpD3jd9zm54G/D2Z02hZcFWBypxlNukXcIYRIm/fk3GZGWtlFJNlj
         LCAw==
X-Gm-Message-State: AJIora80j2pyrb0v24sjLsZ5ILYKkZ/QL1D3OSiHgzYme1lZwyJEFmas
        MSjZy9tAtwTVsErHqCzhYmA=
X-Google-Smtp-Source: AGRyM1vvJ08h9ChDK6UHCuFm9vMoIqMoL2Ccupppj4gxUW014J2pqWPkmOPviXUVO/uYr9Bm3ui8uw==
X-Received: by 2002:a05:6a00:a93:b0:528:77d6:f660 with SMTP id b19-20020a056a000a9300b0052877d6f660mr3243107pfl.50.1656981953065;
        Mon, 04 Jul 2022 17:45:53 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id mn1-20020a17090b188100b001ef42b3c5besm453907pjb.23.2022.07.04.17.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 17:45:52 -0700 (PDT)
From:   Sieng-Piaw Liew <liew.s.piaw@gmail.com>
To:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sieng-Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH] net: ag71xx: switch to napi_build_skb() to reuse skbuff_heads
Date:   Tue,  5 Jul 2022 08:44:34 +0800
Message-Id: <20220705004434.1453-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_build_skb() reuses NAPI skbuff_head cache in order to save some
cycles on freeing/allocating skbuff_heads on every new Rx or completed
Tx.
Use napi_consume_skb() to feed the cache with skbuff_heads of completed
Tx, so it's never empty.

Signed-off-by: Sieng-Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/atheros/ag71xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index cac509708e9d..5b6c4637349c 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -825,7 +825,7 @@ static int ag71xx_tx_packets(struct ag71xx *ag, bool flush)
 		if (!skb)
 			continue;
 
-		dev_kfree_skb_any(skb);
+		napi_consume_skb(skb, !flush);
 		ring->buf[i].tx.skb = NULL;
 
 		bytes_compl += ring->buf[i].tx.len;
@@ -1657,7 +1657,7 @@ static int ag71xx_rx_packets(struct ag71xx *ag, int limit)
 		ndev->stats.rx_packets++;
 		ndev->stats.rx_bytes += pktlen;
 
-		skb = build_skb(ring->buf[i].rx.rx_buf, ag71xx_buffer_size(ag));
+		skb = napi_build_skb(ring->buf[i].rx.rx_buf, ag71xx_buffer_size(ag));
 		if (!skb) {
 			skb_free_frag(ring->buf[i].rx.rx_buf);
 			goto next;
-- 
2.17.1

