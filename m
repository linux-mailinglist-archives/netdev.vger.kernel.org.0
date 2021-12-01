Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E2A46450D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346240AbhLACuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:50:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60646 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241414AbhLACuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:50:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A9C8B81DD3;
        Wed,  1 Dec 2021 02:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D851BC53FC7;
        Wed,  1 Dec 2021 02:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638326818;
        bh=jYTeDRhzORWO1OiHiyDPXjnTq/iT5mMQeTe0rEGclqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TeE0W12YOtGWeQt6SErHztN4icOoKrNAnAkOCNs8DdIpy9Mx4YfTUXLnoDgsOHIYC
         TyMO3ePSBVYrj5cTEgm0i3Wl7K9Px+VAMRAImp/QEcaToyY+ZY27/RNiOuxwQfygpZ
         xqUFC7Lyso8c3qh2/941y0WepM8Jdv7Ussbpd8zGIhRtgVLp1hTgRfcVy2LwJLDTen
         pHdA8VMm/XF3afzBdqDBLgUIveDEHPrOjbzOZ9EAHOYG6GiHFIaDjy7az4JNs4IWrf
         4V2ExaA4eYBHUWf5GoZKx2ZORG98loRM8aES96qllSXdba3KhIF4HW7LfuKhPRvlr0
         kH9n991agkK0Q==
Date:   Tue, 30 Nov 2021 18:46:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: fix wrong list_del in
 smc_lgr_cleanup_early
Message-ID: <20211130184656.6958a442@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201023147.42923-1-dust.li@linux.alibaba.com>
References: <20211201023147.42923-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Dec 2021 10:31:47 +0800 Dust Li wrote:
> smc_lgr_cleanup_early() meant to delete the link
> group from the link group list, but it deleted
> the list head by mistake.
>=20
> This may cause memory corruption since we didn't
> remove the real link group from the list and later
> memseted the link group structure.
> We got a list corruption panic when testing:
>=20
> [ =C2=A0231.277259] list_del corruption. prev->next should be ffff8881398=
a8000, but was 0000000000000000
> [ =C2=A0231.278222] ------------[ cut here ]------------
> [ =C2=A0231.278726] kernel BUG at lib/list_debug.c:53!
> [ =C2=A0231.279326] invalid opcode: 0000 [#1] SMP NOPTI
> [ =C2=A0231.279803] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.10.46+ =
#435
> [ =C2=A0231.280466] Hardware name: Alibaba Cloud ECS, BIOS 8c24b4c 04/01/=
2014
> [ =C2=A0231.281248] Workqueue: events smc_link_down_work
> [ =C2=A0231.281732] RIP: 0010:__list_del_entry_valid+0x70/0x90
> [ =C2=A0231.282258] Code: 4c 60 82 e8 7d cc 6a 00 0f 0b 48 89 fe 48 c7 c7=
 88 4c
> 60 82 e8 6c cc 6a 00 0f 0b 48 89 fe 48 c7 c7 c0 4c 60 82 e8 5b cc 6a 00 <=
0f>
> 0b 48 89 fe 48 c7 c7 00 4d 60 82 e8 4a cc 6a 00 0f 0b cc cc cc
> [ =C2=A0231.284146] RSP: 0018:ffffc90000033d58 EFLAGS: 00010292
> [ =C2=A0231.284685] RAX: 0000000000000054 RBX: ffff8881398a8000 RCX: 0000=
000000000000
> [ =C2=A0231.285415] RDX: 0000000000000001 RSI: ffff88813bc18040 RDI: ffff=
88813bc18040
> [ =C2=A0231.286141] RBP: ffffffff8305ad40 R08: 0000000000000003 R09: 0000=
000000000001
> [ =C2=A0231.286873] R10: ffffffff82803da0 R11: ffffc90000033b90 R12: 0000=
000000000001
> [ =C2=A0231.287606] R13: 0000000000000000 R14: ffff8881398a8000 R15: 0000=
000000000003
> [ =C2=A0231.288337] FS: =C2=A00000000000000000(0000) GS:ffff88813bc00000(=
0000) knlGS:0000000000000000
> [ =C2=A0231.289160] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ =C2=A0231.289754] CR2: 0000000000e72058 CR3: 000000010fa96006 CR4: 0000=
0000003706f0
> [ =C2=A0231.290485] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000=
000000000000
> [ =C2=A0231.291211] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000=
000000000400
> [ =C2=A0231.291940] Call Trace:
> [ =C2=A0231.292211] =C2=A0smc_lgr_terminate_sched+0x53/0xa0
> [ =C2=A0231.292677] =C2=A0smc_switch_conns+0x75/0x6b0
> [ =C2=A0231.293085] =C2=A0? update_load_avg+0x1a6/0x590
> [ =C2=A0231.293517] =C2=A0? ttwu_do_wakeup+0x17/0x150
> [ =C2=A0231.293907] =C2=A0? update_load_avg+0x1a6/0x590
> [ =C2=A0231.294317] =C2=A0? newidle_balance+0xca/0x3d0
> [ =C2=A0231.294716] =C2=A0smcr_link_down+0x50/0x1a0
> [ =C2=A0231.295090] =C2=A0? __wake_up_common_lock+0x77/0x90
> [ =C2=A0231.295534] =C2=A0smc_link_down_work+0x46/0x60
> [ =C2=A0231.295933] =C2=A0process_one_work+0x18b/0x350
>=20
> Fixes: a0a62ee15a829 ("net/smc: separate locks for SMCD and SMCR link gro=
up lists")
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> Acked-by: Karsten Graul <kgraul@linux.ibm.com>

>  net/smc/smc_core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index bb52c8b5f148..8759f9fd8113 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -625,18 +625,16 @@ int smcd_nl_get_lgr(struct sk_buff *skb, struct net=
link_callback *cb)
>  void smc_lgr_cleanup_early(struct smc_connection *conn)
>  {
>  	struct smc_link_group *lgr =3D conn->lgr;
> -	struct list_head *lgr_list;
>  	spinlock_t *lgr_lock;
> =20
>  	if (!lgr)
>  		return;
> =20
>  	smc_conn_free(conn);
> -	lgr_list =3D smc_lgr_list_head(lgr, &lgr_lock);
>  	spin_lock_bh(lgr_lock);
>  	/* do not use this link group for new connections */
> -	if (!list_empty(lgr_list))
> -		list_del_init(lgr_list);
> +	if (!list_empty(&lgr->list))
> +		list_del_init(&lgr->list);
>  	spin_unlock_bh(lgr_lock);
>  	__smc_lgr_terminate(lgr, true);
>  }

clang has something to say about that:

net/smc/smc_core.c:634:15: warning: variable 'lgr_lock' is uninitialized wh=
en used here [-Wuninitialized]
        spin_lock_bh(lgr_lock);
                     ^~~~~~~~
net/smc/smc_core.c:628:22: note: initialize the variable 'lgr_lock' to sile=
nce this warning
        spinlock_t *lgr_lock;
                            ^
                             =3D NULL
