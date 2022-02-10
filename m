Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1C4B02F0
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiBJCCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:02:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbiBJCAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:00:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26E0D7E;
        Wed,  9 Feb 2022 17:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4E9DB823DD;
        Thu, 10 Feb 2022 00:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF63C340F0;
        Thu, 10 Feb 2022 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453418;
        bh=N9tNyaSe13ZsZP0RzUXjkyzbyMgwkUgB1xYpc7beNQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzCzIAZp45+AxnLAY54P3aU9h99uvWGqx0N9Fw7chNGk2EvykHsCaSlIUPeR108/X
         84ntTWUftyNFFonJYTI4KnvFlNVJxTRW4U/+DNCLSXZm7FcjeevIJO9fQcN5tLa7xH
         QNu9Ett+6jtuXD9qvR3OUBjmJR5KvkYVhYcTWbq7pKymqZwW4NXIQJzQPTmnQ0R+RV
         IxyFFxGjYmI2gEYieaO7JWBx59Fi4dPP+5CHKKBFPcM2Z1SSiVrU/ncmEYlu/3iJSD
         srQA8UF5QwDYXIQQ/+rWRXXSXzGjmzugE7XZENMekFDPufBW6uPBjlhErq7MmlH31F
         VNZ1f7JmgbYTA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/11] selftests: net: cmsg_so_mark: test with SO_MARK set by setsockopt
Date:   Wed,  9 Feb 2022 16:36:46 -0800
Message-Id: <20220210003649.3120861-9-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210003649.3120861-1-kuba@kernel.org>
References: <20220210003649.3120861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test if setting SO_MARK with setsockopt works and if cmsg
takes precedence over it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_sender.c   | 14 ++++++++++-
 tools/testing/selftests/net/cmsg_so_mark.sh | 28 +++++++++++++--------
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index edb8c427c7cb..c7586a4b0361 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -29,6 +29,9 @@ struct options {
 	bool silent_send;
 	const char *host;
 	const char *service;
+	struct {
+		unsigned int mark;
+	} sockopt;
 	struct {
 		unsigned int family;
 		unsigned int type;
@@ -56,6 +59,7 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 	       "\t\t        (u = UDP (default); i = ICMP; r = RAW)\n"
 	       "\n"
 	       "\t\t-m val  Set SO_MARK with given value\n"
+	       "\t\t-M val  Set SO_MARK via setsockopt\n"
 	       "");
 	exit(ERN_HELP);
 }
@@ -64,7 +68,7 @@ static void cs_parse_args(int argc, char *argv[])
 {
 	char o;
 
-	while ((o = getopt(argc, argv, "46sp:m:")) != -1) {
+	while ((o = getopt(argc, argv, "46sp:m:M:")) != -1) {
 		switch (o) {
 		case 's':
 			opt.silent_send = true;
@@ -91,6 +95,9 @@ static void cs_parse_args(int argc, char *argv[])
 			opt.mark.ena = true;
 			opt.mark.val = atoi(optarg);
 			break;
+		case 'M':
+			opt.sockopt.mark = atoi(optarg);
+			break;
 		}
 	}
 
@@ -175,6 +182,11 @@ int main(int argc, char *argv[])
 		sin6->sin6_port = htons(opt.sock.proto);
 	}
 
+	if (opt.sockopt.mark &&
+	    setsockopt(fd, SOL_SOCKET, SO_MARK,
+		       &opt.sockopt.mark, sizeof(opt.sockopt.mark)))
+		error(ERN_SOCKOPT, errno, "setsockopt SO_MARK");
+
 	iov[0].iov_base = buf;
 	iov[0].iov_len = sizeof(buf);
 
diff --git a/tools/testing/selftests/net/cmsg_so_mark.sh b/tools/testing/selftests/net/cmsg_so_mark.sh
index 925f6b9deee2..1650b8622f2f 100755
--- a/tools/testing/selftests/net/cmsg_so_mark.sh
+++ b/tools/testing/selftests/net/cmsg_so_mark.sh
@@ -43,19 +43,27 @@ check_result() {
     fi
 }
 
-for i in 4 6; do
-    [ $i == 4 ] && TGT=$TGT4 || TGT=$TGT6
+for ovr in setsock cmsg both; do
+    for i in 4 6; do
+	[ $i == 4 ] && TGT=$TGT4 || TGT=$TGT6
 
-    for p in u i r; do
-	[ $p == "u" ] && prot=UDP
-	[ $p == "i" ] && prot=ICMP
-	[ $p == "r" ] && prot=RAW
+	for p in u i r; do
+	    [ $p == "u" ] && prot=UDP
+	    [ $p == "i" ] && prot=ICMP
+	    [ $p == "r" ] && prot=RAW
 
-	ip netns exec $NS ./cmsg_sender -$i -p $p -m $((MARK + 1)) $TGT 1234
-	check_result $? 0 "$prot pass"
+	    [ $ovr == "setsock" ] && m="-M"
+	    [ $ovr == "cmsg" ]    && m="-m"
+	    [ $ovr == "both" ]    && m="-M $MARK -m"
 
-	ip netns exec $NS ./cmsg_sender -$i -p $p -m $MARK -s $TGT 1234
-	check_result $? 1 "$prot rejection"
+	    ip netns exec $NS ./cmsg_sender -$i -p $p $m $((MARK + 1)) $TGT 1234
+	    check_result $? 0 "$prot $ovr - pass"
+
+	    [ $ovr == "diff" ] && m="-M $((MARK + 1)) -m"
+
+	    ip netns exec $NS ./cmsg_sender -$i -p $p $m $MARK -s $TGT 1234
+	    check_result $? 1 "$prot $ovr - rejection"
+	done
     done
 done
 
-- 
2.34.1

