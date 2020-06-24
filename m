Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81033207934
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404825AbgFXQcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404691AbgFXQcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:32:13 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B5AC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:32:12 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id f18so2422444qkh.1
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=choopa.com; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=0P84RlRCsEprPVNrA2qnHlAmhjgMTsfMv9MHkGQRl50=;
        b=lDVCYhZQwUI58/SoPREIwoklOh5AJRhQoSJ2QjKyT3UqwyTL2UnuD3aMeKfJv4OB3N
         eLxD1qapzxqzJoSNmoJXgG0s79PPaSkSGcVCsPewEtPPGrTj3ZlNDT5QUbsNTHrEKEYg
         lvj/VaCE46ZVBVWRP7RTC2nwmKNMPhAY4qAtXIUmEm68MbllJwGcrjmbdAv27oEugUIW
         MAEhM42NMz1cX16RjCxSPscmIy3/56/l9oVg6SSOfd5Anlp6F1TP8TZ8VXjIrw/yd05z
         hfF/yLofi6cZxbp5e4g+m4drHc8I6AAeGC4jqBK5G22aumiLOnRN+wI5aYIrH9ffbziF
         a1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=0P84RlRCsEprPVNrA2qnHlAmhjgMTsfMv9MHkGQRl50=;
        b=UuhOIJBUVFK2Ydhl/wz6Dk1eb/IiFVsgQeEbusnMcE8Zmes3WMrotsTiX5txXOQA4j
         5P12R/uus3f9WX6g+nY3t5rKm11z+rDl95hGwubl47gM9Wp7nawi1YAlkbIzKV/cZNLq
         OD9UMc4AxU8l+JocFGDzLDwhqVP7toJtMdIlDyFu8JmLD6KAynd3k8bm05SmoYR7NhCH
         uJVJJUJmgTqk0y4uyT12DQ7IukctYcC+xRT7YMIMHuyjmitJeE8TqzLh1CYkx+dnbCgb
         oKzYIQf/nMSUbjF84bXYiqRiGoJJNJvzNKkE6gsLbd5yez6x2ZV3jWgIl/aNdbBRtC2h
         x/Bg==
X-Gm-Message-State: AOAM530mFNSuLTB0F7mFFSBBSR3IUDjAAB501PLXU5nY7EHPlt5wabjs
        GhiFCcSZe/VNyiUYPa3QR+VSuyjSDS8p6hz5zeftI6iTysZAPblqeJIpLjeruv/SuvlvU2BvF6Y
        7+HLlcbncFaiGBYJ/GpArwUAWxqM6J+5C9iF+GkCk0zuT5mM55x/6X8argv4Hano=
X-Google-Smtp-Source: ABdhPJxrigGaHomVrfLtRyV56y2UE7vfHK6yBI2I9UovzmqZrbC7LXBbhtLKN68INH7eSQOFoHpDcA==
X-Received: by 2002:a37:a511:: with SMTP id o17mr26493360qke.141.1593016331589;
        Wed, 24 Jun 2020 09:32:11 -0700 (PDT)
Received: from ?IPv6:2001:470:1f07:968:e9ad:66fd:689f:7a34? ([2001:470:1f07:968:e9ad:66fd:689f:7a34])
        by smtp.gmail.com with ESMTPSA id i10sm4509372qkn.126.2020.06.24.09.32.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 09:32:11 -0700 (PDT)
To:     netdev@vger.kernel.org
From:   Brian Rak <brak@choopa.com>
Subject: Crash/hang in 5.4.47 with nexthop objects
Message-ID: <d46e6ccb-6b00-7c18-21aa-2c36416ab1ea@choopa.com>
Date:   Wed, 24 Jun 2020 12:32:09 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We're hitting an issue where the kernel with either hang indefinitely or 
immediately crash when IPv6 nexthops are used along with the `rpfilter` 
ip6tables module.  The following commands trigger this issue 100% of the 
time for us:

ip -6 route del default; ip -6 route del default; # repeat as necessary 
to remove all existing default routes
ip6tables -t mangle -I PREROUTING 1 -m rpfilter --invert -j DROP
ip nexthop add id 999 via 2001:19f0:1000:8080::1 dev eno1
ip -6 route add default nhid 999

I haven't been able to get a stack trace from the 5.4.47 (as it's 
hanging), but this is what it looked like when we first saw the issue:

