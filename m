Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331396B35E1
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCJFFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjCJFFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:05:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983CBB0B93
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678424661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nx/XrFLQvqfoRq6KKJKJHRcfKaN5Rmhaf8hT4bKmpuo=;
        b=D/Lbbnc/3kHBD9QIjCvpqIaYE4jM7VR4dYDTp7WOUQRWc/l6qnyYwU3Z/wMgok598LnsRo
        X5Etsmz1ZdYWOKwxzjH1zcMVRWSYgV3nunkkjxmlWpFqqqLK5VXAMtj4+jE66J4ohVydRL
        pRfqsCl/Szq4JTSot7J/DajeBd2jjgE=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-xMipT_7NOjS1KvVG8h6Bgg-1; Fri, 10 Mar 2023 00:04:20 -0500
X-MC-Unique: xMipT_7NOjS1KvVG8h6Bgg-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1767ec35ce2so2255962fac.0
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:04:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nx/XrFLQvqfoRq6KKJKJHRcfKaN5Rmhaf8hT4bKmpuo=;
        b=kJ30BEUJpYqN2f3NhChOhgXrexLy4b2wJDEes+xaUCgCcflyhjRepZdxObhgiJXfnl
         r28umkwNCag5V8MpagE5bvq//T38XVMcAgYzVGQ9a/Ln9wmLKwUYnPWpAwIZa071lqC6
         vrBVfrx8J+feuigBw5ndPqk0qkPJ1TBCFeqAFKfMe6wcn/4SjudPyFJ4YEYMFZY4dpSz
         eS0TcoxUzCuhMeNsPaTkeCRmnAwu1n782K08wgcCTWh6ax4zhT7/cShtYKJhTXGwcic/
         9OPGV4xn4ZbAQMc33TswIG92lHmU48XlPI/B/jL7h96v32sig4twMeMhJD+HqEjHDO4M
         9yig==
X-Gm-Message-State: AO0yUKWvChPWek+D7Hc0oZ+gRXqxri/eq4mbXWoLwSCeY3vs8OR/QD8s
        x/4vCYYrC/iXAUYs7D53gkSmPAOeBfZVa9nRLttPmoTui6zL+m++N2XyrJV+f/0JttpKk7EhLpR
        t8aYUzFYxQPfAxmeLlFDAE3mL7b1YaB8x
X-Received: by 2002:a05:6870:c384:b0:175:31d3:e12d with SMTP id g4-20020a056870c38400b0017531d3e12dmr8635633oao.9.1678424659756;
        Thu, 09 Mar 2023 21:04:19 -0800 (PST)
X-Google-Smtp-Source: AK7set92I9VIrrlmhqu1YN/YhNS8WXn8ihRpW9eviURI8x/Q9g7yf9JQeAZf1+rcX4mAPszXbnlct4tl+NlTEAEgtFc=
X-Received: by 2002:a05:6870:c384:b0:175:31d3:e12d with SMTP id
 g4-20020a056870c38400b0017531d3e12dmr8635628oao.9.1678424659454; Thu, 09 Mar
 2023 21:04:19 -0800 (PST)
MIME-Version: 1.0
References: <20230307113621.64153-1-gautam.dawar@amd.com> <20230307113621.64153-5-gautam.dawar@amd.com>
In-Reply-To: <20230307113621.64153-5-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 10 Mar 2023 13:04:08 +0800
Message-ID: <CACGkMEvUhC3HfizpiM8zxMa2RwgkR=yLm-GDpY120_32aBmWFw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 04/14] sfc: evaluate vdpa support based on FW
 capability CLIENT_CMD_VF_PROXY
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 7:37=E2=80=AFPM Gautam Dawar <gautam.dawar@amd.com> =
wrote:
>
> Add and update vdpa_supported field to struct efx_nic to true if
> running Firmware supports CLIENT_CMD_VF_PROXY capability. This is
> required to ensure DMA isolation between MCDI command buffer and guest
> buffers.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c | 26 +++++++++++++++---
>  drivers/net/ethernet/sfc/ef100_nic.c    | 35 +++++++++----------------
>  drivers/net/ethernet/sfc/ef100_nic.h    |  6 +++--
>  drivers/net/ethernet/sfc/ef100_vdpa.h   |  5 ++--
>  4 files changed, 41 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethern=
et/sfc/ef100_netdev.c
> index d916877b5a9a..5d93e870d9b7 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> @@ -355,6 +355,28 @@ void ef100_remove_netdev(struct efx_probe_data *prob=
e_data)
>         efx->state =3D STATE_PROBED;
>  }
>
> +static void efx_ef100_update_tso_features(struct efx_nic *efx)
> +{
> +       struct ef100_nic_data *nic_data =3D efx->nic_data;
> +       struct net_device *net_dev =3D efx->net_dev;
> +       netdev_features_t tso;
> +
> +       if (!efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3))
> +               return;
> +
> +       tso =3D NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
> +             NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
> +             NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
> +
> +       net_dev->features |=3D tso;
> +       net_dev->hw_features |=3D tso;
> +       net_dev->hw_enc_features |=3D tso;
> +       /* EF100 HW can only offload outer checksums if they are UDP,
> +        * so for GRE_CSUM we have to use GSO_PARTIAL.
> +        */
> +       net_dev->gso_partial_features |=3D NETIF_F_GSO_GRE_CSUM;
> +}

I don't see a direct relationship between vDPA and the TSO capability.
Is this an independent fix?

