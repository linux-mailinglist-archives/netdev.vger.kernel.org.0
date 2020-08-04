Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A5E23BA5E
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 14:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHDMa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 08:30:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47558 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgHDMaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 08:30:20 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k2w57-0005bE-2S; Tue, 04 Aug 2020 12:30:13 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/net: skip msg_zerocopy test if we have less than 4 CPUs
Date:   Tue,  4 Aug 2020 13:30:12 +0100
Message-Id: <20200804123012.378750-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The current test will exit with a failure if it cannot set affinity on
specific CPUs which is problematic when running this on single CPU
systems. Add a check for the number of CPUs and skip the test if
the CPU requirement is not met.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/testing/selftests/net/msg_zerocopy.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/net/msg_zerocopy.sh b/tools/testing/selftests/net/msg_zerocopy.sh
index 825ffec85cea..97bc527e1297 100755
--- a/tools/testing/selftests/net/msg_zerocopy.sh
+++ b/tools/testing/selftests/net/msg_zerocopy.sh
@@ -21,6 +21,11 @@ readonly DADDR6='fd::2'
 
 readonly path_sysctl_mem="net.core.optmem_max"
 
+if [[ $(nproc) -lt 4 ]]; then
+	echo "SKIP: test requires at least 4 CPUs"
+	exit 4
+fi
+
 # No arguments: automated test
 if [[ "$#" -eq "0" ]]; then
 	$0 4 tcp -t 1
-- 
2.27.0

