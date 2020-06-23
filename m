Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3E3204D3D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731894AbgFWJBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:01:54 -0400
Received: from mail-dm6nam11on2058.outbound.protection.outlook.com ([40.107.223.58]:56918
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731756AbgFWJBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 05:01:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqOt80mFz87aN1v4WXs9VEDRrINjV6zXfasz6N+8y51BAPa3jPKDQ5YU+Ln9Y963yWyUtpfVNKMcWCJCKvN6GORdNeYVf3wi7IZKFFr2dqeBmno5J4jV7CaMKhEESs298+MNwJDoDIyvgoM4IZjufIlJxrKA3nHEsE1scq+7DNZxfQdsw88ATfCaL7Fuy1uoWA4F8vYWz64jvTuTie5w/IWe1Qel/VQlAnkYNHwE3dnH0cwHuoEFOd3+3k7OcBmXQmfR5PHeQ26F69yBPwVt7ABHcoo1LsceUhx0UhOzVm7il6aPBfJpDiOz1b5Htw1u3CldXzPQ3zlvvRv9Ta0Upg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMWph945oLO2Dy3pSfdIF31nUFqStiN7G4pZIwb6hEI=;
 b=aA0gJ9pHxH0H65l4I7HJQF70tx8jDTdYrKQDGFvKK+alIx1ZB00/mzRxqJ9p7UwFNfA5TxePhM22YQlZ8hj6ZKUoXNJyGZ4FI1j2xP8uaL63Tlv2gmE7Byuxc14F/mt6t8XB9s7VwdE0/d1annLErcbhC7nNM9srqnmB8YN3/dCIG1Zyoam2fdEjUoE90+2XsT4ZHiC4bb0My+SpYV13H+8bGc0NVNCCIN3CH2Be4HvnRwBDuQKzNMm1z0S9SQgzeNQo7TvWp6MJFUV98LMyJYa/3qDlkFAfVM0YPpV2pMq/EFEPwLHO05M4mhysJUXScq2gou5zImBIgi+iKaiSrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMWph945oLO2Dy3pSfdIF31nUFqStiN7G4pZIwb6hEI=;
 b=SvepTQ7dTqBstObPNqEfA/juA8F1GGjQIUhKWoKw7J+2wkS0A7jXIyGi1hYEjBajzQ8oxhyfXIEh+bq+6pSTAHkNm3uP2idq96yy2+x7yKYp0T7NLQipcI7M552QgDFwybPF9xCRUVAOtFGaVXzCooeptZPJueO4cSzEsrOb+ck=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BYAPR11MB3192.namprd11.prod.outlook.com (2603:10b6:a03:7a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.24; Tue, 23 Jun
 2020 09:01:49 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::3d7d:dfc1:b35d:63d1]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::3d7d:dfc1:b35d:63d1%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 09:01:49 +0000
To:     guro@fb.com
Cc:     "cam@neo-zeon.de lizefan"@huawei.com, daniel@iogearbox.net,
        dsonck92@gmail.com, lizefan@huawei.com, lufq.fnst@cn.fujitsu.com,
        netdev@vger.kernel.org, pgwipeout@gmail.com, tj@kernel.org,
        xiyou.wangcong@gmail.com
References: <20200622203910.GE301338@carbon.dhcp.thefacebook.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
From:   "Zhang,Qiang" <qiang.zhang@windriver.com>
Message-ID: <93605a0e-5fcd-e995-f567-50b49160f141@windriver.com>
Date:   Tue, 23 Jun 2020 17:01:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200622203910.GE301338@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To BYAPR11MB2632.namprd11.prod.outlook.com
 (2603:10b6:a02:c4::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.183] (60.247.85.82) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.2 via Frontend Transport; Tue, 23 Jun 2020 09:01:47 +0000
X-Originating-IP: [60.247.85.82]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49b90079-6d54-4e95-d3de-08d81754105d
X-MS-TrafficTypeDiagnostic: BYAPR11MB3192:
X-Microsoft-Antispam-PRVS: <BYAPR11MB31926353DC20801DAA7BAE49FF940@BYAPR11MB3192.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5udIjGbpYe8KSo2RMQyrOrBdlEcx0QQnyzs92yloQiw8EKj+oNzPQx9vv+OaLY9thJnKz48//5WViUh3aXYLkuSxpDWrGvCrkwSNw5falyccoXIPTN1cKNVAYC6HaOAkIb1Hy7La998ajmGLgmuKtZl6hXKqfeMw/WJ6UeF40CWv78Dym0LklC8jfOc/dFVP9O/RXt7QsEncJqCw86sb7dsadqizGwXnTFgfXyOY/HyvJayqJtfvH/50xyoiPT0dtV8S8VIMgibgP7AkO73Pt6xcWwT451nCgsvPDfBLAqTkKL6a1/hQbU7hF7I/ZS3xPZzSxDUn8qceuLm1eB42IVRmaG0x2jMJqsvUjY1vqpjtmodOLYuSIXKWhh9Twdr+UbWprZYDC/zuududB3XgHlYLJNEh78ek2/LSX/LghzlLXmSjThXDwU5alEWi1zc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39850400004)(366004)(376002)(136003)(346002)(4326008)(16576012)(316002)(6666004)(956004)(6486002)(8936002)(8676002)(7416002)(2616005)(16526019)(186003)(45080400002)(26005)(6706004)(31686004)(36756003)(52116002)(6916009)(53546011)(66556008)(66476007)(83380400001)(66946007)(478600001)(5660300002)(86362001)(2906002)(31696002)(78286006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: awQMdinNZgA+FYs49HlmsXYSUqeFXbUoaZLpl0xgX/BahDedhHC9Gf/wo+Ij8b9gCjkD/rzhxekYr/H5YXfV8MlTC3qLoqHnonW1xiKB8qNxTeQ/ld9OMnpsy/Y4EGFgLoQZ9VyIjxQdXKolrNG28REAseEYqsSjJ0Wgdvr0NWAFzhDHgCt9IVNbC1uFeaAB2SOFJKUoV5kvlDoAD4CzIEE5KwXNYIMYURv61tDl1J6Vl+ooxoln6jmpKv1Jz8dgUH7tPqKqyJWqnC4X9bnWbHSTXWwmpWgzcX2l/nurq3uc2HlTIm0VHSDbaY//yKSfLwLWqeAUyZF3dBQr60qX1x6RJOuvI26rNXjzX76i2g8Z1b1r++o50c70Koz6CsTuZUFhNQKnq8XKTnLQItUHljsVOSQdJu+TIEcYDYPRhlrI0UvbEzyG/Ek537yEBA6fupNdJgnGM+AdG2TWkNGepxQeAyJtx/T1n9WSO97EVhk=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b90079-6d54-4e95-d3de-08d81754105d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 09:01:49.4899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vyQ9DDJxu/Qz4GmP7lXH+a+RogpTScCXzCupiT/smmf+qeWHME8BH6A8IIGT7Nro7pfP4m458UJaR4hrRG2OcTiVU8dtX9gJUB82icjQ//8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3192
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 11:14:20AM -0700, Cong Wang wrote:
 > On Sat, Jun 20, 2020 at 8:58 AM Roman Gushchin <guro@fb.com> wrote:
 > >
 > > On Fri, Jun 19, 2020 at 08:00:41PM -0700, Cong Wang wrote:
 > > > On Fri, Jun 19, 2020 at 6:14 PM Roman Gushchin <guro@fb.com> wrote:
 > > > >
 > > > > On Sat, Jun 20, 2020 at 09:00:40AM +0800, Zefan Li wrote:
 > > > > > I think so, though I'm not familiar with the bfp cgroup code.
 > > > > >
 > > > > > > If so, we might wanna fix it in a different way,
 > > > > > > just checking if (!(css->flags & CSS_NO_REF)) in 
cgroup_bpf_put()
 > > > > > > like in cgroup_put(). It feels more reliable to me.
 > > > > > >
 > > > > >
 > > > > > Yeah I also have this idea in my mind.
 > > > >
 > > > > I wonder if the following patch will fix the issue?
 > > >
 > > > Interesting, AFAIU, this refcnt is for bpf programs attached
 > > > to the cgroup. By this suggestion, do you mean the root
 > > > cgroup does not need to refcnt the bpf programs attached
 > > > to it? This seems odd, as I don't see how root is different
 > > > from others in terms of bpf programs which can be attached
 > > > and detached in the same way.
 > > >
 > > > I certainly understand the root cgroup is never gone, but this
 > > > does not mean the bpf programs attached to it too.
 > > >
 > > > What am I missing?
 > >
 > > It's different because the root cgroup can't be deleted.
 > >
 > > All this reference counting is required to automatically detach bpf 
programs
 > > from a _deleted_ cgroup (look at cgroup_bpf_offline()). It's required
 > > because a cgroup can be in dying state for a long time being pinned 
by a
 > > pagecache page, for example. Only a user can detach a bpf program from
 > > an existing cgroup.
 >
 > Yeah, but users can still detach the bpf programs from root cgroup.
 > IIUC, after detaching, the pointer in the bpf array will be 
empty_prog_array
 > which is just an array of NULL. Then __cgroup_bpf_run_filter_skb() will
 > deref it without checking NULL (as check_non_null == false).
 >
 > This matches the 0000000000000010 pointer seen in the bug reports,
 > the 0x10, that is 16, is the offset of items[] in struct bpf_prog_array.
 > So looks like we have to add a NULL check there regardless of refcnt.
 >
 > Also, I am not sure whether your suggested patch makes a difference
 > for percpu refcnt, as percpu_ref_put() will never call ->release() until
 > percpu_ref_kill(), which is never called on root cgroup?

 > Hm, true. But it means that the problem is not with the root cgroup's 
bpf?

 >How easy is to reproduce the problem? Is it possible to bisect the 
problematic
 >commit?

 >Thanks!

The tester found the following information during the test

The dmesg information is as follows (kernelv5.4) I don't know if it 
helps for this question


root@intel-x86-64:~# cgroup: cgroup: disabling cgroup2 socket matching 
due to net_prio or net_cls activation
IPv6: ADDRCONF(NETDEV_CHANGE): veth4c31d8d2: link becomes ready
cni0: port 1(veth4c31d8d2) entered blocking state
cni0: port 1(veth4c31d8d2) entered disabled state
device veth4c31d8d2 entered promiscuous mode
cni0: port 1(veth4c31d8d2) entered blocking state
cni0: port 1(veth4c31d8d2) entered forwarding state
IPv4: martian source 10.244.1.2 from 10.244.1.2, on dev cni0
ll header: 00000000: ff ff ff ff ff ff 12 88 f0 cc 64 b8 08 06
IPv4: martian source 10.244.1.2 from 10.244.1.2, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 12 88 f0 cc 64 b8 08 06
IPv4: martian source 10.244.1.1 from 10.244.1.2, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 12 88 f0 cc 64 b8 08 06
IPv6: ADDRCONF(NETDEV_CHANGE): vethb556dc7b: link becomes ready
cni0: port 2(vethb556dc7b) entered blocking state
cni0: port 2(vethb556dc7b) entered disabled state
device vethb556dc7b entered promiscuous mode
cni0: port 2(vethb556dc7b) entered blocking state
cni0: port 2(vethb556dc7b) entered forwarding state
IPv4: martian source 10.244.1.3 from 10.244.1.3, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 1a d7 25 1c ca 18 08 06
IPv4: martian source 10.244.1.1 from 10.244.1.3, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 1a d7 25 1c ca 18 08 06
IPv4: martian source 10.244.1.2 from 10.244.1.3, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 1a d7 25 1c ca 18 08 06
-----------[ cut here ]-----------
percpu ref (cgroup_bpf_release_fn) <= 0 (-12) after switching to atomic
WARNING: CPU: 1 PID: 0 at lib/percpu-refcount.c:161 
percpu_ref_switch_to_atomic_rcu+0x12a/0x140
Modules linked in: ipt_REJECT nf_reject_ipv4 vxlan ip6_udp_tunnel 
udp_tunnel xt_statistic xt_nat xt_tcpudp iptable_mangle xt_comment 
xt_mark xt_MASQUERADE nf_conntrack_netlink nfnetlink xfrm_user 
iptable_nat xt_addrtype iptable_filter ip_tables xt_conntrack x_tables 
br_netfilter bridge stp llc bnep iTCO_wdt iTCO_vendor_support watchdog 
intel_powerclamp gpio_ich mgag200 drm_vram_helper drm_ttm_helper ttm 
i2c_i801 coretemp lpc_ich acpi_cpufreq sch_fq_codel openvswitch nsh 
nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nfsd
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G I 5.7.0-yoctodev-standard #1
Hardware name: Intel Corporation S5520HC/S5520HC, BIOS 
S5500.86B.01.10.0025.030220091519 03/02/2009
RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x12a/0x140
Code: 80 3d b1 42 3b 01 00 0f 85 56 ff ff ff 49 8b 54 24 d8 48 c7 c7 68 
57 1d a9 c6 05 98 42 3b 01 01 49 8b 74 24 e8 e8 ea 14 aa ff <0f> 0b e9 
32 ff ff ff 0f 0b eb 97 cc cc cc cc cc cc cc cc cc cc cc
RSP: 0018:ffff996183268e90 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 7ffffffffffffff3 RCX: 0000000000000000
RDX: 0000000000000102 RSI: ffffffffa9794aa7 RDI: 00000000ffffffff
RBP: ffff996183268ea8 R08: ffffffffa9794a60 R09: 0000000000000047
R10: 0000000080000001 R11: ffffffffa9794a8c R12: ffff95855904fef0
R13: 000023dc1ba33080 R14: ffff996183268ee0 R15: ffff95855904fef0
FS: 0000000000000000(0000) GS:ffff958563c00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f62622f8658 CR3: 000000044fc0a000 CR4: 00000000000006e0
Call Trace:
<IRQ>
rcu_core+0x227/0x870
? timerqueue_add+0x68/0xa0
rcu_core_si+0xe/0x10
__do_softirq+0x102/0x358
? tick_program_event+0x4d/0x90
irq_exit+0xa0/0x110
smp_apic_timer_interrupt+0xa1/0x1b0
apic_timer_interrupt+0xf/0x20
</IRQ>
RIP: 0010:cpuidle_enter_state+0xc0/0x3c0
Code: 85 c0 0f 8f 28 02 00 00 31 ff e8 5b 1a 5f ff 45 84 ff 74 12 9c 58 
f6 c4 02 0f 85 d0 02 00 00 31 ff e8 34 ba 65 ff fb 45 85 e4 <0f> 88 cc 
00 00 00 49 63 cc 4c 2b 75 d0 48 6b c1 68 48 6b d1 38 48
RSP: 0018:ffff9961831c3e48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
RAX: ffff958563c00000 RBX: ffffffffa9515e60 RCX: 000000000000001f
RDX: 0000000000000000 RSI: 000000003286e833 RDI: 0000000000000000
RBP: ffff9961831c3e88 R08: 0000000000000002 R09: 0000000000000018
R10: 0000000000000364 R11: ffff958563c2a284 R12: 0000000000000003
R13: ffffb9617fc3fd00 R14: 00000194af870de5 R15: 0000000000000000
? cpuidle_enter_state+0xa5/0x3c0
cpuidle_enter+0x2e/0x40
call_cpuidle+0x23/0x40
do_idle+0x1c6/0x240
cpu_startup_entry+0x20/0x30
start_secondary+0x15b/0x190
secondary_startup_64+0xb6/0xc0
--[ end trace 805031dac04b28f5 ]--