> +
>  int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  {
>         struct efx_nic *efx =3D &probe_data->efx;
> @@ -387,9 +409,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_d=
ata)
>                                ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAU=
LT);
>         efx->mdio.dev =3D net_dev;
>
> -       rc =3D efx_ef100_init_datapath_caps(efx);
> -       if (rc < 0)
> -               goto fail;
> +       efx_ef100_update_tso_features(efx);
>
>         rc =3D ef100_phy_probe(efx);
>         if (rc)
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/=
sfc/ef100_nic.c
> index 8cbe5e0f4bdf..ef6e295efcf7 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -161,7 +161,7 @@ int ef100_get_mac_address(struct efx_nic *efx, u8 *ma=
c_address,
>         return 0;
>  }
>
> -int efx_ef100_init_datapath_caps(struct efx_nic *efx)
> +static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>  {
>         MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
>         struct ef100_nic_data *nic_data =3D efx->nic_data;
> @@ -197,25 +197,15 @@ int efx_ef100_init_datapath_caps(struct efx_nic *ef=
x)
>         if (rc)
>                 return rc;
>
> -       if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
> -               struct net_device *net_dev =3D efx->net_dev;
> -               netdev_features_t tso =3D NETIF_F_TSO | NETIF_F_TSO6 | NE=
TIF_F_GSO_PARTIAL |
> -                                       NETIF_F_GSO_UDP_TUNNEL | NETIF_F_=
GSO_UDP_TUNNEL_CSUM |
> -                                       NETIF_F_GSO_GRE | NETIF_F_GSO_GRE=
_CSUM;
> -
> -               net_dev->features |=3D tso;
> -               net_dev->hw_features |=3D tso;
> -               net_dev->hw_enc_features |=3D tso;
> -               /* EF100 HW can only offload outer checksums if they are =
UDP,
> -                * so for GRE_CSUM we have to use GSO_PARTIAL.
> -                */
> -               net_dev->gso_partial_features |=3D NETIF_F_GSO_GRE_CSUM;
> -       }
>         efx->num_mac_stats =3D MCDI_WORD(outbuf,
>                                        GET_CAPABILITIES_V4_OUT_MAC_STATS_=
NUM_STATS);
>         netif_dbg(efx, probe, efx->net_dev,
>                   "firmware reports num_mac_stats =3D %u\n",
>                   efx->num_mac_stats);
> +
> +       nic_data->vdpa_supported =3D efx_ef100_has_cap(nic_data->datapath=
_caps3,
> +                                                    CLIENT_CMD_VF_PROXY)=
 &&
> +                                  efx->type->is_vf;
>         return 0;
>  }
>
> @@ -806,13 +796,6 @@ static char *bar_config_name[] =3D {
>         [EF100_BAR_CONFIG_VDPA] =3D "vDPA",
>  };
>
> -#ifdef CONFIG_SFC_VDPA
> -static bool efx_vdpa_supported(struct efx_nic *efx)
> -{
> -       return efx->type->is_vf;
> -}
> -#endif
> -
>  int efx_ef100_set_bar_config(struct efx_nic *efx,
>                              enum ef100_bar_config new_config)
>  {
> @@ -828,7 +811,7 @@ int efx_ef100_set_bar_config(struct efx_nic *efx,
>
>  #ifdef CONFIG_SFC_VDPA
>         /* Current EF100 hardware supports vDPA on VFs only */
> -       if (new_config =3D=3D EF100_BAR_CONFIG_VDPA && !efx_vdpa_supporte=
d(efx)) {
> +       if (new_config =3D=3D EF100_BAR_CONFIG_VDPA && !nic_data->vdpa_su=
pported) {
>                 pci_err(efx->pci_dev, "vdpa over PF not supported : %s",
>                         efx->name);
>                 return -EOPNOTSUPP;
> @@ -1208,6 +1191,12 @@ static int ef100_probe_main(struct efx_nic *efx)
>                 goto fail;
>         }
>
> +       rc =3D efx_ef100_init_datapath_caps(efx);
> +       if (rc) {
> +               pci_info(efx->pci_dev, "Unable to initialize datapath cap=
s\n");
> +               goto fail;
> +       }
> +
>         return 0;
>  fail:
>         return rc;
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/=
sfc/ef100_nic.h
> index 4562982f2965..117a73d0795c 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.h
> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
> @@ -76,6 +76,9 @@ struct ef100_nic_data {
>         u32 datapath_caps3;
>         unsigned int pf_index;
>         u16 warm_boot_count;
> +#ifdef CONFIG_SFC_VDPA
> +       bool vdpa_supported; /* true if vdpa is supported on this PCIe FN=
 */
> +#endif
>         u8 port_id[ETH_ALEN];
>         DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
>         enum ef100_bar_config bar_config;
> @@ -95,9 +98,8 @@ struct ef100_nic_data {
>  };
>
>  #define efx_ef100_has_cap(caps, flag) \
> -       (!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V4_OUT_ ## flag ## _=
LBN)))
> +       (!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V7_OUT_ ## flag ## _=
LBN)))
>
> -int efx_ef100_init_datapath_caps(struct efx_nic *efx);
>  int ef100_phy_probe(struct efx_nic *efx);
>  int ef100_filter_table_probe(struct efx_nic *efx);
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet=
/sfc/ef100_vdpa.h
> index f6564448d0c7..90062fd8a25d 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -1,7 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -/* Driver for Xilinx network controllers and boards
> - * Copyright (C) 2020-2022, Xilinx, Inc.
> - * Copyright (C) 2022, Advanced Micro Devices, Inc.
> +/* Driver for AMD network controllers and boards
> + * Copyright (C) 2023, Advanced Micro Devices, Inc.

Let's fix this in the patch that introduces this.

Thanks



>   *
>   * This program is free software; you can redistribute it and/or modify =
it
>   * under the terms of the GNU General Public License version 2 as publis=
hed
> --
> 2.30.1
>

