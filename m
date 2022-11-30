Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7681A63D7A9
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiK3OHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiK3OHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:25 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784837721B
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:06:59 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ha10so41656030ejb.3
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJH7/Ya+JyhHFNUH8pzKI3Kt+nJBKR+LqkahaTkfV5I=;
        b=N8NKMeRx8eBoPndC0IEgHED+IAsMA6L1HKjkGU1xUTt0TJ5NdQfo7JNV6/ezwVk1pX
         FxoASo3jluQDvBFl7h5iM4eORI0rXG0egaGqluwsV2vH+3ZF2aHxjRiI6MRlT/5JPVJQ
         iyF/IPa59hFeVo1lIMS+AhE4Ky++In1nQ3S381aGdwBNZc7m8fccTPJabNujGCFtQYA9
         k/Hn8Yeencmut/lCGql1siRDF9kDmTxk/OaARbRfDBbJynmzQwMfr/FZTZD14J6N8u8l
         e3d/E2GMFqmKgBys0T4j8q5JYjKF8JphuFmHdw3iqxidvNAMqBwGuSk0eZKKzlyefG8g
         In4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJH7/Ya+JyhHFNUH8pzKI3Kt+nJBKR+LqkahaTkfV5I=;
        b=RvWmTwRp0VuIijXuNigVoeuPKa7VnJEDXVTu/sezD7gAJxhd4tzcSKjksB8gCKCJgM
         pf36/9W4VtHv2Bz5q/nU62xTcYB0k5mzVemS8xBE/CtT7ZTGZeGyfVnfDEoH2XOi6TXs
         NUV2M4wbVANO5no9e7+AcvMbQYLXcBn+FJUzLqw7U7QubqxrcslEYBeE8e0IX9IiEnt0
         /I+4yo4zzdRp3YrXKpgMnFXYWZAiXoVqpCG0O4JMS2pHY2/of0aJp5qJDx9Z4MgMHcZj
         YaCyMTgT2bMr18iRzEDixRfbfuAD+fchNoNuxb9asX02xaaJsjVkHAks5wAWoCqeC6cS
         hP6g==
X-Gm-Message-State: ANoB5pna5fkAdY9HBb6Xyc9DyJmx/F7ahICD5ajDTetcylnu6F9/uBdv
        cll54hGHbpqkaYc9o3myLw6LmA==
X-Google-Smtp-Source: AA0mqf4Lkeav61h8g7hIlIxLe2otfwL1RA9e2hfJzeHqtmbHlqQ8FAE7SI3tg9X+iRkCatYOSCRI3w==
X-Received: by 2002:a17:906:6dd5:b0:78d:a633:b55 with SMTP id j21-20020a1709066dd500b0078da6330b55mr54279279ejt.106.1669817217863;
        Wed, 30 Nov 2022 06:06:57 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:06:57 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/11] selftests: mptcp: removed defined but unused vars
Date:   Wed, 30 Nov 2022 15:06:24 +0100
Message-Id: <20221130140637.409926-3-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2295; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=x2a5qXK0yM6mpMP24fRnfIxNbSZvxgQ2hoKgZvqEjqI=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2NoxlLLl9Cj2G+5X81Y1LEfhwImH+JGnKgyGGmf
 RrADQnyJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djaAAKCRD2t4JPQmmgc4ATD/
 9eQFrcQ4TSgTaUEypoG6ENRiEGmyIJVDitTU5FxirYDYwZ2a7nife79aF2LHWEj1fVbb9eIGJa6X0d
 Ec3fPSmG6hO+NgWFQmu/fE9KzxJgf/aNqHbB6NQtz4ImrUlsGxxB7ft94p7tSTsjQ+/lYuf/11IR4m
 74zppZAVKtrDHalU+/iNg4sO/VrxRFk4JyCDbyQRLulobTMzReyClTEdUEXkFujwDHsPsKQavoZtAa
 TkbYHuzqAeWGDaU9mHi20vuRNYg+OptrRebS1XTOlkM4sWCwIhhN5LGd4P6HVMGWbFnUUrBqUkOf9P
 0DX0od4qK2T2W6+q0mPFij0NfMbFzlIOiNcbG82H+SA3as/iROZotRk76V5kUX1lcxcg38abayrCjI
 VrpIYrPn2smzUtNVDI7g4Luve1InQAZspJGcYPhQjUz5MEc9ZBaMJZl85K7RfytiLV/krj+fWxSe4F
 f37+0qdI4HsvO6PWegJkY3WcFaFXPOkp2n/CGERnVuzQvsZPA3UhQHbYAhgYILgQSxguJFD0GQOo7+
 HDMiQLWjNzDazSGJBco7ISmH2PZOF9/OPk7305DWhp/v7OamYSjXuzQ48UIYjE7YZ34qZD7gJGwsUq
 jdGSzCbeIEhMGaflUu9pvPm18L15IvRC1WrbByY97R6BrTj7uawSALMxVEJw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some variables were set but never used.

This was not causing any issues except adding some confusion and having
shellcheck complaining about them.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 3 ---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh | 1 -
 tools/testing/selftests/net/mptcp/simult_flows.sh  | 3 ---
 3 files changed, 7 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 60198b91a530..63b722b505e5 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -781,7 +781,6 @@ run_tests_mptfo()
 
 run_tests_disconnect()
 {
-	local peekmode="$1"
 	local old_cin=$cin
 	local old_sin=$sin
 
@@ -789,7 +788,6 @@ run_tests_disconnect()
 
 	# force do_transfer to cope with the multiple tranmissions
 	sin="$cin.disconnect"
-	sin_disconnect=$old_sin
 	cin="$cin.disconnect"
 	cin_disconnect="$old_cin"
 	connect_per_transfer=3
@@ -800,7 +798,6 @@ run_tests_disconnect()
 
 	# restore previous status
 	sin=$old_sin
-	sin_disconnect="$cout".disconnect
 	cin=$old_cin
 	cin_disconnect="$cin".disconnect
 	connect_per_transfer=1
diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index 8a83100b212e..6e8f4599cc44 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -10,7 +10,6 @@ ksft_skip=4
 timeout_poll=30
 timeout_test=$((timeout_poll * 2 + 1))
 mptcp_connect=""
-do_all_tests=1
 
 add_mark_rules()
 {
diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index a5aeefd58ab3..189a664aed81 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -148,9 +148,6 @@ do_transfer()
 	:> "$sout"
 	:> "$capout"
 
-	local addr_port
-	addr_port=$(printf "%s:%d" ${connect_addr} ${port})
-
 	if $capture; then
 		local capuser
 		if [ -z $SUDO_USER ] ; then
-- 
2.37.2

