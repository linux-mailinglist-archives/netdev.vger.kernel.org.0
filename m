Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503981476EC
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 03:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbgAXCUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 21:20:38 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:37386 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729340AbgAXCUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 21:20:38 -0500
Received: by mail-pf1-f178.google.com with SMTP id p14so350390pfn.4
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 18:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:mime-version:user-agent:message-id
         :content-transfer-encoding;
        bh=iada8VAEVl+8Z3N58uNhp9xesRsSz4/3DV+tXF0E0kw=;
        b=DXpiXu7EaqUU9D0f/rZyaxvOMt4fJqpDDvgFPX31qVV6f7wEqWh6pii35XI2Xnlc6c
         HMYbQmxZWP4Gv0Hcq/6KsxRRKgI/ldmEkNkxy/X2J8oD2mtxGRKGRDmqhSmhAXR7szKN
         FVHEn8SABHHzo5jqUDoXR2fJp0oY12gRGj3zCCgyAfBjXmjmHV0uGx1coKEZ4mY+DWgm
         6y5l713jKo/M2J+gAVdF8WQXFOOpwa/uw/CNSaQhk6ZX35AhygSt7SKvvf+Jk74lN8Ol
         YpBG7z/4OE6Bcyx5uy2hYJ45Sj78O/5jA+0WjmibjOXEHfndsBxd3FZnOqluoziBr5ZV
         6NkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:mime-version:user-agent
         :message-id:content-transfer-encoding;
        bh=iada8VAEVl+8Z3N58uNhp9xesRsSz4/3DV+tXF0E0kw=;
        b=ii39UZAtEwKyZUjpLwPL5hXh8qwH65L5osGBI1ftFfbe6RtS6KDPIK9KtH2RsvmEPu
         OEd3BzBJXeN98ADKvsn818/5ZP7yhK4xBZMMbZZqOTpXlRUyjCXZpmyCQwBSSDNFFMRR
         wwIwP/MaOc1JMTlHMn9COLamRxKmEmuB/tjTACjTq0N2BNNSk46K4urKB8JB/t8LTeo6
         E1V+WHVhGiEJOBQI0k4qW6rzn2oGgiAASdfCN2Xy+2GPrBTvL37NP+5oNW8ZYePmaF1t
         PVu4N0DDtasOZ3U8Mp/w4B2FjN8ZalsLyYyR6qCGNw3lM8GiR2YHVJ2DuJi+l92id0TP
         CQtg==
X-Gm-Message-State: APjAAAXNg4AFP5XUfiVz1/MMd3D1KmXjSoUUwn4D9YfqhyIQ1mvBeWZS
        L9htNs040f3nQPLBxsHDm8ldkYDD
X-Google-Smtp-Source: APXvYqzeV+wAvdVYGUqcqE1BRI6eppILRciQzaVw3ob3btmwxKYzOWuUCCb9RQZ+iGhDV8pPJp2QBg==
X-Received: by 2002:a65:4d46:: with SMTP id j6mr1561572pgt.63.1579832437046;
        Thu, 23 Jan 2020 18:20:37 -0800 (PST)
Received: from localhost ([202.125.31.63])
        by smtp.gmail.com with ESMTPSA id u12sm4018605pfm.165.2020.01.23.18.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 18:20:36 -0800 (PST)
Date:   Fri, 24 Jan 2020 12:20:32 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: tg3 hard lockups when injecting PCI errors
To:     netdev@vger.kernel.org
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Message-Id: <1579830659.3y3glveaqg.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tg3 driver looks to be holding interrupts off for a long time when
we inject a PCI link failure that takes a long time to recover from.

The traces are below (sorry it's an older distro kernel, I could get a
newer one re-tested if you like but the code looks the same).

What looks like happening is __tg3_readphy times out after ~50ms, and
then tg3_setup_copper_phy retries it up to 1000 times. The hard lockup
watchdog starts to get angry after about 10s.

Things recover in the end, but would be great if the latency blip could
be fixed.

