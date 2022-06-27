Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EEB55D877
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbiF0Kgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 06:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiF0Kg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 06:36:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FDE163EB
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 03:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656326184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=O1/fh6D3C+FPvqUWaR8xahOpGi8vnVs87gLrDxZMoQo=;
        b=PygLTFeOkk7djNYpCRwTKX2CMdSHSRFYixA3Qm1uWQ57YZArK+8Pz+VQnCWsQPEfjhWwP+
        EDQreMsxi8aJgxXKBF7Lla0nxJZGLY3v8sMlgcJA5JRvKdsZ8AS82ojmW5eGNd7VEl1KJZ
        JzsC7tMSdLAKlQKSzXcTA+KDjFjhmOc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-AbeJApqhOOqo6hbfqrABjQ-1; Mon, 27 Jun 2022 06:36:21 -0400
X-MC-Unique: AbeJApqhOOqo6hbfqrABjQ-1
Received: by mail-qk1-f197.google.com with SMTP id i128-20020a375486000000b006af454d52bcso219969qkb.8
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 03:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:content-language:content-transfer-encoding;
        bh=O1/fh6D3C+FPvqUWaR8xahOpGi8vnVs87gLrDxZMoQo=;
        b=elInNEylscLF2ioG7JZFDQX2dWRmZi8qJMYAodzuhLQrm5av6xhYOD0PtNEeoEm8lV
         vD4mSvJlibNYEb4XlqmAWkKDjY00JMIhy36Qeq8hxDYxTnsIX8Fp/OPNolBEDnt4Qb8r
         Ce8+bX6WS1NaMkdwD5jl490NeV415jnOG1Xsh8gRQs69AKpz+vzkJwgSLzjNtRMXoQ7W
         VVevhN81Kssguew5FqBztiIkHX8m2HHNXAo65JFEG3Fbxt4Fvnh9x1ikJHdOVQwyCrJ7
         5lUjMNMV9N3Nj3QEcsriC4hnV23M8Hob45ao3smCTXUQrMRnqsNu3WlocZVQe0j82cyb
         AjOw==
X-Gm-Message-State: AJIora9X0d1rmU5hx8mYFAiqTIQtJ/AOkpQ+7Lb7CtEOQCK1dn/LrZPs
        +6ERDPYhp7XcfN87nE8jl6hzUlBhL7JH9ouNG9L2eEC6uJ0U4f6YvBs3MGPnKy0zaZ3dEGiW6L3
        W6Xy1Tj6k5oxsXnYa
X-Received: by 2002:a05:622a:94:b0:316:dd82:734f with SMTP id o20-20020a05622a009400b00316dd82734fmr8470247qtw.172.1656326178721;
        Mon, 27 Jun 2022 03:36:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sgUGFcGkLWX/SwHCNDjUNGirpK7lwZM+i1C+q6ePPsEkph71QhOTPjvRAR45ojrkDaZBHw1w==
X-Received: by 2002:a05:622a:94:b0:316:dd82:734f with SMTP id o20-20020a05622a009400b00316dd82734fmr8470211qtw.172.1656326177642;
        Mon, 27 Jun 2022 03:36:17 -0700 (PDT)
