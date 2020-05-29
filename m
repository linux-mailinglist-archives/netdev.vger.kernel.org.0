Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776F81E7920
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 11:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgE2JQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 05:16:10 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:27243
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbgE2JQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 05:16:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKOQ+CC8af/L+FLM/sOupgZufl3sUGlyPbDJZ2B74SjcBuDSGp+6Y12wlJZnTs3ghl0JwxaTQLh6PemBI9NP+LPJaMIYDYx3Gr6vgaBCvKdcYWf/AdpTNABwWN0DFPJRoH6QUK+Qn30oUPzfCg5ErojjfB0W7tP7QdKvAbYYJKTWIxhvDH3FfuML+wqgsmcKO5t4ou2suyZlIZCJin0meuTSr+WVz5kBI6JbkfyPu+FfTTQuGMNqnxWAiNpVQ/Wx6C855ShG59SzO/SPM5G5Vz1XVzPRgFU26fvfJZtRcTdRcNDcpEVT8s2NrFIE9sW/x7VwBuutr36iX/3fZHHDkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLf9Swylfaaq7EGhbgXAwGoTSyCkzx/5Q8ICEbEiyx0=;
 b=jnv1lpbODLA8AMbqp7I9g3x0397ce4LAgWiy3yNwvH9InvKFbA5lILWb/sszzXHbndmSsnOh9/7/HWv2V06rngYEj0gOMazsQETRCTNqqTFeNSPrcxIRH8mWIEc837UqCOWo+E6od6peprFHV1G9Uw07vezUb2Vb1aKUM/xII41+Nvuylg8oBM7I6fXfEDMJ4EsjMG+gvoZAOBxZYxcdXRuZxfTLQ80q/0YzJJ7N2mKEXKwnpCPIGadr80f3FKTF8N9C8pEwVJKEEZQQ+yjnHyfwbirhpruAzCuvsZ18xmCLfXs7u/MkfyF0MBN7T1dm2ihXEa5SIiGd/aLFXGsQLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLf9Swylfaaq7EGhbgXAwGoTSyCkzx/5Q8ICEbEiyx0=;
 b=fSgeRBnRqBw6IPn5RwKOpuMWDKvrS+xgWDqy74G2hbovVxvNDUbCvoBq8e3kVo6P2+JvCSkSR+RF10I0vJ6HnyIkxtyoC2yi3GsUzf67lYTeRFx+d2zOAhP1JzWayUqIw4lSbdWUYObrfi1kdNBcnnJailedjWwPgfNun4fR7Bg=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=nextfour.com;
