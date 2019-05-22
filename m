Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A4027065
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbfEVUDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729981AbfEVTVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:21:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B56F7217D4;
        Wed, 22 May 2019 19:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552895;
        bh=jkEcnpy9mNbigsKjXTwK3nssgT04hHxd61lee7Q3BnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhUYqW9LOpJCm9nekoarSUXOToTl5wyYgwvcd38+PAUxm7JnM+SuloclRLgAl4sJo
         lkRA5J/i2Jphw+sBEBektSuIrGuw0+cNJVvBnxuFeOakVGu4aASSghY9QAZOJlNBX4
         fNlqF4fkfYxLvAhZN26rGrrggSswcUIEJAbBuSSE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 015/375] selftests/bpf: set RLIMIT_MEMLOCK properly for test_libbpf_open.c
Date:   Wed, 22 May 2019 15:15:15 -0400
Message-Id: <20190522192115.22666-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 6cea33701eb024bc6c920ab83940ee22afd29139 ]

Test test_libbpf.sh failed on my development server with failure
  -bash-4.4$ sudo ./test_libbpf.sh
  [0] libbpf: Error in bpf_object__probe_name():Operation not permitted(1).
      Couldn't load basic 'r0 = 0' BPF program.
  test_libbpf: failed at file test_l4lb.o
  selftests: test_libbpf [FAILED]
  -bash-4.4$

The reason is because my machine has 64KB locked memory by default which
is not enough for this program to get locked memory.
Similar to other bpf selftests, let us increase RLIMIT_MEMLOCK
to infinity, which fixed the issue.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_libbpf_open.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_libbpf_open.c b/tools/testing/selftests/bpf/test_libbpf_open.c
index 65cbd30704b5a..9e9db202d218a 100644
--- a/tools/testing/selftests/bpf/test_libbpf_open.c
+++ b/tools/testing/selftests/bpf/test_libbpf_open.c
@@ -11,6 +11,8 @@ static const char *__doc__ =
 #include <bpf/libbpf.h>
 #include <getopt.h>
 
+#include "bpf_rlimit.h"
+
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
 	{"debug",	no_argument,		NULL, 'D' },
-- 
2.20.1

