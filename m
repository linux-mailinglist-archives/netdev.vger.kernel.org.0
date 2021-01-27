Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C159130647C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 20:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhA0Tz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 14:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhA0Tz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 14:55:57 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3644EC061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:55:17 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id n6so3928844edt.10
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fg6HQceex7vUm5D02A3KKhVtmPSp6iJXp2z5FWsisOY=;
        b=MR1vT5F5kTzMoFBHGkn75Xaq290GmdoT8JEjmUZ18bA+F+v7ftDKnAKs9rqtzNkFJf
         Zeot/1dbHrkP56tM0QdjSlSuYWXx4oCWrLuUXzMl8tRa0hMS06l65XXvUgbwYMjUd5+r
         mn3JGvHP4ApuniSi+NHXbNE696CgwSwg50xzVf5mPatD0lwzazvSFW489i9meaqdyMam
         n8cxbLLIt/FXo+paNvpIz7XzlSSYlJW1qMUHMgvxIyKYmy6vlr9kfVMSfWpsHstbEeeV
         G6XoJDhUYAroxagBeNhZcsRAM/i4FdKVtzewq+Hc9ke7sSPGa9Z0PlswgCgpwQf9uy7u
         Ggig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fg6HQceex7vUm5D02A3KKhVtmPSp6iJXp2z5FWsisOY=;
        b=dW7tKvfHAG0e/PjUjw/GCcb60d6boqg6jD3sqTxbtwu8mdMoWakku8XthwxzIJGnJF
         n9sIu4I4ADgUcZ4HjaQCfCPEFiTCXYB+7HrgPcgL5mWoQf25JNngfwzeAU+kSxC1WONk
         kVCH6VHT1N95M5DuCqwJZ+b9YVRWcvEzELex3t+CFboxeCryLf55CDQjGk1310dJp46b
         UTliZ1tS1sd+A7iFHn5uKdFozwHV4LmrMIcHFWOkxqDdY7lhHHjKLbvAhAo0o+A+j71l
         rQNnbdwjgUgOVK5MyEjuGCpIplubFWV7YuNVqEKh/3SKU8RJT8QiNYOTw2apZmuFC/FI
         vUSg==
X-Gm-Message-State: AOAM533EG/+0MOjzOftfh6rRGEWqU8fKFghhz7d1oU90PVhdh6D5fctf
        st3qxK6WPT12Tl+K7z8e8n6FvxGW8sRTJr5Bdx4=
X-Google-Smtp-Source: ABdhPJxTAbnOtBAZ8F1SJxDO/NvwGnx1huJHLkRKQEkWkv0RGuduc4lHEVvuVp1qIA/iakIGMK2mqn7YOjqtCDkh36o=
X-Received: by 2002:a05:6402:ce:: with SMTP id i14mr10486736edu.42.1611777315939;
 Wed, 27 Jan 2021 11:55:15 -0800 (PST)
MIME-Version: 1.0
References: <c7fd197f-8ab8-2297-385e-5d2b1d5911d7@gmail.com>
 <CAF=yD-Jw6MqY+hnzFH75E4+3z5jo8dnO5G+KXpTd_vetZ6Gxwg@mail.gmail.com> <3afea922-776b-baf3-634c-9a1e84e8c4c2@gmail.com>
