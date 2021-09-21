Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A156641374F
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbhIUQTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbhIUQSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:30 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2273C061762;
        Tue, 21 Sep 2021 09:17:00 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h17so76523564edj.6;
        Tue, 21 Sep 2021 09:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qzSzcBiAygB368FHnqyMm4HmQ/+EU21PkgWKIufGPUI=;
        b=N9w751/z5zSxSkpIR7c39xPDws3A/lhRJVP+XVDvwejBnoghB60u6DRTczpsQHRzlD
         lfoeyTw1HuZ9NQAy6Sa07aJnOAa105W4jvlPXtH22OwLUqz5Pdm4bsfN/lc7nfWkS+cv
         qGqGtIZdsbg3sWgUkoXWzvCtmL+JbpVDx9e55Eha67olftneHLq+JcfQYykxydv7Ftyw
         tuHio+onX/zgr4WeJeHwfZGgzMHA/mAwJJryQ6ZR7u/vxWlCqyxptc5V+Jz5g667M5Wu
         fCvbBIaCwSUGwVv6FjFE7JeUci7v9Qjgu1Fs3gC//ughBOf3p+oyKHE6m/SWsjURZ/Qj
         eZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qzSzcBiAygB368FHnqyMm4HmQ/+EU21PkgWKIufGPUI=;
        b=KcqY9ifKXvH+oJY2SIJnaj1MlmoEs4hkV3KD5uo96PONXBHcCHwBP++Pe2RuFZcM61
         FYVH2PQWqda5t3wQqIji4Lmw20N0I1PpTE9x+9K+Yown24gJjWx7PRDQCKe428X49mjj
         IrpDw3jJWmYOIqKz019jk3YgUh5R6U1P3jP7GQClIECJ6NiS/+4nTcFyhmZ3HrPeGK7p
         Rme2R3ysAusCpI85Cqwi6oEgPOwovtWVJwXXT8YRNY0V0sN+iKfbUGZZJFGF51BoeSNz
         kBrZ+ULF2GJCSg/tt373cc3e8yCQUxLyvrIqbUZUhZjMVE87Wnyrh9FFB/x7MkSzWSxD
         C1wg==
X-Gm-Message-State: AOAM532XuQyvuVHWW036H6rYhNS1DWwgqz8saN1a5A6YsyAhKDVeIZ61
        8FSf3IMSD8Djv9qAu7NmeQ4=
X-Google-Smtp-Source: ABdhPJxQRtR6CUvuGguGGsL9kDkUgBeyz49aPVCISKh47OYKF0j0wGgG/BgifNGX1gZNQjKywCqMjQ==
X-Received: by 2002:a17:906:7802:: with SMTP id u2mr35684454ejm.325.1632240944668;
        Tue, 21 Sep 2021 09:15:44 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:44 -0700 (PDT)
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
Subject: [PATCH 16/19] selftests: Initial tcp_authopt support for fcnal-test
Date:   Tue, 21 Sep 2021 19:14:59 +0300
Message-Id: <694da73ec4367c97cbaf9c17eec0db4edfe25c48.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
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
index 13350cd5c8ac..74a7580b6bde 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -791,10 +791,31 @@ ipv4_ping()
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
@@ -1122,10 +1143,11 @@ ipv4_tcp_novrf()
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

