Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2B32661D8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgIKPKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:10:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbgIKPH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599836806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WqCMOiS2VshMlLkrkKtWQH98sRJoAhZ9ktcEKlFUYOE=;
        b=JUDv23bimEVYutA5kEC9htqnYE+687OMnxf8ZOOBYzeGl7Hb2k0T6TZL9TCrC1wwnpJnO6
        gr7wRq7wZyxf38jHMKEqfYE0OLTYvGcPxBMdJzq3StwQr5c6QCPbsAdlAcPDFTUzs/BYSc
        07N7K+93bK253ftAJ5TsZHD72DVU51M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-TqGQvupnP5-fSBLNDJMmTA-1; Fri, 11 Sep 2020 09:52:31 -0400
X-MC-Unique: TqGQvupnP5-fSBLNDJMmTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40A601017DC5;
        Fri, 11 Sep 2020 13:52:30 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14E0C5C1BD;
        Fri, 11 Sep 2020 13:52:28 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 02/13] mptcp: set data_ready status bit in subflow_check_data_avail()
Date:   Fri, 11 Sep 2020 15:51:57 +0200
Message-Id: <10b65904849e08dfccab8da33219d2081341f581.1599832097.git.pabeni@redhat.com>
In-Reply-To: <cover.1599832097.git.pabeni@redhat.com>
References: <cover.1599832097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This simplify mptcp_subflow_data_available() and will
made follow-up patches simpler.

Additionally remove the unneeded checks on subflow copied_seq:
we always whole skbs out of subflows.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 7ae1d3604047..53b455c3c229 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -825,6 +825,8 @@ static bool subflow_check_data_avail(struct sock *ssk)
 
 	pr_debug("msk=%p ssk=%p data_avail=%d skb=%p", subflow->conn, ssk,
 		 subflow->data_avail, skb_peek(&ssk->sk_receive_queue));
+	if (!skb_peek(&ssk->sk_receive_queue))
+		subflow->data_avail = 0;
 	if (subflow->data_avail)
 		return true;
 
@@ -849,6 +851,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 			subflow->map_data_len = skb->len;
 			subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq -
 						   subflow->ssn_offset;
+			subflow->data_avail = 1;
 			return true;
 		}
 
@@ -876,8 +879,10 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		ack_seq = mptcp_subflow_get_mapped_dsn(subflow);
 		pr_debug("msk ack_seq=%llx subflow ack_seq=%llx", old_ack,
 			 ack_seq);
-		if (ack_seq == old_ack)
+		if (ack_seq == old_ack) {
+			subflow->data_avail = 1;
 			break;
+		}
 
 		/* only accept in-sequence mapping. Old values are spurious
 		 * retransmission; we can hit "future" values on active backup
@@ -922,13 +927,13 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	ssk->sk_error_report(ssk);
 	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
+	subflow->data_avail = 0;
 	return false;
 }
 
 bool mptcp_subflow_data_available(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-	struct sk_buff *skb;
 
 	/* check if current mapping is still valid */
 	if (subflow->map_valid &&
@@ -941,15 +946,7 @@ bool mptcp_subflow_data_available(struct sock *sk)
 			 subflow->map_data_len);
 	}
 
-	if (!subflow_check_data_avail(sk)) {
-		subflow->data_avail = 0;
-		return false;
-	}
-
-	skb = skb_peek(&sk->sk_receive_queue);
-	subflow->data_avail = skb &&
-		       before(tcp_sk(sk)->copied_seq, TCP_SKB_CB(skb)->end_seq);
-	return subflow->data_avail;
+	return subflow_check_data_avail(sk);
 }
 
 /* If ssk has an mptcp parent socket, use the mptcp rcvbuf occupancy,
-- 
2.26.2

