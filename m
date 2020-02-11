Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33450159C49
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbgBKWfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:35:48 -0500
Received: from mail-eopbgr130042.outbound.protection.outlook.com ([40.107.13.42]:49622
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727361AbgBKWfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:35:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gx330hf1Mk3e14OMLYJvNsX8+Drg+Wt1Jmo2ttki+FKbbKIEQzWxuxYppVLLaFWoKOU/F5lKBLRIThuy9RdE9ASSg3sEFNRKyRqUReKnPTbEbr3YL7Z/l50L33rjDgxLWseLKCanZwLQ30EFE9r+081+fzdU1BKmV3d4weDtaNFoREA4zbJ7fINt4qE1LY4Yzop5hk+vE/VXwzgftwi0gQ91OooH/MVuiKxBy2PRy7uXpEke1hxJqc5GDwqyzdNB8zrxT5dHHllSSkqXc1dKYps30eZitTaiQgNwr3t7EfrvWL6cfSbDWpK6iexYN+fI+WC2YiVoZjntKNiqNnWCEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qo897a7Wl+74KMGYQLdT/BSd8AdBi8P+vU5/2+VUvHc=;
 b=VhpZ09R1pfRWjVOIgpY2Q/2V1NiyXzEN5wmPu2Lf6k5NIq/+lk0+MEzrkN/k5Q5D+Dml2ngt5cpLtPFOYfTytkD+hXoS/apDt6j5jCuYySuso28xD1gvk+E6YrV+ltzjFk55rmCqNZnqRIiJjLyyqk5SB+8Vo2dTiQHiV0/4al3dz9gjLbSv7yOt+acvUGTslNsosHuIpjatujPQXP37VBFQoFWzyN+fbFBM4S1n6DhBb8CpWO/9cv619GlEmSzzVF4SPOQ5ZsjYT1t8/8+YuGkPiE04TbnptqW7iWDu1/sbEdHuUXryaNhMKnB4YMj7poxJGLWpoQGB0ammUeU87w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qo897a7Wl+74KMGYQLdT/BSd8AdBi8P+vU5/2+VUvHc=;
 b=iVxUlXwNscRRADufpjiDrp0XRNm5NJacHNkadAe19jsP6pw/zKNoy8seQ5A0XwYyh65TmiBCqrJT+GYJhTfE4CD9Xp/4Pynzwwl0IzYAfnp6YmpLTaTb6DWyJdtYUqtlx1lvJxwt5JJ/rSsXLer93RTZFOJv9HoaCAfJEWirkXY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:39 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 01/13] devlink: Force enclosing array on binary fmsg data
Date:   Tue, 11 Feb 2020 14:32:42 -0800
Message-Id: <20200211223254.101641-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:37 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 206aaa5a-1f73-49a8-1f60-08d7af42b852
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB438300B77B4D90E191CFA7F1BE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(6666004)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VuoAbCzcF58/038GCVgPRriN4ySX+TTm4HWGR2giE9+lJEIl8FEqO809BcGrPLoKz3WDmX+S5Rvo3soBbaM35AQPSapuBJVjSM438CG01jKvqLuWCrVKXHteNW2yM8TKuza8nP/Eer9fLOiirKTU1J+VwUcTlahXHmbJme/LAkdJZQYIN6KYbH3Vf6/30Ey11a696/12Al3iUbnL/RwaXlZO8kOqGXgRN2hX7T+Xz7qUfcQbO2EjLkD99CQPe3Es2Nxp+kOwq5oVeEaLAweA4KS92wV+XjgaNJ9vnjIt/1LsPiIJc233TQ61/YBdSsR1Y/PhpeIFO7SuqV16rdhKgDXUWnYuHS4CyjdhMnrOBgQzo62gtO1T5vEdnO1BjIrojdUzQwu/HvMZjlp1ktWlgZ/Yvhd85UnMN1n3soC+dXlnoKniWKSoDzlRVHOGM7MF1jeUAscntq/dVXiGdIzdqsoBbl8B0g0oh/9Hxbp44Cq/iJzMrMIdQWejcT+m8SnLQ7c7CcpPOODdx3xj8f/QQdrh2r1XkEok2oODDk8RrEU=
X-MS-Exchange-AntiSpam-MessageData: cYEivhe3Lp7L9wvnDw5CMStop5hvI2AoGjReTWDEUA4Nj4YQsmydCU8TuWU7nYtYc/GJnVZ39zW1hOkAqLKiQs3yuNlQaeq0S9BxGa5uwVsBJ0+uixouBh6l8xOUnA1nVhRyvJeTNwmQmJa5TPpnMg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206aaa5a-1f73-49a8-1f60-08d7af42b852
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:39.4274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htyBpS0gRS8MHJFRgH4Z7aCMO3rBuOq4apQqyuqzDe0obhen3wYXwKJOBCkaxl6laNR0/Sro8Sz8PFXzwx+pyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add a new API for start/end binary array brackets [] to force array
around binary data as required from JSON. With this restriction, re-open
API to set binary fmsg data.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/net/devlink.h |  5 +++
 net/core/devlink.c    | 94 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ce5cea428fdc..149c108be66f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -981,12 +981,17 @@ int devlink_fmsg_pair_nest_end(struct devlink_fmsg *fmsg);
 int devlink_fmsg_arr_pair_nest_start(struct devlink_fmsg *fmsg,
 				     const char *name);
 int devlink_fmsg_arr_pair_nest_end(struct devlink_fmsg *fmsg);
