Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC5842DA
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 05:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfHGDSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 23:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfHGDSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 23:18:46 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5FA8217D9;
        Wed,  7 Aug 2019 03:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565147924;
        bh=r7Mvbj6hrqiafLV8SusxO33ZbDyvKYL1BupMrkg30Yk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kabPCU+1An9HwV+A8Jm72zaheN7X7720buVewfcjkNEa9xXVzFx/lVyP0tExcrj1+
         +xQHj4qDVN4zXZgNRet4ZST9lcWMx0k79FCT8ZK64GcRiiPiwRjf4dXx9CKJQaQSrt
         cYd7vwRwQFkiYTkd63+Lz1A7Cj7e0vafXcfzHfwU=
Received: by mail-wm1-f45.google.com with SMTP id s15so57075510wmj.3;
        Tue, 06 Aug 2019 20:18:43 -0700 (PDT)
X-Gm-Message-State: APjAAAUAmb6UBHx9Qvr5zvImGRsP1knrGjWpfrM1p6t8Pb6+2Ij9HWbk
        geMEHKklN/tBaTDYgPVJRIzYA/q6ZJEh847WLu0=
X-Google-Smtp-Source: APXvYqxMCsyS9G/NtKgxiz+TH7nGm56gqFNAosHmFtplp3/F0Q61wx3JwGUZu8m1dV0HkzgC93itP8qxk+atxnRrd30=
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr6951926wmj.61.1565147922025;
 Tue, 06 Aug 2019 20:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190806075325.9011-1-wens@kernel.org> <20190806131513.GB2822@t480s.localdomain>
 <CAGb2v67cZb_JKDHSb-9Tm1KnTxw5FOG3faZoQSGef_FzkdSszA@mail.gmail.com> <20190806163402.GB16656@t480s.localdomain>
