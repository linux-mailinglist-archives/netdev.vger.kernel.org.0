Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E20B30C916
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbhBBSKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:10:02 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7651 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbhBBSHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:07:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601994ba0005>; Tue, 02 Feb 2021 10:06:50 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:06:48 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v4 8/8] net: selftests: Add lanes setting test
Date:   Tue, 2 Feb 2021 20:06:12 +0200
Message-ID: <20210202180612.325099-9-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202180612.325099-1-danieller@nvidia.com>
References: <20210202180612.325099-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612289211; bh=4wl74DmLlV6YxmKF2RHNLatqHdn+ugGRed0UbRVqqVI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=oDMGiiDhokzQ1qode+6lhKC8SAhPXCXcp+Geuv6+9UHDyj3pVysk0kp4A2Ti4DlpK
         Hdn9EBzwOK7UWqCiU2tXQouC8YT0RaBbo4jLlgx/Ajt69S0ZuX9DjXAuAWm1F7lUIf
         AI7SVEozz6iWmx7N1bEmjq8JJ5zCt/JNfZBIv+hp4pcBvwJ3SzPmAnOCe+92dGYJAd
         SIhIbHmnoCswZx4+A/mEHWyeatoI1aulGQl8gbBktV4/Ha1FJ93/6zwDlzDHfsp7LD
         IEVcE5SlMivjThyCyuH94xMWXuYA85uNSKbYGIDwBgZK8xJipiGqaNtGKk0SiJ1/Bz
         xzxVWpgnRmjWw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that setting lanes parameter is working.

Set max speed and max lanes in the list of advertised link modes,
and then try to set max speed with the lanes below max lanes if exists
in the list.

And then, test that setting number of lanes larger than max lanes fails.

Do the above for both autoneg on and off.

$ ./ethtool_lanes.sh

TEST: 4 lanes is autonegotiated                                     [ OK ]
TEST: Lanes number larger than max width is not set                 [ OK ]
TEST: Autoneg off, 4 lanes detected during force mode               [ OK ]
TEST: Lanes number larger than max width is not set                 [ OK ]

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v4:
    	* Change the check for lanes unsupported, to not having "Lanes"
    	  line at all.
   =20
    v3:
    	* Move the test to drivers/net/mlxsw.
   =20
    v2:
    	* Fix "then" to "than".
    	* Remove the test for recieving max_width when lanes is not set by
    	  user. When not setting lanes, we don't promise anything regarding
    	  what number of lanes will be chosen.
    	* Reword commit message.
    	* Reword the skip print when ethtool is old.

 .../drivers/net/mlxsw/ethtool_lanes.sh        | 187 ++++++++++++++++++
 .../selftests/net/forwarding/ethtool_lib.sh   |  34 ++++
 tools/testing/selftests/net/forwarding/lib.sh |  28 +++
 3 files changed, 249 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ethtool_lanes=
