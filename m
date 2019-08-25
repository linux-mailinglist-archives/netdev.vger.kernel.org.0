Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5990D9C4F4
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 18:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfHYQ6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 12:58:53 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:58397 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbfHYQ6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 12:58:53 -0400
X-Originating-IP: 209.85.221.178
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
        (Authenticated sender: pshelar@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 83CA860006
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 16:58:51 +0000 (UTC)
Received: by mail-vk1-f178.google.com with SMTP id b204so3475088vka.7
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 09:58:51 -0700 (PDT)
X-Gm-Message-State: APjAAAWr8rQ468y2xOcJajHo96+EUKP+U30ItMeHa9trOwgKO+CNBxlq
        L+XjfdfzPp84p1Rz7cH0aJi9IlB9MMng04E9bQQ=
X-Google-Smtp-Source: APXvYqxjNwDVVYw6ERETfkURbjdJTqSdT+IRej6Tsnefuyb0jXKTlEcTjT4sFV8z4sObkzuYicjVvxhDffFK9qoqFhI=
X-Received: by 2002:a1f:591:: with SMTP id 139mr6746540vkf.23.1566752330207;
 Sun, 25 Aug 2019 09:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190824165846.79627-1-jpettit@ovn.org> <20190824165846.79627-2-jpettit@ovn.org>
In-Reply-To: <20190824165846.79627-2-jpettit@ovn.org>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sun, 25 Aug 2019 10:00:27 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BTc4Bepc9CkNR8HBtookKRYNWeJ7sV9SpVzHA6qrz-Kg@mail.gmail.com>
Message-ID: <CAOrHB_BTc4Bepc9CkNR8HBtookKRYNWeJ7sV9SpVzHA6qrz-Kg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] openvswitch: Clear the L4 portion of the key for
 "later" fragments.
To:     Justin Pettit <jpettit@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 24, 2019 at 9:58 AM Justin Pettit <jpettit@ovn.org> wrote:
>
> Only the first fragment in a datagram contains the L4 headers.  When the
> Open vSwitch module parses a packet, it always sets the IP protocol
> field in the key, but can only set the L4 fields on the first fragment.
> The original behavior would not clear the L4 portion of the key, so
> garbage values would be sent in the key for "later" fragments.  This
> patch clears the L4 fields in that circumstance to prevent sending those
> garbage values as part of the upcall.
>
> Signed-off-by: Justin Pettit <jpettit@ovn.org>
> ---
>  net/openvswitch/flow.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> index bc89e16e0505..0fb2cec08523 100644
> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -623,6 +623,7 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
>                 offset = nh->frag_off & htons(IP_OFFSET);
>                 if (offset) {
>                         key->ip.frag = OVS_FRAG_TYPE_LATER;
> +                       memset(&key->tp, 0, sizeof(key->tp));
>                         return 0;
>                 }
>                 if (nh->frag_off & htons(IP_MF) ||
> @@ -740,8 +741,10 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
>                         return error;
>                 }
>
> -               if (key->ip.frag == OVS_FRAG_TYPE_LATER)
> +               if (key->ip.frag == OVS_FRAG_TYPE_LATER) {
> +                       memset(&key->tp, 0, sizeof(key->tp));
>                         return 0;
> +               }
>                 if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP)
>                         key->ip.frag = OVS_FRAG_TYPE_FIRST;
>

Looks good to me.

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
