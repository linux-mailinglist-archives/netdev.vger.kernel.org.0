Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E370A42ACCE
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 21:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbhJLTCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 15:02:01 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:43309 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbhJLTCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 15:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1634065199; x=1665601199;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mhfoi/qI54H+J0ne98Ggu1vNv51TmFPQSeeSRsMOuSc=;
  b=Mnl+HDnmSUQvg5QaKiZ/lY5cZImJ0HDLewJT/kg4c4mmMrdwGpEcjNnF
   UCEyVspbp3bnfhxY/rtNoHQLx7O0MyEOI3vjUMM5I9YA+jOf+Eyr4m2Op
   KUmaQMmoq+a2CrYNgRzNaP8/YjXt39WeI9PfYrgzkSozVG7IE2ol8q+Gr
   c=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 12 Oct 2021 11:59:58 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 11:59:58 -0700
Received: from [10.111.175.121] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Tue, 12 Oct 2021
 11:59:56 -0700
Message-ID: <e89087c5-c495-c5ca-feb1-54cf3a8775c5@quicinc.com>
Date:   Tue, 12 Oct 2021 14:59:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 1/5] PCI/VPD: Add pci_read/write_vpd_any()
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
 <93ecce28-a158-f02a-d134-8afcaced8efe@gmail.com>
From:   Qian Cai <quic_qiancai@quicinc.com>
In-Reply-To: <93ecce28-a158-f02a-d134-8afcaced8efe@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2021 2:22 AM, Heiner Kallweit wrote:
> In certain cases we need a variant of pci_read_vpd()/pci_write_vpd() that
> does not check against dev->vpd.len. Such cases are:
> - reading VPD if dev->vpd.len isn't set yet (in pci_vpd_size())
> - devices that map non-VPD information to arbitrary places in VPD address
>   space (example: Chelsio T3 EEPROM write-protect flag)
> Therefore add function variants that check against PCI_VPD_MAX_SIZE only.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com
Reverting this series fixed a hang or stack overflow while reading things like,

/sys/devices/pci0000:00/0000:00:00.0/0000:01:00.0/vpd

