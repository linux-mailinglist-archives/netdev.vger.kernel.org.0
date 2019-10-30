Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36375E98CF
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 10:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfJ3JE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 05:04:56 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46075 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbfJ3JEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 05:04:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8EF5D20319;
        Wed, 30 Oct 2019 05:04:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 30 Oct 2019 05:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lMbPEMWLKpIhsL/xo
        QWKUuNXV8Y8Pjh7Xt9S8VGZWwI=; b=W3TR5Sk6tXTSIiy2vEaD4XFB9Omb8T2tG
        ypnhUDVcdv+SVhVNUEJ3YZCrTBZ6ghiU4EkDPTganRaLstPX2iu2g8LRiKfIWMP2
        /aTmEfDcdHth/kFOlpklLQ2kJ+J7fBFB4laBrwO08s7SOTEJpkjptsEKVIduVb3A
        q/Af99+64go2sV5jWJKSHWlhhiRRWpRLzux3tvhm22bb3ylvvvjudSr+Hdd+pwtl
        Fc7s3c4hZl4eTzEUPZGQJXKH9hMjQPcFx1kuPqPKUaIKAYtt1GJKcrmsYCUT25Nc
        YEW2mMRNt4Rrur9TWUwOP+qevxNAdoDE7X/Ckz/JKlbE4ttpF72Og==
X-ME-Sender: <xms:NlK5XSleAX9OLkjjC-HSWaMfR1_AEBwhumq5ybvNPkKxLbTQ3JU4EQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtfecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertddtne
    cuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdho
    rhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgep
    td
X-ME-Proxy: <xmx:NlK5XRqpSshQRFLZL6gx8_hs3W3fuwWXcHCHhbR9cBNMTiXVizx71Q>
    <xmx:NlK5XcD08zW4gQAnOhy54xhiR0nVIbrM3F0VZ6vm-mYcgTvtZ5stpw>
    <xmx:NlK5XQYOiHLocqzXqmo6Wn7DhzSMR2AvQt3ojGRQQxOP1RKoBwfQYg>
    <xmx:NlK5XfSCGqV43Wh5YQqvitF8NdrPtgFFNW0rkPgOmqw3_IbNDFsfpQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 318E880059;
        Wed, 30 Oct 2019 05:04:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: core: Unpublish devlink parameters during reload
Date:   Wed, 30 Oct 2019 11:04:22 +0200
Message-Id: <20191030090422.24698-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The devlink parameter "acl_region_rehash_interval" is a runtime
parameter whose value is stored in a dynamically allocated memory. While
reloading the driver, this memory is freed and then allocated again. A
use-after-free might happen if during this time frame someone tries to
retrieve its value.

Since commit 070c63f20f6c ("net: devlink: allow to change namespaces
during reload") the use-after-free can be reliably triggered when
reloading the driver into a namespace, as after freeing the memory (via
reload_down() callback) all the parameters are notified.

Fix this by unpublishing and then re-publishing the parameters during
reload.

Fixes: 98bbf70c1c41 ("mlxsw: spectrum: add "acl_region_rehash_interval" devlink param")
Fixes: 7c62cfb8c574 ("devlink: publish params only after driver init is done")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 14dcc786926d..4421ab22182f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1186,7 +1186,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_thermal_init;
 
-	if (mlxsw_driver->params_register && !reload)
+	if (mlxsw_driver->params_register)
 		devlink_params_publish(devlink);
 
 	return 0;
@@ -1259,7 +1259,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 			return;
 	}
 
-	if (mlxsw_core->driver->params_unregister && !reload)
+	if (mlxsw_core->driver->params_unregister)
 		devlink_params_unpublish(devlink);
 	mlxsw_thermal_fini(mlxsw_core->thermal);
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
-- 
2.21.0

