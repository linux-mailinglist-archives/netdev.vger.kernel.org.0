Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659BC113075
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbfLDRFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:05:20 -0500
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:16921
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728784AbfLDRFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 12:05:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oL/0zocveqaPpcHZ/FtUGnk+m2kK+RubXd3L7WlK9y9p32R0qgTrP14p1HdmNKtSWVBh+UhNwAXnh5w2ouZyrrB07t2tm95cvCtBY87u/jCrO3uXaY1+AKN/s2/5U5iKrovzqN5xuHO2U1TcsY75PWcVoBZt5SaYM9yjK8mJvsruqvK6myxraxCUsEdgVMek7GLdbQhkGXBeBj3lJgsnhUcKmooBmwzjegzcLZ3gpALVAgGrThYk7YRDU5XE+/8mKKU6g5qhdSaB0WHk2mwbZ/pyAtZyI/gB4epmk1ao6Lu8Rso2IT7CsFedmv1Z6WvGD8muCUHhDFZeRbfq9q5gig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwfpW+klggfKBxfwZjuraMMsRnAdf6shfazeHGkXByI=;
 b=nR1Ga6iJ4FGcq8BNY9wVscKV380Loe9MAbjE/NidBZzXyXS2PvuyUdP5DINohQ+qACdY2ncsYCtOZx+CDLm/GyRa7MN0YoKe7P7IzAUNaHNRNp68ZoLmPluaZbx6MX2cEP4o65rK7Ru8A8bgbFwQhJwwD1oJrZD2BMhQnlMLZWTQlcjgAghtMMOe4d1QYh+jYew7d+NItERcz2coua4cmnxVtr4AKp8DNcENGOnVrTC2qSN7FT8ShkAYm8khcYInN6aWMsljjh6c/v1fkTJjv1in9i+0vaPh24MckLjZphC5Rp2jEmF4Iq0puq4DAxyCZQ/a1sL2tIqrHK1ZyMNtsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwfpW+klggfKBxfwZjuraMMsRnAdf6shfazeHGkXByI=;
 b=f8qRq2K0Kz4YMvLsFe9Sla5zW2EuM8vxu0WuKBjUIkf4HzHrJ8oQW221TaWty1BrjpzGcGEQmmP20Va6Jp5sfM7O36HtLFjlMe8M/a94A15tQug8a35airYwjQ0hJwX3mQXpM7JyLUxHkxdisA3IlBqgUzy2pTIb4tr/W9C43dc=
