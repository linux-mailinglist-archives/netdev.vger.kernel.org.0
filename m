Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A169E2702D0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIRRDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:03:47 -0400
Received: from mail-db8eur05on2126.outbound.protection.outlook.com ([40.107.20.126]:49377
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726273AbgIRRDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:03:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwBNX4l61947JKAym6gR9JcfxAr3OvPNTBvVHVmIaiiph6HKOArqsqqNMDT6GkL9jxkY49bODAxRPkswzcfNHEgOXgwcb/cHS4EW0i6DC33hlYg6R1I6UAGyWYSZV67OW+EeK2yWnY4bGiU9PBk9y6uUagk+40v5sS3g/pokUasoJcwb7fk4aKwWbJ/4BYDA9At5O93S8eDIuEj5Lk1q8U+iwSYvdoRJgpmZGEm8nF12xzmaDBBiqn9ieOId5f/CRZyvsE9PHl8cXwyAULlFBD8SXEDQ9pjXRZKpxMynBn3msAhUWKDGauMg1Q6c5+Jk13BMaU2NNSP0nRPNwEYcrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OdASVBS8i1iS3eRlSrQgPUW8xKahsmbOVhY0cE5yKxs=;
 b=V9ov5jhLCaOfd20wcPsw5aSh1QVcfeMYRdcuYG85EBb1KpbBoOyW5aP50LybwziTRv/0/W1xOa0oeCxAGk5zAQqLpeKIkmq8aDL1GGqysS2IqjDgbMGG/HR1LgKeXhGOPwp0jRmnpYDOySkASBX7CqZALCl/LXUPwwGk8GmmYblsFur4J8KkpOfnIVWeh+NtP7msNVudxkbfegi1JdsRNGWqZIhRGaU2tt/gIA3VG6HxgxGyJqYu4U8xrry0aFKTzvFhNxjIyyyP8ccQ0auZfXxctEQzWtk/IX9uHJZ50jCl6ydjLa8gyjDWrfz5RpyfmS7r8apjx3dr5lUmR+ixig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OdASVBS8i1iS3eRlSrQgPUW8xKahsmbOVhY0cE5yKxs=;
 b=AdFpUh+wOLghfkdE97Pbm3+/RF92PdHJPgM7vtWqG6p1132tZQG5d425jXt4wxKz6c14IWWXivqLKv8tqnKA6mGjfT+L6aQHDhHx5mX+Y4UQ8QigbHxxmpazn3U+zUx2jPBauGNWadAZEF/0Yi+7cpl1M2r96eE+vty6rjt6BDw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR0502MB3827.eurprd05.prod.outlook.com (2603:10a6:208:1a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Fri, 18 Sep
 2020 17:03:04 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3391.015; Fri, 18 Sep 2020
 17:03:04 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next v3 2/4] tipc: introduce encryption master key
Date:   Fri, 18 Sep 2020 08:17:27 +0700
Message-Id: <20200918011729.30146-3-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
References: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26)
 To AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Fri, 18 Sep 2020 17:03:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [113.20.114.51]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f4d428a-0f04-47eb-8609-08d85bf4b4e6
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3827:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB382715C8893978B44AF1057BE23F0@AM0PR0502MB3827.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZjfVMOCJe/D1US/oF9OBKdVXAl1Sc8sP3QfEYGARkIWC7tXSHvrF1Z+3cTJ7zuvGqR4Kmw29nfF9DMyrOTVdLPWLIrhY5c9JdxCN/IBYEhyhe67TyYLmPfXiceYp0hydY7pWH6SQgqwg4V78Dz1uUZuVI8fOOB4qY6Pdf7aTwwglfYDgI4cmWOn5kbjsrO/hYKhju+sTBuiU4+lUF33biS05i2ylGW/EOERfrjwv9g+VXskjhWwB0zcidKxrUoiVywXdvmv3uEaoXVh8tYUHtTNZTKN1X68yAdm3PU0nyj7Xk1UbEZsIepgmtlh4lzg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(346002)(376002)(366004)(396003)(2906002)(103116003)(36756003)(7696005)(55016002)(26005)(4326008)(8936002)(52116002)(316002)(16526019)(956004)(478600001)(186003)(83380400001)(2616005)(1076003)(86362001)(6666004)(66946007)(30864003)(66556008)(8676002)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: wJQFXrHf6taCstnxJZ/W5yTjK/Qloluc8LqsoWHxX3qu/NSe17kpdQdx+VPXxg/4wbTff3EayAviYey1Om35SSS/PoxBSx7RIB1M3MYzrbk1vq4v3pV6iwb+C/Ac9XT8dOVr9dfBjL8dHfjJ0IveERGIECCoYTdC5o5K3tnRY3QZjw37yTYDnzvNt66NvjCDRljF63LtgI+xBQgwmUb39V7rePuxwO134coKna686sKBpa3a/EA7hEw4jAD68lu3Ac1tw1tBiIrfMtPxn8LTFmEx6ZRsVtLOLaYfIJzmD9gr2dWW4XRCXESMyL/zREZwtqWhIJDxPz5TcxoYAwNm6xTn7FXYGbsogEhnfnD7VbnxvjfYb+PZEl+cqYP+Sj3QVm8JKgHNrMY9hahJdBDGlXb9KD7stgXTR7LZ6HLx90JDfuVQnTWT6ukpkMyFd1n9dXHRO0Hq+VdgkNfdX9j+NhhXll1howZHccgGT5wJyTontw2DkS5kbJupwahCWIMZwdTnHM0n+BCPT22qr5lkKOBNB21PlB7+yCW958zjo9siFIsGFLgPk61BrmosfoithnIbV5tne3rAZQRdpeUAh96B3T4uGS02dr2TJYdGmwvbdfWH9kpb+7dinyXgYYyXSIzsc05g9RcU+VHlE6DKkw==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4d428a-0f04-47eb-8609-08d85bf4b4e6
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 17:03:04.1574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DTupt+S4i+lP88Lg4yjd5J2tqqAHCA62UmF3uaQtE8nCc1bpuNpEDDSHwdCe03QtTmEDjVAWwl4HnvNr/cBOXvogna0o0Oy9WeMK0ZAevI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In addition to the supported cluster & per-node encryption keys for the
en/decryption of TIPC messages, we now introduce one option for user to
set a cluster key as 'master key', which is simply a symmetric key like
the former but has a longer life cycle. It has two purposes:

