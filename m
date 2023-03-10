Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999266B35EB
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCJFHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjCJFGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:06:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CD2F05E2
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678424743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1zJYqpQcq8Qkw2hlwEMwGU/rklWWUQtVClakeejpeQA=;
        b=F7nN/WJ5cOeC7y3RMQalsBwnr0hRaaP+VeqczmlKmKQBfYS4CJ9VNYqNYnsktojUb7HNRV
        rBDYqLZBYlwcxfJ7cRKqQhcFksxYBGGEhg27XWTpr1Nzt50mWnfNLGdfHVd3uSagVejCBd
        v0d0tO+B+KpUttUFFfGyrIL4f29JD7k=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-MSdwFnNFMmOd0NNXY7B6Lw-1; Fri, 10 Mar 2023 00:05:41 -0500
X-MC-Unique: MSdwFnNFMmOd0NNXY7B6Lw-1
Received: by mail-oo1-f71.google.com with SMTP id t3-20020a4a96c3000000b005252e74e78fso1336683ooi.9
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:05:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zJYqpQcq8Qkw2hlwEMwGU/rklWWUQtVClakeejpeQA=;
        b=wmkQLPsO18ILvFPs9I1+3ob+LqOPSkHSY8X79P5obRhQYUKHZ3FkTxQyJcoVhrUPVH
         7ldRB4p6nJuEmqiZicifxkjpQG6v/AwB2UWdC6s8KB2xp1CQx1EDe/9JKroAPJyF0KNw
         Gfvcw6Fh7CrEqHg3RBZTycZTYg7KYg/3y/eYskk7ncypwtcNKqszwpQYcO8pEDqzR4m9
         VMrAs+spmnxmfLa5P8kGgs6PBBhe/yyc3SrBfOqEY7nGw+oNVS74RCsR16vff4RAOw03
         KPuBCg0UjgYralFAWSx99I7DAjzme5P5I+Ox7mMtqjbmvi0t+z5zgqvvTkurJR7zXZBh
         60DA==
X-Gm-Message-State: AO0yUKVE2izRlo+BQ5ffOwp7GU+lm2mke0fkNHkbwwG5U6KvdKnweocj
        rKraLmBK/MJsvKD0iGbFC+gsLKxSr6U77nGcfYfRHh7MbLrQ1vlLZmK5mcjWiZbz2Ox0KWKwvGE
        dNnR/4AeD6ZHzf3c2bjwuNozPtOZWiSUC
X-Received: by 2002:a05:6871:6a99:b0:172:3aea:ecaa with SMTP id zf25-20020a0568716a9900b001723aeaecaamr8032493oab.9.1678424740980;
        Thu, 09 Mar 2023 21:05:40 -0800 (PST)
X-Google-Smtp-Source: AK7set/azne/wuN+25wt1hpYQb7g27sw1LSGDQwvGFqieuTTpjMvA8qclduAJdvdXExQt7tKBnhuu4+uuxiZnYAGQVc=
X-Received: by 2002:a05:6871:6a99:b0:172:3aea:ecaa with SMTP id
 zf25-20020a0568716a9900b001723aeaecaamr8032485oab.9.1678424740695; Thu, 09
 Mar 2023 21:05:40 -0800 (PST)
MIME-Version: 1.0
References: <20230307113621.64153-1-gautam.dawar@amd.com> <20230307113621.64153-12-gautam.dawar@amd.com>
In-Reply-To: <20230307113621.64153-12-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 10 Mar 2023 13:05:29 +0800
Message-ID: <CACGkMEt7Lb9mkgd3oiWWsQcAvZYode35GQ_ie63VngcWOpWCBw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 11/14] sfc: use PF's IOMMU domain for running
 VF's MCDI commands
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

