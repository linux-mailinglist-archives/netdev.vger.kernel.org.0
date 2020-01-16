Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28E013F901
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437707AbgAPTWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731005AbgAPQxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5874214AF;
        Thu, 16 Jan 2020 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193611;
        bh=Ct7epx5Ce1DJ/Hup0WnjGmC1dF6IYb33R8xHw35puVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edy9qZXJY2wL2ZtzTXYrDXXEpqnlHKpq05lC7uCIMBhWgfZZkWSCrWgBOskphPQ+L
         GU9ndiMRZZGh018Df6RSmCxqqZtOwUOAamgpuHY/WImwWCoBRHaFEUwUf/L6Ib60Hi
         j2Dn9O4I8w4yxUTr0IIHgPRGcgVmUmZpUU+hItKQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 149/205] SUNRPC: Fix another issue with MIC buffer space
Date:   Thu, 16 Jan 2020 11:42:04 -0500
Message-Id: <20200116164300.6705-149-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit e8d70b321ecc9b23d09b8df63e38a2f73160c209 ]

xdr_shrink_pagelen() BUG's when @len is larger than buf->page_len.
This can happen when xdr_buf_read_mic() is given an xdr_buf with
a small page array (like, only a few bytes).

Instead, just cap the number of bytes that xdr_shrink_pagelen()
will move.

Fixes: 5f1bc39979d ("SUNRPC: Fix buffer handling of GSS MIC ... ")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xdr.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 14ba9e72a204..f3104be8ff5d 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -436,13 +436,12 @@ xdr_shrink_bufhead(struct xdr_buf *buf, size_t len)
 }
 
 /**
- * xdr_shrink_pagelen
+ * xdr_shrink_pagelen - shrinks buf->pages by up to @len bytes
  * @buf: xdr_buf
  * @len: bytes to remove from buf->pages
  *
- * Shrinks XDR buffer's page array buf->pages by
- * 'len' bytes. The extra data is not lost, but is instead
- * moved into the tail.
+ * The extra data is not lost, but is instead moved into buf->tail.
+ * Returns the actual number of bytes moved.
  */
 static unsigned int
 xdr_shrink_pagelen(struct xdr_buf *buf, size_t len)
@@ -455,8 +454,8 @@ xdr_shrink_pagelen(struct xdr_buf *buf, size_t len)
 
 	result = 0;
 	tail = buf->tail;
-	BUG_ON (len > pglen);
-
+	if (len > buf->page_len)
+		len = buf-> page_len;
 	tailbuf_len = buf->buflen - buf->head->iov_len - buf->page_len;
 
 	/* Shift the tail first */
-- 
2.20.1

