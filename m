Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D93E3A9CB8
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 15:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhFPN4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 09:56:22 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:42865 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbhFPNzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 09:55:22 -0400
Received: by mail-lj1-f175.google.com with SMTP id r16so3927987ljk.9;
        Wed, 16 Jun 2021 06:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yak0Jw5qtLSF6XuLp21VlMysIAiLyA6w6CP8nitLvQk=;
        b=mEfyXChHnSHaCrGszybE5zi+Y5Q52iSpBk2fEZ+qYpEDlTE3eYnKoHB4hdc5ScNCm1
         GyZl/a7GbkFK6zaAISQ0EOF+JcI9aj2N24fsVDDSGZ7A4/QKI2neA8IvlGdhXyLPeHLW
         5U6c4CBETcf1zv16Yse7ZJuxvyJ3gYhHvUyy5oqCQ6uodcthYOKmiEgB1mgPdz4cNPj9
         w439Q5blXZAhwG0R7xHA+cAGZ+YtsZA4cA2+gxN0KXs2CWi+4vlDt5pxyEJ5s0f0dbRI
         eq7LsmwrgdG7O0U+jVGmlYdEznTKvUFKgtZqrT4uILxDaNHtixOcmaZ92VxIYB8jTosy
         aEXw==
X-Gm-Message-State: AOAM530Lkxbozny+eTZTw58Pjndsvpra/7V1OxBd3qWFMeMxgB98tCRd
        PPi6Ox/RRtIySu1/6L9A+lgz532hETy3baxFRfg=
X-Google-Smtp-Source: ABdhPJztjS7vGrTuoCmVUMZtJGuQRKly2mHe+80maPnLjPtU4tmHy4EeVuU3+loy+xoAWDpQCjIOm2Ro0fGrZJYK60E=
X-Received: by 2002:a2e:bf14:: with SMTP id c20mr4534138ljr.57.1623851594153;
 Wed, 16 Jun 2021 06:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr> <20210616094633.fwg6rsyxyvm2zc6d@pengutronix.de>
In-Reply-To: <20210616094633.fwg6rsyxyvm2zc6d@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 16 Jun 2021 22:53:02 +0900
Message-ID: <CAMZ6RqLj59+3PrQwTCfK_bVebRBHE=HqCfRb31MU9pRDBPxG8w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] can: netlink: add interface for CAN-FD Transmitter
 Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 16 Jun 2021 at 18:46, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 04.06.2021 00:15:50, Vincent Mailhol wrote:
> [...]
>
> > +static size_t can_tdc_get_size(const struct net_device *dev)
> > +{
> > +     struct can_priv *priv = netdev_priv(dev);
> > +     size_t size;
> > +
> > +     if (!priv->tdc_const)
> > +             return 0;
> > +
> > +     size = nla_total_size(0);                       /* nest IFLA_CAN_TDC */
> > +     size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCV_MAX */
> > +     size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCO_MAX */
> > +     size += nla_total_size(sizeof(u32));            /* IFLA_CAN_TDCF_MAX */
> > +
> > +     if (priv->tdc.tdco) {
>
> Naively I'd say, iff the device has tdc_const give the user space the
> tdc parameters, regardless if some value is 0 or not.
>
> What do you think?

I thought about that.
The first important remark is that if tdc.tdco is zero, then TDC
is off (c.f. documentation of struct can_tdc::tdco).

Let me illustrate my vision through examples.


** Case 1: link is not configured at all. **
Here, only the constant values are displayed.

# ip --details link show can0
1:  can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group
default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
      ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
      ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 brp_inc 1
      tdcv_max 0 tdco_max 127 tdcf_max 127
      clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536
gso_max_segs 65535


** Case 2: only the nominal bitrate is configured. **
The data bittiming variables (including TDC) are not shown.

# ip --details link show can0
1:  can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group
default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
      bitrate 500000 sample-point 0.875
      tq 12 prop-seg 69 phase-seg1 70phase-seg2 20  sjw 1
      ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
      ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 brp_inc 1
      tdcv_max 0 tdco_max 127 tdcf_max 127
      clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536
gso_max_segs 65535


** Case 3: both nominal and data bitrates are configured (but not TDC). **
Only the TDC variables are not shown.

# ip --details link show can0
1:  can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group
default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can <FD> state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
      bitrate 500000 sample-point 0.875
      tq 12 prop-seg 69 phase-seg1 70phase-seg2 20  sjw 1
      ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
      dbitrate 2000000 dsample-point 0.750
      dtq 12 dprop-seg 14 dphase-seg1 15 dphase-seg2 10 dsjw 1
      ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 brp_inc 1
      tdcv_max 0 tdco_max 127 tdcf_max 127
      clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536
gso_max_segs 65535


** Case 4: nominal and data bitrates and TDC are configured. **
Everything is shown.

# ip --details link show can0
1:  can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group
default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can <FD> state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
      bitrate 1000000 sample-point 0.750
      tq 12 prop-seg 29 phase-seg1 30phase-seg2 20  sjw 1
      ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
      dbitrate 5000000 dsample-point 0.750
      dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 1
      tdcv 0 tdco 12 tdcf 0
      ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 brp_inc 1
      tdcv_max 0 tdco_max 127 tdcf_max 127
      clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536
gso_max_segs 65535


I think that we can agree on Cases 1, 2 (it would not make sense
to display TDC without the data bittiming variables) and 4.

The edge case is Case 3. It depends if we consider the TDC as a
separate set or not. It is not silly to display the TDC whenever
fd is on. I prefer to keep it the way I did it. But I would not
object to changing this if you insist. That would mean:
-     if (priv->tdc.tdco) {
+     if (priv->data_bittiming.bitrate) {


Finally, I have one side comment. It seems to me that you did not
understand that the intent of
|     if (priv->tdc.tdco)
was to actually check whether TDC was on or off. In other words, my
code was unclear.

I am now thinking to introduce an helper macro:
static bool can_tdc_is_enabled(const struct can_priv *priv)
|{
|    return !!priv->tdc.tdco;
|}

The code would look more clear like that.
-     if (priv->tdc.tdco) {
+     if (can_tdc_is_enabled(priv) {


Yours sincerely,
Vincent
