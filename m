Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935DE10233A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfKSLf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:35:28 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39648 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfKSLf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:35:28 -0500
Received: by mail-ed1-f68.google.com with SMTP id l25so16766891edt.6;
        Tue, 19 Nov 2019 03:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vm+aZfC/5cPi8/oxpOEPoZUO8D4ORX+AtjR+hFAOaR8=;
        b=PNHGIZ+0qbA1ruNiOaTu1IBvEexRXUy/eVgJ3LGomoTJtpXJD0VYKIKnvJFpMZWJqF
         o1kLp4pgPF7PZ0gF1QGqesncAHEHcZNn8K7JLmByPPYCXaxXtR3L1/rn9KL3aGo/T8mb
         JwNMzNLVlORkQE8JQsi4rSwdeTpseErvi/G7GNuyw4tv8KnvpAVo2Wc1g5NuABL8++dt
         EdR2AwbCCDYCpG6K+HGefUo8DhoLtsAsgPM15IJ5UIAW47kamgDsXEAOVbQnmLZsRdoi
         C11Xn4x/+a3GDd9QShCIAl76TqVvdIkuq5CisVYCORTlar1sBUqRzVL+GzcsgZX4ricN
         JDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vm+aZfC/5cPi8/oxpOEPoZUO8D4ORX+AtjR+hFAOaR8=;
        b=nVFMiA0oj7sy3nM7QhEPTshHuyc2L3WPm8OjlHlNNSwaHMvmAYweRuWdGEPXVgNfRL
         ut2XHn0msg8cq0rdANQ0JXbNBMVdac+6BsAXe4GiXnRAF18KOnGS9HBUTCeW3kCGW1uD
         v3dJF0SnYvbJCfsGT+njVuMpHjRJm6+NiGPWueAmpgpwXufz1rhe8YKZqFitHBjP1V4z
         0hJ2Ip5pxl3/6gDNW/xv6EP0FaXIqynmpLuWgyxSpGY47F9G07BCZzfCvYcR61mi1AIq
         cMzueI/3iiWNla8vjNLvsteNCn1Zn3QYSftmGPLHeo91XiN4T0acoDyGxqQQcdvbSKj4
         3D5A==
X-Gm-Message-State: APjAAAW0yyd/YnguwWddq4qgtm70ZmG/Q/UVlTunjKlYUTEZd+T8Dzh8
        bX2o949OWNPbfN5JUVFMrwSDYbT3xvlRrkP4SAw=
X-Google-Smtp-Source: APXvYqywi470bReJS6zOa121QDrkEZBIN1pmyfGCC0EyERoT3/nHQ2/th87onKCzheD1FErsrXbcKGNFKJspWUzUjrk=
X-Received: by 2002:a17:906:24d4:: with SMTP id f20mr35614041ejb.182.1574163325377;
 Tue, 19 Nov 2019 03:35:25 -0800 (PST)
