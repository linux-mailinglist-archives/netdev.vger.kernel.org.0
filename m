Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A158E6D206F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjCaMd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbjCaMdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:33:47 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8FB1F799;
        Fri, 31 Mar 2023 05:33:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYmTv3ahJ52vwZDYMDjwt1IShgpGt0De74dn3pZhQykY4rhoGKKtjS4ju/k8qwkNI9z229MVFde81xOssrfCU6xCyHV75pb4JhbuzQ/woq+ZrlsAJuHF5/QR/G81ExYDS+WP+HhrvxSonSPJWEq4WORdjmewOCI5nsbjWBBwVcOeuAqh4qUqkTNjf35MPbsGoreOXh22wYDF4hJQ2TAVUZ4P7zWoi+U342aroR4gTjLcbY9TBwzFD+shD8rKC4aPRUdvHmkKsZNhkMYkShis2C6UIzgDRdgg5bmmIM5Yzw30VrygoEN8CHxXY0DDonqcuJI0kgLNhcyUlmPXDPQAvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bzb/c13mz5bsrr+GKFQGdN9ApKwteIcO4n5CRYEkEXk=;
 b=ghv3Dxu0Rb7BrEyPMteTe5OGxu0zo/4KT7aur2RJYKzZKgcbzSoKnYWEM20Fiv1VNYQWhckiWhILH8NoNU8BIbI3mElX4tBzAG/2XOs1Qeb5yJOljAZwVpl7kCMh5+OxGBICNq/+LaRJZXMHbuePbniq18hbRQi7xdMiRnITJoofpdEN0BovRp8MdQdXHkCh8bjQkN/j5hT5I+xYw1wyVhSzzCaJMUku0QSfvK3ZgC3OinlUhUMJSMyQmDQ1XzyR5ZCMXhm95OrBbM0O1OlARI9sW2T+dqQ+T7GCF0wA1WVOIGvqiTDLtjwtH1CEpvOnOqGMYIZGUPbc6KqjSJVbXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzb/c13mz5bsrr+GKFQGdN9ApKwteIcO4n5CRYEkEXk=;
 b=j0O6aluNs6owV576m6OZ9WB1MzkHPue3QWWE0nhH9SEK+sLWpGpHBfvuyT4qReuFKi950M233CUSsRkK9HwOI2Kdf4WLNmaejVEPvf2YzfWwkdyfjJMArDR/5kP2KxzprMty1cxcnsADqqiWcGxFaCmjxgnMs+k5If3RoKCVThc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by DB9PR04MB9355.eurprd04.prod.outlook.com (2603:10a6:10:36b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Fri, 31 Mar
 2023 12:33:25 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733%5]) with mapi id 15.20.6222.034; Fri, 31 Mar 2023
 12:33:25 +0000
