Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78E12833C0
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 12:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgJEKBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 06:01:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgJEKBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 06:01:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601892082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tFJWhgqTTbW6N9Kd7ZDDh802zSS4kURR+ppFG4ZSLTs=;
        b=Z0myC6yVFPsZBy5Thn2zlbSbf9W6r60dxi29v1rT8t4kqFCYuxCca7YDu1soyMLrMdP4/R
        yBTJomZG3WgloO5srbosmQtdvAwPZ8r6drxCj5umc0pbeMIUeVzcNUY+xqvsBJnZQBQwZG
        76xM1Ot91LxtmXwjdPAtyhskrxI9r/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-1lyfUzpmNHmNx6_G82l3Fg-1; Mon, 05 Oct 2020 06:01:20 -0400
X-MC-Unique: 1lyfUzpmNHmNx6_G82l3Fg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC35A873116;
        Mon,  5 Oct 2020 10:01:18 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-59.ams2.redhat.com [10.36.113.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 634D178804;
        Mon,  5 Oct 2020 10:01:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org
Subject: [PATCH net] mptcp: more DATA FIN fixes
Date:   Mon,  5 Oct 2020 12:01:06 +0200
Message-Id: <359280012491ffc587afdfb55aaaec60953c7218.1601891999.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently data fin on data packet are not handled properly:
the 'rcv_data_fin_seq' field is interpreted as the last
sequence number carrying a valid data, but for data fin
packet with valid maps we currently store map_seq + map_len,
that is, the next value.

The 'write_seq' fields carries instead the value subseguent
to the last valid byte, so in mptcp_write_data_fin() we
never detect correctly the last DSS map.

Fixes: 7279da6145bb ("mptcp: Use MPTCP-level flag for sending DATA_FIN")
Fixes: 1a49b2c2a501 ("mptcp: Handle incoming 32-bit DATA_FIN values")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 10 +++++-----
 net/mptcp/subflow.c |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index afa486912f5a..888bbbbb3e8a 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -451,7 +451,10 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
 				 struct sk_buff *skb, struct mptcp_ext *ext)
 {
-	u64 data_fin_tx_seq = READ_ONCE(mptcp_sk(subflow->conn)->write_seq);
+	/* The write_seq value has already been incremented, so the actual
+	 * sequence number for the DATA_FIN is one less.
+	 */
+	u64 data_fin_tx_seq = READ_ONCE(mptcp_sk(subflow->conn)->write_seq) - 1;
 
 	if (!ext->use_map || !skb->len) {
 		/* RFC6824 requires a DSS mapping with specific values
@@ -460,10 +463,7 @@ static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
 		ext->data_fin = 1;
 		ext->use_map = 1;
 		ext->dsn64 = 1;
-		/* The write_seq value has already been incremented, so
-		 * the actual sequence number for the DATA_FIN is one less.
-		 */
-		ext->data_seq = data_fin_tx_seq - 1;
+		ext->data_seq = data_fin_tx_seq;
 		ext->subflow_seq = 0;
 		ext->data_len = 1;
 	} else if (ext->data_seq + ext->data_len == data_fin_tx_seq) {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5f2fa935022d..6f035af1c9d2 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -749,7 +749,7 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 				return MAPPING_DATA_FIN;
 			}
 		} else {
-			u64 data_fin_seq = mpext->data_seq + data_len;
+			u64 data_fin_seq = mpext->data_seq + data_len - 1;
 
 			/* If mpext->data_seq is a 32-bit value, data_fin_seq
 			 * must also be limited to 32 bits.
-- 
2.26.2

