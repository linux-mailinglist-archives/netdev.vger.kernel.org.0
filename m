Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38F3162EB5
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgBRShO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:37:14 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44578 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgBRShN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:37:13 -0500
Received: by mail-io1-f68.google.com with SMTP id z16so23396269iod.11;
        Tue, 18 Feb 2020 10:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6LA/EHc+e6t+L6IRcGNPtyhrDj7kNqfD9AG7NcrsSIY=;
        b=ekctg0PMKqPatEN0YWNxfW/TVojwFT/Xw7GIftfux3NatRBdzA6JL2YNSwG79V8vKD
         UFw11psOsaLwBmDpMbkxywHStdyI6bR827wD7sVoCDbHc2V+SH8nTqn8u2rBcBRprmPH
         SU9n42TIwAc97+EMrUvqUmOvl4QbE9a2vCOc83T/EYnkN0XFJv9NzBDW+aeytcRtI3mz
         hB2rrPEHrade7jwj811BcUiQzn9Vdu3yhEZ1T5ecD6B8T4uRTty2cgqbYL5he+o6jy+O
         GYHxfbqWVzrlQSUUJZNR8KzNeBkY5E3BcTIjcnrcfhhJerkmN68i8YJ32/DwSAh7nAGh
         Vl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6LA/EHc+e6t+L6IRcGNPtyhrDj7kNqfD9AG7NcrsSIY=;
        b=GJCj/dxXhXtrZ/nWwmsscLqWEwpR5akvn/wJAqTBewblUoZ9lcr2ruQ9+OhemgdtAj
         Hge79t1Ujc5SRLmfdeHGeRkQnZlBjwP5J4CxGJBtpNOyCuYdUebi4NbdJHgf2mHuG+4g
         WBJ4hpnBU6VTj3+UrRq8KhUg49pDDgXAl+qe2Rjyi5kXlSIgOvIXltoQBz2rsXIW81mq
         OAqvN7DGPHIYJFpO7SjTTh3/KV9IQnbCH+taRjPfG8FYd9FS3/Aav+xOwPYBRq7Y/6vZ
         TYneyg8wQxuwCcspPGDuFX2W7N9OiwOeDpnKNa+v2km6/ttbLxZTCG1sotKW9liWGu2M
         RE9g==
X-Gm-Message-State: APjAAAX2ySILkV2s0ooxP3PvuBfM6sEwx8VXHzRKbGzrC4pcvfmbZmSj
        4hskRtrcrOAzCzTKpTxW12MnjsBSE2pkLO0SsCI=
X-Google-Smtp-Source: APXvYqwhyw0esPb3ZI68eB4xydSJJbHEThpDI7EWoOn2jZ3Agi54dpmtxRpKq28iacd4HYAP0sYnlF6/X5wTe00bIIg=
X-Received: by 2002:a6b:6205:: with SMTP id f5mr17136935iog.42.1582051032503;
 Tue, 18 Feb 2020 10:37:12 -0800 (PST)
MIME-Version: 1.0
References: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com> <02ea88e7-1a79-f779-d58c-bb1dced0b3b4@gmail.com>
In-Reply-To: <02ea88e7-1a79-f779-d58c-bb1dced0b3b4@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 18 Feb 2020 10:37:01 -0800
Message-ID: <CAKgT0UfaBpLxWQZO55-KE8QKJD9XgC2SCPAtzo=PA_MAwRxtuw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] r8169: use new helper tcp_v6_gso_csum_prep
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Timur Tabi <timur@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        linux-hyperv@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 1:42 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Simplify the code by using new helper tcp_v6_gso_csum_prep.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 26 ++---------------------
>  1 file changed, 2 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 5a9143b50..75ba10069 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4108,29 +4108,6 @@ static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp, struct sk_buff *skb)
>         return skb->len < ETH_ZLEN && tp->mac_version == RTL_GIGA_MAC_VER_34;
>  }
>
> -/* msdn_giant_send_check()
> - * According to the document of microsoft, the TCP Pseudo Header excludes the
> - * packet length for IPv6 TCP large packets.
> - */
> -static int msdn_giant_send_check(struct sk_buff *skb)
> -{
> -       const struct ipv6hdr *ipv6h;
> -       struct tcphdr *th;
> -       int ret;
> -
> -       ret = skb_cow_head(skb, 0);
> -       if (ret)
> -               return ret;
> -
> -       ipv6h = ipv6_hdr(skb);
> -       th = tcp_hdr(skb);
> -
> -       th->check = 0;
> -       th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
> -
> -       return ret;
> -}
> -
>  static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
>  {
>         u32 mss = skb_shinfo(skb)->gso_size;
> @@ -4163,9 +4140,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>                         break;
>
>                 case htons(ETH_P_IPV6):
> -                       if (msdn_giant_send_check(skb))
> +                       if (skb_cow_head(skb, 0))
>                                 return false;
>
> +                       tcp_v6_gso_csum_prep(skb, false);
>                         opts[0] |= TD1_GTSENV6;
>                         break;
>

This change looks more or less identical to the one you made in
"drivers/net/usb/r8152.c" for patch 3. If you have to resubmit it
might make sense to pull that change out and include it here since
they are both essentially the same change.
