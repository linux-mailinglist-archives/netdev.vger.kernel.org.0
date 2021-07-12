Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3377D3C5A7F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhGLKFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 06:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbhGLKE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 06:04:56 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E2BC0613EE;
        Mon, 12 Jul 2021 03:02:00 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id 201so3276041qkj.13;
        Mon, 12 Jul 2021 03:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CcO+S5Zayg1q6m7Eey60LqzwAIbIXqOmOIasgtmtdWM=;
        b=MCP6NgccAbXkgNOyU8PjjtW+CaZ7oJES3A1BuZHkfY9A8y1fMr4He+CdYMYcuRix/r
         9IvHgi6aIBLvq2cAVRkA22LomSKzrxCrnUir37IDi+NpvNliIBXf5OvLu5fJgrrYuGVS
         4ASPEkH6ZauE2823e0+AF8kOmijxbZXmOU97o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CcO+S5Zayg1q6m7Eey60LqzwAIbIXqOmOIasgtmtdWM=;
        b=AqscvtWKKln9HMA11NjSPckYfOLtZ80wnccWV2FLeskxv6i/HtP3G7GvBa/vSOVdKv
         tyUx9dSyz6Vi/sIVGnmCf67AHqBeaiMPVygSRtRAmG+3+mgEAUlx6y7NGXfO1dAqLCv0
         ClwHBTSPjX9Fur5QzJYtZqLWjQ6mgNix+kvsYlBqSaTZ0/wflK5HqzV3dg3AGU4kCR7R
         j2bXBLxDeHCKQID2K4aWRKZLb2JH//MP0tCpITc4gFBruKjff1A0ZBp7sL1Hg15eQCs8
         TD5xNly1ymOUsTtNo50cwQeyKKKdNlRsmOIKeofe9RcZTrA6ProKU4Ou5IX/9jmzs+th
         NiqQ==
X-Gm-Message-State: AOAM5312yRtFRhppb2c0XUU1Hr+LPEoMInsYxxRoOTei9wBvLzDpaTw5
        77IMGH4Ib0XUqZiF5YpJJPvtKNS0lOXSjrC0XHg=
X-Google-Smtp-Source: ABdhPJyVI/uQ7Ws4s58SXJjB9pKH3dBVfAjweUVQV4zxTjzi0eljD2r56wjEaDSjQvDReuSntb16NqQ+iI4cgMDMquA=
X-Received: by 2002:a37:9d41:: with SMTP id g62mr21436759qke.55.1626084119810;
 Mon, 12 Jul 2021 03:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210708122754.555846-1-i.mikhaylov@yadro.com> <20210708122754.555846-3-i.mikhaylov@yadro.com>
In-Reply-To: <20210708122754.555846-3-i.mikhaylov@yadro.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 12 Jul 2021 10:01:45 +0000
Message-ID: <CACPK8Xff9c-_9A_tfZ4UBjucUgRmy8iOOdzcV5dg8VUCOB29AQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] net/ncsi: add NCSI Intel OEM command to keep PHY up
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Eddie James <eajames@linux.ibm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Jul 2021 at 12:27, Ivan Mikhaylov <i.mikhaylov@yadro.com> wrote:
>
> This allows to keep PHY link up and prevents any channel resets during
> the host load.
>
> It is KEEP_PHY_LINK_UP option(Veto bit) in i210 datasheet which
> block PHY reset and power state changes.

How about using runtime configuration over using kconfig for this, so
the same kernel config can be used on different machines. Something
device tree based?

Another option is to use the netlink handler to send the OEM command
from userspace. Eddie has worked on this for an IBM machine, and I've
asked him to post those changes. I would prefer the kernel option
though.


