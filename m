Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37328162E71
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgBRSZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:25:31 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37224 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgBRSZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:25:31 -0500
Received: by mail-io1-f67.google.com with SMTP id k24so10907410ioc.4;
        Tue, 18 Feb 2020 10:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0oo2FfOUL0MjlcigokgYSuRLB0N4VOcL/NZk+nWeo40=;
        b=Wq3t2NifRRVRe6tINTW8hnfC80948jJcADE2VTky69RGcQ4+0Dd53XZ1Y1VlaNyLFa
         EfnQcbLNpv/2vZpiea2s2z9deEkxsXp14CLzj6XpJ2WOoIbvX7WKkcy/cML5KZh+VeGr
         UlwwDsF+m1vxVQRM6vLpsNGVaB3R5HIdPOYp07ciPcmBHr7rqWNT1b5v+o7BEW01IhGj
         ejEtIlBR4lNJUjBPWwg6XvzAX1AJ3XK7nsmTS0zJCx+70vGgdRlDVuN/Etqa1dj8kxDk
         Dwn6dYui17G6BrZxMFPFthQXEJ9Gj6wSKhjYFWNoMX1KEg2kWuURhzvJBT1LKgORPCFs
         zFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0oo2FfOUL0MjlcigokgYSuRLB0N4VOcL/NZk+nWeo40=;
        b=cOIvo9KpwseWMBaV0F96CfmUykbqnduIPRtTwsGDuZXgtoN3/BBHSYMh9Eliw+uatp
         vWeXT1JaMwCpvziT9S+KJVEEe0/nMX6pBq1ahFr/OVXWAHVHkDDeaI+ZgkLL+SAfW1yG
         FKi3rN/Zviwz3hl9iTRJuaWza5p5wC8L04MDnyRgrU8c/8txUtXOaPwhFLYPoIEuhxPV
         bU6DZGUqo8TmshQ0RT5oE6uC2QzySdlIRkredT2LwBL4Ddq8WNICMcChrt1l5ehrSib2
         tWL4Fx2oBOmf4hyFzBzd9MhYN2wE0zuHT7lx1BLN4AvNckiqepWV3OZjpDcNCsw2Vrzn
         eC2Q==
X-Gm-Message-State: APjAAAVIg1E0A0zvo5sOlU8D/4swM2qr9ofjYTDnjtk5Ia7PYdsSu+aU
        eSsnr+wm1HXa/3BltNlo1N4AfIBxFefvaF0dUEo=
X-Google-Smtp-Source: APXvYqwgtWgImN9QZV7JQUuv0hVUZuRkzL56C+1AttxemO7MC8eMPliv6NfqFQATOc/UbFf6Hm1OohYvw/cxkJsQ2bc=
X-Received: by 2002:a5e:860f:: with SMTP id z15mr16017999ioj.64.1582050330517;
 Tue, 18 Feb 2020 10:25:30 -0800 (PST)
MIME-Version: 1.0
References: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com> <9fdc5f0c-fdf0-122e-48a5-43ff029cf8d9@gmail.com>
In-Reply-To: <9fdc5f0c-fdf0-122e-48a5-43ff029cf8d9@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 18 Feb 2020 10:25:19 -0800
Message-ID: <CAKgT0UeUEcoKZsRnxzftMA4tc2chasmW+sWQkP11hVLbdYTYxA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: core: add helper tcp_v6_gso_csum_prep
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

On Mon, Feb 17, 2020 at 1:41 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Several network drivers for chips that support TSO6 share the same code
> for preparing the TCP header. A difference is that some reset the
> payload_len whilst others don't do this. Let's factor out this common
> code to a new helper.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  include/net/ip6_checksum.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/include/net/ip6_checksum.h b/include/net/ip6_checksum.h
> index 7bec95df4..ef0130023 100644
> --- a/include/net/ip6_checksum.h
> +++ b/include/net/ip6_checksum.h
> @@ -76,6 +76,18 @@ static inline void __tcp_v6_send_check(struct sk_buff *skb,
>         }
>  }
>
> +static inline void tcp_v6_gso_csum_prep(struct sk_buff *skb,
> +                                       bool clear_payload_len)
> +{
> +       struct ipv6hdr *ipv6h = ipv6_hdr(skb);
> +       struct tcphdr *th = tcp_hdr(skb);
> +
> +       if (clear_payload_len)
> +               ipv6h->payload_len = 0;
> +
> +       th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
> +}
> +
>  #if IS_ENABLED(CONFIG_IPV6)
>  static inline void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb)
>  {

So functionally I believe this is correct. The only piece I have a
question about is if we should just force the clear_payload_len as
always being the case since the value should either be
ignored/overwritten in any GSO case anyway.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
