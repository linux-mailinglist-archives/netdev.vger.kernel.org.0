Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144163B0D4
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbfFJIln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:41:43 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42639 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388111AbfFJIlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 04:41:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6665521E44;
        Mon, 10 Jun 2019 04:41:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 Jun 2019 04:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=V+MBD0xWM2dUqYkQreHUVRzx3fDiTfvx5ktBSBzpVn4=; b=E3h/9gPm
        DEuXLfTu9qMFLRhIFW/q/WH+S+9VwK7WiivEw7aC7AitTpR4eaeFo0STTsvVTDo2
        55ELzNP2OOw+CmEEUSUrGXRZ4TnUm5fRSy9IOjwNeTDCdctf6lcNktPrQvzl2YdQ
        xrO1BNfYqAyGhIRo0Wl+iMw0mOxlauQpHfwyr3kX6IOHliDS33VYaXeIEuwo1iFL
        sExKsd4iSakuef0j6zQ2Y/nsxVH5O+3ZL/U6MVaU5I1y5MudUbGztAFwS65Z9BNs
        rGvyc15YLVAkLBWfKlLLw4ySRrfQXmDc4LwJduXHw2iTQUOTicRUkPp0efBjyzPk
        UbwEm2IP9kkZUQ==
X-ME-Sender: <xms:xRf-XFTb_P55KGGsjv_MWrghd-5SpSoUoFI3q8jKbkBF9nvFCVy9JA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:xRf-XDDQS2lC3H1cBI0kGvY6TwQZh18YXkQDFLTYYeUQpqGbsnxk0A>
    <xmx:xRf-XF2xPUDVTGQgnqGJZcu6Ag_J2NhkBw8Ruk77GyoLLp6MrrFfAw>
    <xmx:xRf-XBUcWf6F_tvxZQVUzoroUUZBpt-fb7Q6ReHoH7mRY-jGNhOYvA>
    <xmx:xRf-XLjRNYYYEf6VpGHdFE2hY0pDuDz1Jz9R-aKlHVdZAxK5lOY4gw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1403580060;
        Mon, 10 Jun 2019 04:41:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/3] selftests: mlxsw: Add speed and auto-negotiation test
Date:   Mon, 10 Jun 2019 11:40:45 +0300
Message-Id: <20190610084045.6029-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610084045.6029-1-idosch@idosch.org>
References: <20190610084045.6029-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Check configurations and packets transference
with different variations of autoneg and speed.

Test plan:
1. Test force of same speed with autoneg off
2. Test force of different speeds with autoneg off (should fail)
3. One side is autoneg on and other side sets force of common speeds
4. One side is autoneg on and other side only advertises a subset of the common
   speeds (one speed of the subset.)
5. One side is autoneg on and other side only advertises a subset of the
   common speeds. Check that highest speed is negotiated
6. Test autoneg on, but each side advertises different speeds (should fail)

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/ethtool.sh    | 308 ++++++++++++++++++
 1 file changed, 308 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ethtool.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/ethtool.sh b/tools/testing/selftests/drivers/net/mlxsw/ethtool.sh
