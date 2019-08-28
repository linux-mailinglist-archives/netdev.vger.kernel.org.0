Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549AE9F9DF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfH1Fgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:36:52 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44679 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfH1Fgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:36:51 -0400
Received: by mail-ed1-f66.google.com with SMTP id a21so1508526edt.11
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 22:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1zvaZfdD3vTH2HKky/LAkpIswPQW6Rr3ofrhpWYnpd8=;
        b=vC6dcqOSKTLtmqu4GMK9DtV17qKy36brH+QyEwyevX0GMgfCbNRcf/j1GJ6StWFbh8
         CV/kEtOKO2LwQPXeMGpL3qq4K8b1vVXDOv2gvtNFz3gvPzYDYPXY3jxKLRdIECJaVjI+
         nlI9upHAfRYxrZHnlDKrEaRd8yfyjVRe4AdKED9AvkICTGJd+EOTDoOEen0a8i+g5AQz
         qkS02Y3ug+8uat9as8c9nciLyUMY5pq226VXSxguvgYUHolrNRaJw8uBQNkKjJt5q2LK
         WxZNTF68t0JZyGEzxC/7Ce9M2DNCLBZA6sl1TWPhPmaZ+63uwmy2N7JvMF4DGPhwALaY
         gbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1zvaZfdD3vTH2HKky/LAkpIswPQW6Rr3ofrhpWYnpd8=;
        b=XKcQxnetEIYzWoNUldAMcit2c1dX0BtfwSG7ghX3qdg5N3GOUnD0NvJQujamtb5c2H
         bH7Pv7aH5phFOk2LZLwiZ7ftQrAPav1aAgeAH8sDYR5o354Mt9Mr/81aM9Cv5b2QP6/p
         S3TztSPedSqZiBrgc60M45gLqw4dFePIbgLx5kV21C/HpKnRmJ+ti+tzic8uOV/UqirK
         ngnzvmIjH7z2A4O2kmq77hOS3wE+oW9sJlAxQuo4roZacarzHvBoUgXM1Kczj6f/dM1l
         9kcsnbt++J0GnsjBCeYXgFoDuCfxs8SepjQiylVx6OCpBfsgPIrdIo7UFz6KTOKPpNTd
         VNfw==
X-Gm-Message-State: APjAAAUoxyc8aMn2KxrD9I6XHGmxUyZ1P6f5O/KCANAkuXCS36lpeLMe
        NeKLxBnpyBIrUyPlxSykYW4xs7XHMBs=
X-Google-Smtp-Source: APXvYqxFU3AME5y3AK1DCgiBrwywaP8i0AbFvIuEOHjCxgqQb7KI+Yr0z8El6r9yIw07clavy25B0g==
X-Received: by 2002:a17:906:3d8:: with SMTP id c24mr1545620eja.105.1566970609479;
        Tue, 27 Aug 2019 22:36:49 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i23sm237334edv.11.2019.08.27.22.36.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 22:36:48 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jaco.gericke@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 2/2] nfp: bpf: add simple map op cache
Date:   Tue, 27 Aug 2019 22:36:29 -0700
Message-Id: <20190828053629.28658-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828053629.28658-1-jakub.kicinski@netronome.com>
References: <20190828053629.28658-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each get_next and lookup call requires a round trip to the device.
However, the device is capable of giving us a few entries back,
instead of just one.

In this patch we ask for a small yet reasonable number of entries
(4) on every get_next call, and on subsequent get_next/lookup calls
check this little cache for a hit. The cache is only kept for 250us,
and is invalidated on every operation which may modify the map
(e.g. delete or update call). Note that operations may be performed
simultaneously, so we have to keep track of operations in flight.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c | 179 +++++++++++++++++-
 drivers/net/ethernet/netronome/nfp/bpf/fw.h   |   1 +
 drivers/net/ethernet/netronome/nfp/bpf/main.c |  18 ++
 drivers/net/ethernet/netronome/nfp/bpf/main.h |  23 +++
 .../net/ethernet/netronome/nfp/bpf/offload.c  |   3 +
 5 files changed, 215 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
index fcf880c82f3f..0e2db6ea79e9 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
@@ -6,6 +6,7 @@
 #include <linux/bug.h>
 #include <linux/jiffies.h>
 #include <linux/skbuff.h>
