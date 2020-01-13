Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFBF139BC0
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 22:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgAMVj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 16:39:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38503 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726778AbgAMVj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 16:39:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578951566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c6pvUy+BgGk9fXmHIYc6FuRPGv6sOMj5BnD2gJKkYdw=;
        b=fPC5fqf0bcDpoj1AAO4YuK3JjWByU6XtbyRDmEEFSg1N/9Kh8UfCOuhqIjOfYWCRvUlMJf
        +Hxr66y2k/t9PO6/TSa8LguYSm6afbPhu3R5tg7cvrK3iMxScQzZafIlmZyvNuSjzIv35V
        JZATutSrC9RYiK8qXYOr/d54Gg/iSwQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-E0HhSBGeOYCl3ylJUytkBw-1; Mon, 13 Jan 2020 16:39:25 -0500
X-MC-Unique: E0HhSBGeOYCl3ylJUytkBw-1
Received: by mail-wm1-f69.google.com with SMTP id b9so2840042wmj.6
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 13:39:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c6pvUy+BgGk9fXmHIYc6FuRPGv6sOMj5BnD2gJKkYdw=;
        b=SArVSU0YJ/f+PgHKJA+fgDtNTauUJzohS6XmF3pXj7HGej5fbTVrIo6x8GFkR3RB8l
         lnd41XOqwk1gFlUgeroM9IbM/jPuf6TGGWHsF9w1R2L9YoBx2lq0rsvJCVfjqfpGVJDl
         r8oCBOEUjwxt4ECRu3swChuw4XDiI0NcAYuyldub+gE5SyRlF4a/pD8ILyWJPo0jauNy
         6DU1RIepotfWpOMgRHJGc+C9n7/FwBtKdypNlJNa/j9Urd2u+LIOWeosEEF7vV4VlKR0
         QFTBHBgoAZTwtmJ344wYbj6RXYqwrrL0DYNNFIqcrYxa9ej7Dw8aO4OQ4DEum0HxgYsV
         MVww==
X-Gm-Message-State: APjAAAVkBRCQCOrA74Ei9+oLKLPWhFd8g7LqvPkNjx9Rc60XHjzG13tX
        7BD9N2F73Pgu29NkIMrMajkQ9NeYjUJrzijOdW3c1tJo8ykkFs6qmN70wx6YX42llrNAqWAOFSA
        CcJ0PvFHlZwb+WdTH
X-Received: by 2002:a1c:7406:: with SMTP id p6mr22375272wmc.82.1578951564813;
        Mon, 13 Jan 2020 13:39:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqz1h5OT1XBVqV8yvlY8pyQT9HVrvuIF529Ak7L+9lSHoFPwNehw9h716oTYf40YqbI3EqPSNQ==
X-Received: by 2002:a1c:7406:: with SMTP id p6mr22375258wmc.82.1578951564636;
        Mon, 13 Jan 2020 13:39:24 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id f1sm16858815wmc.45.2020.01.13.13.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 13:39:24 -0800 (PST)
Date:   Mon, 13 Jan 2020 22:39:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 2/3] netns: protect netns ID lookups with RCU
Message-ID: <44c8f937a2bd6b902b7d4f82261f087b49b5ab29.1578950227.git.gnault@redhat.com>
References: <cover.1578950227.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1578950227.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__peernet2id() can be protected by RCU as it only calls idr_for_each(),
which is RCU-safe, and never modifies the nsid table.

rtnl_net_dumpid() can also do lockless lookups. It does two nested
idr_for_each() calls on nsid tables (one direct call and one indirect
call because of rtnl_net_dumpid_one() calling __peernet2id()). The
netnsid tables are never updated. Therefore it is safe to not take the
nsid_lock and run within an RCU-critical section instead.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/core/net_namespace.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 05e07d24b45b..e7a5ff4966c9 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -211,7 +211,7 @@ static int net_eq_idr(int id, void *net, void *peer)
 	return 0;
 }
 
-/* Should be called with nsid_lock held. */
+/* Must be called from RCU-critical section or with nsid_lock held */
 static int __peernet2id(const struct net *net, struct net *peer)
 {
 	int id = idr_for_each(&net->netns_ids, net_eq_idr, peer);
@@ -272,9 +272,10 @@ int peernet2id(struct net *net, struct net *peer)
 {
 	int id;
 
-	spin_lock_bh(&net->nsid_lock);
+	rcu_read_lock();
 	id = __peernet2id(net, peer);
-	spin_unlock_bh(&net->nsid_lock);
+	rcu_read_unlock();
+
 	return id;
 }
 EXPORT_SYMBOL(peernet2id);
@@ -941,6 +942,7 @@ struct rtnl_net_dump_cb {
 	int s_idx;
 };
 
+/* Runs in RCU-critical section. */
 static int rtnl_net_dumpid_one(int id, void *peer, void *data)
 {
 	struct rtnl_net_dump_cb *net_cb = (struct rtnl_net_dump_cb *)data;
@@ -1025,19 +1027,9 @@ static int rtnl_net_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 			goto end;
 	}
 
-	spin_lock_bh(&net_cb.tgt_net->nsid_lock);
-	if (net_cb.fillargs.add_ref &&
-	    !net_eq(net_cb.ref_net, net_cb.tgt_net) &&
-	    !spin_trylock_bh(&net_cb.ref_net->nsid_lock)) {
-		spin_unlock_bh(&net_cb.tgt_net->nsid_lock);
-		err = -EAGAIN;
-		goto end;
-	}
+	rcu_read_lock();
 	idr_for_each(&net_cb.tgt_net->netns_ids, rtnl_net_dumpid_one, &net_cb);
-	if (net_cb.fillargs.add_ref &&
-	    !net_eq(net_cb.ref_net, net_cb.tgt_net))
-		spin_unlock_bh(&net_cb.ref_net->nsid_lock);
-	spin_unlock_bh(&net_cb.tgt_net->nsid_lock);
+	rcu_read_unlock();
 
 	cb->args[0] = net_cb.idx;
 end:
-- 
2.21.1

