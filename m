Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC8E67A179
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjAXSlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjAXSk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:40:58 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97D76366A6;
        Tue, 24 Jan 2023 10:40:32 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/4] netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
Date:   Tue, 24 Jan 2023 19:39:30 +0100
Message-Id: <20230124183933.4752-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230124183933.4752-1-pablo@netfilter.org>
References: <20230124183933.4752-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

RFC 9260, Sec 8.5.1 states that for ABORT/SHUTDOWN_COMPLETE, the chunk
MUST be accepted if the vtag of the packet matches its own tag and the
T bit is not set OR if it is set to its peer's vtag and the T bit is set
in chunk flags. Otherwise the packet MUST be silently dropped.

Update vtag verification for ABORT/SHUTDOWN_COMPLETE based on the above
description.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index d88b92a8ffca..2b2c549ba678 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -424,22 +424,29 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		/* Special cases of Verification tag check (Sec 8.5.1) */
 		if (sch->type == SCTP_CID_INIT) {
-			/* Sec 8.5.1 (A) */
+			/* (A) vtag MUST be zero */
 			if (sh->vtag != 0)
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_ABORT) {
-			/* Sec 8.5.1 (B) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
-			    sh->vtag != ct->proto.sctp.vtag[!dir])
+			/* (B) vtag MUST match own vtag if T flag is unset OR
+			 * MUST match peer's vtag if T flag is set
+			 */
+			if ((!(sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[dir]) ||
+			    ((sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[!dir]))
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
-			/* Sec 8.5.1 (C) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
-			    sh->vtag != ct->proto.sctp.vtag[!dir] &&
-			    sch->flags & SCTP_CHUNK_FLAG_T)
+			/* (C) vtag MUST match own vtag if T flag is unset OR
+			 * MUST match peer's vtag if T flag is set
+			 */
+			if ((!(sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[dir]) ||
+			    ((sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[!dir]))
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
-			/* Sec 8.5.1 (D) */
+			/* (D) vtag must be same as init_vtag as found in INIT_ACK */
 			if (sh->vtag != ct->proto.sctp.vtag[dir])
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_HEARTBEAT) {
-- 
2.30.2

