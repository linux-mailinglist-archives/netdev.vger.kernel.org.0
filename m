Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DB627E707
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgI3Ktx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:49:53 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17966 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbgI3Ktr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:49:47 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7462be0000>; Wed, 30 Sep 2020 03:49:34 -0700
Received: from localhost.localdomain (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 10:49:44 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 5/6] selftests: mlxsw: Add headroom handling test
Date:   Wed, 30 Sep 2020 12:49:11 +0200
Message-ID: <91d0e8dc68f7872786efec714b050135357e599a.1601462261.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1601462261.git.petrm@nvidia.com>
References: <cover.1601462261.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601462974; bh=oQfgVOPxDQKK7XU6E5QSXiSXQjUwa3cFJyndW8MUW8U=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=hGP5cXq1DEjAg+Cz48wy+lSE1ZYC35M7E8QtFLRu0hEXQbb2JbVnvXK7Pz3c5ofN1
         QALNa9gQYsXlZmmnQXMSOLjLcBYKuNIrCsCx6U08NmTavodeFki9Yh0DXz6Eluq04w
         A+TaSxqj9RK31HosvkJMqktJmLl5h9S3WkdPE3nv9fgUSI0XYNx1KDS+j2TZS5v8FY
         qGd+xkYueghfMLAy5GSD4micP7I3GFlI6TVfmSely57dPsrWSDnwKqRtYKdcf1daUh
         nuMPGwK+k4I2QB59k6O8vbt/02uxDFg0WnCZomUSCXQ+cRwFlOZUOU2W85r1RD6gOY
         AmxmfBtUQ0exA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test for headroom configuration. This covers projection of ETS
configuration to ingress, PFC, adjustments for MTU, the qdisc / TC
mode and the effect of egress SPAN session on buffer configuration.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/qos_headroom.sh         | 379 ++++++++++++++++++
 1 file changed, 379 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_headroom.=
sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh b/to=
ols/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
new file mode 100755
index 000000000000..27de3d9ed08e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
@@ -0,0 +1,379 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS=3D"
+	test_defaults
+	test_dcb_ets
+	test_mtu
+	test_pfc
+	test_int_buf
+	test_tc_priomap
+	test_tc_mtu
+	test_tc_sizes
+	test_tc_int_buf
+"
+
+lib_dir=3D$(dirname $0)/../../../net/forwarding
+
+NUM_NETIFS=3D0
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+source qos_lib.sh
+
+swp=3D$NETIF_NO_CABLE
+
+cleanup()
+{
+	pre_cleanup
+}
+
+get_prio_pg()
+{
+	__mlnx_qos -i $swp | sed -n '/^PFC/,/^[^[:space:]]/p' |
+		grep buffer | sed 's/ \+/ /g' | cut -d' ' -f 2-
+}
+
+get_prio_pfc()
+{
+	__mlnx_qos -i $swp | sed -n '/^PFC/,/^[^[:space:]]/p' |
+		grep enabled | sed 's/ \+/ /g' | cut -d' ' -f 2-
+}
+
+get_prio_tc()
+{
+	__mlnx_qos -i $swp | sed -n '/^tc/,$p' |
+		awk '/^tc/ { TC =3D $2 }
+		     /priority:/ { PRIO[$2]=3DTC }
+		     END {
+			for (i in PRIO)
+			    printf("%d ", PRIO[i])
+		     }'
+}
+
+get_buf_size()
+{
+	local idx=3D$1; shift
+
+	__mlnx_qos -i $swp | grep Receive | sed 's/.*: //' | cut -d, -f $((idx + =
1))
+}
+
+get_tot_size()
+{
+	__mlnx_qos -i $swp | grep Receive | sed 's/.*total_size=3D//'
+}
+
+check_prio_pg()
+{
+	local expect=3D$1; shift
+
+	local current=3D$(get_prio_pg)
+	test "$current" =3D "$expect"
+	check_err $? "prio2buffer is '$current', expected '$expect'"
+}
+
+check_prio_pfc()
+{
+	local expect=3D$1; shift
+
+	local current=3D$(get_prio_pfc)
+	test "$current" =3D "$expect"
+	check_err $? "prio PFC is '$current', expected '$expect'"
+}
+
+check_prio_tc()
+{
+	local expect=3D$1; shift
+
+	local current=3D$(get_prio_tc)
+	test "$current" =3D "$expect"
+	check_err $? "prio_tc is '$current', expected '$expect'"
+}
+
+__check_buf_size()
+{
+	local idx=3D$1; shift
+	local expr=3D$1; shift
+	local what=3D$1; shift
+
+	local current=3D$(get_buf_size $idx)
+	((current $expr))
+	check_err $? "${what}buffer $idx size is '$current', expected '$expr'"
+	echo $current
+}
+
+check_buf_size()
+{
+	__check_buf_size "$@" > /dev/null
+}
+
+test_defaults()
+{
+	RET=3D0
+
+	check_prio_pg "0 0 0 0 0 0 0 0 "
+	check_prio_tc "0 0 0 0 0 0 0 0 "
+	check_prio_pfc "0 0 0 0 0 0 0 0 "
+
+	log_test "Default headroom configuration"
+}
+
+test_dcb_ets()
+{
+	RET=3D0
+
+	__mlnx_qos -i $swp --prio_tc=3D0,2,4,6,1,3,5,7 > /dev/null
+
+	check_prio_pg "0 2 4 6 1 3 5 7 "
+	check_prio_tc "0 2 4 6 1 3 5 7 "
+	check_prio_pfc "0 0 0 0 0 0 0 0 "
+
+	__mlnx_qos -i $swp --prio_tc=3D0,0,0,0,0,0,0,0 > /dev/null
+
+	check_prio_pg "0 0 0 0 0 0 0 0 "
+	check_prio_tc "0 0 0 0 0 0 0 0 "
+
+	__mlnx_qos -i $swp --prio2buffer=3D1,3,5,7,0,2,4,6 &> /dev/null
+	check_fail $? "prio2buffer accepted in DCB mode"
+
+	log_test "Configuring headroom through ETS"
+}
+
+test_mtu()
+{
+	local what=3D$1; shift
+	local buf0size_2
+	local buf0size
+
+	RET=3D0
+	buf0size=3D$(__check_buf_size 0 "> 0")
+
+	mtu_set $swp 3000
+	buf0size_2=3D$(__check_buf_size 0 "> $buf0size" "MTU 3000: ")
+	mtu_restore $swp
+
+	mtu_set $swp 6000
+	check_buf_size 0 "> $buf0size_2" "MTU 6000: "
+	mtu_restore $swp
+
+	check_buf_size 0 "=3D=3D $buf0size"
+
+	log_test "${what}MTU impacts buffer size"
+}
+
+test_tc_mtu()
+{
+	# In TC mode, MTU still impacts the threshold below which a buffer is
+	# not permitted to go.
+
+	tc qdisc replace dev $swp root handle 1: bfifo limit 1.5M
+	test_mtu "TC: "
+	tc qdisc delete dev $swp root
+}
+
+test_pfc()
+{
+	RET=3D0
+
+	__mlnx_qos -i $swp --prio_tc=3D0,0,0,0,0,1,2,3 > /dev/null
+
+	local buf0size=3D$(get_buf_size 0)
+	local buf1size=3D$(get_buf_size 1)
+	local buf2size=3D$(get_buf_size 2)
+	local buf3size=3D$(get_buf_size 3)
+	check_buf_size 0 "> 0"
+	check_buf_size 1 "> 0"
+	check_buf_size 2 "> 0"
+	check_buf_size 3 "> 0"
+	check_buf_size 4 "=3D=3D 0"
+	check_buf_size 5 "=3D=3D 0"
+	check_buf_size 6 "=3D=3D 0"
+	check_buf_size 7 "=3D=3D 0"
+
+	log_test "Buffer size sans PFC"
+
+	RET=3D0
+
+	__mlnx_qos -i $swp --pfc=3D0,0,0,0,0,1,1,1 --cable_len=3D0 > /dev/null
+
+	check_prio_pg "0 0 0 0 0 1 2 3 "
+	check_prio_pfc "0 0 0 0 0 1 1 1 "
+	check_buf_size 0 "=3D=3D $buf0size"
+	check_buf_size 1 "> $buf1size"
+	check_buf_size 2 "> $buf2size"
+	check_buf_size 3 "> $buf3size"
+
+	local buf1size=3D$(get_buf_size 1)
+	check_buf_size 2 "=3D=3D $buf1size"
+	check_buf_size 3 "=3D=3D $buf1size"
+
+	log_test "PFC: Cable length 0"
+
+	RET=3D0
+
+	__mlnx_qos -i $swp --pfc=3D0,0,0,0,0,1,1,1 --cable_len=3D1000 > /dev/null
+
+	check_buf_size 0 "=3D=3D $buf0size"
+	check_buf_size 1 "> $buf1size"
+	check_buf_size 2 "> $buf1size"
+	check_buf_size 3 "> $buf1size"
+
+	log_test "PFC: Cable length 1000"
+
+	RET=3D0
+
+	__mlnx_qos -i $swp --pfc=3D0,0,0,0,0,0,0,0 --cable_len=3D0 > /dev/null
+	__mlnx_qos -i $swp --prio_tc=3D0,0,0,0,0,0,0,0 > /dev/null
+
+	check_prio_pg "0 0 0 0 0 0 0 0 "
+	check_prio_tc "0 0 0 0 0 0 0 0 "
+	check_buf_size 0 "> 0"
+	check_buf_size 1 "=3D=3D 0"
+	check_buf_size 2 "=3D=3D 0"
+	check_buf_size 3 "=3D=3D 0"
+	check_buf_size 4 "=3D=3D 0"
+	check_buf_size 5 "=3D=3D 0"
+	check_buf_size 6 "=3D=3D 0"
+	check_buf_size 7 "=3D=3D 0"
+
+	log_test "PFC: Restore defaults"
+}
+
+test_tc_priomap()
+{
+	RET=3D0
+
+	__mlnx_qos -i $swp --prio_tc=3D0,1,2,3,4,5,6,7 > /dev/null
+	check_prio_pg "0 1 2 3 4 5 6 7 "
+
+	tc qdisc replace dev $swp root handle 1: bfifo limit 1.5M
+	check_prio_pg "0 0 0 0 0 0 0 0 "
+
+	__mlnx_qos -i $swp --prio2buffer=3D1,3,5,7,0,2,4,6 > /dev/null
+	check_prio_pg "1 3 5 7 0 2 4 6 "
+
+	tc qdisc delete dev $swp root
+	check_prio_pg "0 1 2 3 4 5 6 7 "
+
+	# Clean up.
+	tc qdisc replace dev $swp root handle 1: bfifo limit 1.5M
+	__mlnx_qos -i $swp --prio2buffer=3D0,0,0,0,0,0,0,0 > /dev/null
+	tc qdisc delete dev $swp root
+	__mlnx_qos -i $swp --prio_tc=3D0,0,0,0,0,0,0,0 > /dev/null
+
+	log_test "TC: priomap"
+}
+
+test_tc_sizes()
+{
+	local cell_size=3D$(devlink_cell_size_get)
+	local size=3D$((cell_size * 1000))
+
+	RET=3D0
+
+	__mlnx_qos -i $swp --buffer_size=3D$size,0,0,0,0,0,0,0 &> /dev/null
+	check_fail $? "buffer_size should fail before qdisc is added"
+
+	tc qdisc replace dev $swp root handle 1: bfifo limit 1.5M
+
+	__mlnx_qos -i $swp --buffer_size=3D$size,0,0,0,0,0,0,0 > /dev/null
+	check_err $? "buffer_size should pass after qdisc is added"
+	check_buf_size 0 "=3D=3D $size" "set size: "
+
+	mtu_set $swp 6000
+	check_buf_size 0 "=3D=3D $size" "set MTU: "
+	mtu_restore $swp
+
+	__mlnx_qos -i $swp --buffer_size=3D0,0,0,0,0,0,0,0 > /dev/null
+
+	# After replacing the qdisc for the same kind, buffer_size still has to
+	# work.
+	tc qdisc replace dev $swp root handle 1: bfifo limit 1M
+
+	__mlnx_qos -i $swp --buffer_size=3D$size,0,0,0,0,0,0,0 > /dev/null
+	check_buf_size 0 "=3D=3D $size" "post replace, set size: "
+
+	__mlnx_qos -i $swp --buffer_size=3D0,0,0,0,0,0,0,0 > /dev/null
+
+	# Likewise after replacing for a different kind.
+	tc qdisc replace dev $swp root handle 2: prio bands 8
+
+	__mlnx_qos -i $swp --buffer_size=3D$size,0,0,0,0,0,0,0 > /dev/null
+	check_buf_size 0 "=3D=3D $size" "post replace different kind, set size: "
+
+	tc qdisc delete dev $swp root
+
+	__mlnx_qos -i $swp --buffer_size=3D$size,0,0,0,0,0,0,0 &> /dev/null
+	check_fail $? "buffer_size should fail after qdisc is deleted"
+
+	log_test "TC: buffer size"
+}
+
+test_int_buf()
+{
+	local what=3D$1; shift
+
+	RET=3D0
+
+	local buf0size=3D$(get_buf_size 0)
+	local tot_size=3D$(get_tot_size)
+
+	# Size of internal buffer and buffer 9.
+	local dsize=3D$((tot_size - buf0size))
+
+	tc qdisc add dev $swp clsact
+	tc filter add dev $swp egress matchall skip_sw action mirred egress mirro=
r dev $swp
+
+	local buf0size_2=3D$(get_buf_size 0)
+	local tot_size_2=3D$(get_tot_size)
+	local dsize_2=3D$((tot_size_2 - buf0size_2))
+
+	# Egress SPAN should have added to the "invisible" buffer configuration.
+	((dsize_2 > dsize))
+	check_err $? "Invisible buffers account for '$dsize_2', expected '> $dsiz=
e'"
+
+	mtu_set $swp 3000
+
+	local buf0size_3=3D$(get_buf_size 0)
+	local tot_size_3=3D$(get_tot_size)
+	local dsize_3=3D$((tot_size_3 - buf0size_3))
+
+	# MTU change might change buffer 0, which will show at total, but the
+	# hidden buffers should stay the same size.
+	((dsize_3 =3D=3D dsize_2))
+	check_err $? "MTU change: Invisible buffers account for '$dsize_3', expec=
ted '=3D=3D $dsize_2'"
+
+	mtu_restore $swp
+	tc qdisc del dev $swp clsact
+
+	# After SPAN removal, hidden buffers should be back to the original sizes=
.
+	local buf0size_4=3D$(get_buf_size 0)
+	local tot_size_4=3D$(get_tot_size)
+	local dsize_4=3D$((tot_size_4 - buf0size_4))
+	((dsize_4 =3D=3D dsize))
+	check_err $? "SPAN removed: Invisible buffers account for '$dsize_4', exp=
ected '=3D=3D $dsize'"
+
+	log_test "${what}internal buffer size"
+}
+
+test_tc_int_buf()
+{
+	local cell_size=3D$(devlink_cell_size_get)
+	local size=3D$((cell_size * 1000))
+
+	tc qdisc replace dev $swp root handle 1: bfifo limit 1.5M
+	test_int_buf "TC: "
+
+	__mlnx_qos -i $swp --buffer_size=3D$size,0,0,0,0,0,0,0 > /dev/null
+	test_int_buf "TC+buffsize: "
+
+	__mlnx_qos -i $swp --buffer_size=3D0,0,0,0,0,0,0,0 > /dev/null
+	tc qdisc delete dev $swp root
+}
+
+trap cleanup EXIT
+
+bail_on_lldpad
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
--=20
2.20.1

