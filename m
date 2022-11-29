Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1126963B992
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 06:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbiK2Fxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 00:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiK2Fxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 00:53:47 -0500
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F98046678;
        Mon, 28 Nov 2022 21:53:42 -0800 (PST)
Received: from ubuntu.localdomain (unknown [10.181.252.183])
        by mail-app4 (Coremail) with SMTP id cS_KCgBXzk1OnoVjutqmCA--.20752S2;
        Tue, 29 Nov 2022 13:53:25 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] net: Add a gfp_t parameter in ip_fib_metrics_init to support atomic context
Date:   Tue, 29 Nov 2022 13:53:17 +0800
Message-Id: <20221129055317.53788-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgBXzk1OnoVjutqmCA--.20752S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4kXF4DtryDAF47ArWrXwb_yoWrJr4xpF
        10kry3tF4UKry7W34kC3WkZrZxKw1xGFySkr10k39a93s8Wr1xXFy0g34YyF45CFW8Zaya
        gFyUKry7uFn8CrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk21xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
        JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUF9a9DUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgYJAVZdtcohawAIs6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ip_fib_metrics_init() do not support atomic context, because it
calls "kzalloc(..., GFP_KERNEL)". When ip_fib_metrics_init() is used
in atomic context, the sleep-in-atomic-context bug will happen.

For example, the neigh_proxy_process() is a timer handler that is
used to process the proxy request that is timeout. But it could call
ip_fib_metrics_init(). As a result, the can_block flag in ipv6_add_addr()
and the gfp_flags in addrconf_f6i_alloc() and ip6_route_info_create()
are useless. The process is shown below.

    (atomic context)
neigh_proxy_process()
  pndisc_redo()
    ndisc_recv_ns()
      addrconf_dad_failure()
        ipv6_add_addr(..., bool can_block)
          addrconf_f6i_alloc(..., gfp_t gfp_flags)
            ip6_route_info_create(..., gfp_t gfp_flags)
              ip_fib_metrics_init()
                kzalloc(..., GFP_KERNEL) //may sleep

This patch add a gfp_t parameter in ip_fib_metrics_init() in order to
support atomic context.

Fixes: f3d9832e56c4 ("ipv6: addrconf: cleanup locking in ipv6_add_addr")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 include/net/ip.h         | 2 +-
 net/ipv4/fib_semantics.c | 2 +-
 net/ipv4/metrics.c       | 4 ++--
 net/ipv6/route.c         | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 144bdfbb25a..1e99c9d6240 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -489,7 +489,7 @@ static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
 
 struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
 					int fc_mx_len,
-					struct netlink_ext_ack *extack);
+					struct netlink_ext_ack *extack, gfp_t gfp_flags);
 static inline void ip_fib_metrics_put(struct dst_metrics *fib_metrics)
 {
 	if (fib_metrics != &dst_default_metrics &&
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f721c308248..4a0793e7d34 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1450,7 +1450,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	if (!fi)
 		goto failure;
 	fi->fib_metrics = ip_fib_metrics_init(fi->fib_net, cfg->fc_mx,
-					      cfg->fc_mx_len, extack);
+					      cfg->fc_mx_len, extack, GFP_KERNEL);
 	if (IS_ERR(fi->fib_metrics)) {
 		err = PTR_ERR(fi->fib_metrics);
 		kfree(fi);
diff --git a/net/ipv4/metrics.c b/net/ipv4/metrics.c
index 25ea6ac44db..b0342603a6d 100644
--- a/net/ipv4/metrics.c
+++ b/net/ipv4/metrics.c
@@ -66,7 +66,7 @@ static int ip_metrics_convert(struct net *net, struct nlattr *fc_mx,
 
 struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
 					int fc_mx_len,
-					struct netlink_ext_ack *extack)
+					struct netlink_ext_ack *extack, gfp_t gfp_flags)
 {
 	struct dst_metrics *fib_metrics;
 	int err;
@@ -74,7 +74,7 @@ struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
 	if (!fc_mx)
 		return (struct dst_metrics *)&dst_default_metrics;
 
-	fib_metrics = kzalloc(sizeof(*fib_metrics), GFP_KERNEL);
+	fib_metrics = kzalloc(sizeof(*fib_metrics), gfp_flags);
 	if (unlikely(!fib_metrics))
 		return ERR_PTR(-ENOMEM);
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2f355f0ec32..2687e764a87 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3751,7 +3751,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		goto out;
 
 	rt->fib6_metrics = ip_fib_metrics_init(net, cfg->fc_mx, cfg->fc_mx_len,
-					       extack);
+					       extack, gfp_flags);
 	if (IS_ERR(rt->fib6_metrics)) {
 		err = PTR_ERR(rt->fib6_metrics);
 		/* Do not leave garbage there. */
-- 
2.17.1

