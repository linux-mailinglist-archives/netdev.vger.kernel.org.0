Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B8E64DFCA
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiLORhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLORhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:37:21 -0500
X-Greylist: delayed 380 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Dec 2022 09:37:19 PST
Received: from email.studentenwerk.mhn.de (mailin.studentenwerk.mhn.de [141.84.225.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4670629CB5;
        Thu, 15 Dec 2022 09:37:19 -0800 (PST)
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4NXzm00N79zRhTg;
        Thu, 15 Dec 2022 18:30:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1671125456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=O/PT2ChNLGC2cux6NliV6PIJ2JFRP5aYtPit3o1VDkA=;
        b=GEF6JMhFscQy35Rg9BO+oaXXEpfTltnyC3ewyYhSSNAoLGhAMCGL8dngTNvFGWXmbba9Ay
        yNZkZR2z2pBqzMaZf9IgK410xg3vUL2XHpoxrAr4cOqJF0D5kuh5NC81xfmtGbo/0JaGbO
        D59G4skkjloTp62srvs/N6dpEk7OMCdpmpsce1TRbukbJJXdHBMhCEui7hqiIEFXsTW5nm
        2YORKTemf7Cr+h4IQqvJ94R6K99dTe04XQICNSy40mI/gKPl9dSseQbFdwVCO0ZGqYXeb5
        4LDJDN6Du06+dGz8fFoC+oxHW0SlBAdXV8OlzF/p3C4Dy/ApsGm9y7vRkGQEeg==
MIME-Version: 1.0
Date:   Thu, 15 Dec 2022 18:31:16 +0100
From:   Wolfgang Walter <linux@stwm.de>
To:     linux-wireless@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: kernel v6.1: NULL pointer dereference in ieee80211_deliver_skb
Message-ID: <1585238f2dee5e2daafe28ba0606b6a4@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studentenwerk_M=C3=BCnchen?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

with kernel v6.1 I always get the following oops when running on a small 
router:

====================================================
Dez 14 18:14:29 knut systemd[1]: Started LSB: DHCP relay.
Dez 14 18:14:30 knut kernel: BUG: kernel NULL pointer dereference, 
address: 00000000000000a8
Dez 14 18:14:30 knut kernel: #PF: supervisor write access in kernel mode
Dez 14 18:14:30 knut kernel: #PF: error_code(0x0002) - not-present page
Dez 14 18:14:30 knut kernel: PGD 0 P4D 0
Dez 14 18:14:30 knut kernel: Oops: 0002 [#1] PREEMPT SMP PTI
Dez 14 18:14:30 knut kernel: CPU: 1 PID: 506 Comm: mt76-usb-rx phy 
Tainted: G            E      6.1.0-debian64x+1.7 #3
Dez 14 18:14:30 knut kernel: Hardware name: ZOTAC 
ZBOX-ID92/ZBOX-IQ01/ZBOX-ID92/ZBOX-IQ01, BIOS B220P007 05/21/2014
Dez 14 18:14:30 knut kernel: RIP: 0010:ieee80211_deliver_skb+0x62/0x1f0 
[mac80211]
Dez 14 18:14:30 knut kernel: Code: 00 48 89 04 24 e8 9e a7 c3 df 89 c0 
48 03 1c c5 a0 ea 39 a1 4c 01 6b 08 48 ff 03 48 83 7d 28 00 74 11 48 8b 
45 30 48 63 55 44 <48> 83 84 d0 a8 00 00 00 01 41 8b 86 c0 11 00 00 8d 
50 fd 83 fa 01
Dez 14 18:14:30 knut kernel: RSP: 0018:ffff999040803b10 EFLAGS: 00010286
Dez 14 18:14:30 knut kernel: RAX: 0000000000000000 RBX: ffffb9903f496480 
RCX: 0000000000000000
Dez 14 18:14:30 knut kernel: RDX: 0000000000000000 RSI: 0000000000000000 
RDI: 0000000000000000
Dez 14 18:14:30 knut kernel: RBP: ffff999040803ce0 R08: 0000000000000000 
R09: 0000000000000000
Dez 14 18:14:30 knut kernel: R10: 0000000000000000 R11: 0000000000000000 
R12: ffff8d21828ac900
Dez 14 18:14:30 knut kernel: R13: 000000000000004a R14: ffff8d2198ed89c0 
R15: ffff8d2198ed8000
Dez 14 18:14:30 knut kernel: FS:  0000000000000000(0000) 
GS:ffff8d24afe80000(0000) knlGS:0000000000000000
Dez 14 18:14:30 knut kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Dez 14 18:14:30 knut kernel: CR2: 00000000000000a8 CR3: 0000000429810002 
CR4: 00000000001706e0
Dez 14 18:14:30 knut kernel: Call Trace:
Dez 14 18:14:30 knut kernel:  <TASK>
Dez 14 18:14:30 knut kernel:  __ieee80211_rx_h_amsdu+0x1b5/0x240 
[mac80211]
Dez 14 18:14:30 knut kernel:  ? 
ieee80211_prepare_and_rx_handle+0xcdd/0x1320 [mac80211]
Dez 14 18:14:30 knut kernel:  ? __local_bh_enable_ip+0x3b/0xa0
Dez 14 18:14:30 knut kernel:  
ieee80211_prepare_and_rx_handle+0xcdd/0x1320 [mac80211]
Dez 14 18:14:30 knut kernel:  ? prepare_transfer+0x109/0x1a0 [xhci_hcd]
Dez 14 18:14:30 knut kernel:  ieee80211_rx_list+0xa80/0xda0 [mac80211]
Dez 14 18:14:30 knut kernel:  mt76_rx_complete+0x207/0x2e0 [mt76]
Dez 14 18:14:30 knut kernel:  mt76_rx_poll_complete+0x357/0x5a0 [mt76]
Dez 14 18:14:30 knut kernel:  mt76u_rx_worker+0x4f5/0x600 [mt76_usb]
Dez 14 18:14:30 knut kernel:  ? mt76_get_min_avg_rssi+0x140/0x140 [mt76]
Dez 14 18:14:30 knut kernel:  __mt76_worker_fn+0x50/0x80 [mt76]
Dez 14 18:14:30 knut kernel:  kthread+0xed/0x120
Dez 14 18:14:30 knut kernel:  ? kthread_complete_and_exit+0x20/0x20
Dez 14 18:14:30 knut kernel:  ret_from_fork+0x22/0x30
Dez 14 18:14:30 knut kernel:  </TASK>
Dez 14 18:14:30 knut kernel: Modules linked in: cmac(E) ccm(E) sit(E) 
tunnel4(E) ip_tunnel(E) bridge(E) tun(E) xt_hl(E) xt_LOG(E) 
nf_log_syslog(E) xt_nat(E) xt_connmark(E) xt_addrtype(E) xt_multiport(E) 
xt_tcpudp(E) xt_mark(E) xt_conntrack(E) xt_set(E) ip_set_hash_ip(E) 
ip_set_hash_net(E) ip_set(E) arptable_filter(E) arp_tables(E) ebt_arp(E) 
ebtable_nat(E) ebtable_broute(E) ebtable_filter(E) ebtables(E) 
ip6table_nat(E) ip6table_filter(E) ip6table_mangle(E) ip6table_raw(E) 
ip6_tables(E) iptable_nat(E) nf_nat(E) iptable_filter(E) 
iptable_mangle(E) iptable_raw(E) xt_socket(E) nf_socket_ipv4(E) 
nf_socket_ipv6(E) xt_helper(E) nf_conntrack_tftp(E) nf_conntrack_snmp(E) 
nf_conntrack_broadcast(E) nf_conntrack_sip(E

) nf_conntrack_irc(E) nf_conntrack_h323(E) nf_conntrack_ftp(E) 
nf_conntrack(E) dummy(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) 
intel_rapl_msr(E) intel_rapl_common(E) x86_pkg_temp_thermal(E) 
intel_powerclamp(E) coretemp(E) snd_hda_codec_hdmi(E) kvm_intel(E) 
binfmt_misc(E) kvm(E) irqbypass(E)
Dez 14 18:14:30 knut kernel:  polyval_clmulni(E) polyval_generic(E) 
gf128mul(E) mt76x2u(E) snd_hda_codec_realtek(E) ghash_clmulni_intel(E) 
mt76x2_common(E) snd_hda_codec_generic(E) sha512_ssse3(E) i915(E) 
mt76x02_usb(E) ledtrig_audio(E) mt76_usb(E) aesni_intel(E) rt2800usb(E) 
snd_hda_intel(E) drm_buddy(E) crypto_simd(E) btusb(E) cryptd(E) 
snd_intel_dspcfg(E) btrtl(E) mt76x02_lib(E) iwlmvm(E) rt2x00usb(E) 
rapl(E) btbcm(E) snd_intel_sdw_acpi(E) drm_display_helper(E) 
rt2800lib(E) mt76(E) btintel(E) mei_pxp(E) intel_cstate(E) mei_hdcp(E) 
snd_hda_codec(E) cec(E) rt2x00lib(E) btmtk(E) evdev(E) iwlwifi(E) 
mac80211(E) iTCO_wdt(E) snd_hda_core(E) intel_uncore(E) ttm(E) 
libarc4(E) intel_pmc_bxt(E) iTCO_vendor_support(E) snd_hwdep(E) 
pcspkr(E) at24(E) bluetooth(E) ir_rc6_decoder(E) watchdog(E) 
drm_kms_helper(E) snd_pcm(E) rtsx_usb_ms(E) mei_me(E) snd_timer(E) 
cfg80211(E) ecdh_generic(E) rc_rc6_mce(E) memstick(E) snd(E) ecc(E) 
rfkill(E) i2c_algo_bit(E) mei(E) soundcore(E) ite_cir(E) rc_core(E) 
button(E) sg(E)
Dez 14 18:14:30 knut kernel:  nf_tables(E) libcrc32c(E) nfnetlink(E) 
it87(E) hwmon_vid(E) 8021q(E) garp(E) mrp(E) stp(E) llc(E) drm(E) 
efi_pstore(E) fuse(E) configfs(E) ip_tables(E) x_tables(E) autofs4(E) 
ext4(E) crc32c_generic(E) crc16(E) mbcache(E) jbd2(E) rtsx_usb_sdmmc(E) 
mmc_core(E) rtsx_usb(E) sd_mod(E) t10_pi(E) crc64_rocksoft(E) crc64(E) 
crc_t10dif(E) crct10dif_generic(E) ahci(E) libahci(E) xhci_pci(E) 
r8169(E) libata(E) realtek(E) crct10dif_pclmul(E) crct10dif_common(E) 
mdio_devres(E) ehci_pci(E) xhci_hcd(E) ehci_hcd(E) i2c_i801(E) 
crc32_pclmul(E) crc32c_intel(E) scsi_mod(E) scsi_common(E) i2c_smbus(E) 
libphy(E) usbcore(E) lpc_ich(E) usb_common(E) fan(E) video(E) wmi(E)
Dez 14 18:14:30 knut kernel: CR2: 00000000000000a8
Dez 14 18:14:30 knut kernel: ---[ end trace 0000000000000000 ]---
====================================================

This happens when the wlan device is up (in AP mode). This device is 
again part of a bridge.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
