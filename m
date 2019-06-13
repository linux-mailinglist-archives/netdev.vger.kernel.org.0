Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174AE44D34
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfFMUPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:15:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726855AbfFMUPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 16:15:31 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DKAwuw010723;
        Thu, 13 Jun 2019 13:15:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YnVyZ1hQwp5C/WnJoo9Yn+RT/QB9zaTBcYsIS0MGsJE=;
 b=FTJ1wKF9yxu+kGzZsU1Wns5UhsdT/bQUj4Rdi08LFgj9bP+GmAqLi8f1M2TzEIT3tRUo
 v7U1Fmryd2UVcLkfUUY9312HIdeSYr4dpwjTdnGbFYByKhMY3nEQQfidTqqMii+kTyg2
 ee/zv93z0dNKr0W/ZLIUR9fEmbllvyldquo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3pashn1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 13:15:02 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 13 Jun 2019 13:15:00 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 13 Jun 2019 13:15:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnVyZ1hQwp5C/WnJoo9Yn+RT/QB9zaTBcYsIS0MGsJE=;
 b=iNHpzdlYhDGrRNPChH+FldnK7mxkYgd2cSh9wy9LFatJjt/Rsoe4C25DU9SoG8dYEukFmNGdIugzdoYU9BQ8TS9dWhjXus0mtXpwIuLscvMCXMrC7NI/t3PgD5M2m4HQjm4YUGRDdAgllT2Xl4FRiNeLNzt1UzW07jDtiEob+5I=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1663.namprd15.prod.outlook.com (10.175.141.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 20:14:59 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 20:14:59 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Arthur Fabre <afabre@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: sk_storage: Fix out of bounds memory access
Thread-Topic: [PATCH bpf-next] bpf: sk_storage: Fix out of bounds memory
 access
Thread-Index: AQHVIetyB27HX7/RZ0OWVcircfV4UqaZ02YAgAAyGoA=
Date:   Thu, 13 Jun 2019 20:14:59 +0000
Message-ID: <20190613201457.hv5z3pbi46z2cfwn@kafai-mbp.dhcp.thefacebook.com>
References: <20190613132433.17213-1-afabre@cloudflare.com>
 <CAEf4BzYp0ZtbojxP++GYsc097RpoLBb08Aj7NM0s+GoM7RpvXg@mail.gmail.com>
In-Reply-To: <CAEf4BzYp0ZtbojxP++GYsc097RpoLBb08Aj7NM0s+GoM7RpvXg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0017.namprd14.prod.outlook.com
 (2603:10b6:300:ae::27) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:857]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c259dfd8-b067-4ab2-a2aa-08d6f03bcf29
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1663;
x-ms-traffictypediagnostic: MWHPR15MB1663:
x-microsoft-antispam-prvs: <MWHPR15MB1663848D8A150F60B4942AA0D5EF0@MWHPR15MB1663.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(39860400002)(376002)(136003)(189003)(199004)(14454004)(6916009)(25786009)(476003)(11346002)(446003)(4326008)(6246003)(386003)(5660300002)(6506007)(53546011)(99286004)(46003)(478600001)(2906002)(52116002)(45080400002)(6436002)(6486002)(71190400001)(229853002)(76176011)(71200400001)(53936002)(316002)(86362001)(305945005)(9686003)(6512007)(54906003)(186003)(8936002)(102836004)(7736002)(1076003)(66476007)(66446008)(64756008)(81166006)(73956011)(66556008)(6116002)(256004)(8676002)(14444005)(486006)(81156014)(66946007)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1663;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X9NFRxBRK8WcsCObelXbQtJe8K6OSrk2C7Xd1088tnLqGOfqzRnxb8x0zcXkf7MiYA44Nesg4LLLZP3VyBPIZWC9UmCL8/gCrwmncKEZ2Cr7IaWMcQkERC3NTrfKbKze3CAKo+rZhPAHx/R06Dm8PlmwpVwwdBMsoys9+NLzL8I2L6gcpASBBEosjmqgltApQJUUHjjB3YGMiuSV8Ae7VWBUkp4+IHtsKdYFM8MNI4Izmj86JcKBu5woXjXQ1DxFmsS55o7e9d6jgPhrT8p4bLXrutVJVvjCcRtWDARoMMV0cPAL12EwxeVO/+mHC7sb4qYtcV8VHt403FJ3faU16h3qTudQjf7TPQdCIswEL1TCTQgJ9BQZA+3mNKJS/TYM8XbNB4K348mSw4iP76SfJ/RTvf9rioIHxHm2GTPqDwY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <086A11AC96104241A27151038F1B3148@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c259dfd8-b067-4ab2-a2aa-08d6f03bcf29
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 20:14:59.7349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1663
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=721 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 10:15:38AM -0700, Andrii Nakryiko wrote:
> On Thu, Jun 13, 2019 at 8:16 AM Arthur Fabre <afabre@cloudflare.com> wrot=
e:
> >
> > bpf_sk_storage maps use multiple spin locks to reduce contention.
> > The number of locks to use is determined by the number of possible CPUs=
.
> > With only 1 possible CPU, bucket_log =3D=3D 0, and 2^0 =3D 1 locks are =
used.
Thanks for report.

