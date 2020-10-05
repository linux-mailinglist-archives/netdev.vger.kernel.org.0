Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8FD283408
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 12:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgJEKg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 06:36:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgJEKg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 06:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601894217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BVaaOXwv8CyX/hlyFQUkU2k+m4UBlB+wLNNTE6hW64o=;
        b=Ef3ZtJNNUpWEOCLkwGR9sKxzQlgwWIwRN98U92KhP2RYFh9lsjGPVMLf9Uk0DRx5bsEaaK
        kXKWkGQRuL+GiIoEi5Dj3hKQv7wum1k9xD11Z1wwZWcQapljPQDGVJ2xeJKqdAPd+NRkp+
        AgHir1Fw+q51OcabXc+TtGSJ7eSMSow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-G8igVw_gMFees3JH-Sh_Iw-1; Mon, 05 Oct 2020 06:36:55 -0400
X-MC-Unique: G8igVw_gMFees3JH-Sh_Iw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C0701084C84;
        Mon,  5 Oct 2020 10:36:54 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-59.ams2.redhat.com [10.36.113.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B5F35C225;
        Mon,  5 Oct 2020 10:36:52 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next] mptcp: don't skip needed ack
Date:   Mon,  5 Oct 2020 12:36:44 +0200
Message-Id: <515e80a174ee9bad5e2c6a8338d9362eb43d39b7.1601894086.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we skip calling tcp_cleanup_rbuf() when packets
are moved into the OoO queue or simply dropped. In both
cases we still increment tp->copied_seq, and we should
ask the TCP stack to check for ack.

Fixes: c76c6956566f ("mptcp: call tcp_cleanup_rbuf on subflows")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 34c037731f35..f483eab0081a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -454,10 +454,12 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	unsigned int moved = 0;
 	bool more_data_avail;
 	struct tcp_sock *tp;
+	u32 old_copied_seq;
 	bool done = false;
 
 	pr_debug("msk=%p ssk=%p", msk, ssk);
 	tp = tcp_sk(ssk);
+	old_copied_seq = tp->copied_seq;
 	do {
 		u32 map_remaining, offset;
 		u32 seq = tp->copied_seq;
@@ -516,8 +518,8 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	} while (more_data_avail);
 
 	*bytes += moved;
-	if (moved)
-		tcp_cleanup_rbuf(ssk, moved);
+	if (tp->copied_seq != old_copied_seq)
+		tcp_cleanup_rbuf(ssk, 1);
 
 	return done;
 }
-- 
2.26.2

