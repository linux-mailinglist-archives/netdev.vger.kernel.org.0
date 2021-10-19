Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3B1432DB1
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 08:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhJSGH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:07:29 -0400
Received: from mail-db8eur05on2097.outbound.protection.outlook.com ([40.107.20.97]:47969
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229527AbhJSGH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 02:07:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khbOGyKso7umiuV28irOo95+75kBz83Yhg2a3n8iPyr3HKoMTh0150OTR+hxQQ2KAdik8rMiXHKGIS7W0mrpSkaOWD7YHSG/R2m5W8FgVqJNoLXSlFIaoG5GXfxZ3a8v2ShAqXG2tia5XGSNwznE/Q6u6RiNsvtO8d/5nFh6Tiith17DiqoSHLTQvA8ynysmX8MXj9r9lOUOMWCk5Cj8NDFGxIEFpLIlAIKOlyHLF8LrM/kCTuBPhS3AxaD177HQhb14lxqCX3usiWxmDwH+BGtELOtmzX0kD3yCDlXxByx1RxJJkUV8qEkhZA35+2/0Cnjl0ubQedsioKvkQxHFOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJdj3b9RZMG5Fw13mJmRXuU5GQZtXfNRAosiJHeRtJg=;
 b=XmS4qy+SJKiZxRr7rf+oYUDQdTL0XG8k23Gxjcrm8ZbfbWy5aoOf3EP60xjkLM9TAfqLxULSAWsfcv/IZorMvWDK2UNQIowvG0Y/21kamgxXSIsRGMDsogbOj+f0twUEfgd0PK+0V1KhgvWyjoNiub30ALkG6fWdeTdxvJTCENfSMTUhKojddMrCTKlZGEEvBwjaEbMs2KH7ZXX041jab6pJ+CyEYnm/je4LnkXpRO78XYe2ozoF58vcR5pFoWS8dyHSC+Z67Vhq44E5mMQVbRgGCQ+qgw67UCLgc9lzFXrYAmS7MeG0jJz/ACfMdPkFeXTsyeADfTwe2nvUDRiXHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJdj3b9RZMG5Fw13mJmRXuU5GQZtXfNRAosiJHeRtJg=;
 b=DGBOasCCnXVIFr82mqAPmugaAzeKwsJxOW4yc6HQJBfzzvxxWd8cNsLhFX70s/bJhBkhGN4I7V4mUtNYUT9Q4S2IK0hN7hu+Zk1CqmqEn37xqdfV53szjSjckxRFZCCeCtfcNQPLMtJRXN5ou4uMXxbJFS0Loo69d1Uq9CLlwLI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0478.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:32::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 06:05:11 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::4c5:a11b:e5c6:2f36]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::4c5:a11b:e5c6:2f36%4]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 06:05:11 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: marvell: prestera: add firmware v4.0 support