On Tue, Mar 7, 2023 at 7:38=E2=80=AFPM Gautam Dawar <gautam.dawar@amd.com> =
wrote:
>
> This changeset uses MC_CMD_CLIENT_CMD to execute VF's MCDI
> commands when running in vDPA mode (STATE_VDPA).
> Also, use the PF's IOMMU domain for executing the encapsulated
> VF's MCDI commands to isolate DMA of guest buffers in the VF's
> IOMMU domain.
> This patch also updates the PCIe FN's client id in the efx_nic
> structure which is required while running MC_CMD_CLIENT_CMD.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100.c      |   1 +
>  drivers/net/ethernet/sfc/ef100_nic.c  |  35 +++++++++
>  drivers/net/ethernet/sfc/mcdi.c       | 108 ++++++++++++++++++++++----
>  drivers/net/ethernet/sfc/mcdi.h       |   2 +-
>  drivers/net/ethernet/sfc/net_driver.h |   2 +
>  drivers/net/ethernet/sfc/ptp.c        |   4 +-
>  6 files changed, 132 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/=
ef100.c
> index c1c69783db7b..8453c9ba0f41 100644
> --- a/drivers/net/ethernet/sfc/ef100.c
> +++ b/drivers/net/ethernet/sfc/ef100.c
> @@ -465,6 +465,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
>         efx->type =3D (const struct efx_nic_type *)entry->driver_data;
>
>         efx->pci_dev =3D pci_dev;
> +       efx->client_id =3D MC_CMD_CLIENT_ID_SELF;
>         pci_set_drvdata(pci_dev, efx);
>         rc =3D efx_init_struct(efx, pci_dev);
>         if (rc)
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/=
sfc/ef100_nic.c
> index bda4fcbe1126..cd9f724a9e64 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -206,9 +206,11 @@ static int efx_ef100_init_datapath_caps(struct efx_n=
ic *efx)
>                   "firmware reports num_mac_stats =3D %u\n",
>                   efx->num_mac_stats);
>
> +#ifdef CONFIG_SFC_VDPA
>         nic_data->vdpa_supported =3D efx_ef100_has_cap(nic_data->datapath=
_caps3,
>                                                      CLIENT_CMD_VF_PROXY)=
 &&
>                                    efx->type->is_vf;
> +#endif

This should be done at patch 4?

