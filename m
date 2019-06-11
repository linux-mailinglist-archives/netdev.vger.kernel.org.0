Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE013C273
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391132AbfFKElD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:41:03 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41078 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391117AbfFKElC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:41:02 -0400
Received: by mail-qk1-f195.google.com with SMTP id c11so6832936qkk.8
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bPC30xCXnbhxbmq2x/T8tNV8hKM2GrGTm90rA483c7U=;
        b=uqQ1oRf1QHobrwbuYv5ajcQplIRLXrvyGqwKKd4Py4Gp1/wLLmLfLAclwbpFz5Ym+U
         VJuj2XkpWvBT3iWrdpx6EkE1JECZwBn0AOLq2eDzQGelhxyn5I5Eb3+UjkyqFOMfL2eW
         cQyCtnMCy93FZBr9/AdcRZcWmEavsW+vBTXyQT6d8StI2aSVHCIT9Jdj8zc9og60zQv1
         9hbQGiIvqJe5YOwO8r1DZyLipONdWxJhW4kuSqp+8oV40cHX/kh3/UnJKiWgVPTxKu3f
         6PvZuDzCvb04QI1RmnMsYoZsjLAsR3loTNjYxKCpUrm1w5B/1yL0ixjEasKc7KXIxzSf
         2H/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bPC30xCXnbhxbmq2x/T8tNV8hKM2GrGTm90rA483c7U=;
        b=aPtxa++2ar70QtfUx8XXbenwcKfqsIvXHX4Rd5xB4vzOjpTtlv6PI3mhdrGnQQH1Ke
         nze6QhprOFTw+Dp/kcRZMeyOfVjHvESE/S3OHWxeZWnLHdG16n0msNns/O00hGfz/rPl
         0oxzvr9lyIjXg1dAJZLEody3JSNYo33q5Z7kWIPAD3xvdI/jvRmjLOk+x/ZFnjN9CaLT
         MsYJ69ZbMqbHz5teHmdx8CNuXeA407KVYazpRhYMob3UyAgArzXJPhvqARarnYs8dPfK
         BSj+Xt3IACNZQ9m3nnembT04e0f98i62RY+SFEdbz6llK0ZIm2XBiZGC+CSP1vo6yaCn
         ULjA==
X-Gm-Message-State: APjAAAUyLiLKLHhMCRHhhJm45alGEJ+CtHCKG2tSoKnfYurvt1RIquHB
        YFW/GeXHiRMk6FBkWFo7gCU1wv+2TtY=
X-Google-Smtp-Source: APXvYqzyULHEvHiZ5ggnvtiU566VdJ5LHSt0bnWs/Obh0lc3oUUyC9S2yS4E+lk9xYnVsAXyDwKKvg==
X-Received: by 2002:a37:8002:: with SMTP id b2mr59464739qkd.289.1560228060109;
        Mon, 10 Jun 2019 21:41:00 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.40.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:40:59 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 07/12] nfp: add async version of mailbox communication
Date:   Mon, 10 Jun 2019 21:40:05 -0700
Message-Id: <20190611044010.29161-8-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some control messages must be sent from atomic context.  The mailbox
takes sleeping locks and uses a waitqueue so add a "posted" version
of communication.

Trylock the semaphore and if that's successful kick of the device
communication.  The device communication will be completed from
a workqueue, which will also release the semaphore.

If locks are taken queue the message and return.  Schedule a
different workqueue to take the semaphore and run the communication.
Note that the there are currently no atomic users which would actually
need the return value, so all replies to posted messages are just
freed.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/ccm.h      |   8 +-
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c | 175 ++++++++++++++++--
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  14 ++
 .../ethernet/netronome/nfp/nfp_net_common.c   |  40 +++-
 4 files changed, 215 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/ccm.h b/drivers/net/ethernet/netronome/nfp/ccm.h
index c905898ab26e..da1b1e20df51 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm.h
+++ b/drivers/net/ethernet/netronome/nfp/ccm.h
@@ -100,7 +100,7 @@ struct nfp_ccm {
 	u16 tag_alloc_last;
 
 	struct sk_buff_head replies;
-	struct wait_queue_head wq;
+	wait_queue_head_t wq;
 };
 
 int nfp_ccm_init(struct nfp_ccm *ccm, struct nfp_app *app);
@@ -110,6 +110,10 @@ struct sk_buff *
 nfp_ccm_communicate(struct nfp_ccm *ccm, struct sk_buff *skb,
 		    enum nfp_ccm_type type, unsigned int reply_size);
 
