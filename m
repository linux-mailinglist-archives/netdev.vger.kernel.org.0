Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7A0634236
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiKVRKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiKVRKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:10:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F2279935
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669136967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01iSMPOU4tEuNXU9fKQrAxUry6J8bqfFH20out7H7bY=;
        b=PJ4I2LmL7PZH6m/hpTMTis16eyKvzP/9hQ2rSEsIuJ91j66xb0NlM5FxaEWnwLdCHa4joY
        Fs9MvVKR97VnYYcuNRXW3XRaASWjiFVVoaKCNjKezfWLvbG2sHAWC2YDtiumewohMwQ+XH
        QIQ7x9k1BlvdXpEf18IzVfIhV8hB1h0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-61-AiPqsXnvMKuo8uw69tWf8Q-1; Tue, 22 Nov 2022 12:09:25 -0500
X-MC-Unique: AiPqsXnvMKuo8uw69tWf8Q-1
Received: by mail-qk1-f200.google.com with SMTP id ay43-20020a05620a17ab00b006fa30ed61fdso19514645qkb.5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:09:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=01iSMPOU4tEuNXU9fKQrAxUry6J8bqfFH20out7H7bY=;
        b=0gQl4mbiQbVRxvtRmg9ulQX17ptM98Fzz34TWFuLMZFZyk2SVkB/DDmUivyoJByG8y
         DBvaSiploOg7wKY/3np3wgvNFWOGaxMonHnOfaXa8sUd2WEp8cwHCVGFNJj4EW+lGFQ9
         xRKO2akJAYsndjXV3AnWdXHrIIaOwDYiCYu9ChFaJcikTIAmXRjmS6Zp5VMuJKrqWAeP
         GuM4uwy3vfudbfEXTwCp/FtjO1TH0N3AyLG0Oq5JjDgUQrOHyglCC+uNTVn0I3kI2aex
         NrmRYP+Aeq4qNdEdQSuVqKV5CDbSFC+ykp36xqSsJIPeldRTrVHEafIboGUf2Cx/rEVH
         gEkw==
X-Gm-Message-State: ANoB5pmOWEGzIX3x1wJfuKxb0Kb7ZpefE1N0LdGvwpzBV5wtYXUumw9A
        jqBjfrkfnb3dW/y/VlU5kCeBa9+nfgM7KZm126y0fmzPJQXvtKm35ol4GfyuvCDLoJzuid6Wajn
        DprS2fv+45RQH+E2MZfGijIwfHNM9gQ5d
X-Received: by 2002:ad4:4d53:0:b0:4bb:63ed:152e with SMTP id m19-20020ad44d53000000b004bb63ed152emr6866119qvm.131.1669136964930;
        Tue, 22 Nov 2022 09:09:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6cy3IbzuUHNF01MMGruqTRCNZjrCuej6MZ7flutByhAmKMPaHWqIugf69MLlhgysYeMUUFH+6Ev13ceqpd59Y=
X-Received: by 2002:ad4:4d53:0:b0:4bb:63ed:152e with SMTP id
 m19-20020ad44d53000000b004bb63ed152emr6866099qvm.131.1669136964633; Tue, 22
 Nov 2022 09:09:24 -0800 (PST)
MIME-Version: 1.0
References: <20221117033303.16870-1-jasowang@redhat.com>
In-Reply-To: <20221117033303.16870-1-jasowang@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 22 Nov 2022 18:08:48 +0100
Message-ID: <CAJaqyWcrWgWkZ49eGKVjK5XKZ7ZzuqDmJqmqyqyntjTUyNGHkg@mail.gmail.com>
Subject: Re: [PATCH V2] vdpa: allow provisioning device features
To:     Jason Wang <jasowang@redhat.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, si-wei.liu@oracle.com,
        mst@redhat.com, lingshan.zhu@intel.com, elic@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 4:33 AM Jason Wang <jasowang@redhat.com> wrote:
>
> This patch allows device features to be provisioned via vdpa. This
> will be useful for preserving migration compatibility between source
> and destination:
>
> # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x30002=
0000
> # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
>       negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
> Changes since v1:
> - Use uint64_t instead of __u64 for device_features
> - Fix typos and tweak the manpage
> - Add device_features to the help text
> ---
>  man/man8/vdpa-dev.8            | 15 +++++++++++++++
>  vdpa/include/uapi/linux/vdpa.h |  1 +
>  vdpa/vdpa.c                    | 32 +++++++++++++++++++++++++++++---
>  3 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
> index 9faf3838..43e5bf48 100644
> --- a/man/man8/vdpa-dev.8
> +++ b/man/man8/vdpa-dev.8
> @@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
>  .I NAME
>  .B mgmtdev
>  .I MGMTDEV
> +.RI "[ device_features " DEVICE_FEATURES " ]"
>  .RI "[ mac " MACADDR " ]"
>  .RI "[ mtu " MTU " ]"
>  .RI "[ max_vqp " MAX_VQ_PAIRS " ]"
> @@ -74,6 +75,15 @@ Name of the new vdpa device to add.
>  Name of the management device to use for device addition.
>
>  .PP
> +.BI device_features " DEVICE_FEATURES"
> +Specifies the virtio device features bit-mask that is provisioned for th=
e new vdpa device.
> +
> +The bits can be found under include/uapi/linux/virtio*h.
> +
> +see macros such as VIRTIO_F_ and VIRTIO_XXX(e.g NET)_F_ for specific bit=
 values.
