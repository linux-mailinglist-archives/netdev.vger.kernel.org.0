Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB85E3D1C60
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 05:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGVCnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 22:43:25 -0400
Received: from out2.migadu.com ([188.165.223.204]:49695 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhGVCnZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 22:43:25 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626924239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cKa+ywSRqP2GgvUqE2f7IzaLkIEmcnLx3Z1I9lknd/o=;
        b=ipT2f6xhZE+GkIXRXKFtJ9TDI9PQ+y4InJVOdwh+cgO6eo7RE2Wm29YFS6hinS6aHV1G2x
        Ad9XI7Z9tP6QeIZWPKEvOFvCDgMQWDDP47rrIdDqj7OPNWbXogk8VI0vbJfgDzdxlL/XSg
        /iw+A4UH1edKQYFekdzXLpoUcnaTeQk=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     jhs@mojatatu.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] net: sched: cls_api: Fix the the wrong parameter
Date:   Thu, 22 Jul 2021 11:23:43 +0800
Message-Id: <20210722032343.7178-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 4th parameter in tc_chain_notify() should be flags rather than seq.
Let's change it back correctly.

Fixes: 32a4f5ecd738 ("net: sched: introduce chain object to uapi")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c8cb59a11098..1167cd0be179 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2897,7 +2897,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		break;
 	case RTM_GETCHAIN:
 		err = tc_chain_notify(chain, skb, n->nlmsg_seq,
-				      n->nlmsg_seq, n->nlmsg_type, true);
+				      n->nlmsg_flags, n->nlmsg_type, true);
 		if (err < 0)
 			NL_SET_ERR_MSG(extack, "Failed to send chain notify message");
 		break;
-- 
2.32.0

