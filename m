Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C92B242390
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 03:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHLBFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 21:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHLBFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 21:05:48 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC99C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 18:05:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id o13so178107pgf.0
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 18:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=69ezjE0q6eUgkIQIXkeOC671CS7A+CGMW6pFQXUJKP0=;
        b=jDdahzjj56Eo87LouNZJ5UKjVHS4viAo+2MxWkz4lRuEJD9V9KyXhLhPipSKITTxNm
         +bWWjXp+/JqXOwXy/HUQm+MWkVFNBNhDF7lWubcUwcRsKaut13nqpQwiVRd6C2yBC8so
         MEj+TdS5VVa843PpuptoOSYFqXXZcHmJLEvr8AQ5pS0/uANyTzhkKdf6gyLObqKnu6v4
         vTlKKMU4bO/Rwt0It8hv1bhG6z5haUlB2eXAyZZSSML36orv8bafrs9I0hpz9fKujrC9
         GIIqw5BCtl47OIrFJkZb9RzXzGWtMHdwNoZO6MLYzlzaIKz8IJIqeceWkunGjrdacvdN
         8CwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=69ezjE0q6eUgkIQIXkeOC671CS7A+CGMW6pFQXUJKP0=;
        b=QDJpCOMy73+qT40KNgsWAe3DcujKns3cscK6SK5PpFYUAXdmE7mcO21+pIsUltVoUi
         7bzaWZdJrTMV2Ct1QJllp7XqzUN2yNqHT9EeR2kBnFxcxzLRCWfbHtAWtMEXqqXf150v
         hlDenxnTjmuRq/zqJpibvJsDnQRFAhkck+HUuX7K0H8wUAY2pLyRR7Yo3HN/day4rX2H
         EcSMFPyveFdQnPy5ISpCIF4o9g18liOQOBBrkh+54Ky8pRoAYDYKOKA5ql4ZbEVipLiC
         gSskVQMKWK0PV9cklQ/6SV7N7ClK3k1t7sVBqbx49pptMvh4Fsbz7n9SGwJ+PCyNaoR1
         hKyg==
X-Gm-Message-State: AOAM531AOJ7ayXYC6WjbcqTJXM2EhKkkXzPzZA72ymKeeuBx9FuRURYL
        npnLz4/bfsbQ5+osRbtZznQ99+ZPxxk=
X-Google-Smtp-Source: ABdhPJwOavGgP8t0JlcxvrPHgoT4WBIxpxhpPXdYjg1yh51bCdeTLD+vKwhYJIsFkZ84j6gpStNOJg==
X-Received: by 2002:a63:1059:: with SMTP id 25mr2653248pgq.302.1597194347844;
        Tue, 11 Aug 2020 18:05:47 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p12sm293998pff.110.2020.08.11.18.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 18:05:47 -0700 (PDT)
Date:   Tue, 11 Aug 2020 18:05:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org
Subject: BUG: mlx5 refcount_t: underflow; use-after-free. (5.7)
Message-ID: <20200811180539.66b131a1@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There appears to be a reference count bug in mlx5 device on hotplug remove.
This is reproducible in Debian testing (5.7.0-2-amd64) which is a recent kernel.

Environment Windows Server 2019 (Hyper-V) with Linux guest.
Remove the SR-IOV option from virtual NIC using GUI and hit apply.
This causes hotplug removal of PCI device in guest.

Kernel gets reference count error.

