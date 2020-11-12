Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72182B031A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgKLKtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:49:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727982AbgKLKtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UFTuq78chKCNUrfowtXZsmiS7QwnimXACuj/pFt1OA0=;
        b=RC0y7pz/OkgvnrdLBPNhHMn8jQZ+Z5CSGMubYiEDu3ZTm+7My0OGNx63YmD9jEqnCQ+RpF
        2UXGNRR0OR5IlcsD4JbckNJnTEA1AfmT3/r+OuOiafPuZN2gR2781G35aNFP5BbzKrETV9
        ZFzdJVWx/72lkNIhzUq4j2T/fWgK97g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-yH4Z06OsP6KmlOF54ATI7A-1; Thu, 12 Nov 2020 05:49:13 -0500
X-MC-Unique: yH4Z06OsP6KmlOF54ATI7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0C86803F76;
        Thu, 12 Nov 2020 10:49:11 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9B445C3E1;
        Thu, 12 Nov 2020 10:49:10 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/13] mptcp: try to push pending data on snd una updates
Date:   Thu, 12 Nov 2020 11:48:08 +0100
Message-Id: <5f8b7b5471d6cdb0bded3eaf368aaa8070fcb0c1.1605175834.git.pabeni@redhat.com>
In-Reply-To: <cover.1605175834.git.pabeni@redhat.com>
References: <cover.1605175834.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch we may end-up with unsent data
in the write buffer. If such buffer is full, the writer
will block for unlimited time.

We need to trigger the MPTCP xmit path even for the
subflow rx path, on MPTCP snd_una updates.

Keep things simple and just schedule the work queue if
needed.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index eae457dc7061..86b4b6e2afbc 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -731,6 +731,7 @@ void mptcp_data_acked(struct sock *sk)
 	mptcp_reset_timer(sk);
 
 	if ((!test_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags) ||
+	     mptcp_send_head(sk) ||
 	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)))
 		mptcp_schedule_work(sk);
 }
@@ -1835,6 +1836,8 @@ static void mptcp_worker(struct work_struct *work)
 		__mptcp_close_subflow(msk);
 
 	__mptcp_move_skbs(msk);
+	if (mptcp_send_head(sk))
+		mptcp_push_pending(sk, 0);
 
 	if (msk->pm.status)
 		pm_work(msk);
-- 
2.26.2

