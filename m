Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACE863D7BE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiK3OIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiK3OHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:40 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F063E8BD1D
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:12 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id n21so41558703ejb.9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sr2PpWhxUJjRYOqYBbe/QkQ7A3T0Cv15MkXyo/pb3Ys=;
        b=te/8XCVvFXgYoOZPqtT6lepLDkAOy8Joc7cozwgOc9XRuZeM7N3ZCJIBspLoRYMQgB
         eb7WfhG65rUQU3tTORxGrb5Y38kFk4EsB5UmxHUGqZ6wi+0FM/4xMPQVwz2tWLmsb7/9
         Rol/LXdBCSR1vBCQYFbJfa1mJ3qu2mkZ6v1JtfHT80tF47TC0/GmjFoJamIS1ZIb2TWz
         /qWJcSRLTEPZM/ClqTh41vPN/4oV+BVkDh77ifob5Wr1nON2aC1YPXBD8o7k2ClMfsO5
         wWi3pjKHI1F9baAHUJB29n9UpTU5t4elkq05VUekZ0+mc1HYWJ20E6drQpLmyRuY65pW
         Guyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sr2PpWhxUJjRYOqYBbe/QkQ7A3T0Cv15MkXyo/pb3Ys=;
        b=gt4H1sQ18GkrmJPeCBc3p4zEL8ilV0wyj4oRk6roS3hI4qIMgR6GX7L1udUir0qG1q
         87yphmLWlAlhOp3lAcHvS0nCtgEx6P1EkBGoU2Xmeq1gWn+xdhuZozGVER+W3RA1DKi7
         RPQ1HrClKitSbxgGCe3aVu1/zwQlyeX1Np+geOSQr8vzPi4YU3Ce9Hf3WpUt0gQRZyzF
         OpejGsGpgZnBk6wri9lRXkS4sJnlAGC1JvmuGPocrxyZ0TY5H5Cp/GjevfiKSMKMq10h
         dVdm8PhMLwYGsQAaWdU4bbms4d1IrQpyriWriqCmRauYrjbchRJwo8wqrZ/r79a4hVUN
         tmZA==
X-Gm-Message-State: ANoB5pnJZRoZ+dzgh3sRPKPWT+ff+cGKMXj5HRbhIjd6qXO/0jR2r1VG
        aVNGyyks8lSVs4HXlvuVVUHBPA==
X-Google-Smtp-Source: AA0mqf6lsYvNUFGiWOpZkQZQ1fFVQBGXBtNOItwT+lHprMVk1JdOHjeYTj0M4cZ++LdcKimhYkWN9Q==
X-Received: by 2002:a17:906:8d86:b0:78d:4742:bb62 with SMTP id ry6-20020a1709068d8600b0078d4742bb62mr40839749ejc.43.1669817231344;
        Wed, 30 Nov 2022 06:07:11 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:07:11 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/11] selftests: mptcp: make evts global in mptcp_join
Date:   Wed, 30 Nov 2022 15:06:32 +0100
Message-Id: <20221130140637.409926-11-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3931; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=jy0B03U7SrhLzNlNUKrDAPk8Nk4bPwGVN5x25PhFK6c=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2NpnOwKZdKU09wPqiAzSf1DGh69laqfo7KTdlqS
 1JBirrqJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djaQAKCRD2t4JPQmmgcwRbEA
 C5T21uKknBYwWFEyvIRWOP3qoh4GQvKVV2C2moqK67KLl4CW36OmjAGDfAm3tgAq6x6sxPlfaHhN1o
 Jod7ick/pd/wqfXqocyrPx/Yorf0TbjrpySKuwqMh5NmcHMVxgenYtS18TzG3AvgcMwYcx/Ijo7yGn
 QajMkTgEUQA0rEql5my1622INoY52AB6wLGw/Rwp0WdjyAWFAUl1sshcDBW6UGAkRX9jhJWEErB7ow
 zD4J/wxjADbYKMc5X78wvmUZumsLyDw8ieUYSLPuXyfeTVzWXIfd36viX3MJjboKsnOvpf6Mqy6pfb
 E7jHpOedyZ943qfZ8d5ZTdA3fFMJAdhsWyoPTvaLeKm6czjzcXaOqcaXEiIDEwFmwqTVCRfhBMAbPc
 e4VMvWedTkkF6/7j+GsFZ8AGXdcsw55NhY7paYdC9JCxg7UNhO1ftWzZIERMVzcF3oznpCsQZz1tZj
 pyBHEc85D0tukQoSFOGpNsxu4jEwgkJoVB5L51zkMy1iI399OPRWj5zZgWwmCmJeQwbixclLsvSKjo
 nHQ5HS8kgKFjECtXX4KzixYb6P7G+cjX4SZ+ne7UuUQciOo3/+JhcTgQI16CX4O//G7eFNwIWuUSra
 Caf9qXPQ1rE3N3nN7y2BVKk5bWVDBhNO7Mi7IAhe4HvJ9WOKbY5VXDsGTEmg==
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

