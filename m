Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4754B9563
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiBQBVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:21:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiBQBVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:21:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646D1DDD;
        Wed, 16 Feb 2022 17:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDC9761CB9;
        Thu, 17 Feb 2022 01:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AEAC004E1;
        Thu, 17 Feb 2022 01:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645060887;
        bh=FTEGWojkjlNcaaT3CzuuFlK8HbLnKzp/gldta9M8Abo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=invhP+bhIdD+ym+gXRyNqQsVpFTn5YAflx+Hu/a4wg3EuwMN0nbZF7T93401z0NA0
         vTUF2ldmXKEXyIg53U9J2ZSGDl8XyT+RDVpkvSpURyIOCzmjpfqdjgYCNHwe7K7/xx
         Ebibl0/7+VjSSYEHkSlvUJtp6dRMe+0H0/b9/199nDAaMB4TqKE5Ej74JaeJ/QSkYo
         +QIqLWPh7u/J3dBpYEBDKErxgPvZ3cfFV2SuWu2tDjdt1pntYDLGnpYq90WJPZ6N48
         NRiBCw30H11UPhsGqeuj4SO45k2ZrEIfvbA2KybtVsGxXs5T/MYp5+cVIaFnSozqtb
         61HPJ6UD0ETAQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/5] selftests: net: test IPV6_HOPLIMIT
Date:   Wed, 16 Feb 2022 17:21:19 -0800
Message-Id: <20220217012120.61250-5-kuba@kernel.org>
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

Test setting IPV6_HOPLIMIT via setsockopt and cmsg
across socket types.

Output without the kernel support (this series):

  Case HOPLIMIT ICMP cmsg - packet data returned 1, expected 0
  Case HOPLIMIT ICMP diff - packet data returned 1, expected 0

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_ipv6.sh  | 31 +++++++++++++++++++++++
 tools/testing/selftests/net/cmsg_sender.c | 19 +++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_ipv6.sh b/tools/testing/selftests/net/cmsg_ipv6.sh
index f7bb6ce68c88..e42c36e0d741 100755
--- a/tools/testing/selftests/net/cmsg_ipv6.sh
+++ b/tools/testing/selftests/net/cmsg_ipv6.sh
@@ -106,6 +106,37 @@ for ovr in setsock cmsg both diff; do
     done
 done
 
+# IPV6_HOPLIMIT
+LIM=4
+
+for ovr in setsock cmsg both diff; do
+    for p in u i r; do
+	[ $p == "u" ] && prot=UDP
+	[ $p == "i" ] && prot=ICMP
+	[ $p == "r" ] && prot=RAW
+
+	[ $ovr == "setsock" ] && m="-L"
+	[ $ovr == "cmsg" ]    && m="-l"
+	[ $ovr == "both" ]    && m="-L $LIM -l"
+	[ $ovr == "diff" ]    && m="-L $((LIM + 1)) -l"
+
+	$NSEXE nohup tcpdump --immediate-mode -p -ni dummy0 -w $TMPF -c 4 2> /dev/null &
+	BG=$!
+	sleep 0.05
+
+	$NSEXE ./cmsg_sender -6 -p $p $m $LIM $TGT6 1234
+	check_result $? 0 "HOPLIMIT $prot $ovr - pass"
+
+	while [ -d /proc/$BG ]; do
+	    $NSEXE ./cmsg_sender -6 -p u $TGT6 1234
+	done
+
+	tcpdump -r $TMPF -v 2>&1 | grep "hlim $LIM[^0-9]" >> /dev/null
+	check_result $? 0 "HOPLIMIT $prot $ovr - packet data"
+	rm $TMPF
+    done
+done
+
 # Summary
 if [ $BAD -ne 0 ]; then
     echo "FAIL - $BAD/$TOTAL cases failed"
diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 4033cf93eabf..6136aa7df1c4 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -47,6 +47,7 @@ struct options {
 		unsigned int mark;
 		unsigned int dontfrag;
 		unsigned int tclass;
+		unsigned int hlimit;
 	} sockopt;
 	struct {
 		unsigned int family;
@@ -64,6 +65,7 @@ struct options {
 	struct {
 		struct option_cmsg_u32 dontfrag;
 		struct option_cmsg_u32 tclass;
+		struct option_cmsg_u32 hlimit;
 	} v6;
 } opt = {
 	.size = 13,
@@ -95,6 +97,8 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 	       "\t\t-F val  Set don't fragment via setsockopt\n"
 	       "\t\t-c val  Set TCLASS via cmsg\n"
 	       "\t\t-C val  Set TCLASS via setsockopt\n"
+	       "\t\t-l val  Set HOPLIMIT via cmsg\n"
+	       "\t\t-L val  Set HOPLIMIT via setsockopt\n"
 	       "");
 	exit(ERN_HELP);
 }
@@ -103,7 +107,7 @@ static void cs_parse_args(int argc, char *argv[])
 {
 	char o;
 
-	while ((o = getopt(argc, argv, "46sS:p:m:M:d:tf:F:c:C:")) != -1) {
+	while ((o = getopt(argc, argv, "46sS:p:m:M:d:tf:F:c:C:l:L:")) != -1) {
 		switch (o) {
 		case 's':
 			opt.silent_send = true;
@@ -158,6 +162,13 @@ static void cs_parse_args(int argc, char *argv[])
 		case 'C':
 			opt.sockopt.tclass = atoi(optarg);
 			break;
+		case 'l':
+			opt.v6.hlimit.ena = true;
+			opt.v6.hlimit.val = atoi(optarg);
+			break;
+		case 'L':
+			opt.sockopt.hlimit = atoi(optarg);
+			break;
 		}
 	}
 
@@ -215,6 +226,8 @@ cs_write_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 			  SOL_IPV6, IPV6_DONTFRAG, &opt.v6.dontfrag);
 	ca_write_cmsg_u32(cbuf, cbuf_sz, &cmsg_len,
 			  SOL_IPV6, IPV6_TCLASS, &opt.v6.tclass);
+	ca_write_cmsg_u32(cbuf, cbuf_sz, &cmsg_len,
+			  SOL_IPV6, IPV6_HOPLIMIT, &opt.v6.hlimit);
 
 	if (opt.txtime.ena) {
 		struct sock_txtime so_txtime = {
@@ -360,6 +373,10 @@ static void ca_set_sockopts(int fd)
 	    setsockopt(fd, SOL_IPV6, IPV6_TCLASS,
 		       &opt.sockopt.tclass, sizeof(opt.sockopt.tclass)))
 		error(ERN_SOCKOPT, errno, "setsockopt IPV6_TCLASS");
+	if (opt.sockopt.hlimit &&
+	    setsockopt(fd, SOL_IPV6, IPV6_UNICAST_HOPS,
+		       &opt.sockopt.hlimit, sizeof(opt.sockopt.hlimit)))
+		error(ERN_SOCKOPT, errno, "setsockopt IPV6_HOPLIMIT");
 }
 
 int main(int argc, char *argv[])
-- 
2.34.1