- Authentication of new member nodes in the cluster. New nodes, having
  no knowledge of current session keys in the cluster will still be
  able to join the cluster as long as they know the master key. This is
  because all neighbor discovery (LINK_CONFIG) messages must be
  encrypted with this key.

- Encryption of session encryption keys during automatic exchange and
  update of those.This is a feature we will introduce in a later commit
  in this series.

We insert the new key into the currently unused slot 0 in the key array
and start using it immediately once the user has set it.
After joining, a node only knowing the master key should be fully
communicable to existing nodes in the cluster, although those nodes may
have their own session keys activated (i.e. not the master one). To
support this, we define a 'grace period', starting from the time a node
itself reports having no RX keys, so the existing nodes will use the
master key for encryption instead. The grace period can be extended but
will automatically stop after e.g. 5 seconds without a new report. This
is also the basis for later key exchanging feature as the new node will
be impossible to decrypt anything without the support from master key.

For user to set a master key, we define a new netlink flag -
'TIPC_NLA_NODE_KEY_MASTER', so it can be added to the current 'set key'
netlink command to specify the setting key to be a master key.

Above all, the traditional cluster/per-node key mechanism is guaranteed
to work when user comes not to use this master key option. This is also
compatible to legacy nodes without the feature supported.

Even this master key can be updated without any interruption of cluster
connectivity but is so is needed, this has to be coordinated and set by
the user.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 include/uapi/linux/tipc_netlink.h |   1 +
 net/tipc/crypto.c                 | 210 ++++++++++++++++++++++--------
 net/tipc/crypto.h                 |  15 ++-
 net/tipc/msg.h                    |   4 +-
 net/tipc/netlink.c                |   1 +
 net/tipc/node.c                   |   6 +-
 6 files changed, 175 insertions(+), 62 deletions(-)

