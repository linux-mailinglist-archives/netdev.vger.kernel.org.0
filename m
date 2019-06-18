Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983664AB55
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbfFRUDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:03:09 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42027 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730189AbfFRUDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:03:08 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so16969009qtk.9;
        Tue, 18 Jun 2019 13:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EaReUCVDO+Mrw24Wx5rXnRcMtdqNCUsJxBaExbUmcT0=;
        b=kXJ1uTicl/2X1Pb+j+d9tdVwWnK38dFtIsMoUkJb1y985NSsLLQXGqoqFFfbAYXMHh
         FOJoj2dh+vuQsJPNAOFffQ3u+BYg4u8Xdncay7TCqy8QJ+djww3HzMpXiuv5eCzndav1
         gdzp0FH8ypt0eQ9SPRhSV/ZFU6KkvA/+9b878UGYbcwbB0Irp3nvqjXd6SL2pV79Yor8
         5j543R9Q81IUBmpgdKqUH2y+bKIZjmfJBhqtc2lTSnyMietGu/YSjGKxVOl1KcqVsB2H
         bMW74kLLQhgp1eMD/bv5xffKvlXCHMJamlHDirqyC05epghCUi6a/5SfFwWn+H1xCADP
         EFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EaReUCVDO+Mrw24Wx5rXnRcMtdqNCUsJxBaExbUmcT0=;
        b=aiA/EZl9xsSK79r7v7OE3sQwN7ekxrGYT/WFspTRVhox2t5Hmo5WunPBf/OOse8Ilr
         baZWzilRqakUdGt3thh+9M8qmVsxUaIsNaGnhpZr40j1y9P8dyx+x62ylvjASPViAVZv
         n/rWI37rMg/rqz0gYrf9SRMx86piFWP5SErr1MWiAlBKYEh7nWhcQXmT97pJB8cgz4sm
         lVGEDvocs6L36MPJ4QqzTr6KawZpu4z2h8OmtgvH9YHxlJd/CRnRslw4IDT88UXS7R4j
         36uixDX6Id1CXPR7Q9xXR5a20p8NRbYCXwDq8fUB6kyQ8GO8y+ojTmuO5GfTscdEB1U9
         nvKw==
X-Gm-Message-State: APjAAAXIfpHxhB0MgQzT9EzXgMidvp0u/0Gn38xsFONV2m5jX0TEEvGa
        Ez65zogy9T/K0wM/9gsfVpRUTism
X-Google-Smtp-Source: APXvYqzegGnIgKHkB1vpawYwYqpaOzNpJwM2n0lj640AvSIBy8eqSQfe0LfIi1N9EQxMu/VUHFqHnw==
X-Received: by 2002:a0c:e712:: with SMTP id d18mr28846974qvn.152.1560888186735;
        Tue, 18 Jun 2019 13:03:06 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id s44sm11397521qtc.8.2019.06.18.13.03.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 13:03:06 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        naresh.kamboju@linaro.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] selftests/net: make udpgso_bench skip unsupported testcases
Date:   Tue, 18 Jun 2019 16:03:04 -0400
Message-Id: <20190618200304.63068-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Kselftest can be run against older kernels. Instead of failing hard
when a feature is unsupported, return the KSFT_SKIP exit code.

Specifically, do not fail hard on missing udp zerocopy.

The udp gso bench test runs multiple test cases from a single script.
Fail if any case fails, else return skip if any test is skipped.

Link: https://lore.kernel.org/lkml/20190618171516.GA17547@kroah.com/
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/udpgso_bench.sh   | 75 +++++++++++--------
 tools/testing/selftests/net/udpgso_bench_tx.c | 18 ++++-
 2 files changed, 59 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench.sh b/tools/testing/selftests/net/udpgso_bench.sh
index 4df1cd8d69d2..80b5d352702e 100755
--- a/tools/testing/selftests/net/udpgso_bench.sh
+++ b/tools/testing/selftests/net/udpgso_bench.sh
@@ -3,9 +3,47 @@
 #
 # Run a series of udpgso benchmarks
 
