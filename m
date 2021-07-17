Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6233CC27A
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 12:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhGQKVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 06:21:10 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:44860
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S232942AbhGQKU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 06:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=bbBWRmvP5ym/xXm3w2T9Gmj6e8oJLxtKTwk1h23bysA=; b=I
        iMvouwF6D7bt44ME4A0NcvR4zJ1x2oXk9i6jJQ/3zMgYG1Jnh2JmdKWhBpTnWIMv
        GKKNHrvz0p1dClp7f2QpzUoO3BH9EGUtUhIJfwwok68YF+Zk3xZSXAjyuv9fO+oN
        I0q6zzGpsM2+6rm5ZJkIjJSfmzxjAE26n6STBi+6Jc=
Received: from localhost.localdomain (unknown [39.144.44.130])
        by app2 (Coremail) with SMTP id XQUFCgDHzycdrvJgerrYBA--.38232S3;
        Sat, 17 Jul 2021 18:17:02 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] cxgb4: Convert from atomic_t to refcount_t on l2t_entry->refcnt
Date:   Sat, 17 Jul 2021 18:16:54 +0800
Message-Id: <1626517014-42631-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgDHzycdrvJgerrYBA--.38232S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WF15Kw1xXw47XrW7Jw48Crg_yoW7Kr4UpF
        sIka4kurWrGF4xX3yDtw4kZryavw10v345GrW3G3savryav3y3G3W0gFWUAry5AF4kWF4a
        yrsF9rW5CF1DtrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW8JVW3JwCI42IY6I8E
        87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
        IFyTuYvjfUosqXDUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/l2t.c | 31 ++++++++++++++++---------------
 drivers/net/ethernet/chelsio/cxgb4/l2t.h |  3 ++-
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index a10a6862a9a4..cb26a5e315b1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -69,7 +69,8 @@ static inline unsigned int vlan_prio(const struct l2t_entry *e)
 
 static inline void l2t_hold(struct l2t_data *d, struct l2t_entry *e)
 {
-	if (atomic_add_return(1, &e->refcnt) == 1)  /* 0 -> 1 transition */
+	refcount_inc(&e->refcnt);
+	if (refcount_read(&e->refcnt) == 1)  /* 0 -> 1 transition */
 		atomic_dec(&d->nfree);
 }
 
@@ -270,10 +271,10 @@ static struct l2t_entry *alloc_l2e(struct l2t_data *d)
 
 	/* there's definitely a free entry */
 	for (e = d->rover, end = &d->l2tab[d->l2t_size]; e != end; ++e)
-		if (atomic_read(&e->refcnt) == 0)
+		if (refcount_read(&e->refcnt) == 0)
 			goto found;
 
-	for (e = d->l2tab; atomic_read(&e->refcnt); ++e)
+	for (e = d->l2tab; refcount_read(&e->refcnt); ++e)
 		;
 found:
 	d->rover = e + 1;