From:   "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [RFC net-next] net: phy: introduce phy_reg_field interface
Date:   Fri, 31 Mar 2023 15:32:59 +0300
Message-Id: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|DB9PR04MB9355:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c712832-d0f0-4cec-3ffc-08db31e41f68
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a2yXnYHEw7fDTojznLw8XSPu51KiMsdoGIpw75dF0ZV+rB1LqUlMgd1JyIoUL2Elhkt0nrFA6yvM11DnbUTqLLUn1A3n7zBpoL8p5xJvvUbqQgGsfws+PB2iT/O70Q4KIDdMuawCY3ZGtgYO+k5U0XwrFgDSPAmoiDywRXGnLtyJjsL/PMlAz9/gJq+wEbnj1Scr4FatOxL5QcIAHVx0PQhcPTnD4IsSwaV5wL79h6sJAEkM6jKnzdY4PNC6R1VKY8L6AbXQ2SSjCA7yiLpapEOfu84q2iU7Jeg+zL1wPDSPQMRnJDCuLutG9BzJ02M2lOyKLr0u2PQkQ6gCBX98do5ZQ5rCYaxF5qeeyJZoCUH0y/FdYz5iIC6Tdr3RtTGyLKe77Hr+4t3ud4YI7R/hTAZf7cTqLJB3kQVT/yencswcFbyt5fv6C5xezQPmH6fBl51+f5mmqzlJRlotrSfENztmtMYPFCatK3lSzrOdqbjDpPGBvFfBv0rx6zz+MOEaguW11Gpzt/QcHDrFXYW4Yq3aR9DVGUNRvZZrteQ3QReEEZencKPPPPRSzAuPtQEFtI1TiqXHZxofGnqa1NcOMLAvq67baoZdde3XNkVpZWFvbPi7NJvpWoD2UL0E4wqO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199021)(38100700002)(5660300002)(316002)(8936002)(41300700001)(86362001)(8676002)(4326008)(66476007)(66556008)(38350700002)(83380400001)(2906002)(66946007)(6486002)(2616005)(52116002)(6666004)(26005)(6512007)(6506007)(1076003)(186003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qdxVrvTPbDnyUbgIrtThHWRfpcKS+e+IjlbFk7HniaFPGURk0AT8W/htn3wJ?=
 =?us-ascii?Q?LKvqaMZqOSei5Q/395GxNAIess4HmfUlGiuGVyNibH4B6gT46NrbUhxKgMmZ?=
 =?us-ascii?Q?S7rjrygnF3TRsoPyPsy/K/7ImWM6fPHW/y5ipOXTERNCoTvpu547qTKToCvc?=
 =?us-ascii?Q?P+g75XdN04s90pK6+nFuUcAjFnFRrplujM4ZT9Ve6rmGBeqeNDR08/lD4VBs?=
 =?us-ascii?Q?P09D4MnMmL6QQsKw1kKlhNAaA16/fsg8DwUBmlqyVAxi5/+SxYxVShA13G1Y?=
 =?us-ascii?Q?8iwdZW/jngn8aYxKSNPSaY8uRWqRsBmF789HcCob7IqkIK+Eh+InI9aTYwYz?=
 =?us-ascii?Q?Z+RB0oCL4AjOvpIh2m7Sbz24OkPehSrkQ9RjPonTInF5qS7EhRjng3gVn8tK?=
 =?us-ascii?Q?P/K5bFvIxfxta5zNBL3ruEirIFLSM1Kbv65n732FOV1xyFr0AcXlnmVPqEg2?=
 =?us-ascii?Q?H/X5Qc9lDDRDwyA74Zn3dwgnw8sNjmDjqtlAcqaKnCreHutB2OmHI0DHDXZu?=
 =?us-ascii?Q?vEG9ThCYUWtJBEoIN0bJ9DxyjjwB8DUVRvjJHbhQPv+J6f4VkzqVHHtI09bu?=
 =?us-ascii?Q?Woa+w9n1WAv+UaLL0Q0o19ssHTkl05n2c9rbrgnOPaopNMZGLjw8F16Jp/05?=
 =?us-ascii?Q?PWLrGMLzj5Axy7mNbR3VNlF/UmQssMTJ8R6wHr9ASHsa88WONKe+2PBDwq9e?=
 =?us-ascii?Q?ut89/uTCylxGh3+xzs1jFC0vG+lJBpQTmdQI8f4bb173Uur2S8yULSYAS5DV?=
 =?us-ascii?Q?wH+D0VwzwoibViIhgMWid3NM3yFy55K+Ca/Kfc0ZIgzvYzQVbnjCMcprfUDY?=
 =?us-ascii?Q?W7OiUPVXV5x6nx/ioT/LjvpRQnkho7Q9BN+fC7EzzxdT7h+/gVYi+SroONJq?=
 =?us-ascii?Q?Rt23l/hOeLKMTNO3UVkoTn7bFM2AZrieMPmAL5jay3eFlpfMsHuLJi71rPu7?=
 =?us-ascii?Q?Q1XTbn7pjpOLN1fWhSafqYFDwzxxRtBCbLIYxT303rgbEtCOlauzjhH/hxn6?=
 =?us-ascii?Q?elxWsJ9LXswo5GtxnIZBY/v7HdeEURu1p4wx6Qlht7uK8FkiCrmN4p1mQ9J2?=
 =?us-ascii?Q?K+iO+SmoT1xebms2gMR3kuMSu+37UBxzPGKczm0TYEDDxX7ImxH2wbSRnu1v?=
 =?us-ascii?Q?dAYtK17DgTqkykCAwyxiPvD5IjxmoTjiyRe0UnjwZXt6PcqIaYzCoFmU6+r6?=
 =?us-ascii?Q?xA9Orogf4EWHY7dZ2eBNANmyvR0Qf6QX+ZIph60+mWx4Kz4aCB+2w74lplym?=
 =?us-ascii?Q?eLDbfwki9mYiLFtFaD8nkr7hqO9nCaSDA3oM3uNI07uKY819mpXtwaJbQtTK?=
 =?us-ascii?Q?7Q1FZSQcSD0O3w9AQEJfR4tXwRoG+Vl3YPxCjzCx7W5uAIc96bZzaNS74tjS?=
 =?us-ascii?Q?/dx6DDB0lmHtrQoIs0UPfIgoM1TXtY3pejCsFmBVaHlIOd8+bcVE3jeJtCkN?=
 =?us-ascii?Q?5/jK7P/evqEkI6G0EBuD5ebs73prV9SrvnZ10jOagqT9Y8xXbHWak588EJvk?=
 =?us-ascii?Q?rnbhYujeBqHvNoUABEBBeEaco10dO+EzK/+674KRvUetWfWHMu1HnH48GUCg?=
 =?us-ascii?Q?Ymg6MjxrnjuLYSf8iVB4RIPqKyA/oQgbF9O9RgX44hR7aKxsyDSu57XDw5lT?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c712832-d0f0-4cec-3ffc-08db31e41f68
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 12:33:25.4228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nV9K/DVRqV105IU0zZsERKXOTJJBbqBk5WIPFWjjMeRk0yiSPDXsSdhGicJMyUBfM598T2sj6O7WU3dEiXohb1nMdRxgX97XXdNkcsEeva8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9355
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs can be heavily modified between revisions, and the addresses of
the registers are changed and the register fields are moved from one
register to another.

To integrate more PHYs in the same driver with the same register fields,
but these register fields were located in different registers at
different offsets, I introduced the phy_reg_fied structure.

phy_reg_fied structure abstracts the register fields differences.

Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/phy-core.c | 77 ++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h        | 73 ++++++++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index a64186dc53f8..e9c16e78dc72 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -593,6 +593,45 @@ int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 }
 EXPORT_SYMBOL(phy_read_mmd);
 
