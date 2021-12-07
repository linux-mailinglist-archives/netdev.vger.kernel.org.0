Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9305E46AF77
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378823AbhLGAzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378808AbhLGAzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:47 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7BAC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:18 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b11so8211359pld.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2fENHn91gxqW1qNG15mioT3jCj/d4w48+WpCz+57dP4=;
        b=St1uFNUD0HumITr2pW1Dltzkb8/RrHIWw6vhcD+XdfD3zLy6MrTYUvRDMBUb/E0j1E
         RlF4ZbXwiyG35+bWx/9cHz99QsKMjCCifop6kGrQLzQTZKeC9Na/C2pSGQAq2QqAAYy8
         /gde1IjHs0eDZ/c65cJwMkvxZ67C8eICAFyJQ1T/gRAThN8T6RTUciQm0JUjbM5D4Kf+
         DQ5A25nlQYOdIlxHlScIinBSGw0QtUX64MbvFr8MBwb6sL/XCWefu4RPG9EuQLN0zCxM
         m9eblEb0ZF2K8K1FaB0QtOj2b7kLBCWOJqY0Z3cvt6f93uaILDBf/PN/x55nU51e5xd1
         +z4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2fENHn91gxqW1qNG15mioT3jCj/d4w48+WpCz+57dP4=;
        b=6ukFYyowOKP3fo1XZm5EUvlupje9+KmxxBcLtwlcLWV13Yvbp1ijinI7PmRStSPj7s
         OON3GHRc3Af8HaurcQTSHao9Ztiv22t87vF3ziO8FnCeHDq0qWphIXLSQvurW0u7yZ88
         ZlFJPrC8axOpnphLBENW4t+vU5a+sCXTLc8hjZjUi6u5RfYZen2WzlgxTKuVcHhiMIZs
         LtYPoujS00mb2hYmZWryVidNqkFmBObA9NrAdS3WWMSH1toWQwf2t+y0gQQdUlO1v5S8
         gTKHY+Sxc27LgYTZc4MYEpYsMjvKYtx7hnAdwjHFMzp3b1TMYdvcYW9CxzeA+6ip7pMS
         PzOA==
X-Gm-Message-State: AOAM5312EU+c+ojYORWa3BmmMqGdh+ch2L+PaBRa0XIzxV4nlWFLnNoN
        WVqpkIql8IuYpEM3Om/FEJ0=
X-Google-Smtp-Source: ABdhPJyLH4nEoja8HUwFyKOZnVD/RepyeAu4Qs5vZn6KA2Hd/ojEH+NusTjc1pMXPjyDQDHqvrRpsw==
X-Received: by 2002:a17:90a:5901:: with SMTP id k1mr2584388pji.76.1638838338166;
        Mon, 06 Dec 2021 16:52:18 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 17/17] audit: add netns refcount tracker to struct audit_netlink_list
Date:   Mon,  6 Dec 2021 16:51:42 -0800
Message-Id: <20211207005142.1688204-18-eric.dumazet@gmail.com>
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
 kernel/audit.c       | 2 +-
 kernel/audit.h       | 2 ++
 kernel/auditfilter.c | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 493365899d205c12338323b5a6ca6a30609a3d6a..a5b360ecb379426bbfc743f13beeb6cddc96f068 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -901,7 +901,7 @@ int audit_send_list_thread(void *_dest)
 	while ((skb = __skb_dequeue(&dest->q)) != NULL)
 		netlink_unicast(sk, skb, dest->portid, 0);
 
-	put_net(dest->net);
+	put_net_track(dest->net, &dest->ns_tracker);
 	kfree(dest);
 
 	return 0;
diff --git a/kernel/audit.h b/kernel/audit.h
index c4498090a5bd66e5c620368381c89d4dda14d851..ffa8b18d84ad170f8c76a213dba610b0e4986319 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -15,6 +15,7 @@
 #include <uapi/linux/mqueue.h>
 #include <linux/tty.h>
 #include <uapi/linux/openat2.h> // struct open_how
+#include <net/net_trackers.h>
 
 /* AUDIT_NAMES is the number of slots we reserve in the audit_context
  * for saving names from getname().  If we get more names we will allocate
@@ -236,6 +237,7 @@ extern void		    audit_panic(const char *message);
 struct audit_netlink_list {
 	__u32 portid;
 	struct net *net;
+	netns_tracker ns_tracker;
 	struct sk_buff_head q;
 };
 
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index d75acb014ccdcba2a0bed0646323f5427757e493..2ea0c2ea9b7272a8abcd4c36a4d35f17e75e92e3 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1182,7 +1182,8 @@ int audit_list_rules_send(struct sk_buff *request_skb, int seq)
 	dest = kmalloc(sizeof(*dest), GFP_KERNEL);
 	if (!dest)
 		return -ENOMEM;
-	dest->net = get_net(sock_net(NETLINK_CB(request_skb).sk));
+	dest->net = get_net_track(sock_net(NETLINK_CB(request_skb).sk),
+				  &dest->ns_tracker, GFP_KERNEL);
 	dest->portid = NETLINK_CB(request_skb).portid;
 	skb_queue_head_init(&dest->q);
 
-- 
2.34.1.400.ga245620fadb-goog

