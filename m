Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0929650ABC0
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 01:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392363AbiDUXEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 19:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbiDUXEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 19:04:13 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CB733A1D
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 16:01:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYmmTmcjypYbpYroUvgiSKkV+xFuh5oxMczQoAfhsqt/+6gtvaicBm+0QLu1ShBPz3MZyd5KSSQoEhEwjM0XbF+TGv99O9QLnaFZafNsF7BIKbnFAn6qeczefv060pPqraiVquFCxk+tHuORiUOwhnJbdsLBVLWMoB3FWQ4eQb9f0mmaZo56JfEf6fD47Rk33YGlycG+4NZQyXyn0D/ySkb4rkJ7g6XDweEmK6TaO9PYYSSzjXiqXNdddXdSbzfiTJXfuwleUfPEe700AlJJNci11WO7R70ZBaziuJtvX0//AxSuqpyh5zPBw5DhatrWSrHztP23XCw22BADDMuEoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukX4um2SyVaKnG3pa6dy4A0ke97a1CJCDhfCDdN0p9w=;
 b=HagQeecbuHMW1FuSdnvsynDiAAmCJbukh5oacZHV1vxuczbK0h5HfNraTxiIxEGvr637/hIFLLJ5jXtU3VrntfywdKjuIAePnT88ZvUl7rn1lQ0oZ+vlGcoMDZJpCPGTybjaMmi/dGAH8Qe1QyGn72vDhI+NcUywr4nWOvQSactXy698LYBGgWwdlZKHlOEqMANugnJM1WXAUDOnXvXjajHMS/MAtrOO+yL1FD0FUD0LfhU+0aQMasGQPXDw4w6CJtkueHC2g3UACNr3Jd3CMEKnayUnxt+31dmGnbiL+6eP2FIKBC3ok8jTTM1Ik/D4EchjkaEIat2VxINJsnCPrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukX4um2SyVaKnG3pa6dy4A0ke97a1CJCDhfCDdN0p9w=;
 b=GDNTtGDLpYA/unEL6CzRoQNsnS4Sd/zYacBM9Wv1pD8XOX+9Fx8rfSjIT04qgWuBBEfTyRH40eeTZBOvsPfqWFfZNuhPBv93pG+6+7ZygSHuSyOqR8HdQA5hdU0u101zI26woM0RaNulWV7tARzHUF/1PZOCWJPkUqOAUo6Qimo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4077.eurprd04.prod.outlook.com (2603:10a6:803:4b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 21 Apr
 2022 23:01:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 23:01:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 0/2] Fix Ocelot VLAN regressions introduced by FDB isolation
