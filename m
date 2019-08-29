Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFCB9A2B16
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfH2Xmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:42:36 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:7907
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726416AbfH2Xmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 19:42:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCPKQei5Gqdqh4vy3jSoS4FP5YZJ+lhndS0egZjoBNb3QhGrvWYpAm+8RmdNu2RNnqbr1WLB3sELzl/29mQujYrIl9u/sNUlkThqbCkCn5qlTEFqujmaszD9S46ddoGzbc5dw9uHXRuWhrM1PP7VhP/HJuemM1QhdgIHXR1Ov+qsEZ8z7m5RX1zks99NPqVS4ZNsJdhR18hMEgKzjuW8/XGj79E/No3EC20s3JeWF8AT9KkT6Owyl2iKHAc10rT1EBWrS4HyWQqu/9qncbwHqr+5cz6YUu/AmFVilGz1N24B2ymMboeFkF+pfhKaV9g5NUSv2jairs2FGnhRJBqERg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+5f+O4gOC9f99BftC9NnQmuY1+4szfKFwVU823YrcE=;
 b=imvE7iNNp1pvUcWQEf9pRgVdroOoI6ss1ZgxvKCVGLAicSYhdH+aeOUo5fL17wdohuDdhIXHlNxvgePBR9tHZF6CPliJA8PkmMassCasmUQink4Wlvb44IN+3Nn7UFaxbawRds3VwHXsPMjJDM7V+iQK+hw6iGZJWBGeueehFooo//JeBqRQNkWkhvWRme4+RzT1vNB4MI5uyuCM8RvmxE0vxtMg6Wmz7Tt4uOI7cq3pSkCScmEySmkfeqn46D4YPeH6afTdfO2sApu+yjEAUl4WlxeBsXv1ci2YA49TcTthaelUZQSn6KS2PYBD1MPDwvL5E7PwJlxyJlgERDFz8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+5f+O4gOC9f99BftC9NnQmuY1+4szfKFwVU823YrcE=;
 b=Qkq+4B4FDUJTPjdinetnNNdTySbYV3lDHd+5UDjm9WIRaPaQsLxEx97YFC1cjUX+ICWxf5J+8SeoEBHJ1YBLwEg27aYNfwyzLo/bJpQyYEuAHrwDdi4BG6YKTTH+TLjMWkxnMxtqn9fd9PiK+w9ucllR024wdCak6pUbeGPPG1s=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2333.eurprd05.prod.outlook.com (10.169.135.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 23:42:30 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:42:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 1/5] net/mlx5: Move device memory management to
 mlx5_core
Thread-Topic: [PATCH mlx5-next 1/5] net/mlx5: Move device memory management to
 mlx5_core
Thread-Index: AQHVXsNs1CxBNBt3dki5dvpV4noIUw==
Date:   Thu, 29 Aug 2019 23:42:30 +0000
Message-ID: <20190829234151.9958-2-saeedm@mellanox.com>
References: <20190829234151.9958-1-saeedm@mellanox.com>
In-Reply-To: <20190829234151.9958-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87858c7e-b20f-457f-5694-08d72cda8e42
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2333;
x-ms-traffictypediagnostic: VI1PR0501MB2333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB23338E335C01F0ADC00CA3ECBEA20@VI1PR0501MB2333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(476003)(486006)(450100002)(4326008)(478600001)(2906002)(81156014)(6636002)(110136005)(71200400001)(36756003)(54906003)(71190400001)(305945005)(11346002)(446003)(8676002)(81166006)(7736002)(14444005)(8936002)(5660300002)(50226002)(256004)(2616005)(64756008)(66446008)(186003)(66946007)(14454004)(6116002)(3846002)(316002)(1076003)(6512007)(6486002)(53936002)(6506007)(76176011)(53946003)(107886003)(30864003)(102836004)(6436002)(386003)(25786009)(99286004)(52116002)(86362001)(26005)(66066001)(66556008)(66476007)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2333;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n1VpKmVtGsAEUBlcauuzvP5X2NiE6C8YHkE3MJHNSkiHL/ZBBGlyeAkZe07MqR4t1/T7vwdgcF0Bzpe365fs1t9lJKrqQpO+M8FxNlNWwvhNIQPPfDIGWWEAUOfkNEKXtiQPw7PvgAnMQQroJnDSGoStakr13eVGXMdE3J9WgvJQRqBKjuudX4eUzsCkDqG65vMIEAtPxeohsOKx41jolpP+Ll6+voNmntQlfrkdsYgb7ln7HPqna0+XgRsFHUri17G0BgLv/133PbwR41Mb/U14HQCkAMiS/O/lM8KLRLvOndXlHa1XmOlI8os3jyPAA0dQ6F1U4IMnUaoN9juYTn4cWwr/QjCbcivnQy86uK9zmJhhH602e+JQ55+yQv367UBTsPMocKJM3u0eFoXOS/LDLjH1+eSp2vaxFlaqaYY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87858c7e-b20f-457f-5694-08d72cda8e42
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:42:30.5435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DG7p4uwi+0vXfJdgethciWkzqNMysmczKmAnofTfEL/9ul6OD+bbuvssHfVImt/Z4l8HVFn3SxhII/68Hprt/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Move the device memory allocation and deallocation commands
SW ICM memory to mlx5_core to expose this API for all
mlx5_core users.

