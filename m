Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96F155802
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbfFYTni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:43:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36286 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbfFYTmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:42:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so18027300wrs.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 12:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NZJAZB5vdXR/WpDyZLPJ4DPn0c9D938wugTs5ASTa68=;
        b=YCgwE95siTWIMkFuGxiPLTfcpNRyh8nvZejCJIhLS+rzApzf7Mg54bJHdIR85mb4zc
         kr/3cbL1I4W/m3elY3gDS3qqciSg8rWJa+GC/Tnypr6naIpx09ZJE3zTIvYkj0zUlqDw
         YAdXxoHiXF1vPbrqDTgG8NdV99yiQO34OOCR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NZJAZB5vdXR/WpDyZLPJ4DPn0c9D938wugTs5ASTa68=;
        b=U942D0/lKNwRqum4a80tijaVPHQc1QfS9ExehJfCVbUAu8rvUQ/t5ulP3UHZUSAtMH
         Nao2qbfO+9O16oOF/qrOs6Qe6qcBjL/1tWh9MFmgJm0h0khHPo68UXObU8oWkHfYyGIO
         ZM/2Nqe8OY8JaDb7MAFaB7qbSy18D62SNEM2sjKzY51Msi+7EWSrFh6W0RB8i5XswlEn
         8ibRj9CBltw0boe2nXhjg236AlIUG7WbDYgxRn2aBIhcgjvuNN9lWynjgvIaDcrG8Mvs
         wQe/T1/Zg/ZqFnFXq5L1vmNeixCT1phTKJ4kLOwj/5wRG5+KNiZUYNvWiENsxNUTampC
         bVVg==
X-Gm-Message-State: APjAAAU+/QDO6Dwkeh6Ft+SQuT/TklqgeOAhFt7hxK3THUpLXnY+/F9B
        teleTM8i6V6L6YWDH8QAf1JUzdM/+67GKA==
X-Google-Smtp-Source: APXvYqzkZHCEL5EQpFPRuu/3a/FjcmP7M2c2GZUqCNnvkP2hC06bFFvksfwNk0obOhjie/qywVWfqw==
X-Received: by 2002:adf:fb8d:: with SMTP id a13mr25689557wrr.273.1561491768959;
        Tue, 25 Jun 2019 12:42:48 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedb6.dynamic.kabel-deutschland.de. [95.90.237.182])
        by smtp.gmail.com with ESMTPSA id q193sm84991wme.8.2019.06.25.12.42.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:42:48 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     netdev@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v2 04/10] selftests/bpf: Use bpf_prog_test_run_xattr
Date:   Tue, 25 Jun 2019 21:42:09 +0200
Message-Id: <20190625194215.14927-5-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625194215.14927-1-krzesimir@kinvolk.io>
References: <20190625194215.14927-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_prog_test_run_xattr function gives more options to set up a
test run of a BPF program than the bpf_prog_test_run function.

We will need this extra flexibility to pass ctx data later.

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/testing/selftests/bpf/test_verifier.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 779e30b96ded..db1f0f758f81 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -822,14 +822,20 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
 {
 	__u8 tmp[TEST_DATA_LEN << 2];
 	__u32 size_tmp = sizeof(tmp);
-	uint32_t retval;
 	int err;
 	int saved_errno;
+	struct bpf_prog_test_run_attr attr = {
+		.prog_fd = fd_prog,
+		.repeat = 1,
+		.data_in = data,
+		.data_size_in = size_data,
+		.data_out = tmp,
+		.data_size_out = size_tmp,
+	};
 
 	if (unpriv)
 		set_admin(true);
-	err = bpf_prog_test_run(fd_prog, 1, data, size_data,
-				tmp, &size_tmp, &retval, NULL);
+	err = bpf_prog_test_run_xattr(&attr);
 	saved_errno = errno;
 	if (unpriv)
 		set_admin(false);
@@ -846,9 +852,9 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
 			return err;
 		}
 	}
-	if (retval != expected_val &&
+	if (attr.retval != expected_val &&
 	    expected_val != POINTER_VALUE) {
-		printf("FAIL retval %d != %d ", retval, expected_val);
+		printf("FAIL retval %d != %d ", attr.retval, expected_val);
 		return 1;
 	}
 
-- 
2.20.1

