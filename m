Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C3118A959
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgCRXin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:38:43 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:37095 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726647AbgCRXim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:38:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584574721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o9Wrsz8v4eUq1T/jp5tTm1SuXnBYWqPKbRf8fNcDFh0=;
        b=cUhBMK5cAB9p2hAtuQSsMvLl7pn3Wr4CyY/Ggwyr3kwB4o6oz53TOSL/9AZ87NJgB+aOHg
        bYJpRpdVg5vurgMsujePeWUY7d/oqZTdxOCCgRv0WPj5hjypRahaQPPV6JRqYUyvBxRvaD
        /f8TIg8oDgFQN/RB76kGvskIKtuqFl4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-VpUDSw9WNxK6_v0HA-Jzpg-1; Wed, 18 Mar 2020 19:38:37 -0400
X-MC-Unique: VpUDSw9WNxK6_v0HA-Jzpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C65BA107ACC7;
        Wed, 18 Mar 2020 23:38:35 +0000 (UTC)
Received: from elisabeth (unknown [10.40.208.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6B8A19756;
        Wed, 18 Mar 2020 23:38:30 +0000 (UTC)
Date:   Thu, 19 Mar 2020 00:38:23 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     ecree@solarflare.com, Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, pablo@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Marco Oliverio <marco.oliverio@tanaza.com>
Subject: Re: Bug URGENT Report with new kernel 5.5.10-5.6-rc6
Message-ID: <20200319003823.3b709ad8@elisabeth>
In-Reply-To: <CALidq=UXHz+rjiG5JxAz-CJ1mKsFLVupsH3W+z58L2nSPKE-7w@mail.gmail.com>
References: <CALidq=XsQy66n-pTMOMN=B7nEsk7BpRZnUHery5RJyjnMsiXZQ@mail.gmail.com>
        <CALidq=VVpixeJFJFkUSeDqTW=OX0+dhA04ypE=y949B+Aqaq0w@mail.gmail.com>
        <CALidq=UXHz+rjiG5JxAz-CJ1mKsFLVupsH3W+z58L2nSPKE-7w@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Adding netfilter-devel, netdev, Marco]

Martin,

On Thu, 19 Mar 2020 00:53:53 +0200
Martin Zaharinov <micron10@gmail.com> wrote:

> Back check with last kernel 5.4.26 machine work stable without crash
> Changes is comme from 5.5.x >  kernel release i see in mailin Florian
> add nf_hook_slow_list and other changes .
> But need to investigate this crash...

I just had a very quick look, I might be wrong, but can you try without:

commit 0b9173f4688dfa7c5d723426be1d979c24ce3d51
Author: Marco Oliverio <marco.oliverio@tanaza.com>
Date:   Mon Dec 2 19:54:30 2019 +0100

    netfilter: nf_queue: enqueue skbs with NULL dst

? To me it looks like we're hitting nf_queue_entry_get_br_nf_refs()
with an skb that's not supposed to end up there, and this commit might
reveal some issue in that sense.

--=20
Stefano

>=20
> Martin
>=20
> =D0=9D=D0=B0 =D1=87=D1=82, 19.03.2020 =D0=B3. =D0=B2 0:29 Martin Zaharino=
v <micron10@gmail.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0:
>=20
> >
> >
> > ---------- Forwarded message ---------
> > =D0=9E=D1=82: Martin Zaharinov <micron10@gmail.com>
> > Date: =D1=81=D1=80, 18.03.2020 =D0=B3. =D0=B2 23:31
> > Subject: Bug URGENT Report with new kernel 5.5.10-5.6-rc6
> > To: <sbrivio@redhat.com>, <pablo@netfilter.org>, Florian Westphal < =20
> > fw@strlen.de> =20
> >
> >
> > Hi all
> > Sorry i write hear not in kernel bug list i not found how to report bug
> > them.
> > Server have 300 pppoe customer connect with 400mbit/s traffic
> > When machine run and load all rules need 20-30 min and machine crash wi=
th
> > this bug for my this is old bug but in new kernel manifested immediatel=
y.
> > Please help .
> > Please check this BUG :
> >
> > Mar 17 22:26:16  [ 2344.252448][    C5] general protection fault, proba=
bly
> > for non-canonical address 0x9a830ebedfe5c683: 0000 [#1] SMP PTI
> >
> > Mar 17 22:26:16  [ 2344.253382][    C5] CPU: 5 PID: 12224 Comm: xmrig
> > Tainted: G           O      5.6.0 #1
> >
> > Mar 17 22:26:16  [ 2344.254060][    C5] Hardware name: Supermicro Super
> > Server/X11SPi-TF, BIOS 3.2 10/17/2019
> >
> > Mar 17 22:26:16  [ 2344.254773][    C5] RIP:
> > 0010:nf_queue_entry_get_refs+0x14/0xe0
> >
> > Mar 17 22:26:16  [ 2344.255279][    C5] Code: 5b c3 be 03 00 00 00 4c 89
> > c7 e8 77 b8 be ff e9 7c ff ff ff 66 90 53 48 8b 47 28 48 89 fb 48 85 c0=
 74
> > 0a 48 8b 80 80 04 00 00 <65> ff 00 48 8b 43 30 48 85 c0 74 0a 48 8b 80 =
80
> > 04 00 00 65 ff 00
> >
> > Mar 17 22:26:16  [ 2344.256950][    C5] RSP: 0000:ffffa7e44033cc50 EFLA=
GS:
> > 00010286
> >
> > Mar 17 22:26:16  [ 2344.257456][    C5] RAX: 9a837d63c011c683 RBX:
> > ffff915af771cf80 RCX: ffff915aecf23780
> >
> > Mar 17 22:26:16  [ 2344.258127][    C5] RDX: ffffffff9c82bad0 RSI:
> > 0000000000000000 RDI: ffff915af771cf80
> >
> > Mar 17 22:26:16  [ 2344.258798][    C5] RBP: ffffa7e44033cca8 R08:
> > ffffffff9d6aaac0 R09: ffff915af7ece000
> >
> > Mar 17 22:26:16  [ 2344.259469][    C5] R10: 0000000000000002 R11:
> > 0000000000000004 R12: ffff915af771cf80
> >
> > Mar 17 22:26:16  [ 2344.260140][    C5] R13: ffff915aeccee6f0 R14:
> > 0000000000000006 R15: ffffffffc03da3b0
> >
> > Mar 17 22:26:16  [ 2344.260811][    C5] FS:  00007fd1237fe700(0000)
> > GS:ffff915b1fd40000(0000) knlGS:0000000000000000
> >
> > Mar 17 22:26:16  [ 2344.261564][    C5] CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> >
> > Mar 17 22:26:16  [ 2344.276319][    C5] CR2: 00007fec73ad5cd0 CR3:
> > 00000007ff81e005 CR4: 00000000001606e0
> >
> > Mar 17 22:26:16  [ 2344.306107][    C5] DR0: 0000000000000000 DR1:
> > 0000000000000000 DR2: 0000000000000000
> >
> > Mar 17 22:26:16  [ 2344.336579][    C5] DR3: 0000000000000000 DR6:
> > 00000000fffe0ff0 DR7: 0000000000000400
> >
> > Mar 17 22:26:16  [ 2344.367000][    C5] Call Trace:
> >
> > Mar 17 22:26:16  [ 2344.381799][    C5]  <IRQ>
> >
> > Mar 17 22:26:16  [ 2344.396244][    C5]  nf_queue+0x14f/0x2d0
> >
> > Mar 17 22:26:16  [ 2344.410633][    C5]  nf_hook_slow+0x84/0xe0
> >
> > Mar 17 22:26:16  [ 2344.424672][    C5]  ip_output+0xcd/0x1b0
> >
> > Mar 17 22:26:16  [ 2344.438376][    C5]  ? ip_finish_output_gso+0x160/0=
x160
> >
> > Mar 17 22:26:16  [ 2344.452012][    C5]  __ip_queue_xmit+0x17a/0x370
> >
> > Mar 17 22:26:16  [ 2344.465466][    C5]  __tcp_transmit_skb+0x57a/0xce0
> >
> > Mar 17 22:26:16  [ 2344.478628][    C5]  ? tcp_v4_rcv+0xd5d/0xe30
> >
> > Mar 17 22:26:16  [ 2344.491600][    C5]  __tcp_retransmit_skb+0x177/0x8=
70
> >
> > Mar 17 22:26:16  [ 2344.504406][
> >   C5]  tcp_xmit_retransmit_queue.part.0+0x194/0x390
> >
> > Mar 17 22:26:16  [ 2344.517311][    C5]  tcp_pace_kick+0x161/0x180
> >
> > Mar 17 22:26:16  [ 2344.529847][    C5]  ? tcp_tasklet_func+0x1f0/0x1f0
> >
> > Mar 17 22:26:16  [ 2344.542148][    C5]  __hrtimer_run_queues+0x10b/0x1=
b0
> >
> > Mar 17 22:26:16  [ 2344.554178][    C5]  hrtimer_run_softirq+0x7f/0x170
> >
> > Mar 17 22:26:16  [ 2344.565940][    C5]  __do_softirq+0xc8/0x206
> >
> > Mar 17 22:26:16  [ 2344.577389][    C5]  irq_exit+0xda/0xf0
> >
> > Mar 17 22:26:16  [ 2344.588474][    C5]  smp_apic_timer_interrupt+0x55/=
0x80
> >
> > Mar 17 22:26:16  [ 2344.599449][    C5]  apic_timer_interrupt+0xf/0x20
> >
> > Mar 17 22:26:16  [ 2344.610107][    C5]  </IRQ>
> >
> > Mar 17 22:26:16  [ 2344.620341][    C5] RIP: 0033:0x7fd128ed01c3
> >
> > Mar 17 22:26:16  [ 2344.630378][    C5] Code: f2 25 f8 3f 00 00 f3 44 0f
> > e6 24 06 66 41 0f 5c c4 4d 0f af c4 41 8d 82 4d dd 34 ec 25 f8 3f 00 00=
 4c
> > 89 1c 06 66 41 0f 58 d0 <66> 41 0f 59 f0 49 81 c0 ff 42 83 88 49 f7 c0 =
00
> > 00 80 7f 74 d6 41
> >
> > Mar 17 22:26:16  [ 2344.660620][    C5] RSP: 002b:00007fd1237fdd78 EFLA=
GS:
> > 00000206 ORIG_RAX: ffffffffffffff13
> >
> > Mar 17 22:26:16  [ 2344.680376][    C5] RAX: 0000000000000fc0 RBX:
> > 00000000000000fe RCX: 000000003b741dc9
> >
> > Mar 17 22:26:16  [ 2344.700118][    C5] RDX: 62b3a34bbd2445be RSI:
> > 00007fd128200000 RDI: 00007fd09abec0c0
> >
> > Mar 17 22:26:16  [ 2344.720222][    C5] RBP: 1791b95bb8165a3d R08:
> > 0086c4305d0ac11c R09: cb4d89df4f950a70
> >
> > Mar 17 22:26:16  [ 2344.741734][    C5] R10: 10ce58330b1f3279 R11:
> > 0e9fac5dfa9ec7b8 R12: f4e400dfd4176ea4
> >
> > Mar 17 22:26:16  [ 2344.764623][    C5] R13: 454baf3f4a564cae R14:
> > 47331223df7be353 R15: b8ab1194f474425a
> >
> > Mar 17 22:26:16  [ 2344.788559][    C5] Modules linked in: udp_diag
> > raw_diag unix_diag af_packet_diag sch_hfsc iptable_filter iptable_mangle
> > xt_addrtype xt_nat xt_MASQUERADE iptable_nat ip_tables bpfilter  sch_fq=
_pie
> > sch_pie netconsole coretemp tg3 e1000e e1000 igb i2c_algo_bit ixgbe mdio
> > libphy i40e nf_nat_pptp nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp
> > nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6
> > nf_defrag_ipv4 pppoe pptp gre pppox ppp_mppe ppp_generic slhc libarc4 t=
un
> > hpsa scsi_transport_sas ipmi_si ipmi_devintf ipmi_msghandler  sch_fq_co=
del
> >
> > Mar 17 22:26:16  [ 2344.898031][    C5] ---[ end trace d15fca245f16372d
> > ]---
> >
> > Mar 17 22:26:16  [ 2344.912955][    C5] RIP:
> > 0010:nf_queue_entry_get_refs+0x14/0xe0
> >
> > Mar 17 22:26:17  [ 2344.928110][    C5] Code: 5b c3 be 03 00 00 00 4c 89
> > c7 e8 77 b8 be ff e9 7c ff ff ff 66 90 53 48 8b 47 28 48 89 fb 48 85 c0=
 74
> > 0a 48 8b 80 80 04 00 00 <65> ff 00 48 8b 43 30 48 85 c0 74 0a 48 8b 80 =
80
> > 04 00 00 65 ff 00
> >
> > Mar 17 22:26:17  [ 2344.974788][    C5] RSP: 0000:ffffa7e44033cc50 EFLA=
GS:
> > 00010286
> >
> > Mar 17 22:26:17  [ 2344.990738][    C5] RAX: 9a837d63c011c683 RBX:
> > ffff915af771cf80 RCX: ffff915aecf23780
> >
> > Mar 17 22:26:17  [ 2345.022183][    C5] RDX: ffffffff9c82bad0 RSI:
> > 0000000000000000 RDI: ffff915af771cf80
> >
> > Mar 17 22:26:17  [ 2345.053943][    C5] RBP: ffffa7e44033cca8 R08:
> > ffffffff9d6aaac0 R09: ffff915af7ece000
> >
> > Mar 17 22:26:17  [ 2345.085639][    C5] R10: 0000000000000002 R11:
> > 0000000000000004 R12: ffff915af771cf80
> >
> > Mar 17 22:26:17  [ 2345.117285][    C5] R13: ffff915aeccee6f0 R14:
> > 0000000000000006 R15: ffffffffc03da3b0
> >
> > Mar 17 22:26:17  [ 2345.148948][    C5] FS:  00007fd1237fe700(0000)
> > GS:ffff915b1fd40000(0000) knlGS:0000000000000000
> >
> > Mar 17 22:26:17  [ 2345.180715][    C5] CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> >
> > Mar 17 22:26:17  [ 2345.196835][    C5] CR2: 00007fec73ad5cd0 CR3:
> > 00000007ff81e005 CR4: 00000000001606e0
> >
> > Mar 17 22:26:17  [ 2345.228199][    C5] DR0: 0000000000000000 DR1:
> > 0000000000000000 DR2: 0000000000000000
> >
> > Mar 17 22:26:17  [ 2345.259580][    C5] DR3: 0000000000000000 DR6:
> > 00000000fffe0ff0 DR7: 0000000000000400
> >
> > Mar 17 22:26:17  [ 2345.290736][    C5] Kernel panic - not syncing: Fat=
al
> > exception in interrupt
> >
> > Mar 17 22:26:17  [ 2345.359056][    C5] Kernel Offset: 0x1b000000 from
> > 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfff=
ffff)
> >
> > Mar 17 22:26:17  [ 2345.389933][    C5] Rebooting in 10 seconds..
> >
> > Mar 17 22:26:27  [ 2355.405624][    C5] ACPI MEMORY or I/O RESET_REG.
> >
> >
> >
> > best Regards,
> >
> > Martin
> > =20