This comes as preparation for supporting SW steering in kernel
where it will be required to allocate and register device
memory for direct rule insertion.

In addition, an API to register this device memory for future
remote access operations is introduced using the create_mkey
commands.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c              | 130 ----------
 drivers/infiniband/hw/mlx5/cmd.h              |   4 -
 drivers/infiniband/hw/mlx5/main.c             | 102 +++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   2 -
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/dm.c  | 223 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |   5 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   3 +
 include/linux/mlx5/driver.h                   |  14 ++
 9 files changed, 276 insertions(+), 209 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/=
cmd.c
index 6c8645033102..4937947400cd 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -186,136 +186,6 @@ int mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_a=
ddr_t addr, u64 length)
 	return err;
 }
=20
-int mlx5_cmd_alloc_sw_icm(struct mlx5_dm *dm, int type, u64 length,
-			  u16 uid, phys_addr_t *addr, u32 *obj_id)
-{
-	struct mlx5_core_dev *dev =3D dm->dev;
-	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] =3D {};
-	u32 in[MLX5_ST_SZ_DW(create_sw_icm_in)] =3D {};
-	unsigned long *block_map;
-	u64 icm_start_addr;
-	u32 log_icm_size;
-	u32 num_blocks;
-	u32 max_blocks;
-	u64 block_idx;
-	void *sw_icm;
-	int ret;
-
-	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
-		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_SW_ICM);
-	MLX5_SET(general_obj_in_cmd_hdr, in, uid, uid);
-
-	switch (type) {
-	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
-		icm_start_addr =3D MLX5_CAP64_DEV_MEM(dev,
-						steering_sw_icm_start_address);
-		log_icm_size =3D MLX5_CAP_DEV_MEM(dev, log_steering_sw_icm_size);
-		block_map =3D dm->steering_sw_icm_alloc_blocks;
-		break;
-	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
-		icm_start_addr =3D MLX5_CAP64_DEV_MEM(dev,
-					header_modify_sw_icm_start_address);
-		log_icm_size =3D MLX5_CAP_DEV_MEM(dev,
-						log_header_modify_sw_icm_size);
-		block_map =3D dm->header_modify_sw_icm_alloc_blocks;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	num_blocks =3D (length + MLX5_SW_ICM_BLOCK_SIZE(dev) - 1) >>
-		     MLX5_LOG_SW_ICM_BLOCK_SIZE(dev);
-	max_blocks =3D BIT(log_icm_size - MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
-	spin_lock(&dm->lock);
-	block_idx =3D bitmap_find_next_zero_area(block_map,
-					       max_blocks,
-					       0,
-					       num_blocks, 0);
-
-	if (block_idx < max_blocks)
-		bitmap_set(block_map,
-			   block_idx, num_blocks);
-
-	spin_unlock(&dm->lock);
-
-	if (block_idx >=3D max_blocks)
-		return -ENOMEM;
-
-	sw_icm =3D MLX5_ADDR_OF(create_sw_icm_in, in, sw_icm);
-	icm_start_addr +=3D block_idx << MLX5_LOG_SW_ICM_BLOCK_SIZE(dev);
-	MLX5_SET64(sw_icm, sw_icm, sw_icm_start_addr,
-		   icm_start_addr);
-	MLX5_SET(sw_icm, sw_icm, log_sw_icm_size, ilog2(length));
-
-	ret =3D mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-	if (ret) {
-		spin_lock(&dm->lock);
-		bitmap_clear(block_map,
-			     block_idx, num_blocks);
-		spin_unlock(&dm->lock);
-
-		return ret;
-	}
-
-	*addr =3D icm_start_addr;
-	*obj_id =3D MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
-
-	return 0;
-}
-
-int mlx5_cmd_dealloc_sw_icm(struct mlx5_dm *dm, int type, u64 length,
-			    u16 uid, phys_addr_t addr, u32 obj_id)
-{
-	struct mlx5_core_dev *dev =3D dm->dev;
-	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] =3D {};
-	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] =3D {};
-	unsigned long *block_map;
-	u32 num_blocks;
-	u64 start_idx;
-	int err;
-
-	num_blocks =3D (length + MLX5_SW_ICM_BLOCK_SIZE(dev) - 1) >>
-		     MLX5_LOG_SW_ICM_BLOCK_SIZE(dev);
-
-	switch (type) {
-	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
-		start_idx =3D
-			(addr - MLX5_CAP64_DEV_MEM(
-					dev, steering_sw_icm_start_address)) >>
-			MLX5_LOG_SW_ICM_BLOCK_SIZE(dev);
-		block_map =3D dm->steering_sw_icm_alloc_blocks;
-		break;
-	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
-		start_idx =3D
-			(addr -
-			 MLX5_CAP64_DEV_MEM(
-				 dev, header_modify_sw_icm_start_address)) >>
-			MLX5_LOG_SW_ICM_BLOCK_SIZE(dev);
-		block_map =3D dm->header_modify_sw_icm_alloc_blocks;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
-		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_SW_ICM);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, obj_id);
-	MLX5_SET(general_obj_in_cmd_hdr, in, uid, uid);
-
-	err =3D  mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-	if (err)
-		return err;
-
-	spin_lock(&dm->lock);
-	bitmap_clear(block_map,
-		     start_idx, num_blocks);
-	spin_unlock(&dm->lock);
-
-	return 0;
-}
-
 int mlx5_cmd_query_ext_ppcnt_counters(struct mlx5_core_dev *dev, void *out=
)
 {
 	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] =3D {};
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/=
cmd.h
index 0572dcba6eae..169cab4915e3 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -65,8 +65,4 @@ int mlx5_cmd_alloc_q_counter(struct mlx5_core_dev *dev, u=
16 *counter_id,
 			     u16 uid);
 int mlx5_cmd_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *out=
