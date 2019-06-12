Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331CE4251F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437105AbfFLMKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:10:52 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38426 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfFLMKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:10:52 -0400
Received: by mail-pf1-f194.google.com with SMTP id a186so9557288pfa.5;
        Wed, 12 Jun 2019 05:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3H4KBLy7rzn4N4rsqKL3jtODKunPIFRmncDUCrNEJAQ=;
        b=ZvA1/rmDgqi6AF3tfYkhRg6JSLJi0m6MUeJ8pOWABX5bcOaz3sIUxHwqxiXzJTmWGm
         fy+ym2zGLysa8c9LZsJwKHEspTaSwVerpWDs7+7P44ZhWgioY2+IMARE4K3/ELMo+9aF
         CeSXANVb9g4fv1JQ1Ra71p8lNqBlorNglK8fIRdV2TEyIpD7O07r+5BkoL0KHL2CuGOS
         S6/wtvtF3P1vnfYLNayD93v37Zp+/6m2RfgTT9YceAfBH1xgOCMy3nYgsvRcBiiPa7eO
         vrJgiSNf+5eZOAvx3ISQVKYGncCcoE+ZRDGjABmgZmzOm2crS+sFAcOoF18tKDcjZsgz
         gwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3H4KBLy7rzn4N4rsqKL3jtODKunPIFRmncDUCrNEJAQ=;
        b=PRUzMWKlaJdn7mUzj6316zkZybJMcw1z8hXagnAmzzeyE15rAlpYDm7MrA+1SqhFP3
         TqnoglhdT72AGDB3eBypMDb0JJlHvZxwWIJBLFZ2E5mJ9M7w/QDg3LySsnZ0CNZjeq8m
         tEK0E5fSv4I48lKZqIwXVLXflHR8qebZFscizrDTpWMuNYg45UfM3pEDy0e06l8B8NFW
         4it5Y5VN1l1kBvASRZrrZksVBh4SEUtPe+R6YsSs1PnlCtHf6DGjXB4n8qLtu18rHpF6
         vFnDVEVNcXiime56LA0vl3b+g2f5rQpKrlT7kPtioQT2Nm4oWV4WAqJD5i+IM5oAjyM5
         /5vA==
X-Gm-Message-State: APjAAAX2cVD4U8pqwhagW5fhibP0+EOgOnAsoK0xL/JXxD8pg5/m8Uub
        cj97syaLdJfUvbCKqyIuNKo=
X-Google-Smtp-Source: APXvYqx8YwldwgXedozTQN/uqbDckBhnDXJyP7tva/d98nOtwHCKo8qsRH0r4zreASsukzFDuTSnyQ==
X-Received: by 2002:a65:5241:: with SMTP id q1mr23177763pgp.298.1560341451233;
        Wed, 12 Jun 2019 05:10:51 -0700 (PDT)
Received: from bridge.tencent.com ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id s5sm5035653pji.9.2019.06.12.05.10.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:10:50 -0700 (PDT)
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
X-Google-Original-From: Wenbin Zeng <wenbinzeng@tencent.com>
To:     bfields@fieldses.org, davem@davemloft.net, viro@zeniv.linux.org.uk
Cc:     jlayton@kernel.org, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, wenbinzeng@tencent.com,
        dsahern@gmail.com, nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v3 2/3] netns: add netns_evict into netns_operations
Date:   Wed, 12 Jun 2019 20:09:29 +0800
Message-Id: <1560341370-24197-3-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560341370-24197-1-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1560341370-24197-1-git-send-email-wenbinzeng@tencent.com>
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
Acked-by: David S. Miller <davem@davemloft.net>
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

