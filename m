Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645CD6264C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403955AbfGHQcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:32:12 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:54510 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403820AbfGHQcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:32:02 -0400
Received: by mail-wm1-f45.google.com with SMTP id p74so146339wme.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sQGKbunRlrvdVKbp02vEGwvG8+xrq5xUVQ5fY/+t4TE=;
        b=SJBZLbfj73WvztsTVCyOaGzkao16f0cK4Qd3O7+93OdYSwxGMZrFSA+QNEXHIq4q52
         QTqMGAMrkclA3q+GV20vV9rDe5T7Aq+vjBeSxnO4sxrsd425CRXW6cWA9wOzNeN23mBb
         DH4d4tYhyv4Fh9Zq0DD9xa42KhSbQp1I9es+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sQGKbunRlrvdVKbp02vEGwvG8+xrq5xUVQ5fY/+t4TE=;
        b=jSuJ4WQUR4wlELJamzA+EH/v2tOOf4yEElld7D5Zai7+iy/pkyP9antSt+n9WBnXSS
         KX30cElRF7MNv2Ro1alBeH3FUHHYdUzm9M/QpjZq/TyO8NYI/UZhz2SHb6R77orv20+i
         4kEcjblo8UJnuvhIlOqfYzbLfEMsRsIqgD7E9n5B21lTTLsyn6eLn/9NNmQTOwc2Vzz4
         N/ygOKJpclnylXcKlL8MaVvi5S8kbCcZPmP7A5JuOpuIprNA6dkgcJnqRLP/9KVkvexy
         VNkNeZpll0zysLOpnWdtHYl3kTaIpSlhjidwkAAXsJnQZwwedyGQUArWggnDUIp7CeXe
         MZ2g==
X-Gm-Message-State: APjAAAUQswyQJ9NXsZeTMWIpPRPApgr7PiSBZp2hnyFo0daQxY0GbwCK
        FTLdHfnkoDLYctohyL99c7WKUQ==
X-Google-Smtp-Source: APXvYqzZGSWnfDDVHTzxD8mRM5nAtI2EXCovxJ1DXmzY0w4uYyNkN/nErPCAqTn8joiAXOQfOGRdWg==
X-Received: by 2002:a1c:cc0d:: with SMTP id h13mr17034505wmb.119.1562603521360;
        Mon, 08 Jul 2019 09:32:01 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedbe.dynamic.kabel-deutschland.de. [95.90.237.190])
        by smtp.gmail.com with ESMTPSA id e6sm18255086wrw.23.2019.07.08.09.32.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:32:00 -0700 (PDT)
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
Subject: [bpf-next v3 12/12] selftests/bpf: Test correctness of narrow 32bit read on 64bit field
Date:   Mon,  8 Jul 2019 18:31:21 +0200
Message-Id: <20190708163121.18477-13-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190708163121.18477-1-krzesimir@kinvolk.io>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test the correctness of the 32bit narrow reads by reading both halves
of the 64 bit field and doing a binary or on them to see if we get the
original value.

It succeeds as it should, but with the commit e2f7fc0ac695 ("bpf: fix
undefined behavior in narrow load handling") reverted, the test fails
with a following message:

> $ sudo ./test_verifier
> ...
> #967/p 32bit loads of a 64bit field (both least and most significant words) FAIL retval -1985229329 != 0
> verification time 17 usec
> stack depth 0
> processed 8 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
> ...
> Summary: 1519 PASSED, 0 SKIPPED, 1 FAILED

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/testing/selftests/bpf/test_verifier.c   | 19 +++++++++++++++++
 .../testing/selftests/bpf/verifier/var_off.c  | 21 +++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 484ea8842b06..2a20280a4a44 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -24,6 +24,7 @@
 
 #include <sys/capability.h>
 
+#include <linux/compiler.h>
 #include <linux/unistd.h>
 #include <linux/filter.h>
 #include <linux/bpf_perf_event.h>
@@ -343,6 +344,24 @@ static void bpf_fill_perf_event_test_run_check(struct bpf_test *self)
 	self->fill_insns = NULL;
 }
 
+static void bpf_fill_32bit_loads(struct bpf_test *self)
+{
+	compiletime_assert(
+		sizeof(struct bpf_perf_event_data) <= TEST_CTX_LEN,
+		"buffer for ctx is too short to fit struct bpf_perf_event_data");
+	compiletime_assert(
+		sizeof(struct bpf_perf_event_value) <= TEST_DATA_LEN,
+		"buffer for data is too short to fit struct bpf_perf_event_value");
+
+	struct bpf_perf_event_data ctx = {
+		.sample_period = 0x0123456789abcdef,
+	};
+
+	memcpy(self->ctx, &ctx, sizeof(ctx));
+	free(self->fill_insns);
+	self->fill_insns = NULL;
+}
+
 /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up maps */
 #define BPF_SK_LOOKUP(func)						\
 	/* struct bpf_sock_tuple tuple = {} */				\
diff --git a/tools/testing/selftests/bpf/verifier/var_off.c b/tools/testing/selftests/bpf/verifier/var_off.c
index 8504ac937809..3f8bee0a50ef 100644
--- a/tools/testing/selftests/bpf/verifier/var_off.c
+++ b/tools/testing/selftests/bpf/verifier/var_off.c
@@ -246,3 +246,24 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
+{
+	"32bit loads of a 64bit field (both least and most significant words)",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1, offsetof(struct bpf_perf_event_data, sample_period)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_5, BPF_REG_1, offsetof(struct bpf_perf_event_data, sample_period) + 4),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, offsetof(struct bpf_perf_event_data, sample_period)),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_5, 32),
+	BPF_ALU64_REG(BPF_OR, BPF_REG_4, BPF_REG_5),
+	BPF_ALU64_REG(BPF_XOR, BPF_REG_4, BPF_REG_6),
+	BPF_MOV64_REG(BPF_REG_0, BPF_REG_4),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.ctx = { 0, },
+	.ctx_len = sizeof(struct bpf_perf_event_data),
+	.data = { 0, },
+	.data_len = sizeof(struct bpf_perf_event_value),
+	.fill_helper = bpf_fill_32bit_loads,
+	.override_data_out_len = true,
+},
-- 
2.20.1

