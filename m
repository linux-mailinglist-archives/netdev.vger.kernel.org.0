Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E211599D
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbfEGFiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728597AbfEGFiS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:38:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B998A20B7C;
        Tue,  7 May 2019 05:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207497;
        bh=4ivpgEHAd/I1nF4RAywRQNrnfof+eIb6bU1DhLaTCd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vcc9X2C+QX9jKQQMcrmMAwNg8lUJtKUgPBDfLjPixpHdX60tHHfPUDsMdiau+kxGv
         DXzY4LfuaxgT2WPpNDLEvo2k9KFJlBeLtK67XJCNPNqFJyPKuVGc+kVioaar8/k77q
         iiFVCaxWvrbEdvMKR/eFo67YdGyQA+dSXYzfkojY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 78/81] net: strparser: partially revert "strparser: Call skb_unclone conditionally"
Date:   Tue,  7 May 2019 01:35:49 -0400
Message-Id: <20190507053554.30848-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 4a9c2e3746e6151fd5d077259d79ce9ca86d47d7 ]

This reverts the first part of commit 4e485d06bb8c ("strparser: Call
skb_unclone conditionally").  To build a message with multiple
fragments we need our own root of frag_list.  We can't simply
use the frag_list of orig_skb, because it will lead to linking
all orig_skbs together creating very long frag chains, and causing
stack overflow on kfree_skb() (which is called recursively on
the frag_lists).

BUG: stack guard page was hit at 00000000d40fad41 (stack is 0000000029dde9f4..000000008cce03d5)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP
RIP: 0010:free_one_page+0x2b/0x490

Call Trace:
  __free_pages_ok+0x143/0x2c0
  skb_release_data+0x8e/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0

  [...]

  skb_release_data+0xad/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0
  skb_release_data+0xad/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0
  skb_release_data+0xad/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0
  skb_release_data+0xad/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0
  skb_release_data+0xad/0x140
  __kfree_skb+0xe/0x20
  tcp_disconnect+0xd6/0x4d0
  tcp_close+0xf4/0x430
  ? tcp_check_oom+0xf0/0xf0
  tls_sk_proto_close+0xe4/0x1e0 [tls]
  inet_release+0x36/0x60
  __sock_release+0x37/0xa0
  sock_close+0x11/0x20
  __fput+0xa2/0x1d0
  task_work_run+0x89/0xb0
  exit_to_usermode_loop+0x9a/0xa0
  do_syscall_64+0xc0/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Let's leave the second unclone conditional, as I'm not entirely
sure what is its purpose :)

Fixes: 4e485d06bb8c ("strparser: Call skb_unclone conditionally")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/strparser/strparser.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/strparser/strparser.c b/net/strparser/strparser.c
index da1a676860ca..0f4e42792878 100644
--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -140,13 +140,11 @@ static int __strp_recv(read_descriptor_t *desc, struct sk_buff *orig_skb,
 			/* We are going to append to the frags_list of head.
 			 * Need to unshare the frag_list.
 			 */
-			if (skb_has_frag_list(head)) {
-				err = skb_unclone(head, GFP_ATOMIC);
-				if (err) {
-					STRP_STATS_INCR(strp->stats.mem_fail);
-					desc->error = err;
-					return 0;
-				}
+			err = skb_unclone(head, GFP_ATOMIC);
+			if (err) {
+				STRP_STATS_INCR(strp->stats.mem_fail);
+				desc->error = err;
+				return 0;
 			}
 
 			if (unlikely(skb_shinfo(head)->frag_list)) {
-- 
2.20.1

