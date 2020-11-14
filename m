Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAACD2B2B6A
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 06:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgKNFXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 00:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgKNFXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 00:23:02 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF6AC0613D1;
        Fri, 13 Nov 2020 21:23:02 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id w20so1412539pjh.1;
        Fri, 13 Nov 2020 21:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=46rWomySeq9rncB00xd5dMn3IxU8jqwbRntLm0XmBRA=;
        b=iSxo4HzepnCg6xhh/QXIavXe6nULGq7SWzAcaXy/fLSb8C4SIQU/X2IMqYdpZnvQ8W
         uaM/XAodeUvPjWnfX4YcS3u4A8L4z/eTxpm7b7teFq9BMAYcuDzwUo9OECF1aEYdm4gn
         din9Nb8yf3oivKn2SqzXxQrpwOoapIKa6sQe38+tjAG23lnj631ZtExScglpcoaD+pSE
         iBqerRXRskTb5iWBBve6U6gD8zit3HZX3SHj/po2gQvIdeB5YXACoajWDRosJjz+CXgf
         F7sFDdTARiEq4P9fXZU03MA1Z0b9+dJA8Hp2MrMoGdddf9YauorGj4FN1J2+rBRZ15NS
         P6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=46rWomySeq9rncB00xd5dMn3IxU8jqwbRntLm0XmBRA=;
        b=MfbXchal854QYAL+jlg2kIfPPk3ZArID5HqG57sSzMzdDyT/E1wN8gdb+F+mvwQ8N+
         chZBaeNx+xKp9LO4104Gs7C2JKZA++4KJHjhtsxq1dG3IGvpFWRkHPcOwWP3AsCGx84u
         99adG6AnOHqmYW8PvfSTSOAuk2jo7RJEYaD7Bbw4MDRitkkIyWEzodTvaryoSMi5hNgD
         bQlCvOqjtEsTcifSR6LnIdjkIOtb9UNweosHGdiLoZZSEZFioqORPishopG4a46gzv2d
         GPDPt4wabIiUkSGwK2Z2THvhAd7EPyZ7iJ2+5GkZXJT/F4RhSSByRTA/CAxdnp6lq8Ep
         oc5g==
X-Gm-Message-State: AOAM5323XiSZs1M23L4Yd3K1ixVU9kaiuAPgHl7n02PS3Z2CzbMXMUTT
        lH9OSB7oCi/9q/+bFcQyoy9zEqpFg7I=
X-Google-Smtp-Source: ABdhPJwDOoOwIPZRRScseO0OBIBzLNX8luX6Ae+Bo53w+vPZojDcB+hW/SvYi2sFgXH9ulcuhjqzYg==
X-Received: by 2002:a17:90a:d486:: with SMTP id s6mr6544192pju.115.1605331381588;
        Fri, 13 Nov 2020 21:23:01 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 26sm10067733pgu.83.2020.11.13.21.22.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Nov 2020 21:23:00 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] sctp: change to hold/put transport for proto_unreach_timer
Date:   Sat, 14 Nov 2020 13:22:53 +0800
Message-Id: <102788809b554958b13b95d33440f5448113b8d6.1605331373.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A call trace was found in Hangbin's Codenomicon testing with debug kernel:

  [ 2615.981988] ODEBUG: free active (active state 0) object type: timer_list hint: sctp_generate_proto_unreach_event+0x0/0x3a0 [sctp]
  [ 2615.995050] WARNING: CPU: 17 PID: 0 at lib/debugobjects.c:328 debug_print_object+0x199/0x2b0
  [ 2616.095934] RIP: 0010:debug_print_object+0x199/0x2b0
  [ 2616.191533] Call Trace:
  [ 2616.194265]  <IRQ>
  [ 2616.202068]  debug_check_no_obj_freed+0x25e/0x3f0
  [ 2616.207336]  slab_free_freelist_hook+0xeb/0x140
  [ 2616.220971]  kfree+0xd6/0x2c0
  [ 2616.224293]  rcu_do_batch+0x3bd/0xc70
  [ 2616.243096]  rcu_core+0x8b9/0xd00
  [ 2616.256065]  __do_softirq+0x23d/0xacd
  [ 2616.260166]  irq_exit+0x236/0x2a0
  [ 2616.263879]  smp_apic_timer_interrupt+0x18d/0x620
  [ 2616.269138]  apic_timer_interrupt+0xf/0x20
  [ 2616.273711]  </IRQ>

This is because it holds asoc when transport->proto_unreach_timer starts
and puts asoc when the timer stops, and without holding transport the
transport could be freed when the timer is still running.

So fix it by holding/putting transport instead for proto_unreach_timer
in transport, just like other timers in transport.

v1->v2:
  - Also use sctp_transport_put() for the "out_unlock:" path in
    sctp_generate_proto_unreach_event(), as Marcelo noticed.

Fixes: 50b5d6ad6382 ("sctp: Fix a race between ICMP protocol unreachable and connect()")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c         | 4 ++--
 net/sctp/sm_sideeffect.c | 4 ++--
 net/sctp/transport.c     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 55d4fc6..d508f6f 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -449,7 +449,7 @@ void sctp_icmp_proto_unreachable(struct sock *sk,
 		else {
 			if (!mod_timer(&t->proto_unreach_timer,
 						jiffies + (HZ/20)))
-				sctp_association_hold(asoc);
+				sctp_transport_hold(t);
 		}
 	} else {
 		struct net *net = sock_net(sk);
@@ -458,7 +458,7 @@ void sctp_icmp_proto_unreachable(struct sock *sk,
 			 "encountered!\n", __func__);
 
 		if (del_timer(&t->proto_unreach_timer))
-			sctp_association_put(asoc);
+			sctp_transport_put(t);
 
 		sctp_do_sm(net, SCTP_EVENT_T_OTHER,
 			   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 813d307..0948f14 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -419,7 +419,7 @@ void sctp_generate_proto_unreach_event(struct timer_list *t)
 		/* Try again later.  */
 		if (!mod_timer(&transport->proto_unreach_timer,
 				jiffies + (HZ/20)))
-			sctp_association_hold(asoc);
+			sctp_transport_hold(transport);
 		goto out_unlock;
 	}
 
@@ -435,7 +435,7 @@ void sctp_generate_proto_unreach_event(struct timer_list *t)
 
 out_unlock:
 	bh_unlock_sock(sk);
-	sctp_association_put(asoc);
+	sctp_transport_put(transport);
 }
 
  /* Handle the timeout of the RE-CONFIG timer. */
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 806af58..60fcf31 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -133,7 +133,7 @@ void sctp_transport_free(struct sctp_transport *transport)
 
 	/* Delete the ICMP proto unreachable timer if it's active. */
 	if (del_timer(&transport->proto_unreach_timer))
-		sctp_association_put(transport->asoc);
+		sctp_transport_put(transport);
 
 	sctp_transport_put(transport);
 }
-- 
2.1.0

