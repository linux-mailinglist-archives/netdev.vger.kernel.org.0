Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B48526E71E
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgIQVHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:07:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40874 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726752AbgIQVHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 17:07:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600376870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ii5RKHT4DzfpRC0mW241XcBwMg3usk+atg6kYC/FXIA=;
        b=WwyrrSsRds3HcPc5InFUmrbqfvwuz/g6PEpD6oHbnQBU1zNG02AmxOx31Iyau7AiWRaZCI
        gpMxSmK4l2WXG3B7SXpzeSJD094MPiB52p99462VN0XXPHUNao4aD50XnF7G/dE265P845
        XtFQb+ZgGQvm5B8R2C+MBPJqDhHqbYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-Wh0TSqGvOwWi6wDxsr31pA-1; Thu, 17 Sep 2020 17:07:47 -0400
X-MC-Unique: Wh0TSqGvOwWi6wDxsr31pA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8FEE87147F;
        Thu, 17 Sep 2020 21:07:45 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-68.ams2.redhat.com [10.36.112.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E102E55768;
        Thu, 17 Sep 2020 21:07:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next] mptcp: fix integer overflow in mptcp_subflow_discard_data()
Date:   Thu, 17 Sep 2020 23:07:24 +0200
Message-Id: <1a927c595adf46cf5ff186ca6b129f12fb70f492.1600375771.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph reported an infinite loop in the subflow receive path
under stress condition.

If there are multiple subflows, each of them using a large send
buffer, the delta between the sequence number used by
MPTCP-level retransmission can and the current msk->ack_seq
can be greater than MAX_INT.

In the above scenario, when calling mptcp_subflow_discard_data(),
such delta will be truncated to int, and could result in a negative
number: no bytes will be dropped, and subflow_check_data_avail()
will try again to process the same packet, looping forever.

This change addresses the issue by expanding the 'limit' size to 64
bits, so that overflows are not possible anymore.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/87
Fixes: 6719331c2f73 ("mptcp: trigger msk processing even for OoO data")
Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
net-next patch, as the culprit commit is only on net-next currently
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a2ae3087e24d..34d6230df017 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -807,7 +807,7 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 }
 
 static void mptcp_subflow_discard_data(struct sock *ssk, struct sk_buff *skb,
-				       unsigned int limit)
+				       u64 limit)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	bool fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
-- 
2.26.2

