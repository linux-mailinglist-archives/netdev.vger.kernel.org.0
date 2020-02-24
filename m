Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20838169F5F
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgBXHgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:21 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36789 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbgBXHgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so8192008wma.1
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cL8Qn0eNhz8aXOmxtnA+NbWppUDKczl/eRSDR2kveXw=;
        b=kIIf4Xc0zpU5Xtru0L5L96bcnAQXsrAVgDyRzjwRZtKT/zEIV/M7CkZbU9xjYUx6IA
         YtmO0BNXu2aefG/d9uYhNxXWaBKciRBh12pkEj4rH9FBqcjEjRZU1NJ4pmhuu9KQ41Zm
         9yBn8Ls3u5XtSvMUsUkuXBM2l/p9jTWaujaVJoioPkWbc7kr/jEZveivFDypkouMNf0Q
         AWCKb5G4oPl3O0LoOn3PR05H2ooNr9VFya8SEE3dV5roVav1lzrCgFCmGP76oz0ZTZSM
         aMGltxDCDyiS+uvQkCt4lk+Qcu2mGUArTqXC7V5pGKLwTnNIq9nKTSayh38oucBJqGRR
         szig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cL8Qn0eNhz8aXOmxtnA+NbWppUDKczl/eRSDR2kveXw=;
        b=BxVYv907AxikY8mBI5kgkm89qzcSERgAKL5XC5GAxie0fk2O9k3x7ydimh9SfP6v03
         NDZzjK4ZLttWItZQxp+3RKBevv3PLIxxZs6iKgfSz6+D3GLm5RfUetP0HKIb+XW5LOgb
         RGgYZ2ZK7sqe08F6qNxTZL+W6aP5Qi3Sck7s2UzMqprQomNmPlbdzy2vZAcipvviwI3K
         59gnSHRJa9MfRQ4S3WBCs5rkG3Hm11iX+KyeueDIouaAWg9C8eAFqo6E6SNTyrn5UWRQ
         wP/SDF1+45nnkihLcB9+6aYzWn87qmWb8yq/CNZ9EXmXPFG6WZWRu4lLUe3NS3iMdqpP
         nOKg==
X-Gm-Message-State: APjAAAUcAXsfy8WaS5230TK1+6AQfO46B9keGUyZpOWDpHcPjzeVnLuO
        Q7zyirCDIdWPkvHzMD990ldTwTAlKWY=
X-Google-Smtp-Source: APXvYqzE25L/1HmxvJsCua+Lrj60Ciawvo4tfq+fe1dFOXNmwvxPvSytC0GfjwmO0a4XiU5AMMnvDg==
X-Received: by 2002:a05:600c:294a:: with SMTP id n10mr20973035wmd.11.1582529776159;
        Sun, 23 Feb 2020 23:36:16 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id s22sm16293304wmh.4.2020.02.23.23.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:15 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 14/16] selftests: introduce test for mlxsw tc flower restrictions
Date:   Mon, 24 Feb 2020 08:35:56 +0100
Message-Id: <20200224073558.26500-15-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Include test of forbidding to have drop rule on mixed-bound
shared block.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/tc_flower_restrictions.sh       | 100 ++++++++++++++++++
 1 file changed, 100 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh
new file mode 100755
index 000000000000..58419c3a7d99
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh
@@ -0,0 +1,100 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="shared_block_drop_test"
+NUM_NETIFS=2
+
+source $lib_dir/tc_common.sh
+source $lib_dir/lib.sh
+
+switch_create()
+{
+	simple_if_init $swp1 192.0.2.1/24
+	simple_if_init $swp2 192.0.2.2/24
+}
+
+switch_destroy()
+{
+	simple_if_fini $swp2 192.0.2.2/24
+	simple_if_fini $swp1 192.0.2.1/24
+}
+
+shared_block_drop_test()
+{
+	RET=0
+
+	# It is forbidden in mlxsw driver to have mixed-bound
+	# shared block with a drop rule.
+
+	tc qdisc add dev $swp1 ingress_block 22 clsact
+	check_err $? "Failed to create clsact with ingress block"
+
+	tc filter add block 22 protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop
+	check_err $? "Failed to add drop rule to ingress bound block"
+
+	tc qdisc add dev $swp2 ingress_block 22 clsact
+	check_err $? "Failed to create another clsact with ingress shared block"
+
+	tc qdisc del dev $swp2 clsact
+
+	tc qdisc add dev $swp2 egress_block 22 clsact
+	check_fail $? "Incorrect success to create another clsact with egress shared block"
+
+	tc filter del block 22 protocol ip pref 1 handle 101 flower
+
+	tc qdisc add dev $swp2 egress_block 22 clsact
+	check_err $? "Failed to create another clsact with egress shared block after blocker drop rule removed"
+
+	tc filter add block 22 protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop
+	check_fail $? "Incorrect success to add drop rule to mixed bound block"
+
+	tc qdisc del dev $swp1 clsact
+
+	tc qdisc add dev $swp1 egress_block 22 clsact
+	check_err $? "Failed to create another clsact with egress shared block"
+
+	tc filter add block 22 protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop
+	check_err $? "Failed to add drop rule to egress bound shared block"
+
+	tc filter del block 22 protocol ip pref 1 handle 101 flower
+
+	tc qdisc del dev $swp2 clsact
+	tc qdisc del dev $swp1 clsact
+
+	log_test "shared block drop"
+}
+
+setup_prepare()
+{
+	swp1=${NETIFS[p1]}
+	swp2=${NETIFS[p2]}
+
+	vrf_prepare
+
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+
+	vrf_cleanup
+}
+
+check_tc_shblock_support
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.21.1

