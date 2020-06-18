Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F1F1FE1C7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733298AbgFRB5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731371AbgFRBZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EA0A221E9;
        Thu, 18 Jun 2020 01:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443511;
        bh=8m4HbIApK/nNGLBITxfwbW+hGZ0kunCHWQffAxXTSRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkGZatSjWrH+gwzh0BLZhtHEmOWWCfdwoaVb2kBhIruPX3n+dep1zf99H7oQN37vc
         zs7yji7AG53rI2J9okYkIbSmy37Kpm83EjG+yNX+RXRZ2Jfy/bUp4UTOi2EnQDLqAI
         YtW4cn2hkVm/uYELR9dge/+QcLg3JONmRhPb5C9w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 135/172] rxrpc: Adjust /proc/net/rxrpc/calls to display call->debug_id not user_ID
Date:   Wed, 17 Jun 2020 21:21:41 -0400
Message-Id: <20200618012218.607130-135-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 32f71aa497cfb23d37149c2ef16ad71fce2e45e2 ]

The user ID value isn't actually much use - and leaks a kernel pointer or a
userspace value - so replace it with the call debug ID, which appears in trace
points.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 9805e3b85c36..81a765dd8c9b 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -72,7 +72,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 			 "Proto Local                                          "
 			 " Remote                                         "
 			 " SvID ConnID   CallID   End Use State    Abort   "
-			 " UserID           TxSeq    TW RxSeq    RW RxSerial RxTimo\n");
+			 " DebugId  TxSeq    TW RxSeq    RW RxSerial RxTimo\n");
 		return 0;
 	}
 
@@ -104,7 +104,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	rx_hard_ack = READ_ONCE(call->rx_hard_ack);
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %08x %s %3u"
-		   " %-8.8s %08x %lx %08x %02x %08x %02x %08x %06lx\n",
+		   " %-8.8s %08x %08x %08x %02x %08x %02x %08x %06lx\n",
 		   lbuff,
 		   rbuff,
 		   call->service_id,
@@ -114,7 +114,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   atomic_read(&call->usage),
 		   rxrpc_call_states[call->state],
 		   call->abort_code,
-		   call->user_call_ID,
+		   call->debug_id,
 		   tx_hard_ack, READ_ONCE(call->tx_top) - tx_hard_ack,
 		   rx_hard_ack, READ_ONCE(call->rx_top) - rx_hard_ack,
 		   call->rx_serial,
-- 
2.25.1

