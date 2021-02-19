Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5EE31FDF3
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhBSRhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:37:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhBSRh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 12:37:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vlvCNWj0BkIHxyg9swFraRcO0X6QkFwFa6djst5ydLY=;
        b=VWEGK2BZTGQa9H0VbKgXMpMtp/mSKxEtE1Z0CecEqzhWsyVWeMjvp1SQxdqp9zE/T8nzng
        xyamyJRV4Wo+vmvil2GDuqOmFMP9Lz3MX9gaq8y7BztHwT4hbgh0ulbVqDDkxj/IkSidC2
        5iEYGyBQI8Y5+tHNMokVIUV/iWhlVSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168--E9mmEuqPl6P1IpOzQmccQ-1; Fri, 19 Feb 2021 12:35:56 -0500
X-MC-Unique: -E9mmEuqPl6P1IpOzQmccQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA4A4107ACE4;
        Fri, 19 Feb 2021 17:35:54 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-85.ams2.redhat.com [10.36.115.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37A921A353;
        Fri, 19 Feb 2021 17:35:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 2/4] mptcp: fix DATA_FIN generation on early shutdown
Date:   Fri, 19 Feb 2021 18:35:38 +0100
Message-Id: <e222c171c1f8f7fa72460c7520eb35bd174a9d6b.1613755058.git.pabeni@redhat.com>
In-Reply-To: <cover.1613755058.git.pabeni@redhat.com>
References: <cover.1613755058.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the msk is closed before sending or receiving any data,
no DATA_FIN is generated, instead an MPC ack packet is
crafted out.

In the above scenario, the MPTCP protocol creates and sends a
pure ack and such packets matches also the criteria for an
MPC ack and the protocol tries first to insert MPC options,
leading to the described error.

This change addresses the issue by avoiding the insertion of an
MPC option for DATA_FIN packets or if the sub-flow is not
established.

To avoid doing multiple times the same test, fetch the data_fin
flag in a bool variable and pass it to both the interested
helpers.

Fixes: 6d0060f600ad ("mptcp: Write MPTCP DSS headers to outgoing data packets")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 8fec3dabe109..b220121e795a 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -401,6 +401,7 @@ static void clear_3rdack_retransmission(struct sock *sk)
 }
 
 static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
+					 bool snd_data_fin_enable,
 					 unsigned int *size,
 					 unsigned int remaining,
 					 struct mptcp_out_options *opts)
@@ -418,9 +419,10 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 	if (!skb)
 		return false;
 
-	/* MPC/MPJ needed only on 3rd ack packet */
-	if (subflow->fully_established ||
-	    subflow->snd_isn != TCP_SKB_CB(skb)->seq)
+	/* MPC/MPJ needed only on 3rd ack packet, DATA_FIN and TCP shutdown take precedence */
+	if (subflow->fully_established || snd_data_fin_enable ||
+	    subflow->snd_isn != TCP_SKB_CB(skb)->seq ||
+	    sk->sk_state != TCP_ESTABLISHED)
 		return false;
 
 	if (subflow->mp_capable) {
@@ -492,20 +494,20 @@ static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
 }
 
 static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
+					  bool snd_data_fin_enable,
 					  unsigned int *size,
 					  unsigned int remaining,
 					  struct mptcp_out_options *opts)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
-	u64 snd_data_fin_enable, ack_seq;
 	unsigned int dss_size = 0;
 	struct mptcp_ext *mpext;
 	unsigned int ack_size;
 	bool ret = false;
+	u64 ack_seq;
 
 	mpext = skb ? mptcp_get_ext(skb) : NULL;
-	snd_data_fin_enable = mptcp_data_fin_enabled(msk);
 
 	if (!skb || (mpext && mpext->use_map) || snd_data_fin_enable) {
 		unsigned int map_size;
@@ -684,12 +686,15 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	unsigned int opt_size = 0;
+	bool snd_data_fin;
 	bool ret = false;
 
 	opts->suboptions = 0;
 
-	if (unlikely(mptcp_check_fallback(sk)))
+	if (unlikely(__mptcp_check_fallback(msk)))
 		return false;
 
 	/* prevent adding of any MPTCP related options on reset packet
@@ -698,10 +703,10 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 	if (unlikely(skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_RST))
 		return false;
 
-	if (mptcp_established_options_mp(sk, skb, &opt_size, remaining, opts))
+	snd_data_fin = mptcp_data_fin_enabled(msk);
+	if (mptcp_established_options_mp(sk, skb, snd_data_fin, &opt_size, remaining, opts))
 		ret = true;
-	else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
-					       opts))
+	else if (mptcp_established_options_dss(sk, skb, snd_data_fin, &opt_size, remaining, opts))
 		ret = true;
 
 	/* we reserved enough space for the above options, and exceeding the
-- 
2.26.2

