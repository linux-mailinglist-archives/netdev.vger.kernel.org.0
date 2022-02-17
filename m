Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857384B9568
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiBQBVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:21:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiBQBVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:21:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB59AE7A;
        Wed, 16 Feb 2022 17:21:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EBB1B820E4;
        Thu, 17 Feb 2022 01:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF5EC340F1;
        Thu, 17 Feb 2022 01:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645060887;
        bh=7NWE1IVVDLfrvjPsykbQ9S4y+9dQ21toLFLjCQGo6dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVUq/WUgqq0Za7/Tbm0XOJAHWaVlQw4NTU0jgnx3a+aCa7JZQPEUCofjKMOBhx6Ia
         AClpjobJsEuYtDVSHvaAEy3pmr1hHVxjChjDPa9fDMIst47TSUrg6ReqWqzV357JBI
         oGsDYRKrS3hTuT/yxs5lALpIs8o3Pw6WBHxg0ThgeBn8bibLBDGCleQUbjem567ufn
         leXRuxrwQTjI6RYqr2xNxqqvSJnsF4Yxj48lyYROsjICA/pP5amKlDcWDOVCZOb/mZ
         D9ENW6krw+2Zshi9FcUIQvjVslvxWI1ptYkrRhoh0MwoabVmRVmxt8R/1c58ggu9ou
         B/agV6spBZk/A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/5] selftests: net: test IPV6_TCLASS
Date:   Wed, 16 Feb 2022 17:21:18 -0800
Message-Id: <20220217012120.61250-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217012120.61250-1-kuba@kernel.org>
References: <20220217012120.61250-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test setting IPV6_TCLASS via setsockopt and cmsg
across socket types.

Output without the kernel support (this series):

  Case TCLASS ICMP cmsg - packet data returned 1, expected 0
  Case TCLASS ICMP cmsg - rejection returned 0, expected 1
  Case TCLASS ICMP diff - pass returned 1, expected 0
  Case TCLASS ICMP diff - packet data returned 1, expected 0
  Case TCLASS ICMP diff - rejection returned 0, expected 1

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_ipv6.sh  | 51 +++++++++++++++++++++++
 tools/testing/selftests/net/cmsg_sender.c | 19 ++++++++-
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_ipv6.sh b/tools/testing/selftests/net/cmsg_ipv6.sh
index fb5a8ab7c909..f7bb6ce68c88 100755
--- a/tools/testing/selftests/net/cmsg_ipv6.sh
+++ b/tools/testing/selftests/net/cmsg_ipv6.sh
@@ -1,12 +1,16 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+ksft_skip=4
+
 NS=ns
 IP6=2001:db8:1::1/64
 TGT6=2001:db8:1::2
+TMPF=`mktemp`
 
 cleanup()
 {
+    rm -f $TMPF
     ip netns del $NS
 }
 
@@ -14,6 +18,12 @@ trap cleanup EXIT
 
 NSEXE="ip netns exec $NS"
 
+tcpdump -h | grep immediate-mode >> /dev/null
+if [ $? -ne 0 ]; then
+    echo "SKIP - tcpdump with --immediate-mode option required"
+    exit $ksft_skip
+fi
+
 # Namespaces
 ip netns add $NS
 
@@ -55,6 +65,47 @@ for ovr in setsock cmsg both diff; do
     done
 done
 
