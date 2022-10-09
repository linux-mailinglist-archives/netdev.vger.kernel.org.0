Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65285F90BC
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiJIW06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiJIWZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:25:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C747A3DF2C;
        Sun,  9 Oct 2022 15:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 105ACB80E03;
        Sun,  9 Oct 2022 22:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F36EC43142;
        Sun,  9 Oct 2022 22:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353809;
        bh=f2w/2K2Wr7zpiCFVTdrTiVCurVGndA9EOEHywhstOgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f20Q0bDuKr6MfYaFJ47TtetKT6dJc7bsaCtmPnnomC2MbD9SDcaMh6IE6PW2qd0Ri
         Y8CvN2xdac2Wwq54hWMYIEF9msNgbDM6GT1P6PfyunzH/4+RJFxqJXfmiNJRmFtLSp
         zfWvk1e5fUeGRSOZ5MiI+ASLPhLQNSrKkJ/IjSuLIeoMO/JtHVnQgiv2egUpoB10Zs
         ZBUpFyxOONhP74AmgswZ2bgsmxJkKjnstjPXZLJCxT5gr4dY4oCM2UUpLLe0f6/VGS
         Xxg1UaDlAZtuCi5K/4CjyB6pPvSgylS1mE359rGaZpI/4CL6N1arKOKM4rIS1t/wnz
         0NavHxfDhGl3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        wsa+renesas@sang-engineering.com, horms@verge.net.au,
        johannes@sipsolutions.net, socketcan@hartkopp.net,
        petrm@nvidia.com, harshit.m.mogalapalli@oracle.com
Subject: [PATCH AUTOSEL 5.19 29/73] netlink: Bounds-check struct nlmsgerr creation
Date:   Sun,  9 Oct 2022 18:14:07 -0400
Message-Id: <20221009221453.1216158-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 710d21fdff9a98d621cd4e64167f3ef8af4e2fd1 ]

In preparation for FORTIFY_SOURCE doing bounds-check on memcpy(),
switch from __nlmsg_put to nlmsg_put(), and explain the bounds check
for dealing with the memcpy() across a composite flexible array struct.
Avoids this future run-time warning:

  memcpy: detected field-spanning write (size 32) of single field "&errmsg->msg" at net/netlink/af_netlink.c:2447 (size 16)

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: syzbot <syzkaller@googlegroups.com>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220901071336.1418572-1-keescook@chromium.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 8 +++++---
 net/netlink/af_netlink.c          | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 16ae92054baa..6b31746f9be3 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1719,11 +1719,13 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		skb2 = nlmsg_new(payload, GFP_KERNEL);
 		if (!skb2)
 			return -ENOMEM;
-		rep = __nlmsg_put(skb2, NETLINK_CB(skb).portid,
-				  nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
+		rep = nlmsg_put(skb2, NETLINK_CB(skb).portid,
+				nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
 		errmsg = nlmsg_data(rep);
 		errmsg->error = ret;
-		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
+		unsafe_memcpy(&errmsg->msg, nlh, nlh->nlmsg_len,
+			      /* Bounds checked by the skb layer. */);
+
 		cmdattr = (void *)&errmsg->msg + min_len;
 
 		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0cd91f813a3b..d8d3ed2096a3 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2440,11 +2440,13 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		return;
 	}
 
-	rep = __nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
-			  NLMSG_ERROR, payload, flags);
+	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
+			NLMSG_ERROR, payload, flags);
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
-	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
+	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
+					 ? nlh->nlmsg_len : sizeof(*nlh),
+		      /* Bounds checked by the skb layer. */);
 
 	if (nlk_has_extack && extack) {
 		if (extack->_msg) {
-- 
2.35.1

