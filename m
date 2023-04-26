Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F336EF79D
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbjDZPQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240511AbjDZPQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:16:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BE661A9
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682522145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btvlxsLNMBwIhDJuOQ2AKkOzN4j/Yy1O9lQbuvlEHBE=;
        b=RlUpjkiOJc3rk6DdJLjH9o3KSiXBGRpjt2HgGd5nz7bY7OAbsc3l/TuRgO/NYMgs9+eOPH
        4YNgJW4LC4sXQserNtYN5LlikQe3NCm0SiCaFEiUjbQNp+gam3EHjKvFlZxlRxJgTTAgV6
        Z652rFYcEDJSPKfL9BaN73s1l36q17g=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-wlX2jgoVNMqFjyTEPmHv5A-1; Wed, 26 Apr 2023 11:15:43 -0400
X-MC-Unique: wlX2jgoVNMqFjyTEPmHv5A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-95836419a73so562871666b.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682522141; x=1685114141;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btvlxsLNMBwIhDJuOQ2AKkOzN4j/Yy1O9lQbuvlEHBE=;
        b=L8KFiB2EF8xpU3/iWC1Z4/VWStU8ZzYZ9TOW0aH+pevmTykwNXCIGC5Z8/PUDvb7v4
         J7oBcG/4rM3IdoD1xEOd3tBDBdnJI+/PVzx3IXXmCSSm70j2PF7JdhIlkeT6QVSQbNRI
         vbPrLDUiHxM7zUl8hF9XeY4aPgdVr7kUbLZr0VxW1TqVJ0RLn7qAcxrvD35A5AvYSTIy
         8RbxQ/SeV28XPGj+hBwf70HMr1p3V7SnEmLBd30tKK6kQLiaf5Pb6FRWwh+bLYWmwMxA
         2drg33TghZvm0ZMFTDDE+gStZXUSil94fuMjKCVvHHN/RhceN6OtovsIxID0qO0L2xZZ
         P0Gg==
X-Gm-Message-State: AAQBX9dRZ2+Ku27qFrhd9N53Zf7keinDhbrrBlxLu3Ukv4V56pAJJyai
        1CaX86rq33vpLnBLn9LwVUdUwQpe3xPSjVro6Gd/JfVexBPAmFjAGHbZ0ja7dkBN4IFuNmaGHWx
        qF7xC3voROBPIDwzb
X-Received: by 2002:a17:906:76d4:b0:94f:764e:e311 with SMTP id q20-20020a17090676d400b0094f764ee311mr16470411ejn.16.1682522141532;
        Wed, 26 Apr 2023 08:15:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350aLnMVhJGlV5O3U+aToD+Ujz+A+5OsDyS4ehiTZ1imYMoUMDGCWaq9PFUtXrSz7/Q6baWvYKQ==
X-Received: by 2002:a17:906:76d4:b0:94f:764e:e311 with SMTP id q20-20020a17090676d400b0094f764ee311mr16470383ejn.16.1682522141162;
        Wed, 26 Apr 2023 08:15:41 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id bq6-20020a056402214600b0050470aa444fsm6892866edb.51.2023.04.26.08.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 08:15:40 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <82545fdc-31cc-b963-06c8-151b538bc8a3@redhat.com>
Date:   Wed, 26 Apr 2023 17:15:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Cc:     brouer@redhat.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>,
        lorenzo@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linyunsheng@huawei.com, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V1 2/3] page_pool: Use static_key for
 shutdown phase
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <168244288038.1741095.1092368365531131826.stgit@firesoul>
 <168244294384.1741095.6037010854411310099.stgit@firesoul>
 <20230425233027.w3olphld4nkcdvry@dhcp-172-26-102-232.dhcp.thefacebook.com>
In-Reply-To: <20230425233027.w3olphld4nkcdvry@dhcp-172-26-102-232.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 26/04/2023 01.30, Alexei Starovoitov wrote:
> On Tue, Apr 25, 2023 at 07:15:43PM +0200, Jesper Dangaard Brouer wrote:
>> Performance is very important for page pool (PP). This add the use of
>> static_key APIs for regaining a single instruction, which makes the
>> new PP shutdown scheme zero impact.
>>
>> We are uncertain if this is 100% correct, because static_key APIs uses
>> a mutex lock and it is uncertain if all contexts that can return pages
>> can support this. We could spawn a workqueue (like we just removed) to
>> workaround this issue.
> 
> With debug atomic sleep the issue should be trivial to see.
> iirc the callers of xdp_flush_frame_bulk() need to do it under rcu_read_lock equivalent,
> which is not sleepable and mutex-es should warn.
> 

