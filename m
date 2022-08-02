Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE76D587611
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 05:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbiHBDoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 23:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbiHBDnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 23:43:53 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AB33FA37;
        Mon,  1 Aug 2022 20:43:50 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 7so21926451ybw.0;
        Mon, 01 Aug 2022 20:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C0Ak4IaxG1HCbUjDZlKo8ENRe78+MF1IJnZgspJLz7c=;
        b=QahM7hQ7++dQmmQBlmk5v7D5u8cQ3T2sSnCwiEHYQOt9QzV63pteShaJ5c3iGjbW34
         rEb6C+33Mp1y7IXjDarT3K+BK42HjGcIjqlfQ0G6k87K34UZgiZM/UcDkMObBKXItsTd
         2xrnizgJK2qCy52HbF32YCiZ3Kj8q2ruQzWD3Uq4o0bpc0BgPqZ3qDsE61IoRPQu192U
         ktRcvaF7rw/1yZUbOnrYX16Jz/4F396++06Md2LdtLkzGM6HnlJwaC9iQZQ/rYF2w/Yk
         UzwR/ukYWumGclngr86ZjG6uLhp9LixLmYO3Ntk6J/yTC4JXu3pAfneKSwn6dO8OTsXZ
         iAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C0Ak4IaxG1HCbUjDZlKo8ENRe78+MF1IJnZgspJLz7c=;
        b=xFh3vJklWcLRvuyLgTM8MsXf3LIn1i/MHDFjFFN32FJteXznRou37y0PKd83WAhJWt
         9V5tu1mwDMPdXRTW1bmsBLFh7+bpcgyVIpJkec0gvhKkC7DF9E8IAWg7gebnU2u0FSRH
         MiZTiJ886s2lSdxAnzTBZbFVyFMylJIQ6LCJPWDMdX1Y9sv6dulV6WFI1CF+ImNkvdar
         ozqZvEzJ9Zc1iYZoJJuz4ZzkNLwqUrIXshEspzJoQj73a2+6dij69V6ot+92jN60wETt
         oSr0hik0HkXlbkYde3vtYZqtO0ymsuMyzAsRWijz87S3JHUbWtAUTNywQENk09YuM8Yk
         ysxA==
X-Gm-Message-State: ACgBeo3lsPosqEHNh5+2PvY+IZFWJP2QZL0FYs7RaEBIi9KSgW+/Zu3m
        SGxhckY6WSWwhPH++yja/2g0HeVVS7nrGS4LZRc=
X-Google-Smtp-Source: AA6agR5HWPVuajTSYjNz0c9u8RbmMhQwkJDRXIeuBoWDYzobwjTT2LQyuYhhxJK0aKEtQqsKQQjieJGdQAeK1VmgLPA=
X-Received: by 2002:a25:b812:0:b0:677:68f2:da19 with SMTP id
 v18-20020a25b812000000b0067768f2da19mr3768507ybj.423.1659411829897; Mon, 01
 Aug 2022 20:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz> <20220801184656.702930-2-matej.vasilevski@seznam.cz>
In-Reply-To: <20220801184656.702930-2-matej.vasilevski@seznam.cz>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Tue, 2 Aug 2022 12:43:38 +0900
Message-ID: <CAMZ6RqJEBV=1iUN3dH-ZZVujOFEoJ-U1FaJ5OOJzw+aM_mkUvA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matej,

I just send a series last week which a significant amount of changes
for CAN timestamping tree-wide:
https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/comm=
it/?id=3D12a18d79dc14c80b358dbd26461614b97f2ea4a6

I suggest you have a look at this series and harmonize it with the new
features (e.g. Hardware TX=E2=80=AFtimestamp).

