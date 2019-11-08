Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040A4F50E6
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfKHQTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:19:17 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60362 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727221AbfKHQTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:19:15 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:19:13 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GJB6Z005013;
        Fri, 8 Nov 2019 18:19:12 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GJBm1030107;
        Fri, 8 Nov 2019 18:19:11 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GJBc3030106;
        Fri, 8 Nov 2019 18:19:11 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 09/10] netdevsim: Add devlink subdev sefltest for netdevsim
Date:   Fri,  8 Nov 2019 18:18:45 +0200
Message-Id: <1573229926-30040-10-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test will assign hw_addr to all registered subdevs and query it.

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 55 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index ee89cd2f5bee..15e0911df871 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -5,12 +5,13 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
 	   netns_reload_test resource_test dev_info_test \
-	   empty_reporter_test dummy_reporter_test"
+	   empty_reporter_test dummy_reporter_test subdev_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
 BUS_ADDR=10
 PORT_COUNT=4
+VF_COUNT=4
 DEV_NAME=netdevsim$BUS_ADDR
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
@@ -428,10 +429,60 @@ dummy_reporter_test()
 	log_test "dummy reporter test"
 }
 
+subdev_attr_get()
+{
+	local handle=$1
+	local name=$2
+
+	cmd_jq "devlink subdev show $handle -j" '.[][].'$name
+}
+
+subdev_objects_get()
+{
+	local handle=$1
+
+	cmd_jq "devlink subdev show -j" \
+	       '.[] | keys[] | select(contains("'$handle'"))'
+}
+
+subdev_attr_set()
+{
+	local handle=$1
+	local name=$2
+	local value=$3
+
+	devlink subdev set $handle $name $value
+}
+
+subdev_test()
+{
+	RET=0
+
+	local subdevs=`subdev_objects_get $DL_HANDLE`
+	local num_subdevs=`echo $subdevs | wc -w`
+	[ $num_subdevs == $VF_COUNT ]
+	check_err $? "Expected $VF_COUNT subdevs but got $num_subdevs"
+
+	i=1
+	for subdev in $subdevs
+	do
+		local hw_addr=`printf "10:22:33:44:55:%02x" $i`
+
+		subdev_attr_set "$subdev" hw_addr $hw_addr
+		check_err $? "Failed to set hw_addr value"
+		value=$(subdev_attr_get $subdev hw_addr)
+		check_err $? "Failed to get hw_addr attr value"
+		[ "$value" == "$hw_addr" ]
+		check_err $? "Unexpected hw_addr attr value $value != $hw_addr"
+		i=$(($i+1))
+	done
+	log_test "subdev test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-	echo "$BUS_ADDR $PORT_COUNT" > /sys/bus/netdevsim/new_device
+	echo "$BUS_ADDR $PORT_COUNT $VF_COUNT" > /sys/bus/netdevsim/new_device
 	while [ ! -d $SYSFS_NET_DIR ] ; do :; done
 }
 
-- 
2.17.1

