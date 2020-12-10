Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02062D5FE1
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391093AbgLJPhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391870AbgLJPhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 10:37:38 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD96C0613CF;
        Thu, 10 Dec 2020 07:36:58 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id p6so2948636plo.6;
        Thu, 10 Dec 2020 07:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IX3O9UwkuCo7WhogGijnTIAOODavE5+hGqNB79K6P4w=;
        b=JZ2iIIk2gCeDZ42i1ySKgRv4LYUqlcs+Q9qkHgBoAB3GwueZ+IYJsxPLP2L54y3/OW
         5LpnjEx32ZBBaoYGLTMgL4UDpdok6qB3TC82r0w3NRMFCviU+BNoTaE8NHIlc5cv5rtp
         xpD3AQcuRSfOYDI5PSpIcFCGlQJGdqGy2elmGFzirHAcKaBsGnIfoJXxuLZ26krp7Srw
         I5nfwrGZ4P0R8N4E2RZKbpPPTpQqhLhQOV/90AwbHI/InWJFdYAPRJo6XheKmnJhuAnc
         znYluf1GF9HbsIf6B93E7j9DO62RZP4IqP9ji70rvvtadTWyb2y8jiSmpWJqhImzcjK/
         3+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IX3O9UwkuCo7WhogGijnTIAOODavE5+hGqNB79K6P4w=;
        b=hYjJVxYGWEaFoL3d5hOzMBxdog12liVembPqxYqmuzBIA21dQvqiQ/UWZN9i1Rgeti
         iJK7KGKFnQuKTp/dLLjHZAw5YF7CcS0Ev+dxzdRWpr+weK7kQOw6jjMjGapYSfOxDFtK
         z/A8bNI92DKwcmtHjc8OblY5/1K/N2SUvcXJQ88RoTUqUFj+/saWDDv09PdgWXpYB7Xw
         S5xTE1cqVYkwFAJ9JBEVQuF4G4yolCujAm06XjC2Kl6KM6bnD/ges9B9z/yka8C4eY5k
         a05RZeHVHNZDbcKizfMowmknUlSG31dJ7C0Ot/wivRU1wm8OJbJ+5LyjH4GYs0WBc/rE
         T20w==
X-Gm-Message-State: AOAM531Adr/4YO6ST5d6z0Aj4U+3eq6uwDZF67Fp6aDfQV2boAyvU2ju
        SaKeC9Hl2ds8Nhs1dj+4N5c=
X-Google-Smtp-Source: ABdhPJyifvzciKcBKAjxL1kWBncCPiVpMQRiNQZNGc3BqlnejrOC40yyQ/7gQ63+wDAmxWIWSHcdFA==
X-Received: by 2002:a17:902:8a8a:b029:db:e003:4044 with SMTP id p10-20020a1709028a8ab02900dbe0034044mr2843981plo.19.1607614618434;
        Thu, 10 Dec 2020 07:36:58 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id z9sm6958120pji.48.2020.12.10.07.36.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 07:36:57 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next] samples/bpf: fix possible hang in xdpsock with multiple threads
Date:   Thu, 10 Dec 2020 16:36:45 +0100
Message-Id: <20201210153645.21286-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a possible hang in xdpsock that can occur when using multiple
threads. In this case, one or more of the threads might get stuck in
the while-loop in tx_only after the user has signaled the main thread
to stop execution. In this case, no more Tx packets will be sent, so a
thread might get stuck in the aforementioned while-loop. Fix this by
introducing a test inside the while-loop to check if the benchmark has
been terminated. If so, exit the loop.

Fixes: cd9e72b6f210 ("samples/bpf: xdpsock: Add option to specify batch size")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 samples/bpf/xdpsock_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 568f9815bb1b..813f7eaabf82 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1275,6 +1275,8 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
 				      batch_size) {
 		complete_tx_only(xsk, batch_size);
+		if (benchmark_done)
+			break;
 	}
 
 	for (i = 0; i < batch_size; i++) {

base-commit: 08c6a2f620e427e879d6ec9329143d6fcd810cd8
-- 
2.29.0