.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/ethtool_lanes.sh b/t=
ools/testing/selftests/drivers/net/mlxsw/ethtool_lanes.sh
new file mode 100755
index 000000000000..91891b9418d7
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/ethtool_lanes.sh
@@ -0,0 +1,187 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=3D$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS=3D"
+	autoneg
+	autoneg_force_mode
+"
+
+NUM_NETIFS=3D2
+: ${TIMEOUT:=3D30000} # ms
+source $lib_dir/lib.sh
+source $lib_dir/ethtool_lib.sh
+
+setup_prepare()
+{
+	swp1=3D${NETIFS[p1]}
+	swp2=3D${NETIFS[p2]}
+
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	busywait "$TIMEOUT" wait_for_port_up ethtool $swp2
+	check_err $? "ports did not come up"
+
+	local lanes_exist=3D$(ethtool $swp1 | grep 'Lanes:')
+	if [[ -z $lanes_exist ]]; then
+		log_test "SKIP: driver does not support lanes setting"
+		exit 1
+	fi
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+check_lanes()
+{
+	local dev=3D$1; shift
+	local lanes=3D$1; shift
+	local max_speed=3D$1; shift
+	local chosen_lanes
+
+	chosen_lanes=3D$(ethtool $dev | grep 'Lanes:')
+	chosen_lanes=3D${chosen_lanes#*"Lanes: "}
+
+	((chosen_lanes =3D=3D lanes))
+	check_err $? "swp1 advertise $max_speed and $lanes, devs sync to $chosen_=
lanes"
+}
+
+check_unsupported_lanes()
+{
+	local dev=3D$1; shift
+	local max_speed=3D$1; shift
+	local max_lanes=3D$1; shift
+	local autoneg=3D$1; shift
+	local autoneg_str=3D""
+
+	local unsupported_lanes=3D$((max_lanes *=3D 2))
+
+	if [[ $autoneg -eq 0 ]]; then
+		autoneg_str=3D"autoneg off"
+	fi
+
+	ethtool -s $swp1 speed $max_speed lanes $unsupported_lanes $autoneg_str &=
> /dev/null
+	check_fail $? "Unsuccessful $unsupported_lanes lanes setting was expected=
"
+}
+
+max_speed_and_lanes_get()
+{
+	local dev=3D$1; shift
+	local arr=3D("$@")
+	local max_lanes
+	local max_speed
+	local -a lanes_arr
+	local -a speeds_arr
+	local -a max_values
+
+	for ((i=3D0; i<${#arr[@]}; i+=3D2)); do
+		speeds_arr+=3D("${arr[$i]}")
+		lanes_arr+=3D("${arr[i+1]}")
+	done
+
+	max_values+=3D($(get_max "${speeds_arr[@]}"))
+	max_values+=3D($(get_max "${lanes_arr[@]}"))
+
+	echo ${max_values[@]}
+}
+
+search_linkmode()
+{
+	local speed=3D$1; shift
+	local lanes=3D$1; shift
+	local arr=3D("$@")
+
+	for ((i=3D0; i<${#arr[@]}; i+=3D2)); do
+		if [[ $speed -eq ${arr[$i]} && $lanes -eq ${arr[i+1]} ]]; then
+			return 1
+		fi
+	done
+	return 0
+}
+
+autoneg()
+{
+	RET=3D0
+
+	local lanes
+	local max_speed
+	local max_lanes
+
+	local -a linkmodes_params=3D($(dev_linkmodes_params_get $swp1 1))
+	local -a max_values=3D($(max_speed_and_lanes_get $swp1 "${linkmodes_param=
s[@]}"))
+	max_speed=3D${max_values[0]}
+	max_lanes=3D${max_values[1]}
+
+	lanes=3D$max_lanes
+
+	while [[ $lanes -ge 1 ]]; do
+		search_linkmode $max_speed $lanes "${linkmodes_params[@]}"
+		if [[ $? -eq 1 ]]; then
+			ethtool_set $swp1 speed $max_speed lanes $lanes
+			ip link set dev $swp1 up
+			ip link set dev $swp2 up
+			busywait "$TIMEOUT" wait_for_port_up ethtool $swp2
+			check_err $? "ports did not come up"
+
+			check_lanes $swp1 $lanes $max_speed
+			log_test "$lanes lanes is autonegotiated"
+		fi
+		let $((lanes /=3D 2))
+	done
+
+	check_unsupported_lanes $swp1 $max_speed $max_lanes 1
+	log_test "Lanes number larger than max width is not set"
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+autoneg_force_mode()
+{
+	RET=3D0
+
+	local lanes
+	local max_speed
+	local max_lanes
+
+	local -a linkmodes_params=3D($(dev_linkmodes_params_get $swp1 1))
+	local -a max_values=3D($(max_speed_and_lanes_get $swp1 "${linkmodes_param=
s[@]}"))
+	max_speed=3D${max_values[0]}
+	max_lanes=3D${max_values[1]}
+
+	lanes=3D$max_lanes
+
+	while [[ $lanes -ge 1 ]]; do
+		search_linkmode $max_speed $lanes "${linkmodes_params[@]}"
+		if [[ $? -eq 1 ]]; then
+			ethtool_set $swp1 speed $max_speed lanes $lanes autoneg off
+			ethtool_set $swp2 speed $max_speed lanes $lanes autoneg off
+			ip link set dev $swp1 up
+			ip link set dev $swp2 up
+			busywait "$TIMEOUT" wait_for_port_up ethtool $swp2
+			check_err $? "ports did not come up"
+
+			check_lanes $swp1 $lanes $max_speed
+			log_test "Autoneg off, $lanes lanes detected during force mode"
+		fi
+		let $((lanes /=3D 2))
+	done
+
+	check_unsupported_lanes $swp1 $max_speed $max_lanes 0
+	log_test "Lanes number larger than max width is not set"
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
+	ethtool -s $swp2 autoneg on
+	ethtool -s $swp1 autoneg on
+}
+
+check_ethtool_lanes_support
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ethtool_lib.sh b/tools/=
testing/selftests/net/forwarding/ethtool_lib.sh
index 9188e624dec0..b9bfb45085af 100644
--- a/tools/testing/selftests/net/forwarding/ethtool_lib.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
@@ -22,6 +22,40 @@ ethtool_set()
 	check_err $out "error in configuration. $cmd"
 }
=20
+dev_linkmodes_params_get()
+{
+	local dev=3D$1; shift
+	local adver=3D$1; shift
+	local -a linkmodes_params
+	local param_count
+	local arr
+
+	if (($adver)); then
+		mode=3D"Advertised link modes"
+	else
+		mode=3D"Supported link modes"
+	fi
+
+	local -a dev_linkmodes=3D($(dev_speeds_get $dev 1 $adver))
+	for ((i=3D0; i<${#dev_linkmodes[@]}; i++)); do
+		linkmodes_params[$i]=3D$(echo -e "${dev_linkmodes[$i]}" | \
+			# Replaces all non numbers with spaces
+			sed -e 's/[^0-9]/ /g' | \
+			# Squeeze spaces in sequence to 1 space
+			tr -s ' ')
+		# Count how many numbers were found in the linkmode
+		param_count=3D$(echo "${linkmodes_params[$i]}" | wc -w)
+		if [[ $param_count -eq 1 ]]; then
+			linkmodes_params[$i]=3D"${linkmodes_params[$i]} 1"
+		elif [[ $param_count -ge 3 ]]; then
+			arr=3D(${linkmodes_params[$i]})
+			# Take only first two params
+			linkmodes_params[$i]=3D$(echo "${arr[@]:0:2}")
+		fi
+	done
+	echo ${linkmodes_params[@]}
+}
+
 dev_speeds_get()
 {
 	local dev=3D$1; shift
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/=
selftests/net/forwarding/lib.sh
index 31ce478686cb..26cfc778ff26 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -69,6 +69,15 @@ check_tc_action_hw_stats_support()
 	fi
 }
=20
+check_ethtool_lanes_support()
+{
+	ethtool --help 2>&1| grep lanes &> /dev/null
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: ethtool too old; it is missing lanes support"
+		exit 1
+	fi
+}
+
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
 	exit 0
@@ -263,6 +272,20 @@ not()
 	[[ $? !=3D 0 ]]
 }
=20
+get_max()
+{
+	local arr=3D("$@")
+
+	max=3D${arr[0]}
+	for cur in ${arr[@]}; do
+		if [[ $cur -gt $max ]]; then
+			max=3D$cur
+		fi
+	done
+
+	echo $max
+}
+
 grep_bridge_fdb()
 {
 	local addr=3D$1; shift
@@ -279,6 +302,11 @@ grep_bridge_fdb()
 	$@ | grep $addr | grep $flag "$word"
 }
=20
+wait_for_port_up()
+{
+	"$@" | grep -q "Link detected: yes"
+}
+
 wait_for_offload()
 {
 	"$@" | grep -q offload
--=20
2.26.2

