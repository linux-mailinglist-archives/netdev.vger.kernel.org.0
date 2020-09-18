Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27B52702D3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgIRRD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:03:59 -0400
Received: from mail-db8eur05on2126.outbound.protection.outlook.com ([40.107.20.126]:49377
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726273AbgIRRD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:03:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4hL64OfMEtLNr2fkwB6+5+TXftRSJab+qtzoZANImgPZO7SwRRLyQSkkXS16ny0Z1qT/XLyZte1Dt2sBSP6rOs//NhN4yH18y7wjRa1/SHVqWDYnIx9JA8TP4C9+eyJPUUQza03XCRqd9EAsFCjIuvlNSmorWVO1N58GAcSo4E8u2u40b8eK0cJLL8Azuvrjho9uKc3CFKBIPqwK0vXrDWLkuRbEL3f09I1gIHQXT0VzYR+yJqUVWrzoQHnU5K8rHKQUADKgH7cC93bHmpwOZ3+UYQPzLlYYCuwWOaPXVUxUYnRYi81IlNWW8Q/YBHmMywFpH2qWvj1+fA7Zdz9sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cfi1QNdouopUfAtICYh36Q3iIJ6ajHxtoLOtyZem7k=;
 b=VdP7lDhNtMjhI1PCkp97yYgcJmJprWfNCjRClpn8a3KzqXHMY9WVTieH61xoL5NacDD5O64H3/jiQ36mNjZWFlq+VaVJkj0+JT3yXHGbh3KnTgyhR8ZPKhYEV3d5ySnsVFqnQiDJhMVbbzEBRuJu8OHKlsOX0L3ki7uSRkxBeFTTIe75g3JdVUWM0k9zpN6Ir4Je6BJhfpLl0TfYezc14irUCS9ATwZwcfc/MB5xUZEflwanhqquPFiH5OKxXjMWexb48CAwkfNdEPIUyJBBltalN4dcdv7sM6/0ohSsguxs+8O46fsuLukzj7kjn2c9HFbpjFhWqZfqq8CMDdJfyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cfi1QNdouopUfAtICYh36Q3iIJ6ajHxtoLOtyZem7k=;
 b=DwAImNjs27o1r96nMrJJLHNN4WeY36rH8iNoqX0MO1kGDSMZ9VXYGHSWduE8PqMaycoYbaZVg5jxyQzeSUAoTFp3PXdslfzpHqLNeXXz4x47IlFKIAnf7X30MtJc58w74kqLFy6P0Nhu1RsrzLIJLThg0d8YbaIFPdoYBiAEcgA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR0502MB3827.eurprd05.prod.outlook.com (2603:10a6:208:1a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Fri, 18 Sep
 2020 17:03:08 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3391.015; Fri, 18 Sep 2020
 17:03:08 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next v3 4/4] tipc: add automatic rekeying for encryption key
Date:   Fri, 18 Sep 2020 08:17:29 +0700
Message-Id: <20200918011729.30146-5-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
References: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26)
 To AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Fri, 18 Sep 2020 17:03:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [113.20.114.51]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9845330-357b-405c-b0d2-08d85bf4b79f
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3827:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3827A36F766785AE33CC76CFE23F0@AM0PR0502MB3827.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/KOyxRBtNDOjeXEDGPweboT2RsFbf/2vibHvgmoOlDLloe4Nij0yTjsp2Qo8X3U6hvVNXRN1eOLCO8m35PdLD9ATsu2EPuKtA4/hCavNtX0cbpW5ycHF7Elrl823Wz172MbU0JNQHApJQw8nVMB45GiB2qjZsSPQjdi51ComlaikR8t15/p9hkPpojTpielXQJgFfa0gQ/bZxY6NSywngc/wXRS5pzLC09jT1hPmeansd0H21KcmHiTj8GKYlNLC1+IKFeh0zn+75lqpa+jgCmDyFATIGcvDeEipgtc786jlXQ8SBdXcGBmqcna9yk072rwdNKRoz3o3gQTXc6WKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(346002)(376002)(366004)(396003)(2906002)(103116003)(36756003)(7696005)(55016002)(26005)(4326008)(8936002)(52116002)(316002)(16526019)(956004)(478600001)(186003)(83380400001)(2616005)(1076003)(86362001)(6666004)(66946007)(30864003)(66556008)(8676002)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 1JeSSdsq1/g5vbJdLSBrYAQQ7gS6tEhHMWrA1IEWvn3v7W4cTDyiSiq3uIplaYDAUWD+/vlJSYdpqlj3bNfIOx/HyEe8PhUGdbncWDjzKQrHmF0XuncyFtfqjK62xfIJRVRC3CHRu+1Wab7L5qW74PmiWh+01xSVQ+k/Q9zdq0voA2NVtiOBrM8sbJp6fY7V0UWTVs7J9ZTGwspv50Evgsn08S+Z6F7RNtK2v+IJT0Wh5qMPU4Pi5EbQTwDlUhCAAozd5lXPwTV21n5OvV8st9mGGsbrbxoQ4e79Gg+0GhDxRCqJqzKL9sgZMS2kaIVWbNnKYrwc3cg2Y0FjwV911KS+9uffx0w0VMNpbzrf7lV/vqd9TQSAQvMXqU+8r9mDnfaRlIHjVgs8bjadFIs9fWDZQAjM1/DXknUGPGt+hQE+nxzNi6hKG1S333UotFcWlKjRMt17Qej5or4xY//3Fp6MNKOiPRhFJBNNDmS1jcINCbs98sBjHidG3b1Tk6fStfYT5vkfH6lKfNLEqyw5EXINX35rgj20UHFXnjOl1uS2svBY4/XmmV8cUPYahz44dArazUobwUGUmBAy6kHGJT7MZJvYb2WSzZAMQ93c/uIKe6wOtO0Cg/QIkhxoG1gHMcLln/KvEQGE3VL8SpUzfg==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: d9845330-357b-405c-b0d2-08d85bf4b79f
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 17:03:08.6407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JE/U4JWrgtpq3QzW55nbHUKlCJ6UbrjGkN0Gx9JgwoDRXHJn+Uu8RsRFqLc4VYUGOy53mvItAq87X92AFExNqNvIA/iS06oOXpytpJkapWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3827
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
 net/tipc/crypto.c                 | 113 +++++++++++++++++++++++++++++-
 net/tipc/crypto.h                 |   2 +
 net/tipc/netlink.c                |   1 +
 net/tipc/node.c                   |  25 ++++++-
 6 files changed, 141 insertions(+), 3 deletions(-)

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
index 91d8b268cae0..40c44101fe8e 100644
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
@@ -346,6 +353,27 @@ int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info)
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
@@ -1471,6 +1499,7 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	atomic64_set(&c->sndnxt, 0);
 	c->timer1 = jiffies;
 	c->timer2 = jiffies;
