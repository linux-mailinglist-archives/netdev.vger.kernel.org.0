Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889DC1616C2
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgBQPyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:54:49 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41728 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729403AbgBQPyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:54:49 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j3ijP-00027A-9U; Mon, 17 Feb 2020 16:54:47 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net] mptcp: fix bogus socket flag values
Date:   Mon, 17 Feb 2020 16:54:38 +0100
Message-Id: <20200217155438.16656-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter reports static checker warnings due to bogus BIT() usage:

net/mptcp/subflow.c:571 subflow_write_space() warn: test_bit() takes a bit number
net/mptcp/subflow.c:694 subflow_state_change() warn: test_bit() takes a bit number
net/mptcp/protocol.c:261 ssk_check_wmem() warn: test_bit() takes a bit number
[..]

This is harmless (we use bits 1 & 2 instead of 0 and 1), but would
break eventually when adding BIT(5) (or 6, depends on size of 'long').

Just use 0 and 1, the values are only passed to test/set/clear_bit
functions.

Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8a99a2930284..9f8663b30456 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -56,8 +56,8 @@
 #define MPTCP_DSS_FLAG_MASK	(0x1F)
 
 /* MPTCP socket flags */
-#define MPTCP_DATA_READY	BIT(0)
-#define MPTCP_SEND_SPACE	BIT(1)
+#define MPTCP_DATA_READY	0
+#define MPTCP_SEND_SPACE	1
 
 /* MPTCP connection sock */
 struct mptcp_sock {
-- 
2.24.1

