Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4257402936
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344489AbhIGMwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:52:41 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:39623 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344461AbhIGMwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:52:35 -0400
Received: by mail-lf1-f48.google.com with SMTP id m28so19312029lfj.6;
        Tue, 07 Sep 2021 05:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cwvZGL6uNGaaqi2+xOXF2yAR0QJUaEhN/7eK3I1Y/yU=;
        b=mgc8fp0HNLd+yDAxCkUEh0PU9PqgjHyxRqLSOPqxy6l3+tcATtElc231svWdP+8oap
         WbhY5AxY8L13cg6Awp/0msAAtZFFi3KZNp/3MjdarJlb1n/0q299qlOeAJRs5TjUsTOv
         BfR0/vsC3hOWzKLncKQl8M/zcPwdx8R8HFSG/qIMGLuoGO+SIpnYHFilAh0cvH59uvJU
         Rl5opGg2ONW2Ej2BAZmz+oG30dp1y/9ee/m+ZGRc1HL8Z2L1X9pVFADAGU0cUTjeW2IX
         2JP87Se6Nu2zkFnmAQZfEI1hHdRElK2TmnvC/im9NLnntXOALZAs29qLzyXGVG4CJSCB
         vBsw==
X-Gm-Message-State: AOAM532w4J9XxRQAqYCBfB+0q/ESkGlc8QULVsLGYFEAdPUQp2/Qrp1S
        ao41+fbDrOLoe2zWZvmTUq6nxR+qGuKtGQreJM2IgNX9TA4=
X-Google-Smtp-Source: ABdhPJwIaRn4ZabO1pNbBfeo+qE9noLmjJns7/iHE2YJdhZYx3GlG8KJs/Fl+/LmHUIjKE/gbJUkQ4K9ElC19vMWF8k=
X-Received: by 2002:a19:c710:: with SMTP id x16mr12535481lff.405.1631019088020;
 Tue, 07 Sep 2021 05:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210906160310.54831-1-mailhol.vincent@wanadoo.fr> <20210906160310.54831-2-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20210906160310.54831-2-mailhol.vincent@wanadoo.fr>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Sep 2021 21:51:16 +0900
Message-ID: <CAMZ6RqJaY_jRv+AZ6oH6rxP=dE9Vs1fBwhBQJq_o3dgMWM1vUg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] can: netlink: prevent incoherent can configuration
 in case of early return
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 7 Sep. 2021 at 01:03, Vincent Mailhol
<mailhol.vincent@wanadoo.fr> wrote:
> struct can_priv has a set of flags (can_priv::ctrlmode) which are
> correlated with the other fields of the structure. In
> can_changelink(), those flags are set first and copied to can_priv. If
> the function has to return early, for example due to an out of range
> value provided by the user, then the global configuration might become
> incoherent.
>
> Example: the user provides an out of range dbitrate (e.g. 20
> Mbps). The command fails (-EINVAL), however the FD flag was already
> set resulting in a configuration where FD is on but the databittiming
> parameters are empty.
>
> * Illustration of above example *
>
> | $ ip link set can0 type can bitrate 500000 dbitrate 20000000 fd on
> | RTNETLINK answers: Invalid argument
> | $ ip --details link show can0
> | 1: can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group default qlen 10
> |     link/can  promiscuity 0 minmtu 0 maxmtu 0
> |     can <FD> state STOPPED restart-ms 0
>            ^^ FD flag is set without any of the databittiming parameters...
> |         bitrate 500000 sample-point 0.875
> |         tq 12 prop-seg 69 phase-seg1 70 phase-seg2 20 sjw 1
> |         ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp-inc 1
> |         ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp-inc 1
> |         clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
>
> To prevent this from happening, we do a local copy of can_priv, work
> on it, an copy it at the very end of the function (i.e. only if all
> previous checks succeeded).
>
> Once this done, there is no more need to have a temporary variable for
> a specific parameter. As such, the bittiming and data bittiming (bt
> and dbt) are directly written to the temporary priv variable.
>
>
> N.B. The temporary can_priv is too big to be allocated on the stack
> because, on x86_64 sizeof(struct can_priv) is 448 and:
>
> | $ objdump -d drivers/net/can/dev/netlink.o | ./scripts/checkstack.pl
> | 0x00000000000002100 can_changelink []:            1200
>
>
> Fixes: 9859ccd2c8be ("can: introduce the data bitrate configuration for CAN FD")
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  drivers/net/can/dev/netlink.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
> index 80425636049d..21b76ca8cb22 100644
> --- a/drivers/net/can/dev/netlink.c
> +++ b/drivers/net/can/dev/netlink.c
> @@ -58,14 +58,19 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
>                           struct nlattr *data[],
>                           struct netlink_ext_ack *extack)
>  {
> -       struct can_priv *priv = netdev_priv(dev);
> +       /* Work on a local copy of priv to prevent inconsistent value
> +        * in case of early return.
> +        */
> +       static struct can_priv *priv;
>         int err;
>
>         /* We need synchronization with dev->stop() */
>         ASSERT_RTNL();
>
> +       priv = kmemdup(netdev_priv(dev), sizeof(*priv), GFP_KERNEL);
> +
>         if (data[IFLA_CAN_BITTIMING]) {
> -               struct can_bittiming bt;
> +               struct can_bittiming *bt = &priv->bittiming;
>
>                 /* Do not allow changing bittiming while running */
>                 if (dev->flags & IFF_UP)
> @@ -79,22 +84,20 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
>                 if (!priv->bittiming_const && !priv->do_set_bittiming)
>                         return -EOPNOTSUPP;
>
> -               memcpy(&bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(bt));
> -               err = can_get_bittiming(dev, &bt,
> +               memcpy(bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(*bt));
> +               err = can_get_bittiming(dev, bt,
>                                         priv->bittiming_const,
>                                         priv->bitrate_const,
>                                         priv->bitrate_const_cnt);
>                 if (err)
>                         return err;
>
> -               if (priv->bitrate_max && bt.bitrate > priv->bitrate_max) {
> +               if (priv->bitrate_max && bt->bitrate > priv->bitrate_max) {
>                         netdev_err(dev, "arbitration bitrate surpasses transceiver capabilities of %d bps\n",
>                                    priv->bitrate_max);
>                         return -EINVAL;
>                 }
>
> -               memcpy(&priv->bittiming, &bt, sizeof(bt));
> -
>                 if (priv->do_set_bittiming) {
>                         /* Finally, set the bit-timing registers */
>                         err = priv->do_set_bittiming(dev);

Actually, there is a big issue with my approach: the
do_set_bittiming() and some other callback functions need to
access priv. However, the changes being in the temporary
variable, these will not be visible by the device.

I will rework all that a little bit more before sending v4.


Yours sincerely,
Vincent Mailhol
