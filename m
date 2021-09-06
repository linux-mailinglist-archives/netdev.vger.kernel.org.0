Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B5340187C
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240360AbhIFI6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 04:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241237AbhIFI6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 04:58:33 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CD9C0613D9
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 01:57:08 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id e26so4022987wmk.2
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 01:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xsAUnpvsjZoOrIdtLj1lOTplaQwx8CEaSB4LOfRqAYI=;
        b=lXqsayYxzuke3KOcmbfHR5ukxITid6ppOxFdpJEkDrA3VzpaoODqZV0Ih2A6sTie7z
         wbEcIENvN3goy4O40nCB0midCbTFiQAH7iNV+kjcRaMQ9/DxMQU6VPTEHpTPoZZqT4b6
         NH5ktTMifI2WIjtec6NmyyZrtW+7GO6usTJlW28+jdnuTokXSpEO3j4el2qMiRNSHwTa
         nCgKSPeYPU3o8K4Synw3bIyLksxVvyFCeqRI10uGg+A3S2IqIyVgvOe5m6YMtRwj8GuF
         ArQgX2uHcIry/DCAxz0uFXxcQehlmPXT6L8XbSfhEJDW3X+uiCPq+uko+vQwrVZG5dup
         EBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xsAUnpvsjZoOrIdtLj1lOTplaQwx8CEaSB4LOfRqAYI=;
        b=F3S6tKXL0ww6BdWHYwpSqROn/tiInSJ9YycimB/92LvvKHQxEpPG4D54S7L6zfytPp
         uIr3Rx4cEdY2cM4ha95YCOf5w2JAuHjINHGdiihU70Ghai2vt4uj+9PzMQQvJmrIJURe
         0aeuXXGMlWC98GcvsvcRsBvsnMNBpYc2t/gQcUDz2uYbWKfHtgz6A++YY3pVRAvyTwDl
         mkD2f3r4mN+p6q5koIKQoqf2Nhct0efluAIUCkGi9/yTiY8sZGWdd7WvWeg0sqW1Fzd1
         cZK19LjKO87tWjE0sde5HUJFD8I3dr5thegl85E/6itr2zli+GSQRSIQFb7k2SP31+iw
         SRrQ==
X-Gm-Message-State: AOAM5327yXrDsyP1cbsTzBcIIYqvDvNbovG8BcyuL87TiRyNHsFa/vOz
        hQLsPZnHY3NN0gM4/Or+7Y4HZREPJ2+tDuw=
X-Google-Smtp-Source: ABdhPJzdtafQgwMIsQrXtFHIQNWyzMVVIcvQ6Cu/dlApD8yW+JC7OpL1/RSVy/agLwoHAgyRQlDE2w==
X-Received: by 2002:a05:600c:3b15:: with SMTP id m21mr10193270wms.162.1630918626772;
        Mon, 06 Sep 2021 01:57:06 -0700 (PDT)
Received: from devaron.home ([2001:1620:5107:0:f22f:74ff:fe62:384a])
        by smtp.gmail.com with ESMTPSA id x9sm6523071wmi.30.2021.09.06.01.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 01:57:06 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ardb@kernel.org, jbaron@akamai.com, peterz@infradead.org,
        rostedt@goodmis.org, jpoimboe@redhat.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH net 2/2] selftests/bpf: Test XDP bonding nest and unwind
Date:   Mon,  6 Sep 2021 10:56:38 +0200
Message-Id: <20210906085638.1027202-3-joamaki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906085638.1027202-1-joamaki@gmail.com>
References: <20210906085638.1027202-1-joamaki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the test to check that enslaving a bond slave with a XDP program
is now allowed.

Extend attach test to exercise the program unwinding in bond_xdp_set and
add a new test for loading XDP program on doubly nested bond device to
verify that static key incr/decr is correct.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 .../selftests/bpf/prog_tests/xdp_bonding.c    | 74 ++++++++++++++++---
 1 file changed, 64 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
