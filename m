Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C72FFEB8
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbhAVIw4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Jan 2021 03:52:56 -0500
Received: from mail-yb1-f179.google.com ([209.85.219.179]:34755 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbhAVIwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:52:20 -0500
Received: by mail-yb1-f179.google.com with SMTP id x6so4803968ybr.1;
        Fri, 22 Jan 2021 00:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CcshxsSxb3HxoDICysCU4sJjdMWHDPfpU/9Zl/cZow4=;
        b=RrVWOnbrFeiKMbEg1LJl9lfRFAjR4wcCAMmVCzHvN/w6PHe0X2SehAx7j7lIjeoOai
         7BT8eNF1RHUk5x4+s8wxXWcJjjraajBNOotM8ubbgUsKnXOa3Vkcz+FR7MvcU7v+8pU0
         fjMXoCp9E/wa5OauQgm4vPk5e+yKDfNYBKyVEicS3eQWfNhWYXzSejF3sAiTIHuKappU
         S9QgYgaj6k7AI8PBOG+ZUvu80zh7EJR4kkaN1kRdB7kqyKFdP+dCd6ptOjTYPNGyMm6o
         rsfEFOr6LtojtrgVHgszM5PfhuNA3kkRR5EkhbAexfdsLPJ/gsZ52jrJUtd1IJAS72oG
         wytg==
X-Gm-Message-State: AOAM533b0xD5Isvfjzem0sgEiOVI1PMTcCqikKJbM6dcp/XWPM0T+uK9
        TG816UtDP3SpYyKRavp3PLNvXwQAs617Yw1tXoc=
X-Google-Smtp-Source: ABdhPJzSnfaDU7TrVAvA0CeBo4eAD7jqIgMgAz430yjuvhBQC7rkrf+Rdyuw2vSedemLG8e49Uo9uB/BLy5deDTWIvg=
X-Received: by 2002:a25:5583:: with SMTP id j125mr4543262ybb.307.1611305497077;
 Fri, 22 Jan 2021 00:51:37 -0800 (PST)
MIME-Version: 1.0
References: <20210122062255.202620-1-suyanjun218@gmail.com>
In-Reply-To: <20210122062255.202620-1-suyanjun218@gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 22 Jan 2021 17:51:26 +0900
Message-ID: <CAMZ6RqL87RpZrH39H9c6wi5wg4=1r104oKf542oAZ2vHRke2WQ@mail.gmail.com>
Subject: Re: [PATCH v1] can: mcp251xfd: Add some sysfs debug interfaces for
 registers r/w
To:     Su Yanjun <suyanjun218@gmail.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        manivannan.sadhasivam@linaro.org, thomas.kopp@microchip.com,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lgirdwood@gmail.com,
        broonie@kernel.org, linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In addition to Marc’s comment, I also have security concerns.

On Fri. 22 Jan 2021 at 15:22, Su Yanjun <suyanjun218@gmail.com> wrote:
> When i debug mcp2518fd, some method to track registers is
> needed. This easy debug interface will be ok.
>
> For example,
> read a register at 0xe00:
> echo 0xe00 > can_get_reg
> cat can_get_reg
>
> write a register at 0xe00:
> echo 0xe00,0x60 > can_set_reg

What about:
printf "A%0.s" {1..1000} > can_set_reg

Doesn’t it crash the kernel?

I see no checks of the buf len in your code and I suspect it to be
vulnerable to stack buffer overflow exploits.

> Signed-off-by: Su Yanjun <suyanjun218@gmail.com>
> ---
>  .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 132 ++++++++++++++++++
>  1 file changed, 132 insertions(+)
>
> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> index ab8aad0a7594..d65abe5505d5 100644
> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> @@ -27,6 +27,131 @@
>
>  #define DEVICE_NAME "mcp251xfd"
>
> +/* Add sysfs debug interface for easy to debug
> + *
> + * For example,
> + *
> + * - read a register
> + * echo 0xe00 > can_get_reg
> + * cat can_get_reg
> + *
> + * - write a register
> + * echo 0xe00,0x1 > can_set_reg
> + *
> + */
> +static int reg_offset;
> +
> +static int __get_param(const char *buf, char *off, char *val)
> +{
> +       int len;
> +
> +       if (!buf || !off || !val)
> +               return -EINVAL;
> +
> +       len = 0;
> +       while (*buf != ',') {
> +               *off++ = *buf++;
> +               len++;
> +
> +               if (len >= 16)
> +                       return -EINVAL;
> +       }
> +
> +       buf++;
> +
> +       *off = '\0';
> +
> +       len = 0;
> +       while (*buf) {
> +               *val++ = *buf++;
> +               len++;
> +
> +               if (len >= 16)
> +                       return -EINVAL;
> +       }
> +
> +       *val = '\0';
> +
> +       return 0;
> +}
> +
> +static ssize_t can_get_reg_show(struct device *dev,
> +                               struct device_attribute *attr, char *buf)
> +{
> +       int err;
> +       u32 val;
> +       struct mcp251xfd_priv *priv;
> +
> +       priv = dev_get_drvdata(dev);
> +
> +       err = regmap_read(priv->map_reg, reg_offset, &val);
> +       if (err)
> +               return 0;
> +
> +       return sprintf(buf, "reg = 0x%08x, val = 0x%08x\n", reg_offset, val);
> +}
> +
> +static ssize_t can_get_reg_store(struct device *dev,
> +                                struct device_attribute *attr, const char *buf, size_t len)
> +{
> +       u32 off;
> +
> +       reg_offset = 0;
> +
> +       if (kstrtouint(buf, 0, &off) || (off % 4))
> +               return -EINVAL;
> +
> +       reg_offset = off;
> +
> +       return len;
> +}
> +
> +static ssize_t can_set_reg_show(struct device *dev,
> +                               struct device_attribute *attr, char *buf)
> +{
> +       return 0;
> +}
> +
> +static ssize_t can_set_reg_store(struct device *dev,
> +                                struct device_attribute *attr, const char *buf, size_t len)
> +{
> +       struct mcp251xfd_priv *priv;
> +       u32 off, val;
> +       int err;
> +
> +       char s1[16];
> +       char s2[16];
> +
> +       if (__get_param(buf, s1, s2))
> +               return -EINVAL;
> +
> +       if (kstrtouint(s1, 0, &off) || (off % 4))
> +               return -EINVAL;
> +
> +       if (kstrtouint(s2, 0, &val))
> +               return -EINVAL;
> +
> +       err = regmap_write(priv->map_reg, off, val);
> +       if (err)
> +               return -EINVAL;
> +
> +       return len;
> +}
> +
> +static DEVICE_ATTR_RW(can_get_reg);
> +static DEVICE_ATTR_RW(can_set_reg);
> +
> +static struct attribute *can_attributes[] = {
> +       &dev_attr_can_get_reg.attr,
> +       &dev_attr_can_set_reg.attr,
> +       NULL
> +};
> +
> +static const struct attribute_group can_group = {
> +       .attrs = can_attributes,
> +       NULL
> +};
> +
>  static const struct mcp251xfd_devtype_data mcp251xfd_devtype_data_mcp2517fd = {
>         .quirks = MCP251XFD_QUIRK_MAB_NO_WARN | MCP251XFD_QUIRK_CRC_REG |
>                 MCP251XFD_QUIRK_CRC_RX | MCP251XFD_QUIRK_CRC_TX |
> @@ -2944,6 +3069,12 @@ static int mcp251xfd_probe(struct spi_device *spi)
>         if (err)
>                 goto out_free_candev;
>
> +       err = sysfs_create_group(&spi->dev.kobj, &can_group);
> +       if (err) {
> +               netdev_err(priv->ndev, "Create can group fail.\n");
> +               goto out_free_candev;
> +       }
> +
>         err = can_rx_offload_add_manual(ndev, &priv->offload,
>                                         MCP251XFD_NAPI_WEIGHT);
>         if (err)
> @@ -2972,6 +3103,7 @@ static int mcp251xfd_remove(struct spi_device *spi)
>         mcp251xfd_unregister(priv);
>         spi->max_speed_hz = priv->spi_max_speed_hz_orig;
>         free_candev(ndev);
> +       sysfs_remove_group(&spi->dev.kobj, &can_group);
>
>         return 0;
>  }
> --
> 2.25.1
>
