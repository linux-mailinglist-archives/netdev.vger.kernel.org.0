Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA5C1F2CA6
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732531AbgFIA0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbgFHXQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 954B520823;
        Mon,  8 Jun 2020 23:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658208;
        bh=UcSFkiTpAfG5jGUQL8B1t65YGL3zYNSNTnWb01RrQ0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbWDq0aoREFY6cIOoSg7NM6jSXuvvNPgyfLK7YO4ZOk+23qo9W6uHVOsMCyepilPC
         Y38ROQbBPrwNq6jCv0G48jVPva8cILrTbKopNnVtAJuJQtX/c7gt4nNFkO/2zTic6t
         Z0lcU5yR5clng8Ea0A6sJu1NsCHUItGOsZu4JMC8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, jere.leppanen@nokia.com,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sctp@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 226/606] sctp: Don't add the shutdown timer if its already been added
Date:   Mon,  8 Jun 2020 19:05:51 -0400
Message-Id: <20200608231211.3363633-226-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 20a785aa52c82246055a089e55df9dac47d67da1 ]

This BUG halt was reported a while back, but the patch somehow got
missed:

PID: 2879   TASK: c16adaa0  CPU: 1   COMMAND: "sctpn"
 #0 [f418dd28] crash_kexec at c04a7d8c
 #1 [f418dd7c] oops_end at c0863e02
 #2 [f418dd90] do_invalid_op at c040aaca
 #3 [f418de28] error_code (via invalid_op) at c08631a5
    EAX: f34baac0  EBX: 00000090  ECX: f418deb0  EDX: f5542950  EBP: 00000000
    DS:  007b      ESI: f34ba800  ES:  007b      EDI: f418dea0  GS:  00e0
    CS:  0060      EIP: c046fa5e  ERR: ffffffff  EFLAGS: 00010286
 #4 [f418de5c] add_timer at c046fa5e
 #5 [f418de68] sctp_do_sm at f8db8c77 [sctp]
 #6 [f418df30] sctp_primitive_SHUTDOWN at f8dcc1b5 [sctp]
 #7 [f418df48] inet_shutdown at c080baf9
 #8 [f418df5c] sys_shutdown at c079eedf
 #9 [f418df70] sys_socketcall at c079fe88
    EAX: ffffffda  EBX: 0000000d  ECX: bfceea90  EDX: 0937af98
    DS:  007b      ESI: 0000000c  ES:  007b      EDI: b7150ae4
    SS:  007b      ESP: bfceea7c  EBP: bfceeaa8  GS:  0033
    CS:  0073      EIP: b775c424  ERR: 00000066  EFLAGS: 00000282

It appears that the side effect that starts the shutdown timer was processed
multiple times, which can happen as multiple paths can trigger it.  This of
course leads to the BUG halt in add_timer getting called.

Fix seems pretty straightforward, just check before the timer is added if its
already been started.  If it has mod the timer instead to min(current
expiration, new expiration)

Its been tested but not confirmed to fix the problem, as the issue has only
occured in production environments where test kernels are enjoined from being
installed.  It appears to be a sane fix to me though.  Also, recentely,
Jere found a reproducer posted on list to confirm that this resolves the
issues

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: jere.leppanen@nokia.com
CC: marcelo.leitner@gmail.com
CC: netdev@vger.kernel.org
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_sideeffect.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 2bc29463e1dc..9f36fe911d08 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1523,9 +1523,17 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			timeout = asoc->timeouts[cmd->obj.to];
 			BUG_ON(!timeout);
 
-			timer->expires = jiffies + timeout;
-			sctp_association_hold(asoc);
-			add_timer(timer);
+			/*
+			 * SCTP has a hard time with timer starts.  Because we process
+			 * timer starts as side effects, it can be hard to tell if we
+			 * have already started a timer or not, which leads to BUG
+			 * halts when we call add_timer. So here, instead of just starting
+			 * a timer, if the timer is already started, and just mod
+			 * the timer with the shorter of the two expiration times
+			 */
+			if (!timer_pending(timer))
+				sctp_association_hold(asoc);
+			timer_reduce(timer, jiffies + timeout);
 			break;
 
 		case SCTP_CMD_TIMER_RESTART:
-- 
2.25.1