+int nfp_ccm_mbox_alloc(struct nfp_net *nn);
+void nfp_ccm_mbox_free(struct nfp_net *nn);
+int nfp_ccm_mbox_init(struct nfp_net *nn);
+void nfp_ccm_mbox_clean(struct nfp_net *nn);
 bool nfp_ccm_mbox_fits(struct nfp_net *nn, unsigned int size);
 struct sk_buff *
 nfp_ccm_mbox_msg_alloc(struct nfp_net *nn, unsigned int req_size,
@@ -118,4 +122,6 @@ int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
 			     enum nfp_ccm_type type,
 			     unsigned int reply_size,
 			     unsigned int max_reply_size);
+int nfp_ccm_mbox_post(struct nfp_net *nn, struct sk_buff *skb,
+		      enum nfp_ccm_type type, unsigned int max_reply_size);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
index 53995d53aa3f..02fccd90961d 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
+++ b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
@@ -41,12 +41,14 @@ enum nfp_net_mbox_cmsg_state {
  * @err:	error encountered during processing if any
  * @max_len:	max(request_len, reply_len)
  * @exp_reply:	expected reply length (0 means don't validate)
+ * @posted:	the message was posted and nobody waits for the reply
  */
 struct nfp_ccm_mbox_cmsg_cb {
 	enum nfp_net_mbox_cmsg_state state;
 	int err;
 	unsigned int max_len;
 	unsigned int exp_reply;
+	bool posted;
 };
 
 static u32 nfp_ccm_mbox_max_msg(struct nfp_net *nn)
@@ -65,6 +67,7 @@ nfp_ccm_mbox_msg_init(struct sk_buff *skb, unsigned int exp_reply, int max_len)
 	cb->err = 0;
 	cb->max_len = max_len;
 	cb->exp_reply = exp_reply;
+	cb->posted = false;
 }
 
 static int nfp_ccm_mbox_maxlen(const struct sk_buff *skb)
@@ -96,6 +99,20 @@ static void nfp_ccm_mbox_set_busy(struct sk_buff *skb)
 	cb->state = NFP_NET_MBOX_CMSG_STATE_BUSY;
 }
 
+static bool nfp_ccm_mbox_is_posted(struct sk_buff *skb)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb = (void *)skb->cb;
+
+	return cb->posted;
+}
+
+static void nfp_ccm_mbox_mark_posted(struct sk_buff *skb)
+{
+	struct nfp_ccm_mbox_cmsg_cb *cb = (void *)skb->cb;
+
+	cb->posted = true;
+}
+
 static bool nfp_ccm_mbox_is_first(struct nfp_net *nn, struct sk_buff *skb)
 {
 	return skb_queue_is_first(&nn->mbox_cmsg.queue, skb);
@@ -119,6 +136,8 @@ static void nfp_ccm_mbox_mark_next_runner(struct nfp_net *nn)
 
 	cb = (void *)skb->cb;
 	cb->state = NFP_NET_MBOX_CMSG_STATE_NEXT;
+	if (cb->posted)
+		queue_work(nn->mbox_cmsg.workq, &nn->mbox_cmsg.runq_work);
 }
 
 static void
@@ -205,9 +224,7 @@ static void nfp_ccm_mbox_copy_out(struct nfp_net *nn, struct sk_buff *last)
 	while (true) {
 		unsigned int length, offset, type;
 		struct nfp_ccm_hdr hdr;
-		__be32 *skb_data;
 		u32 tlv_hdr;
-		int i, cnt;
 
 		tlv_hdr = readl(data);
 		type = FIELD_GET(NFP_NET_MBOX_TLV_TYPE, tlv_hdr);
@@ -278,20 +295,26 @@ static void nfp_ccm_mbox_copy_out(struct nfp_net *nn, struct sk_buff *last)
 			goto next_tlv;
 		}
 
