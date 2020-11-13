Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B16D2B1809
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 10:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgKMJSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 04:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgKMJSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 04:18:33 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4756FC0613D1;
        Fri, 13 Nov 2020 01:18:33 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t21so299438pgl.3;
        Fri, 13 Nov 2020 01:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fSo37royzjR0NCHVBZWpFhqlhvEoHQuMF/vuDeQN1w8=;
        b=fN21bAuzTZqXV+uk5ZT72LQfNrhdluqYrYdBT4sPBrFYkzqy7f2i2eenHfZdxh5oM5
         QOrpyiwqlCJJaH0hyJBjyiIpzj2PLBiClmluzKT+g+RoaV4vWEYiHlelF347kETe5txr
         pRn+Oi8ET25TX+mcHGpUwmWvWn11D9oflMxp207/yJuP3F+FIAvkr/j2HR9HwJ/Wq1XF
         fFUeVQMFqwpO39ftHRSY26MJjZBLa0dxC7A4Jl8QJCcLwzDRQXhnd2hDGzdImOufCb3E
         6mqnuVxBf5XYcCi0qAUiXjToMiIVjwJ5tyrNKIMVIsScD50f3BNm3cDfCDHQrmZFZyk0
         XE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fSo37royzjR0NCHVBZWpFhqlhvEoHQuMF/vuDeQN1w8=;
        b=X2MnEr3HdqAIxOyJeUb8BZx1imW9ijPDAlbEQVbqBgai/g42tvR5N+PMlw2Gr1+sCP
         +M8ZRJXO+9oJaYRdU+53/sWE8nqGf3jt0/CcQg2Crl/7JeKBnuMVozoVqhG1wjnqGHdM
         43hBArFYV4XNpMkOgYPfWB+pFzQOKiYqMcC+j/J5tpsa356UiYsWtd4cX1QZHhXnYDbn
         k5xrX4jfbIKoHiyTiv7ABdrrJf9arOsDAj4f4nTSYDlfI8rDxKSwXFYiBDUIMrwedRSU
         YY0k0jpvlDbQmQD4kAOq/p7Wr/8fgonaJFWht75qY9jyJraQoX3ESUjgyGlyX/PwB+C3
         xvzg==
X-Gm-Message-State: AOAM530/WVJYchecTj7j1XcLNEziU8BUL74qgMBJf/oe5OWyGMjJIdiw
        nFj5H8Dcao6RwpSkx4oi0qS45JRiCyE=
X-Google-Smtp-Source: ABdhPJwGApdDwRdE3b6B1dkmJvtbPgt1tjfQ6Vucap5FGv8uISE39e4/+IpGb10MxRLrN9kegEsf5w==
X-Received: by 2002:a63:3c5b:: with SMTP id i27mr1406597pgn.268.1605259112487;
        Fri, 13 Nov 2020 01:18:32 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v196sm9304116pfc.34.2020.11.13.01.18.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Nov 2020 01:18:31 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] sctp: change to hold/put transport for proto_unreach_timer
Date:   Fri, 13 Nov 2020 17:18:24 +0800
Message-Id: <7cb07ff74acd144f14a4467c7dddd12a940fbf52.1605259104.git.lucien.xin@gmail.com>
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

Fixes: 50b5d6ad6382 ("sctp: Fix a race between ICMP protocol unreachable and connect()")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c         | 4 ++--
 net/sctp/sm_sideeffect.c | 2 +-
 net/sctp/transport.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

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
index 813d307..0a51150 100644
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