Received: from [10.16.222.26] (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id o1-20020a05620a2a0100b006a79479657fsm8946557qkp.108.2022.06.27.03.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 03:36:17 -0700 (PDT)
Message-ID: <af48e133-afb1-15e4-3875-e325aacc2d52@redhat.com>
Date:   Mon, 27 Jun 2022 06:36:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
From:   Prarit Bhargava <prarit@redhat.com>
Subject: Wireless WARNING flood seen on Lenovo X1
To:     Michal Schmidt <mschmidt@redhat.com>, sassmann@redhat.com,
        netdev@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The warning flood occurs frequently between 5-10 mins after system boot. 
  I've also noticed that at times the wireless network device takes 
20-30 seconds longer than normal to connect.  The only thing that seems 
to get the system back to a functional state is a reboot.

dmesg (with stack traces) and lspci are below.  Please let me know if 
there is anytihng else I can provide to help debug, if this is fixed in 
latest,  or if there is test code that I can apply to the kernel to help 
validate a fix.

[    0.000000] microcode: microcode updated early to revision 0xf0, date 
= 2021-11-12
[    0.000000] Linux version 5.18.5-200.fc36.x86_64 
(mockbuild@bkernel01.iad2.fedoraproject.org) (gcc (GCC) 12.1.1 20220507 
(Red Hat 12.1.1-1), GNU ld version 2.37-27.fc36) #1 SMP PREEMPT_DYNAMIC 
Thu Jun 16 14:51:11 UTC 2022
[    0.000000] Command line: 
BOOT_IMAGE=(hd0,msdos1)/vmlinuz-5.18.5-200.fc36.x86_64 
root=/dev/mapper/fedora_dhcp--17--161-root ro 
resume=/dev/mapper/fedora_dhcp--17--161-swap 
rd.lvm.lv=fedora_dhcp-17-161/root rd.lvm.lv=fedora_dhcp-17-161/swap rhgb 
quiet systemd.unified_cgroup_hierarchy=0
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating 
point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds 
registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 
960 bytes, using 'compacted' format.
[    0.000000] signal: max sigframe size: 2032
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000040163fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040164000-0x000000004501efff] 
reserved
[    0.000000] BIOS-e820: [mem 0x000000004501f000-0x000000004501ffff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000045020000-0x000000004ff2bfff] 
reserved
[    0.000000] BIOS-e820: [mem 0x000000004ff2c000-0x000000004ff99fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000004ff9a000-0x000000004fffefff] 
ACPI data
[    0.000000] BIOS-e820: [mem 0x000000004ffff000-0x0000000057ffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000058600000-0x000000005c7fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fd000000-0x00000000fe7fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed84000-0x00000000fed84fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000004a17fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 3.0.0 present.
[    0.000000] DMI: LENOVO 20HR006SUS/20HR006SUS, BIOS N1MET42W (1.27 ) 
12/12/2017
[    0.000000] tsc: Detected 2900.000 MHz processor
[    0.000000] tsc: Detected 2899.886 MHz TSC
[    0.001036] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.001042] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.001052] last_pfn = 0x4a1800 max_arch_pfn = 0x400000000
[    0.001275] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.002830] last_pfn = 0x40164 max_arch_pfn = 0x400000000
[    0.016843] Using GB pages for direct mapping
[    0.017512] RAMDISK: [mem 0x33515000-0x35a81fff]
[    0.017520] ACPI: Early table checksum verification disabled
[    0.017524] ACPI: RSDP 0x00000000000F0140 000024 (v02 LENOVO)
[    0.017531] ACPI: XSDT 0x000000004FFC2188 0000FC (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017539] ACPI: FACP 0x000000004FFF5000 0000F4 (v05 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017547] ACPI: DSDT 0x000000004FFD0000 020E02 (v02 LENOVO SKL 
00000000 INTL 20160527)
[    0.017553] ACPI: FACS 0x000000004FF3D000 000040
[    0.017557] ACPI: SSDT 0x000000004FFFC000 0003CC (v02 LENOVO Tpm2Tabl 
00001000 INTL 20160527)
[    0.017562] ACPI: TPM2 0x000000004FFFB000 000034 (v03 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017566] ACPI: UEFI 0x000000004FF53000 000042 (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017571] ACPI: SSDT 0x000000004FFF7000 003246 (v02 LENOVO SaSsdt 
00003000 INTL 20160527)
[    0.017576] ACPI: SSDT 0x000000004FFF6000 0005B6 (v02 LENOVO PerfTune 
00001000 INTL 20160527)
[    0.017581] ACPI: HPET 0x000000004FFF4000 000038 (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017585] ACPI: APIC 0x000000004FFF3000 0000BC (v03 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017590] ACPI: MCFG 0x000000004FFF2000 00003C (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017594] ACPI: ECDT 0x000000004FFF1000 000053 (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017599] ACPI: SSDT 0x000000004FFCE000 001627 (v02 LENOVO ProjSsdt 
00000010 INTL 20160527)
[    0.017604] ACPI: BOOT 0x000000004FFCD000 000028 (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017608] ACPI: BATB 0x000000004FFCC000 00004A (v02 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017613] ACPI: SLIC 0x000000004FFCB000 000176 (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017618] ACPI: SSDT 0x000000004FFC9000 0017AE (v02 LENOVO CpuSsdt 
00003000 INTL 20160527)
[    0.017622] ACPI: SSDT 0x000000004FFC8000 00056D (v02 LENOVO CtdpB 
00001000 INTL 20160527)
[    0.017627] ACPI: SSDT 0x000000004FFC7000 000678 (v02 LENOVO UsbCTabl 
00001000 INTL 20160527)
[    0.017632] ACPI: WSMT 0x000000004FFC6000 000028 (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017636] ACPI: SSDT 0x000000004FFC5000 000141 (v02 LENOVO HdaDsp 
00000000 INTL 20160527)
[    0.017641] ACPI: SSDT 0x000000004FFC4000 00050D (v02 LENOVO TbtTypeC 
00000000 INTL 20160527)
[    0.017646] ACPI: DBGP 0x000000004FFC3000 000034 (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017650] ACPI: DBG2 0x000000004FFFD000 000054 (v00 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017655] ACPI: MSDM 0x000000004FFC1000 000055 (v03 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017659] ACPI: DMAR 0x000000004FFC0000 0000A8 (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017664] ACPI: ASF! 0x000000004FFBF000 0000A0 (v32 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017669] ACPI: FPDT 0x000000004FFBE000 000044 (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017673] ACPI: UEFI 0x000000004FF3A000 00013E (v01 LENOVO TP-N1M 
00001270 PTEC 00000002)
[    0.017677] ACPI: Reserving FACP table memory at [mem 
0x4fff5000-0x4fff50f3]
[    0.017680] ACPI: Reserving DSDT table memory at [mem 
0x4ffd0000-0x4fff0e01]
[    0.017682] ACPI: Reserving FACS table memory at [mem 
0x4ff3d000-0x4ff3d03f]
[    0.017683] ACPI: Reserving SSDT table memory at [mem 
0x4fffc000-0x4fffc3cb]
[    0.017685] ACPI: Reserving TPM2 table memory at [mem 
0x4fffb000-0x4fffb033]
[    0.017686] ACPI: Reserving UEFI table memory at [mem 
0x4ff53000-0x4ff53041]
[    0.017688] ACPI: Reserving SSDT table memory at [mem 
0x4fff7000-0x4fffa245]
[    0.017689] ACPI: Reserving SSDT table memory at [mem 
0x4fff6000-0x4fff65b5]
[    0.017691] ACPI: Reserving HPET table memory at [mem 
0x4fff4000-0x4fff4037]
[    0.017692] ACPI: Reserving APIC table memory at [mem 
0x4fff3000-0x4fff30bb]
[    0.017694] ACPI: Reserving MCFG table memory at [mem 
0x4fff2000-0x4fff203b]
[    0.017695] ACPI: Reserving ECDT table memory at [mem 
0x4fff1000-0x4fff1052]
[    0.017697] ACPI: Reserving SSDT table memory at [mem 
0x4ffce000-0x4ffcf626]
[    0.017698] ACPI: Reserving BOOT table memory at [mem 
0x4ffcd000-0x4ffcd027]
[    0.017700] ACPI: Reserving BATB table memory at [mem 
0x4ffcc000-0x4ffcc049]
[    0.017701] ACPI: Reserving SLIC table memory at [mem 
0x4ffcb000-0x4ffcb175]
[    0.017703] ACPI: Reserving SSDT table memory at [mem 
0x4ffc9000-0x4ffca7ad]
[    0.017704] ACPI: Reserving SSDT table memory at [mem 
0x4ffc8000-0x4ffc856c]
[    0.017706] ACPI: Reserving SSDT table memory at [mem 
0x4ffc7000-0x4ffc7677]
[    0.017707] ACPI: Reserving WSMT table memory at [mem 
0x4ffc6000-0x4ffc6027]
[    0.017709] ACPI: Reserving SSDT table memory at [mem 
0x4ffc5000-0x4ffc5140]
[    0.017710] ACPI: Reserving SSDT table memory at [mem 
0x4ffc4000-0x4ffc450c]
[    0.017712] ACPI: Reserving DBGP table memory at [mem 
0x4ffc3000-0x4ffc3033]
[    0.017713] ACPI: Reserving DBG2 table memory at [mem 
0x4fffd000-0x4fffd053]
[    0.017715] ACPI: Reserving MSDM table memory at [mem 
0x4ffc1000-0x4ffc1054]
[    0.017716] ACPI: Reserving DMAR table memory at [mem 
0x4ffc0000-0x4ffc00a7]
[    0.017718] ACPI: Reserving ASF! table memory at [mem 
0x4ffbf000-0x4ffbf09f]
[    0.017720] ACPI: Reserving FPDT table memory at [mem 
0x4ffbe000-0x4ffbe043]
[    0.017721] ACPI: Reserving UEFI table memory at [mem 
0x4ff3a000-0x4ff3a13d]
[    0.017846] No NUMA configuration found
[    0.017848] Faking a node at [mem 0x0000000000000000-0x00000004a17fffff]
[    0.017865] NODE_DATA(0) allocated [mem 0x4a17d5000-0x4a17fffff]
[    0.055777] Zone ranges:
[    0.055779]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.055783]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.055786]   Normal   [mem 0x0000000100000000-0x00000004a17fffff]
[    0.055788]   Device   empty
[    0.055790] Movable zone start for each node
[    0.055795] Early memory node ranges
[    0.055795]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.055798]   node   0: [mem 0x0000000000100000-0x0000000040163fff]
[    0.055800]   node   0: [mem 0x0000000100000000-0x00000004a17fffff]
[    0.055804] Initmem setup node 0 [mem 
0x0000000000001000-0x00000004a17fffff]
[    0.055811] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.055844] On node 0, zone DMA: 99 pages in unavailable ranges
[    0.094505] On node 0, zone Normal: 32412 pages in unavailable ranges
[    0.094999] On node 0, zone Normal: 26624 pages in unavailable ranges
[    0.095012] Reserving Intel graphics memory at [mem 
0x5a800000-0x5c7fffff]
[    0.095202] ACPI: PM-Timer IO Port: 0x1808
[    0.095211] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.095214] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.095216] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.095217] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.095219] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.095220] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.095221] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.095222] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.095250] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-119
[    0.095255] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.095258] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.095264] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.095265] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.095270] TSC deadline timer available
[    0.095272] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.095301] PM: hibernation: Registered nosave memory: [mem 
0x00000000-0x00000fff]
[    0.095305] PM: hibernation: Registered nosave memory: [mem 
0x0009d000-0x0009ffff]
[    0.095307] PM: hibernation: Registered nosave memory: [mem 
0x000a0000-0x000dffff]
[    0.095308] PM: hibernation: Registered nosave memory: [mem 
0x000e0000-0x000fffff]
[    0.095311] PM: hibernation: Registered nosave memory: [mem 
0x40164000-0x4501efff]
[    0.095312] PM: hibernation: Registered nosave memory: [mem 
0x4501f000-0x4501ffff]
[    0.095314] PM: hibernation: Registered nosave memory: [mem 
0x45020000-0x4ff2bfff]
[    0.095315] PM: hibernation: Registered nosave memory: [mem 
0x4ff2c000-0x4ff99fff]
[    0.095316] PM: hibernation: Registered nosave memory: [mem 
0x4ff9a000-0x4fffefff]
[    0.095318] PM: hibernation: Registered nosave memory: [mem 
0x4ffff000-0x57ffffff]
[    0.095319] PM: hibernation: Registered nosave memory: [mem 
0x58000000-0x585fffff]
[    0.095320] PM: hibernation: Registered nosave memory: [mem 
0x58600000-0x5c7fffff]
[    0.095321] PM: hibernation: Registered nosave memory: [mem 
0x5c800000-0xefffffff]
[    0.095322] PM: hibernation: Registered nosave memory: [mem 
0xf0000000-0xf7ffffff]
[    0.095324] PM: hibernation: Registered nosave memory: [mem 
0xf8000000-0xfcffffff]
[    0.095325] PM: hibernation: Registered nosave memory: [mem 
0xfd000000-0xfe7fffff]
[    0.095326] PM: hibernation: Registered nosave memory: [mem 
0xfe800000-0xfebfffff]
[    0.095327] PM: hibernation: Registered nosave memory: [mem 
0xfec00000-0xfec00fff]
[    0.095328] PM: hibernation: Registered nosave memory: [mem 
0xfec01000-0xfecfffff]
[    0.095330] PM: hibernation: Registered nosave memory: [mem 
0xfed00000-0xfed00fff]
[    0.095331] PM: hibernation: Registered nosave memory: [mem 
0xfed01000-0xfed0ffff]
[    0.095332] PM: hibernation: Registered nosave memory: [mem 
0xfed10000-0xfed19fff]
[    0.095333] PM: hibernation: Registered nosave memory: [mem 
0xfed1a000-0xfed83fff]
[    0.095335] PM: hibernation: Registered nosave memory: [mem 
0xfed84000-0xfed84fff]
[    0.095336] PM: hibernation: Registered nosave memory: [mem 
0xfed85000-0xfedfffff]
[    0.095337] PM: hibernation: Registered nosave memory: [mem 
0xfee00000-0xfee00fff]
[    0.095338] PM: hibernation: Registered nosave memory: [mem 
0xfee01000-0xff7fffff]
[    0.095340] PM: hibernation: Registered nosave memory: [mem 
0xff800000-0xffffffff]
[    0.095342] [mem 0x5c800000-0xefffffff] available for PCI devices
[    0.095344] Booting paravirtualized kernel on bare hardware
[    0.095347] clocksource: refined-jiffies: mask: 0xffffffff 
max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.105207] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 
nr_node_ids:1
[    0.105441] percpu: Embedded 61 pages/cpu s212992 r8192 d28672 u524288
[    0.105452] pcpu-alloc: s212992 r8192 d28672 u524288 alloc=1*2097152
[    0.105456] pcpu-alloc: [0] 0 1 2 3
[    0.105498] Fallback order for Node 0: 0
[    0.105502] Built 1 zonelists, mobility grouping on.  Total pages: 
4005886
[    0.105505] Policy zone: Normal
[    0.105507] Kernel command line: 
BOOT_IMAGE=(hd0,msdos1)/vmlinuz-5.18.5-200.fc36.x86_64 
root=/dev/mapper/fedora_dhcp--17--161-root ro 
resume=/dev/mapper/fedora_dhcp--17--161-swap 
rd.lvm.lv=fedora_dhcp-17-161/root rd.lvm.lv=fedora_dhcp-17-161/swap rhgb 
quiet systemd.unified_cgroup_hierarchy=0
[    0.105703] Unknown kernel command line parameters "rhgb 
BOOT_IMAGE=(hd0,msdos1)/vmlinuz-5.18.5-200.fc36.x86_64", will be passed 
to user space.
[    0.106936] Dentry cache hash table entries: 2097152 (order: 12, 
16777216 bytes, linear)
[    0.107565] Inode-cache hash table entries: 1048576 (order: 11, 
8388608 bytes, linear)
[    0.107799] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.177409] Memory: 15837900K/16278528K available (16393K kernel 
code, 3726K rwdata, 11268K rodata, 2716K init, 6088K bss, 440368K 
reserved, 0K cma-reserved)
[    0.179345] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.179413] Kernel/User page tables isolation: enabled
[    0.179440] ftrace: allocating 49904 entries in 195 pages
[    0.193357] ftrace: allocated 195 pages with 4 groups
[    0.194730] Dynamic Preempt: voluntary
[    0.194859] rcu: Preemptible hierarchical RCU implementation.
[    0.194860] rcu: 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.194863] 	Trampoline variant of Tasks RCU enabled.
[    0.194864] 	Rude variant of Tasks RCU enabled.
[    0.194864] 	Tracing variant of Tasks RCU enabled.
[    0.194866] rcu: RCU calculated value of scheduler-enlistment delay 
is 100 jiffies.
[    0.194867] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.203734] NR_IRQS: 524544, nr_irqs: 1024, preallocated irqs: 16
[    0.204202] kfence: initialized - using 2097152 bytes for 255 objects 
at 0x(____ptrval____)-0x(____ptrval____)
[    0.204254] random: crng init done
[    0.208163] Console: colour VGA+ 80x25
[    0.208184] printk: console [tty0] enabled
[    0.208211] ACPI: Core revision 20211217
[    0.208532] hpet: HPET dysfunctional in PC10. Force disabled.
[    0.208535] APIC: Switch to symmetric I/O mode setup
[    0.208538] DMAR: Host address width 39
[    0.208539] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.208547] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 
1c0000c40660462 ecap 19e2ff0505e
[    0.208552] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.208557] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap 
d2008c40660462 ecap f050da
[    0.208560] DMAR: RMRR base: 0x0000004f49f000 end: 0x0000004f4befff
[    0.208563] DMAR: RMRR base: 0x0000005a000000 end: 0x0000005c7fffff
[    0.208566] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.208568] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.208570] DMAR-IR: Queued invalidation will be enabled to support 
x2apic and Intr-remapping.
[    0.210437] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.210440] x2apic enabled
[    0.210455] Switched APIC routing to cluster x2apic.
[    0.214348] clocksource: tsc-early: mask: 0xffffffffffffffff 
max_cycles: 0x29ccd767b87, max_idle_ns: 440795223720 ns
[    0.214357] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 5799.77 BogoMIPS (lpj=2899886)
[    0.214361] pid_max: default: 32768 minimum: 301
[    0.214395] LSM: Security Framework initializing
[    0.214410] Yama: becoming mindful.
[    0.214417] SELinux:  Initializing.
[    0.214450] LSM support for eBPF active
[    0.214453] landlock: Up and running.
[    0.214513] Mount-cache hash table entries: 32768 (order: 6, 262144 
bytes, linear)
[    0.214555] Mountpoint-cache hash table entries: 32768 (order: 6, 
262144 bytes, linear)
[    0.214872] CPU0: Thermal monitoring enabled (TM1)
[    0.214967] process: using mwait in idle threads
[    0.214971] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.214973] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.214982] Spectre V1 : Mitigation: usercopy/swapgs barriers and 
__user pointer sanitization
[    0.214987] Spectre V2 : Mitigation: Retpolines
[    0.214988] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling 
RSB on context switch
[    0.214989] Spectre V2 : Enabling Restricted Speculation for firmware 
calls
[    0.214991] Spectre V2 : mitigation: Enabling conditional Indirect 
Branch Prediction Barrier
[    0.214993] Spectre V2 : User space: Mitigation: STIBP via prctl
[    0.214995] Speculative Store Bypass: Mitigation: Speculative Store 
Bypass disabled via prctl
[    0.215005] MDS: Mitigation: Clear CPU buffers
[    0.215006] TAA: Mitigation: TSX disabled
[    0.215007] MMIO Stale Data: Mitigation: Clear CPU buffers
[    0.215015] SRBDS: Mitigation: Microcode
[    0.215353] Freeing SMP alternatives memory: 44K
[    0.215353] smpboot: Estimated ratio of average max frequency by base 
frequency (times 1024): 1377
[    0.215353] smpboot: CPU0: Intel(R) Core(TM) i7-7600U CPU @ 2.80GHz 
(family: 0x6, model: 0x8e, stepping: 0x9)
[    0.215353] cblist_init_generic: Setting adjustable number of 
callback queues.
[    0.215353] cblist_init_generic: Setting shift to 2 and lim to 1.
[    0.215353] cblist_init_generic: Setting shift to 2 and lim to 1.
[    0.215353] cblist_init_generic: Setting shift to 2 and lim to 1.
[    0.215353] Performance Events: PEBS fmt3+, Skylake events, 32-deep 
LBR, full-width counters, Intel PMU driver.
[    0.215353] ... version:                4
[    0.215353] ... bit width:              48
[    0.215353] ... generic registers:      4
[    0.215353] ... value mask:             0000ffffffffffff
[    0.215353] ... max period:             00007fffffffffff
[    0.215353] ... fixed-purpose events:   3
[    0.215353] ... event mask:             000000070000000f
[    0.215353] rcu: Hierarchical SRCU implementation.
[    0.215868] NMI watchdog: Enabled. Permanently consumes one hw-PMU 
counter.
[    0.215948] smp: Bringing up secondary CPUs ...
[    0.216073] x86: Booting SMP configuration:
[    0.216074] .... node  #0, CPUs:      #1 #2
[    0.217656] MDS CPU bug present and SMT on, data leak possible. See 
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for 
more details.
[    0.217656] MMIO Stale Data CPU bug present and SMT on, data leak 
possible. See 
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processor_mmio_stale_data.html 
for more details.
[    0.217656]  #3
[    0.218799] smp: Brought up 1 node, 4 CPUs
[    0.218799] smpboot: Max logical packages: 1
[    0.218799] smpboot: Total of 4 processors activated (23199.08 BogoMIPS)
[    0.220075] devtmpfs: initialized
[    0.220075] x86/mm: Memory block size: 128MB
[    0.222119] ACPI: PM: Registering ACPI NVS region [mem 
0x4501f000-0x4501ffff] (4096 bytes)
[    0.222119] ACPI: PM: Registering ACPI NVS region [mem 
0x4ff2c000-0x4ff99fff] (450560 bytes)
[    0.222119] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.222119] futex hash table entries: 1024 (order: 4, 65536 bytes, 
linear)
[    0.222387] pinctrl core: initialized pinctrl subsystem
[    0.222617] PM: RTC time: 21:00:36, date: 2022-06-26
[    0.222974] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.223169] DMA: preallocated 2048 KiB GFP_KERNEL pool for atomic 
allocations
[    0.223178] DMA: preallocated 2048 KiB GFP_KERNEL|GFP_DMA pool for 
atomic allocations
[    0.223185] DMA: preallocated 2048 KiB GFP_KERNEL|GFP_DMA32 pool for 
atomic allocations
[    0.223201] audit: initializing netlink subsys (disabled)
[    0.223212] audit: type=2000 audit(1656277236.008:1): 
state=initialized audit_enabled=0 res=1
[    0.223375] thermal_sys: Registered thermal governor 'fair_share'
[    0.223377] thermal_sys: Registered thermal governor 'bang_bang'
[    0.223379] thermal_sys: Registered thermal governor 'step_wise'
[    0.223380] thermal_sys: Registered thermal governor 'user_space'
[    0.223394] cpuidle: using governor menu
[    0.223484] Simple Boot Flag at 0x47 set to 0x1
[    0.223484] ACPI FADT declares the system doesn't support PCIe ASPM, 
so disable it
[    0.223484] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.223612] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 
0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.223620] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
[    0.223638] PCI: Using configuration type 1 for base access
[    0.223881] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.226548] kprobes: kprobe jump-optimization is enabled. All kprobes 
are optimized if possible.
[    0.226561] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.226561] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.226561] cryptd: max_cpu_qlen set to 1000
[    0.226561] raid6: skipped pq benchmark and selected avx2x4
[    0.226561] raid6: using avx2x2 recovery algorithm
[    0.226561] ACPI: Added _OSI(Module Device)
[    0.226561] ACPI: Added _OSI(Processor Device)
[    0.226561] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.226561] ACPI: Added _OSI(Processor Aggregator Device)
[    0.226561] ACPI: Added _OSI(Linux-Dell-Video)
[    0.226561] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.226561] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.292951] ACPI: 10 ACPI AML tables successfully acquired and loaded
[    0.294388] ACPI: EC: EC started
[    0.294390] ACPI: EC: interrupt blocked
[    0.296505] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.296507] ACPI: EC: Boot ECDT EC used to handle transactions
[    0.298407] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.309688] ACPI: Dynamic OEM Table Load:
[    0.309707] ACPI: SSDT 0xFFFFA00E01128800 0006F6 (v02 PmRef  Cpu0Ist 
00003000 INTL 20160527)
[    0.311363] ACPI: \_PR_.PR00: _OSC native thermal LVT Acked
[    0.312869] ACPI: Dynamic OEM Table Load:
[    0.312881] ACPI: SSDT 0xFFFFA00E00EFF000 0003FF (v02 PmRef  Cpu0Cst 
00003001 INTL 20160527)
[    0.314513] ACPI: Dynamic OEM Table Load:
[    0.314523] ACPI: SSDT 0xFFFFA00E01026780 0000BA (v02 PmRef  Cpu0Hwp 
00003000 INTL 20160527)
[    0.316020] ACPI: Dynamic OEM Table Load:
[    0.316030] ACPI: SSDT 0xFFFFA00E01129000 000628 (v02 PmRef  HwpLvt 
00003000 INTL 20160527)
[    0.317981] ACPI: Dynamic OEM Table Load:
[    0.317996] ACPI: SSDT 0xFFFFA00E0007B000 000D14 (v02 PmRef  ApIst 
00003000 INTL 20160527)
[    0.320456] ACPI: Dynamic OEM Table Load:
[    0.320468] ACPI: SSDT 0xFFFFA00E0110D800 000317 (v02 PmRef  ApHwp 
00003000 INTL 20160527)
[    0.322135] ACPI: Dynamic OEM Table Load:
[    0.322145] ACPI: SSDT 0xFFFFA00E0110E000 00030A (v02 PmRef  ApCst 
00003000 INTL 20160527)
[    0.325347] ACPI: Interpreter enabled
[    0.325436] ACPI: PM: (supports S0 S3 S4 S5)
[    0.325438] ACPI: Using IOAPIC for interrupt routing
[    0.325493] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.326339] ACPI: Enabled 7 GPEs in block 00 to 7F
[    0.331160] ACPI: PM: Power Resource [PUBS]
[    0.348728] ACPI: PM: Power Resource [WRST]
[    0.348916] ACPI: PM: Power Resource [WRST]
[    0.366652] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    0.366663] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI EDR HPX-Type3]
[    0.366757] acpi PNP0A08:00: _OSC: platform does not support 
[PCIeHotplug SHPCHotplug PME AER PCIeCapability]
[    0.366837] acpi PNP0A08:00: _OSC: not requesting control; platform 
does not support [PCIeCapability]
[    0.366840] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug 
SHPCHotplug PME AER PCIeCapability LTR DPC]
[    0.366842] acpi PNP0A08:00: _OSC: platform willing to grant [LTR DPC]
[    0.366843] acpi PNP0A08:00: _OSC: platform retains control of PCIe 
features (AE_SUPPORT)
[    0.369684] PCI host bridge to bus 0000:00
[    0.369687] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.369691] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.369694] pci_bus 0000:00: root bus resource [mem 
0x000a0000-0x000bffff window]
[    0.369696] pci_bus 0000:00: root bus resource [mem 
0x5c800000-0xefffffff window]
[    0.369698] pci_bus 0000:00: root bus resource [mem 
0xfd000000-0xfe7fffff window]
[    0.369700] pci_bus 0000:00: root bus resource [bus 00-7e]
[    0.369721] pci 0000:00:00.0: [8086:5904] type 00 class 0x060000
[    0.369826] pci 0000:00:02.0: [8086:5916] type 00 class 0x030000
[    0.369841] pci 0000:00:02.0: reg 0x10: [mem 0xeb000000-0xebffffff 64bit]
[    0.369851] pci 0000:00:02.0: reg 0x18: [mem 0x60000000-0x6fffffff 
64bit pref]
[    0.369858] pci 0000:00:02.0: reg 0x20: [io  0xe000-0xe03f]
[    0.369884] pci 0000:00:02.0: Video device with shadowed ROM at [mem 
0x000c0000-0x000dffff]
[    0.370106] pci 0000:00:08.0: [8086:1911] type 00 class 0x088000
[    0.370123] pci 0000:00:08.0: reg 0x10: [mem 0xec348000-0xec348fff 64bit]
[    0.370269] pci 0000:00:14.0: [8086:9d2f] type 00 class 0x0c0330
[    0.370291] pci 0000:00:14.0: reg 0x10: [mem 0xec320000-0xec32ffff 64bit]
[    0.370373] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.371123] pci 0000:00:14.2: [8086:9d31] type 00 class 0x118000
[    0.371144] pci 0000:00:14.2: reg 0x10: [mem 0xec349000-0xec349fff 64bit]
[    0.371283] pci 0000:00:16.0: [8086:9d3a] type 00 class 0x078000
[    0.371301] pci 0000:00:16.0: reg 0x10: [mem 0xec34a000-0xec34afff 64bit]
[    0.371363] pci 0000:00:16.0: PME# supported from D3hot
[    0.371793] pci 0000:00:16.3: [8086:9d3d] type 00 class 0x070002
[    0.371810] pci 0000:00:16.3: reg 0x10: [io  0xe060-0xe067]
[    0.371820] pci 0000:00:16.3: reg 0x14: [mem 0xec34c000-0xec34cfff]
[    0.371969] pci 0000:00:1c.0: [8086:9d10] type 01 class 0x060400
[    0.372061] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.372686] pci 0000:00:1c.2: [8086:9d12] type 01 class 0x060400
[    0.372779] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.373375] pci 0000:00:1c.4: [8086:9d14] type 01 class 0x060400
[    0.373477] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.374092] pci 0000:00:1d.0: [8086:9d18] type 01 class 0x060400
[    0.374198] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.374811] pci 0000:00:1f.0: [8086:9d4e] type 00 class 0x060100
[    0.375368] pci 0000:00:1f.2: [8086:9d21] type 00 class 0x058000
[    0.375386] pci 0000:00:1f.2: reg 0x10: [mem 0xec344000-0xec347fff]
[    0.375870] pci 0000:00:1f.3: [8086:9d71] type 00 class 0x040300
[    0.375897] pci 0000:00:1f.3: reg 0x10: [mem 0xec340000-0xec343fff 64bit]
[    0.375934] pci 0000:00:1f.3: reg 0x20: [mem 0xec330000-0xec33ffff 64bit]
[    0.375993] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.376543] pci 0000:00:1f.4: [8086:9d23] type 00 class 0x0c0500
[    0.376602] pci 0000:00:1f.4: reg 0x10: [mem 0xec34b000-0xec34b0ff 64bit]
[    0.376675] pci 0000:00:1f.4: reg 0x20: [io  0xefa0-0xefbf]
[    0.377172] pci 0000:00:1f.6: [8086:15d7] type 00 class 0x020000
[    0.377193] pci 0000:00:1f.6: reg 0x10: [mem 0xec300000-0xec31ffff]
[    0.377302] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.377791] pci 0000:02:00.0: [10ec:525a] type 00 class 0xff0000
[    0.377825] pci 0000:02:00.0: reg 0x14: [mem 0xec200000-0xec200fff]
[    0.377965] pci 0000:02:00.0: supports D1 D2
[    0.377966] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.378137] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.378143] pci 0000:00:1c.0:   bridge window [mem 0xec200000-0xec2fffff]
[    0.378718] pci 0000:04:00.0: [8086:24fd] type 00 class 0x028000
[    0.378811] pci 0000:04:00.0: reg 0x10: [mem 0xec100000-0xec101fff 64bit]
[    0.379446] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.380198] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.380204] pci 0000:00:1c.2:   bridge window [mem 0xec100000-0xec1fffff]
[    0.380375] pci 0000:05:00.0: [144d:a808] type 00 class 0x010802
[    0.380399] pci 0000:05:00.0: reg 0x10: [mem 0xec000000-0xec003fff 64bit]
[    0.380880] pci 0000:00:1c.4: PCI bridge to [bus 05]
[    0.380886] pci 0000:00:1c.4:   bridge window [mem 0xec000000-0xec0fffff]
[    0.380942] pci 0000:00:1d.0: PCI bridge to [bus 06-70]
[    0.380948] pci 0000:00:1d.0:   bridge window [mem 0xbc000000-0xea0fffff]
[    0.380954] pci 0000:00:1d.0:   bridge window [mem 
0x70000000-0xb9ffffff 64bit pref]
[    0.383175] ACPI: PCI: Interrupt link LNKA configured for IRQ 11
[    0.383237] ACPI: PCI: Interrupt link LNKB configured for IRQ 10
[    0.383295] ACPI: PCI: Interrupt link LNKC configured for IRQ 11
[    0.383357] ACPI: PCI: Interrupt link LNKD configured for IRQ 11
[    0.383415] ACPI: PCI: Interrupt link LNKE configured for IRQ 11
[    0.383472] ACPI: PCI: Interrupt link LNKF configured for IRQ 11
[    0.383529] ACPI: PCI: Interrupt link LNKG configured for IRQ 11
[    0.383587] ACPI: PCI: Interrupt link LNKH configured for IRQ 11
[    0.384505] ACPI: EC: interrupt unblocked
[    0.384507] ACPI: EC: event unblocked
[    0.384520] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.384521] ACPI: EC: GPE=0x16
[    0.384523] ACPI: \_SB_.PCI0.LPCB.EC__: Boot ECDT EC initialization 
complete
[    0.384526] ACPI: \_SB_.PCI0.LPCB.EC__: EC: Used to handle 
transactions and events
[    0.384643] iommu: Default domain type: Translated
[    0.384643] iommu: DMA domain TLB invalidation policy: lazy mode
[    0.384643] SCSI subsystem initialized
[    0.384643] libata version 3.00 loaded.
[    0.384643] ACPI: bus type USB registered
[    0.384643] usbcore: registered new interface driver usbfs
[    0.384643] usbcore: registered new interface driver hub
[    0.384643] usbcore: registered new device driver usb
[    0.384643] pps_core: LinuxPPS API ver. 1 registered
[    0.384643] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 
Rodolfo Giometti <giometti@linux.it>
[    0.384643] PTP clock support registered
[    0.384643] EDAC MC: Ver: 3.0.0
[    0.385837] NetLabel: Initializing
[    0.385837] NetLabel:  domain hash size = 128
[    0.385837] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.385837] NetLabel:  unlabeled traffic allowed by default
[    0.385837] mctp: management component transport protocol core
[    0.385837] NET: Registered PF_MCTP protocol family
[    0.385837] PCI: Using ACPI for IRQ routing
[    0.391796] PCI: pci_cache_line_size set to 64 bytes
[    0.392563] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
[    0.392565] e820: reserve RAM buffer [mem 0x40164000-0x43ffffff]
[    0.392567] e820: reserve RAM buffer [mem 0x4a1800000-0x4a3ffffff]
[    0.392589] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.392589] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.392589] pci 0000:00:02.0: vgaarb: VGA device added: 
decodes=io+mem,owns=io+mem,locks=none
[    0.392589] vgaarb: loaded
[    0.392589] clocksource: Switched to clocksource tsc-early
[    0.410378] VFS: Disk quotas dquot_6.6.0
[    0.410393] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)
[    0.410500] pnp: PnP ACPI init
[    0.410747] system 00:00: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.410753] system 00:00: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.410756] system 00:00: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.410759] system 00:00: [mem 0xfe000000-0xfe01ffff] has been reserved
[    0.410761] system 00:00: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.410767] system 00:00: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.410770] system 00:00: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.411224] system 00:01: [io  0xff00-0xfffe] has been reserved
[    0.411722] system 00:02: [io  0x0680-0x069f] has been reserved
[    0.411726] system 00:02: [io  0xffff] has been reserved
[    0.411729] system 00:02: [io  0xffff] has been reserved
[    0.411731] system 00:02: [io  0xffff] has been reserved
[    0.411733] system 00:02: [io  0x1800-0x18fe] has been reserved
[    0.411735] system 00:02: [io  0x164e-0x164f] has been reserved
[    0.411937] system 00:04: [io  0x1854-0x1857] has been reserved
[    0.412131] system 00:07: [io  0x1800-0x189f] could not be reserved
[    0.412135] system 00:07: [io  0x0800-0x087f] has been reserved
[    0.412137] system 00:07: [io  0x0880-0x08ff] has been reserved
[    0.412139] system 00:07: [io  0x0900-0x097f] has been reserved
[    0.412141] system 00:07: [io  0x0980-0x09ff] has been reserved
[    0.412144] system 00:07: [io  0x0a00-0x0a7f] has been reserved
[    0.412146] system 00:07: [io  0x0a80-0x0aff] has been reserved
[    0.412148] system 00:07: [io  0x0b00-0x0b7f] has been reserved
[    0.412150] system 00:07: [io  0x0b80-0x0bff] has been reserved
[    0.412152] system 00:07: [io  0x15e0-0x15ef] has been reserved
[    0.412154] system 00:07: [io  0x1600-0x167f] could not be reserved
[    0.412156] system 00:07: [io  0x1640-0x165f] could not be reserved
[    0.412160] system 00:07: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.412163] system 00:07: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.412166] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.412169] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.412171] system 00:07: [mem 0xfeb00000-0xfebfffff] has been reserved
[    0.412174] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.412179] system 00:07: [mem 0xfed90000-0xfed93fff] could not be 
reserved
[    0.412182] system 00:07: [mem 0xeffe0000-0xefffffff] has been reserved
[    0.414019] system 00:08: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    0.414023] system 00:08: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    0.414026] system 00:08: [mem 0xfdac0000-0xfdacffff] has been reserved
[    0.414810] system 00:09: [mem 0xfed10000-0xfed17fff] could not be 
reserved
[    0.414815] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.414818] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.414821] system 00:09: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.414824] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.414826] system 00:09: [mem 0xfed90000-0xfed93fff] could not be 
reserved
[    0.414828] system 00:09: [mem 0xfed45000-0xfed8ffff] could not be 
reserved
[    0.414831] system 00:09: [mem 0xff000000-0xffffffff] could not be 
reserved
[    0.414833] system 00:09: [mem 0xfee00000-0xfeefffff] could not be 
reserved
[    0.414836] system 00:09: [mem 0xeffe0000-0xefffffff] has been reserved
[    0.415192] pnp 00:0a: disabling [mem 0x000c0000-0x000c3fff] because 
it overlaps 0000:00:02.0 BAR 6 [mem 0x000c0000-0x000dffff]
[    0.415197] pnp 00:0a: disabling [mem 0x000c8000-0x000cbfff] because 
it overlaps 0000:00:02.0 BAR 6 [mem 0x000c0000-0x000dffff]
[    0.415200] pnp 00:0a: disabling [mem 0x000d0000-0x000d3fff] because 
it overlaps 0000:00:02.0 BAR 6 [mem 0x000c0000-0x000dffff]
[    0.415203] pnp 00:0a: disabling [mem 0x000d8000-0x000dbfff] because 
it overlaps 0000:00:02.0 BAR 6 [mem 0x000c0000-0x000dffff]
[    0.415234] system 00:0a: [mem 0x00000000-0x0009ffff] could not be 
reserved
[    0.415237] system 00:0a: [mem 0x000e0000-0x000e3fff] could not be 
reserved
[    0.415239] system 00:0a: [mem 0x000e8000-0x000ebfff] could not be 
reserved
[    0.415241] system 00:0a: [mem 0x000f0000-0x000fffff] could not be 
reserved
[    0.415244] system 00:0a: [mem 0x00100000-0x5c7fffff] could not be 
reserved
[    0.415246] system 00:0a: [mem 0xfec00000-0xfed3ffff] could not be 
reserved
[    0.415249] system 00:0a: [mem 0xfed4c000-0xffffffff] could not be 
reserved
[    0.415445] pnp: PnP ACPI: found 11 devices
[    0.422383] clocksource: acpi_pm: mask: 0xffffff max_cycles: 
0xffffff, max_idle_ns: 2085701024 ns
[    0.422501] NET: Registered PF_INET protocol family
[    0.422723] IP idents hash table entries: 262144 (order: 9, 2097152 
bytes, linear)
[    0.425798] tcp_listen_portaddr_hash hash table entries: 8192 (order: 
5, 131072 bytes, linear)
[    0.425832] Table-perturb hash table entries: 65536 (order: 6, 262144 
bytes, linear)
[    0.425854] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes, linear)
[    0.426038] TCP bind hash table entries: 65536 (order: 8, 1048576 
bytes, linear)
[    0.426196] TCP: Hash tables configured (established 131072 bind 65536)
[    0.426301] MPTCP token hash table entries: 16384 (order: 6, 393216 
bytes, linear)
[    0.426382] UDP hash table entries: 8192 (order: 6, 262144 bytes, linear)
[    0.426426] UDP-Lite hash table entries: 8192 (order: 6, 262144 
bytes, linear)
[    0.426510] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.426520] NET: Registered PF_XDP protocol family
[    0.426530] pci 0000:00:1d.0: bridge window [io  0x1000-0x0fff] to 
[bus 06-70] add_size 1000
[    0.426546] pci 0000:00:1d.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.426552] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.426558] pci 0000:00:1c.0:   bridge window [mem 0xec200000-0xec2fffff]
[    0.426567] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.426572] pci 0000:00:1c.2:   bridge window [mem 0xec100000-0xec1fffff]
[    0.426579] pci 0000:00:1c.4: PCI bridge to [bus 05]
[    0.426591] pci 0000:00:1c.4:   bridge window [mem 0xec000000-0xec0fffff]
[    0.426600] pci 0000:00:1d.0: PCI bridge to [bus 06-70]
[    0.426604] pci 0000:00:1d.0:   bridge window [io  0x2000-0x2fff]
[    0.426609] pci 0000:00:1d.0:   bridge window [mem 0xbc000000-0xea0fffff]
[    0.426613] pci 0000:00:1d.0:   bridge window [mem 
0x70000000-0xb9ffffff 64bit pref]
[    0.426620] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.426623] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.426625] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff 
window]
[    0.426628] pci_bus 0000:00: resource 7 [mem 0x5c800000-0xefffffff 
window]
[    0.426630] pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff 
window]
[    0.426632] pci_bus 0000:02: resource 1 [mem 0xec200000-0xec2fffff]
[    0.426635] pci_bus 0000:04: resource 1 [mem 0xec100000-0xec1fffff]
[    0.426637] pci_bus 0000:05: resource 1 [mem 0xec000000-0xec0fffff]
[    0.426639] pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
[    0.426641] pci_bus 0000:06: resource 1 [mem 0xbc000000-0xea0fffff]
[    0.426643] pci_bus 0000:06: resource 2 [mem 0x70000000-0xb9ffffff 
64bit pref]
[    0.427746] PCI: CLS 0 bytes, default 64
[    0.427773] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.427775] software IO TLB: mapped [mem 
0x000000003c164000-0x0000000040164000] (64MB)
[    0.427827] Trying to unpack rootfs image as initramfs...
[    0.427900] sgx: EPC section 0x50200000-0x55f7ffff
[    0.430614] Initialise system trusted keyrings
[    0.430634] Key type blacklist registered
[    0.430800] workingset: timestamp_bits=36 max_order=22 bucket_order=0
[    0.442370] zbud: loaded
[    0.446362] integrity: Platform Keyring initialized
[    0.446367] integrity: Machine keyring initialized
[    0.477272] NET: Registered PF_ALG protocol family
[    0.477284] xor: automatically using best checksumming function   avx
[    0.477292] Key type asymmetric registered
[    0.477298] Asymmetric key parser 'x509' registered
[    1.230495] Freeing initrd memory: 38324K
[    1.236786] alg: self-tests for CTR-KDF (hmac(sha256)) passed
[    1.236814] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 244)
[    1.236864] io scheduler mq-deadline registered
[    1.236867] io scheduler kyber registered
[    1.236922] io scheduler bfq registered
[    1.239254] atomic64_test: passed for x86-64 platform with CX8 and 
with SSE
[    1.240937] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.241784] ACPI: AC: AC Adapter [AC] (off-line)
[    1.241900] input: Sleep Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    1.241944] ACPI: button: Sleep Button [SLPB]
[    1.241986] input: Lid Switch as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    1.242015] ACPI: button: Lid Switch [LID]
[    1.242052] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.242080] ACPI: button: Power Button [PWRF]
[    1.242278] smpboot: Estimated ratio of average max frequency by base 
frequency (times 1024): 1377
[    1.245575] thermal LNXTHERM:00: registered as thermal_zone0
[    1.245579] ACPI: thermal: Thermal Zone [THM0] (51 C)
[    1.246391] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.264339] ACPI: battery: Slot [BAT0] (battery present)
[    1.265434] 0000:00:16.3: ttyS4 at I/O 0xe060 (irq = 19, base_baud = 
115200) is a 16550A
[    1.265729] hpet_acpi_add: no address or irqs in _CRS
[    1.265839] Non-volatile memory driver v1.3
[    1.265845] Linux agpgart interface v0.103
[    1.267530] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x0, rev-id 78)
[    1.288109] ACPI: bus type drm_connector registered
[    1.289441] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.289447] ehci-pci: EHCI PCI platform driver
[    1.289460] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.289463] ohci-pci: OHCI PCI platform driver
[    1.289472] uhci_hcd: USB Universal Host Controller Interface driver
[    1.289679] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.289780] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
bus number 1
[    1.290865] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 
0x100 quirks 0x0000000081109810
[    1.291317] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.291424] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
bus number 2
[    1.291428] xhci_hcd 0000:00:14.0: Host supports USB 3.0 SuperSpeed
[    1.291472] usb usb1: New USB device found, idVendor=1d6b, 
idProduct=0002, bcdDevice= 5.18
[    1.291476] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.291478] usb usb1: Product: xHCI Host Controller
[    1.291480] usb usb1: Manufacturer: Linux 5.18.5-200.fc36.x86_64 xhci-hcd
[    1.291482] usb usb1: SerialNumber: 0000:00:14.0
[    1.291657] hub 1-0:1.0: USB hub found
[    1.291675] hub 1-0:1.0: 12 ports detected
[    1.292957] usb usb2: New USB device found, idVendor=1d6b, 
idProduct=0003, bcdDevice= 5.18
[    1.292961] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.292963] usb usb2: Product: xHCI Host Controller
[    1.292965] usb usb2: Manufacturer: Linux 5.18.5-200.fc36.x86_64 xhci-hcd
[    1.292967] usb usb2: SerialNumber: 0000:00:14.0
[    1.293125] hub 2-0:1.0: USB hub found
[    1.293137] hub 2-0:1.0: 6 ports detected
[    1.293387] usb: port power management may be unreliable
[    1.293924] usbcore: registered new interface driver usbserial_generic
[    1.293930] usbserial: USB Serial support registered for generic
[    1.293965] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 
0x60,0x64 irq 1,12
[    1.295864] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.295871] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.296022] mousedev: PS/2 mouse device common for all mice
[    1.296322] rtc_cmos 00:03: RTC can wake from S4
[    1.297260] rtc_cmos 00:03: registered as rtc0
[    1.297427] rtc_cmos 00:03: setting system clock to 
2022-06-26T21:00:37 UTC (1656277237)
[    1.297450] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram
[    1.297558] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is 
disabled. Duplicate IMA measurements will not be recorded in the IMA log.
[    1.297583] device-mapper: uevent: version 1.0.3
[    1.297680] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input3
[    1.297682] device-mapper: ioctl: 4.46.0-ioctl (2022-02-22) 
initialised: dm-devel@redhat.com
[    1.297848] intel_pstate: Intel P-state driver initializing
[    1.298106] intel_pstate: HWP enabled
[    1.298380] hid: raw HID events driver (C) Jiri Kosina
[    1.298415] usbcore: registered new interface driver usbhid
[    1.298417] usbhid: USB HID core driver
[    1.298505] intel_pmc_core intel_pmc_core.0:  initialized
[    1.298630] drop_monitor: Initializing network drop monitor service
[    1.322067] Initializing XFRM netlink socket
[    1.322198] NET: Registered PF_INET6 protocol family
[    1.327536] Segment Routing with IPv6
[    1.327539] RPL Segment Routing with IPv6
[    1.327550] In-situ OAM (IOAM) with IPv6
[    1.327576] mip6: Mobile IPv6
[    1.327578] NET: Registered PF_PACKET protocol family
[    1.328244] microcode: sig=0x806e9, pf=0x80, revision=0xf0
[    1.328266] microcode: Microcode Update Driver: v2.2.
[    1.328272] IPI shorthand broadcast: enabled
[    1.328279] AVX2 version of gcm_enc/dec engaged.
[    1.328361] AES CTR mode by8 optimization enabled
[    1.328651] sched_clock: Marking stable (1318363772, 
10277329)->(1340653433, -12012332)
[    1.328837] registered taskstats version 1
[    1.328916] Loading compiled-in X.509 certificates
[    1.352417] Loaded X.509 cert 'Fedora kernel signing key: 
a53fbadddadbb1164ecb4738c5e4c2a4f07abbf2'
[    1.352600] zswap: loaded using pool lzo/zbud
[    1.352760] page_owner is disabled
[    1.352795] Key type ._fscrypt registered
[    1.352796] Key type .fscrypt registered
[    1.352797] Key type fscrypt-provisioning registered
[    1.353004] Btrfs loaded, crc32c=crc32c-generic, zoned=yes, fsverity=yes
[    1.353015] Key type big_key registered
[    1.353138] Key type trusted registered
[    1.355758] Key type encrypted registered
[    1.355769] Loading compiled-in module X.509 certificates
[    1.356144] Loaded X.509 cert 'Fedora kernel signing key: 
a53fbadddadbb1164ecb4738c5e4c2a4f07abbf2'
[    1.356146] ima: Allocated hash algorithm: sha256
[    1.387117] ima: No architecture policies found
[    1.387131] evm: Initialising EVM extended attributes:
[    1.387132] evm: security.selinux
[    1.387133] evm: security.SMACK64 (disabled)
[    1.387133] evm: security.SMACK64EXEC (disabled)
[    1.387134] evm: security.SMACK64TRANSMUTE (disabled)
[    1.387134] evm: security.SMACK64MMAP (disabled)
[    1.387135] evm: security.apparmor (disabled)
[    1.387135] evm: security.ima
[    1.387135] evm: security.capability
[    1.387136] evm: HMAC attrs: 0x1
[    1.407341] alg: No test for 842 (842-scomp)
[    1.407360] alg: No test for 842 (842-generic)
[    1.462364] tsc: Refined TSC clocksource calibration: 2903.996 MHz
[    1.462370] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 
0x29dc020bb13, max_idle_ns: 440795273180 ns
[    1.462404] clocksource: Switched to clocksource tsc
[    1.487976] PM:   Magic number: 10:145:46
[    1.487997] event_source uprobe: hash matches
[    1.488099] RAS: Correctable Errors collector initialized.
[    1.528545] usb 1-7: new full-speed USB device number 2 using xhci_hcd
[    1.656226] usb 1-7: New USB device found, idVendor=8087, 
idProduct=0a2b, bcdDevice= 0.10
[    1.656233] usb 1-7: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    1.771445] usb 1-8: new high-speed USB device number 3 using xhci_hcd
[    1.908340] usb 1-8: New USB device found, idVendor=13d3, 
idProduct=5682, bcdDevice=16.07
[    1.908348] usb 1-8: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    1.908351] usb 1-8: Product: Integrated Camera
[    1.908353] usb 1-8: Manufacturer: SunplusIT Inc
[    2.024374] usb 1-9: new full-speed USB device number 4 using xhci_hcd
[    2.090563] psmouse serio1: synaptics: queried max coordinates: x 
[..5676], y [..4760]
[    2.122484] psmouse serio1: synaptics: queried min coordinates: x 
[1266..], y [1094..]
[    2.122495] psmouse serio1: synaptics: Trying to set up SMBus access
[    2.125372] psmouse serio1: synaptics: SMbus companion is not ready yet
[    2.152523] usb 1-9: New USB device found, idVendor=138a, 
idProduct=0097, bcdDevice= 1.64
[    2.152531] usb 1-9: New USB device strings: Mfr=0, Product=0, 
SerialNumber=1
[    2.152534] usb 1-9: SerialNumber: e9a58c89143b
[    2.186955] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.2, 
id: 0x1e2b1, caps: 0xf002a3/0x940300/0x12e800/0x400000, board id: 3289, 
fw id: 2492434
[    2.186978] psmouse serio1: synaptics: serio: Synaptics pass-through 
port at isa0060/serio1/input0
[    2.226802] input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio1/input/input5
[    2.684125] psmouse serio2: trackpoint: Elan TrackPoint firmware: 
0x04, buttons: 3/3
[    2.885215] input: TPPS/2 Elan TrackPoint as 
/devices/platform/i8042/serio1/serio2/input/input6
[    2.961640] Freeing unused decrypted memory: 2036K
[    2.962085] Freeing unused kernel image (initmem) memory: 2716K
[    2.962142] Write protecting the kernel read-only data: 30720k
[    2.962896] Freeing unused kernel image (text/rodata gap) memory: 2036K
[    2.963247] Freeing unused kernel image (rodata/data gap) memory: 1020K
[    3.004439] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    3.004443] rodata_test: all tests were successful
[    3.004444] x86/mm: Checking user space page tables
[    3.043147] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    3.043165] Run /init as init process
[    3.043166]   with arguments:
[    3.043167]     /init
[    3.043168]     rhgb
[    3.043168]   with environment:
[    3.043169]     HOME=/
[    3.043169]     TERM=linux
[    3.043170]     BOOT_IMAGE=(hd0,msdos1)/vmlinuz-5.18.5-200.fc36.x86_64
[    3.048813] systemd[1]: systemd v250.7-1.fc36 running in system mode 
(+PAM +AUDIT +SELINUX -APPARMOR +IMA +SMACK +SECCOMP +GCRYPT +GNUTLS 
+OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN -IPTC +KMOD 
+LIBCRYPTSETUP +LIBFDISK +PCRE2 +PWQUALITY +P11KIT +QRENCODE +BZIP2 +LZ4 
+XZ +ZLIB +ZSTD +BPF_FRAMEWORK +XKBCOMMON +UTMP +SYSVINIT 
default-hierarchy=unified)
[    3.060557] systemd[1]: Detected architecture x86-64.
[    3.060562] systemd[1]: Running in initial RAM disk.
[    3.070616] systemd[1]: Hostname set to <localhost.localdomain>.
[    3.466619] systemd[1]: LSM BPF program attached
[    3.511387] systemd[1]: Queued start job for default target 
initrd.target.
[    3.515946] systemd[1]: Created slice 
system-systemd\x2dhibernate\x2dresume.slice - Slice 
/system/systemd-hibernate-resume.
[    3.516003] systemd[1]: Reached target initrd-usr-fs.target - Initrd 
/usr File System.
[    3.516021] systemd[1]: Reached target slices.target - Slice Units.
[    3.516030] systemd[1]: Reached target swap.target - Swaps.
[    3.516039] systemd[1]: Reached target timers.target - Timer Units.
[    3.516107] systemd[1]: Listening on dbus.socket - D-Bus System 
Message Bus Socket.
[    3.516214] systemd[1]: Listening on systemd-journald-audit.socket - 
Journal Audit Socket.
[    3.516284] systemd[1]: Listening on systemd-journald-dev-log.socket 
- Journal Socket (/dev/log).
[    3.516367] systemd[1]: Listening on systemd-journald.socket - 
Journal Socket.
[    3.516447] systemd[1]: Listening on systemd-udevd-control.socket - 
udev Control Socket.
[    3.516501] systemd[1]: Listening on systemd-udevd-kernel.socket - 
udev Kernel Socket.
[    3.516510] systemd[1]: Reached target sockets.target - Socket Units.
[    3.517115] systemd[1]: Starting kmod-static-nodes.service - Create 
List of Static Device Nodes...
[    3.517171] systemd[1]: memstrack.service - Memstrack Anylazing 
Service was skipped because all trigger condition checks failed.
[    3.517784] systemd[1]: Started rngd.service - Hardware RNG Entropy 
Gatherer Daemon.
[    3.519475] systemd[1]: Starting systemd-journald.service - Journal 
Service...
[    3.520569] systemd[1]: Starting systemd-modules-load.service - Load 
Kernel Modules...
[    3.521481] systemd[1]: Starting systemd-sysusers.service - Create 
System Users...
[    3.522377] systemd[1]: Starting systemd-vconsole-setup.service - 
Setup Virtual Console...
[    3.532957] systemd[1]: Finished kmod-static-nodes.service - Create 
List of Static Device Nodes.
[    3.533105] audit: type=1130 audit(1656277239.733:2): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='unit=kmod-static-nodes 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    3.550624] systemd[1]: Finished systemd-sysusers.service - Create 
System Users.
[    3.550679] audit: type=1130 audit(1656277239.751:3): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysusers 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    3.551775] systemd[1]: Starting systemd-tmpfiles-setup-dev.service - 
Create Static Device Nodes in /dev...
[    3.564642] systemd[1]: Finished systemd-tmpfiles-setup-dev.service - 
Create Static Device Nodes in /dev.
[    3.564706] audit: type=1130 audit(1656277239.765:4): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel 
msg='unit=systemd-tmpfiles-setup-dev comm="systemd" 
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    3.570971] systemd[1]: Started systemd-journald.service - Journal 
Service.
[    3.571034] audit: type=1130 audit(1656277239.771:5): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-journald 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    3.581151] fuse: init (API version 7.36)
[    3.587519] IPMI message handler: version 39.2
[    3.589694] audit: type=1130 audit(1656277239.790:6): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel 
msg='unit=systemd-tmpfiles-setup comm="systemd" 
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    3.589985] ipmi device interface
[    3.598669] audit: type=1130 audit(1656277239.799:7): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel 
msg='unit=systemd-modules-load comm="systemd" 
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    3.611663] audit: type=1130 audit(1656277239.812:8): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    3.638659] audit: type=1130 audit(1656277239.839:9): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel 
msg='unit=systemd-vconsole-setup comm="systemd" 
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    3.738875] audit: type=1130 audit(1656277239.938:10): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-cmdline 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    4.118263] acpi PNP0C14:02: duplicate WMI GUID 
05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
[    4.118634] acpi PNP0C14:03: duplicate WMI GUID 
05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
[    4.124770] acpi PNP0C14:04: duplicate WMI GUID 
05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
[    4.312527] e1000e: Intel(R) PRO/1000 Network Driver
[    4.312531] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    4.312739] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) 
set to dynamic conservative mode
[    4.342000] nvme nvme0: pci function 0000:05:00.0
[    4.537796] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): 
registered PHC clock
[    4.616912] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 
54:e1:ad:d6:06:35
[    4.616918] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network 
Connection
[    4.616973] e1000e 0000:00:1f.6 eth0: MAC: 12, PHY: 12, PBA No: 
1000FF-0FF
[    4.914865] i915 0000:00:02.0: vgaarb: deactivate vga console
[    4.923403] Console: switching to colour dummy device 80x25
[    4.938788] i915 0000:00:02.0: vgaarb: changed VGA decodes: 
olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.939897] i915 0000:00:02.0: [drm] Finished loading DMC firmware 
i915/kbl_dmc_ver1_04.bin (v1.4)
[    4.995904] [drm] Initialized i915 1.6.0 20201103 for 0000:00:02.0 on 
minor 0
[    4.998178] ACPI: video: Video Device [GFX0] (multi-head: yes  rom: 
no  post: no)
[    4.999646] input: Video Bus as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input7
[    5.006902] fbcon: i915drmfb (fb0) is primary device
[    5.007038] i915 0000:00:02.0: [drm] Reducing the compressed 
framebuffer size. This may lead to less power savings than a 
non-reduced-size. Try to increase stolen memory size if available in BIOS.
[    5.011114] Console: switching to colour frame buffer device 320x90
[    5.032243] i915 0000:00:02.0: [drm] fb0: i915drmfb frame buffer device
[    6.654216] nvme nvme0: Shutdown timeout set to 8 seconds
[    6.662754] nvme nvme0: 4/0/0 default/read/poll queues
[    6.669345]  nvme0n1: p1 p2
[    6.670825] e1000e 0000:00:1f.6 enp0s31f6: renamed from eth0
[    6.990965] kauditd_printk_skb: 6 callbacks suppressed
[    6.990968] audit: type=1130 audit(1656277243.191:17): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='unit=dbus-broker 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    7.112480] PM: Image not found (code -22)
[    7.123352] audit: type=1130 audit(1656277243.322:18): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel 
msg='unit=systemd-hibernate-resume@dev-mapper-fedora_dhcp\x2d\x2d17\x2d\x2d161\x2dswap 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    7.123368] audit: type=1131 audit(1656277243.322:19): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel 
msg='unit=systemd-hibernate-resume@dev-mapper-fedora_dhcp\x2d\x2d17\x2d\x2d161\x2dswap 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    7.152677] audit: type=1130 audit(1656277243.350:20): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-initqueue 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    7.178958] audit: type=1130 audit(1656277243.377:21): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-fsck-root 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[    7.198395] EXT4-fs (dm-0): mounted filesystem with ordered data 
mode. Quota mode: none.
[    7.418016] audit: type=1334 audit(1656277243.618:22): prog-id=24 op=LOAD
[    7.418164] audit: type=1334 audit(1656277243.618:23): prog-id=25 op=LOAD
[    7.418234] audit: type=1334 audit(1656277243.618:24): prog-id=0 
op=UNLOAD
[    7.418288] audit: type=1334 audit(1656277243.618:25): prog-id=0 
op=UNLOAD
[    7.419268] audit: type=1334 audit(1656277243.619:26): prog-id=26 op=LOAD
[    7.769534] systemd-journald[239]: Received SIGTERM from PID 1 (systemd).
[    7.892807] SELinux:  policy capability network_peer_controls=1
[    7.892813] SELinux:  policy capability open_perms=1
[    7.892814] SELinux:  policy capability extended_socket_class=1
[    7.892816] SELinux:  policy capability always_check_network=0
[    7.892817] SELinux:  policy capability cgroup_seclabel=1
[    7.892818] SELinux:  policy capability nnp_nosuid_transition=1
[    7.892819] SELinux:  policy capability genfs_seclabel_symlinks=1
[    7.892820] SELinux:  policy capability ioctl_skip_cloexec=0
[    7.944484] systemd[1]: Successfully loaded SELinux policy in 100.857ms.
[    7.983429] systemd[1]: Relabelled /dev, /dev/shm, /run, 
/sys/fs/cgroup in 30.152ms.
[    7.986204] systemd[1]: systemd v250.7-1.fc36 running in system mode 
(+PAM +AUDIT +SELINUX -APPARMOR +IMA +SMACK +SECCOMP +GCRYPT +GNUTLS 
+OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN -IPTC +KMOD 
+LIBCRYPTSETUP +LIBFDISK +PCRE2 +PWQUALITY +P11KIT +QRENCODE +BZIP2 +LZ4 
+XZ +ZLIB +ZSTD +BPF_FRAMEWORK +XKBCOMMON +UTMP +SYSVINIT 
default-hierarchy=unified)
[    7.997627] systemd[1]: Detected architecture x86-64.
[    8.354632] systemd[1]: LSM BPF program attached
[    8.491755] systemd-sysv-generator[623]: SysV service 
'/etc/rc.d/init.d/livesys-late' lacks a native systemd unit file. 
Automatically generating a unit file for compatibility. Please update 
package to include a native systemd unit file, in order to make it more 
safe and robust.
[    8.491901] systemd-sysv-generator[623]: SysV service 
'/etc/rc.d/init.d/livesys' lacks a native systemd unit file. 
Automatically generating a unit file for compatibility. Please update 
package to include a native systemd unit file, in order to make it more 
safe and robust.
[    8.492042] systemd-sysv-generator[623]: SysV service 
'/etc/rc.d/init.d/network' lacks a native systemd unit file. 
Automatically generating a unit file for compatibility. Please update 
package to include a native systemd unit file, in order to make it more 
safe and robust.
[    8.514405] zram: Added device: zram0
[    8.559941] systemd[1]: /etc/systemd/system/rc-local.service:17: 
Support for option SysVStartPriority= has been removed and it is ignored
[    8.559972] systemd[1]: /etc/systemd/system/rc-local.service:37: 
Support for option SysVStartPriority= has been removed and it is ignored
[    8.560052] systemd[1]: rc-local.service: Service has more than one 
ExecStart= setting, which is only allowed for Type=oneshot services. 
Refusing.
[    8.652469] systemd[1]: initrd-switch-root.service: Deactivated 
successfully.
[    8.660861] systemd[1]: Stopped initrd-switch-root.service - Switch Root.
[    8.661425] systemd[1]: systemd-journald.service: Scheduled restart 
job, restart counter is at 1.
[    8.661754] systemd[1]: Created slice machine.slice - Virtual Machine 
and Container Slice.
[    8.662133] systemd[1]: Created slice system-getty.slice - Slice 
/system/getty.
[    8.662434] systemd[1]: Created slice system-modprobe.slice - Slice 
/system/modprobe.
[    8.662723] systemd[1]: Created slice system-systemd\x2dfsck.slice - 
Slice /system/systemd-fsck.
[    8.663011] systemd[1]: Created slice 
system-systemd\x2dzram\x2dsetup.slice - Slice /system/systemd-zram-setup.
[    8.663231] systemd[1]: Created slice user.slice - User and Session 
Slice.
[    8.663258] systemd[1]: systemd-ask-password-console.path - Dispatch 
Password Requests to Console Directory Watch was skipped because of a 
failed condition check (ConditionPathExists=!/run/plymouth/pid).
[    8.663386] systemd[1]: Started systemd-ask-password-wall.path - 
Forward Password Requests to Wall Directory Watch.
[    8.663907] systemd[1]: Set up automount 
proc-sys-fs-binfmt_misc.automount - Arbitrary Executable File Formats 
File System Automount Point.
[    8.663970] systemd[1]: Reached target cryptsetup.target - Local 
Encrypted Volumes.
[    8.664004] systemd[1]: Reached target getty.target - Login Prompts.
[    8.664042] systemd[1]: Stopped target initrd-switch-root.target - 
Switch Root.
[    8.664079] systemd[1]: Stopped target initrd-fs.target - Initrd File 
Systems.
[    8.664105] systemd[1]: Stopped target initrd-root-fs.target - Initrd 
Root File System.
[    8.664140] systemd[1]: Reached target integritysetup.target - Local 
Integrity Protected Volumes.
[    8.664206] systemd[1]: Reached target nss-user-lookup.target - User 
and Group Name Lookups.
[    8.664256] systemd[1]: Reached target slices.target - Slice Units.
[    8.664309] systemd[1]: Reached target veritysetup.target - Local 
Verity Protected Volumes.
[    8.664728] systemd[1]: Listening on dm-event.socket - Device-mapper 
event daemon FIFOs.
[    8.665465] systemd[1]: Listening on lvm2-lvmpolld.socket - LVM2 poll 
daemon socket.
[    8.666472] systemd[1]: Listening on systemd-coredump.socket - 
Process Core Dump Socket.
[    8.666585] systemd[1]: Listening on systemd-initctl.socket - initctl 
Compatibility Named Pipe.
[    8.666958] systemd[1]: Listening on systemd-oomd.socket - Userspace 
Out-Of-Memory (OOM) Killer Socket.
[    8.667471] systemd[1]: Listening on systemd-udevd-control.socket - 
udev Control Socket.
[    8.667704] systemd[1]: Listening on systemd-udevd-kernel.socket - 
udev Kernel Socket.
[    8.668596] systemd[1]: Activating swap 
dev-mapper-fedora_dhcp\x2d\x2d17\x2d\x2d161\x2dswap.swap - 
/dev/mapper/fedora_dhcp--17--161-swap...
[    8.669634] systemd[1]: Mounting dev-hugepages.mount - Huge Pages 
File System...
[    8.670847] systemd[1]: Mounting dev-mqueue.mount - POSIX Message 
Queue File System...
[    8.672242] systemd[1]: Mounting sys-kernel-debug.mount - Kernel 
Debug File System...
[    8.673609] Adding 8032252k swap on 
/dev/mapper/fedora_dhcp--17--161-swap.  Priority:-2 extents:1 
across:8032252k SSFS
[    8.673805] systemd[1]: Mounting sys-kernel-tracing.mount - Kernel 
Trace File System...
[    8.674049] systemd[1]: auth-rpcgss-module.service - Kernel Module 
supporting RPCSEC_GSS was skipped because of a failed condition check 
(ConditionPathExists=/etc/krb5.keytab).
[    8.675678] systemd[1]: Starting kmod-static-nodes.service - Create 
List of Static Device Nodes...
[    8.676932] systemd[1]: Starting lvm2-monitor.service - Monitoring of 
LVM2 mirrors, snapshots etc. using dmeventd or progress polling...
[    8.678314] systemd[1]: Starting modprobe@configfs.service - Load 
Kernel Module configfs...
[    8.679707] systemd[1]: Starting modprobe@drm.service - Load Kernel 
Module drm...
[    8.681114] systemd[1]: Starting modprobe@fuse.service - Load Kernel 
Module fuse...
[    8.682684] systemd[1]: Starting nfs-convert.service - Preprocess NFS 
configuration convertion...
[    8.682806] systemd[1]: plymouth-switch-root.service: Deactivated 
successfully.
[    8.689498] systemd[1]: Stopped plymouth-switch-root.service - 
Plymouth switch root service.
[    8.689698] systemd[1]: Stopped systemd-journald.service - Journal 
Service.
[    8.691111] systemd[1]: Starting systemd-journald.service - Journal 
Service...
[    8.692522] systemd[1]: Starting systemd-modules-load.service - Load 
Kernel Modules...
[    8.693626] systemd[1]: Starting systemd-remount-fs.service - Remount 
Root and Kernel File Systems...
[    8.693775] systemd[1]: systemd-repart.service - Repartition Root 
Disk was skipped because all trigger condition checks failed.
[    8.695197] systemd[1]: Starting systemd-udev-trigger.service - 
Coldplug All udev Devices...
[    8.700818] systemd[1]: Activated swap 
dev-mapper-fedora_dhcp\x2d\x2d17\x2d\x2d161\x2dswap.swap - 
/dev/mapper/fedora_dhcp--17--161-swap.
[    8.702605] systemd[1]: Mounted dev-hugepages.mount - Huge Pages File 
System.
[    8.702767] systemd[1]: Mounted dev-mqueue.mount - POSIX Message 
Queue File System.
[    8.702898] systemd[1]: Mounted sys-kernel-debug.mount - Kernel Debug 
File System.
[    8.703031] systemd[1]: Mounted sys-kernel-tracing.mount - Kernel 
Trace File System.
[    8.703555] EXT4-fs (dm-0): re-mounted. Quota mode: none.
[    8.711684] systemd[1]: Finished kmod-static-nodes.service - Create 
List of Static Device Nodes.
[    8.712682] systemd[1]: Started systemd-journald.service - Journal 
Service.
[    8.781954] systemd-journald[644]: Received client request to flush 
runtime journal.
[    8.998670] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[    8.998718] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[    9.002445] i2c i2c-6: 2/2 memory slots populated (from DMI)
[    9.053197] mei_me 0000:00:16.0: enabling device (0004 -> 0006)
[    9.133417] thinkpad_acpi: ThinkPad ACPI Extras v0.26
[    9.133421] thinkpad_acpi: http://ibm-acpi.sf.net/
[    9.133422] thinkpad_acpi: ThinkPad BIOS N1MET42W (1.27 ), EC N1MHT29W
[    9.133423] thinkpad_acpi: Lenovo ThinkPad X1 Carbon 5th, model 
20HR006SUS
[    9.134721] thinkpad_acpi: radio switch found; radios are enabled
[    9.134728] thinkpad_acpi: This ThinkPad has standard ACPI backlight 
brightness control, supported by the ACPI video driver
[    9.134730] thinkpad_acpi: Disabling thinkpad-acpi brightness events 
by default...
[    9.139190] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio 
is unblocked
[    9.167035] thinkpad_acpi: secondary fan control detected & enabled
[    9.177680] thinkpad_acpi: battery 1 registered (start 0, stop 100, 
behaviours: 0x7)
[    9.177691] ACPI: battery: new extension: ThinkPad Battery Extension
[    9.186123] input: ThinkPad Extra Buttons as 
/devices/platform/thinkpad_acpi/input/input10
[    9.219880] mc: Linux media interface: v0.10
[    9.307768] input: PC Speaker as /devices/platform/pcspkr/input/input11
[    9.310422] videodev: Linux video capture interface: v2.00
[    9.311203] cfg80211: Loading compiled-in X.509 certificates for 
regulatory database
[    9.311846] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    9.339748] Bluetooth: Core ver 2.22
[    9.339776] NET: Registered PF_BLUETOOTH protocol family
[    9.339777] Bluetooth: HCI device and connection manager initialized
[    9.339781] Bluetooth: HCI socket layer initialized
[    9.339783] Bluetooth: L2CAP socket layer initialized
[    9.339788] Bluetooth: SCO socket layer initialized
[    9.356065] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops 
i915_audio_component_bind_ops [i915])
[    9.364986] resource sanity check: requesting [mem 
0xfed10000-0xfed15fff], which spans more than pnp 00:07 [mem 
0xfed10000-0xfed13fff]
[    9.364992] caller snb_uncore_imc_init_box+0x6a/0xa0 [intel_uncore] 
mapping multiple BARs
[    9.419133] snd_hda_codec_conexant hdaudioC0D0: CX8200: BIOS 
auto-probing.
[    9.420991] snd_hda_codec_conexant hdaudioC0D0: vmaster hook already 
present before cdev!
[    9.421142] snd_hda_codec_conexant hdaudioC0D0: autoconfig for 
CX8200: line_outs=1 (0x17/0x0/0x0/0x0/0x0) type:speaker
[    9.421146] snd_hda_codec_conexant hdaudioC0D0:    speaker_outs=0 
(0x0/0x0/0x0/0x0/0x0)
[    9.421149] snd_hda_codec_conexant hdaudioC0D0:    hp_outs=1 
(0x16/0x0/0x0/0x0/0x0)
[    9.421151] snd_hda_codec_conexant hdaudioC0D0:    mono: mono_out=0x0
[    9.421153] snd_hda_codec_conexant hdaudioC0D0:    inputs:
[    9.421154] snd_hda_codec_conexant hdaudioC0D0:      Internal Mic=0x1a
[    9.421156] snd_hda_codec_conexant hdaudioC0D0:      Mic=0x19
[    9.429711] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 
655360 ms ovfl timer
[    9.429714] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    9.429715] RAPL PMU: hw unit of domain package 2^-14 Joules
[    9.429716] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    9.429717] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    9.429718] RAPL PMU: hw unit of domain psys 2^-14 Joules
[    9.434011] Intel(R) Wireless WiFi driver for Linux
[    9.441119] usb 1-8: Found UVC 1.00 device Integrated Camera (13d3:5682)
[    9.462992] usbcore: registered new interface driver btusb
[    9.471056] Bluetooth: hci0: Firmware revision 0.1 build 19 week 44 2021
[    9.511506] input: HDA Intel PCH Mic as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input12
[    9.511566] input: HDA Intel PCH Headphone as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input13
[    9.511616] input: HDA Intel PCH HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input14
[    9.511664] input: HDA Intel PCH HDMI/DP,pcm=7 as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input15
[    9.511718] input: HDA Intel PCH HDMI/DP,pcm=8 as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input16
[    9.511767] input: HDA Intel PCH HDMI/DP,pcm=9 as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input17
[    9.511817] input: HDA Intel PCH HDMI/DP,pcm=10 as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input18
[    9.520373] iwlwifi 0000:04:00.0: loaded firmware version 
36.ca7b901d.0 8265-36.ucode op_mode iwlmvm
[    9.581433] zram0: detected capacity change from 0 to 16777216
[    9.672774] Adding 8388604k swap on /dev/zram0.  Priority:100 
extents:1 across:8388604k SSDscFS
[    9.720672] input: Integrated Camera: Integrated C as 
/devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/input/input19
[    9.721758] usbcore: registered new interface driver uvcvideo
[    9.747099] intel_tcc_cooling: Programmable TCC Offset detected
[    9.748859] iTCO_vendor_support: vendor-support=0
[    9.792684] iTCO_wdt iTCO_wdt: Found a Intel PCH TCO device 
(Version=4, TCOBASE=0x0400)
[    9.792887] iTCO_wdt iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    9.795939] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band 
Wireless AC 8265, REV=0x230
[    9.796015] thermal thermal_zone3: failed to read out thermal zone (-61)
[    9.812215] mei_hdcp 
0000:00:16.0-b638ab7e-94e2-4ea2-a552-d1c54b627f04: bound 0000:00:02.0 
(ops i915_hdcp_component_ops [i915])
[    9.857188] iwlwifi 0000:04:00.0: base HW address: f8:94:c2:2d:2b:d9, 
OTP minor version: 0x0
[    9.883450] psmouse serio1: synaptics: queried max coordinates: x 
[..5676], y [..4760]
[    9.896632] intel_rapl_common: Found RAPL domain package
[    9.896636] intel_rapl_common: Found RAPL domain core
[    9.896638] intel_rapl_common: Found RAPL domain uncore
[    9.896639] intel_rapl_common: Found RAPL domain dram
[    9.896640] intel_rapl_common: Found RAPL domain psys
[    9.912956] psmouse serio1: synaptics: queried min coordinates: x 
[1266..], y [1094..]
[    9.912964] psmouse serio1: synaptics: Trying to set up SMBus access
[    9.935615] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[    9.943698] iwlwifi 0000:04:00.0 wlp4s0: renamed from wlan0
[    9.943827] rmi4_smbus 6-002c: registering SMbus-connected sensor
[   10.002506] rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: 
Synaptics, product: TM3289-002, fw id: 2492434
[   10.060033] input: Synaptics TM3289-002 as 
/devices/pci0000:00/0000:00:1f.4/i2c-6/6-002c/rmi4-00/input/input20
[   10.065972] serio: RMI4 PS/2 pass-through port at rmi4-00.fn03
[   10.179350] psmouse serio3: trackpoint: Elan TrackPoint firmware: 
0x04, buttons: 3/3
[   10.216257] input: TPPS/2 Elan TrackPoint as 
/devices/pci0000:00/0000:00:1f.4/i2c-6/6-002c/rmi4-00/rmi4-00.fn03/serio3/input/input21
[   10.429908] EXT4-fs (nvme0n1p1): mounted filesystem with ordered data 
mode. Quota mode: none.
[   10.436649] EXT4-fs (dm-2): mounted filesystem with ordered data 
mode. Quota mode: none.
[   10.576676] RPC: Registered named UNIX socket transport module.
[   10.576679] RPC: Registered udp transport module.
[   10.576679] RPC: Registered tcp transport module.
[   10.576680] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   10.787410] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   10.787414] Bluetooth: BNEP filters: protocol multicast
[   10.787419] Bluetooth: BNEP socket layer initialized
[   10.863134] Bluetooth: hci0: Cannot set wakeable for RPA
[   10.956670] NET: Registered PF_QIPCRTR protocol family
[   15.454868] wlp4s0: authenticate with 70:03:7e:e6:13:b8
[   15.465102] wlp4s0: send auth to 70:03:7e:e6:13:b8 (try 1/3)
[   15.574337] wlp4s0: send auth to 70:03:7e:e6:13:b8 (try 2/3)
[   15.682677] wlp4s0: send auth to 70:03:7e:e6:13:b8 (try 3/3)
[   15.791377] wlp4s0: authentication with 70:03:7e:e6:13:b8 timed out
[   41.190980] bridge: filtering via arp/ip/ip6tables is no longer 
available by default. Update your scripts to load br_netfilter if you 
need this.
[   42.977942] Bluetooth: RFCOMM TTY layer initialized
[   42.977949] Bluetooth: RFCOMM socket layer initialized
[   42.978018] Bluetooth: RFCOMM ver 1.11
[   42.993761] rfkill: input handler disabled
[   43.301320] wlp4s0: authenticate with 70:03:7e:e6:13:b8
[   43.310733] wlp4s0: send auth to 70:03:7e:e6:13:b8 (try 1/3)
[   43.415170] wlp4s0: send auth to 70:03:7e:e6:13:b8 (try 2/3)
[   43.520255] wlp4s0: send auth to 70:03:7e:e6:13:b8 (try 3/3)
[   43.622179] wlp4s0: authentication with 70:03:7e:e6:13:b8 timed out
[   46.683086] wlp4s0: authenticate with 70:03:7e:e6:13:b8
[   46.692690] wlp4s0: send auth to 70:03:7e:e6:13:b8 (try 1/3)
[   46.806379] wlp4s0: send auth to 70:03:7e:e6:13:b8 (try 2/3)
[   46.912582] wlp4s0: send auth to 70:03:7e:e6:13:b8 (try 3/3)
[   47.014347] wlp4s0: authentication with 70:03:7e:e6:13:b8 timed out
[   48.479231] rfkill: input handler enabled
[   70.352861] wlp4s0: authenticate with 24:f5:a2:ab:db:43
[   70.363902] wlp4s0: send auth to 24:f5:a2:ab:db:43 (try 1/3)
[   70.370943] wlp4s0: authenticated
[   70.372038] wlp4s0: associate with 24:f5:a2:ab:db:43 (try 1/3)
[   70.375105] wlp4s0: RX AssocResp from 24:f5:a2:ab:db:43 (capab=0x1511 
status=0 aid=2)
[   70.380205] wlp4s0: associated
[   70.394766] wlp4s0: Limiting TX power to 30 (30 - 0) dBm as 
advertised by 24:f5:a2:ab:db:43
[   70.457826] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes ready
[   79.705611] tun: Universal TUN/TAP device driver, 1.6
[  283.192112] iwlwifi 0000:04:00.0: Error sending STATISTICS_CMD: time 
out after 2000ms.
[  283.192128] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 141 
write_ptr 142
[  283.211159] ------------[ cut here ]------------
[  283.211165] Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
[  283.211227] WARNING: CPU: 0 PID: 951 at 
drivers/net/wireless/intel/iwlwifi/pcie/trans.c:2118 
__iwl_trans_pcie_grab_nic_access+0x1ec/0x220 [iwlwifi]
[  283.211274] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  283.211371]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  283.211482] CPU: 0 PID: 951 Comm: NetworkManager Not tainted 
5.18.5-200.fc36.x86_64 #1
[  283.211488] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  283.211491] RIP: 0010:__iwl_trans_pcie_grab_nic_access+0x1ec/0x220 
[iwlwifi]
[  283.211525] Code: 48 89 df e8 26 b4 fe ff 4c 89 f7 e8 1e 65 20 d0 e9 
e6 fe ff ff 89 c6 48 c7 c7 18 b1 b6 c0 c6 05 84 f0 03 00 01 e8 9f 7b 18 
d0 <0f> 0b e9 01 ff ff ff 48 8b 7b 40 48 c7 c2 80 b1 b6 c0 31 f6 e8 cb
[  283.211530] RSP: 0018:ffffba910111b5d8 EFLAGS: 00010296
[  283.211535] RAX: 000000000000003d RBX: ffffa00e07328028 RCX: 
0000000000000000
[  283.211539] RDX: 0000000000000202 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  283.211542] RBP: 00000000ffffffff R08: 0000000000000000 R09: 
ffffba910111b410
[  283.211546] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
0000000000000001
[  283.211548] R13: 0000000000000000 R14: ffffa00e0732a974 R15: 
0000000000000011
[  283.211552] FS:  00007fcd11c95500(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  283.211556] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  283.211559] CR2: 00007fca03a13000 CR3: 000000010535e005 CR4: 
00000000003706f0
[  283.211563] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  283.211565] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  283.211569] Call Trace:
[  283.211573]  <TASK>
[  283.211578]  iwl_trans_pcie_grab_nic_access+0x1b/0x40 [iwlwifi]
[  283.211610]  iwl_force_nmi+0x81/0x100 [iwlwifi]
[  283.211636]  iwl_trans_sync_nmi_with_addr+0x125/0x140 [iwlwifi]
[  283.211664]  iwl_trans_txq_send_hcmd+0x38c/0x3f0 [iwlwifi]
[  283.211699]  ? dequeue_task_stop+0x70/0x70
[  283.211707]  iwl_trans_send_cmd+0x8e/0xe0 [iwlwifi]
[  283.211739]  iwl_mvm_send_cmd+0x1b/0x50 [iwlmvm]
[  283.211775]  iwl_mvm_request_statistics+0x75/0x170 [iwlmvm]
[  283.211807]  iwl_mvm_mac_sta_statistics+0x1db/0x370 [iwlmvm]
[  283.211833]  sta_set_sinfo+0xb8/0xb30 [mac80211]
[  283.211912]  ? kfree+0xcc/0x2d0
[  283.211922]  ieee80211_dump_station+0x6b/0x90 [mac80211]
[  283.212003]  nl80211_dump_station+0xf8/0x220 [cfg80211]
[  283.212180]  ? prepare_alloc_pages.constprop.0+0xab/0x190
[  283.212193]  netlink_dump+0x123/0x310
[  283.212206]  __netlink_dump_start+0x1b6/0x2e0
[  283.212214]  genl_family_rcv_msg_dumpit+0x83/0x100
[  283.212221]  ? genl_family_rcv_msg_doit+0x110/0x110
[  283.212225]  ? nl80211_send_station+0xf20/0xf20 [cfg80211]
[  283.212302]  ? genl_family_rcv_msg_dumpit+0x100/0x100
[  283.212311]  genl_rcv_msg+0x138/0x1b0
[  283.212317]  ? nl80211_dump_station+0x220/0x220 [cfg80211]
[  283.212429]  ? nl80211_send_station+0xf20/0xf20 [cfg80211]
[  283.212520]  ? genl_get_cmd+0xd0/0xd0
[  283.212530]  netlink_rcv_skb+0x51/0xf0
[  283.212546]  genl_rcv+0x24/0x40
[  283.212552]  netlink_unicast+0x212/0x360
[  283.212564]  netlink_sendmsg+0x242/0x490
[  283.212576]  sock_sendmsg+0x5c/0x60
[  283.212587]  ____sys_sendmsg+0x22b/0x270
[  283.212594]  ? import_iovec+0x17/0x20
[  283.212600]  ? sendmsg_copy_msghdr+0x58/0x90
[  283.212609]  ___sys_sendmsg+0x80/0xc0
[  283.212620]  ? __pollwait+0xd0/0xd0
[  283.212631]  ? __pollwait+0xd0/0xd0
[  283.212638]  ? __pollwait+0xd0/0xd0
[  283.212646]  ? __rseq_handle_notify_resume+0x337/0x450
[  283.212655]  ? __fget_light+0x94/0x100
[  283.212665]  ? __fget_light+0x94/0x100
[  283.212673]  __sys_sendmsg+0x47/0x80
[  283.212682]  ? intel_pmu_drain_pebs_nhm+0x470/0x5d0
[  283.212691]  do_syscall_64+0x5b/0x80
[  283.212703]  ? syscall_exit_to_user_mode+0x17/0x40
[  283.212710]  ? do_syscall_64+0x67/0x80
[  283.212718]  ? do_syscall_64+0x67/0x80
[  283.212725]  ? do_syscall_64+0x67/0x80
[  283.212733]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  283.212744] RIP: 0033:0x7fcd12d1371d
[  283.212803] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 ba 5b 
f7 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 0e 5c f7 ff 48
[  283.212809] RSP: 002b:00007ffcdcf446c0 EFLAGS: 00000293 ORIG_RAX: 
000000000000002e
[  283.212817] RAX: ffffffffffffffda RBX: 0000562bf7593a00 RCX: 
00007fcd12d1371d
[  283.212822] RDX: 0000000000000000 RSI: 00007ffcdcf44700 RDI: 
000000000000000b
[  283.212827] RBP: 0000562bf7593a00 R08: 0000000000000000 R09: 
00007fcd12df7d40
[  283.212831] R10: 0000000000000000 R11: 0000000000000293 R12: 
00007ffcdcf44790
[  283.212835] R13: 0000562bf7701180 R14: 00007ffcdcf449c4 R15: 
0000562bf75b1900
[  283.212845]  </TASK>
[  283.212848] ---[ end trace 0000000000000000 ]---
[  283.212858] iwlwifi 0000:04:00.0: iwlwifi transaction failed, dumping 
registers
[  283.212864] iwlwifi 0000:04:00.0: iwlwifi device config registers:
[  283.213119] iwlwifi 0000:04:00.0: 00000000: 24fd8086 00100000 
02800088 00000000 00000004 00000000 00000000 00000000
[  283.213129] iwlwifi 0000:04:00.0: 00000020: 00000000 00000000 
00000000 01308086 00000000 000000c8 00000000 00000100
[  283.213137] iwlwifi 0000:04:00.0: 00000040: 00020010 10008ec0 
001b0c10 0045e811 10110000 00000000 00000000 00000000
[  283.213143] iwlwifi 0000:04:00.0: 00000060: 00000000 00080812 
00000005 00000000 00010001 00000000 00000000 00000000
[  283.213149] iwlwifi 0000:04:00.0: 00000080: 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213155] iwlwifi 0000:04:00.0: 000000a0: 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213161] iwlwifi 0000:04:00.0: 000000c0: 00000000 00000000 
c823d001 0d000000 00804005 00000000 00000000 00000000
[  283.213167] iwlwifi 0000:04:00.0: 000000e0: 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213173] iwlwifi 0000:04:00.0: 00000100: 14010001 00100000 
00000000 00462031 00002000 00002000 00000014 40000001
[  283.213179] iwlwifi 0000:04:00.0: 00000120: 0000000f ec10000c 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213185] iwlwifi 0000:04:00.0: 00000140: 14c10003 ff2d2bd9 
f894c2ff 15410018 00000000 0001001e 00481e1f 00000000
[  283.213189] iwlwifi 0000:04:00.0: iwlwifi device memory mapped registers:
[  283.213226] iwlwifi 0000:04:00.0: 00000000: ffffffff ffffffff 
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
[  283.213233] iwlwifi 0000:04:00.0: 00000020: ffffffff ffffffff 
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
[  283.213240] iwlwifi 0000:04:00.0: iwlwifi device AER capability 
structure:
[  283.213270] iwlwifi 0000:04:00.0: 00000000: 14010001 00100000 
00000000 00462031 00002000 00002000 00000014 40000001
[  283.213274] iwlwifi 0000:04:00.0: 00000020: 0000000f ec10000c 00000000
[  283.213279] iwlwifi 0000:04:00.0: iwlwifi parent port (0000:00:1c.2) 
config registers:
[  283.213414] iwlwifi 0000:00:1c.2: 00000000: 9d128086 00100407 
060400f1 00810000 00000000 00000000 00040400 200000f0
[  283.213421] iwlwifi 0000:00:1c.2: 00000020: ec10ec10 0001fff1 
00000000 00000000 00000000 00000040 00000000 0002030b
[  283.213427] iwlwifi 0000:00:1c.2: 00000040: 01428010 00008001 
00100000 03724c13 70110042 0014b200 01480000 00000000
[  283.213433] iwlwifi 0000:00:1c.2: 00000060: 00000000 00000837 
00000000 0000000e 00010003 00000000 00000000 00000000
[  283.213439] iwlwifi 0000:00:1c.2: 00000080: 00019005 fee00258 
00000000 00000000 0000a00d 224f17aa 00000000 00000000
[  283.213445] iwlwifi 0000:00:1c.2: 000000a0: c8030001 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213451] iwlwifi 0000:00:1c.2: 000000c0: 00000000 00000000 
00000000 00000000 07001001 00001842 899e0008 00000000
[  283.213457] iwlwifi 0000:00:1c.2: 000000e0: 00e30300 88aa88aa 
00100006 00000000 00000150 4c000000 08410fb3 03000004
[  283.213463] iwlwifi 0000:00:1c.2: 00000100: 14010001 00000000 
00010000 00060011 00000000 00002000 00000000 00000000
[  283.213469] iwlwifi 0000:00:1c.2: 00000120: 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213475] iwlwifi 0000:00:1c.2: 00000140: 2001000d 0000000f 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213481] iwlwifi 0000:00:1c.2: 00000160: 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213487] iwlwifi 0000:00:1c.2: 00000180: 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213493] iwlwifi 0000:00:1c.2: 000001a0: 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213498] iwlwifi 0000:00:1c.2: 000001c0: 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213504] iwlwifi 0000:00:1c.2: 000001e0: 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 00000000
[  283.213508] iwlwifi 0000:00:1c.2: 00000200: 2201001e 00b0281f 6002280f
[  283.213513] iwlwifi 0000:04:00.0: iwlwifi root port (0000:00:1c.2) 
AER cap structure:
[  283.213530] iwlwifi 0000:00:1c.2: 00000000: 14010001 00000000 
00010000 00060011 00000000 00002000 00000000 00000000
[  283.213536] iwlwifi 0000:00:1c.2: 00000020: 00000000 00000000 
00000000 00000000 00000000 00000000
[  283.232494] ------------[ cut here ]------------
[  283.232501] WARNING: CPU: 0 PID: 951 at 
drivers/net/wireless/intel/iwlwifi/iwl-trans.h:1414 
iwl_fwrt_dump_lmac_error_log+0x4a0/0x4f0 [iwlwifi]
[  283.232574] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  283.232710]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  283.232982] CPU: 0 PID: 951 Comm: NetworkManager Tainted: G        W 
        5.18.5-200.fc36.x86_64 #1
