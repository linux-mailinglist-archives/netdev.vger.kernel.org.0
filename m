Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF093F6B32
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238863AbhHXVgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237379AbhHXVgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:32 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D354C061757;
        Tue, 24 Aug 2021 14:35:48 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y5so2955323edp.8;
        Tue, 24 Aug 2021 14:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o1q66kQcIlqRZtVzgdzH7H6flHDFaGUIbY6SHa97BBU=;
        b=K4Z8KGR+jCa3o6ucKVT/tgVJDZCnlJwv5te6jvvOXoatXdiNpMh0h56jvdO7CnlvQK
         irydMzE2qSzAOI9ftly8hstALXxmP6duP8v1OivxyEexL0x5QsEDMdxzBAJ1TRevlUus
         5rQtvv1fQJRNqv9nz1M8OxuvKgkVlzhNqJy57P5gUi+wmPlXYPp/ZIhJTvHNdJ20UutD
         VA6UOKHuEDUDXwwSMB0/sAQc4mwJNYPKdWrf8UWgLxvt6lUeow/HnZ2jTmTbxEI+eKYu
         GP59NUmc6mZKXk4IhaOgiNYwZbO0ptmkOgq9D5Zo1briUrMWPTs41P7xanxclJ9ERWkr
         vFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o1q66kQcIlqRZtVzgdzH7H6flHDFaGUIbY6SHa97BBU=;
        b=YEtsvhKs7wphP04LtoyTIEAN46d2GtO41h6H8p5XQr5WoyhEef48+lp+s4JFnARueb
         TnZqlztLHJjVPgjesOU4bmKFkLKkfIUBNTqMPEDa4P19qZJ3VptQw8MLAbZiYf6YxaqM
         61EzdvKcYQ4RDiTcIsVTxv7EwAVVcKhNElfAfKcneg0l0EzsRsidZ0DtBJTKM859cv6k
         fg2pyyS5B8snr8F32h2FbX6AP2cxMAbHlxkfY7BNTC39RKSYhmamctpOyhUw6P2eXIpd
         oZfowev7qz7jCIiN2ZGE/Bus9yxIoL8u/8rF0ScT6Nj3Sb48xHzIgaSx/VEUqifnRfh4
         nY9w==
X-Gm-Message-State: AOAM53193IJapuG2aHY3V2FTZxyNJNOMD63u2Fz7D0IRGo2f6NbBr+4f
        k7YzU7XQwn7ZKxFmAFyX1xg=
X-Google-Smtp-Source: ABdhPJzOZx6SF9+0Ap+6abBGpVvSgeuLwpb01+oXC16D7hIRphf5CLmHXX+3/pKROPO1UaI4EpmoiQ==
X-Received: by 2002:a50:ef11:: with SMTP id m17mr44400009eds.233.1629840946792;
        Tue, 24 Aug 2021 14:35:46 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:46 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFCv3 12/15] selftests: Initial tcp_authopt support for fcnal-test
Date:   Wed, 25 Aug 2021 00:34:45 +0300
Message-Id: <a87b8c675d7bb0d537e1ca43000925b56d9dcb0e.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just test that a correct password is passed or otherwise a timeout is
obtained.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 162e5f1ac36b..ca3b90f6fecb 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -788,10 +788,31 @@ ipv4_ping()
 }
 
 ################################################################################
 # IPv4 TCP
 
+#
+# TCP Authentication Option Tests
+#
+ipv4_tcp_authopt()
+{
+	# basic use case
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: Simple password"
+
+	# wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -s -A ${MD5_PW} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: Client uses wrong password"
+}
+
 #
 # MD5 tests without VRF
 #
 ipv4_tcp_md5_novrf()
 {
@@ -1119,10 +1140,11 @@ ipv4_tcp_novrf()
 	show_hint "Should fail 'Connection refused'"
 	run_cmd nettest -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
 	ipv4_tcp_md5_novrf
+	ipv4_tcp_authopt
 }
 
 ipv4_tcp_vrf()
 {
 	local a
-- 
2.25.1

