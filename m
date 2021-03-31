Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C103505D3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhCaRw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbhCaRwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:23 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386B6C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:23 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m7so14706583pgj.8
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pkzDn6X0RCGFonrmehfqTb80AWvyr1DUQQBDfugKISM=;
        b=NZKPRxQIVIOp7te0u2ckXwQXt8ohwB82XQhxD8A+H3+HhCwQRj38koqyWACXv+USug
         j4m5voj8LZ2WWWR2s9/8FZXxSHXCUx5P/wHupHEVar6PlhEf6DjhDBNu6DAquIfRzjMb
         8YeKgXeDJyu6oDFW4aEsFTNxmObgf/wBynrLrlJnwMRffkT/ZHsXVrwxC9i5/FrUQlx/
         wZ0h5GCrjJzCVMIzyGJEqdEHsj5NpgYT90btsGT/QQTe8MmTNhw7bAaTbHWNPmC3W1YN
         14yYAH9sX4a5aZc1GFRuBUmNvtzL/xF/4fAwk/IOWE9udQ8tnLfh1hdcDrCuOvw3BBdN
         PlBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pkzDn6X0RCGFonrmehfqTb80AWvyr1DUQQBDfugKISM=;
        b=tXWUpF7J+3cCy3O9pChu6zAPN1ot4//XZBF5iwZfyj/Dy2s25Ve/8O8Or1ecO7RKar
         UNoUFkQR501CZMJ9pM4JRzvRHf469IznX+pHW4LcUdQNxwzaqury1paxwOObOdUujV/s
         qNqaGjlAvsIifyLW7l8tw/QsSxXS6Mmd2qsKG9UQeOycpbCaBL7wA4u2cQUU3sL8++53
         h18dCqAecvpdxK80FRtC9h6b9SkJLJU7s5XpuYAbqf/XD27azaL4hIbh6OOQsrubdmhA
         iig8DLgz+dLPgU854CKfcsEPDIe8K6C73pKdvVvh4IsGxTBsXU779Iq7ZJhmRKxC7txA
         ibXQ==
X-Gm-Message-State: AOAM530Zb+gVW+VhDybAHHa4YUnOi0q3txgpHvuoSu3yOP2vBeKRrc2g
        138zy0KstX/7vIWXBAJx9m4=
X-Google-Smtp-Source: ABdhPJw76a/KMbSn6MCmtxbkMqdiXu4ito6yGg6ZrKi3o0Gc9bm/2pn+Uo3Qrj8R8v27JkWJ0rGdbg==
X-Received: by 2002:aa7:96f0:0:b029:1f3:97a4:19d2 with SMTP id i16-20020aa796f00000b02901f397a419d2mr3975657pfq.73.1617213142862;
        Wed, 31 Mar 2021 10:52:22 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:22 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/9] ipv4: convert udp_l3mdev_accept sysctl to u8
Date:   Wed, 31 Mar 2021 10:52:08 -0700
Message-Id: <20210331175213.691460-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Reduce footprint of sysctls.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index b187ac597b8ce33376070bcd42c8c935b9c287eb..d309b1b897158c564ac8e07e4ed6826fa6e7c7b7 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -194,7 +194,7 @@ struct netns_ipv4 {
 	u8 sysctl_fib_notify_on_flag_change;
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
-	int sysctl_udp_l3mdev_accept;
+	u8 sysctl_udp_l3mdev_accept;
 #endif
 
 	int sysctl_igmp_max_memberships;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a2352d8d88cc9956ac0ddcaf351cbc996fa10add..1b6ce649a433c6614d9b1ac28d6c6c3daa01a525 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1065,9 +1065,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "udp_l3mdev_accept",
 		.data		= &init_net.ipv4.sysctl_udp_l3mdev_accept,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
-- 
2.31.0.291.g576ba9dcdaf-goog

