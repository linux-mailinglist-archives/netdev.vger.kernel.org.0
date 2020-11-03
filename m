Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5662F2A407A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgKCJmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCJmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:42:03 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935D8C0613D1;
        Tue,  3 Nov 2020 01:42:03 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id u4so1434546pgr.9;
        Tue, 03 Nov 2020 01:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QgdmBtK50ARRJSPrtBkv/wghdRQJfGjFSSE7r68TMXo=;
        b=uGd/g3zERM5x8FvdUYNHkQC0NMam3gXJrYqFEinXAwhmsWvZoCGi84X4+lYxVHHo/0
         uFU8A9lZXjrCMuBzubvaWcTRLVd/LWU/QcOKM0rR6xDw+J+LodWmRYVLwRHODNL76VHA
         FfTxXpSMIhO8BoyTxLpkmMTS0x66EdklLq9qhv8wkgWFfcHa1E9HkLcjmfCfCjI7P/Ns
         +J5ePLOEQOMg6viwUfhVMBWmwlUFnqUu4bYekKxg/U3qNrhuLWfNdSA4omtnoIn7CIZ/
         4EaffbUHIPV/ZlRuHI0ZGXYUaZsg4jL++JyUlLdEsxaQx4wIFsxGG1owt5fl6DRhRsr3
         /Aew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QgdmBtK50ARRJSPrtBkv/wghdRQJfGjFSSE7r68TMXo=;
        b=pQJ/X2pzjwmxPFz8Z2WmcEfvZkB56Gpj8GDuC/QMTIWnOxLimryaqCDtY4rXg+OVcd
         dySoUAQDb4bt1k+GHmAJkiZKYrj9nVIO6GFz5pqyV8BIqRzcxFqOGe+Cy1a62jxdZyQB
         ykd/qQay+BV0xk9uUJ6FwKuQC0buDQ2NFGTOmrMYLjHfNrGZTB6IkhDsBgnV/w3lkiJ8
         P4iiBxyrBT0KG2iiCPTWKGcwXpOWJA5MYVEDNRv5WLzSR4jG9TMMIiIpZzzemwx+cEPe
         KPUKhheH6THkGLUZLPVPgySMxRkxJ6vjDqNt8GywRD/7YPJ34SLiuwozY+fBSsSQvlJ8
         woCw==
X-Gm-Message-State: AOAM530wMsAtkN0wgMXz+ZH2Ye+QlFIymIbJjAX7/xLvNT9rTkrHa5G+
        FvNk4sgrEHSz7ACIyRmdWyiFPvOuZ4h0vSWsRQM=
X-Google-Smtp-Source: ABdhPJw+Eoux9JaAimukJ1FRcD6PeZipQMzCPWkFDOGS9qBfUu6ZU7j3+GqxSA+Djd4kpCS6aga42A==
X-Received: by 2002:a17:90a:5a4e:: with SMTP id m14mr3022170pji.69.1604396523218;
        Tue, 03 Nov 2020 01:42:03 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id b16sm16419842pfp.195.2020.11.03.01.42.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 01:42:02 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, andrii.nakryiko@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf 2/2] libbpf: fix possible use after free in xsk_socket__delete
Date:   Tue,  3 Nov 2020 10:41:30 +0100
Message-Id: <1604396490-12129-3-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604396490-12129-1-git-send-email-magnus.karlsson@gmail.com>
References: <1604396490-12129-1-git-send-email-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a possible use after free in xsk_socket__delete that will happen
if xsk_put_ctx() frees the ctx. To fix, save the umem reference taken
from the context and just use that instead.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/xsk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 504b7a8..9bc537d 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -892,6 +892,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 {
 	size_t desc_sz = sizeof(struct xdp_desc);
 	struct xdp_mmap_offsets off;
+	struct xsk_umem *umem;
 	struct xsk_ctx *ctx;
 	int err;
 
@@ -899,6 +900,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 		return;
 
 	ctx = xsk->ctx;
+	umem = ctx->umem;
 	if (ctx->prog_fd != -1) {
 		xsk_delete_bpf_maps(xsk);
 		close(ctx->prog_fd);
@@ -918,11 +920,11 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 
 	xsk_put_ctx(ctx);
 
-	ctx->umem->refcount--;
+	umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected
 	 * to it.
 	 */
-	if (xsk->fd != ctx->umem->fd)
+	if (xsk->fd != umem->fd)
 		close(xsk->fd);
 	free(xsk);
 }
-- 
2.7.4