-		if (length <= skb->len)
-			__skb_trim(skb, length);
-		else
-			skb_put(skb, length - skb->len);
-
-		/* We overcopy here slightly, but that's okay, the skb is large
-		 * enough, and the garbage will be ignored (beyond skb->len).
-		 */
-		skb_data = (__be32 *)skb->data;
-		memcpy(skb_data, &hdr, 4);
-
-		cnt = DIV_ROUND_UP(length, 4);
-		for (i = 1 ; i < cnt; i++)
-			skb_data[i] = cpu_to_be32(readl(data + i * 4));
+		if (!cb->posted) {
+			__be32 *skb_data;
+			int i, cnt;
+
+			if (length <= skb->len)
+				__skb_trim(skb, length);
+			else
+				skb_put(skb, length - skb->len);
+
+			/* We overcopy here slightly, but that's okay,
+			 * the skb is large enough, and the garbage will
+			 * be ignored (beyond skb->len).
+			 */
+			skb_data = (__be32 *)skb->data;
+			memcpy(skb_data, &hdr, 4);
+
+			cnt = DIV_ROUND_UP(length, 4);
+			for (i = 1 ; i < cnt; i++)
+				skb_data[i] = cpu_to_be32(readl(data + i * 4));
+		}
 
 		cb->state = NFP_NET_MBOX_CMSG_STATE_REPLY_FOUND;
 next_tlv:
@@ -314,6 +337,14 @@ static void nfp_ccm_mbox_copy_out(struct nfp_net *nn, struct sk_buff *last)
 			smp_wmb(); /* order the cb->err vs. cb->state */
 		}
 		cb->state = NFP_NET_MBOX_CMSG_STATE_DONE;
+
+		if (cb->posted) {
+			if (cb->err)
+				nn_dp_warn(&nn->dp,
+					   "mailbox posted msg failed type:%u err:%d\n",
+					   nfp_ccm_get_type(skb), cb->err);
+			dev_consume_skb_any(skb);
+		}
 	} while (skb != last);
 
 	nfp_ccm_mbox_mark_next_runner(nn);
@@ -563,6 +594,89 @@ int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
 	return err;
 }
 
+static void nfp_ccm_mbox_post_runq_work(struct work_struct *work)
+{
+	struct sk_buff *skb;
+	struct nfp_net *nn;
+
+	nn = container_of(work, struct nfp_net, mbox_cmsg.runq_work);
+
+	spin_lock_bh(&nn->mbox_cmsg.queue.lock);
+
+	skb = __skb_peek(&nn->mbox_cmsg.queue);
+	if (WARN_ON(!skb || !nfp_ccm_mbox_is_posted(skb) ||
+		    !nfp_ccm_mbox_should_run(nn, skb))) {
+		spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+		return;
+	}
+
+	nfp_ccm_mbox_run_queue_unlock(nn);
+}
+
+static void nfp_ccm_mbox_post_wait_work(struct work_struct *work)
+{
+	struct sk_buff *skb;
+	struct nfp_net *nn;
+	int err;
+
+	nn = container_of(work, struct nfp_net, mbox_cmsg.wait_work);
+
+	skb = skb_peek(&nn->mbox_cmsg.queue);
+	if (WARN_ON(!skb || !nfp_ccm_mbox_is_posted(skb)))
+		/* Should never happen so it's unclear what to do here.. */
+		goto exit_unlock_wake;
+
+	err = nfp_net_mbox_reconfig_wait_posted(nn);
+	if (!err)
+		nfp_ccm_mbox_copy_out(nn, skb);
+	else
+		nfp_ccm_mbox_mark_all_err(nn, skb, -EIO);
+exit_unlock_wake:
+	nn_ctrl_bar_unlock(nn);
+	wake_up_all(&nn->mbox_cmsg.wq);
+}
+
+int nfp_ccm_mbox_post(struct nfp_net *nn, struct sk_buff *skb,
+		      enum nfp_ccm_type type, unsigned int max_reply_size)
+{
+	int err;
+
+	err = nfp_ccm_mbox_msg_prepare(nn, skb, type, 0, max_reply_size,
+				       GFP_ATOMIC);
+	if (err)
+		goto err_free_skb;
+
+	nfp_ccm_mbox_mark_posted(skb);
+
+	spin_lock_bh(&nn->mbox_cmsg.queue.lock);
+
+	err = nfp_ccm_mbox_msg_enqueue(nn, skb, type);
+	if (err)
+		goto err_unlock;
+
+	if (nfp_ccm_mbox_is_first(nn, skb)) {
+		if (nn_ctrl_bar_trylock(nn)) {
+			nfp_ccm_mbox_copy_in(nn, skb);
+			nfp_net_mbox_reconfig_post(nn,
+						   NFP_NET_CFG_MBOX_CMD_TLV_CMSG);
+			queue_work(nn->mbox_cmsg.workq,
+				   &nn->mbox_cmsg.wait_work);
+		} else {
+			nfp_ccm_mbox_mark_next_runner(nn);
+		}
+	}
+
+	spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+
+	return 0;
+
+err_unlock:
+	spin_unlock_bh(&nn->mbox_cmsg.queue.lock);
+err_free_skb:
+	dev_kfree_skb_any(skb);
+	return err;
+}
+
 struct sk_buff *
 nfp_ccm_mbox_msg_alloc(struct nfp_net *nn, unsigned int req_size,
 		       unsigned int reply_size, gfp_t flags)
