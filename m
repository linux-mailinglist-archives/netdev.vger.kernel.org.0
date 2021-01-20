Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A332FCF00
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389112AbhATLQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:16:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387743AbhATKm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:42:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611139280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XPDF/8ZhQ5X6VNrQ7rptRG2PQl0Zfy2UgNnICXwROn4=;
        b=CdUsJAk8+lEagxaN6ExTFfIuXy0jDPlqXXVmZeX+c+zdkIAcqGCLC7muegsRx764+tyVQg
        Bh77P/BqUVcLFICKi1mBQVjXCn8XRd4vruyvBnyqFnUKT8iYCHjCNVZPKctrab4oxVTeCa
        522/ySwZK4aFSqJPKWbsFtrhXunJP8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-shXsQIF1Pu-pEybtrgRVVA-1; Wed, 20 Jan 2021 05:41:18 -0500
X-MC-Unique: shXsQIF1Pu-pEybtrgRVVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2BF3801FAE;
        Wed, 20 Jan 2021 10:41:16 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-164.ams2.redhat.com [10.36.115.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBDFC60C6A;
        Wed, 20 Jan 2021 10:41:15 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next 3/5] mptcp: do not queue excessive data on subflows
Date:   Wed, 20 Jan 2021 11:40:38 +0100
Message-Id: <7b6b267c5d108f4fc74a632005f52f659196e0b0.1610991949.git.pabeni@redhat.com>
In-Reply-To: <cover.1610991949.git.pabeni@redhat.com>
References: <cover.1610991949.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current packet scheduler can enqueue up to sndbuf
data on each subflow. If the send buffer is large and
the subflows are not symmetric, this could lead to
suboptimal aggregate bandwidth utilization.

Limit the amount of queued data to the maximum send
window.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d07e60330df56..e741201acc98f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1389,7 +1389,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 			continue;
 
 		nr_active += !subflow->backup;
-		if (!sk_stream_memory_free(subflow->tcp_sock))
+		if (!sk_stream_memory_free(subflow->tcp_sock) || !tcp_sk(ssk)->snd_wnd)
 			continue;
 
 		pace = READ_ONCE(ssk->sk_pacing_rate);
@@ -1415,7 +1415,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 	if (send_info[0].ssk) {
 		msk->last_snd = send_info[0].ssk;
 		msk->snd_burst = min_t(int, MPTCP_SEND_BURST_SIZE,
-				       sk_stream_wspace(msk->last_snd));
+				       tcp_sk(msk->last_snd)->snd_wnd);
 		return msk->last_snd;
 	}
 
-- 
2.26.2