> >
> > When updating elements, the correct lock is determined with hash_ptr().
> > Calling hash_ptr() with 0 bits is undefined behavior, as it does:
> >
> > x >> (64 - bits)
> >
> > Using the value results in an out of bounds memory access.
> > In my case, this manifested itself as a page fault when raw_spin_lock_b=
h()
> > is called later, when running the self tests:
> >
> > ./tools/testing/selftests/bpf/test_verifier 773 775
> >
> > [   16.366342] BUG: unable to handle page fault for address: ffff8fe7a6=
6f93f8
> > [   16.367139] #PF: supervisor write access in kernel mode
> > [   16.367751] #PF: error_code(0x0002) - not-present page
> > [   16.368323] PGD 35a01067 P4D 35a01067 PUD 0
> > [   16.368796] Oops: 0002 [#1] SMP PTI
> > [   16.369175] CPU: 0 PID: 189 Comm: test_verifier Not tainted 5.2.0-rc=
2+ #10
> > [   16.369960] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS 1.12.0-1 04/01/2014
> > [   16.371021] RIP: 0010:_raw_spin_lock_bh (/home/afabre/linux/./includ=
e/trace/events/initcall.h:48)
> > [ 16.371571] Code: 02 00 00 31 c0 ba ff 00 00 00 3e 0f b1 17 75 01 c3 e=
9 82 12 5f ff 66 90 65 81 05 ad 14 6f 41 00 02 00 00 31 c0 ba 01 00 00 00 <=
3e> 0f b1 17 75 01 c3 89 c6 e9 f0 02 5f ff b8 00 02 00 00 3e 0f c1
> > All code
> > =3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   02 00                   add    (%rax),%al
> >    2:   00 31                   add    %dh,(%rcx)
> >    4:   c0 ba ff 00 00 00 3e    sarb   $0x3e,0xff(%rdx)
> >    b:   0f b1 17                cmpxchg %edx,(%rdi)
> >    e:   75 01                   jne    0x11
> >   10:   c3                      retq
> >   11:   e9 82 12 5f ff          jmpq   0xffffffffff5f1298
> >   16:   66 90                   xchg   %ax,%ax
> >   18:   65 81 05 ad 14 6f 41    addl   $0x200,%gs:0x416f14ad(%rip)     =
   # 0x416f14d0
> >   1f:   00 02 00 00
> >   23:   31 c0                   xor    %eax,%eax
> >   25:   ba 01 00 00 00          mov    $0x1,%edx
> >   2a:   3e 0f b1 17             cmpxchg %edx,%ds:*(%rdi)               =
 <-- trapping instruction
> >   2e:   75 01                   jne    0x31
> >   30:   c3                      retq
> >   31:   89 c6                   mov    %eax,%esi
> >   33:   e9 f0 02 5f ff          jmpq   0xffffffffff5f0328
> >   38:   b8 00 02 00 00          mov    $0x200,%eax
> >   3d:   3e                      ds
> >   3e:   0f                      .byte 0xf
> >   3f:   c1                      .byte 0xc1
> >
> > Code starting with the faulting instruction
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   3e 0f b1 17             cmpxchg %edx,%ds:(%rdi)
> >    4:   75 01                   jne    0x7
> >    6:   c3                      retq
> >    7:   89 c6                   mov    %eax,%esi
> >    9:   e9 f0 02 5f ff          jmpq   0xffffffffff5f02fe
> >    e:   b8 00 02 00 00          mov    $0x200,%eax
> >   13:   3e                      ds
> >   14:   0f                      .byte 0xf
> >   15:   c1                      .byte 0xc1
> > [   16.373398] RSP: 0018:ffffa759809d3be0 EFLAGS: 00010246
> > [   16.373954] RAX: 0000000000000000 RBX: ffff8fe7a66f93f0 RCX: 0000000=
000000040
> > [   16.374645] RDX: 0000000000000001 RSI: ffff8fdaf9f0d180 RDI: ffff8fe=
7a66f93f8
> > [   16.375338] RBP: ffff8fdaf9f0d180 R08: ffff8fdafba2c320 R09: ffff8fd=
af9f0d0c0
> > [   16.376028] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8fd=
afa346700
> > [   16.376719] R13: ffff8fe7a66f93f8 R14: ffff8fdaf9f0d0c0 R15: 0000000=
000000001
> > [   16.377413] FS:  00007fda724c0740(0000) GS:ffff8fdafba00000(0000) kn=
lGS:0000000000000000
> > [   16.378204] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   16.378763] CR2: ffff8fe7a66f93f8 CR3: 0000000139d1c006 CR4: 0000000=
000360ef0
> > [   16.379453] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [   16.380144] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [   16.380864] Call Trace:
> > [   16.381112] selem_link_map (/home/afabre/linux/./include/linux/compi=
ler.h:221 /home/afabre/linux/net/core/bpf_sk_storage.c:243)
> > [   16.381476] sk_storage_update (/home/afabre/linux/net/core/bpf_sk_st=
orage.c:355 /home/afabre/linux/net/core/bpf_sk_storage.c:414)
> > [   16.381888] bpf_sk_storage_get (/home/afabre/linux/net/core/bpf_sk_s=
torage.c:760 /home/afabre/linux/net/core/bpf_sk_storage.c:741)
> > [   16.382285] ___bpf_prog_run (/home/afabre/linux/kernel/bpf/core.c:14=
47)
> > [   16.382679] ? __bpf_prog_run32 (/home/afabre/linux/kernel/bpf/core.c=
:1603)
> > [   16.383074] ? alloc_file_pseudo (/home/afabre/linux/fs/file_table.c:=
232)
> > [   16.383486] ? kvm_clock_get_cycles (/home/afabre/linux/arch/x86/kern=
el/kvmclock.c:98)
> > [   16.383906] ? ktime_get (/home/afabre/linux/kernel/time/timekeeping.=
c:265 /home/afabre/linux/kernel/time/timekeeping.c:369 /home/afabre/linux/k=
ernel/time/timekeeping.c:754)
> > [   16.384243] ? bpf_test_run (/home/afabre/linux/net/bpf/test_run.c:47=
)
> > [   16.384613] ? bpf_prog_test_run_skb (/home/afabre/linux/net/bpf/test=
_run.c:313)
> > [   16.385065] ? security_capable (/home/afabre/linux/security/security=
.c:696 (discriminator 19))
> > [   16.385460] ? __do_sys_bpf (/home/afabre/linux/kernel/bpf/syscall.c:=
2072 /home/afabre/linux/kernel/bpf/syscall.c:2848)
> > [   16.385854] ? __handle_mm_fault (/home/afabre/linux/mm/memory.c:3507=
 /home/afabre/linux/mm/memory.c:3532 /home/afabre/linux/mm/memory.c:3666 /h=
ome/afabre/linux/mm/memory.c:3897 /home/afabre/linux/mm/memory.c:4021)
> > [   16.386273] ? __dentry_kill (/home/afabre/linux/fs/dcache.c:595)
> > [   16.386652] ? do_syscall_64 (/home/afabre/linux/arch/x86/entry/commo=
n.c:301)
> > [   16.387031] ? entry_SYSCALL_64_after_hwframe (/home/afabre/linux/./i=
nclude/trace/events/initcall.h:10 /home/afabre/linux/./include/trace/events=
/initcall.h:10)
> > [   16.387541] Modules linked in:
> > [   16.387846] CR2: ffff8fe7a66f93f8
> > [   16.388175] ---[ end trace 891cf27b5b9c9cc6 ]---
> > [   16.388628] RIP: 0010:_raw_spin_lock_bh (/home/afabre/linux/./includ=
e/trace/events/initcall.h:48)
> > [ 16.389089] Code: 02 00 00 31 c0 ba ff 00 00 00 3e 0f b1 17 75 01 c3 e=
9 82 12 5f ff 66 90 65 81 05 ad 14 6f 41 00 02 00 00 31 c0 ba 01 00 00 00 <=
3e> 0f b1 17 75 01 c3 89 c6 e9 f0 02 5f ff b8 00 02 00 00 3e 0f c1
> > All code
> > =3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   02 00                   add    (%rax),%al
> >    2:   00 31                   add    %dh,(%rcx)
> >    4:   c0 ba ff 00 00 00 3e    sarb   $0x3e,0xff(%rdx)
> >    b:   0f b1 17                cmpxchg %edx,(%rdi)
> >    e:   75 01                   jne    0x11
> >   10:   c3                      retq
> >   11:   e9 82 12 5f ff          jmpq   0xffffffffff5f1298
> >   16:   66 90                   xchg   %ax,%ax
> >   18:   65 81 05 ad 14 6f 41    addl   $0x200,%gs:0x416f14ad(%rip)     =
   # 0x416f14d0
