Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8EC2D6206
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391214AbgLJQf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391783AbgLJQfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 11:35:07 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1284C0613CF;
        Thu, 10 Dec 2020 08:34:26 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id t18so3052519plo.0;
        Thu, 10 Dec 2020 08:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3rJuk8usISu/Y/TfNrKaojt28xWpJIRVht3oZIPIOc=;
        b=WHa9FIQ42zsQnabmToprjm4WWyRFiJDTiWwZ++h2YEZ1wC9uKLbjtZ0Wy2NtcDbDNS
         cheRjMnl5QHLUY6AEoHCWm8TZHah0aAWLH8DYALXImu6QbwcRaZnIwxqWd23oW4mxIH/
         3XjtuYwO9w0atIVQ+WBO4i+5IquAsj6pMiXJFusUl7rE6T78r/serM8mxh0sGfk9H8B7
         E61cmk/av48vDlW8QM+PRSIEOT8PJKCcGXS6z+h3A88lobLMOM/HdJjj7ALvE1fbSSRB
         1E7KQPsq0+DCTXdkFGLEmCNeCWn+jDuartVaKJp5se84OkiEdmx/iKaCkSKtKNTq2Tx5
         80kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3rJuk8usISu/Y/TfNrKaojt28xWpJIRVht3oZIPIOc=;
        b=TXeDa+2LLxfIK861pFjC2hQNP7+INaBcxDrSPaNN+dhVKCOXlONPLr9EgTNapzeC+b
         vX3PwqfKn3484xYjjS0/AlcPDELUY/8rJVeYDk2HXo8eNFR4B4byyJNQ4EphCDo6Ib/6
         Lhvd2bHPx+5E9Uw0fk4+6Mcnq39ry3JNBlXoTJuEnwVCU6ZXJBlRZm0P/QR0qK6vIId4
         fLYbAa2LFHGEixTlUMGOz5mSr9n2Xn0ok8qpZ9KMdLQ2en6nVCuuVE6xDxeqmMvqma/I
         1tz+dhqqmJ0hs+n8kWjmuW7IKaUwyMy4LM6twQIWf6XXlsXvpqWT1BHdAsFYu++Lcq1O
         2aPw==
X-Gm-Message-State: AOAM532phgrRmD8Ty6Fpnst3aZDNtFpJ0tFzY5mvM7gc7e0Uzr0FvBbP
        wwkaeTMuHpkdInXCrhkXTMLT+u9YoVB/ylDP5Cw=
X-Google-Smtp-Source: ABdhPJwEiA7Gcv3q1xsSLc/hCjWIwYxuTQYsM8JK4r/EKSReRYegxGJLqtEkvKhDNl9jg+Gq0N2jSg==
X-Received: by 2002:a17:902:aa8b:b029:da:ef22:8675 with SMTP id d11-20020a170902aa8bb02900daef228675mr7191864plr.15.1607618066438;
        Thu, 10 Dec 2020 08:34:26 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id 14sm6775279pjm.21.2020.12.10.08.34.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 08:34:25 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next v2] samples/bpf: fix possible hang in xdpsock with multiple threads
Date:   Thu, 10 Dec 2020 17:34:07 +0100
Message-Id: <20201210163407.22066-1-magnus.karlsson@gmail.com>
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
been terminated. If so, return from the function.

Fixes: cd9e72b6f210 ("samples/bpf: xdpsock: Add option to specify batch size")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
v1->v2:
* Changed break to return

 samples/bpf/xdpsock_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 568f9815bb1b..db0cb73513a5 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1275,6 +1275,8 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
 				      batch_size) {
 		complete_tx_only(xsk, batch_size);
+		if (benchmark_done)
+			return;
 	}

 	for (i = 0; i < batch_size; i++) {

base-commit: 08c6a2f620e427e879d6ec9329143d6fcd810cd8
--
2.29.0
