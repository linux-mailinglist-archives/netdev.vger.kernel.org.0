Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D01F1247B
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 00:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbfEBWNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 18:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfEBWNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 18:13:06 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E87FC2080C;
        Thu,  2 May 2019 22:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556835186;
        bh=KKLfZ+ci/tC9OpwEWCcanP68a+8eJOm0t1Htpg05ZCU=;
        h=From:To:Cc:Subject:Date:From;
        b=eLGxQJD59DMPASSVPVUBLfE6yXXsy5g7xGGF637JlhIa1ZUT3LXYgzf0/Nv3PDiA4
         eY3dKlPMsQIr/ocWv7bBjRaubjxKs0hj02xiZ7UfmIgGfrxhfY1Tb5lfri8+hSPALq
         hqhEhO293arjN7fAcWSBa2R1uA/ngnk9laVDqAuM=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipmr_base: Do not reset index in mr_table_dump
Date:   Thu,  2 May 2019 15:14:15 -0700
Message-Id: <20190502221415.3542-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

e is the counter used to save the location of a dump when an
skb is filled. Once the walk of the table is complete, mr_table_dump
needs to return without resetting that index to 0. Dump of a specific
table is looping because of the reset because there is no way to
indicate the walk of the table is done.

Move the reset to the caller so the dump of each table starts at 0,
but the loop counter is maintained if a dump fills an skb.

Fixes: e1cedae1ba6b0 ("ipmr: Refactor mr_rtm_dumproute")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/ipmr_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index 3e614cc824f7..3a1af50bd0a5 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -335,8 +335,6 @@ int mr_table_dump(struct mr_table *mrt, struct sk_buff *skb,
 	}
 	spin_unlock_bh(lock);
 	err = 0;
-	e = 0;
-
 out:
 	cb->args[1] = e;
 	return err;
@@ -374,6 +372,7 @@ int mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb,
 		err = mr_table_dump(mrt, skb, cb, fill, lock, filter);
 		if (err < 0)
 			break;
+		cb->args[1] = 0;
 next_table:
 		t++;
 	}
-- 
2.11.0

