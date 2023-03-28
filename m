Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11C96CCE33
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjC1Xug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC1Xud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:50:33 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C4D2D44
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:32 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-544781e30easo135312867b3.1
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680047432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3CdzwHl+i0hjW4tayhSMZE6wgFVMM8hGLCJ6rJecFRg=;
        b=ZKwFe5Sa1Hkmzg756Ax6SsmXeZP9W8rz8s8e2YIec5FHjLGFuOBxEkNW2WLRvMeotV
         o6qNm9SKh0lIsnDALILjW/oil3LtQbRph55mdy3bcndd/5kLlhqviIxMs7Z+0e1jbgEo
         RlHEgMTNvSXDVaHDXxusPabgWkO5Ww+P8s6VYRgi+7DtOUtrQ7pAVrGMKgslrWQ8DvHS
         cGmo5N2bWiV7eZwxuJ28TfNfNgVkwfF3rlVY0qLtqcYLesTilX26JBP3leDeJ+IyvOvs
         nIGh+CBwY/c2VjLs9DfjfOsHf0EgzlXMGhBi7N+LzVWWnb7ncPOAFllDbnBT1cPDC5Ur
         ePlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680047432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3CdzwHl+i0hjW4tayhSMZE6wgFVMM8hGLCJ6rJecFRg=;
        b=7+ZWwliKdBFN++67+QtyrT74BVp7nsG8E4AXgFBpf3T+lwmb3njiijEqqq/ickhEqi
         DVAqFnF0uxuznq+r+cawlstr2+Hy53oTIisP2RPgdumIM4SQDqbqQdkO8go3W6oCWT7W
         vwqoIKi9LlTVPVDDAct/eW62u+1iLKr4szOM5HNdx4kKy0Zs5m+98llBbLuOC0c43fsR
         IhHJKb7o1RZXd+N27mBmAhzLA6KFVU0s4NGOQTTcNuRP0VotO8p0SV64ql/KUYIbsdVV
         75G2qP8loDthx4ng0LKW5TN6nae1FUw35Hm89khO5yY/ZMLYuTH8ruzGnaX9ko1ZUwnZ
         28UQ==
X-Gm-Message-State: AAQBX9fZs+ZbAOKYgQ12AwcOLgwg+cFZ8aRe9nqUrNsN3yLGNrkJXFyZ
        ATYH5jxY44Pcw9F+6IxWmtht0oZS94ic6w==
X-Google-Smtp-Source: AKy350ao0t/vmg1VE3azkPdik6EXiGL7WrF4D/o0fJbZWHV0fEolKl686fh/xEcYa5SAXZuuyYwIP7pxfLyBMQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:4516:0:b0:541:9b2b:8240 with SMTP id
 s22-20020a814516000000b005419b2b8240mr8133640ywa.6.1680047432077; Tue, 28 Mar
 2023 16:50:32 -0700 (PDT)
Date:   Tue, 28 Mar 2023 23:50:18 +0000
In-Reply-To: <20230328235021.1048163-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328235021.1048163-2-edumazet@google.com>
Subject: [PATCH net-next 1/4] net: napi_schedule_rps() cleanup
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_schedule_rps() return value is ignored, remove it.

Change the comment to clarify the intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7172334a418fdfe6132562f4c864ad0c69ebfd74..f7050b95d125014d00f4c876175b1569d82525cd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4582,11 +4582,18 @@ static void trigger_rx_softirq(void *data)
 }
 
 /*
- * Check if this softnet_data structure is another cpu one
- * If yes, queue it to our IPI list and return 1
- * If no, return 0
+ * After we queued a packet into sd->input_pkt_queue,
+ * we need to make sure this queue is serviced soon.
+ *
+ * - If this is another cpu queue, link it to our rps_ipi_list,
+ *   and make sure we will process rps_ipi_list from net_rx_action().
+ *   As we do not know yet if we are called from net_rx_action(),
+ *   we have to raise NET_RX_SOFTIRQ. This might change in the future.
+ *
+ * - If this is our own queue, NAPI schedule our backlog.
+ *   Note that this also raises NET_RX_SOFTIRQ.
  */
-static int napi_schedule_rps(struct softnet_data *sd)
+static void napi_schedule_rps(struct softnet_data *sd)
 {
 	struct softnet_data *mysd = this_cpu_ptr(&softnet_data);
 
@@ -4596,11 +4603,10 @@ static int napi_schedule_rps(struct softnet_data *sd)
 		mysd->rps_ipi_list = sd;
 
 		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
-		return 1;
+		return;
 	}
 #endif /* CONFIG_RPS */
 	__napi_schedule_irqoff(&mysd->backlog);
-	return 0;
 }
 
 #ifdef CONFIG_NET_FLOW_LIMIT
-- 
2.40.0.348.gf938b09366-goog

