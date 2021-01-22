Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DA23007DB
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbhAVPxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbhAVPso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:48:44 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B775C0617AA;
        Fri, 22 Jan 2021 07:47:37 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id a8so8135975lfi.8;
        Fri, 22 Jan 2021 07:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kgfuj77ygCva6xUycXu58Mip5sGXVnu1WDOsdvd/Pqw=;
        b=oSHVaptuMd6IcnnNeq3M9M4pLKSGE4eJU8zI/LmTiLP02onRTkKmaK7124Oz3GCUMm
         QmbT1gaKxzJGHSN0pSBdBzg6M6UhZqAuSk8Ptodv78wku1J8M8ScGnb93M0IbwEpBLu5
         z7lWPj4Yrn0Y1X0R1Dqh91hNyTwVCAYdv89wCFiN5md5I1Z4PoZG0M2LRy36K+27ezHu
         OtMFr8nXpH9IGvrUfatwv+pSi0tUJQbALxtIrcM/ZWY41mPlxK7VvozD7oyAuM4G1cvX
         cTyLyt4jtb0sdgHybUu3aUXau+96p2ocfg4wS2FG1PF974knuSzzAnYVqouU/KmpH9Ec
         CmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kgfuj77ygCva6xUycXu58Mip5sGXVnu1WDOsdvd/Pqw=;
        b=nw8oKmYIcpuI1/ndAMa0WdhE2cYW7x1qmSbHWM5c/bqyISP3J2zmlD0+eZEuJcSUED
         GV3Zguw7QyiPieYjmermGMWB4wfFBe5G7e+DRZrdmXPFq/L4qVTbqhP4GqN9zwBnnVxo
         +XEKE1Y4Ufd9B4pz+AIh84cqPeca/hV+YLBZDSqBL2/9FBFlgP2OFtaFwcmYznHHplXX
         82UehDp76f4gvLSQUNSwrh2bQFLTqRwI2MZWGluNX1LP0bRr2mJVsXHj1ofizOSMyS2g
         5wGDDc1s+/+3bH1jIkVIdrpd+q00bBL6DBADGMg6dDY3Zv9zjPM4iuwKql6/Ktxt4DKq
         OmvQ==
X-Gm-Message-State: AOAM530w3jq6ls0unC3ePXsHy/syyS5GKbasdW/r4BpIgOw/LRYoR82R
        mTiuBWJGjVBm3Gt1gX2o996HwZrRfYxRvg==
X-Google-Smtp-Source: ABdhPJxidcUwMf6ZeyoOT4kb/KeSF/nzsxbbNNkK/ewqGCoZQumTPImklJ9fxu/TmMfV5YsAstqYwA==
X-Received: by 2002:a05:6512:32ad:: with SMTP id q13mr2405817lfe.83.1611330455589;
        Fri, 22 Jan 2021 07:47:35 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:34 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 04/12] selftests/bpf: remove memory leak
Date:   Fri, 22 Jan 2021 16:47:17 +0100
Message-Id: <20210122154725.22140-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The allocated entry is immediately overwritten by an assignment. Fix
that.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 77d1bda37afa..9f40d310805a 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -728,7 +728,6 @@ static void worker_pkt_validate(void)
 	u32 payloadseqnum = -2;
 
 	while (1) {
-		pkt_node_rx_q = malloc(sizeof(struct pkt));
 		pkt_node_rx_q = TAILQ_LAST(&head, head_s);
 		if (!pkt_node_rx_q)
 			break;
-- 
2.27.0

