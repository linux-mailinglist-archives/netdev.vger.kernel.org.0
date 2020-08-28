Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF34E255B7E
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 15:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgH1Npq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 09:45:46 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:34538 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729417AbgH1Nbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 09:31:52 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 905F944A9B6;
        Fri, 28 Aug 2020 15:31:07 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1kBeTD-0005xA-FX; Fri, 28 Aug 2020 15:31:07 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 2/2] gtp: relax alloc constraint when adding a pdp
Date:   Fri, 28 Aug 2020 15:30:56 +0200
Message-Id: <20200828133056.22751-3-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200828133056.22751-1-nicolas.dichtel@6wind.com>
References: <20200828133056.22751-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a PDP context is added, the rtnl lock is held, thus no need to force
a GFP_ATOMIC.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 drivers/net/gtp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 6f871ec31393..2ed1e82a8ad8 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1036,7 +1036,7 @@ static void pdp_context_delete(struct pdp_ctx *pctx)
 	call_rcu(&pctx->rcu_head, pdp_context_free);
 }
 
-static int gtp_tunnel_notify(struct pdp_ctx *pctx, u8 cmd);
+static int gtp_tunnel_notify(struct pdp_ctx *pctx, u8 cmd, gfp_t allocation);
 
 static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 {
@@ -1094,7 +1094,7 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 	if (IS_ERR(pctx)) {
 		err = PTR_ERR(pctx);
 	} else {
-		gtp_tunnel_notify(pctx, GTP_CMD_NEWPDP);
+		gtp_tunnel_notify(pctx, GTP_CMD_NEWPDP, GFP_KERNEL);
 		err = 0;
 	}
 
@@ -1166,7 +1166,7 @@ static int gtp_genl_del_pdp(struct sk_buff *skb, struct genl_info *info)
 		netdev_dbg(pctx->dev, "GTPv1-U: deleting tunnel id = %x/%x (pdp %p)\n",
 			   pctx->u.v1.i_tei, pctx->u.v1.o_tei, pctx);
 
-	gtp_tunnel_notify(pctx, GTP_CMD_DELPDP);
+	gtp_tunnel_notify(pctx, GTP_CMD_DELPDP, GFP_ATOMIC);
 	pdp_context_delete(pctx);
 
 out_unlock:
@@ -1220,12 +1220,12 @@ static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
 	return -EMSGSIZE;
 }
 
-static int gtp_tunnel_notify(struct pdp_ctx *pctx, u8 cmd)
+static int gtp_tunnel_notify(struct pdp_ctx *pctx, u8 cmd, gfp_t allocation)
 {
 	struct sk_buff *msg;
 	int ret;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, allocation);
 	if (!msg)
 		return -ENOMEM;
 
-- 
2.26.2

