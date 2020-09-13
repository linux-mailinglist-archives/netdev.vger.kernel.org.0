Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42A7268134
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 22:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgIMUtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 16:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgIMUtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 16:49:17 -0400
X-Greylist: delayed 148 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Sep 2020 13:49:14 PDT
Received: from gwu.lbox.cz (proxybox.linuxbox.cz [IPv6:2a02:8304:2:66::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C4EC06174A
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 13:49:14 -0700 (PDT)
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
        by gwu.lbox.cz (Sendmail) with ESMTPS id 08DKkOhq016290
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 13 Sep 2020 22:46:24 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 08DKkOhq016290
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
        s=default; t=1600029984;
        bh=PwaqgZZWpt4smdTI+NJo/RRawaAPMgerEMt6nqyR95Q=;
        h=Date:From:To:Cc:Subject:From;
        b=VMuPerKLjsCkP525IrI+TEcDd9P8qeSq8zUgmWxkm7VdrDeQ1QdbSjQ3/7U4PgNXP
         xH4GM84Hum5p8+n/J8BJcB7AgSmzJisf4R3IG9NSC4htbZYYJQXm7vOb8Wr20aBDD2
         YsxLsXBCIfFWLhI1dUsT8VMuQ/LctsgjuTLapgmo=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
        by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 08DKkNpb010883
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 13 Sep 2020 22:46:23 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
        by pcnci.linuxbox.cz (8.15.2/8.15.2) with SMTP id 08DKkNni010473;
        Sun, 13 Sep 2020 22:46:23 +0200
Date:   Sun, 13 Sep 2020 22:46:23 +0200
From:   Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To:     netdev@vger.kernel.org
Cc:     elic@nvidia.com, nik@linuxbox.cz,
        Stanislav Schattke <schattke@linuxbox.cz>
Subject: 5.4.55 mlx5x - panic on bond link loss
Message-ID: <20200913204623.GA10015@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.76.66.2
X-Scanned-By: MIMEDefang v2.84/SpamAssassin v3.004004 on lbxovapx.linuxbox.cz (nik)
X-Scanned-By: MIMEDefang 2.84 on 10.76.66.10
X-Antivirus: on lbxovapx.linuxbox.cz by F-Secure antivirus, database version 2020-09-13_08
X-Spam-Score: N/A (imported whitelist)
X-Milter-Copy-Status: O
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

just after updating one of our clusters to 5.4.55 and reconnecting to anoth=
er stack
of switches, the box panicked.. here's what i digged out from pstore:

<6>[ 1056.250637] bond0: (slave eth3): Enslaving as a backup interface with=
 an up link
<4>[ 1057.559331] ------------[ cut here ]------------
<2>[ 1057.564307] kernel BUG at mm/slub.c:3995!
<4>[ 1057.568757] invalid opcode: 0000 [#1] SMP NOPTI
<4>[ 1057.573633] CPU: 28 PID: 21078 Comm: kworker/u64:1 Tainted: G        =
    E     5.4.55lb7.01 #1
<4>[ 1057.582992] Hardware name: Supermicro Super Server/X11DDW-NT, BIOS 3.=
1 04/30/2019
<4>[ 1057.591083] Workqueue: mlx5_lag mlx5_do_bond_work [mlx5_core]
<4>[ 1057.597177] RIP: 0010:kfree+0x1ea/0x200
<4>[ 1057.601428] Code: d3 e0 49 8b 0c 24 48 63 d0 48 c1 e9 36 48 8b 3c cd =
60 f5 1c 82 e8 d6 27 fa ff 89 de 4c 89 e7 5b 5d 41 5c 41 5d e9 f6 6a fd ff =
<0f> 0b 48 83 e8 01 e9 7c fe ff ff 4c 8d 60 ff e9 63 fe ff ff 66 90
<4>[ 1057.621052] RSP: 0018:ffffc90030c27c70 EFLAGS: 00010246
<4>[ 1057.626621] RAX: ffffea02f800c4c8 RBX: 0000000000000000 RCX: ffff893e=
523f1cd9
<4>[ 1057.634109] RDX: 0000777f80000000 RSI: ffff893e9a3f1f28 RDI: ffff893e=
00313332
<4>[ 1057.641599] RBP: ffff893e523f1bb0 R08: ffff893e523f1cd8 R09: ffff893e=
523ef018
<4>[ 1057.649157] R10: ffff893e523ef568 R11: ffffc90030c27c68 R12: ffffea02=
f800c4c0
<4>[ 1057.656640] R13: 0000000000000000 R14: ffff88dec0910430 R15: ffff893e=
92e604a0
<4>[ 1057.664121] FS:  0000000000000000(0000) GS:ffff893ebfb00000(0000) knl=
GS:0000000000000000
<4>[ 1057.672798] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[ 1057.678895] CR2: 00007fca074d2000 CR3: 000000be5cb98006 CR4: 00000000=
007606e0
<4>[ 1057.686375] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
<4>[ 1057.693855] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
<4>[ 1057.701340] PKRU: 55555554
<4>[ 1057.704389] Call Trace:
<4>[ 1057.707185]  kernfs_put+0x71/0x180
<4>[ 1057.710935]  __kernfs_remove+0xf7/0x1f0
<4>[ 1057.715117]  ? kernfs_name_hash+0x12/0x80
<4>[ 1057.719475]  kernfs_remove_by_name_ns+0x3e/0x80
<4>[ 1057.724422]  remove_files.isra.1+0x31/0x70
<4>[ 1057.728859]  sysfs_remove_group+0x3d/0x80
<4>[ 1057.733221]  ib_free_port_attrs+0x85/0x170 [ib_core]
<4>[ 1057.738531]  __ib_unregister_device+0x45/0x90 [ib_core]
<4>[ 1057.744104]  ib_unregister_device+0x21/0x30 [ib_core]
<4>[ 1057.749506]  __mlx5_ib_remove+0x31/0x50 [mlx5_ib]
<4>[ 1057.754560]  mlx5_remove_device+0xbf/0xd0 [mlx5_core]
<4>[ 1057.759967]  mlx5_do_bond+0x14d/0x180 [mlx5_core]
<4>[ 1057.765018]  mlx5_do_bond_work+0x1b/0x40 [mlx5_core]
<4>[ 1057.770326]  process_one_work+0x171/0x380
<4>[ 1057.774680]  worker_thread+0x49/0x3f0
<4>[ 1057.778687]  kthread+0xf8/0x130
<4>[ 1057.782165]  ? max_active_store+0x80/0x80
<4>[ 1057.786523]  ? kthread_bind+0x10/0x10
<4>[ 1057.790533]  ret_from_fork+0x1f/0x40
<4>[ 1057.794449] Modules linked in: rbd(E) ceph(E) libceph(E) dns_resolver=
(E) netconsole(E) bonding(E) openvswitch(E) nf_conncount(E) nf_nat(E) nsh(E=
) nf_conntrack(E) nf_defrag_ipv6(E) libcrc32c(E) nf_defrag_ipv4(E) ib_isert=
(E) iscsi_target_mod(E) ib_srpt(E) target_core_mod(E) ib_srp(E) scsi_transp=
ort_srp(E) i40iw(E) rpcrdma(E) sunrpc(E) rdma_ucm(E) ib_iser(E) rdma_cm(E) =
ib_umad(E) iw_cm(E) crc32_pclmul(E) ib_ipoib(E) libiscsi(E) aesni_intel(E) =
ib_cm(E) glue_helper(E) scsi_transport_iscsi(E) crypto_simd(E) mlx5_ib(E) g=
hash_clmulni_intel(E) cryptd(E) coretemp(E) iTCO_wdt(E) iTCO_vendor_support=
(E) ib_uverbs(E) ib_core(E) crct10dif_pclmul(E) intel_powerclamp(E) x86_pkg=
_temp_thermal(E) ipmi_si(E) i2c_i801(E) mei_me(E) wmi(E) i2c_core(E) mei(E)=
 ipmi_devintf(E) lpc_ich(E) pcspkr(E) sg(E) mfd_core(E) ioatdma(E) ipmi_msg=
handler(E) dca(E) acpi_power_meter(E) acpi_pad(E) vhost_net(E) tun(E) vhost=
(E) tap(E) kvm_intel(E) kvm(E) irqbypass(E) ip_tables(E) ext4(E) mbcache(E)=
 jbd2(E) raid1(E) sd_mod(E)
<4>[ 1057.794473]  mlx5_core(E) ahci(E) mlxfw(E) crc32c_intel(E) pci_hyperv=
_intf(E) libahci(E) nvme(E) i40e(E) xhci_pci(E) nvme_core(E) xhci_hcd(E) li=
bata(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) dax(E)
<4>[ 1057.904356] ---[ end trace 5ba0d92f4b61983a ]---
<4>[ 1057.967400] RIP: 0010:kfree+0x1ea/0x200
<4>[ 1057.971584] Code: d3 e0 49 8b 0c 24 48 63 d0 48 c1 e9 36 48 8b 3c cd =
60 f5 1c 82 e8 d6 27 fa ff 89 de 4c 89 e7 5b 5d 41 5c 41 5d e9 f6 6a fd ff =
<0f> 0b 48 83 e8 01 e9 7c fe ff ff 4c 8d 60 ff e9 63 fe ff ff 66 90
<4>[ 1057.991215] RSP: 0018:ffffc90030c27c70 EFLAGS: 00010246
<4>[ 1057.996792] RAX: ffffea02f800c4c8 RBX: 0000000000000000 RCX: ffff893e=
523f1cd9
<4>[ 1058.004274] RDX: 0000777f80000000 RSI: ffff893e9a3f1f28 RDI: ffff893e=
00313332
<4>[ 1058.011764] RBP: ffff893e523f1bb0 R08: ffff893e523f1cd8 R09: ffff893e=
523ef018
<4>[ 1058.019250] R10: ffff893e523ef568 R11: ffffc90030c27c68 R12: ffffea02=
f800c4c0
<4>[ 1058.026740] R13: 0000000000000000 R14: ffff88dec0910430 R15: ffff893e=
92e604a0
<4>[ 1058.034229] FS:  0000000000000000(0000) GS:ffff893ebfb00000(0000) knl=
GS:0000000000000000
<4>[ 1058.042914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[ 1058.049009] CR2: 00007fca074d2000 CR3: 000000be5cb98006 CR4: 00000000=
007606e0
<4>[ 1058.056491] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
<4>[ 1058.063973] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
<4>[ 1058.071459] PKRU: 55555554
<0>[ 1058.074510] Kernel panic - not syncing: Fatal exception
<0>[ 1058.080140] Kernel Offset: disabled

anyone else observed similar problem? If not, we'll try to reproduce this o=
n the lab..

BR

nik

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
