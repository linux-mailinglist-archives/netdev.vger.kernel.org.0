Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F9B155CCB
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgBGR1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:27:18 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55887 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbgBGR1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:27:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C9C0021ACF;
        Fri,  7 Feb 2020 12:27:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 07 Feb 2020 12:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=EiC8Y9c/z9IwMnf5aKLYDzjGtvMeoMzbOMf4qAbUS7Y=; b=0GZmpseU
        tUPmfnrEl+KU/lsKMTo9mRI5sIJprzYa4exP0fQH+FYiVcCnBs9ayAAWzwsc/6eU
        ZimZe10wGKrFJ5KOsGSHUroOh/fhKpSmIizERYulqEWbNE68N6pBSVjRtlFH5Q3w
        xJQDeUJg7Tk/Jd4CjwrtjAoXt25Slv5Pifh1tzPIqIUxZJyE/Bgn0JDmgt7vaTya
        p3HxVG768iRjAOb+m0N0DyqaKgMYWxAEQPqXhmn9tO9ob06CD8mZJoHF3AigYh5X
        i6JYGglBM3Oa4LU9wmqWlvgJf4emLeVY2VfxHBIZqprNjrYTEW5OQ3Z7m2vsRSft
        jVQjZ/Aat3ic8w==
X-ME-Sender: <xms:9Z09XgFibgvp-vVlXpc6Xj7wpEZxv6Dtwws-xqHZrWHu5pJ1tu9_6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepjeelrd
    dukeefrddutdejrdduvddtnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehm
    rghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:9Z09XtTJYeaoUaouug6u27SHLEQBPNm5ZGxK3BwJBpOT_u-Y7AwMEA>
    <xmx:9Z09XjNmmhk4FIrJD3r_OUmypxElkIItB3AbUYOJFDcbvRSPNUTakQ>
    <xmx:9Z09XqndOcjrRqVASooesbj7U2xbv0bepARiIlC2PaKTbrkPW3_rQg>
    <xmx:9Z09XjQvm9niKCCAF19t6gaOTFZIhEfRMdxSiXvZ69_O5ch_ayXQ1Q>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 342753060840;
        Fri,  7 Feb 2020 12:27:15 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Vadim Pasternak <vadimp@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 4/5] mlxsw: core: Add validation of hardware device types for MGPIR register
Date:   Fri,  7 Feb 2020 19:26:27 +0200
Message-Id: <20200207172628.128763-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207172628.128763-1-idosch@idosch.org>
References: <20200207172628.128763-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

When reading the number of gearboxes from the hardware, the driver does
not validate the returned 'device type' field. The driver can therefore
wrongly assume that the queried devices are gearboxes.

On Spectrum-3 systems that support different types of devices, this can
prevent the driver from loading, as it will try to query the
temperature sensors from devices which it assumes are gearboxes and in
fact are not.

For example:
[  218.129230] mlxsw_minimal 2-0048: Reg cmd access status failed (status=7(bad parameter))
[  218.138282] mlxsw_minimal 2-0048: Reg cmd access failed (reg_id=900a(mtmp),type=write)
[  218.147131] mlxsw_minimal 2-0048: Failed to setup temp sensor number 256
[  218.534480] mlxsw_minimal 2-0048: Fail to register core bus
[  218.540714] mlxsw_minimal: probe of 2-0048 failed with error -5

Fix this by validating the 'device type' field.

Fixes: 2e265a8b6c094 ("mlxsw: core: Extend hwmon interface with inter-connect temperature attributes")
Fixes: f14f4e621b1b4 ("mlxsw: core: Extend thermal core with per inter-connect device thermal zones")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 8 ++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 9bf8da5f6daf..3fe878d7c94c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -573,6 +573,7 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 
 static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 {
+	enum mlxsw_reg_mgpir_device_type device_type;
 	int index, max_index, sensor_index;
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
@@ -584,8 +585,9 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	if (err)
 		return err;
 
-	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, NULL, NULL, NULL);
-	if (!gbox_num)
+	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, &device_type, NULL, NULL);
+	if (device_type != MLXSW_REG_MGPIR_DEVICE_TYPE_GEARBOX_DIE ||
+	    !gbox_num)
 		return 0;
 
 	index = mlxsw_hwmon->module_sensor_max;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index c721b171bd8d..ce0a6837daa3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -895,8 +895,10 @@ static int
 mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 			     struct mlxsw_thermal *thermal)
 {
+	enum mlxsw_reg_mgpir_device_type device_type;
 	struct mlxsw_thermal_module *gearbox_tz;
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
+	u8 gbox_num;
 	int i;
 	int err;
 
@@ -908,11 +910,13 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 	if (err)
 		return err;
 
-	mlxsw_reg_mgpir_unpack(mgpir_pl, &thermal->tz_gearbox_num, NULL, NULL,
+	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, &device_type, NULL,
 			       NULL);
-	if (!thermal->tz_gearbox_num)
+	if (device_type != MLXSW_REG_MGPIR_DEVICE_TYPE_GEARBOX_DIE ||
+	    !gbox_num)
 		return 0;
 
+	thermal->tz_gearbox_num = gbox_num;
 	thermal->tz_gearbox_arr = kcalloc(thermal->tz_gearbox_num,
 					  sizeof(*thermal->tz_gearbox_arr),
 					  GFP_KERNEL);
-- 
2.24.1

