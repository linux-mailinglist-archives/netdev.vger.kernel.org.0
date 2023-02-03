Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCFA68A255
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 19:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbjBCS5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 13:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjBCS5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 13:57:07 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706B7AA241;
        Fri,  3 Feb 2023 10:57:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehCcudjlt9u3AaxxBbbfeqwnr2aG7AjTweNYMb+nwIeTcfMQC4pxWPe9sM5PEgkk1sMlNPZGzKfNSGzastNb2xyUtTkkuAdwA7Aoa84LaAtC5CS7Pn8YnOeDKHQMgxxVACKHrPYz1agxgtnVQFJWRjFJiP6znL71j/a9CXHz/GE37mcWhebV3+awm8k3SO8g87BXkjKefm0V1MZeWskH9kSCGP54N5qepji6Cs6QS6iyGyZ6Ny3sGJvq5N+3DvrueGJoaJDNMN+U9BzeDyLWhfZ48wk9wRL5WFBQUVfMH3uLiDC92As4+l34G8pgHiZoq8Hpuq894rte0R3UPpcH3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsrOscczDwQlGp1/Pgn/qU12NinS1MHesKSqNc/Eewg=;
 b=N1+DRTweeh6srhqG9fLbOiYxNadC5HOQKBm0+0pTWK8Gk65RbTm+aHFmhGU4c+Wa5gfGgBr6I4JFM90CVhFeZCmGrfrRZEZ6hrc8FYhNmDWcPjGrHNhIfkYSae3Yt112jETYBuj9nyxRoqBLaXQBTRLna+wyiiDJQ4YW+fXP2bfXi4NqswW2FrmC03aGpm1S1q2cQi5lMhtdggS53QDhHnIo6U5HVCWTf3d8cnlMcBlKfYbx9Qlzcu9uX2iLwKaac8VV2fv5yr458kAskf0GePIhpN+ikwWofxu2V9Yqxhyu0R0JLz5jgX7QEOxxjoslRevvc189l6brp7jvsfwMBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=knights.ucf.edu; dmarc=pass action=none
 header.from=knights.ucf.edu; dkim=pass header.d=knights.ucf.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=knightsucfedu39751.onmicrosoft.com;
 s=selector2-knightsucfedu39751-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsrOscczDwQlGp1/Pgn/qU12NinS1MHesKSqNc/Eewg=;
 b=aWvfiExLcMumrN5vQSp1KlHpnBrtIh43ugKrE1Djp3vicOruftR79PZlhizrZhnuBOY9/88CT5/nwJwTU63VcHBXqIDDWSrqCZNivkZHmW9DKu7ya5BGZqtemz5WJxx8fBx9Tfye+5Rqn+LBd7OPsItxeFfozUrkFJPgg9aBmmE=