+/**
+ * phy_read_reg_field - Convenience function for reading a register field
+ * on a given PHY.
+ * @phydev: the phy_device struct
+ * @reg_field: the phy_reg_field structure to be read
+ *
+ * Return: the reg field value on success, -errno on failure
+ */
+int phy_read_reg_field(struct phy_device *phydev,
+		       const struct phy_reg_field *reg_field)
+{
+	u16 mask;
+	int ret;
+
+	if (reg_field->size == 0) {
+		phydev_warn(phydev, "Trying to read a reg field of size 0.");
+		return -EINVAL;
+	}
+
+	phy_lock_mdio_bus(phydev);
+	if (reg_field->mmd)
+		ret = __phy_read_mmd(phydev, reg_field->devad,
+				     reg_field->reg);
+	else
+		ret = __phy_read(phydev, reg_field->reg);
+	phy_unlock_mdio_bus(phydev);
+
+	if (ret < 0)
+		return ret;
+
+	mask = reg_field->size == 1 ? BIT(reg_field->offset) :
+		GENMASK(reg_field->offset + reg_field->size - 1, reg_field->offset);
+	ret &= mask;
+	ret >>= reg_field->offset;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_read_reg_field);
+
 /**
  * __phy_write_mmd - Convenience function for writing a register
  * on an MMD on a given PHY.
@@ -652,6 +691,44 @@ int phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(phy_write_mmd);
 
+/**
+ * phy_write_reg_field - Convenience function for writing a register field
+ * on a given PHY.
+ * @phydev: the phy_device struct
+ * @reg_field: the phy_reg_field structure to be written
+ * @val: value to write to @reg_field
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int phy_write_reg_field(struct phy_device *phydev,
+			const struct phy_reg_field *reg_field, u16 val)
+{
+	u16 mask;
+	u16 set;
+	int ret;
+
+	if (reg_field->size == 0) {
+		phydev_warn(phydev, "Trying to write a reg field of size 0.");
+		return -EINVAL;
+	}
+
+	mask = reg_field->size == 1 ? BIT(reg_field->offset) :
+		GENMASK(reg_field->offset + reg_field->size - 1, reg_field->offset);
+	set = val << reg_field->offset;
+
+	phy_lock_mdio_bus(phydev);
+	if (reg_field->mmd)
+		ret = __phy_modify_mmd_changed(phydev, reg_field->devad,
+					       reg_field->reg, mask, set);
+	else
+		ret = __phy_modify_changed(phydev, reg_field->reg,
+					   mask, set);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_write_reg_field);
+
 /**
  * phy_modify_changed - Function for modifying a PHY register
  * @phydev: the phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2f83cfc206e5..f8bf90895340 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1113,6 +1113,39 @@ void phy_resolve_aneg_pause(struct phy_device *phydev);
 void phy_resolve_aneg_linkmode(struct phy_device *phydev);
 void phy_check_downshift(struct phy_device *phydev);
 
+/**
+ * struct phy_reg_field - The generic register field structure for a PHY
+ * @reg: register address
+ * @devad: MMD where the register is present
+ * @offset: offset of the field inside the register
+ * @size: size of the register filed
+ * @mmd: if true, then the register field will be read using phy_read_mmd
+ */
+struct phy_reg_field {
+	u16 reg;
+	u8 devad;
+	u8 offset;
+	u8 size;
+	bool mmd;
+};
+
+#define PHY_REG_FIELD_INIT(_reg, _offset, _size) \
+	((struct phy_reg_field) {		 \
+		.reg = _reg,			 \
+		.offset = _offset,		 \
+		.size = _size,			 \
+		.mmd = false			 \
+	})
+
+#define PHY_REG_FIELD_MMD_INIT(_reg, _mmd, _offset, _size) \
+	((struct phy_reg_field) {			   \
+		.reg = _reg,				   \
+		.devad =  _mmd,				   \
+		.offset = _offset,			   \
+		.size = _size,				   \
+		.mmd = true				   \
+	})
+
 /**
  * phy_read - Convenience function for reading a given PHY register
  * @phydev: the phy_device struct
@@ -1205,6 +1238,13 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
  */
 int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 
