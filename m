Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFFD29D0B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391043AbfEXRes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:34:48 -0400
Received: from mail-vs1-f49.google.com ([209.85.217.49]:46314 "EHLO
        mail-vs1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390967AbfEXRer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:34:47 -0400
Received: by mail-vs1-f49.google.com with SMTP id x8so6342137vsx.13
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TDOX2wRR8skvviEKHKy8go+EK8NhixOMGk2axzaJo2g=;
        b=Tx3W3pORcHj2e9RgxnjPYyNxy0c4Hjr1zCOyLKPNWlkweCPg3S9RlhQwweQ5IAX3ZA
         duKvm3tW2FB2ZjYv0bfi4Txh2xG8eM/32tQhLnBnH6Tw7ex6Cz/CHHL+2o0Y2bi7XDKx
         7AMg982e/uAioSiKVMsd3QX8/PgCjRo8lvgARc7EiXA+5A5znFYsfuXcQD6miFQNWVLv
         K4T4XniybDXLLe6Ncpbfh3+S35mUfAhV8tCD+2DnkEXeF/+qhhFuIZbgema7yfyr53h7
         3fgtCInI7d8d6M2vDz1FzB6y9qRvwtVR9i0VQDNViMoz21bn3PgY60tvwTyqVN/vUhtn
         6pJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TDOX2wRR8skvviEKHKy8go+EK8NhixOMGk2axzaJo2g=;
        b=okufkKKhxl3bgoag/lvFhEOYGGjFdVKB53u4xs69vDpyxm7jv5knDJkReJGzsLkUkz
         GVLMIt/JsI46viq+lOq8zYN1t6gBBuw8u8Ssm3kqaewJGB+ygA0iAqdFc8h+bRFeE0mE
         MDgp5kK9kAtQAD+3+7dwmDv3B8yjxcuk+kHF1MJZ0PiEmsA8pTeHuyB3hFyelARuCjzP
         Qf8buJuuiBKr+bP9b8ew7EA8pnn2RStl1h8HGHcZ5BqEMP/VVU6lWTVu6tD1W9p93Apq
         xUWY3unnWU+KKSfgdgwrxagSq+bM6u8FRX4OSSPFaBLrhajDSOaXQRJq8eqyW6sm4zlN
         iRaw==
X-Gm-Message-State: APjAAAVhkz6p3X7EPyaERUuWCut+V8goxJ5FiGA5SISAIn2APnaLw/tI
        ON4BR5A+3ZHxRolRs7/rPwO6eB+5M0o=
X-Google-Smtp-Source: APXvYqzCp4AdNu+A+NxksVHQhZZSyoBtQcIKkBDJ0LFgEb0F29OgSEm2GS5asCiEOOpMW4WHLupIGg==
X-Received: by 2002:a67:ee12:: with SMTP id f18mr39253693vsp.158.1558719286659;
        Fri, 24 May 2019 10:34:46 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n23sm2025647vsj.27.2019.05.24.10.34.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:34:46 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, john.fastabend@gmail.com, vakul.garg@nxp.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 2/4] selftests/tls: test for lowat overshoot with multiple records
Date:   Fri, 24 May 2019 10:34:31 -0700
Message-Id: <20190524173433.9196-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190524173433.9196-1-jakub.kicinski@netronome.com>
References: <20190524173433.9196-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set SO_RCVLOWAT and test it gets respected when gathering
data from multiple records.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 tools/testing/selftests/net/tls.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 47ddfc154036..01efbcd2258c 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -575,6 +575,25 @@ TEST_F(tls, recv_peek_large_buf_mult_recs)
 	EXPECT_EQ(memcmp(test_str, buf, len), 0);
 }
 
+TEST_F(tls, recv_lowat)
+{
+	char send_mem[10] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
+	char recv_mem[20];
+	int lowat = 8;
+
+	EXPECT_EQ(send(self->fd, send_mem, 10, 0), 10);
+	EXPECT_EQ(send(self->fd, send_mem, 5, 0), 5);
+
+	memset(recv_mem, 0, 20);
+	EXPECT_EQ(setsockopt(self->cfd, SOL_SOCKET, SO_RCVLOWAT,
+			     &lowat, sizeof(lowat)), 0);
+	EXPECT_EQ(recv(self->cfd, recv_mem, 1, MSG_WAITALL), 1);
+	EXPECT_EQ(recv(self->cfd, recv_mem + 1, 6, MSG_WAITALL), 6);
+	EXPECT_EQ(recv(self->cfd, recv_mem + 7, 10, 0), 8);
+
+	EXPECT_EQ(memcmp(send_mem, recv_mem, 10), 0);
+	EXPECT_EQ(memcmp(send_mem, recv_mem + 10, 5), 0);
+}
 
 TEST_F(tls, pollin)
 {
-- 
2.21.0

