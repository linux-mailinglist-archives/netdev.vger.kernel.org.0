Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E642827E903
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 14:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgI3MzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 08:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgI3MzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 08:55:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B32C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 05:55:07 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u3so912388pjr.3
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 05:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VEHL9Fn+s6ITACbUAk/qKRInZLJuJO/LV+luGnZ0jFA=;
        b=N9vHnDY6vxy2vZPC+2lchov90QmP3jDGsrMpkZL7adVvy5/JwTlM1LSJbw/TJh+N2h
         lFBpYw+mNwqgp3NVTJlNNdWsg+1gWrr7knabhl9J0G1Bp9V5d9cEDc8syaapwyyU4N76
         kQH6p0Dj1T4ylaC0wxpBuZTeXimsiI9qJ73Gbl+oJH2JIbN3GRbRgda0MRwcd2dtG6pQ
         byVPlLv3TmmR0rECie9yh77FQigBX+ckS9z5mHE0lVdMhA0ewAzvhGYxoMjt0vlSyjGt
         FdRSHdiEjBFajZ4wj7YR9/rE49z918+i84ujr7fn4oh9OOLbjRsiOZ7KWnwJ4sxSxfsd
         QPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VEHL9Fn+s6ITACbUAk/qKRInZLJuJO/LV+luGnZ0jFA=;
        b=nw/lLI5/4BZbZnUPG9zgGk0vgKDLB4Hbh4Thpo8rrH1H61uKzR9wCt+acZchwWgo20
         liyrxjx2/rjbFpPZnXVDsWnq1XUTKHjSvmIT1/4h6r8xwI0Ty8SiY1S7Dn4ifN5LSaU8
         y4aJ/f4LovfaA0ZsGMjKsatzB8bQC6so9v2N9W0VnsW0RIYLHApNLjovEb7I8riwxxAg
         Ti4RqJ4bJFt+vDgIGpPkbTQyKV9HiQfXDkRhHPHby7CjjwQLP2ubYTLhdtKRyi0Tl/3Y
         kLPY4jg9W34cNUXL48MC0NSFnCTBSfsFT7OMhlG1+WM5IRpm5hSBs85io+YT4rxql4jc
         FzcQ==
X-Gm-Message-State: AOAM53368OdLDesROZvnIjZJXKYJFBAi/noQfxwsYjgFxdl31iIxzCI3
        OoU8U25NX08RNTA9d0Ailhw=
X-Google-Smtp-Source: ABdhPJwa/BP5fu+hP13TvaBRjl5/3LYPum+pnBpA6GpFwlOIjhsj5ppOD7rU3cnSail069nzbhWBGg==
X-Received: by 2002:a17:90b:4b11:: with SMTP id lx17mr2483104pjb.22.1601470506576;
        Wed, 30 Sep 2020 05:55:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id e21sm2235235pgi.91.2020.09.30.05.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 05:55:05 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] tcp: add exponential backoff in __tcp_send_ack()
Date:   Wed, 30 Sep 2020 05:54:57 -0700
Message-Id: <20200930125457.1579469-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
In-Reply-To: <20200930125457.1579469-1-eric.dumazet@gmail.com>
References: <20200930125457.1579469-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Whenever host is under very high memory pressure,
__tcp_send_ack() skb allocation fails, and we setup
a 200 ms (TCP_DELACK_MAX) timer before retrying.

On hosts with high number of TCP sockets, we can spend
considerable amount of cpu cycles in these attempts,
add high pressure on various spinlocks in mm-layer,
ultimately blocking threads attempting to free space
from making any progress.

This patch adds standard exponential backoff to avoid
adding fuel to the fire.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_connection_sock.h |  3 ++-
 net/ipv4/tcp_output.c              | 11 ++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 79875f976190750819948425e63dd0309c699050..7338b3865a2a3d278dc27c0167bba1b966bbda9f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -110,7 +110,7 @@ struct inet_connection_sock {
 		__u8		  pending;	 /* ACK is pending			   */
 		__u8		  quick;	 /* Scheduled number of quick acks	   */
 		__u8		  pingpong;	 /* The session is interactive		   */
-		/* one byte hole. */
+		__u8		  retry;	 /* Number of attempts			   */
 		__u32		  ato;		 /* Predicted tick of soft clock	   */
 		unsigned long	  timeout;	 /* Currently scheduled timeout		   */
 		__u32		  lrcvtime;	 /* timestamp of last received data packet */
@@ -199,6 +199,7 @@ static inline void inet_csk_clear_xmit_timer(struct sock *sk, const int what)
 #endif
 	} else if (what == ICSK_TIME_DACK) {
 		icsk->icsk_ack.pending = 0;
+		icsk->icsk_ack.retry = 0;
 #ifdef INET_CSK_CLEAR_TIMERS
 		sk_stop_timer(sk, &icsk->icsk_delack_timer);
 #endif
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6bd4e383030ea20441332a30e98fbda8cd90f84a..bf48cd73e96787a14b6f9af8beddb1067a7cb8dc 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3941,10 +3941,15 @@ void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
 	buff = alloc_skb(MAX_TCP_HEADER,
 			 sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN));
 	if (unlikely(!buff)) {
+		struct inet_connection_sock *icsk = inet_csk(sk);
+		unsigned long delay;
+
+		delay = TCP_DELACK_MAX << icsk->icsk_ack.retry;
+		if (delay < TCP_RTO_MAX)
+			icsk->icsk_ack.retry++;
 		inet_csk_schedule_ack(sk);
-		inet_csk(sk)->icsk_ack.ato = TCP_ATO_MIN;
-		inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,
-					  TCP_DELACK_MAX, TCP_RTO_MAX);
+		icsk->icsk_ack.ato = TCP_ATO_MIN;
+		inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK, delay, TCP_RTO_MAX);
 		return;
 	}
 
-- 
2.28.0.806.g8561365e88-goog

