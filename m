Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9204A9BC7
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359615AbiBDPTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:19:13 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50332 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242172AbiBDPTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:19:09 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 534536018E;
        Fri,  4 Feb 2022 16:19:03 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/6] netfilter: conntrack: don't refresh sctp entries in closed state
Date:   Fri,  4 Feb 2022 16:18:57 +0100
Message-Id: <20220204151903.320786-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204151903.320786-1-pablo@netfilter.org>
References: <20220204151903.320786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Vivek Thrivikraman reported:
 An SCTP server application which is accessed continuously by client
 application.
 When the session disconnects the client retries to establish a connection.
 After restart of SCTP server application the session is not established
 because of stale conntrack entry with connection state CLOSED as below.

 (removing this entry manually established new connection):

 sctp 9 CLOSED src=10.141.189.233 [..]  [ASSURED]

Just skip timeout update of closed entries, we don't want them to
stay around forever.

Reported-and-tested-by: Vivek Thrivikraman <vivek.thrivikraman@est.tech>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1579
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 2394238d01c9..5a936334b517 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -489,6 +489,15 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			pr_debug("Setting vtag %x for dir %d\n",
 				 ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
+
+			/* don't renew timeout on init retransmit so
+			 * port reuse by client or NAT middlebox cannot
+			 * keep entry alive indefinitely (incl. nat info).
+			 */
+			if (new_state == SCTP_CONNTRACK_CLOSED &&
+			    old_state == SCTP_CONNTRACK_CLOSED &&
+			    nf_ct_is_confirmed(ct))
+				ignore = true;
 		}
 
 		ct->proto.sctp.state = new_state;
-- 
2.30.2

