Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9462367B040
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbjAYKtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235758AbjAYKsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:48:45 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4240856EE6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:11 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so932657wma.1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mjFauu1ty8EOKl/zKVHOIwAbYvDY0AH2ut63+GQyyss=;
        b=HyC9KJ++wPd79JT3e3Qj+7xb4QbvFGvjgEC93RX+0LRO3IvjUyFbu98HL12BDWijfg
         V9rl/j/+T+IRK2Au/LWPs6yPXW5rg1iKTb2mTnyL0MQ9CsZL5NjZumRMjqibqvQ0sMdB
         q9z1+gUsTsHxOzHqvcFtVxhpESMuDzBdEX0bvLVnzflMiOI890oJvvOzO80me8t1dYBI
         80JsEJZ+fF4xJ/JOR7UFgGAHlD8ZL7fIUdbujDrFEu2SG9NcsjRf5wxixv+TeZVg1WcI
         cwaaZ/nVKUHfasrzFU78oY6xpJJjWfZ4LMsSdyYGGw1OX+3dtyuzt5t45E9EZELs1fda
         a5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mjFauu1ty8EOKl/zKVHOIwAbYvDY0AH2ut63+GQyyss=;
        b=FuslyXGXymyb44L5c55046aoKybGOY+UrqVRw9Lo7x627/8lm+AmWGPmqiFY1hL9SW
         e52onbGMEE2+kjA3M2C6zf5acfSQ1upKuyjOb+KsBNH7pWReGQ939Q4RicL0TY6ET5Py
         6hIK8rRR5W+tKik5eKA18dGVhqAMrses0ZhrcozPieHlTR+EHR8jSaFTe1RdPcAyViYz
         nUjLq5ze74GKTD0DDPzP0aoxHpjNWX++dmmWCiqnJTcsOI+NQR6tgNzCNOQ3ThT9P5KJ
         xdM/ElKillEE1gZqtpk3WiRspHrKMNGttAW+BlcQfawsdxnsr5DcrXIiFTawhoO5gosn
         S+/Q==
X-Gm-Message-State: AFqh2kpv6ycUOss0rySb+Z3jHYe+mjpLcP08AMW6KYtgTAmY0AjmCV3T
        HwYXTwjz19NtNBkilm7UT7VmDA==
X-Google-Smtp-Source: AMrXdXsm6QiSIL1qqdqKiXpYNpiBJkeGjOybgfRqpEtAKDjWn6+pasYOOg9Y/LTMg49h5Xho9eyrmQ==
X-Received: by 2002:a05:600c:1c01:b0:3c6:e63e:23e9 with SMTP id j1-20020a05600c1c0100b003c6e63e23e9mr31559003wms.24.1674643682135;
        Wed, 25 Jan 2023 02:48:02 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id r1-20020a05600c424100b003d9a86a13bfsm1423692wmm.28.2023.01.25.02.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 02:48:01 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 25 Jan 2023 11:47:23 +0100
Subject: [PATCH net-next 3/8] selftests: mptcp: add test-cases for mixed
 v4/v6 subflows
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230123-upstream-net-next-pm-v4-v6-v1-3-43fac502bfbf@tessares.net>
References: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
In-Reply-To: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Mailer: b4 0.12.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3323;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=Svwm/hHROTGkPV1oEQjfcOQoXpkUYph8n6kw7hTzaOQ=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj0QjdQmoYk+cbOI+cC/+J4PUVg46ofuGSiHtcZEX/
 2OH+ZVyJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY9EI3QAKCRD2t4JPQmmgc4oUEA
 C/7IaxF/dQF3FtSHdqXw/vY0N98/sb2efy3A1nA/RWfkRFiA3Zr2vLyXEkXk9JdxgeXWALgDAcivbJ
 r3hEBDiZ734LGnzYz4dq2jPNgn7PDJsR+ypB6fKRYWzGsoaBS0McHnwrEcLCowLsAVuS1jk9j4KuWq
 73/X8JG/euwgYo86Ycs3HydoVaEjs4ngfIiO5Ut1vEkuqWoX4o8BLDkkh0YNHoq12XZ7JYyPgVi2+7
 vPM45W00RVk9ikMdgem+v1+xeTOgBC4F0kD2tod2IBfQEZ7vyH/i0jKMBXdTY8sjFTIz8vs1QvejT/
 xIunWCXjsoY4RGXjM3PZEUx2Vtk7rI+bEQnMOA2E4N4LtVEm3gvJSAuGCQvQ+53S4zxpCVRxNXm6T5
 dv20gWN83Aghk9QOdlut0H7NZ4UhZFTYTgF+BlMuiiUusg/P4G8IKllI+YN+ZrIeD5aS7ehUAX+3eX
 VXm/AMsMUJLRUH0LmC7YL76NvxMRX1xfoZ1CqgNpYlz/6rtdMT53lCd+0+q0kuxzLnJalTyABXEgy+
 DWEWwtvgH+G7OjU6jLdRCdhMcGkDyhQf9Va3Me5fzIHcamaF7kWXlpe5LnCDBT+fLTytTQ5KL2KSRe
 cbbQQzey8TYYXR27jPO2oT7btDBkPRXLePPxs1SCPWOkqr9L6eNdokQ+rhkA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Note that we can't guess the listener family anymore based on the client
