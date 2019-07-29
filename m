Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D06579B88
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388913AbfG2VvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:51:21 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:53543 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388897AbfG2VvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:51:20 -0400
Received: by mail-vs1-f74.google.com with SMTP id b23so16416235vsl.20
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mk1AlSdhWouhxekOJpdFXQ55nI5mNZU2X7I4DAKam4s=;
        b=KQGOnIjIwt2k6pB3ac3zD2o3IHiOJelU9siOpG4Bt+TIqO8YHZC3WDt93JmfShgj8E
         hfPY1beD4/vsbesjOzEs2jpem2TZH1g5H0CjHQl6b1qPNgP2yx2QGB7Q0br79WqLOXz7
         jegibWARr8VKxQltqSlMabEyITEDDkCOpPscHGp30fF37gupQEzAzwdq8kZtWX2XT3CD
         bL0X8pP/gsbYZUDLfsi/buhgu9EYhgixf58kUg/MmhcNN3XTB9b5T2P6dDcL+VY18ov3
         FyM39Rm1hm1nw6PbtDGOOlWYyP0DvgELlq4aggPdCHODGxipU6S/P9+GNtMDvYKmtpmw
         BRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mk1AlSdhWouhxekOJpdFXQ55nI5mNZU2X7I4DAKam4s=;
        b=NP2MdGyRTF6IytRtSZkICiHE4E8CATDhdrxMt0lPFNeSO6LYWApbBTPokND7GAuVxA
         dr+MmcHCN+A8lWRTKiPxjJBCiv6dNKIR7Pn8hY7ZHyJUZBNG6PZCp7do+TMPNRYTU6GM
         HR98vIFoSBQpOMZly9lkwpHasW/bkPAra9G5262AZoHzo7xaUuyB/OEsXzi8f2TuJWMu
         R7CKA8wfFrJ5aMP0TR3s6N7g91EJUEAMmhGkrNn+xvbLUomDGoHuuD2X6Wr/pWQYz0Au
         YKlK0hFcngNynN8R1mb/wTzlUkytGFEdm7BjmlhKldIfnpniGs9iWCbP8NtyDZEiqcG0
         Arug==
X-Gm-Message-State: APjAAAXHcO18nMgw/u4NWbY/B+C/kgtzKAsG0xY4SZWPlbm13s4WSGVt
        IFvoqki83ZNYSb1yCAOSed1y+KiC5JfT0qV/2dFX8ofY2E+G81Hv/ml+vcrC5ZqYTtJc6ybWt5X
        venVk1JDdWaSDODBRNi56A4u9IkX59vNI1gRM2+rkJawPWHmjvtPUjQ==
X-Google-Smtp-Source: APXvYqyPnowQnJArtBjC7L0/h1TWdXilXZcN5w4wq1+1hDauWd8K0+2IRbmmSEwA2uC51Yj3kB541A4=
X-Received: by 2002:ab0:470e:: with SMTP id h14mr45447715uac.98.1564437079443;
 Mon, 29 Jul 2019 14:51:19 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:51:11 -0700
In-Reply-To: <20190729215111.209219-1-sdf@google.com>
Message-Id: <20190729215111.209219-3-sdf@google.com>
Mime-Version: 1.0
References: <20190729215111.209219-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH bpf-next 2/2] selftests/bpf: extend sockopt_sk selftest with
 TCP_CONGESTION use case
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ignore SOL_TCP:TCP_CONGESTION in getsockopt and always override
SOL_TCP:TCP_CONGESTION with "cubic" in setsockopt hook.

Call setsockopt(SOL_TCP, TCP_CONGESTION) with short optval ("nv")
to make sure BPF program has enough buffer space to replace it
with "cubic".

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 22 ++++++++++++++++
 tools/testing/selftests/bpf/test_sockopt_sk.c | 25 +++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
index 076122c898e9..9a3d1c79e6fe 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <string.h>
 #include <netinet/in.h>
+#include <netinet/tcp.h>
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
 
@@ -42,6 +44,14 @@ int _getsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_TCP && ctx->optname == TCP_CONGESTION) {
+		/* Not interested in SOL_TCP:TCP_CONGESTION;
+		 * let next BPF program in the cgroup chain or kernel
+		 * handle it.
+		 */
+		return 1;
+	}
+
 	if (ctx->level != SOL_CUSTOM)
 		return 0; /* EPERM, deny everything except custom level */
 
@@ -91,6 +101,18 @@ int _setsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_TCP && ctx->optname == TCP_CONGESTION) {
+		/* Always use cubic */
+
+		if (optval + 5 > optval_end)
+			return 0; /* EPERM, bounds check */
+
+		memcpy(optval, "cubic", 5);
+		ctx->optlen = 5;
+
+		return 1;
+	}
+
 	if (ctx->level != SOL_CUSTOM)
 		return 0; /* EPERM, deny everything except custom level */
 
diff --git a/tools/testing/selftests/bpf/test_sockopt_sk.c b/tools/testing/selftests/bpf/test_sockopt_sk.c
index 036b652e5ca9..e4f6055d92e9 100644
--- a/tools/testing/selftests/bpf/test_sockopt_sk.c
+++ b/tools/testing/selftests/bpf/test_sockopt_sk.c
@@ -6,6 +6,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
+#include <netinet/tcp.h>
 
 #include <linux/filter.h>
 #include <bpf/bpf.h>
@@ -25,6 +26,7 @@ static int getsetsockopt(void)
 	union {
 		char u8[4];
 		__u32 u32;
+		char cc[16]; /* TCP_CA_NAME_MAX */
 	} buf = {};
 	socklen_t optlen;
 
@@ -115,6 +117,29 @@ static int getsetsockopt(void)
 		goto err;
 	}
 
+	/* TCP_CONGESTION can extend the string */
+
+	strcpy(buf.cc, "nv");
+	err = setsockopt(fd, SOL_TCP, TCP_CONGESTION, &buf, strlen("nv"));
+	if (err) {
+		log_err("Failed to call setsockopt(TCP_CONGESTION)");
+		goto err;
+	}
+
+
+	optlen = sizeof(buf.cc);
+	err = getsockopt(fd, SOL_TCP, TCP_CONGESTION, &buf, &optlen);
+	if (err) {
+		log_err("Failed to call getsockopt(TCP_CONGESTION)");
+		goto err;
+	}
+
+	if (strcmp(buf.cc, "cubic") != 0) {
+		log_err("Unexpected getsockopt(TCP_CONGESTION) %s != %s",
+			buf.cc, "cubic");
+		goto err;
+	}
+
 	close(fd);
 	return 0;
 err:
-- 
2.22.0.709.g102302147b-goog

