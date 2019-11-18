Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C26FFFCA
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfKRHuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:50:44 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38185 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726865AbfKRHum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 02:50:42 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 91A0D22465;
        Mon, 18 Nov 2019 02:50:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 18 Nov 2019 02:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=1yumeJJdCl5TXJkCxkM31nClPOnDgJEtkBXnwzoChoE=; b=EIbakuQN
        A9GBJ8lSY9xTW15rsCXoaANnSFeLsb6eRwyHYQT9eCduBD5dUSImfWa716oE99oM
        VNhzee0Ze7DLhlRi58SejG1qXOx6LL8qPZmLgl6L5pN065Jq2m3nTmCHZkhhTGoM
        Q3SxvTgAP6wEctH22HGIoX3ssoD7Ahj0Mb6xs3pdgKQxLyEdVfeSoSky7Jn5WpWq
        jPjIAonABZdXc/lPwvnoUBB2+tAg+O1RFHzXlphVd7iDGb42TYjmrB0ZwZEuqQnD
        ZKB4zMdQLckCxh8W8btCNGoJ6Tib8Rehq+ty69MZEKbEQPTIrZFHlKzhqCDgbQ9E
        NNI7Qo7lKSmcLg==
X-ME-Sender: <xms:UU3SXUFJtQdgr7nfLgLy9qquC1o6WMMyUlPpuxUbB2qybaUEyPpY4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:UU3SXeFlYnSM5RFmdgvm2vkGp8WryszZ9yEPvt2vl_oS18BRwnaAbQ>
    <xmx:UU3SXaSlCY7B6GStMXyPIqaYuh5Ek1M_OR0NGfW5c4WuBeJoX13kRg>
    <xmx:UU3SXXJVJR7wXEOqbr4fCB5wLbqpcyYR6siPHBrrr9wMU-w4hwUA2w>
    <xmx:UU3SXV704s5g440B6MHKs-GXaoY-f8Wpu6W4kseDM7zGa3UQ_CrRtQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C06693060060;
        Mon, 18 Nov 2019 02:50:39 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        mlxsw@mellanox.com, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/5] selftests: forwarding: Add speed and auto-negotiation test
Date:   Mon, 18 Nov 2019 09:50:02 +0200
Message-Id: <20191118075002.1699-6-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191118075002.1699-1-idosch@idosch.org>
References: <20191118075002.1699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Check configurations and packets transference with different variations
of autoneg and speed.

Test plan:
1. Test force of same speed with autoneg off
2. Test force of different speeds with autoneg off (should fail)
3. One side is autoneg on and other side sets force of common speeds
4. One side is autoneg on and other side only advertises a subset of the
   common speeds (one speed of the subset)
5. One side is autoneg on and other side only advertises a subset of the
   common speeds. Check that highest speed is negotiated
6. Test autoneg on, but each side advertises different speeds (should
   fail)

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/ethtool.sh       | 318 ++++++++++++++++++
 1 file changed, 318 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool.sh