target address: always use IPv6.

The fullmesh flag with endpoints from different families is also
validated here.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 53 ++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index d11d3d566608..387abdcec011 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -774,24 +774,17 @@ do_transfer()
 		addr_nr_ns2=${addr_nr_ns2:9}
 	fi
 
-	local local_addr
-	if is_v6 "${connect_addr}"; then
-		local_addr="::"
-	else
-		local_addr="0.0.0.0"
-	fi
-
 	extra_srv_args="$extra_args $extra_srv_args"
 	if [ "$test_link_fail" -gt 1 ];then
 		timeout ${timeout_test} \
 			ip netns exec ${listener_ns} \
 				./mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
-					$extra_srv_args ${local_addr} < "$sinfail" > "$sout" &
+					$extra_srv_args "::" < "$sinfail" > "$sout" &
 	else
 		timeout ${timeout_test} \
 			ip netns exec ${listener_ns} \
 				./mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
-					$extra_srv_args ${local_addr} < "$sin" > "$sout" &
+					$extra_srv_args "::" < "$sin" > "$sout" &
 	fi
 	local spid=$!
 
@@ -2448,6 +2441,47 @@ v4mapped_tests()
 	fi
 }
 
+mixed_tests()
+{
+	if reset "IPv4 sockets do not use IPv6 addresses"; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+		chk_join_nr 0 0 0
+	fi
+
+	# Need an IPv6 mptcp socket to allow subflows of both families
+	if reset "simult IPv4 and IPv6 subflows"; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.1.1 flags signal
+		run_tests $ns1 $ns2 dead:beef:2::1 0 0 0 slow
+		chk_join_nr 1 1 1
+	fi
+
+	# cross families subflows will not be created even in fullmesh mode
+	if reset "simult IPv4 and IPv6 subflows, fullmesh 1x1"; then
+		pm_nl_set_limits $ns1 0 4
+		pm_nl_set_limits $ns2 1 4
+		pm_nl_add_endpoint $ns2 dead:beef:2::2 flags subflow,fullmesh
+		pm_nl_add_endpoint $ns1 10.0.1.1 flags signal
+		run_tests $ns1 $ns2 dead:beef:2::1 0 0 0 slow
+		chk_join_nr 1 1 1
+	fi
+
+	# fullmesh still tries to create all the possibly subflows with
+	# matching family
+	if reset "simult IPv4 and IPv6 subflows, fullmesh 2x2"; then
+		pm_nl_set_limits $ns1 0 4
+		pm_nl_set_limits $ns2 2 4
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+		run_tests $ns1 $ns2 dead:beef:1::1 0 0 fullmesh_1 slow
+		chk_join_nr 4 4 4
+	fi
+}
+
 backup_tests()
 {
 	# single subflow, backup
@@ -3120,6 +3154,7 @@ all_tests_sorted=(
 	a@add_tests
 	6@ipv6_tests
 	4@v4mapped_tests
+	M@mixed_tests
 	b@backup_tests
 	p@add_addr_ports_tests
 	k@syncookies_tests

-- 
2.38.1

