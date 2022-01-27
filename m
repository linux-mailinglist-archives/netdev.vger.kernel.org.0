Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0DE49EC43
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343820AbiA0UJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240073AbiA0UJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:09:45 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C291C061714;
        Thu, 27 Jan 2022 12:09:45 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q75so3249765pgq.5;
        Thu, 27 Jan 2022 12:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vqz3x4L30hj6XxJnf3VM6m56+12Dc+5qoM6cpW+3GgI=;
        b=TfCKmEOPUtKjcU1P322uV0VSo/0Hqbtrig/Js9i+E+ivMVt2IuJuaLJ3KjRNyJpJUl
         LKyYz1cheJSjBgwSjJd3tsp5gaSmWsuVE4NlrfuLVTrv/PCqYvGSPlaqAFI/oI4Ws7sH
         nsPzhS597DmrtybtMIv+gth14gXgssjQajvGVt03B29q/j9/nnfnC9CLzm9tZ4HOEYXY
         61aFSnSMMHxiPXzQLDOJyvOcTeKkzJibuTMFeU+GLNwHjyFGXg7v20II/TroRiZ6Hwy6
         riB8654moFLoI+FC671uGGD2QhR4x1OaN+lrC5Crdwxy0jAz3rzZN2IkUJkUoTuBfzep
         g4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vqz3x4L30hj6XxJnf3VM6m56+12Dc+5qoM6cpW+3GgI=;
        b=mhRPM7K4Y2OocpZguKoGviYjCHvP/2YXYV4LJd+lS6rWreSGI7UZzMQh55dUKF2JJV
         THY60O0iarXbRjqz/awSIK+9LGXwkGgrvb3P9tIcWEj4pl+I/L+7Yz+LJp/Ew7n/Aa0h
         KlAldVk61oG3IGV5+/eO7gQLYu6/g8+3dlNDED6UTNfGDuo75W+KyiiM4On2tSYZWXrm
         6zSGN9i4KD4vZFY4QZjLVegvhygQAjFH2ZW1ZF1MrIMKU3RwuQf8odkdp6U87mZsxHgc
         JFmAQJ/ThWm4l7wnFtqy2/EuHBJVdn3cm97np0NAxMiC96aJAsbrQ/Me+hqXqsbs+OHF
         BoxA==
X-Gm-Message-State: AOAM533bIPqYj7u6cjGYDPUL8eTr2xbICWMTTGziQRVXQbQrsUwDjejM
        baVoKwZDEkV9yQeNk4383e4=
X-Google-Smtp-Source: ABdhPJzx24L1v1OGbNhbkdY9s4EzWFpeWN4ZqMRKU6+pWr/ZYaUDcuhrMwqllkD6u619ubiMQYFs5Q==
X-Received: by 2002:a63:8ac9:: with SMTP id y192mr3835856pgd.409.1643314184953;
        Thu, 27 Jan 2022 12:09:44 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ab5e:9016:8c9e:ba75])
        by smtp.gmail.com with ESMTPSA id y42sm5697892pfw.157.2022.01.27.12.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 12:09:44 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/3] SUNRPC: add netns refcount tracker to struct svc_xprt
Date:   Thu, 27 Jan 2022 12:09:35 -0800
Message-Id: <20220127200937.2157402-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220127200937.2157402-1-eric.dumazet@gmail.com>
References: <20220127200937.2157402-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

struct svc_xprt holds a long lived reference to a netns,
it is worth tracking it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/sunrpc/svc_xprt.h | 1 +
 net/sunrpc/svc_xprt.c           | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index 571f605bc91ef8fa190e7fd5504efb76ec3fa89e..382af90320acc3a7b3817bf66f65fbb15447ae7d 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -88,6 +88,7 @@ struct svc_xprt {
 	struct list_head	xpt_users;	/* callbacks on free */
 
 	struct net		*xpt_net;
+	netns_tracker		ns_tracker;
 	const struct cred	*xpt_cred;
 	struct rpc_xprt		*xpt_bc_xprt;	/* NFSv4.1 backchannel */
 	struct rpc_xprt_switch	*xpt_bc_xps;	/* NFSv4.1 backchannel */
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index b21ad79941474685597c9c7c07b862ef7e98ad74..db878e833b672864551bc9ef884a3cd6ca6c2603 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -162,7 +162,7 @@ static void svc_xprt_free(struct kref *kref)
 	if (test_bit(XPT_CACHE_AUTH, &xprt->xpt_flags))
 		svcauth_unix_info_release(xprt);
 	put_cred(xprt->xpt_cred);
-	put_net(xprt->xpt_net);
+	put_net_track(xprt->xpt_net, &xprt->ns_tracker);
 	/* See comment on corresponding get in xs_setup_bc_tcp(): */
 	if (xprt->xpt_bc_xprt)
 		xprt_put(xprt->xpt_bc_xprt);
@@ -198,7 +198,7 @@ void svc_xprt_init(struct net *net, struct svc_xprt_class *xcl,
 	mutex_init(&xprt->xpt_mutex);
 	spin_lock_init(&xprt->xpt_lock);
 	set_bit(XPT_BUSY, &xprt->xpt_flags);
-	xprt->xpt_net = get_net(net);
+	xprt->xpt_net = get_net_track(net, &xprt->ns_tracker, GFP_ATOMIC);
 	strcpy(xprt->xpt_remotebuf, "uninitialized");
 }
 EXPORT_SYMBOL_GPL(svc_xprt_init);
-- 
2.35.0.rc0.227.g00780c9af4-goog

