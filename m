Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5F03EE9C4
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbhHQJ3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbhHQJ3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:33 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5787FC061796;
        Tue, 17 Aug 2021 02:29:00 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h13so27634387wrp.1;
        Tue, 17 Aug 2021 02:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RrmKLByNzzoypaDx7zqqevtKRSZED5KqWCuj6czuLk4=;
        b=p9TFd3qB1iGq+RZ70QVvlsqTWXWuLoXipD8VVxpX5HaExepFllmTRNvTnI8tjybAgU
         /YjNIaUQEbaa6Cqmm/D+Bkcfuwnmb0sOvoTGUpa7YegJU+j+D4gdA58UwjZ+r7oN/LVV
         fCCW7p6VXsPx+6/T2hdgUjKdtP7hWPunGcM4Y9H/ofdqh7xTbu5cYvenjRxfzqWfUDYr
         f6oR4UhG/sf62ItPb06rmdWy9gy2uz5Gz9fGG4CUB29+4lDUqmaDD70VNUZfqLkges7d
         tt57Mugl72veAvbXnUXToRO3U50g269bS4CpUpZ9NjT+86evtPT2BBNhPFIvn5ur6Wba
         qqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RrmKLByNzzoypaDx7zqqevtKRSZED5KqWCuj6czuLk4=;
        b=Hjpr2ZFhTwiwIW6wzzKc06q+XM00sUYhqPBszQTxj9f2+FK7zyq7o0KfU8Ks3NAmfe
         Jy6MxXo/mfA6glUlUckUf9sUmgXB1wbCnZyez8UgLZzik7CZ6sEfLH3aiCxMkN55aKFA
         ikeCq6pdbbcm46xdzaWaIDayKt+v6a+xtr5UIy5/P4nym9TeF68KyHKvIOf4GrPtetgw
         li3fVt32VrlSxrhU0Zx0GTvJ7Tsl8Vc1ce35y+ACUREjA+7/5pipJBRFK01lhlfGm7Zg
         rUkZSvymvbxIFAdAcwzfLXKV3ganGF4OxVI8em/h2EQf3sYAOOhcpst+tE5mRV9/RksF
         Jr4A==
X-Gm-Message-State: AOAM532HkSjBd8fldP2SYpdfS5FxSsxQnr6pNQZrfHlFM07Jdj7WFq+6
        FpNMwfjei5JMFReO2eCaLVg=
X-Google-Smtp-Source: ABdhPJxjlICyJ1En6Xms6UkdmCUREJtyTAGkxVhrJKEJAwwahVzTrxiz4/10BQoE6oNC2i42HqrpnQ==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr2780537wrx.280.1629192538998;
        Tue, 17 Aug 2021 02:28:58 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.28.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:28:58 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 04/16] selftests: xsk: return correct error codes
Date:   Tue, 17 Aug 2021 11:27:17 +0200
Message-Id: <20210817092729.433-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
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

