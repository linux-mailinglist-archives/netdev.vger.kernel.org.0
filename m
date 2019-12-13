Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B868611EDC4
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 23:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfLMWag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 17:30:36 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:39430 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfLMWaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 17:30:35 -0500
Received: by mail-pl1-f201.google.com with SMTP id p11so2013330plo.6
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 14:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PH7hh3/m0UNb9tTUeqSI8d2JGzJtPRYZDKVy+TJVMiw=;
        b=m22/J67DPQtxDitrFR42MDXsGkj1aIokLMmLjjfUfhA0zEN3zIl8wPmfKHBfa7ZN0H
         3uBj2g+Evgk9J0Nw84s5b2QS4zanZqKccFk8YpFI2ukxeEMnJUd1eXuV7yJqJY8xs+SP
         e4/2YNpTZ6bCGfyKBjpaorFXE8PSefYUVxuW7llfsb1jss8yiDZISMCEEmyuidpi3OYX
         sBN/QVXxLiDrIfI4JRyOZYJl7CJoQJfrk02+CVBBy8npEOb7vTmOs9WKq/wSzVhfs8M8
         cS08eAQjI4QxmTg3YvQD6vuS2HGVBKlA4ZTY4SPQg7Fp9VAsjcGPkRDCjTXgB7OGQhZQ
         /t7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PH7hh3/m0UNb9tTUeqSI8d2JGzJtPRYZDKVy+TJVMiw=;
        b=AgnVnjO1JxMktEiVm0VbslwSb8UHPF3I3UYpUh1mOW8CovR3H6Pbl5lKsZ5Zdn5Y+M
         iQzFV/DExxtRNUoDJ1vVImB/9wfq2AKUmpq7U3N6mmStlD8rIZL/eMkiX0rRc2e2VPIU
         aWXlP++fgIUSFWFF580kQSjDISYBx0zLe3hlCq2yVeGAEhGVFj6fgocgtWverSUaiMgg
         EGg1Eq9da/S/HNmQ3ICvxmTtfwNPPyXFuTzp5rXHULdiVHF8bdbkQ1TKqrvqfmF9opqZ
         d1q5E4c9ynRS/4g7EDt6E+dOjZWKCeJypo8M6+6WRw5ENXghQDX1qRXhdtNxVg5Dggo+
         Bp2w==
X-Gm-Message-State: APjAAAVMK4KygJStj4EK0kAKJGQSWpKSfPvNpfJg8a1x8f21uY+uD0Ed
        vcaIRcpOaT8k/UFrqX0uRwhaVNwdKDqUX2dGFzTVlNDHeBPNG/zRCxBW9N7YhJNWGMNkBPxVMFT
        Bt32pHv89Q9K+gaUHdGS54fibhWmkM9CNT8eXp65Sr7IZ9z1kyKNNFw==
X-Google-Smtp-Source: APXvYqwW9NQi22RWKiztkGnwks4xq/+ocowppkWlVnWoDwxLRBOE/rilUyi0DxnRkne1znjk7VkC9bc=
X-Received: by 2002:a63:6b8a:: with SMTP id g132mr2035382pgc.127.1576276233764;
 Fri, 13 Dec 2019 14:30:33 -0800 (PST)
Date:   Fri, 13 Dec 2019 14:30:28 -0800
In-Reply-To: <20191213223028.161282-1-sdf@google.com>
Message-Id: <20191213223028.161282-2-sdf@google.com>
Mime-Version: 1.0
References: <20191213223028.161282-1-sdf@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: test wire_len/gso_segs in BPF_PROG_TEST_RUN
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we can pass arbitrary data in wire_len/gso_segs.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c | 2 ++
 tools/testing/selftests/bpf/progs/test_skb_ctx.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
index a2eb8db8dafb..edf5e8c7d400 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -11,6 +11,8 @@ void test_skb_ctx(void)
 		.cb[4] = 5,
 		.priority = 6,
 		.tstamp = 7,
+		.wire_len = 100,
+		.gso_segs = 8,
 	};
 	struct bpf_prog_test_run_attr tattr = {
 		.data_in = &pkt_v4,
diff --git a/tools/testing/selftests/bpf/progs/test_skb_ctx.c b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
index 2a9f4c736ebc..534fbf9a7344 100644
--- a/tools/testing/selftests/bpf/progs/test_skb_ctx.c
+++ b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
@@ -18,5 +18,10 @@ int process(struct __sk_buff *skb)
 	skb->priority++;
 	skb->tstamp++;
 
+	if (skb->wire_len != 100)
+		return 1;
+	if (skb->gso_segs != 8)
+		return 1;
+
 	return 0;
 }
-- 
2.24.1.735.g03f4e72817-goog