index 370d220288a6..ad3ba81b4048 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
@@ -384,8 +384,7 @@ static void test_xdp_bonding_attach(struct skeletons *skeletons)
 {
 	struct bpf_link *link = NULL;
 	struct bpf_link *link2 = NULL;
-	int veth, bond;
-	int err;
+	int veth, bond, err;
 
 	if (!ASSERT_OK(system("ip link add veth type veth"), "add veth"))
 		goto out;
@@ -399,22 +398,18 @@ static void test_xdp_bonding_attach(struct skeletons *skeletons)
 	if (!ASSERT_GE(bond, 0, "if_nametoindex bond"))
 		goto out;
 
-	/* enslaving with a XDP program loaded fails */
+	/* enslaving with a XDP program loaded is allowed */
 	link = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, veth);
 	if (!ASSERT_OK_PTR(link, "attach program to veth"))
 		goto out;
 
 	err = system("ip link set veth master bond");
-	if (!ASSERT_NEQ(err, 0, "attaching slave with xdp program expected to fail"))
+	if (!ASSERT_OK(err, "set veth master"))
 		goto out;
 
 	bpf_link__destroy(link);
 	link = NULL;
 
-	err = system("ip link set veth master bond");
-	if (!ASSERT_OK(err, "set veth master"))
-		goto out;
-
 	/* attaching to slave when master has no program is allowed */
 	link = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, veth);
 	if (!ASSERT_OK_PTR(link, "attach program to slave when enslaved"))
@@ -434,8 +429,26 @@ static void test_xdp_bonding_attach(struct skeletons *skeletons)
 		goto out;
 
 	/* attaching to slave not allowed when master has program loaded */
-	link2 = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, bond);
-	ASSERT_ERR_PTR(link2, "attach program to slave when master has program");
+	link2 = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, veth);
+	if (!ASSERT_ERR_PTR(link2, "attach program to slave when master has program"))
+		goto out;
+
+	bpf_link__destroy(link);
+	link = NULL;
+
+	/* test program unwinding with a non-XDP slave */
+	if (!ASSERT_OK(system("ip link add vxlan type vxlan id 1 remote 1.2.3.4 dstport 0 dev lo"),
+		       "add vxlan"))
+		goto out;
+
+	err = system("ip link set vxlan master bond");
+	if (!ASSERT_OK(err, "set vxlan master"))
+		goto out;
+
+	/* attaching not allowed when one slave does not support XDP */
+	link = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, bond);
+	if (!ASSERT_ERR_PTR(link, "attach program to master when slave does not support XDP"))
+		goto out;
 
 out:
 	bpf_link__destroy(link);
@@ -443,6 +456,44 @@ static void test_xdp_bonding_attach(struct skeletons *skeletons)
 
 	system("ip link del veth");
 	system("ip link del bond");
+	system("ip link del vxlan");
+}
+
+/* Test with nested bonding devices to catch issue with negative jump label count */
+static void test_xdp_bonding_nested(struct skeletons *skeletons)
+{
+	struct bpf_link *link = NULL;
+	int bond, err;
+
+	if (!ASSERT_OK(system("ip link add bond type bond"), "add bond"))
+		goto out;
+
+	bond = if_nametoindex("bond");
+	if (!ASSERT_GE(bond, 0, "if_nametoindex bond"))
+		goto out;
+
+	if (!ASSERT_OK(system("ip link add bond_nest1 type bond"), "add bond_nest1"))
+		goto out;
+
+	err = system("ip link set bond_nest1 master bond");
+	if (!ASSERT_OK(err, "set bond_nest1 master"))
+		goto out;
+
+	if (!ASSERT_OK(system("ip link add bond_nest2 type bond"), "add bond_nest1"))
+		goto out;
+
+	err = system("ip link set bond_nest2 master bond_nest1");
+	if (!ASSERT_OK(err, "set bond_nest2 master"))
+		goto out;
+
+	link = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, bond);
+	ASSERT_OK_PTR(link, "attach program to master");
+
+out:
+	bpf_link__destroy(link);
+	system("ip link del bond");
+	system("ip link del bond_nest1");
+	system("ip link del bond_nest2");
 }
 
 static int libbpf_debug_print(enum libbpf_print_level level,
@@ -496,6 +547,9 @@ void test_xdp_bonding(void)
 	if (test__start_subtest("xdp_bonding_attach"))
 		test_xdp_bonding_attach(&skeletons);
 
+	if (test__start_subtest("xdp_bonding_nested"))
+		test_xdp_bonding_nested(&skeletons);
+
 	for (i = 0; i < ARRAY_SIZE(bond_test_cases); i++) {
 		struct bond_test_case *test_case = &bond_test_cases[i];
 
-- 
2.30.2

