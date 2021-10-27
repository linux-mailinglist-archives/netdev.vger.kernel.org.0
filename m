Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6B943C0DB
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 05:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbhJ0Diu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 23:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239136AbhJ0Dir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 23:38:47 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256B3C061570;
        Tue, 26 Oct 2021 20:36:22 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s24so1077946plp.0;
        Tue, 26 Oct 2021 20:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pYPb2efyJzQDBhhqjROUGYTPzR3Jqq7+OMajb/dAad8=;
        b=BFqWmCbqZlHgNOPOrWFoxIH+MCAyXjsTf1gje85IHA99GeViPO/+n6IvksCATFf3EF
         WHVMKEoVzoJTWD1I1DEEmI3zyHjVnlR0XanbY+8BE2v5zobYZCOlyznK1Agdxhl6OjXs
         weJCBEoCKmIii1TcJ7C2UPuWGKgnnXj2uU9inZ485KbllLudfmIhC5Hm3wSW+AiI/W1M
         hl2SMlOSk7UeVIWUy9omaqj5aUWaBDMOf1ojHGdv2cSewVMumMeccyAJ6R0nwup7r6K3
         fxO5gKqp/Z44/O04WbksAjVuhjZN8TkYp43ADld5CScJzaDrOnvGP2LKJrSKKMPd6ML+
         gUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pYPb2efyJzQDBhhqjROUGYTPzR3Jqq7+OMajb/dAad8=;
        b=nk6tw/vEpaKob5R9/3mL794fZwi54KiyVAvzMnkzOqZj/BweiK7Teu+AunE8BIWd9R
         E9DvlIQ4W94uUh6kzQnZUMt3TVvOB77KNnS3J82Kq/cfH0UZjxyFNtRmWZRAvBWv9Esi
         Kk9CZiiTa91YqReuoFxWt9DpP1Dt7EqWwMOL//pObhR2YFMgRBUqkdI1VaoWA5l9chbM
         uD//WXwoUUHRas688Ffr2mRMYeKs7YlE2gWnZ7/GQdbQqyhZ9qBwn2xrblIf4whbTd1B
         wTMDzGtNkPcuES2rhz5t94dDZqwMCFnJUGCqXzzSEZ1+MwfAQut5SO3EUBLiyWqPt6WE
         1n4Q==
X-Gm-Message-State: AOAM5323xO/2iLD3o0Su/ANJ0AitFBs0AThtSGHObVpWp8ubpjIeZ62j
        0suzFzV/9PyBCV0xRLF2VhSeVO+V6Cs=
X-Google-Smtp-Source: ABdhPJxKchfPfShR0g8TsT8phBlwoKhort+IvGCE1nf3z9Uyj6JxGXFfShyH+MH7KTSL1iBbpPPsCw==
X-Received: by 2002:a17:90b:4c4a:: with SMTP id np10mr3078589pjb.233.1635305781490;
        Tue, 26 Oct 2021 20:36:21 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p1sm12080847pfo.143.2021.10.26.20.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 20:36:21 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-kselftest@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 4/4] selftests/bpf/xdp_redirect_multi: limit the tests in netns
Date:   Wed, 27 Oct 2021 11:35:53 +0800
Message-Id: <20211027033553.962413-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027033553.962413-1-liuhangbin@gmail.com>
References: <20211027033553.962413-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As I want to test both DEVMAP and DEVMAP_HASH in XDP multicast redirect,
I limited DEVMAP max entries to a small value for performace. When the
test runs after amount of interface creating/deleting tests. The
interface index will exceed the map max entries and xdp_redirect_multi
will error out with "Get interfacesInterface index to large".

Fix this issue by limit the tests in netns and specify the ifindex when
creating interfaces.

