Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4127E703
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgI3Ktl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:49:41 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5192 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI3Kth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:49:37 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f74625b0000>; Wed, 30 Sep 2020 03:47:55 -0700
Received: from localhost.localdomain (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 10:49:34 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 1/6] selftests: forwarding: devlink_lib: Split devlink_..._set() into save & set
Date:   Wed, 30 Sep 2020 12:49:07 +0200
Message-ID: <81aa2b2c3b26ac63fa9fae88199af5ef91c06415.1601462261.git.petrm@nvidia.com>
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
        t=1601462875; bh=WNS2OYqq05KEF/0DqVJg/wDihWLKl1J6YjDvNS6S7o0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=BPtpFWrGILgbzZXM1uMjqOjpWwyWJAiEQ9nAPdyc6i8Qi7ptScyD1Skk4y1ehQPke
         TdDVl4UG5kulszYpliTNBmfa0cZYfxFjc3PsObjaHjbyJqE33aIKBuBAzvbaFcKG9Z
         XdlaKZ1E9Wv4XVWNBSz/EcKm+DW79doUSIms0yOsp6QNs1Q/aLn6KFk+LbUsDVFvLP
         WNW9iOC2a9FCWw9ja3z2zrc10cUEgMfMhzpWONlSBZiyQacvqmkJAFmTRwCj6Ezehi
         Gs2w+0ObPbUyBzzI7ST6UkoWWcMBjjRD/OAtpWxl1qvUsD/EE2x0JldHIDurLbZhyk
         l7knnrq1I8xJA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing pool type from static to dynamic causes reinterpretation of
threshold values. They therefore need to be saved before pool type is
changed, then the pool type can be changed, and then the new values need
to be set up.

For that reason, set cannot subsume save, because it would be saving the
wrong thing, with possibly a nonsensical value, and restore would then fail
to restore the nonsensical value.

Thus extract a _save() from each of the relevant _set()'s. This way it is
possible to save everything up front, then to tweak it, and then restore in
the required order.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/qos_ets_strict.sh       |  9 +++
 .../drivers/net/mlxsw/qos_mc_aware.sh         |  5 ++
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |  6 ++
 .../drivers/net/mlxsw/sch_red_core.sh         |  1 +
 .../selftests/net/forwarding/devlink_lib.sh   | 64 +++++++++++++++----
 5 files changed, 73 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh b/=
tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh
index 6d1790b5de7a..e9f8718af979 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh
@@ -147,17 +147,26 @@ switch_create()
=20
 	# Make sure that ingress quotas are smaller than egress so that there is
 	# room for both streams of traffic to be admitted to shared buffer.
+	devlink_pool_size_thtype_save 0
 	devlink_pool_size_thtype_set 0 dynamic 10000000
+	devlink_pool_size_thtype_save 4
 	devlink_pool_size_thtype_set 4 dynamic 10000000
=20
+	devlink_port_pool_th_save $swp1 0
 	devlink_port_pool_th_set $swp1 0 6
+	devlink_tc_bind_pool_th_save $swp1 1 ingress
 	devlink_tc_bind_pool_th_set $swp1 1 ingress 0 6
=20
+	devlink_port_pool_th_save $swp2 0
 	devlink_port_pool_th_set $swp2 0 6
+	devlink_tc_bind_pool_th_save $swp2 2 ingress
 	devlink_tc_bind_pool_th_set $swp2 2 ingress 0 6
=20
+	devlink_tc_bind_pool_th_save $swp3 1 egress
 	devlink_tc_bind_pool_th_set $swp3 1 egress 4 7
+	devlink_tc_bind_pool_th_save $swp3 2 egress
 	devlink_tc_bind_pool_th_set $swp3 2 egress 4 7
+	devlink_port_pool_th_save $swp3 4
 	devlink_port_pool_th_set $swp3 4 7
 }
