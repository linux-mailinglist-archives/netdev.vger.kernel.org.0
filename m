Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AA7428CCB
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 14:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhJKMOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 08:14:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:36950 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhJKMOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 08:14:47 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mZuAh-000Ee7-3S; Mon, 11 Oct 2021 14:12:47 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next 3/4] net, neigh: Extend neigh->flags to 32 bit to allow for extensions
Date:   Mon, 11 Oct 2021 14:12:37 +0200
Message-Id: <20211011121238.25542-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211011121238.25542-1-daniel@iogearbox.net>
References: <20211011121238.25542-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26319/Mon Oct 11 10:18:47 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@nvidia.com>

Currently, all bits in struct ndmsg's ndm_flags are used up with the most
recent addition of 435f2e7cc0b7 ("net: bridge: add support for sticky fdb
entries"). This makes it impossible to extend the neighboring subsystem
with new NTF_* flags:

  struct ndmsg {
    __u8   ndm_family;
    __u8   ndm_pad1;
    __u16  ndm_pad2;
    __s32  ndm_ifindex;
    __u16  ndm_state;
    __u8   ndm_flags;
    __u8   ndm_type;
  };

There are ndm_pad{1,2} attributes which are not used. However, due to
uncareful design, the kernel does not enforce them to be zero upon new
neighbor entry addition, and given they've been around forever, it is
not possible to reuse them today due to risk of breakage. One option to
overcome this limitation is to add a new NDA_FLAGS_EXT attribute for
extended flags.

In struct neighbour, there is a 3 byte hole between protocol and ha_lock,
which allows neigh->flags to be extended from 8 to 32 bits while still
being on the same cacheline as before. This also allows for all future
NTF_* flags being in neigh->flags rather than yet another flags field.
Unknown flags in NDA_FLAGS_EXT will be rejected by the kernel.

Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 include/net/neighbour.h        | 14 +++++----
 include/uapi/linux/neighbour.h |  1 +
 net/core/neighbour.c           | 55 ++++++++++++++++++++++++----------
 3 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index eb2a7c03a5b0..26d4ada0aea9 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -144,11 +144,11 @@ struct neighbour {
 	struct timer_list	timer;
 	unsigned long		used;
 	atomic_t		probes;
-	__u8			flags;
-	__u8			nud_state;
-	__u8			type;
-	__u8			dead;
+	u8			nud_state;
+	u8			type;
+	u8			dead;
 	u8			protocol;
+	u32			flags;
 	seqlock_t		ha_lock;
 	unsigned char		ha[ALIGN(MAX_ADDR_LEN, sizeof(unsigned long))] __aligned(8);
 	struct hh_cache		hh;
@@ -172,7 +172,7 @@ struct pneigh_entry {
 	struct pneigh_entry	*next;
 	possible_net_t		net;
 	struct net_device	*dev;
-	u8			flags;
+	u32			flags;
 	u8			protocol;
 	u8			key[];
 };
@@ -258,6 +258,10 @@ static inline void *neighbour_priv(const struct neighbour *n)
 #define NEIGH_UPDATE_F_ISROUTER			0x40000000
 #define NEIGH_UPDATE_F_ADMIN			0x80000000
 
+/* In-kernel representation for NDA_FLAGS_EXT flags: */
+#define NTF_OLD_MASK		0xff
+#define NTF_EXT_SHIFT		8
+
 extern const struct nla_policy nda_policy[];
 
 static inline bool neigh_key_eq16(const struct neighbour *n, const void *pkey)
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 00a60695fa53..a80cca141855 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -31,6 +31,7 @@ enum {
 	NDA_PROTOCOL,  /* Originator of entry */
 	NDA_NH_ID,
 	NDA_FDB_EXT_ATTRS,
+	NDA_FLAGS_EXT,
 	__NDA_MAX
 };
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 3e58037a8ae6..5245e888c981 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -159,7 +159,7 @@ static bool neigh_update_ext_learned(struct neighbour *neigh, u32 flags,
 				     int *notify)
 {
 	bool rc = false;
-	u8 ndm_flags;
+	u32 ndm_flags;
 
 	if (!(flags & NEIGH_UPDATE_F_ADMIN))
 		return rc;
@@ -379,7 +379,7 @@ EXPORT_SYMBOL(neigh_ifdown);
 
 static struct neighbour *neigh_alloc(struct neigh_table *tbl,
 				     struct net_device *dev,
-				     u8 flags, bool exempt_from_gc)
+				     u32 flags, bool exempt_from_gc)
 {
 	struct neighbour *n = NULL;
 	unsigned long now = jiffies;
@@ -578,7 +578,7 @@ EXPORT_SYMBOL(neigh_lookup_nodev);
 
 static struct neighbour *
 ___neigh_create(struct neigh_table *tbl, const void *pkey,
-		struct net_device *dev, u8 flags,
+		struct net_device *dev, u32 flags,
 		bool exempt_from_gc, bool want_ref)
 {
 	u32 hash_val, key_len = tbl->key_len;
@@ -1789,6 +1789,7 @@ const struct nla_policy nda_policy[NDA_MAX+1] = {
 	[NDA_MASTER]		= { .type = NLA_U32 },
 	[NDA_PROTOCOL]		= { .type = NLA_U8 },
 	[NDA_NH_ID]		= { .type = NLA_U32 },
+	[NDA_FLAGS_EXT]		= { .type = NLA_U32 },
 	[NDA_FDB_EXT_ATTRS]	= { .type = NLA_NESTED },
 };
 
@@ -1861,7 +1862,7 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		     struct netlink_ext_ack *extack)
 {
 	int flags = NEIGH_UPDATE_F_ADMIN | NEIGH_UPDATE_F_OVERRIDE |
-		NEIGH_UPDATE_F_OVERRIDE_ISROUTER;
+		    NEIGH_UPDATE_F_OVERRIDE_ISROUTER;
 	struct net *net = sock_net(skb->sk);
 	struct ndmsg *ndm;
 	struct nlattr *tb[NDA_MAX+1];
@@ -1870,6 +1871,7 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct neighbour *neigh;
 	void *dst, *lladdr;
 	u8 protocol = 0;
+	u32 ndm_flags;
 	int err;
 
 	ASSERT_RTNL();
@@ -1885,6 +1887,16 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	ndm = nlmsg_data(nlh);
+	ndm_flags = ndm->ndm_flags;
+	if (tb[NDA_FLAGS_EXT]) {
+		u32 ext = nla_get_u32(tb[NDA_FLAGS_EXT]);
+
+		if (ext & ~0) {
+			NL_SET_ERR_MSG(extack, "Invalid extended flags");
+			goto out;
+		}
+		ndm_flags |= (ext << NTF_EXT_SHIFT);
+	}
 	if (ndm->ndm_ifindex) {
 		dev = __dev_get_by_index(net, ndm->ndm_ifindex);
 		if (dev == NULL) {
@@ -1912,14 +1924,13 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (tb[NDA_PROTOCOL])
 		protocol = nla_get_u8(tb[NDA_PROTOCOL]);
-
-	if (ndm->ndm_flags & NTF_PROXY) {
+	if (ndm_flags & NTF_PROXY) {
 		struct pneigh_entry *pn;
 
 		err = -ENOBUFS;
 		pn = pneigh_lookup(tbl, net, dst, dev, 1);
 		if (pn) {
-			pn->flags = ndm->ndm_flags;
+			pn->flags = ndm_flags;
 			if (protocol)
 				pn->protocol = protocol;
 			err = 0;
@@ -1947,9 +1958,9 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 
 		exempt_from_gc = ndm->ndm_state & NUD_PERMANENT ||
-				 ndm->ndm_flags & NTF_EXT_LEARNED;
+				 ndm_flags & NTF_EXT_LEARNED;
 		neigh = ___neigh_create(tbl, dst, dev,
-					ndm->ndm_flags & NTF_EXT_LEARNED,
+					ndm_flags & NTF_EXT_LEARNED,
 					exempt_from_gc, true);
 		if (IS_ERR(neigh)) {
 			err = PTR_ERR(neigh);
@@ -1969,16 +1980,16 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (protocol)
 		neigh->protocol = protocol;
-	if (ndm->ndm_flags & NTF_EXT_LEARNED)
+	if (ndm_flags & NTF_EXT_LEARNED)
 		flags |= NEIGH_UPDATE_F_EXT_LEARNED;
-	if (ndm->ndm_flags & NTF_ROUTER)
+	if (ndm_flags & NTF_ROUTER)
 		flags |= NEIGH_UPDATE_F_ISROUTER;
-	if (ndm->ndm_flags & NTF_USE)
+	if (ndm_flags & NTF_USE)
 		flags |= NEIGH_UPDATE_F_USE;
 
 	err = __neigh_update(neigh, lladdr, ndm->ndm_state, flags,
 			     NETLINK_CB(skb).portid, extack);
-	if (!err && ndm->ndm_flags & NTF_USE) {
+	if (!err && ndm_flags & NTF_USE) {
 		neigh_event_send(neigh, NULL);
 		err = 0;
 	}
@@ -2433,6 +2444,7 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 static int neigh_fill_info(struct sk_buff *skb, struct neighbour *neigh,
 			   u32 pid, u32 seq, int type, unsigned int flags)
 {
+	u32 neigh_flags, neigh_flags_ext;
 	unsigned long now = jiffies;
 	struct nda_cacheinfo ci;
 	struct nlmsghdr *nlh;
@@ -2442,11 +2454,14 @@ static int neigh_fill_info(struct sk_buff *skb, struct neighbour *neigh,
 	if (nlh == NULL)
 		return -EMSGSIZE;
 
+	neigh_flags_ext = neigh->flags >> NTF_EXT_SHIFT;
+	neigh_flags     = neigh->flags & NTF_OLD_MASK;
+
 	ndm = nlmsg_data(nlh);
 	ndm->ndm_family	 = neigh->ops->family;
 	ndm->ndm_pad1    = 0;
 	ndm->ndm_pad2    = 0;
-	ndm->ndm_flags	 = neigh->flags;
+	ndm->ndm_flags	 = neigh_flags;
 	ndm->ndm_type	 = neigh->type;
 	ndm->ndm_ifindex = neigh->dev->ifindex;
 
@@ -2477,6 +2492,8 @@ static int neigh_fill_info(struct sk_buff *skb, struct neighbour *neigh,
 
 	if (neigh->protocol && nla_put_u8(skb, NDA_PROTOCOL, neigh->protocol))
 		goto nla_put_failure;
+	if (neigh_flags_ext && nla_put_u32(skb, NDA_FLAGS_EXT, neigh_flags_ext))
+		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
 	return 0;
@@ -2490,6 +2507,7 @@ static int pneigh_fill_info(struct sk_buff *skb, struct pneigh_entry *pn,
 			    u32 pid, u32 seq, int type, unsigned int flags,
 			    struct neigh_table *tbl)
 {
+	u32 neigh_flags, neigh_flags_ext;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
 
@@ -2497,11 +2515,14 @@ static int pneigh_fill_info(struct sk_buff *skb, struct pneigh_entry *pn,
 	if (nlh == NULL)
 		return -EMSGSIZE;
 
+	neigh_flags_ext = pn->flags >> NTF_EXT_SHIFT;
+	neigh_flags     = pn->flags & NTF_OLD_MASK;
+
 	ndm = nlmsg_data(nlh);
 	ndm->ndm_family	 = tbl->family;
 	ndm->ndm_pad1    = 0;
 	ndm->ndm_pad2    = 0;
-	ndm->ndm_flags	 = pn->flags | NTF_PROXY;
+	ndm->ndm_flags	 = neigh_flags | NTF_PROXY;
 	ndm->ndm_type	 = RTN_UNICAST;
 	ndm->ndm_ifindex = pn->dev ? pn->dev->ifindex : 0;
 	ndm->ndm_state	 = NUD_NONE;
@@ -2511,6 +2532,8 @@ static int pneigh_fill_info(struct sk_buff *skb, struct pneigh_entry *pn,
 
 	if (pn->protocol && nla_put_u8(skb, NDA_PROTOCOL, pn->protocol))
 		goto nla_put_failure;
+	if (neigh_flags_ext && nla_put_u32(skb, NDA_FLAGS_EXT, neigh_flags_ext))
+		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
 	return 0;
@@ -2826,6 +2849,7 @@ static inline size_t neigh_nlmsg_size(void)
 	       + nla_total_size(MAX_ADDR_LEN) /* NDA_LLADDR */
 	       + nla_total_size(sizeof(struct nda_cacheinfo))
 	       + nla_total_size(4)  /* NDA_PROBES */
+	       + nla_total_size(4)  /* NDA_FLAGS_EXT */
 	       + nla_total_size(1); /* NDA_PROTOCOL */
 }
 
@@ -2854,6 +2878,7 @@ static inline size_t pneigh_nlmsg_size(void)
 {
 	return NLMSG_ALIGN(sizeof(struct ndmsg))
 	       + nla_total_size(MAX_ADDR_LEN) /* NDA_DST */
+	       + nla_total_size(4)  /* NDA_FLAGS_EXT */
 	       + nla_total_size(1); /* NDA_PROTOCOL */
 }
 
-- 
2.27.0

