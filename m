Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BB910594
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 08:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfEAGn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 02:43:27 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46138 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfEAGn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 02:43:26 -0400
Received: by mail-pl1-f195.google.com with SMTP id bi2so3051403plb.13;
        Tue, 30 Apr 2019 23:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tZpDbbxPQIQaiTEJ/QF3eG59ACeQtX21Wr99/jZNM7o=;
        b=VICxe5gWrDbyG3fzdiTZ3NxrsnDGD2Bmk3eV/dfKI+Nspwr3svro/9NsjGbukA37YM
         EreicPwuqGiQxyidBPdvRKLT7UQfIfoemCx1oFnRwJmgDXOH9m3jGoWaEDppqsqI7TR8
         mNNiNLCyLJJB33DoeIodvbZpuDgVtvsuJuId4/lwVaT2uwiGL1P1ZwOmj1jPk9/dkjqv
         h6CIZ77DVLxmeCJBc7LOVLMKA0fg1VPl17ujhbBvxBArg1+onpwQuv2B/8BS4W09FJmk
         PL3XIKlZN5Ua49e0i03pz6qg3690Zqu4IdzHr9qx0NkTU4L9FYx8RuFRDnDvgiwpB/HF
         gs0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tZpDbbxPQIQaiTEJ/QF3eG59ACeQtX21Wr99/jZNM7o=;
        b=rUXYhCTHwn82yeucOjRE3EkxUho6vIlw3r5CdXCJXx1M2sOnsBePG2BeFJfsNwgf5/
         xI/WqZRKYDNLae90tDBTc9CvPXE66yo4ZRNZuzVGTb4LtoGWxc7lGJed8rMdIp87z07w
         tDu7ZdjyLQCFxPW0gbtyHjJjWJjX8muOSE583imK9/yEoaH0L3IK047zgBH17p4gc+wt
         62bGGnhtlsrzYrZ76KdEj83V0T5S7tfCPNqZ192aTfTtWmmsoiItxYkngdMc+6+yM872
         2eTIqvjNhmezt6nX7IZ5EdHZH7NnZXTHkzQqC0MLvNFAI0VEe61yLS6SJMOKZuxYsty3
         KXYQ==
X-Gm-Message-State: APjAAAVtOniobu8idukFvI51Gz4zUl2Ifo72SHsn9/GR2LwI5Nrcv8U9
        sfZ0OUmhtTyJ8vYhvumwkEE=
X-Google-Smtp-Source: APXvYqyCkaw2Mtev/GQI2Ae/9T0TBTMQyOtHtcJP5lPKRujliHcQCSg+hLV/y0BUYpsPOA4Ju4SE5g==
X-Received: by 2002:a17:902:6b47:: with SMTP id g7mr28995601plt.227.1556693005762;
        Tue, 30 Apr 2019 23:43:25 -0700 (PDT)
Received: from bridge.localdomain ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id 25sm56800323pfo.145.2019.04.30.23.43.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 23:43:25 -0700 (PDT)
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
X-Google-Original-From: Wenbin Zeng <wenbinzeng@tencent.com>
To:     viro@zeniv.linux.org.uk, davem@davemloft.net, bfields@fieldses.org,
        jlayton@kernel.org, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, wenbinzeng@tencent.com,
        dsahern@gmail.com, nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH 3/3] auth_gss: fix deadlock that blocks rpcsec_gss_exit_net when use-gss-proxy==1
Date:   Wed,  1 May 2019 14:42:25 +0800
Message-Id: <1556692945-3996-4-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
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