+#include <linux/timekeeping.h>
 
 #include "../ccm.h"
 #include "../nfp_app.h"
@@ -175,29 +176,151 @@ nfp_bpf_ctrl_reply_val(struct nfp_app_bpf *bpf, struct cmsg_reply_map_op *reply,
 	return &reply->data[bpf->cmsg_key_sz * (n + 1) + bpf->cmsg_val_sz * n];
 }
 
+static bool nfp_bpf_ctrl_op_cache_invalidate(enum nfp_ccm_type op)
+{
+	return op == NFP_CCM_TYPE_BPF_MAP_UPDATE ||
+	       op == NFP_CCM_TYPE_BPF_MAP_DELETE;
+}
+
+static bool nfp_bpf_ctrl_op_cache_capable(enum nfp_ccm_type op)
+{
+	return op == NFP_CCM_TYPE_BPF_MAP_LOOKUP ||
+	       op == NFP_CCM_TYPE_BPF_MAP_GETNEXT;
+}
+
+static bool nfp_bpf_ctrl_op_cache_fill(enum nfp_ccm_type op)
+{
+	return op == NFP_CCM_TYPE_BPF_MAP_GETFIRST ||
+	       op == NFP_CCM_TYPE_BPF_MAP_GETNEXT;
+}
+
+static unsigned int
+nfp_bpf_ctrl_op_cache_get(struct nfp_bpf_map *nfp_map, enum nfp_ccm_type op,
+			  const u8 *key, u8 *out_key, u8 *out_value,
+			  u32 *cache_gen)
+{
+	struct bpf_map *map = &nfp_map->offmap->map;
+	struct nfp_app_bpf *bpf = nfp_map->bpf;
+	unsigned int i, count, n_entries;
+	struct cmsg_reply_map_op *reply;
+
+	n_entries = nfp_bpf_ctrl_op_cache_fill(op) ? bpf->cmsg_cache_cnt : 1;
+
+	spin_lock(&nfp_map->cache_lock);
+	*cache_gen = nfp_map->cache_gen;
+	if (nfp_map->cache_blockers)
+		n_entries = 1;
+
+	if (nfp_bpf_ctrl_op_cache_invalidate(op))
+		goto exit_block;
+	if (!nfp_bpf_ctrl_op_cache_capable(op))
+		goto exit_unlock;
+
+	if (!nfp_map->cache)
+		goto exit_unlock;
+	if (nfp_map->cache_to < ktime_get_ns())
+		goto exit_invalidate;
+
+	reply = (void *)nfp_map->cache->data;
+	count = be32_to_cpu(reply->count);
+
+	for (i = 0; i < count; i++) {
+		void *cached_key;
+
+		cached_key = nfp_bpf_ctrl_reply_key(bpf, reply, i);
+		if (memcmp(cached_key, key, map->key_size))
+			continue;
+
+		if (op == NFP_CCM_TYPE_BPF_MAP_LOOKUP)
+			memcpy(out_value, nfp_bpf_ctrl_reply_val(bpf, reply, i),
+			       map->value_size);
+		if (op == NFP_CCM_TYPE_BPF_MAP_GETNEXT) {
+			if (i + 1 == count)
+				break;
+
+			memcpy(out_key,
+			       nfp_bpf_ctrl_reply_key(bpf, reply, i + 1),
+			       map->key_size);
+		}
+
+		n_entries = 0;
+		goto exit_unlock;
+	}
+	goto exit_unlock;
+
+exit_block:
+	nfp_map->cache_blockers++;
+exit_invalidate:
+	dev_consume_skb_any(nfp_map->cache);
+	nfp_map->cache = NULL;
+exit_unlock:
+	spin_unlock(&nfp_map->cache_lock);
+	return n_entries;
+}
+
+static void
+nfp_bpf_ctrl_op_cache_put(struct nfp_bpf_map *nfp_map, enum nfp_ccm_type op,
+			  struct sk_buff *skb, u32 cache_gen)
+{
+	bool blocker, filler;
+
+	blocker = nfp_bpf_ctrl_op_cache_invalidate(op);
+	filler = nfp_bpf_ctrl_op_cache_fill(op);
+	if (blocker || filler) {
+		u64 to = 0;
+
+		if (filler)
+			to = ktime_get_ns() + NFP_BPF_MAP_CACHE_TIME_NS;
+
+		spin_lock(&nfp_map->cache_lock);
+		if (blocker) {
+			nfp_map->cache_blockers--;
+			nfp_map->cache_gen++;
+		}
+		if (filler && !nfp_map->cache_blockers &&
+		    nfp_map->cache_gen == cache_gen) {
+			nfp_map->cache_to = to;
+			swap(nfp_map->cache, skb);
+		}
+		spin_unlock(&nfp_map->cache_lock);
+	}
+
+	dev_consume_skb_any(skb);
+}
+
 static int
 nfp_bpf_ctrl_entry_op(struct bpf_offloaded_map *offmap, enum nfp_ccm_type op,
 		      u8 *key, u8 *value, u64 flags, u8 *out_key, u8 *out_value)
 {
 	struct nfp_bpf_map *nfp_map = offmap->dev_priv;
+	unsigned int n_entries, reply_entries, count;
 	struct nfp_app_bpf *bpf = nfp_map->bpf;
 	struct bpf_map *map = &offmap->map;
 	struct cmsg_reply_map_op *reply;
 	struct cmsg_req_map_op *req;
 	struct sk_buff *skb;
+	u32 cache_gen;
 	int err;
 
 	/* FW messages have no space for more than 32 bits of flags */
 	if (flags >> 32)
 		return -EOPNOTSUPP;
 
+	/* Handle op cache */
+	n_entries = nfp_bpf_ctrl_op_cache_get(nfp_map, op, key, out_key,
+					      out_value, &cache_gen);
+	if (!n_entries)
+		return 0;
+
 	skb = nfp_bpf_cmsg_map_req_alloc(bpf, 1);
-	if (!skb)
-		return -ENOMEM;
+	if (!skb) {
+		err = -ENOMEM;
+		goto err_cache_put;
+	}
 
 	req = (void *)skb->data;
 	req->tid = cpu_to_be32(nfp_map->tid);
-	req->count = cpu_to_be32(1);
+	req->count = cpu_to_be32(n_entries);
 	req->flags = cpu_to_be32(flags);
 
 	/* Copy inputs */
@@ -207,16 +330,38 @@ nfp_bpf_ctrl_entry_op(struct bpf_offloaded_map *offmap, enum nfp_ccm_type op,
 		memcpy(nfp_bpf_ctrl_req_val(bpf, req, 0), value,
 		       map->value_size);
 
-	skb = nfp_ccm_communicate(&bpf->ccm, skb, op,
-				  nfp_bpf_cmsg_map_reply_size(bpf, 1));
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
+	skb = nfp_ccm_communicate(&bpf->ccm, skb, op, 0);
+	if (IS_ERR(skb)) {
+		err = PTR_ERR(skb);
+		goto err_cache_put;
+	}
+
+	if (skb->len < sizeof(*reply)) {
+		cmsg_warn(bpf, "cmsg drop - type 0x%02x too short %d!\n",
+			  op, skb->len);
+		err = -EIO;
+		goto err_free;
+	}
 
 	reply = (void *)skb->data;
+	count = be32_to_cpu(reply->count);
 	err = nfp_bpf_ctrl_rc_to_errno(bpf, &reply->reply_hdr);
+	/* FW responds with message sized to hold the good entries,
+	 * plus one extra entry if there was an error.
+	 */
+	reply_entries = count + !!err;
+	if (n_entries > 1 && count)
+		err = 0;
 	if (err)
 		goto err_free;
 
+	if (skb->len != nfp_bpf_cmsg_map_reply_size(bpf, reply_entries)) {
+		cmsg_warn(bpf, "cmsg drop - type 0x%02x too short %d for %d entries!\n",
+			  op, skb->len, reply_entries);
+		err = -EIO;
+		goto err_free;
+	}
+
 	/* Copy outputs */
 	if (out_key)
 		memcpy(out_key, nfp_bpf_ctrl_reply_key(bpf, reply, 0),
@@ -225,11 +370,13 @@ nfp_bpf_ctrl_entry_op(struct bpf_offloaded_map *offmap, enum nfp_ccm_type op,
 		memcpy(out_value, nfp_bpf_ctrl_reply_val(bpf, reply, 0),
 		       map->value_size);
 
-	dev_consume_skb_any(skb);
+	nfp_bpf_ctrl_op_cache_put(nfp_map, op, skb, cache_gen);
 
 	return 0;
 err_free:
 	dev_kfree_skb_any(skb);
+err_cache_put:
+	nfp_bpf_ctrl_op_cache_put(nfp_map, op, NULL, cache_gen);
 	return err;
 }
 
@@ -275,7 +422,21 @@ unsigned int nfp_bpf_ctrl_cmsg_min_mtu(struct nfp_app_bpf *bpf)
 
 unsigned int nfp_bpf_ctrl_cmsg_mtu(struct nfp_app_bpf *bpf)
 {
-	return max(NFP_NET_DEFAULT_MTU, nfp_bpf_ctrl_cmsg_min_mtu(bpf));
+	return max3(NFP_NET_DEFAULT_MTU,
+		    nfp_bpf_cmsg_map_req_size(bpf, NFP_BPF_MAP_CACHE_CNT),
+		    nfp_bpf_cmsg_map_reply_size(bpf, NFP_BPF_MAP_CACHE_CNT));
+}
+
+unsigned int nfp_bpf_ctrl_cmsg_cache_cnt(struct nfp_app_bpf *bpf)
+{
+	unsigned int mtu, req_max, reply_max, entry_sz;
+
+	mtu = bpf->app->ctrl->dp.mtu;
+	entry_sz = bpf->cmsg_key_sz + bpf->cmsg_val_sz;
+	req_max = (mtu - sizeof(struct cmsg_req_map_op)) / entry_sz;
+	reply_max = (mtu - sizeof(struct cmsg_reply_map_op)) / entry_sz;
+
+	return min3(req_max, reply_max, NFP_BPF_MAP_CACHE_CNT);
 }
 
 void nfp_bpf_ctrl_msg_rx(struct nfp_app *app, struct sk_buff *skb)
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/fw.h b/drivers/net/ethernet/netronome/nfp/bpf/fw.h
index 06c4286bd79e..a83a0ad5e27d 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/fw.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/fw.h
@@ -24,6 +24,7 @@ enum bpf_cap_tlv_type {
 	NFP_BPF_CAP_TYPE_QUEUE_SELECT	= 5,
 	NFP_BPF_CAP_TYPE_ADJUST_TAIL	= 6,
 	NFP_BPF_CAP_TYPE_ABI_VERSION	= 7,
+	NFP_BPF_CAP_TYPE_CMSG_MULTI_ENT	= 8,
 };
 
 struct nfp_bpf_cap_tlv_func {
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 2b1773ed3de9..8f732771d3fa 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -299,6 +299,14 @@ nfp_bpf_parse_cap_adjust_tail(struct nfp_app_bpf *bpf, void __iomem *value,
 	return 0;
 }
 
+static int
+nfp_bpf_parse_cap_cmsg_multi_ent(struct nfp_app_bpf *bpf, void __iomem *value,
+				 u32 length)
+{
+	bpf->cmsg_multi_ent = true;
+	return 0;
+}
+
 static int
 nfp_bpf_parse_cap_abi_version(struct nfp_app_bpf *bpf, void __iomem *value,
 			      u32 length)
@@ -375,6 +383,11 @@ static int nfp_bpf_parse_capabilities(struct nfp_app *app)
 							  length))
 				goto err_release_free;
 			break;
+		case NFP_BPF_CAP_TYPE_CMSG_MULTI_ENT:
+			if (nfp_bpf_parse_cap_cmsg_multi_ent(app->priv, value,
+							     length))
+				goto err_release_free;
+			break;
 		default:
 			nfp_dbg(cpp, "unknown BPF capability: %d\n", type);
 			break;
@@ -426,6 +439,11 @@ static int nfp_bpf_start(struct nfp_app *app)
 		return -EINVAL;
 	}
 
+	if (bpf->cmsg_multi_ent)
+		bpf->cmsg_cache_cnt = nfp_bpf_ctrl_cmsg_cache_cnt(bpf);
+	else
+		bpf->cmsg_cache_cnt = 1;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
index f4802036eb42..fac9c6f9e197 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
@@ -99,6 +99,7 @@ enum pkt_vec {
  * @maps_neutral:	hash table of offload-neutral maps (on pointer)
  *
  * @abi_version:	global BPF ABI version
+ * @cmsg_cache_cnt:	number of entries to read for caching
  *
  * @adjust_head:	adjust head capability
  * @adjust_head.flags:		extra flags for adjust head
@@ -124,6 +125,7 @@ enum pkt_vec {
  * @pseudo_random:	FW initialized the pseudo-random machinery (CSRs)
  * @queue_select:	BPF can set the RX queue ID in packet vector
  * @adjust_tail:	BPF can simply trunc packet size for adjust tail
+ * @cmsg_multi_ent:	FW can pack multiple map entries in a single cmsg
  */
 struct nfp_app_bpf {
 	struct nfp_app *app;
@@ -134,6 +136,8 @@ struct nfp_app_bpf {
 	unsigned int cmsg_key_sz;
 	unsigned int cmsg_val_sz;
 
+	unsigned int cmsg_cache_cnt;
+
 	struct list_head map_list;
 	unsigned int maps_in_use;
 	unsigned int map_elems_in_use;
@@ -169,6 +173,7 @@ struct nfp_app_bpf {
 	bool pseudo_random;
 	bool queue_select;
 	bool adjust_tail;
+	bool cmsg_multi_ent;
 };
 
 enum nfp_bpf_map_use {
@@ -183,11 +188,21 @@ struct nfp_bpf_map_word {
 	unsigned char non_zero_update	:1;
 };
 
+#define NFP_BPF_MAP_CACHE_CNT		4U
+#define NFP_BPF_MAP_CACHE_TIME_NS	(250 * 1000)
+
 /**
  * struct nfp_bpf_map - private per-map data attached to BPF maps for offload
  * @offmap:	pointer to the offloaded BPF map
  * @bpf:	back pointer to bpf app private structure
  * @tid:	table id identifying map on datapath
+ *
+ * @cache_lock:	protects @cache_blockers, @cache_to, @cache
+ * @cache_blockers:	number of ops in flight which block caching
+ * @cache_gen:	counter incremented by every blocker on exit
+ * @cache_to:	time when cache will no longer be valid (ns)
+ * @cache:	skb with cached response
+ *
  * @l:		link on the nfp_app_bpf->map_list list
  * @use_map:	map of how the value is used (in 4B chunks)
  */
@@ -195,6 +210,13 @@ struct nfp_bpf_map {
 	struct bpf_offloaded_map *offmap;
 	struct nfp_app_bpf *bpf;
 	u32 tid;
+
+	spinlock_t cache_lock;
+	u32 cache_blockers;
+	u32 cache_gen;
+	u64 cache_to;
+	struct sk_buff *cache;
+
 	struct list_head l;
 	struct nfp_bpf_map_word use_map[];
 };
@@ -566,6 +588,7 @@ void *nfp_bpf_relo_for_vnic(struct nfp_prog *nfp_prog, struct nfp_bpf_vnic *bv);
 
 unsigned int nfp_bpf_ctrl_cmsg_min_mtu(struct nfp_app_bpf *bpf);
 unsigned int nfp_bpf_ctrl_cmsg_mtu(struct nfp_app_bpf *bpf);
+unsigned int nfp_bpf_ctrl_cmsg_cache_cnt(struct nfp_app_bpf *bpf);
 long long int
 nfp_bpf_ctrl_alloc_map(struct nfp_app_bpf *bpf, struct bpf_map *map);
 void
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index 39c9fec222b4..88fab6a82acf 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -385,6 +385,7 @@ nfp_bpf_map_alloc(struct nfp_app_bpf *bpf, struct bpf_offloaded_map *offmap)
 	offmap->dev_priv = nfp_map;
 	nfp_map->offmap = offmap;
 	nfp_map->bpf = bpf;
+	spin_lock_init(&nfp_map->cache_lock);
 
 	res = nfp_bpf_ctrl_alloc_map(bpf, &offmap->map);
 	if (res < 0) {
@@ -407,6 +408,8 @@ nfp_bpf_map_free(struct nfp_app_bpf *bpf, struct bpf_offloaded_map *offmap)
 	struct nfp_bpf_map *nfp_map = offmap->dev_priv;
 
 	nfp_bpf_ctrl_free_map(bpf, nfp_map);
+	dev_consume_skb_any(nfp_map->cache);
+	WARN_ON_ONCE(nfp_map->cache_blockers);
 	list_del_init(&nfp_map->l);
 	bpf->map_elems_in_use -= offmap->map.max_entries;
 	bpf->maps_in_use--;
-- 
2.21.0