b,
 		     u16 opmod, u8 port);
-int mlx5_cmd_alloc_sw_icm(struct mlx5_dm *dm, int type, u64 length,
-			  u16 uid, phys_addr_t *addr, u32 *obj_id);
-int mlx5_cmd_dealloc_sw_icm(struct mlx5_dm *dm, int type, u64 length,
-			    u16 uid, phys_addr_t addr, u32 obj_id);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index c2a5780cb394..42fdbbea06f0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2280,6 +2280,7 @@ static inline int check_dm_type_support(struct mlx5_i=
b_dev *dev,
 			return -EOPNOTSUPP;
 		break;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
+	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
 		if (!capable(CAP_SYS_RAWIO) ||
 		    !capable(CAP_NET_RAW))
 			return -EPERM;
@@ -2344,20 +2345,20 @@ static int handle_alloc_dm_sw_icm(struct ib_ucontex=
t *ctx,
 				  struct uverbs_attr_bundle *attrs,
 				  int type)
 {
-	struct mlx5_dm *dm_db =3D &to_mdev(ctx->device)->dm;
+	struct mlx5_core_dev *dev =3D to_mdev(ctx->device)->mdev;
 	u64 act_size;
 	int err;
=20
 	/* Allocation size must a multiple of the basic block size
 	 * and a power of 2.
 	 */
-	act_size =3D round_up(attr->length, MLX5_SW_ICM_BLOCK_SIZE(dm_db->dev));
+	act_size =3D round_up(attr->length, MLX5_SW_ICM_BLOCK_SIZE(dev));
 	act_size =3D roundup_pow_of_two(act_size);
=20
 	dm->size =3D act_size;
-	err =3D mlx5_cmd_alloc_sw_icm(dm_db, type, act_size,
-				    to_mucontext(ctx)->devx_uid, &dm->dev_addr,
-				    &dm->icm_dm.obj_id);
+	err =3D mlx5_dm_sw_icm_alloc(dev, type, act_size,
+				   to_mucontext(ctx)->devx_uid, &dm->dev_addr,
+				   &dm->icm_dm.obj_id);
 	if (err)
 		return err;
=20
@@ -2365,9 +2366,9 @@ static int handle_alloc_dm_sw_icm(struct ib_ucontext =
*ctx,
 			     MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET,
 			     &dm->dev_addr, sizeof(dm->dev_addr));
 	if (err)
-		mlx5_cmd_dealloc_sw_icm(dm_db, type, dm->size,
-					to_mucontext(ctx)->devx_uid,
-					dm->dev_addr, dm->icm_dm.obj_id);
+		mlx5_dm_sw_icm_dealloc(dev, type, dm->size,
+				       to_mucontext(ctx)->devx_uid, dm->dev_addr,
+				       dm->icm_dm.obj_id);
=20
 	return err;
 }
@@ -2407,8 +2408,14 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibd=
ev,
 					    attrs);
 		break;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
