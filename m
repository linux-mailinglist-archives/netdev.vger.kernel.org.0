Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4155B30FF5E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhBDVcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhBDVcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:32:42 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92808C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 13:31:52 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b17so2455769plz.6
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 13:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dr8yx2nGH0LQmO22akxBdT6cmSLSRLQFoSNML/BGtPk=;
        b=cptfZMlseUg8JExf19JE0WMtKW7KYK2q1cCUvGsEkE4yGBfWNZV29ASuefK8clr6Dd
         eZG1JOp4vzpdVLt/oLlYCM2ELXBF64qtsc2P4AvNk8JxBouEQa8Go+n3b9oq22bTMwS2
         osTxXKeLaq99u9lA1PhDmsz9vV3oamKS21BpChhdcXq80aQO6MZLZnDuZHNWGHRtPteR
         Xo8DUcYb/Wjz4YvwBuK5OYu7XEaa9DVC+TA04z0DMDMRV5M1JakiwbchtiWXHAG9OWtU
         HfJzVDdvtQs5RzVcACW0zkaDWjJdqhTwbYMQ+iznq1Zf/H8Dt7FdzAo35MiGpnmUcVUe
         8MCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dr8yx2nGH0LQmO22akxBdT6cmSLSRLQFoSNML/BGtPk=;
        b=myCab7BiGAvdZ1/XLTv+xMAfN7gzZ4r+QgpVS1MZl2QK5C+H9fvn+7eGnDy/wzaD/V
         bXgZH2VvLRBLfp2sCkyMfqnQ6R2Rscm6Vq4FUJeYdMKlD7AaPoX9qJMQQNOwXIB5/1FU
         LaEllqTYclGrznJwVEtjLfO6euOM/fF4CQo2M2+xwvz9MhQVSuzUjZ2LBE2SGoXbzrAg
         b94m9S57Qrh/e8025BuTxVCuqIbBJ30PRgXnH8Yj3/kXVwAO1BU2YOYEulXpyoVTUxwb
         MUDlK908N/59b3HuLnQnwxxWUrnBT/7n6Cix60h4LJbeUZOyhQFg5Dklfe2YNee1cBrX
         EL8w==
X-Gm-Message-State: AOAM530e1/7K8HDJLTa7T2Bjeu4bRgHFAIkeyXjKPRxI4HcKZSEMsik4
        UzhLRywNlGFtnSRO0wlbuqg=
X-Google-Smtp-Source: ABdhPJySpp0l25ANQvCDCXcXuyfQEaoOA6XmkhKZvjq5XChUqEeC5usJ53DeIymzUEtt7Z8pEAFs/g==
X-Received: by 2002:a17:90b:4b86:: with SMTP id lr6mr890522pjb.107.1612474312172;
        Thu, 04 Feb 2021 13:31:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8d7f:7e35:a34:6dce])
        by smtp.gmail.com with ESMTPSA id 17sm7143022pfv.13.2021.02.04.13.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:31:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Sperbeck <jsperbeck@google.com>,
        Jian Yang <jianyang@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net] net: gro: do not keep too many GRO packets in napi->rx_list
Date:   Thu,  4 Feb 2021 13:31:46 -0800
Message-Id: <20210204213146.4192368-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Commit c80794323e82 ("net: Fix packet reordering caused by GRO and
listified RX cooperation") had the unfortunate effect of adding
latencies in common workloads.

Before the patch, GRO packets were immediately passed to
upper stacks.

After the patch, we can accumulate quite a lot of GRO
packets (depdending on NAPI budget).

My fix is counting in napi->rx_count number of segments
instead of number of logical packets.

Fixes: c80794323e82 ("net: Fix packet reordering caused by GRO and listified RX cooperation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Bisected-by: John Sperbeck <jsperbeck@google.com>
Tested-by: Jian Yang <jianyang@google.com>
Cc: Maxim Mikityanskiy <maximmi@mellanox.com>
Cc: Alexander Lobakin <alobakin@dlink.ru>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Edward Cree <ecree@solarflare.com>
---
 net/core/dev.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a979b86dbacda9dfe31dd8b269024f7f0f5a8ef1..449b45b843d40ece7dd1e2ed6a5996ee1db9f591 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5735,10 +5735,11 @@ static void gro_normal_list(struct napi_struct *napi)
 /* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded,
  * pass the whole batch up to the stack.
  */
-static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
+static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb, int segs)
 {
 	list_add_tail(&skb->list, &napi->rx_list);
-	if (++napi->rx_count >= gro_normal_batch)
+	napi->rx_count += segs;
+	if (napi->rx_count >= gro_normal_batch)
 		gro_normal_list(napi);
 }
 
@@ -5777,7 +5778,7 @@ static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 	}
 
 out:
-	gro_normal_one(napi, skb);
+	gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
 	return NET_RX_SUCCESS;
 }
 
@@ -6067,7 +6068,7 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
 {
 	switch (ret) {
 	case GRO_NORMAL:
-		gro_normal_one(napi, skb);
+		gro_normal_one(napi, skb, 1);
 		break;
 
 	case GRO_DROP:
@@ -6155,7 +6156,7 @@ static gro_result_t napi_frags_finish(struct napi_struct *napi,
 		__skb_push(skb, ETH_HLEN);
 		skb->protocol = eth_type_trans(skb, skb->dev);
 		if (ret == GRO_NORMAL)
-			gro_normal_one(napi, skb);
+			gro_normal_one(napi, skb, 1);
 		break;
 
 	case GRO_DROP:
-- 
2.30.0.365.g02bc693789-goog

