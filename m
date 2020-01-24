Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E001478BA
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 07:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgAXG6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 01:58:37 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42320 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgAXG6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 01:58:36 -0500
Received: by mail-oi1-f193.google.com with SMTP id 18so942044oin.9
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 22:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0Q8WomwYP2FEzRGcFP0Lf91Topxg8AUcQl10cBZMXsY=;
        b=FLJbOxxREfVN77c7A4Qg1hHDDh1BsuNmUtfNwqikz3Gawq7oP5HXM18g874Ycavt5C
         EjFZRJ4KEKmeGou+QhffythhyqSP41cGwVkKd8MbzfeAyBKAxf3yvT1MZmbk2muqAmo5
         UmiXpmOLIZ7XNFZfA/mQOuzO65hCa80RmGrbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0Q8WomwYP2FEzRGcFP0Lf91Topxg8AUcQl10cBZMXsY=;
        b=kCBTGNd2NI33uIRftylTBjzVIJOaaNG4Fgpuo51os7X0Q9I76xrC0T2/YizsjMIaw0
         +zjtBXZZPOEYfBIiavlBoDDims7JSSC1k2M1l+mXserMMHRHWF7GiXIvKmv4Qw4G4R5f
         Td8q+HSK5bYtseKsq5q5U3Hr5swaAoDaHALK+Ip3JnzRFEm+8PfAPbA5AMeSQN/+Og0x
         fgrbSgfhgjJe7eDAKjkmhT+cJwUMemn2aOxdmZ/XhbVWzozU1aws4+2T3Ngd6PvwZJjo
         DLwGaBtXFyad1BZkwomjBm7jVGTG7UO8TlciTe8AxeeN3oRnmjx2WhvOlGNyMbz+zHgO
         xuAA==
X-Gm-Message-State: APjAAAWhuGDyDMD0Gsi/y0W1b7M0Zl/9uNujgS0GjdfZXPha6qjUGZFz
        J/AWfPX6eBT4Pc0AXqvSLAlAQ+QS32dRBSitHuJz1c2e
X-Google-Smtp-Source: APXvYqygwpICgPJLrCfrfIui4OCnuH12tdrGHyT9SvibKUK3mJclLxnRT2R7wQapOYKxbgjcb4W1esOXoM3jiCfM5pw=
X-Received: by 2002:aca:dd87:: with SMTP id u129mr1104581oig.14.1579849114266;
 Thu, 23 Jan 2020 22:58:34 -0800 (PST)
MIME-Version: 1.0
References: <1579830659.3y3glveaqg.astroid@bobo.none>
In-Reply-To: <1579830659.3y3glveaqg.astroid@bobo.none>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 23 Jan 2020 22:58:22 -0800
Message-ID: <CACKFLi=d0xGf=AiqOrs6tNuGpwZhFjOfSVJ8e3MzpZN+rEGpfw@mail.gmail.com>
Subject: Re: tg3 hard lockups when injecting PCI errors
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 6:20 PM Nicholas Piggin <npiggin@gmail.com> wrote:
>
> The tg3 driver looks to be holding interrupts off for a long time when
> we inject a PCI link failure that takes a long time to recover from.
>

From the trace you are showing below, I think we can disable the
tg3_timer() earlier or set a flag so that tg3_timer() will skip most
of the work after tg3_slot_reset() is called.  We'll get someone to
take a look at this.  Thanks.

