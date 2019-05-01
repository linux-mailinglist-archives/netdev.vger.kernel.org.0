Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C286E10592
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 08:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfEAGnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 02:43:21 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34690 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfEAGnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 02:43:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id ck18so3550474plb.1;
        Tue, 30 Apr 2019 23:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xdrfU3jBA/RaTefpguhrn0FDqFx10ulzhdJD8aISx+c=;
        b=UdawqhhljrG9fvDsp2cbCTnQshFTexvhy5CiZiytSMP/iwATvG2WrQV4l/J3g5tZVF
         hw8lMRc472AbgLfbd9mvwdN0A4fM/C54UYIf1BvkRWDQwPuT4lhLwYvKJtBqp2r2laI6
         P+XN1t2zKPq+MyfSlsDTsnRp3yfNDvNjoHZ2aoedizPQCc55tjS7NbT1Ts/NGkRaKSuP
         ogD7AnGuEdbG4UaULMKO5EoI/H2gzbVxFs86f6hKYYS6yaiLUzm3kwwsYfuiqEYzZuMA
         aQaWRllPVyl0l1/PORoyS2BnveQZXxGsv8YR9cJz1RpHGx1mifdsEWopL44KxhofWJhG
         g7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xdrfU3jBA/RaTefpguhrn0FDqFx10ulzhdJD8aISx+c=;
        b=EJ23zFJ73qKph6bBujQKR4p49c+bcgXMXX2rVIRX+z/IlwvK2fO/NKpXsWccH+D1VO
         zQlkCI7eQCr5s+NEZ/zlr442Nf7usaY0uymEO5lLZLmK88VQKzWaCo1veOtpAmXwyv+5
         Omu00bRaWlRT4SM61kw1NB7WJrlUpQC0CN9C51Qo9WQ7dgbRNXt9zmmnMVFkpxUG6yVR
         phGh+Cc5poNpha2ilQOeAsE5ueVgzZlSm1mUvwYnoky8vcm53RDbC4mteT2uu2pN+vdg
         YfMYel2EElCplIWduW7+XvAYfOfvYfB7iyIUR6rrhRpaFvN9LrF+/c/KtlbZQq99BFtz
         gR1g==
X-Gm-Message-State: APjAAAUK7mnW+HA/lyHomNLulJyyN3COMOTSMOd+i/EHZpX8d3dJlUhK
        RMlRaQbacmBxUoR0VNGm5yc=
X-Google-Smtp-Source: APXvYqzMa78IZEmeG2BBTMQBO6hV4N+2TsEwTeB48HmeFzfU0Jwv1d7C188OpgAE0VxuFPAKHOlG9Q==
X-Received: by 2002:a17:902:1681:: with SMTP id h1mr41640806plh.102.1556692999119;
        Tue, 30 Apr 2019 23:43:19 -0700 (PDT)
Received: from bridge.localdomain ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id 25sm56800323pfo.145.2019.04.30.23.43.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 23:43:18 -0700 (PDT)
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
Subject: [PATCH 2/3] netns: add netns_evict into netns_operations
Date:   Wed,  1 May 2019 14:42:24 +0800
Message-Id: <1556692945-3996-3-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The newly added netns_evict() shall be called when the netns inode being
evicted. It provides another path to release netns refcounts, previously
netns_put() is the only choice, but it is not able to release all netns
refcount, for example, a rpc client holds two netns refcounts, these
refcounts are supposed to be released when the rpc client is freed, but
the code to free rpc client is normally triggered by put() callback only
when netns refcount gets to 0, specifically:
    refcount=0 -> cleanup_net() -> ops_exit_list -> free rpc client
But netns refcount will never get to 0 before rpc client gets freed, to
break the deadlock, the code to free rpc client can be put into the newly
added netns_evict.

Signed-off-by: Wenbin Zeng <wenbinzeng@tencent.com>
---
 include/net/net_namespace.h |  1 +
 net/core/net_namespace.c    | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 12689dd..c44306a 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -357,6 +357,7 @@ struct pernet_operations {
 	int (*init)(struct net *net);
 	void (*exit)(struct net *net);
 	void (*exit_batch)(struct list_head *net_exit_list);
+	void (*evict)(struct net *net);
 	unsigned int *id;
 	size_t size;
 };
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 7e6dcc6..0626fc4 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -1296,6 +1296,17 @@ static void netns_put(struct ns_common *ns)
 	put_net(to_net_ns(ns));
 }
 
+static void netns_evict(struct ns_common *ns)
+{
+	struct net *net = to_net_ns(ns);
+	const struct pernet_operations *ops;
+
+	list_for_each_entry_reverse(ops, &pernet_list, list) {
+		if (ops->evict)
+			ops->evict(net);
+	}
+}
+
 static int netns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 {
 	struct net *net = to_net_ns(ns);
@@ -1319,6 +1330,7 @@ static struct user_namespace *netns_owner(struct ns_common *ns)
 	.type		= CLONE_NEWNET,
 	.get		= netns_get,
 	.put		= netns_put,
+	.evict		= netns_evict,
 	.install	= netns_install,
 	.owner		= netns_owner,
 };
-- 
1.8.3.1

