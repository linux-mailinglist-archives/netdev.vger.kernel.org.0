Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A598C3911
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389700AbfJAPaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:30:22 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42971 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389656AbfJAPaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:30:21 -0400
Received: by mail-ed1-f66.google.com with SMTP id y91so12300425ede.9
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D6rwdQuzbBcUxWZZncZROX4Ah+5TrThN6WKgdQvRsUg=;
        b=b/mSLrdTRVfqDHj/9HRQk6yODFEMhxukqsa5TEjnJ8pBk1dfaU/98Hi6hazOtWIA86
         o3h3/ZNr5K44XmOQjQItE2Cq4ntvGpkeN6wo/zE3Kp1pY6E9bezDS288HttHeyy+bmq5
         i7T2SU+VOxiWTa+n1KKCA708WbDO5DxllE7IA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D6rwdQuzbBcUxWZZncZROX4Ah+5TrThN6WKgdQvRsUg=;
        b=p1UXB83og2/K2Z5pxd/g+cyfoQToJXI/jPUbBRKw84xVWTh7UdpgK1ZpCtVsTgYA0K
         wyBDEa9j/R5KuiDE0daKcpNnKKOT35uiRilK/BZyhGk0r60U6X1wUskjSH+Iqzk32nTh
         JWAP+4xGGEgE+uqT0eKqILTYcSMLsg1OSzOFlbVhgxZjfiVyH84ga/jgJozDU0ySGr/U
         8c+ACAzm0BiFotyDVy3A9wPv0dQXAN0Ap+eX4ejn44rBllW0LY9VgXiu0ExGPbLAHac6
         JtaYbemDJ9Yhy2AUrcOCVAdRkXLXixalcaK3QatfyH1EG0RF4qjB7SSa6E3rwtN/bO+y
         ATWw==
X-Gm-Message-State: APjAAAWBBig+ZwAO4DnU7e0nlWUP1379I8RPOLojo2Evjv6SZdFqQJsA
        dennU+OTtpMSsooBBTIp29fzZ1cEr0LraNLS/SU52Ovzlgw=
X-Google-Smtp-Source: APXvYqxT03JoqR8yFbNYvQcmos/qzoG9ldT3lGu/A5dOxkFAfQOe0H0A36nW4H/RBLKLALaHHV15NkPuFkfhob5+vhI=
X-Received: by 2002:a50:95a3:: with SMTP id w32mr26171562eda.211.1569943819124;
 Tue, 01 Oct 2019 08:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <1db9d050-7ccd-0576-7710-156f22517025@fortanix.com>
In-Reply-To: <1db9d050-7ccd-0576-7710-156f22517025@fortanix.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Tue, 1 Oct 2019 08:30:08 -0700
Message-ID: <CAJieiUgo8mr6+WTiVK_nneqbTP02hJR0yomjXSgf-0K3+hV+EA@mail.gmail.com>
Subject: Re: [RFC PATCH] Don't copy mark from encapsulated packet when routing VXLAN
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Litao jiao <jiaolitao@raisecom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 29, 2019 at 11:27 PM Jethro Beekman <jethro@fortanix.com> wrote:
>
> When using rule-based routing to send traffic via VXLAN, a routing
> loop may occur. Say you have the following routing setup:
>
> ip rule add from all fwmark 0x2/0x2 lookup 2
> ip route add table 2 default via 10.244.2.0 dev vxlan1 onlink
>
> The intention is to route packets with mark 2 through VXLAN, and
> this works fine. However, the current vxlan code copies the mark
> to the encapsulated packet. Immediately after egress on the VXLAN
> interface, the encapsulated packet is routed, with no opportunity
> to mangle the encapsulated packet. The mark is copied from the
> inner packet to the outer packet, and the same routing rule and
> table shown above will apply, resulting in ELOOP.
>
> This patch simply doesn't copy the mark from the encapsulated packet.
> I don't intend this code to land as is, but I want to start a
> discussion on how to make separate routing of VXLAN inner and
> encapsulated traffic easier.

yeah, i think the patch as is will break users who use mark to
influence the underlay route lookup.
When you say the mark is copied into the packet, what exactly are you
seeing and where is the copy happening ?



>
> Signed-off-by: Jethro Beekman <jethro@fortanix.com>
> ---
>  drivers/net/vxlan.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 3d9bcc9..f9ed1b7 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -2236,7 +2236,6 @@ static struct rtable *vxlan_get_route(struct vxlan_dev *vxlan, struct net_device
>         memset(&fl4, 0, sizeof(fl4));
>         fl4.flowi4_oif = oif;
>         fl4.flowi4_tos = RT_TOS(tos);
> -       fl4.flowi4_mark = skb->mark;
>         fl4.flowi4_proto = IPPROTO_UDP;
>         fl4.daddr = daddr;
>         fl4.saddr = *saddr;
> @@ -2294,7 +2293,6 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
>         fl6.daddr = *daddr;
>         fl6.saddr = *saddr;
>         fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tos), label);
> -       fl6.flowi6_mark = skb->mark;
>         fl6.flowi6_proto = IPPROTO_UDP;
>         fl6.fl6_dport = dport;
>         fl6.fl6_sport = sport;
> --
> 2.7.4
>
>
