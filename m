Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AAB2CC34B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389045AbgLBRRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbgLBRRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:17:42 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27DAC0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 09:17:02 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id t18so1501683plo.0
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 09:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UjXRpBRw3xfQMEbeiFtCPfGQzWF20/c/2pXBFUwtoMI=;
        b=NcUGOYCx8sm3NaxvZE+c0jKDUCCICMZLqmazQu0JOk2qRVIKjST4gBnHWZbW117GGT
         F9SnuFtQUD34inGQnFuj9JagitUnwVHi8sNIJFfPv4WclnMmDKh7qKyJkmQ3n/0CaTgz
         9/2kdt775VrgeFspopfPXfmNUG0ZtxiOvZFa4E+zIKL3maFmh76OH0hsDfiBwWrCp7jm
         2Q0yTMSt2/A2AGV51IWWLmsZllSUCMn09FTb1FgTxpxCxpcTZ/r6LVSp1Wne0bJjl1mA
         DSq5ZMy/HI0ecYlKiqaoe8ekRDTHMMzTZF7PQrSb6EMaU13f3kvP6ImutxTe8A2WhGlo
         yKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UjXRpBRw3xfQMEbeiFtCPfGQzWF20/c/2pXBFUwtoMI=;
        b=ZUCFJSHZLMb/GPfJk1csv45VRX267oGL2GuS0tANSWhb02upiLiB29kbvLyWI16KuY
         3ItJ3FpNTbYbmhjTByQMQRaiuEyKhHptEhBO9HnyqM6titRKc6VBB0U7+7R1QHKhBDYt
         xZ+o8UITbVXTLTaQ3bS2zYb2gqB10vdte+IuqGyXoZ+F8PxZQv5dBRnGV/0Nh54nFGef
         5Zvtk+2aWr89Y7y2kTpgSYliU2nNHeo8nmW/AcZk/zbC5J+SnKgKQvTesyAMGoyvMeDu
         87HsZU0srLVl3FMV0t6xrETIpxiUzf/2HLn8+KGjkmOzdraenbEo18UxhqVgL/yIM1pv
         Zdtw==
X-Gm-Message-State: AOAM5301Govjl21J3rAFL3fEJfFKTUGKFWBSppjGQbGIHQTV0zcaBHcp
        6Dmm6iwFGZ6HKq9XpoRULEk=
X-Google-Smtp-Source: ABdhPJwChqyojNP7wEwLqdfcX26oN4QVyeB0dmB4Qpx9MCUksJpu7zf5P7QHQ2j12Z5F5wTeJaKp7w==
X-Received: by 2002:a17:90a:4281:: with SMTP id p1mr810734pjg.87.1606929422307;
        Wed, 02 Dec 2020 09:17:02 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id a17sm307683pga.56.2020.12.02.09.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 09:17:01 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] mptcp: avoid potential infinite loop in mptcp_recvmsg()
Date:   Wed,  2 Dec 2020 09:16:57 -0800
Message-Id: <20201202171657.1185108-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

If a packet is ready in receive queue, and application isssues
a recvmsg()/recvfrom()/recvmmsg() request asking for zero bytes,
we hang in mptcp_recvmsg().

Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 221f7cdd416bdb681968bf1b3ff2ed1b03cea3ce..57213ff60f784fae14c2a96f391ccdec6249c168 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1921,7 +1921,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	len = min_t(size_t, len, INT_MAX);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 
-	for (;;) {
+	while (copied < len) {
 		int bytes_read, old_space;
 
 		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied);
-- 
2.29.2.454.gaff20da3a2-goog

