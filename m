Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4C768C1D3
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjBFPjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjBFPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:39:04 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::71c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F36A23D81
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:38:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbOZz3VmvFBWO6XqZi6pSj+zpZud8Akkmpsg5lvm6W31sJyvpa+y9f31E4Kheek7/LP7BxBWmS5UhOcyTyGzeUHYc0TFO24JKPk87UZUvborxP0FCBxtaTqCRvTuuVgRZz0F0DjhaypH/mEJX+OvsOw0bEGIEEXKZ0GuMfxNzRhFR1i0eySx7o6ZSqTsSFmjmq2z4f9TipcLJEBkO/3TCs6DJS0AoMSpe5aqsXVZshihofghePI1qf8lZYMAXn3QVvqgj+B6E7IY6K6S3ZYq2H6S1Ab7lvKU6r/dGymX5cId1Ul+/R2krDRtmYgqUtQtBO9A3Na2rnVZw+2XvY+2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8m9MxdkdLUdV38JNktbGMEP/LGOKlMubuoZF76WbqQ=;
 b=Wb9W9wK5L/YJw4DWp5Fa0sBPPJDX0IqwQVgTZza+yzzncAHZHJjfwwQOFatqMrMBilLm+QvU0H2Zers2jsk7mIwXkLw8abAli8UVE9SVjdZMPojC4vfRRxPa11amA76tbVxUuEz+FDrisIeL8NbL1Rf0bEN5A3In9AWxcZvxFfqIqsZQAfi+e1NdJqy5YX9Bp8ql3ulQdIRYei/W1NSkTGZqlF0eaRrYm23WmgoICj15zR750BpBBVYvuKfTkhH+B4vpsy+3gNS2jGXBj1VQsryBBvBa2SkBm5YM7u7IfPhZwP46P8bicM8q81iR15p/VYOIzO7ciWAmPXYJgviDLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8m9MxdkdLUdV38JNktbGMEP/LGOKlMubuoZF76WbqQ=;
 b=LTgdc0BLNt2pbV6YGuQvfyCMNS/f31qryXgE3Ugl3GvEYr1wCmjGbTvMsLc/2GS/ydeQ8H/p5rSx565Ak2J1gYSfVJnH2stjR4d945Tp4CnwOiNzUzfllLFTm2hlv7W1DXlcqojZjD4zN7lKAWWVMA1UbgLvCSQK7m3boGgOWNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5009.namprd13.prod.outlook.com (2603:10b6:a03:363::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 15:36:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 15:36:44 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH/RFC net-next 0/2] devlink: expose port function commands to assign VFs to multiple devlink
