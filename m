Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388B9495F12
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 13:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380382AbiAUMfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 07:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbiAUMfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 07:35:33 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686E0C061574;
        Fri, 21 Jan 2022 04:35:33 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id r132-20020a1c448a000000b0034e043aaac7so4772436wma.5;
        Fri, 21 Jan 2022 04:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lSQv1WzBfL2CFgqdZY9tvPFMl+7QRXaGc3x2B0zIHGY=;
        b=VlSeYJT3XdXIv1GaC/PRL28nrmUydrMK/t0BrCpDxJRSD3T0/HsKp8h8/EYLK9SqTK
         pA+p+vDilrey2Xn/LSVVyVhrUZBjffi89kCqhzXYo1X0kLlbZpy1PM6h5TjDbMnvMQtD
         Of2tUZ1HYVaEK0fRyp+sIj+BbiBTJWZ8/4xui73oPT+ZU6uJ81mu1MKkl8XIOIHNHLaX
         2JsFE6EfC4SBI1bwf3B82QRPiMQ00TpgS7vTsmXgv/XnGLnTkl3WMuVoIwjh5RCkAAew
         /PjstZHIUzY9rj3CRBqd8mu7/+3TyZRKKUTHPHpchgwxYtXikYnCz+81seRMQIH0GkoM
         ySpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lSQv1WzBfL2CFgqdZY9tvPFMl+7QRXaGc3x2B0zIHGY=;
        b=qi+1O/KiEyFN17YiJ/sOre+K4wzr0Iz74WGTdXSGMyMELwZYB/Ei0Jm1X8dzTYtRAT
         eecamP4uP4ekEroQWaVuiKOBh8QyFBhTi2Bt7AmnSpR9p1e96mCcdJ4kWEJGAjDLl+pW
         FmZuanYoT54lOGLwX1oy8h4jMuzBIf6FWFQEOvOs6Ije+ARztsDm4NG1LHcC7nLgcr8Z
         JLYQSuI8e66ejv7v871LjymaYnka23hBYPAubaLVV/9cSNzcOh83cQDOpGZc2P2jchHI
         hcdfPytk5P3ALk0Bk7vje1MhK6BIoakPoQlQEmpw27xYFaYMxwWdRKAxseqOanjBpCul
         lpjA==
X-Gm-Message-State: AOAM530EyYp0fuxrDI9nFLLe+Z65RXpiNOJG294KGnTLxXzbf30swrOM
        GMzsgpSF0D5XWfO/T+LRCKmwyYa1Vgg/SD/g
X-Google-Smtp-Source: ABdhPJz1/gWjaOFpwcNjOopqE9JvRPisMPSw1YNN0GYcPXrVD33aQGOcjqtq+mVNBDlKvcjGlFGSBQ==
X-Received: by 2002:adf:a141:: with SMTP id r1mr3610094wrr.124.1642768531335;
        Fri, 21 Jan 2022 04:35:31 -0800 (PST)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id 6sm2013638wry.69.2022.01.21.04.35.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jan 2022 04:35:30 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next] selftests: xsk: fix rx_full stats test
Date:   Fri, 21 Jan 2022 13:35:08 +0100
Message-Id: <20220121123508.12759-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix the rx_full stats test so that it correctly reports pass even when
the fill ring is not full of buffers.

Fixes: 872a1184dbf2 ("selftests: xsk: Put the same buffer only once in the fill ring")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 0a5d23da486d..ffa5502ad95e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -906,7 +906,10 @@ static bool rx_stats_are_valid(struct ifobject *ifobject)
 			return true;
 		case STAT_TEST_RX_FULL:
 			xsk_stat = stats.rx_ring_full;
-			expected_stat -= RX_FULL_RXQSIZE;
+			if (ifobject->umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
+				expected_stat = ifobject->umem->num_frames - RX_FULL_RXQSIZE;
+			else
+				expected_stat = XSK_RING_PROD__DEFAULT_NUM_DESCS - RX_FULL_RXQSIZE;
 			break;
 		case STAT_TEST_RX_FILL_EMPTY:
 			xsk_stat = stats.rx_fill_ring_empty_descs;

base-commit: 820e6e227c4053b6b631ae65ef1f65d560cb392b
-- 
2.34.1