Received: from IA1PR07MB9830.namprd07.prod.outlook.com (2603:10b6:208:44b::14)
 by DM5PR07MB7894.namprd07.prod.outlook.com (2603:10b6:4:aa::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Fri, 3 Feb
 2023 18:56:59 +0000
Received: from IA1PR07MB9830.namprd07.prod.outlook.com
 ([fe80::d883:f078:37f:dace]) by IA1PR07MB9830.namprd07.prod.outlook.com
 ([fe80::d883:f078:37f:dace%9]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 18:56:59 +0000
From:   Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "claudiajkang@gmail.com" <claudiajkang@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "contact@pgazz.com" <contact@pgazz.com>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
Subject: WARNING in send_hsr_supervision_frame
Thread-Topic: WARNING in send_hsr_supervision_frame
Thread-Index: AQHZN/4f/hirPoKFyU6SeeV2GkbEpQ==
Date:   Fri, 3 Feb 2023 18:56:59 +0000
Message-ID: <IA1PR07MB9830DB757C1AAD78BFB84FA2ABD79@IA1PR07MB9830.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=Knights.ucf.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR07MB9830:EE_|DM5PR07MB7894:EE_
x-ms-office365-filtering-correlation-id: 8ca8c208-5a2b-4edf-706e-08db06186dc7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i2rsi8+rM4GDgM5sS9CJbgrZiMdTlsjnNqwkwVMrWTBGO9CsKxTRAPBZNFWhjDkf2WRDNKSjXhNySLf/jbguivyJ+OcZJO/Y7lz1oTTvR9sphdE63ECE3mU1n/Nl0z6xAMD5OrrquHhInIBJMOTsybbkvSK7YvQx8/jYf1Vt0lJpU2fQx892H7KUuf3H/X6Ze7842BZYxrcqixxpGD0kth8aNe8W/HGXHd2gYlK3bpt12UL4lH9nwwD8EiOQplSGHZ+Pv5Qgg9s/MZtAmTzAvBiYiWJZtmlczmfCy34mZV25ADhbu5FGDFKm9gVkSFFE8pUPZrMyj+PLgvK87S5t2JUAXgg6bmPW2chawLaG5mRDHia+gGiz5yrUnTKNfQOpyNxK+phEOg3dOBjC3C6GjUxQsOmYCmxCNsjkcT24Kwcrp5vid+MyYAUhyz/hDSyMtXFLvXZ7Io3DL/s8OyCXtR+cTf/t1FF/g6cIpwZtz8OXAi6KsMVeC4fE//s+a55z6NI4UBCryFp+JmmLZE7t0mvV9wHMVZcOpCzx1Jo/lbjl25hPbriN9lJe8/YtLs32spwmA5KOvBZfHHTFfZoSeF9zfiX8hOHrzmGYJXSY31NXayR5rukvxFdhAlTJ+7M9pf0oypaqI3nKoadacT8VqIMgNu38oZ4gjLOnUpD9Rg5o49aWNfaugZugVM9owjrK7D1OR2pn9Fkf5rnFMJMcl/HofeK0VK4ZXm5xRB3W/YYeegysoOWqQ2iDCQPyRUdMI2Nk9xhvd+A6sKeb/wMDckaZLEfPDcVuiBL1cq9TWAc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR07MB9830.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199018)(7116003)(5930299012)(478600001)(66446008)(2906002)(64756008)(4326008)(7416002)(8676002)(41300700001)(52536014)(44832011)(8936002)(5660300002)(66476007)(316002)(76116006)(71200400001)(66556008)(91956017)(45080400002)(110136005)(54906003)(66946007)(7696005)(786003)(966005)(6506007)(83380400001)(26005)(38070700005)(9686003)(75432002)(186003)(122000001)(55016003)(33656002)(41320700001)(38100700002)(86362001)(58493002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?4+OVnVwecCtB3jGkRxw1UC3rfeEDZNhWzgCS8d7ljfzZV22ca2H1ykxsOO?=
 =?iso-8859-1?Q?hEn3UEOrPqyWHvUu54Qe1yBkpYbit25iy4WV8qbQMsQjdT7HnzMxRfwy0c?=
 =?iso-8859-1?Q?uGdeZZR4CDVo8zHUcNOuv7jeck6deySlc49ZDCzoyemWHylJyLWHnsVH7t?=
 =?iso-8859-1?Q?5P9XTM2HLHWrnqRHwwFgBc+L6LC/fDt4oG2ruZTmD+Af2x60UF13G97gRB?=
 =?iso-8859-1?Q?3gjN0z4xM1Z/67ccDV3ksG5s2MHUMrmktwY0X0JcApwiLcfoH3wdyemcLT?=
 =?iso-8859-1?Q?zJfL7uskV4O9J/x7QQifDdk5cJdaHV6gHL5U6NzhB9D30x8ljnzC92EHlU?=
 =?iso-8859-1?Q?DsiWG4XhbV1U3j24y/xm6p11z4rPsaFCXJZnfHvgbKmrBKb/cdx/DmG/7A?=
 =?iso-8859-1?Q?GcewnhDQOMMfFZSB0noo0fjeTjQ+Sk8GsYb7c/HhB7DOAkTobdv67ZA+61?=
 =?iso-8859-1?Q?NKVcK+VhUZdoptMV9aO8i5kAWYHOS2QoTZE/YrePu7lZf9otAGD7FrPtVa?=
 =?iso-8859-1?Q?YvnQal5WXek71C8ADFDbtyLjL+EEFpIifITkjl+6x5LK9Odsrb2SkPzo8Q?=
 =?iso-8859-1?Q?EEq8y3e+9Afe4kCii0Jz+FIXJ/bXzmrHDYn7oWrBdz/AwHvpD8LKtWhL7K?=
 =?iso-8859-1?Q?5Oy/elItcmSxyMJRXdWqm/riNvbybYE7pTzr7UAeg9ODDMMMJ4bZXBiqy9?=
 =?iso-8859-1?Q?PNqCZLi6M6thf1fKXnX6wwMbw0XlV7wH790yc0/FN/Jd+AkLrHQ84WTNaZ?=
 =?iso-8859-1?Q?4IWl3h6ZL7fUlI+4OgSeLct9AFUX6ghKgFU0XNbU2Eo+IVj0uuhBXG7udX?=
 =?iso-8859-1?Q?TlK0XoR3cT4gkVX9RC8f/0hlDxg7cjWQHXqZGTdo7im38GcfqKarrX8ly5?=
 =?iso-8859-1?Q?grXDZxks0aL/h41zsNgrsjuW6v3oDvv9tbbYL1PhyL3yavTumkAuZTj5QX?=
 =?iso-8859-1?Q?7naYV6vjZPnW93JsCpNzehGExrjoK7bi0pK7QIYfuA/6ZokimBQPMRerCp?=
 =?iso-8859-1?Q?SoFBSI6+7scfD7oWuw2ADJG7YAhfCzlXQo1zLLwMKglG6W0aTnovCofZiC?=
 =?iso-8859-1?Q?bDfnQu/oqbL7He1xuht79GQxgVcwE26qWDXSk0liYHzgj5gz1MCUjdyV4l?=
 =?iso-8859-1?Q?RT/9cIXa0tXb5lRKSlBmQRtz/liR9gAN4Xm6tfd+w7AFqB4lC/vqHYJlF7?=
 =?iso-8859-1?Q?XTnRrUXBiC6fGHLoipPO+szV7FPowjNxiVKQjZUjFI7L3aChxQ5M1A1Heo?=
 =?iso-8859-1?Q?Yhquhro/YoWzLyAhRlAkpspeSgUpdeDSFE8CEXIhh8sMW4P0s/lcFYqGqN?=
 =?iso-8859-1?Q?pg9Jv9MGSwrgUE+Xj34mekNVxKit5wq7WNMEMYTrr+rDkheMPdujimYH0G?=
 =?iso-8859-1?Q?NitYf6lmkzD8QWUbA7ylR2K9AHs+caQMr4AMUb6xV+cJYM96bbebyIjk3w?=
 =?iso-8859-1?Q?BrjDb55P7iG4JzKGVc0EH0C0UqdiN7Y60+bx8M9tpBy/g6QDQJ4DxubS8Y?=
 =?iso-8859-1?Q?eYwM5qHj/S3zoO/hclDFe04E6CL4tyGaBNEfcmTi/OQZVzBrHfh6zz1pId?=
 =?iso-8859-1?Q?bidIsC21D1TXvWqOtpjU5RNbuq9094WYisTsW3anigrJbEaubXQqIwHTkw?=
 =?iso-8859-1?Q?XkUJ+Ss5SPOdfMpDhyKAf5Wg0Ja67JceWAHUNEcZSckilS+1mJZMX4ug?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: knights.ucf.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR07MB9830.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca8c208-5a2b-4edf-706e-08db06186dc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 18:56:59.3200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5b16e182-78b3-412c-9196-68342689eeb7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: khEvetSnJiNL+JjYtr9q1hAhTAX5MBSifeNVy+4W/kdbS3ZBmB5ODS8oN0FNDGuK1pDOMSFr+2js/aLj8GubGv1dCoi+Gf77tr9GT6CRrbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB7894
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day, dear maintainers,=0A=
=0A=
We found a bug using a modified kernel configuration file used by syzbot.=
=0A=
=0A=
We enhanced the coverage of the configuration file using our tool, klocaliz=
er.=0A=
=0A=
Kernel Branch: 6.2.0-rc6-next-20230131=0A=
Kernel config:=A0https://drive.google.com/file/d/1mvxgbYKz5x6HQqwa_NUGDe0Nx=
UVuZN4W/view?usp=3Dsharing=0A=
Unfortunately, we do not have a reproducer yet.=0A=
=0A=
Thank you!=0A=
=0A=
Best regards,=0A=
Sanan Hasanov=0A=
=0A=
ieee802154 phy0 wpan0: encryption failed: -22=0A=
ieee802154 phy1 wpan1: encryption failed: -22=0A=
------------[ cut here ]------------=0A=
HSR: Could not send supervision frame=0A=
WARNING: CPU: 7 PID: 19728 at net/hsr/hsr_device.c:294 send_hsr_supervision=
_frame+0x633/0x850=0A=
Modules linked in:=0A=
CPU: 7 PID: 19728 Comm: kworker/7:13 Not tainted 6.2.0-rc6-next-20230131+ #=
1=0A=
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/=
2014=0A=
Workqueue: events fill_page_cache_func=0A=
RIP: 0010:send_hsr_supervision_frame+0x633/0x850=0A=
Code: 03 31 ff 89 de e8 ed f6 0d f9 84 db 0f 85 f8 fe ff ff e8 00 fc 0d f9 =
48 c7 c7 e0 19 a6 89 c6 05 d3 e2 06 03 01 e8 dd d6 d4 f8 <0f> 0b e9 d9 fe f=
f ff e8 e1 fb 0d f9 bb 3c 00 00 00 ba 01 00 00 00=0A=
RSP: 0018:ffff88811a589c00 EFLAGS: 00010282=0A=
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000100=0A=
RDX: ffff88804e384280 RSI: ffffffff816e1977 RDI: ffffffff816d7cb1=0A=
RBP: ffff88811a589c40 R08: 0000000000000005 R09: 0000000000000000=0A=
R10: 0000000000000101 R11: 0000000000000001 R12: ffff88811a589c70=0A=
R13: ffff888117075000 R14: 0000000000000000 R15: 0000000000000017=0A=
FS:  0000000000000000(0000) GS:ffff88811a580000(0000) knlGS:000000000000000=
0=0A=
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
CR2: 00007fdbbd596438 CR3: 0000000057318000 CR4: 0000000000350ee0=0A=
Call Trace:=0A=
 <IRQ>=0A=
 hsr_announce+0x122/0x390=0A=
 call_timer_fn+0x1fa/0x840=0A=
 __run_timers.part.0+0x6bf/0x950=0A=
 run_timer_softirq+0xb7/0x1b0=0A=
 __do_softirq+0x306/0xb22=0A=
 __irq_exit_rcu+0x196/0x230=0A=
 irq_exit_rcu+0xd/0x30=0A=
 sysvec_apic_timer_interrupt+0xa5/0xc0=0A=
 </IRQ>=0A=
 <TASK>=0A=
 asm_sysvec_apic_timer_interrupt+0x1f/0x30=0A=
RIP: 0010:_raw_spin_unlock_irq+0x52/0x90=0A=
Code: c7 c0 a0 4c 77 8a 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 =
00 75 38 48 83 3d 16 6e e9 01 00 74 25 fb 0f 1f 44 00 00 <bf> 01 00 00 00 e=
8 34 19 d0 f8 65 8b 05 e5 e8 75 77 85 c0 74 0c 4c=0A=
RSP: 0018:ffff888027787310 EFLAGS: 00000282=0A=
RAX: 1ffffffff14ee994 RBX: 0000000000000020 RCX: 1ffffffff1a9fcce=0A=
RDX: dffffc0000000000 RSI: 0000000000000001 RDI: 0000000000000000=0A=
RBP: ffff888027787318 R08: 0000000000000001 R09: ffffffff8d4f64d7=0A=
R10: fffffbfff1a9ec9a R11: 0000000000000001 R12: ffff88810083a050=0A=
R13: ffff8880277878a0 R14: ffff8880277874d8 R15: 0000000000000000=0A=
 shrink_lruvec+0xd19/0x2770=0A=
 shrink_node+0x8f2/0x1ed0=0A=
 do_try_to_free_pages+0x3ff/0x18c0=0A=
 try_to_free_pages+0x348/0xa20=0A=
 __alloc_pages_slowpath.constprop.0+0xa0c/0x2590=0A=
 __alloc_pages+0x51c/0x6e0=0A=
 alloc_pages+0x1a5/0x260=0A=
 __get_free_pages+0x10/0x50=0A=
 fill_page_cache_func+0xae/0x240=0A=
 process_one_work+0xa2d/0x1940=0A=
 worker_thread+0x674/0x10b0=0A=
 kthread+0x306/0x3d0=0A=
 ret_from_fork+0x2c/0x50=0A=
 </TASK>=0A=
irq event stamp: 727444=0A=
hardirqs last  enabled at (727454): [<ffffffff816d7284>] __up_console_sem+0=
xf4/0x180=0A=
hardirqs last disabled at (727463): [<ffffffff816d7269>] __up_console_sem+0=
xd9/0x180=0A=
softirqs last  enabled at (725494): [<ffffffff81534006>] __irq_exit_rcu+0x1=
96/0x230=0A=
softirqs last disabled at (726425): [<ffffffff81534006>] __irq_exit_rcu+0x1=
96/0x230=0A=
---[ end trace 0000000000000000 ]---=0A=
ICMPv6: ndisc: ndisc_alloc_skb failed to allocate an skb=0A=
loop6: detected capacity change from 0 to 128=0A=
EXT4-fs (loop6): mounted filesystem 76b65be2-f6da-4727-8c75-0525a5b65a09 wi=
thout journal. Quota mode: none.=0A=
ext4 filesystem being mounted at /syzkaller-testdir455853457/syzkaller.BkvI=
xk/371/mnt supports timestamps until 2038 (0x7fffffff)=0A=
----------------=0A=
Code disassembly (best guess):=0A=
   0:	c7 c0 a0 4c 77 8a    	mov    $0x8a774ca0,%eax=0A=
   6:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx=0A=
   d:	fc ff df=0A=
  10:	48 c1 e8 03          	shr    $0x3,%rax=0A=
  14:	80 3c 10 00          	cmpb   $0x0,(%rax,%rdx,1)=0A=
  18:	75 38                	jne    0x52=0A=
  1a:	48 83 3d 16 6e e9 01 	cmpq   $0x0,0x1e96e16(%rip)        # 0x1e96e38=
=0A=
  21:	00=0A=
  22:	74 25                	je     0x49=0A=
  24:	fb                   	sti=0A=
  25:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)=0A=
* 2a:	bf 01 00 00 00       	mov    $0x1,%edi <-- trapping instruction=0A=
  2f:	e8 34 19 d0 f8       	call   0xf8d01968=0A=
  34:	65 8b 05 e5 e8 75 77 	mov    %gs:0x7775e8e5(%rip),%eax        # 0x777=
5e920=0A=
  3b:	85 c0                	test   %eax,%eax=0A=
  3d:	74 0c                	je     0x4b=0A=
  3f:	4c                   	rex.WR=0A=
=0A=
