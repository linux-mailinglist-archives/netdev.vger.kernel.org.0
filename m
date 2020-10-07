Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4958285E5C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 13:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgJGLmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 07:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgJGLmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 07:42:40 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E51C061755;
        Wed,  7 Oct 2020 04:42:40 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 144so1188411pfb.4;
        Wed, 07 Oct 2020 04:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xAQFlFHy7kWTivT3gKpMF/fe7kfqKwykruPRIM+JP+w=;
        b=OsHUIYjtaje0JVubDFXPk/qDcZ4BUmqedfX1JkvGYUzXo0yKFOMIOpgZUdvqquK2Hs
         Mbux//Fs5gLRjA9dJdrdrMmy++Q1p7y0cCLY8VO4vG87bTc+UDJbd8++boFzncLZxJOs
         /sCwzSuqqSlx/5UmYdMb6Att0cDUvesBJjIlsTPGAdJMU1q3WC6/G0Ddqo8gGcahvvFa
         aU01jStDpTQfAWZIUqQ2lfP2wihabr81FsOMO4o1qfxbqzK+zjXetp0CYrJSmgIYo43a
         +oAN8tzH2V/rRdiKzrQvb66PuOJbSeqIZqawZ8l2sALr1zvd41fBdrRAdjBtyHRMif+m
         OIog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xAQFlFHy7kWTivT3gKpMF/fe7kfqKwykruPRIM+JP+w=;
        b=jZm03tlvzBLdXYUXUDp4tV9c5J4Y1sLTsyA/iztFCBRfFhbISFN30CraSgrQN12eMz
         oaYpb7MXwiopfeEyLk6Q+FgsL2aN+/dOqTXrqfsA0pbvnpcVjb4JmG0WlcFOCiZmBJwM
         tijzbijUWbCZ+VW/0Qh1EfZNip0U8jB8Jn7sYKmEYKwTKayRw6PpZk6mHdggn+ZCobSp
         2m4AqXg+Vzmd1IAY8APheoGdSNrgf/4tE7sqSChAH4fx4j5sf+AyEzLbJ/q1Nwigfg/+
         v4UXczaXQQtvSVxswM+zmtz9jIGfmEWJWhW2wNRjUOubGCVEcq8MWuhqBf7moOWF/xmC
         goAw==
X-Gm-Message-State: AOAM5332IHXzvQhNEAriUL+GbYzhXzkFCsGrCN20BsJ0UK6w9oc8u2iK
        HInH/365yeuDWvbmFouU38k=
X-Google-Smtp-Source: ABdhPJxKR1guD5qhOYd+sluidkIvw5ziHY9+v25uIh2JYZ2bt8OHTxPJvSoq4kl9WFY8R5OwjEe5LQ==
X-Received: by 2002:a65:4885:: with SMTP id n5mr2781224pgs.63.1602070959551;
        Wed, 07 Oct 2020 04:42:39 -0700 (PDT)
Received: from VM.ger.corp.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id x10sm2812259pfc.88.2020.10.07.04.42.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 04:42:38 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, ciara.loftus@intel.com
Subject: [PATCH bpf-next v2] libbpf: fix compatibility problem in xsk_socket__create
Date:   Wed,  7 Oct 2020 13:42:26 +0200
Message-Id: <1602070946-11154-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a compatibility problem when the old XDP_SHARED_UMEM mode is used
together with the xsk_socket__create() call. In the old XDP_SHARED_UMEM
mode, only sharing of the same device and queue id was allowed, and in
this mode, the fill ring and completion ring were shared between the
AF_XDP sockets. Therefore, it was perfectly fine to call the
xsk_socket__create() API for each socket and not use the new
xsk_socket__create_shared() API. This behavior was ruined by the
commit introducing XDP_SHARED_UMEM support between different devices
and/or queue ids. This patch restores the ability to use
xsk_socket__create in these circumstances so that backward
compatibility is not broken.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
v1->v2:
* Removed the check for different fill or completion rings entered in
  xsk_umem__create and xsk_socket__create_shared. The current
  behavior, that the ones entered in xsk_socket__create_shared
  supersedes the ones in xsk_umem__create, should be kept. Will
  document this in a separate patch and show how it can make the
  application code path easier.
---
 tools/lib/bpf/xsk.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 30b4ca5..e3c98c0 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -705,7 +705,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	struct xsk_ctx *ctx;
 	int err, ifindex;
 
-	if (!umem || !xsk_ptr || !(rx || tx) || !fill || !comp)
+	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
 
 	xsk = calloc(1, sizeof(*xsk));
@@ -735,6 +735,11 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 
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
-- 
2.7.4

