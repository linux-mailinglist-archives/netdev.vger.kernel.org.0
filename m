Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4973415557
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 04:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhIWCFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 22:05:21 -0400
Received: from mail-dm3nam07on2127.outbound.protection.outlook.com ([40.107.95.127]:20832
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238820AbhIWCFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 22:05:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDRrdgCUG1pzSuxwy1SEKpbqX2FzIfTEganCFjA69EQBtUrG5Symeqc2hQtz2ekmj9IYyNUebt5MpdRgigXaYzd4F2vCrQtvGfAFs4rN0iAHJjKzhY3PPFA4+V9lE0rHy1Ks693YzvPCBiT2zCHpp8nj8y34emvU/zSiLZzLlID9GxAeXUxeDciQcBwWDlbK1FDdNY9j1i8SoQO9Zc5UzgrEgHHWS1AaXSavMmsQ7hjQNaAoPaPOUvNfxx6Y6Z8u21tfQA6uZeXdiMSv7AV4twLK7PqUwjrPZqgUoVKRdjJWpyroMW9+8H5GfScPQmaBo13t+Qs7qDcN97jciwAelQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=h63k/CYwi/Sz1UeH1g7n+/QVRG/Us/ocGAh2VcgF8RQ=;
 b=VbHUnkO0E4G0wfLhiE8E5RO2N3Hp1pzChT+9hiqpYnq6wZnx0XuwKcNSR6QZnJ/1/CpT4F5N10UUTiWbkBKl8dHG9ABANF0RZwKo/kHlhlwL5dU1yTrpCrriFaFXprCx9fPxTv8sUiJTbYFH50RZPDrMKrAa/KuIEgAHrbLpvhequwHtdnWMDxBPQut2DwU9uolUMb44ylU0QOugjWc5vvFDlVNf0SB/c0v9wYyLZ6KU/yGIbWhtMo/8L2hPKMDXz8t4S6RRBTAQ6YqDLMPlitP3d0vRoJdOKMSTJvN3O8BWaM7ymd8woG1Uz3UHqt7tmVsF7RyZR7AMSmgO1HJBRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h63k/CYwi/Sz1UeH1g7n+/QVRG/Us/ocGAh2VcgF8RQ=;
 b=CTXqV7hDjxBvS/1iqvd5zFH1hDAU3TS+Fpd4FQGfcb5G4AHmkjxXW/Fo3bhK68hf33KCHo5yVXThdj0kG0l8oOc5ri+W45fcSOv528Yd9LX9Zy2gSP9u+Qm7qF8Cx9w0RjQYx1AvSBzbkczJ8OPXCNq0FIObOZUiy0NCZmL2LQU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com (10.174.170.165) by
 MWHPR10MB1934.namprd10.prod.outlook.com (10.175.55.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.17; Thu, 23 Sep 2021 02:03:47 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4523.018; Thu, 23 Sep 2021
 02:03:46 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 net 0/1] net: mscc: ocelot: broadcast storm fixup
Date:   Wed, 22 Sep 2021 19:03:37 -0700
Message-Id: <20210923020338.1945812-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0375.namprd04.prod.outlook.com
 (2603:10b6:303:81::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0375.namprd04.prod.outlook.com (2603:10b6:303:81::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Thu, 23 Sep 2021 02:03:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abe42623-15f7-4504-a852-08d97e3660a7
X-MS-TrafficTypeDiagnostic: MWHPR10MB1934:
X-Microsoft-Antispam-PRVS: <MWHPR10MB193406EB98933DDF8EE5D526A4A39@MWHPR10MB1934.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJByQGnRgGh9D8lejOPdDGtsRnnn/YMFeFygUfbjwiNDeTnHT8HtS3E5h8QnpgchUOS8FVybKKsKR1QyVOYPkMzk7yP8KTJkk4bEG0UZiGqovGxwIOOsG57q5Et6agpWa2enJS7pKYigveS4bRpXkmjDEUZII2gdH+SZ8gzox60uvo8sdi7ROCB0myNrMMN8phhscbTrKPID/+Ec4LlnV/rrjVg3iGb+BZlP+T/iWZhcXJBM5bZ7PXjketPXAcyPvGd7/j8VKhZjQaqlXEpM4T3kwJ+3s5QpihGn8OD+B/u/qdzWRanyhY30Ryod6NGyyT2ZQZ2q4jlY6sjtClIataFUReO+5I7BuMIJXhI7IWoGG7Bngnmv/OSDcU1gY0OWbQLZ2jGa8cozHIU7DOBAZNQz9crtn0YJfnIufsMLLwnzV8Ami5ts/mdpBgccLOSvot8pF5iWUgcbI6Tf3me3NtmpL4TQbXcbDPGslrnDoHI2srf7Lm9Pw7byKqhr9GG4e6yLxU9fHuM3KwZUuacZFupUWshmTP2SgpupCEH9zFrlM9j6hkCCKkgIcIHLpeD7q+oj0NIa6EnGwnQ5zYRbWKzTD78zIZl47dgjF27J+6ebMi6B+cJ4Aepk2GGuaYHWH2vdqM8eKXw7/wVX9rPVmpBTRYQBYSnlsGY8oJ8wI2gnM6bSp60iS4R90ifzvCTe+yHQsW7hkp5JFhZl0m8R7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39830400003)(396003)(136003)(8936002)(956004)(2616005)(6666004)(5660300002)(66556008)(66476007)(6506007)(44832011)(86362001)(8676002)(83380400001)(52116002)(4744005)(4326008)(36756003)(186003)(6486002)(66946007)(26005)(2906002)(54906003)(38100700002)(316002)(1076003)(6512007)(38350700002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KC8/wc8gaeWhgHfxhyRO2iaqaDOHIVXAZLwZjrSyZBat8XtWiVRa1We/Vz8E?=
 =?us-ascii?Q?oRTCFQ4mlQbaeU9Arpx3F8190tF/QxeRlrAUVftereEO7lnZLwUDgcLHGWQt?=
 =?us-ascii?Q?zdLv65BNVXN14+b7wyP0qrNl+fMxYBuEneFDISPdK8NezrYrYLlFjoxtsz01?=
 =?us-ascii?Q?6I0ec4WvQhMBXAYhxD3WYLxg3ZmTXm3ZKa9GQO6MWms2diAjyD2825kzCdsv?=
 =?us-ascii?Q?pyZu7vDSyotJ9PAaTART5n4DjojNozTXhfuNpntjIHh2J2uBVK8G/+6hgUKQ?=
 =?us-ascii?Q?i61rTUEqFllw6gm8LEIXEfA9GxV5J7fannoAHplHBnVNEIz3EY6uhCIEFk5y?=
 =?us-ascii?Q?3OvbTBkdMIRGDTlVoclDP/JwA3388l2iYmSi287ZdMNvoe5xJlKd2XfWb9rK?=
 =?us-ascii?Q?51ABrxkazgIqqRlHCm/29OEL8/ir66uMW4uu0whXirBTo4OMbNFYHcR47Z2a?=
 =?us-ascii?Q?e5b8iSu3900MOkzVnAHvUmqe64hTwwf8rJDWHPODiGWwrSsLI7RgJ6ao7qyS?=
 =?us-ascii?Q?WpXCDyETknWPjuXgBh5gPIbybGk1ftC4Mb3TzikjWEEZ82UsNWSxxB4prNCz?=
 =?us-ascii?Q?r8yxGXUwCf1NPvpypLZ68MJWP9RQzOt4lZx/hm+Xz6T7Urz5ZmA49NQnoKe0?=
 =?us-ascii?Q?2umE7sGWwh3kNxeM5jKEiOGnFgswkF/eK7IFFSW8x72KFdo9b2azWrgzIo7H?=
 =?us-ascii?Q?cGF6JVq7c9FpVQmKjmnq8Co7Ei2RRZhX5Ba84owx1t0gZGJH4Uy5eppWb54z?=
 =?us-ascii?Q?oiqUF5hGRECcStuASGwknpcp5Alv2qzhezAbzC4jJ70STD3/LA9BbssJgjRs?=
 =?us-ascii?Q?dpgrFFLagaf1FM7P0O6/ZEVFYzws/quI971HR8vza4+kVJd7MlFyJRa+2YPF?=
 =?us-ascii?Q?TnKgibxLlXHc90lJRUM4C/LgdRwA+QX0MPqGKQ5FlQfoe3aHFYCNe3ol1JHu?=
 =?us-ascii?Q?0BQfw1yccUaNZBbObFwNdA8fGHTIZUxv2eiXgoTj4Q+hTDM/rQSu9eBk8hQl?=
 =?us-ascii?Q?h6sa01zkWYJJy/e3X2GZ/jqE1h+x2C9i06NDsSRQGBECtL9e9bFB/cbvH4yH?=
 =?us-ascii?Q?L37LRaEEvkYyTK9kPOqKZxhBTrQjTSpnPHtUm4bF5ZvD0RxxCt6CgTfOK6JA?=
 =?us-ascii?Q?I4roYO5m3Vfi3gIa7G1x2pr5FC9d2FB42PFrRwP+/WHK5qWHpQdeseAj+6Kz?=
 =?us-ascii?Q?GWIVaa8a2ZmTCXJvsE/R5/TtT+jWvOmKvo5I4szqwgjGZma2hF2UlHNSmlMH?=
 =?us-ascii?Q?OwWuGKhmVd10+UJsGYh4h4uBOGZMN8fV7kKUOyhsaxAb5VErDuWmY2Z/UKeC?=
 =?us-ascii?Q?rrZIFSx6ZhUOT19qKAj43BLB?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe42623-15f7-4504-a852-08d97e3660a7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 02:03:46.7188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZnpdB5RneAAXISjBYj1s9zIEyQ7ySYL5Be399I9ffDO4e6LzZY25NMbpvFXGT8KYTMqFpC6+aybjOjR9bJfVYKtr+sUifsyFR6e9Eo+FXJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1934
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot ports would still forward out ethernet broadcasts when they were
in the LEARNING or BLOCKING state. This is due to the
ocelot_get_bridge_fwd_mask, which would tell disabled ports to forward
packets out all FORWARDING ports. Broadcast storms would insue.

This patch restores the functionality of disabling forwarding for ports 
that aren't in the FORWARDING state. No more broadcast storms.

Tested and verified on an in-development driver, and Vladimir has done
independent testing and verification on supported hardware.


Vladimir Oltean (1):
  net: mscc: ocelot: fix forwarding from BLOCKING ports remaining
    enabled

 drivers/net/ethernet/mscc/ocelot.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.25.1

