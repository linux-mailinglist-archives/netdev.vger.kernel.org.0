Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6292346FC05
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhLJHsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbhLJHsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:48:16 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A62C0617A2
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 23:44:42 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 8so7760694pfo.4
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 23:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iYlWezmQ+H2UHYpXYA112HiHGbAK6PAbKqAqIdMSK0E=;
        b=LCV3JmR1AhNvPJEFarVXJfbF2ghrfiI/dYp/uW2fOJnOkyFz+cafbruik7tZ7PwfO5
         HJyEI8mIYWEQgAkGP4SDRz+1U8kTS9PvRGqjwDx1CSdNNg1iJZejRntc25Xl3ZIQkcjj
         SBInUPKqsVz8fnMiiXfYSnwL4hpPW2r/9eiJH+T3wYRHPnCPj9c3kF+6seRZBNTZOTj/
         wxxN9shUAI6A96LwHhAwjWOUQc9IH1YoFJUWVVSCInyE2wJM37wdDm16JMn4zuJtodDb
         d8BO5XbkhHTzP8LEYgFPsSEmyKO59/1d7RVe/JwwtuaVcQMqVSzZsrN8+lpbongrPlZ+
         3sHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iYlWezmQ+H2UHYpXYA112HiHGbAK6PAbKqAqIdMSK0E=;
        b=7DXJDy1r6jYcF/l2Ktx4W8fPPDj7uuv3oBcj4OZqAJqSnApsXb0wIE3VXWLEpqm75r
         Dn87cTw70pvV3y+a7WPw8tOFalAmKMvLsNpwtlRbnAt5kXKEOuzWxRnJrd+XWmdfJ4/R
         GOuASdqXndAkHl4UXF5GCbTKV2qJDh65LlOGpGI0o+jpNznHZbZKra3V0YDjiXJnXAPK
         Miu5ZdSTlsvm2fDSW1J2OK1mbOIWMjZLfRAhexGS003pwm3OemqA10Jbf31Knv+IsH7g
         lq6fmkwRZEK4RaN/OQatMdxxUc78BdLoqbDX2jFM+5jLKEJ/DGG3iE78aUQcpzfy9Z5h
         FLBQ==
X-Gm-Message-State: AOAM531v+6Wu07Ny/bkS9rL8VLyDihzJrHxsTjrWeJzmVeIMeQkeKPt6
        zm6QAhqhRy2fZ83rAO3GoQmJsWRxhnz0rw==
X-Google-Smtp-Source: ABdhPJwb+agvS4Sw1MlwxQ+VqUbW4boxf8/zNL5GkKyBI3KtRKvyiUwN3KWYHM+edOmzT9HH47r9Fg==
X-Received: by 2002:a63:8749:: with SMTP id i70mr38747117pge.487.1639122281680;
        Thu, 09 Dec 2021 23:44:41 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4f5:a6b4:3889:ebe5])
        by smtp.gmail.com with ESMTPSA id y12sm2001346pfe.140.2021.12.09.23.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 23:44:41 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH V2 net-next 4/6] net: sched: add netns refcount tracker to struct tcf_exts
Date:   Thu,  9 Dec 2021 23:44:24 -0800
Message-Id: <20211210074426.279563-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211210074426.279563-1-eric.dumazet@gmail.com>
References: <20211210074426.279563-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/pkt_cls.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 193f88ebf629bd5a66c2d155346b40695e259a13..cebc1bd713b68e9c9c7b7656f569e749c0dc9297 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -202,7 +202,8 @@ struct tcf_exts {
 	__u32	type; /* for backward compat(TCA_OLD_COMPAT) */
 	int nr_actions;
 	struct tc_action **actions;
-	struct net *net;
+	struct net	*net;
+	netns_tracker	ns_tracker;
 #endif
 	/* Map to export classifier specific extension TLV types to the
 	 * generic extensions API. Unsupported extensions must be set to 0.
@@ -218,6 +219,7 @@ static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
 	exts->type = 0;
 	exts->nr_actions = 0;
 	exts->net = net;
+	netns_tracker_alloc(net, &exts->ns_tracker, GFP_KERNEL);
 	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
 				GFP_KERNEL);
 	if (!exts->actions)
@@ -236,6 +238,8 @@ static inline bool tcf_exts_get_net(struct tcf_exts *exts)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	exts->net = maybe_get_net(exts->net);
+	if (exts->net)
+		netns_tracker_alloc(exts->net, &exts->ns_tracker, GFP_KERNEL);
 	return exts->net != NULL;
 #else
 	return true;
@@ -246,7 +250,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	if (exts->net)
-		put_net(exts->net);
+		put_net_track(exts->net, &exts->ns_tracker);
 #endif
 }
 
-- 
2.34.1.173.g76aa8bc2d0-goog

