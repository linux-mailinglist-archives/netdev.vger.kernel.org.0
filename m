Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D33E57C5E2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiGUIL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiGUIL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:11:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93E6785BA
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 01:11:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEayyE5pnJWzFsmdOGoaIu355FacetdEsEVcvkSm9OpSvunaXAL/MBlJ9UvLQVSRnck1NJOekFnysczsvBq8gfT1OH8QjR+uxPz1ilzjJvFTTyBK+PzRH6irZuf5cRPcZMBjBbbcknm0DpxM7sqlzl62DO13yQT/9bMuy+6hfn4kaj8OTose6p0srRY/6vm07AclGce3pLFCKadCZNaTXqZ77tqWtFoPOGWd9dvByWwBqivwc31GK6SGTqxsOWqfxB+r4jESj5u8fIGpxirETmCcBVlsXRvUnjpFuK7WfruBBuJH0E1icCTyABc3DuwY3/ArZTVGlG3TjoiyjeM7PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVThybrYDkQDiNx9yQkwFyo7Z4Y9zXBQEsicoz+7V2U=;
 b=eoG+yPRbX35XQdYG4t6I1Mo6POTJdXflODp1BqSAot+ljMdUNCj61NuIysHOLPkhyhjmmzScdi3+6wnKF2KeGTnhrvmYXI9LX8keUlUliMsbSK8UGP+Ogl5mntJpFOT/EBwUjCisCi9sAtt+CieoJf2ARxjFxz4fj+/i+TXorj5c+BS938SeFmEaNT6GndDXBp5iVwYv7RZiLVavcCeSmYA/9/XaFGC/wPGRinDftusQYV6OSsnuAMLXfMaL7KmRf+5BGCdFOWFUT0k3xY4bj/OOll6PflEcztQAGmp18I6P/gYaBDJVRQm+3KLNqC7kBLyDsHCNwmtIeCLE+DXn6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVThybrYDkQDiNx9yQkwFyo7Z4Y9zXBQEsicoz+7V2U=;
 b=mGdyEXUtOWyRmyOcNquvR0N6eKUdjiZe/gHzmNhovvOto4kXya935H8O0nkj4lompZMIo2wee+93yWlG0pa1gjLRSC5WrfQNxVJ5RwHUozgB27+0tBuXBDmiYCi0VBvaJKc+97hFZ8Rhh6mZr81u/fAt6o4CZC+drasEkV/6c5k21ElCUpAKHPzjzzXMWv6/kYIMB03rlQAiuB7FBLPq5W5/+5Ay7d0oHc3NISjge6Q+eip0/Ew9LXP1zK1xeO7OTTmJu408UmH+sBYBF/zqL/3/GYTWO1LXPr+NzqM/Ioe4+53UEgsGDaLaaY4QfCqp+Spf6q1qOGwN8Lx/YeEt4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB6533.namprd12.prod.outlook.com (2603:10b6:8:c2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Thu, 21 Jul
 2022 08:11:54 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 08:11:54 +0000
Date:   Thu, 21 Jul 2022 11:11:48 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 06/11] mlxsw: core_linecards: Probe
 provisioned line cards for devices and expose FW version
