Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6E96CD5B6
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjC2JAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjC2JAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:00:02 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2135.outbound.protection.outlook.com [40.107.223.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8456B59C7;
        Wed, 29 Mar 2023 01:59:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6qZgtEtZWWzeH0DrYvCfMEu7EBmR//HtcM5DbnSzqefMC7QQ3/gMoti1UCZD9n3NgbLPZwqEyk7QNs8iWf4um6xZGfD+AbFib/19KLImHyyfifx55cB6IXkOHP76YkWE/KnoUJ8YXop8m8C9FqlCQBbgi8E/6rwoSYWFQd3oYpqfT71wKtINU6AoOvGqnERUVLz8+VDoqwHQgG+V3v+Uakn51iVr6jmbQcquiXOt1pyUUod62htzbYATsZnh0f+wZiDHcUVX0lWzyQYwvqcruPhJ9ThZsVolHeaqQNiF8i+T7oObBgsBKSmrPkRVgBVTmQAWF0+9t859AdtzCH2TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuNKC9pH4LO7yqdB+55VHHoIvsBm8d1wUAcsqzYLARI=;
 b=gW8sMlYtixVcFIF8kcF9vJ2/zDD0A6XD0iGec5rWvmWADZgwVw0Y7OXYQqBoZ0eWBG3SyxyLNm9AhsTZ06Q4lLDjYzjasrYtxwIgmZeGOct/+IzSZDoIkl4kSOzoKXGCGDpU1IyoyJfAOYHhFgfL/rMm7IqzfcCdQNQWVA+fKHORvViuf60C5Ipn6kn7YgObQhenjHuD2FPVsk/UqS4SJ0g9cevDdqNQ5/P4iuuoUzr/alWaC8lbCjU7ZjjsT6RCel+ZbuC8GX5jCQdaHOBlPrd9YfaUQgTvc4Mis/udeq9lUgtqVZpb95beCFavDrSMLI7N8YRu7di7QiSWU7dM8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuNKC9pH4LO7yqdB+55VHHoIvsBm8d1wUAcsqzYLARI=;
 b=kGRZdpHxQaIIcsmdhBKAFSSfe+Lx1dAAlxq1uqTnf6cDPqo9pcI4LhVLWJ00iu8MX+aQMdQ2PvK6pOea313czwaosrDm4615S4egJHStmYayguX28AYrn9fcp21lMMiO+hbApx/pPB7v+InZizru6r1ZDcYbXHeMW3XCGPCoQJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3800.namprd13.prod.outlook.com (2603:10b6:610:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 08:58:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 08:58:59 +0000
Date:   Wed, 29 Mar 2023 10:58:51 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v6 vfio 5/7] vfio/pds: Add support for dirty page tracking
Message-ID: <ZCP9y/cmfB4acIOV@corigine.com>
References: <20230327200553.13951-1-brett.creeley@amd.com>
 <20230327200553.13951-6-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327200553.13951-6-brett.creeley@amd.com>
X-ClientProxiedBy: AM4P190CA0013.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3800:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ed571e6-8dc7-462e-cf48-08db3033d595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9gWjwQWK20fWcTCi162objiv7GNiK7WLVNWIRVe4aZ1NLplH4V6H6RFQIgOSiR508z3ivjXVtoGqnpqSB/SxAMX65iUWwqY5Faa8m0Dg8ggYq3n6FjhcwpdSN0FjVAZBoa1Ierhy8s9r+Rv12T06QDtQTJHuhyFDkBayk2crD0hsKrar7rK6Stw5Ol91OBY6UGZUFWhQhkbxSEeumIPh4IN01T30PY65cXL2sGtvWiMhTAS3OrvhidNsMGijIX4AMQ0ikB31GD8oki91fJ2yx301yBNTDcVJsXpR+nOCVDS0HhwjgAdgWelCCjOuhVH8s6lZDMSN4P5OeFWA25U0VCoZxjBj2Mb2iSANEPnabL+CLAGbDa2xKN6S9fKHd0e3snr/kvqHul5hc5LzTaKP7xpKCke3gKZOUv5QkRi8cjQ83JaZbWXr69tvEXhfoHE8hrh/R+7NxllMEwUc2gi8Ot0e8Kd1xqMgm9fQ0qjDLlNpne4Gy2v8pNd2kV5xNn2w0Zl+IzaG0tbQBpc7Qe9WcvrMhdNPrYWycGDYrClmr1h3XYRc7qMaZr+Sv+u7Y9OJaJtGp+X6xtDpYmZTJTvxXehZktE6q4a9eUKU+EeJp8ttKo6gF30UtTPoH19obGKLXJgFzofNTqsuD9H/zBLzCICguXMTHbvutmfY6SUdT4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(366004)(136003)(346002)(451199021)(83380400001)(66946007)(316002)(6486002)(6666004)(2616005)(6512007)(66556008)(478600001)(186003)(2906002)(86362001)(44832011)(6506007)(7416002)(5660300002)(38100700002)(36756003)(41300700001)(8676002)(6916009)(4326008)(66476007)(8936002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K9kcJPELw5EZeKJT9M8c/jJBlLSIz7MfDRkh81rMgdF9sGTkcWfY4yMII6ew?=
 =?us-ascii?Q?rE3jey0/EcZZa7gn1PWlGn1zh37MoSWRLguyqcIJAjqifgxvPxsZT1t4hRDm?=
 =?us-ascii?Q?iV6dwXf8qTUtMq2N62lXurP8E1pflgG6O1Fh5CtEE5OmFi7V9bI5QAItr6nq?=
 =?us-ascii?Q?fpwjqYYpAfJW0qF8QuRjXWzdxXIz2ZSUgWJEBQHbsTbDF+K7rxm2Oo964OEh?=
 =?us-ascii?Q?1tCuJtf8jTbvMhX5R8ZbknjYMUO2aTJtPqJfbAp66VyKSnhx7OXtt8XNfAQA?=
 =?us-ascii?Q?fabN0MuizAfLropo1g33RegeMGwsfAb9uMRFMay5hL19WEJlZOXtsanT57E8?=
 =?us-ascii?Q?TZB6zdz5FjNf5XX2HW4V7/eZmpqnMjLfXsri3TY2lBahXZXT10Ah41lvCAWw?=
 =?us-ascii?Q?n0fjS3JxoCoYYww5q6sndGR4shDbdRjY0Kxm5hIucYsDXX6cGvgoE7wAenn0?=
 =?us-ascii?Q?PgAsqDmX9D6X9g/am2krqttd1VROwdIQWR9+TTsQhOAoEdtnUHEIS/Gf+g/J?=
 =?us-ascii?Q?iBROcYhpUK2LESGyFceZFdMXFWNmCVsv3jTRQU05tpiHFlBFe5jsjeu7UJjR?=
 =?us-ascii?Q?ps3TjjPqzRii9q3LWytUD9Vn040Mnni1fm9SUJprs7i9vvHsB8HLSyRdOuc6?=
 =?us-ascii?Q?Tb/z08UtfGcXPgZKgX8pFWXNoTsRJW6CxbhzDIEGNTWKCZEqT4Dk/Mrm+mO+?=
 =?us-ascii?Q?8zRYG8HLIVgzq3MpBhtZiVHeVchXmrasixS/g0o1pT/kbrX4sEypdYlnzGkh?=
 =?us-ascii?Q?ThdLmw3pLdq3fOYpEdj2ds8R2mGMCvTdK3om6y//ZqdsjK6dQiFhHFcWjtKk?=
 =?us-ascii?Q?O7Mwf1RbZZOzsMEIyuPwLc9SJ79J3UlUodVZEkPfLGfMWzBZ6vTGCBqQl3PM?=
 =?us-ascii?Q?MEXIj/gZ5CIRUHARWzfSKHuD0EuY6YP5paqGDwc5m2jr42TyR4gJyk2h+3ux?=
 =?us-ascii?Q?en3z5LJX4BXWwbQfWlIm+E7dflH0bY5QfzgPxXqNLpk+BBh9v/2gd5lV2ScF?=
 =?us-ascii?Q?fGkNrEMK68HGwiN3UNadL6dC/dQwhJqnTfWQ1UK/dcNwUxuVr1KWbVLhQq/s?=
 =?us-ascii?Q?TpDJG8+xUdNmlPc6sPUgqh7yUaETIJGGuFZHKcOJ+pf6O0QMR4jFJ+dtcgSF?=
 =?us-ascii?Q?mTrey30whv1/CRQJzTrZ+wn/0g0J2LrKJHvU6jrr6gOu2GywZt6iru1T7FDb?=
 =?us-ascii?Q?DLiiPfLMTPGX1xv5OxdqFTxlKBMirGg/sVmsvTwjlf7eWl8rdzVuRS58fVL9?=
 =?us-ascii?Q?FNeteQUptM1Cj8JoqvNhL4iXnEPGRT89+TiE4HWnsSkuzxvDkH1M8tFYt9HP?=
 =?us-ascii?Q?n7AKCDS+jngbw677T2Ctyn91zFUh33jVqcPg+Vy34BTNrhwT/HWKgKLS3JOg?=
 =?us-ascii?Q?qj256IQAoobz2qMxqMFR1pKAusTlDTqxUU25GiUYOpD85wZvBZRb4tDgZAHR?=
 =?us-ascii?Q?d6yUxf9w79lcigcyq10oeAyGTqRgBLkoxSSy2msdZaGxT7D5qgOahMhLhewd?=
 =?us-ascii?Q?GYfYGlRoAJneIoHan0zCb5zVIHd1RABb+JS84tbhwDrvDfLHwBAWc3ZPRt1G?=
 =?us-ascii?Q?CIYT0zLbKFvdIZ+AoP1hyb6SDX48a1WCnJtPVIgnA20po81gdvZTqa/lh5IU?=
 =?us-ascii?Q?oJqcAMgddLsK4RkAjG9GPZWQEc65qrTszB00rQhdHXrCVgJgfD4tlquyNDG9?=
 =?us-ascii?Q?vUYo0Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed571e6-8dc7-462e-cf48-08db3033d595
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 08:58:59.0813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I3SsnzJp/Ij2cnutkdUDq5iiWisVtTKp5ctBWt9FQNYXdWuxnzdIn1DRUU9cJRLQrREJFFrI9aye5AVYTylxcBMyMEG3H/+0Sl/+Qdx9WKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3800
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 01:05:51PM -0700, Brett Creeley wrote:
> In order to support dirty page tracking, the driver has to implement
> the VFIO subsystem's vfio_log_ops. This includes log_start, log_stop,
> and log_read_and_clear.
> 
> All of the tracker resources are allocated and dirty tracking on the
> device is started during log_start. The resources are cleaned up and
> dirty tracking on the device is stopped during log_stop. The dirty
> pages are determined and reported during log_read_and_clear.
> 
> In order to support these callbacks admin queue commands are used.
> All of the adminq queue command structures and implementations
> are included as part of this patch.
> 
> PDS_LM_CMD_DIRTY_STATUS is added to query the current status of
> dirty tracking on the device. This includes if it's enabled (i.e.
> number of regions being tracked from the device's perspective) and
> the maximum number of regions supported from the device's perspective.
> 
> PDS_LM_CMD_DIRTY_ENABLE is added to enable dirty tracking on the
> specified number of regions and their iova ranges.
> 
> PDS_LM_CMD_DIRTY_DISABLE is added to disable dirty tracking for all
> regions on the device.
> 
> PDS_LM_CMD_READ_SEQ and PDS_LM_CMD_DIRTY_WRITE_ACK are added to
> support reading and acknowledging the currently dirtied pages.
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Hi Brett,

overall this patch looks clean to me.
I've made a minor comment inline, which you may wish to consider
if you need to respin the series for some other reason.

> diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c

...

> +static void
> +pds_vfio_print_guest_region_info(struct pds_vfio_pci_device *pds_vfio,
> +				 u8 max_regions)
> +{
> +	int len = max_regions * sizeof(struct pds_lm_dirty_region_info);
> +	struct pds_lm_dirty_region_info *region_info;
> +	struct pci_dev *pdev = pds_vfio->pdev;
> +	dma_addr_t regions_dma;
> +	u8 num_regions;
> +	int err;
> +
> +	region_info = kcalloc(max_regions,
> +			      sizeof(struct pds_lm_dirty_region_info),
> +			      GFP_KERNEL);
> +	if (!region_info)
> +		return;
> +
> +	regions_dma = dma_map_single(pds_vfio->coredev, region_info, len,
> +				     DMA_FROM_DEVICE);
> +	if (dma_mapping_error(pds_vfio->coredev, regions_dma)) {
> +		kfree(region_info);
> +		return;

nit: I think it would be more idiomatic to use a goto label here, say:

		goto err_out;

> +	}
> +
> +	err = pds_vfio_dirty_status_cmd(pds_vfio, regions_dma,
> +					&max_regions, &num_regions);
> +	dma_unmap_single(pds_vfio->coredev, regions_dma, len, DMA_FROM_DEVICE);

and here:

	if (err)
		goto err_out;

> +
> +	if (!err) {

And move this out of a conditional, into the main block of the function.

> +		int i;
> +
> +		for (i = 0; i < num_regions; i++)

The scope of i can handily be limited, now that the kernel has moved to C99.

And it might be slightly nicer to use an unsigned type for it,
I don't think it can ever be negative.

		for (unsigned i = 0; i < num_regions; i++)

> +			dev_dbg(&pdev->dev, "region_info[%d]: dma_base 0x%llx page_count %u page_size_log2 %u\n",
> +				i, le64_to_cpu(region_info[i].dma_base),
> +				le32_to_cpu(region_info[i].page_count),
> +				region_info[i].page_size_log2);
> +	}
> +

err_out:

> +	kfree(region_info);
> +}

...
