Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CCF616269
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiKBMIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiKBMIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:08:36 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43B722516;
        Wed,  2 Nov 2022 05:08:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=chentao.kernel@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VTo8Xcs_1667390902;
Received: from VM20210331-5.tbsite.net(mailfrom:chentao.kernel@linux.alibaba.com fp:SMTPD_---0VTo8Xcs_1667390902)
          by smtp.aliyun-inc.com;
          Wed, 02 Nov 2022 20:08:30 +0800
From:   Tao Chen <chentao.kernel@linux.alibaba.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Petr Machata <petrm@nvidia.com>,
        Kees Cook <keescook@chromium.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Chen <chentao.kernel@linux.alibaba.com>
Subject: [PATCH net-next] netlink: Fix potential skb memleak in netlink_ack
Date:   Wed,  2 Nov 2022 20:08:20 +0800
Message-Id: <7a382b9503d10d235238ca55938bc933d92a1de7.1667389213.git.chentao.kernel@linux.alibaba.com>
X-Mailer: git-send-email 2.2.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should clean the skb resource if nlmsg_put/append failed
, so fix it.

Fiexs: commit 738136a0e375 ("netlink: split up copies in the
ack construction")
Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
---
 net/netlink/af_netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c6b8207e..9d73dae 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2500,7 +2500,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 
 	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
 	if (!skb)
-		goto err_bad_put;
+		goto err_skb;
 
 	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
 			NLMSG_ERROR, sizeof(*errmsg), flags);
@@ -2528,6 +2528,8 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	return;
 
 err_bad_put:
+	kfree_skb(skb);
+err_skb:
 	NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
 	sk_error_report(NETLINK_CB(in_skb).sk);
 }
-- 
2.2.1

