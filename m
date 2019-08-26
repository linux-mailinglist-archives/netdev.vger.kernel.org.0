Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF409D0EA
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732117AbfHZNp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:45:26 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52960 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732062AbfHZNpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 09:45:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Aug 2019 16:45:15 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7QDjEFU000366;
        Mon, 26 Aug 2019 16:45:15 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v3 06/10] net: sched: conditionally obtain rtnl lock in cls hw offloads API
Date:   Mon, 26 Aug 2019 16:45:02 +0300
Message-Id: <20190826134506.9705-7-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190826134506.9705-1-vladbu@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to remove dependency on rtnl lock from offloads code of
classifiers, take rtnl lock conditionally before executing driver
callbacks. Only obtain rtnl lock if block is bound to devices that require
it.

Block bind/unbind code is rtnl-locked and obtains block->cb_lock while
holding rtnl lock. Obtain locks in same order in tc_setup_cb_*() functions
to prevent deadlock.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---

Notes:
    Changes from V2 to V3:
      - Don't speculatively take rtnl lock when caller already has it.
    
    Changes from V1 to V2:
      - Speculatively read block->lockeddevcnt in tc_setup_cb_*() to obtain rtnl
        mutex without retry when block is bound to locked device.

 net/sched/cls_api.c | 65 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 1a39779bdbad..3c103cf9fd0d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3076,11 +3076,28 @@ __tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop, bool rtnl_held)
 {
+	bool take_rtnl = READ_ONCE(block->lockeddevcnt) && !rtnl_held;
 	int ok_count;
 
+retry:
+	if (take_rtnl)
+		rtnl_lock();
 	down_read(&block->cb_lock);
+	/* Need to obtain rtnl lock if block is bound to devs that require it.
+	 * In block bind code cb_lock is obtained while holding rtnl, so we must
+	 * obtain the locks in same order here.
+	 */
+	if (!rtnl_held && !take_rtnl && block->lockeddevcnt) {
+		up_read(&block->cb_lock);
+		take_rtnl = true;
+		goto retry;
+	}
+
 	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
+
 	up_read(&block->cb_lock);
+	if (take_rtnl)
+		rtnl_unlock();
 	return ok_count;
 }
 EXPORT_SYMBOL(tc_setup_cb_call);
@@ -3095,9 +3112,23 @@ int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
 		    enum tc_setup_type type, void *type_data, bool err_stop,
 		    u32 *flags, unsigned int *in_hw_count, bool rtnl_held)
 {
+	bool take_rtnl = READ_ONCE(block->lockeddevcnt) && !rtnl_held;
 	int ok_count;
 
+retry:
+	if (take_rtnl)
+		rtnl_lock();
 	down_read(&block->cb_lock);
+	/* Need to obtain rtnl lock if block is bound to devs that require it.
+	 * In block bind code cb_lock is obtained while holding rtnl, so we must
+	 * obtain the locks in same order here.
+	 */
+	if (!rtnl_held && !take_rtnl && block->lockeddevcnt) {
+		up_read(&block->cb_lock);
+		take_rtnl = true;
+		goto retry;
+	}
+
 	/* Make sure all netdevs sharing this block are offload-capable. */
 	if (block->nooffloaddevcnt && err_stop) {
 		ok_count = -EOPNOTSUPP;
@@ -3115,6 +3146,8 @@ int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
 					  ok_count, true);
 err_unlock:
 	up_read(&block->cb_lock);
+	if (take_rtnl)
+		rtnl_unlock();
 	return ok_count < 0 ? ok_count : 0;
 }
 EXPORT_SYMBOL(tc_setup_cb_add);
@@ -3131,9 +3164,23 @@ int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
 			u32 *new_flags, unsigned int *new_in_hw_count,
 			bool rtnl_held)
 {
+	bool take_rtnl = READ_ONCE(block->lockeddevcnt) && !rtnl_held;
 	int ok_count;
 
+retry:
+	if (take_rtnl)
+		rtnl_lock();
 	down_read(&block->cb_lock);
+	/* Need to obtain rtnl lock if block is bound to devs that require it.
+	 * In block bind code cb_lock is obtained while holding rtnl, so we must
+	 * obtain the locks in same order here.
+	 */
+	if (!rtnl_held && !take_rtnl && block->lockeddevcnt) {
+		up_read(&block->cb_lock);
+		take_rtnl = true;
+		goto retry;
+	}
+
 	/* Make sure all netdevs sharing this block are offload-capable. */
 	if (block->nooffloaddevcnt && err_stop) {
 		ok_count = -EOPNOTSUPP;
@@ -3155,6 +3202,8 @@ int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
 					  new_flags, ok_count, true);
 err_unlock:
 	up_read(&block->cb_lock);
+	if (take_rtnl)
+		rtnl_unlock();
 	return ok_count < 0 ? ok_count : 0;
 }
 EXPORT_SYMBOL(tc_setup_cb_replace);
@@ -3167,9 +3216,23 @@ int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
 			enum tc_setup_type type, void *type_data, bool err_stop,
 			u32 *flags, unsigned int *in_hw_count, bool rtnl_held)
 {
+	bool take_rtnl = READ_ONCE(block->lockeddevcnt) && !rtnl_held;
 	int ok_count;
 
+retry:
+	if (take_rtnl)
+		rtnl_lock();
 	down_read(&block->cb_lock);
+	/* Need to obtain rtnl lock if block is bound to devs that require it.
+	 * In block bind code cb_lock is obtained while holding rtnl, so we must
+	 * obtain the locks in same order here.
+	 */
+	if (!rtnl_held && !take_rtnl && block->lockeddevcnt) {
+		up_read(&block->cb_lock);
+		take_rtnl = true;
+		goto retry;
+	}
+
 	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
 
 	tc_cls_offload_cnt_reset(block, tp, in_hw_count, flags);
@@ -3177,6 +3240,8 @@ int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
 		tp->ops->hw_del(tp, type_data);
 
 	up_read(&block->cb_lock);
+	if (take_rtnl)
+		rtnl_unlock();
 	return ok_count < 0 ? ok_count : 0;
 }
 EXPORT_SYMBOL(tc_setup_cb_destroy);
-- 
2.21.0

