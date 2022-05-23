Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C225319DA
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiEWTJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiEWTHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:07:23 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20105.outbound.protection.outlook.com [40.107.2.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11B59CF0F;
        Mon, 23 May 2022 11:45:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYwFL8+KoXgs/V06iuJSyVnRIi73fMy6aslNUjgIFPKtkV4KeKg7h81JVZZWugscKz8ddnPCvJ1lBkdKKu81wbC1aHlpOzSstx4KZn9Ni2zq0wZso+ZwpPXY7Lsa5VLTOtnVEmvoHKvO4wuv/2C071OUBQXfE1XqlpLjDKC+f6q7RAt+CK8Xru64n4VObtMWapPTCQtmxcB/TBjeKnzQDkJEfW+3N8YnOUWvHRUPU9ADyzDygtKo5rnisqW+W0hjchVfJLM3/Fwctr9tv6zm7guzU34f46kzXEWXKzsuxxoBS5lCMCCIPHQEfh771paF5noFvrimj8XyGy5A6rFV8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tg9Nl1imXfGidgM1Rh+X6JtWKd/6sCW9a8oY/k+MOJ0=;
 b=QPxYnebYJRK/Z8yfPPZ+tezDGvl3ZfLOttEh+usmiKZ55DI81in1MkWYcN7WvI21758YNgyZRFXw7v3U8CeeutUP/d4E1SP0sqQ+1FntcKJw9RR/vnOp4updOFXf2jh/AvdMREeGR35vyuVkTinYUMR+jiIOODRuL4fgkbU4iGk1tWkoc3+3yFsLRNjhxCuaZXbhGvrdF3/vqnHqKW1zb24mXGpxwFpT0evZCXDo86nlLpSqLIp7IhVOliR8ZhtJSVhvUffRKhf0cMDC+NLDB5QWjZEPEBpiG5ARbeadXL3EHEL1Bi4lcO9BhLXRkxAxX03JY//8wz/DIXFBd/1VCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tg9Nl1imXfGidgM1Rh+X6JtWKd/6sCW9a8oY/k+MOJ0=;
 b=qS8PRPjW9jq1R641UyHFr1kgaTIDA9yIrwP3+7LCQoY5MYIxNL4yyVx6J9o9mVzQBKSl7KBPXycItc7TqQ5bPEaVRfaM80XswTNvM2677gtFGi9X2XS1ZjRf+3xfgb8yVDo6g+szuI2qBdSq4pyNf2y5rG0v38gmDPPzLFxncqk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DB6P190MB0535.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.20; Mon, 23 May 2022 18:45:03 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::b51c:d334:b74c:1677]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::b51c:d334:b74c:1677%7]) with mapi id 15.20.5273.017; Mon, 23 May 2022
 18:45:03 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: marvell: prestera: rework bridge flags setting
Date:   Mon, 23 May 2022 21:44:36 +0300
Message-Id: <20220523184439.5567-2-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523184439.5567-1-oleksandr.mazur@plvision.eu>
References: <20220523184439.5567-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::20)
 To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 709d56da-416c-4e54-59ae-08da3cec58bc
