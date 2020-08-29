Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F20A256B8B
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 06:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgH3Elj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 00:41:39 -0400
Received: from mail-eopbgr60101.outbound.protection.outlook.com ([40.107.6.101]:6823
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726226AbgH3Elg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 00:41:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIuFamFQ06SENFRprrjUCzctTJPElrq3Jsuer9UaG4L6nzwnhx8vaa6jZ2cAZbZgw1Q1WP3N7ix0X5+tuTNeW9ERQ7gfoETz1BAJJhs3f3atB30arz1ASNj65ubqW25cO29WcXj78puBO9GZALlKC8G/Qdo8/kocpIIN8ds29hAM8lcEp1njV5R9XuCPsD294EifYMr++aBGyoHJAr+zZUpILVg7lbl3pzYqut9FJusYgp2vXO6Susld+iZ1ZfLB250srviLvklyMBZS3/zDShtWY+FC1a1Ssxh/uCNe9DcsZQSKyRR9/q/uTbRkRUO1j8hDTu4dxEjAfy0/UPYUvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzbFH+FMae0G20CT0ek7jXUQxthEO8y5esXNDNE+DZ4=;
 b=fYL1nGtLRdFjzkQ2FcBGljXAi4xDtclFYn3CgvSpIWx0PQO+iGEuR867E/vbAunQ9WClmb4xe4ouxOzLA2P/LAJygN/YjTJrk3eSDNy4I6zVveSDqAawDYpgPK7LlFzMYXprmdG+fczWRGh5hwF+RKdOAnc5A0mAhRoe+bkOtHcFFfEqA5wpwe2iI0oM+n9oIFmWR55KQZQaCLyBTB3iv3sIdJURfPDKzHivrov8JXgW+0NEqDrXj7X7aIBXWGGebDFCNMlat43R+cpQHw5XizOWBPoSqCQBPxu8Y14sOSNvhR8qkcR+nvIO9gX1o5jU5dxbwEwORIfEu3gJPNqVGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzbFH+FMae0G20CT0ek7jXUQxthEO8y5esXNDNE+DZ4=;
 b=C2uA5NOvGi6Vn9gM361PJ7ZU0WVYTo6+OGz7hO0LQHmB3Vp7B7v2dsDHYWlFNkynltHCKH4MRjAdy+aKMizVinXfU11B+ydSInhW4pZoKcYeX1d6qfsEcjeN3AGqL06SR8mekb02vxZjct1yWCQQ3SF2LLjK6YZp0R9iNlLe0S0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR05MB5105.eurprd05.prod.outlook.com (2603:10a6:208:f4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Sun, 30 Aug
 2020 04:41:12 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3326.025; Sun, 30 Aug 2020
 04:41:12 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 4/4] tipc: add automatic rekeying for encryption key
Date:   Sun, 30 Aug 2020 02:41:57 +0700
Message-Id: <20200829194157.10273-5-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200829194157.10273-1-tuong.t.lien@dektech.com.au>
References: <20200829194157.10273-1-tuong.t.lien@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0040.apcprd02.prod.outlook.com
 (2603:1096:3:18::28) To AM8PR05MB7332.eurprd05.prod.outlook.com
 (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR02CA0040.apcprd02.prod.outlook.com (2603:1096:3:18::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Sun, 30 Aug 2020 04:41:10 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f92f755d-4aca-4f76-bf34-08d84c9eec1e
X-MS-TrafficTypeDiagnostic: AM0PR05MB5105:
X-Microsoft-Antispam-PRVS: <AM0PR05MB51051542B8DA8055B4BF4654E2500@AM0PR05MB5105.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gLyACjZy8y7KzXM9nPfFaHdIGV0Islz0scQGlqhabgNbb/wEi+j8FN9Oq83Xcnmih1/cTdMXDBuGrTlI+ayIyrlFFHTTUeIzskcKdaF51LpUbyBriRjfZAkXZq/CiKG117DZTw2oS9/DOYSAlfFjXb7a+KV1j7ifLuefjTD0YTc369L4DpNN6uriQpE5R/8uvU+uUgFY0fUifyZ0Ty0vdyTj82UqlQ1idG0X99uan3WMoInmjvydSM8w6DHA8xAH1pydi4D2f3/SDz5UGH/63c2t/F0lwIMs/TuANIfSM4H+Mfld+hUTKCV4VToxHWBfxltpKGmew7A26ztBN9OnRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39830400003)(36756003)(86362001)(16526019)(2906002)(478600001)(26005)(186003)(6666004)(55016002)(316002)(66476007)(66556008)(66946007)(8936002)(8676002)(1076003)(956004)(2616005)(103116003)(5660300002)(52116002)(83380400001)(7696005)(30864003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kCpEltdIC6Rvv3DS8IZADFbOcMb3WhP78oCC13+JeK8Y1VQBFcIDUH5UEuR/xXIpTtCStvTSAWBsYP0oekoK3Xah1Qd0jHSK9SQMo3H4YgfrbcGdOjtCRK5NFGXHwsJXwzB7hAXqEFiIOuqOxlL5+JiIu2zMJeVfXX19Hb6kI3DSZnF0EMY2pr0hL9x3yyQZ4EaDtxbp9deF3XUVwb2jlxPqBI9jcQn2JGA/s8LYvKhgUsJg9OKlcrSaNxm9jy6Pigiqo3TYAjrpGLOVxEDhG+PYXFAPVGUMqN8iudWaLxzJJWzHR9sx38Jhikl2ncTC4V3c3ODVWK4hU05euW9a4eN2gZaLTIxv5+IEiA2OPofWxV0+Nmxu7GLJOfwticIH/M/sVpLD0ushI2sPNGdSQI4jl4bu2B81q1MFr9TzAVIC7Hq5aI5yFLMdwJh0DNmpKc69bP3eZr0MXfMahNox3AhQrrohga2Ba630ngQv/oAxWnUVQzeCGi2lXZpqmb45BKwiNYpzuBWOUR5bR1XzapSmeuI/Ys5PqOJuuYI0AVp5Q0DDNtuKFkP+MNRYcpFwQPV52xJkMNeQc+VfRZOBY6GEd3BWQbdY+foMEudIqz9Z5VKoH5gPxiewuL6BYGh8pEzkfig532pa5bUEeL0bNw==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: f92f755d-4aca-4f76-bf34-08d84c9eec1e
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2020 04:41:12.5943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmgU4UWSwRvx2zRI/KyKJwudHvYHGLFzUbE15iY1ePooDDtBoN31NcegO1ZOaYjMIlQ3URO40QWEbq7YobVjhW7gpAW4F3PuwykTttKABLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rekeying is required for security since a key is less secure when using
for a long time. Also, key will be detached when its nonce value (or
seqno ...) is exhausted. We now make the rekeying process automatic and
configurable by user.

Basically, TIPC will at a specific interval generate a new key by using
the kernel 'Random Number Generator' cipher, then attach it as the node
TX key and securely distribute to others in the cluster as RX keys (-
the key exchange). The automatic key switching will then take over, and
make the new key active shortly. Afterwards, the traffic from this node
will be encrypted with the new session key. The same can happen in peer
nodes but not necessarily at the same time.

For simplicity, the automatically generated key will be initiated as a
per node key. It is not too hard to also support a cluster key rekeying
(e.g. a given node will generate a unique cluster key and update to the
others in the cluster...), but that doesn't bring much benefit, while a
per-node key is even more secure.

We also enable user to force a rekeying or change the rekeying interval
via netlink, the new 'set key' command option: 'TIPC_NLA_NODE_REKEYING'
is added for these purposes as follows:
- A value >= 1 will be set as the rekeying interval (in minutes);
- A value of 0 will disable the rekeying;
- A value of 'TIPC_REKEYING_NOW' (~0) will force an immediate rekeying;

The default rekeying interval is (60 * 24) minutes i.e. done every day.
There isn't any restriction for the value but user shouldn't set it too
small or too large which results in an "ineffective" rekeying (thats ok
for testing though).

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 include/uapi/linux/tipc.h         |   2 +
 include/uapi/linux/tipc_netlink.h |   1 +
 net/tipc/crypto.c                 | 115 +++++++++++++++++++++++++++++-
 net/tipc/crypto.h                 |   2 +
 net/tipc/netlink.c                |   1 +
 net/tipc/node.c                   |  28 +++++++-
 6 files changed, 146 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/tipc.h b/include/uapi/linux/tipc.h
index add01db1daef..80ea15e12113 100644
--- a/include/uapi/linux/tipc.h
+++ b/include/uapi/linux/tipc.h
@@ -254,6 +254,8 @@ static inline int tipc_aead_key_size(struct tipc_aead_key *key)
 	return sizeof(*key) + key->keylen;
 }
 
+#define TIPC_REKEYING_NOW		(~0U)
+
 /* The macros and functions below are deprecated:
  */
 
diff --git a/include/uapi/linux/tipc_netlink.h b/include/uapi/linux/tipc_netlink.h
index d484baa9d365..d847dd671d79 100644
--- a/include/uapi/linux/tipc_netlink.h
+++ b/include/uapi/linux/tipc_netlink.h
@@ -166,6 +166,7 @@ enum {
 	TIPC_NLA_NODE_ID,		/* data */
 	TIPC_NLA_NODE_KEY,		/* data */
 	TIPC_NLA_NODE_KEY_MASTER,	/* flag */
+	TIPC_NLA_NODE_REKEYING,		/* u32 */
 
 	__TIPC_NLA_NODE_MAX,
 	TIPC_NLA_NODE_MAX = __TIPC_NLA_NODE_MAX - 1
diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index d29266a9d2ee..9d4ad832572f 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -36,6 +36,7 @@
 
 #include <crypto/aead.h>
 #include <crypto/aes.h>
+#include <crypto/rng.h>
 #include "crypto.h"
 #include "msg.h"
 #include "bcast.h"
@@ -48,6 +49,8 @@
 #define TIPC_MAX_TFMS_DEF	10
 #define TIPC_MAX_TFMS_LIM	1000
 
+#define TIPC_REKEYING_INTV_DEF	(60 * 24) /* default: 1 day */
+
 /**
  * TIPC Key ids
  */
@@ -181,6 +184,7 @@ struct tipc_crypto_stats {
  * @wq: common workqueue on TX crypto
  * @work: delayed work sched for TX/RX
  * @key_distr: key distributing state
+ * @rekeying_intv: rekeying interval (in minutes)
  * @stats: the crypto statistics
  * @name: the crypto name
  * @sndnxt: the per-peer sndnxt (TX)
@@ -206,6 +210,7 @@ struct tipc_crypto {
 #define KEY_DISTR_SCHED		1
 #define KEY_DISTR_COMPL		2
 	atomic_t key_distr;
+	u32 rekeying_intv;
 
 	struct tipc_crypto_stats __percpu *stats;
 	char name[48];
@@ -294,7 +299,9 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 static int tipc_crypto_key_xmit(struct net *net, struct tipc_aead_key *skey,
 				u16 gen, u8 mode, u32 dnode);
 static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr);
+static void tipc_crypto_work_tx(struct work_struct *work);
 static void tipc_crypto_work_rx(struct work_struct *work);
+static int tipc_aead_key_generate(struct tipc_aead_key *skey);
 
 #define is_tx(crypto) (!(crypto)->node)
 #define is_rx(crypto) (!is_tx(crypto))
@@ -342,6 +349,27 @@ int tipc_aead_key_validate(struct tipc_aead_key *ukey)
 	return 0;
 }
 
+/**
+ * tipc_aead_key_generate - Generate new session key
+ * @skey: input/output key with new content
+ *
+ * Return: 0 in case of success, otherwise < 0
+ */
+static int tipc_aead_key_generate(struct tipc_aead_key *skey)
+{
+	int rc = 0;
+
+	/* Fill the key's content with a random value via RNG cipher */
+	rc = crypto_get_default_rng();
+	if (likely(!rc)) {
+		rc = crypto_rng_get_bytes(crypto_default_rng, skey->key,
+					  skey->keylen);
+		crypto_put_default_rng();
+	}
+
+	return rc;
+}
+
 static struct tipc_aead *tipc_aead_get(struct tipc_aead __rcu *aead)
 {
 	struct tipc_aead *tmp;
@@ -1473,6 +1501,7 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	atomic64_set(&c->sndnxt, 0);
 	c->timer1 = jiffies;
 	c->timer2 = jiffies;
+	c->rekeying_intv = TIPC_REKEYING_INTV_DEF;
 	spin_lock_init(&c->lock);
 	scnprintf(c->name, 48, "%s(%s)", (is_rx(c)) ? "RX" : "TX",
 		  (is_rx(c)) ? tipc_node_get_id_str(c->node) :
@@ -1480,6 +1509,8 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 
 	if (is_rx(c))
 		INIT_DELAYED_WORK(&c->work, tipc_crypto_work_rx);
+	else
+		INIT_DELAYED_WORK(&c->work, tipc_crypto_work_tx);
 
 	*crypto = c;
 	return 0;
@@ -1494,8 +1525,11 @@ void tipc_crypto_stop(struct tipc_crypto **crypto)
 		return;
 
 	/* Flush any queued works & destroy wq */
-	if (is_tx(c))
+	if (is_tx(c)) {
+		c->rekeying_intv = 0;
+		cancel_delayed_work_sync(&c->work);
 		destroy_workqueue(c->wq);
+	}
 
 	/* Release AEAD keys */
 	rcu_read_lock();
@@ -2348,3 +2382,82 @@ static void tipc_crypto_work_rx(struct work_struct *work)
 
 	tipc_node_put(rx->node);
 }
+
+/**
+ * tipc_crypto_rekeying_sched - (Re)schedule rekeying w/o new interval
+ * @tx: TX crypto
+ * @changed: if the rekeying needs to be rescheduled with new interval
+ * @new_intv: new rekeying interval (when "changed" = true)
+ */
+void tipc_crypto_rekeying_sched(struct tipc_crypto *tx, bool changed,
+				u32 new_intv)
+{
+	unsigned long delay;
+	bool now = false;
+
+	if (changed) {
+		if (new_intv == TIPC_REKEYING_NOW)
+			now = true;
+		else
+			tx->rekeying_intv = new_intv;
+		cancel_delayed_work_sync(&tx->work);
+	}
+
+	if (tx->rekeying_intv || now) {
+		delay = (now) ? 0 : tx->rekeying_intv * 60 * 1000;
+		queue_delayed_work(tx->wq, &tx->work, msecs_to_jiffies(delay));
+	}
+}
+
+/**
+ * tipc_crypto_work_tx - Scheduled TX works handler
+ * @work: the struct TX work
+ *
+ * The function processes the previous scheduled work, i.e. key rekeying, by
+ * generating a new session key based on current one, then attaching it to the
+ * TX crypto and finally distributing it to peers. It also re-schedules the
+ * rekeying if needed.
+ */
+static void tipc_crypto_work_tx(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct tipc_crypto *tx = container_of(dwork, struct tipc_crypto, work);
+	struct tipc_aead_key *skey = NULL;
+	struct tipc_key key = tx->key;
+	struct tipc_aead *aead;
+	int rc = -ENOMEM;
+
+	if (unlikely(key.pending))
+		goto resched;
+
+	/* Take current key as a template */
+	rcu_read_lock();
+	aead = rcu_dereference(tx->aead[key.active ?: KEY_MASTER]);
+	if (unlikely(!aead)) {
+		rcu_read_unlock();
+		/* At least one key should exist for securing */
+		return;
+	}
+
+	/* Lets duplicate it first */
+	skey = kmemdup(aead->key, tipc_aead_key_size(aead->key), GFP_ATOMIC);
+	rcu_read_unlock();
+
+	/* Now, generate new key, initiate & distribute it */
+	if (likely(skey)) {
+		rc = tipc_aead_key_generate(skey) ?:
+		     tipc_crypto_key_init(tx, skey, PER_NODE_KEY, false);
+		if (likely(rc > 0))
+			rc = tipc_crypto_key_distr(tx, rc, NULL);
+		kzfree(skey);
+	}
+
+	if (likely(!rc))
+		pr_info("%s: rekeying has been done\n", tx->name);
+	else
+		pr_warn_ratelimited("%s: rekeying returns %d\n", tx->name, rc);
+
+resched:
+	/* Re-schedule rekeying if any */
+	tipc_crypto_rekeying_sched(tx, false, 0);
+}
diff --git a/net/tipc/crypto.h b/net/tipc/crypto.h
index 70bda3d7e174..e1f4e8fb5c10 100644
--- a/net/tipc/crypto.h
+++ b/net/tipc/crypto.h
@@ -171,6 +171,8 @@ void tipc_crypto_key_flush(struct tipc_crypto *c);
 int tipc_crypto_key_distr(struct tipc_crypto *tx, u8 key,
 			  struct tipc_node *dest);
 void tipc_crypto_msg_rcv(struct net *net, struct sk_buff *skb);
+void tipc_crypto_rekeying_sched(struct tipc_crypto *tx, bool changed,
+				u32 new_intv);
 int tipc_aead_key_validate(struct tipc_aead_key *ukey);
 bool tipc_ehdr_validate(struct sk_buff *skb);
 
diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index 1ec00fcc26ee..c447cb5f879e 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -109,6 +109,7 @@ const struct nla_policy tipc_nl_node_policy[TIPC_NLA_NODE_MAX + 1] = {
 	[TIPC_NLA_NODE_KEY]		= { .type = NLA_BINARY,
 					    .len = TIPC_AEAD_KEY_SIZE_MAX},
 	[TIPC_NLA_NODE_KEY_MASTER]	= { .type = NLA_FLAG },
+	[TIPC_NLA_NODE_REKEYING]	= { .type = NLA_U32 },
 };
 
 /* Properties valid for media, bearer and link */
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 4f822a5d82d8..c981ef2ad410 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2877,6 +2877,17 @@ static int tipc_nl_retrieve_nodeid(struct nlattr **attrs, u8 **node_id)
 	return 0;
 }
 
+static int tipc_nl_retrieve_rekeying(struct nlattr **attrs, u32 *intv)
+{
+	struct nlattr *attr = attrs[TIPC_NLA_NODE_REKEYING];
+
+	if (!attr)
+		return -ENODATA;
+
+	*intv = nla_get_u32(attr);
+	return 0;
+}
+
 static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attrs[TIPC_NLA_NODE_MAX + 1];
@@ -2884,8 +2895,9 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 	struct tipc_crypto *tx = tipc_net(net)->crypto_tx, *c = tx;
 	struct tipc_node *n = NULL;
 	struct tipc_aead_key *ukey;
-	bool master_key = false;
+	bool rekeying = true, master_key = false;
 	u8 *id, *own_id, mode;
+	u32 intv = 0;
 	int rc = 0;
 
 	if (!info->attrs[TIPC_NLA_NODE])
@@ -2901,9 +2913,17 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 	if (!own_id)
 		return -EPERM;
 
+	rc = tipc_nl_retrieve_rekeying(attrs, &intv);
+	if (rc == -ENODATA)
+		rekeying = false;
+
 	rc = tipc_nl_retrieve_key(attrs, &ukey);
-	if (rc)
+	if (rc == -ENODATA && rekeying) {
+		rc = 0;
+		goto rekeying;
+	} else if (rc) {
 		return rc;
+	}
 
 	rc = tipc_aead_key_validate(ukey);
 	if (rc)
@@ -2938,6 +2958,10 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 	if (!master_key)
 		tipc_crypto_key_distr(tx, rc, NULL);
 
+rekeying:
+	/* Schedule TX rekeying if needed */
+	tipc_crypto_rekeying_sched(tx, rekeying, intv);
+
 exit:
 	if (n)
 		tipc_node_put(n);
-- 
2.26.2

