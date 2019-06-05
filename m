Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC9836682
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfFEVMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:09 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33917 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfFEVMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:09 -0400
Received: by mail-qk1-f196.google.com with SMTP id t64so178438qkh.1
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b0MmhqFJXtc5eNB1lBTfOMKjhsk9zpsxwwGYRdO1jwI=;
        b=u/u23HOG2NfxoI5KmsgelUFrWI8wXYX5RKwXmnziLw9nmYCmp7YQ2HKe5dztKJVZ+6
         W/FXLvorVTVs4sclwvePvtcdIm6BDrnNRAB1DWFLXgq5z0nTo9cbN8RbrIRFVGCM8bxP
         dCJFk5iGOdCXqvHzbG+RWQVJLbXZmqzOaD/JMA3LMqliT1PJWuqSqVTrWyE3jHX9+aOV
         xiiktkDnvsbzSreHQZpFu9q4YfeSHCKy4rRDbedE2Has5lNqKWHXRVHrbHO1qWplxNSx
         0P0oPc6CvAWoe//TCUro5iR+EOy/CgCZ5QLmvVIYPglMl6jG5sm7kurHNpXU5jGDik5K
         90Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b0MmhqFJXtc5eNB1lBTfOMKjhsk9zpsxwwGYRdO1jwI=;
        b=ZsvFDiqEnKxuCozQdRo64Q72+wv0S3t4/Svar5jhJDbo3H2VtwjsCwUvFBYj2Y20cR
         Q2JNgl/j8I/7SkcLumr03DdaEKIX4Ira3IUaZa3N5QSh41wkfbJi0qAHJrFfntysf+4d
         pta7dDzFF9lo1aJoLcl0+KeMeKseo+pAqmfmF2TWhGkDf+rdwOvVdu8KJ6x98INDd+XO
         M9fSxgGWgn7CN2pqPhnryFhXQjpdYyEDylJ57LDm30Dy9b8ZR8QTJggxQxfjUxTnjor2
         ZMEix9j0v2ObsQs4dZg+aDoaUeS6ssbZ0E4SNxEI18+JFtUtOSqj1NIKuYZR6aWsqD9j
         xwQQ==
X-Gm-Message-State: APjAAAUL9bUNc7N7acIg86wOpC6xjNisudH5ufT2oi0RwX7SFm6kDAyf
        iC4IYrWOht8qmslH9uelz5fdsw==
X-Google-Smtp-Source: APXvYqyE68tl/6U9CK7z9NaGPSmc2HGWtO+Ewnr0on06SHJ5IqKbfmlf7ZNvM+ZkHkfhnY2T8taqoQ==
X-Received: by 2002:a05:620a:14ba:: with SMTP id x26mr15544877qkj.328.1559769127362;
        Wed, 05 Jun 2019 14:12:07 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:06 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 04/13] nfp: add support for sending control messages via mailbox
Date:   Wed,  5 Jun 2019 14:11:34 -0700
Message-Id: <20190605211143.29689-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FW may prefer to handle some communication via a mailbox
or the vNIC may simply not have a control queue (VFs).
Add a way of exchanging ccm-compatible messages via a
mailbox.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile   |   1 +
 drivers/net/ethernet/netronome/nfp/ccm.c      |   3 -
 drivers/net/ethernet/netronome/nfp/ccm.h      |  44 +-
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c | 591 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  10 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |   4 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   1 +
 7 files changed, 646 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/ccm_mbox.c

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 87bf784f8e8f..e40893692a8e 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -16,6 +16,7 @@ nfp-objs := \
 	    nfpcore/nfp_rtsym.o \
 	    nfpcore/nfp_target.o \
 	    ccm.o \
+	    ccm_mbox.o \
 	    nfp_asm.o \
 	    nfp_app.o \
 	    nfp_app_nic.o \
diff --git a/drivers/net/ethernet/netronome/nfp/ccm.c b/drivers/net/ethernet/netronome/nfp/ccm.c
index 94476e41e261..71afd111bae3 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm.c
+++ b/drivers/net/ethernet/netronome/nfp/ccm.c
@@ -7,9 +7,6 @@
 #include "nfp_app.h"
 #include "nfp_net.h"
 
