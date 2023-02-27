Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86926A3B48
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 07:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjB0GeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 01:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB0GeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 01:34:21 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0940ECC07;
        Sun, 26 Feb 2023 22:34:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJ1F4u2goi2wMQAgJn6gPvimqF1a8oVckUV5ocqv8WHT+xf+8AkZK0HjGBg97VMKqy/pTdANuvQwqvYPXHLKhNIf6kBFeljMn5IgcsNyx5NYFdj8N/Hi3x1LO44Q9XG8IU44m8U1q8+kpCbdvPGikKuFGSGTYBoasfLFSFQ0s1odQag9c5U9d6FsIbTUBOccFKYnVsAFGFNobqFniK89iCFLTU5w61oqQnPxH+ySamxW8fiIU3o0sEsqZdKKXy+WMSdZqIacHcEmn0kVVaWQsX5PX6fH/nSlMWQ9vdKX44rSJZCt0RvSMggxszlGqbybky1jti/pfQSuVvQuF3t3IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2jTRgDy6HNGLQ46JG8bhaQwsiZ56rFsTe7Rivz1sd4=;
 b=OREh8mucmDMX9yNTtbCDPiv10iRxJUe6Y96jkVylE9p1FWmtgotZpm8qRFFehwx5zJEpDBVcmKe0bvxVE55qDoHOWG0F2Arzk56KcUB0FFuU2NKqTh61oxRsBLbWEKX8QTII3ygs2sGjTgUKQTpcWgCfIA4H9DdTg38HvjUqRZ6KUH9VewEFnx3YiIi1l9bPWqyr5I7aeQrxPgNMbpd7LJK7UaHxG9ZTlAO8wWtVGhvpW2JXmcK2r7h/TFguhvRavUkNE6m0GMpMF4eXaf1l4SvKfur5a7x6iuHeF/A0tpbBZv8TbCa22ShbJHJoAg0VxkUGMCe6KIAcCX2ydO9k1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=knights.ucf.edu; dmarc=pass action=none
 header.from=knights.ucf.edu; dkim=pass header.d=knights.ucf.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=knightsucfedu39751.onmicrosoft.com;
 s=selector2-knightsucfedu39751-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2jTRgDy6HNGLQ46JG8bhaQwsiZ56rFsTe7Rivz1sd4=;
 b=Dm8XCGLBlmnzT7Cnjmf8UAuyw3aE8rP8qP5R3EfjpzrBYmTE1njRXNAMvTBtHiPAc6rw9BKJJUL+NjPQ73vQzs3W/vGac7Of1DEN8gTVdPi8iL/M1qzT6DKDV5SoJX9a0FzqS9xiD2ehrdc71eTWkNEab9Yx9YtH6cSRs7knKg0=
