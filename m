Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212A943F95C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 11:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhJ2JG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 05:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229844AbhJ2JG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 05:06:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C7BE61175;
        Fri, 29 Oct 2021 09:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635498269;
        bh=G484l9NNOoLQKLo2LATY2EMB0XNVbELUoR41W2Hz3yU=;
        h=In-Reply-To:References:Cc:To:From:Subject:Date:From;
        b=d+0VMwTVFNm+LZnyxrQ89c2X/mcVpde9ZD6ze0zz3KU8y/UvBJrUVbevZvU7dp5Vu
         1sZzYsd8Yoj3VrLiXCDaq0t27qcEJ+2mYmTJ5BL1B2sdH2az8sqN/+1zZvNlgQTLv9
         eNV6oq3kuUV2Qf1pokgmMPPxIqzkEjutsii+WgBrUfgZCFCQDQDaeiZF6wJVpvOMZp
         sBpWJouwUL9lD37b7fz0fXde3yYZXK1xbSKfifgFPULeK8VOVDlGDpHedaxTR8gErS
         7O+Mvmy8OTPlYkS5FKDIaS3dN3oG7SMuT/98f2tinTbU7A0hkSBokLOvvAewveRffr
         p2vwhFwqTtXmg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <163293671647.3047.7240482794798716272@kwain>
References: <20210928125500.167943-1-atenart@kernel.org> <20210928125500.167943-9-atenart@kernel.org> <20210928170229.4c1431c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <163290399584.3047.8100336131824633098@kwain> <20210929063126.4a702dbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <163293671647.3047.7240482794798716272@kwain>
Cc:     davem@davemloft.net, pabeni@redhat.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, stephen@networkplumber.org,
        herbert@gondor.apana.org.au, juri.lelli@redhat.com,
        netdev@vger.kernel.org, mhocko@suse.com
To:     Jakub Kicinski <kuba@kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [RFC PATCH net-next 8/9] net: delay device_del until run_todo
Message-ID: <163549826664.3523.4140191764737040064@kwain>
Date:   Fri, 29 Oct 2021 11:04:26 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Antoine Tenart (2021-09-29 19:31:56)
> Quoting Jakub Kicinski (2021-09-29 15:31:26)
> > On Wed, 29 Sep 2021 10:26:35 +0200 Antoine Tenart wrote:
>=20
> > > (While I did ran stress tests reading/writing attributes while
> > > unregistering devices, I think I missed an issue with the
> > > netdev_queue_default attributes; which hopefully can be fixed =E2=80=
=94 if the
> > > whole idea is deemed acceptable).
>=20
> I had a quick look about queue attributes, their removal should also be
> done in run_todo (that's easy). However the queues can be updated in
> flight (while holding the rtnl lock) and the error paths[1][2] do drain
> sysfs files (in kobject_put).
>=20
> We can't release the rtnl lock here. It should be possible to delay this
> outside the rtnl lock (in the global workqueue) but as the kobject are
> embedded in the queues, we might need to have them live outside to allow
> async releases while a net device (and ->_rx/->_tx) is being freed[3].
> That adds to the complexity...
>=20
> [1] https://elixir.bootlin.com/linux/latest/source/net/core/net-sysfs.c#L=
1662
> [2] https://elixir.bootlin.com/linux/latest/source/net/core/net-sysfs.c#L=
1067
> [3] Or having a dedicated workqueue and draining it.

I got back to this and while all other suggestions where easy enough to
get right, handling the queue sysfs files was not... The explanation is
the same for Tx and Rx queues.

Sysfs queue files are special: in addition to being created at device
registration and removed at unregistration, they also can be
reconfigured (added & removed) in-flight. This is done under the rtnl
lock. So for those sysfs files the trylock/restart construction also
helps in not hitting a deadlock while removing queues in-flight.

To make this work here, I had to delay the queue removal outside the
rtnl lock. As the queues are statically allocated in net_device->_tx, I
made them dynamically allocated to allow delaying their removal outside
the rtnl lock (in a workqueue for example).

This worked for allowing the removal of queues not to hit the ABBA
deadlock. (Extra logic to drain the queues before device removal might
be needed too). But this introduced an issue as naming collision between
queues was now possible (if we tried registering new queues while old
ones weren't unregistered yet). This is because the unregistration was
delayed, and for this to work the reconfiguration of queues should be
atomic under the rtnl lock; which is exactly what the changes to not hit
the ABBA deadlock requires... There are contradicting goals here.

This is not really fixable IMHO. First we would need to add a naming
collision logic for queues only, but then we don't have the same
two-step unregistration logic as we have for net devices. And failing on
queues reconfigurations for this doesn't seem acceptable to me (this has
a lot of implications, many "users" can request queues registration &
unregistration). Plus the complexity starts to be quite noticeable,
which doesn't help maintenance.

The above looks like a dead end to me. I tried several approaches to
better handle the queues in sysfs, but couldn't find a solution not
hitting an issue one way or another.

I have however a few other ideas, that may or may not be acceptable.
I'll start a dedicated answer to this thread to discuss those.

Thanks,
Antoine
