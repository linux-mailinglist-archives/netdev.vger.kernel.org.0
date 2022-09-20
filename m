Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0495BDA00
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 04:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiITCRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 22:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiITCRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 22:17:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F88457899
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 19:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663640249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tVCH3EQNWqSiJDgyHq2+Ujl+8EWbJfikiqyIrXZgBBQ=;
        b=IBQchELGUSzwQV+2PYDmwcs4/L5MVmh4Azy9T0yQJA9WVPoMqbVGe1AbF8QTCC5OAfCrcB
        v8uh7hRu0Ydh9iN9EOsIgdUGmQ3j1zI1S+TpzT2+5sLXZ48luUo0L7ZagAX019vbPt1v37
        nGdjXEckDUGcepCYgUz5PrA7YVI9hdU=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-561-KiVbjJUQN6GlSPRHr4j3Xw-1; Mon, 19 Sep 2022 22:17:28 -0400
X-MC-Unique: KiVbjJUQN6GlSPRHr4j3Xw-1
Received: by mail-vs1-f72.google.com with SMTP id a189-20020a6766c6000000b0039b31b27db9so18605vsc.7
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 19:17:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tVCH3EQNWqSiJDgyHq2+Ujl+8EWbJfikiqyIrXZgBBQ=;
        b=EiaisMeA5yCpyGLH2+77Klr/bPJs8SmxcmjIlJ0RVvA8xY/KrdIk8G4doES4cQ2k6b
         5tGQ2+GyGW/yVt9c7qS9y4M5gCVqyjfslYDDsvGABAEHHmXEUXCREACIaewG4NfP49VR
         GmnYoh0KKiQL1r/u2XCrCvl7s9Erneqg+GQIAjLV8Y/1PlgRjvNINrAhtxggSHqCEs67
         KX22xyU3nXfI1gfFILcdRnqlY+1cN8QvABK1s27oUYvkI6HSFL5iTMf79aNMplJJARkU
         qaxQJg8qBJsF724eAZdLHdP8k+FXxo5eoARHtBp3yBIJ2CZADRXJH+Q/tgXIo4lx5PWL
         bqCw==
X-Gm-Message-State: ACrzQf30oGNz87b3MXlc4vLIeIM+6u2bKBo9J+KvmPZl3a8+lkoAkPGy
        AJVcnn6ZZ+9Mv72CjMAuNmouZWFivhI4z/XXS02mZD7QtNcQGMVlcQ2BnguFQTIyHNM3qi9cEMk
        WJ5nvJ4VNTGjS66a8v7yH/udg1Lq8DkET
X-Received: by 2002:a1f:9cc5:0:b0:3a2:bd20:8fc6 with SMTP id f188-20020a1f9cc5000000b003a2bd208fc6mr7123773vke.22.1663640247366;
        Mon, 19 Sep 2022 19:17:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4mWq5eT7AaXAQ7qFJ/OxyfUSXqtfTWp3+HqW/hPsRN4Q3Epwcu7sGV69XwzMKFpw5UU8UDgsDN14/VW5xjOcQ=
X-Received: by 2002:a1f:9cc5:0:b0:3a2:bd20:8fc6 with SMTP id
 f188-20020a1f9cc5000000b003a2bd208fc6mr7123766vke.22.1663640247184; Mon, 19
 Sep 2022 19:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220909085712.46006-1-lingshan.zhu@intel.com> <20220909085712.46006-4-lingshan.zhu@intel.com>
In-Reply-To: <20220909085712.46006-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 20 Sep 2022 10:17:16 +0800
Message-ID: <CACGkMEsjMotoSqukdzcCrQu-P8H1MxnVrC8LGCXiRQegLT7gJg@mail.gmail.com>
Subject: Re: [PATCH 3/4] vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's
 presence
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> virtio 1.2 spec says:
> max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
> VIRTIO_NET_F_RSS is set.
>
> So when reporint MQ to userspace, it should check both
> VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS.
>
> This commit also fixes:
> 1) a spase warning by replacing le16_to_cpu with __virtio16_to_cpu.
> 2) vdpa_dev_net_mq_config_fill() should checks device features
> for MQ than driver features.
> 3) struct vdpa_device *vdev is not needed for
> vdpa_dev_net_mq_config_fill(), unused.

Let's do those in separate patches please.

Thanks

>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 29d7e8858e6f..f8ff61232421 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -801,16 +801,17 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_callba
>         return msg->len;
>  }
>
> -static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
> -                                      struct sk_buff *msg, u64 features,
> +static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>                                        const struct virtio_net_config *config)
>  {
>         u16 val_u16;
>
> -       if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
> +       if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
> +           (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
>                 return 0;
>
> -       val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
> +       val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
> +
>         return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>  }
>
> @@ -851,7 +852,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>                               VDPA_ATTR_PAD))
>                 return -EMSGSIZE;
>
> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
> +       return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
>  }
>
>  static int
> --
> 2.31.1
>

