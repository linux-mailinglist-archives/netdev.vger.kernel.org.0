Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB36610B751
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfK0USJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:18:09 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44131 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfK0USI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:18:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id g3so25845753ljl.11
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mr+wnQAJZuMupw7Gr/YQA5l115kxrbvQDbVlCnDPrUA=;
        b=VpKoCPX1r2L21paGlEGal13TRhMIrqGJvTRsqnv5Hgq+pTJxYVteUMQZjUSDcnDApg
         mMxz7cS6WXWph2qt7m1KiojbOA8b6qVtgSeU2BxnNQht9lPgpNwnuAyL9Y4rFAar2XZQ
         QFCn7FNA+82rXBktBm+DOPJ3YYW4LjlU2qHcjd7uU1vgQ1aPy3GoHCwCFr7RnW0D2qZx
         hTkpp1MTd0PKYqUlmikNdupOr4tlYyE/lSXqTUIChEV9PlU3ycvB24hFp92ZXv4mi39u
         9ll+3Wh3vK932jtus7N1iA+ueAjR8sR0727ai137RQu7MiruiAt7Q8lH0N+qP9EmJVXJ
         6C5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mr+wnQAJZuMupw7Gr/YQA5l115kxrbvQDbVlCnDPrUA=;
        b=lZbbBfkvdPNoHT1vunfTkG9oabHiJCpFeOJNTeOfXfJGS+5iWSOi4nwOBL6n83Da8X
         8pseKlb7v3U0XSyOwEaSYGiFhHFu0CpbTzmJsWQduYZ3RP9LVgFWBCk55H8dNibTk26g
         shj6kyV0xYG3czwN6PhThwIafdgzQVYCToUDTvZDn08mFTggsHhT8zjRMcgvOapy1v78
         +C3t+dce4oCQLZuA9BDNuv3OioqhH9iYMDU8pIYUhKlq4A7/tXlbQxwFDy2YUTUStVgJ
         G+z3RN5Jm4wbU60j1AbDs2CQbV9VrD0CbG18GpwKcCJYUFTSF2TW9N5dHFGLTzbM7Hnd
         TptQ==
X-Gm-Message-State: APjAAAV02gSEX5ZtVqPeRSTMsGm81L4SHfEUBN1MU/AAz82DXML84np9
        jkRqxx2a9JSIjIYn1vSFx9PClXebVlk=
X-Google-Smtp-Source: APXvYqzkDrMChSRN0wPbY+WN8pd7Z3x7ZqNWmuc3RqQkOcv/roXo6L8yz+FhHttETC0sJHIIv/pDug==
X-Received: by 2002:a2e:580c:: with SMTP id m12mr15790344ljb.150.1574885886322;
        Wed, 27 Nov 2019 12:18:06 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm7759739lji.71.2019.11.27.12.18.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 12:18:05 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 4/8] selftests/tls: add a test for fragmented messages
Date:   Wed, 27 Nov 2019 12:16:42 -0800
Message-Id: <20191127201646.25455-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127201646.25455-1-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a sendmsg test with very fragmented messages. This should
fill up sk_msg and test the boundary conditions.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 tools/testing/selftests/net/tls.c | 60 +++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 1c8f194d6556..46abcae47dee 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -268,6 +268,38 @@ TEST_F(tls, sendmsg_single)
 	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
 }
 
+#define MAX_FRAGS	64
+#define SEND_LEN	13
+TEST_F(tls, sendmsg_fragmented)
+{
+	char const *test_str = "test_sendmsg";
+	char buf[SEND_LEN * MAX_FRAGS];
+	struct iovec vec[MAX_FRAGS];
+	struct msghdr msg;
+	int i, frags;
+
+	for (frags = 1; frags <= MAX_FRAGS; frags++) {
+		for (i = 0; i < frags; i++) {
+			vec[i].iov_base = (char *)test_str;
+			vec[i].iov_len = SEND_LEN;
+		}
+
+		memset(&msg, 0, sizeof(struct msghdr));
+		msg.msg_iov = vec;
+		msg.msg_iovlen = frags;
+
+		EXPECT_EQ(sendmsg(self->fd, &msg, 0), SEND_LEN * frags);
+		EXPECT_EQ(recv(self->cfd, buf, SEND_LEN * frags, MSG_WAITALL),
+			  SEND_LEN * frags);
+
+		for (i = 0; i < frags; i++)
+			EXPECT_EQ(memcmp(buf + SEND_LEN * i,
+					 test_str, SEND_LEN), 0);
+	}
+}
+#undef MAX_FRAGS
+#undef SEND_LEN
+
 TEST_F(tls, sendmsg_large)
 {
 	void *mem = malloc(16384);
@@ -694,6 +726,34 @@ TEST_F(tls, recv_lowat)
 	EXPECT_EQ(memcmp(send_mem, recv_mem + 10, 5), 0);
 }
 
+TEST_F(tls, recv_rcvbuf)
+{
+	char send_mem[4096];
+	char recv_mem[4096];
+	int rcv_buf = 1024;
+
+	memset(send_mem, 0x1c, sizeof(send_mem));
+
+	EXPECT_EQ(setsockopt(self->cfd, SOL_SOCKET, SO_RCVBUF,
+			     &rcv_buf, sizeof(rcv_buf)), 0);
+
+	EXPECT_EQ(send(self->fd, send_mem, 512, 0), 512);
+	memset(recv_mem, 0, sizeof(recv_mem));
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), 512);
+	EXPECT_EQ(memcmp(send_mem, recv_mem, 512), 0);
+
+	if (self->notls)
+		return;
+
+	EXPECT_EQ(send(self->fd, send_mem, 4096, 0), 4096);
+	memset(recv_mem, 0, sizeof(recv_mem));
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), -1);
+	EXPECT_EQ(errno, EMSGSIZE);
+
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), -1);
+	EXPECT_EQ(errno, EMSGSIZE);
+}
+
 TEST_F(tls, bidir)
 {
 	char const *test_str = "test_read";
-- 
2.23.0