-#define NFP_CCM_TYPE_REPLY_BIT		7
-#define __NFP_CCM_REPLY(req)		(BIT(NFP_CCM_TYPE_REPLY_BIT) | (req))
-
 #define ccm_warn(app, msg...)	nn_dp_warn(&(app)->ctrl->dp, msg)
 
 #define NFP_CCM_TAG_ALLOC_SPAN	(U16_MAX / 4)
diff --git a/drivers/net/ethernet/netronome/nfp/ccm.h b/drivers/net/ethernet/netronome/nfp/ccm.h
index ac963b128203..c84be54abb4c 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm.h
+++ b/drivers/net/ethernet/netronome/nfp/ccm.h
@@ -9,6 +9,7 @@
 #include <linux/wait.h>
 
 struct nfp_app;
+struct nfp_net;
 
 /* Firmware ABI */
 
@@ -26,10 +27,18 @@ enum nfp_ccm_type {
 
 #define NFP_CCM_ABI_VERSION		1
 
+#define NFP_CCM_TYPE_REPLY_BIT		7
+#define __NFP_CCM_REPLY(req)		(BIT(NFP_CCM_TYPE_REPLY_BIT) | (req))
+
 struct nfp_ccm_hdr {
-	u8 type;
-	u8 ver;
-	__be16 tag;
+	union {
+		struct {
+			u8 type;
+			u8 ver;
+			__be16 tag;
+		};
+		__be32 raw;
+	};
 };
 
 static inline u8 nfp_ccm_get_type(struct sk_buff *skb)
@@ -41,15 +50,31 @@ static inline u8 nfp_ccm_get_type(struct sk_buff *skb)
 	return hdr->type;
 }
 
-static inline unsigned int nfp_ccm_get_tag(struct sk_buff *skb)
+static inline __be16 __nfp_ccm_get_tag(struct sk_buff *skb)
 {
 	struct nfp_ccm_hdr *hdr;
 
 	hdr = (struct nfp_ccm_hdr *)skb->data;
 
-	return be16_to_cpu(hdr->tag);
+	return hdr->tag;
+}
+
+static inline unsigned int nfp_ccm_get_tag(struct sk_buff *skb)
+{
+	return be16_to_cpu(__nfp_ccm_get_tag(skb));
 }
 