+/*
+ * phy_read_reg_field - Convenience function for reading a register field on a
+ * given PHY.
+ */
+int phy_read_reg_field(struct phy_device *phydev,
+		       const struct phy_reg_field *reg_field);
+
 /**
  * phy_read_mmd_poll_timeout - Periodically poll a PHY register until a
  *                             condition is met or a timeout occurs
@@ -1248,6 +1288,39 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
  */
 int phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val);
 
+/*
+ * phy_write_reg_field - Convenience function for writing a register field on a
+ * given PHY.
+ */
+int phy_write_reg_field(struct phy_device *phydev,
+			const struct phy_reg_field *reg_field, u16 val);
+
+/*
+ * phy_set_reg_field - Convenience function for setting a register field
+ * of one bit on a given PHY.
+ */
+static inline int phy_set_reg_field(struct phy_device *phydev,
+				    const struct phy_reg_field *reg_field)
+{
+	if (reg_field->size != 1)
+		return -EINVAL;
+
+	return phy_write_reg_field(phydev, reg_field, 1);
+}
+
+/*
+ * phy_clear_reg_field - Convenience function for clearing a register field
+ * of one bit on a given PHY.
+ */
+static inline int phy_clear_reg_field(struct phy_device *phydev,
+				      const struct phy_reg_field *reg_field)
+{
+	if (reg_field->size != 1)
+		return -EINVAL;
+
+	return phy_write_reg_field(phydev, reg_field, 0);
+}
+
 /*
  * __phy_write_mmd - Convenience function for writing a register
  * on an MMD on a given PHY.
-- 
2.34.1