>         return 0;
>  }
>
> @@ -1086,6 +1088,35 @@ static int ef100_check_design_params(struct efx_ni=
c *efx)
>         return rc;
>  }
>
> +static int efx_ef100_update_client_id(struct efx_nic *efx)
> +{
> +       struct ef100_nic_data *nic_data =3D efx->nic_data;
> +       unsigned int pf_index =3D PCIE_FUNCTION_PF_NULL;
> +       unsigned int vf_index =3D PCIE_FUNCTION_VF_NULL;
> +       efx_qword_t pciefn;
> +       int rc;
> +
> +       if (efx->pci_dev->is_virtfn)
> +               vf_index =3D nic_data->vf_index;
> +       else
> +               pf_index =3D nic_data->pf_index;
> +
> +       /* Construct PCIE_FUNCTION structure */
> +       EFX_POPULATE_QWORD_3(pciefn,
> +                            PCIE_FUNCTION_PF, pf_index,
> +                            PCIE_FUNCTION_VF, vf_index,
> +                            PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
> +       /* look up self client ID */
> +       rc =3D efx_ef100_lookup_client_id(efx, pciefn, &efx->client_id);
> +       if (rc) {
> +               pci_warn(efx->pci_dev,
> +                        "%s: Failed to get client ID, rc %d\n",
> +                        __func__, rc);
> +       }
> +
> +       return rc;
> +}
> +
>  /*     NIC probe and remove
>   */
>  static int ef100_probe_main(struct efx_nic *efx)
> @@ -1173,6 +1204,10 @@ static int ef100_probe_main(struct efx_nic *efx)
>                 goto fail;
>         efx->port_num =3D rc;
>
> +       rc =3D efx_ef100_update_client_id(efx);
> +       if (rc)
> +               goto fail;
> +
>         efx_mcdi_print_fwver(efx, fw_version, sizeof(fw_version));
>         pci_dbg(efx->pci_dev, "Firmware version %s\n", fw_version);
>
> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/m=
cdi.c
> index a7f2c31071e8..3bf1ebe05775 100644
> --- a/drivers/net/ethernet/sfc/mcdi.c
> +++ b/drivers/net/ethernet/sfc/mcdi.c
> @@ -145,14 +145,15 @@ void efx_mcdi_fini(struct efx_nic *efx)
>         kfree(efx->mcdi);
>  }
>
> -static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
> -                                 const efx_dword_t *inbuf, size_t inlen)
> +static void efx_mcdi_send_request(struct efx_nic *efx, u32 client_id,
> +                                 unsigned int cmd, const efx_dword_t *in=
buf,
> +                                 size_t inlen)
>  {
>         struct efx_mcdi_iface *mcdi =3D efx_mcdi(efx);
>  #ifdef CONFIG_SFC_MCDI_LOGGING
>         char *buf =3D mcdi->logging_buffer; /* page-sized */
>  #endif
> -       efx_dword_t hdr[2];
> +       efx_dword_t hdr[5];
>         size_t hdr_len;
>         u32 xflags, seqno;
>
> @@ -179,7 +180,7 @@ static void efx_mcdi_send_request(struct efx_nic *efx=
, unsigned cmd,
>                                      MCDI_HEADER_XFLAGS, xflags,
>                                      MCDI_HEADER_NOT_EPOCH, !mcdi->new_ep=
och);
>                 hdr_len =3D 4;
> -       } else {
> +       } else if (client_id =3D=3D efx->client_id) {
>                 /* MCDI v2 */
>                 BUG_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
>                 EFX_POPULATE_DWORD_7(hdr[0],
> @@ -194,6 +195,35 @@ static void efx_mcdi_send_request(struct efx_nic *ef=
x, unsigned cmd,
>                                      MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
>                                      MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen)=
;
>                 hdr_len =3D 8;
> +       } else {
> +               /* MCDI v2 */

Just wonder if V2 is a must for vDPA? If yes we probably need to fail
vDPA creation without it.

Thanks


> +               WARN_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
> +               /* MCDI v2 with credentials of a different client */
> +               BUILD_BUG_ON(MC_CMD_CLIENT_CMD_IN_LEN !=3D 4);
> +               /* Outer CLIENT_CMD wrapper command with client ID */
> +               EFX_POPULATE_DWORD_7(hdr[0],
> +                                    MCDI_HEADER_RESPONSE, 0,
> +                                    MCDI_HEADER_RESYNC, 1,
> +                                    MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
> +                                    MCDI_HEADER_DATALEN, 0,
> +                                    MCDI_HEADER_SEQ, seqno,
> +                                    MCDI_HEADER_XFLAGS, xflags,
> +                                    MCDI_HEADER_NOT_EPOCH, !mcdi->new_ep=
och);
> +               EFX_POPULATE_DWORD_2(hdr[1],
> +                                    MC_CMD_V2_EXTN_IN_EXTENDED_CMD,
> +                                    MC_CMD_CLIENT_CMD,
> +                                    MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen =
+ 12);
> +               MCDI_SET_DWORD(&hdr[2],
> +                              CLIENT_CMD_IN_CLIENT_ID, client_id);
> +
> +               /* MCDIv2 header for inner command */
> +               EFX_POPULATE_DWORD_2(hdr[3],
> +                                    MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
> +                                    MCDI_HEADER_DATALEN, 0);
> +               EFX_POPULATE_DWORD_2(hdr[4],
> +                                    MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
> +                                    MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen)=
;
> +               hdr_len =3D 20;
>         }
>
>  #ifdef CONFIG_SFC_MCDI_LOGGING
> @@ -474,7 +504,8 @@ static void efx_mcdi_release(struct efx_mcdi_iface *m=
cdi)
>                         &mcdi->async_list, struct efx_mcdi_async_param, l=
ist);
>                 if (async) {
>                         mcdi->state =3D MCDI_STATE_RUNNING_ASYNC;
> -                       efx_mcdi_send_request(efx, async->cmd,
> +                       efx_mcdi_send_request(efx, efx->client_id,
> +                                             async->cmd,
>                                               (const efx_dword_t *)(async=
 + 1),
>                                               async->inlen);
>                         mod_timer(&mcdi->async_timer,
> @@ -797,7 +828,7 @@ static int efx_mcdi_proxy_wait(struct efx_nic *efx, u=
32 handle, bool quiet)
>         return mcdi->proxy_rx_status;
>  }
>
> -static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
> +static int _efx_mcdi_rpc(struct efx_nic *efx, u32 client_id, unsigned in=
t cmd,
>                          const efx_dword_t *inbuf, size_t inlen,
>                          efx_dword_t *outbuf, size_t outlen,
>                          size_t *outlen_actual, bool quiet, int *raw_rc)
> @@ -811,7 +842,7 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigne=
d int cmd,
>                 return -EINVAL;
>         }
>
> -       rc =3D efx_mcdi_rpc_start(efx, cmd, inbuf, inlen);
> +       rc =3D efx_mcdi_rpc_start(efx, client_id, cmd, inbuf, inlen);
>         if (rc)
>                 return rc;
>
> @@ -836,7 +867,8 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigne=
d int cmd,
>
>                         /* We now retry the original request. */
>                         mcdi->state =3D MCDI_STATE_RUNNING_SYNC;
> -                       efx_mcdi_send_request(efx, cmd, inbuf, inlen);
> +                       efx_mcdi_send_request(efx, efx->client_id, cmd,
> +                                             inbuf, inlen);
>
>                         rc =3D _efx_mcdi_rpc_finish(efx, cmd, inlen,
>                                                   outbuf, outlen, outlen_=
actual,
> @@ -855,16 +887,44 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsig=
ned int cmd,
>         return rc;
>  }
>
> +#ifdef CONFIG_SFC_VDPA
> +static bool is_mode_vdpa(struct efx_nic *efx)
> +{
> +       if (efx->pci_dev->is_virtfn &&
> +           efx->pci_dev->physfn &&
> +           efx->state =3D=3D STATE_VDPA &&
> +           efx->vdpa_nic)
> +               return true;
> +
> +       return false;
> +}
> +#endif
> +
>  static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
>                                    const efx_dword_t *inbuf, size_t inlen=
,
>                                    efx_dword_t *outbuf, size_t outlen,
>                                    size_t *outlen_actual, bool quiet)
>  {
> +#ifdef CONFIG_SFC_VDPA
> +       struct efx_nic *efx_pf;
> +#endif
>         int raw_rc =3D 0;
>         int rc;
>
> -       rc =3D _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
> -                          outbuf, outlen, outlen_actual, true, &raw_rc);
> +#ifdef CONFIG_SFC_VDPA
> +       if (is_mode_vdpa(efx)) {
> +               efx_pf =3D pci_get_drvdata(efx->pci_dev->physfn);
> +               rc =3D _efx_mcdi_rpc(efx_pf, efx->client_id, cmd, inbuf,
> +                                  inlen, outbuf, outlen, outlen_actual,
> +                                  true, &raw_rc);
> +       } else {
> +#endif
> +               rc =3D _efx_mcdi_rpc(efx, efx->client_id, cmd, inbuf,
> +                                  inlen, outbuf, outlen, outlen_actual, =
true,
> +                                  &raw_rc);
> +#ifdef CONFIG_SFC_VDPA
> +       }
> +#endif
>
>         if ((rc =3D=3D -EPROTO) && (raw_rc =3D=3D MC_CMD_ERR_NO_EVB_PORT)=
 &&
>             efx->type->is_vf) {
> @@ -881,9 +941,22 @@ static int _efx_mcdi_rpc_evb_retry(struct efx_nic *e=
fx, unsigned cmd,
>
>                 do {
>                         usleep_range(delay_us, delay_us + 10000);
> -                       rc =3D _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
> -                                          outbuf, outlen, outlen_actual,
> -                                          true, &raw_rc);
> +#ifdef CONFIG_SFC_VDPA
> +                       if (is_mode_vdpa(efx)) {
> +                               efx_pf =3D pci_get_drvdata(efx->pci_dev->=
physfn);
> +                               rc =3D _efx_mcdi_rpc(efx_pf, efx->client_=
id, cmd,
> +                                                  inbuf, inlen, outbuf, =
outlen,
> +                                                  outlen_actual, true,
> +                                                  &raw_rc);
> +                       } else {
> +#endif
> +                               rc =3D _efx_mcdi_rpc(efx, efx->client_id,
> +                                                  cmd, inbuf, inlen, out=
buf,
> +                                                  outlen, outlen_actual,=
 true,
> +                                                  &raw_rc);
> +#ifdef CONFIG_SFC_VDPA
> +                       }
> +#endif
>                         if (delay_us < 100000)
>                                 delay_us <<=3D 1;
>                 } while ((rc =3D=3D -EPROTO) &&
> @@ -939,7 +1012,7 @@ int efx_mcdi_rpc(struct efx_nic *efx, unsigned cmd,
>   * function and is then responsible for calling efx_mcdi_display_error
>   * as needed.
>   */
> -int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
> +int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned int cmd,
>                        const efx_dword_t *inbuf, size_t inlen,
>                        efx_dword_t *outbuf, size_t outlen,
>                        size_t *outlen_actual)
> @@ -948,7 +1021,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned=
 cmd,
>                                        outlen_actual, true);
>  }
>
> -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
> +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int =
cmd,
>                        const efx_dword_t *inbuf, size_t inlen)
>  {
>         struct efx_mcdi_iface *mcdi =3D efx_mcdi(efx);
> @@ -965,7 +1038,7 @@ int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned=
 cmd,
>                 return -ENETDOWN;
>
>         efx_mcdi_acquire_sync(mcdi);
> -       efx_mcdi_send_request(efx, cmd, inbuf, inlen);
> +       efx_mcdi_send_request(efx, client_id, cmd, inbuf, inlen);
>         return 0;
>  }
>
> @@ -1009,7 +1082,8 @@ static int _efx_mcdi_rpc_async(struct efx_nic *efx,=
 unsigned int cmd,
>                  */
>                 if (mcdi->async_list.next =3D=3D &async->list &&
>                     efx_mcdi_acquire_async(mcdi)) {
> -                       efx_mcdi_send_request(efx, cmd, inbuf, inlen);
> +                       efx_mcdi_send_request(efx, efx->client_id,
> +                                             cmd, inbuf, inlen);
>                         mod_timer(&mcdi->async_timer,
>                                   jiffies + MCDI_RPC_TIMEOUT);
>                 }
> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/m=
cdi.h
> index dafab52aaef7..2c526d2edeb6 100644
> --- a/drivers/net/ethernet/sfc/mcdi.h
> +++ b/drivers/net/ethernet/sfc/mcdi.h
> @@ -150,7 +150,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned =
cmd,
>                        efx_dword_t *outbuf, size_t outlen,
>                        size_t *outlen_actual);
>
> -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
> +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int =
cmd,
>                        const efx_dword_t *inbuf, size_t inlen);
>  int efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned cmd, size_t inlen,
>                         efx_dword_t *outbuf, size_t outlen,
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet=
/sfc/net_driver.h
> index 1da71deac71c..948c7a06403a 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -859,6 +859,7 @@ struct efx_mae;
>   * @secondary_list: List of &struct efx_nic instances for the secondary =
PCI
>   *     functions of the controller, if this is for the primary function.
>   *     Serialised by rtnl_lock.
> + * @client_id: client ID of this PCIe function
>   * @type: Controller type attributes
>   * @legacy_irq: IRQ number
>   * @workqueue: Workqueue for port reconfigures and the HW monitor.
> @@ -1022,6 +1023,7 @@ struct efx_nic {
>         struct list_head secondary_list;
>         struct pci_dev *pci_dev;
>         unsigned int port_num;
> +       u32 client_id;
>         const struct efx_nic_type *type;
>         int legacy_irq;
>         bool eeh_disabled_legacy_irq;
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/pt=
p.c
> index 9f07e1ba7780..d90d4f6b3824 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -1052,8 +1052,8 @@ static int efx_ptp_synchronize(struct efx_nic *efx,=
 unsigned int num_readings)
>
>         /* Clear flag that signals MC ready */
>         WRITE_ONCE(*start, 0);
> -       rc =3D efx_mcdi_rpc_start(efx, MC_CMD_PTP, synch_buf,
> -                               MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
> +       rc =3D efx_mcdi_rpc_start(efx, MC_CMD_CLIENT_ID_SELF, MC_CMD_PTP,
> +                               synch_buf, MC_CMD_PTP_IN_SYNCHRONIZE_LEN)=
;
>         EFX_WARN_ON_ONCE_PARANOID(rc);
>
>         /* Wait for start from MCDI (or timeout) */
> --
> 2.30.1
>

