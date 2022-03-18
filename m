Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E47D4DDB9C
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 15:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbiCRO1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 10:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbiCRO1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 10:27:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6471131962
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 07:25:43 -0700 (PDT)
From:   Benedikt Spranger <b.spranger@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647613542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwG7/WqvpcPEjPp9zF8rOA0ewAv8Gbn1SFwLTcv+ITQ=;
        b=fKbgl51dMq6G4+XDd/iAzurCD2Kayk0vnE5IaCDIfJgqBO9RQ+ed6ilS7+lHeyo1m9H0nO
        pTHY+xYDV1H75lyv8JQqyCCku4ZsGSYG7DMBJyHcG9BXcCtD+P6qzSdBoF6C4SPpE5v8tD
        sirdPgy2VWy7Rixz4eePxfYid+xErEpl+DWnu4feO/ifw3aNUlELxrThtyxx6Dnam2fJMD
        cwIxoiRI5QSkWwg23XI3af5+wdqchTXTPD1Gj0Rp0Zy9uVDPd+6VDRXjiLhRnpRf4CHqxd
        ba984Aff+5spo5AlSyhih59w9nD0DxgAob0Etd0FP+BY0z/KkBuwna8YkrommA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647613542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwG7/WqvpcPEjPp9zF8rOA0ewAv8Gbn1SFwLTcv+ITQ=;
        b=bMaCHHijg3WYitM2vcjY9wQLZpb+POlXcAU+qo036alC6IgQYT0oH+f4c0uV3mn0KNOWu2
        IbvpsVCg+BCOsrDA==
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/1] net/sched: taprio: Check if socket flags are valid
Date:   Fri, 18 Mar 2022 15:25:32 +0100
Message-Id: <20220318142532.313226-2-b.spranger@linutronix.de>
In-Reply-To: <20220318142532.313226-1-b.spranger@linutronix.de>
References: <20220318142532.313226-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 net/sched/sch_taprio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1ce6416b4810..86911a61e739 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -419,7 +419,8 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 
-	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
+	/* sk_flags are only save to use on full sockets. */
+	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
 		if (!is_valid_interval(skb, sch))
 			return qdisc_drop(skb, sch, to_free);
 	} else if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-- 
2.20.1

