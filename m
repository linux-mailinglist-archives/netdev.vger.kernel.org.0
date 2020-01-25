Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA4B1496EF
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 18:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgAYRe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 12:34:27 -0500
Received: from correo.us.es ([193.147.175.20]:35470 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgAYRe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 12:34:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4600412C1EB
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 18:34:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36857DA702
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 18:34:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2BDF4DA70F; Sat, 25 Jan 2020 18:34:24 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29FABDA702;
        Sat, 25 Jan 2020 18:34:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 25 Jan 2020 18:34:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 051DE42EE38E;
        Sat, 25 Jan 2020 18:34:21 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/7] netfilter: conntrack: sctp: use distinct states for new SCTP connections
Date:   Sat, 25 Jan 2020 18:34:11 +0100
Message-Id: <20200125173415.191571-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200125173415.191571-1-pablo@netfilter.org>
References: <20200125173415.191571-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Wiesner <jwiesner@suse.com>

The netlink notifications triggered by the INIT and INIT_ACK chunks
for a tracked SCTP association do not include protocol information
for the corresponding connection - SCTP state and verification tags
for the original and reply direction are missing. Since the connection
tracking implementation allows user space programs to receive
notifications about a connection and then create a new connection
based on the values received in a notification, it makes sense that
INIT and INIT_ACK notifications should contain the SCTP state
and verification tags available at the time when a notification
is sent. The missing verification tags cause a newly created
netfilter connection to fail to verify the tags of SCTP packets
when this connection has been created from the values previously
received in an INIT or INIT_ACK notification.

A PROTOINFO event is cached in sctp_packet() when the state
of a connection changes. The CLOSED and COOKIE_WAIT state will
be used for connections that have seen an INIT and INIT_ACK chunk,
respectively. The distinct states will cause a connection state
change in sctp_packet().

Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 0399ae8f1188..4f897b14b606 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -114,7 +114,7 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 	{
 /*	ORIGINAL	*/
 /*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
-/* init         */ {sCW, sCW, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA},
+/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA},
 /* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},
 /* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
 /* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL, sSS},
@@ -130,7 +130,7 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 /*	REPLY	*/
 /*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
 /* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},/* INIT in sCL Big TODO */
-/* init_ack     */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},
+/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},
 /* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV, sCL},
 /* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV, sSR},
 /* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV, sHA},
@@ -316,7 +316,7 @@ sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
 
-		ct->proto.sctp.state = new_state;
+		ct->proto.sctp.state = SCTP_CONNTRACK_NONE;
 	}
 
 	return true;
-- 
2.11.0

