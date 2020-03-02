Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E3417562B
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 09:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgCBInI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 03:43:08 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:43041 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCBInI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 03:43:08 -0500
Received: by mail-vs1-f66.google.com with SMTP id 7so5973583vsr.10
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 00:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7hv8FgIhTN+cvLspZyYI2uyLY5qUx05BBT2rH4WN6+E=;
        b=fE44hLbQOPQfaypvJEYOU91TuMWyLZ41kWqkTSIDL03Le1qfjn/vkMCrWN44WN0hgZ
         KjAP0yrU28J8DHrnl8/DldxOwytBGVqA1z5D3acxr4BXipZd6vfpY32W+nkBuw8qb95f
         +Qzp1PN5a+f9beDL2UfzIN5W21WpagxG52cLYG0UGYU9NJJBAuVR7091zpDO0Erx0ZqL
         lfErU4HpQnFKRSJU5lfUu63BcTNSImVFOmzBeaZRTcQZs3t6jJ56FgVoz/b9ZcbLBz9g
         9yius8gieX7ca76Nyk1XQ47pner4xDJH1a2bW8JEIWByWpDiyCB1e9aEAzM6QDdba3FP
         nFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7hv8FgIhTN+cvLspZyYI2uyLY5qUx05BBT2rH4WN6+E=;
        b=dSg2G/9LQfnNxWNxsGXtvHWdgbRpZHaVEIzIk9Uz+RzDgyVTFbuTiVk9pyfRnH6gOS
         crbfM/KtbyuFn1t1Tbzf5uY7exVx+17Ankr4Uc1WHRSjC2iJrV2lYFG9mi6vgU8geWGS
         h8TEwIKAreAq1y9F1/ZEdLcohmIOU6WnjTmqMRC/EehAw+P0ch2vPP4EfdI78+xtuyaQ
         LpT0UvepnUE0irWYDAtajgXRycfAabR6Y7IhBW+wjw1JLAd5DDdtdRTBSewUlXISKOUV
         VPUxvF8x7V9tFq5oq0hf4EvMp3Hmzbz9QXzzMnpo/V1hENldi5Ih92bmGPF7LhH3e+ji
         Yuxg==
X-Gm-Message-State: ANhLgQ3ac+HoNgM8Peux5yx7P+3sNWQKbFfAOKe4iR557XPTmjbny4ky
        jjge9mI70IjNpCakOnifV5eNylmEqylXGjYAJOmfDtcn
X-Google-Smtp-Source: ADFU+vuZGLXgEx+pgEJJn4jFMiR62ja9TX9WzMR0jf+IoqJ/fVtnRKXjw+UZTz1tmVu1YxtdjSdgnegUYTbu3g1IF/4=
X-Received: by 2002:a67:ec41:: with SMTP id z1mr8862520vso.197.1583138587331;
 Mon, 02 Mar 2020 00:43:07 -0800 (PST)
MIME-Version: 1.0
References: <20200228.120150.302053489768447737.davem@davemloft.net> <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
In-Reply-To: <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
From:   Yadu Kishore <kyk.segfault@gmail.com>
Date:   Mon, 2 Mar 2020 14:12:55 +0530
Message-ID: <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
Subject: Re: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
To:     David Miller <davem@davemloft.net>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

A small correction to the data I sent earlier:

Without patch :-
 ============
[Function = %cpu cycles]
skb_mac_gso_segment = 0.05
inet_gso_segment = 0.26
tcp4_gso_segment = 0.05
tcp_gso_segment = 0.17
skb_segment = 0.55
skb_copy_and_csum_bits = 0.60
do_csum = 7.43
memcpy = 3.81
__alloc_skb = 0.93
==================
SUM = 13.85

With patch :-
============
[Function = %cpu cycles]
skb_mac_gso_segment = 0.05
inet_gso_segment = 0.34
tcp4_gso_segment = 0.06
tcp_gso_segment = 0.26
skb_segment = 0.55
** skb_copy_bits = 0.62 **  <-- corrected
do_csum = 0.04
memcpy = 4.29
__alloc_skb = 0.73
==================
** SUM = 6.94 ** <-- corrected

Thanks,
Yadu Kishore