+#define NFP_NET_MBOX_TLV_TYPE		GENMASK(31, 16)
+#define NFP_NET_MBOX_TLV_LEN		GENMASK(15, 0)
+
+enum nfp_ccm_mbox_tlv_type {
+	NFP_NET_MBOX_TLV_TYPE_UNKNOWN	= 0,
+	NFP_NET_MBOX_TLV_TYPE_END	= 1,
+	NFP_NET_MBOX_TLV_TYPE_MSG	= 2,
+	NFP_NET_MBOX_TLV_TYPE_MSG_NOSUP	= 3,
+	NFP_NET_MBOX_TLV_TYPE_RESV	= 4,
+};
+
 /* Implementation */
 
 /**
@@ -80,4 +105,13 @@ void nfp_ccm_rx(struct nfp_ccm *ccm, struct sk_buff *skb);
 struct sk_buff *
 nfp_ccm_communicate(struct nfp_ccm *ccm, struct sk_buff *skb,
 		    enum nfp_ccm_type type, unsigned int reply_size);
+
+bool nfp_ccm_mbox_fits(struct nfp_net *nn, unsigned int size);
+struct sk_buff *
+nfp_ccm_mbox_alloc(struct nfp_net *nn, unsigned int req_size,
+		   unsigned int reply_size, gfp_t flags);
+int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
+			     enum nfp_ccm_type type,
+			     unsigned int reply_size,
+			     unsigned int max_reply_size);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
new file mode 100644
index 000000000000..e5acd96c3335
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
@@ -0,0 +1,591 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <linux/bitfield.h>
+#include <linux/io.h>
+#include <linux/skbuff.h>
+
+#include "ccm.h"
+#include "nfp_net.h"
+
+/* CCM messages via the mailbox.  CMSGs get wrapped into simple TLVs
+ * and copied into the mailbox.  Multiple messages can be copied to
+ * form a batch.  Threads come in with CMSG formed in an skb, then
+ * enqueue that skb onto the request queue.  If threads skb is first
+ * in queue this thread will handle the mailbox operation.  It copies
+ * up to 16 messages into the mailbox (making sure that both requests
+ * and replies will fit.  After FW is done processing the batch it
+ * copies the data out and wakes waiting threads.
+ * If a thread is waiting it either gets its the message completed
+ * (response is copied into the same skb as the request, overwriting
+ * it), or becomes the first in queue.
+ * Completions and next-to-run are signaled via the control buffer
+ * to limit potential cache line bounces.
+ */
+
+#define NFP_CCM_MBOX_BATCH_LIMIT	16
+#define NFP_CCM_TIMEOUT			(NFP_NET_POLL_TIMEOUT * 1000)
+#define NFP_CCM_MAX_QLEN		256
+
+enum nfp_net_mbox_cmsg_state {
+	NFP_NET_MBOX_CMSG_STATE_QUEUED,
+	NFP_NET_MBOX_CMSG_STATE_NEXT,
+	NFP_NET_MBOX_CMSG_STATE_BUSY,
+	NFP_NET_MBOX_CMSG_STATE_REPLY_FOUND,
+	NFP_NET_MBOX_CMSG_STATE_DONE,
+};
+
+/**
+ * struct nfp_ccm_mbox_skb_cb - CCM mailbox specific info
+ * @state:	processing state (/stage) of the message
+ * @err:	error encountered during processing if any
+ * @max_len:	max(request_len, reply_len)
+ * @exp_reply:	expected reply length (0 means don't validate)
+ */
+struct nfp_ccm_mbox_cmsg_cb {
+	enum nfp_net_mbox_cmsg_state state;
+	int err;
+	unsigned int max_len;
+	unsigned int exp_reply;
+};
+
+static u32 nfp_ccm_mbox_max_msg(struct nfp_net *nn)
+{
+	return round_down(nn->tlv_caps.mbox_len, 4) -
+		NFP_NET_CFG_MBOX_SIMPLE_VAL - /* common mbox command header */
+		4 * 2; /* Msg TLV plus End TLV headers */
+}
+
+static void
+nfp_ccm_mbox_msg_init(struct sk_buff *skb, unsigned int exp_reply, int max_len)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb = (void *)skb->cb;
+
+	cb->state = NFP_NET_MBOX_CMSG_STATE_QUEUED;
+	cb->err = 0;
+	cb->max_len = max_len;
+	cb->exp_reply = exp_reply;
+}
+
+static int nfp_ccm_mbox_maxlen(const struct sk_buff *skb)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb = (void *)skb->cb;
+
+	return cb->max_len;
+}
+
+static bool nfp_ccm_mbox_done(struct sk_buff *skb)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb = (void *)skb->cb;
+
+	return cb->state == NFP_NET_MBOX_CMSG_STATE_DONE;
+}
+
+static bool nfp_ccm_mbox_in_progress(struct sk_buff *skb)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb = (void *)skb->cb;
+
+	return cb->state != NFP_NET_MBOX_CMSG_STATE_QUEUED &&
+	       cb->state != NFP_NET_MBOX_CMSG_STATE_NEXT;
+}
+
+static void nfp_ccm_mbox_set_busy(struct sk_buff *skb)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb = (void *)skb->cb;
+
+	cb->state = NFP_NET_MBOX_CMSG_STATE_BUSY;
+}
+
+static bool nfp_ccm_mbox_is_first(struct nfp_net *nn, struct sk_buff *skb)
+{
+	return skb_queue_is_first(&nn->mbox_cmsg.queue, skb);
+}
+
+static bool nfp_ccm_mbox_should_run(struct nfp_net *nn, struct sk_buff *skb)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb = (void *)skb->cb;
+
+	return cb->state == NFP_NET_MBOX_CMSG_STATE_NEXT;
+}
+
+static void nfp_ccm_mbox_mark_next_runner(struct nfp_net *nn)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb;
+	struct sk_buff *skb;
+
+	skb = skb_peek(&nn->mbox_cmsg.queue);
+	if (!skb)
+		return;
+
+	cb = (void *)skb->cb;
+	cb->state = NFP_NET_MBOX_CMSG_STATE_NEXT;
+}
+
+static void
+nfp_ccm_mbox_write_tlv(struct nfp_net *nn, u32 off, u32 type, u32 len)
+{
+	nn_writel(nn, off,
+		  FIELD_PREP(NFP_NET_MBOX_TLV_TYPE, type) |
+		  FIELD_PREP(NFP_NET_MBOX_TLV_LEN, len));
+}
+
+static void nfp_ccm_mbox_copy_in(struct nfp_net *nn, struct sk_buff *last)
+{
+	struct sk_buff *skb;
+	int reserve, i, cnt;
+	__be32 *data;
+	u32 off, len;
+
+	off = nn->tlv_caps.mbox_off + NFP_NET_CFG_MBOX_SIMPLE_VAL;
+	skb = __skb_peek(&nn->mbox_cmsg.queue);
+	while (true) {
+		nfp_ccm_mbox_write_tlv(nn, off, NFP_NET_MBOX_TLV_TYPE_MSG,
+				       skb->len);
+		off += 4;
+
+		/* Write data word by word, skb->data should be aligned */
+		data = (__be32 *)skb->data;
+		cnt = skb->len / 4;
+		for (i = 0 ; i < cnt; i++) {
+			nn_writel(nn, off, be32_to_cpu(data[i]));
+			off += 4;
+		}
+		if (skb->len & 3) {
+			__be32 tmp = 0;
+
+			memcpy(&tmp, &data[i], skb->len & 3);
+			nn_writel(nn, off, be32_to_cpu(tmp));
+			off += 4;
+		}
+
+		/* Reserve space if reply is bigger */
+		len = round_up(skb->len, 4);
+		reserve = nfp_ccm_mbox_maxlen(skb) - len;
+		if (reserve > 0) {
+			nfp_ccm_mbox_write_tlv(nn, off,
+					       NFP_NET_MBOX_TLV_TYPE_RESV,
+					       reserve);
+			off += 4 + reserve;
+		}
+
+		if (skb == last)
+			break;
+		skb = skb_queue_next(&nn->mbox_cmsg.queue, skb);
+	}
+
+	nfp_ccm_mbox_write_tlv(nn, off, NFP_NET_MBOX_TLV_TYPE_END, 0);
+}
+
+static struct sk_buff *
+nfp_ccm_mbox_find_req(struct nfp_net *nn, __be16 tag, struct sk_buff *last)
+{
+	struct sk_buff *skb;
+
+	skb = __skb_peek(&nn->mbox_cmsg.queue);
+	while (true) {
+		if (__nfp_ccm_get_tag(skb) == tag)
+			return skb;
+
+		if (skb == last)
+			return NULL;
+		skb = skb_queue_next(&nn->mbox_cmsg.queue, skb);
+	}
+}
+
+static void nfp_ccm_mbox_copy_out(struct nfp_net *nn, struct sk_buff *last)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb;
+	u8 __iomem *data, *end;
+	struct sk_buff *skb;
+
+	data = nn->dp.ctrl_bar + nn->tlv_caps.mbox_off +
+		NFP_NET_CFG_MBOX_SIMPLE_VAL;
+	end = data + nn->tlv_caps.mbox_len;
+
+	while (true) {
+		unsigned int length, offset, type;
+		struct nfp_ccm_hdr hdr;
+		__be32 *skb_data;
+		u32 tlv_hdr;
+		int i, cnt;
+
+		tlv_hdr = readl(data);
+		type = FIELD_GET(NFP_NET_MBOX_TLV_TYPE, tlv_hdr);
+		length = FIELD_GET(NFP_NET_MBOX_TLV_LEN, tlv_hdr);
+		offset = data - nn->dp.ctrl_bar;
+
+		/* Advance past the header */
+		data += 4;
+
+		if (data + length > end) {
+			nn_dp_warn(&nn->dp, "mailbox oversized TLV type:%d offset:%u len:%u\n",
+				   type, offset, length);
+			break;
+		}
+
+		if (type == NFP_NET_MBOX_TLV_TYPE_END)
+			break;
+		if (type == NFP_NET_MBOX_TLV_TYPE_RESV)
+			goto next_tlv;
+		if (type != NFP_NET_MBOX_TLV_TYPE_MSG &&
+		    type != NFP_NET_MBOX_TLV_TYPE_MSG_NOSUP) {
+			nn_dp_warn(&nn->dp, "mailbox unknown TLV type:%d offset:%u len:%u\n",
+				   type, offset, length);
+			break;
+		}
+
+		if (length < 4) {
+			nn_dp_warn(&nn->dp, "mailbox msg too short to contain header TLV type:%d offset:%u len:%u\n",
+				   type, offset, length);
+			break;
+		}
+
+		hdr.raw = cpu_to_be32(readl(data));
+
+		skb = nfp_ccm_mbox_find_req(nn, hdr.tag, last);
+		if (!skb) {
+			nn_dp_warn(&nn->dp, "mailbox request not found:%u\n",
+				   be16_to_cpu(hdr.tag));
+			break;
+		}
+		cb = (void *)skb->cb;
+
+		if (type == NFP_NET_MBOX_TLV_TYPE_MSG_NOSUP) {
+			nn_dp_warn(&nn->dp,
+				   "mailbox msg not supported type:%d\n",
+				   nfp_ccm_get_type(skb));
+			cb->err = -EIO;
+			goto next_tlv;
+		}
+
+		if (hdr.type != __NFP_CCM_REPLY(nfp_ccm_get_type(skb))) {
+			nn_dp_warn(&nn->dp, "mailbox msg reply wrong type:%u expected:%lu\n",
+				   hdr.type,
+				   __NFP_CCM_REPLY(nfp_ccm_get_type(skb)));
+			cb->err = -EIO;
+			goto next_tlv;
+		}
+		if (cb->exp_reply && length != cb->exp_reply) {
+			nn_dp_warn(&nn->dp, "mailbox msg reply wrong size type:%u expected:%u have:%u\n",
+				   hdr.type, length, cb->exp_reply);
+			cb->err = -EIO;
+			goto next_tlv;
+		}
+		if (length > cb->max_len) {
+			nn_dp_warn(&nn->dp, "mailbox msg oversized reply type:%u max:%u have:%u\n",
+				   hdr.type, cb->max_len, length);
+			cb->err = -EIO;
+			goto next_tlv;
+		}
+
+		if (length <= skb->len)
+			__skb_trim(skb, length);
+		else
+			skb_put(skb, length - skb->len);
+
+		/* We overcopy here slightly, but that's okay, the skb is large
+		 * enough, and the garbage will be ignored (beyond skb->len).
+		 */
+		skb_data = (__be32 *)skb->data;
+		memcpy(skb_data, &hdr, 4);
+
+		cnt = DIV_ROUND_UP(length, 4);
+		for (i = 1 ; i < cnt; i++)
+			skb_data[i] = cpu_to_be32(readl(data + i * 4));
+
+		cb->state = NFP_NET_MBOX_CMSG_STATE_REPLY_FOUND;
+next_tlv:
+		data += round_up(length, 4);
+		if (data + 4 > end) {
+			nn_dp_warn(&nn->dp,
+				   "reached end of MBOX without END TLV\n");
+			break;
+		}
+	}
+
+	smp_wmb(); /* order the skb->data vs. cb->state */
+	spin_lock_bh(&nn->mbox_cmsg.queue.lock);
+	do {
+		skb = __skb_dequeue(&nn->mbox_cmsg.queue);
+		cb = (void *)skb->cb;
+
+		if (cb->state != NFP_NET_MBOX_CMSG_STATE_REPLY_FOUND) {
+			cb->err = -ENOENT;
+			smp_wmb(); /* order the cb->err vs. cb->state */
+		}
+		cb->state = NFP_NET_MBOX_CMSG_STATE_DONE;
+	} while (skb != last);
+
+	nfp_ccm_mbox_mark_next_runner(nn);
+	spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+}
+
+static void
+nfp_ccm_mbox_mark_all_err(struct nfp_net *nn, struct sk_buff *last, int err)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb;
+	struct sk_buff *skb;
+
+	spin_lock_bh(&nn->mbox_cmsg.queue.lock);
+	do {
+		skb = __skb_dequeue(&nn->mbox_cmsg.queue);
+		cb = (void *)skb->cb;
+
+		cb->err = err;
+		smp_wmb(); /* order the cb->err vs. cb->state */
+		cb->state = NFP_NET_MBOX_CMSG_STATE_DONE;
+	} while (skb != last);
+
+	nfp_ccm_mbox_mark_next_runner(nn);
+	spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+}
+
+static void nfp_ccm_mbox_run_queue_unlock(struct nfp_net *nn)
+	__releases(&nn->mbox_cmsg.queue.lock)
+{
+	int space = nn->tlv_caps.mbox_len - NFP_NET_CFG_MBOX_SIMPLE_VAL;
+	struct sk_buff *skb, *last;
+	int cnt, err;
+
+	space -= 4; /* for End TLV */
+
+	/* First skb must fit, because it's ours and we checked it fits */
+	cnt = 1;
+	last = skb = __skb_peek(&nn->mbox_cmsg.queue);
+	space -= 4 + nfp_ccm_mbox_maxlen(skb);
+
+	while (!skb_queue_is_last(&nn->mbox_cmsg.queue, last)) {
+		skb = skb_queue_next(&nn->mbox_cmsg.queue, last);
+		space -= 4 + nfp_ccm_mbox_maxlen(skb);
+		if (space < 0)
+			break;
+		last = skb;
+		nfp_ccm_mbox_set_busy(skb);
+		cnt++;
+		if (cnt == NFP_CCM_MBOX_BATCH_LIMIT)
+			break;
+	}
+	spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+
+	/* Now we own all skb's marked in progress, new requests may arrive
+	 * at the end of the queue.
+	 */
+
+	nn_ctrl_bar_lock(nn);
+
+	nfp_ccm_mbox_copy_in(nn, last);
+
+	err = nfp_net_mbox_reconfig(nn, NFP_NET_CFG_MBOX_CMD_TLV_CMSG);
+	if (!err)
+		nfp_ccm_mbox_copy_out(nn, last);
+	else
+		nfp_ccm_mbox_mark_all_err(nn, last, -EIO);
+
+	nn_ctrl_bar_unlock(nn);
+
+	wake_up_all(&nn->mbox_cmsg.wq);
+}
+
+static int nfp_ccm_mbox_skb_return(struct sk_buff *skb)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb = (void *)skb->cb;
+
+	if (cb->err)
+		dev_kfree_skb_any(skb);
+	return cb->err;
+}
+
+/* If wait timed out but the command is already in progress we have
+ * to wait until it finishes.  Runners has ownership of the skbs marked
+ * as busy.
+ */
+static int
+nfp_ccm_mbox_unlink_unlock(struct nfp_net *nn, struct sk_buff *skb,
+			   enum nfp_ccm_type type)
+	__releases(&nn->mbox_cmsg.queue.lock)
+{
+	bool was_first;
+
+	if (nfp_ccm_mbox_in_progress(skb)) {
+		spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+
+		wait_event(nn->mbox_cmsg.wq, nfp_ccm_mbox_done(skb));
+		smp_rmb(); /* pairs with smp_wmb() after data is written */
+		return nfp_ccm_mbox_skb_return(skb);
+	}
+
+	was_first = nfp_ccm_mbox_should_run(nn, skb);
+	__skb_unlink(skb, &nn->mbox_cmsg.queue);
+	if (was_first)
+		nfp_ccm_mbox_mark_next_runner(nn);
+
+	spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+
+	if (was_first)
+		wake_up_all(&nn->mbox_cmsg.wq);
+
+	nn_dp_warn(&nn->dp, "time out waiting for mbox response to 0x%02x\n",
+		   type);
+	return -ETIMEDOUT;
+}
+
+static int
+nfp_ccm_mbox_msg_prepare(struct nfp_net *nn, struct sk_buff *skb,
+			 enum nfp_ccm_type type,
+			 unsigned int reply_size, unsigned int max_reply_size,
+			 gfp_t flags)
+{
+	const unsigned int mbox_max = nfp_ccm_mbox_max_msg(nn);
+	unsigned int max_len;
+	ssize_t undersize;
+	int err;
+
+	if (unlikely(!(nn->tlv_caps.mbox_cmsg_types & BIT(type)))) {
+		nn_dp_warn(&nn->dp,
+			   "message type %d not supported by mailbox\n", type);
+		return -EINVAL;
+	}
+
+	/* If the reply size is unknown assume it will take the entire
+	 * mailbox, the callers should do their best for this to never
+	 * happen.
+	 */
+	if (!max_reply_size)
+		max_reply_size = mbox_max;
+	max_reply_size = round_up(max_reply_size, 4);
+
+	/* Make sure we can fit the entire reply into the skb,
+	 * and that we don't have to slow down the mbox handler
+	 * with allocations.
+	 */
+	undersize = max_reply_size - (skb_end_pointer(skb) - skb->data);
+	if (undersize > 0) {
+		err = pskb_expand_head(skb, 0, undersize, flags);
+		if (err) {
+			nn_dp_warn(&nn->dp,
+				   "can't allocate reply buffer for mailbox\n");
+			return err;
+		}
+	}
+
+	/* Make sure that request and response both fit into the mailbox */
+	max_len = max(max_reply_size, round_up(skb->len, 4));
+	if (max_len > mbox_max) {
+		nn_dp_warn(&nn->dp,
+			   "message too big for tha mailbox: %u/%u vs %u\n",
+			   skb->len, max_reply_size, mbox_max);
+		return -EMSGSIZE;
+	}
+
+	nfp_ccm_mbox_msg_init(skb, reply_size, max_len);
+
+	return 0;
+}
+
+static int
+nfp_ccm_mbox_msg_enqueue(struct nfp_net *nn, struct sk_buff *skb,
+			 enum nfp_ccm_type type)
+{
+	struct nfp_ccm_hdr *hdr;
+
+	assert_spin_locked(&nn->mbox_cmsg.queue.lock);
+
+	if (nn->mbox_cmsg.queue.qlen >= NFP_CCM_MAX_QLEN) {
+		nn_dp_warn(&nn->dp, "mailbox request queue too long\n");
+		return -EBUSY;
+	}
+
+	hdr = (void *)skb->data;
+	hdr->ver = NFP_CCM_ABI_VERSION;
+	hdr->type = type;
+	hdr->tag = cpu_to_be16(nn->mbox_cmsg.tag++);
+
+	__skb_queue_tail(&nn->mbox_cmsg.queue, skb);
+
+	return 0;
+}
+
+int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
+			     enum nfp_ccm_type type,
+			     unsigned int reply_size,
+			     unsigned int max_reply_size)
+{
+	int err;
+
+	err = nfp_ccm_mbox_msg_prepare(nn, skb, type, reply_size,
+				       max_reply_size, GFP_KERNEL);
+	if (err)
+		goto err_free_skb;
+
+	spin_lock_bh(&nn->mbox_cmsg.queue.lock);
+
+	err = nfp_ccm_mbox_msg_enqueue(nn, skb, type);
+	if (err)
+		goto err_unlock;
+
+	/* First in queue takes the mailbox lock and processes the batch */
+	if (!nfp_ccm_mbox_is_first(nn, skb)) {
+		bool to;
+
+		spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+
+		to = !wait_event_timeout(nn->mbox_cmsg.wq,
+					 nfp_ccm_mbox_done(skb) ||
+					 nfp_ccm_mbox_should_run(nn, skb),
+					 msecs_to_jiffies(NFP_CCM_TIMEOUT));
+
+		/* fast path for those completed by another thread */
+		if (nfp_ccm_mbox_done(skb)) {
+			smp_rmb(); /* pairs with wmb after data is written */
+			return nfp_ccm_mbox_skb_return(skb);
+		}
+
+		spin_lock_bh(&nn->mbox_cmsg.queue.lock);
+
+		if (!nfp_ccm_mbox_is_first(nn, skb)) {
+			WARN_ON(!to);
+
+			err = nfp_ccm_mbox_unlink_unlock(nn, skb, type);
+			if (err)
+				goto err_free_skb;
+			return 0;
+		}
+	}
+
+	/* run queue expects the lock held */
+	nfp_ccm_mbox_run_queue_unlock(nn);
+	return nfp_ccm_mbox_skb_return(skb);
+
+err_unlock:
+	spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+err_free_skb:
+	dev_kfree_skb_any(skb);
+	return err;
+}
+
+struct sk_buff *
+nfp_ccm_mbox_alloc(struct nfp_net *nn, unsigned int req_size,
+		   unsigned int reply_size, gfp_t flags)
+{
+	unsigned int max_size;
+	struct sk_buff *skb;
+
+	if (!reply_size)
+		max_size = nfp_ccm_mbox_max_msg(nn);
+	else
+		max_size = max(req_size, reply_size);
+	max_size = round_up(max_size, 4);
+
+	skb = alloc_skb(max_size, flags);
+	if (!skb)
+		return NULL;
+
+	skb_put(skb, req_size);
+
+	return skb;
+}
+
+bool nfp_ccm_mbox_fits(struct nfp_net *nn, unsigned int size)
+{
+	return nfp_ccm_mbox_max_msg(nn) >= size;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index e006b3abc9f6..134d2709cd70 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -563,6 +563,10 @@ struct nfp_net_dp {
  * @tx_bar:             Pointer to mapped TX queues
  * @rx_bar:             Pointer to mapped FL/RX queues
  * @tlv_caps:		Parsed TLV capabilities
+ * @mbox_cmsg:		Common Control Message via vNIC mailbox state
+ * @mbox_cmsg.queue:	CCM mbox queue of pending messages
+ * @mbox_cmsg.wq:	CCM mbox wait queue of waiting processes
+ * @mbox_cmsg.tag:	CCM mbox message tag allocator
  * @debugfs_dir:	Device directory in debugfs
  * @vnic_list:		Entry on device vNIC list
  * @pdev:		Backpointer to PCI device
@@ -638,6 +642,12 @@ struct nfp_net {
 
 	struct nfp_net_tlv_caps tlv_caps;
 
+	struct {
+		struct sk_buff_head queue;
+		wait_queue_head_t wq;
+		u16 tag;
+	} mbox_cmsg;
+
 	struct dentry *debugfs_dir;
 
 	struct list_head vnic_list;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 39d70936c741..0ccc5206340b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3705,6 +3705,9 @@ nfp_net_alloc(struct pci_dev *pdev, void __iomem *ctrl_bar, bool needs_netdev,
 
 	timer_setup(&nn->reconfig_timer, nfp_net_reconfig_timer, 0);
 
+	skb_queue_head_init(&nn->mbox_cmsg.queue);
+	init_waitqueue_head(&nn->mbox_cmsg.wq);
+
 	err = nfp_net_tlv_caps_parse(&nn->pdev->dev, nn->dp.ctrl_bar,
 				     &nn->tlv_caps);
 	if (err)
@@ -3727,6 +3730,7 @@ nfp_net_alloc(struct pci_dev *pdev, void __iomem *ctrl_bar, bool needs_netdev,
 void nfp_net_free(struct nfp_net *nn)
 {
 	WARN_ON(timer_pending(&nn->reconfig_timer) || nn->reconfig_posted);
+	WARN_ON(!skb_queue_empty(&nn->mbox_cmsg.queue));
 
 	if (nn->dp.netdev)
 		free_netdev(nn->dp.netdev);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 05a5c82ac8f6..b94db7fb691d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -394,6 +394,7 @@
 #define NFP_NET_CFG_MBOX_CMD_CTAG_FILTER_KILL 2
 
 #define NFP_NET_CFG_MBOX_CMD_PCI_DSCP_PRIOMAP_SET	5
+#define NFP_NET_CFG_MBOX_CMD_TLV_CMSG			6
 
 /**
  * VLAN filtering using general use mailbox
-- 
2.21.0

