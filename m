Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FFB6D1F50
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 13:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjCaLki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 07:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjCaLkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 07:40:35 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC8A191FB;
        Fri, 31 Mar 2023 04:40:22 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v6-20020a05600c470600b003f034269c96so3417538wmo.4;
        Fri, 31 Mar 2023 04:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680262820;
        h=mime-version:user-agent:message-id:date:subject:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DFpj03qdDMfbyM7+XZ1x+NUK4s93aePSD7Bo/WXr5U0=;
        b=YBnjIHnh64eLbmE7oA24eR+VbM8xRR8GQ7de0OxwmFViM07spJQl/T3fMTbn/ZKxM2
         ymHqvxfTHftMOK+9hl7UZQl5U+4Qcmfi7NMjlQyz9rQ8rl5tivyboK5yLvfi6veevB9W
         xqCOxuX6TZmVoVcqgaG9x/kcAzteVh/9ECyRw+S0ll/vXh8Y6CSAWkqPD+q/AFdf3JAr
         TS9chWDaa8U6wMZT0QnstjvZX7D64cndKnbElRj3Lb75gQi6va3TcX7/yUZy4CXPhFnu
         70mV//VRCAGKlo4SWms9YSckapBFB1HTvfCcVp55ujfYSWl5+yPydNY2ogplctIf5A+X
         M2Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680262820;
        h=mime-version:user-agent:message-id:date:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DFpj03qdDMfbyM7+XZ1x+NUK4s93aePSD7Bo/WXr5U0=;
        b=xp1MZbMlepuYb6ZS8Ihn5f8/M/rtvWLK7JfPwkYi5/v374i54Lq3JhbFEgmddKDDwM
         /adSnZ4Oow18W4CtEalmYh4Urx/dfcQxxmNUWIzHGkpWO6qpFG/lBtSPAk+26b2JoV80
         +DyrmVmBI/ADpVRTsuvJqsGYQ4Ftj2dAWqjmatPD/eINjMP3bL69CbdWS9haBa9VSX8a
         TiXGA/lV9ZxDcYGzHZHPUef3uFzQxBn3NhZ4uuRHYGzALWrMdqMgAxVrD5oh4RSqlyrx
         QNQRiRn+DLETwOvuCeHkwvDNEH8JKfQ3Em8BrT1uUV0/l4rA8yl4+E1khkPdPpYIFPa7
         n7Uw==
X-Gm-Message-State: AO0yUKWuXrbbqtMajzYvyVrd8FQ5j/sWAWP8fQ+stD5opPCEGrSXI6C7
        AlaORR1O3GLgkDDp6hb9dUK0sJQ4pPDaRw==
X-Google-Smtp-Source: AK7set8bDb6+r3v4tyns18bK6BzcZCWbbumTW68hqJai8c01CT4OVwzyKlv+MXyA5H8hmWPPqmR4cA==
X-Received: by 2002:a7b:cd0d:0:b0:3e2:589:2512 with SMTP id f13-20020a7bcd0d000000b003e205892512mr20301404wmj.21.1680262820454;
        Fri, 31 Mar 2023 04:40:20 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id g20-20020a05600c4ed400b003ee8a1bc220sm9861274wmq.1.2023.03.31.04.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 04:40:19 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620 with igb
Date:   Fri, 31 Mar 2023 12:40:11 +0100
Message-ID: <m2fs9lgndw.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 6.3-rc1 and later release candidates are hanging during boot on our
Dell PowerEdge R620 servers with Intel I350 nics (igb).

After bisecting from v6.2 to v6.3-rc1, I isolated the problem to:

[6fffbc7ae1373e10b989afe23a9eeb9c49fe15c3] PCI: Honor firmware's device
disabled status

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 1779582fb500..b1d80c1d7a69 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1841,6 +1841,8 @@ int pci_setup_device(struct pci_dev *dev)
 
        pci_set_of_node(dev);
        pci_set_acpi_fwnode(dev);
+       if (dev->dev.fwnode && !fwnode_device_is_available(dev->dev.fwnode))
+               return -ENODEV;
 
        pci_dev_assign_slot(dev);
 

