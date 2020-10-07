Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDE3286853
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 21:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgJGTcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 15:32:53 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:28723 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgJGTcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 15:32:53 -0400
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [10.243.128.7])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 925304000A4;
        Wed,  7 Oct 2020 12:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1602099172;
        bh=C0+5yjcysMk84GoYj0z05bOXjUBeWKhioIraoOaj5pU=;
        h=Date:To:Subject:From:From;
        b=mXoD2Q+nkriF0p709lff2+rKBzk1REnY4s8WWlfDsdp8XssJvXd27weNqnsFx5/U/
         sRUi67pxVPh5Y1O4b2/L1D+zOL9gmM86BSOv1xl5badSNO8lnSusEz9+dTETDN/B2P
         yDPwY0lve2/jTMyBTnHwZM2B3zQZ1yFqXPIE+Q458cvvJ+bWR0ZKcN8LvQTzqSDKl9
         c8HjBTU+6M9Ifi9cVezxItw69tTl98ScyOuKIrXsD0rOAjhqdMPRjsWLzgrg449rob
         BLG0t3+vLnLsM8/zxfEgRo1tDe4Sahgq6xzk7LYcqIq14UeYcigAnEkAUCMGKhDceW
         7zhhKeaxmY6cQ==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id 7009D95C169C; Wed,  7 Oct 2020 12:32:52 -0700 (PDT)
Date:   Wed, 07 Oct 2020 12:32:52 -0700
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, fw@strlen.org,
        kadlec@netfilter.org, pablo@netfilter.org, fruggeri@arista.com
Subject: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the first packet conntrack sees after a re-register is an outgoing
keepalive packet with no data (SEG.SEQ = SND.NXT-1), td_end is set to
SND.NXT-1.
When the peer correctly acknowledges SND.NXT, tcp_in_window fails
check III (Upper bound for valid (s)ack: sack <= receiver.td_end) and
returns false, which cascades into nf_conntrack_in setting
skb->_nfct = 0 and in later conntrack iptables rules not matching.
In cases where iptables are dropping packets that do not match
conntrack rules this can result in idle tcp connections to time out.

v2: adjust td_end when getting the reply rather than when sending out
    the keepalive packet.

Fixes: f94e63801ab2 ("netfilter: conntrack: reset tcp maxwin on re-register")
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index e8c86ee4c1c4..c8fb2187ad4b 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -541,13 +541,20 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			swin = win << sender->td_scale;
 			sender->td_maxwin = (swin == 0 ? 1 : swin);
 			sender->td_maxend = end + sender->td_maxwin;
-			/*
-			 * We haven't seen traffic in the other direction yet
-			 * but we have to tweak window tracking to pass III
-			 * and IV until that happens.
-			 */
-			if (receiver->td_maxwin == 0)
+			if (receiver->td_maxwin == 0) {
+				/* We haven't seen traffic in the other
+				 * direction yet but we have to tweak window
+				 * tracking to pass III and IV until that
+				 * happens.
+				 */
 				receiver->td_end = receiver->td_maxend = sack;
+			} else if (sack == receiver->td_end + 1) {
+				/* Likely a reply to a keepalive.
+				 * Needed for III.
+				 */
+				receiver->td_end++;
+			}
+
 		}
 	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
 		     && dir == IP_CT_DIR_ORIGINAL)
-- 
2.28.0