Sure, adding CONFIG_DEBUG_ATOMIC_SLEEP and (keeping) CONFIG_DEBUG_MUTEXES.

Testing this with veth changes that added page_pool to veth
commit 0ebab78cbcbf ("net: veth: add page_pool for page recycling").
which makes it easier to create/trigger inflight packets
via softnet_data->defer_list.

It confirms my suspicion, this patch is not correct.

The dmesg warning looks like below.
(The XXX printk is just from my own debugging patch)

The call site net_rx_action+0xe7 is skb_defer_free_flush
  $ ./scripts/faddr2line vmlinux net_rx_action+0xe7
  net_rx_action+0xe7/0x360:
  skb_defer_free_flush at net/core/dev.c:6615
  (inlined by) skb_defer_free_flush at net/core/dev.c:6601
  (inlined by) net_rx_action at net/core/dev.c:6677


[ 1540.073256] XXX page_pool_shutdown_attempt() inflight=24
[ 1540.078654] XXX page_pool_destroy() Enter into shutdown phase - 
inflight=24
[ 1540.094234] XXX page_pool_shutdown_attempt() inflight=23
[ 1540.099626] XXX page_pool_shutdown_attempt() inflight=22
[ 1540.105012] XXX page_pool_shutdown_attempt() inflight=21
[ 1540.110402] XXX page_pool_shutdown_attempt() inflight=20
[ 1540.115793] XXX page_pool_shutdown_attempt() inflight=19
[ 1540.121183] XXX page_pool_shutdown_attempt() inflight=18
[ 1540.126564] XXX page_pool_shutdown_attempt() inflight=17
[ 1540.131945] XXX page_pool_shutdown_attempt() inflight=16
[ 1540.137329] XXX page_pool_shutdown_attempt() inflight=15
[ 1540.142710] XXX page_pool_shutdown_attempt() inflight=14
[ 1540.148110] XXX page_pool_shutdown_attempt() inflight=13
[ 1540.153512] XXX page_pool_shutdown_attempt() inflight=12
[ 1540.312284] XXX page_pool_shutdown_attempt() inflight=11
[ 1540.317712] XXX page_pool_shutdown_attempt() inflight=10
[ 1540.323128] XXX page_pool_shutdown_attempt() inflight=9
[ 1540.328459] XXX page_pool_shutdown_attempt() inflight=8
[ 1540.333788] XXX page_pool_shutdown_attempt() inflight=7
[ 1540.339111] XXX page_pool_shutdown_attempt() inflight=6
[ 1540.344439] XXX page_pool_shutdown_attempt() inflight=5
[ 1540.349768] XXX page_pool_shutdown_attempt() inflight=4
[ 1540.355091] XXX page_pool_shutdown_attempt() inflight=3
[ 1540.360420] XXX page_pool_shutdown_attempt() inflight=2
[ 1540.365741] XXX page_pool_shutdown_attempt() inflight=1
[ 1540.371064] BUG: sleeping function called from invalid context at 
include/linux/percpu-rwsem.h:49
[ 1540.380052] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 
26501, name: netperf
[ 1540.388171] preempt_count: 101, expected: 0
[ 1540.392452] RCU nest depth: 2, expected: 0
[ 1540.396640] CPU: 2 PID: 26501 Comm: netperf Not tainted 
6.3.0-rc7-net-next-pp-shutdown-vm-lock-dbg+ #67
[ 1540.406147] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 
2.0a 08/01/2016
[ 1540.413749] Call Trace:
[ 1540.416289]  <IRQ>
[ 1540.418395]  dump_stack_lvl+0x32/0x50
[ 1540.422160]  __might_resched+0x11c/0x160
[ 1540.426182]  cpus_read_lock+0x16/0x60
[ 1540.429942]  static_key_slow_dec+0x17/0x50
[ 1540.434137]  page_pool_shutdown_attempt+0x50/0x60
[ 1540.438940]  page_pool_return_skb_page+0x68/0xe0
[ 1540.443654]  skb_free_head+0x4f/0x90
[ 1540.447326]  skb_release_data+0x142/0x1a0
[ 1540.451435]  napi_consume_skb+0x6b/0x180
[ 1540.455448]  net_rx_action+0xe7/0x360
[ 1540.459209]  __do_softirq+0xcb/0x2b1
[ 1540.462885]  do_softirq+0x63/0x90
[ 1540.466297]  </IRQ>
[ 1540.468487]  <TASK>
[ 1540.470671]  __local_bh_enable_ip+0x64/0x70
[ 1540.474948]  __dev_queue_xmit+0x257/0x8a0
[ 1540.479049]  ? __ip_local_out+0x48/0x160
[ 1540.483070]  ip_finish_output2+0x25c/0x540
[ 1540.487255]  __ip_queue_xmit+0x171/0x420
[ 1540.491266]  ? ___slab_alloc+0xd1/0x670
[ 1540.495202]  __tcp_transmit_skb+0x83c/0x950
[ 1540.499486]  tcp_write_xmit+0x373/0xa60
[ 1540.503419]  __tcp_push_pending_frames+0x32/0xf0
[ 1540.508125]  tcp_sendmsg_locked+0x3a0/0xa10
[ 1540.512408]  tcp_sendmsg+0x27/0x40
[ 1540.515907]  sock_sendmsg+0x8b/0xa0
[ 1540.519494]  ? sockfd_lookup_light+0x12/0x70
[ 1540.523856]  __sys_sendto+0xeb/0x130
[ 1540.527531]  ? __switch_to_asm+0x3a/0x80
[ 1540.531549]  ? rseq_get_rseq_cs+0x32/0x290
[ 1540.535736]  ? rseq_ip_fixup+0x14f/0x1e0
[ 1540.539751]  __x64_sys_sendto+0x20/0x30
[ 1540.543686]  do_syscall_64+0x3a/0x90
[ 1540.547357]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[ 1540.552502] RIP: 0033:0x7f389f713680
[ 1540.556174] Code: 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 41 89 ca 
64 8b 04 25 18 00 00 00 85 c0 75 1d 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 68 c3 0f 1f 80 00 00 00 00 55 48 83 ec 20 48
[ 1540.575075] RSP: 002b:00007ffcb4d4a538 EFLAGS: 00000246 ORIG_RAX: 
000000000000002c
[ 1540.582755] RAX: ffffffffffffffda RBX: 000000000063fd28 RCX: 
00007f389f713680
[ 1540.589983] RDX: 0000000000004000 RSI: 0000000001ac3c40 RDI: 
0000000000000004
[ 1540.597208] RBP: 00007ffcb4d4a570 R08: 0000000000000000 R09: 
0000000000000000
[ 1540.604438] R10: 0000000000000000 R11: 0000000000000246 R12: 
000000000063fcf8
[ 1540.611664] R13: 00007ffcb4d4a910 R14: 0000000000000000 R15: 
00007f389fa87000
[ 1540.618896]  </TASK>
[ 1540.621199] ------------[ cut here ]------------
[ 1540.625911] WARNING: CPU: 2 PID: 26501 at kernel/smp.c:912 
smp_call_function_many_cond+0x2c1/0x2e0
[ 1540.635001] Modules linked in: veth nf_defrag_ipv6 nf_defrag_ipv4 
ib_umad rdma_ucm ib_ipoib rdma_cm iw_cm irdma ib_cm ice 
intel_uncore_frequency intel_uncore_frequency_common coretemp kvm_intel 
mlx5_ib kvm ib_uverbs irqbypass rapl intel_cstate ib_core i2c_i801 
intel_uncore pcspkr i2c_smbus bfq acpi_ipmi wmi ipmi_si ipmi_devintf 
ipmi_msghandler acpi_pad sch_fq_codel drm fuse zram zsmalloc mlx5_core 
ixgbe i40e igb igc sd_mod t10_pi mlxfw psample hid_generic 
crc64_rocksoft_generic i2c_algo_bit crc64_rocksoft i2c_core mdio ptp 
pps_core [last unloaded: bpfilter]
[ 1540.684653] CPU: 2 PID: 26501 Comm: netperf Tainted: G        W 
    6.3.0-rc7-net-next-pp-shutdown-vm-lock-dbg+ #67