+int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
+					const char *name);
+int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg);
 
 int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value);
 int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value);
 int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value);
 int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value);
 int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value);
+int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
+			    u16 value_len);
 
 int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name,
 			       bool value);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 549ee56b7a21..216bdd25ce39 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4237,6 +4237,12 @@ struct devlink_fmsg_item {
 
 struct devlink_fmsg {
 	struct list_head item_list;
+	bool putting_binary; /* This flag forces enclosing of binary data
+			      * in an array brackets. It forces using
+			      * of designated API:
+			      * devlink_fmsg_binary_pair_nest_start()
+			      * devlink_fmsg_binary_pair_nest_end()
+			      */
 };
 
 static struct devlink_fmsg *devlink_fmsg_alloc(void)
@@ -4280,17 +4286,26 @@ static int devlink_fmsg_nest_common(struct devlink_fmsg *fmsg,
 
 int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_OBJ_NEST_START);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_start);
 
 static int devlink_fmsg_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_NEST_END);
 }
 
 int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_end(fmsg);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_end);
@@ -4301,6 +4316,9 @@ static int devlink_fmsg_put_name(struct devlink_fmsg *fmsg, const char *name)
 {
 	struct devlink_fmsg_item *item;
 
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	if (strlen(name) + 1 > DEVLINK_FMSG_MAX_SIZE)
 		return -EMSGSIZE;
 
@@ -4321,6 +4339,9 @@ int devlink_fmsg_pair_nest_start(struct devlink_fmsg *fmsg, const char *name)
 {
 	int err;
 
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_PAIR_NEST_START);
 	if (err)
 		return err;
@@ -4335,6 +4356,9 @@ EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_start);
 
 int devlink_fmsg_pair_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_end(fmsg);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_end);
@@ -4344,6 +4368,9 @@ int devlink_fmsg_arr_pair_nest_start(struct devlink_fmsg *fmsg,
 {
 	int err;
 
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	err = devlink_fmsg_pair_nest_start(fmsg, name);
 	if (err)
 		return err;
@@ -4360,6 +4387,9 @@ int devlink_fmsg_arr_pair_nest_end(struct devlink_fmsg *fmsg)
 {
 	int err;
 
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	err = devlink_fmsg_nest_end(fmsg);
 	if (err)
 		return err;
@@ -4372,6 +4402,30 @@ int devlink_fmsg_arr_pair_nest_end(struct devlink_fmsg *fmsg)
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_end);
 
+int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
+					const char *name)
+{
+	int err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	fmsg->putting_binary = true;
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_start);
+
+int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
+	fmsg->putting_binary = false;
+	return devlink_fmsg_arr_pair_nest_end(fmsg);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_end);
+
 static int devlink_fmsg_put_value(struct devlink_fmsg *fmsg,
 				  const void *value, u16 value_len,
 				  u8 value_nla_type)
@@ -4396,40 +4450,59 @@ static int devlink_fmsg_put_value(struct devlink_fmsg *fmsg,
 
 int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_FLAG);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_bool_put);
 
 int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U8);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u8_put);
 
 int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U32);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u32_put);
 
 int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U64);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u64_put);
 
 int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, value, strlen(value) + 1,
 				      NLA_NUL_STRING);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_string_put);
 
-static int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
-				   u16 value_len)
+int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
+			    u16 value_len)
 {
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, value, value_len, NLA_BINARY);
 }
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_put);
 
 int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name,
 			       bool value)
@@ -4540,10 +4613,11 @@ int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
 				 const void *value, u32 value_len)
 {
 	u32 data_size;
+	int end_err;
 	u32 offset;
 	int err;
 
-	err = devlink_fmsg_arr_pair_nest_start(fmsg, name);
+	err = devlink_fmsg_binary_pair_nest_start(fmsg, name);
 	if (err)
 		return err;
 
@@ -4553,14 +4627,18 @@ int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
 			data_size = DEVLINK_FMSG_MAX_SIZE;
 		err = devlink_fmsg_binary_put(fmsg, value + offset, data_size);
 		if (err)
-			return err;
+			break;
+		/* Exit from loop with a break (instead of
+		 * return) to make sure putting_binary is turned off in
+		 * devlink_fmsg_binary_pair_nest_end
+		 */
 	}
 
-	err = devlink_fmsg_arr_pair_nest_end(fmsg);
-	if (err)
-		return err;
+	end_err = devlink_fmsg_binary_pair_nest_end(fmsg);
+	if (end_err)
+		err = end_err;
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_put);
 
-- 
2.24.1

