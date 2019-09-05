Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA97AADFD
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390886AbfIEVqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:46:13 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:50275 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389651AbfIEVqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 17:46:13 -0400
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
        (Authenticated sender: pshelar@ovn.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 8270F240004
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 21:46:11 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id z14so2659499vsz.13
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 14:46:11 -0700 (PDT)
X-Gm-Message-State: APjAAAW5bx2cKpn9HnM6vni3rtJrdOevbkIYYgvM/HK2X7s0rIrtnVv1
        Q7W232Ll+gNZd9UbjFbYNc0/ZSzQ5aMrHuIyTgE=
X-Google-Smtp-Source: APXvYqyNLk8M7tQOi36xdJ93KbukbEt25PuiOrP6ZK4Axg7RgwzjmXjY/q/wtnbjKy8hxKOjtnPw+SGwf5nVgSgGahw=
X-Received: by 2002:a67:fb1a:: with SMTP id d26mr3090648vsr.58.1567719970305;
 Thu, 05 Sep 2019 14:46:10 -0700 (PDT)
MIME-Version: 1.0
References: <1567605397-14060-1-git-send-email-paulb@mellanox.com> <1567605397-14060-2-git-send-email-paulb@mellanox.com>
In-Reply-To: <1567605397-14060-2-git-send-email-paulb@mellanox.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 5 Sep 2019 14:48:46 -0700
X-Gmail-Original-Message-ID: <CAOrHB_DewA97iO48NfKyUT0U2uFmnBsvRLk17gJP_s-xvU=P0g@mail.gmail.com>
Message-ID: <CAOrHB_DewA97iO48NfKyUT0U2uFmnBsvRLk17gJP_s-xvU=P0g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/1] net: openvswitch: Set OvS recirc_id from
 tc chain index
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 6:56 AM Paul Blakey <paulb@mellanox.com> wrote:
>
> Offloaded OvS datapath rules are translated one to one to tc rules,
> for example the following simplified OvS rule:
>
> recirc_id(0),in_port(dev1),eth_type(0x0800),ct_state(-trk) actions:ct(),recirc(2)
>
> Will be translated to the following tc rule:
>
> $ tc filter add dev dev1 ingress \
>             prio 1 chain 0 proto ip \
>                 flower tcp ct_state -trk \
>                 action ct pipe \
>                 action goto chain 2
>
> Received packets will first travel though tc, and if they aren't stolen
> by it, like in the above rule, they will continue to OvS datapath.
> Since we already did some actions (action ct in this case) which might
> modify the packets, and updated action stats, we would like to continue
> the proccessing with the correct recirc_id in OvS (here recirc_id(2))
> where we left off.
>
> To support this, introduce a new skb extension for tc, which
> will be used for translating tc chain to ovs recirc_id to
> handle these miss cases. Last tc chain index will be set
> by tc goto chain action and read by OvS datapath.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Looks good to me.

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