+		err =3D handle_alloc_dm_sw_icm(context, dm,
+					     attr, attrs,
+					     MLX5_SW_ICM_TYPE_STEERING);
+		break;
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
-		err =3D handle_alloc_dm_sw_icm(context, dm, attr, attrs, type);
+		err =3D handle_alloc_dm_sw_icm(context, dm,
+					     attr, attrs,
+					     MLX5_SW_ICM_TYPE_HEADER_MODIFY);
 		break;
 	default:
 		err =3D -EOPNOTSUPP;
@@ -2428,6 +2435,7 @@ int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uve=
rbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_ucontext *ctx =3D rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
+	struct mlx5_core_dev *dev =3D to_mdev(ibdm->device)->mdev;
 	struct mlx5_dm *dm_db =3D &to_mdev(ibdm->device)->dm;
 	struct mlx5_ib_dm *dm =3D to_mdm(ibdm);
 	u32 page_idx;
@@ -2439,19 +2447,23 @@ int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct u=
verbs_attr_bundle *attrs)
 		if (ret)
 			return ret;
=20
-		page_idx =3D (dm->dev_addr -
-			    pci_resource_start(dm_db->dev->pdev, 0) -
-			    MLX5_CAP64_DEV_MEM(dm_db->dev,
-					       memic_bar_start_addr)) >>
-			   PAGE_SHIFT;
+		page_idx =3D (dm->dev_addr - pci_resource_start(dev->pdev, 0) -
+			    MLX5_CAP64_DEV_MEM(dev, memic_bar_start_addr)) >>
+			    PAGE_SHIFT;
 		bitmap_clear(ctx->dm_pages, page_idx,
 			     DIV_ROUND_UP(dm->size, PAGE_SIZE));
 		break;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
+		ret =3D mlx5_dm_sw_icm_dealloc(dev, MLX5_SW_ICM_TYPE_STEERING,
+					     dm->size, ctx->devx_uid, dm->dev_addr,
+					     dm->icm_dm.obj_id);
+		if (ret)
+			return ret;
+		break;
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
-		ret =3D mlx5_cmd_dealloc_sw_icm(dm_db, dm->type, dm->size,
-					      ctx->devx_uid, dm->dev_addr,
-					      dm->icm_dm.obj_id);
+		ret =3D mlx5_dm_sw_icm_dealloc(dev, MLX5_SW_ICM_TYPE_HEADER_MODIFY,
+					     dm->size, ctx->devx_uid, dm->dev_addr,
+					     dm->icm_dm.obj_id);
 		if (ret)
 			return ret;
 		break;
