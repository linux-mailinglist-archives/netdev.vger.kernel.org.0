Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2EE22AD29
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgGWLDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:03:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34549 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728320AbgGWLDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:03:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595502184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4lvMfuzHhoE0KFL7pc1lC0ZGw3YOHiG0MXHkr/x8Exw=;
        b=RqT9fnzqL5jakd6fLBnrlfk8dHSf89mo3AVphfJBZnQtuIsxJ/n9kfRd3AB+k+ls2Ao0Yr
        yNh53NLBZdwlIFfhk921F6c+/p93MLkBshDV3aoS5v14nC9ZOd+q+tVE6MyBp2chmrGwzh
        kEIhoEwwshmcaunSz7F7vC9lw7RB/xE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-hYjPNUFANiKpUsb2VITgOQ-1; Thu, 23 Jul 2020 07:03:02 -0400
X-MC-Unique: hYjPNUFANiKpUsb2VITgOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6C2E1B2C980;
        Thu, 23 Jul 2020 11:03:01 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBB7A8BEDC;
        Thu, 23 Jul 2020 11:03:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next 2/8] mptcp: avoid data corruption on reinsert
Date:   Thu, 23 Jul 2020 13:02:30 +0200
Message-Id: <4fe02ca627f96087f521a2015d63d8f0c92a4440.1595431326.git.pabeni@redhat.com>
In-Reply-To: <cover.1595431326.git.pabeni@redhat.com>
References: <cover.1595431326.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When updating a partially acked data fragment, we
actually corrupt it. This is irrelevant till we send
data on a single subflow, as retransmitted data, if
any are discarded by the peer as duplicate, but it
will cause data corruption as soon as we will start
creating non backup subflows.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 59c0eef807b3..254e6ef2b4e0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -460,15 +460,20 @@ static void mptcp_clean_una(struct sock *sk)
 
 	dfrag = mptcp_rtx_head(sk);
 	if (dfrag && after64(snd_una, dfrag->data_seq)) {
-		u64 delta = dfrag->data_seq + dfrag->data_len - snd_una;
+		u64 delta = snd_una - dfrag->data_seq;
+
+		if (WARN_ON_ONCE(delta > dfrag->data_len))
+			goto out;
 
 		dfrag->data_seq += delta;
+		dfrag->offset += delta;
 		dfrag->data_len -= delta;
 
 		dfrag_uncharge(sk, delta);
 		cleaned = true;
 	}
 
+out:
 	if (cleaned) {
 		sk_mem_reclaim_partial(sk);
 
-- 
2.26.2

