Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAFC6B35E2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCJFFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjCJFFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:05:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C14B3729
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678424667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8RmwsVtXbX7IUUhxyix4SxBX3I7bTr7PWVXbUtprb7s=;
        b=OeowqxaM1mUaI7/TONq+x4pvMdNyjCh+mfbfAW4Q6G7ytW4nv5GErxIk9+Y722M/ZWdE+0
        8RX+OjqtNT2tkVbHCvIDzVapPkCQj/QsPSlzmhhgCzIEhNAU85IPo2cNTQdrZWFYFDdGin
        FsJELTRIplzXZ5BkC/TfmJAfgOOwy+k=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-SHYw0bR1NSWv6n6MVDZLTg-1; Fri, 10 Mar 2023 00:04:26 -0500
X-MC-Unique: SHYw0bR1NSWv6n6MVDZLTg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1768b61f430so2223349fac.14
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:04:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RmwsVtXbX7IUUhxyix4SxBX3I7bTr7PWVXbUtprb7s=;
        b=x8rWoFVzLydLNTzTrnxUBnW5j/TcLAmoTzmhikGV2RHFcvXKMuRnkd5d/F1ZTHhCmk
         9TK57bxN3jbl1pQfGpkpqWibceMDbnYV1q3wVrTSEoqrd2K5pND0orEdTh7FnSzw/qDT
         6COSGHkN/hhKm2JnE9+z47A9WA4QhWIc2ARNj4RrnjFtzR2JbJ/S7eyTJu3XhXtGCbCZ
         MMho0liz8SLBkl4DYWTZd3oJ6inyUXBmhZDG3k1ae/rmLIpRF1VBMwVSPP2s6XjbAaqK
         xvLRzwz3tihtB6rm4nNkeZBVRz2Oe/DE38JzgeZdncfmVwOMd+hSLU+6ttdTCOVahuRo
         yVAg==
X-Gm-Message-State: AO0yUKVm835NSPvVaKL5wFOjr0gBLFMzxWdMhkvQDy/l8B5phSQHwEjC
        eBFI9vRlH0ccoSx40dapwjVn7Yaxp4XERPr2ieXQZuDXFvY+hcyvSIAV6FyVd9lcKq78yc5kZF0
        6OpLM92IDWuzWFnNPeZUKMzvZJmDUGfVz
X-Received: by 2002:a05:6871:6a81:b0:176:207c:1c8d with SMTP id zf1-20020a0568716a8100b00176207c1c8dmr8293685oab.9.1678424665772;
        Thu, 09 Mar 2023 21:04:25 -0800 (PST)
X-Google-Smtp-Source: AK7set8xYROApXXqMvw3qcRH9dZHpfA5Dp8G4wrNcacul9iVlq4uJlRYYTyodXu4iHW3NppClSTGGvDSCOoL+16spiE=
X-Received: by 2002:a05:6871:6a81:b0:176:207c:1c8d with SMTP id
 zf1-20020a0568716a8100b00176207c1c8dmr8293679oab.9.1678424665551; Thu, 09 Mar
 2023 21:04:25 -0800 (PST)
MIME-Version: 1.0
References: <20230307113621.64153-1-gautam.dawar@amd.com> <20230307113621.64153-2-gautam.dawar@amd.com>
In-Reply-To: <20230307113621.64153-2-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 10 Mar 2023 13:04:14 +0800
Message-ID: <CACGkMEubKv-CGgTdTbt=Ja=pbazXT3nOGY9f_VtRwrOsmf8-rw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 01/14] sfc: add function personality support
 for EF100 devices
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 7:36=E2=80=AFPM Gautam Dawar <gautam.dawar@amd.com> =
wrote:
>
> A function personality defines the location and semantics of
> registers in the BAR. EF100 NICs allow different personalities
> of a PCIe function and changing it at run-time. A total of three
> function personalities are defined as of now: EF100, vDPA and
> None with EF100 being the default.
> For now, vDPA net devices can be created on a EF100 virtual
> function and the VF personality will be changed to vDPA in the
> process.
>
> Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100.c     |  6 +-
>  drivers/net/ethernet/sfc/ef100_nic.c | 98 +++++++++++++++++++++++++++-
>  drivers/net/ethernet/sfc/ef100_nic.h | 11 ++++
>  3 files changed, 111 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/=
ef100.c
> index 71aab3d0480f..c1c69783db7b 100644
> --- a/drivers/net/ethernet/sfc/ef100.c
> +++ b/drivers/net/ethernet/sfc/ef100.c
> @@ -429,8 +429,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
>         if (!efx)
>                 return;
>
> -       probe_data =3D container_of(efx, struct efx_probe_data, efx);
> -       ef100_remove_netdev(probe_data);
> +       efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_NONE);
>  #ifdef CONFIG_SFC_SRIOV
>         efx_fini_struct_tc(efx);
>  #endif
> @@ -443,6 +442,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
>         pci_disable_pcie_error_reporting(pci_dev);
>
>         pci_set_drvdata(pci_dev, NULL);
> +       probe_data =3D container_of(efx, struct efx_probe_data, efx);
>         efx_fini_struct(efx);
>         kfree(probe_data);
>  };
> @@ -508,7 +508,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
>                 goto fail;
>
>         efx->state =3D STATE_PROBED;
> -       rc =3D ef100_probe_netdev(probe_data);
> +       rc =3D efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
>         if (rc)
>                 goto fail;
>
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/=
sfc/ef100_nic.c
> index 4dc643b0d2db..8cbe5e0f4bdf 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -772,6 +772,99 @@ static int efx_ef100_get_base_mport(struct efx_nic *=
efx)
>         return 0;
>  }
>
> +/* BAR configuration.
> + * To change BAR configuration, tear down the current configuration (whi=
ch
> + * leaves the hardware in the PROBED state), and then initialise the new
> + * BAR state.
> + */
> +struct ef100_bar_config_ops {
> +       int (*init)(struct efx_probe_data *probe_data);
> +       void (*fini)(struct efx_probe_data *probe_data);
> +};
> +
> +static const struct ef100_bar_config_ops bar_config_ops[] =3D {
> +       [EF100_BAR_CONFIG_EF100] =3D {
> +               .init =3D ef100_probe_netdev,
> +               .fini =3D ef100_remove_netdev
> +       },
> +#ifdef CONFIG_SFC_VDPA
> +       [EF100_BAR_CONFIG_VDPA] =3D {
> +               .init =3D NULL,
> +               .fini =3D NULL
> +       },
> +#endif
> +       [EF100_BAR_CONFIG_NONE] =3D {
> +               .init =3D NULL,
> +               .fini =3D NULL
> +       },
> +};

This looks more like a mini bus implementation. I wonder if we can
reuse an auxiliary bus here which is more user friendly for management
tools. It might work like, during PCI probe, register an aux device
ef100_nic.net . Then we will have two drivers that could be bound:

1) netdev
2) vdpa

So the bar config setup could be delayed to the auxiliary driver
probe. And we can register the mgmt device during probing the vdpa aux
device. This complies with the sysfs based mgmt interface for driver
core and allows more policy to be added on top e.g autoprobe/override
etc.

Thanks

