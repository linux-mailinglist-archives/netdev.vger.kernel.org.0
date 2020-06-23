Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D893F204CCF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 10:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbgFWIpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 04:45:41 -0400
Received: from mail-eopbgr690066.outbound.protection.outlook.com ([40.107.69.66]:1348
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731588AbgFWIpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 04:45:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8q5UjW8pKDsuEFM9Y/rtCtpSabH7gxUA94nSo1DhlA1nEiCjcQSNlMsS6XaRM1aY9d0qvHO+90BtkhyPpGvyxIZD3QabS1qfFRAXOcEYBRQqOIHjhOM1FmLbjHJtFhNd+s0z+hRk3zjmDckQutdlUQP81ia8wwKHtEG6atCI/fdGwcI/RyjYWWgAo1OPyhXD9qTjSTzPrVw0CykOGKuuAS32ol7NGYyG6+aZl1+kNptfzIBmibFjsgksLu+eD5ryGuGEqxw0pc3Y+iLGPnglhmNbVN6+2vOPOpn7jO6tGDz0cyLrmL0jIatL4eK5RoY9uPfrwGHA5wjXUf7/lcs6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PPT1zrIkuV4/rGwHHPXwlM88ScHxIsqjniqJXCc438=;
 b=nT3ECodZTMVfKI9EIHGX+6x3XCg79d8g1OjD1ZkwYsHv8eb3wzQxnpNroUlHSJJkuJLEl+0/NwnulDVNtV+9pSQ0kMDOMBco5jwQl5AxAuiICEnaiRLfNsmOkxOsM+TVA67l3wY6yTkm0edxdj7gCl8iQW4cHwcwkXNYBEd29noascegM4JeoBzSi6E1Gv93wNhh2ac29gssbobzDUg55JICunkGA2oDGqxa9gsUaADpHbL9m9ddIYmFTViBUlYAeyU1hGKUsJoNO0ei4rjdtQyu+TT4Q0GRfTJ8EIKdJc64YGl23r3iL0jLtiR0Lno/f5WUW/cGXglbGPaShRd8Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PPT1zrIkuV4/rGwHHPXwlM88ScHxIsqjniqJXCc438=;
 b=LtNkiwOCXpMKPPgu2XYtpczCfQabaj1s5F3L/kGqIERQ2ijnL/7N/VQBsvfyMNymDSJ6/67tQo0wX+yZt8JYuhYbIRT/iyUoC6ujumhMBcozjYpuqESj0BX9eekp421kO6dd0rTv5QOLvwbx/AUSL7MdMn+EgM65hzByOUnaxC8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BYAPR11MB3718.namprd11.prod.outlook.com (2603:10b6:a03:fd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 08:45:37 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::3d7d:dfc1:b35d:63d1]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::3d7d:dfc1:b35d:63d1%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 08:45:37 +0000
To:     guro@fb.com
Cc:     "cam@neo-zeon.de lizefan@huawei.com pgwipeout@gmail.com xiyou.wangcong"@gmail.com,
        "daniel@iogearbox.net tj@kernel.org netdev"@vger.kernel.org,
        dsonck92@gmail.com, lizefan@huawei.com, lufq.fnst@cn.fujitsu.com,
        netdev@vger.kernel.org, pgwipeout@gmail.com, tj@kernel.org,
        xiyou.wangcong@gmail.com
References: <20200622203910.GE301338@carbon.dhcp.thefacebook.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
From:   "Zhang,Qiang" <qiang.zhang@windriver.com>
Message-ID: <bbcf2abd-53d8-966c-32a0-feccfdd0d7fe@windriver.com>
Date:   Tue, 23 Jun 2020 16:45:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200622203910.GE301338@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR03CA0065.apcprd03.prod.outlook.com
 (2603:1096:202:17::35) To BYAPR11MB2632.namprd11.prod.outlook.com
 (2603:10b6:a02:c4::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.183] (60.247.85.82) by HK2PR03CA0065.apcprd03.prod.outlook.com (2603:1096:202:17::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.11 via Frontend Transport; Tue, 23 Jun 2020 08:45:34 +0000
X-Originating-IP: [60.247.85.82]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f64d63b-7e66-4147-c4e6-08d81751ccb7
X-MS-TrafficTypeDiagnostic: BYAPR11MB3718:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3718364D716E5551ABE5E24DFF940@BYAPR11MB3718.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v2xlALMieWtme8TH7HtYiwtmbQdj8Ofq3IgbRub8EiKIhMkzGCUUtoD0qvHTaeAeQAFRqN7vx9WhbyIMwk8eXpZZT56tyHGSW+GIkhVz5/P05kTZT5SF997yDkU6DxUcAx9B+5WZPyNxI4lqc0HjL2Xmyx+74Jaea3XgnWUoZnEGyf1MDUDfX3D8gLs8CGVTO+PJ0VRpPTtcwnhhpoyT1dlNE70U4zpFlnAcxT7jxrieCneS1uS8AyoLE8N1+zGS6M/pq5AelfPZ3fS6e7wQejpIoHi/Ic7iKUoj6wfGBuR8UaV8klCsnAjiaAWLVS5nk60TxfJuvegLKE7T8tQmmzZesra8AeSOz/xcX8cOXXg3A6EjC4iMUcUzc7u4mR6qLJ4z3/71zxbGX6P2JUYdzjgSZDQKG0fIfvtyEDYqTtjKg6Qz7xYsHOlgLn7YePOa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(396003)(346002)(376002)(366004)(26005)(8936002)(5660300002)(31696002)(8676002)(2906002)(86362001)(66556008)(66946007)(16526019)(6706004)(186003)(66476007)(6916009)(36756003)(7416002)(6666004)(16576012)(2616005)(956004)(4326008)(83380400001)(31686004)(478600001)(316002)(52116002)(45080400002)(6486002)(78286006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oAJ994WiyyiYDCZw5R8cP4sN0RaPhcV7ixep3701ikyzwCZ7133oIcPNy7eRBiHVkIC4DM/Z7Cu4zgp3RK0NPQ/+qr2JNAOmgG+siaB6Y6XlHn8r4egMHcp6PzSVbkgPJm1ZuNwpzzRVLGqaeFIrW7CzKdQ7Dfpiy/8tGejEQX5mHyT3KSuClgocAUF13NbxHXfdV/J4nnPV2/pL0kKwG3K6pLPXOOpH2e17sr1QRxcK2BdWvs8eBqRTK5IIO9FBbAaQpJ2dNmoTHdWedzBT+YzrdC2WA6GvXdTk4AnZmbFEcWvYxe0s5lnBfGzqUdsYBOmB9o2j8Eu3o6awEntEmuqdVmKjxL5MfpmSihRi/+BWFS/Puah22JkurMFxoXhTe7Xy3LPzfRuuXu6yP+ZfNQZB7tlvbtOM8u8cHJJmjm+p6PXmszDeEc1/ZBkAII86o1X5cyxXbBt+1R92Ue8V2JzG9N2oUXjYTscK1HTIeJA=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f64d63b-7e66-4147-c4e6-08d81751ccb7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 08:45:36.9229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HhXYf5MROphVuekj8sTldeQclK+L3vlLsvUO1jrxFa3PudWf6yRldpDB8wg2NyQ+Jik4etzGRyrB62XxhuHkSUDr+G/l+61Ow/WAYwdxWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some message in kernelv5.4, I don't know if it will help.

demsg:

cgroup: cgroup: disabling cgroup2 socket matching due to net_prio or 
net_cls activation
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
