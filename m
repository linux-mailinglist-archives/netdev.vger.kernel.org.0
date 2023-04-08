Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1DD6DBC1C
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 18:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjDHQWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 12:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDHQWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 12:22:43 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26326592;
        Sat,  8 Apr 2023 09:22:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXLJyCsxVd5GCdTi3SBTP71N+BgoWZSpkYr290zIzfvEj6/K7C2j2gsJCtWOuNDnY8tt6XxZsBkDDbOKrrtozQ6uRIzDKBeFAttrxT3PGtj0LgsONgMygX7fYKB28rtyK7uH10jDi6DqutVQ9LD7tVKi6fLJQYFWSOTX2nW98DC9CZ7o7Im+4zkuslmnitC5raal2jOa+Wy+hvn+DeVYaWf9JpO3tU7rOhlmEy94sLDEeOreJIXArZYo9/Xr3IgEnnUT4fzyM4BItkE7QHA6k+O2w8qTLur2S6oysoGCupOafbNt7+4xKbJz6X0Vo9mYVA30H9eNZEQE6NPgnyKVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3d16567EM0NEhDIw02/vb3I6RYsCW2ccMPv19W6+wjw=;
 b=l2Zy8uKMZwVaf0/4m3f4NsO9LROfiTZ8Wj9swi2dkQC8B87gVU2ph/CsiKsRXt6smgYQu2zQ5G9qUyWgGQZBZAiEO4ADDxLO/ALeuyFeaMr3rIwxECs5T3NlO8New5zhfIKhKJ3UVlxGiN398gxep1wo/G5tuP+m616pxyczNu+GoWZ6lRdUSZG0O2cE52aGfXlO+eZ0Ch1P1o09GXACl41aCEy/ytudHai/fL7yP6jTbvBql1FImNKHOJjXZZ0lI+NQvCUSDORaMaZDv/SOEXsmlzTbh1cBSxlEyCB7hPMG/KSOLQ4sAdf48e03Sf2DvfJsIsv8X+xG1xU4cQtZ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3d16567EM0NEhDIw02/vb3I6RYsCW2ccMPv19W6+wjw=;
 b=PZAW72xzRs1E31iMhcZYKJS9di+fOgFuy2DqqcMSUoyxBuXWmxUnPTNuz4fPKxu6L+kD2PKk9yD0jHQ9niw8+oIbDPP5AnN8EYxkL27wPVR+2ioMRoFf4DVHGjwsCh6tWdgC5zbjQ2coM2brb4VvANwpSB7f9Jux766MKyq8k1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4014.namprd13.prod.outlook.com (2603:10b6:806:73::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Sat, 8 Apr
 2023 16:22:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 16:22:38 +0000
Date:   Sat, 8 Apr 2023 18:22:31 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvell.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com
Subject: Re: [net-next Patch v6 1/6] sch_htb: Allow HTB priority parameter in
 offload mode
Message-ID: <ZDGUx586cnbyPa4M@corigine.com>
References: <20230406102103.19910-1-hkelam@marvell.com>
 <20230406102103.19910-2-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406102103.19910-2-hkelam@marvell.com>
X-ClientProxiedBy: AM8P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4014:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d2427a8-b6e6-43c1-f090-08db384d7839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VU2zuacTaCYX5ZAn0oLIYzhiGj2syhOXPtuTDXyp/IHE2dMXnPCjbgTHgmRZL7jW+pBsVJt6UbxxJK1ZvD/sJTxDU3baXdvq0jAAGFgYoM736ShGo8k/zgAIppvmqziGFPlYx5J4rAFnULBNKenw3SsYkuEbct2ZR/WL1FBubQzuen9zwdUk8A1w0pGeYjWgg1u+nLKq1AD5+jOTLJKuSm8Z28sdpsYELaEQGP8ZmmFjpLUnu8K7E/KMkt3gh61IGjVBx1nPjVOVuM9QViRCmblejpL6BGNOTQrl8hzCn4easQyKvhNjRWJmSLPmBzTjB4SrrSsJd8z89dCwwIqbZgg4emmzCN5Ka/tzi3NagLSqDtqEs+G775/48rrmYqyC0IK9dB0mS2yde9N0AcQqhSPdwnMwfNfI0w603tL1vPK1o9MWqaWh7A+4EaIOfaIho43TgKKw4gwdjC9yxql2LvUfajKQ+lno5eJAvZSjqKjf0YyZcTqQH3omKwZ1n1okhcQ4gX2iVLf3fWW3WAXs5lXOdmKlhEP5dvBbK9GosSe0gUDCjQtpjreSSuZxjBzax9ihvasB3jNk21qDM5J8y7b6EVhpn8QoPIIoaHWzd1w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(366004)(376002)(396003)(451199021)(86362001)(36756003)(316002)(41300700001)(66946007)(66556008)(66476007)(8676002)(6916009)(4326008)(6486002)(478600001)(5660300002)(7416002)(8936002)(2906002)(4744005)(44832011)(38100700002)(186003)(6666004)(6512007)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ajXRuyB/Q4Ff1k3iV1jy8qpPYHZrqrYPD3+sJjO40nvA1A5xp4xntibmZ5Hg?=
 =?us-ascii?Q?JifDPyhVLZHtxCAuxXJRFeTpcMcIYJ4I2cUd+uobBPhD7WiCc9gbhqG64jfM?=
 =?us-ascii?Q?LDKKvCgxKTXJyfNswNQbHNSCuGibT4J/CSlcWfb/h0xhMVWQzMFEk0GUfzoS?=
 =?us-ascii?Q?3hYrAGzmLVfJP7OnGBC2D+Al5wepwddbOeFfDbF9LU/YPonlrdZ9mzV0gD0Y?=
 =?us-ascii?Q?GFhsdIYLt/o7rfYNzKT9bWrjpj7QX6aqDJA0d8+eqRetd8KKgF9j/AdlQISH?=
 =?us-ascii?Q?fjYg+GVwNoY4UhqU7BwDzKIc2VkyCEQNHNlaQ+L1ppfAk8S0D0EYFCRmDpvk?=
 =?us-ascii?Q?LUiIFsjdjsPd/wHSzc0nzBblUnJfWd19lGpddiLV4VKo+5aJI0znXvWk3QA0?=
 =?us-ascii?Q?8cyD64Fy+FstSJ0d+iyOzVByKeXzoRXDORyEzXVMaUqrmxjJUWgIUFhUj1S3?=
 =?us-ascii?Q?VbjDIhPh0dpUQWPRaGdXe7q8qAR3FP6qTgsram7XwPo7RZpg4rFCXshvtxMZ?=
 =?us-ascii?Q?w/pgxAZBgHpS4GkyhAjHMf5bfQSdGwtaXL8ICNVJEOz8v7hxtoxS9KEbmODs?=
 =?us-ascii?Q?xHQ1lSSMKAjz0pW7xXbEc1sLphzkUcWwa2wqPvEA5SrWKaaJ1mQWQhm1pEPn?=
 =?us-ascii?Q?3X5VRDG6wFGfzygSyKJqLSveIIno7LpFWj5SjaknqLflOlAjk/nA/ZUxfJoT?=
 =?us-ascii?Q?2MurlTjV5CSG99fkxIbriKri2sctAfFuv6ftIsmdqItmMwcLBfwpwfb0TXLx?=
 =?us-ascii?Q?R4vkTk4NFwKLZu/NLRCFkrxiMCnSbkT/whp9/+oZfV82febcF7whjKYj9WXf?=
 =?us-ascii?Q?6OPZtxNLjpKBYZ8/XtSS4oE/flkPmeAGkp9cEfkcIV1ILDL67ZooO3mm6Jv8?=
 =?us-ascii?Q?SM3I0NAhyQOJvgmi2Q9UP/cz7UyHf1xLCwRHHQZQykaIVL5wkSfYF/Z9oV75?=
 =?us-ascii?Q?SsErrpTKBkil3VdvRqZYogGL1Ib206ONHW8mhXV4CjOhYylKwmxG/RvhL2Sx?=
 =?us-ascii?Q?hCz51MK9Pz/WXQBLGfkeMOm0PcN29WPfv9Kg2vmorH/hrZIv8GbPW3j45WLW?=
 =?us-ascii?Q?43LIGvDZCfANowNqE3FLHPO1jDC1oWDLmsnaZAGuwbeHdzsUdH1v5J8spoVV?=
 =?us-ascii?Q?zLPX0yWFmVNTZ5RfNyNe2cpl/g1T4latVWMFfTyBZcwpvbuxHVHJQHDvF8w7?=
 =?us-ascii?Q?cgxrcsgCzrkwV7sTmhw9kDv1QbYzDnaQkbg9+rkfGPrv4oSiT3Zvbm2bbZhG?=
 =?us-ascii?Q?rCtn2PhuxfAYLXmVEzSCvxGmBy/V2LUZseWoYzSEEPn5/p8ipLvFotXXtIaX?=
 =?us-ascii?Q?2H5CNwcXcBV/oK/ulggOuE5fqPon0UM/jXnmNdtvD9fGkQ9qk8C4L6h861a1?=
 =?us-ascii?Q?ppF/52DD6sHglvS6dmCvLhV7yT4PSTjmNnNnlh1w83OpPg+BIyfXV7Itcp93?=
 =?us-ascii?Q?oYgrtdvbnRcJ4k5Mxgh7CIoiCLSK1IswNZU36FwLPoCENPaSGqOE8hZHAiZX?=
 =?us-ascii?Q?BEIXklSlIvSpsAsmQ6iDWRRC5EUDCpF4cGS1BtJYElBVdmP7jW9IB6yZt6hn?=
 =?us-ascii?Q?StH0+ls7pGBOAaPYC6x54ZfaTyHC/7upbZGNI9EDmcNWp3yIXmXLqhkNlPU5?=
 =?us-ascii?Q?eWJNZiFb0HG2nrI3rkcrjks9/KpXTcqq3Cr9Ytxy+6aa/anH895clEyUJu1R?=
 =?us-ascii?Q?EDCbOQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2427a8-b6e6-43c1-f090-08db384d7839
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 16:22:38.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQJT/gnVMcwE4pDifc3T8dc/EZLEhS3pgJXQxjSdtIje8ZtU5tVvjSLIQJhK6BH1gYioXzngh8XofaJnphb0tBFC5w/7GidG3rvkhWzjXIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4014
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 03:50:58PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> The current implementation of HTB offload returns the EINVAL error
> for unsupported parameters like prio and quantum. This patch removes
> the error returning checks for 'prio' parameter and populates its
> value to tc_htb_qopt_offload structure such that driver can use the
> same.
> 
> Add prio parameter check in mlx5 driver, as mlx5 devices are not capable
> of supporting the prio parameter when htb offload is used. Report error
> if prio parameter is set to a non-default value.
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Co-developed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