Date:   Mon,  6 Feb 2023 16:36:01 +0100
Message-Id: <20230206153603.2801791-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0202CA0013.eurprd02.prod.outlook.com
 (2603:10a6:200:89::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5009:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b3e993a-f4d8-4f34-0b9f-08db0857f306
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cbL3MDLkjvIfLVcH2J277gDK5v9Tj+noaZ4MX0c1MYCfcMvnQ49joB03b3h9KyRe801hgLBSxb34VU/qHBmFLMh5hU8JhF5p64SrO/7GGMKM3k/GgbOTOZZhVP22l5nyanP6KGimulvgo/AehFAhAMIFuIYgtt8TtrQ8cpuaWaSTJ+srPPDKzlO8jyYlghItILgQLb3BTdcOnKVFKyeye9qRnW61HjxZqhXO7yRgOZiXajb4kdyg7RFw1VtcSC8VUl4NffR5lgmGlmk9oIDZyaR7KvZoIqV4U7vZgnrlg6ovUKsJvetlOIHygUnRVrJuJh4kYr+0g+/9TaXdwB/K/j95aAYEqz2NM9+p8ZMqyWwS40Uc68oxXoPVTGSGcRYp4bNKE8vkVXE8hT8DMeugXKCVXVeo7E56ZRgX+hKT2bUDNvxoNQTXOeR8bIGLNE401dnLdU4g084sWc7M3doDG5lN/RGVYUQhFKKxW3zMvSsti38pr4XeTtz4AbwdOjRBvQyI5AS2eg0sumMZNuXG8H9a98Ci7uUdAE4AkK9dvRL8DxmtMGuDyQnDJ17eBhP1xP0tnA2CjI8zqnK5IPevPDgG8aBh2wz8PEbP67/BpXEbMWOIZ8WEjNYpIZbvNL/oUZswkleuXfcqzDyjQDm+w9NvnWpRtGsFoN99ron2qJksGHSJIMZX56LZVIkPFJEg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(346002)(376002)(396003)(366004)(451199018)(52116002)(36756003)(54906003)(66946007)(6666004)(110136005)(8676002)(6506007)(1076003)(4744005)(478600001)(4326008)(7416002)(5660300002)(66556008)(44832011)(2906002)(66476007)(8936002)(316002)(38100700002)(86362001)(186003)(41300700001)(6486002)(107886003)(6512007)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3ZaSnJEbldheElrVWFoeVZSTk81aHRMZWE0K2paRXd0aEVIYmh6WEd3Nlda?=
 =?utf-8?B?VUtiUWdSbllWdkNxenZQVm1YTGpBeE9rT1QrTDV0c2twVWhTU0hjektNV1lK?=
 =?utf-8?B?NTZaQnVydi9VR3VvblFXQk1pdmlBQkZuYmlCbnlNR2tXS0pNbWxZWkNTYmRk?=
 =?utf-8?B?dmErWFF3OTgvL1Q5ckZyWVR0T1Bnc0lZS0pFZy9kMXpjZzVHZ2hNSGtWVWxY?=
 =?utf-8?B?ZkY5WGw3b1pyRGswWlVhcms1VGJYUVducnlWRGs3N1Vnb3NyemlNdlRhSXZZ?=
 =?utf-8?B?K2dqL25tL0lmbnlNUnYrQ0k0WXM4Q1pXaFpwUjlJUm1pL3J4OENIQ1VvUVBx?=
 =?utf-8?B?UVhKOEF4eHNhUkw0SWFVSDlCZ2YyTGpOREZDbXVNOGUrQldkTzc1eVNIMUZM?=
 =?utf-8?B?WFVOSWt0ZFdBYktNdVNoVzc5dnRHZGMrSndwZW9kZlE3OEVkRTZvVXgrM3ll?=
 =?utf-8?B?MzdvWXorOGVWRkc2SXhNQWtoUlIrbGZmVWdiSTgzWjBkNExXaG10ME85M1dp?=
 =?utf-8?B?N2pZdWxHQ3lNa0VtaE0wUzFyWDB6UjdieDMvbU02TE8xdUtUV2F6ZHBUb2g3?=
 =?utf-8?B?V3MxNFJNZG1jUXV1L29CL2pyK21OSHNPUkhIZ2tzaW52bmlLMTlFMmNZZmVj?=
 =?utf-8?B?ck9BVUpoVWgwWkNtcWRxNDYwMDRpYzkyUlVBK20vWlVFVFFSQlUzWWV5K1o1?=
 =?utf-8?B?a2FXQWpCVVN5KysveU9NL1ptSGpUNmdHODl1RVNMelc5dXd5ZW8wUXZPK29o?=
 =?utf-8?B?WnovRStGQ1BZcm15TG5Cb1ZWOGxZcmlmR2NYVldPRnBqTyt5bFhobFlnendE?=
 =?utf-8?B?U3BFeklObk1YUU9ublVNV2lVOXZUdVhOZ1lRa0pQdDRYT043U3V1Z0MzamZ5?=
 =?utf-8?B?M1o4SzVIcjY2SXNuYVJody83Z0tDY2dQY2pIUVFZbnpJcis4Yng4R1NGRlJw?=
 =?utf-8?B?NG5qVmxmVW1ZVUxncVFKTmJKRy9EenBvODZqdVdtTFFtcEVYV0MvMHhFSTlS?=
 =?utf-8?B?YW9zKzR2OTFSenozT0hrY1ZXdHdWdmlDdmFYOEdkN0VGKzBOT25CWFBRamJQ?=
 =?utf-8?B?VjlaZTd6T0l3a2VSVU9ZWkdmVkt0V0xOWCtVWitnamVJeWNCQ0xaZ0kzT1dt?=
 =?utf-8?B?M1dOZVhPSTZqRmVGcnJOc0NoeGw2T05IUkh5QlpFYUZJQi9YRUllUmlNWU8y?=
 =?utf-8?B?cXd2NHFKZFRlRUFQSEEzdlJVaDd5TXlKRzE4cGZEYjFMWHZQU043N1BvSnRk?=
 =?utf-8?B?ZXUyZXlxNGRkQXI4VjBqUXlwSGtUQ2FySVZMU0xzV2JsaWtvNlI1REpTWTlo?=
 =?utf-8?B?T0NidEhzN3hBMVByOFgrdUYyd3cyNGZ0ZkRaWWYyQjRoNVFDOEtWbkMrdzQw?=
 =?utf-8?B?T251ZXVob0VZaUw1V2RuZjNiZVhFOXk5ZHdjU1VpUkNVYlRMRllJS1lTK1NX?=
 =?utf-8?B?QitHWkpNUGJiT3NBemxwQTJGR0F6dFZJVE0zelZveTQ0dmEwV3BlRXZla3VQ?=
 =?utf-8?B?NE82R1RyMzhXMHE3dk9RTnlGQmRBcklNYUFOVXlnU3RiTk9PNjBTeE83dElB?=
 =?utf-8?B?bVBHTTNMWStQaHpVL1VudTg2ZlFqdE1nQ1p6RGJjUWhkWENGMGkxNUFyTmdJ?=
 =?utf-8?B?QmFIUnZmanRPcllkOENHeSs3RmpJRHNMangzYXNRODd6MkR4eXFPZ2JzaDlU?=
 =?utf-8?B?eXc4OUhoVjdDcENYOTRqM21rSy9IblplRUthdjdSOEtNVDhwcWdWQ1J5UExW?=
 =?utf-8?B?eDBUa0Z4RnZueWtBSmw4OGRzUGZzT1haMFJ2QkVySjhLeDg0S0l5eDBGS0lQ?=
 =?utf-8?B?MjhwV2VuRGJnellpVE0zWk5PelVOdkRPcW9MMGVSVWhTWFZNNFJkUlRtRzFH?=
 =?utf-8?B?aTkzY2FEYnQ4NXpDdjBDSW11M0Q2TkJReUpJbG4zNWRYVkFUSzNabW11aXly?=
 =?utf-8?B?SHl4SUZsZm9hUXVoVE93NG82UUhkSnpBNE1YMVYxbUJKS21mU2UxSXlMWko2?=
 =?utf-8?B?blJzL3RHbkNCMjlQZFJCdFZSeDE2VUlsRkZOV2xtbjg0RStRRVVDQXRzZXgv?=
 =?utf-8?B?dWdPWGxlcU1nTHZWbWJhMVNReDBxS3RGYi9BbXNWcFo5Tm90VEY3N0pnNUNh?=
 =?utf-8?B?R0gwalFna1o3SlM2ckRjMTdQcjc2U2ZZd1d0SkM4YXhCd1N0K0dlMVN4U0l2?=
 =?utf-8?B?SjI4L0k4bmhsempEK2NLcDNQSmJNWlViUkMzWi94U2o4aXpXcVpFeHpUTFdV?=
 =?utf-8?B?MnJKdW12d3V0RzZQM1hBOHFROGZnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3e993a-f4d8-4f34-0b9f-08db0857f306
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:36:43.9086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o2PMF8+0qJWPc6EPp0EQH2je4+U8z3qrqOmH6OcbBtOzmRFANjES0A3BlbXhoN1v4g2hFGInX5OZJuWcFun1U4lY0atC3UHt0+fCGJOly5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5009
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series proposed a new devlink port function to allow control over
how many VFs are associated with each physical port of a multi-port NIC.

This is to facilitate such configuration on NICs where this can
be supported.

Patch 1/2: Implements this new devlink feature
Patch 2/2: Uses it in the nfp driver


Fei Qin (2):
  devlink: expose port function commands to assign VFs to multiple
    netdevs
  nfp: add support for assigning VFs to different physical ports

 .../networking/devlink/devlink-port.rst       |  24 +++
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  71 +++++++++
 drivers/net/ethernet/netronome/nfp/nfp_main.c |   5 +
 drivers/net/ethernet/netronome/nfp/nfp_main.h |   4 +
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 147 +++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |   6 +
 include/net/devlink.h                         |  21 +++
 include/uapi/linux/devlink.h                  |   1 +
 net/devlink/leftover.c                        |  65 ++++++++
 9 files changed, 336 insertions(+), 8 deletions(-)

-- 
2.30.2

