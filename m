Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1593C5ADDE
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 02:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfF3Adb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 20:33:31 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:56301 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfF3Adb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 20:33:31 -0400
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
        (Authenticated sender: pshelar@ovn.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 239A4240002
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 00:33:26 +0000 (UTC)
Received: by mail-ua1-f43.google.com with SMTP id c4so3674267uad.1
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 17:33:26 -0700 (PDT)
X-Gm-Message-State: APjAAAVjnmo1PqoYa7EHz5k9UChJxWG3RmZUtt/hDTKl4dGINApPTTNT
        Y2eJHtkKPXJ+pGmy2hsVPheNPgk1p9gGyloqY+s=
X-Google-Smtp-Source: APXvYqwCP+V5F9oX4+/tUCUatdTPQjsT8iISpGlHuAHLmL2ZH1GuTNurup4rWgYxMVHHw49gM2QMgqWBKxCTWcNdTy8=
X-Received: by 2002:ab0:699a:: with SMTP id t26mr9795246uaq.70.1561854805022;
 Sat, 29 Jun 2019 17:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <1561642650-1974-1-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1561642650-1974-1-git-send-email-john.hurley@netronome.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 29 Jun 2019 17:33:18 -0700
X-Gmail-Original-Message-ID: <CAOrHB_Bo2hbu6od6ixsyiJOoJiJKFJRbUek+NeN-dgyt-grV-g@mail.gmail.com>
Message-ID: <CAOrHB_Bo2hbu6od6ixsyiJOoJiJKFJRbUek+NeN-dgyt-grV-g@mail.gmail.com>
Subject: Re: [PATCH net 1/1] net: openvswitch: fix csum updates for MPLS actions
To:     John Hurley <john.hurley@netronome.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 6:37 AM John Hurley <john.hurley@netronome.com> wrote:
>
> Skbs may have their checksum value populated by HW. If this is a checksum
> calculated over the entire packet then the CHECKSUM_COMPLETE field is
> marked. Changes to the data pointer on the skb throughout the network
> stack still try to maintain this complete csum value if it is required
> through functions such as skb_postpush_rcsum.
>
> The MPLS actions in Open vSwitch modify a CHECKSUM_COMPLETE value when
> changes are made to packet data without a push or a pull. This occurs when
> the ethertype of the MAC header is changed or when MPLS lse fields are
> modified.
>
> The modification is carried out using the csum_partial function to get the
> csum of a buffer and add it into the larger checksum. The buffer is an
> inversion of the data to be removed followed by the new data. Because the
> csum is calculated over 16 bits and these values align with 16 bits, the
> effect is the removal of the old value from the CHECKSUM_COMPLETE and
> addition of the new value.
>
> However, the csum fed into the function and the outcome of the
> calculation are also inverted. This would only make sense if it was the
> new value rather than the old that was inverted in the input buffer.
>
> Fix the issue by removing the bit inverts in the csum_partial calculation.
>
> The bug was verified and the fix tested by comparing the folded value of
> the updated CHECKSUM_COMPLETE value with the folded value of a full
> software checksum calculation (reset skb->csum to 0 and run
> skb_checksum_complete(skb)). Prior to the fix the outcomes differed but
> after they produce the same result.
>
> Fixes: 25cd9ba0abc0 ("openvswitch: Add basic MPLS support to kernel")
> Fixes: bc7cc5999fd3 ("openvswitch: update checksum in {push,pop}_mpls")
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---

Thanks for fixing it.
Acked-by: Pravin B Shelar <pshelar@ovn.org>

>  net/openvswitch/actions.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 151518d..bd13146 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -166,8 +166,7 @@ static void update_ethertype(struct sk_buff *skb, struct ethhdr *hdr,
>         if (skb->ip_summed == CHECKSUM_COMPLETE) {
>                 __be16 diff[] = { ~(hdr->h_proto), ethertype };
>
> -               skb->csum = ~csum_partial((char *)diff, sizeof(diff),
> -                                       ~skb->csum);
> +               skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
>         }
>
>         hdr->h_proto = ethertype;
> @@ -259,8 +258,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
>         if (skb->ip_summed == CHECKSUM_COMPLETE) {
>                 __be32 diff[] = { ~(stack->label_stack_entry), lse };
>
> -               skb->csum = ~csum_partial((char *)diff, sizeof(diff),
> -                                         ~skb->csum);
> +               skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
>         }
>
>         stack->label_stack_entry = lse;
> --
> 2.7.4
>