> >   1f:   00 02 00 00
> >   23:   31 c0                   xor    %eax,%eax
> >   25:   ba 01 00 00 00          mov    $0x1,%edx
> >   2a:   3e 0f b1 17             cmpxchg %edx,%ds:*(%rdi)               =
 <-- trapping instruction
> >   2e:   75 01                   jne    0x31
> >   30:   c3                      retq
> >   31:   89 c6                   mov    %eax,%esi
> >   33:   e9 f0 02 5f ff          jmpq   0xffffffffff5f0328
> >   38:   b8 00 02 00 00          mov    $0x200,%eax
> >   3d:   3e                      ds
> >   3e:   0f                      .byte 0xf
> >   3f:   c1                      .byte 0xc1
> >
> > Code starting with the faulting instruction
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   3e 0f b1 17             cmpxchg %edx,%ds:(%rdi)
> >    4:   75 01                   jne    0x7
> >    6:   c3                      retq
> >    7:   89 c6                   mov    %eax,%esi
> >    9:   e9 f0 02 5f ff          jmpq   0xffffffffff5f02fe
> >    e:   b8 00 02 00 00          mov    $0x200,%eax
> >   13:   3e                      ds
> >   14:   0f                      .byte 0xf
> >   15:   c1                      .byte 0xc1
> > [   16.390899] RSP: 0018:ffffa759809d3be0 EFLAGS: 00010246
> > [   16.391410] RAX: 0000000000000000 RBX: ffff8fe7a66f93f0 RCX: 0000000=
000000040
> > [   16.392102] RDX: 0000000000000001 RSI: ffff8fdaf9f0d180 RDI: ffff8fe=
7a66f93f8
> > [   16.392795] RBP: ffff8fdaf9f0d180 R08: ffff8fdafba2c320 R09: ffff8fd=
af9f0d0c0
> > [   16.393481] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8fd=
afa346700
> > [   16.394169] R13: ffff8fe7a66f93f8 R14: ffff8fdaf9f0d0c0 R15: 0000000=
000000001
> > [   16.394870] FS:  00007fda724c0740(0000) GS:ffff8fdafba00000(0000) kn=
lGS:0000000000000000
> > [   16.395641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   16.396193] CR2: ffff8fe7a66f93f8 CR3: 0000000139d1c006 CR4: 0000000=
000360ef0
> > [   16.396876] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [   16.397557] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [   16.398246] Kernel panic - not syncing: Fatal exception in interrupt
> > [   16.399067] Kernel Offset: 0x3ce00000 from 0xffffffff81000000 (reloc=
ation range: 0xffffffff80000000-0xffffffffbfffffff)
> > [   16.400098] ---[ end Kernel panic - not syncing: Fatal exception in =
interrupt ]---
> >
> > Signed-off-by: Arthur Fabre <afabre@cloudflare.com>
> > Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
> > ---
> >  net/core/bpf_sk_storage.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> > index f40e3d35fd9c..7ae0686c5418 100644
> > --- a/net/core/bpf_sk_storage.c
> > +++ b/net/core/bpf_sk_storage.c
> > @@ -90,7 +90,13 @@ struct bpf_sk_storage {
> >  static struct bucket *select_bucket(struct bpf_sk_storage_map *smap,
> >                                     struct bpf_sk_storage_elem *selem)
> >  {
> > -       return &smap->buckets[hash_ptr(selem, smap->bucket_log)];
> > +       /* hash_ptr is undefined behavior with 0 bits */
> > +       int bucket =3D 0;
> > +       if (smap->bucket_log !=3D 0) {
> > +               bucket =3D hash_ptr(selem, smap->bucket_log);
> > +       }
>=20
> Would it be better instead to make sure that bucket_log is always at
> least 1? Having bucket_log as zero can bite us in the future again.
I also think it is better off to have a max_t(u32, 1, ...) done in
bpf_sk_storage_map_alloc().  Having an extra bucket should be fine in
this case.

>=20
> > +
> > +       return &smap->buckets[bucket];
> >  }
> >
> >  static int omem_charge(struct sock *sk, unsigned int size)
> > --
> > 2.20.1
> >
