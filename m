Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B78402233
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 04:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241373AbhIGCHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 22:07:03 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:33390 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbhIGCHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 22:07:02 -0400
Received: by mail-lj1-f182.google.com with SMTP id s12so14089102ljg.0;
        Mon, 06 Sep 2021 19:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wag34i0mvHaNCgUONRntiQDWweufyQCEE0D3LbDF1CM=;
        b=f3xVvob51H2RgMzM9D6HraI7VM5O6sj5rUTO4Wh8Yjndw2vQNn0WTe5aWromSPNRar
         +CkU7D5XEBZPDzj5wSY3kpCawbABoLosfbMBkAOwVY/ggidIsHVt+V3JAlcrkHAlskx3
         +H/EjGARwjufW4ko3UY7SbVxE2MQ2koABzg0WRz5U5BCZ1mWRZjM5T/FlNVtqyhAsq0X
         Z1Wvc1cuzieQt6mP4eXZL1gybR7rLxfxL4RxEnUAyjLpx2tTJLY69ho2Yq8PttrYwI4+
         BDvcgp89GjT49ZWrSqXJZQ70Y8VA/Y0wvbUWxfAW0I8XT3wwo8Jk8X+D8OiysTopB5da
         9aXg==
X-Gm-Message-State: AOAM530Zx1RJuln/a3xkZCCkezC8yZGqk/wiDxujz2nchOXTSdPFrjgC
        qnZAiRjy1QA5h54H5RAkUgOHoEgedeVUIVICMJk=
X-Google-Smtp-Source: ABdhPJy+CbY2y8CERUjMXXsS7HPCNIesrefPkqW4hMG6MgUbHWAjvbCBBA4uaokAOeINMsByvcEk75LkcmFIyRocXkM=
X-Received: by 2002:a2e:90d6:: with SMTP id o22mr13297103ljg.366.1630980355363;
 Mon, 06 Sep 2021 19:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210906160310.54831-1-mailhol.vincent@wanadoo.fr> <20210906160310.54831-2-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20210906160310.54831-2-mailhol.vincent@wanadoo.fr>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Sep 2021 11:05:42 +0900
Message-ID: <CAMZ6RqK4DFOqpvarZa+ee1h0Z1GCpMMYFLzLQsbBjhKRTkgNdA@mail.gmail.com>
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

On Tue. 7 Sep 2021 at 01:03, Vincent Mailhol <mailhol.vincent@wanadoo.fr> wrote:
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

Arg... I forgot to check the return value.
+       if (!priv)
+               return -ENOMEM;

I will send a v4, sorry for the noise.


Yours sincerely,
Vincent
