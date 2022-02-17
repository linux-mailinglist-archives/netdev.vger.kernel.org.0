Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA514B9566
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiBQBVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:21:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiBQBVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:21:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D52E43;
        Wed, 16 Feb 2022 17:21:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BACBB61CB2;
        Thu, 17 Feb 2022 01:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA50FC340F4;
        Thu, 17 Feb 2022 01:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645060888;
        bh=HZVCUt/+nmRvfzJPKLWQYPFJ0Jhkwie0cI7OG0z0bWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tclIz1UHRsJIMBoPSBmNid6qZPPSkc+0CdRoRJMM1saTDHwFj0tJ2RWkBMmaP+VMW
         6oZUrxdMnbvSFt0E2OLLVhL+K0hTfKHYXAUynE1iAhXepKh1BSZbI+rQ7refDg5qRp
         5M0ACwAl6qHe9E634T1HIqBxog0i0vTcSX8pUogAJWKM99KPbLEwejy78sFPffmXg3
         3896Duv9nCRbL4t2OiFZc161I35muyplZ5fuWq1nJxza4rnmA1COEZZ7ep4hHMGe6B
         VgXjP25B9sapTqC/G8/pKbsb/oCmVqunR617MufxQmEh0Olzcg6JiIbmmo8lE9Tw8O
         oSzHQG0XA6VOQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/5] selftests: net: basic test for IPV6_2292*
Date:   Wed, 16 Feb 2022 17:21:20 -0800
Message-Id: <20220217012120.61250-6-kuba@kernel.org>
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

Add a basic test to make sure ping sockets don't crash
with IPV6_2292* options.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_ipv6.sh  |  9 +++++++
 tools/testing/selftests/net/cmsg_sender.c | 33 ++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_ipv6.sh b/tools/testing/selftests/net/cmsg_ipv6.sh
index e42c36e0d741..2d89cb0ad288 100755
--- a/tools/testing/selftests/net/cmsg_ipv6.sh
+++ b/tools/testing/selftests/net/cmsg_ipv6.sh
@@ -137,6 +137,15 @@ for ovr in setsock cmsg both diff; do
     done
 done
 
+# IPV6 exthdr
+for p in u i r; do
+    # Very basic "does it crash" test
+    for h in h d r; do
+	$NSEXE ./cmsg_sender -p $p -6 -H $h $TGT6 1234
+	check_result $? 0 "ExtHdr $prot $ovr - pass"
+    done
+done
+
 # Summary
 if [ $BAD -ne 0 ]; then
     echo "FAIL - $BAD/$TOTAL cases failed"
diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 6136aa7df1c4..aed7845c08a8 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -66,6 +66,7 @@ struct options {
 		struct option_cmsg_u32 dontfrag;
 		struct option_cmsg_u32 tclass;
 		struct option_cmsg_u32 hlimit;
+		struct option_cmsg_u32 exthdr;
 	} v6;
 } opt = {
 	.size = 13,
@@ -99,6 +100,8 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 	       "\t\t-C val  Set TCLASS via setsockopt\n"
 	       "\t\t-l val  Set HOPLIMIT via cmsg\n"
 	       "\t\t-L val  Set HOPLIMIT via setsockopt\n"
+	       "\t\t-H type Add an IPv6 header option\n"
+	       "\t\t        (h = HOP; d = DST; r = RTDST)"
 	       "");
 	exit(ERN_HELP);
 }
@@ -107,7 +110,7 @@ static void cs_parse_args(int argc, char *argv[])
 {
 	char o;
 
-	while ((o = getopt(argc, argv, "46sS:p:m:M:d:tf:F:c:C:l:L:")) != -1) {
+	while ((o = getopt(argc, argv, "46sS:p:m:M:d:tf:F:c:C:l:L:H:")) != -1) {
 		switch (o) {
 		case 's':
 			opt.silent_send = true;
@@ -169,6 +172,23 @@ static void cs_parse_args(int argc, char *argv[])
 		case 'L':
 			opt.sockopt.hlimit = atoi(optarg);
 			break;
+		case 'H':
+			opt.v6.exthdr.ena = true;
+			switch (optarg[0]) {
+			case 'h':
+				opt.v6.exthdr.val = IPV6_HOPOPTS;
+				break;
+			case 'd':
+				opt.v6.exthdr.val = IPV6_DSTOPTS;
+				break;
+			case 'r':
+				opt.v6.exthdr.val = IPV6_RTHDRDSTOPTS;
+				break;
+			default:
+				printf("Error: hdr type: %s\n", optarg);
+				break;
+			}
+			break;
 		}
 	}
 
@@ -272,6 +292,17 @@ cs_write_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 		*(__u32 *)CMSG_DATA(cmsg) = SOF_TIMESTAMPING_TX_SCHED |
 					    SOF_TIMESTAMPING_TX_SOFTWARE;
 	}
+	if (opt.v6.exthdr.ena) {
+		cmsg = (struct cmsghdr *)(cbuf + cmsg_len);
+		cmsg_len += CMSG_SPACE(8);
+		if (cbuf_sz < cmsg_len)
+			error(ERN_CMSG_WR, EFAULT, "cmsg buffer too small");
+
+		cmsg->cmsg_level = SOL_IPV6;
+		cmsg->cmsg_type = opt.v6.exthdr.val;
+		cmsg->cmsg_len = CMSG_LEN(8);
+		*(__u64 *)CMSG_DATA(cmsg) = 0;
+	}
 
 	if (cmsg_len)
 		msg->msg_controllen = cmsg_len;
-- 
2.34.1

