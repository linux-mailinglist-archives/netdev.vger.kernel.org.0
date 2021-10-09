Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10369427CBF
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhJISrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhJISrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:33 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B4DC061764
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y1so8327575plk.10
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cqG8ukWqJUov6G2GTF8lSeTYl/ObEE6+pcLhvhm1K7o=;
        b=R0Mh/pjUyXF04Ch85eyyglJUmRJ4dBWY/cuiL9zzl/5Q2LRuRIW5C2FROyjw8gj9u4
         R/YrzCfzGAjLvv1pmSevGZWXOSZ/71YPg3eNr/rQiqQEHlMbi4YSBrUjxlgN2eVbt+Yk
         gyG/MGoHwMiNmWeoknoAqPF7eyCh8T2hlyk0lfOjoagpcareHPbWOTi8qOAR0wadWeU3
         P6cX1suY0t2D4/yZSnRQk7CARMsx3MbnCwJx/Y+yVqGcTE/I2t7aWHzfOmxTMc9xZ30E
         E3RcJ+Qky9RaPdLKjvd2xqZn+zseD3BGWm/jB/9pZsscDzN3AC0FVXAqqssYOVmc69Sg
         w4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cqG8ukWqJUov6G2GTF8lSeTYl/ObEE6+pcLhvhm1K7o=;
        b=FdDlOb7cUFISzpLnIfgCRXQyGVlWl52dbggeXHrHMN/p4PUhxzkTn6H1sz9wdH7WVm
         I1V9/zSFs+T4qh5Y5QnFJ7eAWZM9LZl1KEcXxtu3bqzWM8zuK3J16GxFPGcrWgas7Ny7
         BRfUCeIJ/a3nEfne9kWHPmJ8hG9CPqB0bBLg5teOjz41PybR8Tno4dfVL/jULk2uv6g9
         4Y3+mJWkzbkS07+vFu96BtdfAEicl9vEzcw2K6Z+pQ0QHGuBvRBZP8Pz1Xrmpltp709j
         ejj9EkIBAk6x7aOk22VDXVtNon9O1viGxmSLPbEv6pJ9Dkxno3cNLMvcloctBKQ75JtL
         MP5Q==
X-Gm-Message-State: AOAM5328TsGlM2Cko2OTFLGW1cq1oGd6Ti48ch8a75+o0ILBP0JzC6MM
        dGnGZNN5VA4+2H/NSWRcqW9beg==
X-Google-Smtp-Source: ABdhPJykCabopHXQZN3q0cCSAAK6QGBbDYSM3H8BkSjfqZ5SWnVMSvqI0aToUh2prJdpSg9P/7dAbA==
X-Received: by 2002:a17:90a:9b84:: with SMTP id g4mr17820856pjp.123.1633805135358;
        Sat, 09 Oct 2021 11:45:35 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:35 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/9] ionic: add generic filter search
Date:   Sat,  9 Oct 2021 11:45:18 -0700
Message-Id: <20211009184523.73154-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
References: <20211009184523.73154-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for enhancing vlan filter management,
add a filter search routine that can figure out for
itself which type of filter search is needed.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 21 ++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 19115d966693..38109244a722 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -239,6 +239,21 @@ struct ionic_rx_filter *ionic_rx_filter_rxsteer(struct ionic_lif *lif)
 	return NULL;
 }
 
+static struct ionic_rx_filter *ionic_rx_filter_find(struct ionic_lif *lif,
+						    struct ionic_rx_filter_add_cmd *ac)
+{
+	switch (le16_to_cpu(ac->match)) {
+	case IONIC_RX_FILTER_MATCH_VLAN:
+		return ionic_rx_filter_by_vlan(lif, le16_to_cpu(ac->vlan.vlan));
+	case IONIC_RX_FILTER_MATCH_MAC:
+		return ionic_rx_filter_by_addr(lif, ac->mac.addr);
+	default:
+		netdev_err(lif->netdev, "unsupported filter match %d",
+			   le16_to_cpu(ac->match));
+		return NULL;
+	}
+}
+
 int ionic_lif_list_addr(struct ionic_lif *lif, const u8 *addr, bool mode)
 {
 	struct ionic_rx_filter *f;
@@ -304,7 +319,7 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
 
 	spin_lock_bh(&lif->rx_filters.lock);
-	f = ionic_rx_filter_by_addr(lif, addr);
+	f = ionic_rx_filter_find(lif, &ctx.cmd.rx_filter_add);
 	if (f) {
 		/* don't bother if we already have it and it is sync'd */
 		if (f->state == IONIC_FILTER_STATE_SYNCED) {
@@ -336,7 +351,7 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	spin_lock_bh(&lif->rx_filters.lock);
 	if (err && err != -EEXIST) {
 		/* set the state back to NEW so we can try again later */
-		f = ionic_rx_filter_by_addr(lif, addr);
+		f = ionic_rx_filter_find(lif, &ctx.cmd.rx_filter_add);
 		if (f && f->state == IONIC_FILTER_STATE_SYNCED) {
 			f->state = IONIC_FILTER_STATE_NEW;
 			set_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state);
@@ -355,7 +370,7 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	else
 		lif->nucast++;
 
-	f = ionic_rx_filter_by_addr(lif, addr);
+	f = ionic_rx_filter_find(lif, &ctx.cmd.rx_filter_add);
 	if (f && f->state == IONIC_FILTER_STATE_OLD) {
 		/* Someone requested a delete while we were adding
 		 * so update the filter info with the results from the add
-- 
2.17.1

