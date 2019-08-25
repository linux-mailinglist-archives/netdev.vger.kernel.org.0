Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759C79C4F1
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 18:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfHYQwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 12:52:46 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45413 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbfHYQwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 12:52:46 -0400
X-Originating-IP: 209.85.217.47
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
        (Authenticated sender: pshelar@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id D84E660006
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 16:52:44 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id s5so9405892vsi.10
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 09:52:44 -0700 (PDT)
X-Gm-Message-State: APjAAAW3E5aly6Qg4rDwJOv81Iqy0nk1bt251Je0sPdo2vSzFI45pew8
        OUnMCluRHZZeTDdzYAxDiD29Cm6F72WqPusVdiI=
X-Google-Smtp-Source: APXvYqy1kpaemhL5OVVQ2hzusG8QW5cGktB7Tljz7yJ5Rl6HEGOlN1+fAQ4zD/Ne/qFdVEkQhQEPuIMs+QIGLeVaGC8=
X-Received: by 2002:a67:e24d:: with SMTP id w13mr7824757vse.58.1566751963700;
 Sun, 25 Aug 2019 09:52:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190824165846.79627-1-jpettit@ovn.org>
In-Reply-To: <20190824165846.79627-1-jpettit@ovn.org>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sun, 25 Aug 2019 09:54:47 -0700
X-Gmail-Original-Message-ID: <CAOrHB_AU1gQ74L5WawyA4THhh=MG8YZhcvkkxnKgRG+5m-436g@mail.gmail.com>
Message-ID: <CAOrHB_AU1gQ74L5WawyA4THhh=MG8YZhcvkkxnKgRG+5m-436g@mail.gmail.com>
Subject: Re: [PATCH net 1/2] openvswitch: Properly set L4 keys on "later" IP fragments.
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
> When IP fragments are reassembled before being sent to conntrack, the
> key from the last fragment is used.  Unless there are reordering
> issues, the last fragment received will not contain the L4 ports, so the
> key for the reassembled datagram won't contain them.  This patch updates
> the key once we have a reassembled datagram.
>
> Signed-off-by: Justin Pettit <jpettit@ovn.org>
> ---
>  net/openvswitch/conntrack.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 848c6eb55064..f40ad2a42086 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -524,6 +524,10 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
>                 return -EPFNOSUPPORT;
>         }
>
> +       /* The key extracted from the fragment that completed this datagram
> +        * likely didn't have an L4 header, so regenerate it. */
> +       ovs_flow_key_update(skb, key);
> +
>         key->ip.frag = OVS_FRAG_TYPE_NONE;
>         skb_clear_hash(skb);
>         skb->ignore_df = 1;
> --

Looks good to me.

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
