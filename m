Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5640646056
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLGRhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLGRhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 12:37:31 -0500
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563B55B869;
        Wed,  7 Dec 2022 09:37:30 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id c17so17359030edj.13;
        Wed, 07 Dec 2022 09:37:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UuoSE1OAoQ/voX/8rDdL495pSywfEx3lR0HiciuEM3M=;
        b=1mcDGvP44Eeop8fNj9t4QBDyaF8N9x7InaKaIDH/PMyrq5HT0VDJCeATuyfwzSP0d0
         UTHEEh4ltZRDOj0rDBrA77ULqNWj7uhprycN62GZYYLcTHZ+RHLlfpHDoKUN+WYaG2kQ
         8PlZVpxyGIJtAiVaeprE9zHmxsjynsC+mbEac9Z34r4o4kRsEdnVz6/wNvguQSVXrNwg
         mbLkpeUrghMw8s2IAuVdfN6CWycnsuDv5bnGLPaotgWHhGDOvcFfw7VOuQ6jkLeU4tXQ
         6dUElnpvns9HdX9x76l7t6fxq29tL/o21ZeGEw8bebnfiHmgFx2tFqVIs20p7Bqoeold
         /dIg==
X-Gm-Message-State: ANoB5pkrYLLtXooH0c2dhW/kCGgOTkhPp8Rd+rx9ynOj9SjDDl7g1pH0
        i6UPn8J1Ng3MFtM/ezZ4iv8=
X-Google-Smtp-Source: AA0mqf714ok462wUiNbLf0eeh5fyKMBd33FfVOqCvwl8YcO9sZKf6M1ledenUqw1W77eOI1WwZTfSg==
X-Received: by 2002:a05:6402:1f09:b0:462:6a0c:cfa with SMTP id b9-20020a0564021f0900b004626a0c0cfamr45502045edb.349.1670434648840;
        Wed, 07 Dec 2022 09:37:28 -0800 (PST)
