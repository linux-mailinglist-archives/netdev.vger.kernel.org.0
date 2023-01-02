Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC4C65B427
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbjABPYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbjABPYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:24:43 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A9B281
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:24:40 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t15so17710542wro.9
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 07:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PMdrO8uLRKIQlFemCDResumzPBnlrdnAHhn02e0TIu8=;
        b=aI1eF1uwD1phk12WwittN+HpTlos+QElLUej2/ZwC+pww2CRmjys7pb0cweDZ3wKef
         UUY/FgDPnwHIVZBTuHcTBpHvoFuVPOwU0sgG34D9RAZifuPfbZsHuQvACUnnNgrJRy9a
         1XX/22Sr4XpTKneaWjdlH6tMIKzjgn4pU3A3+FWrpFE5DQ9g795eZtmFsMWwbhKVZHT8
         NMOn8F6skQPw5K/rlsAZDkPGp738OWDXKdDLSgBKkgIYPKEbu1SuzyTV6p5ncCdEHgrA
         Hi7GWNBn0VWArg0hzV40y0oaEzLgNstLY2ywg3E+Hw+kToONMOHyBKcxIY2FKYxRDwQe
         DHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PMdrO8uLRKIQlFemCDResumzPBnlrdnAHhn02e0TIu8=;
        b=q1UP32W0iDFqai/psMLGO6ti/UnK1Tj/6+4N2DlwMuDoJb6PS9aUfsBveOcABpHK53
         vcTDLwdbKJqLJCd6kidlew4z6GCd6k8VZuAOp0Esi5tmgT4WStCkzNhiAnK5R19AHd8z
         3Dwfa5iaLwNTOuxFAlq2i7VTsfkMCE3TuNZam8oKFz0/lkajTjxI8V/RW3hwkrrnQqvh
         N6qYiZu7O2CZHA8Yh/wsque1N9xyo+umyLEktCfarUA2AJ7Pa826A6fUbePJM/4lfMUx
         ghTSPeffYVpoQTAUB+7tAbutTvE0ABbRulrEMCuFTPn+FfjO+ZWa49Lgf8eGe+hxSOfH
         CpuA==
X-Gm-Message-State: AFqh2krsPtJHCeClANUczdxyIThgQ4sItK2p3Iz63baU1QzQVuK3NPHh
        1vy9gHs9m4QVs1RFZGE1oeWBPBtQtZZC7AMZ
X-Google-Smtp-Source: AMrXdXsA/sED4aKZ1tu/wPxbcWVRBw6xylHzgJU1EuOPg2SeyQanugS0RvVyEgGxi1nTaepTqXFq2A==
X-Received: by 2002:a5d:5449:0:b0:242:4995:2c95 with SMTP id w9-20020a5d5449000000b0024249952c95mr23925786wrv.44.1672673078742;
        Mon, 02 Jan 2023 07:24:38 -0800 (PST)
Received: from localhost.localdomain (p200300c1c7122500ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c712:2500:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id d14-20020adfa40e000000b0029d9ed7e707sm638322wra.44.2023.01.02.07.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 07:24:38 -0800 (PST)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [RFC PATCH 2/2] selftests: net: add tc flower cfm test
Date:   Mon,  2 Jan 2023 16:24:24 +0100
Message-Id: <20230102152424.889155-2-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102152424.889155-1-zahari.doychev@linux.com>
References: <20230102152424.889155-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zahari Doychev <zdoychev@maxlinear.com>

New cfm flower test case is added to the net forwarding selfttests.

Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
---
 .../selftests/net/forwarding/tc_flower_cfm.sh | 168 ++++++++++++++++++
 1 file changed, 168 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

diff --git a/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
new file mode 100755
index 000000000000..c536a3bba8e7
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_flower_cfm.sh
@@ -0,0 +1,168 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="match_cfm_opcode match_cfm_level match_cfm_level_and_opcode"
+
+NUM_NETIFS=2
+source tc_common.sh
+source lib.sh
+
+tcflags="skip_hw"
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24 198.51.100.1/24
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/24 198.51.100.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/24 198.51.100.2/24
+	tc qdisc add dev $h2 clsact
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 clsact
+	simple_if_fini $h2 192.0.2.2/24 198.51.100.2/24
+}
+
+cfm_mdl_opcode()
+{
+	local mdl=$1
+	local op=$2
+	local flags=$3
+	local tlv_offset=$4
+
+	printf "%02x %02x %02x %02x"    \
+		   $((mdl << 5))             \
+		   $((op & 0xff))             \
+		   $((flags & 0xff)) \
+		   $tlv_offset
+}
+
+match_cfm_opcode()
+{
+	local ethtype="89 02"; readonly ethtype
+	RET=0
+
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
+	   flower cfm op 47 action drop
+	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
+	   flower cfm op 43 action drop
+
+	pkt="$ethtype $(cfm_mdl_opcode 7 47 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 6 5 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct opcode"
+
+	tc_check_packets "dev $h2 ingress" 102 0
+	check_err $? "Matched on the wrong opcode"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
+
+	log_test "CFM opcode match test"
+}
+
+match_cfm_level()
+{
+	local ethtype="89 02"; readonly ethtype
+	RET=0
+
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
+	   flower cfm mdl 5 action drop
+	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
+	   flower cfm mdl 3 action drop
+
+	pkt="$ethtype $(cfm_mdl_opcode 5 42 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 6 1 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct level"
+
+	tc_check_packets "dev $h2 ingress" 102 0
+	check_err $? "Matched on the wrong level"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
+
+	log_test "CFM level match test"
+}
+
+match_cfm_level_and_opcode()
+{
+	local ethtype="89 02"; readonly ethtype
+	RET=0
+
+	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
+	   flower cfm mdl 5 op 41 action drop
+	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
+	   flower cfm mdl 7 op 42 action drop
+
+	pkt="$ethtype $(cfm_mdl_opcode 5 41 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 7 3 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+	pkt="$ethtype $(cfm_mdl_opcode 3 42 0 4)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct level and opcode"
+	tc_check_packets "dev $h2 ingress" 102 0
+	check_err $? "Matched on the wrong level and opcode"
+
+	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
+
+	log_test "CFM opcode and level match test"
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
+	h1mac=$(mac_get $h1)
+	h2mac=$(mac_get $h2)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+tc_offload_check
+if [[ $? -ne 0 ]]; then
+	log_info "Could not test offloaded functionality"
+else
+	tcflags="skip_sw"
+	tests_run
+fi
+
+exit $EXIT_STATUS
-- 
2.39.0

