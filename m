Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF08A2A4079
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgKCJmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCJmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:42:00 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDF0C0613D1;
        Tue,  3 Nov 2020 01:42:00 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id x13so13693760pfa.9;
        Tue, 03 Nov 2020 01:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RR2ou0XaLONx8HGAyVgzdLv71+3qXys+12Mmi6OmFu0=;
        b=Wb8hatPjgcVMBpdVaygeV1t4mwkRBAy/nPd5NC0gSladxsQH1BeyqQs75a9SUxTgw0
         EkkGkKJRhLSUDAwc7FG8CpX9Y32lhYBLnMlI7V5npOOS3nIeyZNz5mjOV97ZRD034mSA
         zV+e3/jRZlwB6jPshTSP7Q6/+RFktAgwDBAtPg1Kr2Ln3WsPhcIePOaW8W2aNZn8saCP
         MqL6bgM9zCTNAggSJMEcgevvh97MNywBuHM0tyPs52/v4cAASLty6/ez+X4Acymyg2cy
         AZjQqybBKi51zsmPWrJV3BKGOKQs1iZFAc+YsVtIflNtCO0Kpzs54o2D0ZIfE0lLXfS7
         xn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RR2ou0XaLONx8HGAyVgzdLv71+3qXys+12Mmi6OmFu0=;
        b=XBncHvvJxFAgYvk47JBbtgtjWk81voDYP2grsL/nhNldYEUVxOEUw0iRPxAf0APwaW
         ZuEshF56FcHYcE18GsdCvVOeUVAsTj0IUSN95uqT2IxPiK1lZv53hcrtDxKarVmTMt9d
         /vQYf6NVZ9AwEeQ3iBiGNtGmKcqnFxY8IC2gfci5uh00PJ+iqFTPdvbSgge5hSUWtQJR
         0oGk34HsZtXoqakpDeC5Y4wgyPC5EhFhNFG2Yxia8RPBV8d62TJwSPHSJcY//BnJPTlu
         StpfzZwe89Gsk6ansKWQEOwNvNpn8Kh2ZechfZQv4nRazHLT37tu9erdV/W27Ca6gyqa
         do6A==
X-Gm-Message-State: AOAM5332loufsuLLKGE1EU1hxLRYfaRt6ifd5Jx/EYz9Ura5pTTcxS0h
        PpQni2l1tYrZBfPe7G87Yr8=
X-Google-Smtp-Source: ABdhPJzAGZ1TOpZwSC7uniw0OQCgbmEq7guZES25MRaNH7b2Y22dRXhScOq5sCdIP4cUtpP6SBb4+g==
X-Received: by 2002:a17:90b:118b:: with SMTP id gk11mr1809470pjb.178.1604396519760;
        Tue, 03 Nov 2020 01:41:59 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id b16sm16419842pfp.195.2020.11.03.01.41.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 01:41:59 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, andrii.nakryiko@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf 1/2] libbpf: fix null dereference in xsk_socket__delete
Date:   Tue,  3 Nov 2020 10:41:29 +0100
Message-Id: <1604396490-12129-2-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604396490-12129-1-git-send-email-magnus.karlsson@gmail.com>
References: <1604396490-12129-1-git-send-email-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a possible null pointer dereference in xsk_socket__delete that
will occur if a null pointer is fed into the function.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/xsk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index e3c98c0..504b7a8 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -891,13 +891,14 @@ int xsk_umem__delete(struct xsk_umem *umem)
 void xsk_socket__delete(struct xsk_socket *xsk)
 {
 	size_t desc_sz = sizeof(struct xdp_desc);
-	struct xsk_ctx *ctx = xsk->ctx;
 	struct xdp_mmap_offsets off;
+	struct xsk_ctx *ctx;
 	int err;
 
 	if (!xsk)
 		return;
 
+	ctx = xsk->ctx;
 	if (ctx->prog_fd != -1) {
 		xsk_delete_bpf_maps(xsk);
 		close(ctx->prog_fd);
-- 
2.7.4

