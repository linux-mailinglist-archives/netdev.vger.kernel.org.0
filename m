Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456096E77FE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 13:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbjDSLEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 07:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbjDSLEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 07:04:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2129.outbound.protection.outlook.com [40.107.220.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E3B65BF;
        Wed, 19 Apr 2023 04:04:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFjuXG9DKOQOYk0A8FjZfvv21S/M5+OA3lgv4ztt31l4iDZuPHpPkBwsO6h31ILH8ee4sUAxUHMtH1kkfe2WuamXx/q1GhkYwd2/79QJLCvlC+729K3M3XpA34aOURpUhl7yOQ2VK67qjXewIVKQlwcJrS6DadpuNDMeLLzbg7t5csu5ViKvgLV02jN6Eq7TDoo94d6yryLXVR/Qr7VujZfwLAkVvqFnpq1VNkjsdCqeQnQ7OTPaCwzdjmCSXMbANfUyWeF2ujWSnGYGa8t+nxNzDid8V3vw7udc5vpjYzielZ52PY8IbEGD2cg4kBVM0sr5UXY2jmldVpomRGxR5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txNyvIXzAOgHN1rtANTUc3gzSgzvUNeviRk+D3fhlso=;
 b=hCzy99kQacYMffrGB/KFU3BOkc5SbrUIkTFQPzUSLqjQXGPlUFBr8BwE84IrMdI7aNuBC9d4h0ghHRHBOqI/hasmmAdknZLcxWfF1sVlwDCsOds5Wo7Az6DJGp5VryacQlF0U5cc9BoGlysRA6ET9vmRx6gvkVn2VS/2homtGRJskOQa0xdNuwllDYCf9+K6HfUGVETDKLbzaoDnGeUA+pNavcctwoeIAAq9WIU8HK3Wk9CUYirclXEbcgDp6+uJhg5C7/Lc5FEAbtbAHCHv5CONShP2UMz0uznkd8MWib9l4YWfOHZv4JHT3dGCYpS2m/aXH7yKEguXmlDfiIV5kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txNyvIXzAOgHN1rtANTUc3gzSgzvUNeviRk+D3fhlso=;
 b=dU1oDgnM94eZD9ZiyXHjGCU94yjOEzGdghE7kO5VyAkxpcCkGvZpgUcJBYCqBFhlAQ0jvTIL0nFbzquXrn9N02JLUff5nWEKVopy2mvVCrwFFGw/wUnfODYI7wzcIltPyWCAo/rc7+se4MKIZgqEac41EbpWT93RvQyXzhAkxV4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5503.namprd13.prod.outlook.com (2603:10b6:510:139::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 11:04:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 11:04:05 +0000
Date:   Wed, 19 Apr 2023 13:03:46 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com
Subject: Re: [net PATCH v3 10/10] octeontx2-pf: Disable packet I/O for
 graceful exit
Message-ID: <ZD/KklR3coHRY580@corigine.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-11-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419062018.286136-11-saikrishnag@marvell.com>
X-ClientProxiedBy: AS4P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5503:EE_
X-MS-Office365-Filtering-Correlation-Id: 668dcf84-1241-4737-a45c-08db40c5ca66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6py7vsnKYBvOerRxVpB9r+UFPYJBVUN+RtB8/Fc2R3sM/nZBJj8xfK0MJIQRGWJDgp1dau1WSTw/32wF3aQZTGkWdw50nrurifY/Uf9Tx6WQ3yCrfm7KEOG/Yo8/u7J3WQ5n4yK0EyKsQai9T0kIWAXNgBBVuPiRX4DXgkUjBklmkgfVA+2+hNk2gqwDRGAOE+PqFhfvQ8LrKEThGyH6u65f9a+tx6MFtOeg+bdiihXWGHqI0TzvDcSH3Q7udIJEtAPIVfUzN+fk+DuJ4/+X26ZtTS3ob6X9aB9o/I9fNYI8EnupXcEvl+stwsk12LI+aw1PmecYrZUGmmprl7OOjBjXxZI+jVlPaqV0aqzkr5trEJlBzfHDIXzZir6LjOzRz5WSjyb/DRzTv1CgraRkYIkyPoWN+0zMZeXay+iNbTQJodZJGTfi6vm9nDvQhBJHbZ8FNFwNKdcFJtSxRwRx4ZApKSwOCYaqy8Q7Wujs5PvuJkx2iAXdLVMQ3tHC2rSCPjWm9wfTxnxf54/0vV0B3oCe1J8AjwBVpblIo13hZ6FAN4/S1xnjHAqBc/qp0vDp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(396003)(346002)(136003)(376002)(451199021)(36756003)(86362001)(478600001)(41300700001)(8936002)(8676002)(38100700002)(7416002)(44832011)(5660300002)(2906002)(66476007)(66556008)(66946007)(4326008)(6916009)(316002)(6506007)(6512007)(83380400001)(186003)(6666004)(6486002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WM4eh3wlHTLR4c2emn8gsXNhRJ1EAxD6LQ6PaYdqoQQZrw3FWxXa5DO/78ZL?=
 =?us-ascii?Q?kSXgtptYfIfZ8qTtdLOPXX+WpmzdwwhgBY8gDaAeQQnfIHdFFTdlF5/r0BO4?=
 =?us-ascii?Q?ScV2ALmH3LSPO9r9XAtqOaM5g3ReTUF8Pcewi52qLjzT/TSGL0gNUUILhKFu?=
 =?us-ascii?Q?mtj9I4H28ifsbYBU5W1+IynTxPAaJifY0V4uQMPLouHS06aJT0NzJU88Wt4j?=
 =?us-ascii?Q?PXDoAvBFtwb/QBaLthO0+fuz3F1BwgXalPB5AlKx9CbfNyQqkZEmjGXhvJte?=
 =?us-ascii?Q?HYqP2A53+ZgiWC8tfwvs+Nf+Z+H5Tf6i0479AcaicLJKdhc/QbD6kyosq3gt?=
 =?us-ascii?Q?l3XWfaeUuKKMqYeHcYNw11xt1whwLSpsFdbEjl7ll6MM9TDRJHtcuheMtaeG?=
 =?us-ascii?Q?9COYy/046qnmDMF8xTmC0LyEc9oB+YrOedZL4Izdk+Vstft95AMF2yaK9ydr?=
 =?us-ascii?Q?wUZHXRJ4EuwvJMP4wMZg5i2v6xRKI5vggSYGrW/RKUxAsCjFon2rmhfceEiA?=
 =?us-ascii?Q?qMk/Aqba5mYpaZuSpuy+xQhTk9fc0c2XTXbaJO5SBs6irMfecX60xFMO9RuN?=
 =?us-ascii?Q?8q1om/BBT89wIKDooYb9QPAvaAwF7zVJz3BE9tMB8g+NZ4ZJlUfk8CTlLHcw?=
 =?us-ascii?Q?63UGqw0wqC+12suqhf+pR82qjb0M1FfEaJLAk077vPsAbB1BCARKKHUSLMrN?=
 =?us-ascii?Q?AA1ZN6iMp3I/h8oMfg8jNOuVVGjnIhJK+BfasWam55d8FrUYqTe/MJSxpH4g?=
 =?us-ascii?Q?oRC+M/gmDBgYMWyVUI+8vJ+lxaysZ87QckI2pu5pZ02U8bzDEBDbU4FwJ7ea?=
 =?us-ascii?Q?ht3MnOG3ySCHXjyiEVNXLi1Fj1XLf1cdUSGbUvCaKVqGa2aXSwM2JQFdn5X0?=
 =?us-ascii?Q?3rULTRA4jLUUQSDDBZU7GIjpZv8LSdCFHd+o8pO/PDtQ5j8eQ49KnFE3iyal?=
 =?us-ascii?Q?70i70BBaQfdKBktFoZ90shfA9dlzQ4p4Orxrp1Ls5aT8ZaIol8xhhtPBgENm?=
 =?us-ascii?Q?ikscZyXb17n/nmML+J4hXDxeQQ2Xw3VdND9jlNmDKvBR51yvd1i5D+uunDH5?=
 =?us-ascii?Q?a2dMiVsICa/BYIls9gQ52Ytq6mKFMRXpk0d/DDVSniGsAWj01ish0kbG5cpV?=
 =?us-ascii?Q?0Lyli2U2tVPLpjJVZA4BmcqwDcbV3t5jLfSk/H81vCYG+vat5PmKCr7giebt?=
 =?us-ascii?Q?texMBuMsiIIcy6IGZcOjxkvZ9bUxwd7jAFMWcStin9nwDW1ZG48whXaKJ5PC?=
 =?us-ascii?Q?HcYVxUKNizedax7r/O8hje45pkPqD9z5gNny4kvut5yAQaxTOYwERDbVLC90?=
 =?us-ascii?Q?47bfn/2Lw8i9oXu0lGVKScAvGfRP9q+BylNzbKyoHyq4s+qa/vV/kS13/JdT?=
 =?us-ascii?Q?Smy2hRG9PPadl3dFEGHvvLm1hEZptPTHxEXYqUkTOLlXNJ5n8PJmrHA9+M6u?=
 =?us-ascii?Q?C7oOKVakhSOv/DefZPWO0XJxlc9c3z47dfWQIMGilcDjh7kUCjHp1y+tWJR3?=
 =?us-ascii?Q?G4rSR7bqt/aaSS4aUtm0KHgMkR8595TcROQAdHPzN9K3zLpaM1EDQSMqT/SJ?=
 =?us-ascii?Q?x8JJVu5mBAC8ONc1AkB711RCepFyvhIIYs0ifV/FDU0yrK9OTEVkzP9stnDc?=
 =?us-ascii?Q?AX2t/HDJCbiDQlOpMFlKQY7QJUHGM96wHHK3xif7IHcWC36tRKujwusMt2/5?=
 =?us-ascii?Q?gyivLw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 668dcf84-1241-4737-a45c-08db40c5ca66
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 11:04:05.3370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WrRB/x3oJn3cA5XQIRzoMKuiOxknRPQyuL/lfU64QGBiKVmEop8p/MhEMdHuDThPiDtK8ZlOmoeMwxNu0GI7Znc1K/goJApsw28S4/atQe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5503
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:50:18AM +0530, Sai Krishna wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> At the stage of enabling packet I/O in otx2_open, If mailbox
> timeout occurs then interface ends up in down state where as
> hardware packet I/O is enabled. Hence disable packet I/O also
> before bailing out.
> 
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

I think it would be worth expanding on this part of the change
in the commit message. Because it's not obvious to me.
And I do wonder if it is a separate fix.

r 
>  
>  	err = otx2_set_real_num_queues(netdev, qcount, qcount);
>  	if (err)
> -- 
> 2.25.1
> 