X-MS-TrafficTypeDiagnostic: DB6P190MB0535:EE_
X-Microsoft-Antispam-PRVS: <DB6P190MB0535C38D4577FDFA4D288FC9E4D49@DB6P190MB0535.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zLDi1fNb8vECc47rhD9FJI8voL6ooUFZnk7RRmooQkcyWdpYkb1OT+3izB8mzd1q+L1Y3b5lK/pcF33jhZ/vaUu+D6Q+1Jr9awglmN3lpBZY8E6mpfPVlko2dprSwCWQROlDwq/+0xRAYJpH6g9PS4xYDWh8+fH1S9y44v9Ydw2Gc06Q49aBMwLPNyLWp0YDl1XVXDUEak6iJb4RXjySsfjbarwbhtymR/hnO1FIcEIFAV5bdTPMZg15IZ6BQrg9OOxoqTZp2+etv/xPShDmxX56HO4zNYrYpJJ4VRUVdNFfbuEH/+bL98ptn6BEW1swjG9Xkt2fPHCMtKMVVKJDJ3AOiBLYHp7YBX3qspAXd8RwDjf/wtsiq3ML5t+9NXdDh8nc85lOQXLz6mDvla7X2VcmeJxwiRblzz+ubdayfhAJkzIvmlGz+WkwGYX7tLgNMBOd74vqzdZdtpAYonl4MUTwa0gGmsAhv/YaEobYdxTv6oEZGDT65bkTwlgLgc/eSEJIRYyoAqwKPGE2qQza+u6WJD5+Qh8I6pZpuzBZI2uSg19oUrUqbOpQ7MIqaAw202TPGiTY16KIKe2BkLCQTRsGA1UlK1Ceb13rfamaygOPEX+FFEQSZ0fvwNOeKYYRiDTub8qqMQTyAEei2poJzcXJGKDeFsq8Sm1Sowj0gbK8/xQrPDbcDbqwKaCxq17erIb5L6I3XFupeHsI72uaBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(52116002)(6506007)(6512007)(44832011)(36756003)(5660300002)(8936002)(38100700002)(38350700002)(6666004)(2906002)(4326008)(110136005)(508600001)(66946007)(86362001)(66476007)(8676002)(66556008)(2616005)(1076003)(186003)(83380400001)(6486002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DIVU8dH96njg4gekOlncdVgVjiwtQFafHKm9Uu6a3yAH8pU7pNPeKyylfG4Y?=
 =?us-ascii?Q?kBhON2I6i/cul8k4optW4n0ORAMpPQF0mlLXkcmV6msZQXtDKcqiniPgD0GE?=
 =?us-ascii?Q?bbP/3TnYxB0KKLFpb2BXVbs003RUFpjvtfmHoYZrz98rpOK9qnS/mfTol+H6?=
 =?us-ascii?Q?PhGdgHSk6PNh85vYbKvqoFEvHLJYm4cd/UuZtjzhtzocmhJNGQIJ2lgUro1j?=
 =?us-ascii?Q?4fdDFmPxWzdqDafbomXTXF86J2sEY5gEZel6MENVpl/dxDYMmbRHBAynk2BE?=
 =?us-ascii?Q?Zhjc4PIZGFAb4oZowAf+K/B6b4V06N2oOYWYDdKhf+nD3wCzOTSR2b+Qzp0K?=
 =?us-ascii?Q?m/5nXKHIRN1dlzkyKIsDHC3z2gGHLD3hTgFBLXf7tu7MDZiAaJFfygZIUmi7?=
 =?us-ascii?Q?8Wu+FlHY+ClcbB9342cT1FmHn6Ue4M036IrQEHpBdbztAXNjdZTZjAv7lw9P?=
 =?us-ascii?Q?ZEEYiraD5wKeQecqePxuO4u28p22rxqffObejOEdRzmu1NvuRRKVjONsuq72?=
 =?us-ascii?Q?iMzM585H243szFZn1zesq3uSPbnAO0kGTMSPlR2rH9/XxPJhPSPB/MuXe2dQ?=
 =?us-ascii?Q?o/tIvBXVMT/m9Sie5l8bXoR7nz0R1r6LsWAHJYc+Ye5v8EiHd0PB8aIKRCWT?=
 =?us-ascii?Q?y9muOCN65ZNf2pPg1aM2TLla4RGc4G9ZLHBb/OMqza1+qbCDq0Sv/SQX5Piw?=
 =?us-ascii?Q?q3OvZOqUAl0Y2mY7O3JAbfUDgDTjFxB38LSBq5OmONOMLYJsJEVqwsDZLSG4?=
 =?us-ascii?Q?kidfZc5elkn4qpefCvDua9+J5zfmDGbGoS8jUeKJO1y4ob1sKmq3zdB2xT0y?=
 =?us-ascii?Q?QwKEfboenSeZqu1M5kgNNlRQqicGOCpwG8q+eJwzY10gXQph991zhE0TUNSh?=
 =?us-ascii?Q?lxtosbkv97PE4/bTOppNrWOHa5Vd6AKlXngwz0NTjxHN/evKu9wMQr3pm+qA?=
 =?us-ascii?Q?y+s6gIpmquE3xQaL1tHDu+scOUTnIUn5t7FAdIroBy5s91QvRlB8DHi6aNKr?=
 =?us-ascii?Q?yNWAU4DwUohmBYAFZIboU5YYZVooirIEbqzCUgw9PbKWBG0jPUvAHhwoxXer?=
 =?us-ascii?Q?f6zGr8pndUD0Mj2JFyozqqrIvU8fsV6hlCQYtxZ/PByMeix6SnC8gpoQx1Gq?=
 =?us-ascii?Q?aHgdwYzjUns2iMPx4XMig17ZApXSsaBydUC0UkM6c+lpNkTRcOgo88TCUdAN?=
 =?us-ascii?Q?6yYXtOO4hdFXXOQQ4RD/m1z99cyxp37HTfmpJFuHjXk9jyWnryZF8A6i5ibR?=
 =?us-ascii?Q?9NcWdm+6+2OCTWWgI9jZRXOUNOYHQPu+nlr90PvqfCW0rWXs9IGDzQuB7mfk?=
 =?us-ascii?Q?/BgIcTQIuyLnXGWsIqDQ0JQk7V6aS95wzQkfq0g3dmn/vVA++b6LSRCJDMmL?=
 =?us-ascii?Q?ksQVrqR1yoacU3jacP3SWfXzR/SqPNisn6HvnPM9ZF9nNWRKT1QtEYyWg3bI?=
 =?us-ascii?Q?V1snHCA9I8dFTJ4mFVwxa3FBu6uYwP6ITd7XwFBwz9U3j6dEwnbdGdhvJEnk?=
 =?us-ascii?Q?wUWCw6dOfgrzOwJ4jYpzebJw+E7OqaV0tLL7LmaJjDLcDviDbHYsm90dezdE?=
 =?us-ascii?Q?3z0Hr4Y8xYS1RcbuYagaZ01LZsH0yB1o4ozXMP+ur6J4QQ2AP0xdhFEduX+K?=
 =?us-ascii?Q?01PoYTuIkLA8ff3JN3Bl7jeaqmZ/QR25PgQRC1tm80LAwFqw+zgsHkbdZ98o?=
 =?us-ascii?Q?kDFgsnU0rJIteDGVh618FQ+cb0cy+9rUQoEc11g9UkaWRtZpRqkjqBVGnH4i?=
 =?us-ascii?Q?PqHMeWAgCGkv2hKztLLnNlSb93F0cSY=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 709d56da-416c-4e54-59ae-08da3cec58bc
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 18:45:03.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKbL/DByQzS8DueGh+Io9ks2iPHTfw3/L2nShWWjgclkkqPvsnN15SPM3/ck4OeiX4hNdB8uRTLZnhTvGtdr4pOUhbEtl91ety6YEQTPgdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0535
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate flags to make it possible to alter them separately;
Move bridge flags setting logic from HW API level to prestera_main
  where it belongs;
Move bridge flags parsing (and setting using prestera API) to
  prestera_switchdev.c - module responsible for bridge operations
  handling;

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  4 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 54 +------------
 .../ethernet/marvell/prestera/prestera_hw.h   |  4 +-
 .../ethernet/marvell/prestera/prestera_main.c | 15 ++++
 .../marvell/prestera/prestera_switchdev.c     | 79 +++++++++++--------
 5 files changed, 67 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 6f754ae2a584..837e7a3b361b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -330,6 +330,10 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
 
+int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
+int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
+int prestera_port_mc_flood_set(struct prestera_port *port, bool flood);
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
 bool prestera_netdev_check(const struct net_device *dev);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 79fd3cac539d..b00e69fabc6b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -1531,7 +1531,7 @@ int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_uc_flood_set(const struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
@@ -1549,7 +1549,7 @@ static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
@@ -1567,56 +1567,6 @@ static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_flood_set_v2(struct prestera_port *port, bool flood)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
-		.port = __cpu_to_le32(port->hw_id),
-		.dev = __cpu_to_le32(port->dev_id),
-		.param = {
-			.flood = flood,
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
-			       unsigned long val)
-{
-	int err;
-
-	if (port->sw->dev->fw_rev.maj <= 2) {
-		if (!(mask & BR_FLOOD))
-			return 0;
-
-		return prestera_hw_port_flood_set_v2(port, val & BR_FLOOD);
-	}
-
-	if (mask & BR_FLOOD) {
-		err = prestera_hw_port_uc_flood_set(port, val & BR_FLOOD);
-		if (err)
-			goto err_uc_flood;
-	}
-
-	if (mask & BR_MCAST_FLOOD) {
-		err = prestera_hw_port_mc_flood_set(port, val & BR_MCAST_FLOOD);
-		if (err)
-			goto err_mc_flood;
-	}
-
-	return 0;
-
-err_mc_flood:
-	prestera_hw_port_mc_flood_set(port, 0);
-err_uc_flood:
-	if (mask & BR_FLOOD)
-		prestera_hw_port_uc_flood_set(port, 0);
-
-	return err;
-}
-
 int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid)
 {
 	struct prestera_msg_vlan_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 579d9ba23ffc..3eb99eb8c2da 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -178,8 +178,8 @@ int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *stats);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
-int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
-			       unsigned long val);
+int prestera_hw_port_uc_flood_set(const struct prestera_port *port, bool flood);
+int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood);
 int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 				     enum prestera_accept_frm_type type);
 /* Vlan API */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3952fdcc9240..0e8eecbe13e1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -35,6 +35,21 @@ void prestera_queue_work(struct work_struct *work)
 	queue_work(prestera_owq, work);
 }
 