diff --git a/tools/testing/selftests/net/forwarding/ethtool.sh b/tools/testing/selftests/net/forwarding/ethtool.sh
new file mode 100755
index 000000000000..eb8e2a23bbb4
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ethtool.sh
@@ -0,0 +1,318 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
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
+source lib.sh
+source ethtool_lib.sh
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
+	local adver=$1; shift
+
+	local -a speeds_arr
+
+	speeds_arr=($(common_speeds_get $dev1 $dev2 $with_mode $adver))
+	if [[ ${#speeds_arr[@]} < 2 ]]; then
+		check_err 1 "cannot check different speeds. There are not enough speeds"
+	fi
+
+	echo ${speeds_arr[0]} ${speeds_arr[1]}
+}
+
+same_speeds_autoneg_off()
+{
+	# Check that when each of the reported speeds is forced, the links come
+	# up and are operational.
+	local -a speeds_arr=($(common_speeds_get $h1 $h2 0 0))
+
+	for speed in "${speeds_arr[@]}"; do
+		RET=0
+		ethtool_set $h1 speed $speed autoneg off
+		ethtool_set $h2 speed $speed autoneg off
+
+		setup_wait_dev_with_timeout $h1
+		setup_wait_dev_with_timeout $h2
+		ping_do $h1 192.0.2.2
+		check_err $? "speed $speed autoneg off"
+		log_test "force of same speed autoneg off"
+		log_info "speed = $speed"
+	done
+
+	ethtool -s $h2 autoneg on
+	ethtool -s $h1 autoneg on
+}
+
+different_speeds_autoneg_off()
+{
+	# Test that when we force different speeds, links are not up and ping
+	# fails.
+	RET=0
+
+	local -a speeds_arr=($(different_speeds_get $h1 $h2 0 0))
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
+	# Test that when one device is forced to a speed supported by both
+	# endpoints and the other device is configured to autoneg on, the links
+	# are up and ping passes.
+	local -a speeds_arr=($(common_speeds_get $h1 $h2 0 1))
+
+	for speed in "${speeds_arr[@]}"; do
+		RET=0
+		ethtool_set $h1 speed $speed autoneg off
+
+		setup_wait_dev_with_timeout $h1
+		setup_wait_dev_with_timeout $h2
+		ping_do $h1 192.0.2.2
+		check_err $? "h1-speed=$speed autoneg off, h2 autoneg on"
+		log_test "one side with autoneg off and another with autoneg on"
+		log_info "force speed = $speed"
+	done
+
+	ethtool -s $h1 autoneg on
+}
+
+hex_speed_value_get()
+{
+	local speed=$1; shift
+
+	local shift_size=${speed_values[$speed]}
+	speed=$((0x1 << $"shift_size"))
+	printf "%#x" "$speed"
+}
+
+subset_of_common_speeds_get()
+{
+	local dev1=$1; shift
+	local dev2=$1; shift
+	local adver=$1; shift
+
+	local -a speeds_arr=($(common_speeds_get $dev1 $dev2 0 $adver))
+	local speed_to_advertise=0
+	local speed_to_remove=${speeds_arr[0]}
+	speed_to_remove+='base'
+
+	local -a speeds_mode_arr=($(common_speeds_get $dev1 $dev2 1 $adver))
+
+	for speed in ${speeds_mode_arr[@]}; do
+		if [[ $speed != $speed_to_remove* ]]; then
+			speed=$(hex_speed_value_get $speed)
+			speed_to_advertise=$(($speed_to_advertise | \
+						$speed))
+		fi
+
+	done
+
+	# Convert to hex.
+	printf "%#x" "$speed_to_advertise"
+}
+
+speed_to_advertise_get()
+{
+	# The function returns the hex number that is composed by OR-ing all
+	# the modes corresponding to the provided speed.
+	local speed_without_mode=$1; shift
+	local supported_speeds=("$@"); shift
+	local speed_to_advertise=0
+
+	speed_without_mode+='base'
+
+	for speed in ${supported_speeds[@]}; do
+		if [[ $speed == $speed_without_mode* ]]; then
+			speed=$(hex_speed_value_get $speed)
+			speed_to_advertise=$(($speed_to_advertise | \
+						$speed))
+		fi
+
+	done
+
+	# Convert to hex.
+	printf "%#x" "$speed_to_advertise"
+}
+
+advertise_subset_of_speeds()
+{
+	# Test that when one device advertises a subset of speeds and another
+	# advertises a specific speed (but all modes of this speed), the links
+	# are up and ping passes.
+	RET=0
+
+	local speed_1_to_advertise=$(subset_of_common_speeds_get $h1 $h2 1)
+	ethtool_set $h1 advertise $speed_1_to_advertise
+
+	if [ $RET != 0 ]; then
+		log_test "advertise subset of speeds"
+		return
+	fi
+
+	local -a speeds_arr_without_mode=($(common_speeds_get $h1 $h2 0 1))
+	# Check only speeds that h1 advertised. Remove the first speed.
+	unset speeds_arr_without_mode[0]
+	local -a speeds_arr_with_mode=($(common_speeds_get $h1 $h2 1 1))
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
+		log_test "advertise subset of speeds"
+		log_info "h1=$speed_1_to_advertise, h2=$speed_2_to_advertise"
+	done
+
+	ethtool -s $h2 autoneg on
+	ethtool -s $h1 autoneg on
+}
+
+check_highest_speed_is_chosen()
+{
+	# Test that when one device advertises a subset of speeds, the other
+	# chooses the highest speed. This test checks configuration without
+	# traffic.
+	RET=0
+
+	local max_speed
+	local chosen_speed
+	local speed_to_advertise=$(subset_of_common_speeds_get $h1 $h2 1)
+
+	ethtool_set $h1 advertise $speed_to_advertise
+
+	if [ $RET != 0 ]; then
+		log_test "check highest speed"
+		return
+	fi
+
+	local -a speeds_arr=($(common_speeds_get $h1 $h2 0 1))
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
+	# links are not up and ping fails.
+	RET=0
+
+	local -a speeds=($(different_speeds_get $h1 $h2 1 1))
+	local speed1=${speeds[0]}
+	local speed2=${speeds[1]}
+
+	speed1=$(hex_speed_value_get $speed1)
+	speed2=$(hex_speed_value_get $speed2)
+
+	ethtool_set $h1 advertise $speed1
+	ethtool_set $h2 advertise $speed2
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
+declare -gA speed_values
+eval "speed_values=($(speeds_arr_get))"
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.21.0

