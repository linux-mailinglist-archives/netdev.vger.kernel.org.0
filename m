Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D190A62640
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389724AbfGHQb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:31:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33943 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389168AbfGHQbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:31:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so401038wmd.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PA6jkJnM1L4hkSlGgnQo22GP2iGtLRU/PNmMpvPMBgI=;
        b=LcCICdsn6TvVwfZTSN6FeDsew5y77UahVnYnI7ObUeF5duixZM79FFREJ2kZ9sE+yV
         Eut5p0WpnIoCUxlOVy0lcgM5Z/Gh7JFczGvya5r5AN+3ABuo2UZMFLo2EXqTRFwxxJam
         AjIlOeNvSEybpjsm/cxmkElaZHhwl16GnujbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PA6jkJnM1L4hkSlGgnQo22GP2iGtLRU/PNmMpvPMBgI=;
        b=om/FXi5qXWQ42+fIcn257EWduzSX93SdSdd0tzif0hQBzWAi/mZiXykDklFCPr4cOa
         B2no6IEuA4LrWWv8/+wEo4Gd0G/+dzcnbpVeEvtf4PZd9S2v/vJ8kNd6HlpEAUbJJ2Zz
         KCr42NaG0XzwgTwa9qsBOhzRWAEzFVLL+Adfkk3FdHTqdiuUjIvccnFsXIvwwDRktyOd
         q7zAMRJUST0aqz9tZxGepyql+6iewJmw/CrXxmdhNNfd4OMXovrChsjQ/V1Xbnm9KUQT
         NaVNmbwa3OHqYGf1+mkiOJberZo8nO5xv4Gh+dutFKqv0qPyNBG6KLkPd3XW7X54f/g2
         kthQ==
X-Gm-Message-State: APjAAAVZp2VsAWPkdx6ODj3uYmGirCOuemYxlkCW9MFKOAAO7S+iNgFR
        ZlPAVRq1cdDGOkVIvRElwMOFTA==
X-Google-Smtp-Source: APXvYqzpsZtKBLIhoRGPKcTNBI7QH4tlhmTo6HYO5+fydKQ1czfQmJjn7PwyvaUNOoxcwlKb5PvfdQ==
X-Received: by 2002:a1c:cc0d:: with SMTP id h13mr17034092wmb.119.1562603512663;
        Mon, 08 Jul 2019 09:31:52 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedbe.dynamic.kabel-deutschland.de. [95.90.237.190])
        by smtp.gmail.com with ESMTPSA id e6sm18255086wrw.23.2019.07.08.09.31.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:31:52 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     linux-kernel@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v3 05/12] selftests/bpf: Allow passing more information to BPF prog test run
Date:   Mon,  8 Jul 2019 18:31:14 +0200
Message-Id: <20190708163121.18477-6-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190708163121.18477-1-krzesimir@kinvolk.io>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test case can now specify a custom length of the data member,
context data and its length, which will be passed to
bpf_prog_test_run_xattr. For backward compatilibity, if the data
length is 0 (which is what will happen when the field is left
unspecified in the designated initializer of a struct), then the
length passed to the bpf_prog_test_run_xattr is TEST_DATA_LEN.

Also for backward compatilibity, if context data length is 0, NULL is
passed as a context to bpf_prog_test_run_xattr. This is to avoid
breaking other tests, where context data being NULL and context data
length being 0 is handled differently from the case where context data
is not NULL and context data length is 0.

Custom lengths still can't be greater than hardcoded 64 bytes for data
and 192 for context data.

192 for context data was picked to allow passing struct
bpf_perf_event_data as a context for perf event programs. The struct
is quite large, because it contains struct pt_regs.

Test runs for perf event programs will not allow the copying the data
back to data_out buffer, so they require data_out_size to be zero and
data_out to be NULL. Since test_verifier hardcodes it, make it
possible to override the size. Overriding the size to zero will cause
the buffer to be NULL.

Changes since v2:
- Allow overriding the data out size and buffer.

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/testing/selftests/bpf/test_verifier.c | 105 +++++++++++++++++---
 1 file changed, 93 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 1640ba9f12c1..6f124cc4ee34 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -54,6 +54,7 @@
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
+#define TEST_CTX_LEN	192
 
 #define F_NEEDS_EFFICIENT_UNALIGNED_ACCESS	(1 << 0)
 #define F_LOAD_WITH_STRICT_ALIGNMENT		(1 << 1)
@@ -96,7 +97,12 @@ struct bpf_test {
 	enum bpf_prog_type prog_type;
 	uint8_t flags;
 	__u8 data[TEST_DATA_LEN];
+	__u32 data_len;
+	__u8 ctx[TEST_CTX_LEN];
+	__u32 ctx_len;
 	void (*fill_helper)(struct bpf_test *self);
+	bool override_data_out_len;
+	__u32 overridden_data_out_len;
 	uint8_t runs;
 	struct {
 		uint32_t retval, retval_unpriv;
@@ -104,6 +110,9 @@ struct bpf_test {
 			__u8 data[TEST_DATA_LEN];
 			__u64 data64[TEST_DATA_LEN / 8];
 		};
+		__u32 data_len;
+		__u8 ctx[TEST_CTX_LEN];
+		__u32 ctx_len;
 	} retvals[MAX_TEST_RUNS];
 };
 
