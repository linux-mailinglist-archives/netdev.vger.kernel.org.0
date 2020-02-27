Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A5C1711B7
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgB0Huc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:32 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46483 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbgB0Hua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id j7so1995332wrp.13
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IQSqhv3gQjmQAlmfbYZiLUfJL9sse2D9bBNEvcjkVYU=;
        b=pxjZqkQdMlhalQhtwqy2yTqHhJDcOhtINz15jOXXGKwltVT5Dw0T1zmJMDqthwrSS1
         /Ll1Kk+MTjx0jw9ZLWfvJSYBd4u3GFfoclhkdj7LKmGM98MtgoTRkhhOL3yQWNDZtNPo
         7pLwrbqRkSzYhhQIT8xgJiaHOI4tiXEbsimsDJFPnNa6siHK+peQzySGfWf0uOaYB0j1
         75dmAHnvoV4noqRYQnTLPQTItw2woHdSzSa0AZrer3Lmrhh8GwWk5FHTYTLE6pkkr7wX
         Ft5XIeHnC3WNRgYGi/tt0l7FjbGGPSZM1Ohfp/Pa77cVJsKWVRSig1kVpcNB8nnBLVej
         eJdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IQSqhv3gQjmQAlmfbYZiLUfJL9sse2D9bBNEvcjkVYU=;
        b=QBjWJuVt/ntYNun4UjXeuidgKgPJ9NWDSa69hUsjbKNW2L2D9I+n8NUkQLST0QH06x
         KNQ+fe3BAhTMAW+Mo1BnmvIljsG8avRtiyVrWbgT7CXcPM+oOje4KUumSV2gB8FpSCuR
         IMP0c67wWU7g4iikaa1u45ablvD2x/v+Qt4MrN6qlCQZ20z4/PxjhC1McJNMLqJBYpWc
         bFZDWV29PMFQE6rfNtOSe8/7z7KriTIQfBemqpwPzYkih6OFn8bz5xPZeVjZz48x8tBD
         XzCUDsrdA/KEXS9OhZasxYYpTbZOdLanFA39Ob1aYGLWEan1MYi3hXReD+CSo6OonQga
         eWfA==
X-Gm-Message-State: APjAAAVcFcxnip9u+LYdN3FxZFAP3uT7ZInx6THed/Ik1gp31vyRPZF3
        ReDRklZOPWO5uH30GC/M37KNMhY6iYY=
X-Google-Smtp-Source: APXvYqzAM24N8YwrUU1XH4lp9Nzaam6g70Bj7PSNKNCRcsJj1yCm2rOMiKGJtUW+j2eJDLFVWsQH7Q==
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr3208223wrp.167.1582789828687;
        Wed, 26 Feb 2020 23:50:28 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id h10sm6652630wml.18.2020.02.26.23.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:28 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 05/16] selftests: devlink_trap_l3_drops: Avoid race condition
Date:   Thu, 27 Feb 2020 08:50:10 +0100
Message-Id: <20200227075021.3472-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The test checks that packets are trapped when they should egress a
router interface (RIF) that has become disabled. This is a temporary
state in a RIF's deletion sequence.

Currently, the test deletes the RIF by flushing all the IP addresses
configured on the associated netdev (br0). However, this is racy, as
this also flushes all the routes pointing to the netdev and if the
routes are deleted from the device before the RIF is disabled, then no
packets will try to egress the disabled RIF and the trap will not be
triggered.

Instead, trigger the deletion of the RIF by unlinking the mlxsw port
from the bridge that is backing the RIF. Unlike before, this will not
cause the kernel to delete the routes pointing to the bridge.

Note that due to current mlxsw locking scheme the RIF is always deleted
first, but this is going to change.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/mlxsw/devlink_trap_l3_drops.sh        | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
index 053e5c7b303d..616f47d86a61 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
@@ -641,13 +641,9 @@ erif_disabled_test()
 	mz_pid=$!
 
 	sleep 5
-	# In order to see this trap we need a route that points to disabled RIF.
-	# When ipv6 address is flushed, there is a delay and the routes are
-	# deleted before the RIF and we cannot get state that we have route
-	# to disabled RIF.
-	# Delete IPv6 address first and then check this trap with flushing IPv4.
-	ip -6 add flush dev br0
-	ip -4 add flush dev br0
+	# Unlinking the port from the bridge will disable the RIF associated
+	# with br0 as it is no longer an upper of any mlxsw port.
+	ip link set dev $rp1 nomaster
 
 	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
 	t1_bytes=$(devlink_trap_rx_bytes_get $trap_name)
@@ -659,7 +655,6 @@ erif_disabled_test()
 	log_test "Egress RIF disabled"
 
 	kill $mz_pid && wait $mz_pid &> /dev/null
-	ip link set dev $rp1 nomaster
 	__addr_add_del $rp1 add 192.0.2.2/24 2001:db8:1::2/64
 	ip link del dev br0 type bridge
 	devlink_trap_action_set $trap_name "drop"
-- 
2.21.1