From: Geliang Tang <geliang.tang@suse.com>

This patch moves evts_ns1 and evts_ns2 out of do_transfer() as two global
variables in mptcp_join.sh. Init them in init() and remove them in
cleanup().

Add a new helper reset_with_events() to save the outputs of 'pm_nl_ctl
events' command in them. And a new helper kill_events_pids() to kill
pids of 'pm_nl_ctl events' command. Use these helpers in userspace pm
tests.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 52 +++++++++++--------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f10ef65a7009..32a3694c57fb 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -26,6 +26,10 @@ ip_mptcp=0
 check_invert=0
 validate_checksum=0
 init=0
+evts_ns1=""
+evts_ns2=""
+evts_ns1_pid=0
+evts_ns2_pid=0
 
 declare -A all_tests
 declare -a only_tests_ids
@@ -154,6 +158,8 @@ init() {
 	cin=$(mktemp)
 	cinsent=$(mktemp)
 	cout=$(mktemp)
+	evts_ns1=$(mktemp)
+	evts_ns2=$(mktemp)
 
 	trap cleanup EXIT
 
@@ -165,6 +171,7 @@ cleanup()
 {
 	rm -f "$cin" "$cout" "$sinfail"
 	rm -f "$sin" "$sout" "$cinsent" "$cinfail"
+	rm -rf $evts_ns1 $evts_ns2
 	cleanup_partial
 }
 
@@ -320,6 +327,18 @@ reset_with_fail()
 		index 100 || exit 1
 }
 
+reset_with_events()
+{
+	reset "${1}" || return 1
+
+	:> "$evts_ns1"
+	:> "$evts_ns2"
+	ip netns exec $ns1 ./pm_nl_ctl events >> "$evts_ns1" 2>&1 &
+	evts_ns1_pid=$!
+	ip netns exec $ns2 ./pm_nl_ctl events >> "$evts_ns2" 2>&1 &
+	evts_ns2_pid=$!
+}
+
 fail_test()
 {
 	ret=1
@@ -473,6 +492,12 @@ kill_wait()
 	wait $1 2>/dev/null
 }
 
+kill_events_pids()
+{
+	kill_wait $evts_ns1_pid
+	kill_wait $evts_ns2_pid
+}
+
 pm_nl_set_limits()
 {
 	local ns=$1
@@ -673,10 +698,6 @@ do_transfer()
 	local port=$((10000 + TEST_COUNT - 1))
 	local cappid
 	local userspace_pm=0
-	local evts_ns1
-	local evts_ns1_pid
-	local evts_ns2
-	local evts_ns2_pid
 
 	:> "$cout"
 	:> "$sout"
@@ -753,17 +774,6 @@ do_transfer()
 		addr_nr_ns2=${addr_nr_ns2:9}
 	fi
 
-	if [ $userspace_pm -eq 1 ]; then
-		evts_ns1=$(mktemp)
-		evts_ns2=$(mktemp)
-		:> "$evts_ns1"
-		:> "$evts_ns2"
-		ip netns exec ${listener_ns} ./pm_nl_ctl events >> "$evts_ns1" 2>&1 &
-		evts_ns1_pid=$!
-		ip netns exec ${connector_ns} ./pm_nl_ctl events >> "$evts_ns2" 2>&1 &
-		evts_ns2_pid=$!
-	fi
-
 	local local_addr
 	if is_v6 "${connect_addr}"; then
 		local_addr="::"
@@ -982,12 +992,6 @@ do_transfer()
 	    kill $cappid
 	fi
 
-	if [ $userspace_pm -eq 1 ]; then
-		kill_wait $evts_ns1_pid
-		kill_wait $evts_ns2_pid
-		rm -rf $evts_ns1 $evts_ns2
-	fi
-
 	NSTAT_HISTORY=/tmp/${listener_ns}.nstat ip netns exec ${listener_ns} \
 		nstat | grep Tcp > /tmp/${listener_ns}.out
 	NSTAT_HISTORY=/tmp/${connector_ns}.nstat ip netns exec ${connector_ns} \
@@ -2961,22 +2965,24 @@ userspace_tests()
 	fi
 
 	# userspace pm add & remove address
-	if reset "userspace pm add & remove address"; then
+	if reset_with_events "userspace pm add & remove address"; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 userspace_1 0 slow
 		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 		chk_rm_nr 1 1 invert
+		kill_events_pids
 	fi
 
 	# userspace pm create destroy subflow
-	if reset "userspace pm create destroy subflow"; then
+	if reset_with_events "userspace pm create destroy subflow"; then
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 0 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 userspace_1 slow
 		chk_join_nr 1 1 1
 		chk_rm_nr 0 1
+		kill_events_pids
 	fi
 }
 
-- 
2.37.2

