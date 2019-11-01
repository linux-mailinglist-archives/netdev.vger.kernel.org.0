Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276F9ECB42
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfKAWQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:16:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44534 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:16:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id e10so7288901pgd.11
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 15:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wEdKl0icfQUVPzxkxRSTd9Zn9M5QaxSb6Wa7apC31O0=;
        b=BMj1llPnW5+BOHBO/Z3gf1NFC8roMIwFDcZP6SEQTRQsOoMeEoRhLGW7oEO4Q4M1q0
         Rs+v44hhWw9r7MtVQErxo82N9vKfMGslgCr475/GMs7HTr9PNVv6dZfHJeGI+qJ3bwTp
         wvpPsMlzg1waIcxCrFAwAjdCxZdheqPHQj/1kenmamLGQ9irwgbOldzPSyLuSouMRGZQ
         dxKqA1nu3hP3AWaF6jLvgRL6i+1kNQ7ymXZVwrpNbk1/WB+Czhxf2V3vVOL/g6H9zk8d
         cZAnuEBdXUnMQTD8LO/F9daE1ncp5mqWXcDX3DQv3sKPse5rB1cSdDEAdU8gaLXt/65G
         d6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wEdKl0icfQUVPzxkxRSTd9Zn9M5QaxSb6Wa7apC31O0=;
        b=Vkggmdz2oExPga+n7D1CEO/MYV1/xiZRFERZuI9PkfecZSUXeUoe1lHOOJoB5Ay1Fk
         QJlxaHij1UnugRCmjNyJjD+YU+bwjFQ8c0RvA19OxKcCnIRJXv/Mk4iaVc2hiqktL39C
         pTaff2vYzLJNfnKwohGeV3H8eBSS31OtFkZ5yyT3Y/8WjV7EoX9Pn9C6hdo4VLcVa3nc
         BC0+Vy7QDmz4BxYMRWe4z4bc+qeQG0s92H8cxax7YH3FxUcVpCQJ3W4KTCMeFhVChjYq
         quDMq5J2NpkXsatbQWascKhWuYCkzkcpnKs+LLpUb+7b5qPCtZrEslax3F048s0+lVEj
         /UaQ==
X-Gm-Message-State: APjAAAWXZI86eQql/y4AWzf4dG92HR66WCAM3TgLUX7JOMVUS3cEI3n9
        ddEhXYhyxr5rbuVGQ6Toa1iA0pFQwA4=
X-Google-Smtp-Source: APXvYqyXXfErbsW3334cZNrmtNbIXfKg94qIzHTlUTrKNMAKPhAHPTtFO80xb5PkgUN7b6IkMqIVBg==
X-Received: by 2002:a17:90a:1141:: with SMTP id d1mr17764215pje.35.1572646585773;
        Fri, 01 Nov 2019 15:16:25 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id q6sm8000195pgn.44.2019.11.01.15.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 15:16:25 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC Patch] tcp: make icsk_retransmit_timer pinned
Date:   Fri,  1 Nov 2019 15:16:05 -0700
Message-Id: <20191101221605.32210-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While investigating the spinlock contention on resetting TCP
retransmit timer:

  61.72%    61.71%  swapper          [kernel.kallsyms]                        [k] queued_spin_lock_slowpath
   ...
    - 58.83% tcp_v4_rcv
      - 58.80% tcp_v4_do_rcv
         - 58.80% tcp_rcv_established
            - 52.88% __tcp_push_pending_frames
               - 52.88% tcp_write_xmit
                  - 28.16% tcp_event_new_data_sent
                     - 28.15% sk_reset_timer
                        + mod_timer
                  - 24.68% tcp_schedule_loss_probe
                     - 24.68% sk_reset_timer
                        + 24.68% mod_timer

it turns out to be a serious timer migration issue. After collecting timer_start
trace events for tcp_write_timer, it shows more than 77% times this timer got
migrated to a difference CPU:

	$ perl -ne 'if (/\[(\d+)\].* cpu=(\d+)/){print if $1 != $2 ;}' tcp_timer_trace.txt | wc -l
	1303826
	$ wc -l tcp_timer_trace.txt
	1681068 tcp_timer_trace.txt
	$ python
	Python 2.7.5 (default, Jul 11 2019, 17:13:53)
	[GCC 4.8.5 20150623 (Red Hat 4.8.5-36)] on linux2
	Type "help", "copyright", "credits" or "license" for more information.
	>>> 1303826 / 1681068.0
	0.7755938486723916

And all of those migration happened during an idle CPU serving a network RX
softirq.  So, the logic of testing CPU idleness in idle_cpu() is false positive.
I don't know whether we should relax it for this scenario particuarly, something
like:

-	if (!idle_cpu(cpu) && housekeeping_cpu(cpu, HK_FLAG_TIMER))
+	if ((!idle_cpu(cpu) || in_serving_softirq()) &&
+	    housekeeping_cpu(cpu, HK_FLAG_TIMER))
 		return cpu;

(There could be better way than in_serving_softirq() to measure the idleness,
of course.)

Or simply just make the TCP retransmit timer pinned. At least this approach
has the minimum impact.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index eb30fc1770de..de5510ddb1c8 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -507,7 +507,7 @@ void inet_csk_init_xmit_timers(struct sock *sk,
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
-	timer_setup(&icsk->icsk_retransmit_timer, retransmit_handler, 0);
+	timer_setup(&icsk->icsk_retransmit_timer, retransmit_handler, TIMER_PINNED);
 	timer_setup(&icsk->icsk_delack_timer, delack_handler, 0);
 	timer_setup(&sk->sk_timer, keepalive_handler, 0);
 	icsk->icsk_pending = icsk->icsk_ack.pending = 0;
-- 
2.21.0

