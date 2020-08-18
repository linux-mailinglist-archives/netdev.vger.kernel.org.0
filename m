Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FA8248EF5
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHRTpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgHRTpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:45:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7114BC061346
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y13so12831478plr.1
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wuBO91UgNJzk0BjrCEUQYJPVEmRtko20sYkQpxIa0KE=;
        b=FXZvJi4L45Z/evWgFGevk5DBYxVvwDkYNUtArKaGsPSt98ROHmdSYxXgyUKnNFmUgX
         i140X+wgciNfygB8QEhw14/CnJOhakh2bjHSClvC8RfoYoWCLqZHYTDpqpyWURswRQxO
         qPAxyv5UOyRah6ubx+Qxk0PUwKWwISLGKrosYXZBhfVfghecxgvB7ZUPMdi3TXK8w3G2
         rJQ7PY9XEE6riyLQ9TnENiaAyu4cY1hhKUxIJMWSIAfOBs+gUuIca5lWYiJW7mLzSnxe
         th7vM69JiJIATeTyMqoKG9e+z3li/cLkY+sSxQSdW6owaDDchRVuXEeyiPtjJluvpYgV
         ORng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wuBO91UgNJzk0BjrCEUQYJPVEmRtko20sYkQpxIa0KE=;
        b=hhOU4y6fnZ3NUyEWHl9alv3V2253P5mWqiVXDflh/QdkKa/8/joc3jQEmXtcEmS8w2
         ywGKch954E0rNU1M+2Bk481qSehpi8+7roMrLoD7Y79f0zGDIFq14jzrN3n8VDDlV7kc
         K5ltLnOD1n8no9AoKuovKqAdvRvnqPbkw0XSy95188pM45BzgxHs+adAsD5+6TAyOdX3
         ldr7Z+BVZEVD1loLMv6F/LqOUmcmICK5SA+GI2u41FiIYWBofGiU6gOjRNZkXZu188RL
         Rcn2hTs4CWfkEikz3pmmdD4d3gZ8Ue4+FoH/IkcNjmApKK4Lp3o6qyWSilq+W6cfSFKR
         MTXA==
X-Gm-Message-State: AOAM533CrIVQ6/iC6yOW2KvHGP4pYA4p6XsSESE4rzTAX/NEzaS8oWvU
        aeKn3BWqea0PfrOvz6oz3ueOPBhUVOjBvQbm7TuTeuXpo3P8Y530CGcU1fdX5hDsytA1unNr1jq
        4BDS0k5kXQd/iyDFNS4CI5ZTqJkobOvquq6WSADCfILBE4ABA538q5f/TWrs9oznY7chk8Ju9
X-Google-Smtp-Source: ABdhPJx/ZmpfCpd4ZN3a4tCM42RJ/yESB9kVgZ+zc/KRlfxEuUW7fuKYXzsPrnlXbAbYVO2l9NmLE9rVA/Cl6Qbq
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90a:f014:: with SMTP id
 bt20mr369057pjb.0.1597779912604; Tue, 18 Aug 2020 12:45:12 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:15 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-17-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 16/18] gve: Also WARN for skb index equals num_queues.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WARN condition currently checks if the skb's
queue_mapping is (strictly) greater than tx_cfg.num_queues.

queue_mapping == tx_cfg.num_queues should also be invalid
and trigger the WARNing.

Use WARN_ON_ONCE instead otherwise the host will be stuck in syslog
flood.

Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 5d75dec1c520..5beff4d4d2e3 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -602,8 +602,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 	struct gve_tx_ring *tx;
 	int nsegs;
 
-	WARN(skb_get_queue_mapping(skb) > priv->tx_cfg.num_queues,
-	     "skb queue index out of range");
+	WARN_ON_ONCE(skb_get_queue_mapping(skb) >= priv->tx_cfg.num_queues);
 	tx = &priv->tx[skb_get_queue_mapping(skb)];
 	if (unlikely(gve_maybe_stop_tx(tx, skb))) {
 		/* We need to ring the txq doorbell -- we have stopped the Tx
-- 
2.28.0.220.ged08abb693-goog

