Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5B533DCEE
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCPSxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhCPSwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:52:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E9FC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:52:52 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so1856622pjh.1
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/sj2D6EhueIonIOjXjC7WbxwzD1uKAjfAdMsy+l9mT8=;
        b=nNCVD+3WNEGfIgnZ7REz0xovKLIC//qI2IqlP2+Jbh67o20xsk+DNNQSzZ+ZHoK5GG
         QnyhBzx2/Whwj+gUG4euZmlpv9lU9JN6GZJjPfIQd80JbFCpR5dcuTgB1kEOoF7uWzJk
         pJIKtGF4amqgGraLCrXr8IFXVsmvl9x3vqUSC14LmUl7hc3JYTE9HYYXrILYKTJa4Vzd
         QTnhmlKyob7tYy2iAyF6460/5/6bhbgyV+0uIxpLq3pxWVec8SHUON19oCy3XDna+fk8
         0vpOrx3WDaEE5jP/67L51yVRmFUwQNR3nLMgGWiB5HzW2CMXnDTau/fr9Z70ceDUT546
         BBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/sj2D6EhueIonIOjXjC7WbxwzD1uKAjfAdMsy+l9mT8=;
        b=koXTv8A80pzQHKXgXBWfk+d0wo7ylC3GJJGQD0mVcys08QVJLv2gux9030iqc6tMKZ
         ajJu0URCxD+svAzmPRjUxcA8aND5ANIp+H8xtJYpvQiVySN12pXKVNuyi2e0YN6OMWlt
         BypQtsKSJIeabPQ9kcVDVJEFnKG3m6Q7g8Hkw23hasgGq0GNkqtPhTmpAX9yqmskxd6f
         7TP6tbRY3RwG6q7Vk2V8k/X5FnTiJXy+r7zkGIVd1AaO3MX23m3xb6UhpZ22I4tCQC8j
         Q+TSB94hltXyH5fHLd/my0+BSaqtV5jrPASdXL2TRYAAJ7wG8brNIoY2eRhuPIgOsoEN
         ahgg==
X-Gm-Message-State: AOAM532QAoIW1sa0qRQ0ZJ1VDxSeXPN4+1hU+dAy7LpbxtSd36vKuMy1
        EQ1aXqCCKi2pCERquir0kWB39YiiIT3m7A==
X-Google-Smtp-Source: ABdhPJxjUaPk47RrjpxjSqXpgogkgC07UrdRUNnc7jw1Jegfhdw50bED77E+UEkbkaAYy4Z5zEjH3w==
X-Received: by 2002:a17:902:a404:b029:e6:23d:44ac with SMTP id p4-20020a170902a404b02900e6023d44acmr771579plq.50.1615920772300;
        Tue, 16 Mar 2021 11:52:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a21sm17280457pfk.83.2021.03.16.11.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 11:52:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: linearize tso skb with too many frags
Date:   Tue, 16 Mar 2021 11:52:43 -0700
Message-Id: <20210316185243.30053-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were linearizing non-TSO skbs that had too many frags, but
we weren't checking number of frags on TSO skbs.  This could
lead to a bad page reference when we received a TSO skb with
more frags than the Tx descriptor could support.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 162a1ff1e9d2..462b0d106be4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -1079,25 +1079,27 @@ static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
 {
 	int sg_elems = q->lif->qtype_info[IONIC_QTYPE_TXQ].max_sg_elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	int ndescs;
 	int err;
 
-	/* If TSO, need roundup(skb->len/mss) descs */
+	/* If TSO, need roundup(skb->len/mss) descs
+	 * If non-TSO, just need 1 desc and nr_frags sg elems
+	 */
 	if (skb_is_gso(skb))
-		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
+		ndescs = (skb->len / skb_shinfo(skb)->gso_size) + 1;
+	else
+		ndescs = 1;
 
-	/* If non-TSO, just need 1 desc and nr_frags sg elems */
-	if (skb_shinfo(skb)->nr_frags <= sg_elems)
-		return 1;
+	/* If too many frags, linearize */
+	if (skb_shinfo(skb)->nr_frags > sg_elems) {
+		err = skb_linearize(skb);
+		if (err)
+			return err;
 
-	/* Too many frags, so linearize */
-	err = skb_linearize(skb);
-	if (err)
-		return err;
-
-	stats->linearize++;
+		stats->linearize++;
+	}
 
-	/* Need 1 desc and zero sg elems */
-	return 1;
+	return ndescs;
 }
 
 static int ionic_maybe_stop_tx(struct ionic_queue *q, int ndescs)
-- 
2.17.1

