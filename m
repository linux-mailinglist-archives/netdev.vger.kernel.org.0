Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82721284FD1
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgJFQ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:29:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgJFQ3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 12:29:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602001757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eMCynJ13o3ado4OW8hiqU8BCYQxG79YR/H2z2pIbBrQ=;
        b=QIVniDgckQCjNTyrWeEGkWqlje/XxMuKjFPDY7X612jRe8XJUnCNCB+8CeHIJ+GyF6C16T
        uzwQ9fnPv4dXlz/fex6NArK5mIR+bJPLridpSw0NJUeVqOduaXxEqfHb7SAiM1KmcfRFYY
        kLpyk32QCmmfWoiSmF0CNRqy2jXXico=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-NwLnfClSPi64cIiN3U8aOA-1; Tue, 06 Oct 2020 12:29:16 -0400
X-MC-Unique: NwLnfClSPi64cIiN3U8aOA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEB8418A8223;
        Tue,  6 Oct 2020 16:29:14 +0000 (UTC)
Received: from new-host-6.redhat.com (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF6841A8EC;
        Tue,  6 Oct 2020 16:29:12 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     mptcp@lists.01.org, Christoph Paasch <cpaasch@apple.com>,
        pabeni@redhat.com, Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net] net: mptcp: make DACK4/DACK8 usage consistent among all subflows
Date:   Tue,  6 Oct 2020 18:26:17 +0200
Message-Id: <70c96303d6d9931aae1b1028aed016d807df0e20.1602001119.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

using packetdrill it's possible to observe the same MPTCP DSN being acked
by different subflows with DACK4 and DACK8. This is in contrast with what
specified in RFC8684 §3.3.2: if an MPTCP endpoint transmits a 64-bit wide
DSN, it MUST be acknowledged with a 64-bit wide DACK. Fix 'use_64bit_ack'
variable to make it a property of MPTCP sockets, not TCP subflows.

Fixes: a0c1d0eafd1e ("mptcp: Use 32-bit DATA_ACK when possible")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/options.c  | 2 +-
 net/mptcp/protocol.h | 2 +-
 net/mptcp/subflow.c  | 3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 888bbbbb3e8a..9d7fa93fe0cf 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -516,7 +516,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		return ret;
 	}
 
-	if (subflow->use_64bit_ack) {
+	if (READ_ONCE(msk->use_64bit_ack)) {
 		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
 		opts->ext_copy.data_ack = READ_ONCE(msk->ack_seq);
 		opts->ext_copy.ack64 = 1;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 20f04ac85409..285dd8b2b43a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -202,6 +202,7 @@ struct mptcp_sock {
 	bool		fully_established;
 	bool		rcv_data_fin;
 	bool		snd_data_fin_enable;
+	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct list_head conn_list;
@@ -294,7 +295,6 @@ struct mptcp_subflow_context {
 		backup : 1,
 		data_avail : 1,
 		rx_eof : 1,
-		use_64bit_ack : 1, /* Set when we received a 64-bit DSN */
 		can_ack : 1;	    /* only after processing the remote a key */
 	u32	remote_nonce;
 	u64	thmac;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6f035af1c9d2..91bef7bfffa6 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -769,12 +769,11 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 	if (!mpext->dsn64) {
 		map_seq = expand_seq(subflow->map_seq, subflow->map_data_len,
 				     mpext->data_seq);
-		subflow->use_64bit_ack = 0;
 		pr_debug("expanded seq=%llu", subflow->map_seq);
 	} else {
 		map_seq = mpext->data_seq;
-		subflow->use_64bit_ack = 1;
 	}
+	WRITE_ONCE(mptcp_sk(subflow->conn)->use_64bit_ack, !!mpext->dsn64);
 
 	if (subflow->map_valid) {
 		/* Allow replacing only with an identical map */
-- 
2.26.2

