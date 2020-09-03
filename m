Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AD125C3DA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgICPAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:00:00 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39359 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729086AbgICOGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:06:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id E2F0F580558;
        Thu,  3 Sep 2020 09:42:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 03 Sep 2020 09:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=MpniyUkvSmQe9NFRoUMTf3bTbxDOD1xr/Mvpz3sKJJE=; b=vdbumxA+
        KVqfkTf73dfHyF/3AuQD9I5VqoSM6r4wATs+zZXYdBMM0rpkqqQnusteMIp++Wbr
        pAlXZZn1G2onKqHxwWWVXQXS6WUQ1E9i3a9QXjjkxANhKWUGlxDpAt47KLfoY9/R
        ZM3dgBUzCUGFf/1bbnxlWlMBdUQT9RF6ns6iHkudiqTc+jhtygMMhthkH3MKpVam
        DhbiTzBeBl3dK1TM4fxk86fq7U2V701V+nboAHslLIXv3XWdW0SYZTVEMOodbGtu
        fU+44TeEwuGU2OND06X+OjLW34XyNbrZsJVGAkR7c1piAWvF2TZvYb3AZoA6oHPh
        zkFwGSbn6CzUeQ==
X-ME-Sender: <xms:w_JQX0T_-r0SHAo3B6rT1Sfsl1Bt4bp4QtqQMrUqLsbZq6rhE4-VLw>
    <xme:w_JQXxzk2_dIaKvW-x0nDQ94muuFwGphDoIuTjJQhIGawaBOTewgXjAgKPLdiFQN0
    IpqiYbKuheyyUY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeguddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeduteeiveffffevleekleejffekhfekhefgtdfftefhledvjefggfehgfevjeek
    hfenucfkphepkeegrddvvdelrdefiedrjedunecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:w_JQXx2gwaDDPaAMNmf6_ztWStyOuei-4jCodUn7RB4NGW5Pb0-JwA>
    <xmx:w_JQX4Cm6m3hJq9Rz7j44ef0QVL70U9Bl6fDCdlfExIRQfMb-4EYCw>
    <xmx:w_JQX9iow1gSowVBwZiuPWWk0kr0S4oIzfjhMQuZQJAYYWwiM3Ws2g>
    <xmx:w_JQX1ittnUMRp0BX9J8kRtmIrICiTDumCW9f98X2RjjgMMJu5NO5w>
Received: from shredder.mtl.com (igld-84-229-36-71.inter.net.il [84.229.36.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 241853280065;
        Thu,  3 Sep 2020 09:42:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, vadimp@nvidia.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/3] mlxsw: core_hwmon: Split temperature querying from show functions
Date:   Thu,  3 Sep 2020 16:41:44 +0300
Message-Id: <20200903134146.2166437-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200903134146.2166437-1-idosch@idosch.org>
References: <20200903134146.2166437-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

mlxsw_hwmon_module_temp_show(), mlxsw_hwmon_module_temp_critical_show()
and mlxsw_hwmon_module_temp_emergency_show() query the relevant
temperature from firmware and fill the value in provided buffers.

Split the temperature querying functionality to individual get()
functions and call them from the show() functions.

The get() functions will be used by subsequent patches in the set.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 70 ++++++++++++++-----
 1 file changed, 54 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 3fe878d7c94c..3f1822535bc6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -205,25 +205,39 @@ static ssize_t mlxsw_hwmon_pwm_store(struct device *dev,
 	return len;
 }
 
-static ssize_t mlxsw_hwmon_module_temp_show(struct device *dev,
-					    struct device_attribute *attr,
-					    char *buf)
+static int mlxsw_hwmon_module_temp_get(struct device *dev,
+				       struct device_attribute *attr,
+				       int *p_temp)
 {
 	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	u8 module;
-	int temp;
 	int err;
 
 	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
 	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
 			    false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
+	if (err) {
+		dev_err(dev, "Failed to query module temperature\n");
+		return err;
+	}
+	mlxsw_reg_mtmp_unpack(mtmp_pl, p_temp, NULL, NULL);
+
+	return 0;
+}
+
+static ssize_t mlxsw_hwmon_module_temp_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	int err, temp;
+
+	err = mlxsw_hwmon_module_temp_get(dev, attr, &temp);
 	if (err)
 		return err;
-	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
 
 	return sprintf(buf, "%d\n", temp);
 }
@@ -270,48 +284,72 @@ static ssize_t mlxsw_hwmon_module_temp_fault_show(struct device *dev,
 	return sprintf(buf, "%u\n", fault);
 }
 
-static ssize_t
-mlxsw_hwmon_module_temp_critical_show(struct device *dev,
-				      struct device_attribute *attr, char *buf)
+static int mlxsw_hwmon_module_temp_critical_get(struct device *dev,
+						struct device_attribute *attr,
+						int *p_temp)
 {
 	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
-	int temp;
 	u8 module;
 	int err;
 
 	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
 	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, module,
-						   SFP_TEMP_HIGH_WARN, &temp);
+						   SFP_TEMP_HIGH_WARN, p_temp);
 	if (err) {
 		dev_err(dev, "Failed to query module temperature thresholds\n");
 		return err;
 	}
 
-	return sprintf(buf, "%u\n", temp);
+	return 0;
 }
 
 static ssize_t
-mlxsw_hwmon_module_temp_emergency_show(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf)
+mlxsw_hwmon_module_temp_critical_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	int err, temp;
+
+	err = mlxsw_hwmon_module_temp_critical_get(dev, attr, &temp);
+	if (err)
+		return err;
+
+	return sprintf(buf, "%u\n", temp);
+}
+
+static int mlxsw_hwmon_module_temp_emergency_get(struct device *dev,
+						 struct device_attribute *attr,
+						 int *p_temp)
 {
 	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
 	u8 module;
-	int temp;
 	int err;
 
 	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
 	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, module,
-						   SFP_TEMP_HIGH_ALARM, &temp);
+						   SFP_TEMP_HIGH_ALARM, p_temp);
 	if (err) {
 		dev_err(dev, "Failed to query module temperature thresholds\n");
 		return err;
 	}
 
+	return 0;
+}
+
+static ssize_t
+mlxsw_hwmon_module_temp_emergency_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	int err, temp;
+
+	err = mlxsw_hwmon_module_temp_emergency_get(dev, attr, &temp);
+	if (err)
+		return err;
+
 	return sprintf(buf, "%u\n", temp);
 }
 
-- 
2.26.2

