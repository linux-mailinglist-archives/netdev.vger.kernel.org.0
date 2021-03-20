Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D386C342C05
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 12:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhCTLT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 07:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhCTLTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 07:19:32 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4119C0613EF
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 03:30:22 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id a1so14974465ljp.2
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 03:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=eTAF8VR3Y4ZILOnWgiIi8nrAZ5LxzQjT21sbl7ijIlo=;
        b=vEkJ3AMWBeKCuyIOPMXXHnVZA+U9qrJYIGukI66IYdyqqPai0HFRSRu9loozFWKgR/
         Y1eIBIq5NCKwIkBkjgNbN0DVf8QhoLtkXcY+snUy+CvlFcMbod06i53TM19094jW5G+N
         ptsWxMa5O4fcnQ+o26pJy3buT6ikrC+wkgYiecuQ1NmdPLm0DBHQdZVFPFlJzzmfbHUO
         VFfaOJ5S14b7FlxQ7GZDBzXYujJxyXOgd1JmJ693Ug0p9EkFyuW5pydRAYJB014x3oMr
         6NqKEXhSPhv1SQAlgWgBzis1rTMaMinUqxY5L447miw2rBczGrScOg+0o2Bc82ZPUTCU
         bVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=eTAF8VR3Y4ZILOnWgiIi8nrAZ5LxzQjT21sbl7ijIlo=;
        b=ZuMq84GJb2vy3iUN9IUuqyIdw5pA3VfFvEZ0vSWTmwRKrtVGGFoVQi8fu0UPdA/rA8
         I+7dUJlMN/W1/Dfyk9ZAGMJhzXuS5HAiUYSQasnaLLKBHgSM9/K63fu3VngxBPIJ9fOl
         BRbEogH1QbZ/jQsUQI+z4WAOsuPnLhv5OvNEJhZ4PvZ6ltxp5wp9Y26/o3jF+jQ+5Mu2
         34293C46yQfWJyv3Oy+bI+B6cRm18nWQAYU/f8fLlifzf0GXHoqC3MnnNACZU7UfwXDa
         mlDWAApj9x0a//48OtHan7TmSPsQIv9Y/56NgLLtFY+ug0s/apqHUVDHldF3ABTqtppw
         p56g==
X-Gm-Message-State: AOAM533ljrYwXPqPsqhrSnmAHgGRUD+iK/ge1txpLav/wChkB3zivRZT
        +0FHpjbXhfUPOs64nOUyvWfnVbygHeMDAQ==
X-Google-Smtp-Source: ABdhPJw9sZVlcVaB/4nYAsFhP7PYOVuzKVCkYWqvhIl3ye8GAbxg3qeQPGYcGHjyGCVeFdL6H7rExA==
X-Received: by 2002:a17:906:8583:: with SMTP id v3mr8864831ejx.361.1616229930400;
        Sat, 20 Mar 2021 01:45:30 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id h17sm5631768eds.26.2021.03.20.01.45.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Mar 2021 01:45:29 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.10\))
Subject: Re: [PATCH net v4] net: fix race between napi kthread mode and busy
 poll
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20210316223647.4080796-1-weiwan@google.com>
Date:   Sat, 20 Mar 2021 10:45:28 +0200
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6AF20AA6-07E7-4DDD-8A9E-BE093FC03802@gmail.com>
References: <20210316223647.4080796-1-weiwan@google.com>
To:     Wei Wang <weiwan@google.com>
X-Mailer: Apple Mail (2.3654.80.0.2.10)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wei=20
Check this:

[   39.706567] ------------[ cut here ]------------
[   39.706568] RTNL: assertion failed at net/ipv4/udp_tunnel_nic.c (557)
[   39.706585] WARNING: CPU: 0 PID: 429 at net/ipv4/udp_tunnel_nic.c:557 =
__udp_tunnel_nic_reset_ntf+0xea/0x100
[   39.706594] Modules linked in: i40e(+) nf_nat_sip nf_conntrack_sip =
nf_nat_pptp nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp =
nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 =
acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler rtc_cmos megaraid_sas
[   39.706614] CPU: 0 PID: 429 Comm: kworker/0:2 Tainted: G           O  =
    5.11.7 #1
