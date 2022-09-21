Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E425BFD89
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiIUMNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiIUMMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:12:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2107.outbound.protection.outlook.com [40.107.94.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA84956B9
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 05:12:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Epkp3DXGglBC9Lke/YGVt4rkUkk0rFCutNVAKz0+TXY9KLDwAiaXWL0vf4+E3DfB6sLwd3OxPdKYpNhQiAiXxQoroK3Pu8x6fBZ3ucUjuRv/HCvVbtmr30FwDsMc8MfGQwgvEM92j5krq0dZRD6rpbW0XX/bFZSpsATQTIiChhcEgdK5i9yRx6zWiaK+yr2C4huM9addnPNRV+vLkBTucZ83vERAj7z6mGkXOKoNRcZPJG35HvqzoKnJpoglDO65T+QaC9S/p8fR5nBnsDXH4ExJeICSCM2WaKkEc1qauAD3ec9x/tRGG5ssq8TIme0YJZADK69hbp6GUphjsX3aWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7Jn2ys9qvODTTZXxr5YMHfBbhNcohaMNbYDEbqisiE=;
 b=fDm/m8UfAxGe71A9vJLXYwAB3ewlAD5vMp65IuJk2bzaKcQMzF1EvjCwimAuzJ6yafvzIc106XilaFxIHCRaj+tZ/gxddQ+wR80LlGXOTn6WX2CL67rmcflSdAP2J2N1xznS4u1UhqNN1O/BKTAG8mNW/YMlTXFYduTO9VnLcdK2zKZtghXxsqcIzx8aATuWPPhRSAEWHm0GcJTti4G3nf4gw8hsNHYozb2LK/IYwkSy7lA8YD8qGeTa8zP2pDNVWCIOFmKptnFs5lN7+bvlsJA8LuQaFeCTt9q3OwkpOjbMlL9QbsfvaRX2QdvtkA60FAu17Iav18KcYRBWCOQVqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7Jn2ys9qvODTTZXxr5YMHfBbhNcohaMNbYDEbqisiE=;
 b=gUfj0j67AlfnbkSQtErmfGJ4wjdzuN1/MvdtmQ/8VthO/NVKo5zo4WTY87xWmxiTc6GW8YG57BbDV369apQkvtd7oxgnzfdkhS+0/JRRxr2vRxzch54efy9c1XM9GGytBH1DvN5K6cnn4IFqVqIdRIR85laEMtO1yTLBmC1iHiw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5210.namprd13.prod.outlook.com (2603:10b6:208:341::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 12:12:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 12:12:51 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Date:   Wed, 21 Sep 2022 14:12:34 +0200
Message-Id: <20220921121235.169761-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220921121235.169761-1-simon.horman@corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0049.eurprd04.prod.outlook.com
 (2603:10a6:208:1::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: c69832bf-d931-42be-8fee-08da9bca9a80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IZyBRGEeRSCrirzrOy09RS0vcvjE2Lhw8yU+jyTWfXxJooIzfpW0g++t5DEKIJxTsPz2UjVyz2uVt792aHCopHoXDRK3fpSKwITzG7GTatQbuqolJQ2ZHIFxwWSOC6XXabUqFrwpofaVtCvW3WbrfYp4xuNnNRsVWC0JBgvncT29fPDl7P4uL95lB60YYzGTtqkoXdPk9QrbEGYEM//nfQRkr3VsLD6Nmm7EyzPP/vukO7L23LyKemWBSjdig47jcqnTSkHIIAiAseMk9yBlApEYE1X+p9PcRQv/iU58OT6kys+w1QNoUjWSBIjYEoR45FCnEatswVMV5Il1HUXoVA4qce40POQpzk46lbKLQSvpgTYuWfmBX8R7w8Wd2Hyc4x80biBBIkUevKphLpUEebTUXL8uKFFq0glxR2omI/UHFlDZsPadYsOpmpuGLD2Tn+pJFL6WlWxRmQ12S4YyID11H0ieTq8H2avJU6l/ACndDFPc/SiX839bLvd2F1nvl08scxblaDI75iC674Z1D94jrgZs7w2eC9RhJL/BzLpX0pzbNGdE/di6rvT245+EWIVuHZzinsB7JL87w1htlaKCjqD+J0GrFr7xGevSSCJ7tRaMIuNH05VZZnhP9RQb+CkTgwii/bJKZiV5UO9N0G+PG4ULTTDe6Ih0aRiRolEjryB1htmnRprop5pGlAXGv7DVVb+q5dzTFN1XJAp+FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(107886003)(86362001)(41300700001)(6666004)(5660300002)(44832011)(8676002)(478600001)(110136005)(4326008)(316002)(66946007)(6486002)(66556008)(66476007)(8936002)(38100700002)(2616005)(1076003)(52116002)(6506007)(6512007)(186003)(83380400001)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AOpnyvQ9P6fJ8as6YwLYgVLUfVAplkuqceqQGlGP2XsRbRYnXySZGd+NzAI6?=
 =?us-ascii?Q?dmmhMCT9lCLkcTeC6M3obCQz1iPdwETetrLQUewA47stswgpwlE5TosANGXl?=
 =?us-ascii?Q?PeA09HUQbyf4EZdEpJpuJ5G7j5DYDk+zxbewUHeCrQmiDMOPpPhGfaoe52wU?=
 =?us-ascii?Q?nOmpmyKGOi/Mo+k1xNwQG6eYG8Cu38K0W3aTeq7R8+XxfbXK/O+UxWOA1LMi?=
 =?us-ascii?Q?ItKn7An+6xHm959Kp7cj9f1NKEnGg2g5TwEsdXnn0ZTuElKhOnraI+p/PlFd?=
 =?us-ascii?Q?g9GhAGyu0UHniQ7W7CGRFFgv1m/k40nGLkYrIW+y31nt+zLBVxPb7x7Kn3O0?=
 =?us-ascii?Q?syBVsYe1AYSSd98eZxAASQx5/3eECsOE1IiIPCs8qq0DxNXflEZqXILetJo1?=
 =?us-ascii?Q?hjKsMUhRYoDb/8lo9aahZMG1q3c/iV77xi5c6U01OpSPTdOg+pOHitU8BWbb?=
 =?us-ascii?Q?jadalwdvoTsxgqrsxy7dV7AmXVqFGHDXy58Ch3ISZAfNHJNIZi+wnmGEFR7m?=
 =?us-ascii?Q?/UhvKXOqfr5oc60p75DSTAcOj3CTLVPZ5+gAwrv3AyLTrs0jkG3b38UgF/MP?=
 =?us-ascii?Q?BGCFCOE6f0h8UC7k+bP1YogY5W/rHOLaYVGuXy3edL5XRbYiu7ZyO2U08NGm?=
 =?us-ascii?Q?6KpvpX6/EnlSTJ2IENogPpRwadn2v9AF8KEwYZYZ5fcq1yOzKGlhIWmoM0Q/?=
 =?us-ascii?Q?cUQ6iI5WH30ZbHDILWhT4KdgbuOtEIMZQu3VXY0TEB7AurxYWSVRpf9VT14Y?=
 =?us-ascii?Q?8cdxA9urCHRzLjxyMBXKZQbU5HGVccpcDKCpZlMLAlHtTvsPxJ6AUHXPYKKq?=
 =?us-ascii?Q?zoMLNuebDJHFzCcdkiw8lc67IspeNRL0Y8Uypt9KIQcjb/ucLIxQZGNStEh2?=
 =?us-ascii?Q?FWqofjjkjUe9ebKRmUPnjMijADbTv8RdSmHlm0n0SI5VD6Q0BJmBglTWYqmD?=
 =?us-ascii?Q?P3tA/djgkCgir+j8I1TH2Z0ugtzSxDapbgtzbP64xJslr68UjTocFc/o6x+H?=
 =?us-ascii?Q?+ujgiY6/xrQ/uZ7fsW2HveiES7h4+V0xI6jsg70cqygrtogwYFx4u1Tc/NiX?=
 =?us-ascii?Q?Ofhg3g8GGjMi8hDNpOsloOvKdBTuLe8yuK6NQisyLFTROuKzaKOPHAz+GHgg?=
 =?us-ascii?Q?vmEBwKyYGONthhiY3Kd6vOBY04f0IoCaLpd3PXGes0xPkoIgsOdhUgTCE4Ze?=
 =?us-ascii?Q?uFmwn/MCBqvWVbjqOg9Q15wAt5Zbtz/2kc/sEUg+HlFEXYFAGiVOjgRVhsUK?=
 =?us-ascii?Q?bobGAOP7Y544fCpvv2YMC2dKJSlaK9RY+MxhOHeD7TO5GjeS7wGYxnuq2N5y?=
 =?us-ascii?Q?AEVUiaKwtJ1UU3wr/NaTGs5kG5biJ63wk1w87aH2efaglZwnatCSTXW1dvIq?=
 =?us-ascii?Q?BACbEJ5IT7pliTxXJMwWkBmYULGf0EMRV7lyIJqyalcGgpiMjxhws+ZGRFfm?=
 =?us-ascii?Q?ELWAUPTgRkIAvixekPozDTBB1gF4W5lIbEBSOhIYGBTZ4We4hw4cHnh6jYmk?=
 =?us-ascii?Q?/sE4a3lBdqQfXUWgvMq2z3cca5I3/7XT25PBf5+RiEN0qzqBUzTORTJtmitV?=
 =?us-ascii?Q?me6zjCKNl88QVfq4HMZxnG3Ui5zbOS8DH/SpRADpHXLDMj3x79gkLhh/lCRl?=
 =?us-ascii?Q?ouYpbwDV6Wn0Lo0p0/7pnpHQnLgZBOtJeKb8FAicW21jP8qaiszoNQjXZwnl?=
 =?us-ascii?Q?7zFlpA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c69832bf-d931-42be-8fee-08da9bca9a80
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 12:12:51.0400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJzuY+dsqS4R3FJ1AEPhuMZqvMIurvcoQXFXrLmRWDo87EfG0cBAHXFY6eihA2VCIoCMwGnL/UqPmF8i/TnW1DO5kXI0HXQnc8nbI0229cQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5210
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Report the auto negotiation capability if it's supported
in management firmware, and advertise it if it's enabled.

Changing FEC to mode other than auto or changing port
speed is not allowed when autoneg is enabled. And FEC mode
is enforced into auto mode when enabling link autoneg.

The ethtool <intf> command displays the auto-neg capability:

  # ethtool enp1s0np0
  Settings for enp1s0np0:
          Supported ports: [ FIBRE ]
          Supported link modes:   Not reported
          Supported pause frame use: Symmetric
          Supports auto-negotiation: Yes
          Supported FEC modes: None        RS      BASER
          Advertised link modes:  Not reported
          Advertised pause frame use: Symmetric
          Advertised auto-negotiation: Yes
          Advertised FEC modes: None       RS      BASER
          Speed: 25000Mb/s
          Duplex: Full
          Auto-negotiation: on
          Port: FIBRE
          PHYAD: 0
          Transceiver: internal
          Link detected: yes

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 43 ++++++++++++++++---
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 23 +++++++++-
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  |  2 +
 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       |  4 +-
 4 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index d50af23642a2..00aacc48a7a2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -290,8 +290,13 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	if (eth_port) {
 		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
-		cmd->base.autoneg = eth_port->aneg != NFP_ANEG_DISABLED ?
-			AUTONEG_ENABLE : AUTONEG_DISABLE;
+		if (eth_port->supp_aneg) {
+			ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
+			if (eth_port->aneg == NFP_ANEG_AUTO) {
+				ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
+				cmd->base.autoneg = AUTONEG_ENABLE;
+			}
+		}
 		nfp_net_set_fec_link_mode(eth_port, cmd);
 	}
 
@@ -327,6 +332,7 @@ static int
 nfp_net_set_link_ksettings(struct net_device *netdev,
 			   const struct ethtool_link_ksettings *cmd)
 {
+	bool req_aneg = (cmd->base.autoneg == AUTONEG_ENABLE);
 	struct nfp_eth_table_port *eth_port;
 	struct nfp_port *port;
 	struct nfp_nsp *nsp;
@@ -346,16 +352,36 @@ nfp_net_set_link_ksettings(struct net_device *netdev,
 	if (IS_ERR(nsp))
 		return PTR_ERR(nsp);
 
-	err = __nfp_eth_set_aneg(nsp, cmd->base.autoneg == AUTONEG_ENABLE ?
-				 NFP_ANEG_AUTO : NFP_ANEG_DISABLED);
+	if (req_aneg && !eth_port->supp_aneg) {
+		netdev_warn(netdev, "Autoneg is not supported.\n");
+		err = -EOPNOTSUPP;
+		goto err_bad_set;
+	}
+
+	err = __nfp_eth_set_aneg(nsp, req_aneg ? NFP_ANEG_AUTO : NFP_ANEG_DISABLED);
 	if (err)
 		goto err_bad_set;
+
 	if (cmd->base.speed != SPEED_UNKNOWN) {
-		u32 speed = cmd->base.speed / eth_port->lanes;
+		if (req_aneg) {
+			netdev_err(netdev, "Speed changing is not allowed when working on autoneg mode.\n");
+			err = -EINVAL;
+			goto err_bad_set;
+		} else {
+			u32 speed = cmd->base.speed / eth_port->lanes;
 
-		err = __nfp_eth_set_speed(nsp, speed);
+			err = __nfp_eth_set_speed(nsp, speed);
+			if (err)
+				goto err_bad_set;
+		}
+	}
+
+	if (req_aneg && nfp_eth_can_support_fec(eth_port) && eth_port->fec != NFP_FEC_AUTO_BIT) {
+		err = __nfp_eth_set_fec(nsp, NFP_FEC_AUTO_BIT);
 		if (err)
 			goto err_bad_set;
+
+		netdev_info(netdev, "FEC is enforced into auto mode when autoneg is enabled.\n");
 	}
 
 	err = nfp_eth_config_commit_end(nsp);
@@ -1021,6 +1047,11 @@ nfp_port_set_fecparam(struct net_device *netdev,
 	if (fec < 0)
 		return fec;
 
+	if (eth_port->supp_aneg && eth_port->aneg == NFP_ANEG_AUTO && fec != NFP_FEC_AUTO_BIT) {
+		netdev_err(netdev, "Only auto mode is allowed when link autoneg is enabled.\n");
+		return -EINVAL;
+	}
+
 	err = nfp_eth_set_fec(port->app->cpp, eth_port->index, fec);
 	if (!err)
 		/* Only refresh if we did something */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index e2d4c487e8de..2c0279dcf299 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -322,8 +322,11 @@ static int nfp_net_pf_cfg_nsp(struct nfp_pf *pf, bool sp_indiff)
 
 	snprintf(hwinfo, sizeof(hwinfo), "sp_indiff=%d", sp_indiff);
 	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
-	if (err)
+	if (err) {
+		/* Not a fatal error, no need to return error to stop driver from loading */
 		nfp_warn(pf->cpp, "HWinfo(sp_indiff=%d) set failed: %d\n", sp_indiff, err);
+		err = 0;
+	}
 
 	nfp_nsp_close(nsp);
 	return err;
@@ -331,7 +334,23 @@ static int nfp_net_pf_cfg_nsp(struct nfp_pf *pf, bool sp_indiff)
 
 static int nfp_net_pf_init_nsp(struct nfp_pf *pf)
 {
-	return nfp_net_pf_cfg_nsp(pf, pf->sp_indiff);
+	int err;
+
+	err = nfp_net_pf_cfg_nsp(pf, pf->sp_indiff);
+	if (!err) {
+		struct nfp_port *port;
+
+		/* The eth ports need be refreshed after nsp is configured,
+		 * since the eth table state may change, e.g. aneg_supp field.
+		 * Only `CHANGED` bit is set here in case nsp needs some time
+		 * to process the configuration.
+		 */
+		list_for_each_entry(port, &pf->ports, port_list)
+			if (__nfp_port_get_eth_port(port))
+				set_bit(NFP_PORT_CHANGED, &port->flags);
+	}
+
+	return err;
 }
 
 static void nfp_net_pf_clean_nsp(struct nfp_pf *pf)
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 52465670a01e..e045b6fb5fde 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -174,6 +174,7 @@ struct nfp_eth_table {
 		bool enabled;
 		bool tx_enabled;
 		bool rx_enabled;
+		bool supp_aneg;
 
 		bool override_changed;
 
@@ -218,6 +219,7 @@ void nfp_eth_config_cleanup_end(struct nfp_nsp *nsp);
 int __nfp_eth_set_aneg(struct nfp_nsp *nsp, enum nfp_eth_aneg mode);
 int __nfp_eth_set_speed(struct nfp_nsp *nsp, unsigned int speed);
 int __nfp_eth_set_split(struct nfp_nsp *nsp, unsigned int lanes);
+int __nfp_eth_set_fec(struct nfp_nsp *nsp, enum nfp_eth_fec mode);
 
 /**
  * struct nfp_nsp_identify - NSP static information
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index 18ba7629cdc2..8084d52ade46 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -27,6 +27,7 @@
 #define NSP_ETH_PORT_PHYLABEL		GENMASK_ULL(59, 54)
 #define NSP_ETH_PORT_FEC_SUPP_BASER	BIT_ULL(60)
 #define NSP_ETH_PORT_FEC_SUPP_RS	BIT_ULL(61)
+#define NSP_ETH_PORT_SUPP_ANEG		BIT_ULL(63)
 
 #define NSP_ETH_PORT_LANES_MASK		cpu_to_le64(NSP_ETH_PORT_LANES)
 
@@ -178,6 +179,7 @@ nfp_eth_port_translate(struct nfp_nsp *nsp, const union eth_table_entry *src,
 		return;
 
 	dst->act_fec = FIELD_GET(NSP_ETH_STATE_ACT_FEC, state);
+	dst->supp_aneg = FIELD_GET(NSP_ETH_PORT_SUPP_ANEG, port);
 }
 
 static void
@@ -564,7 +566,7 @@ int __nfp_eth_set_aneg(struct nfp_nsp *nsp, enum nfp_eth_aneg mode)
  *
  * Return: 0 or -ERRNO.
  */
-static int __nfp_eth_set_fec(struct nfp_nsp *nsp, enum nfp_eth_fec mode)
+int __nfp_eth_set_fec(struct nfp_nsp *nsp, enum nfp_eth_fec mode)
 {
 	return NFP_ETH_SET_BIT_CONFIG(nsp, NSP_ETH_RAW_STATE,
 				      NSP_ETH_STATE_FEC, mode,
-- 
2.30.2