Received: from HE1PR0302MB2682.eurprd03.prod.outlook.com (2603:10a6:3:f5::14)
 by HE1PR0302MB2649.eurprd03.prod.outlook.com (2603:10a6:3:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 29 May
 2020 09:16:04 +0000
Received: from HE1PR0302MB2682.eurprd03.prod.outlook.com
 ([fe80::b10a:8b9d:1a18:6b2]) by HE1PR0302MB2682.eurprd03.prod.outlook.com
 ([fe80::b10a:8b9d:1a18:6b2%9]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 09:16:04 +0000
Subject: Re: [PATCH 4/6] vhost_vdpa: support doorbell mapping via mmap
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-5-jasowang@redhat.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <bab90a3f-f0b3-37d3-89bc-cd17d33f3208@nextfour.com>
Date:   Fri, 29 May 2020 12:16:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200529080303.15449-5-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: HE1PR0402CA0047.eurprd04.prod.outlook.com
 (2603:10a6:7:7c::36) To HE1PR0302MB2682.eurprd03.prod.outlook.com
 (2603:10a6:3:f5::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.10.99.2] (194.157.170.35) by HE1PR0402CA0047.eurprd04.prod.outlook.com (2603:10a6:7:7c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 09:16:03 +0000
X-Originating-IP: [194.157.170.35]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57705d77-943b-47fb-42e8-08d803b0e9a6
X-MS-TrafficTypeDiagnostic: HE1PR0302MB2649:
X-Microsoft-Antispam-PRVS: <HE1PR0302MB2649058788C48E9CFA7FB57F838F0@HE1PR0302MB2649.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ldokIm4PXL8b9qF2egTn7hOdXceP+7SgM0E+8PIdfroYlgxR/MBiCG4j1OePiBHUq1MnSi/9FFht2TDmPnG/fKXjdfSXCjPnwilYnXME2lUBd8PQFkf2d0vlT82jLZ9oQE8HwpZrMPdreWJq7N9sURrZHw5agPeNsXq1ZlYGVH6HEYkKGAVeaJR9A1cPlDhr1aSAuAyylN5H6T260lcda0gy+G3DPkstyv1vA6I0TC99GKf72In763injMrxvrZ8BRNxFIOGLumibuRGAAwJOt/M+/XwCVkMqU8kdBXlB95PDNMgecqq7o970ZCXvRqpo2WxM4L6q2mguhfoBzLe90zgFp0xIUr6GXXHhHY+DZ+HolNGYjjSlnqaZHv7B67f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0302MB2682.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(396003)(376002)(39830400003)(346002)(31686004)(36756003)(508600001)(4326008)(5660300002)(66946007)(186003)(956004)(2616005)(66556008)(16526019)(31696002)(66476007)(86362001)(2906002)(83380400001)(316002)(7416002)(8676002)(52116002)(26005)(6486002)(16576012)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PsLvraN7sa1DZ0EoFDuMKswwmnayNDzf7UhC+chpbr6E2YsP4DRJNxBhAcKnos+B0Zza01XODSfW0om+Nd6aD6zNDAfFUhtZLT17KHEA19svzzRqsjbyeUnqWZhguJYAhlHqrCQfjJeTERmbVtc+8XrnPPhlASjZxxTSrOGNyRx3NP/N9VLjVeCmC9sYMomUrAYccucvGRmHNY7uUBoG+VVV1U7zjGvDeClBaTr4agr+dFmRHdGmuwvSapwSUzzgxvc3Q957ZJqrNjnWI6/thB66eDdZiFv7gTxs1q4VW/O3BV6k2NeDG4qRwVvVb6llfxqI6VjZzXn7Eg8kjhPPm5orxkqVv7dWlfZsbUYvJpQrErvQ9lifZZWydynbAIItg4d3rSwys1KAPVhPEGxRv0aSNB9bq+XaZEXh7g51q0UT6S7EVUrZO+HiccIGGjnNla550KQPJ4SJdy6k84KbEcnAgFiYACRLs2sHmJeynS6qvuydVOINQALAFU88LoUK
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57705d77-943b-47fb-42e8-08d803b0e9a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 09:16:04.4768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvtvJY442hddOrhGtxznYB038/qCKSRN/s3jnC/57MG9+bZOe4VDE2kVa1aBpP1mA+CJCgjqOINtFwrztEi/GcXhByZCsXb33dS0Tgz1RTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2649
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 29.5.2020 11.03, Jason Wang wrote:
> Currently the doorbell is relayed via eventfd which may have
> significant overhead because of the cost of vmexits or syscall. This
> patch introduces mmap() based doorbell mapping which can eliminate the
> overhead caused by vmexit or syscall.

Just wondering. I know very little about vdpa. But how is such a "sw 
doorbell" monitored or observed, if no fault or wmexit etc.
Is there some kind of polling used?

> To ease the userspace modeling of the doorbell layout (usually
> virtio-pci), this patch starts from a doorbell per page
> model. Vhost-vdpa only support the hardware doorbell that sit at the
> boundary of a page and does not share the page with other registers.
>
> Doorbell of each virtqueue must be mapped separately, pgoff is the
> index of the virtqueue. This allows userspace to map a subset of the
> doorbell which may be useful for the implementation of software
> assisted virtqueue (control vq) in the future.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vhost/vdpa.c | 59 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 59 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 6ff72289f488..bbe23cea139a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -15,6 +15,7 @@
>   #include <linux/module.h>
>   #include <linux/cdev.h>
>   #include <linux/device.h>
> +#include <linux/mm.h>
>   #include <linux/iommu.h>
>   #include <linux/uuid.h>
>   #include <linux/vdpa.h>
> @@ -741,12 +742,70 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>   	return 0;
>   }
>   
> +static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
> +{
> +	struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
> +	struct vdpa_device *vdpa = v->vdpa;
> +	const struct vdpa_config_ops *ops = vdpa->config;
> +	struct vdpa_notification_area notify;
> +	struct vm_area_struct *vma = vmf->vma;
> +	u16 index = vma->vm_pgoff;
> +
> +	notify = ops->get_vq_notification(vdpa, index);
> +
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
> +			    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
> +			    vma->vm_page_prot))
> +		return VM_FAULT_SIGBUS;
> +
> +	return VM_FAULT_NOPAGE;
> +}
> +
> +static const struct vm_operations_struct vhost_vdpa_vm_ops = {
> +	.fault = vhost_vdpa_fault,
> +};
> +
> +static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct vhost_vdpa *v = vma->vm_file->private_data;
> +	struct vdpa_device *vdpa = v->vdpa;
> +	const struct vdpa_config_ops *ops = vdpa->config;
> +	struct vdpa_notification_area notify;
> +	int index = vma->vm_pgoff;
> +
> +	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
> +		return -EINVAL;
> +	if ((vma->vm_flags & VM_SHARED) == 0)
> +		return -EINVAL;
> +	if (vma->vm_flags & VM_READ)
> +		return -EINVAL;
> +	if (index > 65535)
> +		return -EINVAL;
> +	if (!ops->get_vq_notification)
> +		return -ENOTSUPP;
> +
> +	/* To be safe and easily modelled by userspace, We only
> +	 * support the doorbell which sits on the page boundary and
> +	 * does not share the page with other registers.
> +	 */
> +	notify = ops->get_vq_notification(vdpa, index);
> +	if (notify.addr & (PAGE_SIZE - 1))
> +		return -EINVAL;
> +	if (vma->vm_end - vma->vm_start != notify.size)
> +		return -ENOTSUPP;
> +
> +	vma->vm_ops = &vhost_vdpa_vm_ops;
> +	return 0;
> +}
> +
>   static const struct file_operations vhost_vdpa_fops = {
>   	.owner		= THIS_MODULE,
>   	.open		= vhost_vdpa_open,
>   	.release	= vhost_vdpa_release,
>   	.write_iter	= vhost_vdpa_chr_write_iter,
>   	.unlocked_ioctl	= vhost_vdpa_unlocked_ioctl,
> +	.mmap		= vhost_vdpa_mmap,
>   	.compat_ioctl	= compat_ptr_ioctl,
>   };
>   

