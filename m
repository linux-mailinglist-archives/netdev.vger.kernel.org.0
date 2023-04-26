Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD546EF198
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240379AbjDZKBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240081AbjDZKBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:01:07 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9777835A5;
        Wed, 26 Apr 2023 03:01:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQlAp9XE4wh0wWXuaaI7UtN7KN5kQFpn1MdpKPHFjSXhMWbK16H8FOcIhGJRBnpfKSz0FIQkIn82LGTuP3FroACfQHYNplreXbI8dvbaDdZpzP0uVT84DTlDr6P95CCRXb1ae9MGas/zdx9NZ0qallFesRGCj63oLA+sL427xiQsucuqbJ81TVDmJQLOrAjLgHhtpAlYIhKqDtwKHNMc7pSnznBD8p/GIcmQr1mIOnbJqpX8bHg96tI8m4H2EoE/FaDVBMXI9ObHNaeGx/sXk32v21EomSV99j61ZJUCjfd4BT1GMQt9lOjX6YE6pAoLfXumwhR2mv35VLz4e9OpAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhVdVrvea7gxOgIMc+7+TCNZxytBNHapaFoIMH6CINA=;
 b=nRhTs5b1HR2K5T5p0R+IcGGSHlI/E5pyciBvkLaDmW87tJlgQKatZazeuRJ+lalB6VVw8S/vFDp1eIDjiF1XaTxG7KhKMPyaug4V+MWId9sQdk6YqWvACHpAJyxiyBtdTzMPjt73Jx0QD5qcyHdH6WyMSrVxiZAXs5fIpMjaoXVDvb33S3mTuoUyhY+1OT/jS920qBsca1M+wsUC6MbadrqODtXoeRQHDXQELWQFJEE35Zwqd+9408gWDkillsL5ci9PWqKqbEeBDNHlMn8MLL451VZ5czqG4l1rAb8Z1TIMRWKzofE3cQoPN+m3DkxHJKfuhAhUtcRSWrGyhwMQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhVdVrvea7gxOgIMc+7+TCNZxytBNHapaFoIMH6CINA=;
 b=l49YN5Dq+mlJ6cuVsTCQ1qnIPpOTZWk2ZuUpYAfi8g0f95TA2V/AfTY2V2DWDf42e3QBW/DfWZ5SGClGXQUGaZnph5rZdrkQVOsD65JZzOPZ39gMnr914fyEs/QaoQZGcd2vYEiIPnhnUIhvSqWqe7JVhwv7zi4q2/u37C8b8X0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS0PR13MB6233.namprd13.prod.outlook.com (2603:10b6:8:12e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Wed, 26 Apr
 2023 10:00:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 10:00:56 +0000
Date:   Wed, 26 Apr 2023 12:00:49 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v4 09/10] octeontx2-af: Skip PFs if not enabled
Message-ID: <ZEj2UYNavsn0xE/D@corigine.com>
References: <20230426074345.750135-1-saikrishnag@marvell.com>
 <20230426074345.750135-10-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426074345.750135-10-saikrishnag@marvell.com>
