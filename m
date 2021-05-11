Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4747A37ACCC
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhEKRPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:15:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231392AbhEKRPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 13:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620753250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pk4z78AX9PO6TFw0FJG3UMJGW7JO7PHknrNHBcHpsYw=;
        b=BRX1jLCtxnPb+Ilizt1Q82HMveUelli3PF+nThWD40GEdC/tvhtraAt32sgoeIy2tpvCIG
        CgTYPR3PW8oWDv9qfBaFJJmI+C0nnK2s4tLWd/TgrJ9221XLnvBqTHetnjvwtlYXYGq05T
        EYdjZ3a9EDv/M0+2SYX+w06d3RkdAS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-ZgT30B2VODW3_Hx6oOB55A-1; Tue, 11 May 2021 13:14:07 -0400
X-MC-Unique: ZgT30B2VODW3_Hx6oOB55A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47332107ACC7;
        Tue, 11 May 2021 17:14:05 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-64.ams2.redhat.com [10.36.115.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F8661037F2C;
        Tue, 11 May 2021 17:14:03 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        Maxim Galaganov <max@internet.ru>
Subject: [PATCH v2 net] mptcp: fix data stream corruption
Date:   Tue, 11 May 2021 19:13:51 +0200
Message-Id: <0c393b7ad78e0bab142f48d53995aaa8636b44d9.1620753167.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim reported several issues when forcing a TCP transparent proxy
to use the MPTCP protocol for the inbound connections. He also
provided a clean reproducer.

The problem boils down to 'mptcp_frag_can_collapse_to()' assuming
that only MPTCP will use the given page_frag.

If others - e.g. the plain TCP protocol - allocate page fragments,
we can end-up re-using already allocated memory for mptcp_data_frag.

Fix the issue ensuring that the to-be-expanded data fragment is
located at the current page frag end.

v1 -> v2:
 - added missing fixes tag (Mat)

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/178
Reported-and-tested-by: Maxim Galaganov <max@internet.ru>
Fixes: 18b683bff89d ("mptcp: queue data for mptcp level retransmission")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 29a2d690d8d5..2d21a4793d9d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -879,12 +879,18 @@ static bool mptcp_skb_can_collapse_to(u64 write_seq,
 	       !mpext->frozen;
 }
 
+/* we can append data to the given data frag if:
+ * - there is space available in the backing page_frag
+ * - the data frag tail matches the current page_frag free offset
+ * - the data frag end sequence number matches the current write seq
+ */
 static bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 				       const struct page_frag *pfrag,
 				       const struct mptcp_data_frag *df)
 {
 	return df && pfrag->page == df->page &&
 		pfrag->size - pfrag->offset > 0 &&
+		pfrag->offset == (df->offset + df->data_len) &&
 		df->data_seq + df->data_len == msk->write_seq;
 }
 
-- 
2.26.2

