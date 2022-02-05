Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2E24AAACC
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 19:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353311AbiBESOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 13:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbiBESOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 13:14:20 -0500
X-Greylist: delayed 29279 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Feb 2022 10:14:14 PST
Received: from mxout017.mail.hostpoint.ch (mxout017.mail.hostpoint.ch [IPv6:2a00:d70:0:e::317])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8133CC061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 10:14:14 -0800 (PST)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nGPZb-0000Re-VW; Sat, 05 Feb 2022 19:14:11 +0100
Received: from [2001:1620:50ce:1969:65d6:ee42:8561:f134]
        by asmtp013.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nGPZb-000JRk-S8; Sat, 05 Feb 2022 19:14:11 +0100
X-Authenticated-Sender-Id: thomas@kupper.org
Message-ID: <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
Date:   Sat, 5 Feb 2022 19:14:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
From:   Thomas Kupper <thomas@kupper.org>
In-Reply-To: <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 05.02.22 um 16:51 schrieb Tom Lendacky:
> On 2/5/22 04:06, Thomas Kupper wrote:
>> Hi,
>>
>> I got an OPNsense DEC740 firewall which is based on the AMD V1500B CPU.
>>
>> OPNsense runs fine on it but on Linux I'm not able to get the 10GbE 
>> interfaces to work.
>>
>> My test setup is based on Ubuntu 21.10 Impish Indri with a v5.17-rc2 
>> kernel compiled from Mr Torvalds sources, tag v5.17-rc2. The second 
>> 10GbE interface (enp6s0f2) is set to receive the IP by DHCPv4.
>>
>> The relevant dmesg entries after boot are:
>>
>> [    4.763712] libphy: amd-xgbe-mii: probed
>> [    4.782850] amd-xgbe 0000:06:00.1 eth0: net device enabled
>> [    4.800625] libphy: amd-xgbe-mii: probed
>> [    4.803192] amd-xgbe 0000:06:00.2 eth1: net device enabled
>> [    4.841151] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
>> [    5.116617] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>>
>> After that I see a link up on the switch for enp6s0f2 and the switch 
>> reports 10G link speed.
>>
>> ethtool reports:
>>
>> $ sudo ethtool enp6s0f2
>> Settings for enp6s0f2:
>>          Supported ports: [ FIBRE ]
>>          Supported link modes:   Not reported
>>          Supported pause frame use: No
>>          Supports auto-negotiation: No
>>          Supported FEC modes: Not reported
>>          Advertised link modes:  Not reported
>>          Advertised pause frame use: No
>>          Advertised auto-negotiation: No
>>          Advertised FEC modes: Not reported
>>          Speed: Unknown!
>>          Duplex: Unknown! (255)
>>          Auto-negotiation: off
>>          Port: None
>>          PHYAD: 0
>>          Transceiver: internal
>>          Current message level: 0x00000034 (52)
>>                                 link ifdown ifup
>>          Link detected: no
>>
>>
>> Manually assigning an IP and pull the interface up and I end up with:
>>
>> $ sudo ifconfig enp6s0f2 up
>>
>> SIOCSIFFLAGS: Device or resource busy
>>
>> ... and dmesg reports:
>>
>> [  648.038655] genirq: Flags mismatch irq 59. 00000000 (enp6s0f2-pcs) 
>> vs. 00000000 (enp6s0f2-pcs)
>> [  648.048303] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
>>
>> After that the lights are out on the switch for that port and it 
>> reports 'no link'
>>
>> Would that be an known issue or is that configuration simply not yet 
>> supported?
>>
>
> Reloading the module and specify the dyndbg option to get some 
> additional debug output.
>
> I'm adding Shyam to the thread, too, as I'm not familiar with the 
> configuration for this chip.
>
> Thanks,
> Tom
>
>>
>> Kind Regards
>>
>> Thomas Kupper
>>
Thanks Tom for getting back to me so quick. After adding 
'amd_xgbe.dyndbg=+p' to the kernel command line here the output of 
dmesg. Probably the most interesting is the output after running 'rmmod'.

Right after boot:

[    5.352977] amd-xgbe 0000:06:00.1 eth0: net device enabled
[    5.354198] amd-xgbe 0000:06:00.2 eth1: net device enabled
...
[    5.382185] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
[    5.426931] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
...
[    9.701637] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
[    9.701679] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
[    9.701715] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
[    9.738191] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
[    9.738219] amd-xgbe 0000:06:00.2 enp6s0f2: starting I2C
...
[   10.742622] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox command 
did not complete
[   10.742710] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox reset 
performed
[   10.750813] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
[   10.768366] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
[   10.768371] amd-xgbe 0000:06:00.2 enp6s0f2: fixed PHY configuration

Then after 'ifconfig enp6s0f2 up':

