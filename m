Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA0F554645
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355026AbiFVIkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 04:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355022AbiFVIkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 04:40:04 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1746E387B1
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 01:40:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJCpybp/kwZfl0CkJ/BJyIAqbX4pVTGswkU35Ts9TPtYIebPUp1uucBltSlQRcjCwKUFXaYWDJY0mVjs6w4Zo9fPrxEISzpk1B4QWGKIZIT61N2aUYhTcA6S+Im+rmvqSv4Vay5T+d68TJIe7feCKxPODnJNbO0eI0VCAgUyza+h3jTk6IzqqM2aB9uYIfk7mHiFM2Gs7OAVmlbG8SA6b5GhzeIQZ25axRiavvuRRimUmDXoDS0Fztx3ZFQHbKGhw78ILjhsLDVfKJyQq+jKRR0wPCkLSXCp8/Bk0sykP1Eah2CVQlEyp/BYbExiVw85ir/P6WXqL3KdSR0Nq2BgpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QAOPi4jqSRa2FGHR2UGnHXBuQ6gmA3q8BK32gmO0nc=;
 b=Q9wZfQsHPjcPP5tr1MK78QYGb2sJAaoJ8Yvo+a7yFFEMKrldUOxsbkJsjjxUn34aWE77FkTjBUAUqOdXjIsEXfw0xvuJ7v7rnjbs3c8ut8g0kiU9vQtXQCBx7u6JD7vTzKPkov/Q01Wjo8UGwFIHQwgIn3WDU8Qszb5w6pyEzUFAdnxSJ11igSJc2pYjthfoqV327xN49WtE+GQE2JBVsLSTNHODk3YC7ZNxe4nRO2z0YQYqFFeqNpkRMqD0foIzlvsLSEK9Jpx7nVJGdU0ai6L5zO506C5ag2z3si8aOXbmVuYqG2Ao/PTj9jGo3032SejV28ocWVvalimATERMLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QAOPi4jqSRa2FGHR2UGnHXBuQ6gmA3q8BK32gmO0nc=;
 b=YpB5IlIw6ruofhbd2GM+l6MGzhShi1Yz47YhRFRBu4StBBtm49mKf7L2QYiNBy8WZBfe0KFC2l/eMjOmI4o0o68pAuQiNF+A1tVqTlH2sWAzNAx8XMt9dhQtcxnChdwvz3IgkSofDB7g5bQb6Yp6ZcZzkxaLSDPMh4C1wM+9T0g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1573.namprd13.prod.outlook.com (2603:10b6:903:13a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Wed, 22 Jun
 2022 08:40:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%6]) with mapi id 15.20.5373.015; Wed, 22 Jun 2022
 08:40:00 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Sixiang Chen <sixiang.chen@corigine.com>
