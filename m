Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435504F9231
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiDHJuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 05:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiDHJt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 05:49:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AFE1CB02
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 02:47:55 -0700 (PDT)
From:   Benedikt Spranger <b.spranger@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649411273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8CGxrXEFgnIqv2h6Y/g8r7gRBG1P1y9nGvgryU7amx0=;
        b=Ii0eWYiI/A9ZzFju4fQ9Wb3wnxWqyMDJcVvtwGt89998zFV/mzFk8HUg3CfLztQfL5+56U
        hA22vSUvIxRVxVvt7YRXxu3OBX0235ZGAbzcLymGVa9YGh6om//GhNJ24qQ/9s1/2lZYFG
        9JdlWzm1vx3D0G2GpQmSBykQ5ULO8UhFAlAALTSZMobbaQd1E/u7MENwgwKZugVJzBPeis
        UTRDUPHmPXfBzTI4bv3zv1mPCXNwrL4zK9hMhVAPYTsm94zA6kYxBz64dWOfGYSdDdDI+F
        51zar8o+08HO0Tan2yCr45ooep7dd5qeUpvfrnvJ8ExSegAa34IKJY+iZYVwAA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649411273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8CGxrXEFgnIqv2h6Y/g8r7gRBG1P1y9nGvgryU7amx0=;
        b=ZW+P012U/oHojbz7UO9ztcTpEpefSX+wFbzkJwBtDLJCaSaiQINvnsB/P0X+9bl8DM0tX7
        zw2m9SlGBqK6inAA==
To:     netdev@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH v2 1/1] net/sched: taprio: Check if socket flags are valid
Date:   Fri,  8 Apr 2022 11:47:45 +0200
Message-Id: <20220408094745.3129754-2-b.spranger@linutronix.de>
In-Reply-To: <20220408094745.3129754-1-b.spranger@linutronix.de>
References: <20220408094745.3129754-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user may set the SO_TXTIME socket option to ensure a packet is send
at a given time. The taprio scheduler has to confirm, that it is allowed
to send a packet at that given time, by a check against the packet time
schedule. The scheduler drop the packet, if the gates are closed at the
given send time.

The check, if SO_TXTIME is set, may fail since sk_flags are part of an
union and the union is used otherwise. This happen, if a socket is not
a full socket, like a request socket for example.

Add a check to verify, if the union is used for sk_flags.

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1ce6416b4810..a871b3ef4bca 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -419,7 +419,8 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 
-	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
+	/* sk_flags are only safe to use on full sockets. */
+	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
 		if (!is_valid_interval(skb, sch))
 			return qdisc_drop(skb, sch, to_free);
 	} else if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-- 
2.20.1

