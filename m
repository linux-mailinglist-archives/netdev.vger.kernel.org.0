Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374176EF19E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbjDZKGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjDZKGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:06:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2110.outbound.protection.outlook.com [40.107.244.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A5635A5;
        Wed, 26 Apr 2023 03:06:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lURzx4pfTMrXLXaoivrsH73XTSyjGoNiaf2D2n5DOKhtp5T1QNa9foLdmchZb/hmPamHe99OSN1Fwj7L8mOV0UKYjUrroB4g4m9jqG6UDl2m16JHPQQwKkW4dTEY1+Nh4wzt+AZYL/24ZceeV73oj7Q6K4+XSBfRDsOETeweGzGEIUg6hfq+ym34VKQQ9c+0u6CD1I1fPOgi1eRwxWgFzGiHK49AgxWMGA8YQhOBY/VD+zR6hyZY+mAd4b1HEqKUqbGnbEzXUxmXYN5w3hmHrh8/HsHBy1toZpBg95NvvuGYA3LDaTePebiReWw5IpNUrTyNYZN/yYeP/JO2ehvzBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ez2+vgc4Wwg1m17tcizseV5/i3kPsuP9o11O51bD8ks=;
 b=TNWnOV2hoOQ2eRLFY8rKJGdk6AUHuoCcPR4yguNZlcllgER3KKBq64d2w1s9QokMYY+8cl9/VZzNjph+EVfW5SNH0oaMcIArFZWtFa58zanYuqFwx/C3xGQj+VGtGwFA/Ams6GGitC0lqc0M89K/UfdHRYccWQWq0bMNVD2rVlEjiU9GWDMGTzhgx9sneDBmPmj9T/6Ehomxf/xCEYLpn1rvv+Y/aF4+vBeP9ndq/P4+8ntoibAY8MBmI7us/pWTQaDgdjJQZH0dVyZC6QQCWP2xjhhCKOrAegWWEbIdRcDDvCpPhNsWpEGKlwmYS4Uz1CMbM8PLQq6t+Yc/3pjLFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ez2+vgc4Wwg1m17tcizseV5/i3kPsuP9o11O51bD8ks=;
 b=Xp3SOB2+nAnzQsOVnfFBJlLsgjYuYnjNPZiEPWebBARBaBI90zS9m4Tho52kGTHv7a6IdWhhP1J2d4jsjyWeWOabtTgeOiSW1GNVsgZF0WpEqMTzGIOXeTI6Um5f162pSJvtQovD3udvw6Ip2qLmDgm5Vz6mk4rTP8EHFE7RTYY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4468.namprd13.prod.outlook.com (2603:10b6:208:1cf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 10:06:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 10:06:12 +0000
Date:   Wed, 26 Apr 2023 12:06:04 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com
Subject: Re: [net PATCH v4 10/10] octeontx2-pf: Disable packet I/O for
 graceful exit
Message-ID: <ZEj3jK639HNVN/ks@corigine.com>
References: <20230426074345.750135-1-saikrishnag@marvell.com>
 <20230426074345.750135-11-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426074345.750135-11-saikrishnag@marvell.com>
X-ClientProxiedBy: AM0PR03CA0073.eurprd03.prod.outlook.com
 (2603:10a6:208:69::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a93fc3a-cd39-4d43-9594-08db463ddd1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LPy3hSvh+XF2FZ9WkXP9zYMcOZuaSu50LTSeYHmS4MfKTKh9BNqgpZRt+0ZuVNaIPu4MKaYxsd+YAcKIWWDsjKuarF9WeaMtdFXEmwLW+Wj6kSLJp04zKTbpNVoZolnvniNYfH+86Z2wUcr+ZVz7RYWSdDV+L0BzWY26GmIGswboXcXdCvhRRd4MPt8HDpY7hDSkF3Kb5Mg6VbOkbn5Pjc8VdTaQZpGMAIm2/UBTB8IBnSZtdWHpbTGwgzGiS/SwOnrTtpaBQmY/uej/DA0+SXAl11ay21S5qGgR4kUutLwnw4gLrvrog8piyx/WjtAFvgooGKy/hOSX7kmdwj0mhurGEEn/CZjiGdXb/q+EOqinN4e+HPzbDdm5AIEzKCobJ3X/d11ri3mPDLIv1DPRZEkXZ5X89A0/TxntAvop20Q4QcGKAN+En0tgRxo5MUDx8EwLiGFIdiYQLzQXzVZ/aqtpCXDkojdncftNBomSmhYzgMv0r3txcGxpLETdKF/QHUrY0qbRbpcWglAPcy+k+6SfthpJAIB4bMIrONikoxUecm3qJoLSgO9VodgRcr6I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(376002)(39830400003)(136003)(451199021)(2616005)(4326008)(66476007)(66556008)(66946007)(316002)(6916009)(186003)(83380400001)(6666004)(6486002)(478600001)(41300700001)(8676002)(8936002)(38100700002)(7416002)(5660300002)(44832011)(6512007)(6506007)(2906002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BxdogZSvpga+wQJHN4NMyoEwdYsFtelWIiQ2Mq4qXn4IYwmKIu2UWp/t2Lis?=
 =?us-ascii?Q?oPMrsk3qcKbqQSmc+byJ4n6jWghe713IdPK/5H/zZyJbiHEUvBqUcct2mOGV?=
 =?us-ascii?Q?5zZjpbKeEF5/WGKKZ1pP7Qjxp6UGjlFgtjwYeACi/r3lPK7cek/YQgKMoi5Y?=
 =?us-ascii?Q?2loLFYhe5vusUwJmbA4OhnLE9jhho+nQPJ/69jrriT9fP3XqqIPTvydODoTt?=
 =?us-ascii?Q?hkSPLLpToJ4JBmCPuYsnv+gAG8yOHiUXWz1+acBHNpJ3vEot29ppqHVlSKPD?=
 =?us-ascii?Q?wl3hghjfJyBM3iK8ODetrauf4jvCsLG+aCmpzZ7Y0vryNw2VkN7DSCFsW0XA?=
 =?us-ascii?Q?omKTd7ProNU0sMDc56jXAMpHef5p1PTvVxwJdioTiTrlktMxsF9sGf6yTcRy?=
 =?us-ascii?Q?bgBIhadBJbyYfWhyTWEMpgtb6c0jetmU8kw7j8kOKkFVNa52FPvZZALdg1/W?=
 =?us-ascii?Q?MY96ozmWq0Rd6H3ZWb7bfy/jMefSyJgEMiT2U+S0K9DV+v1oGQvLk7zEew2N?=
 =?us-ascii?Q?PTJvjCoUy2du7VKBC0bFp1ofdJzfg6ByvdZ29im6/pG1da8cCfrcGNVcihSj?=
 =?us-ascii?Q?InnPIYvd2iebeu1dywHNoZs1wwfbUe/pCQzS5IbHxJuSh8zDD5Eo8f5o+MWS?=
 =?us-ascii?Q?34rzfWsulbPTkGYnTX4MYNvWwPBKrC03StnC4Hg3bGqhOEcDHIseDauLKkmM?=
 =?us-ascii?Q?mQNBScNHvRXCBEnapqXw+N7D7/z7mq58X3alOXvq5363Cx3x1NjZ6tEpCPgp?=
 =?us-ascii?Q?wBCWQuznGQOI2hB95BhUU8sCUl5YyoKYcQ8ron+EdWwnv5Z1rSKS3eIgYXhy?=
 =?us-ascii?Q?lvdKobmA9WB8c4YPoBxSGk1J1DbVVREiwNnHfZd2b4smJshMucuBudSOZqAI?=
 =?us-ascii?Q?v+3Pqzto6my87tKwD5UbJmQ55HZCGvpEqN3tm51cqZVG+PLN8Rbsm5R5IQoZ?=
 =?us-ascii?Q?QPtWEuPj5WAQScfR8nEdzg0G88JuuRiV2LCEpCBHE9FRZunEhWjv+H/YSNNj?=
 =?us-ascii?Q?0nDQ+d7SFtYFqXL/z5YuRPXZgvPefhMsDn4d9SJjRA0pKB2QsrBP8EiZhfO6?=
 =?us-ascii?Q?mfDs/4sWb5bp1+1HCTY6hy0xcHfgAwWnet6zvofsGIWoRtomrU2FLHeNxqb8?=
 =?us-ascii?Q?tY8/Wx4vqb4sc1hbMw0MYiSxW0cQRpmCwK96buGL4Au6/Mq1rRwYmwhTeMAY?=
 =?us-ascii?Q?kjr9tdUpzPaooe11Vp1qAynDoU0Hbiw4LJETLHl23MwSXzskEJAgYPxBFzm3?=
 =?us-ascii?Q?HYv051wfsioOMXtMwqurq2rhO2z4nJmHd3PCFt3SanwSM1wpYe9iqCHNgK/J?=
 =?us-ascii?Q?e+36jnkCiGW8lqveaunQoud8rrVg2Kg/k2TOMNYE3GC8ps4Kz4oViKJ/2Hf1?=
 =?us-ascii?Q?6c7QgGfyYc/Vs88vOy+WgehvmTK0iQH4y/Yt+gZLDwB/v25aicI6mesm9VzQ?=
 =?us-ascii?Q?bwG9QrX9+VOjkmMEBQ/xOZhtEYAGSqWJ1WJqIcfNJ/yjXOBmQcpU6d618lA9?=
 =?us-ascii?Q?9xprl9jcTfYN9Njcj+CHgWdy2ACq4l2mNKvhpFr4SFnqXZX9Ui1sC4FwJ7fw?=
 =?us-ascii?Q?3l+ToBNhnfIkm0jTHArHAxROkCVTwAsh4oaXbJMCNrY5xQyiF4wIXE5uTfmt?=
 =?us-ascii?Q?y8L2cIPtICZDosz4+eBe24FWAZJfQwFiw6zk1QVjkJeY+5Jv6qjz7N2pMQaa?=
 =?us-ascii?Q?bvGHVg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a93fc3a-cd39-4d43-9594-08db463ddd1f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 10:06:12.1191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HXOZ6jUGIO8/EK+ZEijm5XlOoCqJWucx5WmzTg5vy7YUkO4J3bxt/BK39ioSCjh2/tyLTgJHWhFYfNLLt/f0460vp5zloPoTJdi8cHcMGqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4468
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 01:13:45PM +0530, Sai Krishna wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> At the stage of enabling packet I/O in otx2_open, If mailbox
> timeout occurs then interface ends up in down state where as
> hardware packet I/O is enabled. Hence disable packet I/O also
> before bailing out.
> 
> As per earlier implementation, when the VF device probe fails due
> to error in MSIX vector allocation, the LF resources, NIX and NPA
> LF were not detached. This patch fixes in releasing these
> resources, when ever this MSIX vector allocation/VF probe fails.

It seems to me that the issue in the 2nd paragraph / hunk is
different to that in the first. And thus it seems to be appropriate
for it to be in a separate patch, possibly with.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")

> Fixes: 1ea0166da050 ("octeontx2-pf: Fix the device state on error")
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 11 ++++++++++-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |  2 +-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index 179433d0a54a..52a57d2493dc 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> @@ -1835,13 +1835,22 @@ int otx2_open(struct net_device *netdev)
>  		otx2_dmacflt_reinstall_flows(pf);
>  
>  	err = otx2_rxtx_enable(pf, true);
> -	if (err)
> +	/* If a mbox communication error happens at this point then interface
> +	 * will end up in a state such that it is in down state but hardware
> +	 * mcam entries are enabled to receive the packets. Hence disable the
> +	 * packet I/O.
> +	 */
> +	if (err == EIO)
> +		goto err_disable_rxtx;
> +	else if (err)
>  		goto err_tx_stop_queues;
>  
>  	otx2_do_set_rx_mode(pf);
>  
>  	return 0;
>  
> +err_disable_rxtx:
> +	otx2_rxtx_enable(pf, false);
>  err_tx_stop_queues:
>  	netif_tx_stop_all_queues(netdev);
>  	netif_carrier_off(netdev);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> index ab126f8706c7..53366dbfbf27 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> @@ -621,7 +621,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	err = otx2vf_realloc_msix_vectors(vf);
>  	if (err)
> -		goto err_mbox_destroy;
> +		goto err_detach_rsrc;
>  
>  	err = otx2_set_real_num_queues(netdev, qcount, qcount);
>  	if (err)
> -- 
> 2.25.1
> 
