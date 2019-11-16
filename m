Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE343FF2FB
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbfKPQWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbfKPPnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:12 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C92C52072D;
        Sat, 16 Nov 2019 15:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918992;
        bh=XR5WvofJzj0e2g0fbgE8Wpx6sS5fNscbX+8F20oWjZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBsb5JGL9l6T+mNo9dPTIdP0v56UCCxHCRSwg2U+XtzSbSV4vYs9AL3BQkporfnXB
         9G0CX3/graOZk6G8NEuntMxU2oVcXjk5JC6+LYneGwKXBZh7YEiUGoIDdcfcUTctJ2
         JSk75SJQc8d69aQpRIMRwq2cQK0RUWQ303D6bFUM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 096/237] selftests/bpf: fix return value comparison for tests in test_libbpf.sh
Date:   Sat, 16 Nov 2019 10:38:51 -0500
Message-Id: <20191116154113.7417-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit c5fa5d602221362f8341ecd9e32d83194abf5bd9 ]

The return value for each test in test_libbpf.sh is compared with

    if (( $? == 0 )) ; then ...

This works well with bash, but not with dash, that /bin/sh is aliased to
on some systems (such as Ubuntu).

Let's replace this comparison by something that works on both shells.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_libbpf.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_libbpf.sh b/tools/testing/selftests/bpf/test_libbpf.sh
index 8b1bc96d8e0cc..2989b2e2d856d 100755
--- a/tools/testing/selftests/bpf/test_libbpf.sh
+++ b/tools/testing/selftests/bpf/test_libbpf.sh
@@ -6,7 +6,7 @@ export TESTNAME=test_libbpf
 # Determine selftest success via shell exit code
 exit_handler()
 {
-	if (( $? == 0 )); then
+	if [ $? -eq 0 ]; then
 		echo "selftests: $TESTNAME [PASS]";
 	else
 		echo "$TESTNAME: failed at file $LAST_LOADED" 1>&2
-- 
2.20.1