X-ClientProxiedBy: AS4P250CA0029.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS0PR13MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: f06f03b2-bf58-4ca0-ed9f-08db463d2115
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJc972IFIL1CqKF7D94RXwtMj2OQb1CpFd8LBEMxppUsdSoaH5kOCf09m4avRtZ+Mbfc4d8kjELzTsGyyrzz8YRHVghPTsRVF357prVEJYRgLKCSZtTPcjmF96knZzNxG9OwLMGHqShN9CHwY/KH3a/HY/fKLveptTUpSnJSejzKYGV4fIXXm7jPS9WkUaeF4NyEsq06ZSYk2HTvmPAit+XN84eutPga28+WN4N4OCh5cZofoVjBXqGNuoe6cMbgZGW0TKL57s1TxZqtieUIs1vezgDJ8yif+7IftTvKb6M62H0YZhQezFhQaA/3jqbXFy0pKK8SceTpsS+y+Dn0mouPsJ4CgjKkunCW/4DIaGw6Z0/Xn/s85HJktZIO6UlcFgbQn1/oGMji30m9pSeD6Kq8uYFbtGnoxjL8JA46lMrv13GK3zozI9oJhuByMaVqmcn3Wg6Jx0UQLIR5gDJxUdofHkOIRS3yaZAkh9L+oiQ1ywqxXM5DCToE6Y8CIyBUDdl57fgvT34tzGZ0GjCSQxNELJoPoPP5MI7ma4fIjjzsuPm/Sr00pbKKBGbfNTPB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(366004)(136003)(396003)(451199021)(2906002)(86362001)(186003)(6506007)(6512007)(83380400001)(66556008)(7416002)(66476007)(66946007)(478600001)(6666004)(6486002)(38100700002)(36756003)(2616005)(316002)(5660300002)(8936002)(6916009)(4326008)(41300700001)(8676002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VRIywLqxsGtl3NsPqHQaWdFic66lui4gKj7ndpGLHL3JrgVAXTFhq0BNJ32w?=
 =?us-ascii?Q?0xO1RalK888F6jYp8D2GVCme5Dygve3z4xOuEIbpwFOCibJp7aDcD5FNlXDb?=
 =?us-ascii?Q?YciUUcQyd4teO/8V8C4lPKdUqh0UBDfMgh6Lw3xEQghyyRNr49/ysw0gQQ82?=
 =?us-ascii?Q?uHEWePfWed7brxEWd1G0cL7r6vtYuYOgaNjnipYSJTY8vZ/peZP60oR3xR7k?=
 =?us-ascii?Q?Wtj8SApPV/z8LHoh7g2eAVA2pzlS/7lnX12+j2QFGSuSWBz95yxCSYnDRNF9?=
 =?us-ascii?Q?x1bITiFNVNWeWH4XlzDcW1UaHwNJcaP/Xbkf57zI/CDu5a+nqjVQ99YqLPyx?=
 =?us-ascii?Q?hmkMZVMSRROYcm3/ogC+buXWxRImZ1yzcPiK5k0sLy3zp5Oe9HH4ND2lrtBa?=
 =?us-ascii?Q?7IKN7EUfPQXbUu83W6TgV7a5SDNcQRt3jR7hSMPG75bFk2v+sc84NKxMaKGb?=
 =?us-ascii?Q?6BQuJF3Hw7DiC2bXruwJF/5g2KrkYRjlaNcYxT3NHmuaryGFJIhuLErFpO9m?=
 =?us-ascii?Q?v9dCIYYFf9vOgJo8EIqm+J5JK2HH5iv4YMpVH/LxWNEQal4HdenYJA4tBgve?=
 =?us-ascii?Q?wEF5zVmJXTkdy5pHEOoqy+bPJ9YtOock0hPCXB1IW0mIy1MPk36vCRtXcbKC?=
 =?us-ascii?Q?eTTtC0y3NDDg3pUXHbQszTVM+Ge7lPOO5d9QF8nqZG0hoS3k6L/S3VuXSR1F?=
 =?us-ascii?Q?iQqGGdAl2cxqmwsZEZC7FGBlaJfXgePq10xMlN5ir+QiQCoycj0ZfziRljpI?=
 =?us-ascii?Q?gM9mGzPi4ap2in840p32h01ojp0POsWRds7wMc7sCGct+10UL3QGZ7uVrrDo?=
 =?us-ascii?Q?hZBDq0pEJpaJf1mdb/MrftzzoaXNdt9243exq9KM49gOIhRFZMg1DoQnrppg?=
 =?us-ascii?Q?0F+9jLUCOfgzBAxrEx2qWCBM7prk0mwdS9c/mLjvewNm24apX+YslwwWhDFz?=
 =?us-ascii?Q?HA2UmoipFxcCB8eHUmh7Mhbzyc0e5ThvmMe6AaanpBbDeO1PwXmE+SRYiVLM?=
 =?us-ascii?Q?vMRUNG09p529b2hoynlAQyCFjCOhYySemXnuFTle5MzTPsei6NUoduT5S3P/?=
 =?us-ascii?Q?/+7Sa2Aih2tRLbh9hUVbbGG1LGS4f/jOMlf0uZX2IF7y9GT1LoSrUfHMAbwU?=
 =?us-ascii?Q?Krl+3IiPmJA8zvI1DEHQoqQdlKTyVLEO2EC5MXLZAbyeFuR2dmIuFwdbULB/?=
 =?us-ascii?Q?BF1FkmkFtekTrEtJRNnfpPDGW/RDys726mPxxHXagWqyxyZ7lwMe2bEkHSNu?=
 =?us-ascii?Q?XNIXgKNQXj6eu9JPOknFeMTqn8ghWiwnmPvauCr0mq+rNfpsryc/oZxWvymj?=
 =?us-ascii?Q?P/5qzKGfVVrYS52O93DMBiZzSgngcZ2fFX7liSAHNkXbJxiuqYvdu6itCF7A?=
 =?us-ascii?Q?3NdzISoIryEj/Sc5rDc6GW6eazxVvve6nezTjmRuXEnd78aGJJPFbItyFEnG?=
 =?us-ascii?Q?zn80Z9RDJM081dpVSMG8R7nUYs8Z2xhYWG9UYFW7mCfWUa2Z1i7ygJfLsli1?=
 =?us-ascii?Q?hZ1RuIJbOJUWp56jwsqtUXUmsgA5kGUSUeUdT6jEOhTXj9Y9wsLSd9GMOhYS?=
 =?us-ascii?Q?+ahcMMm4foXsda+mTs5WC3ltFulon8LzIzv+U4xvBPY4t25+Eiez3anZRAf0?=
 =?us-ascii?Q?8JaK9ufmZn+TRfeb9eKYaxHWoKJJ7g64nZmsholZhXzxk91YRL72blbFK+Fd?=
 =?us-ascii?Q?T2nk/Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f06f03b2-bf58-4ca0-ed9f-08db463d2115
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 10:00:56.7164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLcyH2O1dvQA+csy+6uC3dP1mSAgxphn0XggvaXWsFFpRzrkg7BOq+TxqZ5skg4kuJ5L9bAHGCqvtP6N6JG0kNMB1YIHJQ06/a4bAbEEBeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6233
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 01:13:44PM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> Fiwmware enables set of PFs and allocate mbox resources based on the
> number of enabled PFs. Current driver tries to initialize the mbox
> resources even for disabled PFs, which may waste the resources.
> This patch fixes the issue by skipping the mbox initialization of
> disabled PFs.

FWIIW, this feels more like an enhancement than a fix to me.

> Fixes: 9bdc47a6e328 ("octeontx2-af: Mbox communication support btw AF and it's VFs")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/mbox.c  |  5 ++-
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  3 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu.c   | 44 ++++++++++++++++---
>  3 files changed, 44 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
> index 2898931d5260..9690ac01f02c 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
> @@ -157,7 +157,7 @@ EXPORT_SYMBOL(otx2_mbox_init);
>   */
>  int otx2_mbox_regions_init(struct otx2_mbox *mbox, void **hwbase,
>  			   struct pci_dev *pdev, void *reg_base,
> -			   int direction, int ndevs)
> +			   int direction, int ndevs, unsigned long *pf_bmap)
>  {
>  	struct otx2_mbox_dev *mdev;
>  	int devid, err;
> @@ -169,6 +169,9 @@ int otx2_mbox_regions_init(struct otx2_mbox *mbox, void **hwbase,
>  	mbox->hwbase = hwbase[0];
>  
>  	for (devid = 0; devid < ndevs; devid++) {
> +		if (!test_bit(devid, pf_bmap))
> +			continue;
> +
>  		mdev = &mbox->dev[devid];
>  		mdev->mbase = hwbase[devid];
>  		mdev->hwbase = hwbase[devid];
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> index 0ce533848536..26636a4d7dcc 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> @@ -96,9 +96,10 @@ void otx2_mbox_destroy(struct otx2_mbox *mbox);
>  int otx2_mbox_init(struct otx2_mbox *mbox, void __force *hwbase,
>  		   struct pci_dev *pdev, void __force *reg_base,
>  		   int direction, int ndevs);
> +
>  int otx2_mbox_regions_init(struct otx2_mbox *mbox, void __force **hwbase,
>  			   struct pci_dev *pdev, void __force *reg_base,
> -			   int direction, int ndevs);
> +			   int direction, int ndevs, unsigned long *bmap);
>  void otx2_mbox_msg_send(struct otx2_mbox *mbox, int devid);
>  int otx2_mbox_wait_for_rsp(struct otx2_mbox *mbox, int devid);
>  int otx2_mbox_busy_poll_for_rsp(struct otx2_mbox *mbox, int devid);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> index 8683ce57ed3f..242089b6f199 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> @@ -2282,7 +2282,7 @@ static inline void rvu_afvf_mbox_up_handler(struct work_struct *work)
>  }
>  
>  static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
> -				int num, int type)
> +				int num, int type, unsigned long *pf_bmap)
>  {
>  	struct rvu_hwinfo *hw = rvu->hw;
>  	int region;
> @@ -2294,6 +2294,9 @@ static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
>  	 */
>  	if (type == TYPE_AFVF) {
>  		for (region = 0; region < num; region++) {
> +			if (!test_bit(region, pf_bmap))
> +				continue;
> +
>  			if (hw->cap.per_pf_mbox_regs) {
>  				bar4 = rvu_read64(rvu, BLKADDR_RVUM,
>  						  RVU_AF_PFX_BAR4_ADDR(0)) +
> @@ -2315,6 +2318,9 @@ static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
>  	 * RVU_AF_PF_BAR4_ADDR register.
>  	 */
>  	for (region = 0; region < num; region++) {
> +		if (!test_bit(region, pf_bmap))
> +			continue;
> +
>  		if (hw->cap.per_pf_mbox_regs) {
>  			bar4 = rvu_read64(rvu, BLKADDR_RVUM,
>  					  RVU_AF_PFX_BAR4_ADDR(region));
> @@ -2343,12 +2349,33 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  	int err = -EINVAL, i, dir, dir_up;
>  	void __iomem *reg_base;
>  	struct rvu_work *mwork;
> +	unsigned long *pf_bmap;
>  	void **mbox_regions;
>  	const char *name;
> +	u64 cfg;
> +
> +	pf_bmap = bitmap_zalloc(num, GFP_KERNEL);
> +	if (!pf_bmap)
> +		return -ENOMEM;
> +
> +	/* RVU VFs */
> +	if (type == TYPE_AFVF)
> +		bitmap_set(pf_bmap, 0, num);
> +
> +	if (type == TYPE_AFPF) {
> +		/* Mark enabled PFs in bitmap */
> +		for (i = 0; i < num; i++) {
> +			cfg = rvu_read64(rvu, BLKADDR_RVUM, RVU_PRIV_PFX_CFG(i));
> +			if (cfg & BIT_ULL(20))
> +				set_bit(i, pf_bmap);
> +		}
> +	}
>  
>  	mbox_regions = kcalloc(num, sizeof(void *), GFP_KERNEL);
> -	if (!mbox_regions)
> +	if (!mbox_regions) {
> +		bitmap_free(pf_bmap);
>  		return -ENOMEM;

Maybe it is more idiomatic to use

	goto free_bitmap;

> +	}
>  
>  	switch (type) {
>  	case TYPE_AFPF:
> @@ -2356,7 +2383,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  		dir = MBOX_DIR_AFPF;
>  		dir_up = MBOX_DIR_AFPF_UP;
>  		reg_base = rvu->afreg_base;
> -		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFPF);
> +		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFPF, pf_bmap);
>  		if (err)
>  			goto free_regions;
>  		break;
> @@ -2365,7 +2392,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  		dir = MBOX_DIR_PFVF;
>  		dir_up = MBOX_DIR_PFVF_UP;
>  		reg_base = rvu->pfreg_base;
> -		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFVF);
> +		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFVF, pf_bmap);
>  		if (err)
>  			goto free_regions;
>  		break;
> @@ -2396,16 +2423,19 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  	}
>  
>  	err = otx2_mbox_regions_init(&mw->mbox, mbox_regions, rvu->pdev,
> -				     reg_base, dir, num);
> +				     reg_base, dir, num, pf_bmap);
>  	if (err)
>  		goto exit;
>  
>  	err = otx2_mbox_regions_init(&mw->mbox_up, mbox_regions, rvu->pdev,
> -				     reg_base, dir_up, num);
> +				     reg_base, dir_up, num, pf_bmap);
>  	if (err)
>  		goto exit;
>  
>  	for (i = 0; i < num; i++) {
> +		if (!test_bit(i, pf_bmap))
> +			continue;
> +
>  		mwork = &mw->mbox_wrk[i];
>  		mwork->rvu = rvu;
>  		INIT_WORK(&mwork->work, mbox_handler);
> @@ -2415,6 +2445,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  		INIT_WORK(&mwork->work, mbox_up_handler);
>  	}
>  	kfree(mbox_regions);
> +	bitmap_free(pf_bmap);
>  	return 0;

Also, this could avoid duplication using:

	goto free_regions;

>  exit:
> @@ -2424,6 +2455,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  		iounmap((void __iomem *)mbox_regions[num]);
>  free_regions:
>  	kfree(mbox_regions);

free_bitmap:

> +	bitmap_free(pf_bmap);
>  	return err;
>  }
>  
> -- 
> 2.25.1
> 
