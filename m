Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A8F277BB9
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgIXWr0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Sep 2020 18:47:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45245 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXWrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:47:25 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kLa1E-0004R6-0d; Thu, 24 Sep 2020 22:47:16 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 82A805FED0; Thu, 24 Sep 2020 15:47:14 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 7BD479FB5C;
        Thu, 24 Sep 2020 15:47:14 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     Stephen Hemminger <stephen@networkplumber.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] bonding: make Kconfig toggle to disable legacy interfaces
In-reply-to: <CAKfmpSdSube9ZPYKZTs+z4e2GjZjCsPOv2wWTzoRQQLtG2Q7NA@mail.gmail.com>
References: <20200922133731.33478-1-jarod@redhat.com> <20200922133731.33478-5-jarod@redhat.com> <20200922162459.3f0cf0a8@hermes.lan> <17374.1600818427@famine> <20200922170119.079fe32f@hermes.lan> <CAKfmpSdSube9ZPYKZTs+z4e2GjZjCsPOv2wWTzoRQQLtG2Q7NA@mail.gmail.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Wed, 23 Sep 2020 12:44:06 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14171.1600987634.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 24 Sep 2020 15:47:14 -0700
Message-ID: <14172.1600987634@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>On Tue, Sep 22, 2020 at 8:01 PM Stephen Hemminger
><stephen@networkplumber.org> wrote:
>>
>> On Tue, 22 Sep 2020 16:47:07 -0700
>> Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>>
>> > Stephen Hemminger <stephen@networkplumber.org> wrote:
>> >
>> > >On Tue, 22 Sep 2020 09:37:30 -0400
>> > >Jarod Wilson <jarod@redhat.com> wrote:
>> > >
>> > >> By default, enable retaining all user-facing API that includes the use of
>> > >> master and slave, but add a Kconfig knob that allows those that wish to
>> > >> remove it entirely do so in one shot.
>> > >>
>> > >> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>> > >> Cc: Veaceslav Falico <vfalico@gmail.com>
>> > >> Cc: Andy Gospodarek <andy@greyhouse.net>
>> > >> Cc: "David S. Miller" <davem@davemloft.net>
>> > >> Cc: Jakub Kicinski <kuba@kernel.org>
>> > >> Cc: Thomas Davis <tadavis@lbl.gov>
>> > >> Cc: netdev@vger.kernel.org
>> > >> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> > >
>> > >Why not just have a config option to remove all the /proc and sysfs options
>> > >in bonding (and bridging) and only use netlink? New tools should be only able
>> > >to use netlink only.
>> >
>> >       I agree that new tooling should be netlink, but what value is
>> > provided by such an option that distros are unlikely to enable, and
>> > enabling will break the UAPI?
>
>Do you mean the initial proposed option, or what Stephen is
>suggesting? I think Red Hat actually will consider the former, the
>latter is less likely in the immediate future, since so many people
>still rely on the output of /proc/net/bonding/* for an overall view of
>their bonds' health and status. I don't know how close we are to
>having something comparable that could be spit out with a single
>invocation of something like 'ip' that would only be using netlink.
>It's entirely possible there's something akin to 'ip link bondX
>overview' already that outputs something similar, and I'm just not
>aware of it, but something like that would definitely need to exist
>and be well-documented for Red Hat to remove the procfs bits, I think.

	At the present time, as much as the idea spurs the imagination,
removing the bonding /proc and sysfs stuff wholesale is not feasible.
As you explain, not everything in the proc file is available from other
sources.  I would rather freeze the /proc and sysfs bonding
functionality and move to a netlink / iproute API for all of it, and
then down the road remove the then-legacy APIs.

	Even though "down the road" may practically be "never" (because
the removal breaks backwards compatibility for user space), unifying all
of the configuration and reporting to one place would be worthwhile.

	For "initial proposed option," I'm not sure right off if that's
referring to CONFIG_BONDING_LEGACY_INTERFACES or "duplicate lines in
/proc/net/bonding."  I'm not sure it matters, since both have the same
problem, in that they create a Venn diagram of mutually incompatible
bonding UAPIs.  Portable user space code ends up having to handle all of
the permutations.

	-J

>> > >Then you might convince maintainers to update documentation as well.
>> > >Last I checked there were still references to ifenslave.
>> >
>> >       Distros still include ifenslave, but it's now a shell script
>> > that uses sysfs.  I see it used in scripts from time to time.
>>
>> Some bleeding edge distros have already dropped ifenslave and even ifconfig.
>> The Enterprise ones never will.
>>
>> The one motivation would be for the embedded folks which are always looking
>> to trim out the fat. Although not sure if the minimal versions of commands
>> in busybox are pure netlink yet.
>
>Yeah, the bonding documentation is still filled with references to
>ifenslave. I believe Red Hat still includes it, though it's
>"deprecated" in documentation in favor of using ip. Similar with
>ifconfig. I could see them both getting dropped in a future major
>release of Red Hat Enterprise Linux, but they're definitely still here
>for at least the life of RHEL8.

	As ifconfig is typically bundled in with the much-loved netstat
in the net-tools package, it will be difficult to remove.

	Having an /sbin/ifenslave program isn't really the issue so much
as its reliance on the bonding sysfs UAPI.  It's a shell script, and
could likely be reworked to use ip link.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