@@ -6097,8 +6109,6 @@ static struct ib_counters *mlx5_ib_create_counters(st=
ruct ib_device *device,
=20
 static void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_core_dev *mdev =3D dev->mdev;
-
 	mlx5_ib_cleanup_multiport_master(dev);
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
 		srcu_barrier(&dev->mr_srcu);
@@ -6106,29 +6116,11 @@ static void mlx5_ib_stage_init_cleanup(struct mlx5_=
ib_dev *dev)
 	}
=20
 	WARN_ON(!bitmap_empty(dev->dm.memic_alloc_pages, MLX5_MAX_MEMIC_PAGES));
-
-	WARN_ON(dev->dm.steering_sw_icm_alloc_blocks &&
-		!bitmap_empty(
-			dev->dm.steering_sw_icm_alloc_blocks,
-			BIT(MLX5_CAP_DEV_MEM(mdev, log_steering_sw_icm_size) -
-			    MLX5_LOG_SW_ICM_BLOCK_SIZE(mdev))));
-
-	kfree(dev->dm.steering_sw_icm_alloc_blocks);
-
-	WARN_ON(dev->dm.header_modify_sw_icm_alloc_blocks &&
-		!bitmap_empty(dev->dm.header_modify_sw_icm_alloc_blocks,
-			      BIT(MLX5_CAP_DEV_MEM(
-					  mdev, log_header_modify_sw_icm_size) -
-				  MLX5_LOG_SW_ICM_BLOCK_SIZE(mdev))));
-
-	kfree(dev->dm.header_modify_sw_icm_alloc_blocks);
 }
=20
 static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev =3D dev->mdev;
-	u64 header_modify_icm_blocks =3D 0;
-	u64 steering_icm_blocks =3D 0;
 	int err;
 	int i;
=20
@@ -6173,51 +6165,17 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_d=
ev *dev)
 	INIT_LIST_HEAD(&dev->qp_list);
 	spin_lock_init(&dev->reset_flow_resource_lock);
=20
-	if (MLX5_CAP_GEN_64(mdev, general_obj_types) &
-	    MLX5_GENERAL_OBJ_TYPES_CAP_SW_ICM) {
-		if (MLX5_CAP64_DEV_MEM(mdev, steering_sw_icm_start_address)) {
-			steering_icm_blocks =3D
-				BIT(MLX5_CAP_DEV_MEM(mdev,
-						     log_steering_sw_icm_size) -
-				    MLX5_LOG_SW_ICM_BLOCK_SIZE(mdev));
-
-			dev->dm.steering_sw_icm_alloc_blocks =3D
-				kcalloc(BITS_TO_LONGS(steering_icm_blocks),
-					sizeof(unsigned long), GFP_KERNEL);
-			if (!dev->dm.steering_sw_icm_alloc_blocks)
-				goto err_mp;
-		}
-
-		if (MLX5_CAP64_DEV_MEM(mdev,
-				       header_modify_sw_icm_start_address)) {
-			header_modify_icm_blocks =3D BIT(
-				MLX5_CAP_DEV_MEM(
-					mdev, log_header_modify_sw_icm_size) -
-				MLX5_LOG_SW_ICM_BLOCK_SIZE(mdev));
-
-			dev->dm.header_modify_sw_icm_alloc_blocks =3D
-				kcalloc(BITS_TO_LONGS(header_modify_icm_blocks),
-					sizeof(unsigned long), GFP_KERNEL);
-			if (!dev->dm.header_modify_sw_icm_alloc_blocks)
-				goto err_dm;
-		}
-	}
-
 	spin_lock_init(&dev->dm.lock);
 	dev->dm.dev =3D mdev;
=20
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
 		err =3D init_srcu_struct(&dev->mr_srcu);
 		if (err)
-			goto err_dm;
+			goto err_mp;
 	}
=20
 	return 0;
=20
-err_dm:
-	kfree(dev->dm.steering_sw_icm_alloc_blocks);
-	kfree(dev->dm.header_modify_sw_icm_alloc_blocks);
-
 err_mp:
 	mlx5_ib_cleanup_multiport_master(dev);
=20
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/m=
lx5/mlx5_ib.h
index c482f19958b3..afd69ba33b2b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -880,8 +880,6 @@ struct mlx5_dm {
 	 */
 	spinlock_t lock;
 	DECLARE_BITMAP(memic_alloc_pages, MLX5_MAX_MEMIC_PAGES);
-	unsigned long *steering_sw_icm_alloc_blocks;
-	unsigned long *header_modify_sw_icm_alloc_blocks;
 };