=20
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh b/to=
ols/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
index b025daea062d..8f164c80e215 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
@@ -145,12 +145,17 @@ switch_create()
=20
 	# Make sure that ingress quotas are smaller than egress so that there is
 	# room for both streams of traffic to be admitted to shared buffer.
+	devlink_port_pool_th_save $swp1 0
 	devlink_port_pool_th_set $swp1 0 5
+	devlink_tc_bind_pool_th_save $swp1 0 ingress
 	devlink_tc_bind_pool_th_set $swp1 0 ingress 0 5
=20
+	devlink_port_pool_th_save $swp2 0
 	devlink_port_pool_th_set $swp2 0 5
+	devlink_tc_bind_pool_th_save $swp2 1 ingress
 	devlink_tc_bind_pool_th_set $swp2 1 ingress 0 5
=20
+	devlink_port_pool_th_save $swp3 4
 	devlink_port_pool_th_set $swp3 4 12
 }
=20
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh b/tools/t=
esting/selftests/drivers/net/mlxsw/sch_ets.sh
index 94c37124a840..af64bc9ea8ab 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
@@ -27,11 +27,17 @@ switch_create()
 	# amount of traffic that is admitted to the shared buffers. This makes
 	# sure that there is always enough traffic of all types to select from
 	# for the DWRR process.
+	devlink_port_pool_th_save $swp1 0
 	devlink_port_pool_th_set $swp1 0 12
+	devlink_tc_bind_pool_th_save $swp1 0 ingress
 	devlink_tc_bind_pool_th_set $swp1 0 ingress 0 12
+	devlink_port_pool_th_save $swp2 4
 	devlink_port_pool_th_set $swp2 4 12
+	devlink_tc_bind_pool_th_save $swp2 7 egress
 	devlink_tc_bind_pool_th_set $swp2 7 egress 4 5
+	devlink_tc_bind_pool_th_save $swp2 6 egress
 	devlink_tc_bind_pool_th_set $swp2 6 egress 4 5
+	devlink_tc_bind_pool_th_save $swp2 5 egress
 	devlink_tc_bind_pool_th_set $swp2 5 egress 4 5
=20
 	# Note: sch_ets_core.sh uses VLAN ingress-qos-map to assign packet
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/to=
ols/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 517297a14ecf..b0cb1aaffdda 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -208,6 +208,7 @@ switch_create()
 	ip link set dev br2_11 up
=20
 	local size=3D$(devlink_pool_size_thtype 0 | cut -d' ' -f 1)
+	devlink_port_pool_th_save $swp3 8
 	devlink_port_pool_th_set $swp3 8 $size
 }
=20
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/=
testing/selftests/net/forwarding/devlink_lib.sh
index 75fe24bcb9cd..ba6aca848702 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -117,6 +117,12 @@ devlink_reload()
=20
 declare -A DEVLINK_ORIG
=20
+# Changing pool type from static to dynamic causes reinterpretation of thr=
eshold
+# values. They therefore need to be saved before pool type is changed, the=
n the
+# pool type can be changed, and then the new values need to be set up. The=
refore
+# instead of saving the current state implicitly in the _set call, provide
+# functions for all three primitives: save, set, and restore.
+
 devlink_port_pool_threshold()
 {
 	local port=3D$1; shift
@@ -126,14 +132,21 @@ devlink_port_pool_threshold()
 		| jq '.port_pool."'"$port"'"[].threshold'
 }
=20
-devlink_port_pool_th_set()
+devlink_port_pool_th_save()
 {
 	local port=3D$1; shift
 	local pool=3D$1; shift
-	local th=3D$1; shift
 	local key=3D"port_pool($port,$pool).threshold"
=20
 	DEVLINK_ORIG[$key]=3D$(devlink_port_pool_threshold $port $pool)
+}
+
+devlink_port_pool_th_set()
+{
+	local port=3D$1; shift
+	local pool=3D$1; shift
+	local th=3D$1; shift
+
 	devlink sb port pool set $port pool $pool th $th
 }
