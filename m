Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0C7281423
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 15:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387939AbgJBNgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 09:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgJBNgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 09:36:39 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE5BC0613D0;
        Fri,  2 Oct 2020 06:36:39 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id x16so801320pgj.3;
        Fri, 02 Oct 2020 06:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9abpwhVY5F1y6r9U1G6EegFsxLY2I9VNVQvWHKJ7Pls=;
        b=Zhdkzt9oY6UHJwCSsbAVuPeNe0P9ao6ZY/ZUprw4RaJxMxQ1XqI1o4a6aIl3JOptii
         jkQWJaQMt6DyNGOqpr3gebahqu7SDZjE38KSmSc+6vbVdH0miNxrVs30okS1TD/+WohO
         5k0q5jtI5H7lu/8cvDbaML92qv1nQMQflP62XQlHWS3GxZCiE1YoQGj1775/fdYos/X+
         RXWEC2R1NJsUSg7pDjlJy2L/Cv3da/WEg3yrHQu+ETyJ+Imtx1xX+j8QhSu1dJJZ357Q
         1jd1ZThEWWpPIvv1dIwB0gcqzIysbMccYto4BM+WMmM95EoZsHdtiLIpQbyH6B4CBd5b
         IceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9abpwhVY5F1y6r9U1G6EegFsxLY2I9VNVQvWHKJ7Pls=;
        b=qvT7wUZ+slct1Y2r5zUwRj2LK4LvR+H9/DRWt3Nr2zs6HDR9Mc/aiVR5MSdn2zpNIE
         reImuO+bF5FimR0HysQR+YSQzUXb+QhGsGO4SU/55bVAUm8aRP/Oq6zl+yA4FgGtT8Ft
         2piB0cmciJEZa31yhyLsZtacGHmgh1hCQVJNI9EDqdZnfrt2VwQ4L+SZL+W6z82W516z
         w075YKWJbMEC2CmBrEDW3BhbImDHLHSRuHQ+UxbNwYd+Vh1C7LrVg9ojjL/oRN2NZHvU
         G2qwpAYADwZdKmMie0ZGodAMLpkegeNo7HZGhVtC0TpoMkvmVhy8vRzsRkcBdbTcOrJc
         E7Fw==
X-Gm-Message-State: AOAM5334kRX2THQltlUhis8bNYCQBSqJ7bJZYt0+MQebJd4FAGGoGvE9
        jYexghzyc/7T+ZEoVFpql6M=
X-Google-Smtp-Source: ABdhPJx7HyTAx1Bl7iujSOGyJLOJRS6gYHY1GtqCMlnIdnX7uTEl9hs0a7xbaWXoMP5EXVtP80Ob0A==
X-Received: by 2002:a63:e354:: with SMTP id o20mr2284002pgj.317.1601645799079;
        Fri, 02 Oct 2020 06:36:39 -0700 (PDT)
Received: from VM.ger.corp.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id q65sm1666126pga.88.2020.10.02.06.36.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Oct 2020 06:36:38 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, ciara.loftus@intel.com
Subject: [PATCH bpf-next] libbpf: fix compatibility problem in xsk_socket__create
Date:   Fri,  2 Oct 2020 15:36:27 +0200
Message-Id: <1601645787-16944-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a compatibility problem when the old XDP_SHARED_UMEM mode is used
together with the xsk_socket__create() call. In the old XDP_SHARED_UMEM
mode, only sharing of the same device and queue id was allowed, and in
this mode, the fill ring and completion ring were shared between the
AF_XDP sockets. Therfore, it was perfectly fine to call the
xsk_socket__create() API for each socket and not use the new
xsk_socket__create_shared() API. This behaviour was ruined by the
commit introducing XDP_SHARED_UMEM support between different devices
and/or queue ids. This patch restores the ability to use
xsk_socket__create in these circumstances so that backward
compatibility is not broken.

We also make sure that a user that uses the
xsk_socket__create_shared() api for the first socket in the old
XDP_SHARED_UMEM mode above, gets and error message if the user tries
to feed a fill ring or a completion ring that is not the same as the
ones used for the umem registration. Previously, libbpf would just
have silently ignored the supplied fill and completion rings and just
taken them from the umem. Better to provide an error to the user.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
---
 tools/lib/bpf/xsk.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 30b4ca5..5b61932 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -705,7 +705,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	struct xsk_ctx *ctx;
 	int err, ifindex;
 
-	if (!umem || !xsk_ptr || !(rx || tx) || !fill || !comp)
+	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
 
 	xsk = calloc(1, sizeof(*xsk));
@@ -735,12 +735,24 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 
 	ctx = xsk_get_ctx(umem, ifindex, queue_id);
 	if (!ctx) {
+		if (!fill || !comp) {
+			err = -EFAULT;
+			goto out_socket;
+		}
+
 		ctx = xsk_create_ctx(xsk, umem, ifindex, ifname, queue_id,
 				     fill, comp);
 		if (!ctx) {
 			err = -ENOMEM;
 			goto out_socket;
 		}
+	} else if ((fill && ctx->fill != fill) || (comp && ctx->comp != comp)) {
+		/* If the xsk_socket__create_shared() api is used for the first socket
+		 * registration, then make sure the fill and completion rings supplied
+		 * are the same as the ones used to register the umem. If not, bail out.
+		 */
+		err = -EINVAL;
+		goto out_socket;
 	}
 	xsk->ctx = ctx;
 
-- 
2.7.4

