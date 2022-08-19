Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791B35991F9
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242170AbiHSA4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241528AbiHSA4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:56:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBE2883C3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660870580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKb8wMv3kp7XDXlLqqFY9ANzF7bJt+tTfj6q5NOVelU=;
        b=Kbdn6B0j7xIowrJAKiCZhT4l4rh1LaS6fjsJRHjlRF8huYGEjdMzCyB+KCwVY0YLlKg1Fb
        2T5fi5i+PzKcxPLZmwHK9hM6DToBpJWwOiiXoYYqjyWJThs5z3N+1HTiS4Ltr5rZTZk5D3
        1xmvhoD+4aBjCDxPMRlNr+Oj/u1ROVE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-215-jBrKjDwZNWK_usCPz8_B-g-1; Thu, 18 Aug 2022 20:56:18 -0400
X-MC-Unique: jBrKjDwZNWK_usCPz8_B-g-1
Received: by mail-lf1-f70.google.com with SMTP id v21-20020a197415000000b00492c4d45175so607072lfe.4
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:56:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=WKb8wMv3kp7XDXlLqqFY9ANzF7bJt+tTfj6q5NOVelU=;
        b=DizSHKcVrhVR0+0gNjoYlHoA9IQdLidWQAHnc+MKskwrzQo9RC70IRqGBaeNACYOat
         cW4atZY/GtLdkmt4wI6F3THnaSwsq16XFCcFw9gGEuvPLCkkSZ+kbRvKu/2eyxwFA7q4
         G0VTRqup5OvnsVIhLnMIkOG5hyp9x/p1XStFRvyn6q5+zJgf4d9pRB3K9Zj6NLEOkKbe
         dWhxX9MZuPdvSi9SuoZNkwi6pud00aQ5B4r8p6XuoKQtXMpFYRuCbn53pXlFcHh5JY9V
         68uXODTanfKmZdSm6NRCL18/SoHuBo4aVeWOQbgzTZpN7uDEN+QvNhju1bOGglQ3He5q
         jHOw==
X-Gm-Message-State: ACgBeo212VUyDC4pNP81JbCamxzaVtgauwNEfaoaaKhGJNVDH+KzfkrQ
        7nAUaqPQd2ZxppBoPaAlr3moCD1rH9/N/d7sDWsZK29vNIr8TF6fIShBAzqLVCfO5qDP4Fe9QTK
        phLD0K+fq+ugWPqpzuzgf683xglOpbEQW
X-Received: by 2002:ac2:43b0:0:b0:48b:1eb:d1e5 with SMTP id t16-20020ac243b0000000b0048b01ebd1e5mr1802689lfl.641.1660870577034;
        Thu, 18 Aug 2022 17:56:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7i0/dwaRBFTHT8A2/Jz8ujQitDss25BNCKH8nNf+19R4cWCFm5sm5DSkA6hOMvI0i7uaE60wq6AqnZvmyYw6M=
X-Received: by 2002:ac2:43b0:0:b0:48b:1eb:d1e5 with SMTP id
 t16-20020ac243b0000000b0048b01ebd1e5mr1802668lfl.641.1660870576846; Thu, 18
 Aug 2022 17:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220811135353.2549658-1-eperezma@redhat.com> <20220811135353.2549658-3-eperezma@redhat.com>
In-Reply-To: <20220811135353.2549658-3-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 19 Aug 2022 08:56:05 +0800
Message-ID: <CACGkMEsMbXyXY94dB2NW_uUK=sXQNd7LTRBgOQVE=zMzHA69Gw@mail.gmail.com>
Subject: Re: [PATCH v8 2/3] vdpa: Remove wrong doc of VHOST_VDPA_SUSPEND ioctl
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, ecree.xilinx@gmail.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Laurent Vivier <lvivier@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, Cindy Lu <lulu@redhat.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 9:54 PM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> It was a leftover from previous versions.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  include/linux/vdpa.h       |  2 +-
>  include/uapi/linux/vhost.h | 15 +++++----------
>  2 files changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index d282f464d2f1..6c4e6ea7f7eb 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -218,7 +218,7 @@ struct vdpa_map_file {
>   * @reset:                     Reset device
>   *                             @vdev: vdpa device
>   *                             Returns integer: success (0) or error (< =
0)
> - * @suspend:                   Suspend or resume the device (optional)
> + * @suspend:                   Suspend the device (optional)
>   *                             @vdev: vdpa device
>   *                             Returns integer: success (0) or error (< =
0)
>   * @get_config_size:           Get the size of the configuration space i=
ncludes
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 6d9f45163155..89fcb2afe472 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -171,17 +171,12 @@
>  #define VHOST_VDPA_SET_GROUP_ASID      _IOW(VHOST_VIRTIO, 0x7C, \
>                                              struct vhost_vring_state)
>
> -/* Suspend or resume a device so it does not process virtqueue requests =
anymore
> +/* Suspend a device so it does not process virtqueue requests anymore
>   *
> - * After the return of ioctl with suspend !=3D 0, the device must finish=
 any
> - * pending operations like in flight requests. It must also preserve all=
 the
> - * necessary state (the virtqueue vring base plus the possible device sp=
ecific
> - * states) that is required for restoring in the future. The device must=
 not
> - * change its configuration after that point.
> - *
> - * After the return of ioctl with suspend =3D=3D 0, the device can conti=
nue
> - * processing buffers as long as typical conditions are met (vq is enabl=
ed,
> - * DRIVER_OK status bit is enabled, etc).
> + * After the return of ioctl the device must finish any pending operatio=
ns. It
> + * must also preserve all the necessary state (the virtqueue vring base =
plus
> + * the possible device specific states) that is required for restoring i=
n the
> + * future. The device must not change its configuration after that point=
.
>   */
>  #define VHOST_VDPA_SUSPEND             _IOW(VHOST_VIRTIO, 0x7D, int)
>
> --
> 2.31.1
>

