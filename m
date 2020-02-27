Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A821711B6
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgB0Hue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:34 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:32836 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgB0Hub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:31 -0500
Received: by mail-wm1-f43.google.com with SMTP id m10so6342220wmc.0
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IAQxSzVXZys9GhkIrPqglRbI2DnOG8JPgiF2m5M8aTI=;
        b=fF1j27SI0nEaDwfmVerXui2F42L3FY1hxpG8K1/dYmh0MmE1Il7K9GB0WU7otDTiVm
         luI7YDRwcAUq6UvIWzOq4ZznHk/9waiPaqCiGcjGPwWXYjhGFmUG60y3O5+xD7mYQ/LW
         fu3kf9p7Vi1pJLJmcnFuiWslQkF9Bm+k5ky5Hwb6g1X08UgHS1kOjUkkSprhIYz7EhcO
         sUwwoApOljFcYB+SRd6rKbU6Q4QtCECL+2pc7R3WebZ6Ky6PJ8rZuH53x9sRMvFcB374
         fEhrYFdIyWNcHjNjwkN3hgIZyB9nsUpqxvEZuPFANmK/z1gt+9mYzxFl9nNtHUZKwOyx
         S93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IAQxSzVXZys9GhkIrPqglRbI2DnOG8JPgiF2m5M8aTI=;
        b=Iq5+LfmCK/dIAt2uy8ccy7oJYUsVeorYZcc2rVbiCxl6mSgiq5h4CfQ2QFRjhpoiri
         FeCpAxdEDsSoFLvD9Djgd/hM+qRGxLe3/42YVW7y7Jn0wKVO8Uhru6ic49ErIpBU+Ovp
         lFhMuvXN6ZGMPs9YNaCP/h/8/i9pgXMufGCTwMLet2oTJnMOWm2IOmuzD8M8Z/IhfGkJ
         q5LDlAr85nZNwDeI4UQzQPxD8cwVvardXiFqZ8xRWGz6N2I44Ty2NQGpa+TCRf96hF4e
         updSVrKhSt+jwjoAzx26l6GONgYNGZkHiGgze75BUZvkCh/W4wkawjrXNFFkQkFW/85l
         dbyw==
X-Gm-Message-State: APjAAAVJvNfw8l2GWcpZTGNwAUht1CgPLaD38271QSS1sRRS1yQQTUkX
        0Oc8ViB+m7HzSDGXIeDqAmgD8LnmUDY=
X-Google-Smtp-Source: APXvYqzhWMD5m+KK8jmyJTVoQUbfGdvkfiuX04QFw6WexD+ZklKAx5/b6BeQS+UbvBSWgIzJbu50zw==
X-Received: by 2002:a1c:1b86:: with SMTP id b128mr3435635wmb.64.1582789829912;
        Wed, 26 Feb 2020 23:50:29 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id g10sm7144770wrr.13.2020.02.26.23.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:29 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 06/16] selftests: mlxsw: Use busywait helper in blackhole routes test
Date:   Thu, 27 Feb 2020 08:50:11 +0100
Message-Id: <20200227075021.3472-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Blackhole routes test uses offload indication checks.

Use busywait helper and wait until the routes offload indication is set or
fail if it reaches timeout.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../testing/selftests/drivers/net/mlxsw/blackhole_routes.sh  | 5 +++--
 tools/testing/selftests/net/forwarding/lib.sh                | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/blackhole_routes.sh b/tools/testing/selftests/drivers/net/mlxsw/blackhole_routes.sh
index 5ba5bef44d5b..bdffe698e1d1 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/blackhole_routes.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/blackhole_routes.sh
@@ -45,6 +45,7 @@ ALL_TESTS="
 	blackhole_ipv6
 "
 NUM_NETIFS=4
+: ${TIMEOUT:=20000} # ms
 source $lib_dir/tc_common.sh
 source $lib_dir/lib.sh
 
@@ -123,7 +124,7 @@ blackhole_ipv4()
 		skip_hw dst_ip 198.51.100.1 src_ip 192.0.2.1 ip_proto icmp \
 		action pass
 
-	ip -4 route show 198.51.100.0/30 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload ip -4 route show 198.51.100.0/30
 	check_err $? "route not marked as offloaded when should"
 
 	ping_do $h1 198.51.100.1
@@ -147,7 +148,7 @@ blackhole_ipv6()
 		skip_hw dst_ip 2001:db8:2::1 src_ip 2001:db8:1::1 \
 		ip_proto icmpv6 action pass
 
-	ip -6 route show 2001:db8:2::/120 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload ip -6 route show 2001:db8:2::/120
 	check_err $? "route not marked as offloaded when should"
 
 	ping6_do $h1 2001:db8:2::1
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index aff3178edf6d..5ea33c72f468 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -248,6 +248,11 @@ busywait()
 	done
 }
 
+wait_for_offload()
+{
+	"$@" | grep -q offload
+}
+
 until_counter_is()
 {
 	local value=$1; shift
-- 
2.21.1