I have verified that reverting 6fffbc7ae1373e10b989afe23a9eeb9c49fe15c3
resolves the issue on v6.3-rc4.

Here's the kernel log from v6.3.0-rc1:

igb: Intel(R) Gigabit Ethernet Network Driver
igb: Copyright (c) 2007-2014 Intel Corporation.
igb 0000:07:00.0: can't derive routing for PCI INT D
igb 0000:07:00.0: PCI INT D: no GSI
igb 0000:07:00.0 0000:07:00.0 (uninitialized): PCIe link lost
------------[ cut here ]------------
igb: Failed to read reg 0x18!
WARNING: CPU: 23 PID: 814 at drivers/net/ethernet/intel/igb/igb_main.c:745 igb_rd32+0x78/0x90 [igb]
Modules linked in: igb(+) fjes(-) mei rapl intel_cstate mdio intel_uncore ipmi_si iTCO_wdt intel_pmc_bxt ipmi_devi>
CPU: 23 PID: 814 Comm: systemd-udevd Not tainted 6.3.0-rc1 #1
Hardware name: Dell Inc. PowerEdge R620/01W23F, BIOS 2.2.2 01/16/2014
RIP: 0010:igb_rd32+0x78/0x90 [igb]
Code: 48 c7 c6 f5 56 d3 c0 e8 96 51 f9 c8 48 8b bb 28 ff ff ff e8 3a 46 b6 c8 84 c0 74 c9 89 ee 48 c7 c7 18 64 d3 >
RSP: 0018:ffffab6a07d37b10 EFLAGS: 00010286
RAX: 000000000000001d RBX: ffff900385208f18 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff8a8ba498 RDI: 00000000ffffffff
RBP: 0000000000000018 R08: 0000000000000000 R09: ffffab6a07d379b8
R10: 0000000000000003 R11: ffffffff8b143de8 R12: ffff8ffc4518b0d0
R13: ffff9003852089c0 R14: ffff900385208f18 R15: ffff900385208000
FS:  00007faa81c07b40(0000) GS:ffff900b5fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faa811c3594 CR3: 000000010c6c0001 CR4: 00000000001706e0
Call Trace:
 <TASK>
 igb_get_invariants_82575+0x92/0xec0 [igb]
 igb_probe+0x3bd/0x1510 [igb]
 local_pci_probe+0x41/0x90
 pci_device_probe+0xb3/0x220
 really_probe+0x1a2/0x400
 ? __pfx___driver_attach+0x10/0x10
 __driver_probe_device+0x78/0x170
 driver_probe_device+0x1f/0x90
 __driver_attach+0xce/0x1c0
 bus_for_each_dev+0x74/0xb0
 bus_add_driver+0x112/0x210
 driver_register+0x55/0x100
 ? __pfx_init_module+0x10/0x10 [igb]
 do_one_initcall+0x59/0x230
 do_init_module+0x4a/0x210
 __do_sys_finit_module+0x93/0xf0
 do_syscall_64+0x5b/0x80
 ? do_syscall_64+0x67/0x80
 ? syscall_exit_to_user_mode_prepare+0x18e/0x1c0
 ? syscall_exit_to_user_mode+0x17/0x40
 ? do_syscall_64+0x67/0x80
 ? syscall_exit_to_user_mode+0x17/0x40
 ? do_syscall_64+0x67/0x80
 ? __irq_exit_rcu+0x3d/0x140
 ? common_interrupt+0x61/0xd0
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7faa81b0b27d
Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c >
RSP: 002b:00007fff03879908 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 00005594ac692a60 RCX: 00007faa81b0b27d
RDX: 0000000000000000 RSI: 00007faa8224d43c RDI: 000000000000000e
RBP: 00007faa8224d43c R08: 0000000000000000 R09: 00005594ac758fc0
R10: 000000000000000e R11: 0000000000000246 R12: 0000000000020000
R13: 00005594ac690480 R14: 0000000000000000 R15: 00005594ac693450
 </TASK>
 