Roughly I would say 10s of ms is reasonable irq off latency for unusual
error cases, 100s of ms is undsirable, 1000 starts to get unacceptable.
Is it possible to time out quickly here and wait for the next timer?

Thanks,
Nick

echo 0x0:1:4:0x6028000030000:0xffff0000 > /sys/kernel/debug/powerpc/PCI0005=
/err_injct

EEH: PHB#5 failure detected, location: N/A
CPU: 29 PID: 19816 Comm: lspci Tainted: G           OE    4.15.0-21-generic=
 #22-Ubuntu
Call Trace:
[c000003fbed3fb00] [c000000000cddd5c] dump_stack+0xb0/0xf4 (unreliable)
[c000003fbed3fb40] [c00000000003a824] eeh_dev_check_failure+0x234/0x5b0
[c000003fbed3fbe0] [c0000000000aced8] pnv_pci_read_config+0x128/0x160
[c000003fbed3fc20] [c00000000075b18c] pci_user_read_config_dword+0x8c/0x180
[c000003fbed3fc70] [c000000000770214] pci_read_config+0x104/0x2d0
[c000003fbed3fcf0] [c00000000049e870] sysfs_kf_bin_read+0x70/0xd0
[c000003fbed3fd10] [c00000000049d7c0] kernfs_fop_read+0xe0/0x290
[c000003fbed3fd60] [c0000000003d369c] __vfs_read+0x3c/0x70
[c000003fbed3fd80] [c0000000003d378c] vfs_read+0xbc/0x1b0
[c000003fbed3fdd0] [c0000000003d4004] SyS_pread64+0xc4/0xf0
[c000003fbed3fe30] [c00000000000b184] system_call+0x58/0x6c
EEH: Detected error on PHB#5
EEH: This PCI device has failed 1 times in the last hour
EEH: Notify device drivers to shutdown
tg3 0005:01:00.0 enP5p1s0f0: PCI I/O error detected
tg3 0005:01:00.1 enP5p1s0f1: PCI I/O error detected
Watchdog CPU:128 detected Hard LOCKUP other CPUS:168
Watchdog CPU:168 Hard LOCKUP
Modules linked in: rpcsec_gss_krb5 binfmt_misc nfsv4 nfs fscache rdma_ucm(O=
E) ib_ucm(OE) ib_ipoib(OE) ib_uverbs(OE) ib_umad(OE) esp6_offload esp6 esp4=
_offload esp4 xfrm_algo mlx5_fpga_tools(OE) mlx4_en(OE) mlx4_ib(OE) mlx4_co=
re(OE) bridge stp llc idt_89hpesx at24 uio_pdrv_genirq ipmi_powernv ofpart =
uio cmdlinepart ipmi_devintf powernv_flash mtd ipmi_msghandler opal_prd ibm=
powernv vmx_crypto nfsd auth_rpcgss nfs_acl lockd grace sunrpc sch_fq_codel=
 ib_iser(OE) rdma_cm(OE) iw_cm(OE) ib_cm(OE) iscsi_tcp libiscsi_tcp libiscs=
i scsi_transport_iscsi knem(OE) ip_tables x_tables autofs4 btrfs zstd_compr=
ess raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_=
tx xor raid6_pq libcrc32c raid1 raid0 multipath linear mlx5_ib(OE) ib_core(=
OE) nouveau lpfc mlx5_core(OE) ast i2c_algo_bit
 ttm drm_kms_helper nvmet_fc mlxfw(OE) devlink nvmet syscopyarea mlx_compat=
