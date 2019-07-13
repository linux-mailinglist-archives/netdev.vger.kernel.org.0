Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F07E67C0F
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 23:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfGMVPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 17:15:54 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46938 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbfGMVPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 17:15:54 -0400
Received: by mail-oi1-f194.google.com with SMTP id 65so9882611oid.13;
        Sat, 13 Jul 2019 14:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eD485LN6XByAHt5KmjLCQInLrbXWW1Y7wTAhLWUZutA=;
        b=d3dHpLK9vHt3LiLTj9Vt9HWU4SNLt4Yor5/8ShJkSXiTTCVm3e/R701G8DPQgOTGES
         fw6tU0vXqJp3ML3PatDvFLaAAuEGkKSGJetcHXpAfP/7yr3s0GL5ote1WO1auwn/2odO
         ZymDIsCXUJdaoEVnaw3KN9BRXgYyfv2ezI02rlgeVm66zNlZY/Jzcx/qlGB4Rh8zcZy5
         1bsTEAzENjxXb3tVAyGUHoKhGZ77bLX7dfUePsYVaASIYWBuD9nBSonYQqMKfwSx7SMP
         PVEIEDCFsOeruOFZWzmirjvjuDZD70MgpU/7y3g7ITXObIckSF8ciPWaCNCAY2QErnI1
         otYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eD485LN6XByAHt5KmjLCQInLrbXWW1Y7wTAhLWUZutA=;
        b=mAvyVhKTr04f2f+9ggGYIMNZkTFIszlpgjTmZKil7/82NkKy9+8aETwd5bT91pq65Z
         86Pq0J2Ny5fNLJMHTpuR4ZVB6ROrpqOfXZzqfNDFmd8n25vanFr9myITvNgIckCuc8l9
         WYXlSIbz8szLBLute11ahRV69BPMbqfpPCAKephmirnqxd5DPggl47rRhm709dkx8Bdt
         QLUJshHLb8ewIyzY01QShrYf+CY60iaKIFKyi+VIFeLEFZccuZNLFGsSuuchSzzCHbBA
         61QCDJm7nmpUgK/bgws4qCH1rhNOG+ZyrcPIxj1appsyQg4XOwWoYn0U4Zvs/OgNWMte
         fSyA==
X-Gm-Message-State: APjAAAV+bckBDhqh6MWTQt9LhU6daNQgVeIgsdp6YK0NtOGI1TVdJQIa
        olGue2aGe9OYHE2PxR7HVHCQzGYsmrBq1ihTMV2Ysw==
X-Google-Smtp-Source: APXvYqwn5IGIihDZF9udiN6+gZTLwstT0fIpI9751klIARpXJ9Rt0LYnmO9ejtl/2Vj844ohnnQcvT1Ipk/maqWxws8=
X-Received: by 2002:aca:b808:: with SMTP id i8mr9211752oif.163.1563052552937;
 Sat, 13 Jul 2019 14:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190713210306.30815-1-michael-dev@fami-braun.de>
In-Reply-To: <20190713210306.30815-1-michael-dev@fami-braun.de>
From:   Laura Garcia <nevola@gmail.com>
Date:   Sat, 13 Jul 2019 23:15:41 +0200
Message-ID: <CAF90-Wh9QZbzo64UKLAN98iWGJt3hZH37a+_8_rgyYBGydz-ew@mail.gmail.com>
Subject: Re: [PATCH] Fix dumping vlan rules
To:     michael-dev@fami-braun.de
Cc:     netdev@vger.kernel.org,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing netfilter.

On Sat, Jul 13, 2019 at 11:10 PM <michael-dev@fami-braun.de> wrote:
>
> From: "M. Braun" <michael-dev@fami-braun.de>
>
> Given the following bridge rules:
> 1. ip protocol icmp accept
> 2. ether type vlan vlan type ip ip protocol icmp accept
>
> The are currently both dumped by "nft list ruleset" as
> 1. ip protocol icmp accept
> 2. ip protocol icmp accept
>
> Though, the netlink code actually is different
>
> bridge filter FORWARD 4
>   [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000001 ]
>   [ immediate reg 0 accept ]
>
> bridge filter FORWARD 5 4
>   [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000081 ]
>   [ payload load 2b @ link header + 16 => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000001 ]
>   [ immediate reg 0 accept ]
>
> Fix this by avoiding the removal of all vlan statements
> in the given example.
>
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> ---
>  src/payload.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/src/payload.c b/src/payload.c
> index 3bf1ecc..905422a 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -506,6 +506,18 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
>                      dep->left->payload.desc == &proto_ip6) &&
>                     expr->payload.base == PROTO_BASE_TRANSPORT_HDR)
>                         return false;
> +               /* Do not kill
> +                *  ether type vlan and vlan type ip and ip protocol icmp
> +                * into
> +                *  ip protocol icmp
> +                * as this lacks ether type vlan.
> +                * More generally speaking, do not kill protocol type
> +                * for stacked protocols if we only have protcol type matches.
> +                */
> +               if (dep->left->etype == EXPR_PAYLOAD && dep->op == OP_EQ &&
> +                   expr->flags & EXPR_F_PROTOCOL &&
> +                   expr->payload.base == dep->left->payload.base)
> +                       return false;
>                 break;
>         }
>
> --
> 2.20.1
>