new file mode 100755
index 000000000000..cbf8dbcc375a
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/ethtool.sh
@@ -0,0 +1,308 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	same_speeds_autoneg_off
+	different_speeds_autoneg_off
+	combination_of_neg_on_and_off
+	advertise_subset_of_speeds
+	check_highest_speed_is_chosen
+	different_speeds_autoneg_on
+"
+NUM_NETIFS=2
+source $lib_dir/lib.sh
+source $lib_dir/ethtool_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/24
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 192.0.2.2/24
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
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
+}
+
+different_speeds_get()
+{
+	local dev1=$1; shift
+	local dev2=$1; shift
+	local with_mode=$1; shift
+
+	local -a speeds_arr
+
+	speeds_arr=($(common_speeds_get $dev1 $dev2 $with_mode))
+
+	if [[ ${#speeds_arr[@]} < 2 ]]; then
+		check_err 1 "cannot check different speeds. There are not enough speeds"
+	fi
+
+	echo ${speeds_arr[0]} ${speeds_arr[1]}
+}
+
+same_speeds_autoneg_off()
+{
+	# Check that when each of the reported speeds
+	# is forced, the link comes up and is operational.
+	local -a speeds_arr=($(common_speeds_get $h1 $h2 0))
+	for speed in "${speeds_arr[@]}"; do
+		# Skip 56G because this speed isn't supported with autoneg off.
+		if [[ $speed == 56000 ]]; then
+			continue
+		fi
+
+		RET=0
+		ethtool_set $h1 speed $speed autoneg off
+		ethtool_set $h2 speed $speed autoneg off
+
+		setup_wait_dev_with_timeout $h1
+		setup_wait_dev_with_timeout $h2
+		ping_do $h1 192.0.2.2
+		check_err $? " speed $speed autoneg off"
+		log_test "force of same speed ($speed) autoneg off"
+	done
+
+	ethtool -s $h2 autoneg on
+	ethtool -s $h1 autoneg on
+}
+
+different_speeds_autoneg_off()
+{
+	# Test that when we force different speeds,
+	# links aren't up and ping fails.
+	RET=0
+
+	local -a speeds_arr=($(different_speeds_get $h1 $h2 0))
+	local speed1=${speeds_arr[0]}
+	local speed2=${speeds_arr[1]}
+
+	ethtool_set $h1 speed $speed1 autoneg off
+	ethtool_set $h2 speed $speed2 autoneg off
+
+	setup_wait_dev_with_timeout $h1
+	setup_wait_dev_with_timeout $h2
+	ping_do $h1 192.0.2.2
+	check_fail $? "ping with different speeds"
+
+	log_test "force of different speeds autoneg off"
+
+	ethtool -s $h2 autoneg on
+	ethtool -s $h1 autoneg on
+}
+
+combination_of_neg_on_and_off()
+{
+	# Test that when one dev is forced to a speed supported
+	# by both endpoints and the other dev is configured to autoneg on,
+	# the links are up and ping succeeds.
+	local -a speeds_arr=($(common_speeds_get $h1 $h2 0))
+
+	for speed in "${speeds_arr[@]}"; do
+		# Skip 56G because this speed isn't supported with autoneg off.
+		if [[ $speed == 56000 ]]; then
+			continue
+		fi
+
+		RET=0
+		ethtool_set $h1 speed $speed autoneg off
+
+		setup_wait_dev_with_timeout $h1
+		setup_wait_dev_with_timeout $h2
+		ping_do $h1 192.0.2.2
+		check_err $? "h1-speed=$speed autoneg off, h2 autoneg on"
+		log_test "one side with autoneg off (speed = $speed) and another with autoneg on"
+	done
+
+	ethtool -s $h1 autoneg on
+}
+
+subset_of_common_speeds_get()
+{
+	local dev1=$1; shift
+	local dev2=$1; shift
+
+	local -a speeds_arr=($(common_speeds_get $dev1 $dev2 0))
+	local speed_to_advertise=0
+	local speed_to_remove=${speeds_arr[0]}
+	# If speed_to_remove=x we don't want to remove also speeds
+	# that start with x000.. so add 'base' to limit the speed.
+	speed_to_remove+='base'
+
+	local -a speeds_mode_arr=($(common_speeds_get $dev1 $dev2 1))
+
+	for speed in ${speeds_mode_arr[@]}; do
+		if [[ $speed != $speed_to_remove* ]]; then
+			speed_to_advertise=$(($speed_to_advertise | \
+				${speed_values[$speed]}))
+		fi
+
+	done
+	# Convert to hex base
+	printf "%#x" "$speed_to_advertise"
+}
+
+speed_to_advertise_get()
+{
+	# The function returns the hex number that is appropriate to
+	# all modes of the parameter - speed_without_mode
+	local speed_without_mode=$1; shift
+	local supported_speeds=("$@"); shift
+	local speed_to_advertise=0
+
+	# If speed_without_mode=x we don't want to match also speeds
+	# that start with x000.. so add 'base' to limit the speed.
+	speed_without_mode+='base'
+	for speed in ${supported_speeds[@]}; do
+		if [[ $speed == $speed_without_mode* ]]; then
+			speed_to_advertise=$(($speed_to_advertise | \
+				${speed_values[$speed]}))
+		fi
+
+	done
+
+	# Convert to hex base
+	printf "%#x" "$speed_to_advertise"
+}
+advertise_subset_of_speeds()
+{
+	# Test that when one dev advertises a subset of speeds
+	# and another advertises a specific speed (but all modes of this speed),
+	# the links are up and ping success.
+	RET=0
+
+	local speed_1_to_advertise=$(subset_of_common_speeds_get $h1 $h2)
+	ethtool_set $h1 advertise $speed_1_to_advertise
+
+	if [ $RET != 0 ]; then
+		log_test "advertise subset of speeds"
+		return
+	fi
+
+	local -a speeds_arr_without_mode=($(common_speeds_get $h1 $h2 0))
+	# Check only speeds that h1 advertised. remove the first speed.
+	unset speeds_arr_without_mode[0]
+	local -a speeds_arr_with_mode=($(common_speeds_get $h1 $h2 1))
+
+	for speed_value in ${speeds_arr_without_mode[@]}; do
+		RET=0
+		local speed_2_to_advertise=$(speed_to_advertise_get $speed_value \
+			"${speeds_arr_with_mode[@]}")
+		ethtool_set $h2 advertise $speed_2_to_advertise
+
+		setup_wait_dev_with_timeout $h1
+		setup_wait_dev_with_timeout $h2
+		ping_do $h1 192.0.2.2
+		check_err $? "h1=$speed_1_to_advertise, h2=$speed_2_to_advertise ($speed_value)"
+
+		log_test "advertise subset of speeds (h1=$speed_1_to_advertise, h2=$speed_2_to_advertise)"
+	done
+
+	ethtool -s $h2 autoneg on
+	ethtool -s $h1 autoneg on
+}
+
+check_highest_speed_is_chosen()
+{
+	# Test that when one dev advertise subset of speeds,
+	# the other chooses the highest speed.
+	# This test checks configuration without traffic.
+	RET=0
+
+	local max_speed
+	local chosen_speed
+	local speed_to_advertise=$(subset_of_common_speeds_get $h1 $h2)
+
+	ethtool_set $h1 advertise $speed_to_advertise
+
+	if [ $RET != 0 ]; then
+		log_test "check highest speed."
+		return
+	fi
+
+	local -a speeds_arr=($(common_speeds_get $h1 $h2 0))
+	# Remove the first speed, h1 does not advertise this speed.
+	unset speeds_arr[0]
+
+	max_speed=${speeds_arr[0]}
+	for current in ${speeds_arr[@]}; do
+		if [[ $current -gt $max_speed ]]; then
+			max_speed=$current
+		fi
+	done
+
+	setup_wait_dev_with_timeout $h1
+	setup_wait_dev_with_timeout $h2
+	chosen_speed=$(ethtool $h1 | grep 'Speed:')
+	chosen_speed=${chosen_speed%"Mb/s"*}
+	chosen_speed=${chosen_speed#*"Speed: "}
+	((chosen_speed == max_speed))
+	check_err $? "h1 advertise $speed_to_advertise, h2 sync to speed $chosen_speed"
+
+	log_test "check highest speed"
+
+	ethtool -s $h2 autoneg on
+	ethtool -s $h1 autoneg on
+}
+
+different_speeds_autoneg_on()
+{
+	# Test that when we configure links to advertise different speeds,
+	# link aren't up and ping fails.
+	RET=0
+
+	local -a speeds=($(different_speeds_get $h1 $h2 1))
+	local speed1=${speeds[0]}
+	local speed2=${speeds[1]}
+
+	ethtool_set $h1 advertise ${speed_values[$speed1]}
+	ethtool_set $h2 advertise ${speed_values[$speed2]}
+
+	if (($RET)); then
+		setup_wait_dev_with_timeout $h1
+		setup_wait_dev_with_timeout $h2
+		ping_do $h1 192.0.2.2
+		check_fail $? "ping with different speeds autoneg on"
+	fi
+
+	log_test "advertise different speeds autoneg on"
+
+	ethtool -s $h2 autoneg on
+	ethtool -s $h1 autoneg on
+}
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
2.20.1