[   39.706618] Hardware name: Supermicro X11DPi-N(T)/X11DPi-NT, BIOS 3.4 =
11/23/2020
[   39.706619] Workqueue: events work_for_cpu_fn
[   39.706627] RIP: 0010:__udp_tunnel_nic_reset_ntf+0xea/0x100
[   39.706631] Code: c0 79 f1 00 00 0f 85 4e ff ff ff ba 2d 02 00 00 48 =
c7 c6 45 3c 3a 93 48 c7 c7 40 de 39 93 c6 05 a0 79 f1 00 01 e8 f5 ad 0c =
00 <0f> 0b e9 28 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00
[   39.706634] RSP: 0018:ffffa8390d9b3b38 EFLAGS: 00010292
[   39.706637] RAX: 0000000000000039 RBX: ffff8e02630b2768 RCX: =
00000000ffdfffff
[   39.706639] RDX: 00000000ffdfffff RSI: ffff8e80ad400000 RDI: =
0000000000000001
[   39.706641] RBP: ffff8e025df72000 R08: ffff8e80bb3fffe8 R09: =
00000000ffffffea
[   39.706643] R10: 00000000ffdfffff R11: 80000000ffe00000 R12: =
ffff8e02630b2008
[   39.706645] R13: 0000000000000000 R14: ffff8e024a88ba00 R15: =
0000000000000000
[   39.706646] FS:  0000000000000000(0000) GS:ffff8e40bf800000(0000) =
knlGS:0000000000000000
[   39.706649] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   39.706651] CR2: 00000000004d8f40 CR3: 0000002ca140a002 CR4: =
00000000001706f0
[   39.706652] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
[   39.706654] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
[   39.706656] Call Trace:
[   39.706658]  i40e_setup_pf_switch+0x617/0xf80 [i40e]
[   39.706683]  i40e_probe.part.0.cold+0x8dc/0x109e [i40e]
[   39.706708]  ? acpi_ns_check_object_type+0xd4/0x193
[   39.706713]  ? acpi_ns_check_package_list+0xfd/0x205
[   39.706716]  ? __kmalloc+0x37/0x160
[   39.706720]  ? kmem_cache_alloc+0xcb/0x120
[   39.706723]  ? irq_get_irq_data+0x5/0x20
[   39.706726]  ? mp_check_pin_attr+0xe/0xf0
[   39.706729]  ? irq_get_irq_data+0x5/0x20
[   39.706731]  ? mp_map_pin_to_irq+0xb7/0x2c0
[   39.706735]  ? acpi_register_gsi_ioapic+0x86/0x150
[   39.706739]  ? pci_conf1_read+0x9f/0xf0
[   39.706743]  ? pci_bus_read_config_word+0x2e/0x40
[   39.706746]  local_pci_probe+0x1b/0x40
[   39.706750]  work_for_cpu_fn+0xb/0x20
[   39.706754]  process_one_work+0x1ec/0x350
[   39.706758]  worker_thread+0x24b/0x4d0
[   39.706760]  ? process_one_work+0x350/0x350
[   39.706762]  kthread+0xea/0x120
[   39.706766]  ? kthread_park+0x80/0x80
[   39.706770]  ret_from_fork+0x1f/0x30
[   39.706774] ---[ end trace 7a203f3ec972a377 ]---

Martin
=09

