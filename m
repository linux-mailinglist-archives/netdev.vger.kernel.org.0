Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B0E99413
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388684AbfHVMoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:44:19 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44435 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387901AbfHVMoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:44:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Aug 2019 15:44:11 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7MCiAon025522;
        Thu, 22 Aug 2019 15:44:11 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 06/10] net: sched: conditionally obtain rtnl lock in cls hw offloads API
Date:   Thu, 22 Aug 2019 15:43:49 +0300
Message-Id: <20190822124353.16902-7-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190822124353.16902-1-vladbu@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
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
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/cls_api.c | 65 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 02a547aa77c0..bda42f1b5514 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3076,11 +3076,28 @@ __tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop, bool rtnl_held)
 {
+	bool take_rtnl = false;
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
+	bool take_rtnl = false;
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
@@ -3114,6 +3145,8 @@ int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
 	}
 errout:
 	up_read(&block->cb_lock);
+	if (take_rtnl)
+		rtnl_unlock();
 	return ok_count;
 }
 EXPORT_SYMBOL(tc_setup_cb_add);
@@ -3130,9 +3163,23 @@ int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
 			u32 *new_flags, unsigned int *new_in_hw_count,
 			bool rtnl_held)
 {
+	bool take_rtnl = false;
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
@@ -3153,6 +3200,8 @@ int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
 	}
 errout:
 	up_read(&block->cb_lock);
+	if (take_rtnl)
+		rtnl_unlock();
 	return ok_count;
 }
 EXPORT_SYMBOL(tc_setup_cb_replace);
@@ -3165,9 +3214,23 @@ int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
 			enum tc_setup_type type, void *type_data, bool err_stop,
 			u32 *flags, unsigned int *in_hw_count, bool rtnl_held)
 {
+	bool take_rtnl = false;
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
@@ -3175,6 +3238,8 @@ int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
 		tp->ops->hw_del(tp, type_data);
 
 	up_read(&block->cb_lock);
+	if (take_rtnl)
+		rtnl_unlock();
 	return ok_count;
 }
 EXPORT_SYMBOL(tc_setup_cb_destroy);
-- 
2.21.0