[  189.184928] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
[  189.191828] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
[  189.191863] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
[  189.191894] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
[  189.196338] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
[  189.198792] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
[  189.212036] genirq: Flags mismatch irq 69. 00000000 (enp6s0f2-pcs) 
vs. 00000000 (enp6s0f2-pcs)
[  189.221700] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
[  189.231051] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
[  189.231054] amd-xgbe 0000:06:00.2 enp6s0f2: stopping I2C

And after 'rmmod amd_xgbe':

[  278.324933] ------------[ cut here ]------------
[  278.324939] remove_proc_entry: removing non-empty directory 'irq/69', 
leaking at least 'enp6s0f2-pcs'
[  278.324952] WARNING: CPU: 0 PID: 796 at fs/proc/generic.c:715 
remove_proc_entry+0x196/0x1b0
[  278.324964] Modules linked in: nls_iso8859_1 intel_rapl_msr 
intel_rapl_common snd_hda_intel snd_intel_dspcfg edac_mce_amd 
snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_hwdep kvm snd_pcm rapl 
snd_
timer efi_pstore k10temp snd_rn_pci_acp3x snd soundcore snd_pci_acp3x 
ccp mac_hid sch_fq_codel msr drm ip_tables x_tables autofs4 btrfs 
blake2b_generic zstd_compress raid10 raid456 async_raid6_recov asyn
c_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 
multipath linear crct10dif_pclmul crc32_pclmul ghash_clmulni_intel 
aesni_intel crypto_simd igb nvme cryptd dca amd_xgbe(-) xhci_pci
  i2c_piix4 i2c_amd_mp2_pci xhci_pci_renesas i2c_algo_bit nvme_core 
video spi_amd
[  278.325038] CPU: 0 PID: 796 Comm: rmmod Not tainted 5.17.0-rc2-tk #8
[  278.325043] Hardware name: Deciso B.V. DEC2700 - OPNsense 
Appliance/Netboard-A10 Gen.3, BIOS 05.32.50.0012-A10.20 11/15/2021
[  278.325046] RIP: 0010:remove_proc_entry+0x196/0x1b0
[  278.325052] Code: a8 1d 9e 84 48 85 c0 48 8d 90 78 ff ff ff 48 0f 45 
c2 49 8b 54 24 78 4c 8b 80 a0 00 00 00 48 8b 92 a0 00 00 00 e8 28 53 81 
00 <0f> 0b e9 44 ff ff ff e8 6e bd 87 00 66 66 2e 0f 1f 84
  00 00 00 00
[  278.325055] RSP: 0018:ffff954d81027b00 EFLAGS: 00010286
[  278.325059] RAX: 0000000000000000 RBX: ffff89350022dc00 RCX: 
0000000000000000
[  278.325062] RDX: 0000000000000001 RSI: ffffffff849bc031 RDI: 
00000000ffffffff
[  278.325064] RBP: ffff954d81027b30 R08: 0000000000000000 R09: 
ffff954d810278f0
[  278.325066] R10: ffff954d810278e8 R11: ffffffff84d55f48 R12: 
ffff89351996a780
[  278.325068] R13: ffff89351996a800 R14: 0000000000000046 R15: 
0000000000000046
[  278.325070] FS:  00007f8a17115400(0000) GS:ffff89352ae00000(0000) 
knlGS:0000000000000000
[  278.325073] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  278.325075] CR2: 00007f1fac1391a0 CR3: 00000001104b6000 CR4: 
00000000003506f0
[  278.325078] Call Trace:
[  278.325080] <TASK>
[  278.325085] unregister_irq_proc+0xe4/0x110
[  278.325093] free_desc+0x2e/0x70
[  278.325098] irq_free_descs+0x50/0x80
[  278.325102] irq_domain_free_irqs+0x16b/0x1c0
[  278.325107] __msi_domain_free_irqs+0xf1/0x160
[  278.325114] msi_domain_free_irqs_descs_locked+0x20/0x50
[  278.325118] pci_msi_teardown_msi_irqs+0x49/0x50
[  278.325124] pci_disable_msix.part.0+0xff/0x160
[  278.325128] pci_free_irq_vectors+0x45/0x60
[  278.325132]  xgbe_pci_remove+0x24/0x40 [amd_xgbe]
[  278.325151] pci_device_remove+0x39/0xa0
[  278.325157] __device_release_driver+0x181/0x250
[  278.325163] driver_detach+0xd3/0x120
[  278.325166]  bus_remove_driver+0x59/0xd0
[  278.325169]  driver_unregister+0x31/0x50
[  278.325172]  pci_unregister_driver+0x40/0x90
[  278.325177]  xgbe_pci_exit+0x15/0x20 [amd_xgbe]
[  278.325192]  xgbe_mod_exit+0x9/0x8b0 [amd_xgbe]
[  278.325207]  __do_sys_delete_module.constprop.0+0x183/0x290
[  278.325214]  ? __fput+0x123/0x260
[  278.325219]  __x64_sys_delete_module+0x12/0x20
[  278.325223]  do_syscall_64+0x5c/0xc0
[  278.325228]  ? fpregs_assert_state_consistent+0x26/0x50
[  278.325234]  ? exit_to_user_mode_prepare+0x49/0x1e0
[  278.325239]  ? syscall_exit_to_user_mode+0x27/0x50
[  278.325244]  ? __x64_sys_close+0x11/0x40
[  278.325248]  ? do_syscall_64+0x69/0xc0
[  278.325251]  ? __x64_sys_close+0x11/0x40
[  278.325254]  ? do_syscall_64+0x69/0xc0
[  278.325257]  ? irqentry_exit+0x33/0x40
[  278.325261]  ? exc_page_fault+0x89/0x180
[  278.325265]  ? asm_exc_page_fault+0x8/0x30
[  278.325269]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  278.325274] RIP: 0033:0x7f8a172448eb
[  278.325278] Code: 73 01 c3 48 8b 0d 45 e5 0e 00 f7 d8 64 89 01 48 83 
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 15 e5 0e 00 f7 d8
  64 89 01 48
