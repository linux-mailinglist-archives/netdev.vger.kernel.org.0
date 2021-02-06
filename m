Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E83311D45
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 13:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBFM57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 07:57:59 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8389 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhBFM5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 07:57:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601e91e90000>; Sat, 06 Feb 2021 04:56:09 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 6 Feb
 2021 12:56:08 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 7/7] netdevsim: Add netdevsim port add test cases
Date:   Sat, 6 Feb 2021 14:55:51 +0200
Message-ID: <20210206125551.8616-8-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206125551.8616-1-parav@nvidia.com>
References: <20210206125551.8616-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612616169; bh=VvZLdEd022MJbdQm/lm5+cnNbRNFIM4w4Qy/Fevf7rg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=reXVV+XrvNotyWr4OHsmUBRlNxGfRrNIss/kC0Uh+5Objj+LbQVvbT/tNzOH0jzro
         PiBJhlkSdC7xoXa4FF6Z7KtWt2zjyvokl8MqOdrrWJh0/gKW+Gd6+dgpgq/+kUECPy
         LiqHmY2+wxT18A6YkPFS9YrnJzyrF60B2uAlytT89MLnP9OJgporcA8eYt1kVweMnp
         /1XoD8PyO2rPoPf+H0wX360Ymwd80jXn7diq0EZTfmMsWO3DA5p8ioXhRTHYtdtIOV
         lseGKwI6AqkiEz8QQxy82kepFT9dSu+Qm61lvwYCgQrrAIimtjPYuOa5aL/VoRmQdt
         gOeuUacGS9pbg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for PCI PF and SF port add, configure and delete using user
specified port index and sfumber; and also using auto generated port
index.

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

