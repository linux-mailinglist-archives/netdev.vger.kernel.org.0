Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C7B11C02A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfLKWzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:55:39 -0500
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:14968 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbfLKWzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:55:39 -0500
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id xBBMq874032706;
        Wed, 11 Dec 2019 22:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : subject :
 message-id : date : mime-version : content-type; s=jan2016.eng;
 bh=23Dv6h1HJq7va7VlVXg0Ojithd0efEz3b/ErJEt6MSs=;
 b=ajrA6ge8y51A3DeZWClcWwAifSWo1qCZLbNhWRnPNUZk7xVemb7xDPn6GFZIqQ4ajFw+
 0YiTs2lX1M3pI7KG1CmIIgMSRZ09UllR45ivsAIjivv4ER0IBx82bhIkoPDX2s+NSZDU
 vWCqO5Xm896EoCHZz0yEsc2cGYHVcegHF8AMoG0ETVIKcFDZxoQq09GFtWNNg45xu1lM
 t4Y+U2bomxLMVTAGWR8zNgoR5zRHt/4DZ+MNUkhR7kwusuGdQsSYZ8UZlxQiFIHnObB9
 A87nJTqo9H0iW4KtU09wt3h90lHXDkus6WnohGtNBMFdM6x8d3MhbrZCaUqf7/16kQ4q nQ== 
Received: from prod-mail-ppoint8 (prod-mail-ppoint8.akamai.com [96.6.114.122] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 2wr21kc7uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 22:52:46 +0000
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.27/8.16.0.27) with SMTP id xBBMlLou032059;
        Wed, 11 Dec 2019 17:52:46 -0500
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint8.akamai.com with ESMTP id 2wr8a3e2kr-1;
        Wed, 11 Dec 2019 17:52:42 -0500
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 9661220064;
        Wed, 11 Dec 2019 22:52:41 +0000 (GMT)
From:   Josh Hunt <johunt@akamai.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: crash in __xfrm_state_lookup on 4.19 LTS
Message-ID: <0b3ab776-2b8b-1725-d36e-70af66c138da@akamai.com>
Date:   Wed, 11 Dec 2019 14:52:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------2B89384C3D68F3CE79A1A5C7"
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-12-11_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912110179
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 clxscore=1011 lowpriorityscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110179
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------2B89384C3D68F3CE79A1A5C7
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

We've hit the following crash on a handful of machines recently running 
4.19.55 LTS and strongswan. The kernels running on these machines do 
have some patches on top of 4.19 LTS, but nothing in the area of xfrm/ipsec:

[54284.354997] general protection fault: 0000 [#1] SMP PTI
[54284.355504] CPU: 6 PID: 11937 Comm: charon Tainted: G           O L 
  4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[54284.356382] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 
10GE/CangJie, BIOS CC1F110D 08/12/2014
[54284.357322] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[54284.357856] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 
89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 
4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50
  75 df 44 3a 60 54 75 d9 66
[54284.359190] RSP: 0018:ffffab5043d93ad0 EFLAGS: 00010212
[54284.359748] RAX: 6174735f79636e3d RBX: 6174735f79636e3d RCX: 
0000000064959bc7
[54284.360219] RDX: ffff9bb0593c3380 RSI: 0000000000000000 RDI: 
ffffffff951071c0
[54284.360713] RBP: 0000000000000002 R08: 0000000000000010 R09: 
00000000001b950d
[54284.361209] R10: 000000000000003f R11: 0000000096001849 R12: 
0000000000000032
[54284.361755] R13: 0000000000000000 R14: ffff9bb0593c3380 R15: 
0000000064959bc7
[54284.362255] FS:  00007facd7b01700(0000) GS:ffff9bb07fb80000(0000) 
knlGS:00000000000000000
[54284.363198] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[54284.363687] CR2: 00007f99250e89e0 CR3: 00000007e1078006 CR4: 
00000000001606e0
[54284.364156] Call Trace:
[54284.364642]  xfrm_state_add+0x108/0x290
[54284.365113]  xfrm_add_sa+0x9e6/0xb28 [xfrm_user]
[54284.365580]  ? xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[54284.366077]  xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[54284.366543]  ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[54284.367040]  netlink_rcv_skb+0xde/0x110
[54284.367504]  xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[54284.368000]  netlink_unicast+0x191/0x230
[54284.368463]  netlink_sendmsg+0x2c4/0x390
[54284.368958]  sock_sendmsg+0x36/0x40
[54284.369449]  __sys_sendto+0xd8/0x150
[54284.369940]  ? kern_select+0xb9/0xe0
[54284.370405]  __x64_sys_sendto+0x24/0x30
[54284.370946]  do_syscall_64+0x4e/0x110
[54284.383941]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[54284.384497] RIP: 0033:0x7face4679ad3

(gdb) list *(__xfrm_state_lookup+0x7f)
0xffffffff8271beaf is in __xfrm_state_lookup (net/xfrm/xfrm_state.c:841).
warning: Source file is more recent than executable.
836	{
837		unsigned int h = xfrm_spi_hash(net, daddr, spi, proto, family);
838		struct xfrm_state *x;
839	
840		hlist_for_each_entry_rcu(x, net->xfrm.state_byspi + h, byspi) {
841			if (x->props.family != family ||
842			    x->id.spi       != spi ||
843			    x->id.proto     != proto ||
844			    !xfrm_addr_equal(&x->id.daddr, daddr, family))
845				continue;

The above looks similar to these very old reports:
https://wiki.strongswan.org/issues/2147
https://bugzilla.kernel.org/show_bug.cgi?id=84961

Prior to the crash we are seeing softlockups and rcu stalls (see 
attached netconsole log file.) The RIP in those stalls/lockups appears 
to be in the same area as the crash reported above, lines 840 and 841.

I've tried reproducing the problem in our lab, but have been 
unsuccessful so far and running the latest upstream kernel in production 
to see if that resolves the issue is not possible at the moment. It's 
very possible this crash was happening on earlier kernel versions in our 
network, I just don't have any data to confirm that.

Here's some possible relevant kernel config info, but can provide more 
if requested:

# zgrep -E '(RCU|XFRM)' /proc/config.gz
# RCU Subsystem
CONFIG_TREE_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_NOCB_CPU=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_HAVE_RCU_TABLE_INVALIDATE=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
# CONFIG_XFRM_INTERFACE is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_SECURITY_NETWORK_XFRM is not set
# RCU Debugging
# CONFIG_RCU_PERF_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=30
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set

Please let me what other information would be useful to root-cause this 
problem.

Thanks!
Josh

--------------2B89384C3D68F3CE79A1A5C7
Content-Type: text/x-log; charset=UTF-8;
 name="xfrm-debug.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xfrm-debug.log"

[ 208.332578] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 208.333056] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 208.333082] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 208.333096] CPU: 5 PID: 11926 Comm: charon Tainted: G O 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 208.333097] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 208.333101] RIP: 0010:__xfrm_state_lookup+0x71/0x110
[ 208.333102] Code: 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 <48> 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75
[ 208.333103] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 208.333104] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 208.333104] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 208.333105] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 208.333105] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 208.333105] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 208.333106] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 208.333107] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 208.333107] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 208.333107] Call Trace:
[ 208.333111] xfrm_state_lookup+0x12/0x20
[ 208.333114] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 208.333116] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 208.333118] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 208.333121] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 208.333123] netlink_rcv_skb+0xde/0x110
[ 208.333124] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 208.333125] netlink_unicast+0x191/0x230
[ 208.333127] netlink_sendmsg+0x2c4/0x390
[ 208.333129] sock_sendmsg+0x36/0x40
[ 208.333130] __sys_sendto+0xd8/0x150
[ 208.333133] ? __fput+0x126/0x200
[ 208.333134] ? kern_select+0xb9/0xe0
[ 208.333135] __x64_sys_sendto+0x24/0x30
[ 208.333137] do_syscall_64+0x4e/0x110
[ 208.333139] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 208.333140] RIP: 0033:0x7face4679ad3
[ 208.333141] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 208.333142] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 208.333143] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 208.333143] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 208.333143] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 208.333144] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 208.333144] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 215.501451] rcu: INFO: rcu_sched self-detected stall on CPU
[ 215.501930] rcu: 5-....: (29999 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=7111
[ 215.502780] rcu: (t=30002 jiffies g=85505 q=715850)
[ 215.503247] NMI backtrace for cpu 5
[ 215.503248] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 215.503249] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 215.503249] Call Trace:
[ 215.503251] <IRQ>
[ 215.503255] dump_stack+0x5c/0x7b
[ 215.503257] nmi_cpu_backtrace+0x8a/0x90
[ 215.503260] ? lapic_can_unplug_cpu+0x90/0x90
[ 215.503261] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 215.503263] ? printk+0x43/0x4b
[ 215.503266] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 215.503266] ? cpumask_next+0x16/0x20
[ 215.503267] rcu_dump_cpu_stacks+0x8c/0xbc
[ 215.503269] rcu_check_callbacks+0x6a2/0x800
[ 215.503271] ? tick_init_highres+0x20/0x20
[ 215.503273] update_process_times+0x28/0x50
[ 215.503274] tick_sched_timer+0x50/0x150
[ 215.503276] __hrtimer_run_queues+0xea/0x260
[ 215.503277] hrtimer_interrupt+0x122/0x270
[ 215.503280] smp_apic_timer_interrupt+0x6a/0x140
[ 215.503281] apic_timer_interrupt+0xf/0x20
[ 215.503282] </IRQ>
[ 215.503284] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 215.503285] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 215.503286] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 215.503287] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 215.503287] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 215.503288] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 215.503288] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 215.503289] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 215.503291] xfrm_state_lookup+0x12/0x20
[ 215.503294] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 215.503295] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 215.503296] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 215.503299] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 215.503301] netlink_rcv_skb+0xde/0x110
[ 215.503303] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 215.503304] netlink_unicast+0x191/0x230
[ 215.503305] netlink_sendmsg+0x2c4/0x390
[ 215.503307] sock_sendmsg+0x36/0x40
[ 215.503309] __sys_sendto+0xd8/0x150
[ 215.503311] ? __fput+0x126/0x200
[ 215.503312] ? kern_select+0xb9/0xe0
[ 215.503313] __x64_sys_sendto+0x24/0x30
[ 215.503315] do_syscall_64+0x4e/0x110
[ 215.503317] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 215.503318] RIP: 0033:0x7face4679ad3
[ 215.503319] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 215.503319] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 215.503320] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 215.503321] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 215.503321] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 215.503321] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 215.503322] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 220.777359] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 220.777885] rcu: 5-....: (220435 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=7175
[ 220.778795] rcu: (detected by 7, t=30003 jiffies, g=-1199, q=2)
[ 220.779289] Sending NMI from CPU 7 to CPUs 5:
[ 220.779359] NMI backtrace for cpu 5
[ 220.779359] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 220.779360] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 220.779360] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 220.779361] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 220.779361] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 220.779362] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 220.779362] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 220.779362] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 220.779362] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 220.779363] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 220.779363] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 220.779363] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 220.779363] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 220.779363] Call Trace:
[ 220.779364] xfrm_state_lookup+0x12/0x20
[ 220.779373] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 220.779373] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 220.779374] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 220.779374] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 220.779374] netlink_rcv_skb+0xde/0x110
[ 220.779374] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 220.779374] netlink_unicast+0x191/0x230
[ 220.779374] netlink_sendmsg+0x2c4/0x390
[ 220.779375] sock_sendmsg+0x36/0x40
[ 220.779375] __sys_sendto+0xd8/0x150
[ 220.779375] ? __fput+0x126/0x200
[ 220.779375] ? kern_select+0xb9/0xe0
[ 220.779375] __x64_sys_sendto+0x24/0x30
[ 220.779375] do_syscall_64+0x4e/0x110
[ 220.779376] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 220.779376] RIP: 0033:0x7face4679ad3
[ 220.779376] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 220.779376] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 220.779377] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 220.779377] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 220.779377] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 220.779377] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 220.779378] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 248.331884] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 248.332390] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 248.332416] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 248.332430] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 248.332431] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 248.332435] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 248.332436] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 248.332437] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 248.332438] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 248.332438] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 248.332439] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 248.332439] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 248.332439] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 248.332440] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 248.332440] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 248.332441] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 248.332441] Call Trace:
[ 248.332445] xfrm_state_lookup+0x12/0x20
[ 248.332448] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 248.332449] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 248.332450] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 248.332453] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 248.332455] netlink_rcv_skb+0xde/0x110
[ 248.332456] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 248.332457] netlink_unicast+0x191/0x230
[ 248.332459] netlink_sendmsg+0x2c4/0x390
[ 248.332461] sock_sendmsg+0x36/0x40
[ 248.332462] __sys_sendto+0xd8/0x150
[ 248.332465] ? __fput+0x126/0x200
[ 248.332466] ? kern_select+0xb9/0xe0
[ 248.332467] __x64_sys_sendto+0x24/0x30
[ 248.332469] do_syscall_64+0x4e/0x110
[ 248.332471] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 248.332472] RIP: 0033:0x7face4679ad3
[ 248.332473] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 248.332474] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 248.332474] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 248.332475] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 248.332475] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 248.332475] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 248.332476] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 276.331406] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 276.331949] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 276.331975] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 276.331989] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 276.331989] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 276.331994] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 276.331995] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 276.331995] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 276.331996] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 276.331997] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 276.331997] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 276.331997] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 276.331998] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 276.331998] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 276.331999] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 276.331999] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 276.332000] Call Trace:
[ 276.332003] xfrm_state_lookup+0x12/0x20
[ 276.332006] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 276.332007] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 276.332008] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 276.332010] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 276.332012] netlink_rcv_skb+0xde/0x110
[ 276.332014] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 276.332015] netlink_unicast+0x191/0x230
[ 276.332016] netlink_sendmsg+0x2c4/0x390
[ 276.332018] sock_sendmsg+0x36/0x40
[ 276.332020] __sys_sendto+0xd8/0x150
[ 276.332022] ? __fput+0x126/0x200
[ 276.332023] ? kern_select+0xb9/0xe0
[ 276.332024] __x64_sys_sendto+0x24/0x30
[ 276.332026] do_syscall_64+0x4e/0x110
[ 276.332029] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 276.332030] RIP: 0033:0x7face4679ad3
[ 276.332031] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 276.332031] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 276.332032] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 276.332032] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 276.332032] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 276.332033] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 276.332033] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 304.330922] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 304.331460] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 304.331486] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 304.331499] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 304.331500] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 304.331504] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 304.331505] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 304.331506] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 304.331507] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 304.331507] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 304.331508] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 304.331508] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 304.331508] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 304.331509] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 304.331510] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 304.331510] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 304.331510] Call Trace:
[ 304.331514] xfrm_state_lookup+0x12/0x20
[ 304.331517] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 304.331518] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 304.331520] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 304.331522] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 304.331524] netlink_rcv_skb+0xde/0x110
[ 304.331525] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 304.331527] netlink_unicast+0x191/0x230
[ 304.331528] netlink_sendmsg+0x2c4/0x390
[ 304.331530] sock_sendmsg+0x36/0x40
[ 304.331531] __sys_sendto+0xd8/0x150
[ 304.331534] ? __fput+0x126/0x200
[ 304.331535] ? kern_select+0xb9/0xe0
[ 304.331536] __x64_sys_sendto+0x24/0x30
[ 304.331538] do_syscall_64+0x4e/0x110
[ 304.331541] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 304.331542] RIP: 0033:0x7face4679ad3
[ 304.331543] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 304.331543] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 304.331544] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 304.331544] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 304.331545] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 304.331545] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 304.331546] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 305.502901] rcu: INFO: rcu_sched self-detected stall on CPU
[ 305.503411] rcu: 5-....: (120002 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=28821
[ 305.504295] rcu: (t=120005 jiffies g=85505 q=1148831)
[ 305.504793] NMI backtrace for cpu 5
[ 305.504794] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 305.504795] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 305.504795] Call Trace:
[ 305.504797] <IRQ>
[ 305.504811] dump_stack+0x5c/0x7b
[ 305.504813] nmi_cpu_backtrace+0x8a/0x90
[ 305.504815] ? lapic_can_unplug_cpu+0x90/0x90
[ 305.504816] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 305.504819] ? printk+0x43/0x4b
[ 305.504822] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 305.504822] ? cpumask_next+0x16/0x20
[ 305.504824] rcu_dump_cpu_stacks+0x8c/0xbc
[ 305.504835] rcu_check_callbacks+0x6a2/0x800
[ 305.504838] ? tick_init_highres+0x20/0x20
[ 305.504840] update_process_times+0x28/0x50
[ 305.504841] tick_sched_timer+0x50/0x150
[ 305.504842] __hrtimer_run_queues+0xea/0x260
[ 305.504844] hrtimer_interrupt+0x122/0x270
[ 305.504846] smp_apic_timer_interrupt+0x6a/0x140
[ 305.504847] apic_timer_interrupt+0xf/0x20
[ 305.504848] </IRQ>
[ 305.504851] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 305.504852] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 305.504852] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 305.504853] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 305.504853] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 305.504854] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 305.504854] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 305.504855] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 305.504857] xfrm_state_lookup+0x12/0x20
[ 305.504860] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 305.504862] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 305.504863] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 305.504865] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 305.504867] netlink_rcv_skb+0xde/0x110
[ 305.504868] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 305.504869] netlink_unicast+0x191/0x230
[ 305.504870] netlink_sendmsg+0x2c4/0x390
[ 305.504873] sock_sendmsg+0x36/0x40
[ 305.504874] __sys_sendto+0xd8/0x150
[ 305.504877] ? __fput+0x126/0x200
[ 305.504878] ? kern_select+0xb9/0xe0
[ 305.504879] __x64_sys_sendto+0x24/0x30
[ 305.504881] do_syscall_64+0x4e/0x110
[ 305.504882] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 305.504884] RIP: 0033:0x7face4679ad3
[ 305.504885] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 305.504885] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 305.504886] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 305.504886] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 305.504886] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 305.504887] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 305.504887] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 310.780810] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 310.781331] rcu: 5-....: (310440 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=28893
[ 310.782239] rcu: (detected by 4, t=120008 jiffies, g=-1199, q=2)
[ 310.782708] Sending NMI from CPU 4 to CPUs 5:
[ 310.782755] NMI backtrace for cpu 5
[ 310.782756] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 310.782756] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 310.782756] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 310.782757] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 310.782757] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 310.782757] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 310.782758] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 310.782758] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 310.782758] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 310.782758] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 310.782759] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 310.782759] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 310.782759] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 310.782759] Call Trace:
[ 310.782759] xfrm_state_lookup+0x12/0x20
[ 310.782759] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 310.782760] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 310.782760] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 310.782760] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 310.782760] netlink_rcv_skb+0xde/0x110
[ 310.782760] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 310.782760] netlink_unicast+0x191/0x230
[ 310.782761] netlink_sendmsg+0x2c4/0x390
[ 310.782761] sock_sendmsg+0x36/0x40
[ 310.782761] __sys_sendto+0xd8/0x150
[ 310.782761] ? __fput+0x126/0x200
[ 310.782761] ? kern_select+0xb9/0xe0
[ 310.782761] __x64_sys_sendto+0x24/0x30
[ 310.782761] do_syscall_64+0x4e/0x110
[ 310.782762] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 310.782762] RIP: 0033:0x7face4679ad3
[ 310.782762] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 310.782762] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 310.782763] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 310.782763] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 310.782763] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 310.782763] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 310.782763] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 336.330363] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 336.330841] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 336.330867] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 336.330881] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 336.330882] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 336.330886] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 336.330887] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 336.330887] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 336.330888] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 336.330889] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 336.330889] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 336.330890] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 336.330890] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 336.330891] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 336.330891] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 336.330892] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 336.330892] Call Trace:
[ 336.330896] xfrm_state_lookup+0x12/0x20
[ 336.330899] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 336.330900] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 336.330901] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 336.330904] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 336.330906] netlink_rcv_skb+0xde/0x110
[ 336.330907] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 336.330908] netlink_unicast+0x191/0x230
[ 336.330909] netlink_sendmsg+0x2c4/0x390
[ 336.330912] sock_sendmsg+0x36/0x40
[ 336.330914] __sys_sendto+0xd8/0x150
[ 336.330916] ? __fput+0x126/0x200
[ 336.330917] ? kern_select+0xb9/0xe0
[ 336.330918] __x64_sys_sendto+0x24/0x30
[ 336.330920] do_syscall_64+0x4e/0x110
[ 336.330923] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 336.330924] RIP: 0033:0x7face4679ad3
[ 336.330925] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 336.330925] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 336.330926] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 336.330927] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 336.330927] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 336.330927] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 336.330928] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 364.329868] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 364.330403] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 364.330428] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 364.330441] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 364.330442] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 364.330446] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 364.330447] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 364.330448] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 364.330449] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 364.330449] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 364.330450] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 364.330450] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 364.330451] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 364.330451] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 364.330452] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 364.330452] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 364.330453] Call Trace:
[ 364.330456] xfrm_state_lookup+0x12/0x20
[ 364.330459] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 364.330460] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 364.330462] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 364.330464] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 364.330466] netlink_rcv_skb+0xde/0x110
[ 364.330468] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 364.330469] netlink_unicast+0x191/0x230
[ 364.330470] netlink_sendmsg+0x2c4/0x390
[ 364.330472] sock_sendmsg+0x36/0x40
[ 364.330474] __sys_sendto+0xd8/0x150
[ 364.330477] ? __fput+0x126/0x200
[ 364.330478] ? kern_select+0xb9/0xe0
[ 364.330479] __x64_sys_sendto+0x24/0x30
[ 364.330481] do_syscall_64+0x4e/0x110
[ 364.330483] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 364.330484] RIP: 0033:0x7face4679ad3
[ 364.330485] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 364.330486] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 364.330486] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 364.330487] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 364.330487] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 364.330488] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 364.330488] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 392.329368] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 392.329989] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 392.330015] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 392.330028] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 392.330029] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 392.330033] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 392.330034] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 392.330035] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 392.330035] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 392.330036] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 392.330036] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 392.330037] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 392.330037] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 392.330038] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 392.330038] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 392.330039] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 392.330039] Call Trace:
[ 392.330042] xfrm_state_lookup+0x12/0x20
[ 392.330045] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 392.330046] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 392.330048] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 392.330050] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 392.330052] netlink_rcv_skb+0xde/0x110
[ 392.330053] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 392.330054] netlink_unicast+0x191/0x230
[ 392.330055] netlink_sendmsg+0x2c4/0x390
[ 392.330058] sock_sendmsg+0x36/0x40
[ 392.330059] __sys_sendto+0xd8/0x150
[ 392.330062] ? __fput+0x126/0x200
[ 392.330063] ? kern_select+0xb9/0xe0
[ 392.330064] __x64_sys_sendto+0x24/0x30
[ 392.330066] do_syscall_64+0x4e/0x110
[ 392.330068] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 392.330069] RIP: 0033:0x7face4679ad3
[ 392.330070] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 392.330070] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 392.330071] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 392.330071] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 392.330072] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 392.330072] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 392.330073] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 395.505310] rcu: INFO: rcu_sched self-detected stall on CPU
[ 395.505852] rcu: 5-....: (210006 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=50586
[ 395.506748] rcu: (t=210009 jiffies g=85505 q=1435600)
[ 395.507215] NMI backtrace for cpu 5
[ 395.507216] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 395.507217] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 395.507217] Call Trace:
[ 395.507219] <IRQ>
[ 395.507223] dump_stack+0x5c/0x7b
[ 395.507225] nmi_cpu_backtrace+0x8a/0x90
[ 395.507228] ? lapic_can_unplug_cpu+0x90/0x90
[ 395.507229] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 395.507231] ? printk+0x43/0x4b
[ 395.507234] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 395.507234] ? cpumask_next+0x16/0x20
[ 395.507235] rcu_dump_cpu_stacks+0x8c/0xbc
[ 395.507237] rcu_check_callbacks+0x6a2/0x800
[ 395.507239] ? tick_init_highres+0x20/0x20
[ 395.507241] update_process_times+0x28/0x50
[ 395.507242] tick_sched_timer+0x50/0x150
[ 395.507244] __hrtimer_run_queues+0xea/0x260
[ 395.507245] hrtimer_interrupt+0x122/0x270
[ 395.507247] smp_apic_timer_interrupt+0x6a/0x140
[ 395.507249] apic_timer_interrupt+0xf/0x20
[ 395.507249] </IRQ>
[ 395.507252] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 395.507253] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 395.507253] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 395.507254] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 395.507255] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 395.507255] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 395.507256] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 395.507256] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 395.507258] xfrm_state_lookup+0x12/0x20
[ 395.507262] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 395.507263] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 395.507264] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 395.507266] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 395.507268] netlink_rcv_skb+0xde/0x110
[ 395.507270] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 395.507271] netlink_unicast+0x191/0x230
[ 395.507272] netlink_sendmsg+0x2c4/0x390
[ 395.507274] sock_sendmsg+0x36/0x40
[ 395.507276] __sys_sendto+0xd8/0x150
[ 395.507278] ? __fput+0x126/0x200
[ 395.507279] ? kern_select+0xb9/0xe0
[ 395.507280] __x64_sys_sendto+0x24/0x30
[ 395.507282] do_syscall_64+0x4e/0x110
[ 395.507283] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 395.507285] RIP: 0033:0x7face4679ad3
[ 395.507286] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 395.507286] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 395.507287] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 395.507287] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 395.507288] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 395.507288] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 395.507288] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 400.784216] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 400.784726] rcu: 5-....: (400445 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=50674
[ 400.785608] rcu: (detected by 0, t=210012 jiffies, g=-1199, q=2)
[ 400.786107] Sending NMI from CPU 0 to CPUs 5:
[ 400.786154] NMI backtrace for cpu 5
[ 400.786154] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 400.786154] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 400.786155] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 400.786165] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 400.786165] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 400.786165] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 400.786166] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 400.786166] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 400.786166] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 400.786166] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 400.786166] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 400.786167] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 400.786167] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 400.786167] Call Trace:
[ 400.786167] xfrm_state_lookup+0x12/0x20
[ 400.786167] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 400.786168] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 400.786168] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 400.786168] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 400.786168] netlink_rcv_skb+0xde/0x110
[ 400.786168] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 400.786168] netlink_unicast+0x191/0x230
[ 400.786169] netlink_sendmsg+0x2c4/0x390
[ 400.786169] sock_sendmsg+0x36/0x40
[ 400.786169] __sys_sendto+0xd8/0x150
[ 400.786169] ? __fput+0x126/0x200
[ 400.786169] ? kern_select+0xb9/0xe0
[ 400.786169] __x64_sys_sendto+0x24/0x30
[ 400.786169] do_syscall_64+0x4e/0x110
[ 400.786170] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 400.786170] RIP: 0033:0x7face4679ad3
[ 400.786170] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 400.786170] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 400.786171] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 400.786171] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 400.786171] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 400.786171] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 400.786172] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 428.328720] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 428.329230] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 428.329259] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 428.329272] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 428.329273] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 428.329277] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 428.329278] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 428.329279] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 428.329280] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 428.329280] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 428.329281] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 428.329281] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 428.329282] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 428.329282] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 428.329283] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 428.329283] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 428.329284] Call Trace:
[ 428.329287] xfrm_state_lookup+0x12/0x20
[ 428.329290] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 428.329291] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 428.329292] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 428.329294] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 428.329296] netlink_rcv_skb+0xde/0x110
[ 428.329298] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 428.329299] netlink_unicast+0x191/0x230
[ 428.329300] netlink_sendmsg+0x2c4/0x390
[ 428.329302] sock_sendmsg+0x36/0x40
[ 428.329304] __sys_sendto+0xd8/0x150
[ 428.329306] ? __fput+0x126/0x200
[ 428.329308] ? kern_select+0xb9/0xe0
[ 428.329309] __x64_sys_sendto+0x24/0x30
[ 428.329310] do_syscall_64+0x4e/0x110
[ 428.329313] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 428.329314] RIP: 0033:0x7face4679ad3
[ 428.329315] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 428.329315] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 428.329316] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 428.329316] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 428.329317] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 428.329317] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 428.329318] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 456.328158] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 456.328698] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 456.328723] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 456.328737] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 456.328737] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 456.328742] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 456.328743] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 456.328744] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 456.328745] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 456.328745] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 456.328746] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 456.328746] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 456.328746] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 456.328747] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 456.328748] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 456.328748] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 456.328748] Call Trace:
[ 456.328752] xfrm_state_lookup+0x12/0x20
[ 456.328754] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 456.328756] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 456.328757] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 456.328759] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 456.328761] netlink_rcv_skb+0xde/0x110
[ 456.328763] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 456.328764] netlink_unicast+0x191/0x230
[ 456.328765] netlink_sendmsg+0x2c4/0x390
[ 456.328768] sock_sendmsg+0x36/0x40
[ 456.328769] __sys_sendto+0xd8/0x150
[ 456.328771] ? __fput+0x126/0x200
[ 456.328773] ? kern_select+0xb9/0xe0
[ 456.328774] __x64_sys_sendto+0x24/0x30
[ 456.328776] do_syscall_64+0x4e/0x110
[ 456.328778] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 456.328779] RIP: 0033:0x7face4679ad3
[ 456.328780] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 456.328780] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 456.328781] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 456.328781] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 456.328782] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 456.328782] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 456.328782] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 484.327556] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 484.328036] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 484.328063] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 484.328076] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 484.328077] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 484.328082] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 484.328083] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 484.328083] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 484.328084] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 484.328085] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 484.328085] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 484.328086] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 484.328086] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 484.328087] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 484.328087] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 484.328088] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 484.328088] Call Trace:
[ 484.328092] xfrm_state_lookup+0x12/0x20
[ 484.328095] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 484.328096] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 484.328098] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 484.328100] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 484.328102] netlink_rcv_skb+0xde/0x110
[ 484.328104] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 484.328105] netlink_unicast+0x191/0x230
[ 484.328106] netlink_sendmsg+0x2c4/0x390
[ 484.328108] sock_sendmsg+0x36/0x40
[ 484.328110] __sys_sendto+0xd8/0x150
[ 484.328112] ? __fput+0x126/0x200
[ 484.328114] ? kern_select+0xb9/0xe0
[ 484.328115] __x64_sys_sendto+0x24/0x30
[ 484.328117] do_syscall_64+0x4e/0x110
[ 484.328119] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 484.328120] RIP: 0033:0x7face4679ad3
[ 484.328121] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 484.328121] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 484.328122] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 484.328123] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 484.328123] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 484.328123] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 484.328124] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 485.506530] rcu: INFO: rcu_sched self-detected stall on CPU
[ 485.507007] rcu: 5-....: (300009 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=72338
[ 485.507856] rcu: (t=300012 jiffies g=85505 q=1694796)
[ 485.508323] NMI backtrace for cpu 5
[ 485.508325] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 485.508325] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 485.508326] Call Trace:
[ 485.508328] <IRQ>
[ 485.508331] dump_stack+0x5c/0x7b
[ 485.508334] nmi_cpu_backtrace+0x8a/0x90
[ 485.508336] ? lapic_can_unplug_cpu+0x90/0x90
[ 485.508337] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 485.508340] ? printk+0x43/0x4b
[ 485.508343] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 485.508344] ? cpumask_next+0x16/0x20
[ 485.508345] rcu_dump_cpu_stacks+0x8c/0xbc
[ 485.508346] rcu_check_callbacks+0x6a2/0x800
[ 485.508348] ? tick_init_highres+0x20/0x20
[ 485.508350] update_process_times+0x28/0x50
[ 485.508351] tick_sched_timer+0x50/0x150
[ 485.508353] __hrtimer_run_queues+0xea/0x260
[ 485.508355] hrtimer_interrupt+0x122/0x270
[ 485.508357] smp_apic_timer_interrupt+0x6a/0x140
[ 485.508358] apic_timer_interrupt+0xf/0x20
[ 485.508359] </IRQ>
[ 485.508362] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 485.508362] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 485.508363] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 485.508364] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 485.508364] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 485.508365] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 485.508365] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 485.508366] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 485.508368] xfrm_state_lookup+0x12/0x20
[ 485.508371] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 485.508372] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 485.508373] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 485.508375] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 485.508377] netlink_rcv_skb+0xde/0x110
[ 485.508379] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 485.508380] netlink_unicast+0x191/0x230
[ 485.508381] netlink_sendmsg+0x2c4/0x390
[ 485.508384] sock_sendmsg+0x36/0x40
[ 485.508385] __sys_sendto+0xd8/0x150
[ 485.508388] ? __fput+0x126/0x200
[ 485.508389] ? kern_select+0xb9/0xe0
[ 485.508390] __x64_sys_sendto+0x24/0x30
[ 485.508392] do_syscall_64+0x4e/0x110
[ 485.508393] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 485.508394] RIP: 0033:0x7face4679ad3
[ 485.508395] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 485.508396] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 485.508396] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 485.508397] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 485.508397] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 485.508398] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 485.508398] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 490.787418] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 490.787943] rcu: 5-....: (490450 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=72466
[ 490.788877] rcu: (detected by 1, t=300018 jiffies, g=-1199, q=2)
[ 490.789371] Sending NMI from CPU 1 to CPUs 5:
[ 490.789438] NMI backtrace for cpu 5
[ 490.789438] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 490.789439] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 490.789439] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 490.789439] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 490.789440] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 490.789440] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 490.789441] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 490.789441] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 490.789441] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 490.789442] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 490.789442] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 490.789442] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 490.789443] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 490.789443] Call Trace:
[ 490.789443] xfrm_state_lookup+0x12/0x20
[ 490.789443] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 490.789444] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 490.789444] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 490.789444] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 490.789444] netlink_rcv_skb+0xde/0x110
[ 490.789445] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 490.789445] netlink_unicast+0x191/0x230
[ 490.789445] netlink_sendmsg+0x2c4/0x390
[ 490.789445] sock_sendmsg+0x36/0x40
[ 490.789446] __sys_sendto+0xd8/0x150
[ 490.789446] ? __fput+0x126/0x200
[ 490.789446] ? kern_select+0xb9/0xe0
[ 490.789446] __x64_sys_sendto+0x24/0x30
[ 490.789447] do_syscall_64+0x4e/0x110
[ 490.789447] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 490.789447] RIP: 0033:0x7face4679ad3
[ 490.789448] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 490.789448] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 490.789449] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 490.789449] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 490.789449] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 490.789450] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 490.789450] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 516.326876] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 516.327411] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 516.327446] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 516.327459] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 516.327460] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 516.327473] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 516.327474] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 516.327475] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 516.327476] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 516.327476] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 516.327477] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 516.327477] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 516.327477] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 516.327478] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 516.327479] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 516.327479] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 516.327479] Call Trace:
[ 516.327483] xfrm_state_lookup+0x12/0x20
[ 516.327486] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 516.327487] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 516.327489] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 516.327491] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 516.327493] netlink_rcv_skb+0xde/0x110
[ 516.327494] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 516.327496] netlink_unicast+0x191/0x230
[ 516.327497] netlink_sendmsg+0x2c4/0x390
[ 516.327499] sock_sendmsg+0x36/0x40
[ 516.327500] __sys_sendto+0xd8/0x150
[ 516.327503] ? __fput+0x126/0x200
[ 516.327504] ? kern_select+0xb9/0xe0
[ 516.327505] __x64_sys_sendto+0x24/0x30
[ 516.327507] do_syscall_64+0x4e/0x110
[ 516.327509] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 516.327511] RIP: 0033:0x7face4679ad3
[ 516.327511] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 516.327512] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 516.327513] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 516.327513] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 516.327513] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 516.327514] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 516.327514] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 544.326287] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 544.326767] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 544.326793] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 544.326806] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 544.326807] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 544.326811] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 544.326812] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 544.326813] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 544.326814] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 544.326814] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 544.326815] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 544.326815] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 544.326816] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 544.326816] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 544.326817] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 544.326817] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 544.326818] Call Trace:
[ 544.326822] xfrm_state_lookup+0x12/0x20
[ 544.326825] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 544.326826] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 544.326827] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 544.326830] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 544.326832] netlink_rcv_skb+0xde/0x110
[ 544.326833] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 544.326834] netlink_unicast+0x191/0x230
[ 544.326835] netlink_sendmsg+0x2c4/0x390
[ 544.326838] sock_sendmsg+0x36/0x40
[ 544.326839] __sys_sendto+0xd8/0x150
[ 544.326842] ? __fput+0x126/0x200
[ 544.326843] ? kern_select+0xb9/0xe0
[ 544.326844] __x64_sys_sendto+0x24/0x30
[ 544.326846] do_syscall_64+0x4e/0x110
[ 544.326848] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 544.326849] RIP: 0033:0x7face4679ad3
[ 544.326850] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 544.326851] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 544.326851] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 544.326852] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 544.326852] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 544.326853] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 544.326853] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 572.325702] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 572.326267] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 572.326293] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 572.326307] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 572.326307] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 572.326312] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 572.326313] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 572.326314] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 572.326315] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 572.326315] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 572.326315] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 572.326316] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 572.326316] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 572.326317] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 572.326317] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 572.326318] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 572.326318] Call Trace:
[ 572.326322] xfrm_state_lookup+0x12/0x20
[ 572.326325] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 572.326326] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 572.326337] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 572.326340] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 572.326342] netlink_rcv_skb+0xde/0x110
[ 572.326343] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 572.326344] netlink_unicast+0x191/0x230
[ 572.326346] netlink_sendmsg+0x2c4/0x390
[ 572.326349] sock_sendmsg+0x36/0x40
[ 572.326350] __sys_sendto+0xd8/0x150
[ 572.326352] ? __fput+0x126/0x200
[ 572.326363] ? kern_select+0xb9/0xe0
[ 572.326364] __x64_sys_sendto+0x24/0x30
[ 572.326366] do_syscall_64+0x4e/0x110
[ 572.326368] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 572.326370] RIP: 0033:0x7face4679ad3
[ 572.326370] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 572.326371] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 572.326372] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 572.326372] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 572.326372] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 572.326373] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 572.326373] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 575.507635] rcu: INFO: rcu_sched self-detected stall on CPU
[ 575.508226] rcu: 5-....: (390012 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=94098
[ 575.509075] rcu: (t=390015 jiffies g=85505 q=1852573)
[ 575.509542] NMI backtrace for cpu 5
[ 575.509544] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 575.509544] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 575.509545] Call Trace:
[ 575.509547] <IRQ>
[ 575.509550] dump_stack+0x5c/0x7b
[ 575.509553] nmi_cpu_backtrace+0x8a/0x90
[ 575.509556] ? lapic_can_unplug_cpu+0x90/0x90
[ 575.509557] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 575.509559] ? printk+0x43/0x4b
[ 575.509562] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 575.509563] ? cpumask_next+0x16/0x20
[ 575.509564] rcu_dump_cpu_stacks+0x8c/0xbc
[ 575.509565] rcu_check_callbacks+0x6a2/0x800
[ 575.509567] ? tick_init_highres+0x20/0x20
[ 575.509569] update_process_times+0x28/0x50
[ 575.509571] tick_sched_timer+0x50/0x150
[ 575.509572] __hrtimer_run_queues+0xea/0x260
[ 575.509574] hrtimer_interrupt+0x122/0x270
[ 575.509576] smp_apic_timer_interrupt+0x6a/0x140
[ 575.509577] apic_timer_interrupt+0xf/0x20
[ 575.509578] </IRQ>
[ 575.509581] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 575.509582] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 575.509582] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 575.509583] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 575.509584] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 575.509584] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 575.509585] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 575.509585] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 575.509587] xfrm_state_lookup+0x12/0x20
[ 575.509590] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 575.509591] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 575.509593] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 575.509595] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 575.509597] netlink_rcv_skb+0xde/0x110
[ 575.509598] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 575.509599] netlink_unicast+0x191/0x230
[ 575.509600] netlink_sendmsg+0x2c4/0x390
[ 575.509603] sock_sendmsg+0x36/0x40
[ 575.509604] __sys_sendto+0xd8/0x150
[ 575.509607] ? __fput+0x126/0x200
[ 575.509608] ? kern_select+0xb9/0xe0
[ 575.509609] __x64_sys_sendto+0x24/0x30
[ 575.509611] do_syscall_64+0x4e/0x110
[ 575.509612] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 575.509613] RIP: 0033:0x7face4679ad3
[ 575.509614] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 575.509615] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 575.509615] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 575.509616] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 575.509616] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 575.509616] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 575.509617] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 580.790526] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 580.791004] rcu: 5-....: (580455 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=94212
[ 580.791850] rcu: (detected by 1, t=390023 jiffies, g=-1199, q=2)
[ 580.792319] Sending NMI from CPU 1 to CPUs 5:
[ 580.792377] NMI backtrace for cpu 5
[ 580.792377] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 580.792378] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 580.792378] RIP: 0010:__xfrm_state_lookup+0x76/0x110
[ 580.792379] Code: 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 <48> 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50
[ 580.792379] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 580.792380] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 580.792380] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 580.792380] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 580.792381] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 580.792381] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 580.792381] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 580.792381] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 580.792382] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 580.792382] Call Trace:
[ 580.792382] xfrm_state_lookup+0x12/0x20
[ 580.792383] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 580.792383] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 580.792383] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 580.792383] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 580.792384] netlink_rcv_skb+0xde/0x110
[ 580.792384] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 580.792384] netlink_unicast+0x191/0x230
[ 580.792384] netlink_sendmsg+0x2c4/0x390
[ 580.792385] sock_sendmsg+0x36/0x40
[ 580.792385] __sys_sendto+0xd8/0x150
[ 580.792385] ? __fput+0x126/0x200
[ 580.792385] ? kern_select+0xb9/0xe0
[ 580.792386] __x64_sys_sendto+0x24/0x30
[ 580.792386] do_syscall_64+0x4e/0x110
[ 580.792386] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 580.792386] RIP: 0033:0x7face4679ad3
[ 580.792387] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 580.792387] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 580.792388] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 580.792388] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 580.792389] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 580.792389] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 580.792389] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 608.324957] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 608.325469] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 608.325504] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 608.325527] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 608.325528] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 608.325532] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 608.325533] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 608.325534] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 608.325535] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 608.325535] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 608.325536] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 608.325536] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 608.325536] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 608.325537] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 608.325538] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 608.325538] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 608.325538] Call Trace:
[ 608.325542] xfrm_state_lookup+0x12/0x20
[ 608.325546] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 608.325547] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 608.325549] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 608.325551] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 608.325553] netlink_rcv_skb+0xde/0x110
[ 608.325555] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 608.325556] netlink_unicast+0x191/0x230
[ 608.325557] netlink_sendmsg+0x2c4/0x390
[ 608.325559] sock_sendmsg+0x36/0x40
[ 608.325560] __sys_sendto+0xd8/0x150
[ 608.325563] ? __fput+0x126/0x200
[ 608.325564] ? kern_select+0xb9/0xe0
[ 608.325565] __x64_sys_sendto+0x24/0x30
[ 608.325567] do_syscall_64+0x4e/0x110
[ 608.325569] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 608.325570] RIP: 0033:0x7face4679ad3
[ 608.325571] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 608.325572] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 608.325572] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 608.325573] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 608.325573] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 608.325573] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 608.325574] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 636.324382] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 636.324889] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 636.324914] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 636.324928] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 636.324928] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 636.324932] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 636.324933] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 636.324934] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 636.324935] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 636.324935] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 636.324936] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 636.324936] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 636.324937] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 636.324937] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 636.324938] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 636.324938] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 636.324939] Call Trace:
[ 636.324943] xfrm_state_lookup+0x12/0x20
[ 636.324945] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 636.324947] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 636.324948] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 636.324950] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 636.324953] netlink_rcv_skb+0xde/0x110
[ 636.324954] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 636.324955] netlink_unicast+0x191/0x230
[ 636.324956] netlink_sendmsg+0x2c4/0x390
[ 636.324959] sock_sendmsg+0x36/0x40
[ 636.324961] __sys_sendto+0xd8/0x150
[ 636.324963] ? __fput+0x126/0x200
[ 636.324964] ? kern_select+0xb9/0xe0
[ 636.324966] __x64_sys_sendto+0x24/0x30
[ 636.324967] do_syscall_64+0x4e/0x110
[ 636.324970] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 636.324971] RIP: 0033:0x7face4679ad3
[ 636.324972] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 636.324972] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 636.324973] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 636.324973] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 636.324974] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 636.324974] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 636.324974] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 660.738926] INFO: task kworker/0:3:2036 blocked for more than 300 seconds.
[ 660.739403] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 660.740256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 660.741114] kworker/0:3 D 0 2036 2 0x80000000
[ 660.741120] Workqueue: events proc_cleanup_work
[ 660.741121] Call Trace:
[ 660.741126] ? __schedule+0x2ee/0x840
[ 660.741127] schedule+0x32/0x80
[ 660.741129] schedule_timeout+0x182/0x2a0
[ 660.741131] ? __switch_to_asm+0x41/0x70
[ 660.741131] ? __switch_to_asm+0x35/0x70
[ 660.741132] ? __switch_to_asm+0x41/0x70
[ 660.741132] ? __switch_to_asm+0x35/0x70
[ 660.741133] ? __switch_to_asm+0x41/0x70
[ 660.741134] ? __switch_to_asm+0x35/0x70
[ 660.741135] wait_for_common+0xad/0x170
[ 660.741137] ? wake_up_q+0x60/0x60
[ 660.741139] __wait_rcu_gp+0x114/0x150
[ 660.741141] synchronize_sched+0x44/0x60
[ 660.741142] ? __call_rcu+0x2c0/0x2c0
[ 660.741143] ? __bpf_trace_rcu_utilization+0x10/0x10
[ 660.741145] kern_unmount+0x27/0x50
[ 660.741147] process_one_work+0x158/0x3e0
[ 660.741148] worker_thread+0x49/0x420
[ 660.741150] kthread+0xf8/0x130
[ 660.741151] ? process_one_work+0x3e0/0x3e0
[ 660.741151] ? kthread_park+0x90/0x90
[ 660.741152] ret_from_fork+0x35/0x40
[ 660.741169] INFO: task ghostmon:5602 blocked for more than 300 seconds.
[ 660.741646] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 660.742497] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 660.743357] ghostmon D 0 5602 4093 0x20020004
[ 660.743359] Call Trace:
[ 660.743362] ? __schedule+0x2ee/0x840
[ 660.743364] ? vmap_page_range_noflush+0x28a/0x3b0
[ 660.743366] schedule+0x32/0x80
[ 660.743367] schedule_preempt_disabled+0xa/0x10
[ 660.743369] __mutex_lock.isra.1+0x186/0x4a0
[ 660.743370] ? __vmalloc_node_range+0x14f/0x260
[ 660.743374] ? ip_set_sockfn_get+0x13f/0x260 [ip_set]
[ 660.743375] ip_set_sockfn_get+0x13f/0x260 [ip_set]
[ 660.743378] compat_nf_getsockopt+0x4c/0x70
[ 660.743380] compat_ip_getsockopt+0x62/0xa0
[ 660.743382] __compat_sys_getsockopt+0x70/0x1a0
[ 660.743383] __ia32_compat_sys_socketcall+0x32a/0x340
[ 660.743386] ? _copy_to_user+0x22/0x30
[ 660.743388] ? compat_put_timespec64+0x2a/0x40
[ 660.743390] ? __ia32_compat_sys_clock_gettime+0x44/0x70
[ 660.743392] do_int80_syscall_32+0x56/0x110
[ 660.743394] entry_INT80_compat+0x85/0x90
[ 660.743421] INFO: task buddy.H:9718 blocked for more than 300 seconds.
[ 660.743897] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 660.744752] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 660.745601] buddy.H D 0 9718 9714 0x20020000
[ 660.745602] Call Trace:
[ 660.745604] ? __schedule+0x2ee/0x840
[ 660.745605] schedule+0x32/0x80
[ 660.745607] schedule_timeout+0x182/0x2a0
[ 660.745609] ? mem_cgroup_throttle_swaprate+0x17/0x120
[ 660.745612] wait_for_common+0xad/0x170
[ 660.745615] ? wake_up_q+0x60/0x60
[ 660.745618] __wait_rcu_gp+0x114/0x150
[ 660.745621] synchronize_sched+0x44/0x60
[ 660.745624] ? __call_rcu+0x2c0/0x2c0
[ 660.745625] ? __bpf_trace_rcu_utilization+0x10/0x10
[ 660.745628] __unregister_prot_hook+0xb8/0xe0
[ 660.745630] packet_do_bind+0x19a/0x260
[ 660.745635] __sys_bind+0xbe/0xf0
[ 660.745637] ? sock_alloc_file+0x34/0x90
[ 660.745638] ? sock_alloc_file+0x34/0x90
[ 660.745639] ? __sys_socket+0x80/0xb0
[ 660.745642] __ia32_compat_sys_socketcall+0x279/0x340
[ 660.745644] ? exit_to_usermode_loop+0x59/0xe0
[ 660.745645] do_int80_syscall_32+0x56/0x110
[ 660.745647] entry_INT80_compat+0x85/0x90
[ 660.745664] INFO: task cloud_chimera-1:10054 blocked for more than 300 seconds.
[ 660.746522] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 660.747372] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 660.748224] cloud_chimera-1 D 0 10054 9838 0x00000000
[ 660.748225] Call Trace:
[ 660.748227] ? __schedule+0x2ee/0x840
[ 660.748228] schedule+0x32/0x80
[ 660.748231] schedule_timeout+0x182/0x2a0
[ 660.748235] ? transfer_objects+0x47/0x60
[ 660.748237] wait_for_common+0xad/0x170
[ 660.748239] ? wake_up_q+0x60/0x60
[ 660.748240] __wait_rcu_gp+0x114/0x150
[ 660.748242] synchronize_rcu_bh+0x44/0x60
[ 660.748244] ? call_rcu_sched+0x20/0x20
[ 660.748245] ? __bpf_trace_rcu_utilization+0x10/0x10
[ 660.748248] hash_net4_resize+0x402/0x510 [ip_set_hash_net]
[ 660.748252] call_ad+0x66/0x1c0 [ip_set]
[ 660.748255] ? ip_set_header+0x1f0/0x1f0 [ip_set]
[ 660.748257] ? nla_parse+0xa3/0x120
[ 660.748259] ip_set_uadd+0x139/0x260 [ip_set]
[ 660.748263] nfnetlink_rcv_msg+0x1f0/0x210 [nfnetlink]
[ 660.748266] ? copyout+0x22/0x30
[ 660.748267] ? _copy_to_iter+0x8c/0x400
[ 660.748269] ? __wake_up_common_lock+0x79/0x90
[ 660.748270] ? nfnetlink_net_exit_batch+0x60/0x60 [nfnetlink]
[ 660.748272] netlink_rcv_skb+0xde/0x110
[ 660.748273] nfnetlink_rcv+0x54/0x120 [nfnetlink]
[ 660.748274] ? __netlink_lookup+0x1d/0xf0
[ 660.748275] netlink_unicast+0x191/0x230
[ 660.748276] netlink_sendmsg+0x2c4/0x390
[ 660.748278] sock_sendmsg+0x36/0x40
[ 660.748279] __sys_sendto+0xd8/0x150
[ 660.748281] ? __sys_recvmsg+0x50/0x80
[ 660.748282] ? __sys_recvmsg+0x70/0x80
[ 660.748283] __x64_sys_sendto+0x24/0x30
[ 660.748284] do_syscall_64+0x4e/0x110
[ 660.748286] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 660.748287] RIP: 0033:0x7f996dd30ad3
[ 660.748290] Code: Bad RIP value.
[ 660.748290] RSP: 002b:00007f9951ff8660 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[ 660.748291] RAX: ffffffffffffffda RBX: 00007f992c11a030 RCX: 00007f996dd30ad3
[ 660.748292] RDX: 000000000000005c RSI: 00007f992c10e6a0 RDI: 00000000000000ca
[ 660.748292] RBP: 00007f992c10e6a0 R08: 00007f996eb69a00 R09: 000000000000000c
[ 660.748292] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000001000
[ 660.748293] R13: 00007f992c0b1950 R14: 00007f992cdf1098 R15: 000000000000002e
[ 660.748330] INFO: task tripd:12053 blocked for more than 300 seconds.
[ 660.748806] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 660.749655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 660.750511] tripd D 0 12053 12022 0x20020000
[ 660.750512] Call Trace:
[ 660.750514] ? __schedule+0x2ee/0x840
[ 660.750515] schedule+0x32/0x80
[ 660.750516] schedule_timeout+0x182/0x2a0
[ 660.750530] ? __ext4_handle_dirty_metadata+0xfa/0x1a0 [ext4]
[ 660.750531] wait_for_common+0xad/0x170
[ 660.750532] ? wake_up_q+0x60/0x60
[ 660.750533] __wait_rcu_gp+0x114/0x150
[ 660.750534] synchronize_rcu_bh+0x44/0x60
[ 660.750535] ? call_rcu_sched+0x20/0x20
[ 660.750536] ? __bpf_trace_rcu_utilization+0x10/0x10
[ 660.750540] trip_destination_table_update+0x206/0x660 [trip2]
[ 660.750543] trip_set_ctl+0xb2b/0xb50 [trip2]
[ 660.750546] ? __generic_file_write_iter+0x170/0x1d0
[ 660.750548] ? mem_cgroup_try_charge+0xc7/0x1a0
[ 660.750549] nf_setsockopt+0x44/0x60
[ 660.750551] netlink_setsockopt+0x173/0x330
[ 660.750552] __compat_sys_setsockopt+0x68/0x1b0
[ 660.750553] __ia32_compat_sys_socketcall+0x18b/0x340
[ 660.750555] ? ksys_write+0xa1/0xc0
[ 660.750556] do_int80_syscall_32+0x56/0x110
[ 660.750557] entry_INT80_compat+0x85/0x90
[ 660.750559] INFO: task tripd:13326 blocked for more than 300 seconds.
[ 660.751036] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 660.751894] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 660.752761] tripd D 0 13326 12022 0x20020000
[ 660.752762] Call Trace:
[ 660.752764] ? __schedule+0x2ee/0x840
[ 660.752765] schedule+0x32/0x80
[ 660.752766] __lock_sock+0x69/0x90
[ 660.752768] ? wait_woken+0x80/0x80
[ 660.752769] lock_sock_nested+0x4a/0x50
[ 660.752771] netlink_getsockopt+0x81/0x2b0
[ 660.752772] __compat_sys_getsockopt+0x70/0x1a0
[ 660.752773] __ia32_compat_sys_socketcall+0x32a/0x340
[ 660.752775] ? __ia32_compat_sys_gettimeofday+0x29/0x60
[ 660.752776] ? __ia32_compat_sys_time+0xf/0x40
[ 660.752777] do_int80_syscall_32+0x56/0x110
[ 660.752778] entry_INT80_compat+0x85/0x90
[ 660.752784] INFO: task lxc-start:12781 blocked for more than 300 seconds.
[ 660.753264] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 660.754123] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 660.754972] lxc-start D 0 12781 12775 0x00000000
[ 660.754974] Call Trace:
[ 660.754976] ? __schedule+0x2ee/0x840
[ 660.754977] schedule+0x32/0x80
[ 660.754979] schedule_timeout+0x182/0x2a0
[ 660.754981] wait_for_common+0xad/0x170
[ 660.754984] ? wake_up_q+0x60/0x60
[ 660.754986] __wait_rcu_gp+0x114/0x150
[ 660.754988] synchronize_sched+0x44/0x60
[ 660.754989] ? __call_rcu+0x2c0/0x2c0
[ 660.754991] ? __bpf_trace_rcu_utilization+0x10/0x10
[ 660.754994] namespace_unlock+0x47/0x60
[ 660.754996] ksys_umount+0x20d/0x3e0
[ 660.754999] ? path_put+0x12/0x20
[ 660.755000] __x64_sys_umount+0x12/0x20
[ 660.755002] do_syscall_64+0x4e/0x110
[ 660.755003] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 660.755005] RIP: 0033:0x7fea8ffab677
[ 660.755007] Code: Bad RIP value.
[ 660.755008] RSP: 002b:00007ffcf9aebc88 EFLAGS: 00000206 ORIG_RAX: 00000000000000a6
[ 660.755009] RAX: ffffffffffffffda RBX: 0000000001bc5680 RCX: 00007fea8ffab677
[ 660.755010] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 00007fea9050d089
[ 660.755010] RBP: 00007ffcf9aebcc0 R08: 0000000001bc89b0 R09: 0000000000000001
[ 660.755011] R10: 0000000000000753 R11: 0000000000000206 R12: 000000000000000f
[ 660.755012] R13: 000000000000000c R14: 0000000001bc5010 R15: 0000000001bc54d0
[ 660.755014] INFO: task mount:12905 blocked for more than 300 seconds.
[ 660.755490] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 660.756338] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 660.757194] mount D 0 12905 12255 0x00000000
[ 660.757195] Call Trace:
[ 660.757197] ? __schedule+0x2ee/0x840
[ 660.757198] schedule+0x32/0x80
[ 660.757199] blk_mq_freeze_queue_wait+0x31/0x80
[ 660.757201] ? wait_woken+0x80/0x80
[ 660.757204] loop_set_status+0xcd/0x460
[ 660.757205] loop_set_status64+0x48/0x70
[ 660.757208] blkdev_ioctl+0x468/0x8d0
[ 660.757209] ? sched_clock+0x5/0x10
[ 660.757212] block_ioctl+0x39/0x40
[ 660.757213] do_vfs_ioctl+0x92/0x5d0
[ 660.757215] ? __schedule+0xf7/0x840
[ 660.757216] ksys_ioctl+0x66/0x70
[ 660.757217] __x64_sys_ioctl+0x16/0x20
[ 660.757218] do_syscall_64+0x4e/0x110
[ 660.757219] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 660.757220] RIP: 0033:0x7fe03c7be107
[ 660.757221] Code: Bad RIP value.
[ 660.757222] RSP: 002b:00007ffdc5f7fbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 660.757222] RAX: ffffffffffffffda RBX: 00007ffdc5f7fdc0 RCX: 00007fe03c7be107
[ 660.757223] RDX: 00007ffdc5f7fe90 RSI: 0000000000004c04 RDI: 0000000000000004
[ 660.757223] RBP: 00007fe03cee07d0 R08: 0000000000000006 R09: 000000000000000a
[ 660.757223] R10: 0000000000000527 R11: 0000000000000246 R12: 00007fe03ccd2e58
[ 660.757224] R13: 0000000000000004 R14: 00007ffdc5f7fe90 R15: 00007ffdc5f7fc20
[ 660.757226] INFO: task iptables-save:13516 blocked for more than 300 seconds.
[ 660.757702] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 660.758549] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 660.759401] iptables-save D 0 13516 4050 0x00000000
[ 660.759402] Call Trace:
[ 660.759404] ? __schedule+0x2ee/0x840
[ 660.759406] schedule+0x32/0x80
[ 660.759407] schedule_preempt_disabled+0xa/0x10
[ 660.759408] __mutex_lock.isra.1+0x186/0x4a0
[ 660.759409] ? map_vm_area+0x2e/0x40
[ 660.759411] ? ip_set_sockfn_get+0x13f/0x260 [ip_set]
[ 660.759413] ip_set_sockfn_get+0x13f/0x260 [ip_set]
[ 660.759414] nf_getsockopt+0x47/0x60
[ 660.759416] ip_getsockopt+0x5a/0x80
[ 660.759417] __sys_getsockopt+0x65/0xc0
[ 660.759418] __x64_sys_getsockopt+0x20/0x30
[ 660.759419] do_syscall_64+0x4e/0x110
[ 660.759420] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 660.759421] RIP: 0033:0x7f01f26c33da
[ 660.759422] Code: Bad RIP value.
[ 660.759422] RSP: 002b:00007ffe775512f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
[ 660.759423] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f01f26c33da
[ 660.759424] RDX: 0000000000000053 RSI: 0000000000000000 RDI: 0000000000000005
[ 660.759424] RBP: 0000000000000003 R08: 00007ffe7755130c R09: 0000000000000007
[ 660.759424] R10: 00007ffe77551310 R11: 0000000000000246 R12: 0000000001053960
[ 660.759425] R13: 00007ffe77551370 R14: 0000000000000001 R15: 000000000065fb80
[ 664.323811] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 664.324289] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 664.324316] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 664.324330] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 664.324330] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 664.324335] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 664.324336] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 664.324337] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 664.324338] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 664.324338] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 664.324338] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 664.324339] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 664.324339] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 664.324340] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 664.324340] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 664.324341] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 664.324341] Call Trace:
[ 664.324345] xfrm_state_lookup+0x12/0x20
[ 664.324347] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 664.324349] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 664.324350] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 664.324352] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 664.324354] netlink_rcv_skb+0xde/0x110
[ 664.324356] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 664.324357] netlink_unicast+0x191/0x230
[ 664.324358] netlink_sendmsg+0x2c4/0x390
[ 664.324361] sock_sendmsg+0x36/0x40
[ 664.324362] __sys_sendto+0xd8/0x150
[ 664.324365] ? __fput+0x126/0x200
[ 664.324366] ? kern_select+0xb9/0xe0
[ 664.324367] __x64_sys_sendto+0x24/0x30
[ 664.324369] do_syscall_64+0x4e/0x110
[ 664.324371] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 664.324372] RIP: 0033:0x7face4679ad3
[ 664.324373] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 664.324374] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 664.324374] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 664.324375] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 664.324375] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 664.324376] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 664.324376] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 665.508785] rcu: INFO: rcu_sched self-detected stall on CPU
[ 665.509325] rcu: 5-....: (480015 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=115891
[ 665.510249] rcu: (t=480018 jiffies g=85505 q=1987447)
[ 665.510744] NMI backtrace for cpu 5
[ 665.510745] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 665.510746] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 665.510746] Call Trace:
[ 665.510748] <IRQ>
[ 665.510752] dump_stack+0x5c/0x7b
[ 665.510753] nmi_cpu_backtrace+0x8a/0x90
[ 665.510756] ? lapic_can_unplug_cpu+0x90/0x90
[ 665.510757] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 665.510760] ? printk+0x43/0x4b
[ 665.510762] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 665.510763] ? cpumask_next+0x16/0x20
[ 665.510764] rcu_dump_cpu_stacks+0x8c/0xbc
[ 665.510765] rcu_check_callbacks+0x6a2/0x800
[ 665.510768] ? tick_init_highres+0x20/0x20
[ 665.510770] update_process_times+0x28/0x50
[ 665.510771] tick_sched_timer+0x50/0x150
[ 665.510772] __hrtimer_run_queues+0xea/0x260
[ 665.510774] hrtimer_interrupt+0x122/0x270
[ 665.510776] smp_apic_timer_interrupt+0x6a/0x140
[ 665.510777] apic_timer_interrupt+0xf/0x20
[ 665.510778] </IRQ>
[ 665.510780] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 665.510781] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 665.510782] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 665.510783] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 665.510783] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 665.510784] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 665.510784] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 665.510785] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 665.510787] xfrm_state_lookup+0x12/0x20
[ 665.510791] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 665.510802] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 665.510803] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 665.510805] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 665.510807] netlink_rcv_skb+0xde/0x110
[ 665.510809] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 665.510810] netlink_unicast+0x191/0x230
[ 665.510811] netlink_sendmsg+0x2c4/0x390
[ 665.510813] sock_sendmsg+0x36/0x40
[ 665.510824] __sys_sendto+0xd8/0x150
[ 665.510826] ? __fput+0x126/0x200
[ 665.510828] ? kern_select+0xb9/0xe0
[ 665.510829] __x64_sys_sendto+0x24/0x30
[ 665.510831] do_syscall_64+0x4e/0x110
[ 665.510832] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 665.510833] RIP: 0033:0x7face4679ad3
[ 665.510834] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 665.510834] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 665.510835] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 665.510836] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 665.510836] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 665.510836] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 665.510837] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 670.793678] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 670.794156] rcu: 5-....: (670459 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=115995
[ 670.795006] rcu: (detected by 6, t=480028 jiffies, g=-1199, q=2)
[ 670.795473] Sending NMI from CPU 6 to CPUs 5:
[ 670.795521] NMI backtrace for cpu 5
[ 670.795521] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 670.795521] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 670.795522] RIP: 0010:__xfrm_state_lookup+0x76/0x110
[ 670.795522] Code: 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 <48> 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50
[ 670.795522] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 670.795523] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 670.795523] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 670.795523] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 670.795523] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 670.795523] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 670.795524] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 670.795524] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 670.795524] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 670.795524] Call Trace:
[ 670.795524] xfrm_state_lookup+0x12/0x20
[ 670.795525] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 670.795525] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 670.795525] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 670.795525] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 670.795525] netlink_rcv_skb+0xde/0x110
[ 670.795525] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 670.795526] netlink_unicast+0x191/0x230
[ 670.795526] netlink_sendmsg+0x2c4/0x390
[ 670.795526] sock_sendmsg+0x36/0x40
[ 670.795526] __sys_sendto+0xd8/0x150
[ 670.795526] ? __fput+0x126/0x200
[ 670.795526] ? kern_select+0xb9/0xe0
[ 670.795527] __x64_sys_sendto+0x24/0x30
[ 670.795527] do_syscall_64+0x4e/0x110
[ 670.795527] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 670.795527] RIP: 0033:0x7face4679ad3
[ 670.795527] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 670.795528] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 670.795528] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 670.795528] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 670.795528] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 670.795529] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 670.795529] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 696.323161] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 696.323640] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 696.323667] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 696.323681] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 696.323681] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 696.323686] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 696.323687] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 696.323688] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 696.323689] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 696.323689] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 696.323690] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 696.323690] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 696.323691] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 696.323691] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 696.323692] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 696.323692] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 696.323693] Call Trace:
[ 696.323696] xfrm_state_lookup+0x12/0x20
[ 696.323699] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 696.323700] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 696.323702] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 696.323704] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 696.323706] netlink_rcv_skb+0xde/0x110
[ 696.323707] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 696.323708] netlink_unicast+0x191/0x230
[ 696.323710] netlink_sendmsg+0x2c4/0x390
[ 696.323712] sock_sendmsg+0x36/0x40
[ 696.323713] __sys_sendto+0xd8/0x150
[ 696.323716] ? __fput+0x126/0x200
[ 696.323717] ? kern_select+0xb9/0xe0
[ 696.323718] __x64_sys_sendto+0x24/0x30
[ 696.323720] do_syscall_64+0x4e/0x110
[ 696.323722] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 696.323723] RIP: 0033:0x7face4679ad3
[ 696.323724] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 696.323725] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 696.323725] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 696.323726] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 696.323726] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 696.323727] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 696.323727] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 724.322596] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 724.323091] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 724.323118] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 724.323132] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 724.323132] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 724.323137] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 724.323138] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 724.323138] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 724.323139] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 724.323140] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 724.323140] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 724.323140] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 724.323141] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 724.323142] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 724.323142] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 724.323142] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 724.323143] Call Trace:
[ 724.323146] xfrm_state_lookup+0x12/0x20
[ 724.323149] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 724.323150] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 724.323152] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 724.323154] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 724.323156] netlink_rcv_skb+0xde/0x110
[ 724.323157] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 724.323158] netlink_unicast+0x191/0x230
[ 724.323160] netlink_sendmsg+0x2c4/0x390
[ 724.323162] sock_sendmsg+0x36/0x40
[ 724.323163] __sys_sendto+0xd8/0x150
[ 724.323166] ? __fput+0x126/0x200
[ 724.323167] ? kern_select+0xb9/0xe0
[ 724.323168] __x64_sys_sendto+0x24/0x30
[ 724.323170] do_syscall_64+0x4e/0x110
[ 724.323172] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 724.323174] RIP: 0033:0x7face4679ad3
[ 724.323174] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 724.323175] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 724.323175] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 724.323176] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 724.323176] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 724.323177] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 724.323177] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 752.322034] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 752.322596] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 752.322623] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 752.322636] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 752.322637] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 752.322641] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 752.322642] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 752.322643] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 752.322644] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 752.322644] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 752.322645] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 752.322645] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 752.322645] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 752.322646] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 752.322647] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 752.322647] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 752.322647] Call Trace:
[ 752.322651] xfrm_state_lookup+0x12/0x20
[ 752.322654] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 752.322656] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 752.322657] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 752.322659] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 752.322661] netlink_rcv_skb+0xde/0x110
[ 752.322663] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 752.322664] netlink_unicast+0x191/0x230
[ 752.322665] netlink_sendmsg+0x2c4/0x390
[ 752.322667] sock_sendmsg+0x36/0x40
[ 752.322668] __sys_sendto+0xd8/0x150
[ 752.322671] ? __fput+0x126/0x200
[ 752.322672] ? kern_select+0xb9/0xe0
[ 752.322673] __x64_sys_sendto+0x24/0x30
[ 752.322675] do_syscall_64+0x4e/0x110
[ 752.322678] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 752.322679] RIP: 0033:0x7face4679ad3
[ 752.322680] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 752.322680] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 752.322681] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 752.322681] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 752.322682] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 752.322682] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 752.322682] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 755.509969] rcu: INFO: rcu_sched self-detected stall on CPU
[ 755.510476] rcu: 5-....: (570017 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=137613
[ 755.511414] rcu: (t=570021 jiffies g=85505 q=2142358)
[ 755.511878] NMI backtrace for cpu 5
[ 755.511880] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 755.511880] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 755.511881] Call Trace:
[ 755.511882] <IRQ>
[ 755.511886] dump_stack+0x5c/0x7b
[ 755.511888] nmi_cpu_backtrace+0x8a/0x90
[ 755.511891] ? lapic_can_unplug_cpu+0x90/0x90
[ 755.511891] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 755.511894] ? printk+0x43/0x4b
[ 755.511897] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 755.511897] ? cpumask_next+0x16/0x20
[ 755.511898] rcu_dump_cpu_stacks+0x8c/0xbc
[ 755.511900] rcu_check_callbacks+0x6a2/0x800
[ 755.511902] ? tick_init_highres+0x20/0x20
[ 755.511904] update_process_times+0x28/0x50
[ 755.511905] tick_sched_timer+0x50/0x150
[ 755.511907] __hrtimer_run_queues+0xea/0x260
[ 755.511908] hrtimer_interrupt+0x122/0x270
[ 755.511911] smp_apic_timer_interrupt+0x6a/0x140
[ 755.511912] apic_timer_interrupt+0xf/0x20
[ 755.511913] </IRQ>
[ 755.511915] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 755.511916] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 755.511917] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 755.511917] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 755.511918] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 755.511918] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 755.511919] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 755.511919] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 755.511921] xfrm_state_lookup+0x12/0x20
[ 755.511924] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 755.511926] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 755.511927] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 755.511929] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 755.511931] netlink_rcv_skb+0xde/0x110
[ 755.511932] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 755.511934] netlink_unicast+0x191/0x230
[ 755.511935] netlink_sendmsg+0x2c4/0x390
[ 755.511937] sock_sendmsg+0x36/0x40
[ 755.511938] __sys_sendto+0xd8/0x150
[ 755.511941] ? __fput+0x126/0x200
[ 755.511942] ? kern_select+0xb9/0xe0
[ 755.511943] __x64_sys_sendto+0x24/0x30
[ 755.511945] do_syscall_64+0x4e/0x110
[ 755.511946] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 755.511947] RIP: 0033:0x7face4679ad3
[ 755.511948] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 755.511949] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 755.511950] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 755.511950] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 755.511950] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 755.511951] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 755.511951] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 760.796864] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 760.797349] rcu: 5-....: (760464 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=137735
[ 760.798206] rcu: (detected by 4, t=570033 jiffies, g=-1199, q=2)
[ 760.798677] Sending NMI from CPU 4 to CPUs 5:
[ 760.798743] NMI backtrace for cpu 5
[ 760.798744] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 760.798745] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 760.798745] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 760.798746] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 760.798746] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 760.798747] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 760.798747] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 760.798748] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 760.798748] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 760.798748] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 760.798749] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 760.798749] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 760.798750] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 760.798750] Call Trace:
[ 760.798750] xfrm_state_lookup+0x12/0x20
[ 760.798750] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 760.798751] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 760.798751] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 760.798751] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 760.798752] netlink_rcv_skb+0xde/0x110
[ 760.798752] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 760.798752] netlink_unicast+0x191/0x230
[ 760.798753] netlink_sendmsg+0x2c4/0x390
[ 760.798753] sock_sendmsg+0x36/0x40
[ 760.798753] __sys_sendto+0xd8/0x150
[ 760.798754] ? __fput+0x126/0x200
[ 760.798754] ? kern_select+0xb9/0xe0
[ 760.798754] __x64_sys_sendto+0x24/0x30
[ 760.798754] do_syscall_64+0x4e/0x110
[ 760.798755] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 760.798755] RIP: 0033:0x7face4679ad3
[ 760.798756] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 760.798756] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 760.798757] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 760.798757] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 760.798757] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 760.798758] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 760.798758] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 788.321314] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 788.321842] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 788.321878] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 788.321901] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 788.321901] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 788.321906] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 788.321907] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 788.321907] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 788.321908] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 788.321909] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 788.321909] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 788.321909] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 788.321910] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 788.321910] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 788.321911] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 788.321911] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 788.321912] Call Trace:
[ 788.321915] xfrm_state_lookup+0x12/0x20
[ 788.321918] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 788.321919] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 788.321920] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 788.321923] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 788.321925] netlink_rcv_skb+0xde/0x110
[ 788.321926] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 788.321927] netlink_unicast+0x191/0x230
[ 788.321928] netlink_sendmsg+0x2c4/0x390
[ 788.321931] sock_sendmsg+0x36/0x40
[ 788.321932] __sys_sendto+0xd8/0x150
[ 788.321935] ? __fput+0x126/0x200
[ 788.321936] ? kern_select+0xb9/0xe0
[ 788.321937] __x64_sys_sendto+0x24/0x30
[ 788.321939] do_syscall_64+0x4e/0x110
[ 788.321941] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 788.321942] RIP: 0033:0x7face4679ad3
[ 788.321943] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 788.321944] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 788.321944] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 788.321945] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 788.321945] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 788.321945] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 788.321946] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 816.320756] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 816.321296] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 816.321322] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 816.321336] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 816.321337] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 816.321341] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 816.321342] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 816.321343] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 816.321343] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 816.321344] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 816.321344] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 816.321345] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 816.321345] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 816.321346] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 816.321346] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 816.321347] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 816.321347] Call Trace:
[ 816.321351] xfrm_state_lookup+0x12/0x20
[ 816.321353] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 816.321355] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 816.321356] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 816.321358] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 816.321360] netlink_rcv_skb+0xde/0x110
[ 816.321361] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 816.321363] netlink_unicast+0x191/0x230
[ 816.321364] netlink_sendmsg+0x2c4/0x390
[ 816.321366] sock_sendmsg+0x36/0x40
[ 816.321377] __sys_sendto+0xd8/0x150
[ 816.321379] ? __fput+0x126/0x200
[ 816.321381] ? kern_select+0xb9/0xe0
[ 816.321382] __x64_sys_sendto+0x24/0x30
[ 816.321384] do_syscall_64+0x4e/0x110
[ 816.321386] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 816.321387] RIP: 0033:0x7face4679ad3
[ 816.321388] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 816.321389] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 816.321389] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 816.321390] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 816.321390] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 816.321391] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 816.321391] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 844.320200] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 844.320899] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 844.320924] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 844.320938] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 844.320938] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 844.320943] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 844.320944] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 844.320944] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 844.320945] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 844.320945] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 844.320946] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 844.320946] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 844.320947] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 844.320947] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 844.320948] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 844.320948] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 844.320949] Call Trace:
[ 844.320952] xfrm_state_lookup+0x12/0x20
[ 844.320955] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 844.320956] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 844.320957] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 844.320960] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 844.320962] netlink_rcv_skb+0xde/0x110
[ 844.320964] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 844.320964] netlink_unicast+0x191/0x230
[ 844.320966] netlink_sendmsg+0x2c4/0x390
[ 844.320968] sock_sendmsg+0x36/0x40
[ 844.320969] __sys_sendto+0xd8/0x150
[ 844.320972] ? __fput+0x126/0x200
[ 844.320973] ? kern_select+0xb9/0xe0
[ 844.320974] __x64_sys_sendto+0x24/0x30
[ 844.320976] do_syscall_64+0x4e/0x110
[ 844.320979] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 844.320980] RIP: 0033:0x7face4679ad3
[ 844.320981] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 844.320981] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 844.320982] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 844.320982] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 844.320983] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 844.320983] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 844.320983] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 845.511175] rcu: INFO: rcu_sched self-detected stall on CPU
[ 845.511684] rcu: 5-....: (660020 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=159386
[ 845.512583] rcu: (t=660024 jiffies g=85505 q=2278078)
[ 845.513063] NMI backtrace for cpu 5
[ 845.513064] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 845.513065] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 845.513065] Call Trace:
[ 845.513067] <IRQ>
[ 845.513070] dump_stack+0x5c/0x7b
[ 845.513072] nmi_cpu_backtrace+0x8a/0x90
[ 845.513075] ? lapic_can_unplug_cpu+0x90/0x90
[ 845.513076] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 845.513079] ? printk+0x43/0x4b
[ 845.513081] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 845.513082] ? cpumask_next+0x16/0x20
[ 845.513083] rcu_dump_cpu_stacks+0x8c/0xbc
[ 845.513084] rcu_check_callbacks+0x6a2/0x800
[ 845.513087] ? tick_init_highres+0x20/0x20
[ 845.513089] update_process_times+0x28/0x50
[ 845.513090] tick_sched_timer+0x50/0x150
[ 845.513091] __hrtimer_run_queues+0xea/0x260
[ 845.513093] hrtimer_interrupt+0x122/0x270
[ 845.513095] smp_apic_timer_interrupt+0x6a/0x140
[ 845.513096] apic_timer_interrupt+0xf/0x20
[ 845.513097] </IRQ>
[ 845.513100] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 845.513101] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 845.513101] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 845.513102] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 845.513102] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 845.513103] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 845.513103] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 845.513104] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 845.513106] xfrm_state_lookup+0x12/0x20
[ 845.513108] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 845.513110] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 845.513111] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 845.513113] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 845.513115] netlink_rcv_skb+0xde/0x110
[ 845.513116] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 845.513117] netlink_unicast+0x191/0x230
[ 845.513119] netlink_sendmsg+0x2c4/0x390
[ 845.513122] sock_sendmsg+0x36/0x40
[ 845.513123] __sys_sendto+0xd8/0x150
[ 845.513125] ? __fput+0x126/0x200
[ 845.513127] ? kern_select+0xb9/0xe0
[ 845.513128] __x64_sys_sendto+0x24/0x30
[ 845.513130] do_syscall_64+0x4e/0x110
[ 845.513131] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 845.513132] RIP: 0033:0x7face4679ad3
[ 845.513133] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 845.513133] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 845.513134] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 845.513134] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 845.513135] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 845.513135] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 845.513136] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 850.800071] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 850.800580] rcu: 5-....: (850469 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=159466
[ 850.801520] rcu: (detected by 4, t=660038 jiffies, g=-1199, q=2)
[ 850.802013] Sending NMI from CPU 4 to CPUs 5:
[ 850.802060] NMI backtrace for cpu 5
[ 850.802061] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 850.802061] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 850.802061] RIP: 0010:__xfrm_state_lookup+0x76/0x110
[ 850.802061] Code: 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 <48> 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50
[ 850.802062] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 850.802062] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 850.802062] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 850.802062] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 850.802063] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 850.802063] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 850.802063] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 850.802063] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 850.802063] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 850.802064] Call Trace:
[ 850.802064] xfrm_state_lookup+0x12/0x20
[ 850.802064] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 850.802064] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 850.802064] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 850.802064] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 850.802065] netlink_rcv_skb+0xde/0x110
[ 850.802065] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 850.802065] netlink_unicast+0x191/0x230
[ 850.802065] netlink_sendmsg+0x2c4/0x390
[ 850.802065] sock_sendmsg+0x36/0x40
[ 850.802065] __sys_sendto+0xd8/0x150
[ 850.802066] ? __fput+0x126/0x200
[ 850.802066] ? kern_select+0xb9/0xe0
[ 850.802066] __x64_sys_sendto+0x24/0x30
[ 850.802066] do_syscall_64+0x4e/0x110
[ 850.802066] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 850.802066] RIP: 0033:0x7face4679ad3
[ 850.802067] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 850.802067] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 850.802067] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 850.802067] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 850.802068] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 850.802068] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 850.802068] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 876.319566] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 876.320043] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 876.320069] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 876.320083] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 876.320083] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 876.320088] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 876.320089] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 876.320089] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 876.320090] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 876.320091] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 876.320091] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 876.320092] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 876.320092] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 876.320093] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 876.320093] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 876.320094] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 876.320094] Call Trace:
[ 876.320098] xfrm_state_lookup+0x12/0x20
[ 876.320101] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 876.320102] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 876.320103] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 876.320106] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 876.320108] netlink_rcv_skb+0xde/0x110
[ 876.320109] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 876.320110] netlink_unicast+0x191/0x230
[ 876.320111] netlink_sendmsg+0x2c4/0x390
[ 876.320114] sock_sendmsg+0x36/0x40
[ 876.320115] __sys_sendto+0xd8/0x150
[ 876.320118] ? __fput+0x126/0x200
[ 876.320119] ? kern_select+0xb9/0xe0
[ 876.320120] __x64_sys_sendto+0x24/0x30
[ 876.320123] do_syscall_64+0x4e/0x110
[ 876.320125] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 876.320126] RIP: 0033:0x7face4679ad3
[ 876.320127] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 876.320127] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 876.320128] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 876.320129] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 876.320129] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 876.320129] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 876.320130] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 904.319013] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 904.319522] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 904.319547] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 904.319560] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 904.319561] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 904.319565] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 904.319566] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 904.319567] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 904.319568] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 904.319568] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 904.319569] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 904.319569] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 904.319569] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 904.319570] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 904.319571] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 904.319571] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 904.319571] Call Trace:
[ 904.319575] xfrm_state_lookup+0x12/0x20
[ 904.319577] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 904.319579] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 904.319580] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 904.319582] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 904.319584] netlink_rcv_skb+0xde/0x110
[ 904.319586] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 904.319587] netlink_unicast+0x191/0x230
[ 904.319588] netlink_sendmsg+0x2c4/0x390
[ 904.319591] sock_sendmsg+0x36/0x40
[ 904.319592] __sys_sendto+0xd8/0x150
[ 904.319594] ? __fput+0x126/0x200
[ 904.319596] ? kern_select+0xb9/0xe0
[ 904.319597] __x64_sys_sendto+0x24/0x30
[ 904.319599] do_syscall_64+0x4e/0x110
[ 904.319601] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 904.319602] RIP: 0033:0x7face4679ad3
[ 904.319603] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 904.319604] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 904.319604] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 904.319605] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 904.319605] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 904.319605] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 904.319606] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 932.318461] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 932.319035] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 932.319063] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 932.319076] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 932.319077] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 932.319082] RIP: 0010:__xfrm_state_lookup+0x71/0x110
[ 932.319083] Code: 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 <48> 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75
[ 932.319083] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 932.319084] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 932.319085] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 932.319085] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 932.319085] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 932.319086] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 932.319087] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 932.319087] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 932.319088] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 932.319088] Call Trace:
[ 932.319091] xfrm_state_lookup+0x12/0x20
[ 932.319094] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 932.319096] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 932.319097] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 932.319099] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 932.319101] netlink_rcv_skb+0xde/0x110
[ 932.319103] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 932.319104] netlink_unicast+0x191/0x230
[ 932.319105] netlink_sendmsg+0x2c4/0x390
[ 932.319107] sock_sendmsg+0x36/0x40
[ 932.319109] __sys_sendto+0xd8/0x150
[ 932.319111] ? __fput+0x126/0x200
[ 932.319113] ? kern_select+0xb9/0xe0
[ 932.319114] __x64_sys_sendto+0x24/0x30
[ 932.319116] do_syscall_64+0x4e/0x110
[ 932.319118] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 932.319119] RIP: 0033:0x7face4679ad3
[ 932.319120] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 932.319120] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 932.319121] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 932.319121] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 932.319122] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 932.319122] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 932.319122] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 935.512397] rcu: INFO: rcu_sched self-detected stall on CPU
[ 935.513032] rcu: 5-....: (750023 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=181174
[ 935.514063] rcu: (t=750027 jiffies g=85505 q=2419560)
[ 935.514630] NMI backtrace for cpu 5
[ 935.514632] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 935.514632] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 935.514633] Call Trace:
[ 935.514635] <IRQ>
[ 935.514639] dump_stack+0x5c/0x7b
[ 935.514641] nmi_cpu_backtrace+0x8a/0x90
[ 935.514643] ? lapic_can_unplug_cpu+0x90/0x90
[ 935.514644] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 935.514647] ? printk+0x43/0x4b
[ 935.514649] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 935.514650] ? cpumask_next+0x16/0x20
[ 935.514651] rcu_dump_cpu_stacks+0x8c/0xbc
[ 935.514652] rcu_check_callbacks+0x6a2/0x800
[ 935.514655] ? tick_init_highres+0x20/0x20
[ 935.514657] update_process_times+0x28/0x50
[ 935.514658] tick_sched_timer+0x50/0x150
[ 935.514659] __hrtimer_run_queues+0xea/0x260
[ 935.514661] hrtimer_interrupt+0x122/0x270
[ 935.514663] smp_apic_timer_interrupt+0x6a/0x140
[ 935.514665] apic_timer_interrupt+0xf/0x20
[ 935.514665] </IRQ>
[ 935.514668] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 935.514669] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 935.514669] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 935.514670] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 935.514671] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 935.514671] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 935.514671] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 935.514672] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 935.514674] xfrm_state_lookup+0x12/0x20
[ 935.514677] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 935.514678] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 935.514679] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 935.514682] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 935.514684] netlink_rcv_skb+0xde/0x110
[ 935.514685] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 935.514686] netlink_unicast+0x191/0x230
[ 935.514687] netlink_sendmsg+0x2c4/0x390
[ 935.514690] sock_sendmsg+0x36/0x40
[ 935.514691] __sys_sendto+0xd8/0x150
[ 935.514694] ? __fput+0x126/0x200
[ 935.514695] ? kern_select+0xb9/0xe0
[ 935.514696] __x64_sys_sendto+0x24/0x30
[ 935.514697] do_syscall_64+0x4e/0x110
[ 935.514699] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 935.514700] RIP: 0033:0x7face4679ad3
[ 935.514701] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 935.514701] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 935.514702] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 935.514702] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 935.514703] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 935.514703] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 935.514704] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 940.803293] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 940.803827] rcu: 5-....: (940473 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=181246
[ 940.804788] rcu: (detected by 1, t=750043 jiffies, g=-1199, q=2)
[ 940.805351] Sending NMI from CPU 1 to CPUs 5:
[ 940.805407] NMI backtrace for cpu 5
[ 940.805407] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 940.805408] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 940.805408] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 940.805408] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 940.805409] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 940.805409] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 940.805410] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 940.805410] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 940.805410] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 940.805411] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 940.805411] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 940.805411] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 940.805412] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 940.805412] Call Trace:
[ 940.805412] xfrm_state_lookup+0x12/0x20
[ 940.805412] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 940.805413] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 940.805413] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 940.805413] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 940.805413] netlink_rcv_skb+0xde/0x110
[ 940.805414] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 940.805414] netlink_unicast+0x191/0x230
[ 940.805414] netlink_sendmsg+0x2c4/0x390
[ 940.805414] sock_sendmsg+0x36/0x40
[ 940.805415] __sys_sendto+0xd8/0x150
[ 940.805415] ? __fput+0x126/0x200
[ 940.805415] ? kern_select+0xb9/0xe0
[ 940.805415] __x64_sys_sendto+0x24/0x30
[ 940.805416] do_syscall_64+0x4e/0x110
[ 940.805416] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 940.805416] RIP: 0033:0x7face4679ad3
[ 940.805417] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 940.805417] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 940.805417] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 940.805418] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 940.805418] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 940.805418] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 940.805419] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 968.317753] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 968.318270] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 968.318298] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 968.318321] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 968.318322] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 968.318326] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 968.318327] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 968.318328] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 968.318328] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 968.318329] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 968.318329] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 968.318330] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 968.318330] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 968.318331] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 968.318331] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 968.318332] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 968.318332] Call Trace:
[ 968.318336] xfrm_state_lookup+0x12/0x20
[ 968.318339] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 968.318340] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 968.318341] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 968.318343] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 968.318345] netlink_rcv_skb+0xde/0x110
[ 968.318347] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 968.318348] netlink_unicast+0x191/0x230
[ 968.318349] netlink_sendmsg+0x2c4/0x390
[ 968.318352] sock_sendmsg+0x36/0x40
[ 968.318353] __sys_sendto+0xd8/0x150
[ 968.318355] ? __fput+0x126/0x200
[ 968.318356] ? kern_select+0xb9/0xe0
[ 968.318357] __x64_sys_sendto+0x24/0x30
[ 968.318359] do_syscall_64+0x4e/0x110
[ 968.318362] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 968.318363] RIP: 0033:0x7face4679ad3
[ 968.318364] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 968.318364] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 968.318365] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 968.318365] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 968.318366] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 968.318366] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 968.318366] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 988.412390] INFO: task kworker/0:3:2036 blocked for more than 300 seconds.
[ 988.412870] Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 988.413725] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 988.414767] kworker/0:3 D 0 2036 2 0x80000000
[ 988.414783] Workqueue: events proc_cleanup_work
[ 988.414786] Call Trace:
[ 988.414792] ? __schedule+0x2ee/0x840
[ 988.414795] schedule+0x32/0x80
[ 988.414798] schedule_timeout+0x182/0x2a0
[ 988.414801] ? __switch_to_asm+0x41/0x70
[ 988.414802] ? __switch_to_asm+0x35/0x70
[ 988.414803] ? __switch_to_asm+0x41/0x70
[ 988.414804] ? __switch_to_asm+0x35/0x70
[ 988.414805] ? __switch_to_asm+0x41/0x70
[ 988.414808] ? __switch_to_asm+0x35/0x70
[ 988.414812] wait_for_common+0xad/0x170
[ 988.414815] ? wake_up_q+0x60/0x60
[ 988.414817] __wait_rcu_gp+0x114/0x150
[ 988.414820] synchronize_sched+0x44/0x60
[ 988.414823] ? __call_rcu+0x2c0/0x2c0
[ 988.414825] ? __bpf_trace_rcu_utilization+0x10/0x10
[ 988.414827] kern_unmount+0x27/0x50
[ 988.414831] process_one_work+0x158/0x3e0
[ 988.414832] worker_thread+0x49/0x420
[ 988.414835] kthread+0xf8/0x130
[ 988.414837] ? process_one_work+0x3e0/0x3e0
[ 988.414838] ? kthread_park+0x90/0x90
[ 988.414840] ret_from_fork+0x35/0x40
[ 996.317204] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 996.317713] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 996.317739] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 996.317753] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 996.317754] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 996.317758] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 996.317759] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 996.317759] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 996.317760] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 996.317761] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 996.317761] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 996.317761] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 996.317762] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 996.317763] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 996.317763] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 996.317763] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 996.317764] Call Trace:
[ 996.317767] xfrm_state_lookup+0x12/0x20
[ 996.317770] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 996.317772] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 996.317773] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 996.317775] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 996.317777] netlink_rcv_skb+0xde/0x110
[ 996.317779] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 996.317780] netlink_unicast+0x191/0x230
[ 996.317781] netlink_sendmsg+0x2c4/0x390
[ 996.317783] sock_sendmsg+0x36/0x40
[ 996.317785] __sys_sendto+0xd8/0x150
[ 996.317787] ? __fput+0x126/0x200
[ 996.317788] ? kern_select+0xb9/0xe0
[ 996.317790] __x64_sys_sendto+0x24/0x30
[ 996.317792] do_syscall_64+0x4e/0x110
[ 996.317804] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 996.317805] RIP: 0033:0x7face4679ad3
[ 996.317806] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 996.317806] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 996.317807] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 996.317807] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 996.317808] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 996.317808] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 996.317808] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1024.316655] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1024.317135] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1024.317161] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1024.317175] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1024.317175] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1024.317179] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1024.317181] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1024.317181] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1024.317182] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1024.317183] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1024.317183] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1024.317184] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1024.317184] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1024.317185] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1024.317185] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1024.317186] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1024.317186] Call Trace:
[ 1024.317190] xfrm_state_lookup+0x12/0x20
[ 1024.317193] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1024.317194] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1024.317195] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1024.317198] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1024.317200] netlink_rcv_skb+0xde/0x110
[ 1024.317201] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1024.317202] netlink_unicast+0x191/0x230
[ 1024.317203] netlink_sendmsg+0x2c4/0x390
[ 1024.317206] sock_sendmsg+0x36/0x40
[ 1024.317208] __sys_sendto+0xd8/0x150
[ 1024.317210] ? __fput+0x126/0x200
[ 1024.317211] ? kern_select+0xb9/0xe0
[ 1024.317213] __x64_sys_sendto+0x24/0x30
[ 1024.317215] do_syscall_64+0x4e/0x110
[ 1024.317217] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1024.317218] RIP: 0033:0x7face4679ad3
[ 1024.317219] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1024.317219] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1024.317220] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1024.317221] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1024.317221] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1024.317221] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1024.317222] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1025.513631] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1025.514302] rcu: 5-....: (840025 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=202935
[ 1025.515455] rcu: (t=840030 jiffies g=85505 q=2573067)
[ 1025.516027] NMI backtrace for cpu 5
[ 1025.516029] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1025.516029] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1025.516030] Call Trace:
[ 1025.516032] <IRQ>
[ 1025.516035] dump_stack+0x5c/0x7b
[ 1025.516037] nmi_cpu_backtrace+0x8a/0x90
[ 1025.516040] ? lapic_can_unplug_cpu+0x90/0x90
[ 1025.516041] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1025.516044] ? printk+0x43/0x4b
[ 1025.516046] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1025.516047] ? cpumask_next+0x16/0x20
[ 1025.516048] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1025.516049] rcu_check_callbacks+0x6a2/0x800
[ 1025.516052] ? tick_init_highres+0x20/0x20
[ 1025.516054] update_process_times+0x28/0x50
[ 1025.516055] tick_sched_timer+0x50/0x150
[ 1025.516057] __hrtimer_run_queues+0xea/0x260
[ 1025.516058] hrtimer_interrupt+0x122/0x270
[ 1025.516060] smp_apic_timer_interrupt+0x6a/0x140
[ 1025.516071] apic_timer_interrupt+0xf/0x20
[ 1025.516072] </IRQ>
[ 1025.516074] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1025.516075] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1025.516076] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1025.516077] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1025.516077] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1025.516078] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1025.516078] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1025.516079] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1025.516081] xfrm_state_lookup+0x12/0x20
[ 1025.516083] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1025.516085] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1025.516086] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1025.516098] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1025.516099] netlink_rcv_skb+0xde/0x110
[ 1025.516100] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1025.516101] netlink_unicast+0x191/0x230
[ 1025.516102] netlink_sendmsg+0x2c4/0x390
[ 1025.516105] sock_sendmsg+0x36/0x40
[ 1025.516106] __sys_sendto+0xd8/0x150
[ 1025.516109] ? __fput+0x126/0x200
[ 1025.516110] ? kern_select+0xb9/0xe0
[ 1025.516111] __x64_sys_sendto+0x24/0x30
[ 1025.516113] do_syscall_64+0x4e/0x110
[ 1025.516114] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1025.516115] RIP: 0033:0x7face4679ad3
[ 1025.516116] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1025.516117] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1025.516117] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1025.516118] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1025.516118] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1025.516118] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1025.516119] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1030.806528] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1030.807007] rcu: 5-....: (1030477 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=203008
[ 1030.807855] rcu: (detected by 6, t=840048 jiffies, g=-1199, q=2)
[ 1030.818563] Sending NMI from CPU 6 to CPUs 5:
[ 1030.818611] NMI backtrace for cpu 5
[ 1030.818612] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1030.818612] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1030.818612] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1030.818613] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1030.818613] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 1030.818614] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1030.818614] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1030.818614] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1030.818615] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1030.818615] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1030.818615] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1030.818615] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1030.818615] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1030.818616] Call Trace:
[ 1030.818616] xfrm_state_lookup+0x12/0x20
[ 1030.818616] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1030.818616] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1030.818616] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1030.818616] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1030.818617] netlink_rcv_skb+0xde/0x110
[ 1030.818617] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1030.818617] netlink_unicast+0x191/0x230
[ 1030.818617] netlink_sendmsg+0x2c4/0x390
[ 1030.818617] sock_sendmsg+0x36/0x40
[ 1030.818617] __sys_sendto+0xd8/0x150
[ 1030.818618] ? __fput+0x126/0x200
[ 1030.818618] ? kern_select+0xb9/0xe0
[ 1030.818618] __x64_sys_sendto+0x24/0x30
[ 1030.818618] do_syscall_64+0x4e/0x110
[ 1030.818618] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1030.818618] RIP: 0033:0x7face4679ad3
[ 1030.818619] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1030.818619] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1030.818619] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1030.818620] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1030.818620] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1030.818620] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1030.818620] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1056.316030] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1056.316600] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1056.316626] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1056.316640] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1056.316640] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1056.316645] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 1056.316646] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 1056.316647] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 1056.316648] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1056.316648] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1056.316649] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1056.316649] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1056.316649] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1056.316650] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1056.316651] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1056.316651] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1056.316652] Call Trace:
[ 1056.316655] xfrm_state_lookup+0x12/0x20
[ 1056.316658] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1056.316660] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1056.316661] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1056.316663] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1056.316665] netlink_rcv_skb+0xde/0x110
[ 1056.316667] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1056.316668] netlink_unicast+0x191/0x230
[ 1056.316669] netlink_sendmsg+0x2c4/0x390
[ 1056.316672] sock_sendmsg+0x36/0x40
[ 1056.316673] __sys_sendto+0xd8/0x150
[ 1056.316675] ? __fput+0x126/0x200
[ 1056.316677] ? kern_select+0xb9/0xe0
[ 1056.316678] __x64_sys_sendto+0x24/0x30
[ 1056.316680] do_syscall_64+0x4e/0x110
[ 1056.316682] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1056.316683] RIP: 0033:0x7face4679ad3
[ 1056.316694] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1056.316694] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1056.316695] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1056.316695] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1056.316696] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1056.316696] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1056.316697] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1084.315483] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1084.315961] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1084.315989] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1084.316003] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1084.316004] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1084.316009] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1084.316010] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1084.316011] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1084.316011] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1084.316012] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1084.316012] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1084.316013] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1084.316013] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1084.316014] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1084.316014] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1084.316015] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1084.316015] Call Trace:
[ 1084.316019] xfrm_state_lookup+0x12/0x20
[ 1084.316022] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1084.316023] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1084.316025] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1084.316027] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1084.316029] netlink_rcv_skb+0xde/0x110
[ 1084.316031] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1084.316032] netlink_unicast+0x191/0x230
[ 1084.316033] netlink_sendmsg+0x2c4/0x390
[ 1084.316035] sock_sendmsg+0x36/0x40
[ 1084.316037] __sys_sendto+0xd8/0x150
[ 1084.316039] ? __fput+0x126/0x200
[ 1084.316041] ? kern_select+0xb9/0xe0
[ 1084.316042] __x64_sys_sendto+0x24/0x30
[ 1084.316044] do_syscall_64+0x4e/0x110
[ 1084.316046] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1084.316047] RIP: 0033:0x7face4679ad3
[ 1084.316048] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1084.316048] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1084.316049] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1084.316050] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1084.316050] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1084.316051] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1084.316051] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1112.314936] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1112.315469] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1112.315495] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1112.315509] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1112.315509] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1112.315514] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 1112.315515] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 1112.315515] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 1112.315516] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1112.315517] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1112.315517] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1112.315518] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1112.315518] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1112.315519] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1112.315519] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1112.315520] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1112.315520] Call Trace:
[ 1112.315524] xfrm_state_lookup+0x12/0x20
[ 1112.315527] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1112.315528] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1112.315530] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1112.315532] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1112.315534] netlink_rcv_skb+0xde/0x110
[ 1112.315535] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1112.315537] netlink_unicast+0x191/0x230
[ 1112.315538] netlink_sendmsg+0x2c4/0x390
[ 1112.315540] sock_sendmsg+0x36/0x40
[ 1112.315542] __sys_sendto+0xd8/0x150
[ 1112.315544] ? __fput+0x126/0x200
[ 1112.315546] ? kern_select+0xb9/0xe0
[ 1112.315547] __x64_sys_sendto+0x24/0x30
[ 1112.315549] do_syscall_64+0x4e/0x110
[ 1112.315551] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1112.315552] RIP: 0033:0x7face4679ad3
[ 1112.315553] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1112.315554] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1112.315554] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1112.315555] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1112.315555] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1112.315556] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1112.315556] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1115.514873] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1115.515396] rcu: 5-....: (930027 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=224662
[ 1115.516420] rcu: (t=930033 jiffies g=85505 q=2720497)
[ 1115.516904] NMI backtrace for cpu 5
[ 1115.516905] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1115.516906] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1115.516906] Call Trace:
[ 1115.516908] <IRQ>
[ 1115.516912] dump_stack+0x5c/0x7b
[ 1115.516914] nmi_cpu_backtrace+0x8a/0x90
[ 1115.516916] ? lapic_can_unplug_cpu+0x90/0x90
[ 1115.516918] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1115.516920] ? printk+0x43/0x4b
[ 1115.516923] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1115.516923] ? cpumask_next+0x16/0x20
[ 1115.516924] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1115.516926] rcu_check_callbacks+0x6a2/0x800
[ 1115.516928] ? tick_init_highres+0x20/0x20
[ 1115.516930] update_process_times+0x28/0x50
[ 1115.516931] tick_sched_timer+0x50/0x150
[ 1115.516933] __hrtimer_run_queues+0xea/0x260
[ 1115.516934] hrtimer_interrupt+0x122/0x270
[ 1115.516937] smp_apic_timer_interrupt+0x6a/0x140
[ 1115.516938] apic_timer_interrupt+0xf/0x20
[ 1115.516939] </IRQ>
[ 1115.516941] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1115.516942] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1115.516943] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1115.516944] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1115.516944] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1115.516945] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1115.516945] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1115.516946] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1115.516948] xfrm_state_lookup+0x12/0x20
[ 1115.516951] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1115.516952] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1115.516953] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1115.516956] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1115.516958] netlink_rcv_skb+0xde/0x110
[ 1115.516959] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1115.516960] netlink_unicast+0x191/0x230
[ 1115.516961] netlink_sendmsg+0x2c4/0x390
[ 1115.516964] sock_sendmsg+0x36/0x40
[ 1115.516965] __sys_sendto+0xd8/0x150
[ 1115.516968] ? __fput+0x126/0x200
[ 1115.516969] ? kern_select+0xb9/0xe0
[ 1115.516970] __x64_sys_sendto+0x24/0x30
[ 1115.516972] do_syscall_64+0x4e/0x110
[ 1115.516973] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1115.516974] RIP: 0033:0x7face4679ad3
[ 1115.516976] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1115.516976] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1115.516977] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1115.516977] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1115.516978] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1115.516978] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1115.516979] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1120.809770] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1120.810249] rcu: 5-....: (1120481 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=224713
[ 1120.811102] rcu: (detected by 4, t=930053 jiffies, g=-1199, q=2)
[ 1120.811572] Sending NMI from CPU 4 to CPUs 5:
[ 1120.811619] NMI backtrace for cpu 5
[ 1120.811620] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1120.811620] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1120.811620] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1120.811621] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1120.811621] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 1120.811622] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1120.811622] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1120.811622] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1120.811622] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1120.811623] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1120.811623] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1120.811623] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1120.811623] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1120.811623] Call Trace:
[ 1120.811624] xfrm_state_lookup+0x12/0x20
[ 1120.811624] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1120.811624] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1120.811624] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1120.811624] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1120.811625] netlink_rcv_skb+0xde/0x110
[ 1120.811625] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1120.811625] netlink_unicast+0x191/0x230
[ 1120.811625] netlink_sendmsg+0x2c4/0x390
[ 1120.811625] sock_sendmsg+0x36/0x40
[ 1120.811625] __sys_sendto+0xd8/0x150
[ 1120.811626] ? __fput+0x126/0x200
[ 1120.811626] ? kern_select+0xb9/0xe0
[ 1120.811626] __x64_sys_sendto+0x24/0x30
[ 1120.811626] do_syscall_64+0x4e/0x110
[ 1120.811626] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1120.811626] RIP: 0033:0x7face4679ad3
[ 1120.811627] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1120.811627] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1120.811628] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1120.811628] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1120.811628] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1120.811628] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1120.811629] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1148.314234] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1148.314796] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1148.314822] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1148.314836] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1148.314836] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1148.314841] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1148.314842] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1148.314842] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1148.314843] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1148.314844] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1148.314844] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1148.314845] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1148.314845] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1148.314846] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1148.314846] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1148.314847] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1148.314847] Call Trace:
[ 1148.314850] xfrm_state_lookup+0x12/0x20
[ 1148.314853] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1148.314855] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1148.314856] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1148.314858] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1148.314860] netlink_rcv_skb+0xde/0x110
[ 1148.314862] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1148.314863] netlink_unicast+0x191/0x230
[ 1148.314864] netlink_sendmsg+0x2c4/0x390
[ 1148.314867] sock_sendmsg+0x36/0x40
[ 1148.314869] __sys_sendto+0xd8/0x150
[ 1148.314872] ? __fput+0x126/0x200
[ 1148.314873] ? kern_select+0xb9/0xe0
[ 1148.314874] __x64_sys_sendto+0x24/0x30
[ 1148.314876] do_syscall_64+0x4e/0x110
[ 1148.314878] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1148.314879] RIP: 0033:0x7face4679ad3
[ 1148.314880] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1148.314880] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1148.314881] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1148.314882] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1148.314882] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1148.314882] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1148.314883] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1176.313689] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1176.314169] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1176.314195] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1176.314209] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1176.314209] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1176.314214] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1176.314215] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1176.314216] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1176.314217] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1176.314217] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1176.314218] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1176.314218] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1176.314219] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1176.314219] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1176.314220] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1176.314220] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1176.314221] Call Trace:
[ 1176.314224] xfrm_state_lookup+0x12/0x20
[ 1176.314227] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1176.314229] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1176.314230] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1176.314232] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1176.314234] netlink_rcv_skb+0xde/0x110
[ 1176.314236] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1176.314237] netlink_unicast+0x191/0x230
[ 1176.314238] netlink_sendmsg+0x2c4/0x390
[ 1176.314240] sock_sendmsg+0x36/0x40
[ 1176.314242] __sys_sendto+0xd8/0x150
[ 1176.314244] ? __fput+0x126/0x200
[ 1176.314245] ? kern_select+0xb9/0xe0
[ 1176.314247] __x64_sys_sendto+0x24/0x30
[ 1176.314249] do_syscall_64+0x4e/0x110
[ 1176.314251] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1176.314252] RIP: 0033:0x7face4679ad3
[ 1176.314253] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1176.314253] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1176.314254] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1176.314255] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1176.314255] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1176.314255] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1176.314256] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1204.313144] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1204.313711] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1204.313738] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1204.313752] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1204.313752] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1204.313766] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1204.313767] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1204.313768] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1204.313769] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1204.313769] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1204.313770] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1204.313770] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1204.313771] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1204.313771] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1204.313772] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1204.313772] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1204.313773] Call Trace:
[ 1204.313777] xfrm_state_lookup+0x12/0x20
[ 1204.313789] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1204.313790] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1204.313791] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1204.313794] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1204.313796] netlink_rcv_skb+0xde/0x110
[ 1204.313798] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1204.313799] netlink_unicast+0x191/0x230
[ 1204.313800] netlink_sendmsg+0x2c4/0x390
[ 1204.313802] sock_sendmsg+0x36/0x40
[ 1204.313803] __sys_sendto+0xd8/0x150
[ 1204.313806] ? __fput+0x126/0x200
[ 1204.313807] ? kern_select+0xb9/0xe0
[ 1204.313808] __x64_sys_sendto+0x24/0x30
[ 1204.313810] do_syscall_64+0x4e/0x110
[ 1204.313812] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1204.313814] RIP: 0033:0x7face4679ad3
[ 1204.313815] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1204.313815] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1204.313816] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1204.313816] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1204.313817] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1204.313817] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1204.313818] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1205.516119] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1205.516712] rcu: 5-....: (1020029 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=246396
[ 1205.517647] rcu: (t=1020036 jiffies g=85505 q=2870684)
[ 1205.518113] NMI backtrace for cpu 5
[ 1205.518114] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1205.518115] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1205.518115] Call Trace:
[ 1205.518117] <IRQ>
[ 1205.518121] dump_stack+0x5c/0x7b
[ 1205.518133] nmi_cpu_backtrace+0x8a/0x90
[ 1205.518136] ? lapic_can_unplug_cpu+0x90/0x90
[ 1205.518137] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1205.518139] ? printk+0x43/0x4b
[ 1205.518142] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1205.518143] ? cpumask_next+0x16/0x20
[ 1205.518144] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1205.518145] rcu_check_callbacks+0x6a2/0x800
[ 1205.518157] ? tick_init_highres+0x20/0x20
[ 1205.518159] update_process_times+0x28/0x50
[ 1205.518160] tick_sched_timer+0x50/0x150
[ 1205.518162] __hrtimer_run_queues+0xea/0x260
[ 1205.518163] hrtimer_interrupt+0x122/0x270
[ 1205.518166] smp_apic_timer_interrupt+0x6a/0x140
[ 1205.518167] apic_timer_interrupt+0xf/0x20
[ 1205.518168] </IRQ>
[ 1205.518170] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1205.518171] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1205.518172] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1205.518173] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1205.518173] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1205.518174] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1205.518174] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1205.518175] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1205.518177] xfrm_state_lookup+0x12/0x20
[ 1205.518179] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1205.518181] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1205.518182] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1205.518184] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1205.518186] netlink_rcv_skb+0xde/0x110
[ 1205.518188] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1205.518189] netlink_unicast+0x191/0x230
[ 1205.518190] netlink_sendmsg+0x2c4/0x390
[ 1205.518193] sock_sendmsg+0x36/0x40
[ 1205.518194] __sys_sendto+0xd8/0x150
[ 1205.518206] ? __fput+0x126/0x200
[ 1205.518207] ? kern_select+0xb9/0xe0
[ 1205.518209] __x64_sys_sendto+0x24/0x30
[ 1205.518210] do_syscall_64+0x4e/0x110
[ 1205.518212] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1205.518213] RIP: 0033:0x7face4679ad3
[ 1205.518214] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1205.518214] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1205.518215] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1205.518216] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1205.518216] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1205.518217] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1205.518217] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1210.813017] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1210.813583] rcu: 5-....: (1210485 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=246455
[ 1210.814554] rcu: (detected by 1, t=1020058 jiffies, g=-1199, q=2)
[ 1210.815047] Sending NMI from CPU 1 to CPUs 5:
[ 1210.815102] NMI backtrace for cpu 5
[ 1210.815103] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1210.815103] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1210.815103] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1210.815104] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1210.815104] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 1210.815105] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1210.815105] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1210.815106] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1210.815106] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1210.815106] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1210.815107] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1210.815107] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1210.815107] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1210.815108] Call Trace:
[ 1210.815108] xfrm_state_lookup+0x12/0x20
[ 1210.815108] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1210.815108] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1210.815109] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1210.815109] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1210.815109] netlink_rcv_skb+0xde/0x110
[ 1210.815109] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1210.815110] netlink_unicast+0x191/0x230
[ 1210.815110] netlink_sendmsg+0x2c4/0x390
[ 1210.815110] sock_sendmsg+0x36/0x40
[ 1210.815110] __sys_sendto+0xd8/0x150
[ 1210.815111] ? __fput+0x126/0x200
[ 1210.815111] ? kern_select+0xb9/0xe0
[ 1210.815111] __x64_sys_sendto+0x24/0x30
[ 1210.815111] do_syscall_64+0x4e/0x110
[ 1210.815112] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1210.815112] RIP: 0033:0x7face4679ad3
[ 1210.815113] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1210.815113] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1210.815113] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1210.815114] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1210.815114] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1210.815114] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1210.815115] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1236.312521] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1236.313084] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1236.313110] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1236.313124] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1236.313125] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1236.313129] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 1236.313130] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 1236.313131] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 1236.313132] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1236.313132] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1236.313133] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1236.313133] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1236.313133] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1236.313134] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1236.313135] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1236.313135] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1236.313135] Call Trace:
[ 1236.313139] xfrm_state_lookup+0x12/0x20
[ 1236.313142] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1236.313143] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1236.313144] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1236.313147] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1236.313149] netlink_rcv_skb+0xde/0x110
[ 1236.313151] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1236.313152] netlink_unicast+0x191/0x230
[ 1236.313153] netlink_sendmsg+0x2c4/0x390
[ 1236.313155] sock_sendmsg+0x36/0x40
[ 1236.313157] __sys_sendto+0xd8/0x150
[ 1236.313159] ? __fput+0x126/0x200
[ 1236.313161] ? kern_select+0xb9/0xe0
[ 1236.313162] __x64_sys_sendto+0x24/0x30
[ 1236.313164] do_syscall_64+0x4e/0x110
[ 1236.313166] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1236.313167] RIP: 0033:0x7face4679ad3
[ 1236.313168] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1236.313169] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1236.313170] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1236.313170] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1236.313170] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1236.313171] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1236.313171] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1264.311978] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1264.312455] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1264.312482] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1264.312496] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1264.312497] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1264.312501] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1264.312502] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1264.312503] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1264.312504] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1264.312504] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1264.312505] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1264.312505] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1264.312506] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1264.312506] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1264.312507] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1264.312507] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1264.312508] Call Trace:
[ 1264.312511] xfrm_state_lookup+0x12/0x20
[ 1264.312514] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1264.312515] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1264.312517] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1264.312519] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1264.312521] netlink_rcv_skb+0xde/0x110
[ 1264.312523] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1264.312524] netlink_unicast+0x191/0x230
[ 1264.312525] netlink_sendmsg+0x2c4/0x390
[ 1264.312528] sock_sendmsg+0x36/0x40
[ 1264.312529] __sys_sendto+0xd8/0x150
[ 1264.312532] ? __fput+0x126/0x200
[ 1264.312533] ? kern_select+0xb9/0xe0
[ 1264.312534] __x64_sys_sendto+0x24/0x30
[ 1264.312536] do_syscall_64+0x4e/0x110
[ 1264.312538] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1264.312539] RIP: 0033:0x7face4679ad3
[ 1264.312540] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1264.312541] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1264.312542] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1264.312542] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1264.312542] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1264.312543] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1264.312543] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1292.311434] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1292.312035] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1292.312060] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1292.312074] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1292.312074] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1292.312079] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 1292.312080] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 1292.312081] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 1292.312082] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1292.312082] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1292.312083] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1292.312083] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1292.312083] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1292.312084] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1292.312085] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1292.312085] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1292.312086] Call Trace:
[ 1292.312089] xfrm_state_lookup+0x12/0x20
[ 1292.312092] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1292.312094] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1292.312095] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1292.312097] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1292.312099] netlink_rcv_skb+0xde/0x110
[ 1292.312101] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1292.312102] netlink_unicast+0x191/0x230
[ 1292.312103] netlink_sendmsg+0x2c4/0x390
[ 1292.312105] sock_sendmsg+0x36/0x40
[ 1292.312107] __sys_sendto+0xd8/0x150
[ 1292.312109] ? __fput+0x126/0x200
[ 1292.312111] ? kern_select+0xb9/0xe0
[ 1292.312112] __x64_sys_sendto+0x24/0x30
[ 1292.312114] do_syscall_64+0x4e/0x110
[ 1292.312116] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1292.312117] RIP: 0033:0x7face4679ad3
[ 1292.312118] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1292.312119] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1292.312119] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1292.312120] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1292.312120] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1292.312121] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1292.312121] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1295.517370] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1295.517937] rcu: 5-....: (1110031 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=268171
[ 1295.518873] rcu: (t=1110039 jiffies g=85505 q=3008074)
[ 1295.519339] NMI backtrace for cpu 5
[ 1295.519341] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1295.519341] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1295.519342] Call Trace:
[ 1295.519343] <IRQ>
[ 1295.519347] dump_stack+0x5c/0x7b
[ 1295.519349] nmi_cpu_backtrace+0x8a/0x90
[ 1295.519352] ? lapic_can_unplug_cpu+0x90/0x90
[ 1295.519352] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1295.519355] ? printk+0x43/0x4b
[ 1295.519357] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1295.519358] ? cpumask_next+0x16/0x20
[ 1295.519359] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1295.519360] rcu_check_callbacks+0x6a2/0x800
[ 1295.519363] ? tick_init_highres+0x20/0x20
[ 1295.519365] update_process_times+0x28/0x50
[ 1295.519366] tick_sched_timer+0x50/0x150
[ 1295.519367] __hrtimer_run_queues+0xea/0x260
[ 1295.519369] hrtimer_interrupt+0x122/0x270
[ 1295.519371] smp_apic_timer_interrupt+0x6a/0x140
[ 1295.519373] apic_timer_interrupt+0xf/0x20
[ 1295.519374] </IRQ>
[ 1295.519385] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1295.519387] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1295.519387] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1295.519388] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1295.519388] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1295.519389] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1295.519389] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1295.519390] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1295.519392] xfrm_state_lookup+0x12/0x20
[ 1295.519395] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1295.519396] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1295.519397] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1295.519409] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1295.519411] netlink_rcv_skb+0xde/0x110
[ 1295.519413] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1295.519414] netlink_unicast+0x191/0x230
[ 1295.519415] netlink_sendmsg+0x2c4/0x390
[ 1295.519417] sock_sendmsg+0x36/0x40
[ 1295.519419] __sys_sendto+0xd8/0x150
[ 1295.519421] ? __fput+0x126/0x200
[ 1295.519422] ? kern_select+0xb9/0xe0
[ 1295.519423] __x64_sys_sendto+0x24/0x30
[ 1295.519425] do_syscall_64+0x4e/0x110
[ 1295.519427] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1295.519428] RIP: 0033:0x7face4679ad3
[ 1295.519429] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1295.519429] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1295.519430] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1295.519430] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1295.519431] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1295.519431] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1295.519432] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1300.816268] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1300.816802] rcu: 5-....: (1300489 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=268198
[ 1300.817723] rcu: (detected by 7, t=1110063 jiffies, g=-1199, q=2)
[ 1300.818206] Sending NMI from CPU 7 to CPUs 5:
[ 1300.818254] NMI backtrace for cpu 5
[ 1300.818254] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1300.818254] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1300.818254] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1300.818255] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1300.818255] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 1300.818256] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1300.818256] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1300.818256] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1300.818256] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1300.818257] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1300.818257] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1300.818257] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1300.818257] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1300.818257] Call Trace:
[ 1300.818258] xfrm_state_lookup+0x12/0x20
[ 1300.818258] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1300.818258] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1300.818258] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1300.818258] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1300.818258] netlink_rcv_skb+0xde/0x110
[ 1300.818259] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1300.818259] netlink_unicast+0x191/0x230
[ 1300.818259] netlink_sendmsg+0x2c4/0x390
[ 1300.818259] sock_sendmsg+0x36/0x40
[ 1300.818259] __sys_sendto+0xd8/0x150
[ 1300.818259] ? __fput+0x126/0x200
[ 1300.818260] ? kern_select+0xb9/0xe0
[ 1300.818260] __x64_sys_sendto+0x24/0x30
[ 1300.818260] do_syscall_64+0x4e/0x110
[ 1300.818260] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1300.818260] RIP: 0033:0x7face4679ad3
[ 1300.818261] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1300.818261] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1300.818261] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1300.818261] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1300.818262] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1300.818262] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1300.818262] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1328.310748] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1328.311269] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1328.311296] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1328.311310] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1328.311310] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1328.311315] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1328.311326] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1328.311326] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1328.311327] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1328.311328] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1328.311328] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1328.311329] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1328.311329] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1328.311330] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1328.311330] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1328.311331] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1328.311331] Call Trace:
[ 1328.311334] xfrm_state_lookup+0x12/0x20
[ 1328.311337] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1328.311339] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1328.311340] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1328.311342] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1328.311344] netlink_rcv_skb+0xde/0x110
[ 1328.311346] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1328.311356] netlink_unicast+0x191/0x230
[ 1328.311358] netlink_sendmsg+0x2c4/0x390
[ 1328.311360] sock_sendmsg+0x36/0x40
[ 1328.311361] __sys_sendto+0xd8/0x150
[ 1328.311364] ? __fput+0x126/0x200
[ 1328.311365] ? kern_select+0xb9/0xe0
[ 1328.311366] __x64_sys_sendto+0x24/0x30
[ 1328.311368] do_syscall_64+0x4e/0x110
[ 1328.311370] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1328.311371] RIP: 0033:0x7face4679ad3
[ 1328.311372] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1328.311373] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1328.311374] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1328.311374] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1328.311375] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1328.311375] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1328.311376] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1356.310238] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1356.310756] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1356.310791] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1356.310805] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1356.310806] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1356.310811] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1356.310812] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1356.310812] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1356.310813] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1356.310814] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1356.310814] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1356.310815] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1356.310815] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1356.310816] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1356.310816] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1356.310817] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1356.310817] Call Trace:
[ 1356.310820] xfrm_state_lookup+0x12/0x20
[ 1356.310823] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1356.310824] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1356.310826] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1356.310828] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1356.310830] netlink_rcv_skb+0xde/0x110
[ 1356.310831] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1356.310832] netlink_unicast+0x191/0x230
[ 1356.310834] netlink_sendmsg+0x2c4/0x390
[ 1356.310836] sock_sendmsg+0x36/0x40
[ 1356.310837] __sys_sendto+0xd8/0x150
[ 1356.310840] ? __fput+0x126/0x200
[ 1356.310841] ? kern_select+0xb9/0xe0
[ 1356.310842] __x64_sys_sendto+0x24/0x30
[ 1356.310844] do_syscall_64+0x4e/0x110
[ 1356.310846] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1356.310848] RIP: 0033:0x7face4679ad3
[ 1356.310849] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1356.310849] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1356.310850] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1356.310850] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1356.310851] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1356.310851] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1356.310851] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1384.309725] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1384.310202] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1384.310230] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1384.310243] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1384.310243] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1384.310248] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1384.310249] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1384.310250] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1384.310251] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1384.310251] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1384.310252] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1384.310252] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1384.310252] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1384.310253] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1384.310254] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1384.310254] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1384.310255] Call Trace:
[ 1384.310258] xfrm_state_lookup+0x12/0x20
[ 1384.310261] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1384.310262] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1384.310264] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1384.310266] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1384.310268] netlink_rcv_skb+0xde/0x110
[ 1384.310270] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1384.310271] netlink_unicast+0x191/0x230
[ 1384.310272] netlink_sendmsg+0x2c4/0x390
[ 1384.310275] sock_sendmsg+0x36/0x40
[ 1384.310276] __sys_sendto+0xd8/0x150
[ 1384.310278] ? __fput+0x126/0x200
[ 1384.310280] ? kern_select+0xb9/0xe0
[ 1384.310281] __x64_sys_sendto+0x24/0x30
[ 1384.310283] do_syscall_64+0x4e/0x110
[ 1384.310285] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1384.310286] RIP: 0033:0x7face4679ad3
[ 1384.310287] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1384.310288] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1384.310289] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1384.310289] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1384.310290] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1384.310290] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1384.310290] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1385.518702] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1385.519179] rcu: 5-....: (1200033 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=289953
[ 1385.520031] rcu: (t=1200042 jiffies g=85505 q=3161553)
[ 1385.520497] NMI backtrace for cpu 5
[ 1385.520498] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1385.520499] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1385.520499] Call Trace:
[ 1385.520501] <IRQ>
[ 1385.520505] dump_stack+0x5c/0x7b
[ 1385.520507] nmi_cpu_backtrace+0x8a/0x90
[ 1385.520510] ? lapic_can_unplug_cpu+0x90/0x90
[ 1385.520511] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1385.520514] ? printk+0x43/0x4b
[ 1385.520516] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1385.520517] ? cpumask_next+0x16/0x20
[ 1385.520518] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1385.520520] rcu_check_callbacks+0x6a2/0x800
[ 1385.520522] ? tick_init_highres+0x20/0x20
[ 1385.520524] update_process_times+0x28/0x50
[ 1385.520525] tick_sched_timer+0x50/0x150
[ 1385.520527] __hrtimer_run_queues+0xea/0x260
[ 1385.520528] hrtimer_interrupt+0x122/0x270
[ 1385.520531] smp_apic_timer_interrupt+0x6a/0x140
[ 1385.520532] apic_timer_interrupt+0xf/0x20
[ 1385.520533] </IRQ>
[ 1385.520535] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1385.520536] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1385.520537] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1385.520538] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1385.520538] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1385.520539] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1385.520539] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1385.520539] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1385.520541] xfrm_state_lookup+0x12/0x20
[ 1385.520544] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1385.520546] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1385.520547] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1385.520549] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1385.520551] netlink_rcv_skb+0xde/0x110
[ 1385.520553] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1385.520554] netlink_unicast+0x191/0x230
[ 1385.520555] netlink_sendmsg+0x2c4/0x390
[ 1385.520558] sock_sendmsg+0x36/0x40
[ 1385.520560] __sys_sendto+0xd8/0x150
[ 1385.520563] ? __fput+0x126/0x200
[ 1385.520564] ? kern_select+0xb9/0xe0
[ 1385.520565] __x64_sys_sendto+0x24/0x30
[ 1385.520567] do_syscall_64+0x4e/0x110
[ 1385.520569] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1385.520570] RIP: 0033:0x7face4679ad3
[ 1385.520571] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1385.520572] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1385.520573] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1385.520573] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1385.520574] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1385.520574] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1385.520574] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1390.819606] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1390.820182] rcu: 5-....: (1390494 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=289981
[ 1390.821244] rcu: (detected by 0, t=1200067 jiffies, g=-1199, q=2)
[ 1390.821822] Sending NMI from CPU 0 to CPUs 5:
[ 1390.821876] NMI backtrace for cpu 5
[ 1390.821877] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1390.821877] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1390.821877] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1390.821878] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1390.821878] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 1390.821878] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1390.821879] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1390.821879] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1390.821879] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1390.821879] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1390.821880] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1390.821880] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1390.821880] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1390.821880] Call Trace:
[ 1390.821880] xfrm_state_lookup+0x12/0x20
[ 1390.821881] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1390.821881] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1390.821881] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1390.821881] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1390.821881] netlink_rcv_skb+0xde/0x110
[ 1390.821881] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1390.821882] netlink_unicast+0x191/0x230
[ 1390.821882] netlink_sendmsg+0x2c4/0x390
[ 1390.821882] sock_sendmsg+0x36/0x40
[ 1390.821882] __sys_sendto+0xd8/0x150
[ 1390.821882] ? __fput+0x126/0x200
[ 1390.821882] ? kern_select+0xb9/0xe0
[ 1390.821882] __x64_sys_sendto+0x24/0x30
[ 1390.821883] do_syscall_64+0x4e/0x110
[ 1390.821883] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1390.821883] RIP: 0033:0x7face4679ad3
[ 1390.821883] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1390.821883] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1390.821884] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1390.821884] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1390.821884] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1390.821884] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1390.821885] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1416.309138] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1416.309694] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1416.309720] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1416.309734] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1416.309735] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1416.309739] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 1416.309740] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 1416.309741] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 1416.309742] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1416.309742] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1416.309742] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1416.309743] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1416.309743] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1416.309744] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1416.309744] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1416.309745] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1416.309745] Call Trace:
[ 1416.309749] xfrm_state_lookup+0x12/0x20
[ 1416.309752] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1416.309753] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1416.309754] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1416.309757] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1416.309759] netlink_rcv_skb+0xde/0x110
[ 1416.309760] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1416.309762] netlink_unicast+0x191/0x230
[ 1416.309763] netlink_sendmsg+0x2c4/0x390
[ 1416.309765] sock_sendmsg+0x36/0x40
[ 1416.309766] __sys_sendto+0xd8/0x150
[ 1416.309769] ? __fput+0x126/0x200
[ 1416.309770] ? kern_select+0xb9/0xe0
[ 1416.309771] __x64_sys_sendto+0x24/0x30
[ 1416.309773] do_syscall_64+0x4e/0x110
[ 1416.309775] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1416.309776] RIP: 0033:0x7face4679ad3
[ 1416.309777] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1416.309778] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1416.309779] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1416.309779] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1416.309779] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1416.309780] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1416.309780] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1444.308623] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1444.309189] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1444.309214] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1444.309228] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1444.309228] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1444.309233] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1444.309234] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1444.309234] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1444.309235] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1444.309236] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1444.309236] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1444.309237] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1444.309237] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1444.309238] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1444.309238] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1444.309239] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1444.309239] Call Trace:
[ 1444.309242] xfrm_state_lookup+0x12/0x20
[ 1444.309245] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1444.309246] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1444.309247] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1444.309249] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1444.309251] netlink_rcv_skb+0xde/0x110
[ 1444.309253] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1444.309254] netlink_unicast+0x191/0x230
[ 1444.309255] netlink_sendmsg+0x2c4/0x390
[ 1444.309258] sock_sendmsg+0x36/0x40
[ 1444.309259] __sys_sendto+0xd8/0x150
[ 1444.309262] ? __fput+0x126/0x200
[ 1444.309263] ? kern_select+0xb9/0xe0
[ 1444.309264] __x64_sys_sendto+0x24/0x30
[ 1444.309266] do_syscall_64+0x4e/0x110
[ 1444.309268] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1444.309269] RIP: 0033:0x7face4679ad3
[ 1444.309270] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1444.309270] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1444.309271] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1444.309271] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1444.309272] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1444.309272] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1444.309273] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1472.308108] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1472.308599] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1472.308638] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1472.308657] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1472.308658] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1472.308664] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1472.308665] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1472.308666] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1472.308668] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1472.308669] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1472.308670] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1472.308670] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1472.308671] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1472.308673] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1472.308673] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1472.308674] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1472.308675] Call Trace:
[ 1472.308680] xfrm_state_lookup+0x12/0x20
[ 1472.308683] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1472.308685] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1472.308687] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1472.308689] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1472.308692] netlink_rcv_skb+0xde/0x110
[ 1472.308694] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1472.308695] netlink_unicast+0x191/0x230
[ 1472.308697] netlink_sendmsg+0x2c4/0x390
[ 1472.308700] sock_sendmsg+0x36/0x40
[ 1472.308701] __sys_sendto+0xd8/0x150
[ 1472.308704] ? __fput+0x126/0x200
[ 1472.308706] ? kern_select+0xb9/0xe0
[ 1472.308707] __x64_sys_sendto+0x24/0x30
[ 1472.308709] do_syscall_64+0x4e/0x110
[ 1472.308712] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1472.308713] RIP: 0033:0x7face4679ad3
[ 1472.308715] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1472.308716] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1472.308717] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1472.308718] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1472.308718] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1472.308719] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1472.308720] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1475.520047] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1475.520564] rcu: 5-....: (1290036 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=311707
[ 1475.521416] rcu: (t=1290045 jiffies g=85505 q=3298746)
[ 1475.521881] NMI backtrace for cpu 5
[ 1475.521883] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1475.521883] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1475.521884] Call Trace:
[ 1475.521886] <IRQ>
[ 1475.521890] dump_stack+0x5c/0x7b
[ 1475.521892] nmi_cpu_backtrace+0x8a/0x90
[ 1475.521895] ? lapic_can_unplug_cpu+0x90/0x90
[ 1475.521896] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1475.521899] ? printk+0x43/0x4b
[ 1475.521901] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1475.521902] ? cpumask_next+0x16/0x20
[ 1475.521903] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1475.521904] rcu_check_callbacks+0x6a2/0x800
[ 1475.521906] ? tick_init_highres+0x20/0x20
[ 1475.521909] update_process_times+0x28/0x50
[ 1475.521910] tick_sched_timer+0x50/0x150
[ 1475.521911] __hrtimer_run_queues+0xea/0x260
[ 1475.521913] hrtimer_interrupt+0x122/0x270
[ 1475.521915] smp_apic_timer_interrupt+0x6a/0x140
[ 1475.521917] apic_timer_interrupt+0xf/0x20
[ 1475.521917] </IRQ>
[ 1475.521920] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 1475.521921] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 1475.521922] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 1475.521923] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1475.521923] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1475.521924] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1475.521924] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1475.521925] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1475.521927] xfrm_state_lookup+0x12/0x20
[ 1475.521930] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1475.521931] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1475.521932] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1475.521934] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1475.521936] netlink_rcv_skb+0xde/0x110
[ 1475.521938] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1475.521939] netlink_unicast+0x191/0x230
[ 1475.521940] netlink_sendmsg+0x2c4/0x390
[ 1475.521942] sock_sendmsg+0x36/0x40
[ 1475.521944] __sys_sendto+0xd8/0x150
[ 1475.521946] ? __fput+0x126/0x200
[ 1475.521948] ? kern_select+0xb9/0xe0
[ 1475.521949] __x64_sys_sendto+0x24/0x30
[ 1475.521951] do_syscall_64+0x4e/0x110
[ 1475.521952] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1475.521953] RIP: 0033:0x7face4679ad3
[ 1475.521954] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1475.521955] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1475.521955] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1475.521956] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1475.521956] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1475.521957] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1475.521957] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1480.822949] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1480.823453] rcu: 5-....: (1480499 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=311722
[ 1480.824330] rcu: (detected by 1, t=1290073 jiffies, g=-1199, q=2)
[ 1480.824900] Sending NMI from CPU 1 to CPUs 5:
[ 1480.824977] NMI backtrace for cpu 5
[ 1480.824977] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1480.824978] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1480.824978] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 1480.824979] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 1480.824979] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 1480.824980] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1480.824980] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1480.824980] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1480.824981] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1480.824981] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1480.824981] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1480.824982] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1480.824982] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1480.824982] Call Trace:
[ 1480.824982] xfrm_state_lookup+0x12/0x20
[ 1480.824983] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1480.824983] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1480.824983] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1480.824984] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1480.824984] netlink_rcv_skb+0xde/0x110
[ 1480.824984] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1480.824984] netlink_unicast+0x191/0x230
[ 1480.824985] netlink_sendmsg+0x2c4/0x390
[ 1480.824994] sock_sendmsg+0x36/0x40
[ 1480.824994] __sys_sendto+0xd8/0x150
[ 1480.824995] ? __fput+0x126/0x200
[ 1480.824995] ? kern_select+0xb9/0xe0
[ 1480.824995] __x64_sys_sendto+0x24/0x30
[ 1480.824995] do_syscall_64+0x4e/0x110
[ 1480.824996] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1480.824996] RIP: 0033:0x7face4679ad3
[ 1480.824996] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1480.824997] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1480.824997] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1480.824997] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1480.824998] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1480.824998] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1480.824998] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1508.307442] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1508.307963] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1508.307990] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1508.308003] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1508.308004] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1508.308008] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1508.308009] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1508.308010] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1508.308011] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1508.308011] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1508.308012] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1508.308012] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1508.308013] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1508.308013] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1508.308014] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1508.308014] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1508.308015] Call Trace:
[ 1508.308018] xfrm_state_lookup+0x12/0x20
[ 1508.308021] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1508.308022] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1508.308024] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1508.308026] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1508.308028] netlink_rcv_skb+0xde/0x110
[ 1508.308029] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1508.308030] netlink_unicast+0x191/0x230
[ 1508.308032] netlink_sendmsg+0x2c4/0x390
[ 1508.308034] sock_sendmsg+0x36/0x40
[ 1508.308036] __sys_sendto+0xd8/0x150
[ 1508.308038] ? __fput+0x126/0x200
[ 1508.308039] ? kern_select+0xb9/0xe0
[ 1508.308041] __x64_sys_sendto+0x24/0x30
[ 1508.308042] do_syscall_64+0x4e/0x110
[ 1508.308045] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1508.308046] RIP: 0033:0x7face4679ad3
[ 1508.308047] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1508.308047] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1508.308048] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1508.308049] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1508.308049] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1508.308050] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1508.308050] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1536.306923] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1536.307401] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1536.307428] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1536.307442] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1536.307442] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1536.307447] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1536.307448] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1536.307449] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1536.307450] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1536.307450] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1536.307451] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1536.307451] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1536.307452] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1536.307452] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1536.307453] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1536.307453] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1536.307454] Call Trace:
[ 1536.307457] xfrm_state_lookup+0x12/0x20
[ 1536.307460] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1536.307461] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1536.307462] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1536.307465] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1536.307467] netlink_rcv_skb+0xde/0x110
[ 1536.307469] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1536.307470] netlink_unicast+0x191/0x230
[ 1536.307471] netlink_sendmsg+0x2c4/0x390
[ 1536.307473] sock_sendmsg+0x36/0x40
[ 1536.307475] __sys_sendto+0xd8/0x150
[ 1536.307477] ? __fput+0x126/0x200
[ 1536.307478] ? kern_select+0xb9/0xe0
[ 1536.307479] __x64_sys_sendto+0x24/0x30
[ 1536.307481] do_syscall_64+0x4e/0x110
[ 1536.307484] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1536.307485] RIP: 0033:0x7face4679ad3
[ 1536.307486] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1536.307486] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1536.307487] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1536.307488] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1536.307488] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1536.307488] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1536.307489] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1564.306403] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1564.306882] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1564.306908] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1564.306922] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1564.306923] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1564.306927] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1564.306929] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1564.306929] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1564.306930] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1564.306931] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1564.306931] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1564.306932] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1564.306932] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1564.306933] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1564.306933] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1564.306934] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1564.306934] Call Trace:
[ 1564.306938] xfrm_state_lookup+0x12/0x20
[ 1564.306940] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1564.306942] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1564.306943] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1564.306945] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1564.306947] netlink_rcv_skb+0xde/0x110
[ 1564.306949] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1564.306950] netlink_unicast+0x191/0x230
[ 1564.306951] netlink_sendmsg+0x2c4/0x390
[ 1564.306954] sock_sendmsg+0x36/0x40
[ 1564.306955] __sys_sendto+0xd8/0x150
[ 1564.306958] ? __fput+0x126/0x200
[ 1564.306959] ? kern_select+0xb9/0xe0
[ 1564.306960] __x64_sys_sendto+0x24/0x30
[ 1564.306962] do_syscall_64+0x4e/0x110
[ 1564.306964] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1564.306965] RIP: 0033:0x7face4679ad3
[ 1564.306966] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1564.306967] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1564.306967] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1564.306968] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1564.306968] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1564.306969] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1564.306969] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1565.521379] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1565.521918] rcu: 5-....: (1380039 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=333469
[ 1565.522863] rcu: (t=1380048 jiffies g=85505 q=3431961)
[ 1565.523330] NMI backtrace for cpu 5
[ 1565.523331] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1565.523332] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1565.523332] Call Trace:
[ 1565.523334] <IRQ>
[ 1565.523338] dump_stack+0x5c/0x7b
[ 1565.523340] nmi_cpu_backtrace+0x8a/0x90
[ 1565.523342] ? lapic_can_unplug_cpu+0x90/0x90
[ 1565.523343] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1565.523346] ? printk+0x43/0x4b
[ 1565.523348] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1565.523349] ? cpumask_next+0x16/0x20
[ 1565.523350] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1565.523352] rcu_check_callbacks+0x6a2/0x800
[ 1565.523354] ? tick_init_highres+0x20/0x20
[ 1565.523356] update_process_times+0x28/0x50
[ 1565.523357] tick_sched_timer+0x50/0x150
[ 1565.523359] __hrtimer_run_queues+0xea/0x260
[ 1565.523360] hrtimer_interrupt+0x122/0x270
[ 1565.523363] smp_apic_timer_interrupt+0x6a/0x140
[ 1565.523364] apic_timer_interrupt+0xf/0x20
[ 1565.523365] </IRQ>
[ 1565.523367] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1565.523368] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1565.523369] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1565.523370] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1565.523370] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1565.523371] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1565.523371] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1565.523371] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1565.523373] xfrm_state_lookup+0x12/0x20
[ 1565.523376] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1565.523377] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1565.523379] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1565.523382] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1565.523384] netlink_rcv_skb+0xde/0x110
[ 1565.523395] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1565.523396] netlink_unicast+0x191/0x230
[ 1565.523397] netlink_sendmsg+0x2c4/0x390
[ 1565.523400] sock_sendmsg+0x36/0x40
[ 1565.523401] __sys_sendto+0xd8/0x150
[ 1565.523404] ? __fput+0x126/0x200
[ 1565.523405] ? kern_select+0xb9/0xe0
[ 1565.523406] __x64_sys_sendto+0x24/0x30
[ 1565.523417] do_syscall_64+0x4e/0x110
[ 1565.523419] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1565.523420] RIP: 0033:0x7face4679ad3
[ 1565.523421] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1565.523421] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1565.523422] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1565.523423] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1565.523423] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1565.523423] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1565.523424] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1570.826281] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1570.826852] rcu: 5-....: (1570503 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=333534
[ 1570.827820] rcu: (detected by 1, t=1380078 jiffies, g=-1199, q=2)
[ 1570.828362] Sending NMI from CPU 1 to CPUs 5:
[ 1570.828418] NMI backtrace for cpu 5
[ 1570.828419] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1570.828419] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1570.828419] RIP: 0010:__xfrm_state_lookup+0x76/0x110
[ 1570.828420] Code: 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 <48> 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50
[ 1570.828420] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 1570.828421] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1570.828421] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1570.828422] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1570.828422] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1570.828422] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1570.828423] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1570.828423] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1570.828423] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1570.828423] Call Trace:
[ 1570.828424] xfrm_state_lookup+0x12/0x20
[ 1570.828424] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1570.828424] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1570.828425] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1570.828425] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1570.828425] netlink_rcv_skb+0xde/0x110
[ 1570.828425] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1570.828426] netlink_unicast+0x191/0x230
[ 1570.828426] netlink_sendmsg+0x2c4/0x390
[ 1570.828426] sock_sendmsg+0x36/0x40
[ 1570.828426] __sys_sendto+0xd8/0x150
[ 1570.828427] ? __fput+0x126/0x200
[ 1570.828427] ? kern_select+0xb9/0xe0
[ 1570.828427] __x64_sys_sendto+0x24/0x30
[ 1570.828427] do_syscall_64+0x4e/0x110
[ 1570.828428] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1570.828428] RIP: 0033:0x7face4679ad3
[ 1570.828428] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1570.828429] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1570.828429] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1570.828430] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1570.828430] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1570.828430] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1570.828430] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1596.305808] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1596.306327] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1596.306353] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1596.306367] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1596.306368] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1596.306372] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1596.306373] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1596.306374] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1596.306375] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1596.306375] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1596.306376] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1596.306376] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1596.306376] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1596.306377] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1596.306378] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1596.306378] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1596.306378] Call Trace:
[ 1596.306382] xfrm_state_lookup+0x12/0x20
[ 1596.306385] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1596.306386] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1596.306387] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1596.306389] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1596.306391] netlink_rcv_skb+0xde/0x110
[ 1596.306393] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1596.306394] netlink_unicast+0x191/0x230
[ 1596.306395] netlink_sendmsg+0x2c4/0x390
[ 1596.306398] sock_sendmsg+0x36/0x40
[ 1596.306399] __sys_sendto+0xd8/0x150
[ 1596.306402] ? __fput+0x126/0x200
[ 1596.306403] ? kern_select+0xb9/0xe0
[ 1596.306404] __x64_sys_sendto+0x24/0x30
[ 1596.306406] do_syscall_64+0x4e/0x110
[ 1596.306408] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1596.306409] RIP: 0033:0x7face4679ad3
[ 1596.306411] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1596.306411] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1596.306412] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1596.306412] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1596.306413] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1596.306413] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1596.306413] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1624.305286] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1624.305806] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1624.305834] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1624.305848] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1624.305848] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1624.305853] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1624.305854] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1624.305855] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1624.305855] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1624.305856] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1624.305856] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1624.305857] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1624.305857] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1624.305858] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1624.305858] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1624.305859] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1624.305859] Call Trace:
[ 1624.305862] xfrm_state_lookup+0x12/0x20
[ 1624.305865] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1624.305867] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1624.305868] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1624.305870] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1624.305872] netlink_rcv_skb+0xde/0x110
[ 1624.305874] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1624.305875] netlink_unicast+0x191/0x230
[ 1624.305876] netlink_sendmsg+0x2c4/0x390
[ 1624.305879] sock_sendmsg+0x36/0x40
[ 1624.305880] __sys_sendto+0xd8/0x150
[ 1624.305882] ? __fput+0x126/0x200
[ 1624.305883] ? kern_select+0xb9/0xe0
[ 1624.305885] __x64_sys_sendto+0x24/0x30
[ 1624.305887] do_syscall_64+0x4e/0x110
[ 1624.305889] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1624.305890] RIP: 0033:0x7face4679ad3
[ 1624.305891] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1624.305891] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1624.305892] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1624.305892] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1624.305893] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1624.305893] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1624.305894] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1652.304763] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1652.305318] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1652.305345] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1652.305359] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1652.305360] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1652.305364] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1652.305365] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1652.305366] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1652.305367] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1652.305367] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1652.305368] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1652.305368] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1652.305369] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1652.305369] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1652.305370] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1652.305370] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1652.305371] Call Trace:
[ 1652.305374] xfrm_state_lookup+0x12/0x20
[ 1652.305377] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1652.305378] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1652.305389] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1652.305391] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1652.305393] netlink_rcv_skb+0xde/0x110
[ 1652.305395] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1652.305396] netlink_unicast+0x191/0x230
[ 1652.305397] netlink_sendmsg+0x2c4/0x390
[ 1652.305400] sock_sendmsg+0x36/0x40
[ 1652.305401] __sys_sendto+0xd8/0x150
[ 1652.305403] ? __fput+0x126/0x200
[ 1652.305414] ? kern_select+0xb9/0xe0
[ 1652.305415] __x64_sys_sendto+0x24/0x30
[ 1652.305417] do_syscall_64+0x4e/0x110
[ 1652.305419] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1652.305421] RIP: 0033:0x7face4679ad3
[ 1652.305422] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1652.305422] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1652.305423] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1652.305423] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1652.305424] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1652.305424] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1652.305425] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1655.522702] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1655.523205] rcu: 5-....: (1470041 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=355237
[ 1655.524158] rcu: (t=1470051 jiffies g=85505 q=3588230)
[ 1655.524696] NMI backtrace for cpu 5
[ 1655.524698] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1655.524699] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1655.524699] Call Trace:
[ 1655.524702] <IRQ>
[ 1655.524706] dump_stack+0x5c/0x7b
[ 1655.524717] nmi_cpu_backtrace+0x8a/0x90
[ 1655.524720] ? lapic_can_unplug_cpu+0x90/0x90
[ 1655.524721] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1655.524724] ? printk+0x43/0x4b
[ 1655.524726] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1655.524727] ? cpumask_next+0x16/0x20
[ 1655.524728] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1655.524730] rcu_check_callbacks+0x6a2/0x800
[ 1655.524741] ? tick_init_highres+0x20/0x20
[ 1655.524743] update_process_times+0x28/0x50
[ 1655.524744] tick_sched_timer+0x50/0x150
[ 1655.524746] __hrtimer_run_queues+0xea/0x260
[ 1655.524748] hrtimer_interrupt+0x122/0x270
[ 1655.524750] smp_apic_timer_interrupt+0x6a/0x140
[ 1655.524751] apic_timer_interrupt+0xf/0x20
[ 1655.524752] </IRQ>
[ 1655.524754] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1655.524755] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1655.524756] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1655.524757] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1655.524757] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1655.524758] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1655.524758] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1655.524759] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1655.524761] xfrm_state_lookup+0x12/0x20
[ 1655.524763] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1655.524765] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1655.524766] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1655.524768] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1655.524771] netlink_rcv_skb+0xde/0x110
[ 1655.524772] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1655.524773] netlink_unicast+0x191/0x230
[ 1655.524774] netlink_sendmsg+0x2c4/0x390
[ 1655.524777] sock_sendmsg+0x36/0x40
[ 1655.524778] __sys_sendto+0xd8/0x150
[ 1655.524781] ? __fput+0x126/0x200
[ 1655.524782] ? kern_select+0xb9/0xe0
[ 1655.524783] __x64_sys_sendto+0x24/0x30
[ 1655.524785] do_syscall_64+0x4e/0x110
[ 1655.524786] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1655.524787] RIP: 0033:0x7face4679ad3
[ 1655.524788] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1655.524789] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1655.524790] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1655.524790] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1655.524791] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1655.524791] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1655.524792] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1660.829603] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1660.830095] rcu: 5-....: (1660507 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=355277
[ 1660.831022] rcu: (detected by 2, t=1470083 jiffies, g=-1199, q=2)
[ 1660.831618] Sending NMI from CPU 2 to CPUs 5:
[ 1660.831674] NMI backtrace for cpu 5
[ 1660.831675] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1660.831675] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1660.831675] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1660.831676] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1660.831676] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 1660.831677] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1660.831677] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1660.831687] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1660.831687] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1660.831687] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1660.831687] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1660.831687] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1660.831688] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1660.831688] Call Trace:
[ 1660.831688] xfrm_state_lookup+0x12/0x20
[ 1660.831688] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1660.831688] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1660.831689] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1660.831689] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1660.831689] netlink_rcv_skb+0xde/0x110
[ 1660.831689] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1660.831689] netlink_unicast+0x191/0x230
[ 1660.831689] netlink_sendmsg+0x2c4/0x390
[ 1660.831690] sock_sendmsg+0x36/0x40
[ 1660.831690] __sys_sendto+0xd8/0x150
[ 1660.831690] ? __fput+0x126/0x200
[ 1660.831690] ? kern_select+0xb9/0xe0
[ 1660.831690] __x64_sys_sendto+0x24/0x30
[ 1660.831690] do_syscall_64+0x4e/0x110
[ 1660.831691] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1660.831691] RIP: 0033:0x7face4679ad3
[ 1660.831691] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1660.831691] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1660.831692] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1660.831692] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1660.831692] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1660.831692] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1660.831693] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1688.304090] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1688.304568] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1688.304595] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1688.304609] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1688.304609] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1688.304614] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1688.304615] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1688.304615] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1688.304616] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1688.304617] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1688.304617] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1688.304617] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1688.304618] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1688.304619] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1688.304619] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1688.304620] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1688.304620] Call Trace:
[ 1688.304624] xfrm_state_lookup+0x12/0x20
[ 1688.304626] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1688.304628] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1688.304629] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1688.304631] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1688.304633] netlink_rcv_skb+0xde/0x110
[ 1688.304635] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1688.304636] netlink_unicast+0x191/0x230
[ 1688.304637] netlink_sendmsg+0x2c4/0x390
[ 1688.304640] sock_sendmsg+0x36/0x40
[ 1688.304641] __sys_sendto+0xd8/0x150
[ 1688.304643] ? __fput+0x126/0x200
[ 1688.304645] ? kern_select+0xb9/0xe0
[ 1688.304646] __x64_sys_sendto+0x24/0x30
[ 1688.304648] do_syscall_64+0x4e/0x110
[ 1688.304650] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1688.304652] RIP: 0033:0x7face4679ad3
[ 1688.304653] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1688.304653] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1688.304654] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1688.304655] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1688.304655] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1688.304655] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1688.304656] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1716.303578] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1716.304087] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1716.304114] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1716.304128] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1716.304128] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1716.304133] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1716.304134] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1716.304135] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 1716.304136] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1716.304136] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1716.304136] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1716.304137] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1716.304137] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1716.304138] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1716.304139] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1716.304139] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1716.304139] Call Trace:
[ 1716.304143] xfrm_state_lookup+0x12/0x20
[ 1716.304146] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1716.304147] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1716.304148] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1716.304151] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1716.304153] netlink_rcv_skb+0xde/0x110
[ 1716.304154] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1716.304155] netlink_unicast+0x191/0x230
[ 1716.304157] netlink_sendmsg+0x2c4/0x390
[ 1716.304159] sock_sendmsg+0x36/0x40
[ 1716.304160] __sys_sendto+0xd8/0x150
[ 1716.304163] ? __fput+0x126/0x200
[ 1716.304164] ? kern_select+0xb9/0xe0
[ 1716.304165] __x64_sys_sendto+0x24/0x30
[ 1716.304167] do_syscall_64+0x4e/0x110
[ 1716.304169] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1716.304170] RIP: 0033:0x7face4679ad3
[ 1716.304172] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1716.304172] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1716.304173] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1716.304173] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1716.304173] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1716.304174] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1716.304174] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1744.303110] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1744.303676] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1744.303702] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1744.303716] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1744.303716] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1744.303720] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1744.303722] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1744.303722] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1744.303723] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1744.303724] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1744.303724] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1744.303724] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1744.303725] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1744.303725] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1744.303726] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1744.303727] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1744.303727] Call Trace:
[ 1744.303730] xfrm_state_lookup+0x12/0x20
[ 1744.303733] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1744.303735] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1744.303736] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1744.303738] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1744.303740] netlink_rcv_skb+0xde/0x110
[ 1744.303742] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1744.303743] netlink_unicast+0x191/0x230
[ 1744.303744] netlink_sendmsg+0x2c4/0x390
[ 1744.303747] sock_sendmsg+0x36/0x40
[ 1744.303748] __sys_sendto+0xd8/0x150
[ 1744.303751] ? __fput+0x126/0x200
[ 1744.303752] ? kern_select+0xb9/0xe0
[ 1744.303753] __x64_sys_sendto+0x24/0x30
[ 1744.303755] do_syscall_64+0x4e/0x110
[ 1744.303757] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1744.303758] RIP: 0033:0x7face4679ad3
[ 1744.303759] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1744.303760] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1744.303760] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1744.303761] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1744.303761] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1744.303762] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1744.303762] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1745.524089] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1745.524567] rcu: 5-....: (1560043 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=376981
[ 1745.525421] rcu: (t=1560054 jiffies g=85505 q=3723360)
[ 1745.525887] NMI backtrace for cpu 5
[ 1745.525888] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1745.525889] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1745.525889] Call Trace:
[ 1745.525891] <IRQ>
[ 1745.525894] dump_stack+0x5c/0x7b
[ 1745.525897] nmi_cpu_backtrace+0x8a/0x90
[ 1745.525900] ? lapic_can_unplug_cpu+0x90/0x90
[ 1745.525901] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1745.525904] ? printk+0x43/0x4b
[ 1745.525906] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1745.525907] ? cpumask_next+0x16/0x20
[ 1745.525908] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1745.525909] rcu_check_callbacks+0x6a2/0x800
[ 1745.525912] ? tick_init_highres+0x20/0x20
[ 1745.525914] update_process_times+0x28/0x50
[ 1745.525915] tick_sched_timer+0x50/0x150
[ 1745.525916] __hrtimer_run_queues+0xea/0x260
[ 1745.525918] hrtimer_interrupt+0x122/0x270
[ 1745.525920] smp_apic_timer_interrupt+0x6a/0x140
[ 1745.525922] apic_timer_interrupt+0xf/0x20
[ 1745.525922] </IRQ>
[ 1745.525925] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1745.525926] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1745.525926] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1745.525927] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1745.525928] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1745.525928] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1745.525929] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1745.525929] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1745.525931] xfrm_state_lookup+0x12/0x20
[ 1745.525934] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1745.525936] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1745.525937] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1745.525939] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1745.525941] netlink_rcv_skb+0xde/0x110
[ 1745.525943] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1745.525944] netlink_unicast+0x191/0x230
[ 1745.525945] netlink_sendmsg+0x2c4/0x390
[ 1745.525948] sock_sendmsg+0x36/0x40
[ 1745.525949] __sys_sendto+0xd8/0x150
[ 1745.525951] ? __fput+0x126/0x200
[ 1745.525953] ? kern_select+0xb9/0xe0
[ 1745.525954] __x64_sys_sendto+0x24/0x30
[ 1745.525955] do_syscall_64+0x4e/0x110
[ 1745.525957] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1745.525958] RIP: 0033:0x7face4679ad3
[ 1745.525959] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1745.525960] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1745.525961] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1745.525961] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1745.525962] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1745.525962] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1745.525963] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1750.833000] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1750.833535] rcu: 5-....: (1750512 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=377043
[ 1750.834478] rcu: (detected by 1, t=1560088 jiffies, g=-1199, q=2)
[ 1750.835003] Sending NMI from CPU 1 to CPUs 5:
[ 1750.835078] NMI backtrace for cpu 5
[ 1750.835078] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1750.835079] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1750.835079] RIP: 0010:__xfrm_state_lookup+0x7d/0x110
[ 1750.835080] Code: 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 <74> 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75
[ 1750.835080] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 1750.835081] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1750.835081] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1750.835081] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1750.835082] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1750.835082] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1750.835082] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1750.835083] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1750.835083] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1750.835083] Call Trace:
[ 1750.835084] xfrm_state_lookup+0x12/0x20
[ 1750.835084] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1750.835084] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1750.835084] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1750.835085] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1750.835085] netlink_rcv_skb+0xde/0x110
[ 1750.835085] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1750.835085] netlink_unicast+0x191/0x230
[ 1750.835086] netlink_sendmsg+0x2c4/0x390
[ 1750.835086] sock_sendmsg+0x36/0x40
[ 1750.835086] __sys_sendto+0xd8/0x150
[ 1750.835086] ? __fput+0x126/0x200
[ 1750.835087] ? kern_select+0xb9/0xe0
[ 1750.835087] __x64_sys_sendto+0x24/0x30
[ 1750.835087] do_syscall_64+0x4e/0x110
[ 1750.835087] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1750.835088] RIP: 0033:0x7face4679ad3
[ 1750.835088] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1750.835088] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1750.835089] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1750.835089] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1750.835090] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1750.835090] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1750.835090] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1776.302571] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1776.303111] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1776.303138] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1776.303152] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1776.303152] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1776.303156] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1776.303158] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1776.303158] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1776.303159] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1776.303160] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1776.303160] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1776.303161] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1776.303161] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1776.303162] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1776.303162] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1776.303163] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1776.303163] Call Trace:
[ 1776.303166] xfrm_state_lookup+0x12/0x20
[ 1776.303169] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1776.303171] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1776.303172] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1776.303174] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1776.303176] netlink_rcv_skb+0xde/0x110
[ 1776.303178] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1776.303179] netlink_unicast+0x191/0x230
[ 1776.303180] netlink_sendmsg+0x2c4/0x390
[ 1776.303182] sock_sendmsg+0x36/0x40
[ 1776.303184] __sys_sendto+0xd8/0x150
[ 1776.303187] ? __fput+0x126/0x200
[ 1776.303188] ? kern_select+0xb9/0xe0
[ 1776.303189] __x64_sys_sendto+0x24/0x30
[ 1776.303191] do_syscall_64+0x4e/0x110
[ 1776.303193] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1776.303194] RIP: 0033:0x7face4679ad3
[ 1776.303195] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1776.303196] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1776.303197] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1776.303197] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1776.303198] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1776.303198] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1776.303199] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1804.302096] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1804.302668] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1804.302694] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1804.302707] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1804.302708] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1804.302712] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 1804.302713] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 1804.302714] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 1804.302715] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1804.302715] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1804.302716] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1804.302716] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1804.302717] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1804.302717] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1804.302718] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1804.302718] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1804.302719] Call Trace:
[ 1804.302722] xfrm_state_lookup+0x12/0x20
[ 1804.302725] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1804.302727] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1804.302728] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1804.302730] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1804.302733] netlink_rcv_skb+0xde/0x110
[ 1804.302734] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1804.302735] netlink_unicast+0x191/0x230
[ 1804.302736] netlink_sendmsg+0x2c4/0x390
[ 1804.302739] sock_sendmsg+0x36/0x40
[ 1804.302740] __sys_sendto+0xd8/0x150
[ 1804.302743] ? __fput+0x126/0x200
[ 1804.302744] ? kern_select+0xb9/0xe0
[ 1804.302745] __x64_sys_sendto+0x24/0x30
[ 1804.302747] do_syscall_64+0x4e/0x110
[ 1804.302749] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1804.302750] RIP: 0033:0x7face4679ad3
[ 1804.302751] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1804.302752] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1804.302752] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1804.302753] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1804.302754] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1804.302754] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1804.302754] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1832.301618] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1832.302095] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1832.302123] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1832.302137] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1832.302137] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1832.302142] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 1832.302143] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 1832.302144] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 1832.302145] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1832.302146] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1832.302146] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1832.302146] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1832.302147] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1832.302148] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1832.302148] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1832.302149] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1832.302149] Call Trace:
[ 1832.302152] xfrm_state_lookup+0x12/0x20
[ 1832.302155] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1832.302157] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1832.302158] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1832.302160] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1832.302163] netlink_rcv_skb+0xde/0x110
[ 1832.302164] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1832.302166] netlink_unicast+0x191/0x230
[ 1832.302167] netlink_sendmsg+0x2c4/0x390
[ 1832.302169] sock_sendmsg+0x36/0x40
[ 1832.302171] __sys_sendto+0xd8/0x150
[ 1832.302173] ? __fput+0x126/0x200
[ 1832.302174] ? kern_select+0xb9/0xe0
[ 1832.302176] __x64_sys_sendto+0x24/0x30
[ 1832.302178] do_syscall_64+0x4e/0x110
[ 1832.302180] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1832.302181] RIP: 0033:0x7face4679ad3
[ 1832.302182] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1832.302183] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1832.302183] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1832.302184] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1832.302184] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1832.302185] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1832.302185] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1835.525562] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1835.526111] rcu: 5-....: (1650046 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=398745
[ 1835.527197] rcu: (t=1650057 jiffies g=85505 q=3863912)
[ 1835.527789] NMI backtrace for cpu 5
[ 1835.527791] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1835.527791] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1835.527792] Call Trace:
[ 1835.527803] <IRQ>
[ 1835.527807] dump_stack+0x5c/0x7b
[ 1835.527809] nmi_cpu_backtrace+0x8a/0x90
[ 1835.527812] ? lapic_can_unplug_cpu+0x90/0x90
[ 1835.527813] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1835.527816] ? printk+0x43/0x4b
[ 1835.527818] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1835.527829] ? cpumask_next+0x16/0x20
[ 1835.527829] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1835.527831] rcu_check_callbacks+0x6a2/0x800
[ 1835.527833] ? tick_init_highres+0x20/0x20
[ 1835.527835] update_process_times+0x28/0x50
[ 1835.527836] tick_sched_timer+0x50/0x150
[ 1835.527838] __hrtimer_run_queues+0xea/0x260
[ 1835.527849] hrtimer_interrupt+0x122/0x270
[ 1835.527851] smp_apic_timer_interrupt+0x6a/0x140
[ 1835.527852] apic_timer_interrupt+0xf/0x20
[ 1835.527853] </IRQ>
[ 1835.527856] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 1835.527857] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 1835.527857] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 1835.527858] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1835.527858] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1835.527859] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1835.527860] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1835.527860] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1835.527862] xfrm_state_lookup+0x12/0x20
[ 1835.527875] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1835.527876] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1835.527877] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1835.527879] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1835.527881] netlink_rcv_skb+0xde/0x110
[ 1835.527883] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1835.527884] netlink_unicast+0x191/0x230
[ 1835.527885] netlink_sendmsg+0x2c4/0x390
[ 1835.527887] sock_sendmsg+0x36/0x40
[ 1835.527888] __sys_sendto+0xd8/0x150
[ 1835.527891] ? __fput+0x126/0x200
[ 1835.527892] ? kern_select+0xb9/0xe0
[ 1835.527893] __x64_sys_sendto+0x24/0x30
[ 1835.527895] do_syscall_64+0x4e/0x110
[ 1835.527896] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1835.527897] RIP: 0033:0x7face4679ad3
[ 1835.527898] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1835.527899] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1835.527900] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1835.527900] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1835.527900] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1835.527901] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1835.527901] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1840.836471] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1840.836951] rcu: 5-....: (1840516 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=398793
[ 1840.837805] rcu: (detected by 4, t=1650093 jiffies, g=-1199, q=2)
[ 1840.838275] Sending NMI from CPU 4 to CPUs 5:
[ 1840.838323] NMI backtrace for cpu 5
[ 1840.838324] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1840.838324] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1840.838324] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1840.838325] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1840.838325] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 1840.838326] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1840.838326] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1840.838326] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1840.838327] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1840.838327] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1840.838327] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1840.838327] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1840.838327] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1840.838328] Call Trace:
[ 1840.838328] xfrm_state_lookup+0x12/0x20
[ 1840.838328] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1840.838328] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1840.838328] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1840.838328] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1840.838329] netlink_rcv_skb+0xde/0x110
[ 1840.838329] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1840.838329] netlink_unicast+0x191/0x230
[ 1840.838329] netlink_sendmsg+0x2c4/0x390
[ 1840.838329] sock_sendmsg+0x36/0x40
[ 1840.838329] __sys_sendto+0xd8/0x150
[ 1840.838330] ? __fput+0x126/0x200
[ 1840.838330] ? kern_select+0xb9/0xe0
[ 1840.838330] __x64_sys_sendto+0x24/0x30
[ 1840.838330] do_syscall_64+0x4e/0x110
[ 1840.838330] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1840.838330] RIP: 0033:0x7face4679ad3
[ 1840.838331] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1840.838331] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1840.838331] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1840.838332] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1840.838332] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1840.838332] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1840.838332] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1863.635936] perf: interrupt took too long (2505 > 2500), lowering kernel.perf_event_max_sample_rate to 79000
[ 1868.301004] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1868.301618] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1868.301645] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1868.301659] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1868.301659] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1868.301663] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1868.301664] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1868.301665] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1868.301666] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1868.301666] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1868.301667] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1868.301667] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1868.301668] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1868.301668] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1868.301669] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1868.301669] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1868.301670] Call Trace:
[ 1868.301673] xfrm_state_lookup+0x12/0x20
[ 1868.301676] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1868.301677] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1868.301678] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1868.301681] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1868.301683] netlink_rcv_skb+0xde/0x110
[ 1868.301684] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1868.301685] netlink_unicast+0x191/0x230
[ 1868.301686] netlink_sendmsg+0x2c4/0x390
[ 1868.301689] sock_sendmsg+0x36/0x40
[ 1868.301690] __sys_sendto+0xd8/0x150
[ 1868.301693] ? __fput+0x126/0x200
[ 1868.301694] ? kern_select+0xb9/0xe0
[ 1868.301695] __x64_sys_sendto+0x24/0x30
[ 1868.301697] do_syscall_64+0x4e/0x110
[ 1868.301699] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1868.301700] RIP: 0033:0x7face4679ad3
[ 1868.301701] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1868.301701] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1868.301702] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1868.301702] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1868.301703] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1868.301703] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1868.301704] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1896.300526] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1896.301035] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1896.301062] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1896.301076] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1896.301076] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1896.301081] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1896.301082] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1896.301083] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1896.301083] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1896.301084] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1896.301084] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1896.301085] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1896.301085] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1896.301086] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1896.301087] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1896.301087] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1896.301088] Call Trace:
[ 1896.301091] xfrm_state_lookup+0x12/0x20
[ 1896.301093] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1896.301095] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1896.301096] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1896.301098] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1896.301101] netlink_rcv_skb+0xde/0x110
[ 1896.301102] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1896.301103] netlink_unicast+0x191/0x230
[ 1896.301104] netlink_sendmsg+0x2c4/0x390
[ 1896.301107] sock_sendmsg+0x36/0x40
[ 1896.301108] __sys_sendto+0xd8/0x150
[ 1896.301111] ? __fput+0x126/0x200
[ 1896.301112] ? kern_select+0xb9/0xe0
[ 1896.301113] __x64_sys_sendto+0x24/0x30
[ 1896.301115] do_syscall_64+0x4e/0x110
[ 1896.301117] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1896.301119] RIP: 0033:0x7face4679ad3
[ 1896.301120] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1896.301121] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1896.301122] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1896.301123] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1896.301123] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1896.301124] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1896.301124] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1924.300045] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1924.300569] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1924.300615] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1924.300628] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1924.300629] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1924.300633] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1924.300635] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1924.300635] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1924.300636] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1924.300636] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1924.300637] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1924.300637] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1924.300638] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1924.300638] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1924.300639] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1924.300639] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1924.300640] Call Trace:
[ 1924.300643] xfrm_state_lookup+0x12/0x20
[ 1924.300646] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1924.300647] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1924.300648] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1924.300650] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1924.300653] netlink_rcv_skb+0xde/0x110
[ 1924.300654] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1924.300655] netlink_unicast+0x191/0x230
[ 1924.300656] netlink_sendmsg+0x2c4/0x390
[ 1924.300659] sock_sendmsg+0x36/0x40
[ 1924.300660] __sys_sendto+0xd8/0x150
[ 1924.300672] ? __fput+0x126/0x200
[ 1924.300674] ? kern_select+0xb9/0xe0
[ 1924.300675] __x64_sys_sendto+0x24/0x30
[ 1924.300677] do_syscall_64+0x4e/0x110
[ 1924.300679] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1924.300680] RIP: 0033:0x7face4679ad3
[ 1924.300681] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1924.300681] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1924.300682] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1924.300683] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1924.300683] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1924.300683] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1924.300684] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1925.527022] rcu: INFO: rcu_sched self-detected stall on CPU
[ 1925.527585] rcu: 5-....: (1740048 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=420441
[ 1925.528637] rcu: (t=1740060 jiffies g=85505 q=4019380)
[ 1925.529296] NMI backtrace for cpu 5
[ 1925.529298] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1925.529298] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1925.529299] Call Trace:
[ 1925.529300] <IRQ>
[ 1925.529304] dump_stack+0x5c/0x7b
[ 1925.529306] nmi_cpu_backtrace+0x8a/0x90
[ 1925.529309] ? lapic_can_unplug_cpu+0x90/0x90
[ 1925.529310] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 1925.529312] ? printk+0x43/0x4b
[ 1925.529315] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 1925.529315] ? cpumask_next+0x16/0x20
[ 1925.529316] rcu_dump_cpu_stacks+0x8c/0xbc
[ 1925.529318] rcu_check_callbacks+0x6a2/0x800
[ 1925.529320] ? tick_init_highres+0x20/0x20
[ 1925.529322] update_process_times+0x28/0x50
[ 1925.529323] tick_sched_timer+0x50/0x150
[ 1925.529325] __hrtimer_run_queues+0xea/0x260
[ 1925.529326] hrtimer_interrupt+0x122/0x270
[ 1925.529328] smp_apic_timer_interrupt+0x6a/0x140
[ 1925.529330] apic_timer_interrupt+0xf/0x20
[ 1925.529330] </IRQ>
[ 1925.529333] RIP: 0010:__xfrm_state_lookup+0x71/0x110
[ 1925.529334] Code: 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 <48> 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75
[ 1925.529334] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1925.529335] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1925.529336] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1925.529336] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1925.529336] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1925.529337] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1925.529339] xfrm_state_lookup+0x12/0x20
[ 1925.529342] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1925.529343] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1925.529344] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1925.529346] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1925.529348] netlink_rcv_skb+0xde/0x110
[ 1925.529350] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1925.529351] netlink_unicast+0x191/0x230
[ 1925.529352] netlink_sendmsg+0x2c4/0x390
[ 1925.529354] sock_sendmsg+0x36/0x40
[ 1925.529356] __sys_sendto+0xd8/0x150
[ 1925.529359] ? __fput+0x126/0x200
[ 1925.529360] ? kern_select+0xb9/0xe0
[ 1925.529362] __x64_sys_sendto+0x24/0x30
[ 1925.529363] do_syscall_64+0x4e/0x110
[ 1925.529365] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1925.529366] RIP: 0033:0x7face4679ad3
[ 1925.529367] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1925.529367] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1925.529368] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1925.529368] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1925.529369] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1925.529369] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1925.529369] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1930.839933] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 1930.840452] rcu: 5-....: (1930520 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=420526
[ 1930.841424] rcu: (detected by 3, t=1740098 jiffies, g=-1199, q=2)
[ 1930.841927] Sending NMI from CPU 3 to CPUs 5:
[ 1930.841984] NMI backtrace for cpu 5
[ 1930.841984] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1930.841984] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1930.841984] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 1930.841985] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 1930.841985] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 1930.841986] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1930.841986] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1930.841986] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1930.841986] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1930.841987] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1930.841987] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1930.841987] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1930.841987] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1930.841988] Call Trace:
[ 1930.841988] xfrm_state_lookup+0x12/0x20
[ 1930.841988] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1930.841988] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1930.841988] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1930.841989] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1930.841989] netlink_rcv_skb+0xde/0x110
[ 1930.841989] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1930.841989] netlink_unicast+0x191/0x230
[ 1930.841989] netlink_sendmsg+0x2c4/0x390
[ 1930.841989] sock_sendmsg+0x36/0x40
[ 1930.841990] __sys_sendto+0xd8/0x150
[ 1930.841990] ? __fput+0x126/0x200
[ 1930.841990] ? kern_select+0xb9/0xe0
[ 1930.841990] __x64_sys_sendto+0x24/0x30
[ 1930.841990] do_syscall_64+0x4e/0x110
[ 1930.841990] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1930.841991] RIP: 0033:0x7face4679ad3
[ 1930.841991] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1930.841991] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1930.841991] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1930.841992] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1930.841992] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1930.841992] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1930.841992] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1956.299491] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 1956.300062] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1956.300088] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1956.300102] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1956.300102] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1956.300106] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1956.300108] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1956.300108] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1956.300109] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1956.300110] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1956.300110] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1956.300111] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1956.300111] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1956.300112] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1956.300113] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1956.300113] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1956.300114] Call Trace:
[ 1956.300117] xfrm_state_lookup+0x12/0x20
[ 1956.300120] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1956.300121] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1956.300123] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1956.300125] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1956.300127] netlink_rcv_skb+0xde/0x110
[ 1956.300128] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1956.300129] netlink_unicast+0x191/0x230
[ 1956.300130] netlink_sendmsg+0x2c4/0x390
[ 1956.300133] sock_sendmsg+0x36/0x40
[ 1956.300135] __sys_sendto+0xd8/0x150
[ 1956.300138] ? __fput+0x126/0x200
[ 1956.300139] ? kern_select+0xb9/0xe0
[ 1956.300140] __x64_sys_sendto+0x24/0x30
[ 1956.300142] do_syscall_64+0x4e/0x110
[ 1956.300144] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1956.300145] RIP: 0033:0x7face4679ad3
[ 1956.300146] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1956.300147] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1956.300148] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1956.300148] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1956.300148] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1956.300149] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1956.300149] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 1984.299006] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 1984.299485] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 1984.299512] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 1984.299527] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 1984.299527] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 1984.299532] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 1984.299533] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 1984.299534] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 1984.299535] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 1984.299535] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 1984.299535] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 1984.299536] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 1984.299536] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 1984.299537] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 1984.299538] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1984.299538] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 1984.299539] Call Trace:
[ 1984.299542] xfrm_state_lookup+0x12/0x20
[ 1984.299545] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 1984.299546] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 1984.299548] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 1984.299550] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 1984.299552] netlink_rcv_skb+0xde/0x110
[ 1984.299554] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 1984.299555] netlink_unicast+0x191/0x230
[ 1984.299556] netlink_sendmsg+0x2c4/0x390
[ 1984.299559] sock_sendmsg+0x36/0x40
[ 1984.299560] __sys_sendto+0xd8/0x150
[ 1984.299563] ? __fput+0x126/0x200
[ 1984.299564] ? kern_select+0xb9/0xe0
[ 1984.299565] __x64_sys_sendto+0x24/0x30
[ 1984.299567] do_syscall_64+0x4e/0x110
[ 1984.299569] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1984.299571] RIP: 0033:0x7face4679ad3
[ 1984.299572] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 1984.299572] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 1984.299573] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 1984.299573] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 1984.299574] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 1984.299574] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 1984.299575] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2012.298527] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2012.299006] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2012.299034] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2012.299048] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2012.299048] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2012.299052] RIP: 0010:__xfrm_state_lookup+0x71/0x110
[ 2012.299054] Code: 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 <48> 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75
[ 2012.299054] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2012.299055] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2012.299056] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2012.299056] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2012.299057] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2012.299057] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2012.299058] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2012.299058] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2012.299059] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2012.299059] Call Trace:
[ 2012.299063] xfrm_state_lookup+0x12/0x20
[ 2012.299066] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2012.299067] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2012.299069] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2012.299071] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2012.299073] netlink_rcv_skb+0xde/0x110
[ 2012.299075] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2012.299076] netlink_unicast+0x191/0x230
[ 2012.299077] netlink_sendmsg+0x2c4/0x390
[ 2012.299079] sock_sendmsg+0x36/0x40
[ 2012.299081] __sys_sendto+0xd8/0x150
[ 2012.299083] ? __fput+0x126/0x200
[ 2012.299084] ? kern_select+0xb9/0xe0
[ 2012.299085] __x64_sys_sendto+0x24/0x30
[ 2012.299088] do_syscall_64+0x4e/0x110
[ 2012.299090] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2012.299091] RIP: 0033:0x7face4679ad3
[ 2012.299092] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2012.299092] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2012.299093] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2012.299094] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2012.299094] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2012.299094] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2012.299095] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2015.528470] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2015.528973] rcu: 5-....: (1830050 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=442225
[ 2015.529916] rcu: (t=1830063 jiffies g=85505 q=4156615)
[ 2015.530383] NMI backtrace for cpu 5
[ 2015.530384] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2015.530385] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2015.530386] Call Trace:
[ 2015.530397] <IRQ>
[ 2015.530401] dump_stack+0x5c/0x7b
[ 2015.530403] nmi_cpu_backtrace+0x8a/0x90
[ 2015.530406] ? lapic_can_unplug_cpu+0x90/0x90
[ 2015.530407] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2015.530409] ? printk+0x43/0x4b
[ 2015.530421] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2015.530422] ? cpumask_next+0x16/0x20
[ 2015.530423] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2015.530424] rcu_check_callbacks+0x6a2/0x800
[ 2015.530427] ? tick_init_highres+0x20/0x20
[ 2015.530429] update_process_times+0x28/0x50
[ 2015.530430] tick_sched_timer+0x50/0x150
[ 2015.530431] __hrtimer_run_queues+0xea/0x260
[ 2015.530433] hrtimer_interrupt+0x122/0x270
[ 2015.530435] smp_apic_timer_interrupt+0x6a/0x140
[ 2015.530436] apic_timer_interrupt+0xf/0x20
[ 2015.530437] </IRQ>
[ 2015.530440] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 2015.530441] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 2015.530441] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 2015.530442] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2015.530443] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2015.530443] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2015.530444] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2015.530444] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2015.530446] xfrm_state_lookup+0x12/0x20
[ 2015.530450] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2015.530451] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2015.530452] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2015.530454] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2015.530456] netlink_rcv_skb+0xde/0x110
[ 2015.530458] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2015.530459] netlink_unicast+0x191/0x230
[ 2015.530460] netlink_sendmsg+0x2c4/0x390
[ 2015.530462] sock_sendmsg+0x36/0x40
[ 2015.530463] __sys_sendto+0xd8/0x150
[ 2015.530466] ? __fput+0x126/0x200
[ 2015.530467] ? kern_select+0xb9/0xe0
[ 2015.530468] __x64_sys_sendto+0x24/0x30
[ 2015.530470] do_syscall_64+0x4e/0x110
[ 2015.530472] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2015.530483] RIP: 0033:0x7face4679ad3
[ 2015.530484] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2015.530484] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2015.530485] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2015.530485] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2015.530486] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2015.530486] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2015.530487] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2020.843379] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2020.844006] rcu: 5-....: (2020524 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=442234
[ 2020.845047] rcu: (detected by 4, t=1830103 jiffies, g=-1199, q=2)
[ 2020.845676] Sending NMI from CPU 4 to CPUs 5:
[ 2020.845723] NMI backtrace for cpu 5
[ 2020.845723] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2020.845724] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2020.845724] RIP: 0010:__xfrm_state_lookup+0x7d/0x110
[ 2020.845724] Code: 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 <74> 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75
[ 2020.845724] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 2020.845725] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2020.845725] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2020.845725] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2020.845726] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2020.845726] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2020.845726] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2020.845726] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2020.845726] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2020.845727] Call Trace:
[ 2020.845727] xfrm_state_lookup+0x12/0x20
[ 2020.845727] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2020.845727] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2020.845727] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2020.845727] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2020.845728] netlink_rcv_skb+0xde/0x110
[ 2020.845728] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2020.845728] netlink_unicast+0x191/0x230
[ 2020.845728] netlink_sendmsg+0x2c4/0x390
[ 2020.845728] sock_sendmsg+0x36/0x40
[ 2020.845728] __sys_sendto+0xd8/0x150
[ 2020.845729] ? __fput+0x126/0x200
[ 2020.845729] ? kern_select+0xb9/0xe0
[ 2020.845729] __x64_sys_sendto+0x24/0x30
[ 2020.845729] do_syscall_64+0x4e/0x110
[ 2020.845729] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2020.845729] RIP: 0033:0x7face4679ad3
[ 2020.845730] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2020.845730] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2020.845730] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2020.845731] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2020.845731] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2020.845731] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2020.845731] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2048.297907] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2048.298390] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2048.298417] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2048.298431] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2048.298432] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2048.298436] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2048.298438] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2048.298438] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2048.298439] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2048.298440] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2048.298440] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2048.298440] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2048.298441] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2048.298442] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2048.298442] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2048.298443] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2048.298443] Call Trace:
[ 2048.298447] xfrm_state_lookup+0x12/0x20
[ 2048.298450] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2048.298451] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2048.298452] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2048.298455] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2048.298457] netlink_rcv_skb+0xde/0x110 [ 2048.298458] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2048.298460] netlink_unicast+0x191/0x230
[ 2048.298461] netlink_sendmsg+0x2c4/0x390
[ 2048.298463] sock_sendmsg+0x36/0x40
[ 2048.298465] __sys_sendto+0xd8/0x150
[ 2048.298467] ? __fput+0x126/0x200
[ 2048.298468] ? kern_select+0xb9/0xe0
[ 2048.298470] __x64_sys_sendto+0x24/0x30
[ 2048.298472] do_syscall_64+0x4e/0x110
[ 2048.298474] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2048.298475] RIP: 0033:0x7face4679ad3
[ 2048.298476] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2048.298476] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2048.298477] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2048.298478] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2048.298478] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2048.298479] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2048.298479] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2076.297421] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2076.297960] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2076.297987] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2076.298001] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2076.298002] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2076.298006] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2076.298008] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2076.298008] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2076.298009] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2076.298009] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2076.298010] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2076.298010] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2076.298011] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2076.298012] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2076.298012] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2076.298013] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2076.298013] Call Trace:
[ 2076.298016] xfrm_state_lookup+0x12/0x20
[ 2076.298019] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2076.298021] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2076.298022] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2076.298024] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2076.298026] netlink_rcv_skb+0xde/0x110
[ 2076.298028] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2076.298029] netlink_unicast+0x191/0x230
[ 2076.298030] netlink_sendmsg+0x2c4/0x390
[ 2076.298032] sock_sendmsg+0x36/0x40
[ 2076.298034] __sys_sendto+0xd8/0x150
[ 2076.298037] ? __fput+0x126/0x200
[ 2076.298038] ? kern_select+0xb9/0xe0
[ 2076.298039] __x64_sys_sendto+0x24/0x30
[ 2076.298041] do_syscall_64+0x4e/0x110
[ 2076.298043] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2076.298044] RIP: 0033:0x7face4679ad3
[ 2076.298045] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2076.298045] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2076.298046] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2076.298047] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2076.298047] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2076.298047] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2076.298048] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2104.296933] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2104.297464] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2104.297491] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2104.297504] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2104.297505] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2104.297509] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2104.297511] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2104.297511] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2104.297512] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2104.297513] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2104.297513] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2104.297514] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2104.297514] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2104.297515] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2104.297515] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2104.297516] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2104.297516] Call Trace:
[ 2104.297520] xfrm_state_lookup+0x12/0x20
[ 2104.297523] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2104.297524] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2104.297525] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2104.297527] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2104.297529] netlink_rcv_skb+0xde/0x110
[ 2104.297531] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2104.297532] netlink_unicast+0x191/0x230
[ 2104.297533] netlink_sendmsg+0x2c4/0x390
[ 2104.297536] sock_sendmsg+0x36/0x40
[ 2104.297537] __sys_sendto+0xd8/0x150
[ 2104.297540] ? __fput+0x126/0x200
[ 2104.297541] ? kern_select+0xb9/0xe0
[ 2104.297542] __x64_sys_sendto+0x24/0x30
[ 2104.297544] do_syscall_64+0x4e/0x110
[ 2104.297546] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2104.297547] RIP: 0033:0x7face4679ad3
[ 2104.297548] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2104.297549] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2104.297550] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2104.297550] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2104.297550] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2104.297551] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2104.297551] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2105.529910] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2105.530385] rcu: 5-....: (1920052 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=463950
[ 2105.531236] rcu: (t=1920066 jiffies g=85505 q=5287297)
[ 2105.531703] NMI backtrace for cpu 5
[ 2105.531704] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2105.531705] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2105.531705] Call Trace:
[ 2105.531707] <IRQ>
[ 2105.531711] dump_stack+0x5c/0x7b
[ 2105.531713] nmi_cpu_backtrace+0x8a/0x90
[ 2105.531716] ? lapic_can_unplug_cpu+0x90/0x90
[ 2105.531717] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2105.531720] ? printk+0x43/0x4b
[ 2105.531722] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2105.531723] ? cpumask_next+0x16/0x20
[ 2105.531724] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2105.531725] rcu_check_callbacks+0x6a2/0x800
[ 2105.531728] ? tick_init_highres+0x20/0x20
[ 2105.531730] update_process_times+0x28/0x50
[ 2105.531731] tick_sched_timer+0x50/0x150
[ 2105.531733] __hrtimer_run_queues+0xea/0x260
[ 2105.531734] hrtimer_interrupt+0x122/0x270
[ 2105.531737] smp_apic_timer_interrupt+0x6a/0x140
[ 2105.531738] apic_timer_interrupt+0xf/0x20
[ 2105.531739] </IRQ>
[ 2105.531742] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2105.531743] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2105.531743] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2105.531744] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2105.531745] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2105.531745] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2105.531746] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2105.531746] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2105.531749] xfrm_state_lookup+0x12/0x20
[ 2105.531751] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2105.531753] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2105.531754] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2105.531756] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2105.531758] netlink_rcv_skb+0xde/0x110
[ 2105.531759] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2105.531760] netlink_unicast+0x191/0x230
[ 2105.531762] netlink_sendmsg+0x2c4/0x390
[ 2105.531765] sock_sendmsg+0x36/0x40
[ 2105.531766] __sys_sendto+0xd8/0x150
[ 2105.531768] ? __fput+0x126/0x200
[ 2105.531770] ? kern_select+0xb9/0xe0
[ 2105.531771] __x64_sys_sendto+0x24/0x30
[ 2105.531773] do_syscall_64+0x4e/0x110
[ 2105.531774] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2105.531775] RIP: 0033:0x7face4679ad3
[ 2105.531776] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2105.531777] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2105.531778] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2105.531778] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2105.531778] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2105.531779] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2105.531779] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2110.846818] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2110.847315] rcu: 5-....: (2110529 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=464006
[ 2110.848230] rcu: (detected by 4, t=1920108 jiffies, g=-1199, q=2)
[ 2110.848730] Sending NMI from CPU 4 to CPUs 5:
[ 2110.848777] NMI backtrace for cpu 5
[ 2110.848777] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2110.848777] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2110.848778] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 2110.848778] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 2110.848778] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 2110.848779] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2110.848779] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2110.848779] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2110.848779] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2110.848780] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2110.848780] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2110.848780] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2110.848780] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2110.848780] Call Trace:
[ 2110.848781] xfrm_state_lookup+0x12/0x20
[ 2110.848781] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2110.848781] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2110.848781] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2110.848781] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2110.848782] netlink_rcv_skb+0xde/0x110
[ 2110.848782] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2110.848782] netlink_unicast+0x191/0x230
[ 2110.848782] netlink_sendmsg+0x2c4/0x390
[ 2110.848782] sock_sendmsg+0x36/0x40
[ 2110.848782] __sys_sendto+0xd8/0x150
[ 2110.848782] ? __fput+0x126/0x200
[ 2110.848783] ? kern_select+0xb9/0xe0
[ 2110.848783] __x64_sys_sendto+0x24/0x30
[ 2110.848783] do_syscall_64+0x4e/0x110
[ 2110.848783] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2110.848783] RIP: 0033:0x7face4679ad3
[ 2110.848784] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2110.848784] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2110.848784] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2110.848784] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2110.848785] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2110.848785] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2110.848785] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2136.296372] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2136.296890] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2136.296917] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2136.296931] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2136.296932] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2136.296936] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 2136.296937] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 2136.296938] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 2136.296939] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2136.296939] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2136.296940] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2136.296940] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2136.296941] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2136.296942] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2136.296942] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2136.296943] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2136.296943] Call Trace:
[ 2136.296947] xfrm_state_lookup+0x12/0x20
[ 2136.296950] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2136.296952] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2136.296953] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2136.296955] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2136.296958] netlink_rcv_skb+0xde/0x110
[ 2136.296960] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2136.296961] netlink_unicast+0x191/0x230
[ 2136.296962] netlink_sendmsg+0x2c4/0x390
[ 2136.296964] sock_sendmsg+0x36/0x40
[ 2136.296966] __sys_sendto+0xd8/0x150
[ 2136.296969] ? __fput+0x126/0x200
[ 2136.296970] ? kern_select+0xb9/0xe0
[ 2136.296971] __x64_sys_sendto+0x24/0x30
[ 2136.296973] do_syscall_64+0x4e/0x110
[ 2136.296975] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2136.296977] RIP: 0033:0x7face4679ad3
[ 2136.296978] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2136.296978] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2136.296979] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2136.296979] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2136.296980] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2136.296980] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2136.296980] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2164.295879] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2164.296451] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2164.296477] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2164.296491] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2164.296492] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2164.296496] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2164.296497] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2164.296498] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2164.296499] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2164.296499] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2164.296500] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2164.296500] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2164.296500] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2164.296501] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2164.296502] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2164.296502] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2164.296503] Call Trace:
[ 2164.296506] xfrm_state_lookup+0x12/0x20
[ 2164.296509] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2164.296511] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2164.296512] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2164.296514] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2164.296516] netlink_rcv_skb+0xde/0x110
[ 2164.296518] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2164.296519] netlink_unicast+0x191/0x230
[ 2164.296520] netlink_sendmsg+0x2c4/0x390
[ 2164.296523] sock_sendmsg+0x36/0x40
[ 2164.296524] __sys_sendto+0xd8/0x150
[ 2164.296527] ? __fput+0x126/0x200
[ 2164.296528] ? kern_select+0xb9/0xe0
[ 2164.296529] __x64_sys_sendto+0x24/0x30
[ 2164.296531] do_syscall_64+0x4e/0x110
[ 2164.296533] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2164.296535] RIP: 0033:0x7face4679ad3
[ 2164.296536] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2164.296536] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2164.296537] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2164.296537] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2164.296538] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2164.296538] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2164.296538] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2192.295384] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2192.295892] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2192.295920] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2192.295933] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2192.295934] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2192.295948] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2192.295950] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2192.295950] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2192.295951] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2192.295952] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2192.295952] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2192.295952] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2192.295953] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2192.295954] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2192.295954] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2192.295954] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2192.295955] Call Trace:
[ 2192.295959] xfrm_state_lookup+0x12/0x20
[ 2192.295961] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2192.295972] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2192.295974] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2192.295976] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2192.295978] netlink_rcv_skb+0xde/0x110
[ 2192.295980] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2192.295981] netlink_unicast+0x191/0x230
[ 2192.295982] netlink_sendmsg+0x2c4/0x390
[ 2192.295984] sock_sendmsg+0x36/0x40
[ 2192.295986] __sys_sendto+0xd8/0x150
[ 2192.295988] ? __fput+0x126/0x200
[ 2192.295989] ? kern_select+0xb9/0xe0
[ 2192.295990] __x64_sys_sendto+0x24/0x30
[ 2192.295992] do_syscall_64+0x4e/0x110
[ 2192.295995] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2192.295996] RIP: 0033:0x7face4679ad3
[ 2192.295997] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2192.295997] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2192.295998] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2192.295998] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2192.295999] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2192.295999] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2192.296000] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2195.531326] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2195.531864] rcu: 5-....: (2010055 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=485717
[ 2195.532775] rcu: (t=2010069 jiffies g=85505 q=5426216)
[ 2195.533271] NMI backtrace for cpu 5
[ 2195.533273] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2195.533274] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2195.533274] Call Trace:
[ 2195.533276] <IRQ>
[ 2195.533280] dump_stack+0x5c/0x7b
[ 2195.533281] nmi_cpu_backtrace+0x8a/0x90
[ 2195.533284] ? lapic_can_unplug_cpu+0x90/0x90
[ 2195.533285] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2195.533288] ? printk+0x43/0x4b
[ 2195.533290] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2195.533291] ? cpumask_next+0x16/0x20
[ 2195.533292] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2195.533293] rcu_check_callbacks+0x6a2/0x800
[ 2195.533296] ? tick_init_highres+0x20/0x20
[ 2195.533298] update_process_times+0x28/0x50
[ 2195.533299] tick_sched_timer+0x50/0x150
[ 2195.533300] __hrtimer_run_queues+0xea/0x260
[ 2195.533302] hrtimer_interrupt+0x122/0x270
[ 2195.533304] smp_apic_timer_interrupt+0x6a/0x140
[ 2195.533306] apic_timer_interrupt+0xf/0x20
[ 2195.533306] </IRQ>
[ 2195.533309] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2195.533310] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2195.533311] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2195.533311] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2195.533312] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2195.533312] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2195.533313] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2195.533313] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2195.533315] xfrm_state_lookup+0x12/0x20
[ 2195.533319] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2195.533320] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2195.533322] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2195.533324] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2195.533326] netlink_rcv_skb+0xde/0x110
[ 2195.533328] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2195.533329] netlink_unicast+0x191/0x230
[ 2195.533330] netlink_sendmsg+0x2c4/0x390
[ 2195.533343] sock_sendmsg+0x36/0x40
[ 2195.533344] __sys_sendto+0xd8/0x150
[ 2195.533347] ? __fput+0x126/0x200
[ 2195.533348] ? kern_select+0xb9/0xe0
[ 2195.533349] __x64_sys_sendto+0x24/0x30
[ 2195.533351] do_syscall_64+0x4e/0x110
[ 2195.533353] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2195.533364] RIP: 0033:0x7face4679ad3
[ 2195.533365] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2195.533365] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2195.533366] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2195.533367] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2195.533367] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2195.533368] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2195.533368] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2200.850232] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2200.850770] rcu: 5-....: (2200533 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=485847
[ 2200.851673] rcu: (detected by 1, t=2010113 jiffies, g=-1199, q=2)
[ 2200.852174] Sending NMI from CPU 1 to CPUs 5:
[ 2200.852229] NMI backtrace for cpu 5
[ 2200.852230] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2200.852230] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2200.852230] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2200.852231] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2200.852231] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 2200.852232] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2200.852232] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2200.852233] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2200.852233] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2200.852233] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2200.852233] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2200.852234] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2200.852234] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2200.852234] Call Trace:
[ 2200.852244] xfrm_state_lookup+0x12/0x20
[ 2200.852244] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2200.852245] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2200.852245] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2200.852245] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2200.852246] netlink_rcv_skb+0xde/0x110
[ 2200.852246] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2200.852246] netlink_unicast+0x191/0x230
[ 2200.852246] netlink_sendmsg+0x2c4/0x390
[ 2200.852247] sock_sendmsg+0x36/0x40
[ 2200.852247] __sys_sendto+0xd8/0x150
[ 2200.852247] ? __fput+0x126/0x200
[ 2200.852247] ? kern_select+0xb9/0xe0
[ 2200.852248] __x64_sys_sendto+0x24/0x30
[ 2200.852248] do_syscall_64+0x4e/0x110
[ 2200.852248] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2200.852248] RIP: 0033:0x7face4679ad3
[ 2200.852249] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2200.852249] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2200.852250] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2200.852250] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2200.852250] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2200.852251] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2200.852251] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2228.294748] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2228.295228] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2228.295255] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2228.295269] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2228.295269] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2228.295274] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2228.295275] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2228.295276] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2228.295277] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2228.295277] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2228.295278] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2228.295278] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2228.295278] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2228.295279] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2228.295280] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2228.295280] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2228.295280] Call Trace:
[ 2228.295284] xfrm_state_lookup+0x12/0x20
[ 2228.295287] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2228.295288] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2228.295289] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2228.295292] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2228.295294] netlink_rcv_skb+0xde/0x110
[ 2228.295295] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2228.295296] netlink_unicast+0x191/0x230
[ 2228.295298] netlink_sendmsg+0x2c4/0x390
[ 2228.295301] sock_sendmsg+0x36/0x40
[ 2228.295302] __sys_sendto+0xd8/0x150
[ 2228.295305] ? __fput+0x126/0x200
[ 2228.295306] ? kern_select+0xb9/0xe0
[ 2228.295307] __x64_sys_sendto+0x24/0x30
[ 2228.295309] do_syscall_64+0x4e/0x110
[ 2228.295311] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2228.295312] RIP: 0033:0x7face4679ad3
[ 2228.295313] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2228.295314] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2228.295315] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2228.295315] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2228.295316] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2228.295316] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2228.295316] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2256.294263] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2256.294772] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2256.294799] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2256.294812] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2256.294812] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2256.294817] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2256.294818] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2256.294819] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2256.294820] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2256.294820] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2256.294821] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2256.294821] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2256.294822] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2256.294822] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2256.294823] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2256.294824] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2256.294824] Call Trace:
[ 2256.294828] xfrm_state_lookup+0x12/0x20
[ 2256.294830] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2256.294832] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2256.294833] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2256.294835] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2256.294838] netlink_rcv_skb+0xde/0x110
[ 2256.294839] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2256.294840] netlink_unicast+0x191/0x230
[ 2256.294841] netlink_sendmsg+0x2c4/0x390
[ 2256.294844] sock_sendmsg+0x36/0x40
[ 2256.294846] __sys_sendto+0xd8/0x150
[ 2256.294848] ? __fput+0x126/0x200
[ 2256.294849] ? kern_select+0xb9/0xe0
[ 2256.294850] __x64_sys_sendto+0x24/0x30
[ 2256.294852] do_syscall_64+0x4e/0x110
[ 2256.294854] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2256.294856] RIP: 0033:0x7face4679ad3
[ 2256.294857] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2256.294857] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2256.294858] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2256.294859] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2256.294859] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2256.294859] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2256.294860] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2284.293776] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2284.294411] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2284.294437] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2284.294450] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2284.294451] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2284.294455] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2284.294457] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2284.294457] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2284.294458] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2284.294459] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2284.294459] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2284.294460] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2284.294460] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2284.294461] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2284.294461] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2284.294462] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2284.294462] Call Trace:
[ 2284.294466] xfrm_state_lookup+0x12/0x20
[ 2284.294468] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2284.294470] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2284.294471] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2284.294473] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2284.294475] netlink_rcv_skb+0xde/0x110
[ 2284.294477] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2284.294478] netlink_unicast+0x191/0x230
[ 2284.294479] netlink_sendmsg+0x2c4/0x390
[ 2284.294482] sock_sendmsg+0x36/0x40
[ 2284.294483] __sys_sendto+0xd8/0x150
[ 2284.294485] ? __fput+0x126/0x200
[ 2284.294487] ? kern_select+0xb9/0xe0
[ 2284.294488] __x64_sys_sendto+0x24/0x30
[ 2284.294490] do_syscall_64+0x4e/0x110
[ 2284.294492] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2284.294493] RIP: 0033:0x7face4679ad3
[ 2284.294494] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2284.294495] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2284.294496] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2284.294496] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2284.294496] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2284.294497] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2284.294497] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2285.532753] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2285.533418] rcu: 5-....: (2100057 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=507420
[ 2285.534497] rcu: (t=2100072 jiffies g=85505 q=5622736)
[ 2285.535121] NMI backtrace for cpu 5
[ 2285.535122] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2285.535123] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2285.535123] Call Trace:
[ 2285.535125] <IRQ>
[ 2285.535129] dump_stack+0x5c/0x7b
[ 2285.535131] nmi_cpu_backtrace+0x8a/0x90
[ 2285.535134] ? lapic_can_unplug_cpu+0x90/0x90
[ 2285.535135] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2285.535147] ? printk+0x43/0x4b
[ 2285.535149] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2285.535150] ? cpumask_next+0x16/0x20
[ 2285.535151] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2285.535152] rcu_check_callbacks+0x6a2/0x800
[ 2285.535155] ? tick_init_highres+0x20/0x20
[ 2285.535157] update_process_times+0x28/0x50
[ 2285.535158] tick_sched_timer+0x50/0x150
[ 2285.535160] __hrtimer_run_queues+0xea/0x260
[ 2285.535161] hrtimer_interrupt+0x122/0x270
[ 2285.535163] smp_apic_timer_interrupt+0x6a/0x140
[ 2285.535165] apic_timer_interrupt+0xf/0x20
[ 2285.535165] </IRQ>
[ 2285.535168] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2285.535168] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2285.535169] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2285.535170] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2285.535171] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2285.535171] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2285.535172] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2285.535172] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2285.535184] xfrm_state_lookup+0x12/0x20
[ 2285.535187] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2285.535188] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2285.535189] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2285.535192] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2285.535194] netlink_rcv_skb+0xde/0x110
[ 2285.535195] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2285.535196] netlink_unicast+0x191/0x230
[ 2285.535197] netlink_sendmsg+0x2c4/0x390
[ 2285.535200] sock_sendmsg+0x36/0x40
[ 2285.535211] __sys_sendto+0xd8/0x150
[ 2285.535213] ? __fput+0x126/0x200
[ 2285.535214] ? kern_select+0xb9/0xe0
[ 2285.535215] __x64_sys_sendto+0x24/0x30
[ 2285.535217] do_syscall_64+0x4e/0x110
[ 2285.535219] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2285.535220] RIP: 0033:0x7face4679ad3
[ 2285.535221] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2285.535221] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2285.535222] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2285.535223] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2285.535223] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2285.535224] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2285.535224] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2290.853660] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2290.854163] rcu: 5-....: (2290537 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=507561
[ 2290.855107] rcu: (detected by 6, t=2100118 jiffies, g=-1199, q=2)
[ 2290.855576] Sending NMI from CPU 6 to CPUs 5:
[ 2290.855622] NMI backtrace for cpu 5
[ 2290.855623] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2290.855623] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2290.855623] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2290.855624] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2290.855624] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 2290.855624] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2290.855624] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2290.855625] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2290.855625] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2290.855625] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2290.855625] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2290.855625] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2290.855626] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2290.855626] Call Trace:
[ 2290.855626] xfrm_state_lookup+0x12/0x20
[ 2290.855626] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2290.855626] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2290.855627] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2290.855627] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2290.855627] netlink_rcv_skb+0xde/0x110
[ 2290.855627] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2290.855627] netlink_unicast+0x191/0x230
[ 2290.855627] netlink_sendmsg+0x2c4/0x390
[ 2290.855627] sock_sendmsg+0x36/0x40
[ 2290.855628] __sys_sendto+0xd8/0x150
[ 2290.855628] ? __fput+0x126/0x200
[ 2290.855628] ? kern_select+0xb9/0xe0
[ 2290.855628] __x64_sys_sendto+0x24/0x30
[ 2290.855628] do_syscall_64+0x4e/0x110
[ 2290.855629] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2290.855629] RIP: 0033:0x7face4679ad3
[ 2290.855629] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2290.855629] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2290.855630] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2290.855630] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2290.855630] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2290.855631] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2290.855631] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2316.293216] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2316.293726] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2316.293753] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2316.293766] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2316.293767] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2316.293771] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2316.293782] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2316.293783] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2316.293783] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2316.293784] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2316.293784] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2316.293785] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2316.293785] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2316.293786] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2316.293786] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2316.293787] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2316.293787] Call Trace:
[ 2316.293791] xfrm_state_lookup+0x12/0x20
[ 2316.293794] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2316.293795] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2316.293796] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2316.293799] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2316.293810] netlink_rcv_skb+0xde/0x110
[ 2316.293812] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2316.293813] netlink_unicast+0x191/0x230
[ 2316.293814] netlink_sendmsg+0x2c4/0x390
[ 2316.293816] sock_sendmsg+0x36/0x40
[ 2316.293818] __sys_sendto+0xd8/0x150
[ 2316.293820] ? __fput+0x126/0x200
[ 2316.293822] ? kern_select+0xb9/0xe0
[ 2316.293823] __x64_sys_sendto+0x24/0x30
[ 2316.293825] do_syscall_64+0x4e/0x110
[ 2316.293827] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2316.293828] RIP: 0033:0x7face4679ad3
[ 2316.293829] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2316.293830] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2316.293830] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2316.293831] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2316.293831] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2316.293832] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2316.293832] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2344.292724] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2344.293261] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2344.293288] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2344.293303] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2344.293304] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2344.293308] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2344.293309] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2344.293310] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2344.293311] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2344.293311] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2344.293312] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2344.293312] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2344.293312] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2344.293314] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2344.293314] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2344.293315] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2344.293315] Call Trace:
[ 2344.293319] xfrm_state_lookup+0x12/0x20
[ 2344.293322] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2344.293323] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2344.293324] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2344.293327] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2344.293329] netlink_rcv_skb+0xde/0x110
[ 2344.293330] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2344.293331] netlink_unicast+0x191/0x230
[ 2344.293332] netlink_sendmsg+0x2c4/0x390
[ 2344.293335] sock_sendmsg+0x36/0x40
[ 2344.293336] __sys_sendto+0xd8/0x150
[ 2344.293339] ? __fput+0x126/0x200
[ 2344.293340] ? kern_select+0xb9/0xe0
[ 2344.293341] __x64_sys_sendto+0x24/0x30
[ 2344.293343] do_syscall_64+0x4e/0x110
[ 2344.293345] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2344.293347] RIP: 0033:0x7face4679ad3
[ 2344.293348] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2344.293348] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2344.293349] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2344.293350] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2344.293350] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2344.293350] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2344.293351] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2372.292230] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2372.292759] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2372.292787] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2372.292801] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2372.292801] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2372.292806] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2372.292807] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2372.292808] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2372.292809] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2372.292809] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2372.292810] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2372.292810] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2372.292811] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2372.292811] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2372.292812] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2372.292812] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2372.292813] Call Trace:
[ 2372.292816] xfrm_state_lookup+0x12/0x20
[ 2372.292819] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2372.292820] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2372.292822] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2372.292824] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2372.292826] netlink_rcv_skb+0xde/0x110
[ 2372.292828] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2372.292829] netlink_unicast+0x191/0x230
[ 2372.292830] netlink_sendmsg+0x2c4/0x390
[ 2372.292832] sock_sendmsg+0x36/0x40
[ 2372.292834] __sys_sendto+0xd8/0x150
[ 2372.292836] ? __fput+0x126/0x200
[ 2372.292838] ? kern_select+0xb9/0xe0
[ 2372.292839] __x64_sys_sendto+0x24/0x30
[ 2372.292841] do_syscall_64+0x4e/0x110
[ 2372.292843] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2372.292844] RIP: 0033:0x7face4679ad3
[ 2372.292845] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2372.292846] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2372.292846] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2372.292847] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2372.292847] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2372.292848] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2372.292848] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2375.534171] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2375.534673] rcu: 5-....: (2190059 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=529172
[ 2375.535578] rcu: (t=2190075 jiffies g=85505 q=5763520)
[ 2375.536079] NMI backtrace for cpu 5
[ 2375.536081] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2375.536081] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2375.536082] Call Trace:
[ 2375.536084] <IRQ>
[ 2375.536088] dump_stack+0x5c/0x7b
[ 2375.536090] nmi_cpu_backtrace+0x8a/0x90
[ 2375.536092] ? lapic_can_unplug_cpu+0x90/0x90
[ 2375.536093] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2375.536096] ? printk+0x43/0x4b
[ 2375.536098] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2375.536099] ? cpumask_next+0x16/0x20
[ 2375.536100] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2375.536101] rcu_check_callbacks+0x6a2/0x800
[ 2375.536104] ? tick_init_highres+0x20/0x20
[ 2375.536106] update_process_times+0x28/0x50
[ 2375.536107] tick_sched_timer+0x50/0x150
[ 2375.536108] __hrtimer_run_queues+0xea/0x260
[ 2375.536110] hrtimer_interrupt+0x122/0x270
[ 2375.536112] smp_apic_timer_interrupt+0x6a/0x140
[ 2375.536113] apic_timer_interrupt+0xf/0x20
[ 2375.536114] </IRQ>
[ 2375.536117] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2375.536118] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2375.536118] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2375.536119] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2375.536120] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2375.536120] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2375.536121] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2375.536121] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2375.536123] xfrm_state_lookup+0x12/0x20
[ 2375.536126] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2375.536127] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2375.536129] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2375.536131] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2375.536132] netlink_rcv_skb+0xde/0x110
[ 2375.536134] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2375.536135] netlink_unicast+0x191/0x230
[ 2375.536136] netlink_sendmsg+0x2c4/0x390
[ 2375.536138] sock_sendmsg+0x36/0x40
[ 2375.536139] __sys_sendto+0xd8/0x150
[ 2375.536142] ? __fput+0x126/0x200
[ 2375.536143] ? kern_select+0xb9/0xe0
[ 2375.536144] __x64_sys_sendto+0x24/0x30
[ 2375.536146] do_syscall_64+0x4e/0x110
[ 2375.536147] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2375.536148] RIP: 0033:0x7face4679ad3
[ 2375.536150] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2375.536150] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2375.536151] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2375.536151] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2375.536152] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2375.536152] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2375.536152] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2380.857077] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2380.857638] rcu: 5-....: (2380542 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=529340
[ 2380.858566] rcu: (detected by 7, t=2190123 jiffies, g=-1199, q=2)
[ 2380.859101] Sending NMI from CPU 7 to CPUs 5:
[ 2380.859148] NMI backtrace for cpu 5
[ 2380.859148] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2380.859149] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2380.859149] RIP: 0010:__xfrm_state_lookup+0x76/0x110
[ 2380.859149] Code: 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 <48> 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50
[ 2380.859149] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 2380.859150] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2380.859150] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2380.859150] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2380.859150] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2380.859151] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2380.859151] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2380.859151] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2380.859151] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2380.859151] Call Trace:
[ 2380.859152] xfrm_state_lookup+0x12/0x20
[ 2380.859152] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2380.859152] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2380.859152] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2380.859152] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2380.859152] netlink_rcv_skb+0xde/0x110
[ 2380.859153] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2380.859153] netlink_unicast+0x191/0x230
[ 2380.859153] netlink_sendmsg+0x2c4/0x390
[ 2380.859153] sock_sendmsg+0x36/0x40
[ 2380.859153] __sys_sendto+0xd8/0x150
[ 2380.859153] ? __fput+0x126/0x200
[ 2380.859154] ? kern_select+0xb9/0xe0
[ 2380.859154] __x64_sys_sendto+0x24/0x30
[ 2380.859154] do_syscall_64+0x4e/0x110
[ 2380.859154] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2380.859154] RIP: 0033:0x7face4679ad3
[ 2380.859155] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2380.859155] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2380.859155] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2380.859155] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2380.859156] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2380.859156] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2380.859156] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2408.291591] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2408.292194] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2408.292220] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2408.292233] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2408.292234] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2408.292238] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2408.292239] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2408.292240] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2408.292241] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2408.292241] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2408.292242] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2408.292242] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2408.292243] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2408.292243] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2408.292244] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2408.292244] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2408.292245] Call Trace:
[ 2408.292248] xfrm_state_lookup+0x12/0x20
[ 2408.292251] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2408.292252] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2408.292254] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2408.292256] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2408.292258] netlink_rcv_skb+0xde/0x110
[ 2408.292260] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2408.292261] netlink_unicast+0x191/0x230
[ 2408.292262] netlink_sendmsg+0x2c4/0x390
[ 2408.292265] sock_sendmsg+0x36/0x40
[ 2408.292266] __sys_sendto+0xd8/0x150
[ 2408.292269] ? __fput+0x126/0x200
[ 2408.292270] ? kern_select+0xb9/0xe0
[ 2408.292271] __x64_sys_sendto+0x24/0x30
[ 2408.292273] do_syscall_64+0x4e/0x110
[ 2408.292275] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2408.292276] RIP: 0033:0x7face4679ad3
[ 2408.292277] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2408.292278] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2408.292279] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2408.292279] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2408.292279] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2408.292280] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2408.292280] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2436.291093] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2436.291627] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2436.291653] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2436.291667] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2436.291668] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2436.291672] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2436.291674] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2436.291674] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2436.291675] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2436.291676] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2436.291676] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2436.291676] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2436.291677] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2436.291678] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2436.291678] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2436.291679] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2436.291679] Call Trace:
[ 2436.291683] xfrm_state_lookup+0x12/0x20
[ 2436.291686] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2436.291687] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2436.291688] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2436.291690] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2436.291692] netlink_rcv_skb+0xde/0x110
[ 2436.291694] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2436.291695] netlink_unicast+0x191/0x230
[ 2436.291696] netlink_sendmsg+0x2c4/0x390
[ 2436.291699] sock_sendmsg+0x36/0x40
[ 2436.291700] __sys_sendto+0xd8/0x150
[ 2436.291702] ? __fput+0x126/0x200
[ 2436.291704] ? kern_select+0xb9/0xe0
[ 2436.291705] __x64_sys_sendto+0x24/0x30
[ 2436.291707] do_syscall_64+0x4e/0x110
[ 2436.291709] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2436.291710] RIP: 0033:0x7face4679ad3
[ 2436.291711] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2436.291711] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2436.291712] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2436.291713] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2436.291713] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2436.291713] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2436.291714] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2464.290592] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2464.291088] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2464.291134] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2464.291147] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2464.291148] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2464.291152] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 2464.291154] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 2464.291154] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 2464.291155] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2464.291156] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2464.291156] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2464.291156] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2464.291157] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2464.291158] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2464.291158] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2464.291158] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2464.291159] Call Trace:
[ 2464.291162] xfrm_state_lookup+0x12/0x20
[ 2464.291165] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2464.291166] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2464.291168] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2464.291170] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2464.291172] netlink_rcv_skb+0xde/0x110
[ 2464.291174] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2464.291175] netlink_unicast+0x191/0x230
[ 2464.291176] netlink_sendmsg+0x2c4/0x390
[ 2464.291178] sock_sendmsg+0x36/0x40
[ 2464.291180] __sys_sendto+0xd8/0x150
[ 2464.291182] ? __fput+0x126/0x200
[ 2464.291183] ? kern_select+0xb9/0xe0
[ 2464.291184] __x64_sys_sendto+0x24/0x30
[ 2464.291187] do_syscall_64+0x4e/0x110
[ 2464.291189] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2464.291190] RIP: 0033:0x7face4679ad3
[ 2464.291191] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2464.291192] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2464.291192] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2464.291193] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2464.291193] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2464.291194] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2464.291194] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2465.535569] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2465.536075] rcu: 5-....: (2280062 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=550925
[ 2465.537014] rcu: (t=2280078 jiffies g=85505 q=5899301)
[ 2465.537530] NMI backtrace for cpu 5
[ 2465.537531] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2465.537532] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2465.537532] Call Trace:
[ 2465.537534] <IRQ>
[ 2465.537537] dump_stack+0x5c/0x7b
[ 2465.537540] nmi_cpu_backtrace+0x8a/0x90
[ 2465.537542] ? lapic_can_unplug_cpu+0x90/0x90
[ 2465.537543] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2465.537546] ? printk+0x43/0x4b
[ 2465.537548] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2465.537549] ? cpumask_next+0x16/0x20
[ 2465.537550] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2465.537551] rcu_check_callbacks+0x6a2/0x800
[ 2465.537554] ? tick_init_highres+0x20/0x20
[ 2465.537556] update_process_times+0x28/0x50
[ 2465.537557] tick_sched_timer+0x50/0x150
[ 2465.537558] __hrtimer_run_queues+0xea/0x260
[ 2465.537560] hrtimer_interrupt+0x122/0x270
[ 2465.537562] smp_apic_timer_interrupt+0x6a/0x140
[ 2465.537563] apic_timer_interrupt+0xf/0x20
[ 2465.537564] </IRQ>
[ 2465.537567] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2465.537568] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2465.537569] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2465.537570] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2465.537571] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2465.537571] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2465.537572] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2465.537572] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2465.537584] xfrm_state_lookup+0x12/0x20
[ 2465.537587] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2465.537588] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2465.537589] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2465.537592] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2465.537594] netlink_rcv_skb+0xde/0x110
[ 2465.537595] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2465.537596] netlink_unicast+0x191/0x230
[ 2465.537597] netlink_sendmsg+0x2c4/0x390
[ 2465.537600] sock_sendmsg+0x36/0x40
[ 2465.537602] __sys_sendto+0xd8/0x150
[ 2465.537613] ? __fput+0x126/0x200
[ 2465.537615] ? kern_select+0xb9/0xe0
[ 2465.537616] __x64_sys_sendto+0x24/0x30
[ 2465.537617] do_syscall_64+0x4e/0x110
[ 2465.537619] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2465.537620] RIP: 0033:0x7face4679ad3
[ 2465.537621] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2465.537622] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2465.537622] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2465.537623] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2465.537623] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2465.537624] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2465.537624] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2470.860474] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2470.861029] rcu: 5-....: (2470546 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=551127
[ 2470.862028] rcu: (detected by 4, t=2280128 jiffies, g=-1199, q=2)
[ 2470.862569] Sending NMI from CPU 4 to CPUs 5:
[ 2470.862615] NMI backtrace for cpu 5
[ 2470.862615] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2470.862616] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2470.862616] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2470.862617] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2470.862617] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 2470.862617] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2470.862618] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2470.862618] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2470.862618] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2470.862618] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2470.862618] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2470.862619] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2470.862619] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2470.862619] Call Trace:
[ 2470.862619] xfrm_state_lookup+0x12/0x20
[ 2470.862619] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2470.862619] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2470.862620] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2470.862620] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2470.862620] netlink_rcv_skb+0xde/0x110
[ 2470.862620] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2470.862620] netlink_unicast+0x191/0x230
[ 2470.862620] netlink_sendmsg+0x2c4/0x390
[ 2470.862621] sock_sendmsg+0x36/0x40
[ 2470.862621] __sys_sendto+0xd8/0x150
[ 2470.862621] ? __fput+0x126/0x200
[ 2470.862621] ? kern_select+0xb9/0xe0
[ 2470.862621] __x64_sys_sendto+0x24/0x30
[ 2470.862621] do_syscall_64+0x4e/0x110
[ 2470.862621] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2470.862622] RIP: 0033:0x7face4679ad3
[ 2470.862622] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2470.862622] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2470.862623] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2470.862623] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2470.862623] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2470.862623] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2470.862623] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2496.290018] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2496.290575] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2496.290602] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2496.290615] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2496.290615] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2496.290619] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2496.290621] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2496.290621] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2496.290622] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2496.290623] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2496.290623] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2496.290624] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2496.290624] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2496.290625] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2496.290625] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2496.290626] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2496.290626] Call Trace:
[ 2496.290630] xfrm_state_lookup+0x12/0x20
[ 2496.290632] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2496.290634] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2496.290635] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2496.290637] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2496.290639] netlink_rcv_skb+0xde/0x110
[ 2496.290641] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2496.290642] netlink_unicast+0x191/0x230
[ 2496.290643] netlink_sendmsg+0x2c4/0x390
[ 2496.290645] sock_sendmsg+0x36/0x40
[ 2496.290647] __sys_sendto+0xd8/0x150
[ 2496.290649] ? __fput+0x126/0x200
[ 2496.290651] ? kern_select+0xb9/0xe0
[ 2496.290652] __x64_sys_sendto+0x24/0x30
[ 2496.290654] do_syscall_64+0x4e/0x110
[ 2496.290656] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2496.290657] RIP: 0033:0x7face4679ad3
[ 2496.290658] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2496.290658] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2496.290659] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2496.290659] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2496.290660] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2496.290660] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2496.290661] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2524.289514] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2524.290085] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2524.290111] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2524.290124] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2524.290125] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2524.290129] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2524.290131] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2524.290131] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2524.290132] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2524.290132] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2524.290133] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2524.290133] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2524.290134] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2524.290135] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2524.290135] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2524.290136] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2524.290136] Call Trace:
[ 2524.290140] xfrm_state_lookup+0x12/0x20
[ 2524.290142] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2524.290144] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2524.290145] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2524.290147] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2524.290149] netlink_rcv_skb+0xde/0x110
[ 2524.290151] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2524.290152] netlink_unicast+0x191/0x230
[ 2524.290153] netlink_sendmsg+0x2c4/0x390
[ 2524.290156] sock_sendmsg+0x36/0x40
[ 2524.290157] __sys_sendto+0xd8/0x150
[ 2524.290160] ? __fput+0x126/0x200
[ 2524.290161] ? kern_select+0xb9/0xe0
[ 2524.290162] __x64_sys_sendto+0x24/0x30
[ 2524.290164] do_syscall_64+0x4e/0x110
[ 2524.290166] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2524.290167] RIP: 0033:0x7face4679ad3
[ 2524.290168] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2524.290169] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2524.290169] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2524.290170] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2524.290170] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2524.290171] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2524.290171] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2552.289009] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2552.289565] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2552.289591] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2552.289615] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2552.289615] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2552.289620] RIP: 0010:__xfrm_state_lookup+0x76/0x110
[ 2552.289621] Code: 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 <48> 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50
[ 2552.289622] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 2552.289623] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2552.289623] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2552.289624] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2552.289624] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2552.289625] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2552.289625] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2552.289626] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2552.289626] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2552.289627] Call Trace:
[ 2552.289640] xfrm_state_lookup+0x12/0x20
[ 2552.289642] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2552.289644] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2552.289645] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2552.289647] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2552.289649] netlink_rcv_skb+0xde/0x110
[ 2552.289651] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2552.289652] netlink_unicast+0x191/0x230
[ 2552.289653] netlink_sendmsg+0x2c4/0x390
[ 2552.289655] sock_sendmsg+0x36/0x40
[ 2552.289657] __sys_sendto+0xd8/0x150
[ 2552.289659] ? __fput+0x126/0x200
[ 2552.289661] ? kern_select+0xb9/0xe0
[ 2552.289662] __x64_sys_sendto+0x24/0x30
[ 2552.289664] do_syscall_64+0x4e/0x110
[ 2552.289666] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2552.289667] RIP: 0033:0x7face4679ad3
[ 2552.289668] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2552.289669] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2552.289670] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2552.289670] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2552.289670] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2552.289671] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2552.289671] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2555.536950] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2555.548197] rcu: 5-....: (2370064 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=572681
[ 2555.549097] rcu: (t=2370092 jiffies g=85505 q=6037628)
[ 2555.549589] NMI backtrace for cpu 5
[ 2555.549591] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2555.549591] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2555.549592] Call Trace:
[ 2555.549594] <IRQ>
[ 2555.549597] dump_stack+0x5c/0x7b
[ 2555.549599] nmi_cpu_backtrace+0x8a/0x90
[ 2555.549602] ? lapic_can_unplug_cpu+0x90/0x90
[ 2555.549603] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2555.549606] ? printk+0x43/0x4b
[ 2555.549608] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2555.549609] ? cpumask_next+0x16/0x20
[ 2555.549611] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2555.549612] rcu_check_callbacks+0x6a2/0x800
[ 2555.549615] ? tick_init_highres+0x20/0x20
[ 2555.549617] update_process_times+0x28/0x50
[ 2555.549618] tick_sched_timer+0x50/0x150
[ 2555.549620] __hrtimer_run_queues+0xea/0x260
[ 2555.549621] hrtimer_interrupt+0x122/0x270
[ 2555.549624] smp_apic_timer_interrupt+0x6a/0x140
[ 2555.549625] apic_timer_interrupt+0xf/0x20
[ 2555.549626] </IRQ>
[ 2555.549628] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2555.549629] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2555.549630] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2555.549631] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2555.549631] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2555.549632] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2555.549632] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2555.549633] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2555.549635] xfrm_state_lookup+0x12/0x20
[ 2555.549638] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2555.549639] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2555.549641] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2555.549643] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2555.549645] netlink_rcv_skb+0xde/0x110
[ 2555.549646] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2555.549647] netlink_unicast+0x191/0x230
[ 2555.549648] netlink_sendmsg+0x2c4/0x390
[ 2555.549651] sock_sendmsg+0x36/0x40
[ 2555.549652] __sys_sendto+0xd8/0x150
[ 2555.549655] ? __fput+0x126/0x200
[ 2555.549656] ? kern_select+0xb9/0xe0
[ 2555.549657] __x64_sys_sendto+0x24/0x30
[ 2555.549659] do_syscall_64+0x4e/0x110
[ 2555.549660] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2555.549662] RIP: 0033:0x7face4679ad3
[ 2555.549663] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2555.549663] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2555.549664] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2555.549664] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2555.549665] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2555.549665] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2555.549666] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2560.863854] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2560.864347] rcu: 5-....: (2560540 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=572819
[ 2560.865198] rcu: (detected by 7, t=2370133 jiffies, g=-1199, q=2)
[ 2560.865665] Sending NMI from CPU 7 to CPUs 5:
[ 2560.865713] NMI backtrace for cpu 5
[ 2560.865713] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2560.865714] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2560.865714] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2560.865714] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2560.865714] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 2560.865715] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2560.865715] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2560.865715] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2560.865716] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2560.865716] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2560.865716] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2560.865716] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2560.865716] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2560.865717] Call Trace:
[ 2560.865717] xfrm_state_lookup+0x12/0x20
[ 2560.865717] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2560.865717] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2560.865717] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2560.865717] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2560.865718] netlink_rcv_skb+0xde/0x110
[ 2560.865718] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2560.865718] netlink_unicast+0x191/0x230
[ 2560.865718] netlink_sendmsg+0x2c4/0x390
[ 2560.865718] sock_sendmsg+0x36/0x40
[ 2560.865719] __sys_sendto+0xd8/0x150
[ 2560.865719] ? __fput+0x126/0x200
[ 2560.865719] ? kern_select+0xb9/0xe0
[ 2560.865719] __x64_sys_sendto+0x24/0x30
[ 2560.865719] do_syscall_64+0x4e/0x110
[ 2560.865719] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2560.865720] RIP: 0033:0x7face4679ad3
[ 2560.865720] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2560.865720] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2560.865721] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2560.865721] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2560.865721] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2560.865722] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2560.865722] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2588.288358] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2588.288836] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2588.288865] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2588.288879] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2588.288879] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2588.288884] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2588.288885] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2588.288885] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2588.288886] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2588.288887] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2588.288887] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2588.288888] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2588.288888] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2588.288889] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2588.288889] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2588.288890] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2588.288890] Call Trace:
[ 2588.288894] xfrm_state_lookup+0x12/0x20
[ 2588.288896] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2588.288898] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2588.288899] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2588.288901] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2588.288903] netlink_rcv_skb+0xde/0x110
[ 2588.288905] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2588.288906] netlink_unicast+0x191/0x230
[ 2588.288907] netlink_sendmsg+0x2c4/0x390
[ 2588.288910] sock_sendmsg+0x36/0x40
[ 2588.288911] __sys_sendto+0xd8/0x150
[ 2588.288914] ? __fput+0x126/0x200
[ 2588.288915] ? kern_select+0xb9/0xe0
[ 2588.288916] __x64_sys_sendto+0x24/0x30
[ 2588.288918] do_syscall_64+0x4e/0x110
[ 2588.288920] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2588.288922] RIP: 0033:0x7face4679ad3
[ 2588.288923] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2588.288923] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2588.288924] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2588.288924] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2588.288925] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2588.288925] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2588.288926] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2616.287849] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2616.288359] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2616.288385] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2616.288398] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2616.288398] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2616.288403] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2616.288404] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2616.288405] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2616.288405] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2616.288406] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2616.288406] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2616.288407] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2616.288407] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2616.288408] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2616.288409] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2616.288409] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2616.288410] Call Trace:
[ 2616.288413] xfrm_state_lookup+0x12/0x20
[ 2616.288415] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2616.288417] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2616.288418] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2616.288420] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2616.288422] netlink_rcv_skb+0xde/0x110
[ 2616.288424] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2616.288425] netlink_unicast+0x191/0x230
[ 2616.288426] netlink_sendmsg+0x2c4/0x390
[ 2616.288428] sock_sendmsg+0x36/0x40
[ 2616.288430] __sys_sendto+0xd8/0x150
[ 2616.288432] ? __fput+0x126/0x200
[ 2616.288434] ? kern_select+0xb9/0xe0
[ 2616.288435] __x64_sys_sendto+0x24/0x30
[ 2616.288437] do_syscall_64+0x4e/0x110
[ 2616.288439] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2616.288440] RIP: 0033:0x7face4679ad3
[ 2616.288441] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2616.288442] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2616.288443] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2616.288443] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2616.288443] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2616.288444] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2616.288444] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2644.287340] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2644.287881] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2644.287908] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2644.287921] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2644.287922] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2644.287927] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2644.287928] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2644.287928] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2644.287929] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2644.287930] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2644.287930] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2644.287930] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2644.287931] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2644.287932] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2644.287932] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2644.287933] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2644.287933] Call Trace:
[ 2644.287937] xfrm_state_lookup+0x12/0x20
[ 2644.287940] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2644.287941] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2644.287942] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2644.287944] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2644.287946] netlink_rcv_skb+0xde/0x110
[ 2644.287958] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2644.287959] netlink_unicast+0x191/0x230
[ 2644.287960] netlink_sendmsg+0x2c4/0x390
[ 2644.287963] sock_sendmsg+0x36/0x40
[ 2644.287964] __sys_sendto+0xd8/0x150
[ 2644.287966] ? __fput+0x126/0x200
[ 2644.287968] ? kern_select+0xb9/0xe0
[ 2644.287969] __x64_sys_sendto+0x24/0x30
[ 2644.287971] do_syscall_64+0x4e/0x110
[ 2644.287983] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2644.287984] RIP: 0033:0x7face4679ad3
[ 2644.287985] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2644.287985] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2644.287986] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2644.287987] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2644.287987] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2644.287987] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2644.287988] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2645.538316] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2645.538902] rcu: 5-....: (2460056 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85070 fqs=594463
[ 2645.539834] rcu: (t=2460084 jiffies g=85505 q=6196769)
[ 2645.540341] NMI backtrace for cpu 5
[ 2645.540343] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2645.540353] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2645.540354] Call Trace:
[ 2645.540356] <IRQ>
[ 2645.540359] dump_stack+0x5c/0x7b
[ 2645.540361] nmi_cpu_backtrace+0x8a/0x90
[ 2645.540364] ? lapic_can_unplug_cpu+0x90/0x90
[ 2645.540365] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2645.540367] ? printk+0x43/0x4b
[ 2645.540370] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2645.540370] ? cpumask_next+0x16/0x20
[ 2645.540371] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2645.540373] rcu_check_callbacks+0x6a2/0x800
[ 2645.540375] ? tick_init_highres+0x20/0x20
[ 2645.540377] update_process_times+0x28/0x50
[ 2645.540378] tick_sched_timer+0x50/0x150
[ 2645.540380] __hrtimer_run_queues+0xea/0x260
[ 2645.540381] hrtimer_interrupt+0x122/0x270
[ 2645.540384] smp_apic_timer_interrupt+0x6a/0x140
[ 2645.540385] apic_timer_interrupt+0xf/0x20
[ 2645.540385] </IRQ>
[ 2645.540388] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2645.540389] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2645.540390] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2645.540390] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2645.540391] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2645.540391] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2645.540392] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2645.540392] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2645.540395] xfrm_state_lookup+0x12/0x20
[ 2645.540399] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2645.540400] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2645.540402] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2645.540404] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2645.540406] netlink_rcv_skb+0xde/0x110
[ 2645.540407] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2645.540408] netlink_unicast+0x191/0x230
[ 2645.540409] netlink_sendmsg+0x2c4/0x390
[ 2645.540412] sock_sendmsg+0x36/0x40
[ 2645.540413] __sys_sendto+0xd8/0x150
[ 2645.540415] ? __fput+0x126/0x200
[ 2645.540417] ? kern_select+0xb9/0xe0
[ 2645.540418] __x64_sys_sendto+0x24/0x30
[ 2645.540420] do_syscall_64+0x4e/0x110
[ 2645.540421] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2645.540422] RIP: 0033:0x7face4679ad3
[ 2645.540424] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2645.540424] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2645.540425] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2645.540425] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2645.540426] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2645.540426] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2645.540427] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2650.867219] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2650.867790] rcu: 5-....: (2650544 ticks this GP) idle=92a/1/0x4000000000000000 softirq=0/85070 fqs=594614
[ 2650.868650] rcu: (detected by 6, t=2460138 jiffies, g=-1199, q=2)
[ 2650.869134] Sending NMI from CPU 6 to CPUs 5:
[ 2650.869181] NMI backtrace for cpu 5
[ 2650.869182] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2650.869182] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2650.869183] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2650.869183] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2650.869183] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 2650.869184] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2650.869184] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2650.869184] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2650.869184] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2650.869185] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2650.869185] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2650.869185] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2650.869185] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2650.869185] Call Trace:
[ 2650.869186] xfrm_state_lookup+0x12/0x20
[ 2650.869186] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2650.869186] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2650.869186] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2650.869186] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2650.869186] netlink_rcv_skb+0xde/0x110
[ 2650.869187] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2650.869187] netlink_unicast+0x191/0x230
[ 2650.869187] netlink_sendmsg+0x2c4/0x390
[ 2650.869187] sock_sendmsg+0x36/0x40
[ 2650.869187] __sys_sendto+0xd8/0x150
[ 2650.869187] ? __fput+0x126/0x200
[ 2650.869188] ? kern_select+0xb9/0xe0
[ 2650.869188] __x64_sys_sendto+0x24/0x30
[ 2650.869188] do_syscall_64+0x4e/0x110
[ 2650.869188] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2650.869188] RIP: 0033:0x7face4679ad3
[ 2650.869189] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2650.869189] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2650.869189] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2650.869189] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2650.869190] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2650.869190] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2650.869190] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2676.286756] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2676.287326] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2676.287352] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2676.287366] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2676.287367] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2676.287371] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2676.287372] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2676.287373] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2676.287374] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2676.287374] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2676.287375] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2676.287375] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2676.287376] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2676.287376] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2676.287377] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2676.287377] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2676.287378] Call Trace:
[ 2676.287381] xfrm_state_lookup+0x12/0x20
[ 2676.287383] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2676.287385] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2676.287386] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2676.287388] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2676.287391] netlink_rcv_skb+0xde/0x110
[ 2676.287392] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2676.287393] netlink_unicast+0x191/0x230
[ 2676.287394] netlink_sendmsg+0x2c4/0x390
[ 2676.287397] sock_sendmsg+0x36/0x40
[ 2676.287399] __sys_sendto+0xd8/0x150
[ 2676.287401] ? __fput+0x126/0x200
[ 2676.287402] ? kern_select+0xb9/0xe0
[ 2676.287403] __x64_sys_sendto+0x24/0x30
[ 2676.287405] do_syscall_64+0x4e/0x110
[ 2676.287408] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2676.287409] RIP: 0033:0x7face4679ad3
[ 2676.287410] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2676.287411] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2676.287411] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2676.287412] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2676.287412] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2676.287413] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2676.287413] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2704.286244] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2704.286722] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2704.286749] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2704.286762] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2704.286763] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2704.286767] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2704.286768] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2704.286769] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2704.286770] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2704.286770] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2704.286771] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2704.286771] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2704.286772] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2704.286772] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2704.286773] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2704.286773] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2704.286774] Call Trace:
[ 2704.286777] xfrm_state_lookup+0x12/0x20
[ 2704.286780] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2704.286781] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2704.286783] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2704.286785] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2704.286787] netlink_rcv_skb+0xde/0x110
[ 2704.286789] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2704.286790] netlink_unicast+0x191/0x230
[ 2704.286791] netlink_sendmsg+0x2c4/0x390
[ 2704.286794] sock_sendmsg+0x36/0x40
[ 2704.286795] __sys_sendto+0xd8/0x150
[ 2704.286798] ? __fput+0x126/0x200
[ 2704.286799] ? kern_select+0xb9/0xe0
[ 2704.286800] __x64_sys_sendto+0x24/0x30
[ 2704.286802] do_syscall_64+0x4e/0x110
[ 2704.286804] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2704.286806] RIP: 0033:0x7face4679ad3
[ 2704.286807] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2704.286807] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2704.286808] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2704.286809] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2704.286809] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2704.286809] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2704.286810] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2732.285731] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2732.286210] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2732.286237] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2732.286251] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2732.286251] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2732.286255] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2732.286257] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2732.286257] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2732.286258] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2732.286259] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2732.286259] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2732.286259] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2732.286260] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2732.286261] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2732.286261] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2732.286262] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2732.286262] Call Trace:
[ 2732.286266] xfrm_state_lookup+0x12/0x20
[ 2732.286268] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2732.286270] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2732.286271] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2732.286273] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2732.286276] netlink_rcv_skb+0xde/0x110
[ 2732.286277] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2732.286278] netlink_unicast+0x191/0x230
[ 2732.286279] netlink_sendmsg+0x2c4/0x390
[ 2732.286282] sock_sendmsg+0x36/0x40
[ 2732.286283] __sys_sendto+0xd8/0x150
[ 2732.286286] ? __fput+0x126/0x200
[ 2732.286287] ? kern_select+0xb9/0xe0
[ 2732.286288] __x64_sys_sendto+0x24/0x30
[ 2732.286290] do_syscall_64+0x4e/0x110
[ 2732.286292] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2732.286294] RIP: 0033:0x7face4679ad3
[ 2732.286294] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2732.286295] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2732.286296] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2732.286296] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2732.286296] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2732.286297] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2732.286297] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2735.539670] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2735.540173] rcu: 5-....: (2550049 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85071 fqs=616256
[ 2735.541110] rcu: (t=2550087 jiffies g=85505 q=6334055)
[ 2735.541608] NMI backtrace for cpu 5
[ 2735.541610] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2735.541611] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2735.541611] Call Trace:
[ 2735.541613] <IRQ>
[ 2735.541617] dump_stack+0x5c/0x7b
[ 2735.541619] nmi_cpu_backtrace+0x8a/0x90
[ 2735.541621] ? lapic_can_unplug_cpu+0x90/0x90
[ 2735.541622] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2735.541625] ? printk+0x43/0x4b
[ 2735.541628] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2735.541629] ? cpumask_next+0x16/0x20
[ 2735.541629] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2735.541631] rcu_check_callbacks+0x6a2/0x800
[ 2735.541633] ? tick_init_highres+0x20/0x20
[ 2735.541635] update_process_times+0x28/0x50
[ 2735.541636] tick_sched_timer+0x50/0x150
[ 2735.541638] __hrtimer_run_queues+0xea/0x260
[ 2735.541639] hrtimer_interrupt+0x122/0x270
[ 2735.541642] smp_apic_timer_interrupt+0x6a/0x140
[ 2735.541643] apic_timer_interrupt+0xf/0x20
[ 2735.541644] </IRQ>
[ 2735.541646] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 2735.541647] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 2735.541648] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 2735.541649] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2735.541649] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2735.541649] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2735.541650] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2735.541650] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2735.541653] xfrm_state_lookup+0x12/0x20
[ 2735.541656] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2735.541657] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2735.541658] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2735.541660] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2735.541662] netlink_rcv_skb+0xde/0x110
[ 2735.541664] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2735.541664] netlink_unicast+0x191/0x230
[ 2735.541666] netlink_sendmsg+0x2c4/0x390
[ 2735.541668] sock_sendmsg+0x36/0x40
[ 2735.541670] __sys_sendto+0xd8/0x150
[ 2735.541672] ? __fput+0x126/0x200
[ 2735.541683] ? kern_select+0xb9/0xe0
[ 2735.541684] __x64_sys_sendto+0x24/0x30
[ 2735.541686] do_syscall_64+0x4e/0x110
[ 2735.541688] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2735.541689] RIP: 0033:0x7face4679ad3
[ 2735.541690] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2735.541691] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2735.541692] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2735.541692] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2735.541693] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2735.541693] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2735.541694] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2740.870573] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2740.871084] rcu: 5-....: (27769 ticks this GP) idle=92a/1/0x4000000000000000 softirq=85071/85071 fqs=616404
[ 2740.871998] rcu: (detected by 1, t=2550143 jiffies, g=-1199, q=2)
[ 2740.872514] Sending NMI from CPU 1 to CPUs 5:
[ 2740.872579] NMI backtrace for cpu 5
[ 2740.872580] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2740.872580] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2740.872581] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2740.872581] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2740.872582] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 2740.872582] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2740.872583] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2740.872583] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2740.872583] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2740.872593] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2740.872593] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2740.872594] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2740.872594] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2740.872594] Call Trace:
[ 2740.872594] xfrm_state_lookup+0x12/0x20
[ 2740.872595] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2740.872595] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2740.872595] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2740.872596] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2740.872596] netlink_rcv_skb+0xde/0x110
[ 2740.872596] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2740.872596] netlink_unicast+0x191/0x230
[ 2740.872597] netlink_sendmsg+0x2c4/0x390
[ 2740.872597] sock_sendmsg+0x36/0x40
[ 2740.872597] __sys_sendto+0xd8/0x150
[ 2740.872597] ? __fput+0x126/0x200
[ 2740.872597] ? kern_select+0xb9/0xe0
[ 2740.872598] __x64_sys_sendto+0x24/0x30
[ 2740.872598] do_syscall_64+0x4e/0x110
[ 2740.872598] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2740.872598] RIP: 0033:0x7face4679ad3
[ 2740.872599] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2740.872599] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2740.872600] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2740.872600] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2740.872601] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2740.872601] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2740.872601] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2768.285070] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2768.285599] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2768.285635] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2768.285658] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2768.285659] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2768.285663] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2768.285664] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2768.285664] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2768.285665] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2768.285666] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2768.285666] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2768.285667] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2768.285667] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2768.285668] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2768.285668] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2768.285669] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2768.285669] Call Trace:
[ 2768.285672] xfrm_state_lookup+0x12/0x20
[ 2768.285675] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2768.285676] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2768.285678] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2768.285680] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2768.285682] netlink_rcv_skb+0xde/0x110
[ 2768.285683] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2768.285684] netlink_unicast+0x191/0x230
[ 2768.285685] netlink_sendmsg+0x2c4/0x390
[ 2768.285688] sock_sendmsg+0x36/0x40
[ 2768.285689] __sys_sendto+0xd8/0x150
[ 2768.285692] ? __fput+0x126/0x200
[ 2768.285693] ? kern_select+0xb9/0xe0
[ 2768.285694] __x64_sys_sendto+0x24/0x30
[ 2768.285696] do_syscall_64+0x4e/0x110
[ 2768.285698] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2768.285699] RIP: 0033:0x7face4679ad3
[ 2768.285700] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2768.285700] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2768.285701] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2768.285702] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2768.285702] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2768.285703] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2768.285703] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2796.284554] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2796.285109] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2796.285136] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2796.285150] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2796.285150] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2796.285154] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2796.285156] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2796.285156] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2796.285157] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2796.285158] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2796.285158] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2796.285159] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2796.285159] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2796.285160] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2796.285160] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2796.285161] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2796.285161] Call Trace:
[ 2796.285165] xfrm_state_lookup+0x12/0x20
[ 2796.285168] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2796.285169] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2796.285170] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2796.285172] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2796.285174] netlink_rcv_skb+0xde/0x110
[ 2796.285176] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2796.285177] netlink_unicast+0x191/0x230
[ 2796.285178] netlink_sendmsg+0x2c4/0x390
[ 2796.285181] sock_sendmsg+0x36/0x40
[ 2796.285182] __sys_sendto+0xd8/0x150
[ 2796.285185] ? __fput+0x126/0x200
[ 2796.285186] ? kern_select+0xb9/0xe0
[ 2796.285187] __x64_sys_sendto+0x24/0x30
[ 2796.285189] do_syscall_64+0x4e/0x110
[ 2796.285191] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2796.285192] RIP: 0033:0x7face4679ad3
[ 2796.285193] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2796.285193] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2796.285194] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2796.285195] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2796.285195] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2796.285195] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2796.285196] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2824.284038] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2824.284594] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2824.284620] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2824.284634] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2824.284635] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2824.284639] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2824.284640] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2824.284641] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2824.284642] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2824.284642] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2824.284643] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2824.284643] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2824.284644] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2824.284644] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2824.284645] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2824.284645] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2824.284646] Call Trace:
[ 2824.284649] xfrm_state_lookup+0x12/0x20
[ 2824.284652] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2824.284653] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2824.284655] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2824.284657] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2824.284659] netlink_rcv_skb+0xde/0x110
[ 2824.284661] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2824.284662] netlink_unicast+0x191/0x230
[ 2824.284663] netlink_sendmsg+0x2c4/0x390
[ 2824.284666] sock_sendmsg+0x36/0x40
[ 2824.284667] __sys_sendto+0xd8/0x150
[ 2824.284670] ? __fput+0x126/0x200
[ 2824.284671] ? kern_select+0xb9/0xe0
[ 2824.284672] __x64_sys_sendto+0x24/0x30
[ 2824.284674] do_syscall_64+0x4e/0x110
[ 2824.284686] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2824.284687] RIP: 0033:0x7face4679ad3
[ 2824.284688] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2824.284689] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2824.284690] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2824.284690] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2824.284691] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2824.284691] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2824.284691] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2825.541014] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2825.541489] rcu: 5-....: (2640051 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85071 fqs=638023
[ 2825.542340] rcu: (t=2640090 jiffies g=85505 q=6468391)
[ 2825.542807] NMI backtrace for cpu 5
[ 2825.542808] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2825.542809] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2825.542810] Call Trace:
[ 2825.542812] <IRQ>
[ 2825.542816] dump_stack+0x5c/0x7b
[ 2825.542818] nmi_cpu_backtrace+0x8a/0x90
[ 2825.542821] ? lapic_can_unplug_cpu+0x90/0x90
[ 2825.542822] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2825.542824] ? printk+0x43/0x4b
[ 2825.542827] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2825.542828] ? cpumask_next+0x16/0x20
[ 2825.542829] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2825.542830] rcu_check_callbacks+0x6a2/0x800
[ 2825.542833] ? tick_init_highres+0x20/0x20
[ 2825.542835] update_process_times+0x28/0x50
[ 2825.542836] tick_sched_timer+0x50/0x150
[ 2825.542837] __hrtimer_run_queues+0xea/0x260
[ 2825.542839] hrtimer_interrupt+0x122/0x270
[ 2825.542841] smp_apic_timer_interrupt+0x6a/0x140
[ 2825.542843] apic_timer_interrupt+0xf/0x20
[ 2825.542843] </IRQ>
[ 2825.542846] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 2825.542847] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 2825.542848] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 2825.542849] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2825.542849] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2825.542850] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2825.542850] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2825.542851] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2825.542853] xfrm_state_lookup+0x12/0x20
[ 2825.542856] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2825.542858] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2825.542859] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2825.542861] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2825.542863] netlink_rcv_skb+0xde/0x110
[ 2825.542865] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2825.542866] netlink_unicast+0x191/0x230
[ 2825.542867] netlink_sendmsg+0x2c4/0x390
[ 2825.542870] sock_sendmsg+0x36/0x40
[ 2825.542871] __sys_sendto+0xd8/0x150
[ 2825.542874] ? __fput+0x126/0x200
[ 2825.542875] ? kern_select+0xb9/0xe0
[ 2825.542876] __x64_sys_sendto+0x24/0x30
[ 2825.542878] do_syscall_64+0x4e/0x110
[ 2825.542879] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2825.542881] RIP: 0033:0x7face4679ad3
[ 2825.542882] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2825.542882] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2825.542883] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2825.542883] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2825.542884] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2825.542884] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2825.542885] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2830.873916] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2830.874450] rcu: 5-....: (117774 ticks this GP) idle=92a/1/0x4000000000000000 softirq=85071/85071 fqs=638176
[ 2830.875348] rcu: (detected by 1, t=2640148 jiffies, g=-1199, q=2)
[ 2830.875888] Sending NMI from CPU 1 to CPUs 5:
[ 2830.875963] NMI backtrace for cpu 5
[ 2830.875964] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2830.875964] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2830.875964] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2830.875965] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2830.875965] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 2830.875966] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2830.875966] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2830.875966] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2830.875967] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2830.875967] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2830.875967] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2830.875968] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2830.875968] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2830.875968] Call Trace:
[ 2830.875968] xfrm_state_lookup+0x12/0x20
[ 2830.875969] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2830.875969] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2830.875969] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2830.875970] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2830.875970] netlink_rcv_skb+0xde/0x110
[ 2830.875970] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2830.875970] netlink_unicast+0x191/0x230
[ 2830.875971] netlink_sendmsg+0x2c4/0x390
[ 2830.875971] sock_sendmsg+0x36/0x40
[ 2830.875971] __sys_sendto+0xd8/0x150
[ 2830.875971] ? __fput+0x126/0x200
[ 2830.875972] ? kern_select+0xb9/0xe0
[ 2830.875972] __x64_sys_sendto+0x24/0x30
[ 2830.875972] do_syscall_64+0x4e/0x110
[ 2830.875972] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2830.875973] RIP: 0033:0x7face4679ad3
[ 2830.875973] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2830.875974] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2830.875975] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2830.875975] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2830.875975] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2830.875975] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2830.875976] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2856.283447] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2856.283973] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2856.284000] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2856.284013] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2856.284013] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2856.284018] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2856.284019] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2856.284020] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2856.284021] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2856.284021] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2856.284022] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2856.284022] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2856.284022] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2856.284023] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2856.284024] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2856.284024] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2856.284024] Call Trace:
[ 2856.284028] xfrm_state_lookup+0x12/0x20
[ 2856.284030] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2856.284032] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2856.284043] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2856.284045] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2856.284047] netlink_rcv_skb+0xde/0x110
[ 2856.284048] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2856.284049] netlink_unicast+0x191/0x230
[ 2856.284050] netlink_sendmsg+0x2c4/0x390
[ 2856.284053] sock_sendmsg+0x36/0x40
[ 2856.284054] __sys_sendto+0xd8/0x150
[ 2856.284057] ? __fput+0x126/0x200
[ 2856.284058] ? kern_select+0xb9/0xe0
[ 2856.284059] __x64_sys_sendto+0x24/0x30
[ 2856.284071] do_syscall_64+0x4e/0x110
[ 2856.284073] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2856.284074] RIP: 0033:0x7face4679ad3
[ 2856.284075] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2856.284076] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2856.284076] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2856.284077] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2856.284077] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2856.284078] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2856.284078] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2884.282930] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2884.283437] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2884.283463] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2884.283477] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2884.283478] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2884.283482] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 2884.283483] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 2884.283484] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 2884.283485] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2884.283485] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2884.283486] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2884.283486] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2884.283487] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2884.283487] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2884.283488] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2884.283488] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2884.283489] Call Trace:
[ 2884.283492] xfrm_state_lookup+0x12/0x20
[ 2884.283495] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2884.283496] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2884.283498] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2884.283500] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2884.283502] netlink_rcv_skb+0xde/0x110
[ 2884.283504] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2884.283505] netlink_unicast+0x191/0x230
[ 2884.283506] netlink_sendmsg+0x2c4/0x390
[ 2884.283509] sock_sendmsg+0x36/0x40
[ 2884.283510] __sys_sendto+0xd8/0x150
[ 2884.283513] ? __fput+0x126/0x200
[ 2884.283514] ? kern_select+0xb9/0xe0
[ 2884.283515] __x64_sys_sendto+0x24/0x30
[ 2884.283517] do_syscall_64+0x4e/0x110
[ 2884.283519] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2884.283520] RIP: 0033:0x7face4679ad3
[ 2884.283521] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2884.283522] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2884.283522] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2884.283523] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2884.283523] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2884.283524] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2884.283524] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2912.282411] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2912.282997] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2912.283023] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2912.283036] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2912.283037] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2912.283041] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2912.283042] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2912.283043] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2912.283044] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2912.283044] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2912.283045] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2912.283045] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2912.283045] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2912.283046] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2912.283047] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2912.283047] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2912.283047] Call Trace:
[ 2912.283051] xfrm_state_lookup+0x12/0x20
[ 2912.283053] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2912.283055] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2912.283056] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2912.283058] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2912.283061] netlink_rcv_skb+0xde/0x110
[ 2912.283062] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2912.283063] netlink_unicast+0x191/0x230
[ 2912.283064] netlink_sendmsg+0x2c4/0x390
[ 2912.283067] sock_sendmsg+0x36/0x40
[ 2912.283068] __sys_sendto+0xd8/0x150
[ 2912.283071] ? __fput+0x126/0x200
[ 2912.283072] ? kern_select+0xb9/0xe0
[ 2912.283073] __x64_sys_sendto+0x24/0x30
[ 2912.283075] do_syscall_64+0x4e/0x110
[ 2912.283087] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2912.283088] RIP: 0033:0x7face4679ad3
[ 2912.283089] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2912.283089] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2912.283090] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2912.283090] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2912.283091] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2912.283091] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2912.283092] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2915.542350] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2915.542868] rcu: 5-....: (2730054 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85071 fqs=659801
[ 2915.543781] rcu: (t=2730093 jiffies g=85505 q=6625880)
[ 2915.544245] NMI backtrace for cpu 5
[ 2915.544247] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2915.544247] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2915.544247] Call Trace:
[ 2915.544250] <IRQ>
[ 2915.544253] dump_stack+0x5c/0x7b
[ 2915.544255] nmi_cpu_backtrace+0x8a/0x90
[ 2915.544258] ? lapic_can_unplug_cpu+0x90/0x90
[ 2915.544259] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 2915.544261] ? printk+0x43/0x4b
[ 2915.544264] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 2915.544264] ? cpumask_next+0x16/0x20
[ 2915.544265] rcu_dump_cpu_stacks+0x8c/0xbc
[ 2915.544267] rcu_check_callbacks+0x6a2/0x800
[ 2915.544269] ? tick_init_highres+0x20/0x20
[ 2915.544271] update_process_times+0x28/0x50
[ 2915.544272] tick_sched_timer+0x50/0x150
[ 2915.544274] __hrtimer_run_queues+0xea/0x260
[ 2915.544275] hrtimer_interrupt+0x122/0x270
[ 2915.544278] smp_apic_timer_interrupt+0x6a/0x140
[ 2915.544280] apic_timer_interrupt+0xf/0x20
[ 2915.544280] </IRQ>
[ 2915.544283] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2915.544284] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2915.544284] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2915.544285] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2915.544286] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2915.544286] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2915.544287] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2915.544287] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2915.544289] xfrm_state_lookup+0x12/0x20
[ 2915.544292] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2915.544293] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2915.544295] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2915.544297] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2915.544299] netlink_rcv_skb+0xde/0x110
[ 2915.544300] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2915.544301] netlink_unicast+0x191/0x230
[ 2915.544302] netlink_sendmsg+0x2c4/0x390
[ 2915.544305] sock_sendmsg+0x36/0x40
[ 2915.544306] __sys_sendto+0xd8/0x150
[ 2915.544309] ? __fput+0x126/0x200
[ 2915.544310] ? kern_select+0xb9/0xe0
[ 2915.544311] __x64_sys_sendto+0x24/0x30
[ 2915.544313] do_syscall_64+0x4e/0x110
[ 2915.544315] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2915.544316] RIP: 0033:0x7face4679ad3
[ 2915.544317] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2915.544318] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2915.544318] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2915.544319] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2915.544320] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2915.544320] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2915.544320] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2920.877251] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2920.877809] rcu: 5-....: (207779 ticks this GP) idle=92a/1/0x4000000000000000 softirq=85071/85071 fqs=659939
[ 2920.878869] rcu: (detected by 0, t=2730152 jiffies, g=-1199, q=2)
[ 2920.879412] Sending NMI from CPU 0 to CPUs 5:
[ 2920.879459] NMI backtrace for cpu 5
[ 2920.879459] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2920.879460] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2920.879460] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2920.879461] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2920.879461] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 2920.879461] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2920.879462] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2920.879462] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2920.879462] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2920.879462] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2920.879462] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2920.879463] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2920.879463] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2920.879463] Call Trace:
[ 2920.879463] xfrm_state_lookup+0x12/0x20
[ 2920.879463] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2920.879463] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2920.879464] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2920.879464] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2920.879464] netlink_rcv_skb+0xde/0x110
[ 2920.879464] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2920.879464] netlink_unicast+0x191/0x230
[ 2920.879464] netlink_sendmsg+0x2c4/0x390
[ 2920.879464] sock_sendmsg+0x36/0x40
[ 2920.879465] __sys_sendto+0xd8/0x150
[ 2920.879465] ? __fput+0x126/0x200
[ 2920.879465] ? kern_select+0xb9/0xe0
[ 2920.879465] __x64_sys_sendto+0x24/0x30
[ 2920.879465] do_syscall_64+0x4e/0x110
[ 2920.879465] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2920.879466] RIP: 0033:0x7face4679ad3
[ 2920.879466] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2920.879466] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2920.879466] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2920.879467] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2920.879467] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2920.879467] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2920.879467] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2948.281743] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 2948.282247] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2948.282274] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2948.282288] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2948.282288] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2948.282293] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2948.282294] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2948.282295] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 2948.282296] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2948.282296] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2948.282297] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2948.282297] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2948.282297] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2948.282298] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2948.282299] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2948.282299] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2948.282299] Call Trace:
[ 2948.282303] xfrm_state_lookup+0x12/0x20
[ 2948.282305] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2948.282307] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2948.282308] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2948.282310] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2948.282312] netlink_rcv_skb+0xde/0x110
[ 2948.282314] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2948.282315] netlink_unicast+0x191/0x230
[ 2948.282316] netlink_sendmsg+0x2c4/0x390
[ 2948.282318] sock_sendmsg+0x36/0x40
[ 2948.282320] __sys_sendto+0xd8/0x150
[ 2948.282322] ? __fput+0x126/0x200
[ 2948.282323] ? kern_select+0xb9/0xe0
[ 2948.282324] __x64_sys_sendto+0x24/0x30
[ 2948.282326] do_syscall_64+0x4e/0x110
[ 2948.282328] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2948.282330] RIP: 0033:0x7face4679ad3
[ 2948.282330] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2948.282331] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2948.282332] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2948.282332] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2948.282333] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2948.282333] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2948.282333] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2960.089523] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 2960.090065] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=7264
[ 2960.091009] rcu: (detected by 7, t=30003 jiffies, g=-1195, q=2)
[ 2960.091479] Sending NMI from CPU 7 to CPUs 5:
[ 2960.091537] NMI backtrace for cpu 5
[ 2960.091538] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2960.091538] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2960.091538] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 2960.091539] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 2960.091539] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 2960.091539] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2960.091540] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2960.091540] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2960.091540] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2960.091540] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2960.091541] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2960.091541] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2960.091541] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2960.091541] Call Trace:
[ 2960.091541] xfrm_state_lookup+0x12/0x20
[ 2960.091542] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2960.091542] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2960.091542] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2960.091542] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2960.091542] netlink_rcv_skb+0xde/0x110
[ 2960.091542] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2960.091543] netlink_unicast+0x191/0x230
[ 2960.091543] netlink_sendmsg+0x2c4/0x390
[ 2960.091543] sock_sendmsg+0x36/0x40
[ 2960.091543] __sys_sendto+0xd8/0x150
[ 2960.091543] ? __fput+0x126/0x200
[ 2960.091543] ? kern_select+0xb9/0xe0
[ 2960.091544] __x64_sys_sendto+0x24/0x30
[ 2960.091544] do_syscall_64+0x4e/0x110
[ 2960.091544] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2960.091544] RIP: 0033:0x7face4679ad3
[ 2960.091544] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2960.091545] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2960.091545] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2960.091545] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2960.091545] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2960.091546] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2960.091546] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 2984.281075] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 2984.281642] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 2984.281668] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 2984.281682] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 2984.281683] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 2984.281687] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 2984.281688] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 2984.281689] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 2984.281690] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 2984.281690] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 2984.281691] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 2984.281691] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 2984.281691] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 2984.281692] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 2984.281693] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2984.281693] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 2984.281694] Call Trace:
[ 2984.281697] xfrm_state_lookup+0x12/0x20
[ 2984.281700] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 2984.281701] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 2984.281702] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 2984.281705] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 2984.281707] netlink_rcv_skb+0xde/0x110
[ 2984.281708] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 2984.281709] netlink_unicast+0x191/0x230
[ 2984.281710] netlink_sendmsg+0x2c4/0x390
[ 2984.281713] sock_sendmsg+0x36/0x40
[ 2984.281714] __sys_sendto+0xd8/0x150
[ 2984.281716] ? __fput+0x126/0x200
[ 2984.281718] ? kern_select+0xb9/0xe0
[ 2984.281719] __x64_sys_sendto+0x24/0x30
[ 2984.281721] do_syscall_64+0x4e/0x110
[ 2984.281723] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2984.281724] RIP: 0033:0x7face4679ad3
[ 2984.281725] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 2984.281725] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 2984.281726] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 2984.281727] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 2984.281727] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 2984.281727] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 2984.281728] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3005.543678] rcu: INFO: rcu_sched self-detected stall on CPU
[ 3005.544174] rcu: 5-....: (2820057 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85072 fqs=681577
[ 3005.545102] rcu: (t=2820096 jiffies g=85505 q=6785731)
[ 3005.545614] NMI backtrace for cpu 5
[ 3005.545616] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3005.545616] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3005.545617] Call Trace:
[ 3005.545619] <IRQ>
[ 3005.545622] dump_stack+0x5c/0x7b
[ 3005.545624] nmi_cpu_backtrace+0x8a/0x90
[ 3005.545627] ? lapic_can_unplug_cpu+0x90/0x90
[ 3005.545628] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 3005.545631] ? printk+0x43/0x4b
[ 3005.545633] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 3005.545634] ? cpumask_next+0x16/0x20
[ 3005.545635] rcu_dump_cpu_stacks+0x8c/0xbc
[ 3005.545636] rcu_check_callbacks+0x6a2/0x800
[ 3005.545639] ? tick_init_highres+0x20/0x20
[ 3005.545641] update_process_times+0x28/0x50
[ 3005.545642] tick_sched_timer+0x50/0x150
[ 3005.545643] __hrtimer_run_queues+0xea/0x260
[ 3005.545645] hrtimer_interrupt+0x122/0x270
[ 3005.545647] smp_apic_timer_interrupt+0x6a/0x140
[ 3005.545649] apic_timer_interrupt+0xf/0x20
[ 3005.545649] </IRQ>
[ 3005.545652] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3005.545653] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3005.545653] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 3005.545654] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3005.545655] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3005.545655] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3005.545655] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3005.545656] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3005.545658] xfrm_state_lookup+0x12/0x20
[ 3005.545661] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3005.545662] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3005.545664] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3005.545665] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3005.545668] netlink_rcv_skb+0xde/0x110
[ 3005.545669] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3005.545670] netlink_unicast+0x191/0x230
[ 3005.545671] netlink_sendmsg+0x2c4/0x390
[ 3005.545674] sock_sendmsg+0x36/0x40
[ 3005.545675] __sys_sendto+0xd8/0x150
[ 3005.545678] ? __fput+0x126/0x200
[ 3005.545679] ? kern_select+0xb9/0xe0
[ 3005.545681] __x64_sys_sendto+0x24/0x30
[ 3005.545692] do_syscall_64+0x4e/0x110
[ 3005.545693] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3005.545695] RIP: 0033:0x7face4679ad3
[ 3005.545696] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3005.545696] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3005.545697] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3005.545697] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3005.545698] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3005.545698] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3005.545699] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3032.280181] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 3032.280740] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3032.280766] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3032.280780] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3032.280781] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3032.280795] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3032.280796] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3032.280796] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3032.280797] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3032.280798] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3032.280798] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3032.280799] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3032.280799] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3032.280800] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3032.280800] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3032.280801] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3032.280801] Call Trace:
[ 3032.280805] xfrm_state_lookup+0x12/0x20
[ 3032.280807] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3032.280818] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3032.280819] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3032.280821] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3032.280824] netlink_rcv_skb+0xde/0x110
[ 3032.280825] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3032.280826] netlink_unicast+0x191/0x230
[ 3032.280827] netlink_sendmsg+0x2c4/0x390
[ 3032.280830] sock_sendmsg+0x36/0x40
[ 3032.280831] __sys_sendto+0xd8/0x150
[ 3032.280834] ? __fput+0x126/0x200
[ 3032.280835] ? kern_select+0xb9/0xe0
[ 3032.280836] __x64_sys_sendto+0x24/0x30
[ 3032.280838] do_syscall_64+0x4e/0x110
[ 3032.280840] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3032.280842] RIP: 0033:0x7face4679ad3
[ 3032.280842] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3032.280843] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3032.280844] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3032.280844] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3032.280845] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3032.280845] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3032.280845] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3050.092849] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 3050.093419] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=29038
[ 3050.094329] rcu: (detected by 4, t=120008 jiffies, g=-1195, q=2)
[ 3050.094830] Sending NMI from CPU 4 to CPUs 5:
[ 3050.094898] NMI backtrace for cpu 5
[ 3050.094898] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3050.094898] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3050.094899] RIP: 0010:__xfrm_state_lookup+0x76/0x110
[ 3050.094899] Code: 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 <48> 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50
[ 3050.094899] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 3050.094900] RAX: ffff9bb019fa0928 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3050.094900] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3050.094900] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3050.094900] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3050.094901] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3050.094901] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3050.094901] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3050.094901] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3050.094902] Call Trace:
[ 3050.094902] xfrm_state_lookup+0x12/0x20
[ 3050.094902] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3050.094902] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3050.094903] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3050.094903] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3050.094903] netlink_rcv_skb+0xde/0x110
[ 3050.094903] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3050.094903] netlink_unicast+0x191/0x230
[ 3050.094903] netlink_sendmsg+0x2c4/0x390
[ 3050.094904] sock_sendmsg+0x36/0x40
[ 3050.094904] __sys_sendto+0xd8/0x150
[ 3050.094904] ? __fput+0x126/0x200
[ 3050.094904] ? kern_select+0xb9/0xe0
[ 3050.094904] __x64_sys_sendto+0x24/0x30
[ 3050.094904] do_syscall_64+0x4e/0x110
[ 3050.094905] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3050.094905] RIP: 0033:0x7face4679ad3
[ 3050.094905] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3050.094905] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3050.094906] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3050.094906] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3050.094906] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3050.094906] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3050.094906] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3076.279361] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 3076.279949] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3076.279974] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3076.279988] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3076.279988] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3076.279993] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3076.279994] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3076.279994] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3076.279995] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3076.279996] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3076.279996] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3076.279997] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3076.279997] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3076.279998] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3076.279998] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3076.279999] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3076.279999] Call Trace:
[ 3076.280003] xfrm_state_lookup+0x12/0x20
[ 3076.280005] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3076.280007] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3076.280008] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3076.280010] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3076.280012] netlink_rcv_skb+0xde/0x110
[ 3076.280014] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3076.280015] netlink_unicast+0x191/0x230
[ 3076.280016] netlink_sendmsg+0x2c4/0x390
[ 3076.280018] sock_sendmsg+0x36/0x40
[ 3076.280019] __sys_sendto+0xd8/0x150
[ 3076.280022] ? __fput+0x126/0x200
[ 3076.280023] ? kern_select+0xb9/0xe0
[ 3076.280024] __x64_sys_sendto+0x24/0x30
[ 3076.280026] do_syscall_64+0x4e/0x110
[ 3076.280028] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3076.280029] RIP: 0033:0x7face4679ad3
[ 3076.280030] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3076.280031] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3076.280032] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3076.280032] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3076.280033] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3076.280033] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3076.280033] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3095.545001] rcu: INFO: rcu_sched self-detected stall on CPU
[ 3095.545505] rcu: 5-....: (2910059 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85072 fqs=703351
[ 3095.546386] rcu: (t=2910099 jiffies g=85505 q=6967552)
[ 3095.546852] NMI backtrace for cpu 5
[ 3095.546854] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3095.546854] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3095.546855] Call Trace:
[ 3095.546875] <IRQ>
[ 3095.546879] dump_stack+0x5c/0x7b
[ 3095.546881] nmi_cpu_backtrace+0x8a/0x90
[ 3095.546896] ? lapic_can_unplug_cpu+0x90/0x90
[ 3095.546897] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 3095.546900] ? printk+0x43/0x4b
[ 3095.546902] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 3095.546903] ? cpumask_next+0x16/0x20
[ 3095.546904] rcu_dump_cpu_stacks+0x8c/0xbc
[ 3095.546905] rcu_check_callbacks+0x6a2/0x800
[ 3095.546908] ? tick_init_highres+0x20/0x20
[ 3095.546910] update_process_times+0x28/0x50
[ 3095.546911] tick_sched_timer+0x50/0x150
[ 3095.546913] __hrtimer_run_queues+0xea/0x260
[ 3095.546914] hrtimer_interrupt+0x122/0x270
[ 3095.546917] smp_apic_timer_interrupt+0x6a/0x140
[ 3095.546918] apic_timer_interrupt+0xf/0x20
[ 3095.546919] </IRQ>
[ 3095.546921] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3095.546922] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3095.546923] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3095.546924] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3095.546924] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3095.546925] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3095.546925] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3095.546926] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3095.546928] xfrm_state_lookup+0x12/0x20
[ 3095.546931] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3095.546932] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3095.546933] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3095.546935] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3095.546937] netlink_rcv_skb+0xde/0x110
[ 3095.546939] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3095.546940] netlink_unicast+0x191/0x230
[ 3095.546941] netlink_sendmsg+0x2c4/0x390
[ 3095.546943] sock_sendmsg+0x36/0x40
[ 3095.546945] __sys_sendto+0xd8/0x150
[ 3095.546947] ? __fput+0x126/0x200
[ 3095.546948] ? kern_select+0xb9/0xe0
[ 3095.546950] __x64_sys_sendto+0x24/0x30
[ 3095.546951] do_syscall_64+0x4e/0x110
[ 3095.546953] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3095.546954] RIP: 0033:0x7face4679ad3
[ 3095.546955] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3095.546955] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3095.546956] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3095.546957] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3095.546957] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3095.546958] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3095.546958] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3120.278540] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3120.279081] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3120.279107] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3120.279121] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3120.279121] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3120.279125] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3120.279127] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3120.279127] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3120.279128] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3120.279129] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3120.279129] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3120.279129] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3120.279130] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3120.279131] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3120.279131] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3120.279131] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3120.279132] Call Trace:
[ 3120.279135] xfrm_state_lookup+0x12/0x20
[ 3120.279138] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3120.279139] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3120.279141] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3120.279143] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3120.279145] netlink_rcv_skb+0xde/0x110
[ 3120.279146] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3120.279147] netlink_unicast+0x191/0x230
[ 3120.279149] netlink_sendmsg+0x2c4/0x390
[ 3120.279151] sock_sendmsg+0x36/0x40
[ 3120.279152] __sys_sendto+0xd8/0x150
[ 3120.279155] ? __fput+0x126/0x200
[ 3120.279156] ? kern_select+0xb9/0xe0
[ 3120.279157] __x64_sys_sendto+0x24/0x30
[ 3120.279159] do_syscall_64+0x4e/0x110
[ 3120.279161] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3120.279163] RIP: 0033:0x7face4679ad3
[ 3120.279164] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3120.279164] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3120.279165] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3120.279165] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3120.279166] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3120.279166] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3120.279167] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3140.096169] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 3140.096861] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=50776
[ 3140.098142] rcu: (detected by 4, t=210013 jiffies, g=-1195, q=2)
[ 3140.098694] Sending NMI from CPU 4 to CPUs 5:
[ 3140.098758] NMI backtrace for cpu 5
[ 3140.098758] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3140.098759] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3140.098759] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3140.098760] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3140.098760] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 3140.098761] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3140.098761] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3140.098762] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3140.098762] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3140.098763] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3140.098763] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3140.098763] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3140.098764] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3140.098764] Call Trace:
[ 3140.098764] xfrm_state_lookup+0x12/0x20
[ 3140.098765] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3140.098765] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3140.098765] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3140.098766] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3140.098766] netlink_rcv_skb+0xde/0x110
[ 3140.098766] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3140.098767] netlink_unicast+0x191/0x230
[ 3140.098767] netlink_sendmsg+0x2c4/0x390
[ 3140.098767] sock_sendmsg+0x36/0x40
[ 3140.098767] __sys_sendto+0xd8/0x150
[ 3140.098768] ? __fput+0x126/0x200
[ 3140.098768] ? kern_select+0xb9/0xe0
[ 3140.098768] __x64_sys_sendto+0x24/0x30
[ 3140.098769] do_syscall_64+0x4e/0x110
[ 3140.098769] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3140.098769] RIP: 0033:0x7face4679ad3
[ 3140.098770] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3140.098770] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3140.098771] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3140.098771] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3140.098772] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3140.098772] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3140.098772] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3164.277717] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3164.278194] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3164.278221] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3164.278234] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3164.278235] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3164.278240] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3164.278241] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3164.278242] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 3164.278243] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3164.278243] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3164.278243] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3164.278244] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3164.278244] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3164.278245] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3164.278246] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3164.278246] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3164.278247] Call Trace:
[ 3164.278250] xfrm_state_lookup+0x12/0x20
[ 3164.278253] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3164.278254] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3164.278255] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3164.278258] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3164.278260] netlink_rcv_skb+0xde/0x110
[ 3164.278262] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3164.278263] netlink_unicast+0x191/0x230
[ 3164.278264] netlink_sendmsg+0x2c4/0x390
[ 3164.278266] sock_sendmsg+0x36/0x40
[ 3164.278268] __sys_sendto+0xd8/0x150
[ 3164.278270] ? __fput+0x126/0x200
[ 3164.278271] ? kern_select+0xb9/0xe0
[ 3164.278272] __x64_sys_sendto+0x24/0x30
[ 3164.278274] do_syscall_64+0x4e/0x110
[ 3164.278276] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3164.278278] RIP: 0033:0x7face4679ad3
[ 3164.278278] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3164.278279] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3164.278280] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3164.278280] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3164.278281] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3164.278281] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3164.278281] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3185.546320] rcu: INFO: rcu_sched self-detected stall on CPU
[ 3185.546809] rcu: 5-....: (3000062 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85072 fqs=725114
[ 3185.547673] rcu: (t=3000102 jiffies g=85505 q=7122914)
[ 3185.548146] NMI backtrace for cpu 5
[ 3185.548148] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3185.548149] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3185.548150] Call Trace:
[ 3185.548152] <IRQ>
[ 3185.548157] dump_stack+0x5c/0x7b
[ 3185.548160] nmi_cpu_backtrace+0x8a/0x90
[ 3185.548163] ? lapic_can_unplug_cpu+0x90/0x90
[ 3185.548165] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 3185.548168] ? printk+0x43/0x4b
[ 3185.548170] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 3185.548171] ? cpumask_next+0x16/0x20
[ 3185.548173] rcu_dump_cpu_stacks+0x8c/0xbc
[ 3185.548175] rcu_check_callbacks+0x6a2/0x800
[ 3185.548178] ? tick_init_highres+0x20/0x20
[ 3185.548180] update_process_times+0x28/0x50
[ 3185.548182] tick_sched_timer+0x50/0x150
[ 3185.548184] __hrtimer_run_queues+0xea/0x260
[ 3185.548186] hrtimer_interrupt+0x122/0x270
[ 3185.548188] smp_apic_timer_interrupt+0x6a/0x140
[ 3185.548190] apic_timer_interrupt+0xf/0x20
[ 3185.548191] </IRQ>
[ 3185.548194] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3185.548196] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3185.548196] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3185.548198] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3185.548199] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3185.548199] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3185.548200] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3185.548201] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3185.548204] xfrm_state_lookup+0x12/0x20
[ 3185.548208] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3185.548210] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3185.548212] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3185.548215] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3185.548217] netlink_rcv_skb+0xde/0x110
[ 3185.548220] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3185.548221] netlink_unicast+0x191/0x230
[ 3185.548223] netlink_sendmsg+0x2c4/0x390
[ 3185.548226] sock_sendmsg+0x36/0x40
[ 3185.548228] __sys_sendto+0xd8/0x150
[ 3185.548231] ? __fput+0x126/0x200
[ 3185.548233] ? kern_select+0xb9/0xe0
[ 3185.548234] __x64_sys_sendto+0x24/0x30
[ 3185.548236] do_syscall_64+0x4e/0x110
[ 3185.548239] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3185.548240] RIP: 0033:0x7face4679ad3
[ 3185.548242] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3185.548242] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3185.548244] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3185.548245] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3185.548246] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3185.548246] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3185.548247] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3188.924275] perf: interrupt took too long (3206 > 3131), lowering kernel.perf_event_max_sample_rate to 62000
[ 3212.276819] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3212.277373] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3212.277399] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3212.277413] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3212.277414] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3212.277418] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 3212.277419] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 3212.277420] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 3212.277421] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3212.277421] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3212.277422] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3212.277422] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3212.277422] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3212.277423] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3212.277424] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3212.277424] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3212.277425] Call Trace:
[ 3212.277428] xfrm_state_lookup+0x12/0x20
[ 3212.277431] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3212.277432] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3212.277433] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3212.277436] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3212.277438] netlink_rcv_skb+0xde/0x110
[ 3212.277440] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3212.277441] netlink_unicast+0x191/0x230
[ 3212.277442] netlink_sendmsg+0x2c4/0x390
[ 3212.277444] sock_sendmsg+0x36/0x40
[ 3212.277446] __sys_sendto+0xd8/0x150
[ 3212.277448] ? __fput+0x126/0x200
[ 3212.277450] ? kern_select+0xb9/0xe0
[ 3212.277451] __x64_sys_sendto+0x24/0x30
[ 3212.277453] do_syscall_64+0x4e/0x110
[ 3212.277455] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3212.277456] RIP: 0033:0x7face4679ad3
[ 3212.277457] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3212.277457] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3212.277458] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3212.277459] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3212.277459] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3212.277460] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3212.277460] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3230.099484] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 3230.100035] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=72571
[ 3230.100973] rcu: (detected by 1, t=300018 jiffies, g=-1195, q=2)
[ 3230.101529] Sending NMI from CPU 1 to CPUs 5:
[ 3230.101584] NMI backtrace for cpu 5
[ 3230.101585] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3230.101585] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3230.101586] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3230.101586] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3230.101587] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 3230.101587] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3230.101588] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3230.101588] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3230.101588] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3230.101589] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3230.101589] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3230.101589] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3230.101589] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3230.101590] Call Trace:
[ 3230.101590] xfrm_state_lookup+0x12/0x20
[ 3230.101590] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3230.101591] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3230.101591] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3230.101591] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3230.101591] netlink_rcv_skb+0xde/0x110
[ 3230.101592] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3230.101592] netlink_unicast+0x191/0x230
[ 3230.101592] netlink_sendmsg+0x2c4/0x390
[ 3230.101592] sock_sendmsg+0x36/0x40
[ 3230.101593] __sys_sendto+0xd8/0x150
[ 3230.101593] ? __fput+0x126/0x200
[ 3230.101593] ? kern_select+0xb9/0xe0
[ 3230.101593] __x64_sys_sendto+0x24/0x30
[ 3230.101594] do_syscall_64+0x4e/0x110
[ 3230.101594] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3230.101594] RIP: 0033:0x7face4679ad3
[ 3230.101595] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3230.101595] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3230.101595] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3230.101596] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3230.101596] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3230.101596] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3230.101597] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3256.275994] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3256.276503] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3256.276529] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3256.276543] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3256.276543] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3256.276548] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3256.276549] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3256.276549] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3256.276550] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3256.276551] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3256.276551] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3256.276552] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3256.276552] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3256.276553] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3256.276553] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3256.276554] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3256.276554] Call Trace:
[ 3256.276558] xfrm_state_lookup+0x12/0x20
[ 3256.276561] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3256.276562] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3256.276563] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3256.276566] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3256.276568] netlink_rcv_skb+0xde/0x110
[ 3256.276570] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3256.276571] netlink_unicast+0x191/0x230
[ 3256.276572] netlink_sendmsg+0x2c4/0x390
[ 3256.276574] sock_sendmsg+0x36/0x40
[ 3256.276575] __sys_sendto+0xd8/0x150
[ 3256.276578] ? __fput+0x126/0x200
[ 3256.276579] ? kern_select+0xb9/0xe0
[ 3256.276580] __x64_sys_sendto+0x24/0x30
[ 3256.276582] do_syscall_64+0x4e/0x110
[ 3256.276585] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3256.276586] RIP: 0033:0x7face4679ad3
[ 3256.276587] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3256.276588] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3256.276588] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3256.276589] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3256.276589] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3256.276589] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3256.276590] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3275.548632] rcu: INFO: rcu_sched self-detected stall on CPU
[ 3275.549110] rcu: 5-....: (3090066 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85072 fqs=746888
[ 3275.549958] rcu: (t=3090106 jiffies g=85505 q=7265931)
[ 3275.550422] NMI backtrace for cpu 5
[ 3275.550423] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3275.550424] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3275.550425] Call Trace:
[ 3275.550426] <IRQ>
[ 3275.550430] dump_stack+0x5c/0x7b
[ 3275.550432] nmi_cpu_backtrace+0x8a/0x90
[ 3275.550435] ? lapic_can_unplug_cpu+0x90/0x90
[ 3275.550436] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 3275.550439] ? printk+0x43/0x4b
[ 3275.550441] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 3275.550442] ? cpumask_next+0x16/0x20
[ 3275.550443] rcu_dump_cpu_stacks+0x8c/0xbc
[ 3275.550445] rcu_check_callbacks+0x6a2/0x800
[ 3275.550447] ? tick_init_highres+0x20/0x20
[ 3275.550449] update_process_times+0x28/0x50
[ 3275.550450] tick_sched_timer+0x50/0x150
[ 3275.550452] __hrtimer_run_queues+0xea/0x260
[ 3275.550453] hrtimer_interrupt+0x122/0x270
[ 3275.550456] smp_apic_timer_interrupt+0x6a/0x140
[ 3275.550457] apic_timer_interrupt+0xf/0x20
[ 3275.550458] </IRQ>
[ 3275.550460] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3275.550461] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3275.550462] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3275.550463] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3275.550463] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3275.550464] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3275.550464] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3275.550465] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3275.550467] xfrm_state_lookup+0x12/0x20
[ 3275.550470] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3275.550471] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3275.550472] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3275.550475] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3275.550477] netlink_rcv_skb+0xde/0x110
[ 3275.550478] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3275.550479] netlink_unicast+0x191/0x230
[ 3275.550481] netlink_sendmsg+0x2c4/0x390
[ 3275.550483] sock_sendmsg+0x36/0x40
[ 3275.550484] __sys_sendto+0xd8/0x150
[ 3275.550487] ? __fput+0x126/0x200
[ 3275.550488] ? kern_select+0xb9/0xe0
[ 3275.550489] __x64_sys_sendto+0x24/0x30
[ 3275.550491] do_syscall_64+0x4e/0x110
[ 3275.550493] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3275.550494] RIP: 0033:0x7face4679ad3
[ 3275.550495] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3275.550495] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3275.550496] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3275.550496] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3275.550497] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3275.550497] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3275.550497] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3300.275169] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3300.275692] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3300.275718] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3300.275731] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3300.275732] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3300.275746] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[ 3300.275748] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75 d9 66
[ 3300.275748] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 3300.275749] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3300.275750] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3300.275750] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3300.275751] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3300.275751] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3300.275752] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3300.275752] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3300.275753] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3300.275753] Call Trace:
[ 3300.275757] xfrm_state_lookup+0x12/0x20
[ 3300.275760] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3300.275761] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3300.275772] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3300.275774] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3300.275776] netlink_rcv_skb+0xde/0x110
[ 3300.275778] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3300.275779] netlink_unicast+0x191/0x230
[ 3300.275780] netlink_sendmsg+0x2c4/0x390
[ 3300.275782] sock_sendmsg+0x36/0x40
[ 3300.275784] __sys_sendto+0xd8/0x150
[ 3300.275786] ? __fput+0x126/0x200
[ 3300.275787] ? kern_select+0xb9/0xe0
[ 3300.275788] __x64_sys_sendto+0x24/0x30
[ 3300.275790] do_syscall_64+0x4e/0x110
[ 3300.275793] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3300.275794] RIP: 0033:0x7face4679ad3
[ 3300.275795] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3300.275795] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3300.275796] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3300.275797] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3300.275797] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3300.275798] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3300.275798] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3320.102795] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 3320.103274] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=94360
[ 3320.104120] rcu: (detected by 7, t=390023 jiffies, g=-1195, q=2)
[ 3320.104585] Sending NMI from CPU 7 to CPUs 5:
[ 3320.104633] NMI backtrace for cpu 5
[ 3320.104633] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3320.104633] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3320.104634] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3320.104634] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3320.104634] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 3320.104635] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3320.104635] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3320.104635] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3320.104636] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3320.104636] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3320.104636] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3320.104636] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3320.104637] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3320.104637] Call Trace:
[ 3320.104637] xfrm_state_lookup+0x12/0x20
[ 3320.104638] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3320.104638] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3320.104638] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3320.104638] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3320.104638] netlink_rcv_skb+0xde/0x110
[ 3320.104639] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3320.104639] netlink_unicast+0x191/0x230
[ 3320.104639] netlink_sendmsg+0x2c4/0x390
[ 3320.104639] sock_sendmsg+0x36/0x40
[ 3320.104639] __sys_sendto+0xd8/0x150
[ 3320.104639] ? __fput+0x126/0x200
[ 3320.104639] ? kern_select+0xb9/0xe0
[ 3320.104640] __x64_sys_sendto+0x24/0x30
[ 3320.104640] do_syscall_64+0x4e/0x110
[ 3320.104640] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3320.104640] RIP: 0033:0x7face4679ad3
[ 3320.104641] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3320.104641] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3320.104641] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3320.104641] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3320.104642] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3320.104642] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3320.104642] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3344.274342] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3344.274899] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3344.274926] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3344.274940] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3344.274940] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3344.274945] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3344.274946] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3344.274947] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 3344.274947] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3344.274948] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3344.274948] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3344.274949] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3344.274949] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3344.274950] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3344.274951] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3344.274951] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3344.274951] Call Trace:
[ 3344.274955] xfrm_state_lookup+0x12/0x20
[ 3344.274958] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3344.274959] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3344.274960] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3344.274962] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3344.274964] netlink_rcv_skb+0xde/0x110
[ 3344.274966] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3344.274967] netlink_unicast+0x191/0x230
[ 3344.274968] netlink_sendmsg+0x2c4/0x390
[ 3344.274971] sock_sendmsg+0x36/0x40
[ 3344.274972] __sys_sendto+0xd8/0x150
[ 3344.274974] ? __fput+0x126/0x200
[ 3344.274976] ? kern_select+0xb9/0xe0
[ 3344.274977] __x64_sys_sendto+0x24/0x30
[ 3344.274978] do_syscall_64+0x4e/0x110
[ 3344.274981] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3344.274982] RIP: 0033:0x7face4679ad3
[ 3344.274983] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3344.274983] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3344.274984] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3344.274984] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3344.274985] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3344.274985] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3344.274985] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3365.549941] rcu: INFO: rcu_sched self-detected stall on CPU
[ 3365.550419] rcu: 5-....: (3180069 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85072 fqs=768706
[ 3365.551269] rcu: (t=3180109 jiffies g=85505 q=7403483)
[ 3365.551734] NMI backtrace for cpu 5
[ 3365.551735] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3365.551736] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3365.551736] Call Trace:
[ 3365.551738] <IRQ>
[ 3365.551742] dump_stack+0x5c/0x7b
[ 3365.551744] nmi_cpu_backtrace+0x8a/0x90
[ 3365.551747] ? lapic_can_unplug_cpu+0x90/0x90
[ 3365.551748] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 3365.551751] ? printk+0x43/0x4b
[ 3365.551753] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 3365.551754] ? cpumask_next+0x16/0x20
[ 3365.551755] rcu_dump_cpu_stacks+0x8c/0xbc
[ 3365.551756] rcu_check_callbacks+0x6a2/0x800
[ 3365.551759] ? tick_init_highres+0x20/0x20
[ 3365.551761] update_process_times+0x28/0x50
[ 3365.551762] tick_sched_timer+0x50/0x150
[ 3365.551764] __hrtimer_run_queues+0xea/0x260
[ 3365.551765] hrtimer_interrupt+0x122/0x270
[ 3365.551767] smp_apic_timer_interrupt+0x6a/0x140
[ 3365.551769] apic_timer_interrupt+0xf/0x20
[ 3365.551769] </IRQ>
[ 3365.551772] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3365.551773] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3365.551774] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3365.551775] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3365.551775] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3365.551776] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3365.551776] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3365.551776] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3365.551779] xfrm_state_lookup+0x12/0x20
[ 3365.551782] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3365.551783] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3365.551784] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3365.551786] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3365.551788] netlink_rcv_skb+0xde/0x110
[ 3365.551790] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3365.551791] netlink_unicast+0x191/0x230
[ 3365.551792] netlink_sendmsg+0x2c4/0x390
[ 3365.551794] sock_sendmsg+0x36/0x40
[ 3365.551796] __sys_sendto+0xd8/0x150
[ 3365.551798] ? __fput+0x126/0x200
[ 3365.551800] ? kern_select+0xb9/0xe0
[ 3365.551801] __x64_sys_sendto+0x24/0x30
[ 3365.551802] do_syscall_64+0x4e/0x110
[ 3365.551804] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3365.551805] RIP: 0033:0x7face4679ad3
[ 3365.551806] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3365.551806] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3365.551807] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3365.551808] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3365.551808] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3365.551808] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3365.551809] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3392.273440] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 3392.273959] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3392.273985] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3392.274009] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3392.274010] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3392.274015] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3392.274016] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3392.274017] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3392.274018] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3392.274018] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3392.274019] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3392.274019] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3392.274019] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3392.274020] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3392.274021] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3392.274031] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3392.274031] Call Trace:
[ 3392.274035] xfrm_state_lookup+0x12/0x20
[ 3392.274037] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3392.274039] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3392.274040] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3392.274042] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3392.274044] netlink_rcv_skb+0xde/0x110
[ 3392.274046] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3392.274047] netlink_unicast+0x191/0x230
[ 3392.274048] netlink_sendmsg+0x2c4/0x390
[ 3392.274051] sock_sendmsg+0x36/0x40
[ 3392.274052] __sys_sendto+0xd8/0x150
[ 3392.274055] ? __fput+0x126/0x200
[ 3392.274056] ? kern_select+0xb9/0xe0
[ 3392.274057] __x64_sys_sendto+0x24/0x30
[ 3392.274059] do_syscall_64+0x4e/0x110
[ 3392.274061] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3392.274062] RIP: 0033:0x7face4679ad3
[ 3392.274063] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3392.274064] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3392.274064] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3392.274065] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3392.274065] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3392.274065] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3392.274066] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3410.106104] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 3410.106636] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=116135
[ 3410.107636] rcu: (detected by 1, t=480028 jiffies, g=-1195, q=2)
[ 3410.108166] Sending NMI from CPU 1 to CPUs 5:
[ 3410.108222] NMI backtrace for cpu 5
[ 3410.108223] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3410.108223] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3410.108223] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3410.108224] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3410.108224] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 3410.108225] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3410.108225] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3410.108226] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3410.108226] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3410.108226] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3410.108227] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3410.108227] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3410.108227] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3410.108228] Call Trace:
[ 3410.108228] xfrm_state_lookup+0x12/0x20
[ 3410.108228] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3410.108228] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3410.108229] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3410.108229] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3410.108229] netlink_rcv_skb+0xde/0x110
[ 3410.108229] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3410.108230] netlink_unicast+0x191/0x230
[ 3410.108230] netlink_sendmsg+0x2c4/0x390
[ 3410.108230] sock_sendmsg+0x36/0x40
[ 3410.108230] __sys_sendto+0xd8/0x150
[ 3410.108231] ? __fput+0x126/0x200
[ 3410.108231] ? kern_select+0xb9/0xe0
[ 3410.108231] __x64_sys_sendto+0x24/0x30
[ 3410.108231] do_syscall_64+0x4e/0x110
[ 3410.108232] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3410.108232] RIP: 0033:0x7face4679ad3
[ 3410.108232] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3410.108233] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3410.108233] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3410.108234] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3410.108234] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3410.108235] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3410.108235] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3436.272612] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 3436.273121] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3436.273147] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3436.273161] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3436.273162] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3436.273166] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3436.273167] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3436.273168] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3436.273168] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3436.273169] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3436.273169] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3436.273170] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3436.273170] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3436.273171] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3436.273172] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3436.273172] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3436.273173] Call Trace:
[ 3436.273176] xfrm_state_lookup+0x12/0x20
[ 3436.273179] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3436.273180] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3436.273182] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3436.273184] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3436.273186] netlink_rcv_skb+0xde/0x110
[ 3436.273188] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3436.273189] netlink_unicast+0x191/0x230
[ 3436.273190] netlink_sendmsg+0x2c4/0x390
[ 3436.273193] sock_sendmsg+0x36/0x40
[ 3436.273194] __sys_sendto+0xd8/0x150
[ 3436.273197] ? __fput+0x126/0x200
[ 3436.273198] ? kern_select+0xb9/0xe0
[ 3436.273199] __x64_sys_sendto+0x24/0x30
[ 3436.273201] do_syscall_64+0x4e/0x110
[ 3436.273203] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3436.273205] RIP: 0033:0x7face4679ad3
[ 3436.273206] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3436.273206] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3436.273207] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3436.273207] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3436.273208] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3436.273208] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3436.273209] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3455.551248] rcu: INFO: rcu_sched self-detected stall on CPU
[ 3455.551782] rcu: 5-....: (3270072 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85072 fqs=790489
[ 3455.552733] rcu: (t=3270112 jiffies g=85505 q=7542881)
[ 3455.553276] NMI backtrace for cpu 5
[ 3455.553277] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3455.553278] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3455.553278] Call Trace:
[ 3455.553289] <IRQ>
[ 3455.553293] dump_stack+0x5c/0x7b
[ 3455.553295] nmi_cpu_backtrace+0x8a/0x90
[ 3455.553298] ? lapic_can_unplug_cpu+0x90/0x90
[ 3455.553299] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 3455.553302] ? printk+0x43/0x4b
[ 3455.553304] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 3455.553305] ? cpumask_next+0x16/0x20
[ 3455.553306] rcu_dump_cpu_stacks+0x8c/0xbc
[ 3455.553307] rcu_check_callbacks+0x6a2/0x800
[ 3455.553309] ? tick_init_highres+0x20/0x20
[ 3455.553311] update_process_times+0x28/0x50
[ 3455.553312] tick_sched_timer+0x50/0x150
[ 3455.553314] __hrtimer_run_queues+0xea/0x260
[ 3455.553316] hrtimer_interrupt+0x122/0x270
[ 3455.553319] smp_apic_timer_interrupt+0x6a/0x140
[ 3455.553320] apic_timer_interrupt+0xf/0x20
[ 3455.553330] </IRQ>
[ 3455.553333] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 3455.553334] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 3455.553334] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 3455.553335] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3455.553336] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3455.553336] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3455.553337] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3455.553337] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3455.553339] xfrm_state_lookup+0x12/0x20
[ 3455.553342] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3455.553344] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3455.553345] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3455.553357] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3455.553360] netlink_rcv_skb+0xde/0x110
[ 3455.553362] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3455.553363] netlink_unicast+0x191/0x230
[ 3455.553365] netlink_sendmsg+0x2c4/0x390
[ 3455.553367] sock_sendmsg+0x36/0x40
[ 3455.553369] __sys_sendto+0xd8/0x150
[ 3455.553371] ? __fput+0x126/0x200
[ 3455.553372] ? kern_select+0xb9/0xe0
[ 3455.553373] __x64_sys_sendto+0x24/0x30
[ 3455.553375] do_syscall_64+0x4e/0x110
[ 3455.553377] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3455.553378] RIP: 0033:0x7face4679ad3
[ 3455.553379] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3455.553379] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3455.553380] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3455.553381] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3455.553381] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3455.553381] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3455.553382] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3480.271784] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 3480.272325] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3480.272351] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3480.272365] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3480.272365] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3480.272370] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3480.272371] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3480.272371] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 3480.272372] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3480.272373] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3480.272374] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3480.272374] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3480.272375] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3480.272375] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3480.272376] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3480.272376] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3480.272377] Call Trace:
[ 3480.272380] xfrm_state_lookup+0x12/0x20
[ 3480.272383] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3480.272384] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3480.272385] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3480.272387] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3480.272390] netlink_rcv_skb+0xde/0x110
[ 3480.272392] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3480.272393] netlink_unicast+0x191/0x230
[ 3480.272394] netlink_sendmsg+0x2c4/0x390
[ 3480.272396] sock_sendmsg+0x36/0x40
[ 3480.272397] __sys_sendto+0xd8/0x150
[ 3480.272400] ? __fput+0x126/0x200
[ 3480.272401] ? kern_select+0xb9/0xe0
[ 3480.272402] __x64_sys_sendto+0x24/0x30
[ 3480.272405] do_syscall_64+0x4e/0x110
[ 3480.272407] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3480.272408] RIP: 0033:0x7face4679ad3
[ 3480.272409] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3480.272409] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3480.272410] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3480.272410] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3480.272411] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3480.272411] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3480.272411] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3500.109410] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 3500.109935] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=137946
[ 3500.110888] rcu: (detected by 7, t=570033 jiffies, g=-1195, q=2)
[ 3500.111356] Sending NMI from CPU 7 to CPUs 5:
[ 3500.111404] NMI backtrace for cpu 5
[ 3500.111405] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3500.111405] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3500.111406] RIP: 0010:__xfrm_state_lookup+0x7d/0x110
[ 3500.111406] Code: 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 <74> 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a 60 54 75
[ 3500.111406] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286
[ 3500.111407] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3500.111407] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3500.111408] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3500.111408] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3500.111408] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3500.111409] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3500.111409] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3500.111409] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3500.111409] Call Trace:
[ 3500.111410] xfrm_state_lookup+0x12/0x20
[ 3500.111410] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3500.111410] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3500.111410] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3500.111411] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3500.111411] netlink_rcv_skb+0xde/0x110
[ 3500.111411] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3500.111411] netlink_unicast+0x191/0x230
[ 3500.111412] netlink_sendmsg+0x2c4/0x390
[ 3500.111412] sock_sendmsg+0x36/0x40
[ 3500.111412] __sys_sendto+0xd8/0x150
[ 3500.111412] ? __fput+0x126/0x200
[ 3500.111412] ? kern_select+0xb9/0xe0
[ 3500.111413] __x64_sys_sendto+0x24/0x30
[ 3500.111413] do_syscall_64+0x4e/0x110
[ 3500.111413] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3500.111413] RIP: 0033:0x7face4679ad3
[ 3500.111414] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3500.111414] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3500.111415] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3500.111415] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3500.111416] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3500.111416] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3500.111416] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3524.270955] watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [charon:11926]
[ 3524.271478] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3524.271505] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3524.271518] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3524.271519] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3524.271523] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3524.271524] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3524.271525] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3524.271526] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3524.271526] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3524.271527] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3524.271527] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3524.271528] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3524.271528] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3524.271529] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3524.271529] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3524.271530] Call Trace:
[ 3524.271533] xfrm_state_lookup+0x12/0x20
[ 3524.271536] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3524.271538] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3524.271539] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3524.271541] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3524.271543] netlink_rcv_skb+0xde/0x110
[ 3524.271545] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3524.271546] netlink_unicast+0x191/0x230
[ 3524.271547] netlink_sendmsg+0x2c4/0x390
[ 3524.271549] sock_sendmsg+0x36/0x40
[ 3524.271551] __sys_sendto+0xd8/0x150
[ 3524.271553] ? __fput+0x126/0x200
[ 3524.271554] ? kern_select+0xb9/0xe0
[ 3524.271555] __x64_sys_sendto+0x24/0x30
[ 3524.271558] do_syscall_64+0x4e/0x110
[ 3524.271560] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3524.271561] RIP: 0033:0x7face4679ad3
[ 3524.271562] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3524.271562] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3524.271563] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3524.271564] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3524.271564] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3524.271565] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3524.271565] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3545.552553] rcu: INFO: rcu_sched self-detected stall on CPU
[ 3545.553079] rcu: 5-....: (3360074 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85072 fqs=812330
[ 3545.553959] rcu: (t=3360115 jiffies g=85505 q=7700587)
[ 3545.554424] NMI backtrace for cpu 5
[ 3545.554426] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3545.554426] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3545.554427] Call Trace:
[ 3545.554429] <IRQ>
[ 3545.554432] dump_stack+0x5c/0x7b
[ 3545.554434] nmi_cpu_backtrace+0x8a/0x90
[ 3545.554437] ? lapic_can_unplug_cpu+0x90/0x90
[ 3545.554438] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 3545.554441] ? printk+0x43/0x4b
[ 3545.554443] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 3545.554444] ? cpumask_next+0x16/0x20
[ 3545.554445] rcu_dump_cpu_stacks+0x8c/0xbc
[ 3545.554447] rcu_check_callbacks+0x6a2/0x800
[ 3545.554449] ? tick_init_highres+0x20/0x20
[ 3545.554451] update_process_times+0x28/0x50
[ 3545.554452] tick_sched_timer+0x50/0x150
[ 3545.554454] __hrtimer_run_queues+0xea/0x260
[ 3545.554456] hrtimer_interrupt+0x122/0x270
[ 3545.554458] smp_apic_timer_interrupt+0x6a/0x140
[ 3545.554459] apic_timer_interrupt+0xf/0x20
[ 3545.554460] </IRQ>
[ 3545.554462] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3545.554463] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3545.554464] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3545.554465] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3545.554465] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3545.554466] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3545.554466] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3545.554467] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3545.554469] xfrm_state_lookup+0x12/0x20
[ 3545.554472] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3545.554473] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3545.554474] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3545.554476] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3545.554478] netlink_rcv_skb+0xde/0x110
[ 3545.554480] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3545.554481] netlink_unicast+0x191/0x230
[ 3545.554482] netlink_sendmsg+0x2c4/0x390
[ 3545.554484] sock_sendmsg+0x36/0x40
[ 3545.554486] __sys_sendto+0xd8/0x150
[ 3545.554488] ? __fput+0x126/0x200
[ 3545.554489] ? kern_select+0xb9/0xe0
[ 3545.554490] __x64_sys_sendto+0x24/0x30
[ 3545.554492] do_syscall_64+0x4e/0x110
[ 3545.554494] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3545.554495] RIP: 0033:0x7face4679ad3
[ 3545.554496] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3545.554496] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3545.554497] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3545.554498] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3545.554498] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3545.554499] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3545.554499] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3572.270051] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3572.270540] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3572.270579] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3572.270598] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3572.270599] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3572.270605] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 3572.270607] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 3572.270607] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 3572.270609] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3572.270610] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3572.270611] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3572.270612] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3572.270613] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3572.270614] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3572.270615] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3572.270616] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3572.270616] Call Trace:
[ 3572.270621] xfrm_state_lookup+0x12/0x20
[ 3572.270624] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3572.270626] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3572.270629] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3572.270632] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3572.270634] netlink_rcv_skb+0xde/0x110
[ 3572.270637] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3572.270638] netlink_unicast+0x191/0x230
[ 3572.270640] netlink_sendmsg+0x2c4/0x390
[ 3572.270643] sock_sendmsg+0x36/0x40
[ 3572.270645] __sys_sendto+0xd8/0x150
[ 3572.270648] ? __fput+0x126/0x200
[ 3572.270650] ? kern_select+0xb9/0xe0
[ 3572.270652] __x64_sys_sendto+0x24/0x30
[ 3572.270654] do_syscall_64+0x4e/0x110
[ 3572.270657] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3572.270658] RIP: 0033:0x7face4679ad3
[ 3572.270660] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3572.270661] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3572.270662] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3572.270663] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3572.270663] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3572.270664] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3572.270665] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3590.112713] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 3590.113189] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=159768
[ 3590.114039] rcu: (detected by 6, t=660038 jiffies, g=-1195, q=2)
[ 3590.114506] Sending NMI from CPU 6 to CPUs 5:
[ 3590.114554] NMI backtrace for cpu 5
[ 3590.114554] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3590.114554] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3590.114555] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3590.114555] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3590.114555] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 3590.114556] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3590.114556] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3590.114557] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3590.114557] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3590.114557] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3590.114557] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3590.114558] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3590.114558] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3590.114558] Call Trace:
[ 3590.114558] xfrm_state_lookup+0x12/0x20
[ 3590.114558] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3590.114559] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3590.114559] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3590.114559] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3590.114559] netlink_rcv_skb+0xde/0x110
[ 3590.114559] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3590.114560] netlink_unicast+0x191/0x230
[ 3590.114560] netlink_sendmsg+0x2c4/0x390
[ 3590.114560] sock_sendmsg+0x36/0x40
[ 3590.114560] __sys_sendto+0xd8/0x150
[ 3590.114560] ? __fput+0x126/0x200
[ 3590.114560] ? kern_select+0xb9/0xe0
[ 3590.114561] __x64_sys_sendto+0x24/0x30
[ 3590.114561] do_syscall_64+0x4e/0x110
[ 3590.114561] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3590.114561] RIP: 0033:0x7face4679ad3
[ 3590.114562] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3590.114562] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3590.114563] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3590.114563] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3590.114563] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3590.114563] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3590.114563] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3616.269220] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3616.269784] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3616.269810] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3616.269823] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3616.269824] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3616.269828] RIP: 0010:__xfrm_state_lookup+0x7a/0x110
[ 3616.269829] Code: 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 <48> 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 44 3b 78 50 75 df 44 3a
[ 3616.269830] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
[ 3616.269831] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3616.269831] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3616.269832] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3616.269832] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3616.269833] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3616.269833] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3616.269834] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3616.269834] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3616.269835] Call Trace:
[ 3616.269838] xfrm_state_lookup+0x12/0x20
[ 3616.269841] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3616.269842] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3616.269844] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3616.269846] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3616.269848] netlink_rcv_skb+0xde/0x110
[ 3616.269850] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3616.269851] netlink_unicast+0x191/0x230
[ 3616.269852] netlink_sendmsg+0x2c4/0x390
[ 3616.269854] sock_sendmsg+0x36/0x40
[ 3616.269855] __sys_sendto+0xd8/0x150
[ 3616.269858] ? __fput+0x126/0x200
[ 3616.269859] ? kern_select+0xb9/0xe0
[ 3616.269860] __x64_sys_sendto+0x24/0x30
[ 3616.269862] do_syscall_64+0x4e/0x110
[ 3616.269864] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3616.269866] RIP: 0033:0x7face4679ad3
[ 3616.269867] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3616.269867] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3616.269868] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3616.269868] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3616.269869] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3616.269869] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3616.269869] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3635.553855] rcu: INFO: rcu_sched self-detected stall on CPU
[ 3635.554334] rcu: 5-....: (3450077 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85072 fqs=834106
[ 3635.555191] rcu: (t=3450118 jiffies g=85505 q=7849636)
[ 3635.555655] NMI backtrace for cpu 5
[ 3635.555656] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3635.555657] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3635.555657] Call Trace:
[ 3635.555660] <IRQ>
[ 3635.555663] dump_stack+0x5c/0x7b
[ 3635.555665] nmi_cpu_backtrace+0x8a/0x90
[ 3635.555668] ? lapic_can_unplug_cpu+0x90/0x90
[ 3635.555669] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 3635.555672] ? printk+0x43/0x4b
[ 3635.555674] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 3635.555675] ? cpumask_next+0x16/0x20
[ 3635.555676] rcu_dump_cpu_stacks+0x8c/0xbc
[ 3635.555678] rcu_check_callbacks+0x6a2/0x800
[ 3635.555680] ? tick_init_highres+0x20/0x20
[ 3635.555682] update_process_times+0x28/0x50
[ 3635.555683] tick_sched_timer+0x50/0x150
[ 3635.555685] __hrtimer_run_queues+0xea/0x260
[ 3635.555686] hrtimer_interrupt+0x122/0x270
[ 3635.555689] smp_apic_timer_interrupt+0x6a/0x140
[ 3635.555691] apic_timer_interrupt+0xf/0x20
[ 3635.555691] </IRQ>
[ 3635.555694] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3635.555696] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3635.555696] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3635.555697] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3635.555698] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3635.555698] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3635.555699] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3635.555699] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3635.555701] xfrm_state_lookup+0x12/0x20
[ 3635.555705] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3635.555707] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3635.555709] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3635.555711] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3635.555713] netlink_rcv_skb+0xde/0x110
[ 3635.555715] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3635.555716] netlink_unicast+0x191/0x230
[ 3635.555717] netlink_sendmsg+0x2c4/0x390
[ 3635.555720] sock_sendmsg+0x36/0x40
[ 3635.555721] __sys_sendto+0xd8/0x150
[ 3635.555724] ? __fput+0x126/0x200
[ 3635.555725] ? kern_select+0xb9/0xe0
[ 3635.555726] __x64_sys_sendto+0x24/0x30
[ 3635.555728] do_syscall_64+0x4e/0x110
[ 3635.555730] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3635.555731] RIP: 0033:0x7face4679ad3
[ 3635.555732] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3635.555733] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3635.555733] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3635.555734] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3635.555734] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3635.555735] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3635.555735] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3660.268391] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3660.269012] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3660.269038] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3660.269052] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3660.269053] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3660.269057] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3660.269059] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3660.269059] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3660.269061] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3660.269061] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3660.269062] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3660.269063] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3660.269064] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3660.269065] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3660.269066] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3660.269067] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3660.269067] Call Trace:
[ 3660.269071] xfrm_state_lookup+0x12/0x20
[ 3660.269074] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3660.269076] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3660.269077] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3660.269079] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3660.269082] netlink_rcv_skb+0xde/0x110
[ 3660.269083] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3660.269084] netlink_unicast+0x191/0x230
[ 3660.269085] netlink_sendmsg+0x2c4/0x390
[ 3660.269088] sock_sendmsg+0x36/0x40
[ 3660.269089] __sys_sendto+0xd8/0x150
[ 3660.269092] ? __fput+0x126/0x200
[ 3660.269093] ? kern_select+0xb9/0xe0
[ 3660.269094] __x64_sys_sendto+0x24/0x30
[ 3660.269096] do_syscall_64+0x4e/0x110
[ 3660.269098] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3660.269099] RIP: 0033:0x7face4679ad3
[ 3660.269100] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3660.269101] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3660.269101] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3660.269102] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3660.269102] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3660.269103] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3660.269103] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3680.116014] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 3680.116506] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=181489
[ 3680.117390] rcu: (detected by 1, t=750043 jiffies, g=-1195, q=2)
[ 3680.117895] Sending NMI from CPU 1 to CPUs 5:
[ 3680.117951] NMI backtrace for cpu 5
[ 3680.117952] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3680.117952] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3680.117953] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3680.117953] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3680.117954] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 3680.117954] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3680.117955] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3680.117955] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3680.117955] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3680.117956] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3680.117956] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3680.117956] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3680.117957] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3680.117957] Call Trace:
[ 3680.117957] xfrm_state_lookup+0x12/0x20
[ 3680.117957] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3680.117958] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3680.117958] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3680.117958] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3680.117958] netlink_rcv_skb+0xde/0x110
[ 3680.117959] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3680.117959] netlink_unicast+0x191/0x230
[ 3680.117959] netlink_sendmsg+0x2c4/0x390
[ 3680.117959] sock_sendmsg+0x36/0x40
[ 3680.117960] __sys_sendto+0xd8/0x150
[ 3680.117960] ? __fput+0x126/0x200
[ 3680.117960] ? kern_select+0xb9/0xe0
[ 3680.117960] __x64_sys_sendto+0x24/0x30
[ 3680.117961] do_syscall_64+0x4e/0x110
[ 3680.117961] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3680.117961] RIP: 0033:0x7face4679ad3
[ 3680.117962] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3680.117962] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3680.117963] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3680.117963] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3680.117964] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3680.117964] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3680.117964] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3704.267559] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3704.268116] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3704.268141] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3704.268155] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3704.268156] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3704.268160] RIP: 0010:__xfrm_state_lookup+0x6d/0x110
[ 3704.268161] Code: c1 e8 14 44 31 c8 41 31 c0 48 8b 87 60 11 00 00 45 21 d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 <48> 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2
[ 3704.268161] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[ 3704.268162] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3704.268163] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3704.268163] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3704.268164] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3704.268164] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3704.268165] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3704.268165] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3704.268166] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3704.268166] Call Trace:
[ 3704.268170] xfrm_state_lookup+0x12/0x20
[ 3704.268173] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3704.268174] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3704.268175] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3704.268178] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3704.268180] netlink_rcv_skb+0xde/0x110
[ 3704.268181] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3704.268182] netlink_unicast+0x191/0x230
[ 3704.268183] netlink_sendmsg+0x2c4/0x390
[ 3704.268186] sock_sendmsg+0x36/0x40
[ 3704.268187] __sys_sendto+0xd8/0x150
[ 3704.268190] ? __fput+0x126/0x200
[ 3704.268191] ? kern_select+0xb9/0xe0
[ 3704.268192] __x64_sys_sendto+0x24/0x30
[ 3704.268194] do_syscall_64+0x4e/0x110
[ 3704.268196] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3704.268198] RIP: 0033:0x7face4679ad3
[ 3704.268199] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3704.268199] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3704.268200] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3704.268201] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3704.268201] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3704.268201] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3704.268202] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3725.555156] rcu: INFO: rcu_sched self-detected stall on CPU
[ 3725.555665] rcu: 5-....: (3540080 ticks this GP) idle=92a/1/0x4000000000000002 softirq=85068/85072 fqs=855875
[ 3725.556634] rcu: (t=3540121 jiffies g=85505 q=8003781)
[ 3725.557170] NMI backtrace for cpu 5
[ 3725.557171] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3725.557172] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3725.557172] Call Trace:
[ 3725.557174] <IRQ>
[ 3725.557178] dump_stack+0x5c/0x7b
[ 3725.557180] nmi_cpu_backtrace+0x8a/0x90
[ 3725.557183] ? lapic_can_unplug_cpu+0x90/0x90
[ 3725.557184] nmi_trigger_cpumask_backtrace+0xe5/0x120
[ 3725.557186] ? printk+0x43/0x4b
[ 3725.557198] ? rcu_dump_cpu_stacks+0x8c/0xbc
[ 3725.557199] ? cpumask_next+0x16/0x20
[ 3725.557200] rcu_dump_cpu_stacks+0x8c/0xbc
[ 3725.557201] rcu_check_callbacks+0x6a2/0x800
[ 3725.557204] ? tick_init_highres+0x20/0x20
[ 3725.557206] update_process_times+0x28/0x50
[ 3725.557207] tick_sched_timer+0x50/0x150
[ 3725.557208] __hrtimer_run_queues+0xea/0x260
[ 3725.557210] hrtimer_interrupt+0x122/0x270
[ 3725.557212] smp_apic_timer_interrupt+0x6a/0x140
[ 3725.557213] apic_timer_interrupt+0xf/0x20
[ 3725.557214] </IRQ>
[ 3725.557217] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3725.557218] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3725.557218] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 3725.557219] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3725.557219] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3725.557220] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3725.557221] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3725.557221] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3725.557223] xfrm_state_lookup+0x12/0x20
[ 3725.557226] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3725.557227] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3725.557228] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3725.557230] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3725.557232] netlink_rcv_skb+0xde/0x110
[ 3725.557234] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3725.557234] netlink_unicast+0x191/0x230
[ 3725.557236] netlink_sendmsg+0x2c4/0x390
[ 3725.557238] sock_sendmsg+0x36/0x40
[ 3725.557239] __sys_sendto+0xd8/0x150
[ 3725.557242] ? __fput+0x126/0x200
[ 3725.557243] ? kern_select+0xb9/0xe0
[ 3725.557244] __x64_sys_sendto+0x24/0x30
[ 3725.557246] do_syscall_64+0x4e/0x110
[ 3725.557247] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3725.557249] RIP: 0033:0x7face4679ad3
[ 3725.557250] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3725.557250] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3725.557251] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3725.557251] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3725.557252] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3725.557252] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3725.557253] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3752.266652] watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [charon:11926]
[ 3752.267187] Modules linked in: fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 linear ext4 crc16 mbcache jbd2
[ 3752.267213] xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables raid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aesni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[ 3752.267227] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3752.267227] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3752.267232] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3752.267233] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3752.267233] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[ 3752.267234] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3752.267235] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3752.267235] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3752.267236] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3752.267236] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3752.267237] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3752.267238] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3752.267238] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3752.267238] Call Trace:
[ 3752.267242] xfrm_state_lookup+0x12/0x20
[ 3752.267245] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3752.267246] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3752.267247] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3752.267250] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3752.267252] netlink_rcv_skb+0xde/0x110
[ 3752.267253] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3752.267254] netlink_unicast+0x191/0x230
[ 3752.267256] netlink_sendmsg+0x2c4/0x390
[ 3752.267258] sock_sendmsg+0x36/0x40
[ 3752.267259] __sys_sendto+0xd8/0x150
[ 3752.267262] ? __fput+0x126/0x200
[ 3752.267263] ? kern_select+0xb9/0xe0
[ 3752.267264] __x64_sys_sendto+0x24/0x30
[ 3752.267266] do_syscall_64+0x4e/0x110
[ 3752.267269] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3752.267270] RIP: 0033:0x7face4679ad3
[ 3752.267271] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3752.267271] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3752.267272] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3752.267272] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3752.267273] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3752.267273] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3752.267274] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3770.119314] rcu: INFO: rcu_bh detected stalls on CPUs/tasks:
[ 3770.119809] rcu: 5-....: (1 GPs behind) idle=92a/1/0x4000000000000000 softirq=85071/85072 fqs=203263
[ 3770.120724] rcu: (detected by 6, t=840048 jiffies, g=-1195, q=2)
[ 3770.121221] Sending NMI from CPU 6 to CPUs 5:
[ 3770.121268] NMI backtrace for cpu 5
[ 3770.121268] CPU: 5 PID: 11926 Comm: charon Tainted: G O L 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[ 3770.121268] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie , BIOS CC1F110D 08/12/2014
[ 3770.121269] RIP: 0010:__xfrm_state_lookup+0x88/0x110
[ 3770.121269] Code: 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b 66 3b a8 d2 00 00 00 75 e5 <44> 3b 78 50 75 df 44 3a 60 54 75 d9 66 83 fd 0a 74 59 41 8b 06 39
[ 3770.121269] RSP: 0018:ffffab5043cc3b48 EFLAGS: 00000246
[ 3770.121270] RAX: ffff9bb019fa0900 RBX: ffff9bb019fa0900 RCX: 000000007a91e1cd
[ 3770.121270] RDX: ffff9bb063d96e10 RSI: 0000000000000000 RDI: ffffffff951071c0
[ 3770.121270] RBP: 0000000000000002 R08: 000000000000002e R09: 00000000001c1413
[ 3770.121270] R10: 000000000000003f R11: 00007ffffffff000 R12: 0000000000000032
[ 3770.121271] R13: 0000000000000000 R14: ffff9bb063d96e10 R15: 000000007a91e1cd
[ 3770.121271] FS: 00007facdcb0b700(0000) GS:ffff9bb07fb40000(0000) knlGS:0000000000000000
[ 3770.121271] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3770.121271] CR2: 00007facb80133f8 CR3: 00000007e1078002 CR4: 00000000001606e0
[ 3770.121271] Call Trace:
[ 3770.121272] xfrm_state_lookup+0x12/0x20
[ 3770.121272] xfrm_user_state_lookup.constprop.13+0x83/0xb0 [xfrm_user]
[ 3770.121272] xfrm_get_sa+0x36/0xb0 [xfrm_user]
[ 3770.121272] xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[ 3770.121272] ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[ 3770.121272] netlink_rcv_skb+0xde/0x110
[ 3770.121273] xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[ 3770.121273] netlink_unicast+0x191/0x230
[ 3770.121273] netlink_sendmsg+0x2c4/0x390
[ 3770.121273] sock_sendmsg+0x36/0x40
[ 3770.121273] __sys_sendto+0xd8/0x150
[ 3770.121273] ? __fput+0x126/0x200
[ 3770.121274] ? kern_select+0xb9/0xe0
[ 3770.121274] __x64_sys_sendto+0x24/0x30
[ 3770.121274] do_syscall_64+0x4e/0x110
[ 3770.121274] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3770.121274] RIP: 0033:0x7face4679ad3
[ 3770.121275] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[ 3770.121275] RSP: 002b:00007facdcb0a280 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[ 3770.121275] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[ 3770.121275] RDX: 0000000000000028 RSI: 00007facdcb0a340 RDI: 0000000000000008
[ 3770.121276] RBP: 0000000000000028 R08: 00007facdcb0a2c0 R09: 000000000000000c
[ 3770.121276] R10: 0000000000000000 R11: 0000000000000297 R12: 00007facdcb0a7c8
[ 3770.121276] R13: 00007facdcb0a2c0 R14: 00007facdcb0a340 R15: 0000000000000170
[ 3785.464253] EXT4-fs (loop2): mounted filesystem with ordered data mode. Opts: (null)
[ 3785.465993] EXT4-fs (loop3): mounted filesystem with ordered data mode. Opts: (null)
[ 3785.466040] EXT4-fs (loop4): mounted filesystem with ordered data mode. Opts: (null)
[ 3786.588713] EXT4-fs (loop5): mounted filesystem with ordered data mode. Opts: (null)
[ 3786.589993] EXT4-fs (loop7): mounted filesystem with ordered data mode. Opts: (null)
[ 3786.591589] EXT4-fs (loop6): mounted filesystem with ordered data mode. Opts: (null)
[ 3787.365961] EXT4-fs (loop9): mounted filesystem with ordered data mode. Opts: (null)
[ 3787.373878] EXT4-fs (loop8): mounted filesystem with ordered data mode. Opts: (null)
[ 3788.251195] EXT4-fs (loop2): mounted filesystem with ordered data mode. Opts: (null)
[ 3789.383003] EXT4-fs (loop7): mounted filesystem with ordered data mode. Opts: (null)
[ 3794.395335] EXT4-fs (loop0): mounted filesystem without journal. Opts: norecovery
[ 3794.415348] EXT4-fs (loop1): mounted filesystem without journal. Opts: norecovery
[ 3795.623869] EXT4-fs (loop5): mounted filesystem with ordered data mode. Opts: (null)
[ 3795.623923] EXT4-fs (loop6): mounted filesystem with ordered data mode. Opts: (null)
[ 3796.446483] EXT4-fs (loop9): mounted filesystem with ordered data mode. Opts: (null)
[ 3796.447554] EXT4-fs (loop8): mounted filesystem with ordered data mode. Opts: (null)
[17220.980893] EXT4-fs (loop10): mounted filesystem with ordered data mode. Opts: (null)
[17232.856765] EXT4-fs (loop2): mounted filesystem with ordered data mode. Opts: (null)
[28205.589356] perf: interrupt took too long (4098 > 4007), lowering kernel.perf_event_max_sample_rate to 48000
[39866.501954] EXT4-fs (loop7): mounted filesystem with ordered data mode. Opts: (null)
[39878.362794] EXT4-fs (loop10): mounted filesystem with ordered data mode. Opts: (null)
[54284.354997] general protection fault: 0000 [#1] SMP PTI
[54284.355504] CPU: 6 PID: 11937 Comm: charon Tainted: G           O L    4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
[54284.356382] Hardware name: Ciara Technologies 1x8-X6 SSD 32G 10GE/CangJie, BIOS CC1F110D 08/12/2014
[54284.357322] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
[54284.357856] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89 d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66> 3b a8 d2 00 00 00 75 e5 44 3b 78 50 
 75 df 44 3a 60 54 75 d9 66
[54284.359190] RSP: 0018:ffffab5043d93ad0 EFLAGS: 00010212
[54284.359748] RAX: 6174735f79636e3d RBX: 6174735f79636e3d RCX: 0000000064959bc7
[54284.360219] RDX: ffff9bb0593c3380 RSI: 0000000000000000 RDI: ffffffff951071c0
[54284.360713] RBP: 0000000000000002 R08: 0000000000000010 R09: 00000000001b950d
[54284.361209] R10: 000000000000003f R11: 0000000096001849 R12: 0000000000000032
[54284.361755] R13: 0000000000000000 R14: ffff9bb0593c3380 R15: 0000000064959bc7
[54284.362255] FS:  00007facd7b01700(0000) GS:ffff9bb07fb80000(0000) knlGS:00000000000000000
[54284.363198] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[54284.363687] CR2: 00007f99250e89e0 CR3: 00000007e1078006 CR4: 00000000001606e0
[54284.364156] Call Trace:
[54284.364642]  xfrm_state_add+0x108/0x290
[54284.365113]  xfrm_add_sa+0x9e6/0xb28 [xfrm_user]
[54284.365580]  ? xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[54284.366077]  xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
[54284.366543]  ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
[54284.367040]  netlink_rcv_skb+0xde/0x110
[54284.367504]  xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
[54284.368000]  netlink_unicast+0x191/0x230
[54284.368463]  netlink_sendmsg+0x2c4/0x390
[54284.368958]  sock_sendmsg+0x36/0x40
[54284.369449]  __sys_sendto+0xd8/0x150
[54284.369940]  ? kern_select+0xb9/0xe0
[54284.370405]  __x64_sys_sendto+0x24/0x30
[54284.370946]  do_syscall_64+0x4e/0x110
[54284.383941]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[54284.384497] RIP: 0033:0x7face4679ad3
[54284.385049] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 0
8 e8 9b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 e1 f6 ff ff 48 
 89 d0 48 83 c4 08 48 3d 01
[54284.386682] RSP: 002b:00007facd7b002a0 EFLAGS: 00000297 ORIG_RAX: 000000000000002c
[54284.387801] RAX: ffffffffffffffda RBX: 0000000000cc1040 RCX: 00007face4679ad3
[54284.388333] RDX: 0000000000000160 RSI: 00007facd7b00520 RDI: 0000000000000008
[54284.388926] RBP: 0000000000000160 R08: 00007facd7b002e0 R09: 000000000000000c
[54284.389467] R10: 0000000000000000 R11: 0000000000000297 R12: 00007faca0008200
[54284.390018] R13: 00007facd7b002e0 R14: 00007facd7b00520 R15: 000000000000690c
[54284.390580] Modules linked in: overlay fuse drbg seqiv xfrm_user xfrm4_tunnel tunnel4
 ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_algo af_alg xt_tcpmss trip2 ip6table_raw ip6table_nat nf_na
t_ipv6 ip6table_filter ip6_tables iptable_raw iptable_nat nf_nat_ipv4 nf_nat xt_policy nfnetlink_log
 xt_NFLOG xt_limit xt_recent xt_connmark xt_hashlimit xt_mark xt_conntrack nf_conntrack nf_defrag_ip
v6 nf_defrag_ipv4 xt_multiport xt_owner xt_set ip_set_bitmap_port ip_set_hash_ip ip_set_list_set ip_
set_hash_net zfs(O) zunicode(O) zavl(O) icp(O) zcommon(O) znvpair(O) spl(O) dm_crypt dev_cstack tcp_
bbr tcp_qdk netconsole aep ip6_udp_tunnel udp_tunnel dm_mod i2c_dev jc42 i2c_i801 i2c_core softdog a
utofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 
 linear ext4 crc16 mbcache
[54284.395782]  jbd2 xt_tcpudp ipv6 iptable_filter ip_tables ip_set nfnetlink x_tables r
aid0 md_mod coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal kvm_intel kvm irqbypass ahci aes
ni_intel libahci bnx2x mpt3sas aes_x86_64 raid_class crypto_simd mdio libcrc32c scsi_transport_sas c
cryptd crc32c_generic glue_helper libata lpc_ich mfd_core crc32c_intel ie31200_edac pcc_cpufreq
[54284.406375] Kernel panic - not syncing: Fatal exception in interrupt
[54284.406923] Kernel Offset: 0x12000000 from 0xffffffff82000000 (relocation range: 0xff
fffffff80000000-0xffffffffbfffffff)
[54284.407784] Rebooting in 30 seconds..
[54314.411026] ACPI MEMORY or I/O RESET_REG.


--------------2B89384C3D68F3CE79A1A5C7--
