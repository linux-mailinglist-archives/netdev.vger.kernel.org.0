Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E7F2702CA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgIRRDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:03:20 -0400
Received: from mail-db8eur05on2126.outbound.protection.outlook.com ([40.107.20.126]:49377
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbgIRRDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:03:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pmq3S4R9h2B/foTw1BnqwKO720rg5IUTVE/6XmCXtahuZwuGJoFmgN5ybye674cc5rvoCQr5ao6xEs3Ccz/mCjQKmhAicjGpG48uUIoeHh7i5TcNXQ38zIdzmJpLtunVR0jvyZ6KQC+U7UguqrBLwXjFP7sqOvZBFXbCIxTaDErgbax0oLuQ4PCgUr61+3Dmp8MDC2m9J9OYZ5sS+FFRXQls0Er/r+IH2HPao1u5bs86pZnAHHxZdPTiyCIUyHpsDfXmCmc+sTWqQKbHqt6Vi52Z4CNfvldIZLq87wnMEIBo80JlE86lgqHuf0m1CNTNI1uMeOxO+U7XysrdH+wPZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQoufErXSfhCcCCjCMOoe5ytEYF1+ZsSU4a1jRuO52M=;
 b=bs/WxitCjKWzENKDxIkuLezfW1GvYdELlLCphOfyMCXGXGKEHlo8QIn16Fmu401Pmh2zD/rfRfHLDOUYgI+Q++06qoG5kEUE3b9JWmqAxjWPmBngXlcWHOh1IFfQO6L8M0VJBpfiB77lS2opq5Dr4qAMTQ5uf0I26vvgkR+inp+M3IoTfCEa/VnfSn5pcCy7eQ+5nZ5WmGyU205lfLfSYyYO37CEz7Cudj+IFJWj9aTMwg+yDvhSDdhKsvMuapJp9ZpisMjXt7TgSyCKaX0vdEfxN84EckmihW49E8zNqc/slwH9fVnGpf6nv1SyP9OhKVtf6CCdRglb6j6WNeJ9ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQoufErXSfhCcCCjCMOoe5ytEYF1+ZsSU4a1jRuO52M=;
 b=Mauj3bxIbXAtbxHMmmoQ6DXh5zI91P94df/tfxh4RFf2Gx/uJ3PZEy8p318ySwwM3uvPIKCjHja7+i/TQLqtdZ8n6BINsYx3UFOjHyvJx4cPGDpm4ePS3GcqZlx1YuOjAPhbpHAnRnJl0FhKGviRwYOUMt+Kjx4yQ0SaHVAwgsA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR0502MB3827.eurprd05.prod.outlook.com (2603:10a6:208:1a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Fri, 18 Sep
 2020 17:03:02 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3391.015; Fri, 18 Sep 2020
 17:03:02 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next v3 1/4] tipc: optimize key switching time and logic
Date:   Fri, 18 Sep 2020 08:17:26 +0700
Message-Id: <20200918011729.30146-2-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
References: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26)
 To AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Fri, 18 Sep 2020 17:03:00 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [113.20.114.51]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ffe7eb8-bc5e-4c6d-354b-08d85bf4b399
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3827:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB38272C51702A98E2DDE686CBE23F0@AM0PR0502MB3827.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TRQGepnYszbP+30J9YHyRc0fvo2u1rKiIZEZxUCUnNS5ZJkaLGRcBWFAEE1GGL0z4GBTmmREtAvZ23j9rUvNm5T1AVQi7Zi320Rpm5ha42Ud7JWbjEuU1VzLvCaOQ1g6V6LdgQSEGiPoKbzMB/j0gCkzn5Q+DRAxvnx7OCo5vb7QMVfaHqMrNnR8jDNyaXdJ/6WXLBUF7RI3jGhwrXlUS2HO4AnUOEiomzq0/eRMn/w1+wiIT9QJ4TjaJRs5/IJ/ojErR9lEKDFZhKdXAvre0GMqcSBsm8QX6Vd6oetTSxOTbPlnUN6FcvxHtRxEbMyZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(346002)(376002)(366004)(396003)(2906002)(103116003)(36756003)(7696005)(55016002)(26005)(4326008)(8936002)(52116002)(316002)(16526019)(956004)(478600001)(186003)(83380400001)(2616005)(1076003)(86362001)(6666004)(66946007)(30864003)(66556008)(8676002)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kzKBwih2+gvjF7RnDeLSPmayjKmE6rreKcTlbRvv//zMg7H0JXaays5KeZ6CumOtvkV3RwWwy8YjBPz+F2ID60rwvqNipy8MkWxRbAqzFh6zyY/Fz8uJ2dRXhMaPXfuXcHLE73MDXujk3sbVssSJaX7YdQ9ehR46tZ1nEysvJJlA4U9osKBvbcYJZn2CFVXOB29nZGn12xb38PcV5LBTFquswGHVlROy8YV61V815K2OQKgMxR32swcgZ9CKjHe50dCwN1mpwKckTCsEkywty1PfMFXLz4toSP3eLnX94ld3DKNSnbTnziei65KMKW56p5HozxdYnlRJK/1UpPxVNd7PpLVtiIg0z40g2Qkt001CeEJhsTm6Bvz2ecrCqi6Gl5F3hQWGXbb+nWwr+CU3z729RYZjdYORuEcxwGm00A/iq/PU36iQtT6aUynCzAFT+ixAWDYIES/I2jXQbxkgvI0G3zpjfVOp+GscLY7016h8650vxwPoril++ajo26S6p8BQf+dqURVSZLyE8PkYjYOd3LIHNNg4Iosf9WK6L1S68RaVpaHVmAEKjltUqtzeWkLNJJ7lk9eL3Njos7hp5YidB01SilPeFpwDhB5wows6alapXCxEUdWD+FY4cjPl1Vkx2hpZoc+2wRjjHFOJww==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ffe7eb8-bc5e-4c6d-354b-08d85bf4b399
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 17:03:01.9580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZnyLYPYnZVr1LWrqc0Y0hHhzkMMSl3c1F9tcBrafPN0dahhGhGwkTRNxNbZ1uz5rQCUhphqBfoeZRT1n1LvAjmHq1ztojN8UbLW2sEB3Oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3827
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

