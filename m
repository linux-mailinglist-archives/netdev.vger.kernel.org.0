Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459AD1308FF
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 17:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgAEQWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 11:22:03 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:32795 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbgAEQWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 11:22:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5EFE121111;
        Sun,  5 Jan 2020 11:22:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 Jan 2020 11:22:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=9A4d/h7P/lKs5nNUeUbWSHQcu3WSHOhRsm/kRmP81Kg=; b=QFd3pPXn
        bNR2Xj54rdIC17BES9pvvBJJl5i8t2NkcMugEqtGrY/0B9oy/h580UfS1s7k4yum
        gduVN4+kT0wkvP9gl3RiweK9BMJFsgy7+XVB0vqB1273AxOfGcdhNHKdTfHNktLa
        ETl/gWMoA35rrW5vdi/KuVJVFp0dAAfzz1tB4AFTvhklG1wtw0ndFqxPX0uEwjuU
        CWXfxefK2x0cVkZI8RtpulSGimmcBPz7XOcdRFj+kbw99j4bLD4lX5b9z/e4R8bE
        yL3t/A3XbsSit/MXdAHiAoC0a/qlImOnGXuDg4lMaasb4I4QD5WiNUOOA9MZU/nC
        DhETvghEQX9DcA==
X-ME-Sender: <xms:Kg0SXrL1a0qe3k30HaFx6vAk9PDOjzaLuL2eBvUUY4ZCSXBup2QxBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:Kg0SXq2__FgngvPXqkXadxLIXXzvKQQPAwmRrAbTkYLHuXT3mYXG6A>
    <xmx:Kg0SXrv-_iEq7mKKWgBK0D8CkGghh-EWNrsVqljJv8WD3_E2idUg2A>
    <xmx:Kg0SXigHjdURp2K146ydh9Qnz37mxDckSSkoyl5Jz5SSlxNbSd4Jlg>
    <xmx:Kg0SXnvWjcbYCjECkLs5nPdQMj9qZViltkMtiicRvV6PoKVxkT85Kg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1600A80060;
        Sun,  5 Jan 2020 11:22:00 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/8] selftests: forwarding: router: Add test case for multicast destination MAC mismatch
Date:   Sun,  5 Jan 2020 18:20:53 +0200
Message-Id: <20200105162057.182547-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105162057.182547-1-idosch@idosch.org>
References: <20200105162057.182547-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add test case to check that packets are not dropped when they need to be
routed and their multicast MAC mismatched to their multicast destination
IP.

i.e., destination IP is multicast and
	* for IPV4: DMAC !=  {01-00-5E-0 (25 bits), DIP[22:0]}
	* for IPV6: DMAC !=  {33-33-0 (16 bits), DIP[31:0]}

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/router.sh        | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/router.sh b/tools/testing/selftests/net/forwarding/router.sh
index 6ad652ad7e73..e1f4d6145326 100755
--- a/tools/testing/selftests/net/forwarding/router.sh
+++ b/tools/testing/selftests/net/forwarding/router.sh
@@ -5,12 +5,17 @@ ALL_TESTS="
 	ping_ipv4
 	ping_ipv6
 	sip_in_class_e
+	mc_mac_mismatch
 "
 
 NUM_NETIFS=4
 source lib.sh
 source tc_common.sh
 
+require_command $MCD
+require_command $MC_CLI
+table_name=selftests
+
 h1_create()
 {
 	vrf_create "vrf-h1"
@@ -93,6 +98,25 @@ router_destroy()
 	ip link set dev $rp1 down
 }
 
+start_mcd()
+{
+	SMCROUTEDIR="$(mktemp -d)"
+
+	for ((i = 1; i <= $NUM_NETIFS; ++i)); do
+		echo "phyint ${NETIFS[p$i]} enable" >> \
+			$SMCROUTEDIR/$table_name.conf
+	done
+
+	$MCD -N -I $table_name -f $SMCROUTEDIR/$table_name.conf \
+		-P $SMCROUTEDIR/$table_name.pid
+}
+
+kill_mcd()
+{
+	pkill $MCD
+	rm -rf $SMCROUTEDIR
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
@@ -103,6 +127,8 @@ setup_prepare()
 
 	rp1mac=$(mac_get $rp1)
 
+	start_mcd
+
 	vrf_prepare
 
 	h1_create
@@ -125,6 +151,8 @@ cleanup()
 	h1_destroy
 
 	vrf_cleanup
+
+	kill_mcd
 }
 
 ping_ipv4()
@@ -161,6 +189,60 @@ sip_in_class_e()
 	sysctl_restore net.ipv4.conf.all.rp_filter
 }
 
+create_mcast_sg()
+{
+	local if_name=$1; shift
+	local s_addr=$1; shift
+	local mcast=$1; shift
+	local dest_ifs=${@}
+
+	$MC_CLI -I $table_name add $if_name $s_addr $mcast $dest_ifs
+}
+
+delete_mcast_sg()
+{
+	local if_name=$1; shift
+	local s_addr=$1; shift
+	local mcast=$1; shift
+	local dest_ifs=${@}
+
+	$MC_CLI -I $table_name remove $if_name $s_addr $mcast $dest_ifs
+}
+
+__mc_mac_mismatch()
+{
+	local desc=$1; shift
+	local proto=$1; shift
+	local sip=$1; shift
+	local dip=$1; shift
+	local flags=${1:-""}; shift
+	local dmac=01:02:03:04:05:06
+
+	RET=0
+
+	tc filter add dev $rp2 egress protocol $proto pref 1 handle 101 \
+		flower dst_ip $dip action pass
+
+	create_mcast_sg $rp1 $sip $dip $rp2
+
+	$MZ $flags $h1 -t udp "sp=54321,dp=12345" -c 5 -d 1msec -b $dmac \
+		-B $dip -q
+
+	tc_check_packets "dev $rp2 egress" 101 5
+	check_err $? "Packets were dropped"
+
+	log_test "Multicast MAC mismatch: $desc"
+
+	delete_mcast_sg $rp1 $sip $dip $rp2
+	tc filter del dev $rp2 egress protocol $proto pref 1 handle 101 flower
+}
+
+mc_mac_mismatch()
+{
+	__mc_mac_mismatch "IPv4" "ip" 192.0.2.2 225.1.2.3
+	__mc_mac_mismatch "IPv6" "ipv6" 2001:db8:1::2 ff0e::3 "-6"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.24.1

