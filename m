Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F174346AF6F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378792AbhLGAzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378742AbhLGAze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:34 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28338C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:05 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so649515pja.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JVLblEXWrRl5NFNiudFx6U8kUBQLbNtS9v+jeY8mzB4=;
        b=dFTvp/owneCRMoUC2yw86unakEf7vhlH25x9xWmxfj9cGbHE6K9Jjtj+rSt9IzcO7u
         hPF2unZCxJBiwtKcAkCqc5jaLX1mE5OME173iQtQZuX+/aMX/CgorrrqedPs6il4Rral
         WPQNTWsWNMVOJ/P6hgAaFTqQITcr7il4hHLk+DTZhfcNiGkF5HDYfIc9nJKBMRt1TKaH
         qDhB2Bvyu4hVTV5R5y0cvXcwL+3cFU6wSenrYoGfKGuB3jwZHTL9AX/eJKCIGXzWF8CG
         at0Iumc9/EI3JvdXsnkXcfEH/bRcCRAjkkMD41VcwMUuoT47GViGNi580T4YGfhCuFw2
         N1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JVLblEXWrRl5NFNiudFx6U8kUBQLbNtS9v+jeY8mzB4=;
        b=2Y3IYXZ+ZmK7HJYB0tqCO/vcy3WFQoCsPT72n39EEPp5cyQoDbNsLi1o1gYBAjtFr7
         Sx0M57jo5RxMmQJUpRGXdBqr8vYPwIcNLmDjnWPT0XvMB0HLjy5l9tzBLYCYh5YKPwYV
         8NtxzHwTvvfn5gXZv3F2+poBl3/eR/5HOCw4/f7T7N/smYrVINhItX6cutkl94dSsCtW
         1XWSLGdv3Ry7Pba2wDF4RbfNCy+i84nJewqQMtpqKSQcuWvc8cUSOIk3Fyua306r5Hrm
         a7ByGhwC3yW9d7qqUd4c8kOzDxzFWjbcdjdlE8iOt8puYyexPxRMVcTbEgRJrBYN+dJR
         6Kuw==
X-Gm-Message-State: AOAM53110LAD8m1C6mPTVlDpi4IG+ewz+X+jXT7kb176h8Lh7oZxOBAf
        ZKJUUZMQjaCDdz0FqAzCey67k7l63jI=
X-Google-Smtp-Source: ABdhPJzuzKNdxX+m5Znm/MRv/Whj2O3iihnVLYWh+kLzc77RzSUVMxmQhkk7KHP9qSPO+IoL2x8guQ==
X-Received: by 2002:a17:90b:3ec2:: with SMTP id rm2mr2601425pjb.1.1638838324735;
        Mon, 06 Dec 2021 16:52:04 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:04 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 09/17] SUNRPC: add netns refcount tracker to struct svc_xprt
Date:   Mon,  6 Dec 2021 16:51:34 -0800
Message-Id: <20211207005142.1688204-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
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
index 1e99ba1b9d723d007ec3a00044b5ff922b7d8e56..16ae461fad1412dfc34192dcbdad494910a147f7 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -161,7 +161,7 @@ static void svc_xprt_free(struct kref *kref)
 	if (test_bit(XPT_CACHE_AUTH, &xprt->xpt_flags))
 		svcauth_unix_info_release(xprt);
 	put_cred(xprt->xpt_cred);
-	put_net(xprt->xpt_net);
+	put_net_track(xprt->xpt_net, &xprt->ns_tracker);
 	/* See comment on corresponding get in xs_setup_bc_tcp(): */
 	if (xprt->xpt_bc_xprt)
 		xprt_put(xprt->xpt_bc_xprt);
@@ -197,7 +197,7 @@ void svc_xprt_init(struct net *net, struct svc_xprt_class *xcl,
 	mutex_init(&xprt->xpt_mutex);
 	spin_lock_init(&xprt->xpt_lock);
 	set_bit(XPT_BUSY, &xprt->xpt_flags);
-	xprt->xpt_net = get_net(net);
+	xprt->xpt_net = get_net_track(net, &xprt->ns_tracker, GFP_ATOMIC);
 	strcpy(xprt->xpt_remotebuf, "uninitialized");
 }
 EXPORT_SYMBOL_GPL(svc_xprt_init);
-- 
2.34.1.400.ga245620fadb-goog