> On 17 Mar 2021, at 0:36, Wei Wang <weiwan@google.com> wrote:
>=20
> Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> determine if the kthread owns this napi and could call napi->poll() on
> it. However, if socket busy poll is enabled, it is possible that the
> busy poll thread grabs this SCHED bit (after the previous napi->poll()
> invokes napi_complete_done() and clears SCHED bit) and tries to poll
> on the same napi. napi_disable() could grab the SCHED bit as well.
> This patch tries to fix this race by adding a new bit
> NAPI_STATE_SCHED_THREADED in napi->state. This bit gets set in
> ____napi_schedule() if the threaded mode is enabled, and gets cleared
> in napi_complete_done(), and we only poll the napi in kthread if this
> bit is set. This helps distinguish the ownership of the napi between
> kthread and other scenarios and fixes the race issue.
>=20
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop =
support")
> Reported-by: Martin Zaharinov <micron10@gmail.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Cc: Alexander Duyck <alexanderduyck@fb.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> ---
> Change since v3:
>  - Add READ_ONCE() for thread->state and add comments in
>    ____napi_schedule().
>=20
> include/linux/netdevice.h |  2 ++
> net/core/dev.c            | 19 ++++++++++++++++++-
> 2 files changed, 20 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5b67ea89d5f2..87a5d186faff 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -360,6 +360,7 @@ enum {
> 	NAPI_STATE_IN_BUSY_POLL,	/* sk_busy_loop() owns this NAPI =
*/
> 	NAPI_STATE_PREFER_BUSY_POLL,	/* prefer busy-polling over =
softirq processing*/
> 	NAPI_STATE_THREADED,		/* The poll is performed inside =
its own thread*/
> +	NAPI_STATE_SCHED_THREADED,	/* Napi is currently scheduled =
in threaded mode */
> };
>=20
> enum {
> @@ -372,6 +373,7 @@ enum {
> 	NAPIF_STATE_IN_BUSY_POLL	=3D =
BIT(NAPI_STATE_IN_BUSY_POLL),
> 	NAPIF_STATE_PREFER_BUSY_POLL	=3D =
BIT(NAPI_STATE_PREFER_BUSY_POLL),
> 	NAPIF_STATE_THREADED		=3D BIT(NAPI_STATE_THREADED),
> +	NAPIF_STATE_SCHED_THREADED	=3D =
BIT(NAPI_STATE_SCHED_THREADED),
> };
>=20
> enum gro_result {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6c5967e80132..d3195a95f30e 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4294,6 +4294,13 @@ static inline void ____napi_schedule(struct =
softnet_data *sd,
> 		 */
> 		thread =3D READ_ONCE(napi->thread);
> 		if (thread) {
> +			/* Avoid doing set_bit() if the thread is in
> +			 * INTERRUPTIBLE state, cause napi_thread_wait()
> +			 * makes sure to proceed with napi polling
> +			 * if the thread is explicitly woken from here.
> +			 */
> +			if (READ_ONCE(thread->state) !=3D =
TASK_INTERRUPTIBLE)
> +				set_bit(NAPI_STATE_SCHED_THREADED, =
&napi->state);
> 			wake_up_process(thread);
> 			return;
> 		}
> @@ -6486,6 +6493,7 @@ bool napi_complete_done(struct napi_struct *n, =
int work_done)
> 		WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
>=20
> 		new =3D val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
> +			      NAPIF_STATE_SCHED_THREADED |
> 			      NAPIF_STATE_PREFER_BUSY_POLL);
>=20
> 		/* If STATE_MISSED was set, leave STATE_SCHED set,
> @@ -6968,16 +6976,25 @@ static int napi_poll(struct napi_struct *n, =
struct list_head *repoll)
>=20
> static int napi_thread_wait(struct napi_struct *napi)
> {
> +	bool woken =3D false;
> +
> 	set_current_state(TASK_INTERRUPTIBLE);
>=20
> 	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> -		if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> +		/* Testing SCHED_THREADED bit here to make sure the =
current
> +		 * kthread owns this napi and could poll on this napi.
> +		 * Testing SCHED bit is not enough because SCHED bit =
might be
> +		 * set by some other busy poll thread or by =
napi_disable().
> +		 */
> +		if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || =
woken) {
> 			WARN_ON(!list_empty(&napi->poll_list));
> 			__set_current_state(TASK_RUNNING);
> 			return 0;
> 		}
>=20
> 		schedule();
> +		/* woken being true indicates this thread owns this =
napi. */
> +		woken =3D true;
> 		set_current_state(TASK_INTERRUPTIBLE);
> 	}
> 	__set_current_state(TASK_RUNNING);
> --=20
> 2.31.0.rc2.261.g7f71774620-goog
>=20