On Tue. 2 Aug. 2022 at 03:52, Matej Vasilevski
<matej.vasilevski@seznam.cz> wrote :
> This patch adds support for retrieving hardware timestamps to RX and
> error CAN frames. It uses timecounter and cyclecounter structures,
> because the timestamping counter width depends on the IP core integration
> (it might not always be 64-bit).
> For platform devices, you should specify "ts_clk" clock in device tree.
> For PCI devices, the timestamping frequency is assumed to be the same
> as bus frequency.
>
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> ---
>  drivers/net/can/ctucanfd/Makefile             |   2 +-
>  drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
>  drivers/net/can/ctucanfd/ctucanfd_base.c      | 214 +++++++++++++++++-
>  drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  87 +++++++
>  4 files changed, 315 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
>
> diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd=
/Makefile
> index 8078f1f2c30f..a36e66f2cea7 100644
> --- a/drivers/net/can/ctucanfd/Makefile
> +++ b/drivers/net/can/ctucanfd/Makefile
> @@ -4,7 +4,7 @@
>  #
>
>  obj-$(CONFIG_CAN_CTUCANFD) :=3D ctucanfd.o
> -ctucanfd-y :=3D ctucanfd_base.o
> +ctucanfd-y :=3D ctucanfd_base.o ctucanfd_timestamp.o
>
>  obj-$(CONFIG_CAN_CTUCANFD_PCI) +=3D ctucanfd_pci.o
>  obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) +=3D ctucanfd_platform.o
> diff --git a/drivers/net/can/ctucanfd/ctucanfd.h b/drivers/net/can/ctucan=
fd/ctucanfd.h
> index 0e9904f6a05d..43d9c73ce244 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd.h
> +++ b/drivers/net/can/ctucanfd/ctucanfd.h
> @@ -23,6 +23,10 @@
>  #include <linux/netdevice.h>
>  #include <linux/can/dev.h>
>  #include <linux/list.h>
> +#include <linux/timecounter.h>
> +#include <linux/workqueue.h>
> +
> +#define CTUCANFD_MAX_WORK_DELAY_SEC 86400U     /* one day =3D=3D 24 * 36=
00 seconds */
>
>  enum ctu_can_fd_can_registers;
>
> @@ -51,6 +55,15 @@ struct ctucan_priv {
>         u32 rxfrm_first_word;
>
>         struct list_head peers_on_pdev;
> +
> +       struct cyclecounter cc;
> +       struct timecounter tc;
> +       struct delayed_work timestamp;
> +
> +       struct clk *timestamp_clk;
> +       u32 work_delay_jiffies;
> +       bool timestamp_enabled;
> +       bool timestamp_possible;
>  };
>
>  /**
> @@ -79,4 +92,11 @@ int ctucan_probe_common(struct device *dev, void __iom=
em *addr,
>  int ctucan_suspend(struct device *dev) __maybe_unused;
>  int ctucan_resume(struct device *dev) __maybe_unused;
>
> +u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc);
> +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv);
> +u32 ctucan_calculate_work_delay(const u32 timestamp_bit_size, const u32 =
timestamp_freq);
> +void ctucan_skb_set_timestamp(const struct ctucan_priv *priv, struct sk_=
buff *skb,
> +                             u64 timestamp);
> +void ctucan_timestamp_init(struct ctucan_priv *priv);
> +void ctucan_timestamp_stop(struct ctucan_priv *priv);
>  #endif /*__CTUCANFD__*/
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/c=
tucanfd/ctucanfd_base.c
> index 3c18d028bd8c..35b37de51811 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_base.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
> @@ -18,6 +18,7 @@
>   ***********************************************************************=
*******/
>
>  #include <linux/clk.h>
> +#include <linux/clocksource.h>
>  #include <linux/errno.h>
>  #include <linux/ethtool.h>
>  #include <linux/init.h>
> @@ -148,6 +149,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv =
*priv, enum ctu_can_fd_can_r
>         priv->write_reg(priv, buf_base + offset, val);
>  }
>
> +static u64 concatenate_two_u32(u32 high, u32 low)

Might be good to add the "namespace" prefix. I suggest:

static u64 ctucan_concat_tstamp(u32 high, u32 low)

Because, so far, the function is to be used exclusively with timestamps.

Also, I was surprised that no helper functions in include/linux/
headers already do that. But this is another story.

> +{
> +       return ((u64)high << 32) | ((u64)low);
> +}
> +
> +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv)
> +{
> +       u32 ts_low;
> +       u32 ts_high;
> +       u32 ts_high2;
> +
> +       ts_high =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> +       ts_low =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_LOW);
> +       ts_high2 =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> +
> +       if (ts_high2 !=3D ts_high)
> +               ts_low =3D priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
> +
> +       return concatenate_two_u32(ts_high2, ts_low) & priv->cc.mask;
> +}
> +
>  #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read=
32(priv, CTUCANFD_STATUS)))
>  #define CTU_CAN_FD_ENABLED(priv) (!!FIELD_GET(REG_MODE_ENA, ctucan_read3=
2(priv, CTUCANFD_MODE)))


#define CTU_CAN_FD_TXTNF(priv) \
        (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read32(priv, CTUCANFD_STATUS))=
)

