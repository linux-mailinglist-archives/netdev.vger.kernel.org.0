Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EBC256B83
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 06:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgH3ElO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 00:41:14 -0400
Received: from mail-eopbgr60101.outbound.protection.outlook.com ([40.107.6.101]:6823
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbgH3ElM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 00:41:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuVi3AZ0+aow6GfVV2nVNxypNyBYZ09C8zgFpyqasOE33ftYq9kSwCTDGa4xX0TaZpciXIfHS8u7yAhTNqMppRyywT7Ga2ZNt3WZ0wlQauhEV0jpT1yunLNEnmr219YDl+uYunAiLud8VqaaPQeXt7e1UwzM7BxKM9sUWUel2ywIhCc128/dByu87oxZBi0LgyiQ2v92llf26K8HVEM1FSvcHB6o+BUSGThHpgGnDbGmLJ3/fKVbPzAn18y4ImyNna6C1Cm0UR+Vf2p/JTnD5ZZzNJSaS/PI4jxHI5iiphCoMDRyW5+GTMYQ1MuXC7mnwMe7xb03do07v9fyW7UZlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjoNJn58wUesEs8BWyvzK0A4RGhiYLd6LAsE8OiP3Ng=;
 b=izu9VWHS6/uayrOymOHfEGBJko6OA6T8tmWp9q7l7ec47iaWTF4zXCQzZQvPLUakceGSoC+imtox4mA2gMIwUCeyxm5RAh8CUh+jtdX0dFDgprKMj2vSiJMxfe8SSV9ZQhYjaupPZ0/aL6/IhXwEi91vG6dbWzhXPsEKfnIeJOeRmqaeS5/w/n5OTvgcWlhJPquCnaRWOuUkR6UTR2uWqjV5WAUL+N+b1oSHdUQCqh9+c8zWryW7UKFmmob8W0NuVJjEhff/SxFMt1xo+Awmb8W5Cp04Pehhc2zZ0o4QQQlWR3C2lzaYTGM3P20EGyAveZbW6z5wkz+FPsi+egsFSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjoNJn58wUesEs8BWyvzK0A4RGhiYLd6LAsE8OiP3Ng=;
 b=cO+mzpirBGCHV3VP74EgrcIZrL6YUG743DNOvaJgh/CY78loNquDvcbEMSlfNIb1/f0yL3UyVf2RMHK4DeyLj1ATiBGfckUt6FWemynhIcF+DdDQxX3y3peOegXyqmrEAG/hJBHcyBUlEsWsFp5sT0PWJT+Cu5XBzTUoPYTEO0k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR05MB5105.eurprd05.prod.outlook.com (2603:10a6:208:f4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Sun, 30 Aug
 2020 04:41:05 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3326.025; Sun, 30 Aug 2020
 04:41:05 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 1/4] tipc: optimize key switching time and logic
Date:   Sun, 30 Aug 2020 02:41:54 +0700
Message-Id: <20200829194157.10273-2-tuong.t.lien@dektech.com.au>
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
Received: from dektech.com.au (14.161.14.188) by SG2PR02CA0040.apcprd02.prod.outlook.com (2603:1096:3:18::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Sun, 30 Aug 2020 04:41:03 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e39fa092-c61a-4bf0-ce38-08d84c9ee7e1
X-MS-TrafficTypeDiagnostic: AM0PR05MB5105:
X-Microsoft-Antispam-PRVS: <AM0PR05MB5105517BB084F6B30029602CE2500@AM0PR05MB5105.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N49NLrU9CnBw0SLzuY6jW2nJ4jjzuOhwpvzVCezkYE1WEQBo5CuyFmYXLStcp4FkroONC47WVXIYk+OyfUKcwgqUsrFM11jQ8es2QZkFPvFT92s/e6SgSgdOctSvB/7rz80nCWueg8soELdiHfv7TenGxDM5HjPtyP6R+k6S0yM3kBIDClNivFyzONZDvHTI8+yNLXllNrZZ2hJwg7IpqbniUzKdB8OHoTipfNgPApG0L+momiLtmA9iAWLDrJg6DsoxYZQPerHCFximAVwyH+vPI/cSgNY87/ohS4J68qFlh2eDsBA2iODA6Dl27LC9OrCt/eU9+8PCYqrG1Ltptw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39830400003)(36756003)(86362001)(16526019)(2906002)(478600001)(26005)(186003)(6666004)(55016002)(316002)(66476007)(66556008)(66946007)(8936002)(8676002)(1076003)(956004)(2616005)(103116003)(5660300002)(52116002)(83380400001)(7696005)(30864003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: qJ16kSPHOajVlCP9ZDwmeuHPVbT+FF06mU/AMAhE5D975POVM0AeHgjEJO+WVypoC43rkRHLgCAfUpwIAxCo92XN7S3WSOqrfjs2WZLMu7VIayhtVHKBSXRnxBEHW66Bv76NxBw6YV4Pte5Y8mDkR8P8yQqf1Xi72UPkBG41SaJAcLZhSJNv7WGEIuB+3p9iMNZMdFuQrje48v4GDipoozyqRm1whiDXWJe/2zjZDRoaCHh64sa5CZJlj3kGlF9UZ2F1lZrP/gO7JWV6V5nBerhKXybqe6RihTrDoDkCJPuacqCWN7vBf/s8KxrovkI8FtUe1gsdRjxxEDgLOt71NRrSpDKUmQk+j0CqrpS98pbk1NZFty0pOH51z7mCzy1CD7wEhoWzMjyizxN1DeRh/Iofn4IGIyYfOSJ/wvoIeJoBsd9fHRJJGoe/YIRg18lX2PDQotXPUmqts+yZQHG5F2d1zvq8qoWyaAdrWP+Nr6cLGoO3goWTZ0b3hsfF/uMHJ4swF+8lsl1lTEhRW9ts2z74q1oI7EnFjprBiYet7PkRMHRs/v8ywco5zd2FGfT3FSaF4UaTSWRA4ATpsAXuikGDZnGlj6eoZmwnuD5h3bWG5k+kBzaerOS6FzUMIbrWf1cKsVhZqZjV94W+n0e56g==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: e39fa092-c61a-4bf0-ce38-08d84c9ee7e1
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2020 04:41:05.5587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fcn9p8xoQ5v1KKmRtFHhwIk1jg3zwm0LTavAw9Py86Bu/YAIBjAomuxUvLJXgJtGvF8mkRRrbdaNeYv4n7DgPxJ4aJWXj5y95vaOqNrGUyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We reduce the lasting time for a pending TX key to be active as well as
for a passive RX key to be freed which generally helps speed up the key
switching. It is not expected to be too fast but should not be too slow
either. Also the key handling logic is simplified that a pending RX key
will be removed automatically if it is found not working after a number
of times; the probing for a pending TX key is now carried on a specific
message user ('LINK_PROTOCOL' or 'LINK_CONFIG') which is more efficient
than using a timer on broadcast messages, the timer is reserved for use
later as needed.

The kernel logs or 'pr***()' are now made as clear as possible to user.
Some prints are added, removed or changed to the debug-level. The
'TIPC_CRYPTO_DEBUG' definition is removed, and the 'pr_debug()' is used
instead which will be much helpful in runtime.

Besides we also optimize the code in some other places as a preparation
for later commits.

This commit does not change the en/decryption functionalities.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/crypto.c | 344 +++++++++++++++++++---------------------------
 1 file changed, 141 insertions(+), 203 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 7c523dc81575..53a3b34b3913 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -38,10 +38,10 @@
 #include <crypto/aes.h>
 #include "crypto.h"
 
-#define TIPC_TX_PROBE_LIM	msecs_to_jiffies(1000) /* > 1s */
-#define TIPC_TX_LASTING_LIM	msecs_to_jiffies(120000) /* 2 mins */
+#define TIPC_TX_LASTING_TIME	msecs_to_jiffies(10000) /* 10s */
 #define TIPC_RX_ACTIVE_LIM	msecs_to_jiffies(3000) /* 3s */
-#define TIPC_RX_PASSIVE_LIM	msecs_to_jiffies(180000) /* 3 mins */
+#define TIPC_RX_PASSIVE_LIM	msecs_to_jiffies(15000) /* 15s */
+
 #define TIPC_MAX_TFMS_DEF	10
 #define TIPC_MAX_TFMS_LIM	1000
 
@@ -144,7 +144,7 @@ struct tipc_aead {
 	u32 salt;
 	u8 authsize;
 	u8 mode;
-	char hint[TIPC_AEAD_HINT_LEN + 1];
+	char hint[2 * TIPC_AEAD_HINT_LEN + 1];
 	struct rcu_head rcu;
 
 	atomic64_t seqno ____cacheline_aligned;
@@ -168,9 +168,10 @@ struct tipc_crypto_stats {
  * @key: the key states
  * @working: the crypto is working or not
  * @stats: the crypto statistics
+ * @name: the crypto name
  * @sndnxt: the per-peer sndnxt (TX)
  * @timer1: general timer 1 (jiffies)
- * @timer2: general timer 1 (jiffies)
+ * @timer2: general timer 2 (jiffies)
  * @lock: tipc_key lock
  */
 struct tipc_crypto {
@@ -181,6 +182,7 @@ struct tipc_crypto {
 	struct tipc_key key;
 	u8 working:1;
 	struct tipc_crypto_stats __percpu *stats;
+	char name[48];
 
 	atomic64_t sndnxt ____cacheline_aligned;
 	unsigned long timer1;
@@ -239,18 +241,17 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending);
 static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
 						 struct tipc_crypto *rx,
 						 struct sk_buff *skb);
-static void tipc_crypto_key_synch(struct tipc_crypto *rx, u8 new_rx_active,
-				  struct tipc_msg *hdr);
+static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb);
 static int tipc_crypto_key_revoke(struct net *net, u8 tx_key);
 static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 				     struct tipc_bearer *b,
 				     struct sk_buff **skb, int err);
 static void tipc_crypto_do_cmd(struct net *net, int cmd);
 static char *tipc_crypto_key_dump(struct tipc_crypto *c, char *buf);
-#ifdef TIPC_CRYPTO_DEBUG
 static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 				  char *buf);
-#endif
+#define is_tx(crypto) (!(crypto)->node)
+#define is_rx(crypto) (!is_tx(crypto))
 
 #define key_next(cur) ((cur) % KEY_MAX + 1)
 
@@ -290,7 +291,7 @@ int tipc_aead_key_validate(struct tipc_aead_key *ukey)
 	if (unlikely(keylen != TIPC_AES_GCM_KEY_SIZE_128 &&
 		     keylen != TIPC_AES_GCM_KEY_SIZE_192 &&
 		     keylen != TIPC_AES_GCM_KEY_SIZE_256))
-		return -EINVAL;
+		return -EKEYREJECTED;
 
 	return 0;
 }
