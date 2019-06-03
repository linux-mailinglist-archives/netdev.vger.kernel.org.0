Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7020330D5
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfFCNTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:19:17 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41118 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfFCNTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:19:16 -0400
Received: by mail-lj1-f196.google.com with SMTP id s21so5520367lji.8
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 06:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bp+nVoB4HtDC82RcKiB+JgTW5jisIiXnKI12mHtf1Uc=;
        b=UUFHSAoofzWitUSdDlbj/1Ipu/QHWdiRLAx/izKKfJiNGJdUSAQAqX5dARkyZJigkT
         /G8X0IIGlQzs5YnWSucUbO+08ibhaeDBk7L4si9uLLd65PSMHMv1miLAtm+JJg6xB7JK
         Oq0KaQpjuTU9zM76qzdrTNG0cPMSEhBbx2Mw8/oZfVnYNZf9eCuSkzgl1rroBqms8d2x
         Y6eKix2ycmG9tH70JMZIv24stXlTY/cUh2d3zMc3vrVi6JJuGzioMAtLS6EeOf1SS6Pu
         ct4KLtIKnn608agsCK6+7990KhthSiL7sCzchCF83LKBL/7osLe9lyWJ+Y5dg3AImT8l
         rGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bp+nVoB4HtDC82RcKiB+JgTW5jisIiXnKI12mHtf1Uc=;
        b=by6jhZ/PBZAL/1ABa+lwhzCMzQzJyZkXgyOwzlH0672HCOHk88i7AhVrTQlaIzhCiY
         /i4Hja/Fdeg40n2JggMpdxDpZmoQwERpFhTuI22o+27HCJaGtFXY+iSYRybLNvvHUsJm
         WN6KMo/yaFwk0A6DdyvSVQO7qwKXY1+Jc7DB91cj6JZd+cDes+00WILB7QbtPXarR8Ny
         oFrtOVlqN4zzPVDHQ0kfxrNNOKo337XgoRGrmMTPKpgsvYI8Y2C0HZmd6NMUoziS1+g0
         O9e0OmVlNDRN8JvzHxlyXyFJY9psFOu63f8OlX0oXgo+xKrvwArLYYU4k9DVybfsc5X7
         b5SA==
X-Gm-Message-State: APjAAAW0bL4G+FCsQFAyubk0DE0wri7Vr4oDyLKICQSzn44tu1UA2Url
        1FgYt0AQmjQpl402L1Ca4tA=
X-Google-Smtp-Source: APXvYqzl4UGy7VjsQAdf6pDOupzzT6kT7apYaeaVa/EBHG2PQojkFtRu2YOxFsFeiShmLVbNIMvz/w==
X-Received: by 2002:a2e:4710:: with SMTP id u16mr14239223lja.41.1559567954943;
        Mon, 03 Jun 2019 06:19:14 -0700 (PDT)
Received: from localhost.localdomain (host-185-93-94-143.ip-point.pl. [185.93.94.143])
        by smtp.gmail.com with ESMTPSA id 20sm577808ljf.21.2019.06.03.06.19.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 03 Jun 2019 06:19:14 -0700 (PDT)
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
X-Google-Original-From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com
Subject: [RFC PATCH bpf-next 1/4] libbpf: fill the AF_XDP fill queue before bind() call
Date:   Mon,  3 Jun 2019 15:19:04 +0200
Message-Id: <20190603131907.13395-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.16.1
In-Reply-To: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's get into the driver via ndo_bpf with command set to XDP_SETUP_UMEM
with fill queue that already contains some available entries that can be
used by Rx driver rings. Things worked in such way on old version of
xdpsock (that lacked libbpf support) and there's no particular reason
for having this preparation done after bind().

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
---
 samples/bpf/xdpsock_user.c | 15 ---------------
 tools/lib/bpf/xsk.c        | 19 ++++++++++++++++++-
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index d08ee1ab7bb4..e9dceb09b6d1 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -296,8 +296,6 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
 	struct xsk_socket_config cfg;
 	struct xsk_socket_info *xsk;
 	int ret;
-	u32 idx;
-	int i;
 
 	xsk = calloc(1, sizeof(*xsk));
 	if (!xsk)
@@ -318,19 +316,6 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
 	if (ret)
 		exit_with_error(-ret);
 
-	ret = xsk_ring_prod__reserve(&xsk->umem->fq,
-				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
-				     &idx);
-	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
-		exit_with_error(-ret);
-	for (i = 0;
-	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
-		     XSK_UMEM__DEFAULT_FRAME_SIZE;
-	     i += XSK_UMEM__DEFAULT_FRAME_SIZE)
-		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) = i;
-	xsk_ring_prod__submit(&xsk->umem->fq,
-			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
-
 	return xsk;
 }
 
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 38667b62f1fe..57dda1389870 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -529,7 +529,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	struct xdp_mmap_offsets off;
 	struct xsk_socket *xsk;
 	socklen_t optlen;
-	int err;
+	int err, i;
+	u32 idx;
 
 	if (!umem || !xsk_ptr || !rx || !tx)
 		return -EFAULT;
@@ -632,6 +633,22 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	}
 	xsk->tx = tx;
 
+	err = xsk_ring_prod__reserve(umem->fill,
+				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
+				     &idx);
+	if (err != XSK_RING_PROD__DEFAULT_NUM_DESCS) {
+		err = -errno;
+		goto out_mmap_tx;
+	}
+
+	for (i = 0;
+	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
+		     XSK_UMEM__DEFAULT_FRAME_SIZE;
+	     i += XSK_UMEM__DEFAULT_FRAME_SIZE)
+		*xsk_ring_prod__fill_addr(umem->fill, idx++) = i;
+	xsk_ring_prod__submit(umem->fill,
+			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
+
 	sxdp.sxdp_family = PF_XDP;
 	sxdp.sxdp_ifindex = xsk->ifindex;
 	sxdp.sxdp_queue_id = xsk->queue_id;
-- 
2.16.1

