Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CAA69F8FA
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 17:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjBVQ2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 11:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjBVQ2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 11:28:35 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E4A2940E;
        Wed, 22 Feb 2023 08:28:33 -0800 (PST)
Received: from maxwell ([109.42.114.8]) by mrelayeu.kundenserver.de (mreue009
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1MbAYi-1oy1880Ct6-00bbfz; Wed, 22
 Feb 2023 17:28:04 +0100
User-agent: mu4e 1.8.14; emacs 28.2
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Issue: stmmac reset by netdev watchdog due to tx queue timeout
Date:   Wed, 22 Feb 2023 16:53:30 +0100
Message-ID: <87h6vd64xa.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:eXK3AxMuJS1hcJLRRf0qoul7g4NEQJdLjS6qyfVX2/uTjPaMkPk
 JWW/zIBd8bY1TBJ+/kwrA6tgTNyUfd0R/NIxiLTjvqQwWwnwZQYEsl17Eim7rKF+/fhUf8A
 OVfiK8VmpyOtZCubFaRwVgSR26H5+e32zPh2cH/q7/wp8iFlbsLZqrMuuVbR5Iydxe9MxSz
 rlm1L8X1Hyg5RBebOm35w==
UI-OutboundReport: notjunk:1;M01:P0:hk6ahaYRXS8=;tZW8w/fGFjV6JNx5mHHvBgYJmfa
 c4VMUUaR/A00ZHPEhXeZMzOgHYRBczLzxF38GzQ7aEBNhZzYaOAGNjLIH205gtpn9od8F9jtw
 6eOX1LbQ0TTU88D4ZbaJ1tIj0W/yYtyJt1Y+DmBAx4vrpj8K7RH5vhFPuSO/mmBZRfBY/FyZ9
 ZyeVtJdKU0Ey8LDaZ5WmbqdqhQMSJaBCtReZhQuEFEVkxqyQsLdk8vvNCwKQaQvALDSTYZZTm
 9KkfrI+ezOw/6dmOgltQkHTogsJpTruRLL0ErA3ILJdVf+0fV6rTRp6hGAEqNb2gncfwGZVK0
 cmI/oRCdMw87PXQQkh5ow2iVClHjorW0ttxVmwBkpFSAouHIlUu2nW8XseurBFAeVqtr8ns7O
 ubXQUX42pb1txm34kdaPXrJuZKtu1EkDCUmxUzT9Ls+DvqhSPcEBoWpLpMosAwrExr5uvYSFc
 o0FPlhU/4qJHSXs3s8MRrprGqjYP6vvmMEOfg4f2bYpy6/W1h7QSUjZJQ+q5pjmkYTroeAq7C
 Dw0LhYhkvGFdC3hTgQSk6xdb3Wvjr+yl0BlotJ/Aw1d11Dt9iNH3VLNhxUMM/elBiN1Zx0QyX
 d/C4xEYqhF8j7gHK3KwS8fBi4rE7liD7hFwu9L6b2lUwTxvrGvHgYk3NdOY5SKipNUpFsxsbX
 Ez3bDHlFQIAjTmJvTAEUGKHlzvNGLm7OYhvXhHgf9w==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have been debugging an issue with the stmmac network driver and the
Intel Elkhart Lake SoC for quite some time now. The problem comes up
when a port forwarding is configured with iptables NAT like this:

iptables -t nat -A PREROUTING -p tcp --dport 222 \
         -j DNAT --to-destination 192.168.178.134:22
iptables -t nat -A POSTROUTING -p tcp --dst 192.168.178.134 \
         --dport 22 j SNAT --to-source 192.168.178.138

If I 'ssh -p 222 192.168.178.138' the sttmac is reset after some seconds
with:

[  553.050018] NETDEV WATCHDOG: eno1 (intel-eth-pci): transmit queue 0 timed out
[  553.050048] WARNING: CPU: 2 PID: 0 at net/sched/sch_generic.c:525 dev_watchdog+0x23a/0x250
[  553.050059] Modules linked in: nft_chain_nat xt_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_tcpudp nft_compat nf_tables libcrc32c nfnetlink snd_seq_dummy snd_hrtimer snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic ledtrig_audio snd_sof_pci_intel_tgl snd_sof_intel_hda_common soundwire_intel soundwire_generic_allocation soundwire_cadence snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp snd_sof snd_sof_utils snd_soc_hdac_hda snd_hda_ext_core snd_soc_acpi_intel_match binfmt_misc snd_soc_acpi soundwire_bus snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec intel_rapl_msr snd_hda_core intel_rapl_common snd_hwdep x86_pkg_temp_thermal intel_powerclamp snd_pcm coretemp nls_iso8859_1 snd_seq_midi kvm_intel snd_seq_midi_event snd_rawmidi mei_hdcp i915 kvm mei_pxp snd_seq crct10dif_pclmul ghash_clmulni_intel snd_seq_device sha512_ssse3 drm_buddy ttm cmdlinepart aesni_intel snd_timer spi_nor crypto_simd
[  553.050187]  drm_display_helper mtd cryptd snd intel_cstate cec rc_core joydev intel_wmi_thunderbolt drm_kms_helper soundcore i2c_algo_bit mei_me syscopyarea input_leds sysfillrect mei 8250_dw sysimgblt igen6_edac mac_hid intel_hid acpi_pad acpi_tad sparse_keymap msr parport_pc ppdev lp parport drm pstore_blk ramoops pstore_zone reed_solomon efi_pstore ip_tables x_tables autofs4 hid_logitech_hidpp hid_logitech_dj hid_generic usbhid uas hid usb_storage mxl_gpy polynomial mmc_block dwmac_intel spi_intel_pci i2c_i801 intel_ish_ipc gpio_kempld i2c_kempld crc32_pclmul spi_intel intel_ishtp i2c_smbus stmmac intel_lpss_pci ahci sdhci_pci xhci_pci intel_lpss xhci_pci_renesas pcs_xpcs cqhci libahci video phylink sdhci idma64 kempld_core i2c_scmi wmi pinctrl_elkhartlake(+)
[  553.050354] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D            6.2.0-rc8+ #22
[  553.050360] Hardware name: Default string Default string/COMe-mEL10 E2, BIOS MEL1R904 11/02/2022
[  553.050363] RIP: 0010:dev_watchdog+0x23a/0x250
[  553.050370] Code: 00 e9 2b ff ff ff 48 89 df c6 05 de 01 83 01 01 e8 fb 25 f8 ff 44 89 f1 48 89 de 48 c7 c7 a8 cd c0 a6 48 89 c2 e8 24 53 20 00 <0f> 0b e9 1c ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00
[  553.050373] RSP: 0018:ffffbfc34018ce38 EFLAGS: 00010246
[  553.050378] RAX: 0000000000000000 RBX: ffffa0d392b68000 RCX: 0000000000000000
[  553.050381] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  553.050384] RBP: ffffbfc34018ce68 R08: 0000000000000000 R09: 0000000000000000
[  553.050386] R10: 0000000000000000 R11: 0000000000000000 R12: ffffa0d392b684c8
[  553.050389] R13: ffffa0d392b6841c R14: 0000000000000000 R15: 0000000000000000
[  553.050392] FS:  0000000000000000(0000) GS:ffffa0d4e4300000(0000) knlGS:0000000000000000
[  553.050395] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  553.050398] CR2: 000055da1a873000 CR3: 000000023fc10000 CR4: 0000000000350ee0
[  553.050402] Call Trace:
[  553.050406]  <IRQ>
[  553.050413]  ? __pfx_dev_watchdog+0x10/0x10
[  553.050419]  call_timer_fn+0x29/0x160
[  553.050425]  ? __pfx_dev_watchdog+0x10/0x10
[  553.050429]  __run_timers+0x259/0x310
[  553.050434]  run_timer_softirq+0x1d/0x40
[  553.050437]  __do_softirq+0xd6/0x346
[  553.050444]  ? hrtimer_interrupt+0x11f/0x230
[  553.050449]  __irq_exit_rcu+0xa2/0xd0
[  553.050455]  irq_exit_rcu+0xe/0x20
[  553.050459]  sysvec_apic_timer_interrupt+0x92/0xd0
[  553.050465]  </IRQ>
[  553.050467]  <TASK>
[  553.050469]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
[  553.050475] RIP: 0010:cpuidle_enter_state+0xde/0x6f0
[  553.050481] Code: 7f 1b 5a e8 14 2f 4e ff 8b 53 04 49 89 c7 0f 1f 44 00 00 31 ff e8 22 40 4d ff 80 7d d0 00 0f 85 eb 00 00 00 fb 0f 1f 44 00 00 <45> 85 f6 0f 88 12 02 00 00 4d 63 ee 49 83 fd 09 0f 87 c7 04 00 00
[  553.050484] RSP: 0018:ffffbfc340113e38 EFLAGS: 00000246
[  553.050489] RAX: 0000000000000000 RBX: ffffa0d4e433c930 RCX: 0000000000000000
[  553.050492] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000000
[  553.050494] RBP: ffffbfc340113e88 R08: 0000000000000000 R09: 0000000000000000
[  553.050496] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa76bb700
[  553.050499] R13: 0000000000000003 R14: 0000000000000003 R15: 00000080c45910fe
[  553.050504]  ? cpuidle_enter_state+0xce/0x6f0
[  553.050508]  cpuidle_enter+0x2e/0x50
[  553.050512]  do_idle+0x216/0x2a0
[  553.050517]  cpu_startup_entry+0x1d/0x20
[  553.050521]  start_secondary+0x122/0x160
[  553.050527]  secondary_startup_64_no_verify+0xe5/0xeb
[  553.050535]  </TASK>
[  553.050537] ---[ end trace 0000000000000000 ]---
[  553.050584] intel-eth-pci 0000:00:1d.1 eno1: Reset adapter.
[  553.064639] intel-eth-pci 0000:00:1d.1 eno1: FPE workqueue stop
[  553.065416] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-0
[  553.066003] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-1
[  553.066469] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-2
[  553.066933] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-3
[  553.067428] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-4
[  553.067895] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-5
[  553.068466] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-6
[  553.069025] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-7
[  553.082011] dwmac4: Master AXI performs any burst length
[  553.082094] intel-eth-pci 0000:00:1d.1 eno1: Enabling Safety Features
[  553.082138] intel-eth-pci 0000:00:1d.1 eno1: IEEE 1588-2008 Advanced Timestamp supported
[  553.082438] intel-eth-pci 0000:00:1d.1 eno1: registered PTP clock
[  553.082641] intel-eth-pci 0000:00:1d.1 eno1: FPE workqueue start
[  553.082649] intel-eth-pci 0000:00:1d.1 eno1: configuring for inband/sgmii link mode
[  553.083700] intel-eth-pci 0000:00:1d.1 eno1: Link is Up - 1Gbps/Full - flow control off

This does not happen during normal ssh to the EHL board, this does not
happen if I do port forwarding through userspace, e. g. with socat. And
this does not happen if two independent network interfaces are used in
the iptables rules. I have not observed the issue with other network
chips with the same kernel version so I think the issue must be in the
stmmac driver.

What happens is that the OWNED bit of a DMA descriptor is not reset
(detected in dwmac4_wrback_get_tx_status()) and the queue's txtimer is
looping endlessly until the timeout resets everything. Sometimes the
situation is solved before the timeout, most of the times it is not but
i always takes long until the OWNED bit is reset. This can be reproduced
with 100% success.

I have tried to understand where the issue comes from and I think it may
have something to do with the calls to dma_wmb() and wmb() (or more
precisely with missing barriers) but so far I had no success to solve it
and provide a patch.

The kernel that I am running is a quite recent linux-net
(b60417a9f2b8). I have also tried with linux-net-next without
success. The issue can already be observed with v5.15.39.

Any help or suggestion how I can debug this further would be
appreciated. Or if somebody else can reproduce or not reproduce the
issue on the given platform may help as well.

Regards
-Jochen
