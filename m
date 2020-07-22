Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C70229B39
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgGVPVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:21:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29591 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727778AbgGVPVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595431301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jaQ/a7y/4CoGyZ9LRUkS6Ipuosl5t3mlz1Dz/3miviA=;
        b=FKGD1sJGlxk2uoIyWwGV+BtQEQd4LpeDOQjo/kO/mR3vc9Xd4tiTq14ejBz0tJZLVnb3Zd
        ThMu4FKKhcwQcpaPjaPgp9WCrutXnvt2yjf8cXUU0rG4xGj3YLq71OXSTY0BeiSHYZkUjK
        Mm3SJ6cY0UKEpVFA9EzIecMjy2Rei9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-6ZI6jYd1NUyaZJfRAIFmtg-1; Wed, 22 Jul 2020 11:21:39 -0400
X-MC-Unique: 6ZI6jYd1NUyaZJfRAIFmtg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A9A280BCC9;
        Wed, 22 Jul 2020 15:21:31 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-19.ams2.redhat.com [10.36.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C0192B6DB;
        Wed, 22 Jul 2020 15:21:29 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] mptcp: zero token hash at creation time.
Date:   Wed, 22 Jul 2020 17:20:50 +0200
Message-Id: <9c1619337f0fa54112c0fe6f0e0100ded392ac3e.1595431172.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise the 'chain_len' filed will carry random values,
some token creation calls will fail due to excessive chain
length, causing unexpected fallback to TCP.

Fixes: 2c5ebd001d4f ("mptcp: refactor token container")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/token.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index b25b390dbbff..97cfc45bcc4f 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -368,7 +368,7 @@ void __init mptcp_token_init(void)
 					     sizeof(struct token_bucket),
 					     0,
 					     20,/* one slot per 1MB of memory */
-					     0,
+					     HASH_ZERO,
 					     NULL,
 					     &token_mask,
 					     0,
-- 
2.26.2