=20
@@ -142,8 +155,13 @@ devlink_port_pool_th_restore()
 	local port=3D$1; shift
 	local pool=3D$1; shift
 	local key=3D"port_pool($port,$pool).threshold"
+	local -a orig=3D(${DEVLINK_ORIG[$key]})
=20
-	devlink sb port pool set $port pool $pool th ${DEVLINK_ORIG[$key]}
+	if [[ -z $orig ]]; then
+		echo "WARNING: Mismatched devlink_port_pool_th_restore"
+	else
+		devlink sb port pool set $port pool $pool th $orig
+	fi
 }
=20
 devlink_pool_size_thtype()
@@ -154,14 +172,20 @@ devlink_pool_size_thtype()
 	    | jq -r '.pool[][] | (.size, .thtype)'
 }
=20
+devlink_pool_size_thtype_save()
+{
+	local pool=3D$1; shift
+	local key=3D"pool($pool).size_thtype"
+
+	DEVLINK_ORIG[$key]=3D$(devlink_pool_size_thtype $pool)
+}
+
 devlink_pool_size_thtype_set()
 {
 	local pool=3D$1; shift
 	local thtype=3D$1; shift
 	local size=3D$1; shift
-	local key=3D"pool($pool).size_thtype"
=20
-	DEVLINK_ORIG[$key]=3D$(devlink_pool_size_thtype $pool)
 	devlink sb pool set "$DEVLINK_DEV" pool $pool size $size thtype $thtype
 }
=20
@@ -171,8 +195,12 @@ devlink_pool_size_thtype_restore()
 	local key=3D"pool($pool).size_thtype"
 	local -a orig=3D(${DEVLINK_ORIG[$key]})
=20
-	devlink sb pool set "$DEVLINK_DEV" pool $pool \
-		size ${orig[0]} thtype ${orig[1]}
+	if [[ -z ${orig[0]} ]]; then
+		echo "WARNING: Mismatched devlink_pool_size_thtype_restore"
+	else
+		devlink sb pool set "$DEVLINK_DEV" pool $pool \
+			size ${orig[0]} thtype ${orig[1]}
+	fi
 }
=20
 devlink_tc_bind_pool_th()
@@ -185,16 +213,24 @@ devlink_tc_bind_pool_th()
 	    | jq -r '.tc_bind[][] | (.pool, .threshold)'
 }
=20
-devlink_tc_bind_pool_th_set()
+devlink_tc_bind_pool_th_save()
 {
 	local port=3D$1; shift
 	local tc=3D$1; shift
 	local dir=3D$1; shift
-	local pool=3D$1; shift
-	local th=3D$1; shift
 	local key=3D"tc_bind($port,$dir,$tc).pool_th"
=20
 	DEVLINK_ORIG[$key]=3D$(devlink_tc_bind_pool_th $port $tc $dir)
+}
+
+devlink_tc_bind_pool_th_set()
+{
+	local port=3D$1; shift
+	local tc=3D$1; shift
+	local dir=3D$1; shift
+	local pool=3D$1; shift
+	local th=3D$1; shift
+
 	devlink sb tc bind set $port tc $tc type $dir pool $pool th $th
 }
=20
@@ -206,8 +242,12 @@ devlink_tc_bind_pool_th_restore()
 	local key=3D"tc_bind($port,$dir,$tc).pool_th"
 	local -a orig=3D(${DEVLINK_ORIG[$key]})
=20
-	devlink sb tc bind set $port tc $tc type $dir \
-		pool ${orig[0]} th ${orig[1]}
+	if [[ -z ${orig[0]} ]]; then
+		echo "WARNING: Mismatched devlink_tc_bind_pool_th_restore"
+	else
+		devlink sb tc bind set $port tc $tc type $dir \
+			pool ${orig[0]} th ${orig[1]}
+	fi
 }
=20
 devlink_traps_num_get()
--=20
2.20.1

