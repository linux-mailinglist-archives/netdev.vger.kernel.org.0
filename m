Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85DA3D75BE
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhG0NS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbhG0NSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:17 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CD9C061760;
        Tue, 27 Jul 2021 06:18:16 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q3so15269350wrx.0;
        Tue, 27 Jul 2021 06:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lZnPXa0eEcKFLvwVi4z8DOLXiy35bMAQiZXhSutBkPM=;
        b=NKaSVhcaGLz6qHmdm7lI8ZWYhbipAOAWt1CTfun8JxcqbN21MKN2HUSQ9UEsoLV6Ae
         QDiFn2hgNGuQxHYtxmhCRVWg2ApCAIZB462pxuaq4fCpz96h2Q7HEp1tgt/1/XparCJi
         FCFwOvTKdG6mnQ0wI2fXTig4L+cKKWLG5XywNuSCSy9DlYN43s0AJ+s2uijcjnzrLNXD
         TqVR7c5blasru0n0KE7g26bIUw9CSsMcKkZpQHBfHtE9aGNPAz3rNocnrB5kFqsiZwfu
         8kVSHQIVPy2E/bBQ60nPujIQVKf8QE+sEm2A5N2hTd3dlQKbQXB87Nl/uo1T24pyBF6A
         bwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lZnPXa0eEcKFLvwVi4z8DOLXiy35bMAQiZXhSutBkPM=;
        b=kRSRB9U8jBGQYUIOvsFx0nLVkjBaZAroUxTs5/3w8URUd22BZJ6JYpAGTyDFwr1uHa
         9tlZAcXJrQvB+MPmsMapXlFJMZ6TRldNLeFhHbg+ptCJLhv6Rg18VPbqL0ot/ZxIceqC
         JNQXvE/wBTPe6spsqJKwLCVfVQ2QPsIq0mKM64YHuzxbEIjcpodxYb2USaNMweEsloZu
         nWqKqbL549Z3sw4sFhyj8qyk5HTWaydRv7+iY7DEuGNQOn5Mj9roeGCkcUb9v571kpta
         Jyy3NCF5ffAmzmY9Oz6aiUxVw0o0E3NvntG4AQnDhXo8XaX9mO9x1BRUL2cqQuyL9KOi
         jU0w==
X-Gm-Message-State: AOAM533TlB/rjeXtJSDFGTFOfLqNYvzpMw1xffwFBbJcdQOLNoxMxRE1
        NPKBUhLYPk8DawmvWCK7tGY=
X-Google-Smtp-Source: ABdhPJzzHC9Hf6PPOA8eQiLtQQtwAvhmPvfCnRS0hMDM41ZyKQvcriPh/CzzhrDN5TJwve2l96UK6A==
X-Received: by 2002:adf:efc6:: with SMTP id i6mr24322176wrp.213.1627391895279;
        Tue, 27 Jul 2021 06:18:15 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:14 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 05/17] selftests: xsk: return correct error codes
Date:   Tue, 27 Jul 2021 15:17:41 +0200
Message-Id: <20210727131753.10924-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Return the correct error codes so they can be printed correctly.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 2100ab4e58b7..2ae83b9a1ff4 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -275,7 +275,7 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
 	ret = xsk_umem__create(&umem->umem, buffer, size,
 			       &umem->fq, &umem->cq, &cfg);
 	if (ret)
-		exit_with_error(ret);
+		exit_with_error(-ret);
 
 	umem->buffer = buffer;
 
@@ -289,7 +289,7 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
 
 	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
 	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
-		exit_with_error(ret);
+		exit_with_error(-ret);
 	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = i * XSK_UMEM__DEFAULT_FRAME_SIZE;
 	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
@@ -472,7 +472,7 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			ret = poll(fds, 1, POLL_TMOUT);
 			if (ret < 0)
-				exit_with_error(ret);
+				exit_with_error(-ret);
 		}
 		return;
 	}
@@ -480,11 +480,11 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 	ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
 	while (ret != rcvd) {
 		if (ret < 0)
-			exit_with_error(ret);
+			exit_with_error(-ret);
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			ret = poll(fds, 1, POLL_TMOUT);
 			if (ret < 0)
-				exit_with_error(ret);
+				exit_with_error(-ret);
 		}
 		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
 	}
-- 
2.29.0

