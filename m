Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E75E29D0C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391148AbfEXRew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:34:52 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:46952 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391077AbfEXRev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:34:51 -0400
Received: by mail-vk1-f195.google.com with SMTP id g194so2351077vke.13
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hm0Op7YQmUxQB6TZ0CmjsjhSQo40VaCAAfSJQmm5pUE=;
        b=R+NOSr3Qk/IaPzDlDLLRkeLz7v5y3/QsnujDnIqdtpIolj26ERNooaCSzaOHnYAWNh
         ZEA/KGzFduOxlFj1LZmM5ktZ6UsGIbRMlWNI2rHU2PFESon1z9h/neaFaZSpBOaCfLuR
         PMfXo1SgB+vf4gW7z+5YoaVZkNasTu4M1eC5/blcLFmwpFIzENaD4AnG0ATWzE/O1xyt
         m1E+sS7kKC1Nm0Rx4UqbGZ20mWhMGMNnJ/Z+DcokXBuSCOaMFaJ/AVNhQXlmGhrLU+Zo
         LP8C15hEkH6BT8/6yBy6IlDNUAz4wvTQDnf6zvVxwgwfoKmWqPpRUFxgGsubSW5lScKL
         m7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hm0Op7YQmUxQB6TZ0CmjsjhSQo40VaCAAfSJQmm5pUE=;
        b=teOUoi8kNOd5+aKqYbir3KoilNxz2CYwKm3XepUuzoqQZ+liVaZfl1PxowPmweh8Hs
         IJt0UJLhoCp/GPw0wIyytt/dNuF2kQF+BSWvfmACKYM7AUHeoaUCtODuEKTkMhSWmP76
         7STuYM+NanCR4BTocPHzJtJAXBRJPfm3/IGsH7vOrTsyhzwSvMCRd3o19t8JZ4kAUJ5u
         KcKiVPqZTrBpwBmI7BJZEgdLoRxbEetHmhoQMYPsGzal7ZgWSPrJI/XdyzzSGXGJKJbg
         /N6jRffwEMyGD3VB8ItFbt7HlDmmvm6AXDPymC/yEG7S8lfmErkkf8Sqm3lrZ9hCpy/N
         rnJA==
X-Gm-Message-State: APjAAAUdspqL7RzRlZ8qdmfoiNqSy1KYyTM512XQ7cxu0T0WdDWB14tT
        rJoWyf4XQPi3Q6746O87cfMXBA==
X-Google-Smtp-Source: APXvYqxcV3n94r3S1D0D8Mhcz9NgudkA01iiH9i9KFKOzR/gcYEGaxnZWe7s3VY+3sxbUvQwIASS0g==
X-Received: by 2002:a1f:32d2:: with SMTP id y201mr6390983vky.37.1558719290399;
        Fri, 24 May 2019 10:34:50 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n23sm2025647vsj.27.2019.05.24.10.34.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:34:49 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, john.fastabend@gmail.com, vakul.garg@nxp.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 4/4] selftests/tls: add test for sleeping even though there is data
Date:   Fri, 24 May 2019 10:34:33 -0700
Message-Id: <20190524173433.9196-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190524173433.9196-1-jakub.kicinski@netronome.com>
References: <20190524173433.9196-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test which sends 15 bytes of data, and then tries
to read 10 byes twice.  Previously the second read would
sleep indifinitely, since the record was already decrypted
and there is only 5 bytes left, not full 10.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 tools/testing/selftests/net/tls.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 01efbcd2258c..278c86134556 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -442,6 +442,21 @@ TEST_F(tls, multiple_send_single_recv)
 	EXPECT_EQ(memcmp(send_mem, recv_mem + send_len, send_len), 0);
 }
 
+TEST_F(tls, single_send_multiple_recv_non_align)
+{
+	const unsigned int total_len = 15;
+	const unsigned int recv_len = 10;
+	char recv_mem[recv_len * 2];
+	char send_mem[total_len];
+
+	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
+	memset(recv_mem, 0, total_len);
+
+	EXPECT_EQ(recv(self->cfd, recv_mem, recv_len, 0), recv_len);
+	EXPECT_EQ(recv(self->cfd, recv_mem + recv_len, recv_len, 0), 5);
+	EXPECT_EQ(memcmp(send_mem, recv_mem, total_len), 0);
+}
+
 TEST_F(tls, recv_partial)
 {
 	char const *test_str = "test_read_partial";
-- 
2.21.0

