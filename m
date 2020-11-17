Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661322B5F54
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 13:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgKQMqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 07:46:42 -0500
Received: from mail-eopbgr760047.outbound.protection.outlook.com ([40.107.76.47]:46318
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbgKQMqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 07:46:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+iBbr3vU2b6GptxLGOTZH6nnHNVhxZqEvcPymLbKugnKmX1yBKG8Zpt/GbMZy/odQG4uJAtEMaW6dPQsGNr3LbpMdIUIEt/f5dbd3yK+HIna5/HAvjs82+hLcZ5/JF96OFyK4Xoae/i6jfLkcx44GVYuAzoUwhBkOC5tQMQB0qiBsD0vbSQM+kgs2BHeSdBWGIcjUQLNm5QBahZlHphMWjGBDZviBe4S0H7HO68mJLi4nMco+o6Tsh0nJOTmrCLhNiH9HIgAxl7BEQsJnaUGYjmlNSdq82qWKFyaLEUJ26KecPVNeuD9s6zBdwsK4Ke0qRzCWcGlI3R1LsaIyNeOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13xhq310ClLS9mC0t/N7oe99MNGXWVTWSH1LZaOPagQ=;
 b=UKLmrrWWpI3JTxf6AEv8sxMVqpyb96jicU0PpaMVc4r7mQ+JfnEO1ClTycqKn7jpurj5+/DoAKM+ybDby/x4GsRi9PJTyck1n99+rqz5mozSjs/MAME6sYQZu6QoT7sHGN3gmxpCJmWsF3tcmXG5CcgJkAaVjBseCa6tpF/yb6j+6jesAYj8cvm5qclW+azXn4Nx4tab85r4NnxFG1g++3beDGD2fwC3YZoLOSSxdmK6gUvtkzP7o1C7dEFlfTtnDfa/wDRgReu3okM49EkgB7Nm/4lrpNrO4hsod2WuR1FMWz57MwPraX1qQfYv2xraBpaYFflPWH8/Rrm6H/56SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13xhq310ClLS9mC0t/N7oe99MNGXWVTWSH1LZaOPagQ=;
 b=BLxFhgwksBgh9dEi621EDGO2yWQ7OS5ZPf9imZYwURHa1oOp03LbB9IJtZonHb6SHB6jIzM+WHxmicdncX7xb74leno7urno7fZQ+9s2Y2DCcUbjmiEIfaYBf50dVm8XEueK3s5S+wBjKEhLh1VHUfGumwj9NbfAgRlKPsTI6SY=
Authentication-Results: lists.sourceforge.net; dkim=none (message not signed)
 header.d=none;lists.sourceforge.net; dmarc=none action=none
 header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB3480.namprd11.prod.outlook.com (2603:10b6:a03:79::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Tue, 17 Nov
 2020 12:46:38 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::adbd:559a:4a78:f09b]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::adbd:559a:4a78:f09b%6]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 12:46:38 +0000