v2: silent more kernel logs, also use 'info->extack' for a message
emitted due to netlink operations instead (- David's comments).

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/crypto.c | 342 +++++++++++++++++++---------------------------
 net/tipc/crypto.h |   2 +-
 net/tipc/node.c   |  52 ++++---
 3 files changed, 165 insertions(+), 231 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 7c523dc81575..45a8f4d9d9de 100644
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
 
@@ -271,26 +272,30 @@ do {									\
 /**
  * tipc_aead_key_validate - Validate a AEAD user key
  */
-int tipc_aead_key_validate(struct tipc_aead_key *ukey)
+int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info)
 {
 	int keylen;
 
 	/* Check if algorithm exists */
 	if (unlikely(!crypto_has_alg(ukey->alg_name, 0, 0))) {
-		pr_info("Not found cipher: \"%s\"!\n", ukey->alg_name);
+		GENL_SET_ERR_MSG(info, "unable to load the algorithm (module existed?)");
 		return -ENODEV;
 	}
 
 	/* Currently, we only support the "gcm(aes)" cipher algorithm */
-	if (strcmp(ukey->alg_name, "gcm(aes)"))
+	if (strcmp(ukey->alg_name, "gcm(aes)")) {
+		GENL_SET_ERR_MSG(info, "not supported yet the algorithm");
 		return -ENOTSUPP;
+	}
 
 	/* Check if key size is correct */
 	keylen = ukey->keylen - TIPC_AES_GCM_SALT_SIZE;
 	if (unlikely(keylen != TIPC_AES_GCM_KEY_SIZE_128 &&
 		     keylen != TIPC_AES_GCM_KEY_SIZE_192 &&
-		     keylen != TIPC_AES_GCM_KEY_SIZE_256))
-		return -EINVAL;
+		     keylen != TIPC_AES_GCM_KEY_SIZE_256)) {
+		GENL_SET_ERR_MSG(info, "incorrect key length (20, 28 or 36 octets?)");
+		return -EKEYREJECTED;
+	}
 
 	return 0;
 }
@@ -501,9 +506,9 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
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
@@ -663,13 +668,11 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
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
@@ -1019,23 +1022,16 @@ static inline void tipc_crypto_key_set_state(struct tipc_crypto *c,
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
@@ -1065,12 +1061,6 @@ int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
 			tipc_aead_free(&aead->rcu);
 	}
 
-	pr_info("%s(%s): key initiating, rc %d!\n",
-		(c->node) ? "RX" : "TX",
-		(c->node) ? tipc_node_get_id_str(c->node) :
-			    tipc_own_id_string(c->net),
-		rc);
-
 	return rc;
 }
 