+	c->rekeying_intv = TIPC_REKEYING_INTV_DEF;
 	spin_lock_init(&c->lock);
 	scnprintf(c->name, 48, "%s(%s)", (is_rx(c)) ? "RX" : "TX",
 		  (is_rx(c)) ? tipc_node_get_id_str(c->node) :
@@ -1478,6 +1507,8 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 
 	if (is_rx(c))
 		INIT_DELAYED_WORK(&c->work, tipc_crypto_work_rx);
+	else
+		INIT_DELAYED_WORK(&c->work, tipc_crypto_work_tx);
 
 	*crypto = c;
 	return 0;
@@ -1492,8 +1523,11 @@ void tipc_crypto_stop(struct tipc_crypto **crypto)
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
@@ -2351,3 +2385,80 @@ static void tipc_crypto_work_rx(struct work_struct *work)
 
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
+	if (unlikely(rc))
+		pr_warn_ratelimited("%s: rekeying returns %d\n", tx->name, rc);
+
+resched:
+	/* Re-schedule rekeying if any */
+	tipc_crypto_rekeying_sched(tx, false, 0);
+}
diff --git a/net/tipc/crypto.h b/net/tipc/crypto.h
index b2a9c9b90684..e71193bd5e36 100644
--- a/net/tipc/crypto.h
+++ b/net/tipc/crypto.h
@@ -171,6 +171,8 @@ void tipc_crypto_key_flush(struct tipc_crypto *c);
 int tipc_crypto_key_distr(struct tipc_crypto *tx, u8 key,
 			  struct tipc_node *dest);
 void tipc_crypto_msg_rcv(struct net *net, struct sk_buff *skb);
+void tipc_crypto_rekeying_sched(struct tipc_crypto *tx, bool changed,
+				u32 new_intv);
 int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info);
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
index c9b6042e32b5..cf4b239fc569 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2879,6 +2879,17 @@ static int tipc_nl_retrieve_nodeid(struct nlattr **attrs, u8 **node_id)
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
@@ -2886,8 +2897,9 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 	struct tipc_crypto *tx = tipc_net(net)->crypto_tx, *c = tx;
 	struct tipc_node *n = NULL;
 	struct tipc_aead_key *ukey;
-	bool master_key = false;
+	bool rekeying = true, master_key = false;
 	u8 *id, *own_id, mode;
+	u32 intv = 0;
 	int rc = 0;
 
 	if (!info->attrs[TIPC_NLA_NODE])
@@ -2905,8 +2917,14 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 		return -EPERM;
 	}
 
+	rc = tipc_nl_retrieve_rekeying(attrs, &intv);
+	if (rc == -ENODATA)
+		rekeying = false;
+
 	rc = tipc_nl_retrieve_key(attrs, &ukey);
-	if (rc)
+	if (rc == -ENODATA && rekeying)
+		goto rekeying;
+	else if (rc)
 		return rc;
 
 	rc = tipc_aead_key_validate(ukey, info);
@@ -2945,6 +2963,9 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 		/* Distribute TX key but not master one */
 		if (!master_key && tipc_crypto_key_distr(tx, rc, NULL))
 			GENL_SET_ERR_MSG(info, "failed to replicate new key");
+rekeying:
+		/* Schedule TX rekeying if needed */
+		tipc_crypto_rekeying_sched(tx, rekeying, intv);
 	}
 
 	return 0;
-- 
2.26.2

