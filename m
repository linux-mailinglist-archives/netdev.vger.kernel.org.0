Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D2119879
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 08:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfEJGhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 02:37:14 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44810 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfEJGhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 02:37:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id g9so2662609pfo.11;
        Thu, 09 May 2019 23:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tZpDbbxPQIQaiTEJ/QF3eG59ACeQtX21Wr99/jZNM7o=;
        b=r59rDHqtOd7p+7W9lwVnV5p8DCUR6qGWm1fA+Se52beD9X8hdi5gXvUCA/jU5nhPDl
         WF3brRF3Y+iKrRQCfzoL7srTYKFWGrF4/+JKPn2GZDDQMP4Y32QZVWgJ8fpzz4JHDC/j
         UxJliP3I3+QfBu346rmvtNAiw8aEa1KrCRxRBDErVdos5adye4rfGww0oten6Smdy2Cj
         oRf6DSnhVd+Y6RzhNRsT2Nb/KrQ6xDm+2pd9qCCNTDMNtvZgf8j7kRKGEcMUqsJRXHGV
         /FycWZVKTUm+USwcg0lSigbRGpnzCfKUYsrXV5HD2U4o1IWUz3kIm9Cr1Z6V51X6yv0X
         4HPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tZpDbbxPQIQaiTEJ/QF3eG59ACeQtX21Wr99/jZNM7o=;
        b=o8qNj3xgEwnmTliR1dgcmSsIgabDiB48PR/bKu3qYkeqqrP3S7DqY4ekTsZWbtwDaU
         3SHTjplOcRo4lp2nOLaMnxafxuMREZRcHfTrvQMK84xJc+rHCyyker/ONZfnuvZEOzOs
         JgcwslPXGLoWPdGzmlokmrLOKfGVMRrmMnPn/EgOl9ICTaGBJQBSvCkZyVvG89+UHK0w
         GBoYkgQ+rrJwsulm2tDwuPV5WMeeTwtJSRUHScX+F0RHVaTBgBWqRy9ypCCeeFtFQnu7
         xGR1j7qPmPoK87kcH9oZ+xKijpFDya2bDuw/k4m3igXSAcPtkPBkzrTPjU/tDi/pUh+l
         4+lw==
X-Gm-Message-State: APjAAAVbfGLXmDEeaWxM1ERhu366o6KIDMqeqGS8NpctOzZKVLPH/4qQ
        cZl0aS7tsDnvthd8m7YpMs8=
X-Google-Smtp-Source: APXvYqyTPtOYvxSUX3bbrvCZ4KxRbJM8QDJZj2fhpRLkLZL3C4WBC0szcESYnw8qQPdTbioxaatmIw==
X-Received: by 2002:a63:2124:: with SMTP id h36mr11608289pgh.186.1557470232308;
        Thu, 09 May 2019 23:37:12 -0700 (PDT)
Received: from bridge.localdomain ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id v6sm4469263pgi.88.2019.05.09.23.37.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 23:37:11 -0700 (PDT)
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
X-Google-Original-From: Wenbin Zeng <wenbinzeng@tencent.com>
To:     bfields@fieldses.org, viro@zeniv.linux.org.uk, davem@davemloft.net
Cc:     jlayton@kernel.org, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, wenbinzeng@tencent.com,
        dsahern@gmail.com, nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v2 3/3] auth_gss: fix deadlock that blocks rpcsec_gss_exit_net when use-gss-proxy==1
Date:   Fri, 10 May 2019 14:36:03 +0800
Message-Id: <1557470163-30071-4-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When use-gss-proxy is set to 1, write_gssp() creates a rpc client in
gssp_rpc_create(), this increases netns refcount by 2, these refcounts are
supposed to be released in rpcsec_gss_exit_net(), but it will never happen
because rpcsec_gss_exit_net() is triggered only when netns refcount gets
to 0, specifically:
    refcount=0 -> cleanup_net() -> ops_exit_list -> rpcsec_gss_exit_net
It is a deadlock situation here, refcount will never get to 0 unless
rpcsec_gss_exit_net() is called.

This fix introduced a new callback i.e. evict in struct proc_ns_operations,
which is called in nsfs_evict. Moving rpcsec_gss_exit_net to evict path
gives it a chance to get called and avoids the above deadlock situation.

Signed-off-by: Wenbin Zeng <wenbinzeng@tencent.com>
---
 net/sunrpc/auth_gss/auth_gss.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 3fd56c0..3e6bd59 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -2136,14 +2136,17 @@ static __net_init int rpcsec_gss_init_net(struct net *net)
 	return gss_svc_init_net(net);
 }
 
-static __net_exit void rpcsec_gss_exit_net(struct net *net)
+static void rpcsec_gss_evict_net(struct net *net)
 {
-	gss_svc_shutdown_net(net);
+	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
+
+	if (sn->gssp_clnt)
+		gss_svc_shutdown_net(net);
 }
 
 static struct pernet_operations rpcsec_gss_net_ops = {
 	.init = rpcsec_gss_init_net,
-	.exit = rpcsec_gss_exit_net,
+	.evict = rpcsec_gss_evict_net,
 };
 
 /*
-- 
1.8.3.1

