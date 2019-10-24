Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E92F6E2790
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 03:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389947AbfJXBGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 21:06:37 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33839 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388218AbfJXBGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 21:06:37 -0400
X-Originating-IP: 209.85.222.54
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
        (Authenticated sender: pshelar@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id EA76060005
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 01:06:34 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id n41so6648664uae.2
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 18:06:34 -0700 (PDT)
X-Gm-Message-State: APjAAAUgcrMn58a9gBQqvgdKBddv1kkcQIORr0ATTZIIFpT5eCoA90w/
        jaBS4g+xdn1Y7xs5cI9fPFvNJHYyT75E1fDhww4=
X-Google-Smtp-Source: APXvYqwudxB+DgJHyL2HCb6YaZC9mdAD1uSOPfJh0fkPdLyT+k1+bX7FlEaRFNTbisH9DtVLY0CQ6KT/Qenk+3yL0Pw=
X-Received: by 2002:ab0:6994:: with SMTP id t20mr7310199uaq.124.1571879193394;
 Wed, 23 Oct 2019 18:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <d2d9d7a0168e9c216b6755021ef4cf5b3baaf3b9.1571848485.git.gnault@redhat.com>
In-Reply-To: <d2d9d7a0168e9c216b6755021ef4cf5b3baaf3b9.1571848485.git.gnault@redhat.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 23 Oct 2019 18:06:25 -0700
X-Gmail-Original-Message-ID: <CAOrHB_ApdDHt7xdZg0kkuXSNtMPx42Yn1a1d0xgRepEXNJeLAA@mail.gmail.com>
Message-ID: <CAOrHB_ApdDHt7xdZg0kkuXSNtMPx42Yn1a1d0xgRepEXNJeLAA@mail.gmail.com>
Subject: Re: [PATCH net] netns: fix GFP flags in rtnl_net_notifyid()
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 9:39 AM Guillaume Nault <gnault@redhat.com> wrote:
>
> In rtnl_net_notifyid(), we certainly can't pass a null GFP flag to
> rtnl_notify(). A GFP_KERNEL flag would be fine in most circumstances,
> but there are a few paths calling rtnl_net_notifyid() from atomic
> context or from RCU critical sections. The later also precludes the use
> of gfp_any() as it wouldn't detect the RCU case. Also, the nlmsg_new()
> call is wrong too, as it uses GFP_KERNEL unconditionally.
>
> Therefore, we need to pass the GFP flags as parameter and propagate it
> through function calls until the proper flags can be determined.
>
> In most cases, GFP_KERNEL is fine. The exceptions are:
>   * openvswitch: ovs_vport_cmd_get() and ovs_vport_cmd_dump()
>     indirectly call rtnl_net_notifyid() from RCU critical section,
>
>   * rtnetlink: rtmsg_ifinfo_build_skb() already receives GFP flags as
>     parameter.
>
> Also, in ovs_vport_cmd_build_info(), let's change the GFP flags used
> by nlmsg_new(). The function is allowed to sleep, so better make the
> flags consistent with the ones used in the following
> ovs_vport_cmd_fill_info() call.
>
> Found by code inspection.
>
> Fixes: 9a9634545c70 ("netns: notify netns id events")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