Received: from gmail.com (fwdproxy-cln-004.fbsv.net. [2a03:2880:31ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id e10-20020a170906314a00b007bfc5cbaee8sm8867403eje.17.2022.12.07.09.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 09:37:28 -0800 (PST)
Date:   Wed, 7 Dec 2022 09:37:23 -0800
From:   Breno Leitao <leitao@debian.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, leit@fb.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next] tcp: socket-specific version of
 WARN_ON_ONCE()
Message-ID: <Y5DPU3p+N7rBW+QY@gmail.com>
References: <20220831133758.3741187-1-leitao@debian.org>
 <CANn89iLe9spogp7eaXPziA0L-FqJ0w=6VxdWDL6NKGobTyuQRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLe9spogp7eaXPziA0L-FqJ0w=6VxdWDL6NKGobTyuQRw@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 03, 2022 at 09:42:43AM -0700, Eric Dumazet wrote:
> On Wed, Aug 31, 2022 at 6:38 AM Breno Leitao <leitao@debian.org> wrote:
> >
> > There are cases where we need information about the socket during a
> > warning, so, it could help us to find bugs that happens that do not have
> > a easily repro.
> >
> > BPF congestion control algorithms can change socket state in unexpected
> > ways, leading to WARNings. Additional information about the socket state
> > is useful to identify the culprit.
> 
> Well, this suggests we need to fix BPF side ?
> 
> Not sure how this can happen, because TCP_BPF_IW has
> 
> if (val <= 0 || tp->data_segs_out > tp->syn_data)
>      ret = -EINVAL;
> else
>     tcp_snd_cwnd_set(tp, val);

I am not sure we are hitting this path, please check the stack below

> It seems you already found the issue in an eBPF CC, can you share the details ?

Sure, here is an example of what we are facing (with some obfuscation).
Remeber that there are users' BPF application running:

[155375.750105] ------------[ cut here ]------------
[155375.759526] WARNING: CPU: 19 PID: 0 at net/ipv4/tcp.c:4552 tcp_sock_warn+0x6/0x20
[155375.774700] Modules linked in: vhost_net tun vhost vhost_iotlb tap virtio_net net_failover failover mpls_gso mpls_iptunnel mpls_router ip_tunnel fou ip6_udp_tunnel udp_tunnel sch_fq sunrpc bpf_preload tls act_gact cls_bpf tcp_diag inet_diag skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm evdev ses irqbypass enclosure i2c_i801 i2c_smbus ipmi_si ipmi_devintf ipmi_msghandler acpi_cpufreq button tpm_crb sch_fq_codel fuse sg nvme mpi3mr scsi_transport_sas nvme_core xhci_pci xhci_hcd loop efivarfs autofs4
[155375.874916] CPU: 19 PID: 0 Comm: swapper/19 Kdump: loaded Tainted: G S                5.12.0-0_XXXXXXXX_g0fed6f189e14 #1
[155375.898770] Hardware name: XXXX XXX XXXX XXXXX, BIOS BS_BIOS_XXX XX/XX/2022
[155375.916015] RIP: 0010:tcp_sock_warn+0x6/0x20
[155375.924755] Code: 4d 01 3e 85 c0 0f 84 57 ff ff ff 48 8b 0c 24 44 8b 01 eb 82 e8 eb b7 14 00 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53 <0f> 0b 48 85 ff 0f 85 77 70 14 00 5b c3 66 66 2e 0f 1f 84 00 00 00
[155375.962518] RSP: 0018:ffffc90000d08988 EFLAGS: 00010246
[155375.973157] RAX: ffff88817432b5c0 RBX: ffff88828f748000 RCX: ffffc90000d08a34
[155375.987614] RDX: 0000000000000000 RSI: 00000000822be8c8 RDI: ffff88828f748000
[155376.002074] RBP: 0000000000000040 R08: ffffc90000d08a38 R09: 00000000822be334
[155376.016531] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[155376.030988] R13: ffffc90000d08a34 R14: 0000000000005546 R15: 0000000000000000
[155376.045441] FS:  0000000000000000(0000) GS:ffff88903f8c0000(0000) knlGS:0000000000000000
[155376.061804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[155376.073474] CR2: 00007fe407603080 CR3: 0000000b19993006 CR4: 00000000007706e0
[155376.087928] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[155376.102383] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[155376.116841] PKRU: 55555554
[155376.122427] Call Trace:
[155376.127497]  <IRQ>
[155376.131697]  tcp_fastretrans_alert+0x988/0x9e0
[155376.140774]  tcp_ack+0x8b4/0x1360
[155376.147581]  ? __cgroup_bpf_run_filter_skb+0x185/0x440
[155376.158037]  tcp_rcv_established+0x135/0x660
[155376.166755]  ? sk_filter_trim_cap+0xbc/0x220
[155376.175472]  tcp_v6_do_rcv+0xbe/0x3e0
[155376.182974]  tcp_v6_rcv+0xc01/0xc90
[155376.190128]  ip6_protocol_deliver_rcu+0xbd/0x450
[155376.199541]  ip6_input_finish+0x3d/0x60
[155376.207388]  ip6_input+0xb5/0xc0
[155376.214019]  ip6_sublist_rcv_finish+0x37/0x50
[155376.222912]  ip6_sublist_rcv+0x1dd/0x270
[155376.230935]  ipv6_list_rcv+0x113/0x140
[155376.238618]  __netif_receive_skb_list_core+0x1a0/0x210
[155376.249080]  netif_receive_skb_list_internal+0x186/0x2a0
[155376.259887]  gro_normal_list.part.171+0x19/0x40
[155376.269137]  napi_complete_done+0x65/0x150
[155376.277514]  bnxt_poll_p5+0x25b/0x2b0
[155376.285027]  ? tcp_write_xmit+0x278/0x1060
[155376.293398]  __napi_poll+0x25/0x120
[155376.300552]  net_rx_action+0x189/0x300
[155376.308227]  __do_softirq+0xbb/0x271
[155376.315554]  irq_exit_rcu+0x97/0xa0
[155376.322710]  common_interrupt+0x7f/0xa0
[155376.330566]  </IRQ>
[155376.334947]  asm_common_interrupt+0x1e/0x40
[155376.343499] RIP: 0010:cpuidle_enter_state+0xc2/0x340
[155376.353619] Code: 48 89 c5 0f 1f 44 00 00 31 ff e8 f9 8d 73 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 38 02 00 00 31 ff e8 b2 36 79 ff fb 45 85 f6 <0f> 88 e8 00 00 00 49 63 d6 48 2b 2c 24 48 6b ca 68 48 8d 04 52 48
[155376.391367] RSP: 0018:ffffc90000293e90 EFLAGS: 00000202
[155376.402004] RAX: ffff88903f8eaa80 RBX: ffffe8ffff4c6c00 RCX: 000000000000001f
[155376.416456] RDX: 00008d503c63f228 RSI: 000000005ba4b680 RDI: 0000000000000000
[155376.430910] RBP: 00008d503c63f228 R08: 0000000000000002 R09: 000000000002a300
[155376.445372] R10: 002435b781e62f4a R11: ffff88903f8e9a84 R12: 0000000000000001
[155376.459832] R13: ffffffff83621200 R14: 0000000000000001 R15: 0000000000000000
[155376.474307]  cpuidle_enter+0x29/0x40
[155376.481654]  do_idle+0x1bb/0x200
[155376.488297]  cpu_startup_entry+0x19/0x20
[155376.496320]  start_secondary+0x104/0x140
[155376.504342]  secondary_startup_64_no_verify+0xb0/0xbb
[155376.514629] ---[ end trace 9b428a0d7901c3ff ]---
[155376.524041] TCP: Socket Info: family=10 state=1 sport=12345 dport=57616 ccname=ned_tcp_dctcp01 cwnd=1
[155376.524045] TCP: saddr=XXXX:XXXX:XXXX:XXXX:XXXX:0000:00c8:0000 daddr=XXXX:XXXX:XXXX:XXXX:XXXX:0000:0288:00
