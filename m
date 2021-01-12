Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0752F370E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390602AbhALR1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:27:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732976AbhALR1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 12:27:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610472354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bM2jLbqRCqyDDkvsxvJousKKruXgvxyqSZAVuwhgf6Y=;
        b=fAGb1RiItgZlkAejTa33nrNU2l+FCTyl4KJm2O3L8q60AglVtl40bc4Uj5pBrni0jZ3e7/
        ncUPn3Yfbyv3ms+9tKOSYnmd8+80agvyohcjSVZVSbgFriQDRLEqxmXS/zgUr9pjjJ5Vz2
        MsaRf0EK3lxRBoH2C21CYkXiVqXKoJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-Ob3GbzCLMg6DmTZwsfVIZw-1; Tue, 12 Jan 2021 12:25:50 -0500
X-MC-Unique: Ob3GbzCLMg6DmTZwsfVIZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 060388026A8;
        Tue, 12 Jan 2021 17:25:49 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-120.ams2.redhat.com [10.36.115.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D169E1975E;
        Tue, 12 Jan 2021 17:25:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/2] mptcp: more strict state checking for acks
Date:   Tue, 12 Jan 2021 18:25:23 +0100
Message-Id: <5566ba1c4409a652440d84ff49b99e58ca998a0e.1610471474.git.pabeni@redhat.com>
In-Reply-To: <cover.1610471474.git.pabeni@redhat.com>
References: <cover.1610471474.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller found a way to trigger division by zero
in mptcp_subflow_cleanup_rbuf().

The current checks implemented into tcp_can_send_ack()
are too week, let's be more accurate.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
Fixes: fd8976790a6c ("mptcp: be careful on MPTCP-level ack.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 6628d8d74203..2ff8c7caf74f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -427,7 +427,7 @@ static bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
 static bool tcp_can_send_ack(const struct sock *ssk)
 {
 	return !((1 << inet_sk_state_load(ssk)) &
-	       (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_TIME_WAIT | TCPF_CLOSE));
+	       (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_TIME_WAIT | TCPF_CLOSE | TCPF_LISTEN));
 }
 
 static void mptcp_send_ack(struct mptcp_sock *msk)
-- 
2.26.2

