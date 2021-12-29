Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8E1480FC0
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 06:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhL2FDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 00:03:42 -0500
Received: from mail-bn8nam11on2100.outbound.protection.outlook.com ([40.107.236.100]:8704
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229446AbhL2FDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 00:03:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acaWjfbb4+alSbV4dmAwZI1OcqzWyhJNA3oQICdoelnsuUgrviGTepuaMiR0G2h82lphUUPGFv8HFvviCigwd5E9FHvlrzMm2wVWydbR/YruobyZcbv6eZY8tnY9B7domnWx248zxH7uDOXw2xFqcNkGfpuWuCO16+BtcPa264sKvSg+sV5Wduquh6j/wSOgjfZRvAtJZ9qSPhjEMTOXlgyc4jwF2gUNBdIUS2FehSqD563vQs278aSKj8OXn77wc/wISPneYfYTiGRkgGGBhy1Wv5NUrzfmHzeEWBPk5fINa9OGVGI074YstluTgHd1YLN/su5yszv8R42ChHbC5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hr80a1xQfN/oMwj6OHs2p/lHKoArac+ggGs0CI34NIQ=;
 b=DXGKCJ9A1uG1uKxdzewRtrbLLkZULPk62jds+2Yxre1QhYVhO2tmN2P+JYINpMTxvPv+jwJ6XnMfwPaietfEc3mt8CqczEhMyU8Le7CqiiwbsTM4kGuRfFfuWlKXiOTOaIFfcU75cCj3FioNy8lrkoKI3jdB56ZE6fPfimFtQjnegdLHAQLW/fgIWBE9iHWAcS+jMkijNNQg598VMwt6r3g1n3lpPFm+exxZQ6eYSzIEnfs2H+7BwUcaobCrVoctRd/E1Ezd7vffwkiOsscUYZnVoEAca0W/u0bAKouT2ImJ3g0PUklOQdszXGTXoqwqKpO/Mb7j4eg2fyO6FJUftQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hr80a1xQfN/oMwj6OHs2p/lHKoArac+ggGs0CI34NIQ=;
 b=SAcYJ/55jMpDHeOdzp+SieoZ0TDMCaHHL6GfzIVM/GFtkiYw0NZp5UfUZI7ATHAn4uFvlK1QfRz4WAvIauVoxaywIYA3/x8D4uw9uSXQ40Ic01QTj56gX10d+L0JdkQ4SVdtwYdRVX/l0D/nHI/AhzbF7HP49eC7Ebm0dcAwDTs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4419.namprd10.prod.outlook.com
 (2603:10b6:303:6e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 29 Dec
 2021 05:03:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 05:03:38 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 0/5] lynx pcs interface cleanup
Date:   Tue, 28 Dec 2021 21:03:05 -0800
Message-Id: <20211229050310.1153868-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 491c4843-4565-4ec2-b222-08d9ca88931e
X-MS-TrafficTypeDiagnostic: CO1PR10MB4419:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4419481B0C98C0E157388C8EA4449@CO1PR10MB4419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jAJDlFebzoauUYa+7JlrE5QNl/geCvDh6AIjxABkf7yOxTOXh3k9aOm9wZQD6FvmNT6LEWmiigk8X2W5y9gIilo4c6fqEwgRzZ5WPhppcH+L+1ELqE5AlEFfZaSSETFoS6+7VPRmyrXjcL0Go/HNNr/MkM0GLjmBPLH2CCSS1NACouQEqJ89hbZRLW4bJ4QPVRV1WW9tmZYNcpE9Qt/qy2xN3xFtr4o6ofWqtHM9YiesZOR/bRDm/eggPKir1QiNQj69WkrAttfDaQ3PaQ9gSuGcgONKLQBJbFetmKZKHf0f7XjzXIODTt40nKH5Nr4Bnc/rBLWSSHviGlBjNU8kxZR+TOkv1bipwnRR5MS5lkyGQw0ebsO3knB/MZ7kJPtuZ8Ouz4+3+0rr1737MJKWlFRSd2bNTQbbwqkQMhRN5EXqRhUU8aDeMsEKanuG1pr/ZC0XkVlJIrYllQ4jdfy1W4HdU8G/WfP0lI9NwLBpXnD1UbJAo28p/5t0LN+CfMQExcZztedRMn6APzCt06RqtvZ+ieWBY2WKuliLKhR/0g3bEufVtfLDc/LYnSDjyHB5pj2tP0T+5yI547cX6lz6rCq2TW7lxANpfN2JpJrknOl2SosCUvr4bX0CKnjHCs+4Pla+3rq77uqI8U5ICA0+J3RfGfX0Ll5VvUxyoM11X+vw5qidQvZlVB1fvyB4d5+0kdTJIm4SyvS3+kf4286cdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(42606007)(136003)(39840400004)(376002)(366004)(396003)(346002)(316002)(5660300002)(38350700002)(7416002)(186003)(6512007)(26005)(2616005)(6506007)(38100700002)(44832011)(508600001)(6486002)(86362001)(2906002)(8676002)(52116002)(66946007)(1076003)(66476007)(8936002)(66556008)(83380400001)(6666004)(36756003)(54906003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2r+9CwkOwnoMkOL3tGDQmHP1g3TKwt9wHKX/oU0TAJWLVNYP4Tysp/m0PA8H?=
 =?us-ascii?Q?XoWLco0jOjYnRu+wAjPFoca8Qhom2W4dKXmaYcMRgiLAa0lI2j79Mt8MhrQX?=
 =?us-ascii?Q?r/EsfUR3PuD2iN0syjbVDRhpAzoT2bsQnngDdKp9gK8pJ7gQb0FKMFMHwLJe?=
 =?us-ascii?Q?eM2TwDK1AT4hxHihmmeJnN6aoTz8p/e5VS+TNI3wfX/pdoFX0mGwP4+ndNNt?=
 =?us-ascii?Q?kf78BsC1rcaVkKx3syc9iqH3zRM3lGmRwgJoZg3iC0+c8zdOErsFwEJbcoLS?=
 =?us-ascii?Q?jJI2YlVOe6HbkGa506ISMKBS7x2iZpaLCDG9gexb9lbNCH0DYKvNQjVRkf9F?=
 =?us-ascii?Q?RloWTDzah5AzIt/jWDFmH6nFDHTWTQVSVwxmpFSy1ewaymfxv6jjHELAflh8?=
 =?us-ascii?Q?nnoo1xRX5BKGXi9/biq6MK7jexgoTK1YTtXMvRG8GokncQV7YVMUlnXdf7Q3?=
 =?us-ascii?Q?xbRa/aavrpGMMI0nVS8Nvzv98/96Pn+XSCBLaLVQWPEmrX9r6IkwgBrXWpx/?=
 =?us-ascii?Q?Y0/Wqq+wxaaZejJBEeVYJwf1LeQdiXQ3Fk5J3PRQXSXLh/n8VeREgcuNgmQo?=
 =?us-ascii?Q?EXyybYYVegpxxmHEkydOlbbnCwif0et1oeWtf/7X6n3UUS8qlob7nolBsprj?=
 =?us-ascii?Q?OsVZ727Fhf3hbjDMcb8/ViKl/HoQvy1ONaBuGHwkohdM/1K6MmmoSJ82OGbm?=
 =?us-ascii?Q?uvkPQ4jquPLxLuqdui5yxGJDzZoIyKW9vA+f4/lqdb3ozKBbFpUP7B8c/rYY?=
 =?us-ascii?Q?dc3eFb137MSgGNzIkIj36X5tFY3PsvfETbeKvgsi6n1NJFt+qTemZ+s/mlMz?=
 =?us-ascii?Q?/QHTt38MfyW5O+HNQdgN9OubDnw1sA7fMIlaIjYknFo8f110+guSvNC9wn9u?=
 =?us-ascii?Q?djXTC7u6COk3/9mmmImE0cRa/WyfXskMsq3UgbiJR+5nJ8vfD8VY8MJcSmyY?=
 =?us-ascii?Q?uiELzEU8SYtBzcR5yVFW/OkSQWxhrUjDtfQC0mwTGjmf2WVW7vlrAruDm6sJ?=
 =?us-ascii?Q?ojmKNuEhBaSvbmJbr5Bf2xogLIirxizIjhDEyABurGcePL90suvqOMO6wtCM?=
 =?us-ascii?Q?fFSZbJNh06kuVg0WEBy8aZzLub+mQ2G00YNH+OffZx9mnr6kD+79ReeJeYoz?=
 =?us-ascii?Q?bwkmvXk+zlwEQjawJPOqAlPurtMiU8S2ub4bWGZyrlhDimjY50UawTCxlwDF?=
 =?us-ascii?Q?FVVuFRm3gmtd+PrE+E45RA0W1emAXTF9oJJalOfcXf7HJEg42aS/oK8CugQ4?=
 =?us-ascii?Q?gC4pwe7NQPH7RTyocVo3YAqp6PoISdTtu9dRwoppSY9YLJpE9Jjwu6+hUr1S?=
 =?us-ascii?Q?5I5NTIYCGAmi8nPibc39x3vEjl7UenwBM8jqFX5BjuJ3pm5JkqxiUKnLOWwZ?=
 =?us-ascii?Q?J8I8AAK2YNSyI319lNeDKqJPGDOf5MmmW7bXM87B8WXTgyzUq+GUzWXW+ooc?=
 =?us-ascii?Q?NF1UIEjx72erfwj55qbxTyp+tiTWbHFC15Ci07tROsUEllf2cAJHqYM/di04?=
 =?us-ascii?Q?b0P3j+XrsjUO0PRDg8l8wAixjvvgHaQyywoJ7Iv6kpj12S3El/qFimSF37Qg?=
 =?us-ascii?Q?Ss/geOHz52om7ncAUYzHRGn7CuSUKZg66IoImVkMtO99u2VyCsGRT98+AqXj?=
 =?us-ascii?Q?PUEfs0vC4NbalfxkFjjtz/sR9RR0hcS8VWz0Gh2hMxqsLcyNDKZuOF7x2kJs?=
 =?us-ascii?Q?zfcfLA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491c4843-4565-4ec2-b222-08d9ca88931e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 05:03:38.4292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0dcykHjCHUJn3cy3jIBAgq9awoHN9rSWsePLIOMbPDIvvSYX/nazPTMKw0RKD0WiAMO0zCPJ94ab+jbfDRg7qg39wJc+aJAPfepkgfCAgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4419
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current Felix driver (and Seville) rely directly on the lynx_pcs
device. There are other possible PCS interfaces that can be used with
this hardware, so this should be abstracted from felix. The generic
phylink_pcs is used instead.

While going through the code, there were some opportunities to change
some misleading variable names. Those are included in this patch set.

v1->v2
    * compile-time fixes for freescale parts


Colin Foster (5):
  net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
  net: dsa: felix: name change for clarity from pcs to mdio_device
  net: dsa: seville: name change for clarity from pcs to mdio_device
  net: ethernet: enetc: name change for clarity from pcs to mdio_device
  net: pcs: lynx: use a common naming scheme for all lynx_pcs variables

 drivers/net/dsa/ocelot/felix.c                |  3 +-
 drivers/net/dsa/ocelot/felix.h                |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 28 ++++++++-------
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 28 ++++++++-------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 13 ++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  3 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 28 ++++++++-------
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  4 +--
 drivers/net/pcs/pcs-lynx.c                    | 36 +++++++++++++------
 include/linux/pcs-lynx.h                      |  9 ++---
 10 files changed, 88 insertions(+), 66 deletions(-)

-- 
2.25.1