In-Reply-To: <20190806163402.GB16656@t480s.localdomain>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Wed, 7 Aug 2019 11:18:28 +0800
X-Gmail-Original-Message-ID: <CAGb2v666sNV41rejf=wTJB2gYeDGAHNHn1NyxyRh3E6y9C=11A@mail.gmail.com>
Message-ID: <CAGb2v666sNV41rejf=wTJB2gYeDGAHNHn1NyxyRh3E6y9C=11A@mail.gmail.com>
Subject: Re: [PATCH net v2] net: dsa: Check existence of .port_mdb_add
 callback before calling it
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Chen-Yu Tsai <wens@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 4:34 AM Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> Hi Chen-Yu,
>
> On Wed, 7 Aug 2019 01:49:37 +0800, Chen-Yu Tsai <wens@kernel.org> wrote:
> > On Wed, Aug 7, 2019 at 1:15 AM Vivien Didelot <vivien.didelot@gmail.com> wrote:
> > >
> > > Hi Chen-Yu,
> > >
> > > On Tue,  6 Aug 2019 15:53:25 +0800, Chen-Yu Tsai <wens@kernel.org> wrote:
> > > > From: Chen-Yu Tsai <wens@csie.org>
> > > >
> > > > With the recent addition of commit 75dad2520fc3 ("net: dsa: b53: Disable
> > > > all ports on setup"), users of b53 (BCM53125 on Lamobo R1 in my case)
> > > > are forced to use the dsa subsystem to enable the switch, instead of
> > > > having it in the default transparent "forward-to-all" mode.
> > > >
> > > > The b53 driver does not support mdb bitmap functions. However the dsa
> > > > layer does not check for the existence of the .port_mdb_add callback
> > > > before actually using it. This results in a NULL pointer dereference,
> > > > as shown in the kernel oops below.
> > > >
> > > > The other functions seem to be properly guarded. Do the same for
> > > > .port_mdb_add in dsa_switch_mdb_add_bitmap() as well.
> > > >
> > > > b53 is not the only driver that doesn't support mdb bitmap functions.
> > > > Others include bcm_sf2, dsa_loop, lantiq_gswip, mt7530, mv88e6060,
> > > > qca8k, realtek-smi, and vitesse-vsc73xx.
> > >
> > > I don't know what you mean by that, there's no "mdb bitmap function"
> > > support for drivers, only the port_mdb_{prepare,add,del} callbacks...
> >
> > The term was coined from commit e6db98db8a95 ("net: dsa: add switch mdb
> > bitmap functions"). But yeah, .port_mdb_* ops/callbacks would be more
> > appropriate.
> >
> > > >     8<--- cut here ---
> > > >     Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > > >     pgd = (ptrval)
> > > >     [00000000] *pgd=00000000
> > > >     Internal error: Oops: 80000005 [#1] SMP ARM
> > > >     Modules linked in: rtl8xxxu rtl8192cu rtl_usb rtl8192c_common rtlwifi mac80211 cfg80211
> > > >     CPU: 1 PID: 134 Comm: kworker/1:2 Not tainted 5.3.0-rc1-00247-gd3519030752a #1
> > > >     Hardware name: Allwinner sun7i (A20) Family
> > > >     Workqueue: events switchdev_deferred_process_work
> > > >     PC is at 0x0
> > > >     LR is at dsa_switch_event+0x570/0x620
> > > >     pc : [<00000000>]    lr : [<c08533ec>]    psr: 80070013
> > > >     sp : ee871db8  ip : 00000000  fp : ee98d0a4
> > > >     r10: 0000000c  r9 : 00000008  r8 : ee89f710
> > > >     r7 : ee98d040  r6 : ee98d088  r5 : c0f04c48  r4 : ee98d04c
> > > >     r3 : 00000000  r2 : ee89f710  r1 : 00000008  r0 : ee98d040
> > > >     Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> > > >     Control: 10c5387d  Table: 6deb406a  DAC: 00000051
> > > >     Process kworker/1:2 (pid: 134, stack limit = 0x(ptrval))
> > > >     Stack: (0xee871db8 to 0xee872000)
> > > >     1da0:                                                       ee871e14 103ace2d
> > > >     1dc0: 00000000 ffffffff 00000000 ee871e14 00000005 00000000 c08524a0 00000000
> > > >     1de0: ffffe000 c014bdfc c0f04c48 ee871e98 c0f04c48 ee9e5000 c0851120 c014bef0
> > > >     1e00: 00000000 b643aea2 ee9b4068 c08509a8 ee2bf940 ee89f710 ee871ecb 00000000
> > > >     1e20: 00000008 103ace2d 00000000 c087e248 ee29c868 103ace2d 00000001 ffffffff
> > > >     1e40: 00000000 ee871e98 00000006 00000000 c0fb2a50 c087e2d0 ffffffff c08523c4
> > > >     1e60: ffffffff c014bdfc 00000006 c0fad2d0 ee871e98 ee89f710 00000000 c014c500
> > > >     1e80: 00000000 ee89f3c0 c0f04c48 00000000 ee9e5000 c087dfb4 ee9e5000 00000000
> > > >     1ea0: ee89f710 ee871ecb 00000001 103ace2d 00000000 c0f04c48 00000000 c087e0a8
> > > >     1ec0: 00000000 efd9a3e0 0089f3c0 103ace2d ee89f700 ee89f710 ee9e5000 00000122
> > > >     1ee0: 00000100 c087e130 ee89f700 c0fad2c8 c1003ef0 c087de4c 2e928000 c0fad2ec
> > > >     1f00: c0fad2ec ee839580 ef7a62c0 ef7a9400 00000000 c087def8 c0fad2ec c01447dc
> > > >     1f20: ef315640 ef7a62c0 00000008 ee839580 ee839594 ef7a62c0 00000008 c0f03d00
> > > >     1f40: ef7a62d8 ef7a62c0 ffffe000 c0145b84 ffffe000 c0fb2420 c0bfaa8c 00000000
> > > >     1f60: ffffe000 ee84b600 ee84b5c0 00000000 ee870000 ee839580 c0145b40 ef0e5ea4
> > > >     1f80: ee84b61c c014a6f8 00000001 ee84b5c0 c014a5b0 00000000 00000000 00000000
> > > >     1fa0: 00000000 00000000 00000000 c01010e8 00000000 00000000 00000000 00000000
> > > >     1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > > >     1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
> > > >     [<c08533ec>] (dsa_switch_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
> > > >     [<c014bdfc>] (notifier_call_chain) from [<c014bef0>] (raw_notifier_call_chain+0x18/0x20)
> > > >     [<c014bef0>] (raw_notifier_call_chain) from [<c08509a8>] (dsa_port_mdb_add+0x48/0x74)
> > > >     [<c08509a8>] (dsa_port_mdb_add) from [<c087e248>] (__switchdev_handle_port_obj_add+0x54/0xd4)
> > > >     [<c087e248>] (__switchdev_handle_port_obj_add) from [<c087e2d0>] (switchdev_handle_port_obj_add+0x8/0x14)
> > > >     [<c087e2d0>] (switchdev_handle_port_obj_add) from [<c08523c4>] (dsa_slave_switchdev_blocking_event+0x94/0xa4)
> > > >     [<c08523c4>] (dsa_slave_switchdev_blocking_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
> > > >     [<c014bdfc>] (notifier_call_chain) from [<c014c500>] (blocking_notifier_call_chain+0x50/0x68)
> > > >     [<c014c500>] (blocking_notifier_call_chain) from [<c087dfb4>] (switchdev_port_obj_notify+0x44/0xa8)
> > > >     [<c087dfb4>] (switchdev_port_obj_notify) from [<c087e0a8>] (switchdev_port_obj_add_now+0x90/0x104)
> > > >     [<c087e0a8>] (switchdev_port_obj_add_now) from [<c087e130>] (switchdev_port_obj_add_deferred+0x14/0x5c)
> > > >     [<c087e130>] (switchdev_port_obj_add_deferred) from [<c087de4c>] (switchdev_deferred_process+0x64/0x104)
> > > >     [<c087de4c>] (switchdev_deferred_process) from [<c087def8>] (switchdev_deferred_process_work+0xc/0x14)
> > > >     [<c087def8>] (switchdev_deferred_process_work) from [<c01447dc>] (process_one_work+0x218/0x50c)
> > > >     [<c01447dc>] (process_one_work) from [<c0145b84>] (worker_thread+0x44/0x5bc)
> > > >     [<c0145b84>] (worker_thread) from [<c014a6f8>] (kthread+0x148/0x150)
> > > >     [<c014a6f8>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
> > > >     Exception stack(0xee871fb0 to 0xee871ff8)
> > > >     1fa0:                                     00000000 00000000 00000000 00000000
> > > >     1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > > >     1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> > > >     Code: bad PC value
> > > >     ---[ end trace 1292c61abd17b130 ]---
> > > >
> > > >     [<c08533ec>] (dsa_switch_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
> > > >     corresponds to
> > > >
> > > >       $ arm-linux-gnueabihf-addr2line -C -i -e vmlinux c08533ec
> > > >
> > > >       linux/net/dsa/switch.c:156
> > > >       linux/net/dsa/switch.c:178
> > > >       linux/net/dsa/switch.c:328
> > > >
> > > > Fixes: e6db98db8a95 ("net: dsa: add switch mdb bitmap functions")
> > > > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > > > ---
> > > > Changes since v1:
> > > >
> > > >   - Moved the check to the beginning of dsa_switch_mdb_add()
> > > >
> > > > Looks like we could also move the ops check out of
> > > > dsa_switch_mdb_prepare_bitmap(), though I suppose keeping the code the
> > > > way it is now is clearer.
> > > >
> > > > ---
> > > >  net/dsa/switch.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> > > > index 4ec5b7f85d51..231af5268656 100644
> > > > --- a/net/dsa/switch.c
> > > > +++ b/net/dsa/switch.c
> > > > @@ -164,6 +164,9 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
> > > >       struct switchdev_trans *trans = info->trans;
> > > >       int port;
> > > >
> > > > +     if (!ds->ops->port_mdb_add)
> > > > +             return -EOPNOTSUPP;
> > > > +
> > > >       /* Build a mask of Multicast group members */
> > > >       bitmap_zero(ds->bitmap, ds->num_ports);
> > > >       if (ds->index == info->sw_index)
> > > > --
> > > > 2.20.1
> > > >
> > >
> > > I don't understand the crash here, nor the fix. dsa_switch_mdb_add()
> > > is supposed to be called through switchdev with a prepare phase,
> > > which checks for ds->ops->port_mdb_add. Do you mean that a switchdev
> > > MDB object is added somewhere without a prepare phase? If that's
> > > the case, this is what the commit message must say. Then the
> >
> > I had pretty much zero understanding of how switchdev and dsa work.
> > The symptom is a NULL pointer reference, resulting from an unsupported
> > callback that was not checked before being called, as described above.
> > And that is what I mean. A NULL pointer reference happened when it
> > should not have.
> >
> > Based on what you just mentioned, yes it does look like an object was
> > added without a prepare phase. Randomly looking through the net/dsa
> > code, it seems only dsa_port_vid_add() does a prepare phase, judging
> > by .ph_prepare being set. dsa_port_{vlan,mbd,fdb}_add directly call
> > the add phase, without the prepare phase. So I'm guessing "supposed
> > to be called with a prepare phase" is not quite accurate. This also
> > exceeds the scope of the simple fix I had in mind.
> >
> > > ds->ops->port_mdb_add check must go where it is used, that is to say
> > > at the beginning of dsa_switch_mdb_add_bitmap() (similarly to what
> > > dsa_switch_mdb_prepare_bitmap() does), not in dsa_switch_mdb_add.
> >
> > Andrew asked me to move it to where it is now. Please take a look at
> > v1 [2] if it's what you would like.
> >
> > I'm ok either way.
>
> I still cannot find in the code where a SWITCHDEV_OBJ_ID_PORT_MDB object
> gets added without a prepare phase or a trans object, but it wouldn't hurt to
> double check the presence of ds->ops->port_mdb_add before calling it anyway,
> since a patch may actually bypass this prepare phase.

I dug a bit more and I couldn't find it either. AFAICS the only place it
gets called is through the notification chain invoked in
switchdev_port_obj_add_now(),
which specifically has prepare and commit phases.

> Your v1 patch was a bit confusing and changed the signature of the function
> at the same time. Please check the callback where it is used, like this:
>
>     diff --git a/net/dsa/switch.c b/net/dsa/switch.c
>     index 4ec5b7f85d51..09d9286b27cc 100644
>     --- a/net/dsa/switch.c
>     +++ b/net/dsa/switch.c
>     @@ -153,6 +153,9 @@ static void dsa_switch_mdb_add_bitmap(struct dsa_switch *ds,
>      {
>             int port;
>
>     +       if (!ds->ops->port_mdb_add)
>     +               return;
>     +
>             for_each_set_bit(port, bitmap, ds->num_ports)
>                     ds->ops->port_mdb_add(ds, port, mdb);
>      }
>
>
> This will be easier to maintain. Please provide a simpler commit message,

OK. How about:

The dsa framework has optional .port_mdb_{prepare,add,delete} callback fields
for drivers to handle multicast database entries. When adding an entry, the
framework goes through a prepare phase, then a commit phase. Drivers not
providing these callbacks should be detected in the prepare phase.

For some unknown reason, the guard in the prepare phase is insufficient,
and the framework ends up calling an undefined .port_mdb_add callback.
This results in a NULL pointer dereference, as shown in the log below.

Add a check for .port_mdb_add before calling it in dsa_switch_mdb_add_bitmap().

<attach log>

> this one is not relevant. Are you actually able to reproduce this stack
> trace? If not, that is not necessary to add it to the commit message...

Yes I can reproduce it. Just did on a vanilla v5.3-rc3 kernel.

[   71.827837] br0: port 1(eth0.1) entered blocking state
[   71.844072] br0: port 1(eth0.1) entered disabled state
[   71.849669] device eth0.1 entered promiscuous mode
[   71.865848] device eth0 entered promiscuous mode
[   71.876535] br0: port 2(wan) entered blocking state
[   71.881475] br0: port 2(wan) entered disabled state
[   71.888631] device wan entered promiscuous mode
[   71.914341] bcm53xx stmmac-0:1e wan: configuring for phy/gmii link mode
[   71.921505] 8021q: adding VLAN 0 to HW filter on device wan
[   71.930146] bcm53xx stmmac-0:1e wan: Link is Up - 1Gbps/Full - flow
control rx/tx
[   71.932360] br0: port 3(lan1) entered blocking state
[   71.942751] br0: port 3(lan1) entered disabled state
[   71.950128] device lan1 entered promiscuous mode
[   71.970024] bcm53xx stmmac-0:1e lan1: configuring for phy/gmii link mode
[   71.977157] 8021q: adding VLAN 0 to HW filter on device lan1
[   71.988159] br0: port 4(lan2) entered blocking state
[   71.993158] br0: port 4(lan2) entered disabled state
[   72.001235] device lan2 entered promiscuous mode
[   72.020994] bcm53xx stmmac-0:1e lan2: configuring for phy/gmii link mode
[   72.028081] 8021q: adding VLAN 0 to HW filter on device lan2
[   72.035797] bcm53xx stmmac-0:1e lan2: Link is Up - 1Gbps/Full -
flow control rx/tx
[   72.038767] br0: port 5(lan3) entered blocking state
[   72.048450] br0: port 5(lan3) entered disabled state
[   72.057129] device lan3 entered promiscuous mode
[   72.076956] bcm53xx stmmac-0:1e lan3: configuring for phy/gmii link mode
[   72.084004] 8021q: adding VLAN 0 to HW filter on device lan3
[   72.091352] bcm53xx stmmac-0:1e lan3: Link is Up - 1Gbps/Full -
flow control rx/tx
[   72.095168] br0: port 6(lan4) entered blocking state
[   72.103926] br0: port 6(lan4) entered disabled state
[   72.113313] device lan4 entered promiscuous mode
[   72.133293] bcm53xx stmmac-0:1e lan4: configuring for phy/gmii link mode
[   72.140410] 8021q: adding VLAN 0 to HW filter on device lan4
[   72.147682] bcm53xx stmmac-0:1e lan4: Link is Up - 100Mbps/Full -
flow control rx/tx
[   72.155915] br0: port 6(lan4) entered blocking state
[   72.160905] br0: port 6(lan4) entered forwarding state
[   72.166135] br0: port 5(lan3) entered blocking state
[   72.171111] br0: port 5(lan3) entered forwarding state
[   72.176300] br0: port 4(lan2) entered blocking state
[   72.181277] br0: port 4(lan2) entered forwarding state
[   72.186472] br0: port 2(wan) entered blocking state
[   72.191361] br0: port 2(wan) entered forwarding state
[   72.196453] br0: port 1(eth0.1) entered blocking state
[   72.201601] br0: port 1(eth0.1) entered forwarding state

Waiting for br0 to get ready (MAXWAIT is 32 seconds).
[   72.244956] 8<--- cut here ---
[   72.248072] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   72.256331] pgd = (ptrval)
[   72.259048] [00000000] *pgd=00000000
[   72.262642] Internal error: Oops: 80000005 [#1] SMP ARM
[   72.267869] Modules linked in:
[   72.270934] CPU: 1 PID: 134 Comm: kworker/1:2 Not tainted 5.3.0-rc3 #1
[   72.277458] Hardware name: Allwinner sun7i (A20) Family
[   72.282699] Workqueue: events switchdev_deferred_process_work
[   72.288447] PC is at 0x0
[   72.290988] LR is at dsa_switch_event+0x570/0x620
[   72.295691] pc : [<00000000>]    lr : [<c0853890>]    psr: 80070113
[   72.301955] sp : ef3cfdb8  ip : 00000000  fp : ef0ad0a4
[   72.307180] r10: 0000000c  r9 : 00000008  r8 : eeb3b450
[   72.312405] r7 : ef0ad040  r6 : ef0ad088  r5 : c0f04c48  r4 : ef0ad04c
[   72.318931] r3 : 00000000  r2 : eeb3b450  r1 : 00000008  r0 : ef0ad040
[   72.325459] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   72.332593] Control: 10c5387d  Table: 6de6406a  DAC: 00000051
[   72.338340] Process kworker/1:2 (pid: 134, stack limit = 0x(ptrval))
[   72.344692] Stack: (0xef3cfdb8 to 0xef3d0000)
[   72.349085] fda0:
    ef3cfe14 46893f30
[   72.357329] fdc0: 00000000 ffffffff 00000000 ef3cfe14 00000005
00000000 c0852944 00000000
[   72.365550] fde0: ffffe000 c014be24 c0f04c48 ef3cfe98 c0f04c48
ee9ea800 c08515d8 c014bf18
[   72.373739] fe00: 00000000 63a7c876 ee9b0068 c0850e60 ef26e800
eeb3b450 ef3cfecb 00000000
[   72.381921] fe20: 00000008 46893f30 00000000 c087e718 eebe2068
46893f30 c0e72400 ffffffff
[   72.390102] fe40: 00000000 ef3cfe98 00000006 00000000 c0fb2a50
c087e7a0 ffffffff c0852868
[   72.398283] fe60: ffffffff c014be24 00000006 c0fad2d0 ef3cfe98
eeb3b450 00000000 c014c528
[   72.406463] fe80: 00000000 c015dcf8 c0f04c48 00000000 ee9ea800
c087e484 ee9ea800 00000000
[   72.414644] fea0: eeb3b450 ef3cfecb 00000001 46893f30 00000000
c0f04c48 00000000 c087e578
[   72.422825] fec0: 00000000 ef26e780 00024400 46893f30 eeb3b440
eeb3b450 ee9ea800 00000122
[   72.430998] fee0: 00000100 c087e600 eeb3b440 c0fad2c8 c1003ef0
c087e31c 2e928000 c0fad2ec
[   72.439179] ff00: c0fad2ec ee858080 ef7a62c0 ef7a9400 00000000
c087e3c8 c0fad2ec c0144804
[   72.447360] ff20: ef312280 ef7a62c0 00000008 ee858080 ee858094
ef7a62c0 00000008 c0f03d00
[   72.455541] ff40: ef7a62d8 ef7a62c0 ffffe000 c0145bac ffffe000
c0fb2420 c0bfa1ec 00000000
[   72.463721] ff60: ffffe000 ee855c40 ee855c00 00000000 ef3ce000
ee858080 c0145b68 ef0e5ea4
[   72.471902] ff80: ee855c5c c014a720 0000000b ee855c00 c014a5d8
00000000 00000000 00000000
[   72.480082] ffa0: 00000000 00000000 00000000 c01010e8 00000000
00000000 00000000 00000000
[   72.488262] ffc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   72.496442] ffe0: 00000000 00000000 00000000 00000000 00000013
00000000 00000000 00000000
[   72.504652] [<c0853890>] (dsa_switch_event) from [<c014be24>]
(notifier_call_chain+0x48/0x84)
[   72.513184] [<c014be24>] (notifier_call_chain) from [<c014bf18>]
(raw_notifier_call_chain+0x18/0x20)
[   72.522321] [<c014bf18>] (raw_notifier_call_chain) from
[<c0850e60>] (dsa_port_mdb_add+0x48/0x74)
[   72.531200] [<c0850e60>] (dsa_port_mdb_add) from [<c087e718>]
(__switchdev_handle_port_obj_add+0x54/0xd4)
[   72.540773] [<c087e718>] (__switchdev_handle_port_obj_add) from
[<c087e7a0>] (switchdev_handle_port_obj_add+0x8/0x14)
[   72.551385] [<c087e7a0>] (switchdev_handle_port_obj_add) from
[<c0852868>] (dsa_slave_switchdev_blocking_event+0x94/0xa4)
[   72.562343] [<c0852868>] (dsa_slave_switchdev_blocking_event) from
[<c014be24>] (notifier_call_chain+0x48/0x84)
[   72.572434] [<c014be24>] (notifier_call_chain) from [<c014c528>]
(blocking_notifier_call_chain+0x50/0x68)
[   72.582004] [<c014c528>] (blocking_notifier_call_chain) from
[<c087e484>] (switchdev_port_obj_notify+0x44/0xa8)
[   72.592094] [<c087e484>] (switchdev_port_obj_notify) from
[<c087e578>] (switchdev_port_obj_add_now+0x90/0x104)
[   72.602098] [<c087e578>] (switchdev_port_obj_add_now) from
[<c087e600>] (switchdev_port_obj_add_deferred+0x14/0x5c)
[   72.612537] [<c087e600>] (switchdev_port_obj_add_deferred) from
[<c087e31c>] (switchdev_deferred_process+0x64/0x104)
[   72.623060] [<c087e31c>] (switchdev_deferred_process) from
[<c087e3c8>] (switchdev_deferred_process_work+0xc/0x14)
[   72.633412] [<c087e3c8>] (switchdev_deferred_process_work) from
[<c0144804>] (process_one_work+0x218/0x50c)
[   72.643156] [<c0144804>] (process_one_work) from [<c0145bac>]
(worker_thread+0x44/0x5bc)
[   72.651253] [<c0145bac>] (worker_thread) from [<c014a720>]
(kthread+0x148/0x150)
[   72.658657] [<c014a720>] (kthread) from [<c01010e8>]
(ret_from_fork+0x14/0x2c)
[   72.665879] Exception stack(0xef3cffb0 to 0xef3cfff8)
[   72.670932] ffa0:                                     00000000
00000000 00000000 00000000
[   72.679112] ffc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   72.687291] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   72.693911] Code: bad PC value
[   72.697022] ---[ end trace c7626868564873c8 ]---


ChenYu
