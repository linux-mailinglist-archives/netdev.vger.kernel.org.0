Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2A249AC77
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 07:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346407AbiAYGio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 01:38:44 -0500
Received: from mail-mw2nam12on2121.outbound.protection.outlook.com ([40.107.244.121]:29537
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353723AbiAYGg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 01:36:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbiTA7HS6fDd+FwT1470+3JMdwTsPHKQW9F+/9ewuGxjj8nxktQXEH+PRJa9XEFTqykenHLuJrwr2Wy3L+rn7pNdN8FKEG0Bd0p+6rwVXzMzqaFk0jql5u9Y3Z83xPM+LAtppRxUkI98Jkpph+wYESqBoIoynJaZJ+EZjxqp0etdIkDGdWVwljHOViUkx2gQXqQ4BXEp6BEka9IFJ+lrNbXnUP5bhMsMvlhdjSisVWYptflfWmFSCq2CD8MsZqPCyZtJsF/+xIQ9jpcG5wY1b0+ZyhHL6cOQq0/CluqKfZgYp5ynDHsqUBKBTvTuVnFWAnsMiSmJsKF6ocl48SXfEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipFnab3U9WBewEIdWgjgCiHD4atT6IXjuuAAzCl42FY=;
 b=KjicbtuMYw6/oMP1J69eTFDAGFyabWtZFDKYVdMCRYBHPNuFRtIf2Dut51nbygHM4pELE7wkQS6gVcfKbHSaio55qDDHlIRAQYS2nu+EGCQYbgKifqL+4oyJQMVjNwtDamvOJKP5vizfxBJtK+krAC3wra2Iilo48diLI+2OuOYzZyZ+Nfv3LF4gYUaAZaOKEMJJW/DRazClTf8DbTxRa8OzoN5+hDxLERMc3InYNrpIbFQc/tAfw++AQWmTUqB8I/88NCODDMaBG7rnExUJ1X6GrwSsdYPcFxQUdOWMr26BrnJiiRWieoC9xoHxlcCRKDFl9Phh3l0CInZ3X6M9DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipFnab3U9WBewEIdWgjgCiHD4atT6IXjuuAAzCl42FY=;
 b=obCp5I1ufuJZ2cdHZ9dB5rkbGCR9sHTcurM7BGnFMG1mMrBD8oyFHndeWixzVPhnHtkBP8VjByjkve9QwHmZ6vh3pMPKIK9nP3IgTh0kIV8um/29gENqoH5nwwhN4SDW6/bUZ9qfAS7lSV89dm5AFNFNBN0YC+nvS/fTAVO+0bY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB5265.namprd10.prod.outlook.com
 (2603:10b6:208:325::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 06:35:49 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 06:35:49 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 0/2] use bulk reads for ocelot statistics
Date:   Mon, 24 Jan 2022 22:35:38 -0800
Message-Id: <20220125063540.1178932-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0309.namprd03.prod.outlook.com
 (2603:10b6:303:dd::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2287b8f-efe3-47cb-7729-08d9dfccecd0
X-MS-TrafficTypeDiagnostic: BLAPR10MB5265:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5265B5545A6CD04AF744B8B7A45F9@BLAPR10MB5265.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BgYi3Y14IKwxGh3G7YzBm8+cPjEpbK0kLY1kajGNPp+wbdsU5BCqZYHqVsa0oUC9uZgEaZAf2v0uVxb9rWNtt/RKgdkQa2pC32NQBwj3d1EfP5igZ+GoRw5X0udO7hYnBSzyKEnh3Tv52NQjR0i2lE2QtfW7bsKUokcm35BTqGSEieVGSGDPzHY4Z+9Bw39Xp9rqiofTX0+jkubtp/N/q9CxiT7NQrkKRXD7hmyFnoxge8+muyX9KixsnhiXOwgamstISJ2+KaCGzB38wcwEjHpFouUviynZkyphB+LNJDPEjYgsKx7IgN0/42McD7EJSUkv94ZxSis4dUm8TdHI2/21ve023FMfON9JzBmCnmzs3Vq/Cl6ndY+TvAVx0upAsGwj1CsWyKo2UuwA61EQTi3Fa3YgoFewgACLoIkS9L37EC+PGVhUVZzBsILRlMcDHA4o0aalu0UesSFRHzWCIZGAVVsevwYkUeXgIXmKm5voscrkyIdy2Z3dmIF2Fh0PSyA90zanVPi4WbfZmJq0tkk66iyJxFKHAyvAEKHdm4dEEH8aIzMANi2Gd/vdWZMKrW+E4wZaVEUR0dlpjqxeAyd/EAE+baqTcNu0fAPrZ1N5eW0IIsaXQ4YfSU6bsQKBGniGOOxBoEn0c3QVWy7vCypWevhz6wxw5FpG1l997+2NE/vWZdlE2i/4umJdfuYpaQYWTTwHC8V74TnzUdAmqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(42606007)(366004)(376002)(346002)(396003)(136003)(316002)(66946007)(52116002)(6512007)(26005)(6506007)(186003)(1076003)(6666004)(2616005)(54906003)(83380400001)(508600001)(6486002)(4744005)(44832011)(5660300002)(86362001)(2906002)(38100700002)(38350700002)(8676002)(8936002)(66476007)(36756003)(66556008)(4326008)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rffexe9V3xo1qAU32t8zsREqTjrP0UEA6IaH9v3ROoALOyf4V5O0s+gLkBp/?=
 =?us-ascii?Q?6eJEbdsaPmYlXkcqjAwwY80Smq8KJ21OJ2cSvLhVAKVSP9DHkFF4Ld6dAjfF?=
 =?us-ascii?Q?daIvyXDiBR55skjqEr3A2dS/QkQ3dmwWkNMSizt7JAFBh3cWowusU9NZTh6/?=
 =?us-ascii?Q?ZcHysC2ZXgNINTG6sQPeOFYoU63xGncoplP1Nqp8Tk9YVqZBQtsT+VlHzMOw?=
 =?us-ascii?Q?a5hOAl8CTUIn6SDwPXJdv1y1m7RGiBeej1tuyy6cQ6pOybclbmtAeTHwYnL1?=
 =?us-ascii?Q?BgMvME0i95RDrA6j+B+py09MAgRgVFifAxXJiCbOrdl4WssXDAOvt0PCE52s?=
 =?us-ascii?Q?gCJgF5ucopQtXjfdSQN6624Adz1R3kSrVWiauSlxBezBbA2jG7FN35xg5TiD?=
 =?us-ascii?Q?iKAl7nYhBtZicIu+rGvvHj9l8AL6+bfZd5P6khiHRwDSpuV6m3EzWh0Mo70w?=
 =?us-ascii?Q?gOA3QxMgNl7gcjTjoNBJo5XsQT2k710CvelBYeabNd1v+IE+YUy+l9jssJvr?=
 =?us-ascii?Q?Af0V8Y25n7gHrfDXYaP4s/oWoD+HQgeIuDe6wZa75Q1tPXnXgK47Yyt3DJoc?=
 =?us-ascii?Q?xvhx0KCQGxOFmLMgwKd0WasU3LPxiDCKXt2wAiBz2QjnXgSJnFhVuqexclYI?=
 =?us-ascii?Q?1oomqpN1HFKLXktl969uhcHH6R3zouoRPPknx8FwmtYtDbrwfAqsHT2/cBBz?=
 =?us-ascii?Q?UxvFTVk+fUpSyYMIS/Seul/Zkqve5Q1Rn23JJLcD1qVO0qSFHJEhXPPYcFC5?=
 =?us-ascii?Q?Fm6jZz5A2yfSbv1Syqus88n5rRDuxexW5CmZpxqdEh6L9y02S9vH3a022QUh?=
 =?us-ascii?Q?5U6F3sU72M/+gv2xJ/aCIQerk3XU0X7jskmj1z93X57LUdTMfM4HmGmcraI7?=
 =?us-ascii?Q?8lHOOUGnrJGes9L5GXheMie3bug3FFUZ0cClNn24KlrrnFUs64VViiH4Ytf3?=
 =?us-ascii?Q?RbFPf7jt6SNLRMKfzZVtEyY1xSuN2l+POxwTL0XjXSXubXJwkPDlq9a3ll2g?=
 =?us-ascii?Q?2AagOFyx0cxDwwgAMvBS0ST/pjA5aiP0ymbKZ0WCAh3kACl0Bgplm8JRbbdH?=
 =?us-ascii?Q?g8+6RwAcvrv0/8808QIMH/3fRufRBFzvf5LV8UoZfVMvvRAfomcr4hprOJyv?=
 =?us-ascii?Q?qJ2JsLQMWjCP+u7iUPeE0LE11J2KsP6BRmaov8gFEPQr9VLoaJ0e2kz/VHFe?=
 =?us-ascii?Q?GsoKIYHCIKGgHV++BDSOC5Dym7f/e2fHvfHtoRwCAjDUBUScPPWZkYFG1DhO?=
 =?us-ascii?Q?BQIthWpslWY1afx4prUvr1W46hp9mBhLtPiquKGBYaU8UeRjlu27ltUblt7Z?=
 =?us-ascii?Q?ITJC0zlm7cJ4TXptOBCnoaXg9Hvi3Ab6aUCB9z7hYMX8oelmjSR6Hfp+zt9f?=
 =?us-ascii?Q?y2WPsVzbGFpBDwbldjN+KJrVKVqvMJot4ST+51A+lgx3vwtYwr9ZRgemYOGR?=
 =?us-ascii?Q?RVulN4klartss/afPAIXbOKPrHh+srg4b4proBJYIhWeaf7zzwoovXhTFd6z?=
 =?us-ascii?Q?hpaheosUlx70tcRci8V/ivuNA3zLgotKVHjx5Foo3XRDuf5mxak+Aj6znoaf?=
 =?us-ascii?Q?pgc7Br5Jn2NF+N5XpUr7DNtxWDsD3AQUFEmEVaYEbi4QDd+h4uR0ooJIwya2?=
 =?us-ascii?Q?Wygg3Q6gYS532OgqOK9iS3jZq1VmFudFDnA2xBW6x1SocZxtmroXSiNjnZjb?=
 =?us-ascii?Q?pztb/kWoK4bfAio81EKL5PhPkYk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2287b8f-efe3-47cb-7729-08d9dfccecd0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 06:35:49.1855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4sVQZqf9xIiSLHoXt9edtObBB2+9EqI1dTwcmWiOkWd06+TJP53Ex3Kid/XIDAQDfgpXCRASrV3YMualhiYwhzwaPDVoZHUFvye4sNmBh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5265
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot loops over memory regions to gather stats on different ports.
These regions are mostly continuous, and are ordered. This patch set
uses that information to break the stats reads into regions that can get
read in bulk.

The motiviation is for general cleanup, but also for SPI. Performing two
back-to-back reads on a SPI bus require toggling the CS line, holding,
re-toggling the CS line, sending 3 address bytes, sending N padding
bytes, then actually performing the read. Bulk reads could reduce almost
all of that overhead, but require that the reads are performed via
regmap_bulk_read.

v1 > v2: reword commit messages

Colin Foster (2):
  net: mscc: ocelot: add ability to perform bulk reads
  net: mscc: ocelot: use bulk reads for stats

 drivers/net/ethernet/mscc/ocelot.c    | 76 ++++++++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++
 include/soc/mscc/ocelot.h             | 12 +++++
 3 files changed, 88 insertions(+), 13 deletions(-)

-- 
2.25.1