(OE) sysfillrect sysimgblt nvme_fc cxl fb_sys_fops nvme nvme_fabrics crct10=
dif_vpmsum ahci crc32c_vpmsum drm nvme_core tg3 libahci pnv_php scsi_transp=
ort_fc
CPU: 168 PID: 0 Comm: swapper/168 Tainted: G           OE    4.15.0-21-gene=
ric #22-Ubuntu
NIP:  c000000000024420 LR: c0080000107e970c CTR: c0000000000243e0
REGS: c0000000076c7d80 TRAP: 0100   Tainted: G           OE     (4.15.0-21-=
generic)
MSR:  9000000000089033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 48004824  XER: 000000=
00
CFAR: c00000000002442c SOFTE: 1
GPR00: c0080000107e970c c00020397b4d3660 c0000000016eae00 0000000000001400
GPR04: 0000000000000001 0000000000000000 4000000000000000 0000000000200b20
GPR08: 0000000000000000 0000000000000159 00000070170dd219 c0080000108091c8
GPR12: c0000000000243e0 c000000007a83800 c00020397b4d3f90 0000000000000000
GPR16: 0000000000000000 0000000000000100 0000000000000001 0000000000000010
GPR20: c000000001712208 0000000000200042 0000000000000000 c000000001713b00
GPR24: 000000010001e7f1 5deadbeef0000200 0000000000000000 c00020397b4d370c
GPR28: 0000000000400000 0000000000000001 c000003fed710900 00000000000008c6
NIP [c000000000024420] udelay+0x40/0x60
LR [c0080000107e970c] __tg3_readphy+0xa4/0x1d0 [tg3]
Call Trace:
[c00020397b4d3660] [c0080000107e972c] __tg3_readphy+0xc4/0x1d0 [tg3] (unrel=
iable)
[c00020397b4d36b0] [c0080000107fcf84] tg3_setup_copper_phy+0x64c/0x1130 [tg=
3]
[c00020397b4d3750] [c0080000107fdabc] tg3_setup_phy+0x54/0xa10 [tg3]
[c00020397b4d37c0] [c008000010807b7c] tg3_timer+0x3f4/0x8e0 [tg3]
[c00020397b4d3820] [c0000000001b5410] call_timer_fn+0x50/0x1c0
[c00020397b4d38a0] [c0000000001b56b8] expire_timers+0x138/0x1f0
[c00020397b4d3910] [c0000000001b5878] run_timer_softirq+0x108/0x270
[c00020397b4d39b0] [c000000000cffcc8] __do_softirq+0x158/0x3e4
[c00020397b4d3a90] [c000000000115968] irq_exit+0xe8/0x120
[c00020397b4d3ab0] [c000000000024d0c] timer_interrupt+0x9c/0xe0
[c00020397b4d3ae0] [c000000000009014] decrementer_common+0x114/0x120
--- interrupt: 901 at replay_interrupt_return+0x0/0x4
    LR =3D arch_local_irq_restore+0x74/0x90
