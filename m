Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D985B510E
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiIKUDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiIKUDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:03:07 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF33027FC9;
        Sun, 11 Sep 2022 13:03:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aq4TlOSt8aiK6IV3VVuK/66Ayqo/Y7B2lbHzZkFxFVFQvFGi6p1JAX+jxRV0i44Lk24jYOx61CYpK+EmiR4O9iTt7dqAld5H8QDiigeQMRREqjZ4P59t0nIU/OIniucE4vqSqkWEyWh/wAZ4vRJqu5wKywlRSB/meoRxyJI5054adRmePIvlovonj/ZNKazmm0rVZTeno/oZP6JHsACJ/SNYeR9lpLCySF/5OWgVKKnamIKD9y+f7iYKTNBth5IrZ1aKlq3MEyq1Q03muU2aHpnbV9AkloNJHP1cpST0EPOL9aCFSwftfpn5l2EsD8ZqQpq9VRuMIolbd4R8HDCc2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLzBU2dn6Sa+vdvgNRgichrqThsW4jBbOVCTX5P3wD0=;
 b=hOYfzFDfOEPqWJhzruluU+Wi1t03xr2nyfxBSkITXbIMHEG6oDdz1wGa0u65I7NPBrcwaXGDoYnTSqnhp1kuaUvdrGg/JFCakqlH0yia+rjTtBdcyousFNdnFor3ZNyMMvbnOyMnBIz9538zW1U/WRxypGpGGoYdJsI+YwlXdRQuKPuqLZsjJUkJEHJbsyFuGcBtiF6O37RdODMYimgVXE6BM1zDGVjYn7Ct48P879iawedndxu5vM2U8rWR5TeNYfKVNkrf39NH8L3eeqJoI6bruqBYI/LSxLDwPye2LqHwmQBCtn8siYiRomBCDpXKMHEp0GSv+tXLamXItSANKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLzBU2dn6Sa+vdvgNRgichrqThsW4jBbOVCTX5P3wD0=;
 b=UE/27i+iLdc4d9pPmkykaCfs+j/veGnzFJARuGtyWRpqcy/1KzJ6l7nb4DSB41i0/QLsJnBlPXxNpZCVELvaHnIxERtwsbnrm51zuMUh//fzZZ6Urt4edvM7qxE9q/bl/z8HZAJccT98DAG6K9X1eKj3koIiVbhhCjZlxh06G0A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 20:02:59 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Sun, 11 Sep 2022
 20:02:59 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities for all ports