@@ -589,3 +703,32 @@ bool nfp_ccm_mbox_fits(struct nfp_net *nn, unsigned int size)
 {
 	return nfp_ccm_mbox_max_msg(nn) >= size;
 }
+
+int nfp_ccm_mbox_init(struct nfp_net *nn)
+{
+	return 0;
+}
+
+void nfp_ccm_mbox_clean(struct nfp_net *nn)
+{
+	drain_workqueue(nn->mbox_cmsg.workq);
+}
+
+int nfp_ccm_mbox_alloc(struct nfp_net *nn)
+{
+	skb_queue_head_init(&nn->mbox_cmsg.queue);
+	init_waitqueue_head(&nn->mbox_cmsg.wq);
+	INIT_WORK(&nn->mbox_cmsg.wait_work, nfp_ccm_mbox_post_wait_work);
+	INIT_WORK(&nn->mbox_cmsg.runq_work, nfp_ccm_mbox_post_runq_work);
+
+	nn->mbox_cmsg.workq = alloc_workqueue("nfp-ccm-mbox", WQ_UNBOUND, 0);
+	if (!nn->mbox_cmsg.workq)
+		return -ENOMEM;
+	return 0;
+}
+
+void nfp_ccm_mbox_free(struct nfp_net *nn)
+{
+	destroy_workqueue(nn->mbox_cmsg.workq);
+	WARN_ON(!skb_queue_empty(&nn->mbox_cmsg.queue));
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 7bfc819d1e85..46305f181764 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -19,6 +19,7 @@
 #include <linux/pci.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/semaphore.h>
+#include <linux/workqueue.h>
 #include <net/xdp.h>
 
 #include "nfp_net_ctrl.h"
@@ -586,6 +587,9 @@ struct nfp_net_dp {
  * @mbox_cmsg:		Common Control Message via vNIC mailbox state
  * @mbox_cmsg.queue:	CCM mbox queue of pending messages
  * @mbox_cmsg.wq:	CCM mbox wait queue of waiting processes
+ * @mbox_cmsg.workq:	CCM mbox work queue for @wait_work and @runq_work
+ * @mbox_cmsg.wait_work:    CCM mbox posted msg reconfig wait work
+ * @mbox_cmsg.runq_work:    CCM mbox posted msg queue runner work
  * @mbox_cmsg.tag:	CCM mbox message tag allocator
  * @debugfs_dir:	Device directory in debugfs
  * @vnic_list:		Entry on device vNIC list
@@ -669,6 +673,9 @@ struct nfp_net {
 	struct {
 		struct sk_buff_head queue;
 		wait_queue_head_t wq;
+		struct workqueue_struct *workq;
+		struct work_struct wait_work;
+		struct work_struct runq_work;
 		u16 tag;
 	} mbox_cmsg;
 
@@ -886,6 +893,11 @@ static inline void nn_ctrl_bar_lock(struct nfp_net *nn)
 	down(&nn->bar_lock);
 }
 
+static inline bool nn_ctrl_bar_trylock(struct nfp_net *nn)
+{
+	return !down_trylock(&nn->bar_lock);
+}
+
 static inline void nn_ctrl_bar_unlock(struct nfp_net *nn)
 {
 	up(&nn->bar_lock);
@@ -927,6 +939,8 @@ void nfp_net_coalesce_write_cfg(struct nfp_net *nn);
 int nfp_net_mbox_lock(struct nfp_net *nn, unsigned int data_size);
 int nfp_net_mbox_reconfig(struct nfp_net *nn, u32 mbox_cmd);
 int nfp_net_mbox_reconfig_and_unlock(struct nfp_net *nn, u32 mbox_cmd);
+void nfp_net_mbox_reconfig_post(struct nfp_net *nn, u32 update);
+int nfp_net_mbox_reconfig_wait_posted(struct nfp_net *nn);
 
 unsigned int
 nfp_net_irqs_alloc(struct pci_dev *pdev, struct msix_entry *irq_entries,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 349678425aed..c9c43abb2427 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -40,6 +40,7 @@
 #include <net/vxlan.h>
 
 #include "nfpcore/nfp_nsp.h"
+#include "ccm.h"
 #include "nfp_app.h"
 #include "nfp_net_ctrl.h"
 #include "nfp_net.h"
@@ -229,6 +230,7 @@ static void nfp_net_reconfig_sync_enter(struct nfp_net *nn)
 
 	spin_lock_bh(&nn->reconfig_lock);
 
+	WARN_ON(nn->reconfig_sync_present);
 	nn->reconfig_sync_present = true;
 
 	if (nn->reconfig_timer_active) {
@@ -341,6 +343,24 @@ int nfp_net_mbox_reconfig(struct nfp_net *nn, u32 mbox_cmd)
 	return -nn_readl(nn, mbox + NFP_NET_CFG_MBOX_SIMPLE_RET);
 }
 
+void nfp_net_mbox_reconfig_post(struct nfp_net *nn, u32 mbox_cmd)
+{
+	u32 mbox = nn->tlv_caps.mbox_off;
+
+	nn_writeq(nn, mbox + NFP_NET_CFG_MBOX_SIMPLE_CMD, mbox_cmd);
+
+	nfp_net_reconfig_post(nn, NFP_NET_CFG_UPDATE_MBOX);
+}
+
+int nfp_net_mbox_reconfig_wait_posted(struct nfp_net *nn)
+{
+	u32 mbox = nn->tlv_caps.mbox_off;
+
+	nfp_net_reconfig_wait_posted(nn);
+
+	return -nn_readl(nn, mbox + NFP_NET_CFG_MBOX_SIMPLE_RET);
+}
+
 int nfp_net_mbox_reconfig_and_unlock(struct nfp_net *nn, u32 mbox_cmd)
 {
 	int ret;
@@ -3814,14 +3834,15 @@ nfp_net_alloc(struct pci_dev *pdev, void __iomem *ctrl_bar, bool needs_netdev,
 
 	timer_setup(&nn->reconfig_timer, nfp_net_reconfig_timer, 0);
 
-	skb_queue_head_init(&nn->mbox_cmsg.queue);
-	init_waitqueue_head(&nn->mbox_cmsg.wq);
-
 	err = nfp_net_tlv_caps_parse(&nn->pdev->dev, nn->dp.ctrl_bar,
 				     &nn->tlv_caps);
 	if (err)
 		goto err_free_nn;
 
+	err = nfp_ccm_mbox_alloc(nn);
+	if (err)
+		goto err_free_nn;
+
 	return nn;
 
 err_free_nn:
@@ -3839,7 +3860,7 @@ nfp_net_alloc(struct pci_dev *pdev, void __iomem *ctrl_bar, bool needs_netdev,
 void nfp_net_free(struct nfp_net *nn)
 {
 	WARN_ON(timer_pending(&nn->reconfig_timer) || nn->reconfig_posted);
-	WARN_ON(!skb_queue_empty(&nn->mbox_cmsg.queue));
+	nfp_ccm_mbox_free(nn);
 
 	if (nn->dp.netdev)
 		free_netdev(nn->dp.netdev);
@@ -4117,9 +4138,13 @@ int nfp_net_init(struct nfp_net *nn)
 	if (nn->dp.netdev) {
 		nfp_net_netdev_init(nn);
 
-		err = nfp_net_tls_init(nn);
+		err = nfp_ccm_mbox_init(nn);
 		if (err)
 			return err;
+
+		err = nfp_net_tls_init(nn);
+		if (err)
+			goto err_clean_mbox;
 	}
 
 	nfp_net_vecs_init(nn);
@@ -4127,6 +4152,10 @@ int nfp_net_init(struct nfp_net *nn)
 	if (!nn->dp.netdev)
 		return 0;
 	return register_netdev(nn->dp.netdev);
+
+err_clean_mbox:
+	nfp_ccm_mbox_clean(nn);
+	return err;
 }
 
 /**
@@ -4139,5 +4168,6 @@ void nfp_net_clean(struct nfp_net *nn)
 		return;
 
 	unregister_netdev(nn->dp.netdev);
+	nfp_ccm_mbox_clean(nn);
 	nfp_net_reconfig_wait_posted(nn);
 }
-- 
2.21.0

