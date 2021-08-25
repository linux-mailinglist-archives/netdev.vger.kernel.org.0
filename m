Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FC33F71E0
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbhHYJis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239742AbhHYJio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:44 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CECC0613A3;
        Wed, 25 Aug 2021 02:37:58 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z4so19775928wrr.6;
        Wed, 25 Aug 2021 02:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RrmKLByNzzoypaDx7zqqevtKRSZED5KqWCuj6czuLk4=;
        b=N9RGDrZic02uNWM2Y61zZb+XdjGVW+o0TnFLr8IPAFlvQjv1Rt9Btdjz3A0IdikWXq
         zauOuo2d1DUf8p3sC1QOL5slCw1lMTsouqh1M8gCuBDTdza/BerbcjXN/P6MJUA0kWjb
         WLe2YdUetyABWZD2XhGPvgUfmIoOWDk5U0xXl//IfgnusCasDn+tzA9Xi3jZWxRzSwEu
         sNoYiSdAQHusIXxy82Y9mLZoopGRkii0vXnYM3zOCRYCf5ERirhyxbAhEjl34024uewC
         jip63LXWfimSiMWZVVUIHgbhsg+XMoi3g8fl5RUC24hI6Wi3WMpColsc+MG27kIJpBPB
         /iVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RrmKLByNzzoypaDx7zqqevtKRSZED5KqWCuj6czuLk4=;
        b=ZYwVukU5oytU0wHIiS0Z7ZEZDaLmW+G4T1ix8dwolU+DNaCyOylrD2/8HH1DMgB+PA
         u0lNzzRXP0Xc0GlNgCfnQ8tu1bxwllGUNQXti4wPCE7E/vG8XNlHU+ey2kt1mBoiHF9b
         sKghkSjrTHw4zukHQgJhpzui6gUIOXmpqzDDtUZP5p33AGJ5SRB4iKWtumZuDXU1025Y
         1xFgzmUAsClvBmcm8ZGppJsvHnaLiYHpnDsXO9hRi7mxYlVz7XnuXDjRYKTlHYLDori/
         6aCOF3RVGQzgfAnvP0PpUMiGOs7b5H4+KOYhfxgScZGCpk9yKx1p+tS6Y1C4WvsinuPw
         JR2A==
X-Gm-Message-State: AOAM530diu484WCo/fTHaY9xOBUoaD9P3TqKlpMThKEvbhkfaP/F3XG8
        eY3eMJI6MU0Z3JLca+6jSP8=
X-Google-Smtp-Source: ABdhPJxMG7jBQvYCLpt7AZitWshurWkoBjWCO9ZBFvTYbg9waphqKQqVLivlyL8ofyhZfpyoT5Ok3g==
X-Received: by 2002:adf:c3c3:: with SMTP id d3mr24110219wrg.373.1629884277482;
        Wed, 25 Aug 2021 02:37:57 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.37.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:37:57 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 04/16] selftests: xsk: return correct error codes
Date:   Wed, 25 Aug 2021 11:37:10 +0200
Message-Id: <20210825093722.10219-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
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
index 4d8ee636fc24..f221bc5dae17 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -270,7 +270,7 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
 	ret = xsk_umem__create(&umem->umem, buffer, size,
 			       &umem->fq, &umem->cq, &cfg);
 	if (ret)
-		exit_with_error(ret);
+		exit_with_error(-ret);
 
 	umem->buffer = buffer;
 
@@ -284,7 +284,7 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
 
 	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
 	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
-		exit_with_error(ret);
+		exit_with_error(-ret);
 	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = i * XSK_UMEM__DEFAULT_FRAME_SIZE;
 	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
@@ -467,7 +467,7 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			ret = poll(fds, 1, POLL_TMOUT);
 			if (ret < 0)
-				exit_with_error(ret);
+				exit_with_error(-ret);
 		}
 		return;
 	}
@@ -475,11 +475,11 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
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

