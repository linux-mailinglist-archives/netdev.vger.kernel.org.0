Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8ABF460C86
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 03:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242110AbhK2CEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 21:04:11 -0500
Received: from mail-bn8nam12on2136.outbound.protection.outlook.com ([40.107.237.136]:4161
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235039AbhK2CCJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 21:02:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8eNsSZDdzz+mQ3HM4l00JZsJWKFF2bCzi2eKHjGxxvi/ijmsyqEvZBmH6bIXiyLPOSP+4pj/gBZsJaBaHk9kEnLCSpJEfC2L58P3HwswwkXFS0tpLPZwR5h/kh4MBP4MhvT4BQXbufs/PD8sRgkF2Ecnnn97SXAq8BObaFOFlWVL003W2L1Q/gjtVz9E5bu6GrJd65yOXVBN9dYPOvCONEGgmePZLwweNr/0PH21djsDhPK1I6gB7XGvGLtjtCWEVu7/pgTsaMNrAVPKICQZnA+J7EHDg6+q9n0hVGTh4Xk1HXELC7VHVkq8K4TUEE2Nz74S5L1CT8sGiIQm9ptkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sl7WpUP6f49tMax/aIybtCiXIVuc7nxdPBDYWsOAWa8=;
 b=OVpTFsQx4vWVLXZzWyOsA9uFVh4/z+Zxc7jK2EliybfWar9Ag1j10vd8dQSE+Q35GPGY+FBInIRJhWjWwaeJO8WZmTIlbGGw2s9S9fEf+fXSbwBAGW9hFWRQT3DTVGyWikokmu8CmNE6cc2W2FKDRVI3VOSnOLG1+9NyG8uB0LHvBOKslmagbNSNZR1UjuMsu+F//j4WeEjcU7yaoClccDzSgq1fhdFu2/3OUAH0lCOCWzO1kCUt5235v85YS6cJe4TOBD5D2QhCrcyw/+4b1jhMbiAT923tEGN9zQ3krCSFxkOXPUlwmCG+iM+sjRsyrLlD3d3HIVnDSBjxtIIe/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sl7WpUP6f49tMax/aIybtCiXIVuc7nxdPBDYWsOAWa8=;
 b=AOs83TJDPGjLN43BgYnw2ThDPixqntJ9mJEHFrT8cGwr0821eLNps0hXxByzN8k5l8hmTBfgMszLdw1PilVPQs+VPZE/BZe0UUpDLY4Zq0yVMXlDSTJ4Rg7jHq3MqvFSrUKsanQvdY6QyvfG8eG8NlmUFHBje/nsrqu4EOXOKdU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1341.namprd10.prod.outlook.com
 (2603:10b6:300:20::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 01:57:47 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.023; Mon, 29 Nov 2021
 01:57:47 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v3 net-next 0/3] update seville to use shared MDIO driver
Date:   Sun, 28 Nov 2021 17:57:34 -0800
Message-Id: <20211129015737.132054-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0050.namprd04.prod.outlook.com
 (2603:10b6:303:6a::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0050.namprd04.prod.outlook.com (2603:10b6:303:6a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 01:57:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8da7fba-a680-4baf-2dad-08d9b2dba41c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1341:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1341AB396B0CFEB333F3BC6EA4669@MWHPR10MB1341.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJbORb0I5uQuC9ytvDwvhDY1JE/NAsnIhlmhVSeAfV1ZGF8LB3ImytloWGuSJruuacqzG40KVEmkxGB5KY8/vh7sDljMSn98KM3mQvb6EsHH+yLMGMrerlqiWdGQk0NSQi7shiLF2fl8LvEsMc+SzeVxmCg6vigZxdws/AwYL1xYkiy28FKrJdXBHCoefZZwVIc1Snzb/hjT7uJb/794Q6CJXRIXIZJlNpWXLtPNAePTdssyQxvgzVWgxiqr6bTzjetwIz7vbmW2tmNQQSwUrvcHLzhh9g6QmeUcTsiLazsSzyDdQO3LwjKbfUO5SYhMQJ1RRRQ0PrtdsTaYHA2TWvf6VoADGszvQR6oK8xLkejrI+JeY+AxPdem6Epw2k2CWPv8njEY2WNgFJD+XmkF7UQdC9RtBKgIEEkNGFz2L+BKoGj/XCHC7ME499Mo37GCoTrXUw/vfE2NOEPOZCqSC7dUm0ebXYxxZM+7nXFTmfs7VNuccH3h5EAJi4IvVHIdDXhrgxjPhzCltCJJCvM7yKn6chhlXni9fNP+Qz+IUsVow5OTqB5Eat3kTCR6rlg7fpt4aWcTV21+SqpXVOFalp8lmb4en5+TZ4CdjV0nl8EImaOb8rQKGsgKcj1pSfSpFOvBDi6KB7UAwAlV6xkQE+DZX5SpMk8RpEBoT+LJTr48IBkM2N6dllDY5lYI7oSlgIPUZxEKyG9B0EZutgJMdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(396003)(136003)(376002)(366004)(26005)(66556008)(66476007)(66946007)(38100700002)(38350700002)(186003)(8676002)(316002)(83380400001)(6506007)(8936002)(2906002)(508600001)(36756003)(6486002)(54906003)(4326008)(5660300002)(52116002)(6512007)(44832011)(7416002)(6666004)(956004)(2616005)(86362001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IZ4EBXYrE0q4mC4mKiHerrrA1necXevku2FXI5LvPT9+FVUj39WG7GTp+dlj?=
 =?us-ascii?Q?Z3PJ9VS+0ZfFFfpq2/NLapDx3jqSNlm0f548ZhTNdKWLxH1eMtlI2f06XzlK?=
 =?us-ascii?Q?RtujaBZzygof+MHYBf+rzECx2BLyHnPLe+9JehfjCg0O5EheyWGlJxSmEOOK?=
 =?us-ascii?Q?YGNNI96KbvDdjLn1DAKyyX+SFgenELAhIlMOAXVLfNO2eDrlD4rcq7biyWkF?=
 =?us-ascii?Q?wi7Y2UmsK1dKBnXTjOARqzdIeII7ybUJm0ls6Xa+fNTIZ5UBn6HZ6rJNOhxP?=
 =?us-ascii?Q?AkSu0a4E3etZDLNfcx3nxg2B0VfFCX7oBr+BtFnehuobOp61JYjQvuMJvKeJ?=
 =?us-ascii?Q?dpReKolagZMpUSedtW/1bsR6QToBgPyS8k6BsILvfKjFFgI+mH66x9XJT5hJ?=
 =?us-ascii?Q?7AMYxCEw8tqVjuM9L82I5vxOTGJdKjqlgGDBuKGgrKb02uCaa9JKj75S9Dhv?=
 =?us-ascii?Q?8fXKOgMg1XE+2GB9i6scWfYVF73Md3Lqt0yaXXzj7YIk2oOBvI5SxDBNeeTl?=
 =?us-ascii?Q?nDXPdmK/hi05JhfbDWPNsQVKYjNfBQDj9I3a1Y+xMcIaG+/4BaaAbgTkChw6?=
 =?us-ascii?Q?WZTtUu9YfGWiXtQOwTSWKG87w3D9GCFgBQOLpyFKDhk0VMOfx4Qpnkgrsjod?=
 =?us-ascii?Q?XXKSr8oLCovoGuN6L4DW/YYVxzZ8tPEMwPjIbGQxEzPiMRsxsVJC2mVpPoiL?=
 =?us-ascii?Q?JaxR1fYZSGKhYzN7YRqG15GkO2eoh/M37TZRy5QtEhGyRIUogCw0sV4s31i9?=
 =?us-ascii?Q?bQSbxMlZDPBJp/RMyLFYWoGNkfyqRZ2FqGOKpmv4QDN20bgFP6ljQFLm1U6a?=
 =?us-ascii?Q?kIKg8XepYESUJgVvzNWJemGjqd3rlax8jDLcpOApQGgAzHNCkanCyLtVR2Of?=
 =?us-ascii?Q?t1ospB8yYo7Lxul0QCdTsjzvwz8EZZwN2vY8MhT6FFIOhvzbYXCPKSs5LKAE?=
 =?us-ascii?Q?on5Kye+UL5nC238AeRdzu3JbOGq5uRIWpFyxD01cdnAAxdYfxoCbwX/x5U5d?=
 =?us-ascii?Q?gKDDk5fysA2FKhQhUD5GUHjP7ZWuy4aGwrSUIV7cNOgoOLjBQtFeFXONf692?=
 =?us-ascii?Q?O/EKB5zlCjHFvLexmqu43dBleZNv+iQ31Xz9E+ZZB5WYIEbBkd/zg/ahx9XX?=
 =?us-ascii?Q?8hEIgNyz9wOhRUnKamVut050y9UmWG8ZEXJdalmrnJxGu81debRQT03HZwB2?=
 =?us-ascii?Q?LGQ7cLKy3JCKmIozrgKuPK/KVwpSNVXEWlJx0fmjezLiw2LonEzsAt3M531Z?=
 =?us-ascii?Q?4l/0jF5u7BbqYLdPmPM8tb/DVDcpQ8TmrMscHUsGC5/V7fFUVE8BI5+du5wx?=
 =?us-ascii?Q?NUwGh/6TmchzXdGjBI0wZEa08BsIUdfbpt8yHZycn8ci+cemce0ReLKMiHQq?=
 =?us-ascii?Q?siGDUfpOD4yFM38uNhXSafLz5aciPaOLle6FBI0uS3vHRFbYDVtv3wv14x6w?=
 =?us-ascii?Q?v1xy8GevYzlQ/a3Z8FfbxJhBrxEFmcgpHx3fujYz36ZCaerMpixRJf/uu0rf?=
 =?us-ascii?Q?JdRzzkbZrdHYe97+Fd67zhavWoKWwedFzunQsvatTUze1+1nJkLbwqeO1oCg?=
 =?us-ascii?Q?sygTMIsUa5Q7ce2dmI69VBwpNlQv3rRBXLwQn7y33RMYla/yPdJ9o/HL3yBD?=
 =?us-ascii?Q?sOhOiinof/+YkvQHGZYnrHDZtzDoi0ziyE3MG2M3eR2vm34UBYrMF5unqjI1?=
 =?us-ascii?Q?DKq5cQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8da7fba-a680-4baf-2dad-08d9b2dba41c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 01:57:47.3496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHtAqvAGUZ6I48sWnWHkQG0mAYdKIEOXb6IRlbH9yObDWZ0j6LEROvv5CvVYYa4ZFMQv6BT1gwv2/hJJrnQnU4MqtKeR6PhsrSr2JywRhQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set exposes and utilizes the shared MDIO bus in
drivers/net/mdio/msio-mscc-miim.c

v3: 
    * Fix errors using uninitilized "dev" inside the probe function.
    * Remove phy_regmap from the setup function, since it currently
    isn't used
    * Remove GCB_PHY_PHY_CFG definition from ocelot.h - it isn't used
    yet...

v2:
    * Error handling (thanks Andrew Lunn)
    * Fix logic errors calling mscc_miim_setup during patch 1/3 (thanks
    Jakub Kicinski)
    * Remove unnecessary felix_mdio file (thanks Vladimir Oltean)
    * Pass NULL to mscc_miim_setup instead of GCB_PHY_PHY_CFG, since the
    phy reset isn't handled at that point of the Seville driver (patch
    3/3)


Colin Foster (3):
  net: mdio: mscc-miim: convert to a regmap implementation
  net: dsa: ocelot: seville: utilize of_mdiobus_register
  net: dsa: ocelot: felix: utilize shared mscc-miim driver for indirect
    MDIO access

 drivers/net/dsa/ocelot/Kconfig           |   1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 103 ++-----------
 drivers/net/mdio/mdio-mscc-miim.c        | 181 +++++++++++++++++------
 include/linux/mdio/mdio-mscc-miim.h      |  19 +++
 4 files changed, 168 insertions(+), 136 deletions(-)
 create mode 100644 include/linux/mdio/mdio-mscc-miim.h

-- 
2.25.1