[  125.797082] Insufficient stack space to handle exception!
[  125.797091] ESR: 0x96000047 -- DABT (current EL)
[  125.797095] FAR: 0xffff80002433ffc0
[  125.797096] Task stack:     [0xffff800024340000..0xffff800024350000]
[  125.797099] IRQ stack:      [0xffff8000101c0000..0xffff8000101d0000]
[  125.797102] Overflow stack: [0xffff009b675b02b0..0xffff009b675b12b0]
[  125.797106] CPU: 14 PID: 1550 Comm: lsbug Not tainted 5.15.0-rc5-next-20211012 #143
[  125.797110] Hardware name: MiTAC RAPTOR EV-883832-X3-0001/RAPTOR, BIOS 1.6 06/28/2020
[  125.797114] pstate: 10000005 (nzcV daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  125.797118] pc : pci_vpd_size+0xc/0x1f8
[  125.797128] lr : pci_vpd_read+0x2ec/0x420
[  125.797132] sp : ffff800024340060
[  125.797133] x29: ffff800024340060 x28: ffff00001a54cbcc x27: 0000000000000000
[  125.797142] x26: ffff800024340210 x25: 0000000000000004 x24: 1fffe000034a9979
[  125.797148] x23: ffff00001a54cbc8 x22: ffff00001a54cb38 x21: 0000000000008000
[  125.797153] x20: 1fffe000034a9979 x19: ffff00001a54c000 x18: 0000000000000000
[  125.797158] x17: 0000000000000000 x16: 0000000000000000 x15: dfff800000000000
[  125.797163] x14: ffff800019ab0560 x13: 1fffe00110f9272f x12: ffff60010e945be1
[  125.797168] x11: 1fffe0010e945be0 x10: 1ffff00004868022 x9 : ffff800010d1a38c
[  125.797174] x8 : ffff700004868022 x7 : dfff800000000000 x6 : 0000000000000000
[  125.797179] x5 : ffff000887c93540 x4 : 0000000000000000 x3 : ffff800024340210
[  125.797184] x2 : 0000000000000001 x1 : 0000000000000003 x0 : ffff00001a54c000
[  125.797190] Kernel panic - not syncing: kernel stack overflow
[  125.797193] CPU: 14 PID: 1550 Comm: lsbug Not tainted 5.15.0-rc5-next-20211012 #143
[  125.797197] Hardware name: MiTAC RAPTOR EV-883832-X3-0001/RAPTOR, BIOS 1.6 06/28/2020
[  125.797199] Call trace:
[  125.797201]  dump_backtrace+0x0/0x3b8
[  125.797208]  show_stack+0x20/0x30
[  125.797212]  dump_stack_lvl+0x8c/0xb8
[  125.797216]  dump_stack+0x1c/0x38
[  125.797219]  panic+0x2b0/0x538
[  125.797224]  add_taint+0x0/0xe8
[  125.797229]  panic_bad_stack+0x1e4/0x230
[  125.797233]  handle_bad_stack+0x38/0x50
[  125.797237]  __bad_stack+0x88/0x8c
[  125.797241]  pci_vpd_size+0xc/0x1f8
[  125.797244]  __pci_read_vpd+0x114/0x158
[  125.797247]  pci_vpd_size+0xa0/0x1f8
[  125.797251]  pci_vpd_read+0x2ec/0x420
[  125.797254]  __pci_read_vpd+0x114/0x158
[  125.797258]  pci_vpd_size+0xa0/0x1f8
[  125.797261]  pci_vpd_read+0x2ec/0x420
...
[  125.798534]  __pci_read_vpd+0x114/0x158
[  125.798538]  pci_vpd_size+0xa0/0x1f8
[  125.798541]  pci_vpd_read+0x2ec/0x420
[  125.798545]  __pci_read_vpd+0x114/0x158
__pci_read_vpd at /usr/src/linux-next/drivers/pci/vpd.c:398
[  125.798548]  vpd_read+0x28/0x38
vpd_read at /usr/src/linux-next/drivers/pci/vpd.c:276
[  125.798551]  sysfs_kf_bin_read+0x120/0x218
[  125.798556]  kernfs_fop_read_iter+0x244/0x4a8
[  125.798559]  new_sync_read+0x2bc/0x4e8
[  125.798564]  vfs_read+0x18c/0x390
[  125.798567]  ksys_read+0xf8/0x1e0
[  125.798570]  __arm64_sys_read+0x74/0xa8
[  125.798574]  invoke_syscall.constprop.0+0xdc/0x1d8
[  125.798578]  do_el0_svc+0xe4/0x298
[  125.798582]  el0_svc+0x64/0x130
[  125.798586]  el0t_64_sync_handler+0xb0/0xb8
[  125.798590]  el0t_64_sync+0x180/0x184
[  125.798598] ------------[ cut here ]------------
[  125.798600] WARNING: CPU: -32 PID: 1550 at include/linux/cpumask.h:108 smp_send_stop+0x4a4/0x5e8
[  125.798607] Modules linked in: loop cppc_cpufreq efivarfs ip_tables x_tables ext4 mbcache jbd2 dm_mod igb i2c_algo_bit nvme mlx5_core i2c_core nvme_core firmware_class
[  125.798632] CPU: 791961908 PID: 1550 Comm: lsbug Not tainted 5.15.0-rc5-next-20211012 #143
[  125.798637] Hardware name: MiTAC RAPTOR EV-883832-X3-0001/RAPTOR, BIOS 1.6 06/28/2020
[  125.798639] pstate: a00003c5 (NzCv DAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  125.798643] pc : smp_send_stop+0x4a4/0x5e8
[  125.798647] lr : panic+0x2b8/0x538
[  125.798650] sp : ffff009b675b0c70
[  125.798652] x29: ffff009b675b0c70 x28: ffff000887c92ec0 x27: 0000000000000000
[  125.798658] x26: 0000000000000025 x25: ffff809b55bf0000 x24: ffff800011eeb4d0
[  125.798663] x23: ffff800011426680 x22: ffff800019393000 x21: ffff800019dfa000
[  125.798668] x20: 00000000ffffffe0 x19: ffff8000119c0000 x18: 0000000000000000
[  125.798673] x17: 0000000000000000 x16: 0000000000000002 x15: 0000000000000000
[  125.798678] x14: 0000000000000000 x13: 000000000000000f x12: ffff7000023ef669
[  125.798683] x11: 1ffff000023ef668 x10: ffff7000023ef668 x9 : ffff80001133f2cc
[  125.798688] x8 : 0000000000000003 x7 : 0000000000000001 x6 : ffff800011f7b340
[  125.798693] x5 : 1fffe0136ceb619e x4 : 0000000041b58ab3 x3 : 1fffe0136ceb6000
[  125.798698] x2 : 1ffff000023dd69a x1 : 0000000000000000 x0 : 0000000000000020
[  125.798704] Call trace:
[  125.798705]  smp_send_stop+0x4a4/0x5e8
[  125.798709]  panic+0x2b8/0x538
[  125.798713]  add_taint+0x0/0xe8
[  125.798717]  panic_bad_stack+0x1e4/0x230
[  125.798720]  handle_bad_stack+0x38/0x50
[  125.798724]  __bad_stack+0x88/0x8c
[  125.798727]  pci_vpd_size+0xc/0x1f8
[  125.798731]  __pci_read_vpd+0x114/0x158
[  125.798734]  pci_vpd_size+0xa0/0x1f8
[  125.798738]  pci_vpd_read+0x2ec/0x420
[  125.798741]  __pci_read_vpd+0x114/0x158
[  125.798744]  pci_vpd_size+0xa0/0x1f8
[  125.798748]  pci_vpd_read+0x2ec/0x420  