[  283.232995] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  283.233000] RIP: 0010:iwl_fwrt_dump_lmac_error_log+0x4a0/0x4f0 [iwlwifi]
[  283.233100] Code: ff 48 81 c4 a0 00 00 00 5b 5d 41 5c 41 5d 41 5e c3 
cc 81 fd ff ff 3f 00 0f 87 10 fc ff ff 49 c7 c0 31 7f b6 c0 e9 be fb ff 
ff <0f> 0b 49 8b 7c 24 40 48 c7 c2 58 cf b6 c0 31 f6 e8 ab 05 fe ff 49
[  283.233110] RSP: 0018:ffffba910111b528 EFLAGS: 00010286
[  283.233121] RAX: 00000000fffffff0 RBX: ffffa00e07d62fb0 RCX: 
0000000000000000
[  283.233128] RDX: 0000000000000001 RSI: ffffffff91704aec RDI: 
00000000ffffffff
[  283.233135] RBP: 0000000000811ac8 R08: 0000000000003a98 R09: 
000000002c13c319
[  283.233142] R10: ffffffff91e06110 R11: 00000000eac0c6e6 R12: 
ffffa00e07328028
[  283.233148] R13: 0000000000000000 R14: ffffba910111b530 R15: 
0000000000000000
[  283.233155] FS:  00007fcd11c95500(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  283.233164] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  283.233170] CR2: 00007fca03a13000 CR3: 000000010535e005 CR4: 
00000000003706f0
[  283.233178] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  283.233183] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  283.233189] Call Trace:
[  283.233196]  <TASK>
[  283.233211]  iwl_fwrt_dump_error_logs+0x24/0x1e0 [iwlwifi]
[  283.233283]  iwl_mvm_nic_error+0xa0/0xc0 [iwlmvm]
[  283.233346]  iwl_trans_sync_nmi_with_addr+0x6c/0x140 [iwlwifi]
[  283.233405]  iwl_trans_txq_send_hcmd+0x38c/0x3f0 [iwlwifi]
[  283.233469]  ? dequeue_task_stop+0x70/0x70
[  283.233485]  iwl_trans_send_cmd+0x8e/0xe0 [iwlwifi]
[  283.233543]  iwl_mvm_send_cmd+0x1b/0x50 [iwlmvm]
[  283.233590]  iwl_mvm_request_statistics+0x75/0x170 [iwlmvm]
[  283.233630]  iwl_mvm_mac_sta_statistics+0x1db/0x370 [iwlmvm]
[  283.233657]  sta_set_sinfo+0xb8/0xb30 [mac80211]
[  283.233777]  ? kfree+0xcc/0x2d0
[  283.233790]  ieee80211_dump_station+0x6b/0x90 [mac80211]
[  283.233910]  nl80211_dump_station+0xf8/0x220 [cfg80211]
[  283.234034]  ? prepare_alloc_pages.constprop.0+0xab/0x190
[  283.234053]  netlink_dump+0x123/0x310
[  283.234082]  __netlink_dump_start+0x1b6/0x2e0
[  283.234094]  genl_family_rcv_msg_dumpit+0x83/0x100
[  283.234102]  ? genl_family_rcv_msg_doit+0x110/0x110
[  283.234108]  ? nl80211_send_station+0xf20/0xf20 [cfg80211]
[  283.234223]  ? genl_family_rcv_msg_dumpit+0x100/0x100
[  283.234232]  genl_rcv_msg+0x138/0x1b0
[  283.234276]  ? nl80211_dump_station+0x220/0x220 [cfg80211]
[  283.234389]  ? nl80211_send_station+0xf20/0xf20 [cfg80211]
[  283.234498]  ? genl_get_cmd+0xd0/0xd0
[  283.234504]  netlink_rcv_skb+0x51/0xf0
[  283.234517]  genl_rcv+0x24/0x40
[  283.234523]  netlink_unicast+0x212/0x360
[  283.234535]  netlink_sendmsg+0x242/0x490
[  283.234547]  sock_sendmsg+0x5c/0x60
[  283.234558]  ____sys_sendmsg+0x22b/0x270
[  283.234567]  ? import_iovec+0x17/0x20
[  283.234574]  ? sendmsg_copy_msghdr+0x58/0x90
[  283.234584]  ___sys_sendmsg+0x80/0xc0
[  283.234595]  ? __pollwait+0xd0/0xd0
[  283.234604]  ? __pollwait+0xd0/0xd0
[  283.234613]  ? __pollwait+0xd0/0xd0
[  283.234620]  ? __rseq_handle_notify_resume+0x337/0x450
[  283.234629]  ? __fget_light+0x94/0x100
[  283.234638]  ? __fget_light+0x94/0x100
[  283.234647]  __sys_sendmsg+0x47/0x80
[  283.234657]  ? intel_pmu_drain_pebs_nhm+0x470/0x5d0
[  283.234668]  do_syscall_64+0x5b/0x80
[  283.234681]  ? syscall_exit_to_user_mode+0x17/0x40
[  283.234688]  ? do_syscall_64+0x67/0x80
[  283.234695]  ? do_syscall_64+0x67/0x80
[  283.234702]  ? do_syscall_64+0x67/0x80
[  283.234710]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  283.234721] RIP: 0033:0x7fcd12d1371d
[  283.234774] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 ba 5b 
f7 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 0e 5c f7 ff 48
[  283.234780] RSP: 002b:00007ffcdcf446c0 EFLAGS: 00000293 ORIG_RAX: 
000000000000002e
[  283.234789] RAX: ffffffffffffffda RBX: 0000562bf7593a00 RCX: 
00007fcd12d1371d
[  283.234794] RDX: 0000000000000000 RSI: 00007ffcdcf44700 RDI: 
000000000000000b
[  283.234798] RBP: 0000562bf7593a00 R08: 0000000000000000 R09: 
00007fcd12df7d40
[  283.234803] R10: 0000000000000000 R11: 0000000000000293 R12: 
00007ffcdcf44790
[  283.234807] R13: 0000562bf7701180 R14: 00007ffcdcf449c4 R15: 
0000562bf75b1900
[  283.234818]  </TASK>
[  283.234822] ---[ end trace 0000000000000000 ]---
[  283.234831] iwlwifi 0000:04:00.0: HW error, resetting before reading
[  283.259154] iwlwifi 0000:04:00.0: Loaded firmware version: 
36.ca7b901d.0 8265-36.ucode
[  283.259168] iwlwifi 0000:04:00.0: 0x00000000 | ADVANCED_SYSASSERT
[  283.259175] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status0
[  283.259179] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  283.259182] iwlwifi 0000:04:00.0: 0x00000000 | branchlink2
[  283.259184] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink1
[  283.259187] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
[  283.259190] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  283.259192] iwlwifi 0000:04:00.0: 0x00000000 | data2
[  283.259195] iwlwifi 0000:04:00.0: 0x00000000 | data3
[  283.259197] iwlwifi 0000:04:00.0: 0x00000000 | beacon time
[  283.259200] iwlwifi 0000:04:00.0: 0x00000000 | tsf low
[  283.259202] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  283.259205] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  283.259207] iwlwifi 0000:04:00.0: 0x00000000 | time gp2
[  283.259210] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  283.259212] iwlwifi 0000:04:00.0: 0x00000000 | uCode version major
[  283.259215] iwlwifi 0000:04:00.0: 0x00000000 | uCode version minor
[  283.259218] iwlwifi 0000:04:00.0: 0x00000000 | hw version
[  283.259220] iwlwifi 0000:04:00.0: 0x00000000 | board version
[  283.259223] iwlwifi 0000:04:00.0: 0x00000000 | hcmd
[  283.259225] iwlwifi 0000:04:00.0: 0x00000000 | isr0
[  283.259228] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  283.259230] iwlwifi 0000:04:00.0: 0x00000000 | isr2
[  283.259233] iwlwifi 0000:04:00.0: 0x00000000 | isr3
[  283.259235] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[  283.259237] iwlwifi 0000:04:00.0: 0x00000000 | last cmd Id
[  283.259240] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  283.259243] iwlwifi 0000:04:00.0: 0x00000000 | l2p_control
[  283.259245] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  283.259248] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  283.259250] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  283.259253] iwlwifi 0000:04:00.0: 0x00000000 | lmpm_pmg_sel
[  283.259256] iwlwifi 0000:04:00.0: 0x00000000 | timestamp
[  283.259258] iwlwifi 0000:04:00.0: 0x00000000 | flow_handler
[  283.277896] iwlwifi 0000:04:00.0: 0x00000000 | ADVANCED_SYSASSERT
[  283.277907] iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink1
[  283.277911] iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink2
[  283.277914] iwlwifi 0000:04:00.0: 0x00000000 | umac interruptlink1
[  283.277916] iwlwifi 0000:04:00.0: 0x00000000 | umac interruptlink2
[  283.277919] iwlwifi 0000:04:00.0: 0x00000000 | umac data1
[  283.277922] iwlwifi 0000:04:00.0: 0x00000000 | umac data2
[  283.277924] iwlwifi 0000:04:00.0: 0x00000000 | umac data3
[  283.277927] iwlwifi 0000:04:00.0: 0x00000000 | umac major
[  283.277929] iwlwifi 0000:04:00.0: 0x00000000 | umac minor
[  283.277931] iwlwifi 0000:04:00.0: 0x00000000 | frame pointer
[  283.277934] iwlwifi 0000:04:00.0: 0x00000000 | stack pointer
[  283.277937] iwlwifi 0000:04:00.0: 0x00000000 | last host cmd
[  283.277939] iwlwifi 0000:04:00.0: 0x00000000 | isr status reg
[  283.297045] iwlwifi 0000:04:00.0: IML/ROM dump:
[  283.297053] iwlwifi 0000:04:00.0: 0x5A5A | IML/ROM SYSASSERT
[  283.297057] iwlwifi 0000:04:00.0: 0x5A5A5A5A | IML/ROM error/state
[  283.315375] iwlwifi 0000:04:00.0: 0x5A5A5A5A | IML/ROM data1
[  283.333567] iwlwifi 0000:04:00.0: Collecting data: trigger 2 fired.
[  283.333574] ieee80211 phy0: Hardware restart was requested
[  286.070514] iwlwifi 0000:04:00.0: Could not load the [0] uCode section
[  286.070522] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -5
[  286.070524] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  286.070525] iwlwifi 0000:04:00.0: Failed to start RT ucode: -5
[  286.070563] iwlwifi 0000:04:00.0: Collecting data: trigger 16 fired.
[  286.107431] ------------[ cut here ]------------
[  286.107435] WARNING: CPU: 0 PID: 6 at 
drivers/net/wireless/intel/iwlwifi/iwl-trans.h:1414 
iwl_fwrt_dump_lmac_error_log+0x4a0/0x4f0 [iwlwifi]
[  286.107459] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  286.107511]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  286.107575] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  286.107578] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  286.107579] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  286.107621] RIP: 0010:iwl_fwrt_dump_lmac_error_log+0x4a0/0x4f0 [iwlwifi]
[  286.107639] Code: ff 48 81 c4 a0 00 00 00 5b 5d 41 5c 41 5d 41 5e c3 
cc 81 fd ff ff 3f 00 0f 87 10 fc ff ff 49 c7 c0 31 7f b6 c0 e9 be fb ff 
ff <0f> 0b 49 8b 7c 24 40 48 c7 c2 58 cf b6 c0 31 f6 e8 ab 05 fe ff 49
[  286.107641] RSP: 0018:ffffba910009bb78 EFLAGS: 00010286
[  286.107643] RAX: 00000000fffffff0 RBX: ffffa00e07d62fb0 RCX: 
0000000000000000
[  286.107645] RDX: 0000000000000001 RSI: ffffffff91704af6 RDI: 
00000000ffffffff
[  286.107646] RBP: 0000000000811ac8 R08: 0000000000000002 R09: 
000000002c13c319
[  286.107648] R10: ffffffff91e06110 R11: ffffba9100003ff8 R12: 
ffffa00e07328028
[  286.107649] R13: 0000000000000000 R14: ffffba910009bb80 R15: 
ffffa00e07d62118
[  286.107651] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  286.107653] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  286.107654] CR2: 00007fabc11e56f0 CR3: 0000000104b80004 CR4: 
00000000003706f0
[  286.107656] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  286.107657] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  286.107658] Call Trace:
[  286.107661]  <TASK>
[  286.107666]  iwl_fwrt_dump_error_logs+0x24/0x1e0 [iwlwifi]
[  286.107685]  iwl_mvm_nic_error+0xa0/0xc0 [iwlmvm]
[  286.107702]  iwl_trans_sync_nmi_with_addr+0x6c/0x140 [iwlwifi]
[  286.107715]  iwl_fw_dbg_error_collect+0x5a/0xd0 [iwlwifi]
[  286.107731]  iwl_mvm_up+0xce/0xb30 [iwlmvm]
[  286.107743]  ? __local_bh_enable_ip+0x37/0x80
[  286.107775]  ? iwl_mvm_cleanup_iterator+0x43/0x80 [iwlmvm]
[  286.107787]  ? __iterate_interfaces+0xa0/0x160 [mac80211]
[  286.107829]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  286.107834]  ? ieee80211_wake_queues_by_reason+0xa4/0xc0 [mac80211]
[  286.107873]  ? __iwl_mvm_mac_start+0x68/0x1e0 [iwlmvm]
[  286.107885]  __iwl_mvm_mac_start+0x68/0x1e0 [iwlmvm]
[  286.107897]  iwl_mvm_mac_start+0x6a/0x100 [iwlmvm]
[  286.107910]  drv_start+0x3e/0xf0 [mac80211]
[  286.107943]  ieee80211_reconfig+0x9a/0x14a0 [mac80211]
[  286.107982]  ? kvfree_call_rcu+0x2e0/0x2e0
[  286.107987]  ieee80211_restart_work+0xfc/0x150 [mac80211]
[  286.108018]  process_one_work+0x1c7/0x380
[  286.108023]  worker_thread+0x4d/0x380
[  286.108026]  ? process_one_work+0x380/0x380
[  286.108028]  kthread+0xe9/0x110
[  286.108031]  ? kthread_complete_and_exit+0x20/0x20
[  286.108033]  ret_from_fork+0x22/0x30
[  286.108039]  </TASK>
[  286.108039] ---[ end trace 0000000000000000 ]---
[  286.108043] iwlwifi 0000:04:00.0: HW error, resetting before reading
[  286.132359] iwlwifi 0000:04:00.0: Loaded firmware version: 
36.ca7b901d.0 8265-36.ucode
[  286.132364] iwlwifi 0000:04:00.0: 0x00000000 | ADVANCED_SYSASSERT
[  286.132367] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status0
[  286.132369] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  286.132370] iwlwifi 0000:04:00.0: 0x00000000 | branchlink2
[  286.132371] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink1
[  286.132373] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
[  286.132375] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  286.132376] iwlwifi 0000:04:00.0: 0x00000000 | data2
[  286.132377] iwlwifi 0000:04:00.0: 0x00000000 | data3
[  286.132378] iwlwifi 0000:04:00.0: 0x00000000 | beacon time
[  286.132380] iwlwifi 0000:04:00.0: 0x00000000 | tsf low
[  286.132381] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  286.132382] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  286.132384] iwlwifi 0000:04:00.0: 0x00000000 | time gp2
[  286.132385] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  286.132387] iwlwifi 0000:04:00.0: 0x00000000 | uCode version major
[  286.132388] iwlwifi 0000:04:00.0: 0x00000000 | uCode version minor
[  286.132389] iwlwifi 0000:04:00.0: 0x00000000 | hw version
[  286.132390] iwlwifi 0000:04:00.0: 0x00000000 | board version
[  286.132392] iwlwifi 0000:04:00.0: 0x00000000 | hcmd
[  286.132393] iwlwifi 0000:04:00.0: 0x00000000 | isr0
[  286.132394] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  286.132396] iwlwifi 0000:04:00.0: 0x00000000 | isr2
[  286.132397] iwlwifi 0000:04:00.0: 0x00000000 | isr3
[  286.132398] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[  286.132399] iwlwifi 0000:04:00.0: 0x00000000 | last cmd Id
[  286.132401] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  286.132402] iwlwifi 0000:04:00.0: 0x00000000 | l2p_control
[  286.132403] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  286.132405] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  286.132406] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  286.132407] iwlwifi 0000:04:00.0: 0x00000000 | lmpm_pmg_sel
[  286.132409] iwlwifi 0000:04:00.0: 0x00000000 | timestamp
[  286.132410] iwlwifi 0000:04:00.0: 0x00000000 | flow_handler
[  286.150778] iwlwifi 0000:04:00.0: 0x00000000 | ADVANCED_SYSASSERT
[  286.150783] iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink1
[  286.150785] iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink2
[  286.150786] iwlwifi 0000:04:00.0: 0x00000000 | umac interruptlink1
[  286.150787] iwlwifi 0000:04:00.0: 0x00000000 | umac interruptlink2
[  286.150789] iwlwifi 0000:04:00.0: 0x00000000 | umac data1
[  286.150790] iwlwifi 0000:04:00.0: 0x00000000 | umac data2
[  286.150791] iwlwifi 0000:04:00.0: 0x00000000 | umac data3
[  286.150792] iwlwifi 0000:04:00.0: 0x00000000 | umac major
[  286.150793] iwlwifi 0000:04:00.0: 0x00000000 | umac minor
[  286.150794] iwlwifi 0000:04:00.0: 0x00000000 | frame pointer
[  286.150796] iwlwifi 0000:04:00.0: 0x00000000 | stack pointer
[  286.150797] iwlwifi 0000:04:00.0: 0x00000000 | last host cmd
[  286.150798] iwlwifi 0000:04:00.0: 0x00000000 | isr status reg
[  286.168989] iwlwifi 0000:04:00.0: IML/ROM dump:
[  286.168992] iwlwifi 0000:04:00.0: 0x5A5A | IML/ROM SYSASSERT
[  286.168994] iwlwifi 0000:04:00.0: 0x5A5A5A5A | IML/ROM error/state
[  286.187167] iwlwifi 0000:04:00.0: 0x5A5A5A5A | IML/ROM data1
[  288.211113] iwlwifi 0000:04:00.0: mac start retry 0
[  288.211121] ------------[ cut here ]------------
[  288.211122] Hardware became unavailable during restart.
[  288.211146] WARNING: CPU: 0 PID: 6 at net/mac80211/util.c:2410 
ieee80211_reconfig+0xb1/0x14a0 [mac80211]
[  288.211180] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.211209]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.211244] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.211246] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.211247] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.211266] RIP: 0010:ieee80211_reconfig+0xb1/0x14a0 [mac80211]
[  288.211289] Code: c0 0f 85 81 01 00 00 c6 87 7d 06 00 00 00 e8 26 3a 
fc ff 41 89 c4 85 c0 0f 84 1e 02 00 00 48 c7 c7 d8 13 ec c0 e8 6a 41 e6 
cf <0f> 0b 48 89 df e8 85 c9 ff ff e9 3c 01 00 00 c6 44 24 1f 00 8b 93
[  288.211290] RSP: 0018:ffffba910009be08 EFLAGS: 00010296
[  288.211292] RAX: 000000000000002b RBX: ffffa00e07d608e0 RCX: 
0000000000000000
[  288.211293] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.211294] RBP: ffffa00e07d61f88 R08: 0000000000000000 R09: 
ffffba910009bc40
[  288.211294] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
00000000fffffffb
[  288.211295] R13: ffffa00e07d608e0 R14: ffffa00e0022d480 R15: 
ffffa00e07d61f90
[  288.211296] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.211297] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.211298] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.211299] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.211300] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.211301] Call Trace:
[  288.211302]  <TASK>
[  288.211304]  ? kvfree_call_rcu+0x2e0/0x2e0
[  288.211308]  ieee80211_restart_work+0xfc/0x150 [mac80211]
[  288.211324]  process_one_work+0x1c7/0x380
[  288.211327]  worker_thread+0x4d/0x380
[  288.211329]  ? process_one_work+0x380/0x380
[  288.211330]  kthread+0xe9/0x110
[  288.211332]  ? kthread_complete_and_exit+0x20/0x20
[  288.211334]  ret_from_fork+0x22/0x30
[  288.211337]  </TASK>
[  288.211338] ---[ end trace 0000000000000000 ]---
[  288.211348] ------------[ cut here ]------------
[  288.211348] p2p-dev-wlp4s0: Failed check-sdata-in-driver check, 
flags: 0x0
[  288.211362] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.c:97 
drv_remove_interface+0x10d/0x120 [mac80211]
[  288.211379] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.211402]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.211428] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.211429] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.211430] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.211446] RIP: 0010:drv_remove_interface+0x10d/0x120 [mac80211]
[  288.211461] Code: ff ff 48 8b 83 88 04 00 00 48 8d b3 a8 04 00 00 48 
c7 c7 40 04 ec c0 c6 05 4d 09 0e 00 01 48 85 c0 48 0f 45 f0 e8 fe 01 ea 
cf <0f> 0b e9 32 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44
[  288.211462] RSP: 0018:ffffba910009bd88 EFLAGS: 00010292
[  288.211464] RAX: 000000000000003e RBX: ffffa00e03dbc000 RCX: 
0000000000000000
[  288.211464] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.211465] RBP: ffffa00e07d608e0 R08: 0000000000000000 R09: 
ffffba910009bbc0
[  288.211466] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
ffffa00e07d608e0
[  288.211466] R13: ffffa00e03dbce88 R14: ffffa00e07d61248 R15: 
0000000000000000
[  288.211467] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.211468] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.211469] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.211470] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.211470] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.211471] Call Trace:
[  288.211472]  <TASK>
[  288.211472]  ieee80211_do_stop+0x5fa/0x830 [mac80211]
[  288.211492]  ? ieee80211_sched_scan_end+0x19/0x60 [mac80211]
[  288.211509]  ? mutex_lock+0xe/0x30
[  288.211513]  cfg80211_stop_p2p_device+0x4f/0x150 [cfg80211]
[  288.211537]  cfg80211_shutdown_all_interfaces+0xa7/0xe0 [cfg80211]
[  288.211552]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.211568]  process_one_work+0x1c7/0x380
[  288.211571]  worker_thread+0x4d/0x380
[  288.211572]  ? process_one_work+0x380/0x380
[  288.211574]  kthread+0xe9/0x110
[  288.211575]  ? kthread_complete_and_exit+0x20/0x20
[  288.211577]  ret_from_fork+0x22/0x30
[  288.211579]  </TASK>
[  288.211580] ---[ end trace 0000000000000000 ]---
[  288.211584] iwlwifi 0000:04:00.0: Failed to synchronize multicast 
groups update
[  288.211595] wlp4s0: deauthenticating from 24:f5:a2:ab:db:43 by local 
choice (Reason: 3=DEAUTH_LEAVING)
[  288.211598] ------------[ cut here ]------------
[  288.211598] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.211608] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.h:172 
drv_bss_info_changed+0x17b/0x190 [mac80211]
[  288.211624] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.211646]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.211670] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.211671] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.211672] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.211687] RIP: 0010:drv_bss_info_changed+0x17b/0x190 [mac80211]
[  288.211703] Code: ff ff 48 8b 83 88 04 00 00 48 8d b3 a8 04 00 00 48 
c7 c7 78 03 ec c0 c6 05 e3 34 0e 00 01 48 85 c0 48 0f 45 f0 e8 a0 2d ea 
cf <0f> 0b e9 21 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f
[  288.211704] RSP: 0018:ffffba910009ba38 EFLAGS: 00010292
[  288.211705] RAX: 0000000000000036 RBX: ffffa00e1a2b89c0 RCX: 
0000000000000000
[  288.211705] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.211706] RBP: 0000000000020000 R08: 0000000000000000 R09: 
ffffba910009b870
[  288.211707] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
ffffa00e07d608e0
[  288.211707] R13: ffffa00e1a2b9850 R14: ffffa00e07d61b78 R15: 
ffffa00e1a2b89c0
[  288.211708] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.211709] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.211710] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.211711] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.211711] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.211712] Call Trace:
[  288.211713]  <TASK>
[  288.211713]  ieee80211_set_disassoc+0xc5/0x520 [mac80211]
[  288.211739]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.211768]  ? irq_work_queue+0xa/0x50
[  288.211771]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.211793]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.211813]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.211833]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.211849]  ? dev_printk_emit+0x3e/0x41
[  288.211851]  ? __dev_printk+0x2d/0x67
[  288.211853]  ? _dev_err+0x5c/0x5f
[  288.211854]  ? __slab_free+0xc2/0x2f0
[  288.211857]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.211870]  ? rtnl_is_locked+0x11/0x20
[  288.211872]  ? inetdev_event+0x3a/0x630
[  288.211874]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.211876]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.211877]  ? packet_notifier+0x58/0x1d0
[  288.211879]  raw_notifier_call_chain+0x44/0x60
[  288.211881]  __dev_close_many+0x4f/0xf0
[  288.211884]  dev_close_many+0x7b/0x120
[  288.211885]  ? mutex_lock+0xe/0x30
[  288.211888]  dev_close+0x56/0x80
[  288.211889]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.211905]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.211921]  process_one_work+0x1c7/0x380
[  288.211923]  worker_thread+0x4d/0x380
[  288.211925]  ? process_one_work+0x380/0x380
[  288.211926]  kthread+0xe9/0x110
[  288.211927]  ? kthread_complete_and_exit+0x20/0x20
[  288.211929]  ret_from_fork+0x22/0x30
[  288.211931]  </TASK>
[  288.211932] ---[ end trace 0000000000000000 ]---
[  288.211939] ------------[ cut here ]------------
[  288.211939] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.211948] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.h:633 
__ieee80211_flush_queues+0x22e/0x240 [mac80211]
[  288.211972] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.211994]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.212018] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.212019] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.212020] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.212046] RIP: 0010:__ieee80211_flush_queues+0x22e/0x240 [mac80211]
[  288.212076] Code: 49 8b 84 24 88 04 00 00 49 8d b4 24 a8 04 00 00 48 
c7 c7 30 13 ec c0 c6 05 1e 58 0a 00 01 48 85 c0 48 0f 45 f0 e8 8d 50 e6 
cf <0f> 0b e9 c7 fe ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
[  288.212078] RSP: 0018:ffffba910009ba28 EFLAGS: 00010292
[  288.212079] RAX: 0000000000000036 RBX: 000000000000000f RCX: 
0000000000000000
[  288.212080] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.212081] RBP: ffffa00e07d608e0 R08: 0000000000000000 R09: 
ffffba910009b860
[  288.212082] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
ffffa00e1a2b89c0
[  288.212083] R13: 000000000000000f R14: 0000000000000001 R15: 
ffffa00e1a2b9848
[  288.212084] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.212085] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.212086] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.212088] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.212089] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.212090] Call Trace:
[  288.212091]  <TASK>
[  288.212092]  ieee80211_set_disassoc+0x3fb/0x520 [mac80211]
[  288.212127]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.212173]  ? irq_work_queue+0xa/0x50
[  288.212177]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.212212]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.212243]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.212274]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.212301]  ? dev_printk_emit+0x3e/0x41
[  288.212304]  ? __dev_printk+0x2d/0x67
[  288.212306]  ? _dev_err+0x5c/0x5f
[  288.212308]  ? __slab_free+0xc2/0x2f0
[  288.212310]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.212326]  ? rtnl_is_locked+0x11/0x20
[  288.212328]  ? inetdev_event+0x3a/0x630
[  288.212330]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.212332]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.212333]  ? packet_notifier+0x58/0x1d0
[  288.212335]  raw_notifier_call_chain+0x44/0x60
[  288.212338]  __dev_close_many+0x4f/0xf0
[  288.212340]  dev_close_many+0x7b/0x120
[  288.212342]  ? mutex_lock+0xe/0x30
[  288.212345]  dev_close+0x56/0x80
[  288.212347]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.212372]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.212401]  process_one_work+0x1c7/0x380
[  288.212405]  worker_thread+0x4d/0x380
[  288.212407]  ? process_one_work+0x380/0x380
[  288.212409]  kthread+0xe9/0x110
[  288.212411]  ? kthread_complete_and_exit+0x20/0x20
[  288.212413]  ret_from_fork+0x22/0x30
[  288.212416]  </TASK>
[  288.212417] ---[ end trace 0000000000000000 ]---
[  288.212423] ------------[ cut here ]------------
[  288.212423] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.212442] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.h:1228 
ieee80211_queue_skb+0x698/0x6c0 [mac80211]
[  288.212477] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.212516]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.212559] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.212560] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.212561] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.212620] RIP: 0010:ieee80211_queue_skb+0x698/0x6c0 [mac80211]
[  288.212654] Code: 48 8b 88 00 f6 ff ff 48 2d e0 09 00 00 48 c7 c7 d0 
11 ec c0 c6 05 2b d1 0a 00 01 48 85 c9 48 0f 44 c8 48 89 ce e8 a3 c9 e6 
cf <0f> 0b e9 95 fd ff ff 83 b8 88 0e 00 00 02 0f 84 67 ff ff ff e9 88
[  288.212656] RSP: 0018:ffffba910009b930 EFLAGS: 00010286
[  288.212657] RAX: 0000000000000036 RBX: ffffa00e4a4f3500 RCX: 
0000000000000000
[  288.212659] RDX: 0000000000000201 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.212660] RBP: ffffa00e1a2b89c0 R08: 0000000000000000 R09: 
ffffba910009b768
[  288.212661] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
0000000000000238
[  288.212663] R13: ffffa00e4cfff370 R14: ffffa00e07d608e0 R15: 
ffffa00e4cfff280
[  288.212664] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.212666] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.212667] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.212669] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.212670] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.212671] Call Trace:
[  288.212673]  <TASK>
[  288.212674]  ? sta_info_get+0x45/0x60 [mac80211]
[  288.212704]  ? invoke_tx_handlers_early+0x194/0x620 [mac80211]
[  288.212733]  ieee80211_tx+0xae/0xf0 [mac80211]
[  288.212765]  __ieee80211_tx_skb_tid_band+0x6d/0x90 [mac80211]
[  288.212799]  ieee80211_send_deauth_disassoc+0xfb/0x130 [mac80211]
[  288.212834]  ieee80211_set_disassoc+0x49b/0x520 [mac80211]
[  288.212874]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.212921]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.212959]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.212993]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.213027]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.213060]  ? dev_printk_emit+0x3e/0x41
[  288.213062]  ? __dev_printk+0x2d/0x67
[  288.213065]  ? _dev_err+0x5c/0x5f
[  288.213067]  ? __slab_free+0xc2/0x2f0
[  288.213070]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.213090]  ? rtnl_is_locked+0x11/0x20
[  288.213092]  ? inetdev_event+0x3a/0x630
[  288.213095]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.213097]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.213099]  ? packet_notifier+0x58/0x1d0
[  288.213102]  raw_notifier_call_chain+0x44/0x60
[  288.213105]  __dev_close_many+0x4f/0xf0
[  288.213108]  dev_close_many+0x7b/0x120
[  288.213110]  ? mutex_lock+0xe/0x30
[  288.213113]  dev_close+0x56/0x80
[  288.213115]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.213145]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.213177]  process_one_work+0x1c7/0x380
[  288.213180]  worker_thread+0x4d/0x380
[  288.213183]  ? process_one_work+0x380/0x380
[  288.213185]  kthread+0xe9/0x110
[  288.213187]  ? kthread_complete_and_exit+0x20/0x20
[  288.213189]  ret_from_fork+0x22/0x30
[  288.213193]  </TASK>
[  288.213194] ---[ end trace 0000000000000000 ]---
[  288.213197] ------------[ cut here ]------------
[  288.213198] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.213222] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.h:845 
drv_mgd_complete_tx+0x136/0x150 [mac80211]
[  288.213265] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.213306]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.213354] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.213357] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.213358] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.213388] RIP: 0010:drv_mgd_complete_tx+0x136/0x150 [mac80211]
[  288.213428] Code: ff ff 48 8b 83 88 04 00 00 48 8d b3 a8 04 00 00 48 
c7 c7 98 27 ec c0 c6 05 52 b4 07 00 01 48 85 c0 48 0f 45 f0 e8 b5 ac e3 
cf <0f> 0b e9 1b ff ff ff 0f 0b e9 ea fe ff ff 66 66 2e 0f 1f 84 00 00
[  288.213430] RSP: 0018:ffffba910009ba40 EFLAGS: 00010286
[  288.213432] RAX: 0000000000000036 RBX: ffffa00e1a2b89c0 RCX: 
0000000000000000
[  288.213434] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.213435] RBP: ffffba910009ba72 R08: 0000000000000000 R09: 
ffffba910009b878
[  288.213436] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
ffffa00e07d608e0
[  288.213437] R13: ffffba910009ba72 R14: ffffa00e07d61b78 R15: 
ffffa00e1a2b89c0
[  288.213439] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.213440] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.213442] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.213443] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.213444] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.213445] Call Trace:
[  288.213446]  <TASK>
[  288.213448]  ieee80211_set_disassoc+0xfe/0x520 [mac80211]
[  288.213488]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.213535]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.213575]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.213607]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.213641]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.213671]  ? dev_printk_emit+0x3e/0x41
[  288.213674]  ? __dev_printk+0x2d/0x67
[  288.213676]  ? _dev_err+0x5c/0x5f
[  288.213679]  ? __slab_free+0xc2/0x2f0
[  288.213682]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.213701]  ? rtnl_is_locked+0x11/0x20
[  288.213704]  ? inetdev_event+0x3a/0x630
[  288.213707]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.213710]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.213711]  ? packet_notifier+0x58/0x1d0
[  288.213713]  raw_notifier_call_chain+0x44/0x60
[  288.213717]  __dev_close_many+0x4f/0xf0
[  288.213720]  dev_close_many+0x7b/0x120
[  288.213722]  ? mutex_lock+0xe/0x30
[  288.213725]  dev_close+0x56/0x80
[  288.213727]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.213757]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.213790]  process_one_work+0x1c7/0x380
[  288.213794]  worker_thread+0x4d/0x380
[  288.213797]  ? process_one_work+0x380/0x380
[  288.213799]  kthread+0xe9/0x110
[  288.213801]  ? kthread_complete_and_exit+0x20/0x20
[  288.213803]  ret_from_fork+0x22/0x30
[  288.213808]  </TASK>
[  288.213809] ---[ end trace 0000000000000000 ]---
[  288.213811] ------------[ cut here ]------------
[  288.213812] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.213837] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.c:335 
drv_ampdu_action+0x14f/0x160 [mac80211]
[  288.213870] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.213914]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.213964] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.213967] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.213968] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.214000] RIP: 0010:drv_ampdu_action+0x14f/0x160 [mac80211]
[  288.214029] Code: ff ff 48 8b 83 88 04 00 00 48 8d b3 a8 04 00 00 48 
c7 c7 40 04 ec c0 c6 05 e1 f7 0d 00 01 48 85 c0 48 0f 45 f0 e8 9c f0 e9 
cf <0f> 0b eb c9 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 44 8d 84 16 ef
[  288.214037] RSP: 0018:ffffba910009b908 EFLAGS: 00010296
[  288.214039] RAX: 0000000000000036 RBX: ffffa00e1a2b89c0 RCX: 
0000000000000000
[  288.214040] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.214042] RBP: ffffa00e07d608e0 R08: 0000000000000000 R09: 
ffffba910009b740
[  288.214043] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
0000000000000000
[  288.214044] R13: ffffba910009b930 R14: 0000000000000000 R15: 
0000000000000000
[  288.214045] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.214046] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.214047] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.214048] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.214049] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.214050] Call Trace:
[  288.214083]  <TASK>
[  288.214084]  ___ieee80211_stop_rx_ba_session+0xae/0x130 [mac80211]
[  288.214118]  ieee80211_sta_tear_down_BA_sessions+0x4a/0xe0 [mac80211]
[  288.214149]  __sta_info_destroy_part1+0x45/0x490 [mac80211]
[  288.214179]  __sta_info_flush+0xbb/0x180 [mac80211]
[  288.214210]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.214251]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.214298]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.214340]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.214373]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.214407]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.214437]  ? dev_printk_emit+0x3e/0x41
[  288.214440]  ? __dev_printk+0x2d/0x67
[  288.214442]  ? _dev_err+0x5c/0x5f
[  288.214445]  ? __slab_free+0xc2/0x2f0
[  288.214448]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.214468]  ? rtnl_is_locked+0x11/0x20
[  288.214470]  ? inetdev_event+0x3a/0x630
[  288.214474]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.214477]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.214479]  ? packet_notifier+0x58/0x1d0
[  288.214481]  raw_notifier_call_chain+0x44/0x60
[  288.214485]  __dev_close_many+0x4f/0xf0
[  288.214489]  dev_close_many+0x7b/0x120
[  288.214490]  ? mutex_lock+0xe/0x30
[  288.214494]  dev_close+0x56/0x80
[  288.214496]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.214528]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.214562]  process_one_work+0x1c7/0x380
[  288.214566]  worker_thread+0x4d/0x380
[  288.214569]  ? process_one_work+0x380/0x380
[  288.214571]  kthread+0xe9/0x110
[  288.214573]  ? kthread_complete_and_exit+0x20/0x20
[  288.214575]  ret_from_fork+0x22/0x30
[  288.214581]  </TASK>
[  288.214581] ---[ end trace 0000000000000000 ]---
[  288.214583] wlp4s0: HW problem - can not stop rx aggregation for 
24:f5:a2:ab:db:43 tid 0
[  288.214586] wlp4s0: HW problem - can not stop rx aggregation for 
24:f5:a2:ab:db:43 tid 6
[  288.214644] ------------[ cut here ]------------
[  288.214645] WARNING: CPU: 0 PID: 6 at net/mac80211/agg-tx.c:407 
___ieee80211_stop_tx_ba_session+0x1ef/0x210 [mac80211]
[  288.214685] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.214736]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.214791] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.214793] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.214795] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.214829] RIP: 0010:___ieee80211_stop_tx_ba_session+0x1ef/0x210 
[mac80211]
[  288.214866] Code: cf e9 63 ff ff ff 49 c7 87 90 07 00 00 00 00 00 00 
4c 89 ef e8 e2 02 f1 cf 31 f6 48 89 ef e8 c8 b1 33 cf 31 c0 e9 70 ff ff 
ff <0f> 0b 31 c0 e9 67 ff ff ff b8 8e ff ff ff eb b2 4c 89 ef e8 b9 02
[  288.214868] RSP: 0018:ffffba910009b928 EFLAGS: 00010282
[  288.214870] RAX: 00000000fffffffb RBX: ffffa00e4cff8000 RCX: 
0000000000000000
[  288.214871] RDX: 0000000000000000 RSI: ffffa00e1a2b89c0 RDI: 
ffffa00e07d608e0
[  288.214873] RBP: ffffa00e7bfd9b40 R08: ffffffff91f53b48 R09: 
0000000000000000
[  288.214874] R10: 0000000000000001 R11: 0000000000000000 R12: 
0000000000000003
[  288.214875] R13: ffffa00e4cff80d4 R14: ffffa00e07d608e0 R15: 
ffffa00e4cffe0f0
[  288.214877] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.214879] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.214881] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.214882] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.214883] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.214885] Call Trace:
[  288.214887]  <TASK>
[  288.214889]  ieee80211_sta_tear_down_BA_sessions+0x61/0xe0 [mac80211]
[  288.214925]  __sta_info_destroy_part1+0x45/0x490 [mac80211]
[  288.214957]  __sta_info_flush+0xbb/0x180 [mac80211]
[  288.214988]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.215043]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.215093]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.215140]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.215177]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.215215]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.215248]  ? dev_printk_emit+0x3e/0x41
[  288.215252]  ? __dev_printk+0x2d/0x67
[  288.215256]  ? _dev_err+0x5c/0x5f
[  288.215258]  ? __slab_free+0xc2/0x2f0
[  288.215262]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.215282]  ? rtnl_is_locked+0x11/0x20
[  288.215285]  ? inetdev_event+0x3a/0x630
[  288.215288]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.215291]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.215293]  ? packet_notifier+0x58/0x1d0
[  288.215296]  raw_notifier_call_chain+0x44/0x60
[  288.215300]  __dev_close_many+0x4f/0xf0
[  288.215304]  dev_close_many+0x7b/0x120
[  288.215306]  ? mutex_lock+0xe/0x30
[  288.215309]  dev_close+0x56/0x80
[  288.215312]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.215345]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.215382]  process_one_work+0x1c7/0x380
[  288.215386]  worker_thread+0x4d/0x380
[  288.215390]  ? process_one_work+0x380/0x380
[  288.215392]  kthread+0xe9/0x110
[  288.215394]  ? kthread_complete_and_exit+0x20/0x20
[  288.215397]  ret_from_fork+0x22/0x30
[  288.215403]  </TASK>
[  288.215404] ---[ end trace 0000000000000000 ]---
[  288.215409] ------------[ cut here ]------------
[  288.215410] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.215443] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.h:514 
__sta_info_destroy_part1+0x424/0x490 [mac80211]
[  288.215479] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.215530]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.215601] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.215603] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.215605] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.215636] RIP: 0010:__sta_info_destroy_part1+0x424/0x490 [mac80211]
[  288.215665] Code: 49 8b 84 24 88 04 00 00 49 8d b4 24 a8 04 00 00 48 
c7 c7 a0 04 ec c0 c6 05 00 e5 0d 00 01 48 85 c0 48 0f 45 f0 e8 a7 dd e9 
cf <0f> 0b e9 2b fd ff ff 0f 1f 44 00 00 e9 dd fd ff ff 80 3d da e4 0d
[  288.215667] RSP: 0018:ffffba910009b9b8 EFLAGS: 00010296
[  288.215669] RAX: 0000000000000036 RBX: 0000000000000000 RCX: 
0000000000000000
[  288.215670] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.215671] RBP: ffffa00e4cff8000 R08: 0000000000000000 R09: 
ffffba910009b7f0
[  288.215672] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
ffffa00e1a2b89c0
[  288.215674] R13: ffffa00e4cff8030 R14: ffffa00e07d608e0 R15: 
ffffa00e08f1dea0
[  288.215675] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.215676] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.215678] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.215679] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.215680] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.215682] Call Trace:
[  288.215683]  <TASK>
[  288.215684]  __sta_info_flush+0xbb/0x180 [mac80211]
[  288.215716]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.215757]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.215836]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.215874]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.215907]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.215941]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.215971]  ? dev_printk_emit+0x3e/0x41
[  288.215974]  ? __dev_printk+0x2d/0x67
[  288.215976]  ? _dev_err+0x5c/0x5f
[  288.215978]  ? __slab_free+0xc2/0x2f0
[  288.215981]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.216001]  ? rtnl_is_locked+0x11/0x20
[  288.216003]  ? inetdev_event+0x3a/0x630
[  288.216005]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.216008]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.216010]  ? packet_notifier+0x58/0x1d0
[  288.216012]  raw_notifier_call_chain+0x44/0x60
[  288.216015]  __dev_close_many+0x4f/0xf0
[  288.216019]  dev_close_many+0x7b/0x120
[  288.216021]  ? mutex_lock+0xe/0x30
[  288.216024]  dev_close+0x56/0x80
[  288.216027]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.216060]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.216090]  process_one_work+0x1c7/0x380
[  288.216093]  worker_thread+0x4d/0x380
[  288.216096]  ? process_one_work+0x380/0x380
[  288.216098]  kthread+0xe9/0x110
[  288.216100]  ? kthread_complete_and_exit+0x20/0x20
[  288.216102]  ret_from_fork+0x22/0x30
[  288.216106]  </TASK>
[  288.216106] ---[ end trace 0000000000000000 ]---
[  288.216120] ------------[ cut here ]------------
[  288.216120] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.216144] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.c:118 
drv_sta_state+0x469/0x530 [mac80211]
[  288.216174] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.216216]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.216267] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.216270] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.216271] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.216303] RIP: 0010:drv_sta_state+0x469/0x530 [mac80211]
[  288.216332] Code: ff ff 48 8b 83 88 04 00 00 48 8d b3 a8 04 00 00 48 
c7 c7 40 04 ec c0 c6 05 d0 04 0e 00 01 48 85 c0 48 0f 45 f0 e8 82 fd e9 
cf <0f> 0b e9 d3 fd ff ff 80 3d bb 04 0e 00 00 74 71 41 bc fb ff ff ff
[  288.216334] RSP: 0018:ffffba910009b988 EFLAGS: 00010292
[  288.216336] RAX: 0000000000000036 RBX: ffffa00e1a2b89c0 RCX: 
0000000000000000
[  288.216337] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.216338] RBP: ffffa00e07d608e0 R08: 0000000000000000 R09: 
ffffba910009b7c0
[  288.216339] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
0000000000000004
[  288.216340] R13: 0000000000000003 R14: ffffa00e4cff8000 R15: 
ffffa00e07d61018
[  288.216342] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.216343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.216345] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.216346] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.216347] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.216348] Call Trace:
[  288.216350]  <TASK>
[  288.216351]  sta_info_move_state+0x1ca/0x290 [mac80211]
[  288.216382]  __sta_info_destroy_part2+0x14a/0x160 [mac80211]
[  288.216412]  __sta_info_flush+0x136/0x180 [mac80211]
[  288.216470]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.216512]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.216559]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.216601]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.216635]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.216669]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.216698]  ? dev_printk_emit+0x3e/0x41
[  288.216701]  ? __dev_printk+0x2d/0x67
[  288.216704]  ? _dev_err+0x5c/0x5f
[  288.216706]  ? __slab_free+0xc2/0x2f0
[  288.216710]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.216729]  ? rtnl_is_locked+0x11/0x20
[  288.216732]  ? inetdev_event+0x3a/0x630
[  288.216734]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.216737]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.216739]  ? packet_notifier+0x58/0x1d0
[  288.216742]  raw_notifier_call_chain+0x44/0x60
[  288.216745]  __dev_close_many+0x4f/0xf0
[  288.216748]  dev_close_many+0x7b/0x120
[  288.216750]  ? mutex_lock+0xe/0x30
[  288.216754]  dev_close+0x56/0x80
[  288.216756]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.216786]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.216819]  process_one_work+0x1c7/0x380
[  288.216823]  worker_thread+0x4d/0x380
[  288.216826]  ? process_one_work+0x380/0x380
[  288.216828]  kthread+0xe9/0x110
[  288.216830]  ? kthread_complete_and_exit+0x20/0x20
[  288.216832]  ret_from_fork+0x22/0x30
[  288.216837]  </TASK>
[  288.216838] ---[ end trace 0000000000000000 ]---
[  288.216866] ------------[ cut here ]------------
[  288.216867] WARNING: CPU: 0 PID: 6 at net/mac80211/sta_info.c:1070 
__sta_info_destroy_part2+0x152/0x160 [mac80211]
[  288.216900] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.216946]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.216996] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.216998] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.217000] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.217029] RIP: 0010:__sta_info_destroy_part2+0x152/0x160 [mac80211]
[  288.217064] Code: ef e8 12 a5 ff ff 85 c0 0f 84 4b ff ff ff 0f 0b e9 
44 ff ff ff be 03 00 00 00 48 89 df e8 66 e6 ff ff 85 c0 0f 84 d4 fe ff 
ff <0f> 0b e9 cd fe ff ff 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89
[  288.217065] RSP: 0018:ffffba910009b9d8 EFLAGS: 00010282
[  288.217067] RAX: 00000000fffffffb RBX: ffffa00e4cff8000 RCX: 
0000000000000000
[  288.217069] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.217070] RBP: ffffa00e07d608e0 R08: 0000000000000000 R09: 
ffffba910009b7c0
[  288.217071] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
ffffa00e1a2b89c0
[  288.217072] R13: ffffa00e1a2b89c0 R14: 0000000000000001 R15: 
ffffa00e07d61018
[  288.217073] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.217075] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.217076] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.217077] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.217078] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.217079] Call Trace:
[  288.217080]  <TASK>
[  288.217082]  __sta_info_flush+0x136/0x180 [mac80211]
[  288.217113]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.217154]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.217201]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.217242]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.217275]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.217309]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.217338]  ? dev_printk_emit+0x3e/0x41
[  288.217341]  ? __dev_printk+0x2d/0x67
[  288.217344]  ? _dev_err+0x5c/0x5f
[  288.217346]  ? __slab_free+0xc2/0x2f0
[  288.217349]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.217368]  ? rtnl_is_locked+0x11/0x20
[  288.217370]  ? inetdev_event+0x3a/0x630
[  288.217373]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.217376]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.217378]  ? packet_notifier+0x58/0x1d0
[  288.217380]  raw_notifier_call_chain+0x44/0x60
[  288.217383]  __dev_close_many+0x4f/0xf0
[  288.217387]  dev_close_many+0x7b/0x120
[  288.217389]  ? mutex_lock+0xe/0x30
[  288.217392]  dev_close+0x56/0x80
[  288.217394]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.217424]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.217456]  process_one_work+0x1c7/0x380
[  288.217459]  worker_thread+0x4d/0x380
[  288.217462]  ? process_one_work+0x380/0x380
[  288.217464]  kthread+0xe9/0x110
[  288.217466]  ? kthread_complete_and_exit+0x20/0x20
[  288.217468]  ret_from_fork+0x22/0x30
[  288.217472]  </TASK>
[  288.217473] ---[ end trace 0000000000000000 ]---
[  288.217492] ------------[ cut here ]------------
[  288.217493] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.217517] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.h:248 
drv_set_key+0x151/0x160 [mac80211]
[  288.217553] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.217597]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.217648] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.217650] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.217652] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.217681] RIP: 0010:drv_set_key+0x151/0x160 [mac80211]
[  288.217716] Code: ff ff 48 8b 83 88 04 00 00 48 8d b3 a8 04 00 00 48 
c7 c7 08 12 ec c0 c6 05 31 a2 0a 00 01 48 85 c0 48 0f 45 f0 e8 aa 9a e6 
cf <0f> 0b eb ca 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54
[  288.217718] RSP: 0018:ffffba910009b928 EFLAGS: 00010292
[  288.217720] RAX: 0000000000000036 RBX: ffffa00e1a2b89c0 RCX: 
0000000000000000
[  288.217721] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.217722] RBP: ffffa00e07d608e0 R08: 0000000000000000 R09: 
ffffba910009b760
[  288.217723] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
0000000000000001
[  288.217724] R13: ffffa00e4cff8a60 R14: ffffa00e65d81a30 R15: 
ffffa00e1a2b89c0
[  288.217725] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.217727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.217728] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.217729] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.217731] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.217732] Call Trace:
[  288.217733]  <TASK>
[  288.217734]  ieee80211_key_replace+0x30f/0x7d0 [mac80211]
[  288.217769]  ieee80211_free_sta_keys+0xa7/0xe0 [mac80211]
[  288.217804]  __sta_info_destroy_part2+0x31/0x160 [mac80211]
[  288.217834]  __sta_info_flush+0x136/0x180 [mac80211]
[  288.217865]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.217905]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.217952]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.217989]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.218022]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.218073]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.218118]  ? dev_printk_emit+0x3e/0x41
[  288.218121]  ? __dev_printk+0x2d/0x67
[  288.218124]  ? _dev_err+0x5c/0x5f
[  288.218126]  ? __slab_free+0xc2/0x2f0
[  288.218129]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.218151]  ? rtnl_is_locked+0x11/0x20
[  288.218153]  ? inetdev_event+0x3a/0x630
[  288.218156]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.218158]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.218161]  ? packet_notifier+0x58/0x1d0
[  288.218163]  raw_notifier_call_chain+0x44/0x60
[  288.218166]  __dev_close_many+0x4f/0xf0
[  288.218170]  dev_close_many+0x7b/0x120
[  288.218172]  ? mutex_lock+0xe/0x30
[  288.218176]  dev_close+0x56/0x80
[  288.218178]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.218210]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.218243]  process_one_work+0x1c7/0x380
[  288.218247]  worker_thread+0x4d/0x380
[  288.218250]  ? process_one_work+0x380/0x380
[  288.218253]  kthread+0xe9/0x110
[  288.218255]  ? kthread_complete_and_exit+0x20/0x20
[  288.218257]  ret_from_fork+0x22/0x30
[  288.218261]  </TASK>
[  288.218262] ---[ end trace 0000000000000000 ]---
[  288.218263] wlp4s0: failed to remove key (0, 24:f5:a2:ab:db:43) from 
hardware (-5)
[  288.218319] ------------[ cut here ]------------
[  288.218320] WARNING: CPU: 0 PID: 6 at net/mac80211/sta_info.c:1087 
__sta_info_destroy_part2+0x109/0x160 [mac80211]
[  288.218355] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.218400]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.218450] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.218453] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.218454] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.218486] RIP: 0010:__sta_info_destroy_part2+0x109/0x160 [mac80211]
[  288.218519] Code: 09 00 00 e8 d9 57 02 00 48 8b 43 50 48 89 df 48 8b 
a8 90 04 00 00 e8 a6 b8 ff ff 48 89 de 5b 48 89 ef 5d 41 5c e9 37 e9 ff 
ff <0f> 0b 80 bb 1c 01 00 00 00 0f 84 69 ff ff ff 45 31 c0 b9 01 00 00
[  288.218521] RSP: 0018:ffffba910009b9d8 EFLAGS: 00010282
[  288.218523] RAX: 00000000fffffffb RBX: ffffa00e4cff8000 RCX: 
0000000000000004
[  288.218524] RDX: 0000000000000000 RSI: ffffa00e1a2b89c0 RDI: 
ffffa00e07d608e0
[  288.218526] RBP: ffffa00e07d608e0 R08: 0000000000000003 R09: 
000000008010000f
[  288.218527] R10: 0000000000000000 R11: ffffffff91f453e8 R12: 
ffffa00e1a2b89c0
[  288.218528] R13: ffffa00e1a2b89c0 R14: 0000000000000001 R15: 
ffffa00e07d61018
[  288.218530] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.218532] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.218533] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.218534] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.218536] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.218537] Call Trace:
[  288.218538]  <TASK>
[  288.218539]  __sta_info_flush+0x136/0x180 [mac80211]
[  288.218573]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.218619]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.218670]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.218711]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.218748]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.218784]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.218815]  ? dev_printk_emit+0x3e/0x41
[  288.218819]  ? __dev_printk+0x2d/0x67
[  288.218821]  ? _dev_err+0x5c/0x5f
[  288.218823]  ? __slab_free+0xc2/0x2f0
[  288.218826]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.218847]  ? rtnl_is_locked+0x11/0x20
[  288.218849]  ? inetdev_event+0x3a/0x630
[  288.218852]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.218854]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.218857]  ? packet_notifier+0x58/0x1d0
[  288.218859]  raw_notifier_call_chain+0x44/0x60
[  288.218862]  __dev_close_many+0x4f/0xf0
[  288.218866]  dev_close_many+0x7b/0x120
[  288.218868]  ? mutex_lock+0xe/0x30
[  288.218872]  dev_close+0x56/0x80
[  288.218874]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.218907]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.218940]  process_one_work+0x1c7/0x380
[  288.218944]  worker_thread+0x4d/0x380
[  288.218947]  ? process_one_work+0x380/0x380
[  288.218949]  kthread+0xe9/0x110
[  288.218951]  ? kthread_complete_and_exit+0x20/0x20
[  288.218954]  ret_from_fork+0x22/0x30
[  288.218958]  </TASK>
[  288.218959] ---[ end trace 0000000000000000 ]---
[  288.218980] ------------[ cut here ]------------
[  288.218981] WARNING: CPU: 0 PID: 6 at net/mac80211/sta_info.c:1095 
__sta_info_destroy_part2+0x136/0x160 [mac80211]
[  288.219016] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.219064]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.219114] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.219117] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.219118] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.219152] RIP: 0010:__sta_info_destroy_part2+0x136/0x160 [mac80211]
[  288.219185] Code: bb 1c 01 00 00 00 0f 84 69 ff ff ff 45 31 c0 b9 01 
00 00 00 48 89 da 4c 89 e6 48 89 ef e8 12 a5 ff ff 85 c0 0f 84 4b ff ff 
ff <0f> 0b e9 44 ff ff ff be 03 00 00 00 48 89 df e8 66 e6 ff ff 85 c0
[  288.219187] RSP: 0018:ffffba910009b9d8 EFLAGS: 00010282
[  288.219189] RAX: 00000000fffffffb RBX: ffffa00e4cff8000 RCX: 
0000000000000001
[  288.219191] RDX: 0000000000000000 RSI: ffffa00e1a2b89c0 RDI: 
ffffa00e07d608e0
[  288.219192] RBP: ffffa00e07d608e0 R08: 0000000000000000 R09: 
000000008010000f
[  288.219194] R10: 0000000000000000 R11: ffffffff91f453e8 R12: 
ffffa00e1a2b89c0
[  288.219195] R13: ffffa00e1a2b89c0 R14: 0000000000000001 R15: 
ffffa00e07d61018
[  288.219196] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.219198] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.219199] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.219201] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.219202] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.219203] Call Trace:
[  288.219204]  <TASK>
[  288.219206]  __sta_info_flush+0x136/0x180 [mac80211]
[  288.219240]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.219286]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.219338]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.219380]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.219417]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.219455]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.219487]  ? dev_printk_emit+0x3e/0x41
[  288.219490]  ? __dev_printk+0x2d/0x67
[  288.219493]  ? _dev_err+0x5c/0x5f
[  288.219496]  ? __slab_free+0xc2/0x2f0
[  288.219499]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.219520]  ? rtnl_is_locked+0x11/0x20
[  288.219522]  ? inetdev_event+0x3a/0x630
[  288.219525]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.219528]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.219530]  ? packet_notifier+0x58/0x1d0
[  288.219532]  raw_notifier_call_chain+0x44/0x60
[  288.219535]  __dev_close_many+0x4f/0xf0
[  288.219539]  dev_close_many+0x7b/0x120
[  288.219541]  ? mutex_lock+0xe/0x30
[  288.219545]  dev_close+0x56/0x80
[  288.219547]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.219580]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.219615]  process_one_work+0x1c7/0x380
[  288.219619]  worker_thread+0x4d/0x380
[  288.219622]  ? process_one_work+0x380/0x380
[  288.219625]  kthread+0xe9/0x110
[  288.219627]  ? kthread_complete_and_exit+0x20/0x20
[  288.219629]  ret_from_fork+0x22/0x30
[  288.219634]  </TASK>
[  288.219635] ---[ end trace 0000000000000000 ]---
[  288.219637] ------------[ cut here ]------------
[  288.219638] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.219662] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.h:561 
sta_set_sinfo+0xae3/0xb30 [mac80211]
[  288.219696] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.219744]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.219795] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.219797] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.219798] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.219830] RIP: 0010:sta_set_sinfo+0xae3/0xb30 [mac80211]
[  288.219864] Code: ff ff 48 8b 83 88 04 00 00 48 8d b3 a8 04 00 00 48 
c7 c7 a0 04 ec c0 c6 05 d0 af 0d 00 01 48 85 c0 48 0f 45 f0 e8 78 a8 e9 
cf <0f> 0b e9 d3 f5 ff ff 83 e2 0f 41 88 57 45 48 89 c2 48 c1 e8 0c 48
[  288.219866] RSP: 0018:ffffba910009b978 EFLAGS: 00010296
[  288.219868] RAX: 0000000000000036 RBX: ffffa00e1a2b89c0 RCX: 
0000000000000000
[  288.219869] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.219871] RBP: ffffa00e1a2b89c0 R08: 0000000000000000 R09: 
ffffba910009b7b0
[  288.219872] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
ffffa00e4cff8218
[  288.219873] R13: ffffa00e4cff8000 R14: ffffa00e4cff8a60 R15: 
ffffa00e389cec00
[  288.219875] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.219877] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.219878] CR2: 00007fabc11e56f0 CR3: 000000048fe10004 CR4: 
00000000003706f0
[  288.219880] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.219881] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.219882] Call Trace:
[  288.219883]  <TASK>
[  288.219885]  ? __sta_info_destroy_part2+0x97/0x160 [mac80211]
[  288.219917]  ? kmem_cache_alloc_trace+0x16c/0x2b0
[  288.219921]  __sta_info_destroy_part2+0xaf/0x160 [mac80211]
[  288.219955]  __sta_info_flush+0x136/0x180 [mac80211]
[  288.219988]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.220079]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.220132]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.220184]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.220217]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.220251]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.220280]  ? dev_printk_emit+0x3e/0x41
[  288.220283]  ? __dev_printk+0x2d/0x67
[  288.220285]  ? _dev_err+0x5c/0x5f
[  288.220287]  ? __slab_free+0xc2/0x2f0
[  288.220290]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.220308]  ? rtnl_is_locked+0x11/0x20
[  288.220310]  ? inetdev_event+0x3a/0x630
[  288.220313]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.220315]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.220317]  ? packet_notifier+0x58/0x1d0
[  288.220319]  raw_notifier_call_chain+0x44/0x60
[  288.220322]  __dev_close_many+0x4f/0xf0
[  288.220325]  dev_close_many+0x7b/0x120
[  288.220327]  ? mutex_lock+0xe/0x30
[  288.220330]  dev_close+0x56/0x80
[  288.220332]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.220361]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.220391]  process_one_work+0x1c7/0x380
[  288.220394]  worker_thread+0x4d/0x380
[  288.220397]  ? process_one_work+0x380/0x380
[  288.220399]  kthread+0xe9/0x110
[  288.220401]  ? kthread_complete_and_exit+0x20/0x20
[  288.220403]  ret_from_fork+0x22/0x30
[  288.220407]  </TASK>
[  288.220408] ---[ end trace 0000000000000000 ]---
[  288.220681] ------------[ cut here ]------------
[  288.220682] WARNING: CPU: 0 PID: 6 at net/mac80211/sta_info.c:272 
sta_info_free+0x33/0xe0 [mac80211]
[  288.220715] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.220756]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.220805] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.220807] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.220808] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.220838] RIP: 0010:sta_info_free+0x33/0xe0 [mac80211]
[  288.220868] Code: eb 0f 83 ee 01 48 89 df e8 5a fd ff ff 85 c0 75 2a 
8b b3 20 01 00 00 83 fe 01 76 28 48 8b 83 28 01 00 00 a9 00 00 10 00 74 
d8 <0f> 0b 83 ee 01 48 89 df e8 30 fd ff ff 85 c0 74 d6 80 3d e9 c4 0d
[  288.220870] RSP: 0018:ffffba910009b9e8 EFLAGS: 00010206
[  288.220872] RAX: 000000000430010b RBX: ffffa00e4cff8000 RCX: 
0000000080150014
[  288.220873] RDX: 0000000000000001 RSI: 0000000000000004 RDI: 
ffffa00e07d608e0
[  288.220874] RBP: ffffa00e07d61018 R08: 0000000000000000 R09: 
0000000080150014
[  288.220876] R10: ffffffff91e060f8 R11: ffffa00e902a0280 R12: 
ffffba910009ba18
[  288.220877] R13: ffffa00e1a2b89c0 R14: 0000000000000001 R15: 
ffffa00e07d61018
[  288.220878] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.220880] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.220881] CR2: 00007fabc11e56f0 CR3: 00000001036c6006 CR4: 
00000000003706f0
[  288.220882] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.220884] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.220885] Call Trace:
[  288.220886]  <TASK>
[  288.220887]  __sta_info_flush+0x136/0x180 [mac80211]
[  288.220919]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.220961]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.221009]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.221051]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.221083]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.221114]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.221141]  ? dev_printk_emit+0x3e/0x41
[  288.221143]  ? __dev_printk+0x2d/0x67
[  288.221146]  ? _dev_err+0x5c/0x5f
[  288.221148]  ? __slab_free+0xc2/0x2f0
[  288.221150]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.221167]  ? rtnl_is_locked+0x11/0x20
[  288.221169]  ? inetdev_event+0x3a/0x630
[  288.221172]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.221174]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.221175]  ? packet_notifier+0x58/0x1d0
[  288.221177]  raw_notifier_call_chain+0x44/0x60
[  288.221180]  __dev_close_many+0x4f/0xf0
[  288.221183]  dev_close_many+0x7b/0x120
[  288.221185]  ? mutex_lock+0xe/0x30
[  288.221188]  dev_close+0x56/0x80
[  288.221190]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.221218]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.221248]  process_one_work+0x1c7/0x380
[  288.221252]  worker_thread+0x4d/0x380
[  288.221254]  ? process_one_work+0x380/0x380
[  288.221256]  kthread+0xe9/0x110
[  288.221258]  ? kthread_complete_and_exit+0x20/0x20
[  288.221261]  ret_from_fork+0x22/0x30
[  288.221265]  </TASK>
[  288.221266] ---[ end trace 0000000000000000 ]---
[  288.221268] ------------[ cut here ]------------
[  288.221268] sta_info_move_state() returned -5
[  288.221288] WARNING: CPU: 0 PID: 6 at net/mac80211/sta_info.c:275 
sta_info_free+0xd1/0xe0 [mac80211]
[  288.221318] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.221358]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.221403] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.221405] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.221406] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.221435] RIP: 0010:sta_info_free+0xd1/0xe0 [mac80211]
[  288.221464] Code: 48 8b bb e8 00 00 00 e8 cd 15 4a cf 48 89 df 5b e9 
84 1f 51 cf 89 c6 48 c7 c7 10 05 ec c0 c6 05 68 c4 0d 00 01 e8 1a bd e9 
cf <0f> 0b e9 75 ff ff ff 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
[  288.221466] RSP: 0018:ffffba910009b9e8 EFLAGS: 00010292
[  288.221468] RAX: 0000000000000021 RBX: ffffa00e4cff8000 RCX: 
0000000000000000
[  288.221469] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.221470] RBP: ffffa00e07d61018 R08: 0000000000000000 R09: 
ffffba910009b820
[  288.221472] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
ffffba910009ba18
[  288.221473] R13: ffffa00e1a2b89c0 R14: 0000000000000001 R15: 
ffffa00e07d61018
[  288.221474] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.221476] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.221477] CR2: 00007fabc11e56f0 CR3: 00000001036c6006 CR4: 
00000000003706f0
[  288.221478] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.221479] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.221480] Call Trace:
[  288.221481]  <TASK>
[  288.221482]  __sta_info_flush+0x136/0x180 [mac80211]
[  288.221542]  ieee80211_set_disassoc+0x128/0x520 [mac80211]
[  288.221584]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.221631]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.221666]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.221699]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.221733]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.221762]  ? dev_printk_emit+0x3e/0x41
[  288.221765]  ? __dev_printk+0x2d/0x67
[  288.221767]  ? _dev_err+0x5c/0x5f
[  288.221769]  ? __slab_free+0xc2/0x2f0
[  288.221772]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.221791]  ? rtnl_is_locked+0x11/0x20
[  288.221793]  ? inetdev_event+0x3a/0x630
[  288.221796]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.221798]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.221800]  ? packet_notifier+0x58/0x1d0
[  288.221802]  raw_notifier_call_chain+0x44/0x60
[  288.221805]  __dev_close_many+0x4f/0xf0
[  288.221808]  dev_close_many+0x7b/0x120
[  288.221810]  ? mutex_lock+0xe/0x30
[  288.221814]  dev_close+0x56/0x80
[  288.221816]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.221845]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.221875]  process_one_work+0x1c7/0x380
[  288.221878]  worker_thread+0x4d/0x380
[  288.221881]  ? process_one_work+0x380/0x380
[  288.221883]  kthread+0xe9/0x110
[  288.221885]  ? kthread_complete_and_exit+0x20/0x20
[  288.221887]  ret_from_fork+0x22/0x30
[  288.221891]  </TASK>
[  288.221892] ---[ end trace 0000000000000000 ]---
[  288.221898] ------------[ cut here ]------------
[  288.221899] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.221925] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.c:190 
drv_conf_tx+0x180/0x1c0 [mac80211]
[  288.221956] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.221996]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.222058] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.222061] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.222062] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.222092] RIP: 0010:drv_conf_tx+0x180/0x1c0 [mac80211]
[  288.222121] Code: ff ff 48 8b 83 88 04 00 00 48 8d b3 a8 04 00 00 48 
c7 c7 40 04 ec c0 c6 05 c6 ff 0d 00 01 48 85 c0 48 0f 45 f0 e8 7b f8 e9 
cf <0f> 0b eb ad 80 3d ae ff 0d 00 00 75 c0 0f b7 4d 04 0f b7 d0 48 8d
[  288.222123] RSP: 0018:ffffba910009b9d0 EFLAGS: 00010286
[  288.222125] RAX: 0000000000000036 RBX: ffffa00e1a2b89c0 RCX: 
0000000000000000
[  288.222126] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.222128] RBP: ffffba910009ba1a R08: 0000000000000000 R09: 
ffffba910009b808
[  288.222129] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
0000000000000000
[  288.222130] R13: ffffa00e07d608e0 R14: 0000000000000000 R15: 
ffffa00e1a2b89c0
[  288.222131] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.222133] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.222134] CR2: 00007fabc11e56f0 CR3: 00000001036c6006 CR4: 
00000000003706f0
[  288.222135] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.222136] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.222138] Call Trace:
[  288.222139]  <TASK>
[  288.222140]  ieee80211_set_wmm_default+0x177/0x310 [mac80211]
[  288.222180]  ieee80211_set_disassoc+0x28e/0x520 [mac80211]
[  288.222221]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.222269]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.222308]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.222341]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.222376]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.222406]  ? dev_printk_emit+0x3e/0x41
[  288.222409]  ? __dev_printk+0x2d/0x67
[  288.222411]  ? _dev_err+0x5c/0x5f
[  288.222414]  ? __slab_free+0xc2/0x2f0
[  288.222417]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.222437]  ? rtnl_is_locked+0x11/0x20
[  288.222439]  ? inetdev_event+0x3a/0x630
[  288.222442]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.222444]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.222446]  ? packet_notifier+0x58/0x1d0
[  288.222448]  raw_notifier_call_chain+0x44/0x60
[  288.222452]  __dev_close_many+0x4f/0xf0
[  288.222455]  dev_close_many+0x7b/0x120
[  288.222457]  ? mutex_lock+0xe/0x30
[  288.222461]  dev_close+0x56/0x80
[  288.222463]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.222493]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.222526]  process_one_work+0x1c7/0x380
[  288.222530]  worker_thread+0x4d/0x380
[  288.222532]  ? process_one_work+0x380/0x380
[  288.222534]  kthread+0xe9/0x110
[  288.222536]  ? kthread_complete_and_exit+0x20/0x20
[  288.222538]  ret_from_fork+0x22/0x30
[  288.222543]  </TASK>
[  288.222544] ---[ end trace 0000000000000000 ]---
[  288.222591] ------------[ cut here ]------------
[  288.222592] wlp4s0: Failed check-sdata-in-driver check, flags: 0x0
[  288.222619] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.h:945 
ieee80211_assign_vif_chanctx+0x412/0x470 [mac80211]
[  288.222656] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.222689]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.222735] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.222737] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.222738] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.222769] RIP: 0010:ieee80211_assign_vif_chanctx+0x412/0x470 [mac80211]
[  288.222806] Code: ff ff 48 8b 83 88 04 00 00 48 8d b3 a8 04 00 00 48 
c7 c7 a8 15 ec c0 c6 05 dc de 09 00 01 48 85 c0 48 0f 45 f0 e8 49 d7 e5 
cf <0f> 0b e9 76 fc ff ff 80 3d c3 de 09 00 00 74 20 b8 01 00 00 00 41
[  288.222808] RSP: 0018:ffffba910009b9e0 EFLAGS: 00010282
[  288.222810] RAX: 0000000000000036 RBX: ffffa00e1a2b89c0 RCX: 
0000000000000000
[  288.222812] RDX: 0000000000000001 RSI: ffffffff9166ec4c RDI: 
00000000ffffffff
[  288.222813] RBP: ffffa00e07d608e0 R08: 0000000000000000 R09: 
ffffba910009b818
[  288.222814] R10: 0000000000000003 R11: ffffffff91f453e8 R12: 
ffffa00e7bfd9e40
[  288.222815] R13: 0000000000000000 R14: ffffa00e7bfd9e98 R15: 
ffffa00e1a2b89c0
[  288.222817] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.222819] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.222820] CR2: 00007fabc11e56f0 CR3: 0000000104b80001 CR4: 
00000000003706f0
[  288.222822] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.222823] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.222824] Call Trace:
[  288.222825]  <TASK>
[  288.222826]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.222830]  __ieee80211_vif_release_channel+0x4f/0x130 [mac80211]
[  288.222868]  ieee80211_vif_release_channel+0x3a/0x50 [mac80211]
[  288.222905]  ieee80211_set_disassoc+0x2f4/0x520 [mac80211]
[  288.222946]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.222995]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.223044]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.223078]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.223113]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.223142]  ? dev_printk_emit+0x3e/0x41
[  288.223146]  ? __dev_printk+0x2d/0x67
[  288.223149]  ? _dev_err+0x5c/0x5f
[  288.223151]  ? __slab_free+0xc2/0x2f0
[  288.223154]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.223174]  ? rtnl_is_locked+0x11/0x20
[  288.223177]  ? inetdev_event+0x3a/0x630
[  288.223180]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.223214]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.223217]  ? packet_notifier+0x58/0x1d0
[  288.223219]  raw_notifier_call_chain+0x44/0x60
[  288.223223]  __dev_close_many+0x4f/0xf0
[  288.223227]  dev_close_many+0x7b/0x120
[  288.223228]  ? mutex_lock+0xe/0x30
[  288.223231]  dev_close+0x56/0x80
[  288.223234]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.223265]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.223298]  process_one_work+0x1c7/0x380
[  288.223302]  worker_thread+0x4d/0x380
[  288.223305]  ? process_one_work+0x380/0x380
[  288.223307]  kthread+0xe9/0x110
[  288.223309]  ? kthread_complete_and_exit+0x20/0x20
[  288.223312]  ret_from_fork+0x22/0x30
[  288.223317]  </TASK>
[  288.223317] ---[ end trace 0000000000000000 ]---
[  288.223417] ------------[ cut here ]------------
[  288.223418] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.h:894 
ieee80211_del_chanctx+0x169/0x170 [mac80211]
[  288.223462] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.223509]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.223577] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.223579] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.223581] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.223614] RIP: 0010:ieee80211_del_chanctx+0x169/0x170 [mac80211]
[  288.223654] Code: 7a 1b 3f 0f 85 6e ff ff ff 0f 1f 44 00 00 e9 64 ff 
ff ff e8 b9 4d b4 ff 48 8b bb e8 13 00 00 89 83 f0 13 00 00 e9 c4 fe ff 
ff <0f> 0b e9 07 ff ff ff 0f 1f 44 00 00 55 4c 8d 46 30 48 89 f5 53 48
[  288.223656] RSP: 0018:ffffba910009b9f8 EFLAGS: 00010246
[  288.223658] RAX: 0000000000000000 RBX: ffffa00e07d608e0 RCX: 
ffffa00e07d61cf0
[  288.223659] RDX: 0000000080000000 RSI: ffffa00e7bfd9e40 RDI: 
ffffa00e07d608e0
[  288.223661] RBP: ffffa00e7bfd9e40 R08: ffffa00e7bfd9e70 R09: 
ffffa00e7bfd9e70
[  288.223662] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffffa00e1a2b89c0
[  288.223663] R13: ffffa00e7bfd9e98 R14: ffffa00e07d61b78 R15: 
ffffa00e1a2b89c0
[  288.223664] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.223666] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.223667] CR2: 00007fabc11e56f0 CR3: 0000000104b80001 CR4: 
00000000003706f0
[  288.223668] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.223670] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.223671] Call Trace:
[  288.223672]  <TASK>
[  288.223674]  ieee80211_free_chanctx+0xa3/0xd0 [mac80211]
[  288.223714]  __ieee80211_vif_release_channel+0xee/0x130 [mac80211]
[  288.223752]  ieee80211_vif_release_channel+0x3a/0x50 [mac80211]
[  288.223792]  ieee80211_set_disassoc+0x2f4/0x520 [mac80211]
[  288.223868]  ieee80211_mgd_deauth.cold+0x4c/0x1f5 [mac80211]
[  288.223921]  cfg80211_mlme_deauth+0xa1/0x1b0 [cfg80211]
[  288.223975]  cfg80211_mlme_down+0x56/0x60 [cfg80211]
[  288.224013]  cfg80211_disconnect+0x14e/0x210 [cfg80211]
[  288.224112]  cfg80211_netdev_notifier_call+0xfd/0x490 [cfg80211]
[  288.224171]  ? dev_printk_emit+0x3e/0x41
[  288.224176]  ? __dev_printk+0x2d/0x67
[  288.224180]  ? _dev_err+0x5c/0x5f
[  288.224183]  ? __slab_free+0xc2/0x2f0
[  288.224187]  ? __iwl_err.cold+0x2b/0x62 [iwlwifi]
[  288.224212]  ? rtnl_is_locked+0x11/0x20
[  288.224215]  ? inetdev_event+0x3a/0x630
[  288.224219]  ? _raw_spin_lock_irqsave+0x23/0x50
[  288.224222]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  288.224225]  ? packet_notifier+0x58/0x1d0
[  288.224228]  raw_notifier_call_chain+0x44/0x60
[  288.224234]  __dev_close_many+0x4f/0xf0
[  288.224239]  dev_close_many+0x7b/0x120
[  288.224241]  ? mutex_lock+0xe/0x30
[  288.224246]  dev_close+0x56/0x80
[  288.224248]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.224295]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.224351]  process_one_work+0x1c7/0x380
[  288.224356]  worker_thread+0x4d/0x380
[  288.224359]  ? process_one_work+0x380/0x380
[  288.224361]  kthread+0xe9/0x110
[  288.224364]  ? kthread_complete_and_exit+0x20/0x20
[  288.224367]  ret_from_fork+0x22/0x30
[  288.224372]  </TASK>
[  288.224374] ---[ end trace 0000000000000000 ]---
[  288.224397] iwlwifi 0000:04:00.0: iwl_trans_wait_tx_queues_empty bad 
state = 0
[  288.225110] wlp4s0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from 
hardware (-5)
[  288.238227] ------------[ cut here ]------------
[  288.238230] WARNING: CPU: 0 PID: 6 at net/mac80211/driver-ops.c:36 
drv_stop+0xee/0x100 [mac80211]
[  288.238286] Modules linked in: tun rfcomm snd_seq_dummy snd_hrtimer 
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp 
nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns 
nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat 
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
iptable_security ip_set nfnetlink ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables qrtr bnep sunrpc 
rmi_smbus rmi_core intel_rapl_msr mei_hdcp iTCO_wdt mei_pxp 
intel_pmc_bxt iwlmvm intel_rapl_common mei_wdt iTCO_vendor_support 
intel_tcc_cooling x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
mac80211 coretemp kvm_intel snd_soc_hdac_hda snd_hda_ext_core 
snd_soc_sst_ipc libarc4 snd_soc_sst_dsp kvm snd_soc_acpi_intel_match
[  288.238340]  snd_hda_codec_hdmi snd_soc_acpi btusb btrtl btbcm 
irqbypass snd_soc_core snd_ctl_led uvcvideo snd_hda_codec_conexant rapl 
intel_cstate iwlwifi snd_hda_codec_generic snd_compress 
videobuf2_vmalloc ac97_bus btintel snd_pcm_dmaengine videobuf2_memops 
videobuf2_v4l2 btmtk intel_uncore iwlmei snd_hda_intel videobuf2_common 
think_lmi snd_intel_dspcfg bluetooth firmware_attributes_class joydev 
pcspkr wmi_bmof videodev cfg80211 snd_intel_sdw_acpi 
intel_wmi_thunderbolt snd_hda_codec mc ecdh_generic 
intel_xhci_usb_role_switch snd_hda_core snd_hwdep snd_seq thinkpad_acpi 
snd_seq_device ledtrig_audio platform_profile rfkill snd_pcm mei_me 
snd_timer snd mei i2c_i801 soundcore i2c_smbus intel_pch_thermal 
acpi_pad zram rtsx_pci_sdmmc i915 mmc_core crct10dif_pclmul crc32_pclmul 
nvme crc32c_intel e1000e ghash_clmulni_intel rtsx_pci drm_buddy 
nvme_core drm_dp_helper serio_raw ucsi_acpi typec_ucsi ttm typec wmi 
video i2c_hid_acpi i2c_hid ipmi_devintf ipmi_msghandler fuse
[  288.238404] CPU: 0 PID: 6 Comm: kworker/0:0 Tainted: G        W 
5.18.5-200.fc36.x86_64 #1
[  288.238406] Hardware name: LENOVO 20HR006SUS/20HR006SUS, BIOS 
N1MET42W (1.27 ) 12/12/2017
[  288.238408] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  288.238447] RIP: 0010:drv_stop+0xee/0x100 [mac80211]
[  288.238481] Code: 0e 00 48 85 c0 74 0c 48 8b 78 08 48 89 de e8 59 46 
04 00 65 ff 0d 52 99 1f 3f 0f 85 4e ff ff ff 0f 1f 44 00 00 e9 44 ff ff 
ff <0f> 0b 5b c3 cc 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00
[  288.238483] RSP: 0000:ffffba910009bcf0 EFLAGS: 00010246
[  288.238485] RAX: 0000000000000000 RBX: ffffa00e07d608e0 RCX: 
0000000000000000
[  288.238487] RDX: 0000000080000000 RSI: 0000000000000286 RDI: 
ffffa00e07d608e0
[  288.238488] RBP: ffffa00e07d61b78 R08: ffffa00e00400e18 R09: 
ffffffff91e5cd30
[  288.238490] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffffa00e07d608e0
[  288.238491] R13: ffffa00e1a2b9848 R14: ffffa00e07d61248 R15: 
0000000000000000
[  288.238493] FS:  0000000000000000(0000) GS:ffffa01191800000(0000) 
knlGS:0000000000000000
[  288.238495] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  288.238496] CR2: 00007f136e169c00 CR3: 0000000100d26003 CR4: 
00000000003706f0
[  288.238498] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  288.238499] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  288.238501] Call Trace:
[  288.238504]  <TASK>
[  288.238507]  ieee80211_do_stop+0x628/0x830 [mac80211]
[  288.238574]  ? preempt_count_add+0x64/0x90
[  288.238581]  ieee80211_stop+0x3d/0x170 [mac80211]
[  288.238616]  __dev_close_many+0x8e/0xf0
[  288.238621]  dev_close_many+0x7b/0x120
[  288.238624]  ? mutex_lock+0xe/0x30
[  288.238628]  dev_close+0x56/0x80
[  288.238631]  cfg80211_shutdown_all_interfaces+0x49/0xe0 [cfg80211]
[  288.238676]  ieee80211_restart_work+0x127/0x150 [mac80211]
[  288.238707]  process_one_work+0x1c7/0x380
[  288.238711]  worker_thread+0x4d/0x380
[  288.238713]  ? process_one_work+0x380/0x380
[  288.238715]  kthread+0xe9/0x110
[  288.238718]  ? kthread_complete_and_exit+0x20/0x20
[  288.238720]  ret_from_fork+0x22/0x30
[  288.238725]  </TASK>
[  288.238725] ---[ end trace 0000000000000000 ]---

