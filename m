Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976C0316649
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhBJMNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhBJMKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:10:49 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D026FC061A2A
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:04:40 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id n6so2185336wrv.8
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qMWtdr/D/b55YVpH+AH+ThithGxQzKx+2a1eg5+/BUc=;
        b=x7fU89uX9eU/xJfahZiU/Ny8AdzUWeHHw+gFzpzgqIOauzU3Jq6Er6V0wmk2XSukN0
         Bzqvom9K69BfvyB72sT7xlEPLFRin4iZvsXgkt8cYupgLjBUw143n7qRX55CVHxYsmTP
         5dLTsw9fQ9lSZJb9gNKAtxDPwKWn9BpKOCrhg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qMWtdr/D/b55YVpH+AH+ThithGxQzKx+2a1eg5+/BUc=;
        b=Zeu4gHtMRZ/P8AbknvGg3lzOHFEujJLKmfmbJcuEjO8PhcP0HX7lwHBNlxXKsogk+s
         7kZ/YsTAiDSFwnupsb5WxZGcFDujq91yYcmFpXGK12MlOsdAtakpJXaJ6R9bx2G+VTZZ
         oqtTKyscKpNmOf9leb7dhqOi8/f/4AxcryQSPG1cp2avVzYLcaCYPnjdexBAO+3x+DBS
         N5FexTTFZkLyZOUbuc4IHxrWPhXpinRYwZU1QDtHmhuTf9rHQ6GPoDmd5i04XMI1ZWyD
         7JylQIELgQ+oRAbVJIWEQcKAgMS22U83T3KH6TsGIZsu95osqKtKz1PDMPSfMeF0oP6B
         QlDA==
X-Gm-Message-State: AOAM5310hZRuw9koVgbOJJFADMjCagsDafnPPmBb8ro23oxdMxH9tR5O
        FbXMjPoG7lZN1Hkj5gimlsX76g==
X-Google-Smtp-Source: ABdhPJy7hn6DuyMJ5KdhWZVNZqUeriQtKlVgZ6WCm5DKOJwRRp+IhOVht7MCUa5UsZ3yuzCtjf9H1Q==
X-Received: by 2002:a5d:5549:: with SMTP id g9mr3483473wrw.244.1612958679629;
        Wed, 10 Feb 2021 04:04:39 -0800 (PST)
Received: from antares.lan (c.3.c.9.d.d.c.e.0.a.6.8.a.9.e.c.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:ce9a:86a0:ecdd:9c3c])
        by smtp.gmail.com with ESMTPSA id j7sm2837854wrp.72.2021.02.10.04.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 04:04:39 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf 2/4] nsfs: add an ioctl to discover the network namespace cookie
Date:   Wed, 10 Feb 2021 12:04:23 +0000
Message-Id: <20210210120425.53438-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210210120425.53438-1-lmb@cloudflare.com>
References: <20210210120425.53438-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Network namespaces have a globally unique non-zero identifier aka a
cookie, in line with socket cookies. Add an ioctl to retrieve the
cookie from user space without going via BPF.

Cc: linux-api@vger.kernel.org
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 fs/nsfs.c                   |  9 +++++++++
 include/net/net_namespace.h | 11 +++++++++++
 include/uapi/linux/nsfs.h   |  2 ++
 3 files changed, 22 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 800c1d0eb0d0..d7865e39c049 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -11,6 +11,7 @@
 #include <linux/user_namespace.h>
 #include <linux/nsfs.h>
 #include <linux/uaccess.h>
+#include <net/net_namespace.h>
 
 #include "internal.h"
 
@@ -191,6 +192,8 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 	struct user_namespace *user_ns;
 	struct ns_common *ns = get_proc_ns(file_inode(filp));
 	uid_t __user *argp;
+	struct net *net_ns;
+	u64 cookie;
 	uid_t uid;
 
 	switch (ioctl) {
@@ -209,6 +212,12 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		argp = (uid_t __user *) arg;
 		uid = from_kuid_munged(current_user_ns(), user_ns->owner);
 		return put_user(uid, argp);
+	case NS_GET_COOKIE:
+		if (ns->ops->type != CLONE_NEWNET)
+			return -EINVAL;
+		net_ns = container_of(ns, struct net, ns);
+		cookie = net_gen_cookie(net_ns);
+		return put_user(cookie, (u64 __user *)arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 29567875f428..bbd22dfa9345 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -226,6 +226,17 @@ struct net *get_net_ns_by_fd(int fd);
 
 u64 __net_gen_cookie(struct net *net);
 
+static inline u64 net_gen_cookie(struct net *net)
+{
+	u64 cookie;
+
+	preempt_disable();
+	cookie = __net_gen_cookie(net);
+	preempt_enable();
+
+	return cookie;
+}
+
 #ifdef CONFIG_SYSCTL
 void ipx_register_sysctl(void);
 void ipx_unregister_sysctl(void);
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index a0c8552b64ee..86611c2cf908 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -15,5 +15,7 @@
 #define NS_GET_NSTYPE		_IO(NSIO, 0x3)
 /* Get owner UID (in the caller's user namespace) for a user namespace */
 #define NS_GET_OWNER_UID	_IO(NSIO, 0x4)
+/* Returns a unique non-zero identifier for a network namespace */
+#define NS_GET_COOKIE		_IO(NSIO, 0x5)
 
 #endif /* __LINUX_NSFS_H */
-- 
2.27.0