MIME-Version: 1.0
References: <20190528235627.1315-1-olteanv@gmail.com> <20190528235627.1315-4-olteanv@gmail.com>
In-Reply-To: <20190528235627.1315-4-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 19 Nov 2019 13:35:14 +0200
Message-ID: <CA+h21hpvn-9MNUze3dc2UmVTpRHrv_Xrc_LdAzpzctCqzkE8OA@mail.gmail.com>
Subject: Design issue in DSA RX timestamping (Was "Re: [PATCH net-next 3/5]
 net: dsa: mv88e6xxx: Let taggers specify a can_timestamp function")
To:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 at 02:58, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> The newly introduced function is called on both the RX and TX paths.
>
> The boolean returned by port_txtstamp should only return false if the
> driver tried to timestamp the skb but failed.
>
> Currently there is some logic in the mv88e6xxx driver that determines
> whether it should timestamp frames or not.
>
> This is wasteful, because if the decision is to not timestamp them, then
> DSA will have cloned an skb and freed it immediately afterwards.
>
> Additionally other drivers (sja1105) may have other hardware criteria
> for timestamping frames on RX, and the default conditions for
> timestamping a frame are too restrictive.  When RX timestamping is
> enabled, the sja1105 hardware emits a follow-up frame containing the
> timestamp for every trapped link-local frame.  Then the link-local frame
> is queued up inside the port_rxtstamp callback where it waits for its
> follow-up meta frame to come.  But only a subset of the link-local
> frames will pass through DSA's default filter for port_rxtstamp, so the
> rest of the link-local traffic would still receive a meta frame but
> would not get timestamped.
>
> Since the state machine of waiting for meta frames is implemented in the
> tagger rcv function for sja1105, it is difficult to know which frames
> will pass through DSA's later filter and which won't.  And since
> timestamping more frames than just PTP does no harm, just implement a
> callback for sja1105 that will say that all link-local traffic will be
> timestamped on RX.
>
> PTP classification on the skb is still performed.  But now it is saved
> to the DSA_SKB_CB, so drivers can reuse it without calling it again.
>
> The mv88e6xxx driver was also modified to use the new generic
> DSA_SKB_CB(skb)->ptp_type instead of its own, custom SKB_PTP_TYPE(skb).
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---

Hi Richard,

I've been battling some issues with sja1105 PTP after you suggested me
to do this rework and eliminate the .can_tstamp callback.

Forget my reasoning above, I've done more digging and I think I have
better arguments now. Let me try to explain a catch-22:

- DSA doesn't let drivers to select which frames should be
timestamped. It knows better.

- To be precise, it runs the PTP BPF classifier and filters only the
SYNC (but not FOLLOW-UP) messages. In principle I agree, the FOLLOW-UP
frames are general messages and don't need to be timestamped for the
PTP protocol to work. But by that logic, the HWTSTAMP_FILTER_ALL
rx_filter shouldn't exist? See this commit message:

commit f75159e9936143177b442afc78150b7a7ad8aa07
Author: Richard Cochran <richardcochran@gmail.com>
Date:   Tue Sep 20 01:25:41 2011 +0000

    ptp: fix L2 event message recognition

    The IEEE 1588 standard defines two kinds of messages, event and general
    messages. Event messages require time stamping, and general do not. When
    using UDP transport, two separate ports are used for the two message
    types.

    The BPF designed to recognize event messages incorrectly classifies L2
    general messages as event messages. This commit fixes the issue by
    extending the filter to check the message type field for L2 PTP packets.
    Event messages are be distinguished from general messages by testing
    the "general" bit.

    Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
    Cc: <stable@kernel.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

- Because it treats SYNC and FOLLOW-UP frames differently on the RX
path, it gives them a chance to get reordered. It doesn't give the
driver a chance to avoid the reordering. Both DSA drivers that support
PTP at the moment (sja1105 and mv88e6xxx) schedule a workqueue in the
.port_rxtstamp callback to collect the RX timestamp of the SYNC frame.
So the SYNC frame will get delayed, but the FOLLOW-UP will return as
false from dsa_skb_defer_rx_timestamp and be delivered immediately up
the stack.

- Without fully understanding what happens, I tried to propose better
logic for recovering reordered SYNC/FOLLOW-UP pairs at the application
level in linuxptp [1]. Needless to say, the consensus was to fix the
kernel. So here we are.

[1] https://sourceforge.net/p/linuxptp/mailman/linuxptp-devel/thread/20190928123414.9422-1-olteanv%40gmail.com/#msg36773629

>  drivers/net/dsa/mv88e6xxx/hwtstamp.c | 25 +++++++++----------------
>  drivers/net/dsa/mv88e6xxx/hwtstamp.h |  4 ++--
>  include/net/dsa.h                    |  6 ++++--
>  net/dsa/dsa.c                        | 25 +++++++++++++++----------
>  net/dsa/slave.c                      | 20 ++++++++++++++------
>  5 files changed, 44 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
> index a17c16a2ab78..3295ad10818f 100644
> --- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
> +++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
> @@ -20,8 +20,6 @@
>  #include "ptp.h"
>  #include <linux/ptp_classify.h>
>
> -#define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
> -
>  static int mv88e6xxx_port_ptp_read(struct mv88e6xxx_chip *chip, int port,
>                                    int addr, u16 *data, int len)
>  {
> @@ -216,8 +214,9 @@ int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
>  }
>
>  /* Get the start of the PTP header in this skb */
> -static u8 *parse_ptp_header(struct sk_buff *skb, unsigned int type)
> +static u8 *parse_ptp_header(struct sk_buff *skb)
>  {
> +       unsigned int type = DSA_SKB_CB(skb)->ptp_type;
>         u8 *data = skb_mac_header(skb);
>         unsigned int offset = 0;
>
> @@ -249,7 +248,7 @@ static u8 *parse_ptp_header(struct sk_buff *skb, unsigned int type)
>   * or NULL if the caller should not.
>   */
>  static u8 *mv88e6xxx_should_tstamp(struct mv88e6xxx_chip *chip, int port,
> -                                  struct sk_buff *skb, unsigned int type)
> +                                  struct sk_buff *skb)
>  {
>         struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
>         u8 *hdr;
> @@ -257,7 +256,7 @@ static u8 *mv88e6xxx_should_tstamp(struct mv88e6xxx_chip *chip, int port,
>         if (!chip->info->ptp_support)
>                 return NULL;
>
> -       hdr = parse_ptp_header(skb, type);
> +       hdr = parse_ptp_header(skb);
>         if (!hdr)
>                 return NULL;
>
> @@ -278,8 +277,7 @@ static int mv88e6xxx_ts_valid(u16 status)
>
>  static int seq_match(struct sk_buff *skb, u16 ts_seqid)
>  {
> -       unsigned int type = SKB_PTP_TYPE(skb);
> -       u8 *hdr = parse_ptp_header(skb, type);
> +       u8 *hdr = parse_ptp_header(skb);
>         __be16 *seqid;
>
>         seqid = (__be16 *)(hdr + OFF_PTP_SEQUENCE_ID);
> @@ -367,7 +365,7 @@ static int is_pdelay_resp(u8 *msgtype)
>  }
>
>  bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
> -                            struct sk_buff *skb, unsigned int type)
> +                            struct sk_buff *skb)
>  {
>         struct mv88e6xxx_port_hwtstamp *ps;
>         struct mv88e6xxx_chip *chip;
> @@ -379,12 +377,10 @@ bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
>         if (ps->tstamp_config.rx_filter != HWTSTAMP_FILTER_PTP_V2_EVENT)
>                 return false;
>
> -       hdr = mv88e6xxx_should_tstamp(chip, port, skb, type);
> +       hdr = mv88e6xxx_should_tstamp(chip, port, skb);
>         if (!hdr)
>                 return false;
>
> -       SKB_PTP_TYPE(skb) = type;
> -
>         if (is_pdelay_resp(hdr))
>                 skb_queue_tail(&ps->rx_queue2, skb);
>         else
> @@ -503,17 +499,14 @@ long mv88e6xxx_hwtstamp_work(struct ptp_clock_info *ptp)
>  }
>
>  bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
> -                            struct sk_buff *clone, unsigned int type)
> +                            struct sk_buff *clone)
>  {
>         struct mv88e6xxx_chip *chip = ds->priv;
>         struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
>         __be16 *seq_ptr;
>         u8 *hdr;
>
> -       if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
> -               return false;
> -
> -       hdr = mv88e6xxx_should_tstamp(chip, port, clone, type);
> +       hdr = mv88e6xxx_should_tstamp(chip, port, clone);
>         if (!hdr)
>                 return false;
>
> diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.h b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
> index b9a72661bcc4..17caf374332b 100644
> --- a/drivers/net/dsa/mv88e6xxx/hwtstamp.h
> +++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
> @@ -120,9 +120,9 @@ int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
>                                 struct ifreq *ifr);
>
>  bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
> -                            struct sk_buff *clone, unsigned int type);
> +                            struct sk_buff *clone);
>  bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
> -                            struct sk_buff *clone, unsigned int type);
> +                            struct sk_buff *clone);
>
>  int mv88e6xxx_get_ts_info(struct dsa_switch *ds, int port,
>                           struct ethtool_ts_info *info);
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 685294817712..2fd844688f83 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -76,6 +76,7 @@ struct dsa_device_ops {
>          * as regular on the master net device.
>          */
>         bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
> +       bool (*can_tstamp)(const struct sk_buff *skb, struct net_device *dev);
>         unsigned int overhead;
>         const char *name;
>         enum dsa_tag_protocol proto;
> @@ -87,6 +88,7 @@ struct dsa_device_ops {
>
>  struct dsa_skb_cb {
>         struct sk_buff *clone;
> +       unsigned int ptp_type;
>         bool deferred_xmit;
>  };
>
> @@ -534,9 +536,9 @@ struct dsa_switch_ops {
>         int     (*port_hwtstamp_set)(struct dsa_switch *ds, int port,
>                                      struct ifreq *ifr);
>         bool    (*port_txtstamp)(struct dsa_switch *ds, int port,
> -                                struct sk_buff *clone, unsigned int type);
> +                                struct sk_buff *clone);
>         bool    (*port_rxtstamp)(struct dsa_switch *ds, int port,
> -                                struct sk_buff *skb, unsigned int type);
> +                                struct sk_buff *skb);
>
>         /*
>          * Deferred frame Tx
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 1fc782fab393..ee5606412e2e 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -181,27 +181,32 @@ EXPORT_SYMBOL_GPL(dsa_dev_to_net_device);
>   * delivered is never notified unless we do so here.
>   */
>  static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
> -                                      struct sk_buff *skb)
> +                                      struct sk_buff *skb,
> +                                      struct net_device *dev)
>  {
>         struct dsa_switch *ds = p->dp->ds;
> -       unsigned int type;
> +
> +       if (!ds->ops->port_rxtstamp)
> +               return false;
>
>         if (skb_headroom(skb) < ETH_HLEN)
>                 return false;
>
>         __skb_push(skb, ETH_HLEN);
>
> -       type = ptp_classify_raw(skb);
> +       DSA_SKB_CB(skb)->ptp_type = ptp_classify_raw(skb);
>
>         __skb_pull(skb, ETH_HLEN);
>
> -       if (type == PTP_CLASS_NONE)
> -               return false;
> -
> -       if (likely(ds->ops->port_rxtstamp))
> -               return ds->ops->port_rxtstamp(ds, p->dp->index, skb, type);
> +       if (p->dp->cpu_dp->tag_ops->can_tstamp) {
> +               if (!p->dp->cpu_dp->tag_ops->can_tstamp(skb, dev))
> +                       return false;
> +       } else {
> +               if (DSA_SKB_CB(skb)->ptp_type == PTP_CLASS_NONE)
> +                       return false;
> +       }
>
> -       return false;
> +       return ds->ops->port_rxtstamp(ds, p->dp->index, skb);
>  }
>
>  static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
> @@ -239,7 +244,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>         s->rx_bytes += skb->len;
>         u64_stats_update_end(&s->syncp);
>
> -       if (dsa_skb_defer_rx_timestamp(p, skb))
> +       if (dsa_skb_defer_rx_timestamp(p, skb, dev))
>                 return 0;
>
>         netif_receive_skb(skb);
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 9892ca1f6859..ebe7944a2d0f 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -410,24 +410,32 @@ static inline netdev_tx_t dsa_slave_netpoll_send_skb(struct net_device *dev,
>  }
>
>  static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
> -                                struct sk_buff *skb)
> +                                struct sk_buff *skb, struct net_device *dev)
>  {
>         struct dsa_switch *ds = p->dp->ds;
>         struct sk_buff *clone;
> -       unsigned int type;
>
> -       type = ptp_classify_raw(skb);
> -       if (type == PTP_CLASS_NONE)
> +       if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
>                 return;
>
>         if (!ds->ops->port_txtstamp)
>                 return;
>
> +       DSA_SKB_CB(skb)->ptp_type = ptp_classify_raw(skb);
> +
> +       if (p->dp->cpu_dp->tag_ops->can_tstamp) {
> +               if (!p->dp->cpu_dp->tag_ops->can_tstamp(skb, dev))
> +                       return;
> +       } else {
> +               if (DSA_SKB_CB(skb)->ptp_type == PTP_CLASS_NONE)
> +                       return;
> +       }
> +
>         clone = skb_clone_sk(skb);
>         if (!clone)
>                 return;
>
> -       if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type))
> +       if (ds->ops->port_txtstamp(ds, p->dp->index, clone))
>                 return;
>
>         kfree_skb(clone);
> @@ -468,7 +476,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
>         /* Identify PTP protocol packets, clone them, and pass them to the
>          * switch driver
>          */
> -       dsa_skb_tx_timestamp(p, skb);
> +       dsa_skb_tx_timestamp(p, skb, dev);
>
>         /* Transmit function may have to reallocate the original SKB,
>          * in which case it must have freed it. Only free it here on error.
> --
> 2.17.1
>

Comments appreciated.

Regards,
-Vladimir
