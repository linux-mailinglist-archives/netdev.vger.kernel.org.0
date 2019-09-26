Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F154BF206
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfIZLoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:44:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53163 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726184AbfIZLoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 07:44:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 34A8322011;
        Thu, 26 Sep 2019 07:44:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 26 Sep 2019 07:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Bw00mA3EPKIQ/W17Qj2/VGNzXb48FFdkIOPVMV0Ail4=; b=hNFGKV4q
        i5vdyW1MJ1bjfKmvvGDrS1rCddvQzuZeIzmNwA4uTwuWilqm4Ea6IgYNAQxJ5sOC
        kMNYbj6WZEjiMQUEdhYmqBulpY3KN9uApmb/mOKva/F11DyK8EazL6qSgjhOFrt9
        a/p7P6nbT9Hr3yfWw1TNAc7RhuVhB11zNK4y5TzlHCEf5dIT44wlJMNSnuoevRox
        pB1u8ai6ay4j+qknAjr7cYD1GsD5f82H4SEb3lysqGDIhaRLXhEP3PkmrIis6rYo
        ou5a+Xx5sQyJqoC7T/OJAj2mUk8HcVUj9nwyvhrkgcOytLR3ysa9fb46GRyoJT6N
        Ta2/UxZHirgBpg==
X-ME-Sender: <xms:lKSMXXKnVx3GJnjhyDI_WxHnaw_HaSHXVQMoYxVjeMwexCkAS9Hlew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeeggdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:lKSMXfas_xh--Mh4cYM1CYyYtuqGQKht70dGmQIFfjuNFmI50oJGCQ>
    <xmx:lKSMXauVtOISGPh1T4EhaBSdfW9w2b2Ebt3gLtuj0OZOw_eAJiBdVw>
    <xmx:lKSMXUtl_hdTd4jZR9TWYcE6oVe-39WLXAGQJTt5LLKuVTKvJsc8tw>
    <xmx:laSMXaqdCK-G96JgUSiTOYS4bnb33xHmrWLgFVR8CJnKJvPw0Oj4uw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B5758005B;
        Thu, 26 Sep 2019 07:44:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/3] mlxsw: spectrum: Clear VLAN filters during port initialization
Date:   Thu, 26 Sep 2019 14:43:38 +0300
Message-Id: <20190926114340.9483-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926114340.9483-1-idosch@idosch.org>
References: <20190926114340.9483-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When a port is created, its VLAN filters are not cleared by the
firmware. This causes tagged packets to be later dropped by the ingress
STP filters, which default to DISCARD state.

The above did not matter much until commit b5ce611fd96e ("mlxsw:
spectrum: Add devlink-trap support") where we exposed the drop reason to
users.

Without this patch, the drop reason users will see is not consistent. If
a port is enslaved to a VLAN-aware bridge and a packet with an invalid
VLAN tries to ingress the bridge, it will be dropped due to ingress STP
filter. If the VLAN is later enabled and then disabled, the packet will
be dropped by the ingress VLAN filter despite the above being a
seemingly NOP operation.

Fix this by clearing all the VLAN filters during port initialization.
Adjust the test accordingly.

Fixes: b5ce611fd96e ("mlxsw: spectrum: Add devlink-trap support")
Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Tested-by: Alex Kushnarov <alexanderk@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c           | 9 +++++++++
 .../selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh | 7 -------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dd234cf7b39d..dcf9562bce8a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3771,6 +3771,14 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		goto err_port_qdiscs_init;
 	}
 
+	err = mlxsw_sp_port_vlan_set(mlxsw_sp_port, 0, VLAN_N_VID - 1, false,
+				     false);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to clear VLAN filter\n",
+			mlxsw_sp_port->local_port);
+		goto err_port_vlan_clear;
+	}
+
 	err = mlxsw_sp_port_nve_init(mlxsw_sp_port);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to initialize NVE\n",
@@ -3818,6 +3826,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 err_port_pvid_set:
 	mlxsw_sp_port_nve_fini(mlxsw_sp_port);
 err_port_nve_init:
+err_port_vlan_clear:
 	mlxsw_sp_tc_qdisc_fini(mlxsw_sp_port);
 err_port_qdiscs_init:
 	mlxsw_sp_port_fids_fini(mlxsw_sp_port);
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
index 5dcdfa20fc6c..126caf28b529 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
@@ -224,13 +224,6 @@ ingress_vlan_filter_test()
 	local vid=10
 
 	bridge vlan add vid $vid dev $swp2 master
-	# During initialization the firmware enables all the VLAN filters and
-	# the driver does not turn them off since the traffic will be discarded
-	# by the STP filter whose default is DISCARD state. Add the VID on the
-	# ingress bridge port and then remove it to make sure it is not member
-	# in the VLAN.
-	bridge vlan add vid $vid dev $swp1 master
-	bridge vlan del vid $vid dev $swp1 master
 
 	RET=0
 
-- 
2.21.0

