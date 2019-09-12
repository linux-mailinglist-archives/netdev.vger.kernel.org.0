Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D7DB0758
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 05:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfILD4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 23:56:35 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36286 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfILD4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 23:56:35 -0400
Received: by mail-lf1-f67.google.com with SMTP id x80so18119197lff.3
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 20:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yf0lqQpUrw7O1z8BSu0TZC1bKhKxPJ4bnoPRsx9tsko=;
        b=ENZUFHy3S4Nzz0V/ZcHn1AyQg9ilKgsrM/lA/hgQJWTACropuDzAXYXwMc1nYPmxEa
         H75/khgKuea+kN6j2ZHFmWEfCafwhHue8XqmI3OtSw9TzOgkI0oZVx6NEJvIdwJhbgHv
         9FSYBIF/3xhUbN8lHugHHnxkCzQS1zIhsrpKOIyn+od3X2CBjHqMzfR4+ywwbpce7cmq
         SKNcY//bitOH+bJ/ZXbXA0RLGX2ZwiwWHE238aAH6kAMfq2du6voKGJmO2BRTHhgFi+n
         ywl3Rff+wwtkE+dtkSvyIu5iCzvuDNOt2WR7RFTUQYAHcGo8zokCiAiZ9OKogK8Eyd2G
         amDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yf0lqQpUrw7O1z8BSu0TZC1bKhKxPJ4bnoPRsx9tsko=;
        b=tsJG9oun7Uy4llVJJDFF5+vKLcJxDSH67dc3PJKT+X2yOH/Ox9E26Zj+2kI5B7zMif
         9OHXp+CIBR5/+synKw+cTo9UOE/qZV4tZjh8bas6NrAFJic4upQPeZDoJhS8mTWPoHaS
         4ABoWvCgS/IrEPE/67CDrZVCdsxWJlby8g0cHWUB4EWatAyxQz0IKLQX84mco7CysO80
         uffFAL/HB3HeWYg5y2rM4WB3MjlXYcc9HAa6IIHmRhdRziXue+NgVtj0VEWGAFJbJlkD
         e9rxqG+ceAb/L4ti9x60pz6cndteaK+saI0J6y+F7fB3qqo+HPPKEZwL2VNefxHwEQD3
         QvXg==
X-Gm-Message-State: APjAAAWj3Y3p1Qs4XX0vLV3hQCqvweQ3+zDzAO7MqJ/VsY0SshE8cyPn
        9vSmGU7jcfL2CBNqm6TYaOYE+HM8xbcGR2IGq8M=
X-Google-Smtp-Source: APXvYqyCfBYegsLFmkKaDa886fp/Ze85OLJx7Bmhb83kaiXXsVvWowY3Cldb792JnYPJ4EnQmKJAWncyOqkq8aDdXro=
X-Received: by 2002:a19:641e:: with SMTP id y30mr19742487lfb.148.1568260590773;
 Wed, 11 Sep 2019 20:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190907134532.31975-1-ap420073@gmail.com> <20190912.003209.917226424625610557.davem@davemloft.net>
In-Reply-To: <20190912.003209.917226424625610557.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 12 Sep 2019 12:56:19 +0900
Message-ID: <CAMArcTV-Qvfd7xA0huCh_dbtr7P4LA+cQ7CpnaBBhdq-tq5fZQ@mail.gmail.com>
Subject: Re: [PATCH net v2 01/11] net: core: limit nested device depth
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Sep 2019 at 07:32, David Miller <davem@davemloft.net> wrote:
>

Hi David
Thank you for the review!

> From: Taehee Yoo <ap420073@gmail.com>
> Date: Sat,  7 Sep 2019 22:45:32 +0900
>
> > Current code doesn't limit the number of nested devices.
> > Nested devices would be handled recursively and this needs huge stack
> > memory. So, unlimited nested devices could make stack overflow.
>  ...
> > Splat looks like:
> > [  140.483124] BUG: looking up invalid subclass: 8
> > [  140.483505] turning off the locking correctness validator.
>
> The limit here is not stack memory, but a limit in the lockdep
> validator, which can probably be fixed by other means.
>
> This was the feedback I saw given for the previous version of
> this series as well.

I just realized this commit message is not enough for describing the problems.
It looks like that "invalid subclass" makes panic.
But this is not.
The panic is not related to "invalid subclass" lockdep problem.

