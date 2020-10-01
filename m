Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D650A280AB6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387465AbgJAXAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733246AbgJAW7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 18:59:46 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C196207FB;
        Thu,  1 Oct 2020 22:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601593186;
        bh=3iiYtV6iQ1LqEnDko+q6MrC5X0T6dZzYAe+t+V3NKjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfJIf+lJQBnSG7y776vl/4w8TrUO2qSJ1WHA9pUDdMkFZQC3Mkt8flzYh1hm37FPn
         8rTVWj1Lw+T7hhcXupzJ9ACwKcTUTXmdsN48unZMdVPedvlOuV/rHgJ4yTpM2XIuNb
         gbI44bgXB1/+R4Z5uETCfmnD/I8teQl54TOY7jY4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 08/10] genetlink: use parsed attrs in dumppolicy
Date:   Thu,  1 Oct 2020 15:59:31 -0700
Message-Id: <20201001225933.1373426-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001225933.1373426-1-kuba@kernel.org>
References: <20201001225933.1373426-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attributes are already parsed based on the policy specified
in the family and ready-to-use in info->attrs. No need to
call genlmsg_parse() again.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 2a3608cfb179..9e50a8e4abf9 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1117,18 +1117,13 @@ struct ctrl_dump_policy_ctx {
 
 static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 {
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
-	struct nlattr *tb[CTRL_ATTR_MAX + 1];
+	struct nlattr **tb = info->attrs;
 	const struct genl_family *rt;
-	int err;
 
 	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
-	err = genlmsg_parse(cb->nlh, &genl_ctrl, tb, genl_ctrl.maxattr,
-			    genl_ctrl.policy, cb->extack);
-	if (err)
-		return err;
-
 	if (!tb[CTRL_ATTR_FAMILY_ID] && !tb[CTRL_ATTR_FAMILY_NAME])
 		return -EINVAL;
 
-- 
2.26.2

