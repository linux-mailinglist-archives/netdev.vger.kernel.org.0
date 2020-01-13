Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEDB9139BC2
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 22:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgAMVje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 16:39:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22861 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726778AbgAMVja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 16:39:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578951570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GokqsxQySXClEUUtIjbogJ7HgVx0ZNQI/xTxE+WHQTY=;
        b=UqzksbOLWLN2QWsw52q03DZFEGGYb/qGw20jCCP4W5An0wywtN/Uls8Mat7JQpXe7YkFkD
        uk/lHxfVfNMJ9SgZuXvWQIatbRgctdQfWvfWnM/FfkFEKo13qfPrcpdU6N5IufM2FNWN4z
        1jL2dECEocMbZ6VtxKltFswIynvM0ok=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-zrgPJRavORKhiABwGm5fHw-1; Mon, 13 Jan 2020 16:39:27 -0500
X-MC-Unique: zrgPJRavORKhiABwGm5fHw-1
Received: by mail-wm1-f71.google.com with SMTP id o24so1587771wmh.0
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 13:39:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GokqsxQySXClEUUtIjbogJ7HgVx0ZNQI/xTxE+WHQTY=;
        b=fBrUfbm8TvCUXL3qqiehT8F2fPmxdWc4Dd8OAtA3M0DRA4y7icQjPLkurRfK98on8z
         gVjrNWr2eYkWXMwUtvibg6y5DIwtaqrF9E+4L9K+v3FzXd6mfER82PtkXO0CwAV/N8S4
         RRjFpe9/FBhAxCfCDY/GhNJrUU0OVuoGORZuCCWlXiZKILgoJCAAc3y2BQ9jNbNfXDVG
         QqA9IGbwNT3+SFEME3WvmLh++ZG6FL5OJsiNf9j49sH7C/lyejMk+JiR9QyotedEHyRz
         tpp76mx9K3Jo4MJ2lha+VJDKjW+h4BPeJqaGBgta1vl76UE62C8CfdnBXhs9ZL+UGxmZ
         4vjg==
X-Gm-Message-State: APjAAAW1dKR8eMbuhFZ3YlI0uU3Dcjy9Cu+LGPVJkTaciVPlH9TX0oAF
        nnV7ypXrql5cURnD+tfHFAG5YUrGwb9UIO3o6K9mXbyPyJRTe4DP/UIj4P3CnF04JIBGCnVRehx
        T4pb6GPuTuEWuStyE
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr21873525wmj.39.1578951566066;
        Mon, 13 Jan 2020 13:39:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqycwD6Zz2E61DDT5KdOMRy674i0jHQdlfd4ISfgbwWvcpkfTUgN+4vTP8HaZbb0YHZ5Q9Kjzg==
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr21873509wmj.39.1578951565884;
        Mon, 13 Jan 2020 13:39:25 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id v17sm16665980wrt.91.2020.01.13.13.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 13:39:25 -0800 (PST)
Date:   Mon, 13 Jan 2020 22:39:23 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 3/3] netns: don't disable BHs when locking
 "nsid_lock"
Message-ID: <7bd9e9800d8f1d5511608927baa1a5ab4d3072f5.1578950227.git.gnault@redhat.com>
References: <cover.1578950227.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1578950227.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When peernet2id() had to lock "nsid_lock" before iterating through the
nsid table, we had to disable BHs, because VXLAN can call peernet2id()
from the xmit path:
  vxlan_xmit() -> vxlan_fdb_miss() -> vxlan_fdb_notify()
    -> __vxlan_fdb_notify() -> vxlan_fdb_info() -> peernet2id().

Now that peernet2id() uses RCU protection, "nsid_lock" isn't used in BH
context anymore. Therefore, we can safely use plain
spin_lock()/spin_unlock() and let BHs run when holding "nsid_lock".

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/core/net_namespace.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index e7a5ff4966c9..6412c1fbfcb5 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -237,10 +237,10 @@ int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp)
 	if (refcount_read(&net->count) == 0)
 		return NETNSA_NSID_NOT_ASSIGNED;
 
-	spin_lock_bh(&net->nsid_lock);
+	spin_lock(&net->nsid_lock);
 	id = __peernet2id(net, peer);
 	if (id >= 0) {
-		spin_unlock_bh(&net->nsid_lock);
+		spin_unlock(&net->nsid_lock);
 		return id;
 	}
 
@@ -250,12 +250,12 @@ int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp)
 	 * just been idr_remove()'d from there in cleanup_net().
 	 */
 	if (!maybe_get_net(peer)) {
-		spin_unlock_bh(&net->nsid_lock);
+		spin_unlock(&net->nsid_lock);
 		return NETNSA_NSID_NOT_ASSIGNED;
 	}
 
 	id = alloc_netid(net, peer, -1);
-	spin_unlock_bh(&net->nsid_lock);
+	spin_unlock(&net->nsid_lock);
 
 	put_net(peer);
 	if (id < 0)
@@ -520,20 +520,20 @@ static void unhash_nsid(struct net *net, struct net *last)
 	for_each_net(tmp) {
 		int id;
 
-		spin_lock_bh(&tmp->nsid_lock);
+		spin_lock(&tmp->nsid_lock);
 		id = __peernet2id(tmp, net);
 		if (id >= 0)
 			idr_remove(&tmp->netns_ids, id);
-		spin_unlock_bh(&tmp->nsid_lock);
+		spin_unlock(&tmp->nsid_lock);
 		if (id >= 0)
 			rtnl_net_notifyid(tmp, RTM_DELNSID, id, 0, NULL,
 					  GFP_KERNEL);
 		if (tmp == last)
 			break;
 	}
-	spin_lock_bh(&net->nsid_lock);
+	spin_lock(&net->nsid_lock);
 	idr_destroy(&net->netns_ids);
-	spin_unlock_bh(&net->nsid_lock);
+	spin_unlock(&net->nsid_lock);
 }
 
 static LLIST_HEAD(cleanup_list);
@@ -746,9 +746,9 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return PTR_ERR(peer);
 	}
 
-	spin_lock_bh(&net->nsid_lock);
+	spin_lock(&net->nsid_lock);
 	if (__peernet2id(net, peer) >= 0) {
-		spin_unlock_bh(&net->nsid_lock);
+		spin_unlock(&net->nsid_lock);
 		err = -EEXIST;
 		NL_SET_BAD_ATTR(extack, nla);
 		NL_SET_ERR_MSG(extack,
@@ -757,7 +757,7 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	err = alloc_netid(net, peer, nsid);
-	spin_unlock_bh(&net->nsid_lock);
+	spin_unlock(&net->nsid_lock);
 	if (err >= 0) {
 		rtnl_net_notifyid(net, RTM_NEWNSID, err, NETLINK_CB(skb).portid,
 				  nlh, GFP_KERNEL);
-- 
2.21.1

