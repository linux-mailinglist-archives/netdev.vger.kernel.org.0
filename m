Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233C731FDF4
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBSRhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:37:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229623AbhBSRh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 12:37:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/RYB8opGR79izKUXM8ooYEqmS/gVeO2G0VTzKgWW3PY=;
        b=ZlmaHCStaR8BM+D7NwIEoFf4ncUrSAVt/3KqyullaqcdAjWrs4ejJLnsXiRR0HiibiOoKV
        8Mhdt7JJ7auKwaaipnhbMOAuufIH0Y+bIDsw6CVGgf0skoQx1CubYB9v2LUFJkqfzEx6QN
        SE/BUwOGaQZ85/GnNQVmKa2ykWnxRLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-anSD2zi1NfyYhCc-2ECTFQ-1; Fri, 19 Feb 2021 12:35:59 -0500
X-MC-Unique: anSD2zi1NfyYhCc-2ECTFQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88EAF801978;
        Fri, 19 Feb 2021 17:35:58 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-85.ams2.redhat.com [10.36.115.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 325C01971D;
        Fri, 19 Feb 2021 17:35:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 4/4] mptcp: do not wakeup listener for MPJ subflows
Date:   Fri, 19 Feb 2021 18:35:40 +0100
Message-Id: <039d97d7c7d90a52e55aa90760585eea7cb0d027.1613755058.git.pabeni@redhat.com>
In-Reply-To: <cover.1613755058.git.pabeni@redhat.com>
References: <cover.1613755058.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPJ subflows are not exposed as fds to user spaces. As such,
incoming MPJ subflows are removed from the accept queue by
tcp_check_req()/tcp_get_cookie_sock().

Later tcp_child_process() invokes subflow_data_ready() on the
parent socket regardless of the subflow kind, leading to poll
wakeups even if the later accept will block.

Address the issue by double-checking the queue state before
waking the user-space.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/164
Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8b2338dfdc80..59f992fe6728 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1018,6 +1018,12 @@ static void subflow_data_ready(struct sock *sk)
 
 	msk = mptcp_sk(parent);
 	if (state & TCPF_LISTEN) {
+		/* MPJ subflow are removed from accept queue before reaching here,
+		 * avoid stray wakeups
+		 */
+		if (reqsk_queue_empty(&inet_csk(sk)->icsk_accept_queue))
+			return;
+
 		set_bit(MPTCP_DATA_READY, &msk->flags);
 		parent->sk_data_ready(parent);
 		return;
-- 
2.26.2