Subject: Re: KASAN: invalid-free in p9_client_create
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+3a0f6c96e37e347c6ba9@syzkaller.appspotmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        David Miller <davem@davemloft.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        v9fs-developer@lists.sourceforge.net
References: <0000000000006ef45b05b436ddb4@google.com>
 <CACT4Y+aMw276FEUfS5+ZjJxxZqmFqM7=MnC7gWE9zn7vgha-AA@mail.gmail.com>
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <38f9ad29-36d0-da57-76f0-6a7ce4182774@windriver.com>
Date:   Tue, 17 Nov 2020 20:46:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <CACT4Y+aMw276FEUfS5+ZjJxxZqmFqM7=MnC7gWE9zn7vgha-AA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR0302CA0008.apcprd03.prod.outlook.com
 (2603:1096:202::18) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.160] (60.247.85.82) by HK2PR0302CA0008.apcprd03.prod.outlook.com (2603:1096:202::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.14 via Frontend Transport; Tue, 17 Nov 2020 12:46:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36b4f726-bb30-4830-7fd1-08d88af6d26c
X-MS-TrafficTypeDiagnostic: BYAPR11MB3480:
X-Microsoft-Antispam-PRVS: <BYAPR11MB34800E967B4BEB72D8B824EAE4E20@BYAPR11MB3480.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Occ2qDAcKi2SNtEy9TUwmzHamRhtK1Fnkwe7LRBg9hXPbWeBQn07fIsn4n7Hx4a7qBH6m0ZhX9si/fxBh6pn7TAk+SRRtTP3F6a/SNOGfbQMRcCDLcE+Gv0rTDKeK5QKWKifD3m8g5dk71SbFn+iynyzIba8XnGpes/ES4IYqMnh/f7wscIdZWQL0vsuczctkth39gb3d6wHO2jxsYuyXxujIKnavECwi9gj7diUHxvyddT63279W+weKjftuWjgd+C9dWG+0vmvvU5GJvv32ZRwO4//Fkm/5CTdlMIJXHN5KdPdJYKu9xL3xr4f8TLV6ZAnnOg6DZBAQiqj+JbgpFFmmG15MkCD42tAElOO2x0fm0LlQWzf8cIuGkXjedohYzryX/QvYV5+SdzWDIUx0VtoBQzyHF/NIG05T6wpehBdjZCPKfKAvx7lW23SPsusVf3r9G8ExnMFO1qhZT7k2/bt8it9lPGiW2+/wqNeW9rKf2gYg0CyF22ymRURcKVJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39850400004)(396003)(376002)(136003)(478600001)(956004)(83380400001)(5660300002)(86362001)(4326008)(2906002)(31696002)(316002)(2616005)(26005)(66556008)(966005)(66946007)(54906003)(6486002)(52116002)(8936002)(66476007)(186003)(16526019)(8676002)(53546011)(16576012)(36756003)(6706004)(7416002)(31686004)(6666004)(110136005)(99710200001)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Szwnn8eNufsWjKsiI7i5LiH+bOYnvk6FYHiWoYHLW6WTvLbbbj93SXmY/cRQWwBf7B43fAzW9Z0xIBrK9a54cn+EkfQU1mPI8tVS9Lfmuu0saO3Xz8oRbfwQG5GkHXbjbcdDTB1iYJ1jHiq0BjR9NSUZVpmVs/bQoAxiYrElAMC2e2IbxEnVcc4xn6dYomAj6PWcA97KDSDsrFuHlbJnR8mqTlgjdlziWxUD5EfrPk6KhNwRmk0bKtB3F3vtuTVqVFkh3gBhw0wbyiFUrGPLVQuSTq8axEiXggL2nzQRR9xY3voQr4II3UErsCLvqvUbtvB+EI5B7+Vv6xgHJYmet9Zbe+ul0DsLynLwS2teRunplkbDbMqT+z+SKETTW0/5q4MqSnc55fjhlN4ClEnFrPaxgsJfABy7BRGPWn0exLwVHnFm+fJriXJ6DH+jnArWfVzRSVgEHw6aYUqYEmSsvUWLip+oqa0des2eq01Bb/OcZ5W9AVenZYSGmWg4lMifk0TfkwB+LzBB2On8m+Z7cZ3gRl+uY0qgFi5gW8FT4HpB/c1srjRdniQik7EYFMyx34vivQicyyg8K+u4lQv4RMVFn2lGFA6vE3K5uxu/7lTTdnONQfZUyxRk/lRoaxyZ/MNKXwvscHKuskZBQCp1eQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b4f726-bb30-4830-7fd1-08d88af6d26c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 12:46:37.9633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 226diERAg40T5pkjF3RiFeCA/mng4ACatReMSZrXVVD67+j1ex2/BCrNqeeVQ9XWEc1vs8rxvrUmq6rahzplFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How about this patch? If it is appropriate, I will send a real one.

     mm/slub: fix slab double-free when release callback of sysfs trigger

     Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>

diff --git a/mm/slub.c b/mm/slub.c
index 4148235ba554..d10c4fbf8c84 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5653,7 +5653,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
         s->kobj.kset = kset;
         err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", 
name);
         if (err) {
-               kobject_put(&s->kobj);
+               kfree_const(&s->kobj.name);
                 goto out;
         }