@@ -818,21 +827,35 @@ static int set_admin(bool admin)
 }
 
 static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
-			    void *data, size_t size_data)
+			    void *data, size_t size_data, void *ctx,
+			    size_t size_ctx, u32 *overridden_data_out_size)
 {
-	__u8 tmp[TEST_DATA_LEN << 2];
-	__u32 size_tmp = sizeof(tmp);
-	int saved_errno;
-	int err;
 	struct bpf_prog_test_run_attr attr = {
 		.prog_fd = fd_prog,
 		.repeat = 1,
 		.data_in = data,
 		.data_size_in = size_data,
-		.data_out = tmp,
-		.data_size_out = size_tmp,
+		.ctx_in = ctx,
+		.ctx_size_in = size_ctx,
 	};
+	__u8 tmp[TEST_DATA_LEN << 2];
+	__u32 size_tmp = sizeof(tmp);
+	__u32 size_buf = size_tmp;
+	__u8 *buf = tmp;
+	int saved_errno;
+	int err;
 
+	if (overridden_data_out_size)
+		size_buf = *overridden_data_out_size;
+	if (size_buf > size_tmp) {
+		printf("FAIL: out data size (%d) greater than a buffer size (%d) ",
+		       size_buf, size_tmp);
+		return -EINVAL;
+	}
+	if (!size_buf)
+		buf = NULL;
+	attr.data_size_out = size_buf;
+	attr.data_out = buf;
 	if (unpriv)
 		set_admin(true);
 	err = bpf_prog_test_run_xattr(&attr);
@@ -956,13 +979,45 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	if (!alignment_prevented_execution && fd_prog >= 0) {
 		uint32_t expected_val;
 		int i;
+		__u32 size_data;
+		__u32 size_ctx;
+		bool bad_size;
+		void *ctx;
+		__u32 *overridden_data_out_size;
 
 		if (!test->runs) {
+			if (test->data_len > 0)
+				size_data = test->data_len;
+			else
+				size_data = sizeof(test->data);
+			if (test->override_data_out_len)
+				overridden_data_out_size = &test->overridden_data_out_len;
+			else
+				overridden_data_out_size = NULL;
+			size_ctx = test->ctx_len;
+			bad_size = false;
 			expected_val = unpriv && test->retval_unpriv ?
 				test->retval_unpriv : test->retval;
 
-			err = do_prog_test_run(fd_prog, unpriv, expected_val,
-					       test->data, sizeof(test->data));
+			if (size_data > sizeof(test->data)) {
+				printf("FAIL: data size (%u) greater than TEST_DATA_LEN (%lu) ", size_data, sizeof(test->data));
+				bad_size = true;
+			}
+			if (size_ctx > sizeof(test->ctx)) {
+				printf("FAIL: ctx size (%u) greater than TEST_CTX_LEN (%lu) ", size_ctx, sizeof(test->ctx));
+				bad_size = true;
+			}
+			if (size_ctx)
+				ctx = test->ctx;
+			else
+				ctx = NULL;
+			if (bad_size)
+				err = 1;
+			else
+				err = do_prog_test_run(fd_prog, unpriv, expected_val,
+						       test->data, size_data,
+						       ctx, size_ctx,
+						       overridden_data_out_size);
 			if (err)
 				run_errs++;
 			else
@@ -970,14 +1025,40 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		}
 
 		for (i = 0; i < test->runs; i++) {
+			if (test->retvals[i].data_len > 0)
+				size_data = test->retvals[i].data_len;
+			else
+				size_data = sizeof(test->retvals[i].data);
+			if (test->override_data_out_len)
+				overridden_data_out_size = &test->overridden_data_out_len;
+			else
+				overridden_data_out_size = NULL;
+			size_ctx = test->retvals[i].ctx_len;
+			bad_size = false;
 			if (unpriv && test->retvals[i].retval_unpriv)
 				expected_val = test->retvals[i].retval_unpriv;
 			else
 				expected_val = test->retvals[i].retval;
 
-			err = do_prog_test_run(fd_prog, unpriv, expected_val,
-					       test->retvals[i].data,
-					       sizeof(test->retvals[i].data));
+			if (size_data > sizeof(test->retvals[i].data)) {
+				printf("FAIL: data size (%u) at run %i greater than TEST_DATA_LEN (%lu) ", size_data, i + 1, sizeof(test->retvals[i].data));
+				bad_size = true;
+			}
+			if (size_ctx > sizeof(test->retvals[i].ctx)) {
+				printf("FAIL: ctx size (%u) at run %i greater than TEST_CTX_LEN (%lu) ", size_ctx, i + 1, sizeof(test->retvals[i].ctx));
+				bad_size = true;
+			}
+			if (size_ctx)
+				ctx = test->retvals[i].ctx;
+			else
+				ctx = NULL;
+			if (bad_size)
+				err = 1;
+			else
+				err = do_prog_test_run(fd_prog, unpriv, expected_val,
+						       test->retvals[i].data, size_data,
+						       ctx, size_ctx,
+						       overridden_data_out_size);
 			if (err) {
 				printf("(run %d/%d) ", i + 1, test->runs);
 				run_errs++;
-- 
2.20.1

