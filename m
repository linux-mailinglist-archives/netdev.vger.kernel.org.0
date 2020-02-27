Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF6B1711B5
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgB0Hu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:29 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45408 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbgB0Hu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:28 -0500
Received: by mail-wr1-f68.google.com with SMTP id v2so2000667wrp.12
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rQG4B0zrbeY6v1kRUVQ+gBEAVcGHVm+2oU89z9ojPZo=;
        b=KOITct1acOhhcT3FsULaUxBNrL4I9XHzI3h5KiZC7veZmyxme2BprjsqKjTKimnfl3
         tHTKAPhmQAS4G260qjVuZh8cE5DEFE6Fc9Xy1Q1VKXpltgnW7w6j2Zkv8Ek/WxP1jA9J
         urU35Ldx2ba8ZKpw+h6PI9jNBaoGoAxqXqmDJ/tjxy2GCIjob1wc9OuWgn0mXR5E7hb3
         s5DqqFubYmls9OIrnc718gBuk1K8N2ZSroupUBg2ivuQQQqUHDDtziBvunWgIbWcljql
         ZLjeElfcJUgK1SruWEXCFiBhgWIoLciZQjyvpKKjVBD/8fXzVRDTJFFhs+cUOhgRHh06
         e6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rQG4B0zrbeY6v1kRUVQ+gBEAVcGHVm+2oU89z9ojPZo=;
        b=Ii5rSmWq2OEFs56gFYknLVKh1YwdAzjlKBOeTQdPV/RxOWCqrrx2jTDwyyEuLoBpND
         wmApnDbA0Wi19xXIBKV3cx0iK3Yi7knfkV1P5LdN4bHjJuSb16J4TqndcVUm6WfGUuQt
         PxYjWTJSubnaQvlHMtPA9IBvtu42YHaJrBIexgldzsqKjcm8gEhjuuvQOrl8Beqxj3x/
         3fYDkYzvqBfcQdYyi3ReZIm1xIdGsC1DV8o3lWRKabNSAYHLMgS6Fle9VuDOTB2AR+L6
         pDKHgU6mgWsfTFdiDxLj/69AXH/X/pCZOjEJWD1sw27sfzubHHKD5QjGRHb9/YEeaN5y
         kjUQ==
X-Gm-Message-State: APjAAAWWkznA5M5J49Fv+tLe8UevX4QagdmsiN3rZRqiy4QwfHbhdo4w
        IFD3MArDZqMWCrbLg1pGhbOomX0bYDw=
X-Google-Smtp-Source: APXvYqxG+YaDGEtuDLCMER1c4LtZw2lcaekzPXYYKMgY1XtovBZDnSnhl/uRfnFckmwfASEn2HvfdA==
X-Received: by 2002:adf:f588:: with SMTP id f8mr3390268wro.188.1582789826554;
        Wed, 26 Feb 2020 23:50:26 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a16sm6842464wrx.87.2020.02.26.23.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:25 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 03/16] selftests: add egress redirect test to mlxsw tc flower restrictions
Date:   Thu, 27 Feb 2020 08:50:08 +0100
Message-Id: <20200227075021.3472-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Include test of forbidding to have redirect rule on egress-bound block.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/tc_flower_restrictions.sh       | 60 ++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh
index 58419c3a7d99..67e0c25adcee 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh
@@ -3,7 +3,10 @@
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 
-ALL_TESTS="shared_block_drop_test"
+ALL_TESTS="
+	shared_block_drop_test
+	egress_redirect_test
+"
 NUM_NETIFS=2
 
 source $lib_dir/tc_common.sh
@@ -69,6 +72,61 @@ shared_block_drop_test()
 	log_test "shared block drop"
 }
 
+egress_redirect_test()
+{
+	RET=0
+
+	# It is forbidden in mlxsw driver to have mirred redirect on
+	# egress-bound block.
+
+	tc qdisc add dev $swp1 ingress_block 22 clsact
+	check_err $? "Failed to create clsact with ingress block"
+
+	tc filter add block 22 protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 \
+		action mirred egress redirect dev $swp2
+	check_err $? "Failed to add redirect rule to ingress bound block"
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
+	check_err $? "Failed to create another clsact with egress shared block after blocker redirect rule removed"
+
+	tc filter add block 22 protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 \
+		action mirred egress redirect dev $swp2
+	check_fail $? "Incorrect success to add redirect rule to mixed bound block"
+
+	tc qdisc del dev $swp1 clsact
+
+	tc qdisc add dev $swp1 egress_block 22 clsact
+	check_err $? "Failed to create another clsact with egress shared block"
+
+	tc filter add block 22 protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 \
+		action mirred egress redirect dev $swp2
+	check_fail $? "Incorrect success to add redirect rule to egress bound shared block"
+
+	tc qdisc del dev $swp2 clsact
+
+	tc filter add block 22 protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 \
+		action mirred egress redirect dev $swp2
+	check_fail $? "Incorrect success to add redirect rule to egress bound block"
+
+	tc qdisc del dev $swp1 clsact
+
+	log_test "shared block drop"
+}
+
 setup_prepare()
 {
 	swp1=${NETIFS[p1]}
-- 
2.21.1

