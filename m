Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5AB16388C5
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 12:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKYLaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 06:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKYLay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 06:30:54 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2125.outbound.protection.outlook.com [40.107.93.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FD418360
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 03:30:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clJqmgpoVA38ukZkChHqs9/Z7WDYbCyC4GAWZMAVgVq4epzbTebNG5dbL+bqXWXj65WRwM5gcC09BXLmt0H+nDuCoJ66fozRgXhZqDs8XuEAx9W0j00rIOFQQTtXymbBUt9vrqNzdq/xoH5NPlKpJF47OajnQy0PmOv3JieybcXhbHt876vRKmTA8fM3OXtNCu5W052k0qeAPnkcGzuHANFFN7QfHSREkz9/3l4twS1fc3W+QiUH50Ci2Ro0lQw4vqkqe0GOC/TdEUay0PyCQ6emcfMr76OqKPWCVVxhCyydvAjcE7T71VQHdii7PvfVO3eV/b/WM8zOwrSV4SXcyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1u6TMXjuOgjfKihctgLon4rPjE5BD+n8C/KxqTVg4o=;
 b=F0XWsI5pf7vjfrL5VniWX8aSHpHzqDD0zQQgfEMBCr0EkLHYRPJLInBJf1zHDTKKVHF+4CQvOMOE0ZiFsO9vn2sMLHHqoA1I+UGFt3a/1xll1IIlyx0AAFwD8xNey7Z9PprVwZE740Hlm2okRfMzm594di6qVNdVoJMDZMX+krG7SuBYYkGMAhyc1gZG5EU2fALsDxCyGllkMvl7pYqe/uRM6SV7QlYfnVWt/isfusi3vtubXVNpaABBmGi3Jj6LfRC+SqTjTqQYVzha2w01zou+nTC+9Zni0Pg2TQ3C2wuIC2VlmyeilC1dgoA1cx7tWPMOod3CW9EZX7t34HTROg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1u6TMXjuOgjfKihctgLon4rPjE5BD+n8C/KxqTVg4o=;
 b=mf1gxX/h76wHh3snLBU+2cTeAYlzqQI7dwF7sUE/wljvbaOMjBdtyOEJJAeOdAHbNipv6AMikTnVPQ8BQrSlDXdlQTD7BuGXaPohh3nppcrKf3QtGIJCQY++Hd/K3SG6WTnqyWkDsEqBRIsDSvNEdCVAmTxSYqcZsx5lDO/Enqk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4758.namprd13.prod.outlook.com (2603:10b6:408:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 11:30:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 11:30:48 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2] nfp: ethtool: support reporting link modes
Date:   Fri, 25 Nov 2022 12:30:30 +0100
Message-Id: <20221125113030.141642-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0016.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4758:EE_
X-MS-Office365-Filtering-Correlation-Id: a16366e0-da72-4895-f124-08daced87ffc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TqXQ0+FTtGM1AffKgVyGLRqcy7V4gcrcny4LVek/nd5y+SDsdLRxlP5VnAWs312Q5JOCsm8McLtu871iMjUId2FGDjkvJsOzE+nIXgsVnPQtRS1UTNMB2xHe98S5XY/PWcPx1wOAuXyfoSJzTemsvwgOc0twKycDiOO6KcfIthMkGawgd0h5KVN+he4tgfpFvsqWM9KSl4Br4slNUQW6vQ4slHOb3vShraNTfKC6aubPd0fQsoDzHx8tKYMvRpz1FIHnVyFVMJ28EwdTSzBoQgyTI/heSm2tbRvfiBcpRSxeKR5NWid5xGNM34N95hxRI/n0W+inCHEMOpAKktFTpYcWCsybpdZY7l5M8kyqGcS0ECdOPh7iBTbdRxS5nChHITuLjUFbKqAG0iKvoGmbEQWM78MTyc7QMK1EITZTnmp9aTB6RcEtpAz9qFjTn8zNHlg/8Uw6JtkDEad0rDG6LToFnt+PPYhzbJbHLfiiUzAwU9gOUmmzT46219rPQKrBz7doWdZE38O8Pv9UnN58YFmopsj4nJ4ufgJVOzrtRe067rB+bpCqL+sH3JuVWXQshHE16iaTu9mVIcc+kEXARRzHTJ1MBDDH0w4iMZ7lMAL1meruNedL5ombqU79hEX8IYUzBy2P3vUgQnrQi2THhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(346002)(396003)(136003)(376002)(366004)(451199015)(316002)(5660300002)(30864003)(36756003)(110136005)(44832011)(54906003)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(41300700001)(83380400001)(186003)(1076003)(38100700002)(6486002)(478600001)(86362001)(6512007)(52116002)(2616005)(6666004)(107886003)(6506007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0wL4W4C636nzUMX/+UC0jgmShnC8iag9bV3HTxaI2euHkORIQUh2OaoV2YHZ?=
 =?us-ascii?Q?wVirGGt/REDD+O5Am/A2Me707EjEfYjaKod1xTpBNjiziBaQVS9WPEwMKLKT?=
 =?us-ascii?Q?Ym2WnH4J6aimmSHIORCcWA0U7g7VWfNIa2meLB/2mvloInZRwpp6loi9ePcK?=
 =?us-ascii?Q?kFi7y5b9actHmYLtGtOQ8qe6WYQGsLFEj+OINwduMh2wEzcVQLmII5bw2+0E?=
 =?us-ascii?Q?l+wGBLOvY9wqdXrGq1fkvdV4hBQYEv9qTLJmdAnz/jRTRcMFsI424kYPG88M?=
 =?us-ascii?Q?jb4+U3wDALJIA3lA4XgkAoMuG2Ha+9NmnCS/f2202SxqUe/cfTXXkvA+h21R?=
 =?us-ascii?Q?CpnJV6WCUBNAn6CXb5Yf1MLCQGPrLo1kM9ObZGlDQN6UUPuxbxBZWbPApaV9?=
 =?us-ascii?Q?z7mtnxbLxquITzTATdAJNLFX2dNz+fNwLmpHhcr9BYwbyujGw3NLzFc3f4Wj?=
 =?us-ascii?Q?0EcA3TvVN+ec9zKMlQSKAXY5LyLiMIRgUJCCgzMdOuOc77/J1+x9nuXKl1ex?=
 =?us-ascii?Q?O6MNZeBfQE/kravZs3S/pdWHFfNFVFqUfQlDXIECX4AfvlzMvDCPVucaUOWl?=
 =?us-ascii?Q?q0TO28ertMp4ChNYtqiF1uEnN8ZKWx8xS5iwXBxtK+7wipaJ7jNrRjbK7SrA?=
 =?us-ascii?Q?Jugj2CRI5hwdSolWW+VBDbTJAp+mZaiexwToW2quFZBXd/SeYr2zBNruLzHn?=
 =?us-ascii?Q?BBxZ7GwAZhPSjUBHcJqycOfQs35FffVkC2HwuX/yWSBNV0IIpdcl1l2m2rCf?=
 =?us-ascii?Q?b4onWF+WzZQDht2haX+3mbM13I+dFiiGNNXLoOvQZFCOgZB6/A5MrS5RcF3u?=
 =?us-ascii?Q?tR36tvPMIMUbXVj7aVe8oPLhOl8A+mBGMYt+X11496b+zvIKNVTB3cn8Jbma?=
 =?us-ascii?Q?fS85yFOCdTMrrbS5lzNLtiN5PF3CkLo3zd56cX5k/lGBwZ4Wa5T7kYBCoOGR?=
 =?us-ascii?Q?l+K0On9cpIFin+Mcj3+LaFF6kyKxOIxGrhm6oxyz+vkAaTC1eO32zVPq/zJq?=
 =?us-ascii?Q?+wjyDETSMFHNw+oSZoh5k+bMrYRcR2QByLUwTOUnLZMWC+1G3p7JgJSczztq?=
 =?us-ascii?Q?+Yc3VPWVnXhZwmCrPePi9XvM64KjpJ0r7q8SrTZC9mBCqh8W0iwC6ZkeZdRo?=
 =?us-ascii?Q?6HMnkZm/xEIrbPzkg2AYKtNB36vuXeQ7xgJzeCvbw8iBfJNyC0YBoO6m8eN4?=
 =?us-ascii?Q?+PJOwJccPVkoqG9Cs0QZGvGRjnFzj/rMcpuNqmpnJ8xeaSxjPQjYMckS8aez?=
 =?us-ascii?Q?Rq8see2Oq5+re1k6Igw2c9U1RGHaNCwsR9b5Zi9A8hthuNrvcYZLTO9wKARy?=
 =?us-ascii?Q?833wSxZOuTDA0ZE0VMDHkBarO+2hodEIZWx/0g8b5Di6q2xdw0Bozj0U0Q7C?=
 =?us-ascii?Q?2gGFls5GGqR5LBUB061Jdl0qCNkhhYsMrqO5SCx/szzojNqvGwBSgqTCYOkK?=
 =?us-ascii?Q?MS3sWWrClnrPcD3uIRSoSq/tNWUTZ8afUSz2b8uPCQI4WKd3ag77CvpC3rps?=
 =?us-ascii?Q?Q0EoPvLFitHdvquM9Zc5F3rh/17FdnbQP4FB6H4jDmJ6P+oVZH7CU4Eal70c?=
 =?us-ascii?Q?zB9p/z5YJ/z1rafFSVgEGJvq2TnLdupzFPO6GJdlAfvu8TP5D9KsujXiDmRS?=
 =?us-ascii?Q?hVyJrJWxbME9ohzH+c9k9IjtNMg9mB/rlMJMAAakbHKZXGZpltZ/fp32sUR2?=
 =?us-ascii?Q?HCz4+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16366e0-da72-4895-f124-08daced87ffc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 11:30:48.3563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KiQxC42BXoko4WnTxiliO/2PWX5EDcxUvjy1qeX9xSC2yiC1ud4pYAhL2oRr0FLBsa606mxFDqc8MtR0vw638QeT5I0WNI+YHZJqnMTDCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4758
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Add support for reporting link modes,
including `Supported link modes` and `Advertised link modes`,
via ethtool $DEV.

A new command `SPCODE_READ_MEDIA` is added to read info from
management firmware. Also, the mapping table `nfp_eth_media_table`
associates the link modes between NFP and kernel. Both of them
help to support this ability.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>

---
v2
* Replace u8 with u16 for nfp_eth_media_table, as u8 is too easily
  overflowed
* Add tab alignments for link modes of nfp_eth_media_table,
  a visual cleanup
* Correct the initialization format of struct nfp_eth_media_buf ethm
* Replace u8 with unsigned int i for loop variable,
  there is no need to restrict the width of iterators
* Replace test_bit() with BIT_ULL(), as the second input of test_bit()
  need unsigned long
* Use __le64 instead of DECLARE_BITMAP() in struct nfp_eth_media_buf,
  as the former is hardware appropriate while the latter is not
* Use %pe in int nfp_eth_read_media(),
  to allow printing symbolic name of error
---
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  1 +
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 73 +++++++++++++++++++
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.c  | 17 +++++
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  | 56 ++++++++++++++
 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 26 +++++++
 5 files changed, 173 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index 5a18af672e6b..14a751bfe1fe 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -27,6 +27,7 @@ struct nfp_hwinfo;
 struct nfp_mip;
 struct nfp_net;
 struct nfp_nsp_identify;
+struct nfp_eth_media_buf;
 struct nfp_port;
 struct nfp_rtsym;
 struct nfp_rtsym_table;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 0058ba2b3505..e0cc60d12dda 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -293,6 +293,76 @@ nfp_net_set_fec_link_mode(struct nfp_eth_table_port *eth_port,
 	}
 }
 
+static const u16 nfp_eth_media_table[] = {
+	[NFP_MEDIA_1000BASE_CX]		= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	[NFP_MEDIA_1000BASE_KX]		= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	[NFP_MEDIA_10GBASE_KX4]		= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+	[NFP_MEDIA_10GBASE_KR]		= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+	[NFP_MEDIA_10GBASE_CX4]		= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+	[NFP_MEDIA_10GBASE_CR]		= ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
+	[NFP_MEDIA_10GBASE_SR]		= ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+	[NFP_MEDIA_10GBASE_ER]		= ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+	[NFP_MEDIA_25GBASE_KR]		= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+	[NFP_MEDIA_25GBASE_KR_S]	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+	[NFP_MEDIA_25GBASE_CR]		= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+	[NFP_MEDIA_25GBASE_CR_S]	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+	[NFP_MEDIA_25GBASE_SR]		= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+	[NFP_MEDIA_40GBASE_CR4]		= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+	[NFP_MEDIA_40GBASE_KR4]		= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+	[NFP_MEDIA_40GBASE_SR4]		= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+	[NFP_MEDIA_40GBASE_LR4]		= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+	[NFP_MEDIA_50GBASE_KR]		= ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
+	[NFP_MEDIA_50GBASE_SR]		= ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
+	[NFP_MEDIA_50GBASE_CR]		= ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
+	[NFP_MEDIA_50GBASE_LR]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	[NFP_MEDIA_50GBASE_ER]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	[NFP_MEDIA_50GBASE_FR]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	[NFP_MEDIA_100GBASE_KR4]	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_SR4]	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_CR4]	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_KP4]	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_CR10]	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+};
+
+static void nfp_add_media_link_mode(struct nfp_port *port,
+				    struct nfp_eth_table_port *eth_port,
+				    struct ethtool_link_ksettings *cmd)
+{
+	u64 supported_modes[2], advertised_modes[2];
+	struct nfp_eth_media_buf ethm = {
+		.eth_index = eth_port->eth_index,
+	};
+	struct nfp_cpp *cpp = port->app->cpp;
+
+	if (nfp_eth_read_media(cpp, &ethm))
+		return;
+
+	for (u32 i = 0; i < 2; i++) {
+		supported_modes[i] = le64_to_cpu(ethm.supported_modes[i]);
+		advertised_modes[i] = le64_to_cpu(ethm.advertised_modes[i]);
+	}
+
+	for (u32 i = 0; i < NFP_MEDIA_LINK_MODES_NUMBER; i++) {
+		if (i < 64) {
+			if (supported_modes[0] & BIT_ULL(i))
+				__set_bit(nfp_eth_media_table[i],
+					  cmd->link_modes.supported);
+
+			if (advertised_modes[0] & BIT_ULL(i))
+				__set_bit(nfp_eth_media_table[i],
+					  cmd->link_modes.advertising);
+		} else {
+			if (supported_modes[1] & BIT_ULL(i - 64))
+				__set_bit(nfp_eth_media_table[i],
+					  cmd->link_modes.supported);
+
+			if (advertised_modes[1] & BIT_ULL(i - 64))
+				__set_bit(nfp_eth_media_table[i],
+					  cmd->link_modes.advertising);
+		}
+	}
+}
+
 /**
  * nfp_net_get_link_ksettings - Get Link Speed settings
  * @netdev:	network interface device structure
@@ -311,6 +381,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	u16 sts;
 
 	/* Init to unknowns */
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
@@ -321,6 +393,7 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	if (eth_port) {
 		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
+		nfp_add_media_link_mode(port, eth_port, cmd);
 		if (eth_port->supp_aneg) {
 			ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
 			if (eth_port->aneg == NFP_ANEG_AUTO) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index 730fea214b8a..7136bc48530b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -100,6 +100,7 @@ enum nfp_nsp_cmd {
 	SPCODE_FW_LOADED	= 19, /* Is application firmware loaded */
 	SPCODE_VERSIONS		= 21, /* Report FW versions */
 	SPCODE_READ_SFF_EEPROM	= 22, /* Read module EEPROM */
+	SPCODE_READ_MEDIA	= 23, /* Get either the supported or advertised media for a port */
 };
 
 struct nfp_nsp_dma_buf {
@@ -1100,4 +1101,20 @@ int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
 	kfree(buf);
 
 	return ret;
+};
+
+int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size)
+{
+	struct nfp_nsp_command_buf_arg media = {
+		{
+			.code		= SPCODE_READ_MEDIA,
+			.option		= size,
+		},
+		.in_buf		= buf,
+		.in_size	= size,
+		.out_buf	= buf,
+		.out_size	= size,
+	};
+
+	return nfp_nsp_command_buf(state, &media);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 992d72ac98d3..8f5cab0032d0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -65,6 +65,11 @@ static inline bool nfp_nsp_has_read_module_eeprom(struct nfp_nsp *state)
 	return nfp_nsp_get_abi_ver_minor(state) > 28;
 }
 
+static inline bool nfp_nsp_has_read_media(struct nfp_nsp *state)
+{
+	return nfp_nsp_get_abi_ver_minor(state) > 33;
+}
+
 enum nfp_eth_interface {
 	NFP_INTERFACE_NONE	= 0,
 	NFP_INTERFACE_SFP	= 1,
@@ -97,6 +102,47 @@ enum nfp_eth_fec {
 	NFP_FEC_DISABLED_BIT,
 };
 
+/* link modes about RJ45 haven't been used, so there's no mapping to them */
+enum nfp_ethtool_link_mode_list {
+	NFP_MEDIA_W0_RJ45_10M,
+	NFP_MEDIA_W0_RJ45_10M_HD,
+	NFP_MEDIA_W0_RJ45_100M,
+	NFP_MEDIA_W0_RJ45_100M_HD,
+	NFP_MEDIA_W0_RJ45_1G,
+	NFP_MEDIA_W0_RJ45_2P5G,
+	NFP_MEDIA_W0_RJ45_5G,
+	NFP_MEDIA_W0_RJ45_10G,
+	NFP_MEDIA_1000BASE_CX,
+	NFP_MEDIA_1000BASE_KX,
+	NFP_MEDIA_10GBASE_KX4,
+	NFP_MEDIA_10GBASE_KR,
+	NFP_MEDIA_10GBASE_CX4,
+	NFP_MEDIA_10GBASE_CR,
+	NFP_MEDIA_10GBASE_SR,
+	NFP_MEDIA_10GBASE_ER,
+	NFP_MEDIA_25GBASE_KR,
+	NFP_MEDIA_25GBASE_KR_S,
+	NFP_MEDIA_25GBASE_CR,
+	NFP_MEDIA_25GBASE_CR_S,
+	NFP_MEDIA_25GBASE_SR,
+	NFP_MEDIA_40GBASE_CR4,
+	NFP_MEDIA_40GBASE_KR4,
+	NFP_MEDIA_40GBASE_SR4,
+	NFP_MEDIA_40GBASE_LR4,
+	NFP_MEDIA_50GBASE_KR,
+	NFP_MEDIA_50GBASE_SR,
+	NFP_MEDIA_50GBASE_CR,
+	NFP_MEDIA_50GBASE_LR,
+	NFP_MEDIA_50GBASE_ER,
+	NFP_MEDIA_50GBASE_FR,
+	NFP_MEDIA_100GBASE_KR4,
+	NFP_MEDIA_100GBASE_SR4,
+	NFP_MEDIA_100GBASE_CR4,
+	NFP_MEDIA_100GBASE_KP4,
+	NFP_MEDIA_100GBASE_CR10,
+	NFP_MEDIA_LINK_MODES_NUMBER
+};
+
 #define NFP_FEC_AUTO		BIT(NFP_FEC_AUTO_BIT)
 #define NFP_FEC_BASER		BIT(NFP_FEC_BASER_BIT)
 #define NFP_FEC_REED_SOLOMON	BIT(NFP_FEC_REED_SOLOMON_BIT)
@@ -256,6 +302,16 @@ enum nfp_nsp_sensor_id {
 int nfp_hwmon_read_sensor(struct nfp_cpp *cpp, enum nfp_nsp_sensor_id id,
 			  long *val);
 
+struct nfp_eth_media_buf {
+	u8 eth_index;
+	u8 reserved[7];
+	__le64 supported_modes[2];
+	__le64 advertised_modes[2];
+};
+
+int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size);
+int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm);
+
 #define NFP_NSP_VERSION_BUFSZ	1024 /* reasonable size, not in the ABI */
 
 enum nfp_nsp_versions {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index bb64efec4c46..570ac1bb2122 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -647,3 +647,29 @@ int __nfp_eth_set_split(struct nfp_nsp *nsp, unsigned int lanes)
 	return NFP_ETH_SET_BIT_CONFIG(nsp, NSP_ETH_RAW_PORT, NSP_ETH_PORT_LANES,
 				      lanes, NSP_ETH_CTRL_SET_LANES);
 }
+
+int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm)
+{
+	struct nfp_nsp *nsp;
+	int ret;
+
+	nsp = nfp_nsp_open(cpp);
+	if (IS_ERR(nsp)) {
+		nfp_err(cpp, "Failed to access the NSP: %pe\n", nsp);
+		return PTR_ERR(nsp);
+	}
+
+	if (!nfp_nsp_has_read_media(nsp)) {
+		nfp_warn(cpp, "Reading media link modes not supported. Please update flash\n");
+		ret = -EOPNOTSUPP;
+		goto exit_close_nsp;
+	}
+
+	ret = nfp_nsp_read_media(nsp, ethm, sizeof(*ethm));
+	if (ret)
+		nfp_err(cpp, "Reading media link modes failed: %pe\n", ERR_PTR(ret));
+
+exit_close_nsp:
+	nfp_nsp_close(nsp);
+	return ret;
+}
-- 
2.30.2