+# IPV6_TCLASS
+TOS=0x10
+TOS2=0x20
+
+ip -6 -netns $NS rule add tos $TOS lookup 300
+ip -6 -netns $NS route add table 300 prohibit any
+
+for ovr in setsock cmsg both diff; do
+    for p in u i r; do
+	[ $p == "u" ] && prot=UDP
+	[ $p == "i" ] && prot=ICMP
+	[ $p == "r" ] && prot=RAW
+
+	[ $ovr == "setsock" ] && m="-C"
+	[ $ovr == "cmsg" ]    && m="-c"
+	[ $ovr == "both" ]    && m="-C $((TOS2)) -c"
+	[ $ovr == "diff" ]    && m="-C $((TOS )) -c"
+
+	$NSEXE nohup tcpdump --immediate-mode -p -ni dummy0 -w $TMPF -c 4 2> /dev/null &
+	BG=$!
+	sleep 0.05
+
+	$NSEXE ./cmsg_sender -6 -p $p $m $((TOS2)) $TGT6 1234
+	check_result $? 0 "TCLASS $prot $ovr - pass"
+
+	while [ -d /proc/$BG ]; do
+	    $NSEXE ./cmsg_sender -6 -p u $TGT6 1234
+	done
+
+	tcpdump -r $TMPF -v 2>&1 | grep "class $TOS2" >> /dev/null
+	check_result $? 0 "TCLASS $prot $ovr - packet data"
+	rm $TMPF
+
+	[ $ovr == "both" ]    && m="-C $((TOS )) -c"
+	[ $ovr == "diff" ]    && m="-C $((TOS2)) -c"
+
+	$NSEXE ./cmsg_sender -6 -p $p $m $((TOS)) -s $TGT6 1234
+	check_result $? 1 "TCLASS $prot $ovr - rejection"
+    done
+done
+
 # Summary
 if [ $BAD -ne 0 ]; then
     echo "FAIL - $BAD/$TOTAL cases failed"
diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 844ca6134662..4033cf93eabf 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -46,6 +46,7 @@ struct options {
 	struct {
 		unsigned int mark;
 		unsigned int dontfrag;
+		unsigned int tclass;
 	} sockopt;
 	struct {
 		unsigned int family;
@@ -62,6 +63,7 @@ struct options {
 	} ts;
 	struct {
 		struct option_cmsg_u32 dontfrag;
+		struct option_cmsg_u32 tclass;
 	} v6;
 } opt = {
 	.size = 13,
@@ -91,6 +93,8 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 	       "\t\t-t      Enable time stamp reporting\n"
 	       "\t\t-f val  Set don't fragment via cmsg\n"
 	       "\t\t-F val  Set don't fragment via setsockopt\n"
+	       "\t\t-c val  Set TCLASS via cmsg\n"
+	       "\t\t-C val  Set TCLASS via setsockopt\n"
 	       "");
 	exit(ERN_HELP);
 }
@@ -99,7 +103,7 @@ static void cs_parse_args(int argc, char *argv[])
 {
 	char o;
 
-	while ((o = getopt(argc, argv, "46sS:p:m:M:d:tf:F:")) != -1) {
+	while ((o = getopt(argc, argv, "46sS:p:m:M:d:tf:F:c:C:")) != -1) {
 		switch (o) {
 		case 's':
 			opt.silent_send = true;
@@ -147,6 +151,13 @@ static void cs_parse_args(int argc, char *argv[])
 		case 'F':
 			opt.sockopt.dontfrag = atoi(optarg);
 			break;
+		case 'c':
+			opt.v6.tclass.ena = true;
+			opt.v6.tclass.val = atoi(optarg);
+			break;
+		case 'C':
+			opt.sockopt.tclass = atoi(optarg);
+			break;
 		}
 	}
 
@@ -202,6 +213,8 @@ cs_write_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 			  SOL_SOCKET, SO_MARK, &opt.mark);
 	ca_write_cmsg_u32(cbuf, cbuf_sz, &cmsg_len,
 			  SOL_IPV6, IPV6_DONTFRAG, &opt.v6.dontfrag);
+	ca_write_cmsg_u32(cbuf, cbuf_sz, &cmsg_len,
+			  SOL_IPV6, IPV6_TCLASS, &opt.v6.tclass);
 
 	if (opt.txtime.ena) {
 		struct sock_txtime so_txtime = {
@@ -343,6 +356,10 @@ static void ca_set_sockopts(int fd)
 	    setsockopt(fd, SOL_IPV6, IPV6_DONTFRAG,
 		       &opt.sockopt.dontfrag, sizeof(opt.sockopt.dontfrag)))
 		error(ERN_SOCKOPT, errno, "setsockopt IPV6_DONTFRAG");
+	if (opt.sockopt.tclass &&
+	    setsockopt(fd, SOL_IPV6, IPV6_TCLASS,
+		       &opt.sockopt.tclass, sizeof(opt.sockopt.tclass)))
+		error(ERN_SOCKOPT, errno, "setsockopt IPV6_TCLASS");
 }
 
 int main(int argc, char *argv[])
-- 
2.34.1