lspci:

00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v6/7th Gen Core 
Processor Host Bridge/DRAM Registers (rev 02)
	Subsystem: Lenovo ThinkPad X1 Carbon 5th Gen
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: skl_uncore

00:02.0 VGA compatible controller: Intel Corporation HD Graphics 620 
(rev 02) (prog-if 00 [VGA controller])
	Subsystem: Lenovo ThinkPad X1 Carbon 5th Gen
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 130
	Region 0: Memory at eb000000 (64-bit, non-prefetchable) [size=16M]
	Region 2: Memory at 60000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at e000 [size=64]
	Expansion ROM at 000c0000 [virtual] [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: i915
	Kernel modules: i915

00:08.0 System peripheral: Intel Corporation Xeon E3-1200 v5/v6 / 
E3-1500 v5 / 6th/7th/8th Gen Core Processor Gaussian Mixture Model
	Subsystem: Lenovo ThinkPad X1 Carbon 5th Gen
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 255
	Region 0: Memory at ec348000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

00:14.0 USB controller: Intel Corporation Sunrise Point-LP USB 3.0 xHCI 
Controller (rev 21) (prog-if 30 [XHCI])
	Subsystem: Lenovo Device 224f
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 126
	Region 0: Memory at ec320000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: xhci_hcd

00:14.2 Signal processing controller: Intel Corporation Sunrise Point-LP 
Thermal subsystem (rev 21)
	Subsystem: Lenovo ThinkPad X1 Carbon 5th Gen
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at ec349000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel_pch_thermal
	Kernel modules: intel_pch_thermal

00:16.0 Communication controller: Intel Corporation Sunrise Point-LP 
CSME HECI #1 (rev 21)
	Subsystem: Lenovo ThinkPad X1 Carbon 5th Gen
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 135
	Region 0: Memory at ec34a000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: mei_me
	Kernel modules: mei_me

00:16.3 Serial controller: Intel Corporation Sunrise Point-LP Active 
Management Technology - SOL (rev 21) (prog-if 02 [16550])
	Subsystem: Lenovo Device 224f
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin D routed to IRQ 19
	Region 0: I/O ports at e060 [size=8]
	Region 1: Memory at ec34c000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: serial

00:1c.0 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root 
Port #1 (rev f1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 122
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff [disabled]
	Memory behind bridge: ec200000-ec2fffff [size=1M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff 
[disabled]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root 
Port #3 (rev f1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 123
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff [disabled]
	Memory behind bridge: ec100000-ec1fffff [size=1M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff 
[disabled]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root 
Port #5 (rev f1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 124
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 0000f000-00000fff [disabled]
	Memory behind bridge: ec000000-ec0fffff [size=1M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff 
[disabled]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root 
Port #9 (rev f1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 125
	Bus: primary=00, secondary=06, subordinate=70, sec-latency=0
	I/O behind bridge: 00002000-00002fff [size=4K]
	Memory behind bridge: bc000000-ea0fffff [size=737M]
	Prefetchable memory behind bridge: 0000000070000000-00000000b9ffffff 
[size=1184M]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1f.0 ISA bridge: Intel Corporation Sunrise Point LPC Controller/eSPI 
Controller (rev 21)
	Subsystem: Lenovo Device 224f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:1f.2 Memory controller: Intel Corporation Sunrise Point-LP PMC (rev 21)
	Subsystem: Lenovo ThinkPad X1 Carbon 5th Gen
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at ec344000 (32-bit, non-prefetchable) [size=16K]

00:1f.3 Audio device: Intel Corporation Sunrise Point-LP HD Audio (rev 21)
	Subsystem: Lenovo ThinkPad X1 Carbon 5th Gen
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 136
	Region 0: Memory at ec340000 (64-bit, non-prefetchable) [size=16K]
	Region 4: Memory at ec330000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel, snd_soc_skl

00:1f.4 SMBus: Intel Corporation Sunrise Point-LP SMBus (rev 21)
	Subsystem: Lenovo ThinkPad X1 Carbon 5th Gen
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ec34b000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at efa0 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c_i801

00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection (4) 
I219-LM (rev 21)
	Subsystem: Lenovo Device 224f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 128
	Region 0: Memory at ec300000 (32-bit, non-prefetchable) [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: e1000e
	Kernel modules: e1000e

02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS525A 
PCI Express Card Reader (rev 01)
	Subsystem: Lenovo ThinkPad X1 Carbon 5th Gen
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 127
	Region 1: Memory at ec200000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: rtsx_pci
	Kernel modules: rtsx_pci

04:00.0 Network controller: Intel Corporation Wireless 8265 / 8275 (rev 88)
	Subsystem: Intel Corporation Device 0130
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 137
	Region 0: Memory at ec100000 (64-bit, non-prefetchable) [virtual] [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi

05:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe 
SSD Controller SM981/PM981/PM983 (prog-if 02 [NVM Express])
	Subsystem: Samsung Electronics Co Ltd SSD 970 EVO Plus 1TB
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	NUMA node: 0
	Region 0: Memory at ec000000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: nvme
	Kernel modules: nvme

