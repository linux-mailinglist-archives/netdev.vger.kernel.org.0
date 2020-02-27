Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EAA1711C2
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgB0Hub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:31 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37914 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgB0Hua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:30 -0500
Received: by mail-wm1-f42.google.com with SMTP id a9so2199542wmj.3
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4TdAKRAdhGqK+iwF3A/wjK1hGvRR285ycg7j+GUg+x0=;
        b=we33tfmQZV3y6zFgdnCx4VLEg0uU8EaA/fiLcZPQVAFRTrfdiKxeyu1rhCLaK9oaIk
         0oug9vnB4c30cdEFsrhSjV3ZOGZKgtJ/INog272wHQswAFHDHbQamBc3YOLeLxlHE+PU
         e5JfVW5A8bCDpjo69ApLw0ucPRYxNlBAGNaPVj3B2avHfwNu+nBY7fmYYARHIoAoPqWF
         0FdUBTzqgL8rSdSbXxlSG/iCUyEI1PTYGNcYvrY66jJg2+tWZC/IGMMsyVQ7DivxRB/r
         HmB1VndRkYhygr0G9xZLGGdhkBD9x94Um0wtV78OwsDTjxMQiBxBBC8/Bg+DJW+f6amI
         pfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4TdAKRAdhGqK+iwF3A/wjK1hGvRR285ycg7j+GUg+x0=;
        b=o2b5S34fUO0bJ1WPBO0vI4S1wa1W3H89u6HQcHJaUt16rgHnNyZjQT8IdX3Gbl2Df7
         kkQ4sj3JI4BJQweOMBunH3JtT+jw8s1itaKLcWanUKWoLvNN2mOQrLDlb2PTbcci+t/y
         rDeLjsT2mdxCb6/fbfd4Ck+bll8+GeHh4CrxsPZFmcUCBiKaEt0NQlzh45YdazE3Eh5I
         vMiTdSyDx06+vXuS+jHprbuQSATX33onYphFvsdRiNQjEzqUbCnORWIH7FgMohS1Ixss
         BNXbtfupA6VbtUWi5AXiI9vyyvxAguL/7CPwnxvE1GMGbSkV39KWbXu+V0fM8wUEyha2
         IsRw==
X-Gm-Message-State: APjAAAVgAeviA4imgMYLpk8Nkq87gTQyEOkLnGN7oOgLMoetYtJJ3qPO
        xB9iqP/llwLSPcvBMIRDZsPqzouJH8o=
X-Google-Smtp-Source: APXvYqxrr3WEEZu9G2RSmTJ0JuNEXcbFCzyz05NKJ6Jl/elzJY0jHoGxRrj+7AmWpWepguQ/ojMFvQ==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr3795545wmj.54.1582789827643;
        Wed, 26 Feb 2020 23:50:27 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id o15sm7039069wra.83.2020.02.26.23.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:27 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 04/16] selftests: add a mirror test to mlxsw tc flower restrictions
Date:   Thu, 27 Feb 2020 08:50:09 +0100
Message-Id: <20200227075021.3472-5-jiri@resnulli.us>
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

Include test of forbidding to have multiple mirror actions.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/tc_flower_restrictions.sh       | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh
index 67e0c25adcee..68c80d0ec1ec 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh
@@ -6,6 +6,7 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 ALL_TESTS="
 	shared_block_drop_test
 	egress_redirect_test
+	multi_mirror_test
 "
 NUM_NETIFS=2
 
@@ -127,6 +128,33 @@ egress_redirect_test()
 	log_test "shared block drop"
 }
 
+multi_mirror_test()
+{
+	RET=0
+
+	# It is forbidden in mlxsw driver to have multiple mirror
+	# actions in a single rule.
+
+	tc qdisc add dev $swp1 clsact
+
+	tc filter add dev $swp1 ingress protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 \
+		action mirred egress mirror dev $swp2
+	check_err $? "Failed to add rule with single mirror action"
+
+	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
+
+	tc filter add dev $swp1 ingress protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 \
+		action mirred egress mirror dev $swp2 \
+		action mirred egress mirror dev $swp1
+	check_fail $? "Incorrect success to add rule with two mirror actions"
+
+	tc qdisc del dev $swp1 clsact
+
+	log_test "multi mirror"
+}
+
 setup_prepare()
 {
 	swp1=${NETIFS[p1]}
-- 
2.21.1