@@ -302,7 +303,7 @@ static struct l2t_entry *find_or_alloc_l2e(struct l2t_data *d, u16 vlan,
 	struct l2t_entry *first_free = NULL;
 
 	for (e = &d->l2tab[0], end = &d->l2tab[d->l2t_size]; e != end; ++e) {
-		if (atomic_read(&e->refcnt) == 0) {
+		if (refcount_read(&e->refcnt) == 0) {
 			if (!first_free)
 				first_free = e;
 		} else {
@@ -352,7 +353,7 @@ static void _t4_l2e_free(struct l2t_entry *e)
 {
 	struct l2t_data *d;
 
-	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
+	if (refcount_read(&e->refcnt) == 0) {  /* hasn't been recycled */
 		if (e->neigh) {
 			neigh_release(e->neigh);
 			e->neigh = NULL;
@@ -370,7 +371,7 @@ static void t4_l2e_free(struct l2t_entry *e)
 	struct l2t_data *d;
 
 	spin_lock_bh(&e->lock);
-	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
+	if (refcount_read(&e->refcnt) == 0) {  /* hasn't been recycled */
 		if (e->neigh) {
 			neigh_release(e->neigh);
 			e->neigh = NULL;
@@ -385,7 +386,7 @@ static void t4_l2e_free(struct l2t_entry *e)
 
 void cxgb4_l2t_release(struct l2t_entry *e)
 {
-	if (atomic_dec_and_test(&e->refcnt))
+	if (refcount_dec_and_test(&e->refcnt))
 		t4_l2e_free(e);
 }
 EXPORT_SYMBOL(cxgb4_l2t_release);
@@ -441,7 +442,7 @@ struct l2t_entry *cxgb4_l2t_get(struct l2t_data *d, struct neighbour *neigh,
 		if (!addreq(e, addr) && e->ifindex == ifidx &&
 		    e->vlan == vlan && e->lport == lport) {
 			l2t_hold(d, e);
-			if (atomic_read(&e->refcnt) == 1)
+			if (refcount_read(&e->refcnt) == 1)
 				reuse_entry(e, neigh);
 			goto done;
 		}
@@ -458,7 +459,7 @@ struct l2t_entry *cxgb4_l2t_get(struct l2t_data *d, struct neighbour *neigh,
 		e->hash = hash;
 		e->lport = lport;
 		e->v6 = addr_len == 16;
-		atomic_set(&e->refcnt, 1);
+		refcount_set(&e->refcnt, 1);
 		neigh_replace(e, neigh);
 		e->vlan = vlan;
 		e->next = d->l2tab[hash].first;
@@ -520,7 +521,7 @@ void t4_l2t_update(struct adapter *adap, struct neighbour *neigh)
 	for (e = d->l2tab[hash].first; e; e = e->next)
 		if (!addreq(e, addr) && e->ifindex == ifidx) {
 			spin_lock(&e->lock);
-			if (atomic_read(&e->refcnt))
+			if (refcount_read(&e->refcnt))
 				goto found;
 			spin_unlock(&e->lock);
 			break;
@@ -585,12 +586,12 @@ struct l2t_entry *t4_l2t_alloc_switching(struct adapter *adap, u16 vlan,
 	e = find_or_alloc_l2e(d, vlan, port, eth_addr);
 	if (e) {
 		spin_lock(&e->lock);          /* avoid race with t4_l2t_free */
-		if (!atomic_read(&e->refcnt)) {
+		if (!refcount_read(&e->refcnt)) {
 			e->state = L2T_STATE_SWITCHING;
 			e->vlan = vlan;
 			e->lport = port;
 			ether_addr_copy(e->dmac, eth_addr);
-			atomic_set(&e->refcnt, 1);
+			refcount_set(&e->refcnt, 1);
 			ret = write_l2e(adap, e, 0);
 			if (ret < 0) {
 				_t4_l2e_free(e);
@@ -599,7 +600,7 @@ struct l2t_entry *t4_l2t_alloc_switching(struct adapter *adap, u16 vlan,
 				return NULL;
 			}
 		} else {
-			atomic_inc(&e->refcnt);
+			refcount_inc(&e->refcnt);
 		}
 
 		spin_unlock(&e->lock);
@@ -654,7 +655,7 @@ struct l2t_data *t4_init_l2t(unsigned int l2t_start, unsigned int l2t_end)
 		d->l2tab[i].idx = i;
 		d->l2tab[i].state = L2T_STATE_UNUSED;
 		spin_lock_init(&d->l2tab[i].lock);
-		atomic_set(&d->l2tab[i].refcnt, 0);
+		refcount_set(&d->l2tab[i].refcnt, 0);
 		skb_queue_head_init(&d->l2tab[i].arpq);
 	}
 	return d;
@@ -726,7 +727,7 @@ static int l2t_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%4u %-25s %17pM %4d %u %2u   %c   %5u %s\n",
 			   e->idx + d->l2t_start, ip, e->dmac,
 			   e->vlan & VLAN_VID_MASK, vlan_prio(e), e->lport,
-			   l2e_state(e), atomic_read(&e->refcnt),
+			   l2e_state(e), refcount_read(&e->refcnt),
 			   e->neigh ? e->neigh->dev->name : "");
 		spin_unlock_bh(&e->lock);
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.h b/drivers/net/ethernet/chelsio/cxgb4/l2t.h
index 340fecb28a13..6914a0e9836b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.h
@@ -38,6 +38,7 @@
 #include <linux/spinlock.h>
 #include <linux/if_ether.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #define VLAN_NONE 0xfff
 
@@ -80,7 +81,7 @@ struct l2t_entry {
 	struct l2t_entry *next;     /* next l2t_entry on chain */
 	struct sk_buff_head arpq;   /* packet queue awaiting resolution */
 	spinlock_t lock;
-	atomic_t refcnt;            /* entry reference count */
+	refcount_t refcnt;            /* entry reference count */
 	u16 hash;                   /* hash bucket the entry is on */
 	u16 vlan;                   /* VLAN TCI (id: bits 0-11, prio: 13-15 */
 	u8 v6;                      /* whether entry is for IPv6 */
-- 
2.7.4

