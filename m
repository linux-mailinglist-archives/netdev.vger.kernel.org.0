Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC0D2FD316
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390733AbhATOnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:43:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390738AbhATOlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:41:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611153579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XPDF/8ZhQ5X6VNrQ7rptRG2PQl0Zfy2UgNnICXwROn4=;
        b=SrGPNp6tUwcZlhhU3BhqBC6Z4EZh3PFhfwNSPIhl7bwxKNaltwIwab5OcSKIKvBV6v+O3Z
        VcQR4LgcAIQ/IpX63gfru/zpU92ex0kPFr/99/CSjysU3uuKfmUddFHPidUWpagNV60OfR
        h0AZWIZ6dXNllib/G1hGno3A50UCrN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-C7pKSm59PSOmZvzg971NVQ-1; Wed, 20 Jan 2021 09:39:35 -0500
X-MC-Unique: C7pKSm59PSOmZvzg971NVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABBB7107ACE6;
        Wed, 20 Jan 2021 14:39:34 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-164.ams2.redhat.com [10.36.115.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 483875D9C2;
        Wed, 20 Jan 2021 14:39:33 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH v2 net-next 3/5] mptcp: do not queue excessive data on subflows
Date:   Wed, 20 Jan 2021 15:39:12 +0100
Message-Id: <0ee2b775b36e79bbd46828d8fd95b0b4c030928b.1611153172.git.pabeni@redhat.com>
In-Reply-To: <cover.1611153172.git.pabeni@redhat.com>
References: <cover.1611153172.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

