Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A5437A1A6
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 10:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhEKIYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 04:24:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230157AbhEKIYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 04:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620721377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tyfAsOOD0IYI1NffGoCzs4QiyeVGAdf22UtbY4croNs=;
        b=R7C2AToQ98nrnx+ZEj6OvhtpyEIj26vz2Bx4nEkn9ePfJ2Wg3gou5ZMIH03BbxOj9pdmEy
        5UJb4Tzmrog/83B2ZVBwBmnbOstxjJ1hSgQ0iCSUi0bJ0ueXjWTlt8o4S5RC1X3LW4xLlM
        SVEGUXnVTE+RAmR1vJMfaSZUvheru+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-z2TxfIlFMhCCnLTz06KurQ-1; Tue, 11 May 2021 04:22:52 -0400
X-MC-Unique: z2TxfIlFMhCCnLTz06KurQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFE2A188E3C2;
        Tue, 11 May 2021 08:22:50 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-64.ams2.redhat.com [10.36.115.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54A195C1A3;
        Tue, 11 May 2021 08:22:48 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        Maxim Galaganov <max@internet.ru>
Subject: [PATCH net] mptcp: fix data stream corruption
Date:   Tue, 11 May 2021 10:22:08 +0200
Message-Id: <95cee926051dae0afe4d39072f446e1cad17008a.1620720059.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/178
Reported-and-tested-by: Maxim Galaganov <max@internet.ru>
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

