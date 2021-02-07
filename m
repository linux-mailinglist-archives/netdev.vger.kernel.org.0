Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C143122D9
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhBGIp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:45:56 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4418 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBGIps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:45:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601fa86e0000>; Sun, 07 Feb 2021 00:44:30 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 08:44:29 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v2 7/7] netdevsim: Add netdevsim port add test cases
Date:   Sun, 7 Feb 2021 10:44:12 +0200
Message-ID: <20210207084412.252259-8-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210207084412.252259-1-parav@nvidia.com>
References: <20210206125551.8616-1-parav@nvidia.com>
 <20210207084412.252259-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612687470; bh=s0JYRKidIQwPxU3hjTDHghe0hIen03uiAITxUTIUc9U=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lnpgoNBl0fitQxGjE+NJAvBTbLsHOGeEuic306sz2+49XrXvM63QNInjUqSlApEag
         u4sb91gOTUvD1gmrTbn5LrRFi4fsSuXQoz1V/n8zdfwOFV5QQB1DLxs1foCL+VbCMS
         WPk5bVxiKE7EiXell5tomlHEUqdg5FLVVTaVid5YWhAE1i2t9T079j3gZt+tq+/EzQ
         ogtQ9zohsSw7t3BFvmNdb/+XlHHw2m+c5+dwz6T4W2s1os8112Bh0XTDdpS7Xwuqpt
         LsAL+VgGWMfM2d1Gb51g3jAE7Z+5SXKs58oPIYhuJ62Z4jNBarb39201OerRDBIWKY
         4Taa0kggtndfQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for PCI PF and SF port add, configure and delete.

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 72 ++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/too=
ls/testing/selftests/drivers/net/netdevsim/devlink.sh
index 40909c254365..ba349909a37e 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -5,7 +5,7 @@ lib_dir=3D$(dirname $0)/../../../net/forwarding
=20
 ALL_TESTS=3D"fw_flash_test params_test regions_test reload_test \
 	   netns_reload_test resource_test dev_info_test \
-	   empty_reporter_test dummy_reporter_test"
+	   empty_reporter_test dummy_reporter_test devlink_port_add_test"
 NUM_NETIFS=3D0
 source $lib_dir/lib.sh
=20
@@ -507,6 +507,76 @@ dummy_reporter_test()
 	log_test "dummy reporter test"
 }
=20
+function_state_get()
+{
+	local name=3D$1
+
+	cmd_jq "devlink port show $DL_HANDLE/$USR_SF_PORT_INDEX -j" \
+		" .[][].function.$1"
+}
+
+devlink_port_add_test()
+{
+	RET=3D0
+	USR_PF_PORT_INDEX=3D600
+	USR_PFNUM_A=3D2
+	USR_PFNUM_B=3D3
+	USR_SF_PORT_INDEX=3D601
+	USR_SFNUM_A=3D44
+	USR_SFNUM_B=3D55
+
+	devlink port add $DL_HANDLE flavour pcipf pfnum $USR_PFNUM_A
+	check_err $? "Failed PF port addition"
+
+	devlink port show
+	check_err $? "Failed PF port show"
+
+	devlink port add $DL_HANDLE flavour pcisf pfnum $USR_PFNUM_A
+	check_err $? "Failed SF port addition"
+
+	devlink port add $DL_HANDLE flavour pcisf pfnum $USR_PFNUM_A \
+			sfnum $USR_SFNUM_A
+	check_err $? "Failed SF port addition"
+
+	devlink port add $DL_HANDLE flavour pcipf pfnum $USR_PFNUM_B
+	check_err $? "Failed second PF port addition"
+
+	devlink port add $DL_HANDLE/$USR_SF_PORT_INDEX flavour pcisf \
+			pfnum $USR_PFNUM_B sfnum $USR_SFNUM_B
+	check_err $? "Failed SF port addition"
+
+	devlink port show
+	check_err $? "Failed PF port show"
+
+	state=3D$(function_state_get "state")
+	check_err $? "Failed to get function state"
+	[ "$state" =3D=3D "inactive" ]
+	check_err $? "Unexpected function state $state"
+
+	state=3D$(function_state_get "opstate")
+	check_err $? "Failed to get operational state"
+	[ "$state" =3D=3D "detached" ]
+	check_err $? "Unexpected function opstate $opstate"
+
+	devlink port function set $DL_HANDLE/$USR_SF_PORT_INDEX state active
+	check_err $? "Failed to set state"
+
+	state=3D$(function_state_get "state")
+	check_err $? "Failed to get function state"
+	[ "$state" =3D=3D "active" ]
+	check_err $? "Unexpected function state $state"
+
+	state=3D$(function_state_get "opstate")
+	check_err $? "Failed to get operational state"
+	[ "$state" =3D=3D "attached" ]
+	check_err $? "Unexpected function opstate $opstate"
+
+	devlink port del $DL_HANDLE/$USR_SF_PORT_INDEX
+	check_err $? "Failed SF port deletion"
+
+	log_test "port_add test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
--=20
2.26.2

