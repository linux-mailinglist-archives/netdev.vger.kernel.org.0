Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18461AAD4C
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389940AbfIEUr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:47:26 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41901 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731142AbfIEUrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 16:47:25 -0400
Received: by mail-ed1-f68.google.com with SMTP id z9so4177585edq.8;
        Thu, 05 Sep 2019 13:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kB2jjwTxmG739/c0X2n3JU0/QMvBG/XQ10gbX2t4+Y0=;
        b=fQ8fdCt8EW4/NlLWLwQGlzuxB9Cb0xJQpoiNZFpeo7vpr1WiyuFy52ABSmJLhHRX2m
         o9A+tnlGklM4eqRSQN3Hcb2lkRhxkBtQPUMfjcM99jrctka6tLjodmyCyZdUlCoLwTxo
         gTa8VSJXt2JUBYOCOabyyPzREEmlZnlhgrFx7fdZ1wrdRBOhehNmhoGOK+mLw3L3DR/4
         NIt6wa8pDEhChnM94cXIVZi4YTooBKMAYHRxs9hAmIiEp04Mtqnz6jIUJXfPmBHh1xWt
         xfR1K+JHkpuqvea3pXidDqDZ1GUZDJU5AzyzNPSTDSPNwxkg2hu4rb3mixSO1JlCGBDx
         9oMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kB2jjwTxmG739/c0X2n3JU0/QMvBG/XQ10gbX2t4+Y0=;
        b=d7bgdxU+0xz0AVvDGy1dF+q9V4UJoJjgID7Lm30w6Zz1t6ngIVWenPxLNUDYhWnBe4
         RekFifLywRi80Z2nv8cUxpC5vAjvltvQmPZW+a3sYDI69p9u1UyYFcIQJNd3qO16ECGr
         bkd8DXK62YP9PWeA9CDOdyfZlnv8P2t28fTZxHT4ZtrLPw8hCtxQtVBWued3/ah5m4r8
         Cnv+W7KgIukm/jriFmbEr4PIa3Vu+Zr5E/LIMFBm6ujbGmAtFZNT2g7g3y4avW3X1bta
         vA7m12ltcGQJkulNQcq8m40Rubx9HlweFmf5oamIc3K9Kv+xj3+nds4XGiAZwPXnOCeB
         Tc1g==
X-Gm-Message-State: APjAAAXXl5BC5/A044kwHNNI4Ty6sZdXoaVuckVBfd/uHYiFCXxt2kF+
        ma89UjcKXHpJXH5BkdzvtOHS3mpThdSm6myPwI5WKE9h
X-Google-Smtp-Source: APXvYqz7tCLIOTjgqv3aJAxKS0GQAQXdJfEE8ntxpKWtICMOaScSqpWOtFxjgwihZYRLoPn594HD1NCdYyCtHE7pw3I=
X-Received: by 2002:a17:906:4056:: with SMTP id y22mr4662235ejj.230.1567716444102;
 Thu, 05 Sep 2019 13:47:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190903010817.GA13595@embeddedor> <cb7d53cd-3f1e-146b-c1ab-f11a584a7224@gmail.com>
 <CA+h21hpCAJhE8xhsgDQ55_MUUiesV=uVY4tD=TzaCE6wynUPoQ@mail.gmail.com> <8736hd9ilm.fsf@intel.com>
In-Reply-To: <8736hd9ilm.fsf@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 5 Sep 2019 23:47:13 +0300
Message-ID: <CA+h21hqtuGuJm0rMx_SZAy_HCjSVD_UK1j8wa7fv+p_zUGNV7A@mail.gmail.com>
Subject: Re: [PATCH] net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Wed, 4 Sep 2019 at 00:26, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi,
>
> Vladimir Oltean <olteanv@gmail.com> writes:
>
> > Right. And while we're at it, there's still the potential
> > division-by-zero problem which I still don't know how to solve without
> > implementing a full-blown __ethtool_get_link_ksettings parser that
> > checks against all the possible outputs it can have under the "no
> > carrier" condition - see "[RFC PATCH 1/1] phylink: Set speed to
> > SPEED_UNKNOWN when there is no PHY connected" for details.
> > And there's also a third fix to be made: the netdev_dbg should be made
> > to print "speed" instead of "ecmd.base.speed".
>
> For the ksettings part I am thinking on adding something like this to
> ethtool.c. Do you think anything is missing (apart from the
> documentation)?
>
> ->
>
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 95991e43..d37c80b 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -177,6 +177,9 @@ void ethtool_convert_legacy_u32_to_link_mode(unsigned long *dst,
>  bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
>                                      const unsigned long *src);
>
> +u32 ethtool_link_ksettings_to_speed(const struct ethtool_link_ksettings *settings,
> +                                   u32 default_speed);
> +
>  /**
>   * struct ethtool_ops - optional netdev operations
>   * @get_drvinfo: Report driver/device information.  Should only set the
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index 6288e69..80e3db3 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -539,6 +539,18 @@ struct ethtool_link_usettings {
>         } link_modes;
>  };
>
> +u32 ethtool_link_ksettings_to_speed(const struct ethtool_link_ksettings *settings,
> +                                  u32 default_speed)
> +{
> +       if (settings->base.speed == SPEED_UNKNOWN)
> +               return default_speed;
> +
> +       if (settings->base.speed == 0)
> +               return default_speed;
> +
> +       return settings->base.speed;
> +}
> +
>  /* Internal kernel helper to query a device ethtool_link_settings. */
>  int __ethtool_get_link_ksettings(struct net_device *dev,
>                                  struct ethtool_link_ksettings *link_ksettings)

Looks ok to me, but I have no saying over ethtool API. Actually I
don't even know whom to ask - the output of
./scripts/get_maintainer.pl net/core/ethtool.c is a bit overwhelming.
To avoid conflicts, there needs to be somebody out of us who takes
Eric's simplification, with Gustavo's Reported-by tag, and the 2
ethtool & taprio patches to avoid division by zero, and the printing
fix, and maybe do the same in cbs. Will you be the one? Should I?

Thanks,
-Vladimir
