Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD01A279F62
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgI0Hux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:50:53 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48405 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730471AbgI0Huw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:50:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 90D8747B;
        Sun, 27 Sep 2020 03:50:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=OEqvsLd0RqoZkuyuroxebnn6oySCdICXC2SXF2gEW+I=; b=AKwMjRuj
        xC6R3KZPyvliQoUee3x4KsVgEEBSs3Edtwu4G7+KdtU+OJhzpgj1hphrEz6cEIRI
        HMwLziayYBn+1lZxRGgoK+w36J3KzJ1gRoGP6QNkaKE+qWKnrTQ67drImgnU094a
        aF9zEHKLe3jSWKSlDOY62buVk7wgs67ftTlJ8124gJG3dpBjf9uqrqURjhSwJMav
        wilo0664KrIcSfWUz/1bZkoV24XzzeQej2POVhgr6MQzVEUYvLJ63kmmwLnvWCq4
        1W/94nI1rUuszShKHACog9pd26AtXHZPKIRJw+yZhFHk8IWFyplzVZz8w4XvBn32
        3m5TDeH3gNoACA==
X-ME-Sender: <xms:WkRwX1rKdQpAcboEtXCzRA3ma6sobzIBZXGVFeNzQYm4mL5jYKVaKg>
    <xme:WkRwX3og4iZJOP8Ghrdz3wBwPWqcy2a5j-QfzRrT-QYdRPnEa6PoeKrUQ4gcLquAj
    aA9GMt5TiGeEVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeejrddugeek
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WkRwXyPITWtQIID604n3E25KP4XuUI2oOQA7EzgqpXg5XH0lj-4gwA>
    <xmx:WkRwXw4VFbFp_Vjjh7KwsWL8cMN2A8qQtSr5eMi-2z55Q4y273euyA>
    <xmx:WkRwX05PECA3Al1mJ8OJiLwQoxK0xUjgcWYTL8VBE7XwzCOqF1-9MA>
    <xmx:WkRwXynjv-xTaneXRHB7cZAPSHsjO-v-kvBa2-lVMytNmDvUq3kBAw>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D2183280060;
        Sun, 27 Sep 2020 03:50:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: core_hwmon: Query MTMP before writing to set only relevant fields
Date:   Sun, 27 Sep 2020 10:50:09 +0300
Message-Id: <20200927075015.1417714-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The MTMP register controls various temperature settings on a per-sensor
basis. Subsequent patches are going to alter some of these settings for
sensors found on port modules in response to certain events.

In order to prevent the current callers that write to MTMP from
overriding these settings, have them first query the register and then
change only the relevant register fields.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 21 +++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 252e91072c5a..2196c946698a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -106,7 +106,7 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
-	char mtmp_pl[MLXSW_REG_MTMP_LEN];
+	char mtmp_pl[MLXSW_REG_MTMP_LEN] = {0};
 	unsigned long val;
 	int index;
 	int err;
@@ -119,7 +119,13 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 
 	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
 					   mlxsw_hwmon->module_sensor_max);
-	mlxsw_reg_mtmp_pack(mtmp_pl, index, true, true);
+
+	mlxsw_reg_mtmp_sensor_index_set(mtmp_pl, index);
+	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
+	if (err)
+		return err;
+	mlxsw_reg_mtmp_mte_set(mtmp_pl, true);
+	mlxsw_reg_mtmp_mtr_set(mtmp_pl, true);
 	err = mlxsw_reg_write(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to reset temp sensor history\n");
@@ -570,7 +576,6 @@ static void mlxsw_hwmon_attr_add(struct mlxsw_hwmon *mlxsw_hwmon,
 static int mlxsw_hwmon_temp_init(struct mlxsw_hwmon *mlxsw_hwmon)
 {
 	char mtcap_pl[MLXSW_REG_MTCAP_LEN] = {0};
-	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	int i;
 	int err;
 
@@ -581,7 +586,15 @@ static int mlxsw_hwmon_temp_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	}
 	mlxsw_hwmon->sensor_count = mlxsw_reg_mtcap_sensor_count_get(mtcap_pl);
 	for (i = 0; i < mlxsw_hwmon->sensor_count; i++) {
-		mlxsw_reg_mtmp_pack(mtmp_pl, i, true, true);
+		char mtmp_pl[MLXSW_REG_MTMP_LEN] = {0};
+
+		mlxsw_reg_mtmp_sensor_index_set(mtmp_pl, i);
+		err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp),
+				      mtmp_pl);
+		if (err)
+			return err;
+		mlxsw_reg_mtmp_mte_set(mtmp_pl, true);
+		mlxsw_reg_mtmp_mtr_set(mtmp_pl, true);
 		err = mlxsw_reg_write(mlxsw_hwmon->core,
 				      MLXSW_REG(mtmp), mtmp_pl);
 		if (err) {
-- 
2.26.2