#define CTU_CAN_FD_ENABLED(priv) \
        (!!FIELD_GET(REG_MODE_ENA, ctucan_read32(priv, CTUCANFD_MODE)))

Even if the rule is now more relaxed, the soft limit remains 80
characters per line:

https://www.kernel.org/doc/html/latest/process/coding-style.html#breaking-l=
ong-lines-and-strings

> @@ -640,12 +662,16 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff=
 *skb, struct net_device *nde
>   * @priv:      Pointer to CTU CAN FD's private data
>   * @cf:                Pointer to CAN frame struct
>   * @ffw:       Previously read frame format word
> + * @skb:       Pointer to buffer to store timestamp
>   *
>   * Note: Frame format word must be read separately and provided in 'ffw'=
.
>   */
> -static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf, u32 ffw)
> +static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf,
> +                                u32 ffw, u64 *timestamp)
>  {
>         u32 idw;
> +       u32 tstamp_high;
> +       u32 tstamp_low;
>         unsigned int i;
>         unsigned int wc;
>         unsigned int len;
> @@ -682,9 +708,10 @@ static void ctucan_read_rx_frame(struct ctucan_priv =
*priv, struct canfd_frame *c
>         if (unlikely(len > wc * 4))
>                 len =3D wc * 4;
>
> -       /* Timestamp - Read and throw away */
> -       ctucan_read32(priv, CTUCANFD_RX_DATA);
> -       ctucan_read32(priv, CTUCANFD_RX_DATA);
> +       /* Timestamp */
> +       tstamp_low =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> +       tstamp_high =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> +       *timestamp =3D concatenate_two_u32(tstamp_high, tstamp_low) & pri=
v->cc.mask;
>
>         /* Data */
>         for (i =3D 0; i < len; i +=3D 4) {
> @@ -713,6 +740,7 @@ static int ctucan_rx(struct net_device *ndev)
>         struct net_device_stats *stats =3D &ndev->stats;
>         struct canfd_frame *cf;
>         struct sk_buff *skb;
> +       u64 timestamp;
>         u32 ffw;
>
>         if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
> @@ -736,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
>                 return 0;
>         }
>
> -       ctucan_read_rx_frame(priv, cf, ffw);
> +       ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
> +       if (priv->timestamp_enabled)
> +               ctucan_skb_set_timestamp(priv, skb, timestamp);
>
>         stats->rx_bytes +=3D cf->len;
>         stats->rx_packets++;
> @@ -906,6 +936,11 @@ static void ctucan_err_interrupt(struct net_device *=
ndev, u32 isr)
>         if (skb) {
>                 stats->rx_packets++;
>                 stats->rx_bytes +=3D cf->can_dlc;
> +               if (priv->timestamp_enabled) {
> +                       u64 tstamp =3D ctucan_read_timestamp_counter(priv=
);
> +
> +                       ctucan_skb_set_timestamp(priv, skb, tstamp);
> +               }
>                 netif_rx(skb);
>         }
>  }
> @@ -951,6 +986,11 @@ static int ctucan_rx_poll(struct napi_struct *napi, =
int quota)
>                         cf->data[1] |=3D CAN_ERR_CRTL_RX_OVERFLOW;
>                         stats->rx_packets++;
>                         stats->rx_bytes +=3D cf->can_dlc;
> +                       if (priv->timestamp_enabled) {
> +                               u64 tstamp =3D ctucan_read_timestamp_coun=
ter(priv);
> +
> +                               ctucan_skb_set_timestamp(priv, skb, tstam=
p);
> +                       }
>                         netif_rx(skb);
>                 }
>
> @@ -1231,6 +1271,9 @@ static int ctucan_open(struct net_device *ndev)
>                 goto err_chip_start;
>         }
>
> +       if (priv->timestamp_possible)
> +               ctucan_timestamp_init(priv);
> +
>         netdev_info(ndev, "ctu_can_fd device registered\n");
>         napi_enable(&priv->napi);
>         netif_start_queue(ndev);
> @@ -1263,6 +1306,9 @@ static int ctucan_close(struct net_device *ndev)
>         ctucan_chip_stop(ndev);
>         free_irq(ndev->irq, ndev);
>         close_candev(ndev);
> +       if (priv->timestamp_possible)
> +               ctucan_timestamp_stop(priv);
> +
>
>         pm_runtime_put(priv->dev);
>
> @@ -1295,15 +1341,117 @@ static int ctucan_get_berr_counter(const struct =
net_device *ndev, struct can_ber
>         return 0;
>  }
>
> +static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq *ifr=
)
> +{
> +       struct ctucan_priv *priv =3D netdev_priv(dev);
> +       struct hwtstamp_config cfg;
> +
> +       if (!priv->timestamp_possible)
> +               return -EOPNOTSUPP;
> +
> +       if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> +               return -EFAULT;
> +
> +       if (cfg.flags)
> +               return -EINVAL;
> +
> +       if (cfg.tx_type !=3D HWTSTAMP_TX_OFF)
> +               return -ERANGE;

I have a great news: your driver now also support hardware TX timestamps:

https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/comm=
it/?id=3D8bdd1112edcd3edce2843e03826204a84a61042d

> +
> +       switch (cfg.rx_filter) {
> +       case HWTSTAMP_FILTER_NONE:
> +               priv->timestamp_enabled =3D false;
> +               break;
> +       case HWTSTAMP_FILTER_ALL:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +               fallthrough;
> +       case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +               priv->timestamp_enabled =3D true;
> +               cfg.rx_filter =3D HWTSTAMP_FILTER_ALL;
> +               break;

All those HWTSTAMP_FILTER_PTP_V2_* filters are for UDP, Ethernet or AS1:
https://elixir.bootlin.com/linux/v5.4.5/source/include/uapi/linux/net_tstam=
p.h#L106

Because those layers do not exist in CAN, I suggest treating them all
as not supported.

Please have a look at this patch:
https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/comm=
it/?id=3D90f942c5a6d775bad1be33ba214755314105da4a

> +       default:
> +               return -ERANGE;
> +       }
> +
> +       return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT :=
 0;
> +}
> +
> +static int ctucan_hwtstamp_get(struct net_device *dev, struct ifreq *ifr=
)
> +{
> +       struct ctucan_priv *priv =3D netdev_priv(dev);
> +       struct hwtstamp_config cfg;
> +
> +       if (!priv->timestamp_possible)
> +               return -EOPNOTSUPP;
> +
> +       cfg.flags =3D 0;
> +       cfg.tx_type =3D HWTSTAMP_TX_OFF;

Hardware TX timestamps are now supported (c.f. supra).

> +       cfg.rx_filter =3D priv->timestamp_enabled ? HWTSTAMP_FILTER_ALL :=
 HWTSTAMP_FILTER_NONE;
> +       return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT :=
 0;
> +}
> +
> +static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr, int c=
md)