+int prestera_port_learning_set(struct prestera_port *port, bool learn)
+{
+	return prestera_hw_port_learning_set(port, learn);
+}
+
+int prestera_port_uc_flood_set(struct prestera_port *port, bool flood)
+{
+	return prestera_hw_port_uc_flood_set(port, flood);
+}
+
+int prestera_port_mc_flood_set(struct prestera_port *port, bool flood)
+{
+	return prestera_hw_port_mc_flood_set(port, flood);
+}
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
 {
 	enum prestera_accept_frm_type frm_type;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index b4599fe4ca8d..7002c35526d2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -74,6 +74,39 @@ static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
 static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
 				     u8 state);
 
+static void
+prestera_br_port_flags_reset(struct prestera_bridge_port *br_port,
+			     struct prestera_port *port)
+{
+	prestera_port_uc_flood_set(port, false);
+	prestera_port_mc_flood_set(port, false);
+	prestera_port_learning_set(port, false);
+}
+
+static int prestera_br_port_flags_set(struct prestera_bridge_port *br_port,
+				      struct prestera_port *port)
+{
+	int err;
+
+	err = prestera_port_uc_flood_set(port, br_port->flags & BR_FLOOD);
+	if (err)
+		goto err_out;
+
+	err = prestera_port_mc_flood_set(port, br_port->flags & BR_MCAST_FLOOD);
+	if (err)
+		goto err_out;
+
+	err = prestera_port_learning_set(port, br_port->flags & BR_LEARNING);
+	if (err)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	prestera_br_port_flags_reset(br_port, port);
+	return err;
+}
+
 static struct prestera_bridge_vlan *
 prestera_bridge_vlan_create(struct prestera_bridge_port *br_port, u16 vid)
 {
@@ -461,19 +494,13 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 	if (err)
 		return err;
 
-	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
-					 br_port->flags);
-	if (err)
-		goto err_port_flood_set;
-
-	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	err = prestera_br_port_flags_set(br_port, port);
 	if (err)