There are two splats.
1. [  140.483124] BUG: looking up invalid subclass: 8
2. [  168.446539] BUG: KASAN: slab-out-of-bounds in __unwind_start+0x71/0x850
    [  168.794493] Rebooting in 5 seconds..


The first message is just a warning message of lockdep because of too deep
lockdep subclasses and it doesn't make any problem and panic.
This message can be ignored right now because other patches of
this patchset avoids this problem using dynamic lockdep key.

The second message is a panic message.
This is stack overflow and it occurs because of too deep nested devices.
The goal of this patch is to fix this stack overflow problem.

I tested with this reproducer commands without lockdep.

    ip link add dummy0 type dummy
    ip link add link dummy0 name vlan1 type vlan id 1
    ip link set vlan1 up

    for i in {2..200}
    do
            let A=$i-1

            ip link add name vlan$i link vlan$A type vlan id $i
    done
    ip link del vlan1 <-- this command is added.

Splat looks like:
[  181.594092] Thread overran stack, or stack corrupted
[  181.594726] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  181.595417] CPU: 1 PID: 1402 Comm: ip Not tainted 5.3.0-rc7+ #173
[  181.596193] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[  181.605986] RIP: 0010:stack_depot_fetch+0x10/0x30
[  181.606588] Code: 00 75 10 48 8b 73 18 48 89 ef 5b 5d e9 59 bf 89
ff 0f 0b e8 02 3f 9d ff eb e9 89 f8 c1 ef 110
[  181.609820] RSP: 0018:ffff8880cbebedd8 EFLAGS: 00010006
[  181.610485] RAX: 00000000001fffff RBX: ffff8880cbebfc00 RCX: 0000000000000000
[  181.611394] RDX: 000000000000001d RSI: ffff8880cbebede0 RDI: 0000000000003ff0
[  181.612297] RBP: ffffea00032fae00 R08: ffffed101b5a3eab R09: ffffed101b5a3eab
[  181.613222] R10: 0000000000000001 R11: ffffed101b5a3eaa R12: ffff8880d6115e80
[  181.614148] R13: ffff8880cbebeac0 R14: ffff8880cbebfc00 R15: ffff8880cbebef80
[  181.615053] FS:  00007f46140510c0(0000) GS:ffff8880dad00000(0000)
knlGS:0000000000000000
[  181.616085] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  181.616841] CR2: ffffffffb9a7a0d8 CR3: 00000000bc356003 CR4: 00000000000606e0
[  181.635748] Call Trace:
[  181.635996] Modules linked in: 8021q garp stp mrp llc dummy veth
openvswitch nsh nf_conncount nf_nat nf_conntrs
[  181.637360] CR2: ffffffffb9a7a0d8
[  181.637670] ---[ end trace f890ce3e5c51ceb4 ]---
[  181.638096] RIP: 0010:stack_depot_fetch+0x10/0x30
[  181.638524] Code: 00 75 10 48 8b 73 18 48 89 ef 5b 5d e9 59 bf 89
ff 0f 0b e8 02 3f 9d ff eb e9 89 f8 c1 ef 110
[  181.805441] RSP: 0018:ffff8880cbebedd8 EFLAGS: 00010006
[  181.900192] RAX: 00000000001fffff RBX: ffff8880cbebfc00 RCX: 0000000000000000
[  181.901119] RDX: 000000000000001d RSI: ffff8880cbebede0 RDI: 0000000000003ff0
[  181.902038] RBP: ffffea00032fae00 R08: ffffed101b5a3eab R09: ffffed101b5a3eab
[  181.902960] R10: 0000000000000001 R11: ffffed101b5a3eaa R12: ffff8880d6115e80
[  181.903885] R13: ffff8880cbebeac0 R14: ffff8880cbebfc00 R15: ffff8880cbebef80
[  181.904825] FS:  00007f46140510c0(0000) GS:ffff8880dad00000(0000)
knlGS:0000000000000000
[  181.905862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  181.906604] CR2: ffffffffb9a7a0d8 CR3: 00000000bc356003 CR4: 00000000000606e0
[  181.907525] Kernel panic - not syncing: Fatal exception
[  181.908179] Kernel Offset: 0x34000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffff)
[  181.909176] Rebooting in 5 seconds..