> The traces are below (sorry it's an older distro kernel, I could get a
> newer one re-tested if you like but the code looks the same).
>
> What looks like happening is __tg3_readphy times out after ~50ms, and
> then tg3_setup_copper_phy retries it up to 1000 times. The hard lockup
> watchdog starts to get angry after about 10s.
>
> Things recover in the end, but would be great if the latency blip could
> be fixed.
>
> Roughly I would say 10s of ms is reasonable irq off latency for unusual
> error cases, 100s of ms is undsirable, 1000 starts to get unacceptable.
> Is it possible to time out quickly here and wait for the next timer?
>
> Thanks,
> Nick
>
> echo 0x0:1:4:0x6028000030000:0xffff0000 > /sys/kernel/debug/powerpc/PCI00=
05/err_injct
>
> EEH: PHB#5 failure detected, location: N/A
> CPU: 29 PID: 19816 Comm: lspci Tainted: G           OE    4.15.0-21-gener=
ic #22-Ubuntu
> Call Trace:
> [c000003fbed3fb00] [c000000000cddd5c] dump_stack+0xb0/0xf4 (unreliable)
> [c000003fbed3fb40] [c00000000003a824] eeh_dev_check_failure+0x234/0x5b0
> [c000003fbed3fbe0] [c0000000000aced8] pnv_pci_read_config+0x128/0x160
> [c000003fbed3fc20] [c00000000075b18c] pci_user_read_config_dword+0x8c/0x1=
80
> [c000003fbed3fc70] [c000000000770214] pci_read_config+0x104/0x2d0
> [c000003fbed3fcf0] [c00000000049e870] sysfs_kf_bin_read+0x70/0xd0
> [c000003fbed3fd10] [c00000000049d7c0] kernfs_fop_read+0xe0/0x290
> [c000003fbed3fd60] [c0000000003d369c] __vfs_read+0x3c/0x70
> [c000003fbed3fd80] [c0000000003d378c] vfs_read+0xbc/0x1b0
> [c000003fbed3fdd0] [c0000000003d4004] SyS_pread64+0xc4/0xf0
> [c000003fbed3fe30] [c00000000000b184] system_call+0x58/0x6c
> EEH: Detected error on PHB#5
> EEH: This PCI device has failed 1 times in the last hour
> EEH: Notify device drivers to shutdown
> tg3 0005:01:00.0 enP5p1s0f0: PCI I/O error detected
> tg3 0005:01:00.1 enP5p1s0f1: PCI I/O error detected
> Watchdog CPU:128 detected Hard LOCKUP other CPUS:168
> Watchdog CPU:168 Hard LOCKUP
> Modules linked in: rpcsec_gss_krb5 binfmt_misc nfsv4 nfs fscache rdma_ucm=
(OE) ib_ucm(OE) ib_ipoib(OE) ib_uverbs(OE) ib_umad(OE) esp6_offload esp6 es=
p4_offload esp4 xfrm_algo mlx5_fpga_tools(OE) mlx4_en(OE) mlx4_ib(OE) mlx4_=
core(OE) bridge stp llc idt_89hpesx at24 uio_pdrv_genirq ipmi_powernv ofpar=
t uio cmdlinepart ipmi_devintf powernv_flash mtd ipmi_msghandler opal_prd i=
bmpowernv vmx_crypto nfsd auth_rpcgss nfs_acl lockd grace sunrpc sch_fq_cod=
el ib_iser(OE) rdma_cm(OE) iw_cm(OE) ib_cm(OE) iscsi_tcp libiscsi_tcp libis=
csi scsi_transport_iscsi knem(OE) ip_tables x_tables autofs4 btrfs zstd_com=
press raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor asyn=
c_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear mlx5_ib(OE) ib_cor=
e(OE) nouveau lpfc mlx5_core(OE) ast i2c_algo_bit
>  ttm drm_kms_helper nvmet_fc mlxfw(OE) devlink nvmet syscopyarea mlx_comp=
at(OE) sysfillrect sysimgblt nvme_fc cxl fb_sys_fops nvme nvme_fabrics crct=
10dif_vpmsum ahci crc32c_vpmsum drm nvme_core tg3 libahci pnv_php scsi_tran=
sport_fc
> CPU: 168 PID: 0 Comm: swapper/168 Tainted: G           OE    4.15.0-21-ge=
neric #22-Ubuntu
> NIP:  c000000000024420 LR: c0080000107e970c CTR: c0000000000243e0
> REGS: c0000000076c7d80 TRAP: 0100   Tainted: G           OE     (4.15.0-2=
1-generic)
> MSR:  9000000000089033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 48004824  XER: 0000=
0000
> CFAR: c00000000002442c SOFTE: 1
> GPR00: c0080000107e970c c00020397b4d3660 c0000000016eae00 000000000000140=
0
> GPR04: 0000000000000001 0000000000000000 4000000000000000 0000000000200b2=
0
> GPR08: 0000000000000000 0000000000000159 00000070170dd219 c0080000108091c=
8
> GPR12: c0000000000243e0 c000000007a83800 c00020397b4d3f90 000000000000000=
0
> GPR16: 0000000000000000 0000000000000100 0000000000000001 000000000000001=
0
> GPR20: c000000001712208 0000000000200042 0000000000000000 c000000001713b0=
0
> GPR24: 000000010001e7f1 5deadbeef0000200 0000000000000000 c00020397b4d370=
c
> GPR28: 0000000000400000 0000000000000001 c000003fed710900 00000000000008c=
6
> NIP [c000000000024420] udelay+0x40/0x60
> LR [c0080000107e970c] __tg3_readphy+0xa4/0x1d0 [tg3]
> Call Trace:
> [c00020397b4d3660] [c0080000107e972c] __tg3_readphy+0xc4/0x1d0 [tg3] (unr=
eliable)
> [c00020397b4d36b0] [c0080000107fcf84] tg3_setup_copper_phy+0x64c/0x1130 [=
tg3]
> [c00020397b4d3750] [c0080000107fdabc] tg3_setup_phy+0x54/0xa10 [tg3]
> [c00020397b4d37c0] [c008000010807b7c] tg3_timer+0x3f4/0x8e0 [tg3]
> [c00020397b4d3820] [c0000000001b5410] call_timer_fn+0x50/0x1c0
> [c00020397b4d38a0] [c0000000001b56b8] expire_timers+0x138/0x1f0
> [c00020397b4d3910] [c0000000001b5878] run_timer_softirq+0x108/0x270
> [c00020397b4d39b0] [c000000000cffcc8] __do_softirq+0x158/0x3e4
> [c00020397b4d3a90] [c000000000115968] irq_exit+0xe8/0x120
> [c00020397b4d3ab0] [c000000000024d0c] timer_interrupt+0x9c/0xe0
> [c00020397b4d3ae0] [c000000000009014] decrementer_common+0x114/0x120
> --- interrupt: 901 at replay_interrupt_return+0x0/0x4