Please consider using the generic function can_eth_ioctl_hwts()
https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/comm=
it/?id=3D90f942c5a6d775bad1be33ba214755314105da4a

> +{
> +       switch (cmd) {
> +       case SIOCSHWTSTAMP:
> +               return ctucan_hwtstamp_set(dev, ifr);
> +       case SIOCGHWTSTAMP:
> +               return ctucan_hwtstamp_get(dev, ifr);
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> +}
>
> +static int ctucan_ethtool_get_ts_info(struct net_device *ndev, struct et=
htool_ts_info *info)

Please break the line to meet the 80 columns soft limit.

Please consider using the generic function can_ethtool_op_get_ts_info_hwts(=
):
https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/comm=
it/?id=3D7fb48d25b5ce3bc488dbb019bf1736248181de9a

Something like that:
static int ctucan_ethtool_get_ts_info(struct net_device *ndev,
                                      struct ethtool_ts_info *inf
{
        struct ctucan_priv *priv =3D netdev_priv(ndev);

        if (!priv->timestamp_possible)
                ethtool_op_get_ts_info(ndev, info);

        return can_ethtool_op_get_ts_info_hwts(ndev, info);
}

> +{
> +       struct ctucan_priv *priv =3D netdev_priv(ndev);
> +
> +       ethtool_op_get_ts_info(ndev, info);
> +
> +       if (!priv->timestamp_possible)
> +               return 0;
> +
> +       info->so_timestamping |=3D SOF_TIMESTAMPING_RX_HARDWARE |
> +                                SOF_TIMESTAMPING_RAW_HARDWARE;
> +       info->tx_types =3D BIT(HWTSTAMP_TX_OFF);

Hardware TX timestamps are now supported (c.f. supra).

> +       info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE) |
> +                          BIT(HWTSTAMP_FILTER_ALL);
> +
> +       return 0;
> +}
> +
>  static const struct net_device_ops ctucan_netdev_ops =3D {
>         .ndo_open       =3D ctucan_open,
>         .ndo_stop       =3D ctucan_close,
>         .ndo_start_xmit =3D ctucan_start_xmit,
>         .ndo_change_mtu =3D can_change_mtu,
> +       .ndo_eth_ioctl  =3D ctucan_ioctl,
>  };
>
>  static const struct ethtool_ops ctucan_ethtool_ops =3D {
> -       .get_ts_info =3D ethtool_op_get_ts_info,
> +       .get_ts_info =3D ctucan_ethtool_get_ts_info,
>  };
>
>  int ctucan_suspend(struct device *dev)
> @@ -1345,6 +1493,8 @@ int ctucan_probe_common(struct device *dev, void __=
iomem *addr, int irq, unsigne
>         struct ctucan_priv *priv;
>         struct net_device *ndev;
>         int ret;
> +       u32 timestamp_freq =3D 0;
> +       u32 timestamp_bit_size =3D 0;
>
>         /* Create a CAN device instance */
>         ndev =3D alloc_candev(sizeof(struct ctucan_priv), ntxbufs);
> @@ -1386,7 +1536,9 @@ int ctucan_probe_common(struct device *dev, void __=
iomem *addr, int irq, unsigne
>
>         /* Getting the can_clk info */
>         if (!can_clk_rate) {
> -               priv->can_clk =3D devm_clk_get(dev, NULL);
> +               priv->can_clk =3D devm_clk_get_optional(dev, "core-clk");
> +               if (!priv->can_clk)
> +                       priv->can_clk =3D devm_clk_get(dev, NULL);
>                 if (IS_ERR(priv->can_clk)) {
>                         dev_err(dev, "Device clock not found.\n");

Just a suggestion, but you may want to print the mnemotechnic of the error =
code:
dev_err(dev, "Device clock not found: %pe.\n", priv->can_clk);

>                         ret =3D PTR_ERR(priv->can_clk);
> @@ -1425,6 +1577,54 @@ int ctucan_probe_common(struct device *dev, void _=
_iomem *addr, int irq, unsigne
>
>         priv->can.clock.freq =3D can_clk_rate;
>
> +       priv->timestamp_enabled =3D false;
> +       priv->timestamp_possible =3D true;
> +       priv->timestamp_clk =3D NULL;
> +
> +       /* Obtain timestamping frequency */
> +       if (pm_enable_call) {
> +               /* Plaftorm device: get tstamp clock from device tree */
> +               priv->timestamp_clk =3D devm_clk_get(dev, "ts-clk");
> +               if (IS_ERR(priv->timestamp_clk)) {
> +                       /* Take the core clock frequency instead */
> +                       timestamp_freq =3D can_clk_rate;
> +               } else {
> +                       timestamp_freq =3D clk_get_rate(priv->timestamp_c=
lk);
> +               }
> +       } else {
> +               /* PCI device: assume tstamp freq is equal to bus clk rat=
e */
> +               timestamp_freq =3D can_clk_rate;
> +       }
> +
> +       /* Obtain timestamping counter bit size */
> +       timestamp_bit_size =3D (ctucan_read32(priv, CTUCANFD_ERR_CAPT) & =
REG_ERR_CAPT_TS_BITS) >> 24;
> +       timestamp_bit_size +=3D 1;        /* the register value was bit_s=
ize - 1 */
> +
> +       /* For 2.x versions of the IP core, we will assume 64-bit counter
> +        * if there was a 0 in the register.
> +        */
> +       if (timestamp_bit_size =3D=3D 1) {
> +               u32 version_reg =3D ctucan_read32(priv, CTUCANFD_DEVICE_I=
D);
> +               u32 major =3D (version_reg & REG_DEVICE_ID_VER_MAJOR) >> =
24;
> +
> +               if (major =3D=3D 2)
> +                       timestamp_bit_size =3D 64;
> +               else
> +                       priv->timestamp_possible =3D false;
> +       }
> +
> +       /* Setup conversion constants and work delay */
> +       priv->cc.read =3D ctucan_read_timestamp_cc_wrapper;
> +       priv->cc.mask =3D CYCLECOUNTER_MASK(timestamp_bit_size);
> +       if (priv->timestamp_possible) {
> +               clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, t=
imestamp_freq,
> +                                      NSEC_PER_SEC, CTUCANFD_MAX_WORK_DE=
LAY_SEC);
> +               priv->work_delay_jiffies =3D
> +                       ctucan_calculate_work_delay(timestamp_bit_size, t=
imestamp_freq);
> +               if (priv->work_delay_jiffies =3D=3D 0)
> +                       priv->timestamp_possible =3D false;
> +       }
> +
>         netif_napi_add(ndev, &priv->napi, ctucan_rx_poll, NAPI_POLL_WEIGH=
T);
>
>         ret =3D register_candev(ndev);
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_timestamp.c b/drivers/net/=
can/ctucanfd/ctucanfd_timestamp.c
> new file mode 100644
> index 000000000000..c802123bbfbb
> --- /dev/null
> +++ b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> @@ -0,0 +1,87 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/***********************************************************************=
********
> + *
> + * CTU CAN FD IP Core
> + *
> + * Copyright (C) 2022 Matej Vasilevski <matej.vasilevski@seznam.cz> FEE =
CTU
> + *
> + * Project advisors:
> + *     Jiri Novak <jnovak@fel.cvut.cz>
> + *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
> + *
> + * Department of Measurement         (http://meas.fel.cvut.cz/)
> + * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
> + * Czech Technical University        (http://www.cvut.cz/)
> + ***********************************************************************=
*******/
> +
> +#include "vdso/time64.h"
> +#include <linux/bitops.h>
> +#include <linux/clocksource.h>
> +#include <linux/math64.h>
> +#include <linux/timecounter.h>
> +#include <linux/workqueue.h>
> +
> +#include "ctucanfd.h"
> +#include "ctucanfd_kregs.h"
> +
> +u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc)
> +{
> +       struct ctucan_priv *priv;
> +
> +       priv =3D container_of(cc, struct ctucan_priv, cc);
> +       return ctucan_read_timestamp_counter(priv);
> +}
> +
> +static void ctucan_timestamp_work(struct work_struct *work)
> +{
> +       struct delayed_work *delayed_work =3D to_delayed_work(work);
> +       struct ctucan_priv *priv;
> +
> +       priv =3D container_of(delayed_work, struct ctucan_priv, timestamp=
);
> +       timecounter_read(&priv->tc);
> +       schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies)=
;
> +}
> +
> +u32 ctucan_calculate_work_delay(const u32 timestamp_bit_size, const u32 =
timestamp_freq)
> +{
> +       u32 jiffies_order =3D fls(HZ);
> +       u32 max_shift_left =3D 63 - jiffies_order;
> +       s32 final_shift =3D (timestamp_bit_size - 1) - max_shift_left;
> +       u64 work_delay_jiffies;
> +
> +       /* The formula is work_delay_jiffies =3D 2**(bit_size - 1) / ts_f=
requency * HZ
> +        * using (bit_size - 1) instead of full bit_size to read the coun=
ter
> +        * roughly twice per period
> +        */
> +       work_delay_jiffies =3D div_u64((u64)HZ << max_shift_left, timesta=
mp_freq);
> +
> +       if (final_shift > 0)
> +               work_delay_jiffies =3D work_delay_jiffies << final_shift;
> +       else
> +               work_delay_jiffies =3D work_delay_jiffies >> -final_shift=
;
> +
> +       work_delay_jiffies =3D min(work_delay_jiffies,
> +                                (unsigned long long)CTUCANFD_MAX_WORK_DE=
LAY_SEC * HZ);
> +       return (u32)work_delay_jiffies;
> +}
> +
> +void ctucan_skb_set_timestamp(const struct ctucan_priv *priv, struct sk_=
buff *skb, u64 timestamp)
> +{
> +       struct skb_shared_hwtstamps *hwtstamps =3D skb_hwtstamps(skb);
> +       u64 ns;
> +
> +       ns =3D timecounter_cyc2time(&priv->tc, timestamp);
> +       hwtstamps->hwtstamp =3D ns_to_ktime(ns);
> +}
> +
> +void ctucan_timestamp_init(struct ctucan_priv *priv)
> +{
> +       timecounter_init(&priv->tc, &priv->cc, ktime_get_real_ns());
> +       INIT_DELAYED_WORK(&priv->timestamp, ctucan_timestamp_work);
> +       schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies)=
;
> +}
> +
> +void ctucan_timestamp_stop(struct ctucan_priv *priv)
> +{
> +       cancel_delayed_work_sync(&priv->timestamp);
> +}
> --
> 2.25.1
>
