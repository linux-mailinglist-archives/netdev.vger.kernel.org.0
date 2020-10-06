Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F5284604
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgJFG2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:28:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726022AbgJFG2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:28:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601965726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=f8EEeFHl54ekBi2EYp8/Pctg0a03FhMC0u46rQIjQ6s=;
        b=NXxgx1OBb3e/HR0Yu98E8MST1QOdwPVzKnvElu88sxrGzJEWuWEk9627lvnJmV7tqUfL79
        ZU+PCUGUZzlGFL8uNBlDvfu5EFSGOFAn9jEhj+O+vIg8q3yhOROz9RXrqa/+SYj1Y4vhK/
        KvCICRXfgsKWaSLgPTf/6wNrgLd8A5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-8LP2dlVbM_mrrnqpTowQQQ-1; Tue, 06 Oct 2020 02:28:42 -0400
X-MC-Unique: 8LP2dlVbM_mrrnqpTowQQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA54018A0764;
        Tue,  6 Oct 2020 06:28:41 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-231.ams2.redhat.com [10.36.112.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F1CF5D9D2;
        Tue,  6 Oct 2020 06:28:40 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next] mptcp: fix infinite loop on recvmsg()/worker() race.
Date:   Tue,  6 Oct 2020 08:27:34 +0200
Message-Id: <5a2464d778499bdc2ced43b56569008030b470bc.1601965539.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If recvmsg() and the workqueue race to dequeue the data
pending on some subflow, the current mapping for such
subflow covers several skbs and some of them have not
reached yet the received, either the worker or recvmsg()
can find a subflow with the data_avail flag set - since
the current mapping is valid and in sequence - but no
skbs in the receive queue - since the other entity just
processed them.

The above will lead to an unbounded loop in __mptcp_move_skbs()
and a subsequent hang of any task trying to acquiring the msk
socket lock.

This change addresses the issue stopping the __mptcp_move_skbs()
loop as soon as we detect the above race (empty receive queue
with data_avail set).

Reported-and-tested-by: syzbot+fcf8ca5817d6e92c6567@syzkaller.appspotmail.com
Fixes: ab174ad8ef76 ("mptcp: move ooo skbs into msk out of order queue.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f483eab0081a..42928db28351 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -471,8 +471,15 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 				mptcp_subflow_get_map_offset(subflow);
 
 		skb = skb_peek(&ssk->sk_receive_queue);
-		if (!skb)
+		if (!skb) {
+			/* if no data is found, a racing workqueue/recvmsg
+			 * already processed the new data, stop here or we
+			 * can enter an infinite loop
+			 */
+			if (!moved)
+				done = true;
 			break;
+		}
 
 		if (__mptcp_check_fallback(msk)) {
 			/* if we are running under the workqueue, TCP could have
-- 
2.26.2

