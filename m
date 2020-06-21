Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129B32029BA
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgFUI7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:59:05 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55759 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgFUI7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 04:59:04 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9b3343b1
        for <netdev@vger.kernel.org>;
        Sun, 21 Jun 2020 08:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :from:date:message-id:subject:to:cc:content-type; s=mail; bh=XG3
        p6gJb0WfRCbaY3qI/kWfBD3w=; b=vGfo1Q3XRw15xlh2mftJQCLsqOo2TjzI55L
        rbh/8Qx9GqDjj9qaPSo/jJfbc9BVKseKXL/2iO77u+0g932C7c2DvtiWEGx64boE
        oI686HnmMuD316e+f4zYO39DLSjLyc1T57Hk1WWEYo0LOCr9uTzdSB/txJ0zemxE
        86hkJs+fqplP2+PoDvWyoOmf0JfTdcYwiozM/OhbtkR+vFUUQoXwhmUiYrRR3rYd
        Q9PWo6ZzXs+wNWsxCUt4Dffxn9abFxZJ5+bd9q8LIh0ZKwjcu2TQuuLLuMidQXpy
        PjYlBLzcs3uQbAvTaQJelpYnSx7/YsfKW6zYpSb7mj6OhE4apOQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 61bcdf21 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sun, 21 Jun 2020 08:40:25 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id e11so13227700ilr.4
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 01:59:01 -0700 (PDT)
X-Gm-Message-State: AOAM531B3bbzW2jvr1rIznZXW+MVIq7iOxEyptYw37B0ahZbvVxJOTk4
        iAR3MbbZxzWQlryvNv9ltxNIdENXLqUN3sAC5jE=
X-Google-Smtp-Source: ABdhPJwwmdiAG5y+5n2f+XzMjp5UhksUmvnndbtVa8VeVf+KOQAY/sRUn8oCFJtSf9ppwLUWqxekeKYsVtkqCB92wvk=
X-Received: by 2002:a92:c852:: with SMTP id b18mr12047822ilq.224.1592729940595;
 Sun, 21 Jun 2020 01:59:00 -0700 (PDT)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 21 Jun 2020 02:58:49 -0600
X-Gmail-Original-Message-ID: <CAHmME9rz0JQfEBfOKkopx6yBbK_gbKVy40rh82exy1d7BZDWGw@mail.gmail.com>
Message-ID: <CAHmME9rz0JQfEBfOKkopx6yBbK_gbKVy40rh82exy1d7BZDWGw@mail.gmail.com>
Subject: missing retval check of call_netdevice_notifiers in dev_change_net_namespace
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In register_netdevice, there's a call to
call_netdevice_notifiers(NETDEV_REGISTER), whose return value is
checked to determine whether or not to roll back the device
registration. The reason checking that return value is important is
because this represents an opportunity for the various notifiers to
veto the registration, or for another error to happen. It's good that
the error value is checked when that function is called from
register_netdevice. But from other functions, the error value is not
always checked.

The notification is split up into two stages:

        ret = raw_notifier_call_chain(&net->netdev_chain, val, info);
        if (ret & NOTIFY_STOP_MASK)
                return ret;
        return raw_notifier_call_chain(&netdev_chain, val, info);

One is per-net and the other is global. So there's ample space for
something in either chain to abort the whole process.

The wireguard module uses the notifier to keep track of netns changes
in order to do some reference count bookkeeping. If this bookkeeping
goes wrong, there's UaF potential. However, I noticed that the call to
call_netdevice_notifiers(NETDEV_REGISTER) at the end of
dev_change_net_namespace doesn't check its return value and doesn't
implement any sort of rollback like register_netdevice does:

int dev_change_net_namespace(struct net_device *dev, struct net *net,
const char *pat)
{
       struct net *net_old = dev_net(dev);
       int err, new_nsid, new_ifindex;

       ASSERT_RTNL();
[...]
        /* Add the device back in the hashes */
        list_netdevice(dev);

        /* Notify protocols, that a new device appeared. */
        call_netdevice_notifiers(NETDEV_REGISTER, dev);
[...]
}

Notice that call_netdevice_notifiers isn't checking it's return value there.

It seems like if any device vetoes the notification chain, it's bad
news bears for modules that depend on getting a netns change
notification.

I've been trying to audit the various registered notifiers to see if
any of them pose a risk for wireguard. There are also unexpected
errors that can happen, such as OOM conditions for kmalloc(GFP_KERNEL)
or vmalloc and suchlike, which might be influenceable by attackers. In
other words, relying on those notifications always being delivered
seems kind of brittle. Not _super_ brittle, but brittle enough that
it's at the moment making me a bit nervous. (See: UaF potential.)

I've been trying to come up with a good solution to this.

I'm not sure how reasonable it'd be to implement rollback inside of
dev_change_net_namespace, but I guess that could technically be
possible. The way that'd work would be that when vetoed, the function
would complete, but then would start over again (a "goto top" sort of
pattern), with oldnet and newnet reversed. But that could of course
fail too and we could get ourselves in some sort of infinite loop. Not
good.

Another idea would be to have a different notifier for netns changes
(instead of overloading NETDEV_REGISTER as is the case now), whose
entire chain always gets called, where the return value is always
ignored. This seems like it'd be a bit better, and at least explicit
about its purpose. But that'd be a quasi-new thing.

Finally, it could be the solution is that modules that use the netdev
notifier never really rely too heavily upon getting notifications, and
if they need something reliable, then they rearchitect their code to
not need that. I could imagine this attitude holding sway here
somehow, but it's also not very appealing from a code writing and
refactoring perspective.

I figured before I go to town coding one of these up, maybe I should
bring up the issue here, in case anybody has more developed thoughts
than me about it.

Thanks,
Jason