-		goto err_port_learning_set;
+		goto err_flags2port_set;
 
 	return 0;
 
-err_port_learning_set:
-err_port_flood_set:
+err_flags2port_set:
 	prestera_hw_bridge_port_delete(port, bridge->bridge_id);
 
 	return err;
@@ -592,8 +619,7 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 
-	prestera_hw_port_learning_set(port, false);
-	prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD, 0);
+	prestera_br_port_flags_reset(br_port, port);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
 }
@@ -603,26 +629,14 @@ static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 					   struct switchdev_brport_flags flags)
 {
 	struct prestera_bridge_port *br_port;
-	int err;
 
 	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
 	if (!br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, flags.mask, flags.val);
-	if (err)
-		return err;
-
-	if (flags.mask & BR_LEARNING) {
-		err = prestera_hw_port_learning_set(port,
-						    flags.val & BR_LEARNING);
-		if (err)
-			return err;
-	}
-
-	memcpy(&br_port->flags, &flags.val, sizeof(flags.val));
-
-	return 0;
+	br_port->flags &= ~flags.mask;
+	br_port->flags |= flags.val & flags.mask;
+	return prestera_br_port_flags_set(br_port, port);
 }
 
 static int prestera_port_attr_br_ageing_set(struct prestera_port *port,
@@ -918,14 +932,9 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 	if (port_vlan->br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
-					 br_port->flags);
-	if (err)
-		return err;
-
-	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	err = prestera_br_port_flags_set(br_port, port);
 	if (err)
-		goto err_port_learning_set;
+		goto err_flags2port_set;
 
 	err = prestera_port_vid_stp_set(port, vid, br_port->stp_state);
 	if (err)
@@ -950,8 +959,8 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 err_bridge_vlan_get:
 	prestera_port_vid_stp_set(port, vid, BR_STATE_FORWARDING);
 err_port_vid_stp_set:
-	prestera_hw_port_learning_set(port, false);
-err_port_learning_set:
+	prestera_br_port_flags_reset(br_port, port);
+err_flags2port_set:
 	return err;
 }
 
-- 
2.17.1

