Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B833769A7
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhEGRsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 13:48:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49132 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhEGRsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 13:48:51 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A10AF64158;
        Fri,  7 May 2021 19:47:02 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/8] netfilter: remove BUG_ON() after skb_header_pointer()
Date:   Fri,  7 May 2021 19:47:36 +0200
Message-Id: <20210507174739.1850-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507174739.1850-1-pablo@netfilter.org>
References: <20210507174739.1850-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several conntrack helpers and the TCP tracker assume that
skb_header_pointer() never fails based on upfront header validation.
Even if this should not ever happen, BUG_ON() is a too drastic measure,
remove them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ftp.c       | 5 ++++-
 net/netfilter/nf_conntrack_h323_main.c | 3 ++-
 net/netfilter/nf_conntrack_irc.c       | 5 ++++-
 net/netfilter/nf_conntrack_pptp.c      | 4 +++-
 net/netfilter/nf_conntrack_proto_tcp.c | 6 ++++--
 net/netfilter/nf_conntrack_sane.c      | 5 ++++-
 6 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index b22801f97bce..a414274338cf 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -413,7 +413,10 @@ static int help(struct sk_buff *skb,
 
 	spin_lock_bh(&nf_ftp_lock);
 	fb_ptr = skb_header_pointer(skb, dataoff, datalen, ftp_buffer);
-	BUG_ON(fb_ptr == NULL);
+	if (!fb_ptr) {
+		spin_unlock_bh(&nf_ftp_lock);
+		return NF_ACCEPT;
+	}
 
 	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
 	seq = ntohl(th->seq) + datalen;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 8ba037b76ad3..aafaff00baf1 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -146,7 +146,8 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 		/* Get first TPKT pointer */
 		tpkt = skb_header_pointer(skb, tcpdataoff, tcpdatalen,
 					  h323_buffer);
-		BUG_ON(tpkt == NULL);
+		if (!tpkt)
+			goto clear_out;
 
 		/* Validate TPKT identifier */
 		if (tcpdatalen < 4 || tpkt[0] != 0x03 || tpkt[1] != 0) {
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index e40988a2f22f..08ee4e760a3d 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -143,7 +143,10 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	spin_lock_bh(&irc_buffer_lock);
 	ib_ptr = skb_header_pointer(skb, dataoff, skb->len - dataoff,
 				    irc_buffer);
-	BUG_ON(ib_ptr == NULL);
+	if (!ib_ptr) {
+		spin_unlock_bh(&irc_buffer_lock);
+		return NF_ACCEPT;
+	}
 
 	data = ib_ptr;
 	data_limit = ib_ptr + skb->len - dataoff;
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 5105d4250012..7d5708b92138 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -544,7 +544,9 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 
 	nexthdr_off = protoff;
 	tcph = skb_header_pointer(skb, nexthdr_off, sizeof(_tcph), &_tcph);
-	BUG_ON(!tcph);
+	if (!tcph)
+		return NF_ACCEPT;
+
 	nexthdr_off += tcph->doff * 4;
 	datalen = tcplen - tcph->doff * 4;
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 318b8f723349..34e22416a721 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -338,7 +338,8 @@ static void tcp_options(const struct sk_buff *skb,
 
 	ptr = skb_header_pointer(skb, dataoff + sizeof(struct tcphdr),
 				 length, buff);
-	BUG_ON(ptr == NULL);
+	if (!ptr)
+		return;
 
 	state->td_scale =
 	state->flags = 0;
@@ -394,7 +395,8 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 
 	ptr = skb_header_pointer(skb, dataoff + sizeof(struct tcphdr),
 				 length, buff);
-	BUG_ON(ptr == NULL);
+	if (!ptr)
+		return;
 
 	/* Fast path for timestamp-only option */
 	if (length == TCPOLEN_TSTAMP_ALIGNED
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 1aebd6569d4e..fcb33b1d5456 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -95,7 +95,10 @@ static int help(struct sk_buff *skb,
 
 	spin_lock_bh(&nf_sane_lock);
 	sb_ptr = skb_header_pointer(skb, dataoff, datalen, sane_buffer);
-	BUG_ON(sb_ptr == NULL);
+	if (!sb_ptr) {
+		spin_unlock_bh(&nf_sane_lock);
+		return NF_ACCEPT;
+	}
 
 	if (dir == IP_CT_DIR_ORIGINAL) {
 		if (datalen != sizeof(struct sane_request))
-- 
2.30.2

