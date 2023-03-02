Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755ED6A8523
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 16:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjCBPal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 10:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCBPaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 10:30:15 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2103.outbound.protection.outlook.com [40.107.223.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6525813508;
        Thu,  2 Mar 2023 07:30:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZOqNVwQ4zsZ76z6h9p+vmnSLBEiQFL1xDNdhVPo5MkFxO05CntgpYOH47qnaAilzRUTIlSZHE6h7L/y5SMgqSU14VENFCVVqNuOEwBTpjo5rxwjgnww6NKaBr5vZGKfeoL/NN1Eq07D9WYSoHBqI6gFB4o1Jsyg5QQ4Nnb9mXxezLV4kCOrtNFgMByM4++UgtOmXvsQc/yhIUrbEEGM5d7/3XQE1BGk7n6XS0o4bmB6+ua1+ZKd98Nx1Bx1ziI2S6BK8JmSGg6lSxciN0ZkuGx0S22PwvvJM+xcHVNknF0Tb6L3S4YuLNLdh8Cwf/vSbm5LiOa6P/dnqEJMsUsgkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+pNEbcATjslmqm/4RpbloK1KP9eAfGMMZtmsjluYQQ=;
 b=kz6Js4hwfyGtzdMhVgq01iXy2Z/g1dLA7bWipe6LbXrN4IEtrxcQlf9hzj+jFIDrVasSzbdSI+bL6YEcIOVIe0jjjIjTpdvD7ymOT5tdQdBHgb4g3KuJD5CG8iRd/V71EBF1XeLtpGl9raIOwW6RwmvPvEi6G+Q9+DBRooMpiEg5KtupaJZwihOQ3of07kWt69FRZ/Tp2hLqkVmeNKq+MC60iEZw4Aph8kdVs+XySnvGnZW6GsIRXALJGGxhMbq9BzWYlye+gFnSoR+T5RkpeXLp+CChni+oW8jfsnSq4aPeq6VFXbDSugWIAL4/X1wthqnPg8KnikWY9WVC//4XpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+pNEbcATjslmqm/4RpbloK1KP9eAfGMMZtmsjluYQQ=;
 b=gbC2yTBT3kfQ+IjtxeLvvLUXvSFNSXjHwapDxWMCr/uDB8gnGTUDh3aV2aUGun+t7hxewZt09WwFumfsgGoIcm1ocXKvNb0sUJERYh1QGPrGciAYGoLewotJHul8EQJYKyGquuPcZj/evXtKpIm9sU+aH6PQhx2rgZ0AUdiQiFU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3832.namprd13.prod.outlook.com (2603:10b6:610:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 15:30:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 15:30:11 +0000
Date:   Thu, 2 Mar 2023 16:30:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 6/8] vdpa_sim: use kthread worker
Message-ID: <ZADA/GgpbDoi+SzU@corigine.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-7-sgarzare@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302113421.174582-7-sgarzare@redhat.com>
X-ClientProxiedBy: AM4PR05CA0018.eurprd05.prod.outlook.com (2603:10a6:205::31)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3832:EE_
X-MS-Office365-Filtering-Correlation-Id: 52d1f08e-4c44-41d0-4935-08db1b33031d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j19ISSGPRlSJCzgONApg3DNZqPolGJXRoM/q2bJtThEaQXQBj370ueoiwLpu9I5wLTViCbDOvtFyii7KC0BsziuyvWzQqIgJyXKrAhHDrsE9116UFt9rs2gJDDYpCPLuOrGMIKStm/khmkvDmMhZJOkJi4i4rsPdM8ZewbbQX8Dt/CjzowZEs9S6K5yCVLDuv5vI/NwLTkJmL4PO26wW8cm+BWm8RAPrx+IIDb6pvRU0cVY7YU3FZ5tTLtbnG2NVmaoIur2k4+zC2s5BGOPeb5bmTCxFv3tQAhvg9Xgw1X1tRrqPxVG2k4928pxPc8BhNigB06crxwnuxw4UTO09um2kgF5ke+Biv1SOc/s188txYHTB7sfIQpE0wZijc5GNwah71izujitQ5vEX9RImlkmSAUiQOmG6tt4jQz4FAdmyvS7Bgz9ZI2q5IgIiw7HIEcAbQdQ8Zc16KZkmGEfnmQ+CGQwka/Hs+tIUk1YB4Tec+DX3ATOo//oHzzBhIm1vgM0kFgtIAdiDM0T6CpK5KEzvBC5/qpROj6/8N4z86xBAdGuOtAEtjAMgJO+GgpKZvVWPVi5kbnv/gGmsRbLIfQoKBMPO9YpDecoK6Ajjaul1TZrNZUVY41BPSX7Vt0VXIF9/27OeIm53xKg8QXIa71HELF8iq87Cwhksoinud4z/mzVuHEjaRokBaYFTUqoE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(376002)(366004)(136003)(346002)(451199018)(86362001)(36756003)(186003)(6512007)(6506007)(41300700001)(2906002)(66946007)(4326008)(8676002)(6916009)(66476007)(38100700002)(8936002)(5660300002)(7416002)(6666004)(44832011)(2616005)(478600001)(66556008)(54906003)(83380400001)(316002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Ur9Wn+TxdwreYHXGJJtL0nSMfejlU1O7iVf98wjzoaFRhjBWL2WayV7wkHw?=
 =?us-ascii?Q?O8lojtLuZCXXfzPBwxS6FOF3bMFh1py20ZEBZPFj3AT4+lHlHHtMxIdjY0rG?=
 =?us-ascii?Q?03QtET/pseb5B/yIHF9pptuzLjwNi5qgXJobeWj4Pt1tt9mYnIQskECnL3DK?=
 =?us-ascii?Q?XrWUQ88AzhjMRnmJX2PyKYN7THuvq8EhUo7MPFI6I+K5InBYaC/K3a1vcWLl?=
 =?us-ascii?Q?OQ3EeS+QMz5bS7vDhJtMLsm8cIG0fnnSRWaMFhOITRcRvhm2z2yv5EtEaaGR?=
 =?us-ascii?Q?TfGTdeEZAJB7Pv6yyOUalO2w7iA/WvWHzKXjlWhOyZN6++Dwc6t7yUNL+WRU?=
 =?us-ascii?Q?/oJlaiCqWLXqwLg02QJQzGOJOOL37MTue0/v9zAHeDtSuM/GQan8NM1BC8w6?=
 =?us-ascii?Q?K70+G+LH6QGjBSmzmTCucD5iVxaQf8V5xyb5PsWrY5HqMmYijOYw/bpz7/YM?=
 =?us-ascii?Q?UUcysymOK3NHjzuJltAlyaZl690Zsjf4zfskpA5y72jaxE+SAeVsfam8jWN/?=
 =?us-ascii?Q?19qrsyhoy7TO0Zh9mEP/jmHI5wlc0xqAbo+xJrwVDsh1pwRXOGm+mib4w66A?=
 =?us-ascii?Q?RhTZT46AmLTd/ZfplY/Hp+3UNLWTUViBLEVk5ACI6bbE32i4ju0C17G0/a3i?=
 =?us-ascii?Q?CJhqBXr8HTgbcM/Gr+MNSOpCriueMO/zuaw1/MHqVAer+lLLNsyXN6pnbOH8?=
 =?us-ascii?Q?M2uQ0RlBovrrcY2Sqo5J1Cr6SRdAyh7FvXsrKgwWj7lZ/dkmmbO12C/Sziv5?=
 =?us-ascii?Q?S3BT5DqH+wV98ftl0qQfXDfiYrGWdHQPSZOXqXv0+XWi2NeXeauNhXDesQcs?=
 =?us-ascii?Q?nSzyuDzjNacGAPvCNxN/6nS6lDPK+seTxxZpUYxfuz9q7k5Uf/Qk6a39uvEA?=
 =?us-ascii?Q?Zlxd+X22krtFo3bJn6o9S1HlldZG6uCP2NTjLSEwZ4OltXtJj8g+cf0Bruyv?=
 =?us-ascii?Q?ZHfDH9fDzIyy9oESHmV4AnIgh3TehieXZrBOLJPZvtkzGJgQT90dmc6tZAxb?=
 =?us-ascii?Q?jxRVbJv4L9HDz4QEEqDYt49HkmcUyPzRvdcDhdfsoS2KofGxHBVbDHzNXez0?=
 =?us-ascii?Q?8DT7+w9ypCkptxBOmYjVYKgbeGJGR0642KOZkm8OhBoOahENMu24Dgnrswk+?=
 =?us-ascii?Q?YuzciBTpd7WryX5Iryr9mtbmTn/z1Ci24YSPZC47Oz4PN4yABk+P/VJKHnOv?=
 =?us-ascii?Q?2tt1an4ZqFxPjQ7yS/XD2yKhoWKucNC3G7vPqlwuEoO5RnpYQg6Pe9AAyf7s?=
 =?us-ascii?Q?WVppGFre3rjFmw/VoTNRRowttkHXckl/4/AtpUMkpSgG3WIYNO3LtflBVVpP?=
 =?us-ascii?Q?yewSVWWB3yLNdq6Y+8EK98xRL1xhJ5/7nhdPkK1f11wQohF/xw8JodvdHiC9?=
 =?us-ascii?Q?aHA1pHsDD4UzoqVayrb+hJhGzQLjqgveW/iQQ4vQOB8tKAr3Xv3UsifqE4Ed?=
 =?us-ascii?Q?mmNwbaszEx+cXF8ZQpsaLdQ0HflO/hxN7gjngCZ9avK6n5JpoQXV/C7XUn+v?=
 =?us-ascii?Q?IcV2OoNC0Jn0xY3z4YkhjCcsi4rJUOmEJhWs+oSEfUqvjUGDPq6SNeP2DiAf?=
 =?us-ascii?Q?1bHfwxeKfqpVy0TKh7bUM3QlVi1Or8+RTncQsG5TGaWd/odH/h+kAkNzf4h3?=
 =?us-ascii?Q?yd4lHSVo2PKpyarqABx++OPago8Gsan8kOaabRyd8+lN1zrIpjo54/VK+X2n?=
 =?us-ascii?Q?3bHCmw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d1f08e-4c44-41d0-4935-08db1b33031d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 15:30:11.4933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zm5OieZJE/iKB72DUwPZterNqJ/Pw2SEMKWlu9c3JQ95d9olBOuOTH52c1sWbzWMFlC1ESYsHbH6pSFLKFSLblAScjY/b44pN+bQdLl3jTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3832
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 12:34:19PM +0100, Stefano Garzarella wrote:
> Let's use our own kthread to run device jobs.
> This allows us more flexibility, especially we can attach the kthread
> to the user address space when vDPA uses user's VA.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.h |  3 ++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 17 ++++++++++++-----
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> index acee20faaf6a..ce83f9130a5d 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -57,7 +57,8 @@ struct vdpasim_dev_attr {
>  struct vdpasim {
>  	struct vdpa_device vdpa;
>  	struct vdpasim_virtqueue *vqs;
> -	struct work_struct work;
> +	struct kthread_worker *worker;
> +	struct kthread_work work;
>  	struct vdpasim_dev_attr dev_attr;
>  	/* spinlock to synchronize virtqueue state */
>  	spinlock_t lock;
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index a6ee830efc38..6feb29726c2a 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -11,8 +11,8 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> +#include <linux/kthread.h>
>  #include <linux/slab.h>
> -#include <linux/sched.h>
>  #include <linux/dma-map-ops.h>
>  #include <linux/vringh.h>
>  #include <linux/vdpa.h>
> @@ -116,7 +116,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
>  static const struct vdpa_config_ops vdpasim_config_ops;
>  static const struct vdpa_config_ops vdpasim_batch_config_ops;
>  
> -static void vdpasim_work_fn(struct work_struct *work)
> +static void vdpasim_work_fn(struct kthread_work *work)
>  {
>  	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
>  
> @@ -159,7 +159,13 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
>  
>  	vdpasim = vdpa_to_sim(vdpa);
>  	vdpasim->dev_attr = *dev_attr;
> -	INIT_WORK(&vdpasim->work, vdpasim_work_fn);
> +
> +	kthread_init_work(&vdpasim->work, vdpasim_work_fn);
> +	vdpasim->worker = kthread_create_worker(0, "vDPA sim worker: %s",
> +						dev_attr->name);
> +	if (IS_ERR(vdpasim->worker))
> +		goto err_iommu;

Branching to err_iommu will result in a call to put_device(dev)...

> +
>  	spin_lock_init(&vdpasim->lock);
>  	spin_lock_init(&vdpasim->iommu_lock);

... but dev is not initialised until the line following this hunk,
which is:

	dev = &vdpasim->vdpa.dev;

In order to avoid leaking dev I _think_ the correct approach
is to move the initialisation of dev above the branch to
err_iommu, perhaps above the call to kthread_init_work()
is a good place.

This does move the assignment outside the locks above.
But I _think_ that is ok.

> @@ -212,7 +218,7 @@ EXPORT_SYMBOL_GPL(vdpasim_create);
>  
>  void vdpasim_schedule_work(struct vdpasim *vdpasim)
>  {
> -	schedule_work(&vdpasim->work);
> +	kthread_queue_work(vdpasim->worker, &vdpasim->work);
>  }
>  EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
>  
> @@ -612,7 +618,8 @@ static void vdpasim_free(struct vdpa_device *vdpa)
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>  	int i;
>  
> -	cancel_work_sync(&vdpasim->work);
> +	kthread_cancel_work_sync(&vdpasim->work);
> +	kthread_destroy_worker(vdpasim->worker);
>  
>  	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
>  		vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
> -- 
> 2.39.2
> 
