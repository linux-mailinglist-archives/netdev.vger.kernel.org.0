Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C94412B96E
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfL0SFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:05:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbfL0SDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:03:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48E922173E;
        Fri, 27 Dec 2019 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469786;
        bh=9ou5MNpUS1sANXm3BLDXni62ZoDMKIvRDc5ovsMkDpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTOTBpmTJrCHR5NFCFjDWNiLA82FbaXHiZ2Gjpr6qEaPhSXsSrVLOQYwBGb92WKxF
         RXf3o5W+oef8AwAPj235aOhCB2r2Urn1+Zq2CY1CMIHaFuu5y3dMm7ivy7ll8kEDsy
         Om903rmcNzrrpaErEi3zCL8XCw34j98B0bBjT5wE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 35/57] gtp: fix wrong condition in gtp_genl_dump_pdp()
Date:   Fri, 27 Dec 2019 13:02:00 -0500
Message-Id: <20191227180222.7076-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 94a6d9fb88df43f92d943c32b84ce398d50bf49f ]

gtp_genl_dump_pdp() is ->dumpit() callback of GTP module and it is used
to dump pdp contexts. it would be re-executed because of dump packet size.

If dump packet size is too big, it saves current dump pointer
(gtp interface pointer, bucket, TID value) then it restarts dump from
last pointer.
Current GTP code allows adding zero TID pdp context but dump code
ignores zero TID value. So, last dump pointer will not be found.

In addition, this patch adds missing rcu_read_lock() in
gtp_genl_dump_pdp().

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 0522cbdce44a..52628a9986b1 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -42,7 +42,6 @@ struct pdp_ctx {
 	struct hlist_node	hlist_addr;
 
 	union {
-		u64		tid;
 		struct {
 			u64	tid;
 			u16	flow;
@@ -1247,43 +1246,46 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
 	struct gtp_dev *last_gtp = (struct gtp_dev *)cb->args[2], *gtp;
+	int i, j, bucket = cb->args[0], skip = cb->args[1];
 	struct net *net = sock_net(skb->sk);
-	struct gtp_net *gn = net_generic(net, gtp_net_id);
-	unsigned long tid = cb->args[1];
-	int i, k = cb->args[0], ret;
 	struct pdp_ctx *pctx;
+	struct gtp_net *gn;
+
+	gn = net_generic(net, gtp_net_id);
 
 	if (cb->args[4])
 		return 0;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(gtp, &gn->gtp_dev_list, list) {
 		if (last_gtp && last_gtp != gtp)
 			continue;
 		else
 			last_gtp = NULL;
 
-		for (i = k; i < gtp->hash_size; i++) {
-			hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i], hlist_tid) {
-				if (tid && tid != pctx->u.tid)
-					continue;
-				else
-					tid = 0;
-
-				ret = gtp_genl_fill_info(skb,
-							 NETLINK_CB(cb->skb).portid,
-							 cb->nlh->nlmsg_seq,
-							 cb->nlh->nlmsg_type, pctx);
-				if (ret < 0) {
+		for (i = bucket; i < gtp->hash_size; i++) {
+			j = 0;
+			hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i],
+						 hlist_tid) {
+				if (j >= skip &&
+				    gtp_genl_fill_info(skb,
+					    NETLINK_CB(cb->skb).portid,
+					    cb->nlh->nlmsg_seq,
+					    cb->nlh->nlmsg_type, pctx)) {
 					cb->args[0] = i;
-					cb->args[1] = pctx->u.tid;
+					cb->args[1] = j;
 					cb->args[2] = (unsigned long)gtp;
 					goto out;
 				}
+				j++;
 			}
+			skip = 0;
 		}
+		bucket = 0;
 	}
 	cb->args[4] = 1;
 out:
+	rcu_read_unlock();
 	return skb->len;
 }
 
-- 
2.20.1

