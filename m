Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B386DAFFC
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbjDGP7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjDGP7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:59:17 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2127.outbound.protection.outlook.com [40.107.237.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6719CB779;
        Fri,  7 Apr 2023 08:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGY8A0v3bVkY3fDOCGv+p0fMzkVuwcftV5aLov43dU8KYzdY4fYnZz6l19vD9FxvSESjeEJAYhQhMR0zd7e8W3bsOagtzex1t+P1GgUEi3uHd4bHl+WQ21N9MZm7aajfSAagg2qMkW0PivilLyISi85HB005g6fF8wKZ+NfgWbabU+A2KUnOFttlMq9gN4XELVNd26dEqxrOt9++c1tzt/T6gUOXMC3KU5KYimmnIBTzSXKHpqTedpTSzgtu0sRFhhoyx6AgIEQ65Rroz3laHe6x6eT7e0P739W8oCKiVX1tFAqOOMejlIep30oFUmsoH30SFDVI/qTf9NDyaLQEYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRfAawKQugkBywr5yMrozdNW8n9Pcf2nyof4AN5Qo+w=;
 b=BFoqWAJ/3w7sSs7+86l9X5nwm5QtU1DpY4Pg+cpxr8KnTN9yzX1VQGYimCWIzAx17a0OXmqpmcHp0XkUZ+hUxBhtihyjvJzY1LUJdffCXmOB2nyWHXSMAfgs8IRpOE+tuMkiRQQOPTsbL4SWsaLcIRGycwlASVLQj8fIzN3/uWgJt/1KhStyj97aPWzMx6NmhrXD8If+TBo7QwHlOh7ytxnD6BL2GrSp5Yp6GTo87EeZJvIPMVawF/1gRYaeuCX9elsmTRl1z04uO4FoW5vrKE7pz0oSDWKjMeKSSzsPWqtbQOAWmY2xd+bbyKzhi4zk3pwR7LFefB3gsyAnYghkZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRfAawKQugkBywr5yMrozdNW8n9Pcf2nyof4AN5Qo+w=;
 b=prNBEg/HMWoX+eG4l0D8gtCrQuL4lU0VoXNIk+FoKdI2q93xrQoGNM2cra3p2rDyXJ4Gd9vchIA9gGXGYQR2THY4ZxRTTL3AXicmC0jAgEnU2xSvLBsdXsTCUb8Tllt/kyl4KOBGKxNsnLwhmtmJFgxcoOi7yoJ5ygfO97w6P6U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4182.namprd10.prod.outlook.com
 (2603:10b6:610:7a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 15:58:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2e97:b62d:a858:c5af]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2e97:b62d:a858:c5af%4]) with mapi id 15.20.6277.033; Fri, 7 Apr 2023
 15:58:57 +0000
Date:   Fri, 7 Apr 2023 08:58:53 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] regmap: allow upshifting register addresses before
 performing operations
