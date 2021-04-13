Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D4135E2CE
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhDMPZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhDMPZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:25:35 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B9CC061574;
        Tue, 13 Apr 2021 08:25:14 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id v26so17443898iox.11;
        Tue, 13 Apr 2021 08:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iEkFvtIIJwWjPMTHPUh8pykqV8qelaf111D4c5j8NNA=;
        b=tDyWBKyI07EoQCiqVaB2z9Ker9DumbnCK3Ml9Nu4KOZE+VB1kTzB4jrnQy7qEodb62
         2bWGa7onwKSyv5dXo+nSrL5dAeJ/sgFbY3B3Ma+jmCwram13g75Ggzx4PoXXffIp51hu
         8RjIw+Q5k3sYIf8ESScjQnbP4woH9ocnQ7TR4SYQhd29A2/P7hlY8Cd3KsBxOjYDKCle
         V9JAROuG2YDeiXc95dNHXDxdkqDGUpkLbT0WJP9Oy+5MszJDRJu4ZOqC8QinGG1K5yDQ
         RkppYBe9GZw7y5DQfqHOfJsuIZjWmp6Bu/dXqImCMfNPUmUZeC/nQqReTA9z932M1G5g
         Czew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iEkFvtIIJwWjPMTHPUh8pykqV8qelaf111D4c5j8NNA=;
        b=IqgdL38yPEnLTY62Hot5VuYFSq2NvZYG+0azA/ahx1mgGD8Aj4fsQUgO8ttstDpxiw
         KLbbWXiUOWY6NBTWkIABXk6N6Dn+PnNYn9oJAo2Do7OB9+q9dkWC8mR/PuTwQjypYvSY
         yYa/YEBbw7A3ES7zhe/nciyxTnOhyuYRCM+clILjCI1WggbJc9NdDxYXQyaephT2x+Ql
         q/nywfgpa/r2O8WwgOpAfxTJL/+a3nEs1L1HlDDspkBP5eGolJiX47Pukjp6xEpdHp85
         MTePa18sbQw8Kmb4721+r93tFtRjBoDMKBMOO/3ojdP4Owsmba/qVu/hF+KixlfEA9VI
         pdjw==
X-Gm-Message-State: AOAM53079dZ+JFs3uSufuvTRwEJVGv/z+sHja7cMRR72AKbD05l21vi8
        Va1NeI6mAcJvAuzLowTxJJrojyAvA3Swmg1rmOA=
X-Google-Smtp-Source: ABdhPJzEhueFKv2yERuPNsQ9B/O4YOCvuA+I3aOzshga6AY/kS/tfVGWmW79I825q1ZwTz9OUjp1t+9anMhd1xtdWpE=
X-Received: by 2002:a6b:f909:: with SMTP id j9mr27601969iog.138.1618327513486;
 Tue, 13 Apr 2021 08:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210412101713.15161-1-kurt@linutronix.de> <20210412162846.42706d99@carbon>
In-Reply-To: <20210412162846.42706d99@carbon>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 13 Apr 2021 08:25:01 -0700
Message-ID: <CAKgT0UekqPNQxV6PzpEeis69z3e3YNcaFyot=nD7w26hLxPX2Q@mail.gmail.com>
Subject: Re: [PATCH RFC net] igb: Fix XDP with PTP enabled
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 7:29 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
>
> On Mon, 12 Apr 2021 12:17:13 +0200
> Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> > When using native XDP with the igb driver, the XDP frame data doesn't point to
> > the beginning of the packet. It's off by 16 bytes. Everything works as expected
> > with XDP skb mode.
> >
> > Actually these 16 bytes are used to store the packet timestamps. Therefore, pull
> > the timestamp before executing any XDP operations and adjust all other code
> > accordingly. The igc driver does it like that as well.
>
> (Cc. Alexander Duyck)
>
> Do we have enough room for the packet page-split tricks when these 16
> bytes are added?
>
> AFAIK this driver like ixgbe+i40e split the page in two 2048 bytes packets.
>
>  The XDP headroom is reduced to 192 bytes.
>  The skb_shared_info is 320 bytes in size.
>
> 2048-192-320 = 1536 bytes
>
>  MTU(L3) 1500
>  Ethernet (L2) headers 14 bytes
>  VLAN 4 bytes, but Q-in-Q vlan 8 bytes.
>
> Single VLAN: 1536-1500-14-4 = 18 bytes left
> Q-in-q VLAN: 1536-1500-14-8 = 14 bytes left

So the Q-in-q case should kick us over to jumbo frames since we have
to add the extra size into the final supported frame size. So the size
itself should work.

> > diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
> > index 86a576201f5f..0cbdf48285d3 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_ptp.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
> > @@ -863,23 +863,22 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
> >   * igb_ptp_rx_pktstamp - retrieve Rx per packet timestamp
> >   * @q_vector: Pointer to interrupt specific structure
> >   * @va: Pointer to address containing Rx buffer
> > - * @skb: Buffer containing timestamp and packet
> >   *
> >   * This function is meant to retrieve a timestamp from the first buffer of an
> >   * incoming frame.  The value is stored in little endian format starting on
> >   * byte 8
> >   *
> > - * Returns: 0 if success, nonzero if failure
> > + * Returns: 0 on failure, timestamp on success
> >   **/
> > -int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
> > -                     struct sk_buff *skb)
> > +ktime_t igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va)
> >  {
> >       struct igb_adapter *adapter = q_vector->adapter;
> > +     struct skb_shared_hwtstamps ts;
> >       __le64 *regval = (__le64 *)va;
> >       int adjust = 0;
> >
> >       if (!(adapter->ptp_flags & IGB_PTP_ENABLED))
> > -             return IGB_RET_PTP_DISABLED;
> > +             return 0;
> >
> >       /* The timestamp is recorded in little endian format.
> >        * DWORD: 0        1        2        3
> > @@ -888,10 +887,9 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
> >
> >       /* check reserved dwords are zero, be/le doesn't matter for zero */
> >       if (regval[0])
> > -             return IGB_RET_PTP_INVALID;
> > +             return 0;
> >

One thing that needs to be cleaned up in the patch is that if it is
going to drop these return values it should probably drop the defines
for them since I don't think they are used anywhere else.
