Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7911B2702D2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgIRRDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:03:54 -0400
Received: from mail-db8eur05on2126.outbound.protection.outlook.com ([40.107.20.126]:49377
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbgIRRDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:03:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Enx1Af+zn4fuEE7yBmQKwYrO6WUOG7TDzaEbqUyNn/O0jLafVvD7S9mcB1XvsWgaW4OU5aAT9womPuY8iMiui0f/bgWN61SFMDIIQZpE2Ormh/lJKXYxvfaWI52gGpSHU/wk6CSDj2VFEI2p/dljnrhY1mA2cRJw6tbxD61VtqOm9BRob3SNkRjXBwe511GJGC/Sf+clS8DTnVuaJmo7z/VygEWJ45+LcyMYoljzLMtOLrN2FbbuR1QxFTegTQ+uxfq8bzvBo2lV4YMIxzGagQgfvmbWzIwnBYeOftCRMjmbgfZWNwm6yRNT5XdJeS9qWDFir4OLFU1Dv6ucryMfzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4Zr0ude7vAaKzpYUyH+S+s7XmM7hY/Q01WNcpmaJ2U=;
 b=ZOBm3azLyX6NuhBHpLKIKVjrEsDdvYN/meIbrfiHbaH/J8v7aasGRRCFFvtNDgAxTp2o3KyJZfF5DDK79430ukbMjHwJdQMYnLnHnVcVFtdN4V1ovG8rH+QcKCGGrH1LLnqbKp/0qeMGEQFF5U12R518HnwWz7rvgoITJn+7TyGFgGRx8q3oMHBHC9htP/CLAp8wDXF8THJ5U5G0U+8U2ANabdse3QgbKVX88WLL/X/L1lNnlf8MYTwypbK1B8s7/0IipINSK8GDI7nVNhGhVMhVRhIAzUvedXXzgPiHyzLzjVQpwyHflNxrkyswg2ABi2OCMmND9dA1Rirxgi0ASg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4Zr0ude7vAaKzpYUyH+S+s7XmM7hY/Q01WNcpmaJ2U=;
 b=prbPJwSwhPG8+i0HlIZbGPkSW+ZwAq4eF2+kOoSY5MxD2WCr9+Al2PfrEDmLVuQr/3uR1l1bJnNtQViC8dDnqO4rdr5ieYh/asx+pRwnaqWrlSWkx0lNevDT124nSmJtDM7shQpQ97kPLyvBN1a7JGjL/YHWu60qk653cgpqL2g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR0502MB3827.eurprd05.prod.outlook.com (2603:10a6:208:1a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Fri, 18 Sep
 2020 17:03:06 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3391.015; Fri, 18 Sep 2020
 17:03:06 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net,
        kernel test robot <lkp@intel.com>
Subject: [net-next v3 3/4] tipc: add automatic session key exchange
Date:   Fri, 18 Sep 2020 08:17:28 +0700
Message-Id: <20200918011729.30146-4-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
References: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26)
 To AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Fri, 18 Sep 2020 17:03:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [113.20.114.51]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0522200-2cb5-444e-e201-08d85bf4b65a
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3827:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3827DE7136B8008555A92A96E23F0@AM0PR0502MB3827.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:158;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1wopF02WRVKkCPmv29haFQwvOTIrznmWOzIcLpKom1psHlwmlPRsSfOu0FltWRT1H4o0tjuF1/1P7B5l6osgF+1IzECQP1EFZ735c8+XMACj9JdQ1CrQKLGW3Ts4/A20q8/39TlYUm76e0lWq/8n8BK+OsWM6MmzCkE+yX8ZSbRGy/7UmAcA9/sPxbka9zAN7clc7c8JPa+oOnWRz2EQMugcn0FoEzSAOfr1RuD/iArinjEcCPgOquB4NysnU5O9DRMkx/cRxarHA3uxLCftJIFbhjOLaqymz9NZHXI+BtJo4ocHU37Mq0oYe0pkCBli
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(346002)(376002)(366004)(396003)(2906002)(103116003)(36756003)(7696005)(55016002)(26005)(4326008)(8936002)(52116002)(316002)(16526019)(956004)(478600001)(186003)(83380400001)(2616005)(1076003)(86362001)(6666004)(66946007)(30864003)(66556008)(8676002)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mtOYLCec5LGM5/7uUHlKzYDSA7SiOTh/WUP534nNGglijjdr+YZ/tjXfTLM0/6jcHp9GChPCGPKKoH/OsPKtLRTR/eninvurzQH5i2TT9u1HpgRcEVu69AxgVsOFbsfxO7CbfDCIDJUQGguIFzKmwCCDyZHhcYpJBIyCQTpdnpJiB3Q/NsjAO73h///7QZkFzCL2cqMi6x2Of89S/lSXkpmev8sYnpetgvDUKG0XjRkzER7tl+iRjEMmI9gXQP2Eu7ZXdOfdweKVjeCKrG8S8aA+h/4GKSQeNARCK94ccFtsGimpjIuCz3nkiaP4Zg8W46X/gv49YvPpUdSaaMIsRJoRmo2GdKrAOuxe9rWxo4PyuO2NAA4Y/A0MCtHr+X34jj/PeDeTvQ7EXWW1OHjt+8sdhOjUCITCemcH8crdoMwQggHIIwpjRxizEG9j0w2LYJsR83IxdxyTBUwKbjFqP5IM1P+GY2sMXDRK0eMdNHqyxXhRHwtsG58opgICL5Jci/JHe0g3t1aVjOH2ZwehRCBY4TPtRP7i+3LxZs4GCbvRA6Il08V42j7pFhyWoTODZNc3XFlrHZWXDuXzFCGvhjhFqUlGChPBsZZsIrLkKDpumTmKKsCcyxlRagybS3lyk9vXK+lgfKwVwnZNB0YOhQ==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: d0522200-2cb5-444e-e201-08d85bf4b65a
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 17:03:06.5509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ff4x2LlcZmNIRiA9ASCl8pIyG+rdIBtmCv+BU0mlL+DKFtjso6E00eTD9LvvByi/MI1V3osoYnPvlTduLpzrjzTfG1+8RkKKTxFNnGH0PSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With support from the master key option in the previous commit, it
becomes easy to make frequent updates/exchanges of session keys between
authenticated cluster nodes.
Basically, there are two situations where the key exchange will take in
place:

- When a new node joins the cluster (with the master key), it will need
  to get its peer's TX key, so that be able to decrypt further messages
  from that peer.

- When a new session key is generated (by either user manual setting or
  later automatic rekeying feature), the key will be distributed to all
  peer nodes in the cluster.

A key to be exchanged is encapsulated in the data part of a 'MSG_CRYPTO
/KEY_DISTR_MSG' TIPC v2 message, then xmit-ed as usual and encrypted by
using the master key before sending out. Upon receipt of the message it
will be decrypted in the same way as regular messages, then attached as
the sender's RX key in the receiver node.

In this way, the key exchange is reliable by the link layer, as well as
security, integrity and authenticity by the crypto layer.

Also, the forward security will be easily achieved by user changing the
master key actively but this should not be required very frequently.

The key exchange feature is independent on the presence of a master key
Note however that the master key still is needed for new nodes to be
able to join the cluster. It is also optional, and can be turned off/on
via the sysfs: 'net/tipc/key_exchange_enabled' [default 1: enabled].

Backward compatibility is guaranteed because for nodes that do not have
master key support, key exchange using master key ie. tx_key = 0 if any
will be shortly discarded at the message validation step. In other
words, the key exchange feature will be automatically disabled to those
nodes.

v2: fix the "implicit declaration of function 'tipc_crypto_key_flush'"
error in node.c. The function only exists when built with the TIPC
"CONFIG_TIPC_CRYPTO" option.

v3: use 'info->extack' for a message emitted due to netlink operations
instead (- David's comment).

Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/crypto.c | 364 +++++++++++++++++++++++++++++++++++++++++++---
 net/tipc/crypto.h |  24 +++
 net/tipc/link.c   |   5 +
 net/tipc/msg.h    |   4 +
 net/tipc/node.c   |  17 ++-
 net/tipc/node.h   |   2 +
 net/tipc/sysctl.c |   9 ++
 7 files changed, 405 insertions(+), 20 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 2510b82d3cc1..91d8b268cae0 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -37,6 +37,8 @@
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 #include "crypto.h"
+#include "msg.h"
+#include "bcast.h"
 
 #define TIPC_TX_GRACE_PERIOD	msecs_to_jiffies(5000) /* 5s */
 #define TIPC_TX_LASTING_TIME	msecs_to_jiffies(10000) /* 10s */
@@ -82,6 +84,8 @@ static const char *hstats[MAX_STATS] = {"ok", "nok", "async", "async_ok",
 
 /* Max TFMs number per key */
 int sysctl_tipc_max_tfms __read_mostly = TIPC_MAX_TFMS_DEF;
+/* Key exchange switch, default: on */
+int sysctl_tipc_key_exchange_enabled __read_mostly = 1;
 
 /**
  * struct tipc_key - TIPC keys' status indicator
@@ -133,6 +137,8 @@ struct tipc_tfm {
  * @mode: crypto mode is applied to the key
  * @hint[]: a hint for user key
  * @rcu: struct rcu_head
+ * @key: the aead key
+ * @gen: the key's generation
  * @seqno: the key seqno (cluster scope)
  * @refcnt: the key reference counter
  */
@@ -147,6 +153,8 @@ struct tipc_aead {
 	u8 mode;
 	char hint[2 * TIPC_AEAD_HINT_LEN + 1];
 	struct rcu_head rcu;
+	struct tipc_aead_key *key;
+	u16 gen;
 
 	atomic64_t seqno ____cacheline_aligned;
 	refcount_t refcnt ____cacheline_aligned;
@@ -166,7 +174,13 @@ struct tipc_crypto_stats {
  * @node: TIPC node (RX)
  * @aead: array of pointers to AEAD keys for encryption/decryption
  * @peer_rx_active: replicated peer RX active key index
+ * @key_gen: TX/RX key generation
  * @key: the key states
+ * @skey_mode: session key's mode
+ * @skey: received session key
+ * @wq: common workqueue on TX crypto
+ * @work: delayed work sched for TX/RX
+ * @key_distr: key distributing state
  * @stats: the crypto statistics
  * @name: the crypto name
  * @sndnxt: the per-peer sndnxt (TX)
@@ -175,6 +189,7 @@ struct tipc_crypto_stats {
  * @working: the crypto is working or not
  * @key_master: flag indicates if master key exists
  * @legacy_user: flag indicates if a peer joins w/o master key (for bwd comp.)
+ * @nokey: no key indication
  * @lock: tipc_key lock
  */
 struct tipc_crypto {
@@ -182,7 +197,16 @@ struct tipc_crypto {
 	struct tipc_node *node;
 	struct tipc_aead __rcu *aead[KEY_MAX + 1];
 	atomic_t peer_rx_active;
+	u16 key_gen;
 	struct tipc_key key;
+	u8 skey_mode;
+	struct tipc_aead_key *skey;
+	struct workqueue_struct *wq;
+	struct delayed_work work;
+#define KEY_DISTR_SCHED		1
+#define KEY_DISTR_COMPL		2
+	atomic_t key_distr;
+
 	struct tipc_crypto_stats __percpu *stats;
 	char name[48];
 
@@ -194,6 +218,7 @@ struct tipc_crypto {
 			u8 working:1;
 			u8 key_master:1;
 			u8 legacy_user:1;
+			u8 nokey: 1;
 		};
 		u8 flags;
 	};
@@ -266,6 +291,11 @@ static void tipc_crypto_do_cmd(struct net *net, int cmd);
 static char *tipc_crypto_key_dump(struct tipc_crypto *c, char *buf);
 static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 				  char *buf);
+static int tipc_crypto_key_xmit(struct net *net, struct tipc_aead_key *skey,
+				u16 gen, u8 mode, u32 dnode);
+static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr);
+static void tipc_crypto_work_rx(struct work_struct *work);
+
 #define is_tx(crypto) (!(crypto)->node)
 #define is_rx(crypto) (!is_tx(crypto))
 
@@ -360,6 +390,7 @@ static void tipc_aead_free(struct rcu_head *rp)
 		kfree(head);
 	}
 	free_percpu(aead->tfm_entry);
+	kzfree(aead->key);
 	kfree(aead);
 }
 
@@ -530,6 +561,7 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 	tmp->mode = mode;
 	tmp->cloned = NULL;
 	tmp->authsize = TIPC_AES_GCM_TAG_SIZE;
+	tmp->key = kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
 	memcpy(&tmp->salt, ukey->key + keylen, TIPC_AES_GCM_SALT_SIZE);
 	atomic_set(&tmp->users, 0);
 	atomic64_set(&tmp->seqno, 0);
@@ -1011,7 +1043,7 @@ static int tipc_ehdr_build(struct net *net, struct tipc_aead *aead,
 	ehdr->tx_key = tx_key;
 	ehdr->destined = (__rx) ? 1 : 0;
 	ehdr->rx_key_active = (__rx) ? __rx->key.active : 0;
-	ehdr->rx_nokey = (__rx) ? !__rx->key.keys : 0;
+	ehdr->rx_nokey = (__rx) ? __rx->nokey : 0;
 	ehdr->master_key = aead->crypto->key_master;
 	ehdr->reserved_1 = 0;
 	ehdr->reserved_2 = 0;
@@ -1130,11 +1162,13 @@ static int tipc_crypto_key_attach(struct tipc_crypto *c,
 
 attach:
 	aead->crypto = c;
+	aead->gen = (is_tx(c)) ? ++c->key_gen : c->key_gen;
 	tipc_aead_rcu_replace(c->aead[new_key], aead, &c->lock);
 	if (likely(c->key.keys != key.keys))
 		tipc_crypto_key_set_state(c, key.passive, key.active,
 					  key.pending);
 	c->working = 1;
+	c->nokey = 0;
 	c->key_master |= master_key;
 	rc = new_key;
 
@@ -1145,14 +1179,33 @@ static int tipc_crypto_key_attach(struct tipc_crypto *c,
 
 void tipc_crypto_key_flush(struct tipc_crypto *c)
 {
+	struct tipc_crypto *tx, *rx;
 	int k;
 
 	spin_lock_bh(&c->lock);
+	if (is_rx(c)) {
+		/* Try to cancel pending work */
+		rx = c;
+		tx = tipc_net(rx->net)->crypto_tx;
+		if (cancel_delayed_work(&rx->work)) {
+			kfree(rx->skey);
+			rx->skey = NULL;
+			atomic_xchg(&rx->key_distr, 0);
+			tipc_node_put(rx->node);
+		}
+		/* RX stopping => decrease TX key users if any */
+		k = atomic_xchg(&rx->peer_rx_active, 0);
+		if (k) {
+			tipc_aead_users_dec(tx->aead[k], 0);
+			/* Mark the point TX key users changed */
+			tx->timer1 = jiffies;
+		}
+	}
+
 	c->flags = 0;
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	for (k = KEY_MIN; k <= KEY_MAX; k++)
 		tipc_crypto_key_detach(c->aead[k], &c->lock);
-	atomic_set(&c->peer_rx_active, 0);
 	atomic64_set(&c->sndnxt, 0);
 	spin_unlock_bh(&c->lock);
 }
@@ -1298,7 +1351,8 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
  * decreased correspondingly.
  *
  * It also considers if peer has no key, then we need to make own master key
- * (if any) taking over i.e. starting grace period.
+ * (if any) taking over i.e. starting grace period and also trigger key
+ * distributing process.
  *
  * The "per-peer" sndnxt is also reset when the peer key has switched.
  */
@@ -1309,6 +1363,7 @@ static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 	struct tipc_msg *hdr = buf_msg(skb);
 	u32 self = tipc_own_addr(rx->net);
 	u8 cur, new;
+	unsigned long delay;
 
 	/* Update RX 'key_master' flag according to peer, also mark "legacy" if
 	 * a peer has no master key.
@@ -1322,9 +1377,22 @@ static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 		return;
 
 	/* Case 1: Peer has no keys, let's make master key take over */
-	if (ehdr->rx_nokey)
+	if (ehdr->rx_nokey) {
 		/* Set or extend grace period */
 		tx->timer2 = jiffies;
+		/* Schedule key distributing for the peer if not yet */
+		if (tx->key.keys &&
+		    !atomic_cmpxchg(&rx->key_distr, 0, KEY_DISTR_SCHED)) {
+			get_random_bytes(&delay, 2);
+			delay %= 5;
+			delay = msecs_to_jiffies(500 * ++delay);
+			if (queue_delayed_work(tx->wq, &rx->work, delay))
+				tipc_node_get(rx->node);
+		}
+	} else {
+		/* Cancel a pending key distributing if any */
+		atomic_xchg(&rx->key_distr, 0);
+	}
 
 	/* Case 2: Peer RX active key has changed, let's update own TX users */
 	cur = atomic_read(&rx->peer_rx_active);
@@ -1377,6 +1445,15 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	if (!c)
 		return -ENOMEM;
 
+	/* Allocate workqueue on TX */
+	if (!node) {
+		c->wq = alloc_ordered_workqueue("tipc_crypto", 0);
+		if (!c->wq) {
+			kfree(c);
+			return -ENOMEM;
+		}
+	}
+
 	/* Allocate statistic structure */
 	c->stats = alloc_percpu_gfp(struct tipc_crypto_stats, GFP_ATOMIC);
 	if (!c->stats) {
@@ -1387,7 +1464,9 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	c->flags = 0;
 	c->net = net;
 	c->node = node;
+	get_random_bytes(&c->key_gen, 2);
 	tipc_crypto_key_set_state(c, 0, 0, 0);
+	atomic_set(&c->key_distr, 0);
 	atomic_set(&c->peer_rx_active, 0);
 	atomic64_set(&c->sndnxt, 0);
 	c->timer1 = jiffies;
@@ -1397,32 +1476,27 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 		  (is_rx(c)) ? tipc_node_get_id_str(c->node) :
 			       tipc_own_id_string(c->net));
 
+	if (is_rx(c))
+		INIT_DELAYED_WORK(&c->work, tipc_crypto_work_rx);
+
 	*crypto = c;
 	return 0;
 }
 
 void tipc_crypto_stop(struct tipc_crypto **crypto)
 {
-	struct tipc_crypto *c = *crypto, *tx, *rx;
+	struct tipc_crypto *c = *crypto;
 	u8 k;
 
 	if (!c)
 		return;
 
-	rcu_read_lock();
-	/* RX stopping? => decrease TX key users if any */
-	if (is_rx(c)) {
-		rx = c;
-		tx = tipc_net(rx->net)->crypto_tx;
-		k = atomic_read(&rx->peer_rx_active);
-		if (k) {
-			tipc_aead_users_dec(tx->aead[k], 0);
-			/* Mark the point TX key users changed */
-			tx->timer1 = jiffies;
-		}
-	}
+	/* Flush any queued works & destroy wq */
+	if (is_tx(c))
+		destroy_workqueue(c->wq);
 
 	/* Release AEAD keys */
+	rcu_read_lock();
 	for (k = KEY_MIN; k <= KEY_MAX; k++)
 		tipc_aead_put(rcu_dereference(c->aead[k]));
 	rcu_read_unlock();
@@ -1621,6 +1695,7 @@ int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
 		}
 		if (user == LINK_CONFIG ||
 		    (user == LINK_PROTOCOL && type == RESET_MSG) ||
+		    (user == MSG_CRYPTO && type == KEY_DISTR_MSG) ||
 		    time_before(jiffies, tx->timer2 + TIPC_TX_GRACE_PERIOD)) {
 			if (__rx && __rx->key_master &&
 			    !atomic_read(&__rx->peer_rx_active))
@@ -1705,7 +1780,7 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 	struct tipc_aead *aead = NULL;
 	struct tipc_key key;
 	int rc = -ENOKEY;
-	u8 tx_key;
+	u8 tx_key, n;
 
 	tx_key = ((struct tipc_ehdr *)(*skb)->data)->tx_key;
 
@@ -1755,8 +1830,19 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 		if (rc == -ENOKEY) {
 			kfree_skb(*skb);
 			*skb = NULL;
-			if (rx)
+			if (rx) {
+				/* Mark rx->nokey only if we dont have a
+				 * pending received session key, nor a newer
+				 * one i.e. in the next slot.
+				 */
+				n = key_next(tx_key);
+				rx->nokey = !(rx->skey ||
+					      rcu_access_pointer(rx->aead[n]));
+				pr_debug_ratelimited("%s: nokey %d, key %d/%x\n",
+						     rx->name, rx->nokey,
+						     tx_key, rx->key.keys);
 				tipc_node_put(rx->node);
+			}
 			this_cpu_inc(stats->stat[STAT_NOKEYS]);
 			return rc;
 		} else if (rc == -EBADMSG) {
@@ -2025,3 +2111,243 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 	i += scnprintf(buf + i, 32 - i, "]");
 	return buf;
 }
+
+/**
+ * tipc_crypto_msg_rcv - Common 'MSG_CRYPTO' processing point
+ * @net: the struct net
+ * @skb: the receiving message buffer
+ */
+void tipc_crypto_msg_rcv(struct net *net, struct sk_buff *skb)
+{
+	struct tipc_crypto *rx;
+	struct tipc_msg *hdr;
+
+	if (unlikely(skb_linearize(skb)))
+		goto exit;
+
+	hdr = buf_msg(skb);
+	rx = tipc_node_crypto_rx_by_addr(net, msg_prevnode(hdr));
+	if (unlikely(!rx))
+		goto exit;
+
+	switch (msg_type(hdr)) {
+	case KEY_DISTR_MSG:
+		if (tipc_crypto_key_rcv(rx, hdr))
+			goto exit;
+		break;
+	default:
+		break;
+	}
+
+	tipc_node_put(rx->node);
+
+exit:
+	kfree_skb(skb);
+}
+
+/**
+ * tipc_crypto_key_distr - Distribute a TX key
+ * @tx: the TX crypto
+ * @key: the key's index
+ * @dest: the destination tipc node, = NULL if distributing to all nodes
+ *
+ * Return: 0 in case of success, otherwise < 0
+ */
+int tipc_crypto_key_distr(struct tipc_crypto *tx, u8 key,
+			  struct tipc_node *dest)
+{
+	struct tipc_aead *aead;
+	u32 dnode = tipc_node_get_addr(dest);
+	int rc = -ENOKEY;
+
+	if (!sysctl_tipc_key_exchange_enabled)
+		return 0;
+
+	if (key) {
+		rcu_read_lock();
+		aead = tipc_aead_get(tx->aead[key]);
+		if (likely(aead)) {
+			rc = tipc_crypto_key_xmit(tx->net, aead->key,
+						  aead->gen, aead->mode,
+						  dnode);
+			tipc_aead_put(aead);
+		}
+		rcu_read_unlock();
+	}
+
+	return rc;
+}
+
+/**
+ * tipc_crypto_key_xmit - Send a session key
+ * @net: the struct net
+ * @skey: the session key to be sent
+ * @gen: the key's generation
+ * @mode: the key's mode
+ * @dnode: the destination node address, = 0 if broadcasting to all nodes
+ *
+ * The session key 'skey' is packed in a TIPC v2 'MSG_CRYPTO/KEY_DISTR_MSG'
+ * as its data section, then xmit-ed through the uc/bc link.
+ *
+ * Return: 0 in case of success, otherwise < 0
+ */
+static int tipc_crypto_key_xmit(struct net *net, struct tipc_aead_key *skey,
+				u16 gen, u8 mode, u32 dnode)
+{
+	struct sk_buff_head pkts;
+	struct tipc_msg *hdr;
+	struct sk_buff *skb;
+	u16 size, cong_link_cnt;
+	u8 *data;
+	int rc;
+
+	size = tipc_aead_key_size(skey);
+	skb = tipc_buf_acquire(INT_H_SIZE + size, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	hdr = buf_msg(skb);
+	tipc_msg_init(tipc_own_addr(net), hdr, MSG_CRYPTO, KEY_DISTR_MSG,
+		      INT_H_SIZE, dnode);
+	msg_set_size(hdr, INT_H_SIZE + size);
+	msg_set_key_gen(hdr, gen);
+	msg_set_key_mode(hdr, mode);
+
+	data = msg_data(hdr);
+	*((__be32 *)(data + TIPC_AEAD_ALG_NAME)) = htonl(skey->keylen);
+	memcpy(data, skey->alg_name, TIPC_AEAD_ALG_NAME);
+	memcpy(data + TIPC_AEAD_ALG_NAME + sizeof(__be32), skey->key,
+	       skey->keylen);
+
+	__skb_queue_head_init(&pkts);
+	__skb_queue_tail(&pkts, skb);
+	if (dnode)
+		rc = tipc_node_xmit(net, &pkts, dnode, 0);
+	else
+		rc = tipc_bcast_xmit(net, &pkts, &cong_link_cnt);
+
+	return rc;
+}
+
+/**
+ * tipc_crypto_key_rcv - Receive a session key
+ * @rx: the RX crypto
+ * @hdr: the TIPC v2 message incl. the receiving session key in its data
+ *
+ * This function retrieves the session key in the message from peer, then
+ * schedules a RX work to attach the key to the corresponding RX crypto.
+ *
+ * Return: "true" if the key has been scheduled for attaching, otherwise
+ * "false".
+ */
+static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
+{
+	struct tipc_crypto *tx = tipc_net(rx->net)->crypto_tx;
+	struct tipc_aead_key *skey = NULL;
+	u16 key_gen = msg_key_gen(hdr);
+	u16 size = msg_data_sz(hdr);
+	u8 *data = msg_data(hdr);
+
+	spin_lock(&rx->lock);
+	if (unlikely(rx->skey || (key_gen == rx->key_gen && rx->key.keys))) {
+		pr_err("%s: key existed <%p>, gen %d vs %d\n", rx->name,
+		       rx->skey, key_gen, rx->key_gen);
+		goto exit;
+	}
+
+	/* Allocate memory for the key */
+	skey = kmalloc(size, GFP_ATOMIC);
+	if (unlikely(!skey)) {
+		pr_err("%s: unable to allocate memory for skey\n", rx->name);
+		goto exit;
+	}
+
+	/* Copy key from msg data */
+	skey->keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
+	memcpy(skey->alg_name, data, TIPC_AEAD_ALG_NAME);
+	memcpy(skey->key, data + TIPC_AEAD_ALG_NAME + sizeof(__be32),
+	       skey->keylen);
+
+	/* Sanity check */
+	if (unlikely(size != tipc_aead_key_size(skey))) {
+		kfree(skey);
+		skey = NULL;
+		goto exit;
+	}
+
+	rx->key_gen = key_gen;
+	rx->skey_mode = msg_key_mode(hdr);
+	rx->skey = skey;
+	rx->nokey = 0;
+	mb(); /* for nokey flag */
+
+exit:
+	spin_unlock(&rx->lock);
+
+	/* Schedule the key attaching on this crypto */
+	if (likely(skey && queue_delayed_work(tx->wq, &rx->work, 0)))
+		return true;
+
+	return false;
+}
+
+/**
+ * tipc_crypto_work_rx - Scheduled RX works handler
+ * @work: the struct RX work
+ *
+ * The function processes the previous scheduled works i.e. distributing TX key
+ * or attaching a received session key on RX crypto.
+ */
+static void tipc_crypto_work_rx(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct tipc_crypto *rx = container_of(dwork, struct tipc_crypto, work);
+	struct tipc_crypto *tx = tipc_net(rx->net)->crypto_tx;
+	unsigned long delay = msecs_to_jiffies(5000);
+	bool resched = false;
+	u8 key;
+	int rc;
+
+	/* Case 1: Distribute TX key to peer if scheduled */
+	if (atomic_cmpxchg(&rx->key_distr,
+			   KEY_DISTR_SCHED,
+			   KEY_DISTR_COMPL) == KEY_DISTR_SCHED) {
+		/* Always pick the newest one for distributing */
+		key = tx->key.pending ?: tx->key.active;
+		rc = tipc_crypto_key_distr(tx, key, rx->node);
+		if (unlikely(rc))
+			pr_warn("%s: unable to distr key[%d] to %s, err %d\n",
+				tx->name, key, tipc_node_get_id_str(rx->node),
+				rc);
+
+		/* Sched for key_distr releasing */
+		resched = true;
+	} else {
+		atomic_cmpxchg(&rx->key_distr, KEY_DISTR_COMPL, 0);
+	}
+
+	/* Case 2: Attach a pending received session key from peer if any */
+	if (rx->skey) {
+		rc = tipc_crypto_key_init(rx, rx->skey, rx->skey_mode, false);
+		if (unlikely(rc < 0))
+			pr_warn("%s: unable to attach received skey, err %d\n",
+				rx->name, rc);
+		switch (rc) {
+		case -EBUSY:
+		case -ENOMEM:
+			/* Resched the key attaching */
+			resched = true;
+			break;
+		default:
+			synchronize_rcu();
+			kfree(rx->skey);
+			rx->skey = NULL;
+			break;
+		}
+	}
+
+	if (resched && queue_delayed_work(tx->wq, &rx->work, delay))
+		return;
+
+	tipc_node_put(rx->node);
+}
diff --git a/net/tipc/crypto.h b/net/tipc/crypto.h
index 643b55077112..b2a9c9b90684 100644
--- a/net/tipc/crypto.h
+++ b/net/tipc/crypto.h
@@ -67,6 +67,7 @@ enum {
 };
 
 extern int sysctl_tipc_max_tfms __read_mostly;
+extern int sysctl_tipc_key_exchange_enabled __read_mostly;
 
 /**
  * TIPC encryption message format:
@@ -167,8 +168,31 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 int tipc_crypto_key_init(struct tipc_crypto *c, struct tipc_aead_key *ukey,
 			 u8 mode, bool master_key);
 void tipc_crypto_key_flush(struct tipc_crypto *c);
+int tipc_crypto_key_distr(struct tipc_crypto *tx, u8 key,
+			  struct tipc_node *dest);
+void tipc_crypto_msg_rcv(struct net *net, struct sk_buff *skb);
 int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info);
 bool tipc_ehdr_validate(struct sk_buff *skb);
 
+static inline u32 msg_key_gen(struct tipc_msg *m)
+{
+	return msg_bits(m, 4, 16, 0xffff);
+}
+
+static inline void msg_set_key_gen(struct tipc_msg *m, u32 gen)
+{
+	msg_set_bits(m, 4, 16, 0xffff, gen);
+}
+
+static inline u32 msg_key_mode(struct tipc_msg *m)
+{
+	return msg_bits(m, 4, 0, 0xf);
+}
+
+static inline void msg_set_key_mode(struct tipc_msg *m, u32 mode)
+{
+	msg_set_bits(m, 4, 0, 0xf, mode);
+}
+
 #endif /* _TIPC_CRYPTO_H */
 #endif
diff --git a/net/tipc/link.c b/net/tipc/link.c
index a2989f22ebb6..97dc4b5fb20b 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1250,6 +1250,11 @@ static bool tipc_data_input(struct tipc_link *l, struct sk_buff *skb,
 	case MSG_FRAGMENTER:
 	case BCAST_PROTOCOL:
 		return false;
+#ifdef CONFIG_TIPC_CRYPTO
+	case MSG_CRYPTO:
+		tipc_crypto_msg_rcv(l->net, skb);
+		return true;
+#endif
 	default:
 		pr_warn("Dropping received illegal msg type\n");
 		kfree_skb(skb);
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 25e5c5c8a6ff..5d64596ba987 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -82,6 +82,7 @@ struct plist;
 #define  NAME_DISTRIBUTOR     11
 #define  MSG_FRAGMENTER       12
 #define  LINK_CONFIG          13
+#define  MSG_CRYPTO           14
 #define  SOCK_WAKEUP          14       /* pseudo user */
 #define  TOP_SRV              15       /* pseudo user */
 
@@ -749,6 +750,9 @@ static inline void msg_set_nameupper(struct tipc_msg *m, u32 n)
 #define GRP_RECLAIM_MSG      4
 #define GRP_REMIT_MSG        5
 
+/* Crypto message types */
+#define KEY_DISTR_MSG		0
+
 /*
  * Word 1
  */
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 5da94d1dda77..c9b6042e32b5 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -278,6 +278,14 @@ struct tipc_crypto *tipc_node_crypto_rx_by_list(struct list_head *pos)
 {
 	return container_of(pos, struct tipc_node, list)->crypto_rx;
 }
+
+struct tipc_crypto *tipc_node_crypto_rx_by_addr(struct net *net, u32 addr)
+{
+	struct tipc_node *n;
+
+	n = tipc_node_find(net, addr);
+	return (n) ? n->crypto_rx : NULL;
+}
 #endif
 
 static void tipc_node_free(struct rcu_head *rp)
@@ -303,7 +311,7 @@ void tipc_node_put(struct tipc_node *node)
 	kref_put(&node->kref, tipc_node_kref_release);
 }
 
-static void tipc_node_get(struct tipc_node *node)
+void tipc_node_get(struct tipc_node *node)
 {
 	kref_get(&node->kref);
 }
@@ -584,6 +592,9 @@ static void tipc_node_calculate_timer(struct tipc_node *n, struct tipc_link *l)
 
 static void tipc_node_delete_from_list(struct tipc_node *node)
 {
+#ifdef CONFIG_TIPC_CRYPTO
+	tipc_crypto_key_flush(node->crypto_rx);
+#endif
 	list_del_rcu(&node->list);
 	hlist_del_rcu(&node->hash);
 	tipc_node_put(node);
@@ -2930,6 +2941,10 @@ static int __tipc_nl_node_set_key(struct sk_buff *skb, struct genl_info *info)
 	if (unlikely(rc < 0)) {
 		GENL_SET_ERR_MSG(info, "unable to initiate or attach new key");
 		return rc;
+	} else if (c == tx) {
+		/* Distribute TX key but not master one */
+		if (!master_key && tipc_crypto_key_distr(tx, rc, NULL))
+			GENL_SET_ERR_MSG(info, "failed to replicate new key");
 	}
 
 	return 0;
diff --git a/net/tipc/node.h b/net/tipc/node.h
index 9f6f13f1604f..154a5bbb0d29 100644
--- a/net/tipc/node.h
+++ b/net/tipc/node.h
@@ -79,12 +79,14 @@ bool tipc_node_get_id(struct net *net, u32 addr, u8 *id);
 u32 tipc_node_get_addr(struct tipc_node *node);
 char *tipc_node_get_id_str(struct tipc_node *node);
 void tipc_node_put(struct tipc_node *node);
+void tipc_node_get(struct tipc_node *node);
 struct tipc_node *tipc_node_create(struct net *net, u32 addr, u8 *peer_id,
 				   u16 capabilities, u32 hash_mixes,
 				   bool preliminary);
 #ifdef CONFIG_TIPC_CRYPTO
 struct tipc_crypto *tipc_node_crypto_rx(struct tipc_node *__n);
 struct tipc_crypto *tipc_node_crypto_rx_by_list(struct list_head *pos);
+struct tipc_crypto *tipc_node_crypto_rx_by_addr(struct net *net, u32 addr);
 #endif
 u32 tipc_node_try_addr(struct net *net, u8 *id, u32 addr);
 void tipc_node_check_dest(struct net *net, u32 onode, u8 *peer_id128,
diff --git a/net/tipc/sysctl.c b/net/tipc/sysctl.c
index 97a6264a2993..9fb65c988f7f 100644
--- a/net/tipc/sysctl.c
+++ b/net/tipc/sysctl.c
@@ -74,6 +74,15 @@ static struct ctl_table tipc_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1         = SYSCTL_ONE,
 	},
+	{
+		.procname	= "key_exchange_enabled",
+		.data		= &sysctl_tipc_key_exchange_enabled,
+		.maxlen		= sizeof(sysctl_tipc_key_exchange_enabled),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
 #endif
 	{
 		.procname	= "bc_retruni",
-- 
2.26.2

