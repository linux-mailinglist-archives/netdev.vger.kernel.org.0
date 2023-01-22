Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039956770B4
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 17:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjAVQrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 11:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjAVQrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 11:47:02 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2113.outbound.protection.outlook.com [40.107.101.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC201A942;
        Sun, 22 Jan 2023 08:47:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1BBJUqeYzQU4MrA3btzkq71iF6Y1nrlC3TvncQvDJ8+GmcO5OWYKrXwfarzm/lhr7cvq9YOR0C/Fv/xL0pprGkK8KHeNUeWrizXSbayOZTFITbX3uZYYHnOZuwcn++2jOZSmg4HohzYgETVpVIFGCMapqQGL8Cc+LsldOYpeDL2tnMtmscmxh9f49o1Sh4K6MXlP1tdHh9CvAZZCljiKGQuNhmuxwbLYu89aEoWa5FA6I5HMUES4eg+2IJJdcMY8SJEQS8m6NJ3mNTM9HjNGMubJHwOrkDt91cXpuWrdDYpzHPESjHIXnYehj+19Zmn8YraiEiJ5+b5zPw69Ya8BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w5R4SNmREknrQIxd31MiStFsJkkDGg1qblHUStZtM4=;
 b=gfsSu/HtF9QnBePIgAGfmDbbMRMQQjoJlMCoQ4r4vyH+pXUyCM9GgXSXJeIm1lvnFPRXfDZjKhMIHR3wKL4ZeBM8DXeypIHOhHnGezVkVQaPPSz5YFlicpkaLVN/uA7wbgUORhKPdfGAB1kcOSO8d9KcmzymRjZSusS3ikChVB259HH1MfDlYbLxxd7bTDGH8pIe0/eQ7piF+tAffjS4v7AQA0pOjd/FTXWCPEefyNc/K7hTgxfOu5rkcZ+p76LMI9s0sZnIULSsSfXrZ5Jm/apyIWTZ+hJIYL3OtuV530mshe2yaZfC2p+IDPnyfNmOLHf/08Lo30O/wLT1mMjBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w5R4SNmREknrQIxd31MiStFsJkkDGg1qblHUStZtM4=;
 b=DM6tZF4TZpFoFyn5hbaVfTlTTQPcwfta7uvZFwWsaSkVgqx/kVXqHhS0kseKpjDR0pXxOVOBr0l6gNzc0bnqpU6mnyfmwPr7PCqMOic/x//Tt2Te+IlED63ZLtpGkWA7WdcCqtNd5yUISVHj+Nr9N9HJmbeLZ8rWbC7MIYEbSqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5082.namprd13.prod.outlook.com (2603:10b6:610:ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Sun, 22 Jan
 2023 16:46:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Sun, 22 Jan 2023
 16:46:57 +0000
Date:   Sun, 22 Jan 2023 17:46:49 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        saeedm@nvidia.com, richardcochran@gmail.com, tariqt@nvidia.com,
        linux-rdma@vger.kernel.org, maxtram95@gmail.com
Subject: Re: [net-next Patch v2 2/5] octeontx2-pf: qos send queues management
Message-ID: <Y81oeTZiSTOCXsoK@corigine.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-3-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118105107.9516-3-hkelam@marvell.com>
X-ClientProxiedBy: AM0PR10CA0072.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5082:EE_
X-MS-Office365-Filtering-Correlation-Id: f2b9f074-3338-4878-31df-08dafc984602
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7yCVe9bfQJ7aII3kPeClermnAr4WzBURslm6I+3FNi/PxkxV2hQeo50oBSORz0m27JJ90gzPdm5S8GNcrMJZWLhAYZb5HM2Hxgj+halyAd0dnRMwJblmfYo22kaTIVhgkFsU69Dxy2YLewZl3IRrMzSkIECoECRnFf7gYAzUQhEfSylbjDT+ZoeuWmhY1tMFgAqWhBqbJjWIEr95qVduvgR9Uy5i0bOgYwO9TJjwB3Kgu2KWyZYao7uGRQyo7P69uuFPK3uHMxxKiyb/QhZRuPau4H9DmnaCek4RRk2RwiH4PCJLofaKu3Z3fDCjZs6BRZYEU7oJmgf5Og/kUCvlovdQsOf3VYFvehqFuqKC98hVwqQ2boLgk5VG2spqHGdHe0WaqJx6hQ3k1dijnjxTFVgaq6QA7Ukw27wbY6cFZEj/wtAu+dlpmLbBHznWjtE7Wnarr7YJDnTw1OFQGSFg8wGcMW0yqScTALDhJptj4trYKnAynd6q9Nd/DYcN7MzACP+6Iq+X27XzdHztTk6azU+ZLrepxt+pVk/wHTBgGBKAVRxCorzr1U+ZDK7kM1fsvxye44NXUApwJ/3qYEh9RX4wtrnITwytryCbfohw+ykYOHimDQobrgqH0MbH7uZ0DbTtlwl5L/rxpOF1St6b8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199015)(316002)(41300700001)(66476007)(66556008)(66946007)(8676002)(4326008)(6916009)(36756003)(83380400001)(86362001)(38100700002)(6486002)(478600001)(6666004)(2616005)(6506007)(186003)(6512007)(7416002)(2906002)(66899015)(44832011)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fXdKWPSwtWC5l1jn+9EVFUFi6FMkiFRjohuLpHT+Cc6b5fZ4e1HfJJLWdtOk?=
 =?us-ascii?Q?vhCMJVYZ/ub0YJbiSDty+48aLtUJ8fUnRgwLLGwKwMiLhUhdaByY5tms6vxy?=
 =?us-ascii?Q?XcYEmvW52fh3U8n0JuX6I1vv8G0mpIjtrA55lR21uu9+/JvDK+4xmN8I5iMx?=
 =?us-ascii?Q?KQK73p/KRZ+NYRt1UtCOavzpH6TAWdx0I6SAbC/q25tPIa62wMFgCm86hOif?=
 =?us-ascii?Q?XdylB4p50rvFstVqaiQg6FH4FC9rxTZ2Mtn7GRrBibChRdpq/tSQFsji4aWz?=
 =?us-ascii?Q?3XVTLl5v9msY2szKwkFIkqXMos5UmDkOwOSWnF4rzYtZoEWFD3xxgJMvqyzz?=
 =?us-ascii?Q?lOzM/WvLWbM1z03nNHTcjRlpSODR3/kg0EpBVoP/gkHngUUSJdaValYFcBaz?=
 =?us-ascii?Q?9Vynt7xsLYhYe2syFkCtPtlz2jqtX1HtvzThl8rwZJpA+O8ndYqknoomhkLU?=
 =?us-ascii?Q?YlC9xOR879oEBtCuC1iKI6hlwzjcbvHLMt82VWjrbbuSEA72u5YvxrKIw11r?=
 =?us-ascii?Q?SkLxBiAgIGMw/FP3h8m8sS5VKte/NITo4kcnnFXiq+1wzeUFZ39R4V3Z8CJL?=
 =?us-ascii?Q?ILKvHixzIw8sPTRm9e1nkYBQq3vdJoU1KSe4pqNdgRcATjLcPwzdEckooeGL?=
 =?us-ascii?Q?Tqtj5UmYGetDVSi4R/vJyPdlCa9hm6kG1nfgVH/9PFTZCgX/TYp0VH8Gn65k?=
 =?us-ascii?Q?+GqGwtCFrjqgmri9sdHo/cgxG6cI4Wv///nHVT72QcOkdn2m5d+RdxeYnGUX?=
 =?us-ascii?Q?LGoFe7gGs6K4R8AqUSwdkC83A8M7ynY+mg3+YC6b5o0s+AzhlxX93ZNnkb36?=
 =?us-ascii?Q?fY5Df5xZ8pwdD5xpNIivV9jzBPF+8ps4RWr0caKkHGLRZ9vYFlMVSxSHD32e?=
 =?us-ascii?Q?owREyf8cz+5p/AliUU1u6bjXaTawp3nZR8zCLnd+IH6DRe80uyPA7JWGwjdU?=
 =?us-ascii?Q?m5TIGoyRMZtZMjTS1Sg+0AIJ5zEP7shW/RtazOVbBVYrRsN2Crnvs3zwlnLu?=
 =?us-ascii?Q?ObEJaQ/JigqgF2yrdlhPJ8+UZVEB1EG5uQHn0WJ9/7tW6pZCYMDOHU/EyRPW?=
 =?us-ascii?Q?mxWVPIsvhIjwQne9cAPv8bObecBvRnNeSQjC/YSqfOu84OvHUsKJFzwpGhz9?=
 =?us-ascii?Q?E/P31lOwHcpTWzc6bD2pUxcFu554WgWeWn1xAuTvxbvKG5/aAulnS0Pespe5?=
 =?us-ascii?Q?wrwJp1SmJlYLuOerH55baepPJ7DqsDs4QbemuQ0tELPTQ9vW5q0oNOM/GTFZ?=
 =?us-ascii?Q?H/U74oR01XCZn+cPEt+vpbVA34C0thgkGg605+A/7WES/ni+5SEiAXW+PYLn?=
 =?us-ascii?Q?aAKZbD6FjAPh8cK1qgo9UVCk8swy/jbv295AcEqtS+oAdYsB1PsZva6tXJgw?=
 =?us-ascii?Q?koT4+qiXhWOw7olYTlHxRemx1e7855VsvDMlQEPL0cUnNtW3DZi9ClGeMiOk?=
 =?us-ascii?Q?sNiFEfUZbfbWIB/dh3vM+PWY8wFAvvyKAuR5hmdUhI14z4m1/4F9pYvmHvCR?=
 =?us-ascii?Q?1nKcGk9Pj2QLzm03rjuoy6cohB+rUGpRd2LhQg+l4cFx0HBmzHKIKLY+mscS?=
 =?us-ascii?Q?JJyYtj+0ZIvF7R5ZXl1/0HhF5iypFq1XOm0rI26HtmvlpXnFFaCiYX8QmIDJ?=
 =?us-ascii?Q?097ORKFRrUrSc4IDLX/WeXfkXBaD/I8LcwCQos9/vIZuhKL/Cn3ag5qMMAOV?=
 =?us-ascii?Q?ZB+ZiQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b9f074-3338-4878-31df-08dafc984602
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 16:46:56.8311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFQx/w+mwxWQtxEjimpKNTm3hrdZE2UQrBSk5nvvhxnOtsbgs09o7l4QTlt5WJxEPZh94A31QumIeYGDTejhsBJiYyjKITjcpOaqB3UA7eM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5082
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 04:21:04PM +0530, Hariprasad Kelam wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Current implementation is such that the number of Send queues (SQs)
> are decided on the device probe which is equal to the number of online
> cpus. These SQs are allocated and deallocated in interface open and c
> lose calls respectively.
> 
> This patch defines new APIs for initializing and deinitializing Send
> queues dynamically and allocates more number of transmit queues for
> QOS feature.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 88f8772a61cd..0868ae825736 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -758,11 +758,16 @@ int otx2_txschq_stop(struct otx2_nic *pfvf)
>  void otx2_sqb_flush(struct otx2_nic *pfvf)
>  {
>  	int qidx, sqe_tail, sqe_head;
> +	struct otx2_snd_queue *sq;
>  	u64 incr, *ptr, val;
>  	int timeout = 1000;
>  
>  	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
> -	for (qidx = 0; qidx < pfvf->hw.tot_tx_queues; qidx++) {
> +	for (qidx = 0; qidx < pfvf->hw.tot_tx_queues + pfvf->hw.tc_tx_queues;

nit:

It seems awkward that essentially this is saying that the
total tx queues is 'tot_tx_queues' + 'tc_tx_queues'.
As I read 'tot' as being short for 'total'.

Also, the pfvf->hw.tot_tx_queues + pfvf->hw.tc_tx_queues pattern
is rather verbose and repeated often. Perhaps a helper would... help.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index c1ea60bc2630..3acda6d289d3 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c

...

> @@ -1688,11 +1693,13 @@ int otx2_open(struct net_device *netdev)
>  
>  	netif_carrier_off(netdev);
>  
> -	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.tot_tx_queues;
>  	/* RQ and SQs are mapped to different CQs,
>  	 * so find out max CQ IRQs (i.e CINTs) needed.
>  	 */
>  	pf->hw.cint_cnt = max(pf->hw.rx_queues, pf->hw.tx_queues);
> +	pf->hw.cint_cnt = max_t(u8, pf->hw.cint_cnt, pf->hw.tc_tx_queues);

nit: maybe this is nicer? *completely untested!*

	pf->hw.cint_cnt = max3(pf->hw.rx_queues, pf->hw.tx_queues),
			       pf->hw.tc_tx_queues);

...

> @@ -735,7 +741,10 @@ static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
>  		sqe_hdr->aura = sq->aura_id;
>  		/* Post a CQE Tx after pkt transmission */
>  		sqe_hdr->pnc = 1;
> -		sqe_hdr->sq = qidx;
> +		if (pfvf->hw.tx_queues == qidx)
> +			sqe_hdr->sq = qidx + pfvf->hw.xdp_queues;
> +		else
> +			sqe_hdr->sq = qidx;

nit: maybe this is nicer? *completely untested!*

		sqe_hdr = pfvf->hw.tx_queues != qidx ?
			  qidx + pfvf->hw.xdp_queues : qidx;

...