>
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
> ---
>  net/ncsi/Kconfig       |  6 ++++++
>  net/ncsi/internal.h    |  5 +++++
>  net/ncsi/ncsi-manage.c | 45 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 56 insertions(+)
>
> diff --git a/net/ncsi/Kconfig b/net/ncsi/Kconfig
> index 93309081f5a4..ea1dd32b6b1f 100644
> --- a/net/ncsi/Kconfig
> +++ b/net/ncsi/Kconfig
> @@ -17,3 +17,9 @@ config NCSI_OEM_CMD_GET_MAC
>         help
>           This allows to get MAC address from NCSI firmware and set them back to
>                 controller.
> +config NCSI_OEM_CMD_KEEP_PHY
> +       bool "Keep PHY Link up"
> +       depends on NET_NCSI
> +       help
> +         This allows to keep PHY link up and prevents any channel resets during
> +         the host load.
> diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
> index cbbb0de4750a..0b6cfd3b31e0 100644
> --- a/net/ncsi/internal.h
> +++ b/net/ncsi/internal.h
> @@ -78,6 +78,9 @@ enum {
>  /* OEM Vendor Manufacture ID */
>  #define NCSI_OEM_MFR_MLX_ID             0x8119
>  #define NCSI_OEM_MFR_BCM_ID             0x113d
> +#define NCSI_OEM_MFR_INTEL_ID           0x157
> +/* Intel specific OEM command */
> +#define NCSI_OEM_INTEL_CMD_KEEP_PHY     0x20   /* CMD ID for Keep PHY up */
>  /* Broadcom specific OEM Command */
>  #define NCSI_OEM_BCM_CMD_GMA            0x01   /* CMD ID for Get MAC */
>  /* Mellanox specific OEM Command */
> @@ -86,6 +89,7 @@ enum {
>  #define NCSI_OEM_MLX_CMD_SMAF           0x01   /* CMD ID for Set MC Affinity */
>  #define NCSI_OEM_MLX_CMD_SMAF_PARAM     0x07   /* Parameter for SMAF         */
>  /* OEM Command payload lengths*/
> +#define NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN 7
>  #define NCSI_OEM_BCM_CMD_GMA_LEN        12
>  #define NCSI_OEM_MLX_CMD_GMA_LEN        8
>  #define NCSI_OEM_MLX_CMD_SMAF_LEN        60
> @@ -271,6 +275,7 @@ enum {
>         ncsi_dev_state_probe_mlx_gma,
>         ncsi_dev_state_probe_mlx_smaf,
>         ncsi_dev_state_probe_cis,
> +       ncsi_dev_state_probe_keep_phy,
>         ncsi_dev_state_probe_gvi,
>         ncsi_dev_state_probe_gc,
>         ncsi_dev_state_probe_gls,
> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
> index 42b54a3da2e6..89c7742cd72e 100644
> --- a/net/ncsi/ncsi-manage.c
> +++ b/net/ncsi/ncsi-manage.c
> @@ -689,6 +689,35 @@ static int set_one_vid(struct ncsi_dev_priv *ndp, struct ncsi_channel *nc,
>         return 0;
>  }
>
> +#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
> +
> +static int ncsi_oem_keep_phy_intel(struct ncsi_cmd_arg *nca)
> +{
> +       unsigned char data[NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN];
> +       int ret = 0;
> +
> +       nca->payload = NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN;
> +
> +       memset(data, 0, NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN);
> +       *(unsigned int *)data = ntohl((__force __be32)NCSI_OEM_MFR_INTEL_ID);
> +
> +       data[4] = NCSI_OEM_INTEL_CMD_KEEP_PHY;
> +
> +       /* PHY Link up attribute */
> +       data[6] = 0x1;
> +
> +       nca->data = data;
> +
> +       ret = ncsi_xmit_cmd(nca);
> +       if (ret)
> +               netdev_err(nca->ndp->ndev.dev,
> +                          "NCSI: Failed to transmit cmd 0x%x during configure\n",
> +                          nca->type);
> +       return ret;
> +}
> +
> +#endif
> +
>  #if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
>
>  /* NCSI OEM Command APIs */
> @@ -1391,8 +1420,24 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
>                                 goto error;
>                 }
>
> +               nd->state = ncsi_dev_state_probe_gvi;
> +               if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
> +                       nd->state = ncsi_dev_state_probe_keep_phy;
> +               break;
> +#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
> +       case ncsi_dev_state_probe_keep_phy:
> +               ndp->pending_req_num = 1;
> +
> +               nca.type = NCSI_PKT_CMD_OEM;
> +               nca.package = ndp->active_package->id;
> +               nca.channel = 0;
> +               ret = ncsi_oem_keep_phy_intel(&nca);
> +               if (ret)
> +                       goto error;
> +
>                 nd->state = ncsi_dev_state_probe_gvi;
>                 break;
> +#endif /* CONFIG_NCSI_OEM_CMD_KEEP_PHY */
>         case ncsi_dev_state_probe_gvi:
>         case ncsi_dev_state_probe_gc:
>         case ncsi_dev_state_probe_gls:
> --
> 2.31.1
>