=20
 struct mlx5_read_counters_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 57d2cc666fe3..4eb52e8500c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -15,7 +15,7 @@ mlx5_core-y :=3D	main.o cmd.o debugfs.o fw.o eq.o uar.o p=
agealloc.o \
 		health.o mcg.o cq.o alloc.o qp.o port.o mr.o pd.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
 		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
-		lib/devcom.o lib/pci_vsc.o diag/fs_tracepoint.o \
+		lib/devcom.o lib/pci_vsc.o lib/dm.o diag/fs_tracepoint.o \
 		diag/fw_tracer.o diag/crdump.o devlink.o
=20
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c b/drivers/net=
/ethernet/mellanox/mlx5/core/lib/dm.c
new file mode 100644
index 000000000000..e065c2f68f5a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2019 Mellanox Technologies
+
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/device.h>
+
+#include "mlx5_core.h"
+#include "lib/mlx5.h"
+
+struct mlx5_dm {
+	/* protect access to icm bitmask */
+	spinlock_t lock;
+	unsigned long *steering_sw_icm_alloc_blocks;
+	unsigned long *header_modify_sw_icm_alloc_blocks;
+};
+
+struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
+{
+	u64 header_modify_icm_blocks =3D 0;
+	u64 steering_icm_blocks =3D 0;
+	struct mlx5_dm *dm;
+
+	if (!(MLX5_CAP_GEN_64(dev, general_obj_types) & MLX5_GENERAL_OBJ_TYPES_CA=
P_SW_ICM))
+		return 0;
+
+	dm =3D kzalloc(sizeof(*dm), GFP_KERNEL);
+	if (!dm)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&dm->lock);
+
+	if (MLX5_CAP64_DEV_MEM(dev, steering_sw_icm_start_address)) {
+		steering_icm_blocks =3D
+			BIT(MLX5_CAP_DEV_MEM(dev, log_steering_sw_icm_size) -
+			    MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
+
+		dm->steering_sw_icm_alloc_blocks =3D
+			kcalloc(BITS_TO_LONGS(steering_icm_blocks),
+				sizeof(unsigned long), GFP_KERNEL);
+		if (!dm->steering_sw_icm_alloc_blocks)
+			goto err_steering;
+	}
+
+	if (MLX5_CAP64_DEV_MEM(dev, header_modify_sw_icm_start_address)) {
+		header_modify_icm_blocks =3D
+			BIT(MLX5_CAP_DEV_MEM(dev, log_header_modify_sw_icm_size) -
+			    MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
+
+		dm->header_modify_sw_icm_alloc_blocks =3D
+			kcalloc(BITS_TO_LONGS(header_modify_icm_blocks),
+				sizeof(unsigned long), GFP_KERNEL);
+		if (!dm->header_modify_sw_icm_alloc_blocks)
+			goto err_modify_hdr;
+	}
+
+	return dm;
+
+err_modify_hdr:
+	kfree(dm->steering_sw_icm_alloc_blocks);
+
+err_steering:
+	kfree(dm);
+
+	return ERR_PTR(-ENOMEM);
+}
+
+void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_dm *dm =3D dev->dm;
+
+	if (!dev->dm)
+		return;
+
+	if (dm->steering_sw_icm_alloc_blocks) {
+		WARN_ON(!bitmap_empty(dm->steering_sw_icm_alloc_blocks,
+				      BIT(MLX5_CAP_DEV_MEM(dev, log_steering_sw_icm_size) -
+					  MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))));
+		kfree(dm->steering_sw_icm_alloc_blocks);
+	}
+
+	if (dm->header_modify_sw_icm_alloc_blocks) {
+		WARN_ON(!bitmap_empty(dm->header_modify_sw_icm_alloc_blocks,
+				      BIT(MLX5_CAP_DEV_MEM(dev,
+							   log_header_modify_sw_icm_size) -
+				      MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))));
+		kfree(dm->header_modify_sw_icm_alloc_blocks);
+	}
+
+	kfree(dm);
+}
+
+int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type =
type,
+			 u64 length, u16 uid, phys_addr_t *addr, u32 *obj_id)
+{
+	u32 num_blocks =3D DIV_ROUND_UP_ULL(length, MLX5_SW_ICM_BLOCK_SIZE(dev));
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(create_sw_icm_in)] =3D {};
+	struct mlx5_dm *dm =3D dev->dm;
+	unsigned long *block_map;
+	u64 icm_start_addr;
+	u32 log_icm_size;
+	u32 max_blocks;
+	u64 block_idx;
+	void *sw_icm;
+	int ret;
+
+	if (!dev->dm)
+		return -EOPNOTSUPP;
+
+	if (!length || (length & (length - 1)) ||
+	    length & (MLX5_SW_ICM_BLOCK_SIZE(dev) - 1))
+		return -EINVAL;
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_SW_ICM);
+	MLX5_SET(general_obj_in_cmd_hdr, in, uid, uid);
+
+	switch (type) {
+	case MLX5_SW_ICM_TYPE_STEERING:
+		icm_start_addr =3D MLX5_CAP64_DEV_MEM(dev, steering_sw_icm_start_address=
);
+		log_icm_size =3D MLX5_CAP_DEV_MEM(dev, log_steering_sw_icm_size);
+		block_map =3D dm->steering_sw_icm_alloc_blocks;
+		break;
+	case MLX5_SW_ICM_TYPE_HEADER_MODIFY:
+		icm_start_addr =3D MLX5_CAP64_DEV_MEM(dev, header_modify_sw_icm_start_ad=
dress);
+		log_icm_size =3D MLX5_CAP_DEV_MEM(dev,
+						log_header_modify_sw_icm_size);
+		block_map =3D dm->header_modify_sw_icm_alloc_blocks;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!block_map)
+		return -EOPNOTSUPP;
+
+	max_blocks =3D BIT(log_icm_size - MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
+	spin_lock(&dm->lock);
+	block_idx =3D bitmap_find_next_zero_area(block_map,
+					       max_blocks,
+					       0,
+					       num_blocks, 0);
+
+	if (block_idx < max_blocks)
+		bitmap_set(block_map,
+			   block_idx, num_blocks);
+
+	spin_unlock(&dm->lock);
+
+	if (block_idx >=3D max_blocks)
+		return -ENOMEM;
+
+	sw_icm =3D MLX5_ADDR_OF(create_sw_icm_in, in, sw_icm);
+	icm_start_addr +=3D block_idx << MLX5_LOG_SW_ICM_BLOCK_SIZE(dev);
+	MLX5_SET64(sw_icm, sw_icm, sw_icm_start_addr,
+		   icm_start_addr);
+	MLX5_SET(sw_icm, sw_icm, log_sw_icm_size, ilog2(length));
+
+	ret =3D mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (ret) {
+		spin_lock(&dm->lock);
+		bitmap_clear(block_map,
+			     block_idx, num_blocks);
+		spin_unlock(&dm->lock);
+
+		return ret;
+	}
+
+	*addr =3D icm_start_addr;
+	*obj_id =3D MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_dm_sw_icm_alloc);
+
+int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_typ=
e type,
+			   u64 length, u16 uid, phys_addr_t addr, u32 obj_id)
+{
+	u32 num_blocks =3D DIV_ROUND_UP_ULL(length, MLX5_SW_ICM_BLOCK_SIZE(dev));
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] =3D {};
+	struct mlx5_dm *dm =3D dev->dm;
+	unsigned long *block_map;
+	u64 icm_start_addr;
+	u64 start_idx;
+	int err;
+
+	if (!dev->dm)
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case MLX5_SW_ICM_TYPE_STEERING:
+		icm_start_addr =3D MLX5_CAP64_DEV_MEM(dev, steering_sw_icm_start_address=
);
+		block_map =3D dm->steering_sw_icm_alloc_blocks;
+		break;
+	case MLX5_SW_ICM_TYPE_HEADER_MODIFY:
+		icm_start_addr =3D MLX5_CAP64_DEV_MEM(dev, header_modify_sw_icm_start_ad=
dress);
+		block_map =3D dm->header_modify_sw_icm_alloc_blocks;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_SW_ICM);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, obj_id);
+	MLX5_SET(general_obj_in_cmd_hdr, in, uid, uid);
+
+	err =3D  mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	start_idx =3D (addr - icm_start_addr) >> MLX5_LOG_SW_ICM_BLOCK_SIZE(dev);
+	spin_lock(&dm->lock);
+	bitmap_clear(block_map,
+		     start_idx, num_blocks);
+	spin_unlock(&dm->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_dm_sw_icm_dealloc);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index 7f70ecb1db6d..c1679d11d71f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -879,6 +879,10 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_eswitch_cleanup;
 	}
