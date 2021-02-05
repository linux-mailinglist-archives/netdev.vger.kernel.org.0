Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03A13101D5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhBEArr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:47:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:38218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhBEArm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 19:47:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9246AAE3F;
        Fri,  5 Feb 2021 00:47:00 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date:   Fri, 05 Feb 2021 11:36:30 +1100
Subject: [PATCH 3/3] net: fix iteration for sctp transport seq_files
Cc:     Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <161248539022.21478.17038123892954492263.stgit@noble1>
In-Reply-To: <161248518659.21478.2484341937387294998.stgit@noble1>
References: <161248518659.21478.2484341937387294998.stgit@noble1>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sctp transport seq_file iterators take a reference to the transport
in the ->start and ->next functions and releases the reference in the
->show function.  The preferred handling for such resources is to
release them in the subsequent ->next or ->stop function call.

Since Commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration
code and interface") there is no guarantee that ->show will be called
after ->next, so this function can now leak references.

So move the sctp_transport_put() call to ->next and ->stop.

Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Reported-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 net/sctp/proc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index f7da88ae20a5..982a87b3e11f 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -215,6 +215,12 @@ static void sctp_transport_seq_stop(struct seq_file *seq, void *v)
 {
 	struct sctp_ht_iter *iter = seq->private;
 
+	if (v && v != SEQ_START_TOKEN) {
+		struct sctp_transport *transport = v;
+
+		sctp_transport_put(transport);
+	}
+
 	sctp_transport_walk_stop(&iter->hti);
 }
 
@@ -222,6 +228,12 @@ static void *sctp_transport_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct sctp_ht_iter *iter = seq->private;
 
+	if (v && v != SEQ_START_TOKEN) {
+		struct sctp_transport *transport = v;
+
+		sctp_transport_put(transport);
+	}
+
 	++*pos;
 
 	return sctp_transport_get_next(seq_file_net(seq), &iter->hti);
@@ -277,8 +289,6 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
 		sk->sk_rcvbuf);
 	seq_printf(seq, "\n");
 
-	sctp_transport_put(transport);
-
 	return 0;
 }
 
@@ -354,8 +364,6 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "\n");
 	}
 
-	sctp_transport_put(transport);
-
 	return 0;
 }
 


