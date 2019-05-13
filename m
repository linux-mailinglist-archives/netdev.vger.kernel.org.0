Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48B51BA8F
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbfEMQEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:04:21 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43914 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbfEMQEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:04:20 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so18305213edb.10
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 09:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=snqBFnriVbm8W8k7NApKboEBr7CW/Swoidh2GaajigQ=;
        b=QU3AGAOj5nZloxyDbnf9PFh9wlFFv8Mxca2CdK/fJtelZskmeJc44Fioz74UR9/1N1
         MALEnI2ccq+0SCaYDAVZmHb2ynOxvz3Z1xL7w3wbaEh6orv3SP+Egx11yW1Ejsq02SEO
         FX0s4EbfEMSRzY7LhEXmq9H1ReUYMpyrduIdrmTWt6loaclsL9eOVRWikKQdnWWDZg+a
         ks7WPdKdOgoLfM53gBEBkkibCkDB3eWA4zgsMwcojKvHtuyDMQrMT5UNF3dRvNJKH94g
         6t3dKNoGSzFNa5aUf5OEA+a6R9tHkPTXFXp4otuCg9qBMf5dV0KuCfTFlMSt3aB5R8JK
         FUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=snqBFnriVbm8W8k7NApKboEBr7CW/Swoidh2GaajigQ=;
        b=qZnGmYEEXudp7/bYXfqOrTi4uJP2nUOGnhURume0VOuaZDqjAtpuQ6+mO9Z5Q3MxCe
         aVLWst+AJ/rmqiHIrc2jOJRaau0+OkD2XZKAuMx2tbJqZsw4StlZ2SbeP+nq+Pu5E/Me
         FDwR5HRhTM6fTBslQWC/1THJFWgyOJkbtTMW476JlYA16F5lxBG1MLTt9dSJYidsNjfy
         olN4LekM2TGunaH5O56uBUcITuzjIltUgswCCDdqDO07C3BmmJnBsYEwCHwzvXAuSKrb
         3CvejZLRAvEn08S4+G0YA7WKZjk1ijopJekf8K6UEWzOz5PkPwi/8D/Ma3cF10VnVp8j
         ttaQ==
X-Gm-Message-State: APjAAAUiIGR1UrEcocJP/1Mi7oL9LzDSfPoKkUg+qNMgqQ+oAeNwsaG3
        IIJiyBtBVR/SaYZYUwEjQoNDZg==
X-Google-Smtp-Source: APXvYqzPY9FDAzI9mGKP/oPtH04uRI9fflJRlYDeLepRgrsMBe4xAQEQ+DdqicJO54HpWZDIVsnNrQ==
X-Received: by 2002:a50:a886:: with SMTP id k6mr30253386edc.211.1557763457792;
        Mon, 13 May 2019 09:04:17 -0700 (PDT)
Received: from ben.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k18sm3825581eda.92.2019.05.13.09.04.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 13 May 2019 09:04:17 -0700 (PDT)
From:   mcmahon@arista.com
To:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        christian@brauner.io, khlebnikov@yandex-team.ru,
        lzgrablic@arista.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mowat@arista.com, dmia@arista.com
Cc:     Ben McMahon <mcmahon@arista.com>
Subject: getneigh: add nondump to retrieve single entry
Date:   Mon, 13 May 2019 17:03:35 +0100
Message-Id: <20190513160335.24128-1-mcmahon@arista.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <mcmahon@arista.com>
References: <mcmahon@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leonard Zgrablic <lzgrablic@arista.com>

Currently there is only a dump version of RTM_GETNEIGH for PF_UNSPEC in
RTNETLINK that dumps neighbor entries, no non-dump version that can be used to
retrieve a single neighbor entry.

Add support for the non-dump (doit) version of RTM_GETNEIGH for PF_UNSPEC so
that a single neighbor entry can be retrieved.

