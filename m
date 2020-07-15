Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2F1221638
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgGOU1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:27:32 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36705 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725917AbgGOU1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 16:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594844849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IltLClpxgs4K5MYmfJWYiZjllfQyoqFX5PLfjzR2ttA=;
        b=RSv0vtZq7thX2mfZtLU+zlqnYkWDsIHz0rk8a3yN7GN6AN9xqfeJwaUVTg6SknVbZcEfuH
        UCZafGofuOAVD0TfBfYeKRKBcWO7iVic5KqmeTj0q+q38u9TRz4ArE/5+FVifUPCbtYkDr
        /OL/yn1eFzHEinZmJotcx1MTHenb8xI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-rw7XNDciOGutg97xuADnDA-1; Wed, 15 Jul 2020 16:27:23 -0400
X-MC-Unique: rw7XNDciOGutg97xuADnDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0ADC180BCAC;
        Wed, 15 Jul 2020 20:27:22 +0000 (UTC)
Received: from new-host-6.redhat.com (unknown [10.40.192.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56C1879D10;
        Wed, 15 Jul 2020 20:27:20 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: [PATCH net-next] mptcp: silence warning in subflow_data_ready()
Date:   Wed, 15 Jul 2020 22:27:05 +0200
Message-Id: <87f4954cfd7eacd6e220ab60d61e09f35ed32252.1594844608.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

since commit d47a72152097 ("mptcp: fix race in subflow_data_ready()"), it
is possible to observe a regression in MP_JOIN kselftests. For sockets in
TCP_CLOSE state, it's not sufficient to just wake up the main socket: we
also need to ensure that received data are made available to the reader.
Silence the WARN_ON_ONCE() in these cases: it preserves the syzkaller fix
and restores kselftests	when they are ran as follows:

  # while true; do
  > make KBUILD_OUTPUT=/tmp/kselftest TARGETS=net/mptcp kselftest
  > done

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: d47a72152097 ("mptcp: fix race in subflow_data_ready()")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/47
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/subflow.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9f7f3772c13c..519122e66f17 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -869,18 +869,19 @@ void mptcp_space(const struct sock *ssk, int *space, int *full_space)
 static void subflow_data_ready(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	u16 state = 1 << inet_sk_state_load(sk);
 	struct sock *parent = subflow->conn;
 	struct mptcp_sock *msk;
 
 	msk = mptcp_sk(parent);
-	if ((1 << inet_sk_state_load(sk)) & (TCPF_LISTEN | TCPF_CLOSE)) {
+	if (state & TCPF_LISTEN) {
 		set_bit(MPTCP_DATA_READY, &msk->flags);
 		parent->sk_data_ready(parent);
 		return;
 	}
 
 	WARN_ON_ONCE(!__mptcp_check_fallback(msk) && !subflow->mp_capable &&
-		     !subflow->mp_join);
+		     !subflow->mp_join && !(state & TCPF_CLOSE));
 
 	if (mptcp_subflow_data_available(sk))
 		mptcp_data_ready(parent, sk);
-- 
2.26.2