[c00020397b4d3dd0] [00000000000000a8] 0xa8 (unreliable)
[c00020397b4d3df0] [c000000000ac1870] cpuidle_enter_state+0xf0/0x450
[c00020397b4d3e50] [c00000000017311c] call_cpuidle+0x4c/0x90
[c00020397b4d3e70] [c000000000173530] do_idle+0x2b0/0x330
[c00020397b4d3ec0] [c0000000001737ec] cpu_startup_entry+0x3c/0x50
[c00020397b4d3ef0] [c00000000004a050] start_secondary+0x4f0/0x510
[c00020397b4d3f90] [c00000000000aa6c] start_secondary_prolog+0x10/0x14
Instruction dump:
3d22ffe7 e9297d00 7c6349d2 7c210b78 7d4c42a6 7d2c42a6 7d2a4850 7fa34840
409d0020 60000000 60000000 60420000 <7d2c42a6> 7d2a4850 7fa34840 419dfff4
tg3 0005:01:00.1 enP5p1s0f1: Link is down
Watchdog CPU:168 became unstuck
EEH: Collect temporary log
PHB4 PHB#5 Diag-data (Version: 1)
brdgCtl:    00000002
RootSts:    00260020 00402000 a8220008 00100107 00004800
RootErrSts: 00000024 00000000 00000000
sourceId:   01000000
nFir:       0000800000000000 0030001c00000000 0000800000000000
PhbSts:     0000001c00000000 0000001c00000000
Lem:        1001000104100100 0000000000000000 1000000000000000
PhbErr:     00000d8000000000 0000010000000000 2148000098000240 a00840000000=
0000
PhbTxeErr:  0000000600000000 0000000200000000 0000000000000000 000000000000=
0000
RxeArbErr:  0000000020000020 0000000000000020 4000010000000000 000000000000=
0000
RxeMrgErr:  0000000000000001 0000000000000001 0000000000000000 000000000000=
0000
PblErr:     0000000000020000 0000000000020000 0000000000000000 000000000000=
0000
RegbErr:    0000004000000000 0000004000000000 8800003c00000000 000000000701=
1000
PE[000] A/B: a700000300000000 8101000001010000
PE[100] A/B: 80000007f8c97c00 80000000300d2243
EEH: Reset without hotplug activity
: enP5p1s0f0: Lost carrier
: enP5p1s0f1: Lost carrier
: Network configuration changed, trying to establish connection.
EEH: Notify device drivers the completion of reset
tg3 0005:01:00.0: enabling device (0140 -> 0142)
tg3 0005:01:00.1: enabling device (0140 -> 0142)
EEH: Notify device driver to resume
tg3 0005:01:00.0 enP5p1s0f0: Link is down
tg3 0005:01:00.1 enP5p1s0f1: Link is up at 1000 Mbps, full duplex
tg3 0005:01:00.1 enP5p1s0f1: Flow control is on for TX and on for RX
tg3 0005:01:00.1 enP5p1s0f1: EEE is disabled
: enP5p1s0f1: Gained carrier
info>  [1526537213.5872] device (enP5p1s0f1): carrier: link connected
: enP5p1s0f1: Configured
tg3 0005:01:00.0 enP5p1s0f0: Link is up at 1000 Mbps, full duplex
tg3 0005:01:00.0 enP5p1s0f0: Flow control is off for TX and off for RX
tg3 0005:01:00.0 enP5p1s0f0: EEE is disabled
: enP5p1s0f0: Gained carrier
info>  [1526537214.2502] device (enP5p1s0f0): carrier: link connected
: enP5p1s0f0: Configured
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014701] EEH: PHB#5 failure =
detected, location: N/A
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014758] CPU: 53 PID: 19979 =
Comm: lspci Tainted: G           OE    4.15.0-21-generic #22-Ubuntu
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014760] Call Trace:
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014766] [c000003f0bcbbb00] =
[c000000000cddd5c] dump_stack+0xb0/0xf4 (unreliable)
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014772] [c000003f0bcbbb40] =
[c00000000003a824] eeh_dev_check_failure+0x234/0x5b0
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014775] [c000003f0bcbbbe0] =
[c0000000000aced8] pnv_pci_read_config+0x128/0x160
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014779] [c000003f0bcbbc20] =
[c00000000075b18c] pci_user_read_config_dword+0x8c/0x180
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014782] [c000003f0bcbbc70] =
[c000000000770214] pci_read_config+0x104/0x2d0
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014786] [c000003f0bcbbcf0] =
[c00000000049e870] sysfs_kf_bin_read+0x70/0xd0
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014789] [c000003f0bcbbd10] =
[c00000000049d7c0] kernfs_fop_read+0xe0/0x290
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014793] [c000003f0bcbbd60] =
[c0000000003d369c] __vfs_read+0x3c/0x70
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014796] [c000003f0bcbbd80] =
[c0000000003d378c] vfs_read+0xbc/0x1b0
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014799] [c000003f0bcbbdd0] =
[c0000000003d4004] SyS_pread64+0xc4/0xf0
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014803] [c000003f0bcbbe30] =
[c00000000000b184] system_call+0x58/0x6c
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.014803] [c000003f0bcbbe30] =
[c00000000000b184] system_call+0x58/0x6c
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.015437] EEH: Detected error=
 on PHB#5
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.015440] EEH: This PCI devic=
e has failed 2 times in the last hour
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.015440] EEH: Notify device =
drivers to shutdown
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.015447] tg3 0005:01:00.0 en=
P5p1s0f0: PCI I/O error detected
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.015481] tg3 0005:01:00.1 en=
P5p1s0f1: PCI I/O error detected
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016504] EEH: Collect tempor=
ary log
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016506] PHB4 PHB#5 Diag-dat=
a (Version: 1)
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016507] brdgCtl:    0000000=
2
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016509] RootSts:    0026002=
0 00402000 a8220008 00100107 00004800
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016510] RootErrSts: 0000002=
4 00000000 00000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016511] sourceId:   0100000=
0
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016512] nFir:       0000800=
000000000 0030001c00000000 0000800000000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016513] PhbSts:     0000001=
c00000000 0000001c00000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016515] Lem:        1001000=
104100100 0000000000000000 1000000000000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016516] PhbErr:     00000d8=
000000000 0000010000000000 2148000098000240 a008400000000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016517] PhbTxeErr:  0000000=
600000000 0000000200000000 0000000000000000 0000000000000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016519] RxeArbErr:  0000000=
020000020 0000000000000020 4000010000000000 0000000000000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016520] RxeMrgErr:  0000000=
000000001 0000000000000001 0000000000000000 0000000000000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016521] PblErr:     0000000=
000020000 0000000000020000 0000000000000000 0000000000000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016523] RegbErr:    0040004=
000000000 0000004000000000 4800012c00000000 0000000007000000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016524] PE[000] A/B: a70000=
0300000000 8101000001010000
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016526] PE[100] A/B: 800000=
07f8c97c00 80000000300d2243
May 17 02:07:07 ltciofvtr-spoon1 kernel: [  831.016527] EEH: Reset without =
hotplug activity
May 17 02:07:07 ltciofvtr-spoon1 systemd-networkd[19674]: enP5p1s0f0: Lost =
carrier
May 17 02:07:08 ltciofvtr-spoon1 systemd-networkd[19674]: enP5p1s0f1: Lost =
carrier
May 17 02:07:10 ltciofvtr-spoon1 kernel: [  834.381604] EEH: Notify device =
drivers the completion of reset
May 17 02:07:10 ltciofvtr-spoon1 kernel: [  834.381615] tg3 0005:01:00.0: e=
nabling device (0140 -> 0142)
May 17 02:07:10 ltciofvtr-spoon1 kernel: [  834.381766] tg3 0005:01:00.1: e=
nabling device (0140 -> 0142)
May 17 02:07:10 ltciofvtr-spoon1 kernel: [  834.381907] EEH: Notify device =
driver to resume
May 17 02:07:10 ltciofvtr-spoon1 kernel: [  834.383752] tg3 0005:01:00.0 en=
P5p1s0f0: Link is down
May 17 02:07:10 ltciofvtr-spoon1 kernel: [  834.509724] tg3 0005:01:00.1 en=
P5p1s0f1: Link is down
May 17 02:07:14 ltciofvtr-spoon1 kernel: [  837.836891] tg3 0005:01:00.1 en=
P5p1s0f1: Link is up at 1000 Mbps, full duplex
May 17 02:07:14 ltciofvtr-spoon1 kernel: [  837.837009] tg3 0005:01:00.1 en=
P5p1s0f1: Flow control is on for TX and on for RX
May 17 02:07:14 ltciofvtr-spoon1 kernel: [  837.837013] tg3 0005:01:00.1 en=
P5p1s0f1: EEE is disabled
May 17 02:07:14 ltciofvtr-spoon1 systemd-networkd[19674]: enP5p1s0f1: Gaine=
d carrier
May 17 02:07:14 ltciofvtr-spoon1 NetworkManager[6962]: <info>  [1526537234.=
2359] device (enP5p1s0f1): carrier: link connected
May 17 02:07:14 ltciofvtr-spoon1 systemd-networkd[19674]: enP5p1s0f1: Confi=
gured


=
