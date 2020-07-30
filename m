Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F8A23326D
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 14:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgG3Mxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 08:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgG3Mxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 08:53:30 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B00C061794
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 05:53:28 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 184so6123303wmb.0
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 05:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5p3h1EoHNDt6I25i6Sk0k0PHptS8q4TynLsY8lOs+0A=;
        b=FpPy62A8sOsaFDTDgaKyMVxd6/T7nlCPWrdc4tuZK9iG6+tWqh4glix9euuRYHkMIg
         qcFNUGWa8x2SoFUI3AdF7oTWkySMtgjenp50rJKlEMtT5xy3z1RUZc7wwUJfZOEmDDsc
         Tzvtwm2749shNSZq1N7+jFBO4b3WCHILPZ/Tg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5p3h1EoHNDt6I25i6Sk0k0PHptS8q4TynLsY8lOs+0A=;
        b=GXcqCUrjtpiKK0RyqCLgVV2HudnTe1/5J5Jom54fiuv6wj1mrzH0XFumuPb2BGrR0u
         P9cQtm4fgMbVTbnlI7z3MJZaqwBpYV20y7shWYrimhJSN4CT+KmDeazoOzqI20nN8eea
         Khm9GEZX+Xr5mrxu4dtMQK/b91tNCMskhuJllI2BYKXuV4ADT9ifik68lT7u8i5yLt/s
         WDoocbDlh32p0cF0kblLaA2cOXBU2CG/QHuEfvwgEUphaWqp7caShiR18vQ3DLcg5uU7
         w9+Fa8ALYB/wPxTPDw22Zq++1AmKK0O0UZ6WhngOoaHk7COQ1rNWhWerMdnIt2MnL5F/
         HP/Q==
X-Gm-Message-State: AOAM532uRVf9f9BdYokgSBVnezVoXYtD/q8qBTJjeLsdmeRfv5/IDHiu
        G77uADQt2pBhXpjt2/IyXmfeNg==
X-Google-Smtp-Source: ABdhPJwueHGR2ItU0WTJAE6scyrZDbwAcckP5+ts6Ldk5Cvo9DMgLhZwasvv/IVWHal0am0RMACV9g==
X-Received: by 2002:a1c:24c4:: with SMTP id k187mr6646148wmk.148.1596113607251;
        Thu, 30 Jul 2020 05:53:27 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b8sm9892648wrv.4.2020.07.30.05.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 05:53:26 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Omit nodad flag when adding addresses to loopback
Date:   Thu, 30 Jul 2020 14:53:25 +0200
Message-Id: <20200730125325.1869363-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting IFA_F_NODAD flag for IPv6 addresses to add to loopback is
unnecessary. Duplicate Address Detection does not happen on loopback
device.

Also, passing 'nodad' flag to 'ip address' breaks libbpf CI, which runs in
an environment with BusyBox implementation of 'ip' command, that doesn't
understand this flag.

Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index 9bbd2b2b7630..379da6f10ee9 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -1290,8 +1290,8 @@ static void run_tests(struct test_sk_lookup *skel)
 static int switch_netns(void)
 {
 	static const char * const setup_script[] = {
-		"ip -6 addr add dev lo " EXT_IP6 "/128 nodad",
-		"ip -6 addr add dev lo " INT_IP6 "/128 nodad",
+		"ip -6 addr add dev lo " EXT_IP6 "/128",
+		"ip -6 addr add dev lo " INT_IP6 "/128",
 		"ip link set dev lo up",
 		NULL,
 	};
-- 
2.25.4