Message-ID: <ZDA9vafqY0j0NhT3@euler>
References: <20230407152604.105467-1-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407152604.105467-1-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: BYAPR01CA0053.prod.exchangelabs.com (2603:10b6:a03:94::30)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH2PR10MB4182:EE_
X-MS-Office365-Filtering-Correlation-Id: a0cb733e-ce30-4101-c40e-08db3780fe6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dupn1BmEnGczmq/ue2aEvmAILAkTB+zLZKkltCRPCsx5qBLEJEDCM5f1CePAlaQ8s/yjcxtb5g1gsIIqc/4C2peGzK40LSWLWzU/qpODebviJURxpEE/r0mVXqRMZ8YKq+AWDq2nU+6M3nvnD4vNkJdQfM3HQJPwPnoshwVBCEvPjxSgG8ocHZXKxsbSFt1kSi/N5pXdvOkjH65hZxyLZgKX9/lg70LdhmR0qNg2e9IpKOtTYgTjvm8dn96WSMt0H7pTt6AJZ6miaYvJI8yhT3QJ/cCmDdauCu96pMJh5M4mbT1T05+Y31v34ASkdjb8oP9tvzrBxGaZwIikVyWgzdWM5Giz05rErVWj2K4icErqDRmOrYNXskl6YUuCf6M/HmOM3YHiMaMzNSVDtAgdpFxmK6tLTCuV60KW76b4cfHthI2CCBY6tssmcUfQBRzBQElCeWzTHy7wKLL3X5Nc0Nd+Rrdp4B2/mISGxzcDV7u56AmFX8Uhezn/IOTBRGyEvyi4rUEdgXqcw9xatzRGMQi+lH2l7xw4l3IEMC4HvUw/G9h467OPdqDTAj9xurui
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39830400003)(366004)(396003)(136003)(346002)(376002)(451199021)(6506007)(6486002)(9686003)(26005)(6512007)(38100700002)(41300700001)(186003)(66556008)(6666004)(66476007)(54906003)(316002)(478600001)(7416002)(33716001)(44832011)(86362001)(4744005)(2906002)(8676002)(4326008)(6916009)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oiD4imH+ANPkEThXgeXWDdTVLnd4NLgW2g5+nvUcnvnjUJ2cK4oty4Wjox+d?=
 =?us-ascii?Q?bkvrpwnB0Oq/BXousoEWkpDccTi7PcmXQt3viZjGC++r3xkKh7XTCFgmozwS?=
 =?us-ascii?Q?TbKuwsKInJfg9RKKi9mDoZKaMziDzKKNxZtS2vbYFpaBNVcraBS+8srGfXyk?=
 =?us-ascii?Q?eJr9SxnMGPBy+cvTiLKCaeh4V7IbqEyacih53CSQebGhWtdeGmjErAHs+o6A?=
 =?us-ascii?Q?x8mPxEq/tZPQFL7Dkz3ozWZ9c3vNu3vXzyzxh1YXXAGhUc7E5SSmwmvbyoF/?=
 =?us-ascii?Q?otE4E4tF6G4tJZa8F0n1APuF87LC0/W3E1CRvohwCAtTfmjN6Kkq0fjGHJ65?=
 =?us-ascii?Q?x7RFJMoi74houEdf7qHMvZU+GZO6g6CgtQcn0byT4f8bVDMiXtbR/b0GySdj?=
 =?us-ascii?Q?6qaxBGtAEfUs8xdfEh20wIXJD/sGpb05q2UGxeJ6vPCHCngNRkA6G7n76QR3?=
 =?us-ascii?Q?myQoc3Hmaw1dpNcXFoqQvooL2klVypJCAxE1205dVFV5tfZtF3WxS0qbKZg0?=
 =?us-ascii?Q?UZLGiQS4Rmg/9KuU/bCabyTXUNyaeuaRsuyEOmEgcJ1a8BHTfSV/4YNd037J?=
 =?us-ascii?Q?Z6C48iDvfaeZ5H8zkjNx7Fm4TUjbt5khMz4EIxKo02GV30/ezmMne1WGzv8L?=
 =?us-ascii?Q?+WQibekvTcQk9VH/q+rsoKpqLE9dLf/GzyFq0W/nsnZL3dKsaADzzVNDTwNF?=
 =?us-ascii?Q?xj75RFz2WmI7pXNW3g4rExAOBcIkR6wicu+WFKPUqAShkPtjo1f1ycvQVT/f?=
 =?us-ascii?Q?aJGXEOXqBwL1WofZ7UC/6RYu1GKC/6bRAcs/cPdfQRJwymUJhaCRP4a5Ivax?=
 =?us-ascii?Q?kSUlU+jKgq3V+YN+/EluBVSqtzA0Ypvuv1mewJ3OTI2UG8U6DUOh+7Er9ifa?=
 =?us-ascii?Q?/SVWUpAuu29klcY00z2Ww8SqZ/ulUB4gjXQvQWBlRQa9Nazb9iPZIT7Ffc3r?=
 =?us-ascii?Q?glIUKqnz+13dXw/BblNkugpt1TBMxQKAVfTQCcnGOzf/zMkzI3nSeHUa0ozk?=
 =?us-ascii?Q?2/FjyiVX6Reqyy1ADH+Gg6fUFpNbx60loaa1UYm584e5SFZ8y0YaaXKt5Ud7?=
 =?us-ascii?Q?HZcWECjJ594aDJqGze/TpUiN+dXuh3U+81mvjUvrmdrC09p46VP/uukrPFVF?=
 =?us-ascii?Q?wG1ayfmoe/nz2KaSa8SiXdc9N64P7ZpxQLDLoaFJZOBwSwmgBF0pNfojp6Lu?=
 =?us-ascii?Q?OI9lPZLlj4BRULhLXFMajDul8MMnxwtZ72Cem6wYfnlnPiVwpzu9t/vgfcso?=
 =?us-ascii?Q?CjQHkE5a9Ofbj2zL2su/ttLLgGZbkEhPaW+EYP1JF2rejGXP11WkBBN+0x68?=
 =?us-ascii?Q?CCFXDT5PYvOTk2Ijf45iHQBCKnsnoZp2snl2FXTDw4eUbWQu+LxOM41hjdlO?=
 =?us-ascii?Q?AutcldijOvDMPyZIOLkifttg2JhnJ0wWhEc/OK7PlLnLJOLDE0JxdTa4OwIJ?=
 =?us-ascii?Q?xkbdec7UB0TkApO7GlSn/R/n18kGvd/C7KBL8NX4vOBWOSmXHtd1XmpZSOEN?=
 =?us-ascii?Q?i3mISG69cHiz2fTbYmdcada1Iv1e1/4n70cJwj+gG0RPVatJ7AOmPeq+GGgu?=
 =?us-ascii?Q?qn2QBYxCDqUhPc08b6MLSIQvKhnbeGvf5HKfVKUkCC9pG0vZ3gnS/xbZMje0?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cb733e-ce30-4101-c40e-08db3780fe6b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 15:58:56.8997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9JflbGngTRq59g5w+ZUzK3QyRqjmFVCf75ssPxiOqUE7aogDcSQmYzQenBOUeO6HgqjE52tbZNFseWjMeClrUNeX6wQ31zMBxSyXx649uY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4182
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Fri, Apr 07, 2023 at 05:26:04PM +0200, Maxime Chevallier wrote:
>  	.reg_stride = 4,
> -	.reg_downshift = 2,
> +	.reg_shift = REGMAP_DOWNSHIFT(2),
>  	.val_bits = 32,

Looks great! Thanks. I tested this with a merge of net-next and
regmap-next + this patch.

Tested-by: Colin Foster <colin.foster@in-advantage.com>