Reported-by: Jiri Benc <jbenc@redhat.com>
Fixes: d23292476297 ("selftests/bpf: Add xdp_redirect_multi test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 23 ++++++++++++-------
 .../selftests/bpf/xdp_redirect_multi.c        |  4 ++--
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
index 37e347159ab4..bedff7aa7023 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -2,11 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # Test topology:
-#     - - - - - - - - - - - - - - - - - - - - - - - - -
-#    | veth1         veth2         veth3 |  ... init net
+#    - - - - - - - - - - - - - - - - - - -
+#    | veth1         veth2         veth3 |  ns0
 #     - -| - - - - - - | - - - - - - | - -
 #    ---------     ---------     ---------
-#    | veth0 |     | veth0 |     | veth0 |  ...
+#    | veth0 |     | veth0 |     | veth0 |
 #    ---------     ---------     ---------
 #       ns1           ns2           ns3
 #
@@ -51,6 +51,7 @@ clean_up()
 		ip link del veth$i 2> /dev/null
 		ip netns del ns$i 2> /dev/null
 	done
+	ip netns del ns0 2> /dev/null
 }
 
 # Kselftest framework requirement - SKIP code is 4.
@@ -78,10 +79,12 @@ setup_ns()
 		mode="xdpdrv"
 	fi
 
+	ip netns add ns0
 	for i in $(seq $NUM); do
 	        ip netns add ns$i
-	        ip link add veth$i type veth peer name veth0 netns ns$i
-		ip link set veth$i up
+		ip -n ns$i link add veth0 index 2 type veth \
+			peer name veth$i netns ns0 index $((1 + $i))
+		ip -n ns0 link set veth$i up
 		ip -n ns$i link set veth0 up
 
 		ip -n ns$i addr add 192.0.2.$i/24 dev veth0
@@ -92,7 +95,7 @@ setup_ns()
 			xdp_dummy.o sec xdp_dummy &> /dev/null || \
 			{ test_fail "Unable to load dummy xdp" && exit 1; }
 		IFACES="$IFACES veth$i"
-		veth_mac[$i]=$(ip link show veth$i | awk '/link\/ether/ {print $2}')
+		veth_mac[$i]=$(ip -n ns0 link show veth$i | awk '/link\/ether/ {print $2}')
 	done
 }
 
@@ -177,9 +180,13 @@ do_tests()
 		xdpgeneric) drv_p="-S";;
 	esac
 
-	./xdp_redirect_multi $drv_p $IFACES &> ${LOG_DIR}/xdp_redirect_${mode}.log &
+	ip netns exec ns0 ./xdp_redirect_multi $drv_p $IFACES &> ${LOG_DIR}/xdp_redirect_${mode}.log &
 	xdp_pid=$!
 	sleep 1
+	if ! ps -p $xdp_pid > /dev/null; then
+		test_fail "$mode xdp_redirect_multi start failed"
+		return 1
+	fi
 
 	if [ "$mode" = "xdpegress" ]; then
 		do_egress_tests $mode
@@ -190,7 +197,7 @@ do_tests()
 	kill $xdp_pid
 }
 
-trap clean_up 0 2 3 6 9
+trap clean_up EXIT
 
 check_env
 
diff --git a/tools/testing/selftests/bpf/xdp_redirect_multi.c b/tools/testing/selftests/bpf/xdp_redirect_multi.c
index 3696a8f32c23..f5ffba341c17 100644
--- a/tools/testing/selftests/bpf/xdp_redirect_multi.c
+++ b/tools/testing/selftests/bpf/xdp_redirect_multi.c
@@ -129,7 +129,7 @@ int main(int argc, char **argv)
 		goto err_out;
 	}
 
-	printf("Get interfaces");
+	printf("Get interfaces:");
 	for (i = 0; i < MAX_IFACE_NUM && argv[optind + i]; i++) {
 		ifaces[i] = if_nametoindex(argv[optind + i]);
 		if (!ifaces[i])
@@ -139,7 +139,7 @@ int main(int argc, char **argv)
 			goto err_out;
 		}
 		if (ifaces[i] > MAX_INDEX_NUM) {
-			printf("Interface index to large\n");
+			printf(" interface index too large\n");
 			goto err_out;
 		}
 		printf(" %d", ifaces[i]);
-- 
2.31.1

