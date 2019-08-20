Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF1D96C4E
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbfHTWdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731062AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uxjydkD/7Vpe331e6pJnW+AIz5qFMTsK6OIGFiodGPI=; b=SWmN+7go46GU5B+Mi+dCBt2Oaf
        6iwbPxLAeySt+tcLArsnoFps3mwUbubkGqM/D6OVD4pZgdwbwhpTOCLV+teYw1d7UppEkIjbQ6Lav
        T0TegY9HaUSxauf+9mDNhAnTf8A5s3irLAB8k01SNOY78xQ2vPPAHw0ipqxdl1FelF15bHSQKevOC
        UKO4z2oTDuAsoiktjD9+wQOGXowrPDstwvwSUVi5c6g0aiJm0ThBzaaDORzozkCZeGquHDWraT1yF
        DgM+a2BrMp2k/SdqA4vqxgQFoB7d5AqiryjRn+mgRhka7C0/1lboBhtrjqMwvvPkJG5/OEY6DIHeL
        zecLw13g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005t0-JH; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 36/38] netlink: Convert genl_fam_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:57 -0700
Message-Id: <20190820223259.22348-37-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Straightforward conversion without touching the locking.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/netlink/genetlink.c | 46 +++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index efccd1ac9a66..02f5c7453f84 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -18,7 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/bitmap.h>
 #include <linux/rwsem.h>
-#include <linux/idr.h>
+#include <linux/xarray.h>
 #include <net/sock.h>
 #include <net/genetlink.h>
 
@@ -60,7 +60,8 @@ static void genl_unlock_all(void)
 	up_write(&cb_lock);
 }
 
-static DEFINE_IDR(genl_fam_idr);
+static unsigned int genl_families_next;
+static DEFINE_XARRAY_ALLOC(genl_families);
 
 /*
  * Bitmap of multicast groups that are currently in use.
@@ -92,15 +93,15 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 
 static const struct genl_family *genl_family_find_byid(unsigned int id)
 {
-	return idr_find(&genl_fam_idr, id);
+	return xa_load(&genl_families, id);
 }
 
 static const struct genl_family *genl_family_find_byname(char *name)
 {
 	const struct genl_family *family;
-	unsigned int id;
+	unsigned long id;
 
-	idr_for_each_entry(&genl_fam_idr, family, id)
+	xa_for_each(&genl_families, id, family)
 		if (strcmp(family->name, name) == 0)
 			return family;
 
@@ -362,12 +363,10 @@ int genl_register_family(struct genl_family *family)
 	} else
 		family->attrbuf = NULL;
 
-	family->id = idr_alloc_cyclic(&genl_fam_idr, family,
-				      start, end + 1, GFP_KERNEL);
-	if (family->id < 0) {
-		err = family->id;
+	err = xa_alloc_cyclic(&genl_families, &family->id, family,
+			XA_LIMIT(start, end), &genl_families_next, GFP_KERNEL);
+	if (err < 0)
 		goto errout_free;
-	}
 
 	err = genl_validate_assign_mc_groups(family);
 	if (err)
@@ -384,7 +383,7 @@ int genl_register_family(struct genl_family *family)
 	return 0;
 
 errout_remove:
-	idr_remove(&genl_fam_idr, family->id);
+	xa_erase(&genl_families, family->id);
 errout_free:
 	kfree(family->attrbuf);
 errout_locked:
@@ -412,7 +411,7 @@ int genl_unregister_family(const struct genl_family *family)
 
 	genl_unregister_mc_groups(family);
 
-	idr_remove(&genl_fam_idr, family->id);
+	xa_erase(&genl_families, family->id);
 
 	up_write(&cb_lock);
 	wait_event(genl_sk_destructing_waitq,
@@ -802,28 +801,21 @@ static int ctrl_fill_mcgrp_info(const struct genl_family *family,
 
 static int ctrl_dumpfamily(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	int n = 0;
 	struct genl_family *rt;
 	struct net *net = sock_net(skb->sk);
-	int fams_to_skip = cb->args[0];
-	unsigned int id;
+	unsigned long id;
 
-	idr_for_each_entry(&genl_fam_idr, rt, id) {
+	xa_for_each_start(&genl_families, id, rt, cb->args[0]) {
 		if (!rt->netnsok && !net_eq(net, &init_net))
 			continue;
 
-		if (n++ < fams_to_skip)
-			continue;
-
 		if (ctrl_fill_info(rt, NETLINK_CB(cb->skb).portid,
 				   cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				   skb, CTRL_CMD_NEWFAMILY) < 0) {
-			n--;
+				   skb, CTRL_CMD_NEWFAMILY) < 0)
 			break;
-		}
 	}
 
-	cb->args[0] = n;
+	cb->args[0] = id;
 	return skb->len;
 }
 
@@ -993,11 +985,11 @@ static int genl_bind(struct net *net, int group)
 {
 	struct genl_family *f;
 	int err = -ENOENT;
-	unsigned int id;
+	unsigned long id;
 
 	down_read(&cb_lock);
 
-	idr_for_each_entry(&genl_fam_idr, f, id) {
+	xa_for_each(&genl_families, id, f) {
 		if (group >= f->mcgrp_offset &&
 		    group < f->mcgrp_offset + f->n_mcgrps) {
 			int fam_grp = group - f->mcgrp_offset;
@@ -1019,11 +1011,11 @@ static int genl_bind(struct net *net, int group)
 static void genl_unbind(struct net *net, int group)
 {
 	struct genl_family *f;
-	unsigned int id;
+	unsigned long id;
 
 	down_read(&cb_lock);
 
-	idr_for_each_entry(&genl_fam_idr, f, id) {
+	xa_for_each(&genl_families, id, f) {
 		if (group >= f->mcgrp_offset &&
 		    group < f->mcgrp_offset + f->n_mcgrps) {
 			int fam_grp = group - f->mcgrp_offset;
-- 
2.23.0.rc1

