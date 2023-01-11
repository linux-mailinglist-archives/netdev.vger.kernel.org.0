Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9867665E66
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbjAKOvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbjAKOv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:51:26 -0500
Received: from wizmail.org (wizmail.org [85.158.153.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E541A065
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:51:25 -0800 (PST)
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=wizmail.org; s=e202001; h=Content-Transfer-Encoding:MIME-Version:References
        :In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=mhSooOYTKZ+l2BgFItE4CB0Ir8bcni2NWTLCodChpAY=; b=JqLby22yQDnoLUx
        YO0+J/7VvM/bY8hXZcpXIjK/+DafUbCNcDrwtFfFnuEPWbIlEhnYrv49Xu4TCdH2q5qhjBQ==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizmail.org
        ; s=r202001; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=mhSooOYTKZ+l2BgFItE4CB0Ir8bcni2NWTLCodChpAY=; b=Pszd18cbdcDjH45
        YSPq0ojzTi2WKTXj+0CrC7Jop/fmXAS7M9NUNVdGntgOh5/h9wLbH6zvHLeveHABIuiFylrtJD+jq
        rrIcCmD42lCHLUQdh3+a9dYIO1PMVZBqtX/xbZaCN51CR8UULbBJEGR2wp/+BOB2bKIfCTSR/0jY8
        M6rX7/Gqc7+KbprB1vMW/PUKlcio0n37QWZiTx6aKtCooMQe6Yr8z0bLx+nNln0PDUCt4mnDeDw76
        h1YIcmD+B83td5GrshwfCBJkAg+G41g4UgLKF3T/NkHj2UMDve5EUshA1hOQirVPr8doVSb1CAuZk
        i3ROlA433+AE+OPjUnA==;
Authentication-Results: wizmail.org;
        local=pass (non-smtp, wizmail.org) u=root
Received: from root
        by [] (Exim 4.96.108)
        with local
        id 1pFcBW-004jFh-2v
        (return-path <root@w81.gulag.org.uk>);
        Wed, 11 Jan 2023 14:34:34 +0000
From:   jgh@redhat.com
To:     netdev@vger.kernel.org
Cc:     Jeremy Harris <jgh@redhat.com>
Subject: [RFC PATCH 7/7] drivers: net: bnx2: NIC driver Rx ring ECN
Date:   Wed, 11 Jan 2023 14:34:27 +0000
Message-Id: <20230111143427.1127174-8-jgh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230111143427.1127174-1-jgh@redhat.com>
References: <20230111143427.1127174-1-jgh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Harris <jgh@redhat.com>

Sample NIC driver support.
This is a less-preferred model, which will throttle based on the NAPI
budget rather than the receive ring fill level.

Signed-off-by: Jeremy Harris <jgh@redhat.com>
---
 drivers/net/ethernet/broadcom/bnx2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index f55ac9c7b6fd..c7d867114234 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -3143,6 +3143,7 @@ bnx2_rx_int(struct bnx2 *bp, struct bnx2_napi *bnapi, int budget)
 {
 	u16 hw_cons, sw_cons, sw_ring_cons, sw_prod, sw_ring_prod;
 	struct bnx2_rx_ring_info *rxr = &bnapi->rx_ring;
+	int congestion_level = budget * 7 / 8;
 	int rx_pkt = 0, pg_ring_used = 0;
 	struct l2_fhdr *rx_hdr;
 
@@ -3273,6 +3274,12 @@ bnx2_rx_int(struct bnx2 *bp, struct bnx2_napi *bnapi, int budget)
 				     PKT_HASH_TYPE_L3);
 
 		skb_record_rx_queue(skb, bnapi - &bp->bnx2_napi[0]);
+
+		/* We are congested if the budget is approached
+		 */
+		if (unlikely(rx_pkt > congestion_level))
+			skb->congestion_experienced = true;
+
 		napi_gro_receive(&bnapi->napi, skb);
 		rx_pkt++;
 
-- 
2.39.0

