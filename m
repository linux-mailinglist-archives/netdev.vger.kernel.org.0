Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640CC6A2AD3
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBYQoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBYQoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:44:05 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2093.outbound.protection.outlook.com [40.107.244.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F75113D8;
        Sat, 25 Feb 2023 08:44:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0LBivdZtftmvX7peg71us0CJsX9slvcFKqfErQ9GWTmehh7rLGk3LedlQhsLtVvq5jIkXrV5EhQUPa+II0rNZq5iKVHAoSurkv/Cyd29LOCCiG+MI1JObVKxCpjD9yTmugoopact7jI/mWXWCHOfIMXrSao/XofVY3bzIbTs7pHLFAeSCYkOOvF+zSOh641wqxHioS4vektwyCBOnjZWx49hXVCCZwixHarCHjvyKwcU6JRpyC65+p66hR+DdiJz8ri08ZGQTygxAktj8nsKu+OoTAz8bX3mSJfmQ4zrUKoK3N5SSi6mvsdAaxsNvVWHdgIOMduPHbPLT2nnSPyKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nyYso3dBQrKL2Aey5BAJJGrU2cNPPKFLhKO8SQ/cYuM=;
 b=Esz/dO0Dqoj5rCw31fftJS1eVQmUdw2WuYMFg+/aYPSaHG7V+SqDvAcSvHd/rIVe76r2YGPoBCK6cS+5UYCSfhPm+edAXvxxtV5IAP/2U2hShLlGuTGU9U3GGv/gqnbFYBZSHOyFl4NtZQkXOmAOJh/GUwa6HlNJbZRz4Dkxeq8C8RTbPUmjSMhDzlh+yG+X2QD7mzEn+7L/fxbJWUxAO0QL8/ubP4tCDZtI+QBGcvx19vYXdaHWmP37gUwCdm5snleEZzJqDhBy9ZOWu4M5PZ3GxMy0BCl7hdaRumBAMxEv/PblJd4Ljg0Kpsv2MFehwGGigt2UJRzXJy3LdMdm2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyYso3dBQrKL2Aey5BAJJGrU2cNPPKFLhKO8SQ/cYuM=;
 b=sM00c5FA+Kg9D3eHDFjM7XzmbFUb9R2AwExxJwlV/5/pKVOzw78vM33bEtyalsKJd5/cvWHL6yc4ey3NCu1Nsv2nKXkaRN2hYrFzsXzr4vQXiOOxeS/zwKHQR8BWXK/lGsUXlJ5IPlZo9uMmXOWesRmJgz62pNPWKqHLmD2Oulo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5682.namprd13.prod.outlook.com (2603:10b6:510:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 16:43:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:43:58 +0000
Date:   Sat, 25 Feb 2023 17:43:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net v1 1/1] net: phy: c45: fix network interface
 initialization failures on xtensa, arm:cubieboard
Message-ID: <Y/o6yLsGbwCEFil0@corigine.com>
References: <20230225071644.2754893-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230225071644.2754893-1-o.rempel@pengutronix.de>
X-ClientProxiedBy: AM4PR0501CA0063.eurprd05.prod.outlook.com
 (2603:10a6:200:68::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5682:EE_
X-MS-Office365-Filtering-Correlation-Id: 2209c3da-7de1-4318-24ed-08db174f7db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGTyRjN8PhOi/156ZQu7xvNlyCC4mVBfdC3YAzwdSffMQBiTo4Wz6SbquHzYHLZ2FxCfafGiRud9fl+1/Zy3zzzgU2O4IjfMTP2Lb42CLD74iTIoAt6CWzeSD/aYRc1d/+hYNDa7kCQXxqYwpwh3AZo+VF/CCmDza+/zaI211q/QFgjtdlKiqQkdzE+VHTufOjvJnlwNHZdob/NE0qPMqjGZRNLmWKfHV1s9PA2PW7MzFn7pQiJaAKIO3B/TzXxycDWcBN3VDvp6V38CpAOK2IZS1GeBOB0cKYSOw7vvdLZ7XLPc/Q7yXU54vvF2A1bXvRivQ7olA9G5RVQFHK+Su4sHGAsi1KY2Gdn66C92E6Lq7F/CCicq2tR3Fy54T5srGP5qHUI8HvVavYoyNHfGXd2efd/bCbSmvPwEgOdje/tz7uPKHHVLOu1r0HulexHYVtQ/5Ai+XsC0fLQLdOjJUP8EN2r4h7uRO3dPvKo+8HkqGoKsPvJKD67IAR/BZaYvVjd+IUlFzmydA0fEsojJYhDe4WhRxpoFMRA4EFiIk0yYRuLpE0vkGswgmW6cdywAEszL5/sNHtN12bdqQWHDIAr0rc3pewhriClaq+03DrgeUCEJ+eQPvIIZe9xL16HY8RE5BdZPhifT03hxnS44Kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(396003)(376002)(39830400003)(451199018)(7416002)(41300700001)(8936002)(44832011)(4744005)(2906002)(6916009)(4326008)(5660300002)(66946007)(8676002)(66476007)(66556008)(6666004)(54906003)(83380400001)(6512007)(316002)(478600001)(6506007)(36756003)(6486002)(186003)(2616005)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S8vVcfmg0WzG02YKcpT7GPLllfBPLrtsyIUzIINYUKQgx7lNS7XLZl+Uz0UX?=
 =?us-ascii?Q?z4c0g07lMxKXs0jleyakUdPwG4gNlH5OMXxCxJch0qPbORxql6O/i3j01vqN?=
 =?us-ascii?Q?dsJO/44FAyzcd8mo/DXpXlDXwNgO4ClAvfdDtQzdwZ25CuM+tYsOZye/vMRM?=
 =?us-ascii?Q?U6HCgmR7n9WaxkRHBLPEfFE/w8vdUfKv73J2WfkRFrPzB5AG3Tb7NPKBL1K3?=
 =?us-ascii?Q?Cfvx+Anm6ZxnGVMZ8PVXOW65tUmLwSK7fp/OCMIu66LyNf6sIcpvnd7Rcn6I?=
 =?us-ascii?Q?lkrcNkG98IOH0VY+JLmoFJplXw10BprNgcsU4osL6X0YKRE12W15UOsxy+1b?=
 =?us-ascii?Q?WWnqEJC7ubJ7gAubqEfxzwsJrcpWBPJNxCMYJ+EemBOZ/vbbn0nxdYwbZnJ/?=
 =?us-ascii?Q?C/Ts1aE/F+7Y9GlVQJn7L5SxkvvK36JEpzOLW2AAtdWBLwHrEZsn/jXdoQFj?=
 =?us-ascii?Q?tK6k8noSbbT7tml1+Qw+qVjHRV5l5GHlpNvcDreGzjCdoUmq/XpDmN4M+P69?=
 =?us-ascii?Q?1OomBlu/fcjokW2SiZVmukcmM32B6ZVNXoxa+fD5eB6NYVKzKHbXAXNmF15g?=
 =?us-ascii?Q?J0ueY2Ro1TRbzv3ifEEvYropTapwzQ2R8JtRBJp9pW+nGez6Gxul++NvCZaH?=
 =?us-ascii?Q?kHZ4mAjm4evOV/ySc41x0IXN5k+0WuQM0c5TYP7mM296yiVbDbWxraQ9QGvN?=
 =?us-ascii?Q?FL0u/rL2DI40xyYcn0cFnwSYnt1cBoNBW+0fNJnUX82fI0Z+eLHb5q1WS9ZY?=
 =?us-ascii?Q?yMJfHkfeFKRYRBjccrh2UgIDoWgbcc91Ls5WL66pMBZWls52ljKGA/h25O9u?=
 =?us-ascii?Q?t44TEA7ltdNOQCfuMKzpRm2j47dkY8h3S9XCRkTd9VCnHLpwfM5BrnGve+hN?=
 =?us-ascii?Q?ZLtH9SOJuIi+vsAuMLsjJuEUOapGVfrmPUG3m/Qp+NbVaencl5K2+EFKz+Eb?=
 =?us-ascii?Q?HMjthIKzSEs9pmCLgrKXjsWXHo83Q59W8byTT8sz7MFOXfrMZLFnnUncDrXE?=
 =?us-ascii?Q?VS1vVKqm9l6oPAWI3gZpLrTeR9irSdF+YHA4E5vXG49MMqc8BtR3DMY3RCJZ?=
 =?us-ascii?Q?y/QmZpJX2jSnlLIX/szRcaOr9wZNJwWy9iVtD0LP43YOMOWuVDViTbBrGq8t?=
 =?us-ascii?Q?oFFoCO+OaPe66inBvF0Emg1I0BN48djpACjIpb5qFEWHcBGRRdFdnSjoLQv3?=
 =?us-ascii?Q?SspwY5r6asRT5+o112uCjXx2T+rVDKyGkhCIevBwNMLeWkjECr+a19gZzxCI?=
 =?us-ascii?Q?jSQk9k/YY6VCkVEyHlWrCEX+uxT/8gzAX96U3p8Jq9X0swGcM74x/zkcEN64?=
 =?us-ascii?Q?/2oZgI8s68dX8bi8kWyWnL5QLBwcQ1fU14qVnYyu0gqGxaeH+yWoZAA13PpG?=
 =?us-ascii?Q?VGe30OX1uQUEntnH4vf/PblkGVlNMfK/DYzM883Pbahzdi9WOzQ5uqVU0ZQx?=
 =?us-ascii?Q?racJVhmpeuATyuTodsMXFThIaTP0DKJ1tNBDF/SweioPAt2WNc8VhQH4ugJz?=
 =?us-ascii?Q?IrNaZEGLlI4N5RgKTHSbNrK4GeGOri26yUmF5jmyNzfylMiiK4GL6IsphNOx?=
 =?us-ascii?Q?uwH2hlg/bVYqRhlOFxgOKLdsUzKwgpEVgwT2rPeBQC6IqpAFl/BPvi2Ou2sz?=
 =?us-ascii?Q?49VAKGIF7LGCUsCLb5GF1duB0KrO1k2XGp3gZ0anXJi/xTcy4HgRjiS1hsjA?=
 =?us-ascii?Q?2Rnkwg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2209c3da-7de1-4318-24ed-08db174f7db1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:43:58.4329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RwLL9O4vGoFUv0TGjRuVv2LqhXeNOnzvQkuh1QamOy2K/kk42Q/j5WuXbsm2qDSwsGufk8w/uU9kWlvdpKpJS3LJoLevTpf5l53a9tyrKHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5682
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 08:16:44AM +0100, Oleksij Rempel wrote:
> Without proper initialization, "changed" returned random numbers and caused
> interface initialization failures.
> 
> Fixes: 022c3f87f88e ("net: phy: add genphy_c45_ethtool_get/set_eee() support")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

