Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0A65FE42
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfGDVvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:51:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34656 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfGDVvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:51:01 -0400
Received: by mail-qt1-f196.google.com with SMTP id k10so1675243qtq.1
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MTaW+lneOwrfeQUjieT5VA6MLG6XGeAqlaz+nMyhVlY=;
        b=QkO8JAVIiLCm3HGcqbSEMC/Tf4Q8syu1AOdLd9H0Q8uPWhBkSETfGHMS+1P/i1BaVN
         7LrHnWSMLJeIVyYn5ZOYispqySqEd5TrZc6br+scLrodjE7Ey1OJ5RQcuyqof90thW1L
         xNFeaLlhGrhPRhbp3+NNOYSvdjcQYqOAj5gfPXcvWm8MMet1MLXy2OHrigsVR01MANZ1
         Y6bgz14C25YIcOJgl4nrWcoJIODbPa3sILL5JT3tMF/2MRhryGZgNAhBnxRTDsza0RXB
         t32SIcfvOPix2fuqpHRv0C01hOVfsxzuvVYHJqw/YnVJl2/klG1C4AF/CdcGQ2N5v9aJ
         zyWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MTaW+lneOwrfeQUjieT5VA6MLG6XGeAqlaz+nMyhVlY=;
        b=tLOiqqWv6yqewwhX1a/bQrGUKZmmPUvahy5MdNYT9uaMq/yKwwBxI+22Apqs3ciknp
         nHil4a969gQDVyOXbTAHY+ZyCVUbSNisBW/LpUii23pO2J7+UFPQ5XoYPJ7FFwdQKkAA
         yjzYPlBIKK86KlbUkI8k3nSH1yrIS31V9UzqAFe2iCA/DxbNdyez2AWvbTSloDrXRC9l
         v1MVbNSmwCkq4lxT/FWcVPI/vm8/rPoNADcKYVy1X2sBA7FaAiC2T4EdmuScczt9enaw
         VdlEmFrGo4LhQ/YOihVFs9KA078K46GfbTkifSEvZzuMqtbwJiyzUqV9HpD1jivGJc2t
         2VtQ==
X-Gm-Message-State: APjAAAU6nrOMxGZvBm7XYpnPynXZ51a93aR/1H0SrEWbfPEmar0r1xx9
        u4b+42nN3zCI0gbWFICE+qgyug==
X-Google-Smtp-Source: APXvYqxPhZeBZcqE39jvZbC8dZXqrrlXHAnbai3aLg1pot5h+XGtJng5QjpP3cVlcNs+5FTDSoB3mg==
X-Received: by 2002:a0c:c94d:: with SMTP id v13mr379616qvj.211.1562277060565;
        Thu, 04 Jul 2019 14:51:00 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t2sm3542329qth.33.2019.07.04.14.50.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 14:51:00 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 2/2] selftests/tls: add test for poll() with data in TLS ULP
Date:   Thu,  4 Jul 2019 14:50:37 -0700
Message-Id: <20190704215037.6008-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704215037.6008-1-jakub.kicinski@netronome.com>
References: <20190704215037.6008-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test which checks if leftover record data in TLS
layer correctly wakes up poll().

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 tools/testing/selftests/net/tls.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 278c86134556..090fff9dbc48 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -644,6 +644,32 @@ TEST_F(tls, poll_wait)
 	EXPECT_EQ(recv(self->cfd, recv_mem, send_len, MSG_WAITALL), send_len);
 }
 
+TEST_F(tls, poll_wait_split)
+{
+	struct pollfd fd = { 0, 0, 0 };
+	char send_mem[20] = {};
+	char recv_mem[15];
+
+	fd.fd = self->cfd;
+	fd.events = POLLIN;
+	/* Send 20 bytes */
+	EXPECT_EQ(send(self->fd, send_mem, sizeof(send_mem), 0),
+		  sizeof(send_mem));
+	/* Poll with inf. timeout */
+	EXPECT_EQ(poll(&fd, 1, -1), 1);
+	EXPECT_EQ(fd.revents & POLLIN, 1);
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), MSG_WAITALL),
+		  sizeof(recv_mem));
+
+	/* Now the remaining 5 bytes of record data are in TLS ULP */
+	fd.fd = self->cfd;
+	fd.events = POLLIN;
+	EXPECT_EQ(poll(&fd, 1, -1), 1);
+	EXPECT_EQ(fd.revents & POLLIN, 1);
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0),
+		  sizeof(send_mem) - sizeof(recv_mem));
+}
+
 TEST_F(tls, blocking)
 {
 	size_t data = 100000;
-- 
2.21.0

