Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C694B9A76
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiBQIAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:00:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiBQIAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:00:04 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2090.outbound.protection.outlook.com [40.107.93.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F1E26550E;
        Wed, 16 Feb 2022 23:59:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQdGcz+jz1hACqDIoeZTxyA7eRWUSNR4YHRWfqR18lz6cupW7X05Be/LyzZnMWR3SCuihOnTzkvL/yOFtClt6Z5hIOQNmXJelVDHlSB8R4XBlNq44RqnKIFDfzweWIyBgkH++ibb89CYdWYxjaRdTcRNqRSSr3v8pvA5TkPFwFSGnxpB/vYLWkdcCIk36AkeWJAes0vkJ30rdaynPClBTZxDye8czCuHr8yzFeWPtxHwraaJs0I1fEhPKVlG2DNEnVCKRbbQrhLujzR9zeMYOI4M/ygpdsBwlPn9SK3zOCyahsA8Uk56+ykNFk9kXHRJ1wsKpZadaRsU+HdBarqNmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGRu1MJIivbIGrOGbOw404DXfTvc3Xhpmy0OMZ2xOtI=;
 b=lRX2SWolCl5fCgMrt/qGfnMI3NoVpfqVVKJx23Rb6G7Ora89DPw5TAVqadC3YRM3qsHLZpYrk2vd8YpluH+hoyuI/pCI0DBaP2fhBly1tvF3uzDY1EqujSYlps2dDo7P66dTQUTl59erk6ybaVsgbW4KZ0vR4Eez8eU4cB94NOsD4yf3KyuRar5h4wbazfJF614sZCYr5B6x9W1NWDm1Qn0HdPSwFRp0EyRzzrQ+6dRzfFlacGm1DqTyD7KCwL+jvpxLsa3ZWphy74UOVIG9DoKs62ZxTXflQfEXOJejHykxql3r1cw/7QVhemxQkQjF0eTmStoAZ7rh8x1DByX5YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGRu1MJIivbIGrOGbOw404DXfTvc3Xhpmy0OMZ2xOtI=;
 b=WDbXBGrodjFfITUS4ZsFCb/ZjNYT+zWdLMOSx93AoeCPvD4JcV11PosY0B6ysT2vjSJkEYInpVrkwndAbpRIYeQLWNrNbIxvnDZ4DrqU5RWEg/oFYHegXSCes96WImt3sc6GWRznYHPjSSlAoHTz1MhLVtQ/CDr5T7MsOWoXnXQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB1843.namprd13.prod.outlook.com (2603:10b6:404:145::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.7; Thu, 17 Feb
 2022 07:59:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.015; Thu, 17 Feb 2022
 07:59:47 +0000
Date:   Thu, 17 Feb 2022 08:59:41 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] nfp: flower: Fix a potential leak in
 nfp_tunnel_add_shared_mac()
Message-ID: <20220217075940.GA4665@corigine.com>
References: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
 <20220211165356.1927a81b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211165356.1927a81b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM8P251CA0020.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7387fd5-388e-41e2-11bf-08d9f1eb7787
X-MS-TrafficTypeDiagnostic: BN6PR13MB1843:EE_
X-Microsoft-Antispam-PRVS: <BN6PR13MB1843B40BE1D6B2F4E8FC4A16E8369@BN6PR13MB1843.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wz+q3OCFshBIT3TdPvVTk46KoxH3aezAERt0kqOHgHllzFg2WPnOHSD5g0cxs/1CnufXLsemveNq5uTkXOMSPLMo57lBeYih9vs0diYNw6oifvoB8Epwf1LU5dylM1R/OWzEqJc7emnV98Ddo+pKvBdQAt5Hwd7Gg0yfCgBHi4lvoO2GKlkMavUF3iW8L8EbRMcWH4qV3ktsArLwiLFAy6ZN2x+YbJJXO3y2N4wqPBrctNtcsT7H4uv9Leo8lZC4hM79l9tAjYObhSlftH5Kn7z8iEgQ3QvZoLDsBZWpJ90zt1f0ML/DUFlbjoW8r9qX/bA27exUMK4e2UsHd7pnxSXk/94kwRwo0xyL92zelgKfssPlvs8BcvgLvRTFHZmWI89x5zD1mwim2TyRc2Yp86EK3YpBsKFAFv6FEFTSspPHTW8zFocRaOvd6RW9nVgz1sPDTX1D/VqufN5Yjv4cVBlJMbbg3Bl7zUVJSRM9FmQ+QrCa4WGFrxy+W8gNGcVeWxrbkSXiT/gRLo94sI8H+EQsM+GpvjMhWydtx/W9FI+czpHCF3iNfaHG+g+vMm9HGlBAQs4Hpti1GAF57kra554BRJOuVaKai1D2hroegCkESxyP1qoUjLg8ASpN8848tHLZC2MkKydfxA1imPILyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(396003)(39840400004)(376002)(346002)(2616005)(6666004)(8936002)(5660300002)(38100700002)(6916009)(54906003)(86362001)(316002)(36756003)(4326008)(186003)(66476007)(66556008)(66946007)(1076003)(33656002)(8676002)(44832011)(83380400001)(4744005)(2906002)(6512007)(6506007)(508600001)(6486002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C9QuocKtoM36k4dtoF2yybEBGwrqoWr2di2fP8VHMmT/osTDlEBKlOyi3FR9?=
 =?us-ascii?Q?qFmGRNyDg045Gv0ZnEahIGEC2aq29/XChB6cmGFlK9LvFU8XYlKNRWJDMKGz?=
 =?us-ascii?Q?bgb7vIUcnkYpsObjWCZpPfl/hhn6Rc6MjWJc2i2KRPESn5abhwgW0Z2PqKoc?=
 =?us-ascii?Q?SY9V7dAG+6w+8KaHjpnTuTEv7Wyt+BxU2UAbNiXorSbjjfCrHXQOJ4l0WGSd?=
 =?us-ascii?Q?XjpO41kBSd5muO2c8pjyaRo9aM7IwKd0LfzQrQ+TDWMoVv86xZjHzC2S39oo?=
 =?us-ascii?Q?lIYGyw0re9slGTHji7YTYL8puuRZq/ukvkXur/IqUZ1kEugMmPR1Q0ORznUu?=
 =?us-ascii?Q?qsbCL2Y2S4juIh32iOpn9xENmbbXcWkjzacverm93MT/5KuL/OFOIKW6G8We?=
 =?us-ascii?Q?qI0I0NxnXxfwJYBnOgriTFJMb3x1COZ3kFR8gOSD16gLKy37sJfeOr65dC8V?=
 =?us-ascii?Q?JeXlRYxHzzGRyKQi8oBXoCMq6p5FFK/HwOuhdRKSsjrJYJYT5w9WgWMWcWss?=
 =?us-ascii?Q?SAGADLpRJPJSX3Tt4gMuzLSqaOFgptWXU1A/gyNAllSn8N015YmP1AdA1YdS?=
 =?us-ascii?Q?ekmqxz4CjaRx5swXXOgfo9w7zVOVDgiSOzgtDDheGgw+LnywYrgPnos0sXee?=
 =?us-ascii?Q?+7Kd05lVuD6p5XBpGoO9kzNXehwjZ4QCGQhfr4b7HYcvkgRbvBUY6eDXAorB?=
 =?us-ascii?Q?cyJfjITN6ezhWwq5VbXtEJjwiHm35YbpsuONbK1LRyfLeW5+FURtuCwtA2/T?=
 =?us-ascii?Q?bIpLMyxSsLl+eYtHrd87McF2mdZg03skInLpCMbm9fJMA59EwZGz76Z1TaL+?=
 =?us-ascii?Q?tRn5nyrzfXFoN4Y2zQrOhxqBtr3OuEsbHAX763pywA8R3nqzBPuOXDt8umxa?=
 =?us-ascii?Q?xkPlccJUKKhpGKtgEPaSh4erSt2jIxyNRMYjaPq3U72HCk1eGA7gUgk3yxMj?=
 =?us-ascii?Q?7y9mTr02UF4UC06IbdNFUdIeAYycHBkq78q0BeeMRZ4Wyoi+uIRFj2NAWtvv?=
 =?us-ascii?Q?CQfIFJisxMkUs1VgI61qhOu6SKtw5SxNFpOhgZOCTfzO4gsYqQHdb3Ga5X+h?=
 =?us-ascii?Q?DQPPZftYX952COnddsvTuEts0ygZa/pjK5yy0alTEE5qp4rEJ+pCwH7RBpRH?=
 =?us-ascii?Q?coB5hPszJmP+s19au0paJRx6+yoONpiRFVtZzqZonLTsUrTWppPb0qboTDlZ?=
 =?us-ascii?Q?YiQ5t9afSIdEKW4FQbLjDi2BPrt9P2skD6A5llBWIH/MCmlIPTvgSzOKgK5O?=
 =?us-ascii?Q?63s0NvX8xwPbAyiLHikIcoAD9c+4djfAIEVNZ94DQ5X86A3Dm318cdh9/QH+?=
 =?us-ascii?Q?KXO/b+AY/L9IIj5DNOGnOSLPMo7RmUzCMPhvZsOgjNFXMrLcoXOf9wb1bSG4?=
 =?us-ascii?Q?IgyfI2+z6VpEsz8JCEPha4NH6QKOr2xCJhRxJussFgocKNkBYQ1Fldiy0FAH?=
 =?us-ascii?Q?hFMLdcZCDiIj+seYUy7eymEboSQJg7aw5ZOpAzDy/UBRg8PaG+VqN/hXfYkt?=
 =?us-ascii?Q?f4U2+7EwCOqa2znMtMbOqubGcHz/s4cLOuPFvvJIqYddpQsTgCYfUyTuzHz4?=
 =?us-ascii?Q?jPifUOklXFQxtuEQljPP7WASrdrFcRzXjEf82Se/Pi/8dU7uU0FdiIm7M6sq?=
 =?us-ascii?Q?z+UaCwURmOKjiL8vyVPlrK8ls78KBMIsWIayRNV0QsrS+Uy+PPy9WCRzG2CU?=
 =?us-ascii?Q?A14b06+rIl5ojRUXLt0RjuQkwvzUF1XBad4/LU9kpo665fioqmxrT0FHB90K?=
 =?us-ascii?Q?tUYe3gXxLh+Pf+AZ0HcpPv4eum3h2dU=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7387fd5-388e-41e2-11bf-08d9f1eb7787
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 07:59:47.6147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IbyxC5hOJDYe5LoMY+8zIUsr8eaKw0ERANDR0bvprByuc4fMm78neEgp1DT48dgDPa2TYUbVPc0dcrG9LOKP2uw16G6Qm1GcE0jBVXY9iEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1843
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 04:53:56PM -0800, Jakub Kicinski wrote:
> On Thu, 10 Feb 2022 23:34:52 +0100 Christophe JAILLET wrote:
> > ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
> > inclusive.
> > So NFP_MAX_MAC_INDEX (0xff) is a valid id.
> > 
> > In order for the error handling path to work correctly, the 'invalid'
> > value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
> > inclusive.
> > 
> > So set it to -1.
> > 
> > Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> This patch is a fix and the other one is refactoring. They can't be
> in the same series because they need to go to different trees. Please
> repost the former with [PATCH net] and ~one week later the latter with
> [PATCH net-next].

Thanks Jakub.

Christophe, please let me know if you'd like me to handle reposting
the patches as described by Jakub.
