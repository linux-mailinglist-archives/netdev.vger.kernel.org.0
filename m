Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FBB19876
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 08:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfEJGhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 02:37:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44803 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfEJGhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 02:37:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id g9so2662507pfo.11;
        Thu, 09 May 2019 23:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xdrfU3jBA/RaTefpguhrn0FDqFx10ulzhdJD8aISx+c=;
        b=LUHea/+gXaK+ldcCF1TiORDqUzjf3Qltryz8swWImZoJDp/+LE9B4dViupdCxI9GzP
         Vaef4tuHn6gDIR7CX5mieXSFPRgRdapU2NW0I9VjJTBE+X+pUVaCDvsuixld/TtLkZeG
         Y7ZDrq5xz9rWlYGvowW1GgaIy1xaVOIXkhDU4dT4ga9ito1Xg/L9Rooy0hbAMX+Y9EX7
         9SVKTzAVdUpnJw+M8S6sM0n2Ybd73KzsOtz4JJ6fmj/pyc7dQrNIE1Z4GyA58eN0IPdr
         sJG1+ZXq4mYVNJO02swLUlaFTq72YvYeDL4fmJaPJEJ3y81+ZZDiO6bEVolgLqiwJshb
         ovbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xdrfU3jBA/RaTefpguhrn0FDqFx10ulzhdJD8aISx+c=;
        b=XE5FM9nimTqxuj5KP6rkgoqbQyJgOUSQ74PukBx1yrhETrefYWjas7mZgsxR6gRFYW
         2vDUHtMv57NGpVZZad9DevMnPjJjUSs9PjyJS7NEj3sFI0ZmPx1EDKoLbRuvsBfiWMTq
         pOxKDcLB8Z0idgEj02SJptsInHapkDC+9Ul3VEZJ/dbSoYYlH7dJevgZ35okx7nL0NWO
         YExDRZGzw1WdKXbdSSXQiKT+IGXpl/QPOkalnQ3UVgehrPrdnIrPODPsSUCrxfdvDdJB
         t3k9fXepEV46N8jO3Vb4nmI6hve1mpDig55BMnva5xO/UILspZtqbxONocj6BE0feuXx
         FSpg==
X-Gm-Message-State: APjAAAXPpeaw4rKSsmWqHPZfc6wUO8DJ9mavMMVMm5dORlmi9piVUUra
        Wl6cjhi3OaNs6gXvI9wZTGQ=
X-Google-Smtp-Source: APXvYqwEg2W/ONGhmSKEJ4iAryMnClEs/wpvuLAXoKejUtG4t1tjei2Q47PD83+u7r3ZvEdDfrqSqw==
X-Received: by 2002:a62:5b81:: with SMTP id p123mr12002969pfb.158.1557470227343;
        Thu, 09 May 2019 23:37:07 -0700 (PDT)
Received: from bridge.localdomain ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id v6sm4469263pgi.88.2019.05.09.23.37.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 23:37:06 -0700 (PDT)
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
Subject: [PATCH v2 2/3] netns: add netns_evict into netns_operations
Date:   Fri, 10 May 2019 14:36:02 +0800
Message-Id: <1557470163-30071-3-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
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

