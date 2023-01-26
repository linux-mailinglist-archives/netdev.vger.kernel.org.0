Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC4267C4CB
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjAZHVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjAZHVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:21:35 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2092.outbound.protection.outlook.com [40.107.243.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC365E52C;
        Wed, 25 Jan 2023 23:21:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGr2z6ysbE0KccQBd6YtsVJib5biIou7dbLVF1LJEmojHtQ4amOU5NWA/NMdm0ye7TPoMgmo/moV7HqdltgBeLur5RSeyAjqHgdn9nATGEaAOWSomlKDW+5Fagi/Q8K45LLSYKu34EzR8sD/iNh/2+lWFz1UeH7DzvbzLU4jeymkTEQ0BR3ihd1Ywd1d0U5IdQAZTS6iAqrcbO7kNZomjCTUZyg7WeDgRSb8YuvunC+QjOAyeU8GrgiZicj2C4bb0DGpqHuxOIbG0uhIuT0sbRjwYti0J805ROTZ/3cIY50ni09kmoVvyvLp6DUuHs0Ag/SH1DSYBGfAqlccxwWUHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYkWc+rnU/SNzUaCIQB0O2M+CSLSJ3ATWvUlOU/gBBY=;
 b=UJM9v1UPIafgqd6JuUwTIDKec/3H5kCSvy2GjyZx3r1zZPwagnlDaJNrCLp76jibCL+DKWTqQoIshxtjVVrcA26nmUkz5cnwUSsJudddCICiOVdvm1bn2a0rKVxCPr/YVw7jPGUd0Zkl3tjFcJHOia5ojQfcClu02x34ZWsF3DWYmHLZsInNSHopw4R6FD0fRaBTNr9jqIBri6/mJBQ+ORiQaH5zcZA+xkkNyFHrdCLaKOHzi8ki9Uf9h1TYPD3MsL2UkhXaaFmfbDxWEiYymNAHYeyND3HCWuv5Iil/fx8dnUAEIsZbNKXyKRuM41rFjj52SVCzsu9ShVIcLGSBNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYkWc+rnU/SNzUaCIQB0O2M+CSLSJ3ATWvUlOU/gBBY=;
 b=pShNAH1yrlSBKQ+fVIhvALoPnWId8j+5UB5QLSkP5CWArwpgwY6ALmes6t9X0yOOJUkt5vp67p0kocvohbDES9zpzUnQ2n0Pqdxh/MkPbC01nLZtXvxm4Xp8DoVG1n0KMMX7Hg5aQiXKPqT04XHy22D864Yg1iFhDmqVHm51fiI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4486.namprd13.prod.outlook.com (2603:10b6:a03:1d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 07:21:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.021; Thu, 26 Jan 2023
 07:21:30 +0000
Date:   Thu, 26 Jan 2023 08:21:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andre Kalb <andre.kalb@sma.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felix Riemann <felix.riemann@sma.de>
Subject: Re: [PATCH net] net: phy: dp83822: Fix null pointer access on
 DP83825/DP83826 devices
Message-ID: <Y9Ip9Ikluruosxb5@corigine.com>
References: <Y9FzniUhUtbaGKU7@pc6682>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9FzniUhUtbaGKU7@pc6682>
X-ClientProxiedBy: AM0PR10CA0086.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: 05f8462d-6eaf-4aa1-21a9-08daff6df1f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ut0JJy7piuCnSGjyoZN7x47QG/ow7q1hm1ix9RA0MsoIVRuregxWE4z5LqdTgdFJX5QqklGN/4g0+p1sOjPNpH6dLNJ87Dpbr9GJ0ZHmXjvSMEpiAw4hR0XkazJ0i5kbU8/DsqnahnJHx7TqaGJrtFNGhkJKq0oYuICRWA5JF33Crf9WIcsn/lHPL1M416VsJNkLPk6gOKNOdbqeV7KSTurMzItS2y80UWc1yy/vEtyEYfzY2iMPv5UBtHDqoNv3c0W7Mhq9xv9vICELLwW8eNhmsgJtUcySZFilUOdzoVf9WPSG24lGHsL1dKxYJ9CtFA5rpWcS5meUR/XrSbqbyfHO2TmX0Zk+x3+4vbfz25u5hFqy5AVE6wLU2sDLZRoP2RFwBipF8iHE1yI1eMlJlMuk+CPIOGyLW5e58puakqmvVhOzlf/56AQkWFhu0L6EJSbxNDq+5AzANW6vSO7hBnGfYnyiHtbaEJ4bgrR5L0Co/lRh13ifl3ylT9AYBomlxpgjCCTHDwXXTpndGlC2ptvw1tpCI/ZY542rVCGe1v9fB0Hvig9Vhb7qtvr4ZZPucTsHN0bIJJoEcpDujCVqYknRDHCiQnpAZ8oR/ijxITyPL+lby3JGUk43NcHGs8XgEXv5IhirFSkCaET6zQsUXCxdg7lpXxFGmLB8DdtMNRXC6X2S/nq7uCjusp3p9K+/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(396003)(39830400003)(136003)(451199018)(66476007)(8936002)(2906002)(44832011)(4744005)(5660300002)(36756003)(66556008)(41300700001)(6916009)(66946007)(38100700002)(54906003)(4326008)(478600001)(6486002)(8676002)(86362001)(83380400001)(316002)(2616005)(6512007)(186003)(6506007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5WludPu/JoGTkmUO+HCpkw6cF9G0Dy7gxMVrS1NnsprbRRDLRD9ArhOlhL/F?=
 =?us-ascii?Q?y51qjVYi31P/23W2CWhDTuITYCPm2CHDy9+Ls7kIOhwjHDEvSJF6OFqFYN0g?=
 =?us-ascii?Q?kDiMAD8UBk4QQCpA5tyZ99bpXrUE6fD4j4ZBIOEbe1PmM389e5HLbBEHC1HR?=
 =?us-ascii?Q?Vv0t71yfAkPD4G+kOMQ4gio4Srko/QUniJRGf0DD9mNiFzlFILlDGsF0MSTk?=
 =?us-ascii?Q?g8wdBlEGh29w5/QrvjTT0bcmU97dOi9W8U+h8RbT9I4IfB9KHZmH4iciJYaP?=
 =?us-ascii?Q?wgI99+R8ythcmJ78hGYoj5kPlVmac9p80yRzydVOQIOx2kpiqf3p2O7fsjyW?=
 =?us-ascii?Q?8xCDX8ppdQbGVah4fRqWXUPtwnlxHTeUwYcD8xH6t29uAXfdTYPjjKFOoWwG?=
 =?us-ascii?Q?f65V723aNXGxraRhPZN5od9YDN1rzjte0tksqEqC8Ly8twVcBUAEJRWlp2SY?=
 =?us-ascii?Q?2cP010ecuasrthYKWUQ7pZssyH0+39lFB8FszBD7DEJM7F84rk/f6INsbZcY?=
 =?us-ascii?Q?Faf859bNZir+vrAAB65LY7WWoyKfMtLKzMOTqM5oMebw7ojpxqLI1/KVnip7?=
 =?us-ascii?Q?v6+qJ+AlYjXY5EwOuumTLNNt7cLPJoH/UC9JSFiktCjXpFFC6M4/OSjNhrVF?=
 =?us-ascii?Q?9qysuJ0QrkVwoDLxAVPUi66UwFfGjeMDlGbpuEpR6jnOfelPlxbgsgEURa0G?=
 =?us-ascii?Q?I8P+y0yS+TknNC+yALLt+4HDM3Y/fUoOMNd/P2KtonER426wkgjUZ4uatugr?=
 =?us-ascii?Q?uCMH9wd+EwAV6TLEdk5tGbEiM93u1AeMZDYQJHagxHNdOKkZOyXA2E3c2zur?=
 =?us-ascii?Q?+rgbkP6zRTwvp1RC9Vs7OYKpJjDwxbuQ6f20ZUtJKFpDMwbiDI0thMnukesn?=
 =?us-ascii?Q?uUR8zFhvnTMggc+7HanvumjwIR/n19FrltNn6GEj3tpgBAmAmdgy+eBQMenY?=
 =?us-ascii?Q?Eo4Bjy4qvN+nzKugj7D51y6xeDgAz+MpEKu1NmU8DKEa+zGOx15Z2aQLiNAf?=
 =?us-ascii?Q?9N65PIqk+o4j81KDS3hPg7RIi0AqTI1ZTyB9ZEzN+iTzt7RWoCuzf7+8T4ll?=
 =?us-ascii?Q?UgFz+/CUWYTY6EwKIS9EQI+31CDkoyBNgpwyA6+YeVSP/ExrS37OCC1nu2x6?=
 =?us-ascii?Q?v6+ZFgeDoDabO/8E+QfnaPAFSuG2Y5LxmpasmXmmaxPUgOsNopyMZj1oqyCw?=
 =?us-ascii?Q?ole5czODvlFThwpV3JgAT7LaaC+aNu9/iTJPJisGmRk58TtJLFhGv+AHdj2X?=
 =?us-ascii?Q?DZDj+SfS8ikMvjOEIiDOIs/S1+sO+d1fn+S6oBTgQDqUFxPj0+A4s6XfprjZ?=
 =?us-ascii?Q?e4cHNTkbfyQij7agGixNypdEHvS5ofPDOzT/Ewb/puyz2qCilZEZvGOHsvEb?=
 =?us-ascii?Q?F1isSmXCoNcAM7CbEN3qkH9T5kbDWdGmHGR7ymYRx4ROMdVabdXniENCdKdq?=
 =?us-ascii?Q?YVYjjhEW+1ucLyy9YNWyCCe+vd4jLNuItnhjkg4ArxG8ARZV6HxoIJ09dqjD?=
 =?us-ascii?Q?99A0g+WWDDtgeUoE8F9IQeEpHmYjdHbyV3738FnpWy+F+pndzEDfEI3Kw8hF?=
 =?us-ascii?Q?dgxEnLPBsC2fAgZ/HkeOXOQHqkiuYODYBDpA7rwt43KjlXGdy8Wy99g9mlsQ?=
 =?us-ascii?Q?2DFIiqUG3AhgxWq4DKwd6lFvFuJkUmQrjzuWp1VZpWbpkXV5pGhT7ZaTo5ry?=
 =?us-ascii?Q?CvV8vA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f8462d-6eaf-4aa1-21a9-08daff6df1f2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 07:21:30.4697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3UMHteiHrJT4BaALxe6L1XdafE2UPGasjFiNNh/vdVtl91UVZLmmnFq30w+Kf9cWJ1pNCdy6FsufbHsEzyyRjhFEA3QXHQuhtHj0S/Jel3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4486
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 07:23:26PM +0100, Andre Kalb wrote:
> From: Andre Kalb <andre.kalb@sma.de>
> 
> The probe() function is only used for the DP83822 PHY, leaving the
> private data pointer uninitialized for the smaller DP83825/26 models.
> While all uses of the private data structure are hidden in 82822 specific
> callbacks, configuring the interrupt is shared across all models.
> This causes a NULL pointer dereference on the smaller PHYs as it accesses
> the private data unchecked. Verifying the pointer avoids that.
> 
> Fixes: 5dc39fd5ef35 ("net: phy: DP83822: Add ability to advertise Fiber connection")
> Signed-off-by: Andre Kalb <andre.kalb@sma.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
