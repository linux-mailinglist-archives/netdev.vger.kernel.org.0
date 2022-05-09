Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5A951FCDF
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbiEIMfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiEIMfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:35:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24011B434C;
        Mon,  9 May 2022 05:31:11 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q18so742306pln.12;
        Mon, 09 May 2022 05:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MBkrt0SUkDfCJX6P4GbifrxeHSLkx5CXpfEy6Fo+oxI=;
        b=j24J2mmCWVTfciS79l9WsXOME+o2GRmy+XDFsljOg+u/rf3JIlbK8C8C0/obdWTlYs
         Lyti8j7T+/vIlQ1XYwUg2ldJUT97k2PP1fMeNVClx5eFDgP2NXxMtIYEtBVsPfXd23+k
         sC6PJPEiTSPZ1oDuttnRAaFAuNgX2OUVT84kuFFx1RVubJu3ba4vG6Th4E96AgExGGeu
         arf7htlXrjeuT5jr0ESUIH/b6InURDwz8lCl+eKwRXOEzGBcIfi9eoJNdUXsj22MT55A
         tDsQqKWZw3Q6MEtyxVeyvhSDCEJYD5Ng3OSPtkcvTBCWOwAUXd4MsXOfab9pN6ncp3aj
         QmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MBkrt0SUkDfCJX6P4GbifrxeHSLkx5CXpfEy6Fo+oxI=;
        b=zjdf0bY0/qQr1is5j5VtF7lJzivPT+1WfyQcNHv9jhgVDLmgS31DTXv7aHth+x4Pnn
         6Z0U0jT1IRAnPJRw9uazPpZNShUQep5QlEL+4WdklPEu3StY2mbrJyWKqBzWGc0/ud5b
         ludMXnGPP4xLr+kaQI2h3TSVgWz8I3uyOjhYPVHttPVYI/H5aIcPyfUmU0MJi2Hq+M2z
         65bnIeM+NaYfN3frJbNXQ/eqw71R9QkjqLDHD4Wa1ouWl6U4D3qzXDcAAjK10bjryIvC
         cN3aGvioNqB1qMm2uPg/QmPrQnbFlxBEgYBfTSsoRbVDl1F3tHZ1ejLQxXaVWvIqx3pE
         Idng==
X-Gm-Message-State: AOAM531KuKq0W1IiZ2VAScNgN2FHsrctYc80d+tTUxUKmiFtZXc6UmZf
        FLtRAE/LQ7Errocr4Fw+nw8=
X-Google-Smtp-Source: ABdhPJx0119ewapiTv0gtx/bvLqOkiUycrfiG2H+OZMR7WXYJoc3gdTakKXA4DiXUcUeaux2aKAShQ==
X-Received: by 2002:a17:902:f681:b0:15e:ade1:b703 with SMTP id l1-20020a170902f68100b0015eade1b703mr16022627plg.112.1652099471413;
        Mon, 09 May 2022 05:31:11 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.88])
        by smtp.gmail.com with ESMTPSA id t20-20020a170902b21400b0015e8d4eb269sm7025761plr.179.2022.05.09.05.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 05:31:10 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next] net: ipvs: random start for RR scheduler
Date:   Mon,  9 May 2022 20:22:13 +0800
Message-Id: <20220509122213.19508-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

For now, the start of the RR scheduler is in the order of dest
service added, it will result in imbalance if the load balance
is done in client side and long connect is used.

For example, we have client1, client2, ..., client5 and real service
service1, service2, service3. All clients have the same ipvs config,
and each of them will create 2 long TCP connect to the virtual
service. Therefore, all the clients will connect to service1 and
service2, leaving service3 free.

Fix this by randomize the start of dest service to RR scheduler when
IP_VS_SVC_F_SCHED_RR_RANDOM is set.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/uapi/linux/ip_vs.h    |  2 ++
 net/netfilter/ipvs/ip_vs_rr.c | 25 ++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index 4102ddcb4e14..7f74bafd3211 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -28,6 +28,8 @@
 #define IP_VS_SVC_F_SCHED_SH_FALLBACK	IP_VS_SVC_F_SCHED1 /* SH fallback */
 #define IP_VS_SVC_F_SCHED_SH_PORT	IP_VS_SVC_F_SCHED2 /* SH use port */
 
+#define IP_VS_SVC_F_SCHED_RR_RANDOM	IP_VS_SVC_F_SCHED1 /* random start */
+
 /*
  *      Destination Server Flags
  */
diff --git a/net/netfilter/ipvs/ip_vs_rr.c b/net/netfilter/ipvs/ip_vs_rr.c
index 38495c6f6c7c..e309d97bdd08 100644
--- a/net/netfilter/ipvs/ip_vs_rr.c
+++ b/net/netfilter/ipvs/ip_vs_rr.c
@@ -22,13 +22,36 @@
 
 #include <net/ip_vs.h>
 
+static void ip_vs_rr_random_start(struct ip_vs_service *svc)
+{
+	struct list_head *cur;
+	u32 start;
+
+	if (!(svc->flags | IP_VS_SVC_F_SCHED_RR_RANDOM) ||
+	    svc->num_dests <= 1)
+		return;
+
+	spin_lock_bh(&svc->sched_lock);
+	start = get_random_u32() % svc->num_dests;
+	cur = &svc->destinations;
+	while (start--)
+		cur = cur->next;
+	svc->sched_data = cur;
+	spin_unlock_bh(&svc->sched_lock);
+}
 
 static int ip_vs_rr_init_svc(struct ip_vs_service *svc)
 {
 	svc->sched_data = &svc->destinations;
+	ip_vs_rr_random_start(svc);
 	return 0;
 }
 
+static int ip_vs_rr_add_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest)
+{
+	ip_vs_rr_random_start(svc);
+	return 0;
+}
 
 static int ip_vs_rr_del_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest)
 {
@@ -104,7 +127,7 @@ static struct ip_vs_scheduler ip_vs_rr_scheduler = {
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_rr_scheduler.n_list),
 	.init_service =		ip_vs_rr_init_svc,
-	.add_dest =		NULL,
+	.add_dest =		ip_vs_rr_add_dest,
 	.del_dest =		ip_vs_rr_del_dest,
 	.schedule =		ip_vs_rr_schedule,
 };
-- 
2.36.0