Received: from IA1PR07MB9830.namprd07.prod.outlook.com (2603:10b6:208:44b::14)
 by SJ0PR07MB8584.namprd07.prod.outlook.com (2603:10b6:a03:371::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 06:34:15 +0000
Received: from IA1PR07MB9830.namprd07.prod.outlook.com
 ([fe80::d883:f078:37f:dace]) by IA1PR07MB9830.namprd07.prod.outlook.com
 ([fe80::d883:f078:37f:dace%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 06:34:15 +0000
From:   Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
To:     "alex.aring@gmail.com" <alex.aring@gmail.com>,
        "stefan@datenfreihafen.org" <stefan@datenfreihafen.org>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "contact@pgazz.com" <contact@pgazz.com>
Subject: general protection fault in nl802154_trigger_scan
Thread-Topic: general protection fault in nl802154_trigger_scan
Thread-Index: AQHZSm/2aDWAs9JcO0O7fV0iUpc7eg==
Date:   Mon, 27 Feb 2023 06:34:15 +0000
Message-ID: <IA1PR07MB98302CDCC21F6BA664FB7298ABAF9@IA1PR07MB9830.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=Knights.ucf.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR07MB9830:EE_|SJ0PR07MB8584:EE_
x-ms-office365-filtering-correlation-id: 991b44f8-15f5-45cb-87a7-08db188ca5a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ONCP/SrOWiXuFW4TG2AFNs2baLiRfXpptAfDakyiMD609TbIS1MV5kA+W0kTXFJB7DxjmJmGYDq3WTmzyipqdELYs8CmobOIYJujKiGmHnFQUdNOcHAgS5ignizBO2k4JPlbb2OtHVfyfqW0Xm0OhcgxvUdFaFSIWbL5jvDkHkegtvjEqXdpHQ2ohL1rsk2pMwxBjTt94laGe9sSM8ZUvracaGY2fo83OFR7B7alQ5d6ZD/Ym05Rtdl8YBJZCVzyOSyCPYKm4f2SrzbuTawpiNhlwVK7tq0zbG7CbEHGW2Lbyo+vvvcB9HdYJOIkstOVFOfifZ6LVr/bCBCi0resNkZ9g5os97yNlv03VYzTELgf0Mu/Wp8nvlrlXR5yewL179Z+nyeqp9TUADN6hUeGl2yhO1PLz29lViPuVOauDq+cMt7QspfYeGmdrU9ZTxqQ3M05/yDBM3rf2JF2t1Y6R0QA/3vCCpFMcHBo6E2hx1UO+7T52L4BYmt23x4vSDCrXsV+w5h6wmmJT7J12gpZOqDgo7wBj9VG3iaOKsI//otuZWXg3XZNryTUalLdyTCCrBJYVHifMAEuqDcQoIBOlDIhSFvpyXjJlWizU4bex8sjsPwr7zdVQ7bqyXla+oHAIuUFtVqRbdl5leLFXP7K0Z1VfY8i1jjZrrVCtcV/jnc5KmwdLKeTAB/Y3Uh6YnU/YlC8rAuGWdAjOmyZuAltw+xA7MYZ3Pj2P6GFZ5egM8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR07MB9830.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199018)(8936002)(5660300002)(7416002)(52536014)(91956017)(71200400001)(44832011)(41300700001)(2906002)(66556008)(76116006)(66446008)(66946007)(64756008)(4326008)(8676002)(66476007)(110136005)(786003)(54906003)(316002)(478600001)(7696005)(45080400002)(966005)(6506007)(26005)(186003)(9686003)(5930299012)(86362001)(75432002)(41320700001)(83380400001)(38070700005)(921005)(33656002)(55016003)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?DSAMYQdWJrfLY0xbbUKdiPxChfdl1vMlJBJFeRAfg6L1ep59nUHWeUcmQP?=
 =?iso-8859-1?Q?F6ZybGggND3bFEDGfJaZXvkqUOKwQTHLh9HQVWrE3NbZBxErLVdigm04Cx?=
 =?iso-8859-1?Q?RASBHKh/O1lfhHchvWNyDoTV/zqUWZe1NQZiQvn5qnibntkzTBKiZgRobb?=
 =?iso-8859-1?Q?CMzz0D90PSvUW925zOj5CQBL1cB0j0MG82nNLGDZe/8ynaytjarAW0ioKI?=
 =?iso-8859-1?Q?JuFsrG2znuWUyX+A+cQJgL8CpBbsDff7lC7Wa3R/CFg8FwLHbllx5aRmII?=
 =?iso-8859-1?Q?ykKu/r1ZjQ8uDVW8qADlE15MfFw9HbCI/GUOJyyOREmz4Z8MOt7K5Mk6bF?=
 =?iso-8859-1?Q?vXAPBIqYtSBR3oV90BDLOBXOKCOCJwPcgV++QJJNCBF89RAm8JJ/HIF5Gx?=
 =?iso-8859-1?Q?XZDbwmQ3EHnRI1BgvkgC0YF0oi8+5ZaSVz2l8vYE8LbYGtLP6TzrsmYCSC?=
 =?iso-8859-1?Q?U82gnKpGSD4h6qxze5S1S2/IXmRwqGcZzOsH6LTt3avGIhzoVuzIMwnmCE?=
 =?iso-8859-1?Q?SQBmnPJogD2JykX2uidTOKpzgSPDFrfz6FJpddZKidQ0eUSUnRAR114tm8?=
 =?iso-8859-1?Q?irj49cPq6ig6Fa79c3nLqoxIB5YcHKWNDAffY7UXbi28I3J3oSJ2EtkYy3?=
 =?iso-8859-1?Q?pj4Uw5gQhKYCqLcUe4RkyHX2KlDx7vaACG5uSJlSt9sHFx3v2J5lejnnvi?=
 =?iso-8859-1?Q?1xx6luLJ5VuszMl2B6pvSNvz1O3guLUFXhOaK+Bq6olQYuAQeZoIOtBm54?=
 =?iso-8859-1?Q?XZ+GPx/mIuE1o8m5DNRJDqbs56+8DjDJE6CrAZho4jgplia9ovkoURloRN?=
 =?iso-8859-1?Q?lirlFhpBPAIS6P9sUFm0/8OoQ9Qp9mjBiAdvJdMKpLZLye6zs6raUcwqNf?=
 =?iso-8859-1?Q?D44tg0DZsNMe0OZNN12NA4c1Uno3CQWvVGwG6gDiSmI6s8nQzZzyiv2cgA?=
 =?iso-8859-1?Q?l+lfRfNYI7qxss+jZKj0RFdTdKfYnp5Ony5Xlr0I67qGxBKH5R8gkHy8F2?=
 =?iso-8859-1?Q?6pTdT9aGfdXjkHB3tGpbPqdgq7NrUrE+Oz24rb4uSaHV6ijXUKCf93UBCB?=
 =?iso-8859-1?Q?BA/fGp6QuYEWus2whIVm3TH6fxkxVzlWIO2UHhDPxM3/7VBg4d7yJspbZs?=
 =?iso-8859-1?Q?yQPAi48aBROD2zFupIh8oJTEzrUXFY3VnTFHWka9sF+BbZvrz/xz9asCXm?=
 =?iso-8859-1?Q?e5b5i+ucYJwE1SU7SIIkW8sY6pbeHt9BotvnyIeQAq4X2vFQJ068UL0ErQ?=
 =?iso-8859-1?Q?x092Tu1DScsnTmZCU4wFDkpUAxNlMKBHczL062ztYGzrL01p40U8O/nfM5?=
 =?iso-8859-1?Q?yYXpM1NktFA65UeAHD4FiwGJVokYCRdCx+gZctedRiq3Oi6AsTb6ha7w/J?=
 =?iso-8859-1?Q?bJkOBIaIHEHmdlnd/X/Sj2uyBwN/BgSdiTCJ605WTqmdKakO8TnstqPLSG?=
 =?iso-8859-1?Q?9QIMfYhuYDoe8fjJ9NbLUjxrtMjUSzYg4tuvHBX7l/KNOVf2HxkiFQVCnh?=
 =?iso-8859-1?Q?i3C1t4Tu33o55qGB91JauKJmhU7Zxv398RuJ/cNJQ5wPaw9IWJVK/PeuDo?=
 =?iso-8859-1?Q?Wd0To/svWfHXm6cuGFGizzQHQAxO8tqGsEdchy83gTyC2LvMyY61Q2TryS?=
 =?iso-8859-1?Q?oNQL6URKc2aMN94RdBHV5AROoffnXKZZuXgDOg6N0Do4iBbzefieDQdQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: knights.ucf.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR07MB9830.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991b44f8-15f5-45cb-87a7-08db188ca5a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 06:34:15.6124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5b16e182-78b3-412c-9196-68342689eeb7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IEwvNeGdt9qd5AtVBztcFVxGL5g9DieW1ixoOcaJiBmkWCP4HjgpqS/ACTTwhAyw48wlo77KzDrme6yOkw9aDSjb72sagC+la7m8RcTOUnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB8584
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
Kernel Branch: 6.2.0-next-20230224=0A=
Kernel config:=A0https://drive.google.com/file/d/1nlVJD4vp7iMOPapFzdASZQ7JS=
iDf6SwY/view?usp=3Dshare_link=0A=
C Reproducer:=A0Unfortunately, there is no reproducer yet=0A=
=0A=
Thank you!=0A=
=0A=
Best regards,=0A=
Sanan Hasanov=0A=
=0A=
general protection fault, probably for non-canonical address 0xdffffc000000=
0000: 0000 [#1] PREEMPT SMP KASAN=0A=
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]=0A=
CPU: 4 PID: 26115 Comm: syz-executor.2 Not tainted 6.2.0-next-20230224 #1=
=0A=
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/=
2014=0A=
RIP: 0010:nl802154_trigger_scan+0x132/0xc40=0A=
Code: 48 c1 ea 03 80 3c 02 00 0f 85 e1 09 00 00 48 8b ad f8 00 00 00 48 b8 =
00 00 00 00 00 fc ff df 48 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 8=
9 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 90 07 00 00=0A=
RSP: 0018:ffffc9000b087550 EFLAGS: 00010257=0A=
RAX: dffffc0000000000 RBX: ffffc9000b0875c0 RCX: ffffc9000df9a000=0A=
RDX: 0000000000000000 RSI: ffffffff88a65a91 RDI: 0000000000000004=0A=
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000001=0A=
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88810f098c10=0A=
R13: ffff88810f050000 R14: ffff88810f0500a0 R15: ffffc9000b0875e0=0A=
FS:  00007f7b8a7fe700(0000) GS:ffff88811a200000(0000) knlGS:000000000000000=
0=0A=
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
CR2: 00007ffd3780efdc CR3: 000000004dd9e000 CR4: 0000000000350ee0=0A=
Call Trace:=0A=
 <TASK>=0A=
 genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0=0A=
 genl_rcv_msg+0x4ff/0x7e0=0A=
 netlink_rcv_skb+0x165/0x440=0A=
 genl_rcv+0x28/0x40=0A=
 netlink_unicast+0x547/0x7f0=0A=
 netlink_sendmsg+0x92f/0xe50=0A=
 sock_sendmsg+0xde/0x190=0A=
 ____sys_sendmsg+0x717/0x900=0A=
 ___sys_sendmsg+0x11d/0x1b0=0A=
 __sys_sendmsg+0xfe/0x1d0=0A=
 do_syscall_64+0x39/0x80=0A=
 entry_SYSCALL_64_after_hwframe+0x63/0xcd=0A=
RIP: 0033:0x7f7b8b88edcd=0A=
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48=0A=
RSP: 002b:00007f7b8a7fdbf8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e=0A=
RAX: ffffffffffffffda RBX: 00007f7b8b9bbf80 RCX: 00007f7b8b88edcd=0A=
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000004=0A=
RBP: 00007f7b8b8fc59c R08: 0000000000000000 R09: 0000000000000000=0A=
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000=0A=
R13: 00007ffd638e65bf R14: 00007ffd638e6760 R15: 00007f7b8a7fdd80=0A=
 </TASK>=0A=
Modules linked in:=0A=
---[ end trace 0000000000000000 ]---=0A=
RIP: 0010:nl802154_trigger_scan+0x132/0xc40=0A=
Code: 48 c1 ea 03 80 3c 02 00 0f 85 e1 09 00 00 48 8b ad f8 00 00 00 48 b8 =
00 00 00 00 00 fc ff df 48 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 8=
9 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 90 07 00 00=0A=
RSP: 0018:ffffc9000b087550 EFLAGS: 00010257=0A=
RAX: dffffc0000000000 RBX: ffffc9000b0875c0 RCX: ffffc9000df9a000=0A=
RDX: 0000000000000000 RSI: ffffffff88a65a91 RDI: 0000000000000004=0A=
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000001=0A=
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88810f098c10=0A=
R13: ffff88810f050000 R14: ffff88810f0500a0 R15: ffffc9000b0875e0=0A=
FS:  00007f7b8a7fe700(0000) GS:ffff88811a200000(0000) knlGS:000000000000000=
0=0A=
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
CR2: 00007ffd3780efdc CR3: 000000004dd9e000 CR4: 0000000000350ee0=0A=
----------------=0A=
Code disassembly (best guess):=0A=
   0:	48 c1 ea 03          	shr    $0x3,%rdx=0A=
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)=0A=
   8:	0f 85 e1 09 00 00    	jne    0x9ef=0A=
   e:	48 8b ad f8 00 00 00 	mov    0xf8(%rbp),%rbp=0A=
  15:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax=0A=
  1c:	fc ff df=0A=
  1f:	48 8d 7d 04          	lea    0x4(%rbp),%rdi=0A=
  23:	48 89 fa             	mov    %rdi,%rdx=0A=
  26:	48 c1 ea 03          	shr    $0x3,%rdx=0A=
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruct=
ion=0A=
  2e:	48 89 fa             	mov    %rdi,%rdx=0A=
  31:	83 e2 07             	and    $0x7,%edx=0A=
  34:	38 d0                	cmp    %dl,%al=0A=
  36:	7f 08                	jg     0x40=0A=
  38:	84 c0                	test   %al,%al=0A=
  3a:	0f 85 90 07 00 00    	jne    0x7d0=0A=