=20
+	dev->dm =3D mlx5_dm_create(dev);
+	if (IS_ERR(dev->dm))
+		mlx5_core_warn(dev, "Failed to init device memory%d\n", err);
+
 	dev->tracer =3D mlx5_fw_tracer_create(dev);
=20
 	return 0;
@@ -912,6 +916,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 {
 	mlx5_fw_tracer_destroy(dev->tracer);
+	mlx5_dm_cleanup(dev);
 	mlx5_fpga_cleanup(dev);
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
 	mlx5_sriov_cleanup(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/=
net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 471bbc48bc1f..bbcf4ee40ad5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -198,6 +198,9 @@ int mlx5_set_mtpps(struct mlx5_core_dev *mdev, u32 *mtp=
ps, u32 mtpps_size);
 int mlx5_query_mtppse(struct mlx5_core_dev *mdev, u8 pin, u8 *arm, u8 *mod=
e);
 int mlx5_set_mtppse(struct mlx5_core_dev *mdev, u8 pin, u8 arm, u8 mode);
=20
+struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev);
+void mlx5_dm_cleanup(struct mlx5_core_dev *dev);
+
 #define MLX5_PPS_CAP(mdev) (MLX5_CAP_GEN((mdev), pps) &&		\
 			    MLX5_CAP_GEN((mdev), pps_modify) &&		\
 			    MLX5_CAP_MCAM_FEATURE((mdev), mtpps_fs) &&	\
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0acd28f2e62c..72bc6ce44b55 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -622,6 +622,11 @@ struct mlx5e_resources {
 	struct mlx5_sq_bfreg       bfreg;
 };
=20
+enum mlx5_sw_icm_type {
+	MLX5_SW_ICM_TYPE_STEERING,
+	MLX5_SW_ICM_TYPE_HEADER_MODIFY,
+};
+
 #define MLX5_MAX_RESERVED_GIDS 8
=20
 struct mlx5_rsvd_gids {
@@ -653,10 +658,14 @@ struct mlx5_clock {
 	struct mlx5_pps            pps_info;
 };
=20
+struct mlx5_dm;
 struct mlx5_fw_tracer;
 struct mlx5_vxlan;
 struct mlx5_geneve;
=20
+#define MLX5_LOG_SW_ICM_BLOCK_SIZE(dev) (MLX5_CAP_DEV_MEM(dev, log_sw_icm_=
alloc_granularity))
+#define MLX5_SW_ICM_BLOCK_SIZE(dev) (1 << MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))
+
 struct mlx5_core_dev {
 	struct device *device;
 	enum mlx5_coredev_type coredev_type;
@@ -690,6 +699,7 @@ struct mlx5_core_dev {
 	atomic_t		num_qps;
 	u32			issi;
 	struct mlx5e_resources  mlx5e_res;
+	struct mlx5_dm          *dm;
 	struct mlx5_vxlan       *vxlan;
 	struct mlx5_geneve      *geneve;
 	struct {
@@ -1072,6 +1082,10 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_de=
v *dev,
 				 size_t *offsets);
 struct mlx5_uars_page *mlx5_get_uars_page(struct mlx5_core_dev *mdev);
 void mlx5_put_uars_page(struct mlx5_core_dev *mdev, struct mlx5_uars_page =
*up);
+int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type =
type,
+			 u64 length, u16 uid, phys_addr_t *addr, u32 *obj_id);
+int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_typ=
e type,
+			   u64 length, u16 uid, phys_addr_t addr, u32 obj_id);
=20
 #ifdef CONFIG_MLX5_CORE_IPOIB
 struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
--=20
2.21.0