Received: from DBBPR05MB6522.eurprd05.prod.outlook.com (20.179.40.143) by
 DBBPR05MB6474.eurprd05.prod.outlook.com (20.179.42.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 17:05:16 +0000
Received: from DBBPR05MB6522.eurprd05.prod.outlook.com
 ([fe80::15f9:a1bb:26aa:6260]) by DBBPR05MB6522.eurprd05.prod.outlook.com
 ([fe80::15f9:a1bb:26aa:6260%7]) with mapi id 15.20.2516.013; Wed, 4 Dec 2019
 17:05:16 +0000
From:   Vladyslav Tarasiuk <vladyslavt@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>
CC:     Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: page_pool: mutex lock inside atomic context
Thread-Topic: page_pool: mutex lock inside atomic context
Thread-Index: AdWqxNFDwXdvDTBZTeaRFFFtwkVXSw==
Date:   Wed, 4 Dec 2019 17:05:16 +0000
Message-ID: <DBBPR05MB6522EAE7219849CE10EF5023BF5D0@DBBPR05MB6522.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladyslavt@mellanox.com; 
x-originating-ip: [77.75.144.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 605bca13-148a-49a1-8eb1-08d778dc2282
x-ms-traffictypediagnostic: DBBPR05MB6474:|DBBPR05MB6474:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB647420AD0716C34B9AA4E1D1BF5D0@DBBPR05MB6474.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(199004)(189003)(1361003)(74316002)(71200400001)(7736002)(305945005)(2501003)(71190400001)(81156014)(8676002)(8936002)(2351001)(25786009)(81166006)(14444005)(316002)(186003)(5660300002)(5640700003)(76116006)(9686003)(6306002)(6916009)(99286004)(6506007)(7696005)(4326008)(102836004)(33656002)(3846002)(14454004)(66446008)(66556008)(54906003)(86362001)(64756008)(66476007)(66946007)(30864003)(55016002)(6436002)(2906002)(966005)(6116002)(26005)(52536014)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6474;H:DBBPR05MB6522.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0WMIi9Ri/HjrOvoyFsIbXH7LhyQuSYwicJE+om333SHeK6YuKBCqbxCOqNa08mGqDyarwEhXHweDogIwwuc07/MJl4sjyLIin/ae0xeuBuzOZhOF1CqFumtESnOY9wZjBWp/W3k63xp0nkzsBb8nKEgLuUy7eu7HH26IRJextcOkc1Tn61CERaX90GESGh15hcLTYRk7Kq4BC4ZaROIJ2pkzHXrHOSWJlKNwTCGhspSsxStJDcU48X7wzNO0bi7231mnykxGglmUY5L9RYvr8RU+mlk0SWKjU7WC6Jtpi5y5mR5FJtl5V59ZeSKYMI4S0RX7wkeRjOKHC/um/snJVy5hDQcJUrmqo0as5d1ybjzXere6AU9dvEsizFf7iE5YI4OPIEchUgz1xZuCTj7eR+V1wqSV6H4WOydZKm0Dac66dsgqaORoniVfMVUnfn46epbmpf48ysuMF/E/I+qOK4O3bvwDZebvBCbDMit0s0g=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 605bca13-148a-49a1-8eb1-08d778dc2282
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 17:05:16.2214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2smGsc198m+hWHCHV5PNuaYoROrQOxI5DL2ZiAOBxQAQ1WWFTEAMA2Se4zK9zY6Gf0r6Bks4UK4ly46exEGdKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6474
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jonathan,

Recently we found a bug regarding invalid mutex lock inside atomic context.
The bug occurs when destroying a page pool that was registered as a
XDP allocator.
An original stack trace for it is at the end of the mail, but in short,
the flow from the mlx5 driver looks like this:
- xdp_rxq_info_unreg is called before page_pool_destroy from the stack trac=
e,
  which in turn calls page_pool_destroy, but only decreases the refcount
  and exits;
- page_pool_destroy is called, which decreases refcount to zero
  and starts releasing the pages;
- page_pool_destroy eventually reaches page_pool_free, which calls a
  mem_allocator_disconnect function via a function pointer stored in=20
  'disconnect' field inside page_pool structure;
- mem_allocator_disconnect takes rcu lock inside rhashtable_walk_start
  and holds it while calling mem_xa_remove;
- mem_xa_remove tries to lock on a mem_id_lock mutex which should not be
  done while rcu lock is taken.
 =20
The pointer to mem_allocator_disconnect is assigned to 'disconnect' field
of page_pool struct with a call to xdp_rxq_info_reg_mem_model function and
is basically hardcoded, so this bug should always reproduce when destroying
a page pool that was registered as a XDP allocator.

We were able to reproduce this bug on Mellanox setup by unloading or reload=
ing
the mlx5 driver with, for example, executing this command:
# devlink dev reload <PCI address>
CONFIG_DEBUG_ATOMIC_SLEEP=3Dy is required to see this stacktrace.

We found the commit that introduced this bug with a bisect and its patch
discussion can be found here:
https://patchwork.ozlabs.org/patch/1195227/

Regards,
Vlad

[ 100.437147] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 100.437682] WARNING: suspicious RCU usage
[ 100.438152] 5.4.0-rc7+ #296 Not tainted
[ 100.438629] -----------------------------
[ 100.439113] include/linux/rcupdate.h:272 Illegal context switch in RCU re=
ad-side critical section!
[ 100.440414]
[ 100.440414] other info that might help us debug this:
[ 100.440414]
[ 100.441353]
[ 100.441353] rcu_scheduler_active =3D 2, debug_locks =3D 1
[ 100.442080] 4 locks held by modprobe/428:
[ 100.442531] #0: ffffffffa04822b0 (mlx5_intf_mutex){+.+.}, at: mlx5_unregi=
ster_interface+0x20/0x1d0 [mlx5_core]
[ 100.443813] #1: ffffffff83f9ca70 (rtnl_mutex){+.+.}, at: unregister_netde=
v+0xe/0x20
[ 100.444734] #2: ffff88810fc82380 (&priv->state_lock){+.+.}, at: mlx5e_clo=
se+0x4e/0xc0 [mlx5_core]
[ 100.445621] #3: ffffffff839b04a0 (rcu_read_lock){....}, at: rhashtable_wa=
lk_start_check+0xae/0xb30
[ 100.446379]
[ 100.446379] stack backtrace:
[ 100.446852] CPU: 1 PID: 428 Comm: modprobe Not tainted 5.4.0-rc7+ #296
[ 100.447402] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-=
1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[ 100.448251] Call Trace:
[ 100.448452] dump_stack+0x97/0xe0
[ 100.448693] __might_sleep+0x226/0x2f0
[ 100.448934] __mutex_lock+0xca/0x1570
[ 100.449165] ? mem_xa_remove+0xe3/0x570
[ 100.449417] ? sched_clock+0x5/0x10
[ 100.449653] ? sched_clock_cpu+0x31/0x1f0
[ 100.449886] ? mutex_lock_io_nested+0x1400/0x1400
[ 100.450206] ? rcu_read_lock_sched_held+0xaf/0xe0
[ 100.450537] ? rcu_read_lock_bh_held+0xc0/0xc0
[ 100.450862] ? mem_xa_remove+0xe3/0x570
[ 100.451097] mem_xa_remove+0xe3/0x570
[ 100.451322] ? xdp_rxq_info_reg+0x160/0x160
[ 100.451551] ? rhashtable_destroy+0x10/0x10
[ 100.451787] mem_allocator_disconnect+0xd1/0x134
[ 100.452096] ? mem_xa_remove+0x570/0x570
[ 100.452333] ? rcu_read_lock_bh_held+0xc0/0xc0
[ 100.452648] ? lockdep_hardirqs_on+0x39b/0x5a0
[ 100.452958] ? page_pool_release+0x371/0x9d0
[ 100.453276] page_pool_release+0x527/0x9d0
[ 100.453515] page_pool_destroy+0x32/0x230
[ 100.453788] mlx5e_free_rq+0x1e1/0x2f0 [mlx5_core]
[ 100.454134] mlx5e_close_queues+0x31/0x330 [mlx5_core]
[ 100.454495] mlx5e_close_channel+0x49/0x80 [mlx5_core]
[ 100.454835] mlx5e_close_channels+0x95/0x160 [mlx5_core]
[ 100.455181] mlx5e_close_locked+0xe0/0x110 [mlx5_core]
[ 100.455529] mlx5e_close+0x85/0xc0 [mlx5_core]
[ 100.455827] __dev_close_many+0x189/0x2a0
[ 100.456051] ? list_netdevice+0x3a0/0x3a0
[ 100.456294] dev_close_many+0x1d9/0x580
[ 100.456548] ? find_held_lock+0x2d/0x110
[ 100.456783] ? netif_stacked_transfer_operstate+0xd0/0xd0
[ 100.457084] ? unregister_netdev+0xe/0x20
[ 100.457321] rollback_registered_many+0x33b/0xe10
[ 100.457651] ? netif_set_real_num_tx_queues+0x6d0/0x6d0
[ 100.457975] ? unregister_netdev+0xe/0x20
[ 100.458199] ? mutex_lock_io_nested+0x1400/0x1400
[ 100.458503] rollback_registered+0xd0/0x180
[ 100.458745] ? rollback_registered_many+0xe10/0xe10
[ 100.459058] ? lock_downgrade+0x6a0/0x6a0
[ 100.459280] unregister_netdevice_queue+0x18b/0x250
[ 100.459629] ? mlx5e_destroy_netdev+0xb0/0xb0 [mlx5_core]
[ 100.459934] unregister_netdev+0x18/0x20
[ 100.460208] mlx5e_remove+0x7b/0xb0 [mlx5_core]
[ 100.460582] mlx5_remove_device+0x220/0x2f0 [mlx5_core]
[ 100.460908] mlx5_unregister_interface+0x4b/0x1d0 [mlx5_core]
[ 100.461339] cleanup+0x5/0x1e [mlx5_core]
[ 100.461600] __x64_sys_delete_module+0x270/0x380
[ 100.461932] ? __ia32_sys_delete_module+0x380/0x380
[ 100.462217] ? task_work_run+0xa4/0x180
[ 100.462469] ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
[ 100.462788] ? trace_hardirqs_off_thunk+0x1a/0x20
[ 100.463101] ? do_syscall_64+0x18/0x4a0
[ 100.463326] do_syscall_64+0x95/0x4a0
[ 100.463566] entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 100.463875] RIP: 0033:0x7f93d7d43ebb
[ 100.464113] Code: 73 01 c3 48 8b 0d cd 2f 0c 00 f7 d8 64 89 01 48 83 c8 f=
f c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48>=
 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d 2f 0c 00 f7 d8 64 89 01 48
