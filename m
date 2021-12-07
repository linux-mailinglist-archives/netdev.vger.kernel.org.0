Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A10246AF76
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378811AbhLGAzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378824AbhLGAzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:46 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E477DC0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:16 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b11so8211322pld.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HMp4O+Iz3SGdy9klc9PTcFjplbcGCBUGfPXbAYR+zrU=;
        b=EnvDPrXdT2ddThaoGsQIEhwFYkBu9HQWyfBRMX/lSm7rH8Q99B1uNxoiadIQIxDovk
         tVJcUKm1/n/xzABt+WQy72EWVx7ilNU5h3u4znA+vJQwL5JiNsgGGmAWi5G+Z6X0sPvo
         klQNV0CKGJmku8+FqX1P5qqNQo+w66q1GnxmW9Wz0rjZ7Rn3LtYwnHSnQOnuZGkTYkYi
         MGQ4bOmQgwHcYHrasClL2gooilsIZZVBeEt4BhHw5BJb95tSjTwuuTPjff/eHzjAIfiY
         JhFXwXsewofEZbsnnvOFH9XEEaxm6srCJZ9rd7xPqFumesH4wdoV81KbSREi0tScCETB
         Oycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HMp4O+Iz3SGdy9klc9PTcFjplbcGCBUGfPXbAYR+zrU=;
        b=2jTdchGuUmApaA7OAtz06mKA3VMQ3zjsY+GNMYy2alVBTrjAT8P6Bcv1qR/eTySGNH
         X6Kw9koxBiBKT5CUno1MtToZwuxa0QXJr7TmI+Wg5QEzZG2Ubf8euzjVFPUGjAMG9PPH
         Q/ukqbwPU7uZ67/q1fdfw3UqBV+Uu0tssfad/id36HD2345/6WT9uSQ6T/bpyFlhMtwg
         885IUxwpNpbMH3UAsP+RgC5MaJ+wTR69x/qr7ktWCwb4byrVtwcxu7QFp43NnzmwnftV
         HGL/CSTLfE+33ar4EHgLeKXjepEObL6IJRtARctgW3pMtyBbBujBeYSqELl8h3VWXbAl
         njog==
X-Gm-Message-State: AOAM531HGhzPtPR3nGpmC27KZYn47qXit1YNrKg21ytSUi++1n2iAlh/
        E/o8ZBrX5l7xsxYVOzwrM5I=
X-Google-Smtp-Source: ABdhPJxKWw2f2Fz6AlDeW9bAC4C6vSotpNn8oYitNfdhbJwL116+QczZuxWju/IHrNfd2IY6Rll9oA==
X-Received: by 2002:a17:90a:b107:: with SMTP id z7mr2569267pjq.104.1638838336543;
        Mon, 06 Dec 2021 16:52:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 16/17] audit: add netns refcount tracker to struct audit_reply
Date:   Mon,  6 Dec 2021 16:51:41 -0800
Message-Id: <20211207005142.1688204-17-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 kernel/audit.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 27013414847678af4283484feab2461e3d9c67ed..493365899d205c12338323b5a6ca6a30609a3d6a 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -207,6 +207,7 @@ struct audit_buffer {
 struct audit_reply {
 	__u32 portid;
 	struct net *net;
+	netns_tracker ns_tracker;
 	struct sk_buff *skb;
 };
 
@@ -938,7 +939,7 @@ static void audit_free_reply(struct audit_reply *reply)
 
 	kfree_skb(reply->skb);
 	if (reply->net)
-		put_net(reply->net);
+		put_net_track(reply->net, &reply->ns_tracker);
 	kfree(reply);
 }
 
@@ -982,7 +983,8 @@ static void audit_send_reply(struct sk_buff *request_skb, int seq, int type, int
 	reply->skb = audit_make_reply(seq, type, done, multi, payload, size);
 	if (!reply->skb)
 		goto err;
-	reply->net = get_net(sock_net(NETLINK_CB(request_skb).sk));
+	reply->net = get_net_track(sock_net(NETLINK_CB(request_skb).sk),
+				   &reply->ns_tracker, GFP_KERNEL);
 	reply->portid = NETLINK_CB(request_skb).portid;
 
 	tsk = kthread_run(audit_send_reply_thread, reply, "audit_send_reply");
-- 
2.34.1.400.ga245620fadb-goog