[ 1540.695642] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 
2.0a 08/01/2016
[ 1540.703239] RIP: 0010:smp_call_function_many_cond+0x2c1/0x2e0
[ 1540.709090] Code: fe ff ff 8b 44 24 14 48 c7 c6 a0 04 fc 82 8b 15 85 
f4 e6 01 48 8b 3c 24 8d 48 01 48 63 c9 e8 36 c5 4b 00 89 c2 e9 c5 fd ff 
ff <0f> 0b e9 86 fd ff ff 8b 7c 24 28 e8 4f b8 f7 ff eb af 66 66 2e 0f
[ 1540.727999] RSP: 0018:ffffc9000003cda8 EFLAGS: 00010206
[ 1540.733322] RAX: 0000000000000102 RBX: ffffffff8383b2ea RCX: 
0000000000000003
[ 1540.740552] RDX: 0000000000000000 RSI: ffffffff810271a0 RDI: 
ffffffff82fc04a0
[ 1540.747782] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000001
[ 1540.755008] R10: 000000087c9e9000 R11: ffffffff82c4f620 R12: 
0000000000000000
[ 1540.762241] R13: ffffffff8383b300 R14: 0000000000000002 R15: 
0000000000000001
[ 1540.769474] FS:  00007f389f954740(0000) GS:ffff88887fc80000(0000) 
knlGS:0000000000000000
[ 1540.777685] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1540.783528] CR2: 00007f1e27582000 CR3: 000000015775c004 CR4: 
00000000003706e0
[ 1540.790761] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1540.797987] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[ 1540.805220] Call Trace:
[ 1540.807763]  <IRQ>
[ 1540.809868]  ? __pfx_do_sync_core+0x10/0x10
[ 1540.814146]  on_each_cpu_cond_mask+0x20/0x40
[ 1540.818514]  text_poke_bp_batch+0x9e/0x250
[ 1540.822708]  text_poke_finish+0x1b/0x30
[ 1540.826644]  arch_jump_label_transform_apply+0x16/0x30
[ 1540.831880]  __static_key_slow_dec_cpuslocked.part.0+0x2f/0x40
[ 1540.837809]  static_key_slow_dec+0x30/0x50
[ 1540.841999]  page_pool_shutdown_attempt+0x50/0x60
[ 1540.846803]  page_pool_return_skb_page+0x68/0xe0
[ 1540.851517]  skb_free_head+0x4f/0x90
[ 1540.855194]  skb_release_data+0x142/0x1a0
[ 1540.859300]  napi_consume_skb+0x6b/0x180
[ 1540.863320]  net_rx_action+0xe7/0x360
[ 1540.867082]  __do_softirq+0xcb/0x2b1
[ 1540.870756]  do_softirq+0x63/0x90
[ 1540.874171]  </IRQ>
[ 1540.876359]  <TASK>
[ 1540.878553]  __local_bh_enable_ip+0x64/0x70
[ 1540.882829]  __dev_queue_xmit+0x257/0x8a0
[ 1540.886938]  ? __ip_local_out+0x48/0x160
[ 1540.890959]  ip_finish_output2+0x25c/0x540
[ 1540.895155]  __ip_queue_xmit+0x171/0x420
[ 1540.899175]  ? ___slab_alloc+0xd1/0x670
[ 1540.903108]  __tcp_transmit_skb+0x83c/0x950
[ 1540.907393]  tcp_write_xmit+0x373/0xa60
[ 1540.911327]  __tcp_push_pending_frames+0x32/0xf0
[ 1540.916041]  tcp_sendmsg_locked+0x3a0/0xa10
[ 1540.920324]  tcp_sendmsg+0x27/0x40
[ 1540.923821]  sock_sendmsg+0x8b/0xa0
[ 1540.927411]  ? sockfd_lookup_light+0x12/0x70
[ 1540.931780]  __sys_sendto+0xeb/0x130
[ 1540.935456]  ? __switch_to_asm+0x3a/0x80
[ 1540.939477]  ? rseq_get_rseq_cs+0x32/0x290
[ 1540.943670]  ? rseq_ip_fixup+0x14f/0x1e0
[ 1540.947693]  __x64_sys_sendto+0x20/0x30
[ 1540.951626]  do_syscall_64+0x3a/0x90
[ 1540.955300]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[ 1540.960451] RIP: 0033:0x7f389f713680
[ 1540.964124] Code: 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 41 89 ca 
64 8b 04 25 18 00 00 00 85 c0 75 1d 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 68 c3 0f 1f 80 00 00 00 00 55 48 83 ec 20 48
[ 1540.983035] RSP: 002b:00007ffcb4d4a538 EFLAGS: 00000246 ORIG_RAX: 
000000000000002c
[ 1540.990724] RAX: ffffffffffffffda RBX: 000000000063fd28 RCX: 
00007f389f713680
[ 1540.997957] RDX: 0000000000004000 RSI: 0000000001ac3c40 RDI: 
0000000000000004
[ 1541.005187] RBP: 00007ffcb4d4a570 R08: 0000000000000000 R09: 
0000000000000000
[ 1541.012422] R10: 0000000000000000 R11: 0000000000000246 R12: 
000000000063fcf8
[ 1541.019649] R13: 00007ffcb4d4a910 R14: 0000000000000000 R15: 
00007f389fa87000
[ 1541.026881]  </TASK>
[ 1541.029166] ---[ end trace 0000000000000000 ]---
[ 1541.033925] XXX page_pool_shutdown_attempt() inflight=0




