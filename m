Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B5534A7D5
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhCZNKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhCZNKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 09:10:05 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98E5C0613B1
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:10:04 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id dm8so6270986edb.2
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xyFIGb5tgMoLJ+C2dLCptTO4xPo45801GBsThwDgsdE=;
        b=yZub6IN6FEffpOqBoIHjmb6uaXRoSs4BRTBqbsRHtRQ97W/Xs4E+g3TvZcG/fTXBbG
         ZhfdP/RcMig042ealI6G6498ZXTfBm5kaET4BVhHJbmA6JG2FdZxGQmbjvPnlVULbLsv
         5B3N6bTEVvhUmBbQVI1J5JYmDvAazIv7HCYtV47IGRBe1rIVdp7mYjDgJClK9X9JL32w
         etlY5AdButybXr+Lmk4VY7HJ+RUkEyfJi4HEyY2gDEGeG9pT1+6JtCH2WzzszQMiugUl
         iOIEtiu5RipYzGK+1MDPn7DlWt6f34nBcXgvsfoEn9V2uhUaE+ncjdMMTp514ynwGKhl
         dhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xyFIGb5tgMoLJ+C2dLCptTO4xPo45801GBsThwDgsdE=;
        b=slqTabAB6rhdjJaz+xRl4yMeRnM2LS4Ow/wkBRosI70AgRlJmHDDGzCDJvQ8fbls/B
         wB+S2UV+LLAbBEkVUCfvKw8zt7mFW3b0CvMZwzrkQ+qlrIfwOlENehB8E1QwG10QuB8u
         peaBy3ngeZg1ZsgfrEwlOvviMXjp6M1qkZ/PquWEoFNRTago3808Mh/g3tjEBhGzVlNy
         uZcVneX4H/PkkFt5eq35Cai6BWKaEQCrvy9xxT0EY2ByLE/sOxXlSpwZ3OkBG1mgKGhJ
         DInm/niIG1r21PvVqosxuM3fsGHpT9bLXlejbpdfbMiAqwwan8363ov+pjNsP0T/Xmw1
         pqtQ==
X-Gm-Message-State: AOAM532QuclH3KjbCdu1GTC1ww610+PYXyJRY+0QKIxlw64JiMaMme/6
        8XLLOoMAgSlkKiveN7t262MH9w==
X-Google-Smtp-Source: ABdhPJwhi191Ank03/s9Kg/631INEG5Z4Qf9mmKT+a3aXomFF1EUF2Oc+PaTvPCxXcKAG3zpYfgJBg==
X-Received: by 2002:aa7:c889:: with SMTP id p9mr14880198eds.82.1616764203539;
        Fri, 26 Mar 2021 06:10:03 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id 90sm4202624edf.31.2021.03.26.06.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 06:10:02 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Ido Schimmel <idosch@idosch.org>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 2/2] selftests: forwarding: Add tc-police tests for packets per second
Date:   Fri, 26 Mar 2021 14:09:38 +0100
Message-Id: <20210326130938.15814-3-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210326130938.15814-1-simon.horman@netronome.com>
References: <20210326130938.15814-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Test tc-police action for packets per second.
The test is mainly in scenarios Rx policing and Tx policing.
The test passes with veth pairs ports.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 tools/testing/selftests/net/forwarding/lib.sh |  9 +++
 .../selftests/net/forwarding/tc_police.sh     | 56 +++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 05c05e02bade..42e28c983d41 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -772,6 +772,15 @@ rate()
 	echo $((8 * (t1 - t0) / interval))
 }
 
+packets_rate()
+{
+	local t0=$1; shift
+	local t1=$1; shift
+	local interval=$1; shift
+
+	echo $(((t1 - t0) / interval))
+}
+
 mac_get()
 {
 	local if_name=$1
diff --git a/tools/testing/selftests/net/forwarding/tc_police.sh b/tools/testing/selftests/net/forwarding/tc_police.sh
index 160f9cccdfb7..4f9f17cb45d6 100755
--- a/tools/testing/selftests/net/forwarding/tc_police.sh
+++ b/tools/testing/selftests/net/forwarding/tc_police.sh
@@ -35,6 +35,8 @@ ALL_TESTS="
 	police_shared_test
 	police_rx_mirror_test
 	police_tx_mirror_test
+	police_pps_rx_test
+	police_pps_tx_test
 "
 NUM_NETIFS=6
 source tc_common.sh
@@ -290,6 +292,60 @@ police_tx_mirror_test()
 	police_mirror_common_test $rp2 egress "police tx and mirror"
 }
 
+police_pps_common_test()
+{
+	local test_name=$1; shift
+
+	RET=0
+
+	# Rule to measure bandwidth on ingress of $h2
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action drop
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=54321 -p 1000 -c 0 -q &
+
+	local t0=$(tc_rule_stats_get $h2 1 ingress .packets)
+	sleep 10
+	local t1=$(tc_rule_stats_get $h2 1 ingress .packets)
+
+	local er=$((2000))
+	local nr=$(packets_rate $t0 $t1 10)
+	local nr_pct=$((100 * (nr - er) / er))
+	((-10 <= nr_pct && nr_pct <= 10))
+	check_err $? "Expected rate $(humanize $er), got $(humanize $nr), which is $nr_pct% off. Required accuracy is +-10%."
+
+	log_test "$test_name"
+
+	{ kill %% && wait %%; } 2>/dev/null
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+}
+
+police_pps_rx_test()
+{
+	# Rule to police traffic destined to $h2 on ingress of $rp1
+	tc filter add dev $rp1 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action police pkts_rate 2000 pkts_burst 400 conform-exceed drop/ok
+
+	police_pps_common_test "police pps on rx"
+
+	tc filter del dev $rp1 ingress protocol ip pref 1 handle 101 flower
+}
+
+police_pps_tx_test()
+{
+	# Rule to police traffic destined to $h2 on egress of $rp2
+	tc filter add dev $rp2 egress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action police pkts_rate 2000 pkts_burst 400 conform-exceed drop/ok
+
+	police_pps_common_test "police pps on tx"
+
+	tc filter del dev $rp2 egress protocol ip pref 1 handle 101 flower
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.20.1

