Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2516D1BDB
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjCaJTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjCaJTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:19:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3711E1C1E3
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680254281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yF9v5IIOGw5V44anpb+5Mxccda/7bq4u5RLsf+2F9Rw=;
        b=Ku4PPTYrD4OonMC2PT6EI4HI8x+AMLGLG3CxR9ueZ8nBD9OGkmTWn5JemFE8HLtUD4skIO
        70M4Rhz5GtdpcUjIHETV0+7nkIlTBpfDQhaA80Lyry59dlTCJJl4q+DUSbwPglM4qPl21y
        Z2AuO3jg5cPcRQjhDCHSYADP5VPi5oI=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-qFw7qx8jNfymnRC1BOal9w-1; Fri, 31 Mar 2023 05:17:59 -0400
X-MC-Unique: qFw7qx8jNfymnRC1BOal9w-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-177c9cc7db5so11340807fac.15
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680254279; x=1682846279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yF9v5IIOGw5V44anpb+5Mxccda/7bq4u5RLsf+2F9Rw=;
        b=Pr1UumosZ8y7ZvLP7mUclU5e3gv+3pCHIVGSyVkbtutFPxsG6snPshaGAys8ePHpuL
         ClLANPIt6980Aco+uq6IciDLHXoR9EsndFanUW2bsUJ1OD7rgdKZqR3Ndk/BcngFvFlv
         YgtbOHfu7ppTgtPNT885jscaa2+XE7JCbK89ecHgC0g2yWYbkgwUHKnkMGujpJK+X9wq
         5IYDidT4/gmO7WW0I8I8c22mOntoncLjarautp8fRDbwmZF36mg3LL7AnvKa3114CGnD
         9n/P9K6Jm+/FlRhWNdSbjUqgVxpp7vdBl/EPUhlXklkBiJly+haSf/1uyLnttcQYA/pn
         Ywmw==
X-Gm-Message-State: AAQBX9d2Skl/g5+dKs26m4PqO6M8tMsNlI71Va2C282VUprp0wPWn45E
        t7kotSbQlVDSdAMxM6nmfQNO2FCxKU6OOk7pCTmt5i9R+XxKvo5U0qz/+NAqEnHQe2xh4Oy7UPg
        jG4rsxBYTWKXRkbUdjW8nH0AAAPhzArO4
X-Received: by 2002:a05:6870:8310:b0:177:c2fb:8cec with SMTP id p16-20020a056870831000b00177c2fb8cecmr10256248oae.9.1680254279144;
        Fri, 31 Mar 2023 02:17:59 -0700 (PDT)
X-Google-Smtp-Source: AK7set+E2W7ure/YSp1DuLxL/pvVMjd7YOtJGAtSadYaT4ARjDtzxSTPtCoDCPBuSTIJIZfHW6UC773ZQzF41GhWaJ8=
X-Received: by 2002:a05:6870:8310:b0:177:c2fb:8cec with SMTP id
 p16-20020a056870831000b00177c2fb8cecmr10256243oae.9.1680254278939; Fri, 31
 Mar 2023 02:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230331-vhost-fixes-v1-0-1f046e735b9e@kernel.org> <20230331-vhost-fixes-v1-1-1f046e735b9e@kernel.org>
In-Reply-To: <20230331-vhost-fixes-v1-1-1f046e735b9e@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 31 Mar 2023 17:17:47 +0800
Message-ID: <CACGkMEtObQFH=oQtEmeBdRS504roSTryx9QR5Xww5Lyob6W5Yg@mail.gmail.com>
Subject: Re: [PATCH vhost 1/3] vdpa: address kdoc warnings
To:     Simon Horman <horms@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Parav Pandit <parav@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 4:58=E2=80=AFPM Simon Horman <horms@kernel.org> wro=
te:
>
> This patch addresses the following minor kdoc problems.
>
> * Incorrect spelling of 'callback' and 'notification'
> * Unrecognised kdoc format for 'struct vdpa_map_file'
> * Missing documentation of 'get_vendor_vq_stats' member of
>   'struct vdpa_config_ops'
> * Missing documentation of 'max_supported_vqs' and 'supported_features'
>   members of 'struct vdpa_mgmt_dev'
>
> Most of these problems were flagged by:
>
>  $ ./scripts/kernel-doc -Werror -none  include/linux/vdpa.h
>  include/linux/vdpa.h:20: warning: expecting prototype for struct vdpa_ca=
lllback. Prototype was for struct vdpa_callback instead
>  include/linux/vdpa.h:117: warning: This comment starts with '/**', but i=
sn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * Corresponding file area for device memory mapping
>  include/linux/vdpa.h:357: warning: Function parameter or member 'get_ven=
dor_vq_stats' not described in 'vdpa_config_ops'
>  include/linux/vdpa.h:518: warning: Function parameter or member 'support=
ed_features' not described in 'vdpa_mgmt_dev'
>  include/linux/vdpa.h:518: warning: Function parameter or member 'max_sup=
ported_vqs' not described in 'vdpa_mgmt_dev'
>
> The misspelling of 'notification' was flagged by:
>  $ ./scripts/checkpatch.pl --codespell --showfile --strict -f include/lin=
ux/vdpa.h
>  include/linux/vdpa.h:171: CHECK: 'notifcation' may be misspelled - perha=
ps 'notification'?
>  ...
>
> Signed-off-by: Simon Horman <horms@kernel.org>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  include/linux/vdpa.h | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 43f59ef10cc9..010321945997 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -10,7 +10,7 @@
>  #include <linux/if_ether.h>
>
>  /**
> - * struct vdpa_calllback - vDPA callback definition.
> + * struct vdpa_callback - vDPA callback definition.
>   * @callback: interrupt callback function
>   * @private: the data passed to the callback function
>   */
> @@ -114,7 +114,7 @@ struct vdpa_dev_set_config {
>  };
>
>  /**
> - * Corresponding file area for device memory mapping
> + * struct vdpa_map_file - file area for device memory mapping
>   * @file: vma->vm_file for the mapping
>   * @offset: mapping offset in the vm_file
>   */
> @@ -165,10 +165,16 @@ struct vdpa_map_file {
>   *                             @vdev: vdpa device
>   *                             @idx: virtqueue index
>   *                             @state: pointer to returned state (last_a=
vail_idx)
> + * @get_vendor_vq_stats:       Get the vendor statistics of a device.
> + *                             @vdev: vdpa device
> + *                             @idx: virtqueue index
> + *                             @msg: socket buffer holding stats message
> + *                             @extack: extack for reporting error messa=
ges
> + *                             Returns integer: success (0) or error (< =
0)
>   * @get_vq_notification:       Get the notification area for a virtqueue=
 (optional)
>   *                             @vdev: vdpa device
>   *                             @idx: virtqueue index
> - *                             Returns the notifcation area
> + *                             Returns the notification area
>   * @get_vq_irq:                        Get the irq number of a virtqueue=
 (optional,
>   *                             but must implemented if require vq irq of=
floading)
>   *                             @vdev: vdpa device
> @@ -506,6 +512,8 @@ struct vdpa_mgmtdev_ops {
>   * @config_attr_mask: bit mask of attributes of type enum vdpa_attr that
>   *                   management device support during dev_add callback
>   * @list: list entry
> + * @supported_features: features supported by device
> + * @max_supported_vqs: maximum number of virtqueues supported by device
>   */
>  struct vdpa_mgmt_dev {
>         struct device *device;
>
> --
> 2.30.2
>