Date:   Tue, 19 Oct 2021 09:03:43 +0300
Message-Id: <1634623424-15011-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::23) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by FR3P281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4628.13 via Frontend Transport; Tue, 19 Oct 2021 06:05:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f95f5f8-ceac-4dd0-9d23-08d992c668c2
X-MS-TrafficTypeDiagnostic: VI1P190MB0478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0478962062FF95631E6A3D6C8FBD9@VI1P190MB0478.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OvGw0tjMd1qRiEWwJtokXyWEsaiNOgZtIah1J/cRpuagMqafu6V9WVqmvFguWWG092CG+TcsiDtPlITEGM0kD1TcmOPGSTuGdTxrkICTGxeqsZrHdhVzqptstLnzVimdHN854twuUnrG8boNo3VWHeX23CpHrBdxWLOjYokJkpOy4VWDb22KeJ51kcIMqa+WzA+oZxpQXQMFtYvS0Pz7DDoL+uULnSXzyOp4/9t7ATwYtuy8gxuIzwdjJ1+jlQnV8mLWxaiERhsvPEBG3GCz7UNmzRO6P89qMUVHTYhlLnlqzAAHKHnq2eCcFS8tscqb4DUvejebAQ1IZISILGjPzsMh1dfvvU9oIt15tbZ4S/OtOnHMVr6hjzmO05bx60aj5WIIyJlAPJSXlXC0yfCA4nU/DfggcMRurU2URODNBCTtZiFC9eajgNmJSyojk6leQKJZIorspwT6wDkE2cMH6nsaqtJtgsIIvehGjLdWMQk3k9fHpzHkFJHJ/usjJbmfLCEp2/NwwRfJ2T6vDuqEPWe2vJi1cH6nSE1Gq3xB2fuklphlo5ZPLfbcSsKsSQk5yaKsqDrDcZ2ygrg7FWa5V5mpMHYBi++1P5EsPtcs6nqxnqDVKS/YdnZroDHNPBqBEeCXq0UoO/s+23RpZ/RIpGq22r+EAXLoz+Smv/ZyeXJEIAL8hyQlXdoUwAOnNYrILNFCcWYXRNbn4SlcFBlgZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(396003)(39840400004)(8676002)(5660300002)(44832011)(36756003)(66574015)(83380400001)(956004)(38100700002)(66946007)(30864003)(6512007)(6666004)(66556008)(38350700002)(66476007)(316002)(54906003)(508600001)(8936002)(4326008)(6916009)(186003)(26005)(6486002)(52116002)(86362001)(6506007)(2616005)(2906002)(559001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VsXVPdC53gKnASpOhZ+45uFXpDCY1d4DdXmTi2iOm/oF2Qkxn7woWeksqRjm?=
 =?us-ascii?Q?gluN+LhVnLra/nMxef0bCQWDLQ9jBLlXg1DXkmsiJeEfBYSjT6XAmyXBQjwQ?=
 =?us-ascii?Q?60G0a918zJzjyGxGzSkCFTGt8vHb1skkWfubH4CJeaMnhThGcoMeLseEkUe7?=
 =?us-ascii?Q?mLV0zLpcmm73ZA8GIeS7PbvzeLUgEc3Uz3yMUO6EmZUJjXfdvJq7RDOCk/CO?=
 =?us-ascii?Q?SQmaMecUb9Ws9KHqCZp0vf4zeslaQ/xHLw/KNPuwhu/JhbvDwQK7af7wM6s3?=
 =?us-ascii?Q?61uuqrnd5rqiR5NiGwrXR8bKVhTYS4mdN2KTJI0cTx+HeRCGH59VE1El4Nhx?=
 =?us-ascii?Q?BCVHgzsqDqRNRVE/ojwKMNFqXpka4d9iXkGulDQuTshMPXF0Vg94yMQKMsWi?=
 =?us-ascii?Q?Bk0Vud/thDKEMNvXYSJ56y3x2LYFqYwmdvxeHCq/dZdbMqR0MaQqx7stY9Zd?=
 =?us-ascii?Q?EsjbjBClge4n9jvEVjk9BoXVCm0kC272ntZ915IfKACmPCts23t733dO1Arg?=
 =?us-ascii?Q?u/5IWSa0lTWtTTDeMJnvBkmuAwGyE/V7DBBTY2e/miKsgSzeZUpXOyJEAGWn?=
 =?us-ascii?Q?vD9WKu0a6hMSvU6cJ1r1hhiO7kKKTdw4u3LeWQtKmMFVPhW+T+Cr0oPF/mQj?=
 =?us-ascii?Q?7Ehj++HAwSCaYtbetekC9l3KWwmEoTwEuES1QyLvs+pIhIIiYKHZJ3xGhej2?=
 =?us-ascii?Q?8NRC3/n9ldOdJgHplbMI/LHg9Pl1GE+iYPLeicke9Zm+yOgEZhJ06WiTMSKt?=
 =?us-ascii?Q?EtkDdgAYBNHqOkSU0h5Dnm0DH7PccijVK4Zj2Pl5xqIeJMWzB+pnoHuCULSA?=
 =?us-ascii?Q?8yJzl6tnDRP7gkn4qXG1k+IJO+EDltbZQLrCCRn3dpTxnUImdl+ymw4SBm/z?=
 =?us-ascii?Q?MIRV2+5buJUapSrW25QTU/HYTnHaPxxLimBIP7PqFd3Jb48zQb+pdkpIoK7z?=
 =?us-ascii?Q?oNbpjhmVWiRoF8eIGjID8G7vMrrZnW7lzUYzzLnNl9T4fwACeGIkPpAwSBG1?=
 =?us-ascii?Q?MHx9qI65PHimFOSaeSO/1a45H527GGyExMaCRATzjKD2XMscSsi0X7NvAkcv?=
 =?us-ascii?Q?qsDPzWkVn/u/RJtJpZL9BvtJA+mDkXa9izanx1ZPpdB1CaqjMPDCgo6ZWds/?=
 =?us-ascii?Q?HX0tz95FJILHt1TJ6/gi9246iwsSOpRCwxQ8KVFBxZsncoS2nwEeksvIHVu6?=
 =?us-ascii?Q?BHgYVY0a7QTlsLGN2WZadUbGfTVWmBg+LyOxczJUcu76EwljPyelbfEQJnuu?=
 =?us-ascii?Q?NTcU6D+y71BvBFjsq7/FOFuGmhHtHHLAiw6yr8TM/r3Najqq6laFtV4d+70D?=
 =?us-ascii?Q?8UUASroAfmpDUVx0MMKEUDP4?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f95f5f8-ceac-4dd0-9d23-08d992c668c2
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 06:05:11.1466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R0DNTyJQV3+IW8ROWxqON/X7xxFeFQyr91pYJPoU4WXwZgfhFYF91xFhv/KfiZTCfNoRgonFkQJRuIgMyVjuIfZm4dVCBTZLOMBm8KCTT5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0478
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Add firmware (FW) version 4.0 support for Marvell Prestera
driver. This FW ABI will be compatible with future Prestera
driver versions and features.

The previous FW support is dropped due to significant changes
in FW ABI, thus this version of Prestera driver will not be
compatible with previous FW versions.

Co-developed-by: Vadym Kochan <vkochan@marvell.com>
Signed-off-by: Vadym Kochan <vkochan@marvell.com>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---

Changes in V2:
    * Fix sparse errors:
      warning: no previous prototype for function 'prestera_hw_port_state_set' [-Wmissing-prototypes]
      int prestera_hw_port_state_set(const struct prestera_port *port,
          ^

 drivers/net/ethernet/marvell/prestera/prestera.h   |  70 ++-
 .../ethernet/marvell/prestera/prestera_ethtool.c   | 219 ++++++----
 .../ethernet/marvell/prestera/prestera_ethtool.h   |   6 +
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 483 +++++++++------------
 .../net/ethernet/marvell/prestera/prestera_hw.h    |  47 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  | 144 ++++--
 .../net/ethernet/marvell/prestera/prestera_pci.c   | 114 +++--
 .../net/ethernet/marvell/prestera/prestera_rxtx.c  |   7 -
 8 files changed, 628 insertions(+), 462 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index f18fe664b373..bc187ccdd8d3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -53,6 +53,8 @@ struct prestera_port_stats {
 	u64 good_octets_sent;
 };
 
+#define PRESTERA_AP_PORT_MAX   (10)
+
 struct prestera_port_caps {
 	u64 supp_link_modes;
 	u8 supp_fec;
@@ -69,6 +71,40 @@ struct prestera_lag {
 
 struct prestera_flow_block;
 
+struct prestera_port_mac_state {
+	bool oper;
+	u32 mode;
+	u32 speed;
+	u8 duplex;
+	u8 fc;
+	u8 fec;
+};
+
+struct prestera_port_phy_state {
+	u64 lmode_bmap;
+	struct {
+		bool pause;
+		bool asym_pause;
+	} remote_fc;
+	u8 mdix;
+};
+
+struct prestera_port_mac_config {
+	bool admin;
+	u32 mode;
+	u8 inband;
+	u32 speed;
+	u8 duplex;
+	u8 fec;
+};
+
+/* TODO: add another parameters here: modes, etc... */
+struct prestera_port_phy_config {
+	bool admin;
+	u32 mode;
+	u8 mdix;
+};
+
 struct prestera_port {
 	struct net_device *dev;
 	struct prestera_switch *sw;
@@ -91,6 +127,10 @@ struct prestera_port {
 		struct prestera_port_stats stats;
 		struct delayed_work caching_dw;
 	} cached_hw_stats;
+	struct prestera_port_mac_config cfg_mac;
+	struct prestera_port_phy_config cfg_phy;
+	struct prestera_port_mac_state state_mac;
+	struct prestera_port_phy_state state_phy;
 };
 
 struct prestera_device {
@@ -107,7 +147,7 @@ struct prestera_device {
 	int (*recv_msg)(struct prestera_device *dev, void *msg, size_t size);
 
 	/* called by higher layer to send request to the firmware */
-	int (*send_req)(struct prestera_device *dev, void *in_msg,
+	int (*send_req)(struct prestera_device *dev, int qid, void *in_msg,
 			size_t in_size, void *out_msg, size_t out_size,
 			unsigned int wait);
 };
@@ -129,13 +169,28 @@ enum prestera_rxtx_event_id {
 
 enum prestera_port_event_id {
 	PRESTERA_PORT_EVENT_UNSPEC,
-	PRESTERA_PORT_EVENT_STATE_CHANGED,
+	PRESTERA_PORT_EVENT_MAC_STATE_CHANGED,
 };
 
 struct prestera_port_event {
 	u32 port_id;
 	union {
-		u32 oper_state;
+		struct {
+			u8 oper;
+			u32 mode;
+			u32 speed;
+			u8 duplex;
+			u8 fc;
+			u8 fec;
+		} mac;
+		struct {
+			u8 mdix;
+			u64 lmode_bmap;
+			struct {
+				bool pause;
+				bool asym_pause;
+			} remote_fc;
+		} phy;
 	} data;
 };
 
@@ -223,11 +278,16 @@ void prestera_device_unregister(struct prestera_device *dev);
 struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 						 u32 dev_id, u32 hw_id);
 
-int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
-			      u64 adver_link_modes, u8 adver_fec);
+int prestera_port_autoneg_set(struct prestera_port *port, u64 link_modes);
 
 struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
 
+int prestera_port_cfg_mac_read(struct prestera_port *port,
+			       struct prestera_port_mac_config *cfg);
+
+int prestera_port_cfg_mac_write(struct prestera_port *port,
+				struct prestera_port_mac_config *cfg);
+
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
index 93a5e2baf808..6011454dba71 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -323,7 +323,6 @@ static int prestera_port_type_set(const struct ethtool_link_ksettings *ecmd,
 {
 	u32 new_mode = PRESTERA_LINK_MODE_MAX;
 	u32 type, mode;
-	int err;
 
 	for (type = 0; type < PRESTERA_PORT_TYPE_MAX; type++) {
 		if (port_types[type].eth_type == ecmd->base.port &&
@@ -348,13 +347,8 @@ static int prestera_port_type_set(const struct ethtool_link_ksettings *ecmd,
 		}
 	}
 
-	if (new_mode < PRESTERA_LINK_MODE_MAX)
-		err = prestera_hw_port_link_mode_set(port, new_mode);
-	else
-		err = -EINVAL;
-
-	if (err)
-		return err;
+	if (new_mode >= PRESTERA_LINK_MODE_MAX)
+		return -EINVAL;
 
 	port->caps.type = type;
 	port->autoneg = false;
@@ -434,27 +428,33 @@ static void prestera_port_supp_types_get(struct ethtool_link_ksettings *ecmd,
 static void prestera_port_remote_cap_get(struct ethtool_link_ksettings *ecmd,
 					 struct prestera_port *port)
 {
+	struct prestera_port_phy_state *state = &port->state_phy;
 	bool asym_pause;
 	bool pause;
 	u64 bitmap;
 	int err;
 
-	err = prestera_hw_port_remote_cap_get(port, &bitmap);
-	if (!err) {
-		prestera_modes_to_eth(ecmd->link_modes.lp_advertising,
-				      bitmap, 0, PRESTERA_PORT_TYPE_NONE);
+	err = prestera_hw_port_phy_mode_get(port, NULL, &state->lmode_bmap,
+					    &state->remote_fc.pause,
+					    &state->remote_fc.asym_pause);
+	if (err)
+		netdev_warn(port->dev, "Remote link caps get failed %d",
+			    port->caps.transceiver);
 
-		if (!bitmap_empty(ecmd->link_modes.lp_advertising,
-				  __ETHTOOL_LINK_MODE_MASK_NBITS)) {
-			ethtool_link_ksettings_add_link_mode(ecmd,
-							     lp_advertising,
-							     Autoneg);
-		}
+	bitmap = state->lmode_bmap;
+
+	prestera_modes_to_eth(ecmd->link_modes.lp_advertising,
+			      bitmap, 0, PRESTERA_PORT_TYPE_NONE);
+
+	if (!bitmap_empty(ecmd->link_modes.lp_advertising,
+			  __ETHTOOL_LINK_MODE_MASK_NBITS)) {
+		ethtool_link_ksettings_add_link_mode(ecmd,
+						     lp_advertising,
+						     Autoneg);
 	}
 
-	err = prestera_hw_port_remote_fc_get(port, &pause, &asym_pause);
-	if (err)
-		return;
+	pause = state->remote_fc.pause;
+	asym_pause = state->remote_fc.asym_pause;
 
 	if (pause)
 		ethtool_link_ksettings_add_link_mode(ecmd,
@@ -466,30 +466,46 @@ static void prestera_port_remote_cap_get(struct ethtool_link_ksettings *ecmd,
 						     Asym_Pause);
 }
 
-static void prestera_port_speed_get(struct ethtool_link_ksettings *ecmd,
-				    struct prestera_port *port)
+static void prestera_port_link_mode_get(struct ethtool_link_ksettings *ecmd,
+					struct prestera_port *port)
 {
+	struct prestera_port_mac_state *state = &port->state_mac;
 	u32 speed;
+	u8 duplex;
 	int err;
 
-	err = prestera_hw_port_speed_get(port, &speed);
-	ecmd->base.speed = err ? SPEED_UNKNOWN : speed;
+	if (!port->state_mac.oper)
+		return;
+
+	if (state->speed == SPEED_UNKNOWN || state->duplex == DUPLEX_UNKNOWN) {
+		err = prestera_hw_port_mac_mode_get(port, NULL, &speed,
+						    &duplex, NULL);
+		if (err) {
+			state->speed = SPEED_UNKNOWN;
+			state->duplex = DUPLEX_UNKNOWN;
+		} else {
+			state->speed = speed;
+			state->duplex = duplex == PRESTERA_PORT_DUPLEX_FULL ?
+					  DUPLEX_FULL : DUPLEX_HALF;
+		}
+	}
+
+	ecmd->base.speed = port->state_mac.speed;
+	ecmd->base.duplex = port->state_mac.duplex;
 }
 
-static void prestera_port_duplex_get(struct ethtool_link_ksettings *ecmd,
-				     struct prestera_port *port)
+static void prestera_port_mdix_get(struct ethtool_link_ksettings *ecmd,
+				   struct prestera_port *port)
 {
-	u8 duplex;
-	int err;
+	struct prestera_port_phy_state *state = &port->state_phy;
 
-	err = prestera_hw_port_duplex_get(port, &duplex);
-	if (err) {
-		ecmd->base.duplex = DUPLEX_UNKNOWN;
-		return;
+	if (prestera_hw_port_phy_mode_get(port, &state->mdix, NULL, NULL, NULL)) {
+		netdev_warn(port->dev, "MDIX params get failed");
+		state->mdix = ETH_TP_MDI_INVALID;
 	}
 
-	ecmd->base.duplex = duplex == PRESTERA_PORT_DUPLEX_FULL ?
-			    DUPLEX_FULL : DUPLEX_HALF;
+	ecmd->base.eth_tp_mdix = port->state_phy.mdix;
+	ecmd->base.eth_tp_mdix_ctrl = port->cfg_phy.mdix;
 }
 
 static int
@@ -501,6 +517,8 @@ prestera_ethtool_get_link_ksettings(struct net_device *dev,
 	ethtool_link_ksettings_zero_link_mode(ecmd, supported);
 	ethtool_link_ksettings_zero_link_mode(ecmd, advertising);
 	ethtool_link_ksettings_zero_link_mode(ecmd, lp_advertising);
+	ecmd->base.speed = SPEED_UNKNOWN;
+	ecmd->base.duplex = DUPLEX_UNKNOWN;
 
 	ecmd->base.autoneg = port->autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 
@@ -521,13 +539,8 @@ prestera_ethtool_get_link_ksettings(struct net_device *dev,
 
 	prestera_port_supp_types_get(ecmd, port);
 
-	if (netif_carrier_ok(dev)) {
-		prestera_port_speed_get(ecmd, port);
-		prestera_port_duplex_get(ecmd, port);
-	} else {
-		ecmd->base.speed = SPEED_UNKNOWN;
-		ecmd->base.duplex = DUPLEX_UNKNOWN;
-	}
+	if (netif_carrier_ok(dev))
+		prestera_port_link_mode_get(ecmd, port);
 
 	ecmd->base.port = prestera_port_type_get(port);
 
@@ -545,8 +558,7 @@ prestera_ethtool_get_link_ksettings(struct net_device *dev,
 
 	if (port->caps.type == PRESTERA_PORT_TYPE_TP &&
 	    port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER)
-		prestera_hw_port_mdix_get(port, &ecmd->base.eth_tp_mdix,
-					  &ecmd->base.eth_tp_mdix_ctrl);
+		prestera_port_mdix_get(ecmd, port);
 
 	return 0;
 }
@@ -555,12 +567,17 @@ static int prestera_port_mdix_set(const struct ethtool_link_ksettings *ecmd,
 				  struct prestera_port *port)
 {
 	if (ecmd->base.eth_tp_mdix_ctrl != ETH_TP_MDI_INVALID &&
-	    port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER &&
-	    port->caps.type == PRESTERA_PORT_TYPE_TP)
-		return prestera_hw_port_mdix_set(port,
-						 ecmd->base.eth_tp_mdix_ctrl);
-
+	    port->caps.transceiver ==  PRESTERA_PORT_TCVR_COPPER &&
+	    port->caps.type == PRESTERA_PORT_TYPE_TP) {
+		port->cfg_phy.mdix = ecmd->base.eth_tp_mdix_ctrl;
+		return prestera_hw_port_phy_mode_set(port, port->cfg_phy.admin,
+						     port->autoneg,
+						     port->cfg_phy.mode,
+						     port->adver_link_modes,
+						     port->cfg_phy.mdix);
+	}
 	return 0;
+
 }
 
 static int prestera_port_link_mode_set(struct prestera_port *port,
@@ -568,12 +585,15 @@ static int prestera_port_link_mode_set(struct prestera_port *port,
 {
 	u32 new_mode = PRESTERA_LINK_MODE_MAX;
 	u32 mode;
+	int err;
 
 	for (mode = 0; mode < PRESTERA_LINK_MODE_MAX; mode++) {
-		if (speed != port_link_modes[mode].speed)
+		if (speed != SPEED_UNKNOWN &&
+		    speed != port_link_modes[mode].speed)
 			continue;
 
-		if (duplex != port_link_modes[mode].duplex)
+		if (duplex != DUPLEX_UNKNOWN &&
+		    duplex != port_link_modes[mode].duplex)
 			continue;
 
 		if (!(port_link_modes[mode].pr_mask &
@@ -590,36 +610,31 @@ static int prestera_port_link_mode_set(struct prestera_port *port,
 	if (new_mode == PRESTERA_LINK_MODE_MAX)
 		return -EOPNOTSUPP;
 
-	return prestera_hw_port_link_mode_set(port, new_mode);
+	err = prestera_hw_port_phy_mode_set(port, port->cfg_phy.admin,
+					    false, new_mode, 0,
+					    port->cfg_phy.mdix);
+	if (err)
+		return err;
+
+	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
+	port->adver_link_modes = 0;
+	port->cfg_phy.mode = new_mode;
+	port->autoneg = false;
+
+	return 0;
 }
 
 static int
 prestera_port_speed_duplex_set(const struct ethtool_link_ksettings *ecmd,
 			       struct prestera_port *port)
 {
-	u32 curr_mode;
-	u8 duplex;
-	u32 speed;
-	int err;
-
-	err = prestera_hw_port_link_mode_get(port, &curr_mode);
-	if (err)
-		return err;
-	if (curr_mode >= PRESTERA_LINK_MODE_MAX)
-		return -EINVAL;
+	u8 duplex = DUPLEX_UNKNOWN;
 
 	if (ecmd->base.duplex != DUPLEX_UNKNOWN)
 		duplex = ecmd->base.duplex == DUPLEX_FULL ?
 			 PRESTERA_PORT_DUPLEX_FULL : PRESTERA_PORT_DUPLEX_HALF;
-	else
-		duplex = port_link_modes[curr_mode].duplex;
 
-	if (ecmd->base.speed != SPEED_UNKNOWN)
-		speed = ecmd->base.speed;
-	else
-		speed = port_link_modes[curr_mode].speed;
-
-	return prestera_port_link_mode_set(port, speed, duplex,
+	return prestera_port_link_mode_set(port, ecmd->base.speed, duplex,
 					   port->caps.type);
 }
 
@@ -645,19 +660,12 @@ prestera_ethtool_set_link_ksettings(struct net_device *dev,
 	prestera_modes_from_eth(ecmd->link_modes.advertising, &adver_modes,
 				&adver_fec, port->caps.type);
 
-	err = prestera_port_autoneg_set(port,
-					ecmd->base.autoneg == AUTONEG_ENABLE,
-					adver_modes, adver_fec);
-	if (err)
-		return err;
-
-	if (ecmd->base.autoneg == AUTONEG_DISABLE) {
+	if (ecmd->base.autoneg == AUTONEG_ENABLE)
+		err = prestera_port_autoneg_set(port, adver_modes);
+	else
 		err = prestera_port_speed_duplex_set(ecmd, port);
-		if (err)
-			return err;
-	}
 
-	return 0;
+	return err;
 }
 
 static int prestera_ethtool_get_fecparam(struct net_device *dev,
@@ -668,7 +676,7 @@ static int prestera_ethtool_get_fecparam(struct net_device *dev,
 	u32 mode;
 	int err;
 
-	err = prestera_hw_port_fec_get(port, &active);
+	err = prestera_hw_port_mac_mode_get(port, NULL, NULL, NULL, &active);
 	if (err)
 		return err;
 
@@ -693,18 +701,19 @@ static int prestera_ethtool_set_fecparam(struct net_device *dev,
 					 struct ethtool_fecparam *fecparam)
 {
 	struct prestera_port *port = netdev_priv(dev);
-	u8 fec, active;
+	struct prestera_port_mac_config cfg_mac;
 	u32 mode;
-	int err;
+	u8 fec;
 
 	if (port->autoneg) {
 		netdev_err(dev, "FEC set is not allowed while autoneg is on\n");
 		return -EINVAL;
 	}
 
-	err = prestera_hw_port_fec_get(port, &active);
-	if (err)
-		return err;
+	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
+		netdev_err(dev, "FEC set is not allowed on non-SFP ports\n");
+		return -EINVAL;
+	}
 
 	fec = PRESTERA_PORT_FEC_MAX;
 	for (mode = 0; mode < PRESTERA_PORT_FEC_MAX; mode++) {
@@ -715,13 +724,19 @@ static int prestera_ethtool_set_fecparam(struct net_device *dev,
 		}
 	}
 
-	if (fec == active)
+	prestera_port_cfg_mac_read(port, &cfg_mac);
+
+	if (fec == cfg_mac.fec)
 		return 0;
 
-	if (fec == PRESTERA_PORT_FEC_MAX)
-		return -EOPNOTSUPP;
+	if (fec == PRESTERA_PORT_FEC_MAX) {
+		netdev_err(dev, "Unsupported FEC requested");
+		return -EINVAL;
+	}
+
+	cfg_mac.fec = fec;
 
-	return prestera_hw_port_fec_set(port, fec);
+	return prestera_port_cfg_mac_write(port, &cfg_mac);
 }
 
 static int prestera_ethtool_get_sset_count(struct net_device *dev, int sset)
@@ -766,6 +781,28 @@ static int prestera_ethtool_nway_reset(struct net_device *dev)
 	return -EINVAL;
 }
 
+void prestera_ethtool_port_state_changed(struct prestera_port *port,
+					 struct prestera_port_event *evt)
+{
+	struct prestera_port_mac_state *smac = &port->state_mac;
+
+	smac->oper = evt->data.mac.oper;
+
+	if (smac->oper) {
+		smac->mode = evt->data.mac.mode;
+		smac->speed = evt->data.mac.speed;
+		smac->duplex = evt->data.mac.duplex;
+		smac->fc = evt->data.mac.fc;
+		smac->fec = evt->data.mac.fec;
+	} else {
+		smac->mode = PRESTERA_MAC_MODE_MAX;
+		smac->speed = SPEED_UNKNOWN;
+		smac->duplex = DUPLEX_UNKNOWN;
+		smac->fc = 0;
+		smac->fec = 0;
+	}
+}
+
 const struct ethtool_ops prestera_ethtool_ops = {
 	.get_drvinfo = prestera_ethtool_get_drvinfo,
 	.get_link_ksettings = prestera_ethtool_get_link_ksettings,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
index 523ef1f592ce..9eb18e99dea6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
@@ -6,6 +6,12 @@
 
 #include <linux/ethtool.h>
 
+struct prestera_port_event;
+struct prestera_port;
+
 extern const struct ethtool_ops prestera_ethtool_ops;
 
+void prestera_ethtool_port_state_changed(struct prestera_port *port,
+					 struct prestera_port_event *evt);
+
 #endif /* _PRESTERA_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index c1297859e471..a7330097c18d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -47,7 +47,6 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_ACL_PORT_UNBIND = 0x531,
 
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
-	PRESTERA_CMD_TYPE_RXTX_PORT_INIT = 0x801,
 
 	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
 	PRESTERA_CMD_TYPE_LAG_MEMBER_DELETE = 0x901,
@@ -76,16 +75,12 @@ enum {
 	PRESTERA_CMD_PORT_ATTR_LEARNING = 7,
 	PRESTERA_CMD_PORT_ATTR_FLOOD = 8,
 	PRESTERA_CMD_PORT_ATTR_CAPABILITY = 9,
-	PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY = 10,
-	PRESTERA_CMD_PORT_ATTR_REMOTE_FC = 11,
-	PRESTERA_CMD_PORT_ATTR_LINK_MODE = 12,
+	PRESTERA_CMD_PORT_ATTR_PHY_MODE = 12,
 	PRESTERA_CMD_PORT_ATTR_TYPE = 13,
-	PRESTERA_CMD_PORT_ATTR_FEC = 14,
-	PRESTERA_CMD_PORT_ATTR_AUTONEG = 15,
-	PRESTERA_CMD_PORT_ATTR_DUPLEX = 16,
 	PRESTERA_CMD_PORT_ATTR_STATS = 17,
-	PRESTERA_CMD_PORT_ATTR_MDIX = 18,
-	PRESTERA_CMD_PORT_ATTR_AUTONEG_RESTART = 19,
+	PRESTERA_CMD_PORT_ATTR_MAC_AUTONEG_RESTART = 18,
+	PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART = 19,
+	PRESTERA_CMD_PORT_ATTR_MAC_MODE = 22,
 };
 
 enum {
@@ -203,26 +198,35 @@ struct prestera_msg_switch_init_resp {
 	u8  switch_id;
 	u8  lag_max;
 	u8  lag_member_max;
-};
+	u32 size_tbl_router_nexthop;
+} __packed __aligned(4);
 
-struct prestera_msg_port_autoneg_param {
-	u64 link_mode;
-	u8  enable;
-	u8  fec;
-};
+struct prestera_msg_event_port_param {
+	union {
+		struct {
+			u8 oper;
+			u32 mode;
+			u32 speed;
+			u8 duplex;
+			u8 fc;
+			u8 fec;
+		} mac;
+		struct {
+			u8 mdix;
+			u64 lmode_bmap;
+			u8 fc;
+		} phy;
+	};
+} __packed __aligned(4);
 
 struct prestera_msg_port_cap_param {
 	u64 link_mode;
 	u8  type;
 	u8  fec;
+	u8  fc;
 	u8  transceiver;
 };
 
-struct prestera_msg_port_mdix_param {
-	u8 status;
-	u8 admin_mode;
-};
-
 struct prestera_msg_port_flood_param {
 	u8 type;
 	u8 enable;
@@ -242,10 +246,44 @@ union prestera_msg_port_param {
 	u8  duplex;
 	u8  fec;
 	u8  fc;
-	struct prestera_msg_port_mdix_param mdix;
-	struct prestera_msg_port_autoneg_param autoneg;
+
+	union {
+		struct {
+			/* TODO: merge it with "mode" */
+			u8 admin:1;
+			u8  fc;
+			u8 ap_enable;
+			union {
+				struct {
+					u32 mode;
+					u8  inband:1;
+					u32 speed;
+					u8  duplex;
+					u8  fec;
+					u8  fec_supp;
+				} reg_mode;
+				struct {
+					u32 mode;
+					u32 speed;
+					u8  fec;
+					u8  fec_supp;
+				} ap_modes[PRESTERA_AP_PORT_MAX];
+			};
+		} mac;
+		struct {
+			/* TODO: merge it with "mode" */
+			u8 admin:1;
+			u8 adv_enable;
+			u64 modes;
+			/* TODO: merge it with modes */
+			u32 mode;
+			u8 mdix;
+		} phy;
+	} link;
+
 	struct prestera_msg_port_cap_param cap;
 	struct prestera_msg_port_flood_param flood_ext;
+	struct prestera_msg_event_port_param link_evt;
 };
 
 struct prestera_msg_port_attr_req {
@@ -254,12 +292,14 @@ struct prestera_msg_port_attr_req {
 	u32 port;
 	u32 dev;
 	union prestera_msg_port_param param;
-};
+} __packed __aligned(4);
+
 
 struct prestera_msg_port_attr_resp {
 	struct prestera_msg_ret ret;
 	union prestera_msg_port_param param;
-};
+} __packed __aligned(4);
+
 
 struct prestera_msg_port_stats_resp {
 	struct prestera_msg_ret ret;
@@ -412,12 +452,6 @@ struct prestera_msg_rxtx_resp {
 	u32 map_addr;
 };
 
-struct prestera_msg_rxtx_port_req {
-	struct prestera_msg_cmd cmd;
-	u32 port;
-	u32 dev;
-};
-
 struct prestera_msg_lag_req {
 	struct prestera_msg_cmd cmd;
 	u32 port;
@@ -441,14 +475,10 @@ struct prestera_msg_event {
 	u16 id;
 };
 
-union prestera_msg_event_port_param {
-	u32 oper_state;
-};
-
 struct prestera_msg_event_port {
 	struct prestera_msg_event id;
 	u32 port_id;
-	union prestera_msg_event_port_param param;
+	struct prestera_msg_event_port_param param;
 };
 
 union prestera_msg_event_fdb_param {
@@ -466,6 +496,9 @@ struct prestera_msg_event_fdb {
 	union prestera_msg_event_fdb_param param;
 };
 
+static u8 prestera_hw_mdix_to_eth(u8 mode);
+static void prestera_hw_remote_fc_to_eth(u8 fc, bool *pause, bool *asym_pause);
+
 static int __prestera_cmd_ret(struct prestera_switch *sw,
 			      enum prestera_cmd_type_t type,
 			      struct prestera_msg_cmd *cmd, size_t clen,
@@ -477,7 +510,7 @@ static int __prestera_cmd_ret(struct prestera_switch *sw,
 
 	cmd->type = type;
 
-	err = dev->send_req(dev, cmd, clen, ret, rlen, waitms);
+	err = dev->send_req(dev, 0, cmd, clen, ret, rlen, waitms);
 	if (err)
 		return err;
 
@@ -517,14 +550,23 @@ static int prestera_cmd(struct prestera_switch *sw,
 
 static int prestera_fw_parse_port_evt(void *msg, struct prestera_event *evt)
 {
-	struct prestera_msg_event_port *hw_evt = msg;
+	struct prestera_msg_event_port *hw_evt;
 
-	if (evt->id != PRESTERA_PORT_EVENT_STATE_CHANGED)
-		return -EINVAL;
+	hw_evt = (struct prestera_msg_event_port *)msg;
 
-	evt->port_evt.data.oper_state = hw_evt->param.oper_state;
 	evt->port_evt.port_id = hw_evt->port_id;
 
+	if (evt->id == PRESTERA_PORT_EVENT_MAC_STATE_CHANGED) {
+		evt->port_evt.data.mac.oper = hw_evt->param.mac.oper;
+		evt->port_evt.data.mac.mode = hw_evt->param.mac.mode;
+		evt->port_evt.data.mac.speed = hw_evt->param.mac.speed;
+		evt->port_evt.data.mac.duplex = hw_evt->param.mac.duplex;
+		evt->port_evt.data.mac.fc = hw_evt->param.mac.fc;
+		evt->port_evt.data.mac.fec = hw_evt->param.mac.fec;
+	} else {
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -635,6 +677,34 @@ static void prestera_pkt_recv(struct prestera_device *dev)
 	eh.func(sw, &ev, eh.arg);
 }
 
+static u8 prestera_hw_mdix_to_eth(u8 mode)
+{
+	switch (mode) {
+	case PRESTERA_PORT_TP_MDI:
+		return ETH_TP_MDI;
+	case PRESTERA_PORT_TP_MDIX:
+		return ETH_TP_MDI_X;
+	case PRESTERA_PORT_TP_AUTO:
+		return ETH_TP_MDI_AUTO;
+	default:
+		return ETH_TP_MDI_INVALID;
+	}
+}
+
+static u8 prestera_hw_mdix_from_eth(u8 mode)
+{
+	switch (mode) {
+	case ETH_TP_MDI:
+		return PRESTERA_PORT_TP_MDI;
+	case ETH_TP_MDI_X:
+		return PRESTERA_PORT_TP_MDIX;
+	case ETH_TP_MDI_AUTO:
+		return PRESTERA_PORT_TP_AUTO;
+	default:
+		return PRESTERA_PORT_TP_NA;
+	}
+}
+
 int prestera_hw_port_info_get(const struct prestera_port *port,
 			      u32 *dev_id, u32 *hw_id, u16 *fp_id)
 {
@@ -713,15 +783,56 @@ int prestera_hw_switch_ageing_set(struct prestera_switch *sw, u32 ageing_ms)
 			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_port_state_set(const struct prestera_port *port,
-			       bool admin_state)
+int prestera_hw_port_mac_mode_get(const struct prestera_port *port,
+				  u32 *mode, u32 *speed, u8 *duplex, u8 *fec)
 {
+	struct prestera_msg_port_attr_resp resp;
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_ADMIN_STATE,
+		.attr = PRESTERA_CMD_PORT_ATTR_MAC_MODE,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	if (mode)
+		*mode = resp.param.link_evt.mac.mode;
+
+	if (speed)
+		*speed = resp.param.link_evt.mac.speed;
+
+	if (duplex)
+		*duplex = resp.param.link_evt.mac.duplex;
+
+	if (fec)
+		*fec = resp.param.link_evt.mac.fec;
+
+	return err;
+}
+
+int prestera_hw_port_mac_mode_set(const struct prestera_port *port,
+				  bool admin, u32 mode, u8 inband,
+				  u32 speed, u8 duplex, u8 fec)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_MAC_MODE,
 		.port = port->hw_id,
 		.dev = port->dev_id,
 		.param = {
-			.admin_state = admin_state,
+			.link = {
+				.mac = {
+					.admin = admin,
+					.reg_mode.mode = mode,
+					.reg_mode.inband = inband,
+					.reg_mode.speed = speed,
+					.reg_mode.duplex = duplex,
+					.reg_mode.fec = fec
+				}
+			}
 		}
 	};
 
@@ -729,6 +840,62 @@ int prestera_hw_port_state_set(const struct prestera_port *port,
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_port_phy_mode_get(const struct prestera_port *port,
+				  u8 *mdix, u64 *lmode_bmap,
+				  bool *fc_pause, bool *fc_asym)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_PHY_MODE,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	if (mdix)
+		*mdix = prestera_hw_mdix_to_eth(resp.param.link_evt.phy.mdix);
+
+	if (lmode_bmap)
+		*lmode_bmap = resp.param.link_evt.phy.lmode_bmap;
+
+	if (fc_pause && fc_asym)
+		prestera_hw_remote_fc_to_eth(resp.param.link_evt.phy.fc,
+					     fc_pause, fc_asym);
+
+	return err;
+}
+
+int prestera_hw_port_phy_mode_set(const struct prestera_port *port,
+				  bool admin, bool adv, u32 mode, u64 modes,
+				  u8 mdix)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_PHY_MODE,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.link = {
+				.phy = {
+					.admin = admin,
+					.adv_enable = adv ? 1 : 0,
+					.mode = mode,
+					.modes = modes,
+				}
+			}
+		}
+	};
+
+	req.param.link.phy.mdix = prestera_hw_mdix_from_eth(mdix);
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu)
 {
 	struct prestera_msg_port_attr_req req = {
@@ -798,44 +965,9 @@ int prestera_hw_port_cap_get(const struct prestera_port *port,
 	return err;
 }
 
-int prestera_hw_port_remote_cap_get(const struct prestera_port *port,
-				    u64 *link_mode_bitmap)
+static void prestera_hw_remote_fc_to_eth(u8 fc, bool *pause, bool *asym_pause)
 {
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*link_mode_bitmap = resp.param.cap.link_mode;
-
-	return 0;
-}
-
-int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
-				   bool *pause, bool *asym_pause)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_REMOTE_FC,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	switch (resp.param.fc) {
+	switch (fc) {
 	case PRESTERA_FC_SYMMETRIC:
 		*pause = true;
 		*asym_pause = false;
@@ -852,8 +984,6 @@ int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
 		*pause = false;
 		*asym_pause = false;
 	}
-
-	return 0;
 }
 
 int prestera_hw_acl_ruleset_create(struct prestera_switch *sw, u16 *ruleset_id)
@@ -1144,140 +1274,6 @@ int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
 	return 0;
 }
 
-int prestera_hw_port_fec_get(const struct prestera_port *port, u8 *fec)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_FEC,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*fec = resp.param.fec;
-
-	return 0;
-}
-
-int prestera_hw_port_fec_set(const struct prestera_port *port, u8 fec)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_FEC,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.param = {
-			.fec = fec,
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-static u8 prestera_hw_mdix_to_eth(u8 mode)
-{
-	switch (mode) {
-	case PRESTERA_PORT_TP_MDI:
-		return ETH_TP_MDI;
-	case PRESTERA_PORT_TP_MDIX:
-		return ETH_TP_MDI_X;
-	case PRESTERA_PORT_TP_AUTO:
-		return ETH_TP_MDI_AUTO;
-	default:
-		return ETH_TP_MDI_INVALID;
-	}
-}
-
-static u8 prestera_hw_mdix_from_eth(u8 mode)
-{
-	switch (mode) {
-	case ETH_TP_MDI:
-		return PRESTERA_PORT_TP_MDI;
-	case ETH_TP_MDI_X:
-		return PRESTERA_PORT_TP_MDIX;
-	case ETH_TP_MDI_AUTO:
-		return PRESTERA_PORT_TP_AUTO;
-	default:
-		return PRESTERA_PORT_TP_NA;
-	}
-}
-
-int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
-			      u8 *admin_mode)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_MDIX,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*status = prestera_hw_mdix_to_eth(resp.param.mdix.status);
-	*admin_mode = prestera_hw_mdix_to_eth(resp.param.mdix.admin_mode);
-
-	return 0;
-}
-
-int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_MDIX,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-
-	req.param.mdix.admin_mode = prestera_hw_mdix_from_eth(mode);
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-int prestera_hw_port_link_mode_set(const struct prestera_port *port, u32 mode)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_LINK_MODE,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.param = {
-			.link_mode = mode,
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-int prestera_hw_port_link_mode_get(const struct prestera_port *port, u32 *mode)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_LINK_MODE,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*mode = resp.param.link_mode;
-
-	return 0;
-}
-
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
 {
 	struct prestera_msg_port_attr_req req = {
@@ -1298,30 +1294,10 @@ int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
 	return 0;
 }
 
-int prestera_hw_port_autoneg_set(const struct prestera_port *port,
-				 bool autoneg, u64 link_modes, u8 fec)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_AUTONEG,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.param = {
-			.autoneg = {
-				.link_mode = link_modes,
-				.enable = autoneg,
-				.fec = fec,
-			}
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
 int prestera_hw_port_autoneg_restart(struct prestera_port *port)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_AUTONEG_RESTART,
+		.attr = PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART,
 		.port = port->hw_id,
 		.dev = port->dev_id,
 	};
@@ -1330,26 +1306,6 @@ int prestera_hw_port_autoneg_restart(struct prestera_port *port)
 			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_port_duplex_get(const struct prestera_port *port, u8 *duplex)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_DUPLEX,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*duplex = resp.param.duplex;
-
-	return 0;
-}
-
 int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *st)
 {
@@ -1774,17 +1730,6 @@ int prestera_hw_rxtx_init(struct prestera_switch *sw,
 	return 0;
 }
 
-int prestera_hw_rxtx_port_init(struct prestera_port *port)
-{
-	struct prestera_msg_rxtx_port_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_RXTX_PORT_INIT,
-			    &req.cmd, sizeof(req));
-}
-
 int prestera_hw_lag_member_add(struct prestera_port *port, u16 lag_id)
 {
 	struct prestera_msg_lag_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 546d5fd8240d..57a3c2e5b112 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -20,6 +20,23 @@ enum prestera_fdb_flush_mode {
 };
 
 enum {
+	PRESTERA_MAC_MODE_INTERNAL,
+	PRESTERA_MAC_MODE_SGMII,
+	PRESTERA_MAC_MODE_1000BASE_X,
+	PRESTERA_MAC_MODE_KR,
+	PRESTERA_MAC_MODE_KR2,
+	PRESTERA_MAC_MODE_KR4,
+	PRESTERA_MAC_MODE_CR,
+	PRESTERA_MAC_MODE_CR2,
+	PRESTERA_MAC_MODE_CR4,
+	PRESTERA_MAC_MODE_SR_LR,
+	PRESTERA_MAC_MODE_SR_LR2,
+	PRESTERA_MAC_MODE_SR_LR4,
+
+	PRESTERA_MAC_MODE_MAX
+};
+
+enum {
 	PRESTERA_LINK_MODE_10baseT_Half,
 	PRESTERA_LINK_MODE_10baseT_Full,
 	PRESTERA_LINK_MODE_100baseT_Half,
@@ -116,32 +133,29 @@ int prestera_hw_switch_mac_set(struct prestera_switch *sw, const char *mac);
 /* Port API */
 int prestera_hw_port_info_get(const struct prestera_port *port,
 			      u32 *dev_id, u32 *hw_id, u16 *fp_id);
-int prestera_hw_port_state_set(const struct prestera_port *port,
-			       bool admin_state);
+
+int prestera_hw_port_mac_mode_get(const struct prestera_port *port,
+				  u32 *mode, u32 *speed, u8 *duplex, u8 *fec);
+int prestera_hw_port_mac_mode_set(const struct prestera_port *port,
+				  bool admin, u32 mode, u8 inband,
+				  u32 speed, u8 duplex, u8 fec);
+int prestera_hw_port_phy_mode_get(const struct prestera_port *port,
+				  u8 *mdix, u64 *lmode_bmap,
+				  bool *fc_pause, bool *fc_asym);
+int prestera_hw_port_phy_mode_set(const struct prestera_port *port,
+				  bool admin, bool adv, u32 mode, u64 modes,
+				  u8 mdix);
+
 int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu);
 int prestera_hw_port_mtu_get(const struct prestera_port *port, u32 *mtu);
 int prestera_hw_port_mac_set(const struct prestera_port *port, const char *mac);
 int prestera_hw_port_mac_get(const struct prestera_port *port, char *mac);
 int prestera_hw_port_cap_get(const struct prestera_port *port,
 			     struct prestera_port_caps *caps);
-int prestera_hw_port_remote_cap_get(const struct prestera_port *port,
-				    u64 *link_mode_bitmap);
-int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
-				   bool *pause, bool *asym_pause);
 int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type);
-int prestera_hw_port_fec_get(const struct prestera_port *port, u8 *fec);
-int prestera_hw_port_fec_set(const struct prestera_port *port, u8 fec);
-int prestera_hw_port_autoneg_set(const struct prestera_port *port,
-				 bool autoneg, u64 link_modes, u8 fec);
 int prestera_hw_port_autoneg_restart(struct prestera_port *port);
-int prestera_hw_port_duplex_get(const struct prestera_port *port, u8 *duplex);
 int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *stats);
-int prestera_hw_port_link_mode_set(const struct prestera_port *port, u32 mode);
-int prestera_hw_port_link_mode_get(const struct prestera_port *port, u32 *mode);
-int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
-			      u8 *admin_mode);
-int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
 int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
@@ -206,7 +220,6 @@ void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
 /* RX/TX */
 int prestera_hw_rxtx_init(struct prestera_switch *sw,
 			  struct prestera_rxtx_params *params);
-int prestera_hw_rxtx_port_init(struct prestera_port *port);
 
 /* LAG API */
 int prestera_hw_lag_member_add(struct prestera_port *port, u16 lag_id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index b667f560b931..5924924e8f13 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -80,27 +80,76 @@ struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id)
 	return port;
 }
 
-static int prestera_port_open(struct net_device *dev)
+int prestera_port_cfg_mac_read(struct prestera_port *port,
+			       struct prestera_port_mac_config *cfg)
+{
+	*cfg = port->cfg_mac;
+	return 0;
+}
+
+int prestera_port_cfg_mac_write(struct prestera_port *port,
+				struct prestera_port_mac_config *cfg)
 {
-	struct prestera_port *port = netdev_priv(dev);
 	int err;
 
-	err = prestera_hw_port_state_set(port, true);
+	err = prestera_hw_port_mac_mode_set(port, cfg->admin,
+					    cfg->mode, cfg->inband, cfg->speed,
+					    cfg->duplex, cfg->fec);
 	if (err)
 		return err;
 
+	port->cfg_mac = *cfg;
+	return 0;
+}
+
+static int prestera_port_open(struct net_device *dev)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	struct prestera_port_mac_config cfg_mac;
+	int err = 0;
+
+	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
+		err = prestera_port_cfg_mac_read(port, &cfg_mac);
+		if (!err) {
+			cfg_mac.admin = true;
+			err = prestera_port_cfg_mac_write(port, &cfg_mac);
+		}
+	} else {
+		port->cfg_phy.admin = true;
+		err = prestera_hw_port_phy_mode_set(port, true, port->autoneg,
+						    port->cfg_phy.mode,
+						    port->adver_link_modes,
+						    port->cfg_phy.mdix);
+	}
+
 	netif_start_queue(dev);
 
-	return 0;
+	return err;
 }
 
 static int prestera_port_close(struct net_device *dev)
 {
 	struct prestera_port *port = netdev_priv(dev);
+	struct prestera_port_mac_config cfg_mac;
+	int err = 0;
 
 	netif_stop_queue(dev);
 
-	return prestera_hw_port_state_set(port, false);
+	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
+		err = prestera_port_cfg_mac_read(port, &cfg_mac);
+		if (!err) {
+			cfg_mac.admin = false;
+			prestera_port_cfg_mac_write(port, &cfg_mac);
+		}
+	} else {
+		port->cfg_phy.admin = false;
+		err = prestera_hw_port_phy_mode_set(port, false, port->autoneg,
+						    port->cfg_phy.mode,
+						    port->adver_link_modes,
+						    port->cfg_phy.mdix);
+	}
+
+	return err;
 }
 
 static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
@@ -228,46 +277,23 @@ static const struct net_device_ops prestera_netdev_ops = {
 	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
-int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
-			      u64 adver_link_modes, u8 adver_fec)
+int prestera_port_autoneg_set(struct prestera_port *port, u64 link_modes)
 {
-	bool refresh = false;
-	u64 link_modes;
 	int err;
-	u8 fec;
-
-	if (port->caps.type != PRESTERA_PORT_TYPE_TP)
-		return enable ? -EINVAL : 0;
-
-	if (!enable)
-		goto set_autoneg;
-
-	link_modes = port->caps.supp_link_modes & adver_link_modes;
-	fec = port->caps.supp_fec & adver_fec;
-
-	if (!link_modes && !fec)
-		return -EOPNOTSUPP;
-
-	if (link_modes && port->adver_link_modes != link_modes) {
-		port->adver_link_modes = link_modes;
-		refresh = true;
-	}
-
-	if (fec && port->adver_fec != fec) {
-		port->adver_fec = fec;
-		refresh = true;
-	}
 
-set_autoneg:
-	if (port->autoneg == enable && !refresh)
+	if (port->autoneg && port->adver_link_modes == link_modes)
 		return 0;
 
-	err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
-					   port->adver_fec);
+	err = prestera_hw_port_phy_mode_set(port, port->cfg_phy.admin,
+					    true, 0, link_modes,
+					    port->cfg_phy.mdix);
 	if (err)
 		return err;
 
-	port->autoneg = enable;
+	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
+	port->adver_link_modes = link_modes;
+	port->cfg_phy.mode = 0;
+	port->autoneg = true;
 
 	return 0;
 }
@@ -288,6 +314,7 @@ static void prestera_port_list_del(struct prestera_port *port)
 
 static int prestera_port_create(struct prestera_switch *sw, u32 id)
 {
+	struct prestera_port_mac_config cfg_mac;
 	struct prestera_port *port;
 	struct net_device *dev;
 	int err;
@@ -356,16 +383,43 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 		goto err_port_init;
 	}
 
-	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
-	prestera_port_autoneg_set(port, true, port->caps.supp_link_modes,
-				  port->caps.supp_fec);
+	port->adver_link_modes = port->caps.supp_link_modes;
+	port->adver_fec = 0;
+	port->autoneg = true;
+
+	/* initialize config mac */
+	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP) {
+		cfg_mac.admin = true;
+		cfg_mac.mode = PRESTERA_MAC_MODE_INTERNAL;
+	} else {
+		cfg_mac.admin = false;
+		cfg_mac.mode = PRESTERA_MAC_MODE_MAX;
+	}
+	cfg_mac.inband = false;
+	cfg_mac.speed = 0;
+	cfg_mac.duplex = DUPLEX_UNKNOWN;
+	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
 
-	err = prestera_hw_port_state_set(port, false);
+	err = prestera_port_cfg_mac_write(port, &cfg_mac);
 	if (err) {
-		dev_err(prestera_dev(sw), "Failed to set port(%u) down\n", id);
+		dev_err(prestera_dev(sw), "Failed to set port(%u) mac mode\n", id);
 		goto err_port_init;
 	}
 
+	/* initialize config phy (if this is inegral) */
+	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP) {
+		port->cfg_phy.mdix = ETH_TP_MDI_AUTO;
+		port->cfg_phy.admin = false;
+		err = prestera_hw_port_phy_mode_set(port,
+						    port->cfg_phy.admin,
+						    false, 0, 0,
+						    port->cfg_phy.mdix);
+		if (err) {
+			dev_err(prestera_dev(sw), "Failed to set port(%u) phy mode\n", id);
+			goto err_port_init;
+		}
+	}
+
 	err = prestera_rxtx_port_init(port);
 	if (err)
 		goto err_port_init;
@@ -446,8 +500,10 @@ static void prestera_port_handle_event(struct prestera_switch *sw,
 
 	caching_dw = &port->cached_hw_stats.caching_dw;
 
-	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED) {
-		if (evt->port_evt.data.oper_state) {
+	prestera_ethtool_port_state_changed(port, &evt->port_evt);
+
+	if (evt->id == PRESTERA_PORT_EVENT_MAC_STATE_CHANGED) {
+		if (port->state_mac.oper) {
 			netif_carrier_on(port->dev);
 			if (!delayed_work_pending(caching_dw))
 				queue_delayed_work(prestera_wq, caching_dw, 0);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index a250d394da38..5d4d410b07c8 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -14,10 +14,10 @@
 
 #define PRESTERA_MSG_MAX_SIZE 1500
 
-#define PRESTERA_SUPP_FW_MAJ_VER	3
+#define PRESTERA_SUPP_FW_MAJ_VER	4
 #define PRESTERA_SUPP_FW_MIN_VER	0
 
-#define PRESTERA_PREV_FW_MAJ_VER	2
+#define PRESTERA_PREV_FW_MAJ_VER	4
 #define PRESTERA_PREV_FW_MIN_VER	0
 
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
@@ -102,23 +102,30 @@ struct prestera_fw_evtq_regs {
 	u32 len;
 };
 
+#define PRESTERA_CMD_QNUM_MAX	4
+
+struct prestera_fw_cmdq_regs {
+	u32 req_ctl;
+	u32 req_len;
+	u32 rcv_ctl;
+	u32 rcv_len;
+	u32 offs;
+	u32 len;
+};
+
 struct prestera_fw_regs {
 	u32 fw_ready;
-	u32 pad;
 	u32 cmd_offs;
 	u32 cmd_len;
+	u32 cmd_qnum;
 	u32 evt_offs;
 	u32 evt_qnum;
 
-	u32 cmd_req_ctl;
-	u32 cmd_req_len;
-	u32 cmd_rcv_ctl;
-	u32 cmd_rcv_len;
-
 	u32 fw_status;
 	u32 rx_status;
 
-	struct prestera_fw_evtq_regs evtq_list[PRESTERA_EVT_QNUM_MAX];
+	struct prestera_fw_cmdq_regs cmdq_list[PRESTERA_EVT_QNUM_MAX];
+	struct prestera_fw_evtq_regs evtq_list[PRESTERA_CMD_QNUM_MAX];
 };
 
 #define PRESTERA_FW_REG_OFFSET(f)	offsetof(struct prestera_fw_regs, f)
@@ -130,14 +137,22 @@ struct prestera_fw_regs {
 
 #define PRESTERA_CMD_BUF_OFFS_REG	PRESTERA_FW_REG_OFFSET(cmd_offs)
 #define PRESTERA_CMD_BUF_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_len)
+#define PRESTERA_CMD_QNUM_REG		PRESTERA_FW_REG_OFFSET(cmd_qnum)
 #define PRESTERA_EVT_BUF_OFFS_REG	PRESTERA_FW_REG_OFFSET(evt_offs)
 #define PRESTERA_EVT_QNUM_REG		PRESTERA_FW_REG_OFFSET(evt_qnum)
 
-#define PRESTERA_CMD_REQ_CTL_REG	PRESTERA_FW_REG_OFFSET(cmd_req_ctl)
-#define PRESTERA_CMD_REQ_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_req_len)
+#define PRESTERA_CMDQ_REG_OFFSET(q, f)			\
+	(PRESTERA_FW_REG_OFFSET(cmdq_list) +		\
+	 (q) * sizeof(struct prestera_fw_cmdq_regs) +	\
+	 offsetof(struct prestera_fw_cmdq_regs, f))
+
+#define PRESTERA_CMDQ_REQ_CTL_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, req_ctl)
+#define PRESTERA_CMDQ_REQ_LEN_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, req_len)
+#define PRESTERA_CMDQ_RCV_CTL_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, rcv_ctl)
+#define PRESTERA_CMDQ_RCV_LEN_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, rcv_len)
+#define PRESTERA_CMDQ_OFFS_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, offs)
+#define PRESTERA_CMDQ_LEN_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, len)
 
-#define PRESTERA_CMD_RCV_CTL_REG	PRESTERA_FW_REG_OFFSET(cmd_rcv_ctl)
-#define PRESTERA_CMD_RCV_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_rcv_len)
 #define PRESTERA_FW_STATUS_REG		PRESTERA_FW_REG_OFFSET(fw_status)
 #define PRESTERA_RX_STATUS_REG		PRESTERA_FW_REG_OFFSET(rx_status)
 
@@ -174,6 +189,13 @@ struct prestera_fw_evtq {
 	size_t len;
 };
 
+struct prestera_fw_cmdq {
+	/* serialize access to dev->send_req */
+	struct mutex cmd_mtx;
+	u8 __iomem *addr;
+	size_t len;
+};
+
 struct prestera_fw {
 	struct prestera_fw_rev rev_supp;
 	const struct firmware *bin;
@@ -183,9 +205,10 @@ struct prestera_fw {
 	u8 __iomem *ldr_ring_buf;
 	u32 ldr_buf_len;
 	u32 ldr_wr_idx;
-	struct mutex cmd_mtx; /* serialize access to dev->send_req */
 	size_t cmd_mbox_len;
 	u8 __iomem *cmd_mbox;
+	struct prestera_fw_cmdq cmd_queue[PRESTERA_CMD_QNUM_MAX];
+	u8 cmd_qnum;
 	struct prestera_fw_evtq evt_queue[PRESTERA_EVT_QNUM_MAX];
 	u8 evt_qnum;
 	struct work_struct evt_work;
@@ -324,7 +347,27 @@ static int prestera_fw_wait_reg32(struct prestera_fw *fw, u32 reg, u32 cmp,
 				  1 * USEC_PER_MSEC, waitms * USEC_PER_MSEC);
 }
 
-static int prestera_fw_cmd_send(struct prestera_fw *fw,
+static void prestera_fw_cmdq_lock(struct prestera_fw *fw, u8 qid)
+{
+	mutex_lock(&fw->cmd_queue[qid].cmd_mtx);
+}
+
+static void prestera_fw_cmdq_unlock(struct prestera_fw *fw, u8 qid)
+{
+	mutex_unlock(&fw->cmd_queue[qid].cmd_mtx);
+}
+
+static u32 prestera_fw_cmdq_len(struct prestera_fw *fw, u8 qid)
+{
+	return fw->cmd_queue[qid].len;
+}
+
+static u8 __iomem *prestera_fw_cmdq_buf(struct prestera_fw *fw, u8 qid)
+{
+	return fw->cmd_queue[qid].addr;
+}
+
+static int prestera_fw_cmd_send(struct prestera_fw *fw, int qid,
 				void *in_msg, size_t in_size,
 				void *out_msg, size_t out_size,
 				unsigned int waitms)
@@ -335,30 +378,32 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw,
 	if (!waitms)
 		waitms = PRESTERA_FW_CMD_DEFAULT_WAIT_MS;
 
-	if (ALIGN(in_size, 4) > fw->cmd_mbox_len)
+	if (ALIGN(in_size, 4) > prestera_fw_cmdq_len(fw, qid))
 		return -EMSGSIZE;
 
 	/* wait for finish previous reply from FW */
-	err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG, 0, 30);
+	err = prestera_fw_wait_reg32(fw, PRESTERA_CMDQ_RCV_CTL_REG(qid), 0, 30);
 	if (err) {
 		dev_err(fw->dev.dev, "finish reply from FW is timed out\n");
 		return err;
 	}
 
-	prestera_fw_write(fw, PRESTERA_CMD_REQ_LEN_REG, in_size);
-	memcpy_toio(fw->cmd_mbox, in_msg, in_size);
+	prestera_fw_write(fw, PRESTERA_CMDQ_REQ_LEN_REG(qid), in_size);
+
+	memcpy_toio(prestera_fw_cmdq_buf(fw, qid), in_msg, in_size);
 
-	prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REQ_SENT);
+	prestera_fw_write(fw, PRESTERA_CMDQ_REQ_CTL_REG(qid),
+			  PRESTERA_CMD_F_REQ_SENT);
 
 	/* wait for reply from FW */
-	err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG,
+	err = prestera_fw_wait_reg32(fw, PRESTERA_CMDQ_RCV_CTL_REG(qid),
 				     PRESTERA_CMD_F_REPL_SENT, waitms);
 	if (err) {
 		dev_err(fw->dev.dev, "reply from FW is timed out\n");
 		goto cmd_exit;
 	}
 
-	ret_size = prestera_fw_read(fw, PRESTERA_CMD_RCV_LEN_REG);
+	ret_size = prestera_fw_read(fw, PRESTERA_CMDQ_RCV_LEN_REG(qid));
 	if (ret_size > out_size) {
 		dev_err(fw->dev.dev, "ret_size (%u) > out_len(%zu)\n",
 			ret_size, out_size);
@@ -366,14 +411,15 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw,
 		goto cmd_exit;
 	}
 
-	memcpy_fromio(out_msg, fw->cmd_mbox + in_size, ret_size);
+	memcpy_fromio(out_msg, prestera_fw_cmdq_buf(fw, qid) + in_size, ret_size);
 
 cmd_exit:
-	prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REPL_RCVD);
+	prestera_fw_write(fw, PRESTERA_CMDQ_REQ_CTL_REG(qid),
+			  PRESTERA_CMD_F_REPL_RCVD);
 	return err;
 }
 
-static int prestera_fw_send_req(struct prestera_device *dev,
+static int prestera_fw_send_req(struct prestera_device *dev, int qid,
 				void *in_msg, size_t in_size, void *out_msg,
 				size_t out_size, unsigned int waitms)
 {
@@ -382,9 +428,10 @@ static int prestera_fw_send_req(struct prestera_device *dev,
 
 	fw = container_of(dev, struct prestera_fw, dev);
 
-	mutex_lock(&fw->cmd_mtx);
-	ret = prestera_fw_cmd_send(fw, in_msg, in_size, out_msg, out_size, waitms);
-	mutex_unlock(&fw->cmd_mtx);
+	prestera_fw_cmdq_lock(fw, qid);
+	ret = prestera_fw_cmd_send(fw, qid, in_msg, in_size, out_msg, out_size,
+				   waitms);
+	prestera_fw_cmdq_unlock(fw, qid);
 
 	return ret;
 }
@@ -414,7 +461,16 @@ static int prestera_fw_init(struct prestera_fw *fw)
 
 	fw->cmd_mbox = base + prestera_fw_read(fw, PRESTERA_CMD_BUF_OFFS_REG);
 	fw->cmd_mbox_len = prestera_fw_read(fw, PRESTERA_CMD_BUF_LEN_REG);
-	mutex_init(&fw->cmd_mtx);
+	fw->cmd_qnum = prestera_fw_read(fw, PRESTERA_CMD_QNUM_REG);
+
+	for (qid = 0; qid < fw->cmd_qnum; qid++) {
+		u32 offs = prestera_fw_read(fw, PRESTERA_CMDQ_OFFS_REG(qid));
+		struct prestera_fw_cmdq *cmdq = &fw->cmd_queue[qid];
+
+		cmdq->len = prestera_fw_read(fw, PRESTERA_CMDQ_LEN_REG(qid));
+		cmdq->addr = fw->cmd_mbox + offs;
+		mutex_init(&cmdq->cmd_mtx);
+	}
 
 	fw->evt_buf = base + prestera_fw_read(fw, PRESTERA_EVT_BUF_OFFS_REG);
 	fw->evt_qnum = prestera_fw_read(fw, PRESTERA_EVT_QNUM_REG);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index 73d2eba5262f..e452cdeaf703 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -794,14 +794,7 @@ void prestera_rxtx_switch_fini(struct prestera_switch *sw)
 
 int prestera_rxtx_port_init(struct prestera_port *port)
 {
-	int err;
-
-	err = prestera_hw_rxtx_port_init(port);
-	if (err)
-		return err;
-
 	port->dev->needed_headroom = PRESTERA_DSA_HLEN;
-
 	return 0;
 }
 
-- 
2.7.4