Subject: [PATCH net-next] nfp: add 'ethtool --identify' support
Date:   Wed, 22 Jun 2022 10:39:38 +0200
Message-Id: <20220622083938.291548-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0130.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18a17261-b4c0-4975-bd86-08da542acb84
X-MS-TrafficTypeDiagnostic: CY4PR13MB1573:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1573A3B4127B4638CA479E3DE8B29@CY4PR13MB1573.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ghj+69pm4QevxwK6E50vPTSqsAd4VSt1DdpJ02uZJDUCDnFqEVynEC5Y4m+Byy3RfC+RfOMQaOF000JVsUOAakK0iSvJ/u84jlxNHZiPDIc3lskNqfIJbATb5gki+bELbcUXJ/xYwjLWK4yiOQVQMogNJKOG8T2D7QND/Yrl6XByUGjIFgA4PZDijgtwNZQE1FLU65OnYH+yPFujZoFPD0IeXetyWw2PCE6YUJaUAMSICCLIkzfQATPRRd5pNwDyMZPhJYZuuOangl+TdK+6b9HfrVgtHjI2bszEtt5lYHV6odqwPAslL/YHAqtN8gzznxK+MGgyEg0t1Lj/cRAg3Jk97iUnxaBdtndXvkMGcL6s7nJntJaan6YyrZSQeaXgLXlNt1XyuNZkp5jmTvOLgy7lyRZfoVhpuKUaQVKdR1kHA4STcUdKH8MZ9FObQ1Tfjra0iyXgb5w9LKVwe6emkGLbAjmlrdDc9RtuJhzqNMvjsHTg4H1ANFXsc1CNkECXXQ/EL10M79XwY85unHPxwZcu3bAl03ECcHpR+MhGjulxGpcs87KV9KwKl+vKblvWCOoG7u5lwK16nCNnVEW93mfOH+SCQwZT2ZNvg53xToo5R1IO9iuoj88iNRoUnA5yCz8Ng1Lj9QQYFQ5Lo66P95pBxhaK2xczt5frOyK2OkLTOzWXPQERau7KxFUGG3Izeq72gE5VnklKh0FcXGkudCSlOMGBpY9h81atYdBLugENuFG+Qtf83cliGTfjECKM/1ig72VdN7Qm2w3SStoSzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39830400003)(396003)(366004)(376002)(36756003)(2906002)(6486002)(478600001)(186003)(83380400001)(5660300002)(44832011)(86362001)(66556008)(4326008)(316002)(8676002)(1076003)(66476007)(66946007)(2616005)(107886003)(8936002)(110136005)(41300700001)(6506007)(52116002)(38100700002)(6666004)(26005)(6512007)(38350700002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Upp9rI+VGdoUM0b3meTz7XAAoW3m8HNPobFkNBQ8HU6FHhgdcj0uUgpD2LgE?=
 =?us-ascii?Q?9jSp8erLIRwS/TawcN0et1vIxsCMaXvmDQ1+vc7TnCw+9o0daE0nt7E683MP?=
 =?us-ascii?Q?RHA+vCqEMc/D2dCTHsthJ6nIgVZV1ZZVIDa2XP8kQ+yjFEyk9L3UMnoDbhTe?=
 =?us-ascii?Q?FDBpv1Xa5WzIJ5/jdA9keOJ42MgE+cO987LupKOOC5IHqXy9Q6xvOOKzKbev?=
 =?us-ascii?Q?8daTbfVLqSA1A11XWTaENZ50GltkpUfzDgun4b1aessbhjMq+ZwVhYSaX7Fc?=
 =?us-ascii?Q?f9euYRh12VxPklECD4+zyC2M8/JNtR0KQ6VI6kweLnCsGFuM3OeMY09uc47u?=
 =?us-ascii?Q?l622PanA69ypo+76ba7tDDzixbnuqtIKCuyWIp68/K8ug2p14IXU8O50N6b8?=
 =?us-ascii?Q?3mTS+MHWSUGS6ZBKDAhBvXoPxt4tcx38Mkz+IU6Kr9UqX/A5lFVhR8C0BOLH?=
 =?us-ascii?Q?TU9jqBrHl1h8DhwnNUsNDbowgAolifDhWd6WUqWO0vbHbGXwUfrLZED/eC7H?=
 =?us-ascii?Q?cwsL7xk4KG7Vj+hDiQE4c9qBT7ItMhklftk27QRJOOYcY85lJBdzAAYkAO7C?=
 =?us-ascii?Q?YK6NMZ4A25rdPZ/6oGtjME5bKwnb2dqxD2BvPKpJnibI9cTtai35NRZqGzI3?=
 =?us-ascii?Q?1i8SB1YzG/MD43vSBHPx6X5QaGFaYWLylatmshWd4XLF8qmSmABM6/ydOCpA?=
 =?us-ascii?Q?mKp+7LDOUsI7msUJFRddRerSETMDFc5j5Zr63+fxpvC6Tnd+8O90241aI0mC?=
 =?us-ascii?Q?Lfnd/Ej34YyR1KPfpJSHr+nHtim0x+UAih8W2zCnLorbcjm5PRrNQGMkstPK?=
 =?us-ascii?Q?RueZqoH0yM+Dsr6OptELkAaYpxqXVf3D2tL24So++GUmgxlborna3NLuYqJS?=
 =?us-ascii?Q?YkHiBeckdqBM79Bvq/aWuCYVhBiszY2lgH7TJi7pkwjh4Ez3oEDWK+Nj3UFg?=
 =?us-ascii?Q?DUg4JJFFiQP3zxl1kffkhMV/IgQxgWW9hqeGw/l78zkG74X8iCUeR6yR2GrY?=
 =?us-ascii?Q?RbOIYFCvEtN2u6le6QmHT4m9Ou8vnRAtfgGX7VvMKXLY13R+Lyj5vB+yhLpQ?=
 =?us-ascii?Q?ui/oyvLVEOBnuq0yEX7C/8t72i6CbvB2l4vDjnHMSGK9RmT6DUEfWV9jPi6S?=
 =?us-ascii?Q?nm8LH2hQUQ8nU/vBMF8NO/XUkVr+aENVvev+vpIz/5a70cU2lCD9s8MVknti?=
 =?us-ascii?Q?9boeWjoAE3XFlNaQUB5eWI5vOSwZ5FBlMMEJn7aKMgtzeYF4yi6ogHDImfCF?=
 =?us-ascii?Q?bn/kbLN3AH631DeOQpriH3+O/9tf0/VsenYzoUL489W4edz052MFBQCheTbL?=
 =?us-ascii?Q?kDGxEm4NfBD/nZaQncN9jtgW0g8GD60Aa+UtUelLITvekOsD5wwMVAAul2CU?=
 =?us-ascii?Q?zI1spLWO1+nS0h96LOfCTSZ9RUbQwjYxKcNuFZ1/DcpqvE1+N9V2UnkKqeRM?=
 =?us-ascii?Q?+uzFuX7z6mfIXswci4H5EYajr2LsFrbTG6bJLdeRvjm3y/XZ6k6GefbUHmyw?=
 =?us-ascii?Q?VlRTJDztxzLWX6yqB6CsPXephl4gOOGE3s20JgJPyVBkf5d2pn3ISP1Nmn2/?=
 =?us-ascii?Q?8lwVlMvsjAEggdwYT5SSc4gnIL7j2h7lI1NEtYyJ5AtyC9J8xFzkef1uZCSp?=
 =?us-ascii?Q?8zW/Hbg+JRn4YHyyADbIY1/V2lU2Hp3aoKAObcdLfmiH5bt+GLbsanol8tm4?=
 =?us-ascii?Q?Zx+B8tWJqgmMkQrt5YgbHG1oSdKV1iL+9Dbnwm6TisEIp5hrVbF2K7Ch111I?=
 =?us-ascii?Q?g2ImulbViUiMv59ivNSC8speVXCDUvs=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a17261-b4c0-4975-bd86-08da542acb84
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 08:40:00.7742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLajZU5GNGKD2VzeCgLn0ww5epXGbUyWF0JaQEE5ka7fD39XuYf5ZodK8QX4olcrstYJ+VLEePy9H41LZnUAZpQReNCyUDkMZrDApoOQjcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1573
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sixiang Chen <sixiang.chen@corigine.com>

Add support for ethtool -p|--identify
by enabling blinking of the panel LED if supported by the NIC firmware.

Signed-off-by: Sixiang Chen <sixiang.chen@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 34 +++++++++++++++++++
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  |  2 ++
 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 30 ++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 15e9cf71a8e2..7475b209353f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1477,6 +1477,38 @@ static void nfp_port_get_pauseparam(struct net_device *netdev,
 	pause->tx_pause = 1;
 }
 
+static int nfp_net_set_phys_id(struct net_device *netdev,
+			       enum ethtool_phys_id_state state)
+{
+	struct nfp_eth_table_port *eth_port;
+	struct nfp_port *port;
+	int err;
+
+	port = nfp_port_from_netdev(netdev);
+	eth_port = __nfp_port_get_eth_port(port);
+	if (!eth_port)
+		return -EOPNOTSUPP;
+
+	switch (state) {
+	case ETHTOOL_ID_ACTIVE:
+		/* Control LED to blink */
+		err = nfp_eth_set_idmode(port->app->cpp, eth_port->index, 1);
+		break;
+
+	case ETHTOOL_ID_INACTIVE:
+		/* Control LED to normal mode */
+		err = nfp_eth_set_idmode(port->app->cpp, eth_port->index, 0);
+		break;
+
+	case ETHTOOL_ID_ON:
+	case ETHTOOL_ID_OFF:
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
 static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -1510,6 +1542,7 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.get_fecparam		= nfp_port_get_fecparam,
 	.set_fecparam		= nfp_port_set_fecparam,
 	.get_pauseparam		= nfp_port_get_pauseparam,
+	.set_phys_id		= nfp_net_set_phys_id,
 };
 
 const struct ethtool_ops nfp_port_ethtool_ops = {
@@ -1528,6 +1561,7 @@ const struct ethtool_ops nfp_port_ethtool_ops = {
 	.get_fecparam		= nfp_port_get_fecparam,
 	.set_fecparam		= nfp_port_set_fecparam,
 	.get_pauseparam		= nfp_port_get_pauseparam,
+	.set_phys_id		= nfp_net_set_phys_id,
 };
 
 void nfp_net_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index f5360bae6f75..77d66855be42 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -196,6 +196,8 @@ int nfp_eth_set_configured(struct nfp_cpp *cpp, unsigned int idx,
 int
 nfp_eth_set_fec(struct nfp_cpp *cpp, unsigned int idx, enum nfp_eth_fec mode);
 
+int nfp_eth_set_idmode(struct nfp_cpp *cpp, unsigned int idx, bool state);
+
 static inline bool nfp_eth_can_support_fec(struct nfp_eth_table_port *eth_port)
 {
 	return !!eth_port->fec_modes_supported;
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index 311a5be25acb..edd300033735 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -49,6 +49,7 @@
 #define NSP_ETH_CTRL_SET_LANES		BIT_ULL(5)
 #define NSP_ETH_CTRL_SET_ANEG		BIT_ULL(6)
 #define NSP_ETH_CTRL_SET_FEC		BIT_ULL(7)
+#define NSP_ETH_CTRL_SET_IDMODE		BIT_ULL(8)
 
 enum nfp_eth_raw {
 	NSP_ETH_RAW_PORT = 0,
@@ -492,6 +493,35 @@ nfp_eth_set_bit_config(struct nfp_nsp *nsp, unsigned int raw_idx,
 	return 0;
 }
 
+int nfp_eth_set_idmode(struct nfp_cpp *cpp, unsigned int idx, bool state)
+{
+	union eth_table_entry *entries;
+	struct nfp_nsp *nsp;
+	u64 reg;
+
+	nsp = nfp_eth_config_start(cpp, idx);
+	if (IS_ERR(nsp))
+		return PTR_ERR(nsp);
+
+	/* Set this features were added in ABI 0.32 */
+	if (nfp_nsp_get_abi_ver_minor(nsp) < 32) {
+		nfp_err(nfp_nsp_cpp(nsp),
+			"set id mode operation not supported, please update flash\n");
+		return -EOPNOTSUPP;
+	}
+
+	entries = nfp_nsp_config_entries(nsp);
+
+	reg = le64_to_cpu(entries[idx].control);
+	reg &= ~NSP_ETH_CTRL_SET_IDMODE;
+	reg |= FIELD_PREP(NSP_ETH_CTRL_SET_IDMODE, state);
+	entries[idx].control = cpu_to_le64(reg);
+
+	nfp_nsp_config_set_modified(nsp, true);
+
+	return nfp_eth_config_commit_end(nsp);
+}
+
 #define NFP_ETH_SET_BIT_CONFIG(nsp, raw_idx, mask, val, ctrl_bit)	\
 	({								\
 		__BF_FIELD_CHECK(mask, 0ULL, val, "NFP_ETH_SET_BIT_CONFIG: "); \
-- 
2.30.2

