Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E053C9E6
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389302AbfFKLVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:21:45 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51332 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387444AbfFKLVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:21:44 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1haeqR-0002l7-S5; Tue, 11 Jun 2019 07:21:42 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     linux-sctp@vger.kernel.org
Cc:     netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2] [net] Free cookie before we memdup a new one
Date:   Tue, 11 Jun 2019 07:21:28 -0400
Message-Id: <20190611112128.27057-1-nhorman@tuxdriver.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610163456.7778-1-nhorman@tuxdriver.com>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on comments from Xin, even after fixes for our recent syzbot
report of cookie memory leaks, its possible to get a resend of an INIT
chunk which would lead to us leaking cookie memory.

To ensure that we don't leak cookie memory, free any previously
allocated cookie first.

---
Change notes
v1->v2
update subsystem tag in subject (davem)
repeat kfree check for peer_random and peer_hmacs (xin)

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC: Xin Long <lucien.xin@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
---
 net/sctp/sm_make_chunk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index f17908f5c4f3..0992ec0395f8 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2583,6 +2583,8 @@ static int sctp_process_param(struct sctp_association *asoc,
 	case SCTP_PARAM_STATE_COOKIE:
 		asoc->peer.cookie_len =
 			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
+		if (asoc->peer.cookie)
+			kfree(asoc->peer.cookie);
 		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
 		if (!asoc->peer.cookie)
 			retval = 0;
@@ -2647,6 +2649,8 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		/* Save peer's random parameter */
+		if (asoc->peer.peer_random)
+			kfree(asoc->peer.peer_random);
 		asoc->peer.peer_random = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_random) {
@@ -2660,6 +2664,8 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		/* Save peer's HMAC list */
+		if (asoc->peer.peer_hmacs)
+			kfree(asoc->peer.peer_hmacs);
 		asoc->peer.peer_hmacs = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_hmacs) {
-- 
2.20.1