@@ -1085,49 +1075,42 @@ int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
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
@@ -1206,7 +1189,8 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
 		rcu_assign_pointer(rx->aead[new_passive], tmp2);
 	refcount_set(&tmp1->refcnt, 1);
 	aligned = true;
-	pr_info("RX(%s): key is aligned!\n", tipc_node_get_id_str(rx->node));
+	pr_info_ratelimited("%s: key[%d] -> key[%d]\n", rx->name, key.pending,
+			    new_pending);
 
 exit:
 	spin_unlock(&rx->lock);
@@ -1276,8 +1260,7 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
 /**
  * tipc_crypto_key_synch: Synch own key data according to peer key status
  * @rx: RX crypto handle
- * @new_rx_active: latest RX active key from peer
- * @hdr: TIPCv2 message
+ * @skb: TIPCv2 message buffer (incl. the ehdr from peer)
  *
  * This function updates the peer node related data as the peer RX active key
  * has changed, so the number of TX keys' users on this node are increased and
@@ -1285,44 +1268,35 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
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
 
@@ -1340,7 +1314,7 @@ static int tipc_crypto_key_revoke(struct net *net, u8 tx_key)
 	tipc_crypto_key_detach(tx->aead[key.active], &tx->lock);
 	spin_unlock(&tx->lock);
 
-	pr_warn("TX(%s): key is revoked!\n", tipc_own_id_string(net));
+	pr_warn("%s: key is revoked\n", tx->name);
 	return -EKEYREVOKED;
 }
 
@@ -1373,25 +1347,26 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
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
@@ -1402,15 +1377,10 @@ void tipc_crypto_stop(struct tipc_crypto **crypto)
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
@@ -1424,102 +1394,81 @@ void tipc_crypto_timeout(struct tipc_crypto *rx)
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
+	pr_debug("%s: key[%d] is removed\n", rx->name, key.pending);
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
+	pr_debug("%s: key[%d] is deactivated\n", rx->name, key.active);
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
+	pr_debug("%s: key[%d] is freed\n", rx->name, key.passive);
 
 s5:
 	spin_unlock(&rx->lock);
@@ -1562,10 +1511,12 @@ int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
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
@@ -1583,17 +1534,18 @@ int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
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
@@ -1675,22 +1627,12 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
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
-		goto decrypt;
-	if (tx_key == key.pending)
+	if (tx_key == key.active || tx_key == key.pending ||
+	    tx_key == key.passive)
 		goto decrypt;
-	if (tx_key == key.passive) {
-		rx->timer2 = jiffies;
-		if (tipc_aead_users(rx->aead[key.passive]) > 0)
-			goto decrypt;
-	}
 
 	/* Unknown key, let's try to align RX key(s) */
 	if (tipc_crypto_key_try_align(rx, tx_key))
@@ -1749,21 +1691,17 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
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
@@ -1784,9 +1722,6 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 				goto free_skb;
 		}
 
-		/* Skip cloning this time as we had a RX pending key */
-		if (rx->key.pending)
-			goto rcv;
 		if (tipc_aead_clone(&tmp, aead) < 0)
 			goto rcv;
 		if (tipc_crypto_key_attach(rx, tmp, ehdr->tx_key) < 0) {
@@ -1811,8 +1746,12 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 
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
 
@@ -1822,9 +1761,8 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 		goto free_skb;
 	}
 
-	/* Update peer RX active key & TX users */
-	if (destined)
-		tipc_crypto_key_synch(rx, rx_key_active, buf_msg(*skb));
+	/* Ok, everything's fine, try to synch own keys according to peers' */
+	tipc_crypto_key_synch(rx, *skb);
 
 	/* Mark skb decrypted */
 	skb_cb->decrypted = 1;
@@ -1883,7 +1821,7 @@ static void tipc_crypto_do_cmd(struct net *net, int cmd)
 	/* Print crypto statistics */
 	for (i = 0, j = 0; i < MAX_STATS; i++)
 		j += scnprintf(buf + j, 200 - j, "|%11s ", hstats[i]);
-	pr_info("\nCounter     %s", buf);
+	pr_info("Counter     %s", buf);
 
 	memset(buf, '-', 115);
 	buf[115] = '\0';
