Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0A5E0AE5
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732340AbfJVRn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:43:28 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55875 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730432AbfJVRn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:43:27 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 19:43:24 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MHhNLm005593;
        Tue, 22 Oct 2019 20:43:24 +0300
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id x9MHhNEZ023995;
        Tue, 22 Oct 2019 20:43:23 +0300
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id x9MHhNXk023994;
        Tue, 22 Oct 2019 20:43:23 +0300
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next 8/9] netdevsim: Add devlink vdev sefltest for netdevsim
Date:   Tue, 22 Oct 2019 20:43:09 +0300
Message-Id: <1571766190-23943-9-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test will assign hw_addr to all registered vdevs and query it.

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 55 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index ee89cd2f5bee..88ddf65b7897 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -5,12 +5,13 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
 	   netns_reload_test resource_test dev_info_test \
-	   empty_reporter_test dummy_reporter_test"
+	   empty_reporter_test dummy_reporter_test vdev_test"
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
 
+vdev_attr_get()
+{
+	local handle=$1
+	local name=$2
+
+	cmd_jq "devlink vdev show $handle -j" '.[][].'$name
+}
+
+vdev_objects_get()
+{
+	local handle=$1
+
+	cmd_jq "devlink vdev show -j" \
+	       '.[] | keys[] | select(contains("'$handle'"))'
+}
+
+vdev_attr_set()
+{
+	local handle=$1
+	local name=$2
+	local value=$3
+
+	devlink vdev set $handle $name $value
+}
+
+vdev_test()
+{
+	RET=0
+
+	local vdevs=`vdev_objects_get $DL_HANDLE`
+	local num_vdevs=`echo $vdevs | wc -w`
+	[ $num_vdevs == $VF_COUNT ]
+	check_err $? "Expected $VF_COUNT vdevs but got $num_vdevs"
+
+	i=1
+	for vdev in $vdevs
+	do
+		local hw_addr=`printf "10:22:33:44:55:%02x" $i`
+
+		vdev_attr_set "$vdev" hw_addr $hw_addr
+		check_err $? "Failed to set hw_addr value"
+		value=$(vdev_attr_get $vdev hw_addr)
+		check_err $? "Failed to get hw_addr attr value"
+		[ "$value" == "$hw_addr" ]
+		check_err $? "Unexpected hw_addr attr value $value != $hw_addr"
+		i=$(($i+1))
+	done
+	log_test "vdev test"
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

