Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A80E280911
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbgJAVFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbgJAVF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:05:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4521C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 14:05:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r22so4197198pgk.14
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 14:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=5E10GGGvgCDCSxi8I3vApoTU2C/HVeJeXskhaYnpCLA=;
        b=vVJgEMx4bVTGdzsZbarIlH4kwMBBSHhtuLCccB5inPrAe/jDp1KloozVJyo0BJuQiC
         FVvbxqaOL0KHbQ+kYTwIpaMbQI4l3Vgy2qvZOPwmlkT5CmPOLmkReu1DJ9yiY0Aw6FOi
         bTlPZPxfSi36E/iDIACRHsyhNnYbvk2giVqDc1STv1h5vVtE7GQJQiF5NIEWfMhs/1Lx
         hoD9+ySJp8nlJrXpqzZr5zviK8UNp6wGG/laXRIN4KZaTJ9U2GyCJyXWpJcRjYuTtRQn
         7KvozRDYafMNZs2fZqgFhG9KZ2185YPb4ViyFOXO+r+B8CCv51/vrhCz6TlWZBQFNt1w
         60Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=5E10GGGvgCDCSxi8I3vApoTU2C/HVeJeXskhaYnpCLA=;
        b=p761koPaSPU+fSmgvl+VdzPcUC1FrwfNKAsPFNVEidtC2Zb9a9e/RPIt6pYcdJJdHd
         /R4jX3lQrLe6A3W/qEgvC/s27YEhAjcBK72wvXRzanGwIITWqX02Rr5kjqEyrUczXvQL
         B7daKmdbD7WBmRd4PXtyTsA5GaQL8MD7aX40b7SwcWoTiWC9gSn2IhtbTYkYNSzHbgRS
         ieVx7KuxAH1UoZrL4Z9UE0yTTqChaIIXomrNnZ6aCNydQ83xpsWl99aIfInSdkQ04H15
         Jq5UfHc5qTBqe8fRBUFTrO2toCW4iQNqbyFNxy0SOhf1vMj2oGbqeGOOl4l2ECwm9o71
         z9Kw==
X-Gm-Message-State: AOAM531tRkKA0Fu18aRkqo/jUYwJUrgh3GlRTfrnRn7XvfbUDmA3ydBM
        B+xP+6sGaWff40s8Qg+71T1gUJV4r0I=
X-Google-Smtp-Source: ABdhPJyc8RTKxTypwU+BM+QM3DzSvzfYASsBx+0qwNEjcNbAXxikmZ09X0buYEtLfIG3XeK4bONwADRDoX8=
Sender: "ycheng via sendgmr" <ycheng@ycheng.svl.corp.google.com>
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:fc76])
 (user=ycheng job=sendgmr) by 2002:a17:902:988c:b029:d2:2f2a:8aa6 with SMTP id
 s12-20020a170902988cb02900d22f2a8aa6mr4530590plp.17.1601586328339; Thu, 01
 Oct 2020 14:05:28 -0700 (PDT)
Date:   Thu,  1 Oct 2020 14:05:18 -0700
Message-Id: <20201001210518.92495-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH net-next] tcp: account total lost packets properly
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The retransmission refactoring patch
686989700cab ("tcp: simplify tcp_mark_skb_lost")
does not properly update the total lost packet counter which may
break the policer mode in BBR. This patch fixes it.

Fixes: 686989700cab ("tcp: simplify tcp_mark_skb_lost")
Reported-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f7b3e37d2198..20f89078fa8d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1020,6 +1020,14 @@ static void tcp_verify_retransmit_hint(struct tcp_sock *tp, struct sk_buff *skb)
 		tp->retransmit_skb_hint = skb;
 }
 
+/* Sum the number of packets on the wire we have marked as lost, and
+ * notify the congestion control module that the given skb was marked lost.
+ */
+static void tcp_notify_skb_loss_event(struct tcp_sock *tp, const struct sk_buff *skb)
+{
+	tp->lost += tcp_skb_pcount(skb);
+}
+
 void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
 {
 	__u8 sacked = TCP_SKB_CB(skb)->sacked;
@@ -1036,10 +1044,12 @@ void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
 			tp->retrans_out -= tcp_skb_pcount(skb);
 			NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPLOSTRETRANSMIT,
 				      tcp_skb_pcount(skb));
+			tcp_notify_skb_loss_event(tp, skb);
 		}
 	} else {
 		tp->lost_out += tcp_skb_pcount(skb);
 		TCP_SKB_CB(skb)->sacked |= TCPCB_LOST;
+		tcp_notify_skb_loss_event(tp, skb);
 	}
 }
 
-- 
2.28.0.709.gb0816b6eb0-goog

