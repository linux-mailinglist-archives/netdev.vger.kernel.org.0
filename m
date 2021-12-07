Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0167F46AF75
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378803AbhLGAzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378805AbhLGAzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:44 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E937C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:15 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id q17so8223074plr.11
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UdPDwq8o61e7G20ZR30qlNL+N7paQ2mCgzDyN9fgfok=;
        b=Vnf9Ic7ou7Ywh4dPcqA1fCTw3cAYcQ5drF9YAHkZn/+uI2x9G/waXB1TBHmEbJofAF
         REclTMdcWcqiG7pIV6tsWioUOV+eU/f8DbZXQSCDcBlsaEY+VYqrQf/3QejwdQhCYgjv
         kMHSvJ/5W6WeYxtEF/IZ2NqOr2B5M7bPUy785BlqDeyZo5wRB6bxGs/aHbuaWVpUoVtA
         CxF9m5HPbTWHMKqjIoRacYDTQrGgTW6niM1hCA/j1RgV6YlhkNkktg7zIZ/J74J7BhMw
         X5iYZ1X9uXNiYEj7j9nuLXQ+1y5wwULdKvkkDL/mfc7cbAHrF0bk7VDG1BLy06GXhjB6
         9kvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UdPDwq8o61e7G20ZR30qlNL+N7paQ2mCgzDyN9fgfok=;
        b=2WVjrWxWLgdQSDDfCv/9fNIAdRKwzAEgzRY6bYmsmxfLCG4k7U2DAcY/mD8529ePgt
         qPpfyNFPyC8wkXjW4mecQuOXK4Bza8LywjXG7nB9f31tEsF0IV88XoM0w8c2Be9n4HDb
         Me18OqvBJBkIpI2FeQNmq5ypJBXOdyLhCmLnXgu6OWViouO9enJ7jhrkLnGIJucWXIAX
         0yuELvRM4AR3VMQd7emTdjrh1Dt/dEM3TDlfb7bzSLHkESS0j2x5ZVdCXVzYc0DalNbA
         vL1QHP1SJ2wYFnLYhJCINoC5x8Kg+UsAGI8OtdMXrnkgM+j15pkFvjF5bkEgLAe/C3Kq
         lRXg==
X-Gm-Message-State: AOAM530SJBseO54HceWxBxszQMAKlMzzMAHN7z50qah2UaRVluH0qUdG
        Lzi5gztIOLkus7tp9BwfFbQ=
X-Google-Smtp-Source: ABdhPJwutXFl+VfpKFht4WNUYX7JtfH+QbJ+H/40E2b7xxflacFMKn8FSEZ/aXoc4hMCpEMdYIsMVQ==
X-Received: by 2002:a17:90a:8c0a:: with SMTP id a10mr2589485pjo.58.1638838334913;
        Mon, 06 Dec 2021 16:52:14 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 15/17] audit: add netns refcount tracker to struct audit_net
Date:   Mon,  6 Dec 2021 16:51:40 -0800
Message-Id: <20211207005142.1688204-16-eric.dumazet@gmail.com>
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
index 121d37e700a62b53854c06199d9a89850ec39dd4..27013414847678af4283484feab2461e3d9c67ed 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -96,6 +96,7 @@ struct audit_net {
  * @pid: auditd PID
  * @portid: netlink portid
  * @net: the associated network namespace
+ * ns_tracker: tracker for @net reference
  * @rcu: RCU head
  *
  * Description:
@@ -106,6 +107,7 @@ struct auditd_connection {
 	struct pid *pid;
 	u32 portid;
 	struct net *net;
+	netns_tracker ns_tracker;
 	struct rcu_head rcu;
 };
 static struct auditd_connection __rcu *auditd_conn;
@@ -481,7 +483,7 @@ static void auditd_conn_free(struct rcu_head *rcu)
 
 	ac = container_of(rcu, struct auditd_connection, rcu);
 	put_pid(ac->pid);
-	put_net(ac->net);
+	put_net_track(ac->net, &ac->ns_tracker);
 	kfree(ac);
 }
 
@@ -508,7 +510,7 @@ static int auditd_set(struct pid *pid, u32 portid, struct net *net)
 		return -ENOMEM;
 	ac_new->pid = get_pid(pid);
 	ac_new->portid = portid;
-	ac_new->net = get_net(net);
+	ac_new->net = get_net_track(net, &ac_new->ns_tracker, GFP_KERNEL);
 
 	spin_lock_irqsave(&auditd_conn_lock, flags);
 	ac_old = rcu_dereference_protected(auditd_conn,
-- 
2.34.1.400.ga245620fadb-goog

