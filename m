Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648744B5E60
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiBNXm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:42:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiBNXm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:42:27 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30069.outbound.protection.outlook.com [40.107.3.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6328E
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:42:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWY+MykMp44nYSqLr4RnVM3h//lJHiQ3FcZKklPCLkQiV2Cto704lyc+WHCQTP1m2ATJed2xvZqgERY8nee8lcKdSDIcdscs1lhWRTk3TwmYgXSDgRp+yscknwKo5zxjwYXjhGQosCT3WrUIVGjxZWhSOUHg/BzIFcfY262YmwofaJqwU5NDFoYaF7j9oEwzovep5EN8b29ShH4rprQSZCjxlypxX4vpmObnw/42nknh3sLxP5ZPuGDvbDdxFMOKPQGWrkXBhT7/H/5hHHGMP1XvuOl6m29FtG5N70oohD3WDC4G1zv0CC2m8LigAN95gzp3WqDZfni7o2ShWB5Jlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTMlYPb8SzAinR7lkF5ZsoSUgrSOfZ2YwicfUz3lBGY=;
 b=LfWNmfF3ZuCFH/PU9nAQS0/oV28qOSo44dGFNpOsZsiwpNnBC3p9XGSLJAMkTM8g4jPaXA+AHhPpBEpuV3Lrw838R4mtO+ih1U/MwjIxKHXc9R6GpwZHaWqWHBjudGRmZYO66Vl6zqzgZCiimifBErIUbKWlTETL/4pa8RcHDiAFGqm/c4PbcLCrlXu0V7TYaxRxDQzuFlLuinABxRjwBoigZg8IT/blPM7h/3Zceb/F65XQm7LVRe0S1tf4OA7AOCmKL3+1qAFYhg+Xkux5SsHHJMSBY0NofejMmEGiaaRcp7yu2OWe4PEMA/xwRmcUc5eeyZaQsFRoKFReT8lNsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTMlYPb8SzAinR7lkF5ZsoSUgrSOfZ2YwicfUz3lBGY=;
 b=B4xzlzf3eOMqDEdOA3j2ceV87LkNsW17zbfgHiGEPAHJ8EGzyueNIwIm9dm64A2UU5UjMK+7X1Vs1Oj85/pXEsHE2SdM3y2SYuZLTBf6mGJxWcl8O3BZ9I1zmF57u6yLExeo+z/TTT/tNI51B/wTBHbibzIQk3WQLMeZv/3eVQE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3895.eurprd04.prod.outlook.com (2603:10a6:209:1a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Mon, 14 Feb
 2022 23:42:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:42:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: mscc: ocelot: fix use-after-free in ocelot_vlan_del()
Date:   Tue, 15 Feb 2022 01:42:00 +0200
Message-Id: <20220214234200.1594787-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0070.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af1fd107-6104-460d-787b-08d9f0139ee9
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3895:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3895863D6D3FF34812C011F7E0339@AM6PR0402MB3895.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWHGA5IdkjHtrWsB7DHpg5YoR+cpz6IWXx21WxwQHrT18iPgSDGRu4dp0VJP/BYkWKyOeWWKGTAxsNc2QV3wNlbGq8Bb0wrmdlDwSsrfDRyaJDPeW2Tt1p4PV7ZDWcJmhcKyG7PIUsAfFauQMWCwzFinIqJShW3tOtox/Y35EPpSDoEF579qTB9TA3w8rFboudVtW9Ly0FIuoCsKhfQzk7rntkfgt4gj25afQZ01L3jVvw7a+kU5bkUcU9yymkpwNyu+l8RF8yHpqojuSnvxf94AmI8DJC5UuV0ZRTLDHVR26yFHOSs6XC4TLfcIN1VoseApg8YfQO1qPowLC5O313sJiL5q+9br/NCH4RJUNyshCIh/6O8Cev0JLWHQQxRiHk108veBYHnAO3s/3NQn1Hts5rz1XtREWBlNwqeHyqyRzzFdvIHpRoV5YpiUPi42lYK3BqowwAxGDCKX2OvcOM8xgqLE8b2F+snO66y1l2QWadnk30+2M11b7ARgHf/cpyDCjOCgueOtO2PjAG+LCFISoPGxV3JiIEFzuyzVEf5ZTeEVTBZBlJLa3XZJmlc0rLox7DL1ZPGn1f6pNviVvGLSSQCE57rc1I15F7Bh4RDJoSgsaxqovwkRdpfZ7ngKvKYOqodh2/UX9KBHOKTGSNE8jUybFzKiRqCEW8MgLJ4fW3XQZ1+JcCGG7q/haSWx3r2a5dSPx0m8NtqExE0x3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(66556008)(66476007)(66946007)(38100700002)(6512007)(5660300002)(6666004)(8676002)(8936002)(6506007)(52116002)(4326008)(83380400001)(38350700002)(2616005)(26005)(54906003)(186003)(508600001)(86362001)(36756003)(6486002)(2906002)(316002)(1076003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uf5LrmXyAZumM3vpJ3eDayNukjPCdRhEnc6jUz7qmEnIbQsyVNncwyKBpivO?=
 =?us-ascii?Q?79A8Kbrc/WpcQGzYK9Ny8+jx6eRtBUb0Bgko4JEL41FbmLuKJ5quaa/u+nW1?=
 =?us-ascii?Q?CkNHLZcm/0mY97YETPCeV6nUB1kQ8veseJ3cqdOCTynW1zgisUvyqRYZOOUx?=
 =?us-ascii?Q?mQ0c2SgWoJwTyDGnqYkJcrMPaHBn3btpnqArhgD/kX/ru5AYlrUOr6BaEYef?=
 =?us-ascii?Q?ZA03rQ2G72k7aNoM+KY0TSJMgJ8tiEKyfJ6P5b3foQIKZfF4f2gCZujLt4py?=
 =?us-ascii?Q?NkhwqZ9GgOtUDtr0SllzaEiRf+1gc4qYBL4gcDlV9Ug8HajD6VmAghJRO3Kb?=
 =?us-ascii?Q?Vi7DPs4gvWxL9Wue8ugYbji359sFg+rua+4xCaBnAQtws2Qoe3YI1nSoKllP?=
 =?us-ascii?Q?bk3ccP2LXdCvNf6Xxe17P2dNhnbIxYmPVJxpdP75LubtjBwYqRQarSK+ZAgh?=
 =?us-ascii?Q?D/YBQRMm9bjx+0qZrRBut1mh0NPNHB/eXaqsW3/MxZoyZjBiFIQhBZtFqjcY?=
 =?us-ascii?Q?nQEnxNmlDHBpBTCY2tnZ+y0Iduwesclhz6Q3HKLUYi9IY2VU2gItA1/uunWU?=
 =?us-ascii?Q?tn8R8EM1HsBIwdAchMmimHKd30LhK8r5r9uwVLi7GYbcY0Ol0vaykVPfx6YQ?=
 =?us-ascii?Q?eV02BFiG+PYgjXnLijxiGToYcxMCs5zr49ILx8B2guslykHp5ea2in5fn7nP?=
 =?us-ascii?Q?PT9BbDlLH5YE+HKCV7MdcTYduxY0+61pe2buR+dhk3PR6w02GaNFOc8CrtsB?=
 =?us-ascii?Q?qciNFWqvvpElFWW3jQDiqJBgT4w28ryVQzR9NmaNQTUvttp5PAkyrp8WEnmf?=
 =?us-ascii?Q?3YRvennlHMQRhygYhgIyHh7XAOu0myW/So+Vcm9F9uQk7dPZEJ2UHde5kbV3?=
 =?us-ascii?Q?0kkcZZ0tZJSBpGgfds2Ahp6zZIGO6jQ5HeGLPlly0M91Le4TmstuzfZRiGwB?=
 =?us-ascii?Q?Bhch+ELSvmcaILGkDmRJdsbfp4N3nIDs6gqkKCAS05khDF27y2U4bWaR0/3u?=
 =?us-ascii?Q?FtQNS4o7GWJOed/e2cvTx9EmmqxfFq24Zx9FulRThL6tPW/Jd/Xhcn9JOAfa?=
 =?us-ascii?Q?cWMh1bkqWPZN9c7AvLFXJTbO/K49APY1QS9nvTZN7NIS6iv+tJXN+v5P1DMe?=
 =?us-ascii?Q?NRatbluDzgQ30AfHdl3jlPOmfa2O+VT/bv/oBt9qr4/1SzioRAinPNQotMXb?=
 =?us-ascii?Q?CzrWXyO5D9ed8gMMldqHDFG5WHnAwfjbjxNTbW+snMw8lf8kKbDyZR1Tv+cu?=
 =?us-ascii?Q?N99ceT+ZJi1hvvA9mWRpD6HzLi+1f1ZSA7xr9ufihkboBaFakEdsu2F8tURd?=
 =?us-ascii?Q?oUl6X2/BDF8fB2QKc5gY/eIxIXvBR1IdCNOHBTrv3J7G+05WxMDMKTsO3ENA?=
 =?us-ascii?Q?ZWQT0Eommnyi8oIqLwAKdW8FXKu/Q4+aw8FROP+0Gy1lS3QF3Yf5a9uWRRwA?=
 =?us-ascii?Q?ur68zL3mTTJvd5oiumXHC/dNGM2sV3QDAAZgInHMeXNYoKnxoAjd2UDVpPff?=
 =?us-ascii?Q?s7nyQGLGtnPQfDm2omAkjJCwqeiJdUL3vuC5zn1Wp+n6zJlGqAem6Uvk2sou?=
 =?us-ascii?Q?NEpd7EM3EDmDFneJ1Jmb7tL7KFrhieNFzkLhttvjDbz4A+NblejLFjSDCwop?=
 =?us-ascii?Q?myKhViSsuFPKlrZKMYiatmo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af1fd107-6104-460d-787b-08d9f0139ee9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:42:11.2343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+17cXRYps3giJOZXAsJGRJArUfX5T+Hei4NQm2/FohNWdtbLy39FwsXxEC/F4fr31nqk5aWNMaL0G/3WfH/6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3895
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_vlan_member_del() will free the struct ocelot_bridge_vlan, so if
this is the same as the port's pvid_vlan which we access afterwards,
what we're accessing is freed memory.

Fix the bug by determining whether to clear ocelot_port->pvid_vlan prior
to calling ocelot_vlan_member_del().

Fixes: d4004422f6f9 ("net: mscc: ocelot: track the port pvid using a pointer")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e6de86552df0..fd3ceb74620d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -549,14 +549,18 @@ EXPORT_SYMBOL(ocelot_vlan_add);
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	bool del_pvid = false;
 	int err;
 
+	if (ocelot_port->pvid_vlan && ocelot_port->pvid_vlan->vid == vid)
+		del_pvid = true;
+
 	err = ocelot_vlan_member_del(ocelot, port, vid);
 	if (err)
 		return err;
 
 	/* Ingress */
-	if (ocelot_port->pvid_vlan && ocelot_port->pvid_vlan->vid == vid)
+	if (del_pvid)
 		ocelot_port_set_pvid(ocelot, port, NULL);
 
 	/* Egress */
-- 
2.25.1

