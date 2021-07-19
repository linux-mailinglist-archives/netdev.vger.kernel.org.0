Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B005E3CF20F
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 04:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhGTBxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 21:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443887AbhGSXFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 19:05:21 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477A8C061767;
        Mon, 19 Jul 2021 16:41:35 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id gh6so9276408qvb.3;
        Mon, 19 Jul 2021 16:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tG3VNaXw5GOzMIsu0CiI5SvtjI+jDKkdFfqR2rMpbXQ=;
        b=ukHLi4nkEFU5WxlAaCJhPm4GSHtNNmHN+xODDOgQkICkx9CLlFvbvBhNIBonKE0fJg
         Ggl0q7FrCfw5psKcZbOcA1Awg1OodHbECGTMvBJ7ILivSLjEWJvHqh6YJxhmstdJEhyJ
         B4ks3IjMvc5pGWlvmIEkZMk/OKQdj4yc1TYIau+JiZAe9CTXepZkAipq5jd9aaKaBbmw
         EPg5FeoAzgE8ZJlfbZ5EiU8ZFn+f0cy/hUf7volywoSX8XeHfWFNcxo9Kd7/ApocefMa
         BG2l0zy0o5Qm3AeaxilP2Qw8mesVRimXoojBWYpoYids/odf3d+QBQYpPqA3o5PuLXiD
         yS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tG3VNaXw5GOzMIsu0CiI5SvtjI+jDKkdFfqR2rMpbXQ=;
        b=YX0JcxbUNLxbtfIYXs/0H8uwTVoLvniVrj+MA5ILhL5lhGX16pLcNqkSlVuN2pdHBa
         QTiqWF+aaMADsk3caC811tCFjm5I1NXPjcr/rOcK9HABc7kI2uUpPlExR6UIAWCxM95h
         tuUA0lGL71UpEJ3U65uB+7cvTiPfb4qaAht9Q43A9xWmmozyW6X3xINf6UaH2G28PluH
         rOb0mcPk7PVen/CoqXuLZw8ZasAhX42PJKeGBBUOvjbYeY/TpkH9wyvle2Au0zXzPTY2
         z4ZEBs/NTVaGByJn0Cd6Lvmwik421iRScCHoaJXIXdHD+f7o7G3rtq6xLCahakDS+XXE
         f3pA==
X-Gm-Message-State: AOAM533XkjxPHidiI3UMvVcX4Qjdk86khjie3bBzH9G4oGonLRCPO05v
        kccTtxXXr4ext2VIfxm+2w==
X-Google-Smtp-Source: ABdhPJyw8paABx4qYfJX/57pB1bFva0Goisp+bJsoBNRvSMQ1zD/qE054Th1ZxDlCQ55ru0Oyztmhg==
X-Received: by 2002:a05:6214:1882:: with SMTP id cx2mr27485724qvb.2.1626738094460;
        Mon, 19 Jul 2021 16:41:34 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id l12sm124689qtx.45.2021.07.19.16.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 16:41:33 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net] net/sched: act_skbmod: Skip non-Ethernet packets
Date:   Mon, 19 Jul 2021 16:41:24 -0700
Message-Id: <20210719234124.18383-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Currently tcf_skbmod_act() assumes that packets use Ethernet as their L2
protocol, which is not always the case.  As an example, for CAN devices:

	$ ip link add dev vcan0 type vcan
	$ ip link set up vcan0
	$ tc qdisc add dev vcan0 root handle 1: htb
	$ tc filter add dev vcan0 parent 1: protocol ip prio 10 \
		matchall action skbmod swap mac

Doing the above silently corrupts all the packets.  Do not perform skbmod
actions for non-Ethernet packets.

Fixes: 86da71b57383 ("net_sched: Introduce skbmod action")
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/act_skbmod.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 81a1c67335be..8d17a543cc9f 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -6,6 +6,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/if_arp.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
@@ -33,6 +34,13 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
 	tcf_lastuse_update(&d->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(d->common.cpu_bstats), skb);
 
+	action = READ_ONCE(d->tcf_action);
+	if (unlikely(action == TC_ACT_SHOT))
+		goto drop;
+
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER)
+		return action;
+
 	/* XXX: if you are going to edit more fields beyond ethernet header
 	 * (example when you add IP header replacement or vlan swap)
 	 * then MAX_EDIT_LEN needs to change appropriately
@@ -41,10 +49,6 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
 	if (unlikely(err)) /* best policy is to drop on the floor */
 		goto drop;
 
-	action = READ_ONCE(d->tcf_action);
-	if (unlikely(action == TC_ACT_SHOT))
-		goto drop;
-
 	p = rcu_dereference_bh(d->skbmod_p);
 	flags = p->flags;
 	if (flags & SKBMOD_F_DMAC)
-- 
2.20.1