----------------------------------------------------------
Because a previous patch dde3c6b7(mm/slub: fix a memory leak in 
sysfs_slab_add()) added a kobject_put() in the error path of 
kobject_init_and_add(). It results the release callback of sysfs, which 
is kmem_cache_release(), is triggered when get into the error path.

However, we will also free the 'kmem_cache' and 'kmem_cache_node' and 
'kmem_cache->name' at the error path of create_cache() when 
kobject_init_and_add() returns failure. That makes double-free.

About the patch which introduced this issue, I think we could fix it by 
freeing the leaked memory directly instead of adding kobject_put（）.

Regards,
Yanfei



On 11/16/20 7:11 PM, Dmitry Vyukov wrote:
> [Please note this e-mail is from an EXTERNAL e-mail address]
> 
> On Mon, Nov 16, 2020 at 11:30 AM syzbot
> <syzbot+3a0f6c96e37e347c6ba9@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    92edc4ae Add linux-next specific files for 20201113
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=142f8816500000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=79ad4f8ad2d96176
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3a0f6c96e37e347c6ba9
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+3a0f6c96e37e347c6ba9@syzkaller.appspotmail.com
> 
> Looks like a real double free in slab code. +MM maintainers
> Note there was a preceding kmalloc failure in sysfs_slab_add.
> 
> 
>> RBP: 00007fa358076ca0 R08: 0000000020000080 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000001f
>> R13: 00007fff7dcf224f R14: 00007fa3580779c0 R15: 000000000118bf2c
>> kobject_add_internal failed for 9p-fcall-cache (error: -12 parent: slab)
>> ==================================================================
>> BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3157 [inline]
>> BUG: KASAN: double-free or invalid-free in kmem_cache_free+0x82/0x350 mm/slub.c:3173
>>
>> CPU: 0 PID: 15981 Comm: syz-executor.5 Not tainted 5.10.0-rc3-next-20201113-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:79 [inline]
>>   dump_stack+0x107/0x163 lib/dump_stack.c:120
>>   print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
>>   kasan_report_invalid_free+0x51/0x80 mm/kasan/report.c:355
>>   ____kasan_slab_free+0x100/0x110 mm/kasan/common.c:352
>>   kasan_slab_free include/linux/kasan.h:194 [inline]
>>   slab_free_hook mm/slub.c:1548 [inline]
>>   slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1586
>>   slab_free mm/slub.c:3157 [inline]
>>   kmem_cache_free+0x82/0x350 mm/slub.c:3173
>>   create_cache mm/slab_common.c:274 [inline]
>>   kmem_cache_create_usercopy+0x2ab/0x300 mm/slab_common.c:357
>>   p9_client_create+0xc4d/0x10c0 net/9p/client.c:1063
>>   v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
>>   v9fs_mount+0x79/0x9b0 fs/9p/vfs_super.c:126
>>   legacy_get_tree+0x105/0x220 fs/fs_context.c:592
>>   vfs_get_tree+0x89/0x2f0 fs/super.c:1549
>>   do_new_mount fs/namespace.c:2896 [inline]
>>   path_mount+0x12ae/0x1e70 fs/namespace.c:3227
>>   do_mount fs/namespace.c:3240 [inline]
>>   __do_sys_mount fs/namespace.c:3448 [inline]
>>   __se_sys_mount fs/namespace.c:3425 [inline]
>>   __x64_sys_mount+0x27f/0x300 fs/namespace.c:3425
>>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x45deb9
>> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007fa358076c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
>> RAX: ffffffffffffffda RBX: 0000000000021800 RCX: 000000000045deb9
>> RDX: 0000000020000100 RSI: 0000000020000040 RDI: 0000000000000000
>> RBP: 00007fa358076ca0 R08: 0000000020000080 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000001f
>> R13: 00007fff7dcf224f R14: 00007fa3580779c0 R15: 000000000118bf2c
>>
>> Allocated by task 15981:
>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:39
>>   kasan_set_track mm/kasan/common.c:47 [inline]
>>   set_alloc_info mm/kasan/common.c:403 [inline]
>>   ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:434
>>   kasan_slab_alloc include/linux/kasan.h:211 [inline]
>>   slab_post_alloc_hook mm/slab.h:512 [inline]
>>   slab_alloc_node mm/slub.c:2903 [inline]
>>   slab_alloc mm/slub.c:2911 [inline]
>>   kmem_cache_alloc+0x12a/0x470 mm/slub.c:2916
>>   kmem_cache_zalloc include/linux/slab.h:672 [inline]
>>   create_cache mm/slab_common.c:251 [inline]
>>   kmem_cache_create_usercopy+0x1a6/0x300 mm/slab_common.c:357
>>   p9_client_create+0xc4d/0x10c0 net/9p/client.c:1063
>>   v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
>>   v9fs_mount+0x79/0x9b0 fs/9p/vfs_super.c:126
>>   legacy_get_tree+0x105/0x220 fs/fs_context.c:592
>>   vfs_get_tree+0x89/0x2f0 fs/super.c:1549
>>   do_new_mount fs/namespace.c:2896 [inline]
>>   path_mount+0x12ae/0x1e70 fs/namespace.c:3227
>>   do_mount fs/namespace.c:3240 [inline]
>>   __do_sys_mount fs/namespace.c:3448 [inline]
>>   __se_sys_mount fs/namespace.c:3425 [inline]
>>   __x64_sys_mount+0x27f/0x300 fs/namespace.c:3425
>>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Freed by task 15981:
>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:39
>>   kasan_set_track+0x1c/0x30 mm/kasan/common.c:47
>>   kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:359
>>   ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:373
>>   kasan_slab_free include/linux/kasan.h:194 [inline]
>>   slab_free_hook mm/slub.c:1548 [inline]
>>   slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1586
>>   slab_free mm/slub.c:3157 [inline]
>>   kmem_cache_free+0x82/0x350 mm/slub.c:3173
>>   kobject_cleanup lib/kobject.c:705 [inline]
>>   kobject_release lib/kobject.c:736 [inline]
>>   kref_put include/linux/kref.h:65 [inline]
>>   kobject_put+0x1c8/0x540 lib/kobject.c:753
>>   sysfs_slab_add+0x164/0x1d0 mm/slub.c:5656
>>   __kmem_cache_create+0x471/0x5a0 mm/slub.c:4476
>>   create_cache mm/slab_common.c:262 [inline]
>>   kmem_cache_create_usercopy+0x1ed/0x300 mm/slab_common.c:357
>>   p9_client_create+0xc4d/0x10c0 net/9p/client.c:1063
>>   v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
>>   v9fs_mount+0x79/0x9b0 fs/9p/vfs_super.c:126
>>   legacy_get_tree+0x105/0x220 fs/fs_context.c:592
>>   vfs_get_tree+0x89/0x2f0 fs/super.c:1549
>>   do_new_mount fs/namespace.c:2896 [inline]
>>   path_mount+0x12ae/0x1e70 fs/namespace.c:3227
>>   do_mount fs/namespace.c:3240 [inline]
>>   __do_sys_mount fs/namespace.c:3448 [inline]
>>   __se_sys_mount fs/namespace.c:3425 [inline]
>>   __x64_sys_mount+0x27f/0x300 fs/namespace.c:3425
>>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> The buggy address belongs to the object at ffff888013a45b40
>>   which belongs to the cache kmem_cache of size 224
>> The buggy address is located 0 bytes inside of
>>   224-byte region [ffff888013a45b40, ffff888013a45c20)
>> The buggy address belongs to the page:
>> page:00000000cfbbc7ff refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888013a45c80 pfn:0x13a45
>> flags: 0xfff00000000200(slab)
>> raw: 00fff00000000200 dead000000000100 dead000000000122 ffff888010041000
>> raw: ffff888013a45c80 00000000800c0004 00000001ffffffff 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>   ffff888013a45a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>   ffff888013a45a80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>>> ffff888013a45b00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>>                                             ^
>>   ffff888013a45b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>   ffff888013a45c00: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
>> ==================================================================
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000006ef45b05b436ddb4%40google.com.