@@ -501,9 +502,9 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 		return err;
 	}
 
-	/* Copy some chars from the user key as a hint */
-	memcpy(tmp->hint, ukey->key, TIPC_AEAD_HINT_LEN);
-	tmp->hint[TIPC_AEAD_HINT_LEN] = '\0';
+	/* Form a hex string of some last bytes as the key's hint */
+	bin2hex(tmp->hint, ukey->key + keylen - TIPC_AEAD_HINT_LEN,
+		TIPC_AEAD_HINT_LEN);
 
 	/* Initialize the other data */
 	tmp->mode = mode;
@@ -663,13 +664,11 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 	 * but there is no frag_list, it should be still fine!
 	 * Otherwise, we must cow it to be a writable buffer with the tailroom.
 	 */
-#ifdef TIPC_CRYPTO_DEBUG
 	SKB_LINEAR_ASSERT(skb);
 	if (tailen > skb_tailroom(skb)) {
-		pr_warn("TX: skb tailroom is not enough: %d, requires: %d\n",
-			skb_tailroom(skb), tailen);
+		pr_debug("TX(): skb tailroom is not enough: %d, requires: %d\n",
+			 skb_tailroom(skb), tailen);
 	}
-#endif
 
 	if (unlikely(!skb_cloned(skb) && tailen <= skb_tailroom(skb))) {
 		nsg = 1;
@@ -1019,23 +1018,16 @@ static inline void tipc_crypto_key_set_state(struct tipc_crypto *c,
 					     u8 new_active,
 					     u8 new_pending)
 {
-#ifdef TIPC_CRYPTO_DEBUG
 	struct tipc_key old = c->key;
 	char buf[32];
-#endif
 
 	c->key.keys = ((new_passive & KEY_MASK) << (KEY_BITS * 2)) |
 		      ((new_active  & KEY_MASK) << (KEY_BITS)) |
 		      ((new_pending & KEY_MASK));
 
-#ifdef TIPC_CRYPTO_DEBUG
-	pr_info("%s(%s): key changing %s ::%pS\n",
-		(c->node) ? "RX" : "TX",
-		(c->node) ? tipc_node_get_id_str(c->node) :
-			    tipc_own_id_string(c->net),
-		tipc_key_change_dump(old, c->key, buf),
-		__builtin_return_address(0));
-#endif
+	pr_debug("%s: key changing %s ::%pS\n", c->name,
+		 tipc_key_change_dump(old, c->key, buf),
+		 __builtin_return_address(0));
 }
 
 /**
@@ -1057,20 +1049,20 @@ int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
 
 	/* Initiate with the new user key */
 	rc = tipc_aead_init(&aead, ukey, mode);
+	if (unlikely(rc)) {
+		pr_err("%s: unable to init key, err %d\n", c->name, rc);
+		return rc;
+	}
 
 	/* Attach it to the crypto */
-	if (likely(!rc)) {
-		rc = tipc_crypto_key_attach(c, aead, 0);
-		if (rc < 0)
-			tipc_aead_free(&aead->rcu);
+	rc = tipc_crypto_key_attach(c, aead, 0);
+	if (rc < 0) {
+		pr_err("%s: unable to attach key, err %d\n", c->name, rc);
+		tipc_aead_free(&aead->rcu);
+		return rc;
 	}
 
-	pr_info("%s(%s): key initiating, rc %d!\n",
-		(c->node) ? "RX" : "TX",
-		(c->node) ? tipc_node_get_id_str(c->node) :
-			    tipc_own_id_string(c->net),
-		rc);
-
+	pr_info("%s: key[%d] is successfully attached\n", c->name, rc);
 	return rc;
 }
 
@@ -1085,49 +1077,42 @@ int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
 static int tipc_crypto_key_attach(struct tipc_crypto *c,
 				  struct tipc_aead *aead, u8 pos)
 {
-	u8 new_pending, new_passive, new_key;
 	struct tipc_key key;
 	int rc = -EBUSY;
+	u8 new_key;
 
 	spin_lock_bh(&c->lock);
 	key = c->key;
 	if (key.active && key.passive)
 		goto exit;
-	if (key.passive && !tipc_aead_users(c->aead[key.passive]))
-		goto exit;
 	if (key.pending) {
-		if (pos)
-			goto exit;
 		if (tipc_aead_users(c->aead[key.pending]) > 0)
 			goto exit;
+		/* if (pos): ok with replacing, will be aligned when needed */
 		/* Replace it */
-		new_pending = key.pending;
-		new_passive = key.passive;
-		new_key = new_pending;
+		new_key = key.pending;
 	} else {
 		if (pos) {
 			if (key.active && pos != key_next(key.active)) {
-				new_pending = key.pending;
-				new_passive = pos;
-				new_key = new_passive;
+				key.passive = pos;
+				new_key = pos;
 				goto attach;
 			} else if (!key.active && !key.passive) {
-				new_pending = pos;
-				new_passive = key.passive;
-				new_key = new_pending;
+				key.pending = pos;
+				new_key = pos;
 				goto attach;
 			}
 		}
-		new_pending = key_next(key.active ?: key.passive);
-		new_passive = key.passive;
-		new_key = new_pending;
+		key.pending = key_next(key.active ?: key.passive);
+		new_key = key.pending;
 	}
 
 attach:
 	aead->crypto = c;
-	tipc_crypto_key_set_state(c, new_passive, key.active, new_pending);
 	tipc_aead_rcu_replace(c->aead[new_key], aead, &c->lock);
-
+	if (likely(c->key.keys != key.keys))
+		tipc_crypto_key_set_state(c, key.passive, key.active,
+					  key.pending);
 	c->working = 1;
 	c->timer1 = jiffies;
 	c->timer2 = jiffies;
@@ -1206,7 +1191,8 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
 		rcu_assign_pointer(rx->aead[new_passive], tmp2);
 	refcount_set(&tmp1->refcnt, 1);
 	aligned = true;
-	pr_info("RX(%s): key is aligned!\n", tipc_node_get_id_str(rx->node));
+	pr_info_ratelimited("%s: key[%d] -> key[%d]\n", rx->name, key.pending,
+			    new_pending);
 
 exit:
 	spin_unlock(&rx->lock);
@@ -1276,8 +1262,7 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
 /**
  * tipc_crypto_key_synch: Synch own key data according to peer key status
  * @rx: RX crypto handle
- * @new_rx_active: latest RX active key from peer
- * @hdr: TIPCv2 message
+ * @skb: TIPCv2 message buffer (incl. the ehdr from peer)
  *
  * This function updates the peer node related data as the peer RX active key
  * has changed, so the number of TX keys' users on this node are increased and
@@ -1285,44 +1270,35 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
  *
  * The "per-peer" sndnxt is also reset when the peer key has switched.
  */
-static void tipc_crypto_key_synch(struct tipc_crypto *rx, u8 new_rx_active,
-				  struct tipc_msg *hdr)
+static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 {
-	struct net *net = rx->net;
-	struct tipc_crypto *tx = tipc_net(net)->crypto_tx;
-	u8 cur_rx_active;
-
-	/* TX might be even not ready yet */
-	if (unlikely(!tx->key.active && !tx->key.pending))
-		return;
-
-	cur_rx_active = atomic_read(&rx->peer_rx_active);
-	if (likely(cur_rx_active == new_rx_active))
-		return;
+	struct tipc_ehdr *ehdr = (struct tipc_ehdr *)skb_network_header(skb);
+	struct tipc_crypto *tx = tipc_net(rx->net)->crypto_tx;
+	struct tipc_msg *hdr = buf_msg(skb);
+	u32 self = tipc_own_addr(rx->net);
+	u8 cur, new;
 
-	/* Make sure this message destined for this node */
-	if (unlikely(msg_short(hdr) ||
-		     msg_destnode(hdr) != tipc_own_addr(net)))
+	/* Ensure this message is destined to us first */
+	if (!ehdr->destined || msg_short(hdr) || msg_destnode(hdr) != self)
 		return;
 
-	/* Peer RX active key has changed, try to update owns' & TX users */
-	if (atomic_cmpxchg(&rx->peer_rx_active,
-			   cur_rx_active,
-			   new_rx_active) == cur_rx_active) {
-		if (new_rx_active)
-			tipc_aead_users_inc(tx->aead[new_rx_active], INT_MAX);
-		if (cur_rx_active)
-			tipc_aead_users_dec(tx->aead[cur_rx_active], 0);
+	/* Peer RX active key has changed, let's update own TX users */
+	cur = atomic_read(&rx->peer_rx_active);
+	new = ehdr->rx_key_active;
+	if (tx->key.keys &&
+	    cur != new &&
+	    atomic_cmpxchg(&rx->peer_rx_active, cur, new) == cur) {
+		if (new)
+			tipc_aead_users_inc(tx->aead[new], INT_MAX);
+		if (cur)
+			tipc_aead_users_dec(tx->aead[cur], 0);
 
 		atomic64_set(&rx->sndnxt, 0);
 		/* Mark the point TX key users changed */
 		tx->timer1 = jiffies;
 
-#ifdef TIPC_CRYPTO_DEBUG
-		pr_info("TX(%s): key users changed %d-- %d++, peer RX(%s)\n",
-			tipc_own_id_string(net), cur_rx_active,
-			new_rx_active, tipc_node_get_id_str(rx->node));
-#endif
+		pr_debug("%s: key users changed %d-- %d++, peer %s\n",
+			 tx->name, cur, new, rx->name);
 	}
 }
 
@@ -1340,7 +1316,7 @@ static int tipc_crypto_key_revoke(struct net *net, u8 tx_key)
 	tipc_crypto_key_detach(tx->aead[key.active], &tx->lock);
 	spin_unlock(&tx->lock);
 
-	pr_warn("TX(%s): key is revoked!\n", tipc_own_id_string(net));
+	pr_warn("%s: key is revoked\n", tx->name);
 	return -EKEYREVOKED;
 }
 
@@ -1373,25 +1349,26 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	c->timer1 = jiffies;
 	c->timer2 = jiffies;
 	spin_lock_init(&c->lock);
-	*crypto = c;
+	scnprintf(c->name, 48, "%s(%s)", (is_rx(c)) ? "RX" : "TX",
+		  (is_rx(c)) ? tipc_node_get_id_str(c->node) :
+			       tipc_own_id_string(c->net));
 
+	*crypto = c;
 	return 0;
 }
 
 void tipc_crypto_stop(struct tipc_crypto **crypto)
 {
-	struct tipc_crypto *c, *tx, *rx;
-	bool is_rx;
+	struct tipc_crypto *c = *crypto, *tx, *rx;
 	u8 k;
 
-	if (!*crypto)
+	if (!c)
 		return;
 
 	rcu_read_lock();
 	/* RX stopping? => decrease TX key users if any */
-	is_rx = !!((*crypto)->node);
-	if (is_rx) {
-		rx = *crypto;
+	if (is_rx(c)) {
+		rx = c;
 		tx = tipc_net(rx->net)->crypto_tx;
 		k = atomic_read(&rx->peer_rx_active);
 		if (k) {
@@ -1402,15 +1379,10 @@ void tipc_crypto_stop(struct tipc_crypto **crypto)
 	}
 
 	/* Release AEAD keys */
-	c = *crypto;
 	for (k = KEY_MIN; k <= KEY_MAX; k++)
 		tipc_aead_put(rcu_dereference(c->aead[k]));
 	rcu_read_unlock();
-
-	pr_warn("%s(%s) has been purged, node left!\n",
-		(is_rx) ? "RX" : "TX",
-		(is_rx) ? tipc_node_get_id_str((*crypto)->node) :
-			  tipc_own_id_string((*crypto)->net));
+	pr_debug("%s: has been stopped\n", c->name);
 
 	/* Free this crypto statistics */
 	free_percpu(c->stats);
@@ -1424,102 +1396,81 @@ void tipc_crypto_timeout(struct tipc_crypto *rx)
 	struct tipc_net *tn = tipc_net(rx->net);
 	struct tipc_crypto *tx = tn->crypto_tx;
 	struct tipc_key key;
-	u8 new_pending, new_passive;
 	int cmd;
 
-	/* TX key activating:
-	 * The pending key (users > 0) -> active
-	 * The active key if any (users == 0) -> free
-	 */
+	/* TX pending: taking all users & stable -> active */
 	spin_lock(&tx->lock);
 	key = tx->key;
 	if (key.active && tipc_aead_users(tx->aead[key.active]) > 0)
 		goto s1;
 	if (!key.pending || tipc_aead_users(tx->aead[key.pending]) <= 0)
 		goto s1;
-	if (time_before(jiffies, tx->timer1 + TIPC_TX_LASTING_LIM))
+	if (time_before(jiffies, tx->timer1 + TIPC_TX_LASTING_TIME))
 		goto s1;
 
 	tipc_crypto_key_set_state(tx, key.passive, key.pending, 0);
 	if (key.active)
 		tipc_crypto_key_detach(tx->aead[key.active], &tx->lock);
 	this_cpu_inc(tx->stats->stat[STAT_SWITCHES]);
-	pr_info("TX(%s): key %d is activated!\n", tipc_own_id_string(tx->net),
-		key.pending);
+	pr_info("%s: key[%d] is activated\n", tx->name, key.pending);
 
 s1:
 	spin_unlock(&tx->lock);
 
-	/* RX key activating:
-	 * The pending key (users > 0) -> active
-	 * The active key if any -> passive, freed later
-	 */
+	/* RX pending: having user -> active */
 	spin_lock(&rx->lock);
 	key = rx->key;
 	if (!key.pending || tipc_aead_users(rx->aead[key.pending]) <= 0)
 		goto s2;
 
-	new_pending = (key.passive &&
-		       !tipc_aead_users(rx->aead[key.passive])) ?
-				       key.passive : 0;
-	new_passive = (key.active) ?: ((new_pending) ? 0 : key.passive);
-	tipc_crypto_key_set_state(rx, new_passive, key.pending, new_pending);
+	if (key.active)
+		key.passive = key.active;
+	key.active = key.pending;
+	rx->timer2 = jiffies;
+	tipc_crypto_key_set_state(rx, key.passive, key.active, 0);
 	this_cpu_inc(rx->stats->stat[STAT_SWITCHES]);
-	pr_info("RX(%s): key %d is activated!\n",
-		tipc_node_get_id_str(rx->node),	key.pending);
+	pr_info("%s: key[%d] is activated\n", rx->name, key.pending);
 	goto s5;
 
 s2:
-	/* RX key "faulty" switching:
-	 * The faulty pending key (users < -30) -> passive
-	 * The passive key (users = 0) -> pending
-	 * Note: This only happens after RX deactivated - s3!
-	 */
-	key = rx->key;
-	if (!key.pending || tipc_aead_users(rx->aead[key.pending]) > -30)
-		goto s3;
-	if (!key.passive || tipc_aead_users(rx->aead[key.passive]) != 0)
+	/* RX pending: not working -> remove */
+	if (!key.pending || tipc_aead_users(rx->aead[key.pending]) > -10)
 		goto s3;
 
-	new_pending = key.passive;
-	new_passive = key.pending;
-	tipc_crypto_key_set_state(rx, new_passive, key.active, new_pending);
+	tipc_crypto_key_set_state(rx, key.passive, key.active, 0);
+	tipc_crypto_key_detach(rx->aead[key.pending], &rx->lock);
+	pr_info("%s: key[%d] is removed\n", rx->name, key.pending);
 	goto s5;
 
 s3:
-	/* RX key deactivating:
-	 * The passive key if any -> pending
-	 * The active key -> passive (users = 0) / pending
-	 * The pending key if any -> passive (users = 0)
-	 */
-	key = rx->key;
+	/* RX active: timed out or no user -> pending */
 	if (!key.active)
 		goto s4;
-	if (time_before(jiffies, rx->timer1 + TIPC_RX_ACTIVE_LIM))
+	if (time_before(jiffies, rx->timer1 + TIPC_RX_ACTIVE_LIM) &&
+	    tipc_aead_users(rx->aead[key.active]) > 0)
 		goto s4;
 
-	new_pending = (key.passive) ?: key.active;
-	new_passive = (key.passive) ? key.active : key.pending;
-	tipc_aead_users_set(rx->aead[new_pending], 0);
-	if (new_passive)
-		tipc_aead_users_set(rx->aead[new_passive], 0);
-	tipc_crypto_key_set_state(rx, new_passive, 0, new_pending);
-	pr_info("RX(%s): key %d is deactivated!\n",
-		tipc_node_get_id_str(rx->node), key.active);
+	if (key.pending)
+		key.passive = key.active;
+	else
+		key.pending = key.active;
+	rx->timer2 = jiffies;
+	tipc_crypto_key_set_state(rx, key.passive, 0, key.pending);
+	tipc_aead_users_set(rx->aead[key.pending], 0);
+	pr_info("%s: key[%d] is deactivated\n", rx->name, key.active);
 	goto s5;
 
 s4:
-	/* RX key passive -> freed: */
-	key = rx->key;
-	if (!key.passive || !tipc_aead_users(rx->aead[key.passive]))
+	/* RX passive: outdated or not working -> free */
+	if (!key.passive)
 		goto s5;
-	if (time_before(jiffies, rx->timer2 + TIPC_RX_PASSIVE_LIM))
+	if (time_before(jiffies, rx->timer2 + TIPC_RX_PASSIVE_LIM) &&
+	    tipc_aead_users(rx->aead[key.passive]) > -10)
 		goto s5;
 
 	tipc_crypto_key_set_state(rx, 0, key.active, key.pending);
 	tipc_crypto_key_detach(rx->aead[key.passive], &rx->lock);
-	pr_info("RX(%s): key %d is freed!\n", tipc_node_get_id_str(rx->node),
-		key.passive);
+	pr_info("%s: key[%d] is freed\n", rx->name, key.passive);
 
 s5:
 	spin_unlock(&rx->lock);
@@ -1562,10 +1513,12 @@ int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
 	struct tipc_crypto *__rx = tipc_node_crypto_rx(__dnode);
 	struct tipc_crypto *tx = tipc_net(net)->crypto_tx;
 	struct tipc_crypto_stats __percpu *stats = tx->stats;
+	struct tipc_msg *hdr = buf_msg(*skb);
 	struct tipc_key key = tx->key;
 	struct tipc_aead *aead = NULL;
-	struct sk_buff *probe;
+	struct sk_buff *_skb;
 	int rc = -ENOKEY;
+	u32 user = msg_user(hdr);
 	u8 tx_key;
 
 	/* No encryption? */
@@ -1583,17 +1536,18 @@ int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
 			goto encrypt;
 		if (__rx && atomic_read(&__rx->peer_rx_active) == tx_key)
 			goto encrypt;
-		if (TIPC_SKB_CB(*skb)->probe)
+		if (TIPC_SKB_CB(*skb)->probe) {
+			pr_debug("%s: probing for key[%d]\n", tx->name,
+				 key.pending);
 			goto encrypt;
-		if (!__rx &&
-		    time_after(jiffies, tx->timer2 + TIPC_TX_PROBE_LIM)) {
-			tx->timer2 = jiffies;
-			probe = skb_clone(*skb, GFP_ATOMIC);
-			if (probe) {
-				TIPC_SKB_CB(probe)->probe = 1;
-				tipc_crypto_xmit(net, &probe, b, dst, __dnode);
-				if (probe)
-					b->media->send_msg(net, probe, b, dst);
+		}
+		if (user == LINK_CONFIG || user == LINK_PROTOCOL) {
+			_skb = skb_clone(*skb, GFP_ATOMIC);
+			if (_skb) {
+				TIPC_SKB_CB(_skb)->probe = 1;
+				tipc_crypto_xmit(net, &_skb, b, dst, __dnode);
+				if (_skb)
+					b->media->send_msg(net, _skb, b, dst);
 			}
 		}
 	}
@@ -1675,22 +1629,12 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 	if (unlikely(!rx))
 		goto pick_tx;
 
-	/* Pick RX key according to TX key, three cases are possible:
-	 * 1) The current active key (likely) or;
-	 * 2) The pending (new or deactivated) key (if any) or;
-	 * 3) The passive or old active key (i.e. users > 0);
-	 */
 	tx_key = ((struct tipc_ehdr *)(*skb)->data)->tx_key;
+	/* Pick RX key according to TX key if any */
 	key = rx->key;
-	if (likely(tx_key == key.active))
+	if (tx_key == key.active || tx_key == key.pending ||
+	    tx_key == key.passive)
 		goto decrypt;
-	if (tx_key == key.pending)
-		goto decrypt;
-	if (tx_key == key.passive) {
-		rx->timer2 = jiffies;
-		if (tipc_aead_users(rx->aead[key.passive]) > 0)
-			goto decrypt;
-	}
 
 	/* Unknown key, let's try to align RX key(s) */
 	if (tipc_crypto_key_try_align(rx, tx_key))
@@ -1749,21 +1693,17 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 	struct tipc_aead *tmp = NULL;
 	struct tipc_ehdr *ehdr;
 	struct tipc_node *n;
-	u8 rx_key_active;
-	bool destined;
 
 	/* Is this completed by TX? */
-	if (unlikely(!rx->node)) {
+	if (unlikely(is_tx(aead->crypto))) {
 		rx = skb_cb->tx_clone_ctx.rx;
-#ifdef TIPC_CRYPTO_DEBUG
-		pr_info("TX->RX(%s): err %d, aead %p, skb->next %p, flags %x\n",
-			(rx) ? tipc_node_get_id_str(rx->node) : "-", err, aead,
-			(*skb)->next, skb_cb->flags);
-		pr_info("skb_cb [recurs %d, last %p], tx->aead [%p %p %p]\n",
-			skb_cb->tx_clone_ctx.recurs, skb_cb->tx_clone_ctx.last,
-			aead->crypto->aead[1], aead->crypto->aead[2],
-			aead->crypto->aead[3]);
-#endif
+		pr_debug("TX->RX(%s): err %d, aead %p, skb->next %p, flags %x\n",
+			 (rx) ? tipc_node_get_id_str(rx->node) : "-", err, aead,
+			 (*skb)->next, skb_cb->flags);
+		pr_debug("skb_cb [recurs %d, last %p], tx->aead [%p %p %p]\n",
+			 skb_cb->tx_clone_ctx.recurs, skb_cb->tx_clone_ctx.last,
+			 aead->crypto->aead[1], aead->crypto->aead[2],
+			 aead->crypto->aead[3]);
 		if (unlikely(err)) {
 			if (err == -EBADMSG && (*skb)->next)
 				tipc_rcv(net, (*skb)->next, b);
@@ -1784,9 +1724,6 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 				goto free_skb;
 		}
 
-		/* Skip cloning this time as we had a RX pending key */
-		if (rx->key.pending)
-			goto rcv;
 		if (tipc_aead_clone(&tmp, aead) < 0)
 			goto rcv;
 		if (tipc_crypto_key_attach(rx, tmp, ehdr->tx_key) < 0) {
@@ -1811,8 +1748,12 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 
 	/* Remove ehdr & auth. tag prior to tipc_rcv() */
 	ehdr = (struct tipc_ehdr *)(*skb)->data;
-	destined = ehdr->destined;
-	rx_key_active = ehdr->rx_key_active;
+
+	/* Mark this point, RX passive still works */
+	if (rx->key.passive && ehdr->tx_key == rx->key.passive)
+		rx->timer2 = jiffies;
+
+	skb_reset_network_header(*skb);
 	skb_pull(*skb, tipc_ehdr_size(ehdr));
 	pskb_trim(*skb, (*skb)->len - aead->authsize);
 
@@ -1822,9 +1763,8 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 		goto free_skb;
 	}
 
-	/* Update peer RX active key & TX users */
-	if (destined)
-		tipc_crypto_key_synch(rx, rx_key_active, buf_msg(*skb));
+	/* Ok, everything's fine, try to synch own keys according to peers' */
+	tipc_crypto_key_synch(rx, *skb);
 
 	/* Mark skb decrypted */
 	skb_cb->decrypted = 1;
@@ -1883,7 +1823,7 @@ static void tipc_crypto_do_cmd(struct net *net, int cmd)
 	/* Print crypto statistics */
 	for (i = 0, j = 0; i < MAX_STATS; i++)
 		j += scnprintf(buf + j, 200 - j, "|%11s ", hstats[i]);
-	pr_info("\nCounter     %s", buf);
+	pr_info("Counter     %s", buf);
 
 	memset(buf, '-', 115);
 	buf[115] = '\0';
@@ -1941,7 +1881,7 @@ static char *tipc_crypto_key_dump(struct tipc_crypto *c, char *buf)
 		aead = rcu_dereference(c->aead[k]);
 		if (aead)
 			i += scnprintf(buf + i, 200 - i,
-				       "{\"%s...\", \"%s\"}/%d:%d",
+				       "{\"0x...%s\", \"%s\"}/%d:%d",
 				       aead->hint,
 				       (aead->mode == CLUSTER_KEY) ? "c" : "p",
 				       atomic_read(&aead->users),
@@ -1950,14 +1890,13 @@ static char *tipc_crypto_key_dump(struct tipc_crypto *c, char *buf)
 		i += scnprintf(buf + i, 200 - i, "\n");
 	}
 
-	if (c->node)
+	if (is_rx(c))
 		i += scnprintf(buf + i, 200 - i, "\tPeer RX active: %d\n",
 			       atomic_read(&c->peer_rx_active));
 
 	return buf;
 }
 
-#ifdef TIPC_CRYPTO_DEBUG
 static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 				  char *buf)
 {
@@ -1988,4 +1927,3 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 	i += scnprintf(buf + i, 32 - i, "]");
 	return buf;
 }
-#endif
-- 
2.26.2

