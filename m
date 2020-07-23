Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA97222AD28
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgGWLDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:03:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32600 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726867AbgGWLDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:03:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595502183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+pF8ujY7iuJ+xZrtJ9+RaovFYs8zNTVHnb2H5CWDP5w=;
        b=EztFikat/Iog9sI0F8JhCN9aJQSNd+uefv7WJaPPu2ej7zrfqFkdqGhQa0bCLvoMyS/ff9
        2tfRiACy9EiygepC2gI4fr3G0Va8eMhG/8JCJs3i7UZXMd+zEnXYc8+G+QT7Py7cWyV1qG
        YKaI9KN6xnd5eIib9ASJgYCcC21XNJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-Mms33mx1P22jXjJvNKWjWw-1; Thu, 23 Jul 2020 07:03:01 -0400
X-MC-Unique: Mms33mx1P22jXjJvNKWjWw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60E4E1005504;
        Thu, 23 Jul 2020 11:03:00 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 507228BED9;
        Thu, 23 Jul 2020 11:02:59 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next 1/8] subflow: always init 'rel_write_seq'
Date:   Thu, 23 Jul 2020 13:02:29 +0200
Message-Id: <16f5e1d322d514caec1dd2e2779ee884d1448154.1595431326.git.pabeni@redhat.com>
In-Reply-To: <cover.1595431326.git.pabeni@redhat.com>
References: <cover.1595431326.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we do not init the subflow write sequence for
MP_JOIN subflows. This will cause bad mapping being
generated as soon as we will use non backup subflow.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 1 -
 net/mptcp/subflow.c  | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f0b0b503c262..59c0eef807b3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1814,7 +1814,6 @@ void mptcp_finish_connect(struct sock *ssk)
 	ack_seq++;
 	subflow->map_seq = ack_seq;
 	subflow->map_subflow_seq = 1;
-	subflow->rel_write_seq = 1;
 
 	/* the socket is not connected yet, no msk/subflow ops can access/race
 	 * accessing the field below
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 519122e66f17..84e70806b250 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -200,6 +200,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	if (subflow->conn_finished)
 		return;
 
+	subflow->rel_write_seq = 1;
 	subflow->conn_finished = 1;
 	subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
 	pr_debug("subflow=%p synack seq=%x", subflow, subflow->ssn_offset);
-- 
2.26.2