Signed-off-by: Leonard Zgrablic <lzgrablic@arista.com>
Signed-off-by: Ben McMahon <mcmahon@arista.com>
---
 net/core/neighbour.c | 160 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 147 insertions(+), 13 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 30f6fd8f68e0..981f1568710b 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2733,6 +2733,149 @@ static int neigh_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static inline size_t neigh_nlmsg_size(void)
+{
+		return NLMSG_ALIGN(sizeof(struct ndmsg))
+			+ nla_total_size(MAX_ADDR_LEN) /* NDA_DST */
+			+ nla_total_size(MAX_ADDR_LEN) /* NDA_LLADDR */
+			+ nla_total_size(sizeof(struct nda_cacheinfo))
+			+ nla_total_size(4); /* NDA_PROBES */
+}
+
+static int neigh_find_fill(struct neigh_table *tbl, const void *pkey,
+                           struct net_device *dev, struct sk_buff *skb, u32 pid,
+                           u32 seq)
+{
+	struct neighbour *neigh;
+	int key_len = tbl->key_len;
+	u32 hash_val;
+	struct neigh_hash_table *nht;
+	int err;
+	
+	if (dev == NULL)
+		return -EINVAL;
+	
+	NEIGH_CACHE_STAT_INC(tbl, lookups);
+
+	rcu_read_lock_bh();
+   nht = rcu_dereference_bh(tbl->nht);
+	hash_val = tbl->hash(pkey, dev, nht->hash_rnd) >>
+		(32 - nht->hash_shift);
+
+	for (neigh = rcu_dereference_bh(nht->hash_buckets[hash_val]);
+		neigh != NULL;
+		neigh = rcu_dereference_bh(neigh->next)) {
+		if (dev == neigh->dev &&
+			!memcmp(neigh->primary_key, pkey, key_len)) {
+				if (!atomic_read(&neigh->refcnt))
+					neigh = NULL;
+				NEIGH_CACHE_STAT_INC(tbl, hits);
+				break;
+		}
+	}
+	if (neigh == NULL) {
+		err = -ENOENT;
+		goto out_rcu_read_unlock;
+	}
+
+	err = neigh_fill_info(skb, neigh, pid, seq, RTM_NEWNEIGH, 0);
+
+out_rcu_read_unlock:
+	rcu_read_unlock_bh();
+	return err;
+}
+
+static int pneigh_find_fill(struct neigh_table *tbl, const void *pkey,
+			struct net_device *dev, struct net *net,
+			struct sk_buff *skb, u32 pid, u32 seq)
+{
+	struct pneigh_entry *pneigh;
+	int key_len = tbl->key_len;
+	u32 hash_val = pneigh_hash(pkey, key_len);
+	int err;
+
+	read_lock_bh(&tbl->lock);
+
+	pneigh = __pneigh_lookup_1(tbl->phash_buckets[hash_val], net, pkey,
+                                   key_len, dev);
+	if (pneigh == NULL) {
+		err = -ENOENT;
+		goto out_read_unlock;
+	}
+
+	err = pneigh_fill_info(skb, pneigh, pid, seq, RTM_NEWNEIGH, 0, tbl);
+
+out_read_unlock:
+	read_unlock_bh(&tbl->lock);
+	return err;
+}
+
+static int neigh_get(struct sk_buff *skb, struct nlmsghdr *nlh)
+{
+	struct net *net = sock_net(skb->sk);
+	struct ndmsg *ndm;
+	struct nlattr *dst_attr;
+	struct neigh_table *tbl;
+	struct net_device *dev = NULL;
+
+	ASSERT_RTNL();
+	if (nlmsg_len(nlh) < sizeof(*ndm))
+		return -EINVAL;
+
+	dst_attr = nlmsg_find_attr(nlh, sizeof(*ndm), NDA_DST);
+	if (dst_attr == NULL)
+		return -EINVAL;
+
+	ndm = nlmsg_data(nlh);
+	if (ndm->ndm_ifindex) {
+		dev = __dev_get_by_index(net, ndm->ndm_ifindex);
+		if (dev == NULL)
+			return -ENODEV;
+	}
+
+	read_lock(&neigh_tbl_lock);
+	for (tbl = neigh_tables; tbl; tbl = tbl->next) {
+		struct sk_buff *nskb;
+		int err;
+
+		if (tbl->family != ndm->ndm_family)
+			continue;
+
+		read_unlock(&neigh_tbl_lock);
+
+		if (nla_len(dst_attr) < tbl->key_len)
+			return -EINVAL;
+
+		nskb = nlmsg_new(neigh_nlmsg_size(), GFP_KERNEL);
+		if (nskb == NULL)
+			return -ENOBUFS;
+
+		if (ndm->ndm_flags & NTF_PROXY)
+			err = pneigh_find_fill(tbl, nla_data(dst_attr), dev,
+				net, nskb,
+				NETLINK_CB(skb).portid,
+				nlh->nlmsg_seq);
+		else
+			err = neigh_find_fill(tbl, nla_data(dst_attr), dev,
+				nskb, NETLINK_CB(skb).portid,
+				nlh->nlmsg_seq);
+
+		if (err < 0) {
+			/* -EMSGSIZE implies BUG in neigh_nlmsg_size */
+			WARN_ON(err == -EMSGSIZE);
+			kfree_skb(nskb);
+		} else {
+			err = rtnl_unicast(nskb, net, NETLINK_CB(skb).portid);
+		}
+
+		return err;
+	}
+	read_unlock(&neigh_tbl_lock);
+	return -EAFNOSUPPORT;
+}
+
+
+
 static int neigh_valid_get_req(const struct nlmsghdr *nlh,
 			       struct neigh_table **tbl,
 			       void **dst, int *dev_idx, u8 *ndm_flags,
@@ -2793,16 +2936,6 @@ static int neigh_valid_get_req(const struct nlmsghdr *nlh,
 	return 0;
 }
 
-static inline size_t neigh_nlmsg_size(void)
-{
-	return NLMSG_ALIGN(sizeof(struct ndmsg))
-	       + nla_total_size(MAX_ADDR_LEN) /* NDA_DST */
-	       + nla_total_size(MAX_ADDR_LEN) /* NDA_LLADDR */
-	       + nla_total_size(sizeof(struct nda_cacheinfo))
-	       + nla_total_size(4)  /* NDA_PROBES */
-	       + nla_total_size(1); /* NDA_PROTOCOL */
-}
-
 static int neigh_get_reply(struct net *net, struct neighbour *neigh,
 			   u32 pid, u32 seq)
 {
@@ -2827,8 +2960,8 @@ static int neigh_get_reply(struct net *net, struct neighbour *neigh,
 static inline size_t pneigh_nlmsg_size(void)
 {
 	return NLMSG_ALIGN(sizeof(struct ndmsg))
-	       + nla_total_size(MAX_ADDR_LEN) /* NDA_DST */
-	       + nla_total_size(1); /* NDA_PROTOCOL */
+		+ nla_total_size(MAX_ADDR_LEN) /* NDA_DST */
+		+ nla_total_size(1); /* NDA_PROTOCOL */
 }
 
 static int pneigh_get_reply(struct net *net, struct pneigh_entry *neigh,
@@ -3703,7 +3836,8 @@ static int __init neigh_init(void)
 {
 	rtnl_register(PF_UNSPEC, RTM_NEWNEIGH, neigh_add, NULL, 0);
 	rtnl_register(PF_UNSPEC, RTM_DELNEIGH, neigh_delete, NULL, 0);
-	rtnl_register(PF_UNSPEC, RTM_GETNEIGH, neigh_get, neigh_dump_info, 0);
+	rtnl_register(PF_UNSPEC, RTM_GETNEIGH, neigh_get, neigh_dump_info, 
+		NULL);
 
 	rtnl_register(PF_UNSPEC, RTM_GETNEIGHTBL, NULL, neightbl_dump_info,
 		      0);
-- 
2.21.0

