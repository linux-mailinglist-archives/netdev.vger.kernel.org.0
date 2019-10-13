Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3D1D5797
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 21:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbfJMTJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 15:09:56 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44057 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbfJMTJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 15:09:56 -0400
X-Originating-IP: 209.85.222.41
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
        (Authenticated sender: pshelar@ovn.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 04518E0008
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 19:09:53 +0000 (UTC)
Received: by mail-ua1-f41.google.com with SMTP id q11so4411354uao.1
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 12:09:53 -0700 (PDT)
X-Gm-Message-State: APjAAAXvSJkrvJUbtGhStKaHflmBcV9VGqdLvRGYqC2UPeRP4mH2PSqD
        6F5pRFDNFTaEpY+rWpm+hKjH13Aem51Y7EaS45U=
X-Google-Smtp-Source: APXvYqwZ4Klipzm4gi7nKVL1rQXYT9e5A68yhBoApvF+puW8NjMtChYQe89p9kL0LfReh2HumHiGoNQYZxcmVYRdAOg=
X-Received: by 2002:ab0:6994:: with SMTP id t20mr8373510uaq.124.1570993792607;
 Sun, 13 Oct 2019 12:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <41b3fbfe3aac5ca03f4af0f1c4e146ae67c20570.1570734410.git.gnault@redhat.com>
In-Reply-To: <41b3fbfe3aac5ca03f4af0f1c4e146ae67c20570.1570734410.git.gnault@redhat.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sun, 13 Oct 2019 12:09:43 -0700
X-Gmail-Original-Message-ID: <CAOrHB_Dfoy3hiVVWu7+4fgm_U+rcB_CPuRV58XqB7kKOBcGb1w@mail.gmail.com>
Message-ID: <CAOrHB_Dfoy3hiVVWu7+4fgm_U+rcB_CPuRV58XqB7kKOBcGb1w@mail.gmail.com>
Subject: Re: [RFC PATCH net] netns: fix GFP flags in rtnl_net_notifyid()
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Jesse Gross <jesse@nicira.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 12:07 PM Guillaume Nault <gnault@redhat.com> wrote:
>
> In rtnl_net_notifyid(), we certainly can't pass a null GFP flag to
> rtnl_notify(). A GFP_KERNEL flag would be fine in most circumstances,
> but there are a few paths calling rtnl_net_notifyid() from atomic
> context or from RCU critical section. The later also precludes the use
> of gfp_any() as it wouldn't detect the RCU case. Also, the nlmsg_new()
> call is wrong too, as it uses GFP_KERNEL unconditionally.
>
> Therefore, we need to pass the GFP flags as parameter. The problem then
> propagates recursively to the callers until the proper flags can be
> determined. The problematic call chains are:
>
>  * ovs_vport_cmd_fill_info -> peernet2id_alloc -> rtnl_net_notifyid
>
>  * rtnl_fill_ifinfo -> rtnl_fill_link_netnsid -> peernet2id_alloc
>  -> rtnl_net_notifyid
>
> For openvswitch, ovs_vport_cmd_get() and ovs_vport_cmd_dump() prevent
> ovs_vport_cmd_fill_info() from using GFP_KERNEL. It'd be nice to move
> the call out of the RCU critical sections, but struct vport doesn't
> have a reference counter, so that'd probably require taking the ovs
> lock. Also, I don't get why ovs_vport_cmd_build_info() used GFP_ATOMIC
> in nlmsg_new(). I've changed it to GFP_KERNEL for consistency, as this
> functions seems to be allowed to sleep (as stated in the comment, it's
> called from a workqueue, under the protection of a mutex).
>
It is safe to change GFP flags to GFP_KERNEL in ovs_vport_cmd_build_info().
The patch looks good to me.

> For core networking, rtmsg_ifinfo_build_skb() prevents rtnl_fill_ifinfo()
> from using GFP_KERNEL. So we have to reuse rtmsg_ifinfo_build_skb()'s GFP
> flags there. Actually, the only caller preventing the use of GFP_KERNEL,
> is __dev_notify_flags() which calls rtmsg_ifinfo() with GFP_ATOMIC (see
> commit 7f29405403d7 ("net: fix rtnl notification in atomic context")).
> I'd have expected this function to be allowed to sleep, but I haven't
> dug deeper yet.
>
> Before I spend more time on this, do we have a chance to make
> ovs_vport_cmd_fill_info() and __dev_notify_flags() sleepable?
> I'd like to avoid passing GFP flags along these call chains, if at all
> possible.
>
> Found by code inspection.
>
> Fixes: 9a9634545c70 ("netns: notify netns id events")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