Message-ID: <YtkKRO0oEh4p/tT0@shredder>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-7-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720151234.3873008-7-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR0302CA0008.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5e01f15-6565-40fb-b4fe-08da6af0ac6a
X-MS-TrafficTypeDiagnostic: DS0PR12MB6533:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /DmRpb3V+cNWatwlXERcIiWt2XpViRQh7CqMkUPZK3wCiC67aexv0J9m5QlEuSn3h+udaq+3Lst4VjbRrAXNS2b+2te824t+ZbTCez+J4S9OKIHIRiAFcOFhNlV/8zLQiCl4XsF9Qu4LafqPbvBs/WCpj3VB6B62nb5dy5JwGK1mkBMfKbmDCSFRRgt9KCQNq+oWOeFtbh4R6jXzWpl4jLCCMlF7OdeZ2G4DN2f0lsss2rnshgJ9BBitIZlc+f0NUxhVQ145noSXsfoeMZ6KzJjY9PIJwZV+cn4gn4xf+Ng7j16NXIV2puHSPF7LDoVNntggMTBHOZlfyxuHrhHyA8EiiFIaNUIgn07ZT33Tj563Pvbv6ujVawTqu3sM8btzcU5TygPV3TfXvIG0Lr9ZDyAJM+nP6Tyx8D5320NLjBkzikiyUWQlGSnakl6X81Q+GeVJIwtB4U8JBui+IzhzryOyx90OEJu/nKVKM2i4R7N/l8gG02fPX8fqfHtrEcSx9j/Xs+Fn7so1VdfZ4pTvii6nmHbIH8twB42AR1absjkAI6JUisyYXH1xWumlDjflUurh8/Lqcy5XFLvmqpprvtl5lPvcAySE/EPuN0OWX1MIBtfUiUaIAxWVFt/jy/yJPeCpdJXfNnvkR5Hb6YLGV0Ee5DOsRG9U1jc6aGLkecmUQa9E1iJMFV5WzxsDa5TTy+TuYAD26j2ef0jUAxvZXln9ESvCgLywjn6y54o6gIhgar1LILr/V3ZuE/s7Yo3b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(136003)(366004)(346002)(39860400002)(396003)(26005)(8936002)(4326008)(66946007)(2906002)(6916009)(5660300002)(33716001)(66556008)(316002)(83380400001)(8676002)(66476007)(9686003)(6512007)(86362001)(41300700001)(6666004)(4744005)(38100700002)(6506007)(478600001)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ozixHydG3hriWjO5IEnnisVKhHODp+XncrAxP1DXwHh3RObefXitmtLRFi0X?=
 =?us-ascii?Q?mRUsWPYxd0EAR9kG2caRva2oGfT6uDLsQxXalzQjOf4546ussvG2x/aCN71w?=
 =?us-ascii?Q?4+Y+JfH/3dLzPfTsy8HzpU+Lysz68gFu5b6BzYBY/IZJYxNK19m8mMPPjnQq?=
 =?us-ascii?Q?9WPFMYZXQPwpbC0XDxXy7BakFrh1HWsfwTbdN8NojXKgNqBsasCJQOjCy9Pg?=
 =?us-ascii?Q?E/6zY4vxpJwFTvRMhlGOOLUi1NNVdCIWp13VpgAwHfF+29FvB30Odq2tUGju?=
 =?us-ascii?Q?Od499uP4XqoeqCJ5Vpdua5THvGUozK1tgw3XT+usYEMfd81zHqhn+lVwINdd?=
 =?us-ascii?Q?6hmutmEDNB0vloXEsXrUcAnFXiFdYFcUPAqSLGKMKOKCCLiBGSa6zwoi2MTB?=
 =?us-ascii?Q?HiDLOdcXIOdiCMlnu71OBT6LIet1KUV6GVcOjApYqV9teSeMDSpRpjdL7T1o?=
 =?us-ascii?Q?XVjkKuCUnQNwIV4kqWX78j+PD0HJ3REnVW0nuCFi0GJIfvTEGAUpGUJdviGl?=
 =?us-ascii?Q?8/dZi/JZREKlmqrlDkdRKog7DYNaIc8ThJDbsOcQyM/vvzPhECYXpIvJJuWu?=
 =?us-ascii?Q?mUClKDY5z4Ev8zImTm3QD8KXlJREOEiUiPaiOBVmFop+UdCHFbdDdz+ejXEQ?=
 =?us-ascii?Q?dwnF5yx9vz+kQhad0ukbbD1TJ2Z3V+UKYtXaoH72Y5A2/5M6MWqRumsNFqw6?=
 =?us-ascii?Q?1oAPcZcvnfPy6Ya+t1ndn5sk1TuQoT9+QmkH5ecC1p/T4ZIh4YlcmHrzzEJT?=
 =?us-ascii?Q?5nvs/Le3PDhI4kSli9dZRGjCmdFJxntp43RglIoFOT1tkEKEsNIlk3sVOoKn?=
 =?us-ascii?Q?Kef8ecshx2GBncTzM/fSdZsRILOO+szg5ghavR3+5B//cKX5+7KttZpt3/W/?=
 =?us-ascii?Q?/RWOChES/SqqsAmS5evQ2NiQGLD0KS2eHHfpYcplfIeDx8n1QRgucePRRTGr?=
 =?us-ascii?Q?Zv6RgaQ3XJcjamIMpOK+9AJWD7W5L9tIajPb7nyGpzGCVX3q9YDDbicPc9En?=
 =?us-ascii?Q?X/KErBrV+GhlnF+rWGQyNw/jUG0BGzuQosFTqzJp/xB8f578fJZcKqRs4znC?=
 =?us-ascii?Q?y5ikKphArrnsd6G8Y4YZmvN4/aBIN8YB1rNeQjoBiYLpNtavJQdCdRn2Vd9v?=
 =?us-ascii?Q?KVeEryuvoCMH//aEk+J5K4ricv0XAk9JMP6MW9Gwt2xLF/LLsuSbFlfUfZv0?=
 =?us-ascii?Q?eCeIMDVMfUqIx5IjI8/w8ubaOkFZ8MwAEQ7ifx8W2zBSScN5Vx3wgA3q6m64?=
 =?us-ascii?Q?gmKnnOrVB1NPHRVMIdEN704R6usznD9awBOSG2RhSwdvOD8q1sEU0MQV5oP/?=
 =?us-ascii?Q?cXJY3Bl1I2Lcg1Ue+siGXViSK6yTrdtaw6n56ltRHrSvP4ayED9iRWMvhN42?=
 =?us-ascii?Q?KC1q88LnN2EioA7D4yK//XCIjum+4JAhVnLGAaaphbi3cr2GPW35tUgU0/r7?=
 =?us-ascii?Q?311xYQjFW4Ui7JYKRjUelxbLzb1d0uE/RroEZbKEeiN3w1wF5ze9NZLstMlv?=
 =?us-ascii?Q?0p5baOXduizds42WjJcs7U+9fmLpAHeHn8TD130eE+tb6Q83roDIBRhe5Jq2?=
 =?us-ascii?Q?LSMBVbxU3Vz/DEensMNhE47TKMIu8cYsckso4yb9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e01f15-6565-40fb-b4fe-08da6af0ac6a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 08:11:54.4653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7/uyP1PGbTtewVMFDCxYV17TmwVyCq1xra8GaOdvmAXAXy8nZeJvGvYOexTxgyUg56nteKqhEJAj2Up/8DgYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6533
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subject is misleading, only ready/active line cards are probed for
FW version, not merely provisioned ones.

On Wed, Jul 20, 2022 at 05:12:29PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> In case the line card is provisioned, go over all possible existing

Same comment

> devices (gearboxes) on it and expose FW version of the flashable one.
> 
> Example:
> 
> $ devlink dev info auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0:
>   versions:
>       fixed:
>         hw.revision 0
>       running:
>         ini.version 4
>         fw 19.2010.1312
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Assuming the above will be fixed in next version (it's already marked as
"Changes Requested"):

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
