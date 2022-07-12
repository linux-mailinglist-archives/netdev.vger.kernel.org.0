Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809C75717C2
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiGLK5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbiGLK5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:57:34 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1781AEF50
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m14so6939274plg.5
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iMsIvLoy4gUgTHZwBFWQvUNHWvL/r9TQ3Q07LAwWE4s=;
        b=Jz81xJHGG0UNWsqYnwufThtFyPeTks+qZBzBZWsp9Gy19/bXdZTgKlHBlV476fH5Ob
         DgEpZ7UsABjNr0rR8jUUWgo7AGiXKworLtWrpibd78rUI6KCcPOi5EntV99NABeFG4q4
         oUFOyQAuimL4w2im/Js4cK1tLI417zJ+/7LrrO2ijhikztPO+WuGJE+UWzuVJT40x3Y6
         Io7pWanVgBGP2feYYXYwbpY8AjRjFnFjafk+6PZE6evV0TJMwQk9l8JyhfBuAriZ6DIK
         kigThDtQu5bw5Ep2VSUVAudoDrhRudEG3FzVHBJDAbQ+7e0mEHPFbnhSj3Wz2//r2R9v
         TgUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iMsIvLoy4gUgTHZwBFWQvUNHWvL/r9TQ3Q07LAwWE4s=;
        b=JKM+dkLfex1eVP1OPrvHTCmeOXF26GAc6V0fDRdTT+v9b8VVGXVAeE1b//eF9fuksJ
         4dCfy2EKgZlEF93UC0cM5JSR9NJ4r1Su1b9SPHv+/UuC3oT7B9LCS+rQQJsworACfyAq
         zV3UxdKikBfEZQoY4L1pSkNfKZpdAlp0+6bvWcvXBOcksA12oy6QB2hZPfTKEPZlnLoM
         DczULPdPPW37BJKWEhhz5vRtK3ZCstFnpFcwlezGiJ2ySvzzSPpMeFndtDd2ii3oSIrt
         Nl8cDsakZHv2i2Dy7MIyUGw2P69LHloKtzOojOA/A3OpXMo2sZsq2qbwNSkiCoTLlgS8
         heEQ==
X-Gm-Message-State: AJIora9+KCc1sbD07/38Q2j8/pcuzCl3c9L1Rk2coqW0TskmDLdhQCY1
        NIuVDwAPNkGh/ULH12if2ATEg6PRB9o=
X-Google-Smtp-Source: AGRyM1uieH5AoEzjOm/KWeRJ0EfODgzeAIB9T8ZQuckM2hmJiDwFR8yKsRqeez5nsDWYL1B1azGxdQ==
X-Received: by 2002:a17:90b:1b41:b0:1f0:e99:ecc2 with SMTP id nv1-20020a17090b1b4100b001f00e99ecc2mr3603716pjb.122.1657623452169;
        Tue, 12 Jul 2022 03:57:32 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016c37fe48casm5681714plb.193.2022.07.12.03.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:57:31 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 3/8] amt: use READ_ONCE() in amt module
Date:   Tue, 12 Jul 2022 10:57:09 +0000
Message-Id: <20220712105714.12282-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712105714.12282-1-ap420073@gmail.com>
References: <20220712105714.12282-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/amt.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 3ff8e522b92a..9977ce9e5ae0 100644
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
@@ -2897,7 +2898,7 @@ static int amt_err_lookup(struct sock *sk, struct sk_buff *skb)
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