> +
> +This is optional.
> +
>  .BI mac " MACADDR"
>  - specifies the mac address for the new vdpa device.
>  This is applicable only for the network type of vdpa device. This is opt=
ional.
> @@ -127,6 +137,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
>  Add the vdpa device named foo on the management device vdpa_sim_net.
>  .RE
>  .PP
> +vdpa dev add name foo mgmtdev vdpa_sim_net device_features 0x300020000
> +.RS 4
> +Add the vdpa device named foo on the management device vdpa_sim_net with=
 device_features of 0x300020000
> +.RE
> +.PP
>  vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
>  .RS 4
>  Add the vdpa device named foo on the management device vdpa_sim_net with=
 mac address of 00:11:22:33:44:55.
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdp=
a.h
> index 94e4dad1..7c961991 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -51,6 +51,7 @@ enum vdpa_attr {
>         VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>         VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>         VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
> +       VDPA_ATTR_DEV_FEATURES,                 /* u64 */
>
>         /* new attributes must be added above here */
>         VDPA_ATTR_MAX,
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index b73e40b4..d0ce5e22 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -27,6 +27,7 @@
>  #define VDPA_OPT_VDEV_MTU              BIT(5)
>  #define VDPA_OPT_MAX_VQP               BIT(6)
>  #define VDPA_OPT_QUEUE_INDEX           BIT(7)
> +#define VDPA_OPT_VDEV_FEATURES         BIT(8)
>
>  struct vdpa_opts {
>         uint64_t present; /* flags of present items */
> @@ -38,6 +39,7 @@ struct vdpa_opts {
>         uint16_t mtu;
>         uint16_t max_vqp;
>         uint32_t queue_idx;
> +       uint64_t device_features;
>  };
>
>  struct vdpa {
> @@ -187,6 +189,17 @@ static int vdpa_argv_u32(struct vdpa *vdpa, int argc=
, char **argv,
>         return get_u32(result, *argv, 10);
>  }
>
> +static int vdpa_argv_u64_hex(struct vdpa *vdpa, int argc, char **argv,
> +                            uint64_t *result)
> +{
> +       if (argc <=3D 0 || !*argv) {
> +               fprintf(stderr, "number expected\n");
> +               return -EINVAL;
> +       }
> +
> +       return get_u64(result, *argv, 16);
> +}
> +
>  struct vdpa_args_metadata {
>         uint64_t o_flag;
>         const char *err_msg;
> @@ -244,6 +257,10 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, stru=
ct vdpa *vdpa)
>                 mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts=
->max_vqp);
>         if (opts->present & VDPA_OPT_QUEUE_INDEX)
>                 mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->qu=
eue_idx);
> +       if (opts->present & VDPA_OPT_VDEV_FEATURES) {
> +               mnl_attr_put_u64(nlh, VDPA_ATTR_DEV_FEATURES,
> +                               opts->device_features);
> +       }
>  }
>
>  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> @@ -329,6 +346,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int ar=
gc, char **argv,
>
>                         NEXT_ARG_FWD();
>                         o_found |=3D VDPA_OPT_QUEUE_INDEX;
> +               } else if (!strcmp(*argv, "device_features") &&
> +                          (o_optional & VDPA_OPT_VDEV_FEATURES)) {
> +                       NEXT_ARG_FWD();
> +                       err =3D vdpa_argv_u64_hex(vdpa, argc, argv,
> +                                               &opts->device_features);
> +                       if (err)
> +                               return err;
> +                       o_found |=3D VDPA_OPT_VDEV_FEATURES;
>                 } else {
>                         fprintf(stderr, "Unknown option \"%s\"\n", *argv)=
;
>                         return -EINVAL;
> @@ -615,8 +640,9 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, c=
har **argv)
>  static void cmd_dev_help(void)
>  {
>         fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> -       fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENT=
DEV [ mac MACADDR ] [ mtu MTU ]\n");
> -       fprintf(stderr, "                                                =
    [ max_vqp MAX_VQ_PAIRS ]\n");
> +       fprintf(stderr, "       vdpa dev add name NAME mgmtdevMANAGEMENTD=
EV [ device_features DEVICE_FEATURES]\n");
> +       fprintf(stderr, "                                                =
   [ mac MACADDR ] [ mtu MTU ]\n");
> +       fprintf(stderr, "                                                =
   [ max_vqp MAX_VQ_PAIRS ]\n");
>         fprintf(stderr, "       vdpa dev del DEV\n");
>         fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
>         fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
> @@ -708,7 +734,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, c=
har **argv)
>         err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>                                   VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT=
_VDEV_NAME,
>                                   VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
> -                                 VDPA_OPT_MAX_VQP);
> +                                 VDPA_OPT_MAX_VQP | VDPA_OPT_VDEV_FEATUR=
ES);
>         if (err)
>                 return err;
>
> --
> 2.25.1
>