[ 100.465174] RSP: 002b:00007ffddb2e7d68 EFLAGS: 00000206 ORIG_RAX: 0000000=
0000000b0
[ 100.465664] RAX: ffffffffffffffda RBX: 000055ec90c97b50 RCX: 00007f93d7d4=
3ebb
[ 100.466105] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000055ec90c9=
7bb8
[ 100.466564] RBP: 000055ec90c97b50 R08: 0000000000000000 R09: 000000000000=
0000
[ 100.467038] R10: 00007f93d7db7ac0 R11: 0000000000000206 R12: 000055ec90c9=
7bb8
[ 100.467511] R13: 0000000000000000 R14: 000055ec90c980a0 R15: 000055ec90c9=
7910
[ 100.468005] BUG: sleeping function called from invalid context at kernel/=
locking/mutex.c:935
[ 100.468520] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 428, n=
ame: modprobe
[ 100.468968] 4 locks held by modprobe/428:
[ 100.469194] #0: ffffffffa04822b0 (mlx5_intf_mutex){+.+.}, at: mlx5_unregi=
ster_interface+0x20/0x1d0 [mlx5_core]
[ 100.469837] #1: ffffffff83f9ca70 (rtnl_mutex){+.+.}, at: unregister_netde=
v+0xe/0x20
[ 100.470290] #2: ffff88810fc82380 (&priv->state_lock){+.+.}, at: mlx5e_clo=
se+0x4e/0xc0 [mlx5_core]
[ 100.470856] #3: ffffffff839b04a0 (rcu_read_lock){....}, at: rhashtable_wa=
lk_start_check+0xae/0xb30
[ 100.471372] CPU: 1 PID: 428 Comm: modprobe Not tainted 5.4.0-rc7+ #296
[ 100.471758] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-=
1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[ 100.472454] Call Trace:
[ 100.472615] dump_stack+0x97/0xe0
[ 100.472850] __might_sleep.cold+0x180/0x1b0
[ 100.473152] __mutex_lock+0xca/0x1570
[ 100.473389] ? mem_xa_remove+0xe3/0x570
[ 100.473633] ? sched_clock+0x5/0x10
[ 100.473863] ? sched_clock_cpu+0x31/0x1f0
[ 100.474081] ? mutex_lock_io_nested+0x1400/0x1400
[ 100.474384] ? rcu_read_lock_sched_held+0xaf/0xe0
[ 100.474703] ? rcu_read_lock_bh_held+0xc0/0xc0
[ 100.474999] ? mem_xa_remove+0xe3/0x570
[ 100.475221] mem_xa_remove+0xe3/0x570
[ 100.475464] ? xdp_rxq_info_reg+0x160/0x160
[ 100.475694] ? rhashtable_destroy+0x10/0x10
[ 100.475930] mem_allocator_disconnect+0xd1/0x134
[ 100.476221] ? mem_xa_remove+0x570/0x570
[ 100.476465] ? rcu_read_lock_bh_held+0xc0/0xc0
[ 100.476774] ? lockdep_hardirqs_on+0x39b/0x5a0
[ 100.477111] ? page_pool_release+0x371/0x9d0
[ 100.477430] page_pool_release+0x527/0x9d0
[ 100.477672] page_pool_destroy+0x32/0x230
[ 100.477916] mlx5e_free_rq+0x1e1/0x2f0 [mlx5_core]
[ 100.478254] mlx5e_close_queues+0x31/0x330 [mlx5_core]
[ 100.478599] mlx5e_close_channel+0x49/0x80 [mlx5_core]
[ 100.478947] mlx5e_close_channels+0x95/0x160 [mlx5_core]
[ 100.479276] mlx5e_close_locked+0xe0/0x110 [mlx5_core]
[ 100.479622] mlx5e_close+0x85/0xc0 [mlx5_core]
[ 100.479925] __dev_close_many+0x189/0x2a0
[ 100.480149] ? list_netdevice+0x3a0/0x3a0
[ 100.480373] dev_close_many+0x1d9/0x580
[ 100.480606] ? find_held_lock+0x2d/0x110
[ 100.480857] ? netif_stacked_transfer_operstate+0xd0/0xd0
[ 100.481144] ? unregister_netdev+0xe/0x20
[ 100.481375] rollback_registered_many+0x33b/0xe10
[ 100.481704] ? netif_set_real_num_tx_queues+0x6d0/0x6d0
[ 100.482014] ? unregister_netdev+0xe/0x20
[ 100.482225] ? mutex_lock_io_nested+0x1400/0x1400
[ 100.482545] rollback_registered+0xd0/0x180
[ 100.482789] ? rollback_registered_many+0xe10/0xe10
[ 100.483091] ? lock_downgrade+0x6a0/0x6a0
[ 100.483320] unregister_netdevice_queue+0x18b/0x250
[ 100.483672] ? mlx5e_destroy_netdev+0xb0/0xb0 [mlx5_core]
[ 100.483962] unregister_netdev+0x18/0x20
[ 100.484237] mlx5e_remove+0x7b/0xb0 [mlx5_core]
[ 100.484571] mlx5_remove_device+0x220/0x2f0 [mlx5_core]
[ 100.484914] mlx5_unregister_interface+0x4b/0x1d0 [mlx5_core]
[ 100.485319] cleanup+0x5/0x1e [mlx5_core]
[ 100.485572] __x64_sys_delete_module+0x270/0x380
[ 100.485882] ? __ia32_sys_delete_module+0x380/0x380
[ 100.486179] ? task_work_run+0xa4/0x180
[ 100.486412] ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
[ 100.486725] ? trace_hardirqs_off_thunk+0x1a/0x20
[ 100.487031] ? do_syscall_64+0x18/0x4a0
[ 100.487269] do_syscall_64+0x95/0x4a0
[ 100.487498] entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 100.487780] RIP: 0033:0x7f93d7d43ebb
[ 100.488016] Code: 73 01 c3 48 8b 0d cd 2f 0c 00 f7 d8 64 89 01 48 83 c8 f=
f c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48>=
 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d 2f 0c 00 f7 d8 64 89 01 48
[ 100.489054] RSP: 002b:00007ffddb2e7d68 EFLAGS: 00000206 ORIG_RAX: 0000000=
0000000b0
[ 100.489513] RAX: ffffffffffffffda RBX: 000055ec90c97b50 RCX: 00007f93d7d4=
3ebb
[ 100.489978] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000055ec90c9=
7bb8
[ 100.490417] RBP: 000055ec90c97b50 R08: 0000000000000000 R09: 000000000000=
0000
[ 100.490867] R10: 00007f93d7db7ac0 R11: 0000000000000206 R12: 000055ec90c9=
7bb8
[ 100.491321] R13: 0000000000000000 R14: 000055ec90c980a0 R15: 000055ec90c9=
7910