In-Reply-To: <3afea922-776b-baf3-634c-9a1e84e8c4c2@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 14:54:38 -0500
Message-ID: <CAF=yD-LBAVbVuaJZgpgyU16Wd1ppKquRjvfX=HbDTJABBzeo9A@mail.gmail.com>
Subject: Re: [PATCH net] r8169: work around RTL8125 UDP hw bug
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xplo.bn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 27.01.2021 19:07, Willem de Bruijn wrote:
> > On Tue, Jan 26, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> It was reported that on RTL8125 network breaks under heavy UDP load,
> >> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
> >> and provided me with a test version of the r8125 driver including a
> >> workaround. Tests confirmed that the workaround fixes the issue.
> >> I modified the original version of the workaround to meet mainline
> >> code style.
> >>
> >> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
> >>
> >> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
> >> Tested-by: xplo <xplo.bn@gmail.com>
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >> ---
> >>  drivers/net/ethernet/realtek/r8169_main.c | 64 ++++++++++++++++++++---
> >>  1 file changed, 58 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> >> index fb67d8f79..90052033b 100644
> >> --- a/drivers/net/ethernet/realtek/r8169_main.c
> >> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> >> @@ -28,6 +28,7 @@
> >>  #include <linux/bitfield.h>
> >>  #include <linux/prefetch.h>
> >>  #include <linux/ipv6.h>
> >> +#include <linux/ptp_classify.h>
> >>  #include <asm/unaligned.h>
> >>  #include <net/ip6_checksum.h>
> >>
> >> @@ -4007,17 +4008,64 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
> >>         return -EIO;
> >>  }
> >>
> >> -static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
> >> +static bool rtl_skb_is_udp(struct sk_buff *skb)
> >>  {
> >> +       switch (vlan_get_protocol(skb)) {
> >> +       case htons(ETH_P_IP):
> >> +               return ip_hdr(skb)->protocol == IPPROTO_UDP;
> >> +       case htons(ETH_P_IPV6):
> >> +               return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP;
> >
> > This trusts that an skb with given skb->protocol is well behaved. With
> > packet sockets/tun/virtio, that may be false.
> >
> >> +       default:
> >> +               return false;
> >> +       }
> >> +}
> >> +
> >> +#define RTL_MIN_PATCH_LEN      47
> >> +#define PTP_GEN_PORT           320
> >
> > Why the two PTP ports? The report is not PTP specific. Also, what does
> > patch mean in this context?
> >
> >> +
> >> +/* see rtl8125_get_patch_pad_len() in r8125 vendor driver */
> >> +static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
> >> +                                           struct sk_buff *skb)
> >> +{
> >> +       unsigned int padto = 0, len = skb->len;
> >> +
> >> +       if (rtl_is_8125(tp) && len < 175 && rtl_skb_is_udp(skb) &&
> >> +           skb_transport_header_was_set(skb)) {
> >
> > What is 175 here?
> >
> >> +               unsigned int trans_data_len = skb_tail_pointer(skb) -
> >> +                                             skb_transport_header(skb);
> >> +
> >> +               if (trans_data_len > 3 && trans_data_len < RTL_MIN_PATCH_LEN) {
> >
> > And 3 here, instead of sizeof(struct udphdr)
> >
> >> +                       u16 dest = ntohs(udp_hdr(skb)->dest);
> >> +
> >> +                       if (dest == PTP_EV_PORT || dest == PTP_GEN_PORT)
> >> +                               padto = len + RTL_MIN_PATCH_LEN - trans_data_len;
> >> +               }
> >> +
> >> +               if (trans_data_len < UDP_HLEN)
> >> +                       padto = max(padto, len + UDP_HLEN - trans_data_len);
> >> +       }
> >> +
> >> +       return padto;
> >> +}
> >> +
> >> +static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
> >> +                                          struct sk_buff *skb)
> >> +{
> >> +       unsigned int padto;
> >> +
> >> +       padto = rtl8125_quirk_udp_padto(tp, skb);
> >> +
> >>         switch (tp->mac_version) {
> >>         case RTL_GIGA_MAC_VER_34:
> >>         case RTL_GIGA_MAC_VER_60:
> >>         case RTL_GIGA_MAC_VER_61:
> >>         case RTL_GIGA_MAC_VER_63:
> >> -               return true;
> >> +               padto = max_t(unsigned int, padto, ETH_ZLEN);
> >>         default:
> >> -               return false;
> >> +               break;
> >>         }
> >> +
> >> +       return padto;
> >>  }
> >>
> >>  static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
> >> @@ -4089,9 +4137,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
> >>
> >>                 opts[1] |= transport_offset << TCPHO_SHIFT;
> >>         } else {
> >> -               if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
> >> -                       /* eth_skb_pad would free the skb on error */
> >> -                       return !__skb_put_padto(skb, ETH_ZLEN, false);
> >> +               unsigned int padto = rtl_quirk_packet_padto(tp, skb);
> >> +
> >> +               /* skb_padto would free the skb on error */
> >> +               return !__skb_put_padto(skb, padto, false);
> >>         }
> >>
> >>         return true;
> >> @@ -4268,6 +4317,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
> >>                 if (skb->len < ETH_ZLEN)
> >>                         features &= ~NETIF_F_CSUM_MASK;
> >>
> >> +               if (rtl_quirk_packet_padto(tp, skb))
> >> +                       features &= ~NETIF_F_CSUM_MASK;
> >> +
> >>                 if (transport_offset > TCPHO_MAX &&
> >>                     rtl_chip_supports_csum_v2(tp))
> >>                         features &= ~NETIF_F_CSUM_MASK;
> >> --
> >> 2.30.0
> >>
>
> The workaround was provided by Realtek, I just modified it to match
> mainline code style. For your reference I add the original version below.
> I don't know where the magic numbers come from, Realtek releases
> neither data sheets nor errata information.

Okay. I don't know what is customary for this process.

But I would address the possible out of bounds read by trusting ip
header integrity in rtl_skb_is_udp.