Date:   Fri, 22 Apr 2022 02:01:03 +0300
Message-Id: <20220421230105.3570690-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0081.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c013108-b226-46a4-1217-08da23ead802
X-MS-TrafficTypeDiagnostic: VI1PR04MB4077:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4077FAC05DEF7928A55E0AD8E0F49@VI1PR04MB4077.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bAC09cpQKBv8q5tlNovsYzDO1f+ODrpQwdNLYk8eWiQndtJSE3DlnUOpSzwX71PskkWoY0OtT/bFq1Zy20WYPZhjTNPqmoMxlyWA3cnF/T+sL1SEOvceql82lnlrdJI/7TC6ihFlUsh1AKm6Alsf67XNybqnJxAf+teWmklbP1sA41+MtE8sPsYpYR31H3No+gQrpuu/jFma/R5wQKteV6MAyR4jGNWx2f5IuRsYD244BRnujmxREhYDOzQ4SlK+qRpFerOm6WM9QZAIa8cbdexqA2qHsohLrH8WFbhkrq6PZUcPNGhV6RbkSbBGMfbWOJTIPd3tsCSn1CDT9oweeHvEkMMZHP31dBliNrspGLFOuFCS+dZUcIsubEJDbSWaKsTO5yttgvOSF+vCrPNa42X9dxgog9WKrRDJyUzazERC2jU3EHdFJByFfukfDXkZ/SmH8OgMujfInQScS5KmRqIjIghwibSi2LXiSymfb5JXe0Wqx0B/iaGR/dJC0SZLHJmEaO3psaC+SijsAbYQnyFX4hRoAQbhWATkpnJD/SfBTEPz9EtZnJzGqv022DEMo040pxQZyZEgoFUKTC85OXzJg/6z+uubahrk/4kzKhIJTrD3X+MLr3P7JmymDxp30S1uNG5rR4a6oDeIwjq3VXqImHL0M8rq0mTfEYdNgn9EWegH2PBInCG90jHhg+N1zHvBUIoZAFksz1t8yQOxdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(66476007)(66556008)(66946007)(6666004)(6512007)(6506007)(26005)(2906002)(8676002)(54906003)(4326008)(38350700002)(38100700002)(508600001)(186003)(1076003)(2616005)(36756003)(44832011)(5660300002)(4744005)(6916009)(86362001)(52116002)(316002)(8936002)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?feQ7gfpZS4hJ0cdlUjPkGnAVdE2FXoAElakFZ04bkf0ESKgTk/QJQ3irK77L?=
 =?us-ascii?Q?ExYNfBkXBpTo8XVEOgjmsE9753kTmGDFsK/uskqiBS0eDGuDpEjbi+ShmrKM?=
 =?us-ascii?Q?NE2D2ntw0NECEly7O8zCTOuDbvfLdrAK0aKLxO2I23Nx55c7m8WNn3KpyVeQ?=
 =?us-ascii?Q?AnuO9PpYIFbt+lMxqma/vX9z2bH6ikHyW/EEVYHLGzF60ktFWlZk6+EGGSKl?=
 =?us-ascii?Q?XZjQWeiYgASWh+O5VMKmCFcAKwoGG07jz31ouo97K/LllXFZmE5aYN+7/fpv?=
 =?us-ascii?Q?8BT+ZLLtBE/xLMyZc+UhdNrqnYr46ISq4MEbUV9n4bJhy2mi98aY8F+HNx6J?=
 =?us-ascii?Q?OB2FwewUNDKtbvIzMoLELUBKYSISWejYloFl4JlF23lixK/erfH5a3VTbLMj?=
 =?us-ascii?Q?9lCNfN/D4qTWoL/P+ELfAGSIVOJh7XLgNgbABEF/mEC3crv6yOEZOImQwTta?=
 =?us-ascii?Q?YFla+TtpVetkfbeeoTNZ/gDubFFU0trHjxo8P2hr8A9N6HRvQBRwMheJPCLA?=
 =?us-ascii?Q?OZ4YRP9Zrw13M6Lop8Oy/L8mmfuQOUxsww64yzBrG+sx5zTITKMFarsI1k3A?=
 =?us-ascii?Q?Dxz7wn0+1JIUhx/1+zCQ64zLWciCpnDO1LnRJMhL0qyBNnZcwvu0vKy+Wo6u?=
 =?us-ascii?Q?XaWui5gE1F2i+wG8dxGoIo5iZXb53KMhiPAgnnK0VO4zBqzQ0fFLGlglCk2d?=
 =?us-ascii?Q?UQvK7mVkrOGCYTyXc0ovOBlGRE9qLFwro/4FvuyRvqJCw5VYJQgBPNBdtL9R?=
 =?us-ascii?Q?o+HVXarbLYwx1PgjkXrDkBMNaH+UwBiLTXnaq/hYj112v1yxHSiEsMVFke2j?=
 =?us-ascii?Q?3WqjXwVD1pZ9KDoEeMrXui3hQQd5I7bC5rCKUcyEbD4E1lBeRIh5EbC1lyWf?=
 =?us-ascii?Q?twDYCxgy0nTE/21kEclr+svhnd/J0PA+S6M9oEtV/UZ21vBDHVyYlF/+muYR?=
 =?us-ascii?Q?vgad2uJ3r+MPy/7ft2QKFZligR7tZxFiL7/oz/nNC9nu5vr5qti5RX1yRIrM?=
 =?us-ascii?Q?Yb7LFXPYLQy4ab90uQ8HJ3vUZFMZBEdhfuU+b3nxve3FDKzaOIWWTRh4BbH3?=
 =?us-ascii?Q?OPugOITbqUIFyRIcMa+T5y+joZT64n3xoOLDnVp48YGYKrPiJPNOa8hxxl0p?=
 =?us-ascii?Q?mrYgWG6GbINmSTwSCCLNxpw/Ons6GmEmptb3PvEH4ceZ6OSeoHVJ9mrSBxEw?=
 =?us-ascii?Q?2mzNEubDhiNrak3jYudt+GtlxI7WM5h3aMEzgJmN0HY4jTyiQ6yx480qpIhr?=
 =?us-ascii?Q?oP1VHV+zKGQRNEe6Xkk97TZA2+4TkEmgV3RY7xwx9AHzawM4XAbLm2dJfbos?=
 =?us-ascii?Q?Sp4+p4FpJjKyGo/9IYYagoHUfvGXH3IPTDOmbgXOuPoxKuLBi5c5xr4vg9qE?=
 =?us-ascii?Q?NPrha9TzI8hSlaz1H85WID9ROwh1Ka+tyC3+6GiykOsV3WOsV0bT0aZIkbsB?=
 =?us-ascii?Q?o6mMzToEzkw5gZWdyU4eYSPwHta6VRJYTc2AciBi2lCu9q+Tscy9yXIWynFd?=
 =?us-ascii?Q?roo4/coW/8PGnML8SLn48x2VrncqvAxKrjSVyrr9xzflS/PG9hUJZ5ICKf1e?=
 =?us-ascii?Q?li+EKCqWKD5ZGVG8mG5nnGLqU0Wjngf4vllmn3JAWXacvE4u8l7fgKUFPRQ4?=
 =?us-ascii?Q?YIoRiQ5PHyOi0AESE8HJdHt+LDUkB0HrGibQ3IQD5mAojwl4Xrwx3LajLMIT?=
 =?us-ascii?Q?G1pSyqIvQVbdxAHnoncuhVnaJJj0wUJy7iFc4a4VqCsWLmlUOoHkKrxArnRc?=
 =?us-ascii?Q?q+S1Jd6fgXUhTCdei/YvYks4ikQ62+8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c013108-b226-46a4-1217-08da23ead802
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 23:01:18.1086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUi05ARKbKwIHDMOWBBd8iWXlS2FybRAOHM0oO+4PYqMixHUPzwXvw8TBmIQszRu78ar3VIgnqSZ6HUl089z1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4077
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 regressions in the VLAN handling code of the ocelot/felix
DSA driver which can be seen when running the bridge_vlan_aware.sh
selftest. These manifest in the form of valid VLAN configurations being
rejected by the driver with incorrect extack messages.

First regression occurs when we attempt to install an egress-untagged
bridge VLAN to a bridge port that was brought up *while* it was under a
bridge (not before).

The second regression occurs when a port leaves a VLAN-aware bridge and
then re-joins it.

Both issues can be traced back to the recent commit which added VLAN
based FDB isolation in the ocelot driver.

Vladimir Oltean (2):
  net: mscc: ocelot: ignore VID 0 added by 8021q module
  net: mscc: ocelot: don't add VID 0 to ocelot->vlans when leaving
    VLAN-aware bridge

 drivers/net/ethernet/mscc/ocelot.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
2.25.1