Date:   Sun, 11 Sep 2022 13:02:42 -0700
Message-Id: <20220911200244.549029-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911200244.549029-1-colin.foster@in-advantage.com>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:303:dd::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5eacb02b-e21c-485c-648d-08da94309f10
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +b+L7yLVTA3PlQy4cE653FTr3KEiErEeON8JdleANCkPihOUZmiOdvFQI59zjmHrM0D6IsdyQxLr/T+Tm6LmgkYi4EHpFK9EMKAGDrvnBm0jQyRcBm3cnRES0uqvTraw8ZBJpPBgaD2ACTcReJntq4807iMguHZlTRWtJWvf0AN9GpMXuH0AgphLcN4BYr9yrhkaveEBlIJnx3gsIegXFGWLH9ezYbEzRiQvxiPku/BvaBXcDmpdOiplWs6pAvuJJlSZDbiIP+TMXj7GGATMvUM1jB8MkqIBKpP6oOrsIO1s2/gPM/W5OFVX6b6IXrUgWl1G/3i9v7ViwXV2LjzmcZTxzXy5pRd9BSmc1kZT/GjG22V5d64AIfzt8FjeqPrIUs59rvjuyoCpS9sVaiYKEmpzqowFxjdgwd3ju/FmE74iXgb5/2sxgvqJ9bJ2jWEIGgkgt6x3zYtjoHIX7GKQfRQv9EjpxWujqInjAjIkRy4jiGRBTPhThRvfM/fUWsQE0fKsCrKQsmpeRYivVoaFng/YmNPNBOe51bbH5ii7KVcNVO0UC+D4/mF72kJijb15Y5Xi+i6NkgNWA316yeuO44jFQ9/2MHkUiEu1zBOxeeBWTWYVE1nUQ3RLZ7C2VbRDwMT4NS7wPMnnY5vnZcUh/XNFYocyBKlvM9nAJfx3jNVgbiLTJuV6E6VK+W0E26EcC9DQ2oKiP0ItAfDyM8I4S9SugtaEzB3ql5DjeQW3o0vIqkZWvo1BV9zV8uCDI21BvwB6hG0TQman88lpF2Q3EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39830400003)(376002)(346002)(38350700002)(38100700002)(8676002)(4326008)(66946007)(36756003)(86362001)(66556008)(66476007)(2906002)(83380400001)(186003)(2616005)(6512007)(6506007)(1076003)(52116002)(478600001)(6486002)(6666004)(26005)(316002)(54906003)(4744005)(44832011)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8GT62Il9qja0vOQCC3bil2WAsBpgbRgd/AvUm5yW7/ASw9OGOk9xddKSi7IJ?=
 =?us-ascii?Q?ap0/MaO7IWWXsqdCF/xXuqfW4gw8UkjGVdYobI3QCWVSDqWftASVX9pkKWnh?=
 =?us-ascii?Q?Nc7CKSzYDnBigDWBLdo9TR2H49kZNXEoiNDFFygnc3yNu6QyiU4JOX9Atn4v?=
 =?us-ascii?Q?Zs/Zvcuuj/hNPMNbyX/cpMIIcWCx7aM+9thFIecuePHfKedTaFPKeSnf7piA?=
 =?us-ascii?Q?QCm50lrS9ki3+WYTVtScbAOZb+tp/eUICjFkdjaNO4XHD3e7GfUwtoefYW+P?=
 =?us-ascii?Q?0kjN1baXHZebWxRBX0uumFq/cQiemqQ8iz8F2Rx0wttrTaQ78p89PzljA9sM?=
 =?us-ascii?Q?cysyGd8raFDofx3TrnWdV6MQWygjWdWy0lQHWCApQkvXEYosjPfzTKaKlpSn?=
 =?us-ascii?Q?SKeCzxFF1dG9mmRhROoTC/MXugoFBn+yjgHHspusLGN+wOFwJoMzvswmh/jq?=
 =?us-ascii?Q?ZkTn3HMgT15i8sv5EkuOH0K1SfXeZAGhPl/FCN2DPqgQsCQvX8m99bVXRQMr?=
 =?us-ascii?Q?DL5HHxoJP1zel+nfQqDBCYx1ifQwzmH+0riCnF74kTHharqdGyTUqsnykdcP?=
 =?us-ascii?Q?JxEsP/QSAJB+Jvg1J4HpVMcLWEGa780TILn1OU0AoTviahrq04S3acP3B5SB?=
 =?us-ascii?Q?aY02WrjTTHE9gBbbXlhXyr699VMiTVrEq2PF4mHVnsRRe8zGoilSIurpT6ms?=
 =?us-ascii?Q?+4I44WuBYz3kDTN5OhnoJdCtkuOKYHgGWCppYVDaeWxw+t+7+btsxMvmb4HB?=
 =?us-ascii?Q?pK81BzZotVjNgqGLAdJXU0W+LgcxHfmv1eZEINnfZ3xNnI5Eo6sju4hrifDh?=
 =?us-ascii?Q?I/wG5BhI3zKMGrHGOn93vSno/H3HnvjsgPI4DZ6NkElZ/m2Mani7HAX8EPEN?=
 =?us-ascii?Q?SxO8Dt2yVYfoPJwwhBGmo0xTgTF6imdJ1ejz/8ASsxFZuQ/VHsgyGtbt3UVq?=
 =?us-ascii?Q?D8cdX2a4phzx3dSoorqvB/ef9seijnQkp/WtJFNNBgo1i0+DCZW/wEt8sNLL?=
 =?us-ascii?Q?EMy2vsPP88GW3QLSSFVY6wYFTm2Lgmc/XuyqsMTIZzgKh2yjExW5AC9D9BCy?=
 =?us-ascii?Q?Aa/dVuAorhLeUYiQvtcCct4mduqCpbyaG9CsVPCLmFUgt65R+od7LiKJqHkm?=
 =?us-ascii?Q?18BhvUF8W9l1IbSmgFSsPgXzh12cQV/jLu4G6Px+22SqAwSUF5n8myTtQxU5?=
 =?us-ascii?Q?kOox2rlb/l90xkKCwrLG44gyXFPc4KNx2e4HHG+QzC51hyw8wnkqMF6fuZJS?=
 =?us-ascii?Q?zjWhJ6Wbrbffp0lxvBfIbZ/XC9IxWWzmMPNRrL8R2dih1KVjM6eNOScDWDK7?=
 =?us-ascii?Q?oHIfcLuer6z0QPZDLaptX1sTUTPVgjp/GOEvSNrwa8x3nZ68kC5t7OPmQNge?=
 =?us-ascii?Q?831yjAyX5x0kYxxju+lQHyt1KhT3rED8Eo1Dj0nHJq7hMuqCAF/WNBe3EhqU?=
 =?us-ascii?Q?v40Ef1oJQANO3UPlu1wxyRuRnujBPfwnH1eo+/Cryy91PIxFQgBHW7hAyYGm?=
 =?us-ascii?Q?9kggLXYeXGNfMeHhIMZZ4of6qsU8xCCMMcaOH+aULYXg9qXs1K2VrkVU8puY?=
 =?us-ascii?Q?HJkZ0fw9DVyPkwMZiQ7dv0nqz4t6J6aJY/kuuSoFElm2PuWLlDBz5jOhTHz4?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eacb02b-e21c-485c-648d-08da94309f10
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 20:02:57.5901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PiWjnK30hWU5kETeR2rm4SPeoa9D7QO1OZ+0C1djtkW3Ckw4iv4P71wyRnW9aLsSb3i1MThrYPV61AlVuTBLVKhRgWHDENBdFo6EC8WMsNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_generic_validate() requires that mac_capabilities is correctly
populated. While no existing drivers have used phylink_generic_validate(),
the ocelot_ext.c driver will. Populate this element so the use of existing
functions is possible.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 from previous RFC:
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 95a5c5d0815c..201bf3bdd67d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -958,6 +958,9 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 
 	__set_bit(ocelot->ports[port]->phy_mode,
 		  config->supported_interfaces);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE | MAC_10 |
+				   MAC_100 | MAC_1000FD | MAC_2500FD;
 }
 
 static void felix_phylink_validate(struct dsa_switch *ds, int port,
-- 
2.25.1