-GREEN='\033[0;92m'
-RED='\033[0;31m'
-NC='\033[0m' # No Color
+readonly GREEN='\033[0;92m'
+readonly YELLOW='\033[0;33m'
+readonly RED='\033[0;31m'
+readonly NC='\033[0m' # No Color
+
+readonly KSFT_PASS=0
+readonly KSFT_FAIL=1
+readonly KSFT_SKIP=4
+
+num_pass=0
+num_err=0
+num_skip=0
+
+kselftest_test_exitcode() {
+	local -r exitcode=$1
+
+	if [[ ${exitcode} -eq ${KSFT_PASS} ]]; then
+		num_pass=$(( $num_pass + 1 ))
+	elif [[ ${exitcode} -eq ${KSFT_SKIP} ]]; then
+		num_skip=$(( $num_skip + 1 ))
+	else
+		num_err=$(( $num_err + 1 ))
+	fi
+}
+
+kselftest_exit() {
+	echo -e "$(basename $0): PASS=${num_pass} SKIP=${num_skip} FAIL=${num_err}"
+
+	if [[ $num_err -ne 0 ]]; then
+		echo -e "$(basename $0): ${RED}FAIL${NC}"
+		exit ${KSFT_FAIL}
+	fi
+
+	if [[ $num_skip -ne 0 ]]; then
+		echo -e "$(basename $0): ${YELLOW}SKIP${NC}"
+		exit ${KSFT_SKIP}
+	fi
+
+	echo -e "$(basename $0): ${GREEN}PASS${NC}"
+	exit ${KSFT_PASS}
+}
 
 wake_children() {
 	local -r jobs="$(jobs -p)"
@@ -29,93 +67,66 @@ run_in_netns() {
 	local -r args=$@
 
 	./in_netns.sh $0 __subprocess ${args}
+	kselftest_test_exitcode $?
 }
 
 run_udp() {
 	local -r args=$@
-	local errors=0
 
 	echo "udp"
 	run_in_netns ${args}
-	errors=$(( $errors + $? ))
 
 	echo "udp gso"
 	run_in_netns ${args} -S 0
-	errors=$(( $errors + $? ))
 
 	echo "udp gso zerocopy"
 	run_in_netns ${args} -S 0 -z
-	errors=$(( $errors + $? ))
 
 	echo "udp gso timestamp"
 	run_in_netns ${args} -S 0 -T
-	errors=$(( $errors + $? ))
 
 	echo "udp gso zerocopy audit"
 	run_in_netns ${args} -S 0 -z -a
-	errors=$(( $errors + $? ))
 
 	echo "udp gso timestamp audit"
 	run_in_netns ${args} -S 0 -T -a
-	errors=$(( $errors + $? ))
 
 	echo "udp gso zerocopy timestamp audit"
 	run_in_netns ${args} -S 0 -T -z -a
-	errors=$(( $errors + $? ))
-
-	return $errors
 }
 
 run_tcp() {
 	local -r args=$@
-	local errors=0
 
 	echo "tcp"
 	run_in_netns ${args} -t
-	errors=$(( $errors + $? ))
 
 	echo "tcp zerocopy"
 	run_in_netns ${args} -t -z
-	errors=$(( $errors + $? ))
 
 	# excluding for now because test fails intermittently
 	# add -P option to include poll() to reduce possibility of lost messages
 	#echo "tcp zerocopy audit"
 	#run_in_netns ${args} -t -z -P -a
-	#errors=$(( $errors + $? ))
-
-	return $errors
 }
 
 run_all() {
 	local -r core_args="-l 3"
 	local -r ipv4_args="${core_args} -4 -D 127.0.0.1"
 	local -r ipv6_args="${core_args} -6 -D ::1"
-	local errors=0
 
 	echo "ipv4"
 	run_tcp "${ipv4_args}"
-	errors=$(( $errors + $? ))
 	run_udp "${ipv4_args}"
-	errors=$(( $errors + $? ))
 
 	echo "ipv6"
 	run_tcp "${ipv4_args}"
-	errors=$(( $errors + $? ))
 	run_udp "${ipv6_args}"
-	errors=$(( $errors + $? ))
-
-	return $errors
 }
 
 if [[ $# -eq 0 ]]; then
 	run_all
-	if [ $? -ne 0 ]; then
-		echo -e "$(basename $0): ${RED}FAIL${NC}"
-		exit 1
-	fi
-
-	echo -e "$(basename $0): ${GREEN}PASS${NC}"
+	kselftest_exit
 elif [[ $1 == "__subprocess" ]]; then
 	shift
 	run_one $@
diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index dfa83ad57206..ada99496634a 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -25,6 +25,8 @@
 #include <sys/types.h>
 #include <unistd.h>
 
+#include "../kselftest.h"
+
 #ifndef ETH_MAX_MTU
 #define ETH_MAX_MTU 0xFFFFU
 #endif
@@ -45,6 +47,10 @@
 #define MSG_ZEROCOPY	0x4000000
 #endif
 
+#ifndef ENOTSUPP
+#define ENOTSUPP	524
+#endif
+
 #define NUM_PKT		100
 
 static bool	cfg_cache_trash;
@@ -603,7 +609,7 @@ int main(int argc, char **argv)
 {
 	unsigned long num_msgs, num_sends;
 	unsigned long tnow, treport, tstop;
-	int fd, i, val;
+	int fd, i, val, ret;
 
 	parse_opts(argc, argv);
 
@@ -623,8 +629,16 @@ int main(int argc, char **argv)
 
 	if (cfg_zerocopy) {
 		val = 1;
-		if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val)))
+
+		ret = setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY,
+				 &val, sizeof(val));
+		if (ret) {
+			if (errno == ENOPROTOOPT || errno == ENOTSUPP) {
+				fprintf(stderr, "SO_ZEROCOPY not supported");
+				exit(KSFT_SKIP);
+			}
 			error(1, errno, "setsockopt zerocopy");
+		}
 	}
 
 	if (cfg_connected &&
-- 
2.22.0.410.gd8fdbe21b5-goog

