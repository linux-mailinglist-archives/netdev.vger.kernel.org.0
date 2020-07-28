Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9123162E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgG1XPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbgG1XPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 19:15:18 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2182074F;
        Tue, 28 Jul 2020 23:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595978118;
        bh=JtlM6EI87LpZCJNQlFH9vE+J/6hwipNvLFYT+KMovEI=;
        h=From:To:Cc:Subject:Date:From;
        b=UZTx6+bNI93NioQufc+tAkaKKGY5NoGHSfU7jbglaouEgYFGwrcO2u/NbsneTmmDp
         3Tu70PqBnyO4i4ZJKIaFveGr0KILNwQ10TqAMimdwwBtpgyoYFIEYUQ7rA+LqFuu/h
         o5mIdyDnXwbGOvJddngdr9VlbdCmkTeMIHjB60j8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@mellanox.com,
        kernel-team@fb.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] devlink: ignore -EOPNOTSUPP errors on dumpit
Date:   Tue, 28 Jul 2020 16:15:07 -0700
Message-Id: <20200728231507.426387-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Number of .dumpit functions try to ignore -EOPNOTSUPP errors.
Recent change missed that, and started reporting all errors
but -EMSGSIZE back from dumps. This leads to situation like
this:

$ devlink dev info
devlink answers: Operation not supported

Dump should not report an error just because the last device
to be queried could not provide an answer.

To fix this and avoid similar confusion make sure we clear
err properly, and not leave it set to an error if we don't
terminate the iteration.

Fixes: c62c2cfb801b ("net: devlink: don't ignore errors during dumpit")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/devlink.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2cafbc808b09..1d38b6651b23 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1065,7 +1065,9 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 						   devlink_sb,
 						   NETLINK_CB(cb->skb).portid,
 						   cb->nlh->nlmsg_seq);
-			if (err && err != -EOPNOTSUPP) {
+			if (err == -EOPNOTSUPP) {
+				err = 0;
+			} else if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -1266,7 +1268,9 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 							devlink, devlink_sb,
 							NETLINK_CB(cb->skb).portid,
 							cb->nlh->nlmsg_seq);
-			if (err && err != -EOPNOTSUPP) {
+			if (err == -EOPNOTSUPP) {
+				err = 0;
+			} else if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -1498,7 +1502,9 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 							   devlink_sb,
 							   NETLINK_CB(cb->skb).portid,
 							   cb->nlh->nlmsg_seq);
-			if (err && err != -EOPNOTSUPP) {
+			if (err == -EOPNOTSUPP) {
+				err = 0;
+			} else if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -3299,7 +3305,9 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NLM_F_MULTI);
-			if (err && err != -EOPNOTSUPP) {
+			if (err == -EOPNOTSUPP) {
+				err = 0;
+			} else if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -3569,7 +3577,9 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 						NETLINK_CB(cb->skb).portid,
 						cb->nlh->nlmsg_seq,
 						NLM_F_MULTI);
-				if (err && err != -EOPNOTSUPP) {
+				if (err == -EOPNOTSUPP) {
+					err = 0;
+				} else if (err) {
 					mutex_unlock(&devlink->lock);
 					goto out;
 				}
@@ -4518,7 +4528,9 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
 					   cb->extack);
 		mutex_unlock(&devlink->lock);
-		if (err && err != -EOPNOTSUPP)
+		if (err == -EOPNOTSUPP)
+			err = 0;
+		else if (err)
 			break;
 		idx++;
 	}
-- 
2.26.2