diff --git a/include/uapi/linux/tipc_netlink.h b/include/uapi/linux/tipc_netlink.h
index dc0d23a50e69..d484baa9d365 100644
--- a/include/uapi/linux/tipc_netlink.h
+++ b/include/uapi/linux/tipc_netlink.h
@@ -165,6 +165,7 @@ enum {
 	TIPC_NLA_NODE_UP,		/* flag */
 	TIPC_NLA_NODE_ID,		/* data */
 	TIPC_NLA_NODE_KEY,		/* data */
+	TIPC_NLA_NODE_KEY_MASTER,	/* flag */
 
 	__TIPC_NLA_NODE_MAX,
 	TIPC_NLA_NODE_MAX = __TIPC_NLA_NODE_MAX - 1
diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 45a8f4d9d9de..2510b82d3cc1 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -38,6 +38,7 @@
 #include <crypto/aes.h>
 #include "crypto.h"
 
+#define TIPC_TX_GRACE_PERIOD	msecs_to_jiffies(5000) /* 5s */
 #define TIPC_TX_LASTING_TIME	msecs_to_jiffies(10000) /* 10s */
 #define TIPC_RX_ACTIVE_LIM	msecs_to_jiffies(3000) /* 3s */
 #define TIPC_RX_PASSIVE_LIM	msecs_to_jiffies(15000) /* 15s */
@@ -49,9 +50,9 @@
  * TIPC Key ids
  */
 enum {
-	KEY_UNUSED = 0,
-	KEY_MIN,
-	KEY_1 = KEY_MIN,
+	KEY_MASTER = 0,
+	KEY_MIN = KEY_MASTER,
+	KEY_1 = 1,
 	KEY_2,
 	KEY_3,
 	KEY_MAX = KEY_3,
@@ -166,27 +167,36 @@ struct tipc_crypto_stats {
  * @aead: array of pointers to AEAD keys for encryption/decryption
  * @peer_rx_active: replicated peer RX active key index
  * @key: the key states
- * @working: the crypto is working or not
  * @stats: the crypto statistics
  * @name: the crypto name
  * @sndnxt: the per-peer sndnxt (TX)
  * @timer1: general timer 1 (jiffies)
  * @timer2: general timer 2 (jiffies)
+ * @working: the crypto is working or not
+ * @key_master: flag indicates if master key exists
+ * @legacy_user: flag indicates if a peer joins w/o master key (for bwd comp.)
  * @lock: tipc_key lock
  */
 struct tipc_crypto {
 	struct net *net;
 	struct tipc_node *node;
-	struct tipc_aead __rcu *aead[KEY_MAX + 1]; /* key[0] is UNUSED */
+	struct tipc_aead __rcu *aead[KEY_MAX + 1];
 	atomic_t peer_rx_active;
 	struct tipc_key key;
-	u8 working:1;
 	struct tipc_crypto_stats __percpu *stats;
 	char name[48];
 
 	atomic64_t sndnxt ____cacheline_aligned;
 	unsigned long timer1;
 	unsigned long timer2;
+	union {
+		struct {
+			u8 working:1;
+			u8 key_master:1;
+			u8 legacy_user:1;
+		};
+		u8 flags;
+	};
 	spinlock_t lock; /* crypto lock */
 
 } ____cacheline_aligned;
@@ -236,13 +246,19 @@ static inline void tipc_crypto_key_set_state(struct tipc_crypto *c,
 					     u8 new_active,
 					     u8 new_pending);
 static int tipc_crypto_key_attach(struct tipc_crypto *c,
-				  struct tipc_aead *aead, u8 pos);
+				  struct tipc_aead *aead, u8 pos,
+				  bool master_key);
 static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending);
 static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
 						 struct tipc_crypto *rx,
-						 struct sk_buff *skb);
+						 struct sk_buff *skb,
+						 u8 tx_key);
 static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb);
 static int tipc_crypto_key_revoke(struct net *net, u8 tx_key);
+static inline void tipc_crypto_clone_msg(struct net *net, struct sk_buff *_skb,
+					 struct tipc_bearer *b,
+					 struct tipc_media_addr *dst,
+					 struct tipc_node *__dnode, u8 type);
 static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 				     struct tipc_bearer *b,
 				     struct sk_buff **skb, int err);
