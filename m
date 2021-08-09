Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00FA3E4E9F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbhHIVgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbhHIVgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:36:24 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A946EC0617B9;
        Mon,  9 Aug 2021 14:36:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id f13so26778707edq.13;
        Mon, 09 Aug 2021 14:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E3jO1mj7XUbGg6uQHpuj74IXQp0/lQKR6D9BzqtSWcA=;
        b=I71UQb+QKnUupszJxZVDzmKvLYD7kslD5ooI8iSAqN2k8U34BNmaQuSDO9XxwdsIVP
         /8uGJzl3K9gCBEQngHEIfA4BQdBx3WttcUoO6bv8oLi/TZsncKkCYKysIMjwTdePJWh9
         uMpZ06bub9LQxmiHMyF0BkEzMjrCMyVPplegHvB6HkHVTbhFKO6D04Zd9HovtYLZ1Pcw
         MnIF+x949ZQAkBUmWIGDTCE2WKwyB714+EE05jc7rAbpjkK+b82Gt3pMRrL4aIcPbFSa
         deXduyAB2SjCEvylx1Oh4w5joGBu8Ar3A41v8FLTilCPt3db5EkEs782+LNmofZVaOnx
         32xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E3jO1mj7XUbGg6uQHpuj74IXQp0/lQKR6D9BzqtSWcA=;
        b=f/xpbJfC7ke1S2w4992a/F7FsExzcte+EIS5WP+iZC7HrZgvER2cPSeMLHu6McX2Dv
         Z+9OFHB6QP/wPlMx664gdvatSSVG0sT+slVZTJEelXTNlXb7fGS2FHDvLZVHpoqrSvc8
         YPTmFTpolOWE/qFlvuPC5Vk/lkw9CuDsbEpOBAC7NDLTB1qQQTt/shvR7sXBj+gSNAEn
         V4nYmV+DLSonrTTD5LDWlLEsZaNb5OzKmjvMfUqk4wf58u9Ken9H0pL7T4onD5gLGktf
         FXyeVz2T7Ubk8fkqQt7YIL414Fv0xBZJTFsiUc3ak0Sp1L+ev4OXYryVCj6jddoc3NJ+
         W+wA==
X-Gm-Message-State: AOAM533ZHUr1J9wCb9JkbB94bcxdd1dBi47hopPU1S83t6EIGwBND6VU
        5+DiYKiklXYyjc8pMYEftiw=
X-Google-Smtp-Source: ABdhPJwN7vsmxv9PK+2n1Up1zehgDiPvQ0UZ47UNLzhNZQYMd6xZrIEOS7Y16G0S1+7febRMZp3d1g==
X-Received: by 2002:a05:6402:214a:: with SMTP id bq10mr472497edb.296.1628544961303;
        Mon, 09 Aug 2021 14:36:01 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:688d:23e:82c6:84aa])
        by smtp.gmail.com with ESMTPSA id v24sm5542932edt.41.2021.08.09.14.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:36:00 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFCv2 9/9] selftests: Initial TCP-AO support for fcnal-test
Date:   Tue, 10 Aug 2021 00:35:38 +0300
Message-Id: <3f6d654c1c36f489b471e2892c9231d6fa8fad7a.1628544649.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1628544649.git.cdleonard@gmail.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just test that a correct password is required.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index a8ad92850e63..569c340040f4 100755
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

