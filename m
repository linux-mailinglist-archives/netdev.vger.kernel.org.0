Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1713B997
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfFJQfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:35:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43792 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbfFJQfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:35:11 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1haNGD-0001Qk-BG; Mon, 10 Jun 2019 12:35:08 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     linux-sctp@vger.kernel.org
Cc:     netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] Free cookie before we memdup a new one
Date:   Mon, 10 Jun 2019 12:34:56 -0400
Message-Id: <20190610163456.7778-1-nhorman@tuxdriver.com>
X-Mailer: git-send-email 2.20.1
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

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC: Xin Long <lucien.xin@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
---
 net/sctp/sm_make_chunk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index f17908f5c4f3..21f7faf032e5 100644
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
-- 
2.20.1

