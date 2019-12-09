Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99DF116E45
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfLINzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:55:54 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:43667 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfLINzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 08:55:53 -0500
Received: by mail-pj1-f66.google.com with SMTP id g4so5930688pjs.10;
        Mon, 09 Dec 2019 05:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FtlFTwPN7vm8GGYvOb47ybx5xe8EPoD5OQwlGaO2mBw=;
        b=hwE6YJsiTcW9eYzih0IvFW62nhAohQF8BGZBqSeh/+hUugtoUKRK01g0OQKcszZS6G
         e8sXCheu6MV0XxlTJM1AFA0OhGm4qPjvMSuyEkY2op/lYktsSDUI2g7kLCFQcXP9y3A/
         A8hCMYuA2oshMc6T6Cnj4BQA7bo4Aj6FOzNItwrrhrsh8ZEPUu6lI76Ur05HjfXTudIN
         ISdDqgMHz4i6uebcp0EEbNUuBIoiIcbO8lCbtCHnHJb5LroBmpfWRgqSAqKc5Vx21+wM
         fZqzsKvEB0hrwSNBWvgpayvZyJXzj3WPmKAvCZIlUbdGGbkLpT7jSN7fZMEG/MwXbaNN
         0dBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FtlFTwPN7vm8GGYvOb47ybx5xe8EPoD5OQwlGaO2mBw=;
        b=PL4vGLBtM11nDEmHL0JA7LpdRzNMYfCAOiTy8E80wMSqjZEePilqTL+cB+/cpkYBkf
         d+wmVcHDQFbREwBjg+0078X/OSfoNhFx32cXrTfVpgACCL3ImdZI/hBiIlEIobL/7BtB
         5tjr9hnRwe5m7A/N2Au+iZJdq+B0eOjClUGrQj9bxr9dumZfu8LnJV9bgA0ORbqhfxrv
         PlJrTUyr2udH0zTHUceNplOYyHPxrZDLQNR8f4nslbMgkb3u2uyhZ9v6vtgutHeyjLij
         Aq7aeH75+nIc7bZM/IMJNXYb5TcZ5nKtKP+L7/AWqRMay1ss/46EoB3vo1E2YaGTnGZc
         r/Vg==
X-Gm-Message-State: APjAAAWPwQ+yVBIvUTnwMDBwuaeUdEDkyYCbhUFhF/Au9BwmmxvpX3za
        TJo5geg+G2Fa5oRVcePVsrB3q3T85r5URg==
X-Google-Smtp-Source: APXvYqxzdiHtX+qYnO1QO59HhWVbDFiFR1kF7rkXdTjaZVj9oPlsXXJNwdUWiWdXdVeBrQrHPg8g3g==
X-Received: by 2002:a17:90a:508:: with SMTP id h8mr32256100pjh.91.1575899752603;
        Mon, 09 Dec 2019 05:55:52 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id h26sm19543403pfr.9.2019.12.09.05.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 05:55:52 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v3 5/6] selftests: bpf: add xdp_perf test
Date:   Mon,  9 Dec 2019 14:55:21 +0100
Message-Id: <20191209135522.16576-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209135522.16576-1-bjorn.topel@gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The xdp_perf is a dummy XDP test, only used to measure the the cost of
jumping into a XDP program.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 .../selftests/bpf/prog_tests/xdp_perf.c       | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_perf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_perf.c b/tools/testing/selftests/bpf/prog_tests/xdp_perf.c
new file mode 100644
index 000000000000..7185bee16fe4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_perf.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+void test_xdp_perf(void)
+{
+	const char *file = "./xdp_dummy.o";
+	__u32 duration, retval, size;
+	struct bpf_object *obj;
+	char in[128], out[128];
+	int err, prog_fd;
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	err = bpf_prog_test_run(prog_fd, 1000000, &in[0], 128,
+				out, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_PASS || size != 128,
+	      "xdp-perf",
+	      "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	bpf_object__close(obj);
+}
-- 
2.20.1

