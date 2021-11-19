Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB46A4578E4
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhKSWqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 17:46:31 -0500
Received: from mail-co1nam11on2117.outbound.protection.outlook.com ([40.107.220.117]:22881
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232960AbhKSWqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 17:46:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fw1DcUY5f7iElZLgGtmp9BVAfZJwQuOcP5+iHIthfLE0segudqYjE27giWXy4p/FeKKCwOsJWb7drhpEZ4CCZXJ/ap9QA+IIJYu7WWp1vq2inkXvPPT6zw0YOOoL2zTafFCwe1RZSYjdz2S8jUiex6u7NF92lyPM+GCm17MrNQhxTDfxQ0CXYONf4Em62EWQD8NkbeizbeKAFr4zwkS3wTujvXlDJdJo2/s0m/P4MFjR6JONVpT1p8PbdzL0+6FL8sl5kxke6+oufkhnbwSO0tu6KDx2XhMzh2qO22x3X8INIAQI4pVDk4IgmxxP+xZ36uILMEvQcazJ9P8uSvylrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOeCoRlZ1dseDN5I+5Qj+v7PxT8yxh6wlCCnm/svKic=;
 b=MVAmm/FXRqMtE74Tf1vLVWrh25N7KRWvlD+GMMFcBRPbyq34xRp4EyYxfYkLCBT/V3gUve2tJNdb09KtRlu6jz7pJbofjUMpfani50AqfoySS8+8/dcZ2U/nXTLAikisjoB+tkIbPD68WLpHmIPSaf2UEcaOAD37I+q1GXL0Y67I8aIIDk7Phx/H0QZDVbJHwN9GYia0RZEfhiciI018zu/KUJ2ssbudpidNcUwUs0dwGIHsqVJ5/brj0Imo5VpG290H1KcuvWoq9+lVKlIWAt91XHM0+TWFk9F21MWigXapJRSl9Q9rJCoV85fMSmMyLmEtia/yjamJFoD0g8vrfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOeCoRlZ1dseDN5I+5Qj+v7PxT8yxh6wlCCnm/svKic=;
 b=Y1iPLqQMLLR07WvH9csscGOtjl+Ci6vCnkdBGXiLf4JTbUHFaykYl+VqteLvWVylqyxZpXtP0/IKbi9QS0i3enNk/Fsw86igJJ6ESmiEEyXZQx5pXfFyGvah9CPuzDKTd5+1xleGq8ss2dsxPqsxFUPawJGl7H5c5b6kn0sBl3E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 22:43:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 22:43:24 +0000
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
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v1 net-next 0/6] prepare ocelot for external interface control
Date:   Fri, 19 Nov 2021 14:43:07 -0800
Message-Id: <20211119224313.2803941-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0061.namprd19.prod.outlook.com
 (2603:10b6:300:94::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR19CA0061.namprd19.prod.outlook.com (2603:10b6:300:94::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 22:43:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbb7d7bc-63c2-41c6-1d9d-08d9abadfe6c
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB570195253984155D2C768FA5A49C9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0M6sOEDy58p+1tZF+K6UTxpV2ALrR2WFGOvuro/cdyJ2ceI3N/hM5BvSjOM4y4/Knb0gDQlRuuQf0j7i5tT+LEnXgW0y2yl16glrYWG+QjN6jHycH7HXBtBoYmMMIfBShZRYxAkttBc7mjWF92OS0yjQz5onSYjMgbD96Vh/As6XvUn0YxbC2YDe+5d8ooHi9ns6kH5x6LdApJ71zM0ZxAliecfZm9oHQEqNm/zWZNQYSmdnbAETal5M5sl81w4jNKCDhuImKB45ma++7S28daMTLrZ2lPBjMJnnby+jl6+bsORcykjWeRPE8tqjLkad5tlNhcvBAn4ySl4VF3LfQDXsyWtxxcs51WkSah0X+kI7hV9USDld/u7+WYHEhmUr+bfDokcDhbgZFm5pXos8KjOlj19W6rPlrHyqIyLxAS8t8FOgQPkhRC1mC3uFq7spKPycbezRg/N6EewFO76P6vvCW2YLwYP0bBCpyAv36N5aIKI3NaXtcoyPCAmmfcPe9e9FvcnBxrmCKUSotnnHjHfXLz1ImK7s8Nyf8sABinplYE8V6UeF/2wGCMy6ssDFdFnP1+gf/kD0eeCr17LsH8xHlFW6ZUjsXea+cx+rFzwh4o646IsPacn15s1y52l+h0wYpzDWMxmWx61M4aBCPHrQ9iMwOhpTjydrSgRvkXUk+ea2ZJzy134PntHxNYl14tTV6+5I1O6dIt4yJok6KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(36756003)(44832011)(8936002)(8676002)(6486002)(4326008)(6506007)(508600001)(956004)(2616005)(1076003)(7416002)(6512007)(26005)(86362001)(66476007)(66946007)(66556008)(83380400001)(2906002)(38100700002)(52116002)(38350700002)(186003)(54906003)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dEnQVYQLPtuOjINUTajOyxTyZSxfyVpj/f3p8BvU3W5EKX7efGxY6JNAoE9B?=
 =?us-ascii?Q?Iny7bSx/riQhwwmEnDNSdpnCVoY8brAAvaDOyUgs+BwZcwtmWhp2mzSB6T3O?=
 =?us-ascii?Q?nbfUN7CRLjkD0SWFbugNaxWLlTvgqkYBY9eDxWhCcFY1988ge/dzUVY3zWPT?=
 =?us-ascii?Q?eGrN2Hhwh4cIzBgg3r2vupDR2ZbijRNfRU+tUPtVRMo3G/gp7W+RLruiIZ+P?=
 =?us-ascii?Q?p7KvkiaEiGiHvJNOuQmkJBl/JFfQs2ruBsQsvkarzuttaGiE9NaEpCVMXaUP?=
 =?us-ascii?Q?qeY57+CmEY0ebCMUu0IBjbU0nlxNc6p3QAfebQlpO8YvyW6j846JDovjw/Zz?=
 =?us-ascii?Q?qXplufXJtOPUgh5tHrgfyDdKWx2igQMd/kWrINZY9I2RwHznd6zzA/mLptOE?=
 =?us-ascii?Q?8uEuTU+LFfE1JGayXnma+eyYzrottASGHyi+uUlQO1LPD+CwBafJ59pNDoiv?=
 =?us-ascii?Q?9tC2S6v8D/Y/Im5HUazYbau2giEA/NPhWLvSYnx51cIkZfKCvopizcBGiNs9?=
 =?us-ascii?Q?RKe7xSnkcPVuEE52y3s/qmZuC8idmQlZSuwmLupcJQfVU2d7fjCuY2xlcpIZ?=
 =?us-ascii?Q?zap/v/N1pGUCnwwRqOXMWzqykkMD/bpRsJk3+QskZahT5QTQORTvLHhSV8r/?=
 =?us-ascii?Q?rjOvubp+fyCjyj/oTgMFW5SNnYcXyaoiFhdBOzkXF5TyWfc79X4bk0K47Q29?=
 =?us-ascii?Q?wA0zmp4Lmeaj9dyXI7LF6MU8lsQBYFBEF8zKwH6IysDcdI5D2VF8JsE+1FQ2?=
 =?us-ascii?Q?qRA2o+sOzKCoWuhsLFqmKZwOOhsF9i6usj4WKoRRqQKWXQsedKMn2TCVGGJX?=
 =?us-ascii?Q?7jEK8pgACnQDd4xpevdJv51MNBzgvaAQXiQHeGe6BiLvLXSvnzbRDVd5vbij?=
 =?us-ascii?Q?6sUOwtsL184G4w6tVvzEsmRtZcE2xiHud5GX7dMdfI20Y4W6wfbsyWufLXnL?=
 =?us-ascii?Q?D39VPnfpr1wElDtJxzor0zPgO6Dp63Wp8c4OIE4MRvWMBeXlRBAV+0Au+YPU?=
 =?us-ascii?Q?Xgpi/b7P9UtTek7c+gesdMpVrVofAa26RALduIwoZfaj+NGfng45HB4+zUAb?=
 =?us-ascii?Q?D/c9jhjrrg9DrQQEpa6FaS7pQAXTT2u/Wp99tRCtLizvEhDL8LI3SmC4/3va?=
 =?us-ascii?Q?4oaCRsCj/ZKSg3mH5GenqT3U8jNRz3WrEIrRyRY2vG5Vn5iZRMpAWH9cNoGQ?=
 =?us-ascii?Q?oPxmuOLQpGvBW8QWT17UH80oA/fJtArRxc5vSAupu/mJ5mUFQ6p5YYW4l8Ii?=
 =?us-ascii?Q?N47z/Gijd2CBcm0N/jIySF0tf6OVnr2MbYHay+Rhbcpx1aOOPz5gscSfWO3Z?=
 =?us-ascii?Q?/u76XvD7k+hnMPXvCOCv+dQqdjHAqsGkN1Q/UJvBj8X3CmDcPEla5PpLRiTu?=
 =?us-ascii?Q?i88KBPwL9kan6kd56DrAQEa15hqZSVRvn8WYOFShj4ytO2KLT3cpUnQM0iS1?=
 =?us-ascii?Q?kF2gYT5ErX/MzHzMw883OkfvzUowB4oceXTsfVTHJM8UqfLfOrRDds7lKCA4?=
 =?us-ascii?Q?un43lokocT/SsivOms7d3DhQKO9FgSAYywEEp8Az5LGP+ZL4NptaGBu/ka21?=
 =?us-ascii?Q?V7YihH0r9PCyhn/1kmQAvlySoDVYsLGPZh+9MIaP9LafVnpR1lMqLkfkL+x7?=
 =?us-ascii?Q?zB6icSI5/a4gcJCBU9jB5F4bVrM3V1WVf90Cg14XWfQ0KLySw/SnQqyKZRRe?=
 =?us-ascii?Q?Qxl6OoacFExLxYs5QLW2Nxfiwyg=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb7d7bc-63c2-41c6-1d9d-08d9abadfe6c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 22:43:24.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /iD091CmW9s1d3mIIM5B8bTwYd6dQPUoklHk740goviUTOcQzNkPNDyRKCYb/mSfZbWaejpJQDIuhz13vqKVXhsDw923vAqEZA+rzKOdOkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is derived from an attempt to include external control
for a VSC751[1234] chip via SPI. That patch set has grown large and is
getting unwieldy for reviewers and the developers... me.

I'm breaking out the changes from that patch set. Some are trivial 
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices

some are required for SPI
  net: dsa: ocelot: felix: add interface for custom regmaps

and some are just to expose code to be shared
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions


The entirety of this patch set should have essentially no impact on the
system performance.


Colin Foster (6):
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
  net: dsa: ocelot: felix: add interface for custom regmaps
  net: dsa: ocelot: felix: add per-device-per-port quirks
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions

 drivers/net/dsa/ocelot/felix.c             |  26 +-
 drivers/net/dsa/ocelot/felix.h             |   8 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  12 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   2 +
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c |  31 ++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 548 +--------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 522 ++++++++++++++++++++
 include/soc/mscc/ocelot.h                  |   5 +
 include/soc/mscc/vsc7514_regs.h            |  27 +
 10 files changed, 632 insertions(+), 552 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
 create mode 100644 include/soc/mscc/vsc7514_regs.h

-- 
2.25.1