2020-06-24 09:55:23     [2903971.348676] BUG: kernel NULL pointer 
dereference, address: 00000000000004a8
2020-06-24 09:55:23     [2903971.348903] #PF: supervisor read access in 
kernel mode
2020-06-24 09:55:23     [2903971.349050] #PF: error_code(0x0000) - 
not-present page
2020-06-24 09:55:23     [2903971.349204] PGD 0 P4D 0
2020-06-24 09:55:23     [2903971.349286] Oops: 0000 [#1] SMP NOPTI
2020-06-24 09:55:23     [2903971.349396] CPU: 88 PID: 2549031 Comm: 
vhost-2549003 Not tainted 5.4.38-121124.el7.x86_64 #1
2020-06-24 09:55:23     [2903971.349645] Hardware name: Dell Inc. 
PowerEdge R640/0RGP26, BIOS 2.6.4 04/09/2020
2020-06-24 09:55:23     [2903971.349876] RIP: 
0010:ip6_create_rt_rcu+0x6b/0x170
2020-06-24 09:55:23     [2903971.350016] Code: d0 0f 8f f4 00 00 00 44 
89 c0 f0 0f b1 11 0f 94 c2 84 d2 89 c6 0f 84 ba 00 00 00 45 85 c0 74 6c 
0f b6 83 86 00 00 00 4c 89 ee <49> 8b bd a8 04 00 00 89 c2 83 e2 02 80 
fa 01 19 d2 f7 d2 83 e2 08
2020-06-24 09:55:23     [2903971.350569] RSP: 0018:ffffb826f74eb720 
EFLAGS: 00010202
2020-06-24 09:55:23     [2903971.350723] RAX: 0000000000000000 RBX: 
ffff9827f204e3c0 RCX: ffff9827f204e3ec
2020-06-24 09:55:23     [2903971.350937] RDX: 0000000000000001 RSI: 
0000000000000000 RDI: ffffb826f74eb790
2020-06-24 09:55:23     [2903971.351150] RBP: ffffb826f74eb740 R08: 
0000000000000002 R09: 0000000000000000
2020-06-24 09:55:23     [2903971.351362] R10: ffff982800007640 R11: 
0000000000000000 R12: ffffb826f74eb790
2020-06-24 09:55:23     [2903971.351575] R13: 0000000000000000 R14: 
ffff982786312180 R15: ffffffffa739f540
2020-06-24 09:55:23     [2903971.351789] FS: 0000000000000000(0000) 
GS:ffff982800f00000(0000) knlGS:0000000000000000
2020-06-24 09:55:23     [2903971.352030] CS:  0010 DS: 0000 ES: 0000 
CR0: 0000000080050033
2020-06-24 09:55:23     [2903971.352207] CR2: 00000000000004a8 CR3: 
000000524eaca005 CR4: 00000000007626e0
2020-06-24 09:55:23     [2903971.352415] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
2020-06-24 09:55:23     [2903971.352629] DR3: 0000000000000000 DR6: 
00000000fffe0ff0 DR7: 0000000000000400
2020-06-24 09:55:23     [2903971.352842] PKRU: 55555554
2020-06-24 09:55:23     [2903971.352927] Call Trace:
2020-06-24 09:55:23     [2903971.353009] ip6_pol_route_lookup+0x304/0x4b0
2020-06-24 09:55:23     [2903971.353135]  ? fib6_select_path+0x170/0x170
2020-06-24 09:55:23     [2903971.353262] fib6_rule_lookup+0x1ec/0x220
2020-06-24 09:55:23     [2903971.353386]  ? hash_net6_test+0x238/0x3f0 
[ip_set_hash_net]
2020-06-24 09:55:23     [2903971.353555] ip6_route_lookup+0x15/0x20
2020-06-24 09:55:23     [2903971.353669]  rpfilter_mt+0x17b/0x230 
[ip6t_rpfilter]
2020-06-24 09:55:23     [2903971.353820] ip6t_do_table+0x24a/0x6c0 
[ip6_tables]
2020-06-24 09:55:23     [2903971.353966]  ? set_match_v4+0xa4/0xe0 [xt_set]
2020-06-24 09:55:23     [2903971.354099]  ? ip6t_do_table+0x31d/0x6c0 
[ip6_tables]
2020-06-24 09:55:23     [2903971.354254] ip6table_mangle_hook+0x4b/0x150 
[ip6table_mangle]
2020-06-24 09:55:23     [2903971.354430]  nf_hook_slow+0x42/0xc0
2020-06-24 09:55:23     [2903971.354534]  ipv6_rcv+0xbe/0xd0
2020-06-24 09:55:23     [2903971.354630]  ? ip6_sublist_rcv_finish+0x70/0x70
2020-06-24 09:55:23     [2903971.354768] 
__netif_receive_skb_one_core+0x5f/0xb0
2020-06-24 09:55:23     [2903971.354913] __netif_receive_skb+0x18/0x60
2020-06-24 09:55:23     [2903971.355039] 
netif_receive_skb_internal+0x76/0xc0
2020-06-24 09:55:23     [2903971.355183]  ? __build_skb+0x25/0xe0
2020-06-24 09:55:23     [2903971.355293] netif_receive_skb+0x1c/0xc0
2020-06-24 09:55:23     [2903971.355416]  tun_sendmsg+0x370/0x860 [tun]
2020-06-24 09:55:23     [2903971.355540] 
vhost_tx_batch.isra.21+0x62/0xd0 [vhost_net]
2020-06-24 09:55:23     [2903971.355699] handle_tx_copy+0x1a3/0x640 
[vhost_net]
2020-06-24 09:55:23     [2903971.361727]  handle_tx+0xad/0xd0 [vhost_net]
2020-06-24 09:55:23     [2903971.367808]  handle_tx_kick+0x15/0x20 
[vhost_net]
2020-06-24 09:55:23     [2903971.373823]  vhost_worker+0xaa/0x100 [vhost]
2020-06-24 09:55:23     [2903971.379843]  kthread+0x105/0x140
2020-06-24 09:55:23     [2903971.385725]  ? 
vhost_chr_read_iter+0x190/0x190 [vhost]
2020-06-24 09:55:23     [2903971.391537]  ? kthread_bind+0x20/0x20
2020-06-24 09:55:23     [2903971.397310]  ret_from_fork+0x35/0x40
2020-06-24 09:55:23     [2903971.403017] Modules linked in: ip6table_raw 
dm_snapshot dm_bufio xt_conntrack vxlan ip6_udp_tunnel udp_tunnel 
ip6t_rpfilter ipt_rpfilter ts_bm xt_string dm_mod netconsole 
sch_fq_codel ip6table_mangle ebtable_filter ebtables dell_rbu xt_comment 
ip6t_REJECT nf_reject_ipv6 ip6table_filter ip6_tables xt_CHECKSUM 
xt_DSCP iptable_mangle xt_CT nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 
libcrc32c iptable_raw ipt_REJECT nf_reject_ipv4 xt_set xt_multiport 
iptable_filter ip_set_hash_net vfat fat skx_edac nfit 
x86_pkg_temp_thermal intel_powerclamp dell_smbios wmi_bmof dcdbas 
dell_wmi_descriptor coretemp crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper ses 
enclosure intel_cstate lpc_ich wdat_wdt sg intel_rapl_perf i2c_i801 
mfd_core wmi mlx4_en ipmi_si ipmi_devintf mlx4_core ipmi_msghandler 
acpi_power_meter vhost_net tun vhost tap kvm_intel kvm irqbypass ip_set 
nfnetlink tcp_bbr dummy ip_tables ext4 mbcache jbd2 raid1 drm_kms_helper 
syscopyarea sysfil2020-06-24 09:55:23     lrect
2020-06-24 09:55:23     [2903971.403060]  sysimgblt fb_sys_fops 
crc32c_intel drm_vram_helper ttm mlx5_core drm mpt3sas ahci libahci 
raid_class mlxfw ptp libata i2c_algo_bit scsi_transport_sas pps_core
2020-06-24 09:55:23     [2903971.471371] CR2: 00000000000004a8
2020-06-24 09:55:23     [2903971.478819] ---[ end trace 3c36ff45af0c8149 
]---
2020-06-24 09:55:23     [2903971.548065] RIP: 
0010:ip6_create_rt_rcu+0x6b/0x170
2020-06-24 09:55:23     [2903971.555231] Code: d0 0f 8f f4 00 00 00 44 
89 c0 f0 0f b1 11 0f 94 c2 84 d2 89 c6 0f 84 ba 00 00 00 45 85 c0 74 6c 
0f b6 83 86 00 00 00 4c 89 ee <49> 8b bd a8 04 00 00 89 c2 83 e2 02 80 
fa 01 19 d2 f7 d2 83 e2 08
2020-06-24 09:55:23     [2903971.570139] RSP: 0018:ffffb826f74eb720 
EFLAGS: 00010202
2020-06-24 09:55:23     [2903971.577598] RAX: 0000000000000000 RBX: 
ffff9827f204e3c0 RCX: ffff9827f204e3ec
2020-06-24 09:55:23     [2903971.585266] RDX: 0000000000000001 RSI: 
0000000000000000 RDI: ffffb826f74eb790
2020-06-24 09:55:23     [2903971.592841] RBP: ffffb826f74eb740 R08: 
0000000000000002 R09: 0000000000000000
2020-06-24 09:55:23     [2903971.600464] R10: ffff982800007640 R11: 
0000000000000000 R12: ffffb826f74eb790
2020-06-24 09:55:23     [2903971.608144] R13: 0000000000000000 R14: 
ffff982786312180 R15: ffffffffa739f540
2020-06-24 09:55:23     [2903971.615795] FS: 0000000000000000(0000) 
GS:ffff982800f00000(0000) knlGS:0000000000000000
2020-06-24 09:55:23     [2903971.623586] CS:  0010 DS: 0000 ES: 0000 
CR0: 0000000080050033
2020-06-24 09:55:23     [2903971.631416] CR2: 00000000000004a8 CR3: 
000000524eaca005 CR4: 00000000007626e0
2020-06-24 09:55:23     [2903971.639246] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
2020-06-24 09:55:23     [2903971.647056] DR3: 0000000000000000 DR6: 
00000000fffe0ff0 DR7: 0000000000000400
2020-06-24 09:55:23     [2903971.654826] PKRU: 55555554
2020-06-24 09:55:23     [2903971.662496] Kernel panic - not syncing: 
Fatal exception in interrupt
2020-06-24 09:55:23     [2903971.670438] Kernel Offset: 0x25000000 from 
0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
2020-06-24 09:55:23     [2903971.734793] ---[ end Kernel panic - not 
syncing: Fatal exception in interrupt ]---


