Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91E4213D3E
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 18:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgGCQGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 12:06:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46307 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726147AbgGCQGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 12:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593792378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=53qq1GO4ayYZEQO7BYWvUslst4Vh6HGOCdIWCJqcnYE=;
        b=XTG3jVFgKVs+JIOIgSZlREHL1jFUZnDofBQHA4U7gKHPVGwM3mVYNvQT7cqB+rm7Jd0yx2
        kw+adKgShMap2hF8UVtfusBxPYd+ExHGwwIybT0TvthDbim+dodCuY4NqBn+eR8XA94OyI
        r+CINymCJKAFg+trMYDpJrJrCf6ThSE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-Hyr7ftYgOjyCLM6znZIZyA-1; Fri, 03 Jul 2020 12:06:16 -0400
X-MC-Unique: Hyr7ftYgOjyCLM6znZIZyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89CE9BFC0;
        Fri,  3 Jul 2020 16:06:15 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-104.ams2.redhat.com [10.36.114.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5246C7AC6C;
        Fri,  3 Jul 2020 16:06:14 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: fix DSS map generation on fin retransmission
Date:   Fri,  3 Jul 2020 18:06:04 +0200
Message-Id: <1fa7663816c25b247db50501cf3d9df01729dc28.1593792286.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RFC 8684 mandates that no-data DATA FIN packets should carry
a DSS with 0 sequence number and data len equal to 1. Currently,
on FIN retransmission we re-use the existing mapping; if the previous
fin transmission was part of a partially acked data packet, we could
end-up writing in the egress packet a non-compliant DSS.

The above will be detected by a "Bad mapping" warning on the receiver
side.

This change addresses the issue explicitly checking for 0 len packet
when adding the DATA_FIN option.

Fixes: 6d0060f600ad ("mptcp: Write MPTCP DSS headers to outgoing data packets")
Reported-by: syzbot+42a07faa5923cfaeb9c9@syzkaller.appspotmail.com
Tested-by: Christoph Paasch <cpaasch@apple.com>
Reviewed-by: Christoph Paasch <cpaasch@apple.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index df9a51425c6f..8f940be42f98 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -449,9 +449,9 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 }
 
 static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
-				 struct mptcp_ext *ext)
+				 struct sk_buff *skb, struct mptcp_ext *ext)
 {
-	if (!ext->use_map) {
+	if (!ext->use_map || !skb->len) {
 		/* RFC6824 requires a DSS mapping with specific values
 		 * if DATA_FIN is set but no data payload is mapped
 		 */
@@ -503,7 +503,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 			opts->ext_copy = *mpext;
 
 		if (skb && tcp_fin && subflow->data_fin_tx_enable)
-			mptcp_write_data_fin(subflow, &opts->ext_copy);
+			mptcp_write_data_fin(subflow, skb, &opts->ext_copy);
 		ret = true;
 	}
 
-- 
2.26.2

