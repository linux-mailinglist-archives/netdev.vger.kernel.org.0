Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33014570AD
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235901AbhKSObn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:31:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhKSObn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 09:31:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637332121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNIjVdNfrH1EBdflai/IJbkOIg9YwNJFT/WnhVIR6xY=;
        b=Ll4MIT8lhLqgvTDkhSMJ5o1bOiHkrtr3tSQTxf3IMQQ9yzGo5Ns/H2xlqiC4NQASQdywGW
        iYvEu7vxvVDXnJI4USbcuZzsyI7nDZ6W6TGtWaEnJUoKUCxYaOJgOQxS/h0BcSSEoPVgMA
        JvyiFFk9QeHAJLOop/FJdOAhvoO4WvQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-JRDxYi44Of6EnXS1JfR1Sg-1; Fri, 19 Nov 2021 09:28:39 -0500
X-MC-Unique: JRDxYi44Of6EnXS1JfR1Sg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 736B518125C9;
        Fri, 19 Nov 2021 14:28:38 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80A2660657;
        Fri, 19 Nov 2021 14:28:37 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net 1/2] mptcp: fix delack timer
Date:   Fri, 19 Nov 2021 15:27:54 +0100
Message-Id: <3168be19fb4e9c79ff5fe1af1b0b700c39770c43.1637331462.git.pabeni@redhat.com>
In-Reply-To: <cover.1637331462.git.pabeni@redhat.com>
References: <cover.1637331462.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

To compute the rtx timeout schedule_3rdack_retransmission() does multiple
things in the wrong way: srtt_us is measured in usec/8 and the timeout
itself is an absolute value.

Fixes: ec3edaa7ca6ce02f ("mptcp: Add handling of outgoing MP_JOIN requests")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau>@linux.intel.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/mptcp/options.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 7c3420afb1a0..2e9b73eeeeb5 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -434,9 +434,10 @@ static void schedule_3rdack_retransmission(struct sock *sk)
 
 	/* reschedule with a timeout above RTT, as we must look only for drop */
 	if (tp->srtt_us)
-		timeout = tp->srtt_us << 1;
+		timeout = usecs_to_jiffies(tp->srtt_us >> (3 - 1));
 	else
 		timeout = TCP_TIMEOUT_INIT;
+	timeout += jiffies;
 
 	WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
 	icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
-- 
2.33.1

