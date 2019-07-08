Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCEED62661
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403966AbfGHQco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:32:44 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33939 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389092AbfGHQbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:31:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so401000wmd.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z76b7cDfMIhdXC2S4ZNE4xkrLelxUNXMkQTCGU5+CcM=;
        b=RhXNYx6sIoPRSm80OucW4DTy7frQhaZPWJmrYQbwM4HE/3hixCW6WTJJ4w43q9LLNd
         dZJiNF+rmokzqQRRd+3NRPWItWj67xvVHDa1VDb1ML5a6iA5MqmuGGScfvd9ir26Nmr5
         0IdygbIrnx4b+g9Gfgn/r431cV34dVhbf0v+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z76b7cDfMIhdXC2S4ZNE4xkrLelxUNXMkQTCGU5+CcM=;
        b=gPAhdAm1bsn2q4D7Lpr4ISJYOkLESsQ96VRm3C2lpe2B6PT4gOs8O/zpu6KznHS5Tf
         mof62udwNKU9MjePjfQmGbgQabv4KFgZ1oFEe0nqcyRvrit0KHNYoFPa1V1t+B5UkUZL
         kEO2/3F1ZrU859zppPLKHjTv1VtZBj2dhw8dF6YbPuu90qeEu4KECzWXDPnvthDRg6Tv
         T3JQPJ4xzQgkkgn4+SbcPIb3aQbGFPkf9vrpDzddQfqFRFtD45I30tmxKwBf72vNN2hl
         uVt15r0w/JZlDU6G50RxEg60f/vDTcmHg+mwpPHO3xrguDj74bNCaL/mAn7tpZ6QU5on
         TVZA==
X-Gm-Message-State: APjAAAXJnSEBbirmsJqsof01mw3D1V4lxqg9dzFY7eN7R6nypqbFs4HY
        wOBZeORzvFGvZMneZ2hN0RDDDw==
X-Google-Smtp-Source: APXvYqzwiQkZAgs0VAH6SVpMDzW0Obn5DcSK9LXbi4kam1MbYa2py60vd/mSlpqJk3xgKq7QBW+AKw==
X-Received: by 2002:a05:600c:22ce:: with SMTP id 14mr17954233wmg.27.1562603511384;
        Mon, 08 Jul 2019 09:31:51 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedbe.dynamic.kabel-deutschland.de. [95.90.237.190])
        by smtp.gmail.com with ESMTPSA id e6sm18255086wrw.23.2019.07.08.09.31.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:31:50 -0700 (PDT)
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
Subject: [bpf-next v3 04/12] selftests/bpf: Use bpf_prog_test_run_xattr
Date:   Mon,  8 Jul 2019 18:31:13 +0200
Message-Id: <20190708163121.18477-5-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190708163121.18477-1-krzesimir@kinvolk.io>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
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
index c7541f572932..1640ba9f12c1 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -822,14 +822,20 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
 {
 	__u8 tmp[TEST_DATA_LEN << 2];
 	__u32 size_tmp = sizeof(tmp);
-	uint32_t retval;
 	int saved_errno;
 	int err;
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