On Mon, Mar 2, 2020 at 12:22 PM Yadu Kishore <kyk.segfault@gmail.com> wrote:
>
> > > Can you contrast this against a run with your changes? The thought is
> > > that the majority of this cost is due to the memory loads and stores, not
> > > the arithmetic ops to compute the checksum. When enabling checksum
> > > offload, the same stalls will occur, but will simply be attributed to
> > > memcpy instead of to do_csum.
>
> > Agreed.
>
> Below is the data from perf with and without the patch for the same
> TCP Tx iperf run: (network driver has NETIF_F_HW_CSUM enabled)
>
> Without patch :-
> ============
> [Function = %cpu cycles]
> skb_mac_gso_segment = 0.05
> inet_gso_segment = 0.26
> tcp4_gso_segment = 0.05
> tcp_gso_segment = 0.17
> skb_segment = 0.55
> skb_copy_and_csum_bits = 0.60
> do_csum = 7.43
> memcpy = 3.81
> __alloc_skb = 0.93
> ==================
> SUM = 13.85
>
>
> With patch :-
> ============
> [Function = %cpu cycles]
> skb_mac_gso_segment = 0.05
> inet_gso_segment = 0.34
> tcp4_gso_segment = 0.06
> tcp_gso_segment = 0.26
> skb_segment = 0.55
> skb_copy_and_csum_bits = 0.00
> do_csum = 0.04
> memcpy = 4.29
> __alloc_skb = 0.73
> ==================
> SUM = 6.32
>
> So, with the patch, from the above data we can see
> that the percentage of cpu cycles spent in do_csum
> has come down from 7.43% to 0.04%.
>
> > > > Is this not already handled by __copy_skb_header above? If ip_summed
> > > > has to be initialized, so have csum_start and csum_offset. That call
> > > > should have initialized all three.
>
> > > Thanks, I will look into why even though __copy_skb_header is being
> > > called, I am still
> > > seeing skb->ip_summed set to CHECKSUM_NONE in the network driver.
>
> > Thanks.
>
> My mistake. I had removed the 'skb->ip_summed = CHECKSUM_PARTIAL' line
> from the patch but had forgotten to enable NETIF_F_HW_CSUM in the network
> driver. Hence I was still seeing skb->ip_summed set to CHECKSUM_NONE.
> After re-enabling NETIF_F_HW_CSUM in the driver, I now see that
> skb->ip_summed is being set correctly to CHECKSUM_PARTIAL.
> So as suggested, the __copy_skb_header is indeed taking care of doing
> this and hence there is no need to explicitly set 'ip_summed' in the patch.
> Below is V2 of the patch with the changes.
>
>
> Problem:
> TCP checksum in the output path is not being offloaded during GSO
> in the following case:
> The network driver does not support scatter-gather but supports
> checksum offload with NETIF_F_HW_CSUM.
>
> Cause:
> skb_segment calls skb_copy_and_csum_bits if the network driver
> does not announce NETIF_F_SG. It does not check if the driver
> supports NETIF_F_HW_CSUM.
> So for devices which might want to offload checksum but do not support SG
> there is currently no way to do so if GSO is enabled.
>
> Solution:
> In skb_segment check if the network controller does checksum and if so
> call skb_copy_bits instead of skb_copy_and_csum_bits.
>
> Testing:
> Without the patch, ran iperf TCP traffic with NETIF_F_HW_CSUM enabled
> in the network driver. Observed the TCP checksum offload is not happening
> since the skbs received by the driver in the output path have
> skb->ip_summed set to CHECKSUM_NONE.
>
> With the patch ran iperf TCP traffic and observed that TCP checksum
> is being offloaded with skb->ip_summed set to CHECKSUM_PARTIAL.
> Also tested with the patch by disabling NETIF_F_HW_CSUM in the driver
> to cover the newly introduced if-else code path in skb_segment.
>
> Link: https://lore.kernel.org/netdev/CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com
> Signed-off-by: Yadu Kishore <kyk.segfault@gmail.com>
> ---
>  net/core/skbuff.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1365a55..eca72bc 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3926,14 +3926,21 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>                         goto perform_csum_check;
>
>                 if (!sg) {
> -                       if (!nskb->remcsum_offload)
> -                               nskb->ip_summed = CHECKSUM_NONE;
> -                       SKB_GSO_CB(nskb)->csum =
> -                               skb_copy_and_csum_bits(head_skb, offset,
> -                                                      skb_put(nskb, len),
> -                                                      len, 0);
> -                       SKB_GSO_CB(nskb)->csum_start =
> -                               skb_headroom(nskb) + doffset;
> +                       if (!csum) {
> +                               if (!nskb->remcsum_offload)
> +                                       nskb->ip_summed = CHECKSUM_NONE;
> +                               SKB_GSO_CB(nskb)->csum =
> +                                       skb_copy_and_csum_bits(head_skb, offset,
> +                                                              skb_put(nskb,
> +                                                                      len),
> +                                                              len, 0);
> +                               SKB_GSO_CB(nskb)->csum_start =
> +                                       skb_headroom(nskb) + doffset;
> +                       } else {
> +                               skb_copy_bits(head_skb, offset,
> +                                             skb_put(nskb, len),
> +                                             len);
> +                       }
>                         continue;
>                 }
>
> --
> 2.7.4
>
