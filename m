Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4DC6DAA88
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbjDGJB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbjDGJB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:01:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2107.outbound.protection.outlook.com [40.107.244.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201F793D9;
        Fri,  7 Apr 2023 02:01:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHAyRTCKkH5rKqGvkj4t3okOD35qANOKnmOAELqbKgKKKDXF+aMmosRcqwfxLtpU0BmZovb0FYuPFw8mjBzVECtmoXCjcNRnMqDf93Qhyfwaw85RVBIAOk4NXYk0YKpiZNjs75T6SR3dlRlVOs7zF3IguL9NRoirAudWUSWmOxSxosyd1Lbpat93WvuUyW2Lqix/IRKMsgT5NoDETQkbTXmjEM7BoFwazIQtwOYSNlawDM2aiLkktKpxu3j5iuglZ6AVA/+UwsVLSV6O5JUCLXaD2xvwzRL5feM80tYFuyOIkwrDmWMfwxTY78NXBRfNabq3kmPWrAKqbyr3Adnysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGzzygMuCBZygdJ367nYSEKi7+DZ/K9TR09ZIZOIanQ=;
 b=M3UMGiUkn2K2423+W9riYEnmfe8FBbLhWIcFGTVyTFv1mymp/I8SayEfWz1JeRr7tMKC1NTTtaDdpxf345u41vT/uLR4e65s2O9mZ1vhwsJ3dYcN5LTCqAUkgWKfl5TGJ8jUPE+SKUy9aQtCNcsojqccWbSuNg4zeos3yksMPrU4EUrNVkFgy8IQG854jd+4Z5q67G3cF2HtKxo92hWyY2/ilSASyJlyOA/hU05qEvpHlG9Fx5Smu5FqXSIi5FjK0vGdd8Zdz5hDfAkJl0HKG0tfxGIpl4tWxOswlf1OUt+Ga3pMq253Y79uksgvJiaCm9ASH45DXkIPMrUq2tYYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGzzygMuCBZygdJ367nYSEKi7+DZ/K9TR09ZIZOIanQ=;
 b=ivbPuHjo2EyIttSSgscBaQ0Izy0sYEgoukvVKDtfEjugXRYZ7Mpo5rVMv6gwiMfEMz45rTGvrg9Jh43lrBKR6D/Y1xGtHjh9RdL4SrdedUbmpAnicwbPC+++8SSN2HMib4LahGbhGYp7IwCwF3SdqnNBBXVhz6Tu/Ckz8ryx9yo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3995.namprd13.prod.outlook.com (2603:10b6:303:52::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Fri, 7 Apr
 2023 09:01:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 09:01:21 +0000
Date:   Fri, 7 Apr 2023 11:01:14 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anirban.chakraborty@qlogic.com, sony.chacko@qlogic.com,
        GR-Linux-NIC-Dev@marvell.com, helgaas@kernel.org,
        manishc@marvell.com, shshaikh@marvell.com
Subject: Re: [PATCH net-next v2] qlcnic: check pci_reset_function result
Message-ID: <ZC/b2lP5+MRwcGqb@corigine.com>
References: <20230407071849.309516-1-den-plotnikov@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407071849.309516-1-den-plotnikov@yandex-team.ru>
X-ClientProxiedBy: AM0PR04CA0117.eurprd04.prod.outlook.com
 (2603:10a6:208:55::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3995:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a536aa8-abee-4b07-a21d-08db3746a810
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YFa3eTEXUVtY7SS6rBOsZS0QaZW+ZoGiNjFHktTgvzokWWeTOM/XQklVDxKiMdQ7Ld/GKf924fpCLc8IbEcAikNN2hyTbmse522iDDlys4pHr4SoZXwzddaoJKYMNbNg69cqDkXDwXDiewSHWoz+LzQqze6cuZuktWoDLdpzvo+ejGMAeANZhiRznKZNwLsopxdT36UxWKnkZ9fo4Z/1rLCEDV2zgO1Xf2/YNJWHmGqbm8ticD4NfQ7Y41jxRlwUu5vT8wRXvGheTv6oLtyPO0fH/uRopyUV9DC4GAFKZegyuscCDjIS3sNRHO6gjMZtUwhvY+lLWSVMG0B26cpcwxIPWY0exPeYGFFcg/oyru0WhYrsXjEJllRk6BQk4XJ1Cd0dS4alI6G66FWhXJzm8xi7wc/Qj5YDNVoC/SjaRqgCy4tvoNYswGgEfNtI3ofmaaeTjp0f020raHc1OSYFEUQv42PfyTH6RbcZ+D1GU4J3PbWDzumNdTH9qKSKjg3qtrYUj73kvxtsiIA8cnmIyUV3tYyb4GZjCWQfSKAon9ZzijA6sQ+xgL/l3gxBznglNhonmLlar2mp/HE5wbnOmS69atB33DRaLK3F4hOQU/I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(346002)(39840400004)(376002)(451199021)(38100700002)(2616005)(316002)(83380400001)(478600001)(186003)(86362001)(66946007)(66556008)(66476007)(4326008)(8676002)(6916009)(2906002)(6506007)(6512007)(6666004)(44832011)(36756003)(5660300002)(6486002)(966005)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mB/MZOKvmSZ8QHAiSVOb7bzHAve2nhCEllxSsxH4jUZ8WMKZAKT+HaYrVLOh?=
 =?us-ascii?Q?axiS3RnLWFwd0Sk5MfsEwoz7cNEupF1ARCHYkD+R93V6hJTefFUI1VmruiBE?=
 =?us-ascii?Q?flmDH93ulJUUl+vXoueRzHPd4zldgPVZuDSsQ/Li89R7lh+Bvhh8j1UYNh5y?=
 =?us-ascii?Q?7cVSjslb1+YOIFrA7LR/G6uxI3VBoJfgBeStgvH91fQPm2KlxiaaunBEd02t?=
 =?us-ascii?Q?+g6dCMC0BpkgoC6wRKmo5oDO4fue0lnWt+Ba4O37Owk4oIqfugQE6eXznQwO?=
 =?us-ascii?Q?RCpwQ2LvJoToq9+8SwiCioGnddnXRxgl4fKItOrgtkt+8C3fiG7rAXYH+n7f?=
 =?us-ascii?Q?+lDIh/tSh6NtWEPTWWlIvixmbQ5KZxJ/pZXuOyEj13F8EPv8c4cMc2ikpbFS?=
 =?us-ascii?Q?T44rl/pLG27sTlZGebmE4gile/pwWX1jmT3JMXJresFTfwTZeFiAdgLlMOaq?=
 =?us-ascii?Q?9NTYt6DNMo9zjM0rAI6nt2oPxHPmeh7Q86yCW8kdc63wEDVYCf1BZvnvgGrh?=
 =?us-ascii?Q?oOKccHSvHYCPf2KY3/StJE0DRKexYSsz+xvBVhJvjxxK1Dbyh1ajHuarjkxG?=
 =?us-ascii?Q?/npFcaQxUk/LTNexl21svCMzsFFn+y9wshbl3X2CYCTk29/QAZQJ2o8RSBUi?=
 =?us-ascii?Q?Dd0I52qsp+xvl4R81Ef33yjkAr27Q5HqkT6z07BHtkOQb/Xjf1FDba7noKuX?=
 =?us-ascii?Q?DtpFfYkc7VJrP7iun+Zf+yobO2YhP/zil1EuEJ8o7ZW0QJnmGPbnzba8MVJ0?=
 =?us-ascii?Q?UxgrJaZoj6r2mYKiesygvog3vmxvJaoUn+j88PWSGyQRV7zq0ic2ZsuNXM4d?=
 =?us-ascii?Q?hk9F7wxl+gMU3uFAgcCEbLCDIx6gR9DSBmWWJUIOwmPgIgu78Z3nDOQSZPw1?=
 =?us-ascii?Q?nS0RyDpOWWEpZzYC9d5smIP5qB8PBNqcZS1J6lFsU6y7Jy4p3GG0heeGOfBI?=
 =?us-ascii?Q?2DQdzOxXL6U6+90LVBgoARaXz26v3JK4+3d8yzM7zPYf8cLoYefxTDf37sJH?=
 =?us-ascii?Q?lwkm9y7vhJrCS4q10wnjJlAN125H8Gfo+HImy7ITJk9kDFdQYLZ4Atgr42ZF?=
 =?us-ascii?Q?ozDALQC9H2wsin25qybAeFnItT4KpHQSydr7FX/x8/Hhk5a18EUC/LeCc60G?=
 =?us-ascii?Q?vFShhPWeGu/pdOU8s816e45h38XzMaAhP/SFNq/M3GQygRV3l3OOdPumkjah?=
 =?us-ascii?Q?GWAnqtLgWgoOVXiHIUF/QVBAZmjZW6ur4HCxqE8gaLdI3RYs15rEBAy0YRtd?=
 =?us-ascii?Q?BQybz8bzB5tvV+IEJBxfhW0HJzomTrcfPEt0n8gj+RQhoMNEM+OeYtH0n+mY?=
 =?us-ascii?Q?0A/L1xGX+5Ht8jPruJ8rdyhHDgfF5e3CshjWw56GRXfBqsiW8TTVcptHhY/W?=
 =?us-ascii?Q?ydfeCQYZMTIXZdNchVXmMxTbaL+dM3F2xGN0fWpuLkHCTAU/F2BpIdZaj0pO?=
 =?us-ascii?Q?86l/Yanr/f7rwH17a1mSivMJMosrmo7QTPn/9A/nQE9y55B7cJqqVXScRsBd?=
 =?us-ascii?Q?/p2EJEIas889TTAKXvARC3gwzF/qOgewFSINSXED5112h53cLvUJNLXuYFr/?=
 =?us-ascii?Q?ekRxOyFsRV1YDy4a0vCa2v121WvNYs5kPoD5zpa94Gd/Ujiz5873opGODt6A?=
 =?us-ascii?Q?jV+OrfWFziqIXZPjzHMrtl318fjpCk8XILRd7Q+jZ5u5zNvZDtBK13R7hZCx?=
 =?us-ascii?Q?At/oxw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a536aa8-abee-4b07-a21d-08db3746a810
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 09:01:21.1784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U53b4pSGVIzOSRydpcQfoBhI9oN+Bi7O8Q8nf9dvG/IODHkOTZcLbwcD9vek+tMgAsoCDpMnkvlkrSgLVhJuXSI039eXGaS98HrGATzni8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3995
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 10:18:49AM +0300, Denis Plotnikov wrote:
> Static code analyzer complains to unchecked return value.
> The result of pci_reset_function() is unchecked.
> Despite, the issue is on the FLR supported code path and in that
> case reset can be done with pcie_flr(), the patch uses less invasive
> approach by adding the result check of pci_reset_function().
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 7e2cf4feba05 ("qlcnic: change driver hardware interface mechanism")
> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>

Thanks Denis,

With reference to,

Link: https://lore.kernel.org/all/20230405193708.GA3632282@bhelgaas/

I think this is the best approach in lieu of feedback from those
with knowledge of the hardware / testing on the hardware.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> index 87f76bac2e463..eb827b86ecae8 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> @@ -628,7 +628,13 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
>  	int i, err, ring;
>  
>  	if (dev->flags & QLCNIC_NEED_FLR) {
> -		pci_reset_function(dev->pdev);
> +		err = pci_reset_function(dev->pdev);
> +		if (err) {
> +			dev_err(&dev->pdev->dev,
> +				"Adapter reset failed (%d). Please reboot\n",
> +				err);
> +			return err;
> +		}
>  		dev->flags &= ~QLCNIC_NEED_FLR;
>  	}
>  
> -- 
> 2.25.1
> 
