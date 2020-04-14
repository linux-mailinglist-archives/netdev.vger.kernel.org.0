Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6114B1A78BF
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 12:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438626AbgDNKsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 06:48:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42663 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438470AbgDNKlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 06:41:50 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jOIye-0002Aq-5I; Tue, 14 Apr 2020 10:39:36 +0000
Date:   Tue, 14 Apr 2020 12:39:34 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/8] kernfs: let objects opt-in to propagating from the
 initial namespace
Message-ID: <20200414103934.ks4x45cwt7ss7v4d@wittgenstein>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-6-christian.brauner@ubuntu.com>
 <20200413190239.GG60335@mtj.duckdns.org>
 <20200413193950.tokh5m7wsyrous3c@wittgenstein>
 <20200413194550.GJ60335@mtj.duckdns.org>
 <20200413195915.yo2l657nmtkwripb@wittgenstein>
 <20200413203716.GK60335@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200413203716.GK60335@mtj.duckdns.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 04:37:16PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 13, 2020 at 09:59:15PM +0200, Christian Brauner wrote:
> > Right, pid namespaces deal with a single random identifier about which
> > userspace makes no assumptions other than that it's a positive number so
> > generating aliases is fine. In addition pid namespaces are nicely
> 
> I don't see any fundamental differences between pids and device numbers. One
> of the reasons pid namespace does aliasing instead of just showing subsets is
> because applications can have expectations on what the specific numbers should
> be - e.g. for checkpoint-restarting.

One difference is that ownership is hierarchial in a pid namespace. This
becomes clear when looking at the parent child relationship when
creating new processes in nested pid namespaces. All processes created
in the innermost pid namespace are owned by that pid namespaces's init
process. If that pid namespace's init/subreaper process dies all
processes get zapped and autoreaped. In essence, unless the ancestor pid
namespace has setns()ed a process in there, ownership of that process is
clearly defined. I don't think that model is transferable to a device.
What seems most important to me here is that a pid namespace completely
defines ownership of a process. But there's not necessarily
a single namespace that guarantees ownership for all device types.
Network devices, imho are a good example for that. Their full ownership
is network namespace + user namespace actually. You could easily
envision other device classes where a combination of namespaces would
make sense.

> 
> > hierarchical. I fear that we might introduce unneeded complexity if we
> > go this way and start generating aliases for devices that userspace
> 
> It adds complexity for sure but the other side of the scale is losing
> visiblity into what devices are on the system, which can become really nasty
> in practice, so I do think it can probably justify some additional complexity
> especially if it's something which can be used by different devices. Even just
> for block, if we end up expanding ns support to regular block devices for some
> reason, it's kinda dreadful to think a situation where all devices can't be
> discovered at the system level.

Hm, it is already the case that we can't see all devices at the system
level. That includes network devices and also binderfs devices (the
latter don't have sysfs entries though which is what this is about).
And for virtual devices just as loop, binder, and network devices this
is fine imho. They are not physicall attached to your computer. Actual
disk devices where this would matter wouldn't be namespaced anyway imho.

We also need to consider that it is potentially dangerous for a
namespace to trigger a device event tricking the host into performing an
action on it. If e.g. the creation of a network device were to propagate
into all namespaces and there'd be a rule matching it you could trick
the host into performing privileged actions it. So it also isn't
obviously safe propagating devices out of their namespace. (I fixed
something similar to this just recently in a sysfs series.)

I addition the file ownership permissions would propagate from the inner
to all outer sysfs instances as well which would mean you'd suddenly
have 100000:100000 entries in your host's sysfs in the initial
namespace.

> 
> > already knows about and has expectations of. We also still face some of
> > the other problems I mentioned.
> > I do think that what you say might make sense to explore in more detail
> > for a new device class (or type under a given class) that userspace does
> > not yet know about and were we don't regress anything.
> 
> I don't quite follow why adding namespace support would break existing users.
> Wouldn't namespace usage be opt-in?

For sysfs, this change is opt-in per device type and it only applies to
loop devices here, i.e. if you don't e.g. use loopfs nothing changes
for you at all. If you use it, all that you get is correct ownership for
sysfs entries for those loop devices accounted to you in addition to all
the other entries that have always been there. This way we can handle
legacy workloads cleanly which we really want for our use-case.

Your model would effectively require a new version of sysfs where you
e.g. mount it with a new option that zaps all device entries that don't
belong to non-initial user namespaces. Which would mean most major tools
in containers will break completely. We can still totally try to bring
up a change like this independent of this patchset. This patchset
doesn't rule this out at all.

Christian