@@ -943,8 +959,6 @@ bool tipc_ehdr_validate(struct sk_buff *skb)
 		return false;
 	if (unlikely(skb->len <= ehsz + TIPC_AES_GCM_TAG_SIZE))
 		return false;
-	if (unlikely(!ehdr->tx_key))
-		return false;
 
 	return true;
 }
@@ -997,6 +1011,8 @@ static int tipc_ehdr_build(struct net *net, struct tipc_aead *aead,
 	ehdr->tx_key = tx_key;
 	ehdr->destined = (__rx) ? 1 : 0;
 	ehdr->rx_key_active = (__rx) ? __rx->key.active : 0;
+	ehdr->rx_nokey = (__rx) ? !__rx->key.keys : 0;
+	ehdr->master_key = aead->crypto->key_master;
 	ehdr->reserved_1 = 0;
 	ehdr->reserved_2 = 0;
 
@@ -1039,6 +1055,7 @@ static inline void tipc_crypto_key_set_state(struct tipc_crypto *c,
  * @c: TIPC crypto to which new key is attached
  * @ukey: the user key
  * @mode: the key mode (CLUSTER_KEY or PER_NODE_KEY)
+ * @master_key: specify this is a cluster master key
  *
  * A new TIPC AEAD key will be allocated and initiated with the specified user
  * key, then attached to the TIPC crypto.
@@ -1046,7 +1063,7 @@ static inline void tipc_crypto_key_set_state(struct tipc_crypto *c,
  * Return: new key id in case of success, otherwise: < 0
  */
 int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
-			 u8 mode)
+			 u8 mode, bool master_key)
 {
 	struct tipc_aead *aead = NULL;
 	int rc = 0;
@@ -1056,7 +1073,7 @@ int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
 
 	/* Attach it to the crypto */
 	if (likely(!rc)) {
-		rc = tipc_crypto_key_attach(c, aead, 0);
+		rc = tipc_crypto_key_attach(c, aead, 0, master_key);
 		if (rc < 0)
 			tipc_aead_free(&aead->rcu);
 	}
@@ -1069,11 +1086,13 @@ int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
  * @c: TIPC crypto to which the new AEAD key is attached
  * @aead: the new AEAD key pointer
  * @pos: desired slot in the crypto key array, = 0 if any!
+ * @master_key: specify this is a cluster master key
  *
  * Return: new key id in case of success, otherwise: -EBUSY
  */
 static int tipc_crypto_key_attach(struct tipc_crypto *c,
-				  struct tipc_aead *aead, u8 pos)
+				  struct tipc_aead *aead, u8 pos,
+				  bool master_key)
 {
 	struct tipc_key key;
 	int rc = -EBUSY;
@@ -1081,6 +1100,10 @@ static int tipc_crypto_key_attach(struct tipc_crypto *c,
 
 	spin_lock_bh(&c->lock);
 	key = c->key;
+	if (master_key) {
+		new_key = KEY_MASTER;
+		goto attach;
+	}
 	if (key.active && key.passive)
 		goto exit;
 	if (key.pending) {
@@ -1112,8 +1135,7 @@ static int tipc_crypto_key_attach(struct tipc_crypto *c,
 		tipc_crypto_key_set_state(c, key.passive, key.active,
 					  key.pending);
 	c->working = 1;
-	c->timer1 = jiffies;
-	c->timer2 = jiffies;
+	c->key_master |= master_key;
 	rc = new_key;
 
 exit:
@@ -1126,7 +1148,7 @@ void tipc_crypto_key_flush(struct tipc_crypto *c)
 	int k;
 
 	spin_lock_bh(&c->lock);
-	c->working = 0;
+	c->flags = 0;
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	for (k = KEY_MIN; k <= KEY_MAX; k++)
 		tipc_crypto_key_detach(c->aead[k], &c->lock);
@@ -1202,6 +1224,7 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
  * @tx: TX crypto handle
  * @rx: RX crypto handle (can be NULL)
  * @skb: the message skb which will be decrypted later
+ * @tx_key: peer TX key id
  *
  * This function looks up the existing TX keys and pick one which is suitable
  * for the message decryption, that must be a cluster key and not used before
@@ -1211,7 +1234,8 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
  */
 static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
 						 struct tipc_crypto *rx,
-						 struct sk_buff *skb)
+						 struct sk_buff *skb,
+						 u8 tx_key)
 {
 	struct tipc_skb_cb *skb_cb = TIPC_SKB_CB(skb);
 	struct tipc_aead *aead = NULL;
@@ -1230,6 +1254,10 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
 
 	/* Pick one TX key */
 	spin_lock(&tx->lock);
+	if (tx_key == KEY_MASTER) {
+		aead = tipc_aead_rcu_ptr(tx->aead[KEY_MASTER], &tx->lock);
+		goto done;
+	}
 	do {
 		k = (i == 0) ? key.pending :
 			((i == 1) ? key.active : key.passive);
@@ -1249,9 +1277,12 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
 		skb->next = skb_clone(skb, GFP_ATOMIC);
 		if (unlikely(!skb->next))
 			pr_warn("Failed to clone skb for next round if any\n");
-		WARN_ON(!refcount_inc_not_zero(&aead->refcnt));
 		break;
 	} while (++i < 3);
+
+done:
+	if (likely(aead))
+		WARN_ON(!refcount_inc_not_zero(&aead->refcnt));
 	spin_unlock(&tx->lock);
 
 	return aead;
@@ -1266,6 +1297,9 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
  * has changed, so the number of TX keys' users on this node are increased and
  * decreased correspondingly.
  *
+ * It also considers if peer has no key, then we need to make own master key
+ * (if any) taking over i.e. starting grace period.
+ *
  * The "per-peer" sndnxt is also reset when the peer key has switched.
  */
 static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
@@ -1276,11 +1310,23 @@ static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 	u32 self = tipc_own_addr(rx->net);
 	u8 cur, new;
 
-	/* Ensure this message is destined to us first */
+	/* Update RX 'key_master' flag according to peer, also mark "legacy" if
+	 * a peer has no master key.
+	 */
+	rx->key_master = ehdr->master_key;
+	if (!rx->key_master)
+		tx->legacy_user = 1;
+
+	/* For later cases, apply only if message is destined to this node */
 	if (!ehdr->destined || msg_short(hdr) || msg_destnode(hdr) != self)
 		return;
 
-	/* Peer RX active key has changed, let's update own TX users */
+	/* Case 1: Peer has no keys, let's make master key take over */
+	if (ehdr->rx_nokey)
+		/* Set or extend grace period */
+		tx->timer2 = jiffies;
+
+	/* Case 2: Peer RX active key has changed, let's update own TX users */
 	cur = atomic_read(&rx->peer_rx_active);
 	new = ehdr->rx_key_active;
 	if (tx->key.keys &&
@@ -1338,7 +1384,7 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 		return -ENOMEM;
 	}
 
-	c->working = 0;
+	c->flags = 0;
 	c->net = net;
 	c->node = node;
 	tipc_crypto_key_set_state(c, 0, 0, 0);
@@ -1473,6 +1519,12 @@ void tipc_crypto_timeout(struct tipc_crypto *rx)
 s5:
 	spin_unlock(&rx->lock);
 
+	/* Relax it here, the flag will be set again if it really is, but only
+	 * when we are not in grace period for safety!
+	 */
+	if (time_after(jiffies, tx->timer2 + TIPC_TX_GRACE_PERIOD))
+		tx->legacy_user = 0;
+
 	/* Limit max_tfms & do debug commands if needed */
 	if (likely(sysctl_tipc_max_tfms <= TIPC_MAX_TFMS_LIM))
 		return;
@@ -1482,6 +1534,22 @@ void tipc_crypto_timeout(struct tipc_crypto *rx)
 	tipc_crypto_do_cmd(rx->net, cmd);
 }
 
+static inline void tipc_crypto_clone_msg(struct net *net, struct sk_buff *_skb,
+					 struct tipc_bearer *b,
+					 struct tipc_media_addr *dst,
+					 struct tipc_node *__dnode, u8 type)
+{
+	struct sk_buff *skb;
+
+	skb = skb_clone(_skb, GFP_ATOMIC);
+	if (skb) {
+		TIPC_SKB_CB(skb)->xmit_type = type;
+		tipc_crypto_xmit(net, &skb, b, dst, __dnode);
+		if (skb)
+			b->media->send_msg(net, skb, b, dst);
+	}
+}
+
 /**
  * tipc_crypto_xmit - Build & encrypt TIPC message for xmit
  * @net: struct net
@@ -1491,7 +1559,8 @@ void tipc_crypto_timeout(struct tipc_crypto *rx)
  * @__dnode: destination node for reference if any
  *
  * First, build an encryption message header on the top of the message, then
- * encrypt the original TIPC message by using the active or pending TX key.
+ * encrypt the original TIPC message by using the pending, master or active
+ * key with this preference order.
  * If the encryption is successful, the encrypted skb is returned directly or
  * via the callback.
  * Otherwise, the skb is freed!
@@ -1514,46 +1583,63 @@ int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
 	struct tipc_msg *hdr = buf_msg(*skb);
 	struct tipc_key key = tx->key;
 	struct tipc_aead *aead = NULL;
-	struct sk_buff *_skb;
-	int rc = -ENOKEY;
 	u32 user = msg_user(hdr);
-	u8 tx_key;
+	u32 type = msg_type(hdr);
+	int rc = -ENOKEY;
+	u8 tx_key = 0;
 
 	/* No encryption? */
 	if (!tx->working)
 		return 0;
 
-	/* Try with the pending key if available and:
-	 * 1) This is the only choice (i.e. no active key) or;
-	 * 2) Peer has switched to this key (unicast only) or;
-	 * 3) It is time to do a pending key probe;
-	 */
+	/* Pending key if peer has active on it or probing time */
 	if (unlikely(key.pending)) {
 		tx_key = key.pending;
-		if (!key.active)
+		if (!tx->key_master && !key.active)
 			goto encrypt;
 		if (__rx && atomic_read(&__rx->peer_rx_active) == tx_key)
 			goto encrypt;
-		if (TIPC_SKB_CB(*skb)->probe) {
+		if (TIPC_SKB_CB(*skb)->xmit_type == SKB_PROBING) {
 			pr_debug("%s: probing for key[%d]\n", tx->name,
 				 key.pending);
 			goto encrypt;
 		}
-		if (user == LINK_CONFIG || user == LINK_PROTOCOL) {
-			_skb = skb_clone(*skb, GFP_ATOMIC);
-			if (_skb) {
-				TIPC_SKB_CB(_skb)->probe = 1;
-				tipc_crypto_xmit(net, &_skb, b, dst, __dnode);
-				if (_skb)
-					b->media->send_msg(net, _skb, b, dst);
+		if (user == LINK_CONFIG || user == LINK_PROTOCOL)
+			tipc_crypto_clone_msg(net, *skb, b, dst, __dnode,
+					      SKB_PROBING);
+	}
+
+	/* Master key if this is a *vital* message or in grace period */
+	if (tx->key_master) {
+		tx_key = KEY_MASTER;
+		if (!key.active)
+			goto encrypt;
+		if (TIPC_SKB_CB(*skb)->xmit_type == SKB_GRACING) {
+			pr_debug("%s: gracing for msg (%d %d)\n", tx->name,
+				 user, type);
+			goto encrypt;
+		}
+		if (user == LINK_CONFIG ||
+		    (user == LINK_PROTOCOL && type == RESET_MSG) ||
+		    time_before(jiffies, tx->timer2 + TIPC_TX_GRACE_PERIOD)) {
+			if (__rx && __rx->key_master &&
+			    !atomic_read(&__rx->peer_rx_active))
+				goto encrypt;
+			if (!__rx) {
+				if (likely(!tx->legacy_user))
+					goto encrypt;
+				tipc_crypto_clone_msg(net, *skb, b, dst,
+						      __dnode, SKB_GRACING);
 			}
 		}
 	}
+
 	/* Else, use the active key if any */
 	if (likely(key.active)) {
 		tx_key = key.active;
 		goto encrypt;
 	}
+
 	goto exit;
 
 encrypt:
@@ -1619,15 +1705,16 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 	struct tipc_aead *aead = NULL;
 	struct tipc_key key;
 	int rc = -ENOKEY;
-	u8 tx_key = 0;
+	u8 tx_key;
+
+	tx_key = ((struct tipc_ehdr *)(*skb)->data)->tx_key;
 
 	/* New peer?
 	 * Let's try with TX key (i.e. cluster mode) & verify the skb first!
 	 */
-	if (unlikely(!rx))
+	if (unlikely(!rx || tx_key == KEY_MASTER))
 		goto pick_tx;
 
-	tx_key = ((struct tipc_ehdr *)(*skb)->data)->tx_key;
 	/* Pick RX key according to TX key if any */
 	key = rx->key;
 	if (tx_key == key.active || tx_key == key.pending ||
@@ -1640,7 +1727,7 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 
 pick_tx:
 	/* No key suitable? Try to pick one from TX... */
-	aead = tipc_crypto_key_pick_tx(tx, rx, *skb);
+	aead = tipc_crypto_key_pick_tx(tx, rx, *skb, tx_key);
 	if (aead)
 		goto decrypt;
 	goto exit;
@@ -1722,9 +1809,12 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 				goto free_skb;
 		}
 
+		/* Ignore cloning if it was TX master key */
+		if (ehdr->tx_key == KEY_MASTER)
+			goto rcv;
 		if (tipc_aead_clone(&tmp, aead) < 0)
 			goto rcv;
-		if (tipc_crypto_key_attach(rx, tmp, ehdr->tx_key) < 0) {
+		if (tipc_crypto_key_attach(rx, tmp, ehdr->tx_key, false) < 0) {
 			tipc_aead_free(&tmp->rcu);
 			goto rcv;
 		}
@@ -1740,10 +1830,10 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 	/* Set the RX key's user */
 	tipc_aead_users_set(aead, 1);
 
-rcv:
 	/* Mark this point, RX works */
 	rx->timer1 = jiffies;
 
+rcv:
 	/* Remove ehdr & auth. tag prior to tipc_rcv() */
 	ehdr = (struct tipc_ehdr *)(*skb)->data;
 
@@ -1865,14 +1955,24 @@ static char *tipc_crypto_key_dump(struct tipc_crypto *c, char *buf)
 	char *s;
 
 	for (k = KEY_MIN; k <= KEY_MAX; k++) {
-		if (k == key.passive)
-			s = "PAS";
-		else if (k == key.active)
-			s = "ACT";
-		else if (k == key.pending)
-			s = "PEN";
-		else
-			s = "-";
+		if (k == KEY_MASTER) {
+			if (is_rx(c))
+				continue;
+			if (time_before(jiffies,
+					c->timer2 + TIPC_TX_GRACE_PERIOD))
+				s = "ACT";
+			else
+				s = "PAS";
+		} else {
+			if (k == key.passive)
+				s = "PAS";
+			else if (k == key.active)
+				s = "ACT";
+			else if (k == key.pending)
+				s = "PEN";
+			else
+				s = "-";
+		}
 		i += scnprintf(buf + i, 200 - i, "\tKey%d: %s", k, s);
 
 		rcu_read_lock();
@@ -1905,7 +2005,7 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 	/* Output format: "[%s %s %s] -> [%s %s %s]", max len = 32 */
 again:
 	i += scnprintf(buf + i, 32 - i, "[");
-	for (k = KEY_MIN; k <= KEY_MAX; k++) {
+	for (k = KEY_1; k <= KEY_3; k++) {
 		if (k == key->passive)
 			s = "pas";
 		else if (k == key->active)
@@ -1915,7 +2015,7 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 		else
 			s = "-";
 		i += scnprintf(buf + i, 32 - i,
-			       (k != KEY_MAX) ? "%s " : "%s", s);
+			       (k != KEY_3) ? "%s " : "%s", s);
 	}
 	if (key != &new) {
 		i += scnprintf(buf + i, 32 - i, "] -> ");
diff --git a/net/tipc/crypto.h b/net/tipc/crypto.h
index c387240e03d0..643b55077112 100644
--- a/net/tipc/crypto.h
+++ b/net/tipc/crypto.h
@@ -74,7 +74,7 @@ extern int sysctl_tipc_max_tfms __read_mostly;
  *     3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
  *     1 0 9 8 7 6 5 4|3 2 1 0 9 8 7 6|5 4 3 2 1 0 9 8|7 6 5 4 3 2 1 0
  *    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
- * w0:|Ver=7| User  |D|TX |RX |K|                 Rsvd                |
+ * w0:|Ver=7| User  |D|TX |RX |K|M|N|             Rsvd                |
  *    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  * w1:|                             Seqno                             |
  * w2:|                           (8 octets)                          |
@@ -101,6 +101,9 @@ extern int sysctl_tipc_max_tfms __read_mostly;
  *	RX	: Currently RX active key corresponding to the destination
  *	          node's TX key (when the "D" bit is set)
  *	K	: Keep-alive bit (for RPS, LINK_PROTOCOL/STATE_MSG only)
+ *	M       : Bit indicates if sender has master key
+ *	N	: Bit indicates if sender has no RX keys corresponding to the
+ *	          receiver's TX (when the "D" bit is set)
  *	Rsvd	: Reserved bit, field
  * Word1-2:
  *	Seqno	: The 64-bit sequence number of the encrypted message, also
@@ -117,7 +120,9 @@ struct tipc_ehdr {
 			__u8	destined:1,
 				user:4,
 				version:3;
-			__u8	reserved_1:3,
+			__u8	reserved_1:1,
+				rx_nokey:1,
+				master_key:1,
 				keepalive:1,
 				rx_key_active:2,
 				tx_key:2;
@@ -128,7 +133,9 @@ struct tipc_ehdr {
 			__u8	tx_key:2,
 				rx_key_active:2,
 				keepalive:1,
-				reserved_1:3;
+				master_key:1,
+				rx_nokey:1,
+				reserved_1:1;
 #else
 #error  "Please fix <asm/byteorder.h>"
 #endif
@@ -158,7 +165,7 @@ int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
 int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 		    struct sk_buff **skb, struct tipc_bearer *b);
 int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
-			 u8 mode);
+			 u8 mode, bool master_key);
 void tipc_crypto_key_flush(struct tipc_crypto *c);
 int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info);
 bool tipc_ehdr_validate(struct sk_buff *skb);
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 1016e96db5c4..25e5c5c8a6ff 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -127,7 +127,9 @@ struct tipc_skb_cb {
 #ifdef CONFIG_TIPC_CRYPTO
 			u8 encrypted:1;
 			u8 decrypted:1;
-			u8 probe:1;
+#define SKB_PROBING	1
+#define SKB_GRACING	2
+			u8 xmit_type:2;
 			u8 tx_clone_deferred:1;
 #endif
 		};
diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index c4aee6247d55..1ec00fcc26ee 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -108,6 +108,7 @@ const struct nla_policy tipc_nl_node_policy[TIPC_NLA_NODE_MAX + 1] = {
 					    .len = TIPC_NODEID_LEN},
 	[TIPC_NLA_NODE_KEY]		= { .type = NLA_BINARY,
 					    .len = TIPC_AEAD_KEY_SIZE_MAX},
+	[TIPC_NLA_NODE_KEY_MASTER]	= { .type = NLA_FLAG },
 };
 
 /* Properties valid for media, bearer and link */
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 70045630e6bb..5da94d1dda77 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2875,6 +2875,7 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 	struct tipc_crypto *tx = tipc_net(net)->crypto_tx, *c = tx;
 	struct tipc_node *n = NULL;
 	struct tipc_aead_key *ukey;
+	bool master_key = false;
 	u8 *id, *own_id, mode;
 	int rc = 0;
 
@@ -2905,6 +2906,7 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 	switch (rc) {
 	case -ENODATA:
 		mode = CLUSTER_KEY;
+		master_key = !!(attrs[TIPC_NLA_NODE_KEY_MASTER]);
 		break;
 	case 0:
 		mode = PER_NODE_KEY;
@@ -2921,11 +2923,11 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Initiate the TX/RX key */
-	rc = tipc_crypto_key_init(c, ukey, mode);
+	rc = tipc_crypto_key_init(c, ukey, mode, master_key);
 	if (n)
 		tipc_node_put(n);
 
-	if (rc < 0) {
+	if (unlikely(rc < 0)) {
 		GENL_SET_ERR_MSG(info, "unable to initiate or attach new key");
 		return rc;
 	}
-- 
2.26.2