[  532.333069] hv_netvsc 4179c815-5d8a-4915-976e-9ea2378e382b eth1: Data path switched to VF: enP44703s2np0
[  532.363165] device: 'mlx5_0': device_add
[  532.370508] PM: Adding info for No Bus:mlx5_0
[  532.379786] device: 'uverbs0': device_add
[  532.382409] PM: Adding info for No Bus:uverbs0
[  532.510182] infiniband mlx5_0: renaming to rdmaP44703p0s2
[  532.547190] device class 'infiniband_cm': registering
[  532.558788] Loading iSCSI transport class v2.0-870.
[  532.567164] device class 'iscsi_transport': registering
[  532.570989] device class 'iscsi_endpoint': registering
[  532.575108] device class 'iscsi_iface': registering
[  532.578727] device class 'iscsi_host': registering
[  532.582560] device class 'iscsi_connection': registering
[  532.582702] device class 'infiniband_mad': registering
[  532.586392] device class 'iscsi_session': registering
[  532.593841] bus: 'iscsi_flashnode': registered
[  532.611082] device: 'iser': device_add
[  532.614577] PM: Adding info for No Bus:iser
[  532.623155] iscsi: registered transport (iser)
[  532.629388] device: 'rdma_cm': device_add
[  532.635064] PM: Adding info for No Bus:rdma_cm
[  532.659457] RPC: Registered named UNIX socket transport module.
[  532.667507] RPC: Registered udp transport module.
[  532.671664] RPC: Registered tcp transport module.
[  532.676335] RPC: Registered tcp NFSv4.1 backchannel transport module.
[  532.695796] RPC: Registered rdma transport module.
[  532.699960] RPC: Registered rdma backchannel transport module.
[ 1264.311748] TCP: eth0: Driver has suspect GRO implementation, TCP performance may be compromised.
[ 1484.876854] PM: Removing info for No Bus:uverbs0
[ 1484.972841] PM: Removing info for No Bus:rdmaP44703p0s2
[ 1485.730637] hv_netvsc 4179c815-5d8a-4915-976e-9ea2378e382b eth1: Data path switched from VF: enP44703s2np0
[ 1485.738086] hv_netvsc 4179c815-5d8a-4915-976e-9ea2378e382b eth1: VF unregistering: enP44703s2np0
[ 1485.745467] PM: Removing info for No Bus:enP44703s2np0
[ 1486.149250] mlx5_core ae9f:00:02.0: mlx5_destroy_flow_group:2089:(pid 990): Flow group 19 wasn't destroyed, refcount > 1
[ 1486.156135] mlx5_core ae9f:00:02.0: mlx5_destroy_flow_table:2078:(pid 990): Flow table 1048581 wasn't destroyed, refcount > 1
[ 1486.186055] mlx5_core ae9f:00:02.0: mlx5_cmd_check:753:(pid 990): DESTROY_FLOW_TABLE(0x931) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x389e56)
[ 1486.197990] mlx5_core ae9f:00:02.0: del_hw_flow_table:454:(pid 990): flow steering can't destroy ft
[ 1486.299161] ------------[ cut here ]------------
[ 1486.304071] refcount_t: underflow; use-after-free.
[ 1486.309209] WARNING: CPU: 1 PID: 990 at lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0
[ 1486.313184] Modules linked in: rpcrdma sunrpc rdma_ucm ib_iser rdma_cm iw_cm libiscsi ib_umad ib_ipoib scsi_transport_iscsi configfs ib_cm mlx5_ib ib_uverbs ib_core mlx5_core mlxfw pci_hyperv pci_hyperv_intf act_mirred cls_flower sch_ingress sch_multiq tun intel_rapl_msr intel_rapl_common sb_edac ghash_clmulni_intel aesni_intel libaes nls_ascii crypto_simd nls_cp437 cryptd glue_helper vfat rapl serio_raw fat efi_pstore hv_utils ptp evdev hyperv_fb hyperv_keyboard hv_balloon pps_core sg efivars pcspkr joydev drm efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic sd_mod sr_mod t10_pi crc_t10dif cdrom crct10dif_generic hv_netvsc hid_generic hid_hyperv hv_storvsc scsi_transport_fc hid scsi_mod crct10dif_pclmul crct10dif_common crc32_pclmul hv_vmbus crc32c_intel
[ 1486.313184] CPU: 1 PID: 990 Comm: kworker/u8:0 Not tainted 5.7.0-2-amd64 #1 Debian 5.7.10-1
[ 1486.313184] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0 01/30/2019
[ 1486.313184] Workqueue: hv_pci_ae9f hv_eject_device_work [pci_hyperv]
[ 1486.313184] RIP: 0010:refcount_warn_saturate+0xa6/0xf0
[ 1486.313184] Code: 05 af 73 ce 00 01 e8 1b 6d c5 ff 0f 0b c3 80 3d 9d 73 ce 00 00 75 95 48 c7 c7 70 34 d2 a1 c6 05 8d 73 ce 00 01 e8 fc 6c c5 ff <0f> 0b c3 80 3d 7c 73 ce 00 00 0f 85 72 ff ff ff 48 c7 c7 c8 34 d2
[ 1486.313184] RSP: 0018:ffffbeb9406e3c28 EFLAGS: 00010282
[ 1486.313184] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 1486.313184] RDX: ffff96c283ca9900 RSI: ffff96c283c99ac8 RDI: ffff96c283c99ac8
[ 1486.313184] RBP: ffff96c2686586d8 R08: 000000000000065a R09: ffffbeb945baf01c
[ 1486.313184] R10: 0000000000aaaaaa R11: 00000000ff000000 R12: ffff96c26e24e370
[ 1486.313184] R13: ffff96c26e24e3d0 R14: ffff96c26e55ea80 R15: ffff96c1b6010890
[ 1486.313184] FS:  0000000000000000(0000) GS:ffff96c283c80000(0000) knlGS:0000000000000000
[ 1486.313184] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1486.313184] CR2: 00005651a0346e58 CR3: 00000000ecd90003 CR4: 00000000003606e0
[ 1486.313184] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1486.313184] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1486.313184] Call Trace:
[ 1486.313184]  tree_put_node+0x115/0x150 [mlx5_core]
[ 1486.313184]  clean_tree+0x48/0xd0 [mlx5_core]
[ 1486.313184]  clean_tree+0x48/0xd0 [mlx5_core]
[ 1486.313184]  clean_tree+0x48/0xd0 [mlx5_core]
[ 1486.313184]  clean_tree+0x58/0xd0 [mlx5_core]
[ 1486.313184]  clean_tree+0x48/0xd0 [mlx5_core]
[ 1486.313184]  clean_tree+0x58/0xd0 [mlx5_core]
[ 1486.313184]  mlx5_cleanup_fs+0x26/0x160 [mlx5_core]
[ 1486.313184]  mlx5_unload+0x1e/0x80 [mlx5_core]
[ 1486.313184]  mlx5_unload_one+0x49/0xb0 [mlx5_core]
[ 1486.313184]  remove_one+0x3f/0x70 [mlx5_core]
[ 1486.313184]  pci_device_remove+0x3b/0xa0
[ 1486.313184]  device_release_driver_internal+0xe4/0x1c0
[ 1486.313184]  pci_stop_bus_device+0x68/0x90
[ 1486.313184]  pci_stop_and_remove_bus_device+0xe/0x20
[ 1486.313184]  hv_eject_device_work+0x6c/0x170 [pci_hyperv]
[ 1486.313184]  ? __schedule+0x2e2/0x770
[ 1486.313184]  process_one_work+0x1b4/0x380
[ 1486.313184]  worker_thread+0x50/0x3c0
[ 1486.313184]  kthread+0xf9/0x130
[ 1486.313184]  ? process_one_work+0x380/0x380
[ 1486.313184]  ? kthread_park+0x90/0x90
[ 1486.313184]  ret_from_fork+0x35/0x40
[ 1486.313184] ---[ end trace 36bebf916c9c3f8e ]---
[ 1486.526006] mlx5_core ae9f:00:02.0: mlx5_cmd_check:753:(pid 990): DESTROY_FLOW_GROUP(0x934) op_mod(0x0) failed, status bad resource state(0x9), syndrome (0x563e2f)
[ 1486.534741] mlx5_core ae9f:00:02.0: del_hw_flow_group:584:(pid 990): flow steering can't destroy fg 19 of ft 1048581
[ 1486.544489] mlx5_core ae9f:00:02.0: mlx5_cmd_check:753:(pid 990): DESTROY_FLOW_TABLE(0x931) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x66d6c3)
[ 1486.555257] mlx5_core ae9f:00:02.0: del_hw_flow_table:454:(pid 990): flow steering can't destroy ft
[ 1486.562116] mlx5_core ae9f:00:02.0: mlx5_cmd_check:753:(pid 990): DESTROY_FLOW_TABLE(0x931) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x389e56)
[ 1486.573629] mlx5_core ae9f:00:02.0: del_hw_flow_table:454:(pid 990): flow steering can't destroy ft
[ 1487.781955] PM: Removing info for No Bus:ptp1
[ 1488.218522] bus: 'pci': remove device ae9f:00:02.0
[ 1488.223662] PM: Removing info for pci:ae9f:00:02.0
[ 1488.230235] hv_netvsc 4179c815-5d8a-4915-976e-9ea2378e382b eth1: VF slot 2 removed
[ 1488.230243] device: '2383f0f2-ae9f-4ffb-be78-a687e08f3d1d': device_unregister
[ 1488.247874] bus: 'vmbus': remove device 2383f0f2-ae9f-4ffb-be78-a687e08f3d1d
[ 1488.264833] device: 'ae9f:00': device_unregister
[ 1488.270150] PM: Removing info for No Bus:ae9f:00
[ 1488.275894] device: 'pciae9f:00': device_unregister
[ 1488.281550] PM: Removing info for No Bus:pciae9f:00
[ 1488.287609] PM: Removing info for vmbus:2383f0f2-ae9f-4ffb-be78-a687e08f3d1d
