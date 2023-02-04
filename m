Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2043668A9CA
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjBDMqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjBDMqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:46:22 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2133.outbound.protection.outlook.com [40.107.223.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBADF1F5E2;
        Sat,  4 Feb 2023 04:46:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHZby+NXzYlEOCA3SLlFF2JEPtm7GFX9XVXRLe4w3XSLzm5iyjQzrVpJm6fSzrniB9xF2RPA7Bs5tpXbIaI1E5/odjfBNdWiXRDxvH62Cp3D66dXbUKQnnV9mQAtiK4/gJ08nJWoCXt40MPp0wSG38Pg7XBUreCLCdFAeDnguSfDk1NcGPD+4WPG9QEp2Rt/To1Gl/Ri0X+kJj1ygiR+BnU6eOiFw6UY6BX58TE+j5r6i3ThBdKIG6JsFPIZKtSCZZDoC84x69Mtt74Z6cmSrHWPXFS1Yzqs+2RSRXbPBo4p5if+csSrNs9DzRB1kTpyi7AAX2MjIf2PLyRRzhOSJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HiheQF8UK/ZSYPB9H+kjpHncTnMBhxKNEInNAbFBxI=;
 b=coW+DhPpmzLn4Dmo+9sZ6nTn51xMpgfJx8KmAF97OpKXGlFc6XXb51nLKadBH8v0K1CpKKeXNEdosr7lOAHoGdWI6Pi766pmMe8YeTT78dVg+mkkNLNOEaDZkcWxAABn8Ex7ZapLmlreFdR+T9jEKevC3ADwGEIM6EAfHOwzj0XsMxkDgl+5ccsc48rr4F4p2BW3CieXw28d3BlDt9XToF6mnxMEGwTVfrCKDPOmj3x/mUreRZ9sBgJSKagAifrRo0/Jo/mhaubWmzQL2l/eBvDCLIj7kjYjCEI+EqqQ6VY+6NjS4nUMG38816mYrUWiNlxcAL4q5Q0/sycrto4F0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HiheQF8UK/ZSYPB9H+kjpHncTnMBhxKNEInNAbFBxI=;
 b=CRuRjA2DN8NDzH7e/AgBxxPJoBnnG27HDOX7T/kcZ9cZ00DlyyFRABe6l5pr6Z7wQRwwfuYREtaF5Toa9cX4dwq2ao84mo7ZpGTYftLPgZQNRNkB04EmryjTn521aedm3KfLxrfhlokOOtMUuCrGt+RnpxDK59Yqa2t7tUqPCWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5454.namprd13.prod.outlook.com (2603:10b6:510:130::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sat, 4 Feb
 2023 12:46:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:46:16 +0000
Date:   Sat, 4 Feb 2023 13:46:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 09/10] net: microchip: sparx5: initialize PSFP
Message-ID: <Y95Ti6oI2gC7bA8Z@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-10-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-10-daniel.machon@microchip.com>
X-ClientProxiedBy: AM4P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: a4a244d9-8946-4cdf-8e68-08db06adce37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IaA4+TTmdMg4Ys0OH2W/fSlytBNvIIHak2WlRbKL80bnb/n+pW76pvvsYEzjnzB6K1hO23GOB+I61EdLVITqOHfO5aLQYLeHvJMzgggaLQxTPCQ0mIK/F6syeruzBJsbElxnMYGMYTjJQC6r1yCVQ0/Kay7To0aFGLdte1OHhSm+cv5BlySdiNyTJPjN9axoWS//M5Hwi8ygl3HhhEX1AfgiMhatAmIPtUoZ+tz53X600UQ5Yi9BaKMj/WEqsqgm169rukzwHrcezNxNwRPxvBILkK78IzU4xLgUoXBbJnr5W6COOrmmQmmZP8CBlw4C8GMbdpIlmoxo4uR21/5ooApA551kK7K9+C3IYftgjDjb4Y7ckRclUOXKOYgFOAQZKEtixN8cpopbreGC28E1Cu6CqzK9eRocvwBKd+7WzlXguvlVPyPA3DTgp5zbnyF+Zf65N7q5xapW5Kf+a5A9lDPrAUrtBC2T1+G9COMAOhlTkXL46hq3ts99DC/L2MySMJRdU+itOXDeTH7K0ucWmhOLmZZ2v/7SclU9aewUjt8m/MAOhlFlHbWyb+4CvRJhbUWL2TwnacTLMQeD1G/ujSwcoJI9mWOv+DKBpJAcgMt2ny9E2IK65xgoR8n/q3FbKVlgGpNldo1pBEcB6dEvUvA/9v6TXNdNMxfTiKqy3J2AgVc9GKPymxBF4vALF7IW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(136003)(346002)(366004)(396003)(451199018)(2616005)(6486002)(8936002)(478600001)(7416002)(41300700001)(6666004)(6512007)(186003)(5660300002)(6506007)(316002)(66476007)(6916009)(8676002)(4326008)(66946007)(66556008)(86362001)(36756003)(44832011)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gxYcuRkri4yEed7sNoEEr4EUnO4R0NVna6qjN7ADxylWvy1CqHsUgdqPqrcA?=
 =?us-ascii?Q?alWl8OCCR3vUD5srzujYiu/PDAUZ1wsp1zASyY5zwKwnaKMg8M9Ka0bXYUQP?=
 =?us-ascii?Q?bHAPxNtAPJShHISdMLmXpgX4rImfy8SFByTOtKHFaJtfyl4PZXE89Akr+ONz?=
 =?us-ascii?Q?y1VMetQyvNCs6r1dL8oZYLCiSTgZDMeTsRAWOimV2qVz96qtFXTYHnozJ7BK?=
 =?us-ascii?Q?84IP9vd0xnRBl/ZUhaHejxdjjvPSxcSgxr5fokUxXxAU6ergL28+AzQ6c3tk?=
 =?us-ascii?Q?ZiW1SXo2YzQ4epxQzkbH9eXIShr04oI7+lDLnVt143ISnuBTiaxs+nJK75OR?=
 =?us-ascii?Q?4lo8CbBpAniDtKw2R2LuH0c/35zDegJCo8v2j/Pz0f3wkoDjfpv65Lb2JfFZ?=
 =?us-ascii?Q?sTSiF2+DW2p2Qix07xcQTP0C6NA6B04uwFC+EMdqfeUEpeaT6Mlakv3EoHaF?=
 =?us-ascii?Q?8Hj6SCLTl2jrz3OkjW28TwYkuTbUhyxd6lzaj045c0aIiMih3NlIvrq/LtlI?=
 =?us-ascii?Q?35uiSIapf2b13Bx1lFwbCeTs1GHuWriC6tIsFl09bZalIFw+o5Jzaoy3J+0p?=
 =?us-ascii?Q?fqnbTfzl4Cw3irbOCdsInIgedbgW9K00mTYcElUqf2d3XhMf6TyiaQ1J5fxt?=
 =?us-ascii?Q?OWs+rd1xXBLpdSQtsheKY6OWCjrLYvZ+hhZdTO0DX/OV+zFErWeiafCqhFTh?=
 =?us-ascii?Q?u/50nn8y2dq787wAFxWNjF3SxZFLM6QTxpM1kPAxrVi9uhau6XXv7XAW2l9H?=
 =?us-ascii?Q?MsX5Tj+ph682n1XC+iknaDQIFsmuCX+H7XEzHOEfeX4EPEgWlghxRAhfjfis?=
 =?us-ascii?Q?+pbUq6MOm9LngiVhzKo3/BObZ7EU2WUMCrfL57ILsSFkmofSt//ojDNbtK6v?=
 =?us-ascii?Q?ENDiW3wB9l/M56IxtWgCrF3FZv8SxIbkTxSCeAKSeiH5kVrNc2vyfeS8wFrE?=
 =?us-ascii?Q?1XJuzFvlOQvi8JrPjJQ803Vcl/0P8ogHTBm96DDWMBCYd3vUbgGX+J6FlKG/?=
 =?us-ascii?Q?/20t6Toug8iUHwQQ90iwWrOW2sPWCuDVZGA2yXA3WgzwERgScn0oamvaHHpJ?=
 =?us-ascii?Q?5/7z6696JCNEXjCmgBre6nM6sT6Txgm9rCVZVkek3PNsuJaw4+foxZ9US5SA?=
 =?us-ascii?Q?t4KcjmtIrL4iLvWPzHo+EVjq4TCaGMC37kxje5FceYRaYRnUYuyTpjj/o8E7?=
 =?us-ascii?Q?3lk3eF+4LX35ZLfGhadimCmylkg2vgR/Zcazc2+aZSwjlYUQ9m+NaYWWe8c4?=
 =?us-ascii?Q?RQPp2sH2JVjwSiMaohPsc7lyYpsjYlF88egy+eWfFJzQaRq8ahlO8UUcSNsy?=
 =?us-ascii?Q?XZE4kD3ducTqSD2Sw9KpRsjFznBXE8K14tc6P+uyG7QA+mRhD7LDdP9Lahri?=
 =?us-ascii?Q?Myehs1+VrrNtNiEOmPBBeufalscbyck+DFPyqDflRH8EZRzWc15m9mtO7zAD?=
 =?us-ascii?Q?eSVPgjdTt56m9EyN4MWeuwWjJarpbCdlO9my2wuEcG5z9qvYOQFP7wxb9nRc?=
 =?us-ascii?Q?VBRZxqWqPxLKUIuWT8XTWcGN9WZttb9KLmGJ0oSCOtM5FKFby1LBDjR3aqiE?=
 =?us-ascii?Q?4QdkKc+c7XyeFOZxgtzqWgLTxgNDjR+W/4hJnq1CI/9d8Fb7CbqpFSafUds4?=
 =?us-ascii?Q?7zl/wH+yBhH/mi+axJyvde1z61u0jgYVHyIHx2zpmoimx2nXC25dvfSaG6bn?=
 =?us-ascii?Q?jK6P+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a244d9-8946-4cdf-8e68-08db06adce37
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:46:16.4568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5wfNLtJbVaLW4MfchAGCbcd8dtqf0HY7dUDW/+jOIINqDfa4f2HtB6N0sDLjBfxdywACaNy5yedcgnX1Djp3sgc2SbuvalQxiP/5aI/uDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5454
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:54AM +0100, Daniel Machon wrote:
> Initialize the SDLB's, stream gates and stream filters.
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  .../ethernet/microchip/sparx5/sparx5_main.h    |  3 +++
>  .../ethernet/microchip/sparx5/sparx5_psfp.c    | 18 ++++++++++++++++++
>  .../net/ethernet/microchip/sparx5/sparx5_qos.c |  2 ++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> index cffed893fb7b..72e7928912eb 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> @@ -456,6 +456,7 @@ int sparx5_sdlb_group_del(struct sparx5 *sparx5, u32 group, u32 idx);
>  
>  void sparx5_sdlb_group_init(struct sparx5 *sparx5, u64 max_rate, u32 min_burst,
>  			    u32 frame_size, u32 idx);
> +

nit: This hunk appears to belong in patch 4/9
     No need to respin because of this, afaic.

>  /* sparx5_police.c */
>  enum {
>  	/* More policer types will be added later */

...
