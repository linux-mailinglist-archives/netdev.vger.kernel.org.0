Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11FB57773C
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiGQQMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiGQQM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:12:28 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8F013CD3
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:27 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id f11so8632449pgj.7
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PLhOnTBMd6RLNUqtsrx+gCZ1FA1A76mcTFjIVf9ITGE=;
        b=eU3vyp+232ASD+WaMdUUyDEgWgqo4Na6P4txFp9amiNMhKbvj8+KIQ4VXRX29v1Rk/
         716r4T5npSOIQXOgHyTqI7iRDS5RQgf2gRcuaJ7A3u3Kg+cDA6og5vVDXlJz5qnHffjh
         MyexgeWQisjsG8Fb+BDWxMPqmrWUdsVqWQYetl6p9J9WCpv20tjH3avb5MLmUd2ewQTi
         Q13j8kW/Ip9guy5oX2bSRfkzARCkK+UErKDC3RUwL42GaeX6Sa244IRUko2qBSHoA9xq
         hbEQMeyGPUiShW/rnRWdaEqmptJCUH6ha7ZU6FWXInR2RrBG9TUDDntzsnsIx6Si4CNT
         OjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PLhOnTBMd6RLNUqtsrx+gCZ1FA1A76mcTFjIVf9ITGE=;
        b=fNb9L3mo5OrraPzqV6YChaMvfKH6LMBd8kut4d3nWvf1+ZdxnhrOFUc38uzO3oh3qs
         v8rhOLanVGuuKFDUX/5cY6kbfvZEr6UomYC3nzqu7IcwMReQe9XrCcfMWOveD8ltV8OD
         L6a3O7yzgl25cRE5k2U+8vjar6IgyFVI0WKVjiZrky0BCvJGACIwWuhugevwLL0vaD8G
         DiytoeakeVZe8YKM6H1QibJTYk/9/2GortCgWTAnt7T0bgAWSlxn0NwqxcudTh39XHHM
         8oWMdXBMWB9JaFnStrLMFvi+rpkjz4mhc9usTscXIOm0Yiwx6wr3RspE/BtVV6YVLaD1
         PzPw==
X-Gm-Message-State: AJIora9rI3LP8fJfX1xFlgAjU8i3RkqyfeCSvWzyQu5i2fCvIly1v8R0
        57inOthX/F7cXqdQO5BeE1zBt8W8ATg=
X-Google-Smtp-Source: AGRyM1tY4JdeIOdj6R2Ynztyn1hUN6hWTX9yYiNIQAmkhZDYaD4w77XcXcSfT5LhIAYZ1wThWhbnDg==
X-Received: by 2002:a05:6a00:162e:b0:52b:5909:fdfd with SMTP id e14-20020a056a00162e00b0052b5909fdfdmr6529187pfc.65.1658074346745;
        Sun, 17 Jul 2022 09:12:26 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm7443026plg.171.2022.07.17.09.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:12:26 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 3/8] amt: use READ_ONCE() in amt module
Date:   Sun, 17 Jul 2022 16:09:05 +0000
Message-Id: <20220717160910.19156-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220717160910.19156-1-ap420073@gmail.com>
References: <20220717160910.19156-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some data races in the amt module.
amt->ready4, amt->ready6, and amt->status can be accessed concurrently
without locks.
So, it uses READ_ONCE() and WRITE_ONCE().

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - No changes.

 drivers/net/amt.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 42220d857f8a..f0703284a1f1 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -584,7 +584,7 @@ static void amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
 		return;
 	netdev_dbg(amt->dev, "Update GW status %s -> %s",
 		   status_str[amt->status], status_str[status]);
-	amt->status = status;
+	WRITE_ONCE(amt->status, status);
 }
 
 static void __amt_update_relay_status(struct amt_tunnel_list *tunnel,
@@ -958,8 +958,8 @@ static void amt_event_send_request(struct amt_dev *amt)
 	if (amt->req_cnt > AMT_MAX_REQ_COUNT) {
 		netdev_dbg(amt->dev, "Gateway is not ready");
 		amt->qi = AMT_INIT_REQ_TIMEOUT;
-		amt->ready4 = false;
-		amt->ready6 = false;
+		WRITE_ONCE(amt->ready4, false);
+		WRITE_ONCE(amt->ready6, false);
 		amt->remote_ip = 0;
 		amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
@@ -1239,7 +1239,8 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* Gateway only passes IGMP/MLD packets */
 		if (!report)
 			goto free;
-		if ((!v6 && !amt->ready4) || (v6 && !amt->ready6))
+		if ((!v6 && !READ_ONCE(amt->ready4)) ||
+		    (v6 && !READ_ONCE(amt->ready6)))
 			goto free;
 		if (amt_send_membership_update(amt, skb,  v6))
 			goto free;
@@ -2368,7 +2369,7 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		ihv3 = skb_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
-		amt->ready4 = true;
+		WRITE_ONCE(amt->ready4, true);
 		amt->mac = amtmq->response_mac;
 		amt->req_cnt = 0;
 		amt->qi = ihv3->qqic;
@@ -2391,7 +2392,7 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		mld2q = skb_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
-		amt->ready6 = true;
+		WRITE_ONCE(amt->ready6, true);
 		amt->mac = amtmq->response_mac;
 		amt->req_cnt = 0;
 		amt->qi = mld2q->mld2q_qqic;
@@ -2898,7 +2899,7 @@ static int amt_err_lookup(struct sock *sk, struct sk_buff *skb)
 		break;
 	case AMT_MSG_REQUEST:
 	case AMT_MSG_MEMBERSHIP_UPDATE:
-		if (amt->status >= AMT_STATUS_RECEIVED_ADVERTISEMENT)
+		if (READ_ONCE(amt->status) >= AMT_STATUS_RECEIVED_ADVERTISEMENT)
 			mod_delayed_work(amt_wq, &amt->req_wq, 0);
 		break;
 	default:
-- 
2.17.1