[  278.325280] RSP: 002b:00007ffe3a968e98 EFLAGS: 00000206 ORIG_RAX: 
00000000000000b0
[  278.325284] RAX: ffffffffffffffda RBX: 00007f8a190dc760 RCX: 
00007f8a172448eb
[  278.325286] RDX: 000000000000000a RSI: 0000000000000800 RDI: 
00007f8a190dc7c8
[  278.325288] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000000
[  278.325289] R10: 00007f8a172dcac0 R11: 0000000000000206 R12: 
00007ffe3a9690f8
[  278.325291] R13: 00007ffe3a969847 R14: 00007f8a190dc2a0 R15: 
00007f8a190dc760
[  278.325296]  </TASK>
[  278.325298] ---[ end trace 0000000000000000 ]---
[  278.922700] irq 31: nobody cared (try booting with the "irqpoll" option)
[  278.930195] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G W         
5.17.0-rc2-tk #8
[  278.930201] Hardware name: Deciso B.V. DEC2700 - OPNsense 
Appliance/Netboard-A10 Gen.3, BIOS 05.32.50.0012-A10.20 11/15/2021
[  278.930204] Call Trace:
[  278.930206]  <IRQ>
[  278.930210]  dump_stack_lvl+0x4c/0x63
[  278.930219]  dump_stack+0x10/0x12
[  278.930223]  __report_bad_irq+0x3a/0xaf
[  278.930228]  note_interrupt.cold+0xb/0x60
[  278.930232]  ? __this_cpu_preempt_check+0x13/0x20
[  278.930238]  handle_irq_event+0x71/0x80
[  278.930244]  handle_fasteoi_irq+0x95/0x1e0
[  278.930249]  __common_interrupt+0x6e/0x110
[  278.930254]  common_interrupt+0xbd/0xe0
[  278.930258]  </IRQ>
[  278.930259]  <TASK>
[  278.930261]  asm_common_interrupt+0x1e/0x40
[  278.930265] RIP: 0010:cpuidle_enter_state+0xdf/0x380
[  278.930273] Code: ff e8 e5 88 73 ff 80 7d d7 00 74 17 9c 58 0f 1f 44 
00 00 f6 c4 02 0f 85 82 02 00 00 31 ff e8 d8 9e 7a ff fb 66 0f 1f 44 00 
00 <45> 85 ff 0f 88 1a 01 00 00 49 63 d7 4c 89 f1 48 2b 4d
  c8 48 8d 04
[  278.930277] RSP: 0018:ffff954d800e3e68 EFLAGS: 00000246
[  278.930281] RAX: ffff89352af00000 RBX: 0000000000000002 RCX: 
000000000000001f
[  278.930284] RDX: 0000000000000000 RSI: ffffffff849bc031 RDI: 
ffffffff849cab7f
[  278.930287] RBP: ffff954d800e3ea0 R08: 00000040f1169c00 R09: 
00000040d2207b5c
[  278.930289] R10: 0000000000000001 R11: ffff89352af2fd84 R12: 
ffff893501907000
[  278.930291] R13: ffffffff84e6e3c0 R14: 00000040f1169c00 R15: 
0000000000000002
[  278.930297]  ? cpuidle_enter_state+0xbb/0x380
[  278.930302]  cpuidle_enter+0x2e/0x40
[  278.930307]  do_idle+0x203/0x290
[  278.930313]  cpu_startup_entry+0x20/0x30
[  278.930316]  start_secondary+0x118/0x150
[  278.930322]  secondary_startup_64_no_verify+0xd5/0xdb
[  278.930330]  </TASK>
[  278.930331] handlers:
[  278.932870] [<000000000a369c68>] amd_mp2_irq_isr [i2c_amd_mp2_pci]
[  278.939782] Disabling IRQ #31


Cheers
/Thomas

