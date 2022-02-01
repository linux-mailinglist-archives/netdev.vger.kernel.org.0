Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942264A5B10
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 12:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbiBALXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 06:23:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233102AbiBALXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 06:23:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643714592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wls2HlLMZ5xS0VLgYNarmM3xEfIz1yMYSVtpjmaBDnA=;
        b=Fz5bmqajG50A+SHyTs5R8Ui8Ob58YOIm5TutbZCJyluY8ErtXwwI1yhigyZH9IBEt+K6Y8
        o0CpMJCQ4ZlSKVBwZPJjq/3RembVSqGkP/DNUeZ9rWaYh9/Osl0RXM76qqZ7W+4OiPWq1n
        YnGPOaBRmtaaFN0NaIcWM1GAR+q6deE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-NB2v9r2dMte-i36Jh3lmVw-1; Tue, 01 Feb 2022 06:23:09 -0500
X-MC-Unique: NB2v9r2dMte-i36Jh3lmVw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BB8E1019988;
        Tue,  1 Feb 2022 11:23:07 +0000 (UTC)
Received: from localhost (unknown [10.39.194.79])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 145CE73160;
        Tue,  1 Feb 2022 11:23:06 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
In-Reply-To: <20220130160826.32449-11-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-11-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 01 Feb 2022 12:23:05 +0100
Message-ID: <874k5izv8m.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
>
> v1 was never implemented and is replaced by v2.
>
> The old uAPI definitions are removed from the header file. As per Linus's
> past remarks we do not have a hard requirement to retain compilation
> compatibility in uapi headers and qemu is already following Linus's
> preferred model of copying the kernel headers.

If we are all in agreement that we will replace v1 with v2 (and I think
we are), we probably should remove the x-enable-migration stuff in QEMU
sooner rather than later, to avoid leaving a trap for the next
unsuspecting person trying to update the headers.

>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 228 --------------------------------------
>  1 file changed, 228 deletions(-)
>
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9efc35535b29..70c77da5812d 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -323,7 +323,6 @@ struct vfio_region_info_cap_type {
>  #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
>  #define VFIO_REGION_TYPE_GFX                    (1)
>  #define VFIO_REGION_TYPE_CCW			(2)
> -#define VFIO_REGION_TYPE_MIGRATION              (3)

Do we want to keep region type 3 reserved? Probably not really needed,
but would put us on the safe side.

