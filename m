Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D2A3505D4
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhCaRw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbhCaRwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:24 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2BDC061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:24 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id m7so14706633pgj.8
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R0IHSRMOjGG2b7EQy7oiUAwODG+2km7NuDei/NzPfLM=;
        b=IuFDwgO2QU7KptJMfIfnew2rdEHwk/fVIyy5vaTkLd/OuTLzE8rVINrYJR0AMAdNph
         uSO6r+dLs1o/q4Y5haHSDvBGdPBDwa8catpi43ucYTb9XvtY1TGpiO08DNEEzSNP79IW
         h7mADR5cHX7I9hndSfmbEQSOYX44jVb7XYpVMnaFZkTcwfEJu1iGY9t4AH3+QNzQPcVH
         zX+uXWTagtdZVg/A3CzWV3ohm/qYBFZxO8gFwGiaHioT+jAUJ6lmtzQFdD/KgysxZ06Q
         uy7jWefB33hIcoBgmp6MCA1y4aq8uvHeClWWqDjznxfg1asOF4ellk3P9+rUFU3aaYW8
         krPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R0IHSRMOjGG2b7EQy7oiUAwODG+2km7NuDei/NzPfLM=;
        b=R99H4G4rSoE/fIPNsLlW2u/pvwr0C6NwKI8RoR8Gwdkb6HQcgfc7SolcNKvUiNgTUH
         LDpe5JxndE45hG/jShMvJy3NBTxIWOiQZ/7OMHzZtIfsZ3KBrjKiGTu2J2oa+HczYaTc
         q89H7+JY231+dSGXYJP0N+YiORz0AlFTlGrNdlM4mbNoKygzkiqNWnuhcr8KprCQ46Ub
         a8LzTFiQPZ2xAm1CSdTK6YKpuFfSOLZssWYcqvJYBd3rswqOSa/JPFFqAINy8o9H8kAA
         rIy3VZJc6PwJVQanQeXmIsuJ7gvlwE+WukTCp5/Zd37S7rKnBxkPgBKkXSPTbVrp/Iph
         5sCQ==
X-Gm-Message-State: AOAM532/gP/G4d/inm6/zM3SvaaysgkOe7WAJ4GHrlmCBsUY9D9bBy3X
        lROERLolD6x6ZKWY4TkdGlT+8abeLUo=
X-Google-Smtp-Source: ABdhPJytyi0hLz3zni0I0w9Woct1a+55eWRzxroPBkHOb961tCxlOV8RgRXuCRCkWVALt3lsQgck9w==
X-Received: by 2002:a62:800c:0:b029:203:6990:78e2 with SMTP id j12-20020a62800c0000b0290203699078e2mr4045857pfd.3.1617213144245;
        Wed, 31 Mar 2021 10:52:24 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:23 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 5/9] ipv4: convert fib_multipath_{use_neigh|hash_policy} sysctls to u8
Date:   Wed, 31 Mar 2021 10:52:09 -0700
Message-Id: <20210331175213.691460-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Make room for better packing of netns_ipv4

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   | 4 ++--
 net/ipv4/sysctl_net_ipv4.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index d309b1b897158c564ac8e07e4ed6826fa6e7c7b7..eb6ca07d3b0f5a3e0e90eee3e3049c0a0cc31d3d 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -220,8 +220,8 @@ struct netns_ipv4 {
 #endif
 #endif
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
-	int sysctl_fib_multipath_use_neigh;
-	int sysctl_fib_multipath_hash_policy;
+	u8 sysctl_fib_multipath_use_neigh;
+	u8 sysctl_fib_multipath_hash_policy;
 #endif
 
 	struct fib_notifier_ops	*notifier_ops;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 1b6ce649a433c6614d9b1ac28d6c6c3daa01a525..ad75d6bb2df7f60afda5c4a4f6524885a8b982c2 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -456,7 +456,7 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 	    ipv4.sysctl_fib_multipath_hash_policy);
 	int ret;
 
-	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
 	if (write && ret == 0)
 		call_netevent_notifiers(NETEVENT_IPV4_MPATH_HASH_UPDATE, net);
 
@@ -1038,16 +1038,16 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "fib_multipath_use_neigh",
 		.data		= &init_net.ipv4.sysctl_fib_multipath_use_neigh,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "fib_multipath_hash_policy",
 		.data		= &init_net.ipv4.sysctl_fib_multipath_hash_policy,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-- 
2.31.0.291.g576ba9dcdaf-goog