@@ -1941,7 +1879,7 @@ static char *tipc_crypto_key_dump(struct tipc_crypto *c, char *buf)
 		aead = rcu_dereference(c->aead[k]);
 		if (aead)
 			i += scnprintf(buf + i, 200 - i,
-				       "{\"%s...\", \"%s\"}/%d:%d",
+				       "{\"0x...%s\", \"%s\"}/%d:%d",
 				       aead->hint,
 				       (aead->mode == CLUSTER_KEY) ? "c" : "p",
 				       atomic_read(&aead->users),
@@ -1950,14 +1888,13 @@ static char *tipc_crypto_key_dump(struct tipc_crypto *c, char *buf)
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
@@ -1988,4 +1925,3 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 	i += scnprintf(buf + i, 32 - i, "]");
 	return buf;
 }
-#endif
diff --git a/net/tipc/crypto.h b/net/tipc/crypto.h
index c3de769f49e8..c387240e03d0 100644
--- a/net/tipc/crypto.h
+++ b/net/tipc/crypto.h
@@ -160,7 +160,7 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
 			 u8 mode);
 void tipc_crypto_key_flush(struct tipc_crypto *c);
-int tipc_aead_key_validate(struct tipc_aead_key *ukey);
+int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info);
 bool tipc_ehdr_validate(struct sk_buff *skb);
 
 #endif /* _TIPC_CRYPTO_H */
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 4edcee3088da..70045630e6bb 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2872,11 +2872,10 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attrs[TIPC_NLA_NODE_MAX + 1];
 	struct net *net = sock_net(skb->sk);
-	struct tipc_net *tn = tipc_net(net);
+	struct tipc_crypto *tx = tipc_net(net)->crypto_tx, *c = tx;
 	struct tipc_node *n = NULL;
 	struct tipc_aead_key *ukey;
-	struct tipc_crypto *c;
-	u8 *id, *own_id;
+	u8 *id, *own_id, mode;
 	int rc = 0;
 
 	if (!info->attrs[TIPC_NLA_NODE])
@@ -2886,52 +2885,52 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 			      info->attrs[TIPC_NLA_NODE],
 			      tipc_nl_node_policy, info->extack);
 	if (rc)
-		goto exit;
+		return rc;
 
 	own_id = tipc_own_id(net);
 	if (!own_id) {
-		rc = -EPERM;
-		goto exit;
+		GENL_SET_ERR_MSG(info, "not found own node identity (set id?)");
+		return -EPERM;
 	}
 
 	rc = tipc_nl_retrieve_key(attrs, &ukey);
 	if (rc)
-		goto exit;
+		return rc;
 
-	rc = tipc_aead_key_validate(ukey);
+	rc = tipc_aead_key_validate(ukey, info);
 	if (rc)
-		goto exit;
+		return rc;
 
 	rc = tipc_nl_retrieve_nodeid(attrs, &id);
 	switch (rc) {
 	case -ENODATA:
-		/* Cluster key mode */
-		rc = tipc_crypto_key_init(tn->crypto_tx, ukey, CLUSTER_KEY);
+		mode = CLUSTER_KEY;
 		break;
 	case 0:
-		/* Per-node key mode */
-		if (!memcmp(id, own_id, NODE_ID_LEN)) {
-			c = tn->crypto_tx;
-		} else {
+		mode = PER_NODE_KEY;
+		if (memcmp(id, own_id, NODE_ID_LEN)) {
 			n = tipc_node_find_by_id(net, id) ?:
 				tipc_node_create(net, 0, id, 0xffffu, 0, true);
-			if (unlikely(!n)) {
-				rc = -ENOMEM;
-				break;
-			}
+			if (unlikely(!n))
+				return -ENOMEM;
 			c = n->crypto_rx;
 		}
-
-		rc = tipc_crypto_key_init(c, ukey, PER_NODE_KEY);
-		if (n)
-			tipc_node_put(n);
 		break;
 	default:
-		break;
+		return rc;
 	}
 
-exit:
-	return (rc < 0) ? rc : 0;
+	/* Initiate the TX/RX key */
+	rc = tipc_crypto_key_init(c, ukey, mode);
+	if (n)
+		tipc_node_put(n);
+
+	if (rc < 0) {
+		GENL_SET_ERR_MSG(info, "unable to initiate or attach new key");
+		return rc;
+	}
+
+	return 0;
 }
 
 int tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
@@ -2958,7 +2957,6 @@ static int __tipc_nl_node_flush_key(struct sk_buff *skb,
 		tipc_crypto_key_flush(n->crypto_rx);
 	rcu_read_unlock();
 
-	pr_info("All keys are flushed!\n");
 	return 0;
 }
 
-- 
2.26.2

