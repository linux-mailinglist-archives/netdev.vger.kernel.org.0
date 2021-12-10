Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B8546FDB5
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhLJJ3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:29:30 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45214 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239448AbhLJJ31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:29:27 -0500
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639128351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SbfqRvUEuwXlh3IgpzftBaSjJPxLuVUDM5Hle0yirKc=;
        b=1CiwUTXjYzIN67Dy+42lXh6uk19p6P6p/eDuevwDWA0bm8PTcfefc7t/nVnJSq+G4CgrJg
        PEsVCWksvOWEXe7JDF9rEZB4pgY3YnfOvY3fESJcfL4Rh6R3IRb2cG7AfopB5O/CCvs3mh
        KeEGq5OS2En5+hD/tqPw8Y/5SLuF7CC0T/ADxigMKQvy8mSJmYlpKs2oUo1vFCu/nEQiQa
        KX29EHlurv0GbqJz1EcA4RBHsyrZbAPkvlBgHmPqe0ZnI/PwvPBGvt8jInCV3rg/VXclQq
        YFRORRxuV50XrtDi8Ob4UlVfyFpgfvSwQ0GvPwKghRbMDZPtQH35brtWCvPF0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639128351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SbfqRvUEuwXlh3IgpzftBaSjJPxLuVUDM5Hle0yirKc=;
        b=j67PQmV09+izrduHq93q1lvJNYCCRDoO0q6hvhkLVk4BUfiFctFmpkKv8cvohtEOWsnrdx
        33jca16PkKb3urDg==
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 1/2] net: stmmac: fix tc flower deletion for
 VLAN priority Rx steering
In-Reply-To: <20211209151631.138326-2-boon.leong.ong@intel.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
 <20211209151631.138326-2-boon.leong.ong@intel.com>
Date:   Fri, 10 Dec 2021 10:25:49 +0100
Message-ID: <87lf0szu8y.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi BL,

On Thu Dec 09 2021, Ong Boon Leong wrote:
> To replicate the issue:-
>
> 1) Add 2 flower filters for VLAN Priority based frame steering:-
> $ IFDEVNAME=eth0
> $ tc qdisc add dev $IFDEVNAME ingress
> $ tc qdisc add dev $IFDEVNAME root mqprio num_tc 8 \
>    map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0 \
>    queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
> $ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
>    flower vlan_prio 0 hw_tc 0
> $ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
>    flower vlan_prio 1 hw_tc 1
>
> 2) Get the 'pref' id
> $ tc filter show dev $IFDEVNAME ingress
>
> 3) Delete a specific tc flower record
> $ tc filter del dev $IFDEVNAME parent ffff: pref 49151
>
> From dmesg, we will observe kernel NULL pointer ooops
>
> [  197.170464] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  197.171367] #PF: supervisor read access in kernel mode
> [  197.171367] #PF: error_code(0x0000) - not-present page
> [  197.171367] PGD 0 P4D 0
> [  197.171367] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  197.171367] CPU: 0 PID: 3216 Comm: tc Tainted: G     U      E     5.16.0-rc2+ #12
> [  197.171367] Hardware name: Intel Corporation Elkhart Lake Embedded Platform/ElkhartLake LPDDR4x T3 CRB, BIOS EHLSFWI1.R00.3273.A04.2107240322 07/24/2021
> [  197.171367] RIP: 0010:tc_setup_cls+0x20b/0x4a0 [stmmac]
> [  197.171367] Code: fe ff ff c7 43 14 00 00 00 00 48 c7 03 00 00 00 00 c7 43 1c 00 00 00 00 49 8b 44 24 28 48 8b bd b0 00 00 00 41 0f b7 54 24 58 <48> 8b 00 0f bf 8f 38 08 00 00 81 ea e0 ff 00 00 8b 00 25 00 04 00
> [  197.171367] RSP: 0018:ffff940940a037c0 EFLAGS: 00010246
> [  197.171367] RAX: 0000000000000000 RBX: ffff92e826cae2c8 RCX: ffff92e825f39000
> [  197.171367] RDX: 0000000000000000 RSI: ffff92e826cae2a8 RDI: ffff92e82f0c0000
> [  197.171367] RBP: ffff92e82f0c0940 R08: 0000000000000000 R09: ffff92e825f39434
> [  197.171367] R10: ffff92e826c5af00 R11: ffff940940a038a8 R12: ffff940940a038a8
> [  197.171367] R13: 0000000000000000 R14: 0000000000000000 R15: ffff92e830a5b600
> [  197.171367] FS:  00007fa7b0c47740(0000) GS:ffff92e964200000(0000) knlGS:0000000000000000
> [  197.171367] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  197.171367] CR2: 0000000000000000 CR3: 0000000124c50000 CR4: 0000000000350ef0
> [  197.171367] Call Trace:
> [  197.171367]  <TASK>
> [  197.171367]  ? __stmmac_disable_all_queues+0xa8/0xe0 [stmmac]
> [  197.171367]  stmmac_setup_tc_block_cb+0x70/0x110 [stmmac]
> [  197.171367]  tc_setup_cb_destroy+0xb3/0x180
> [  197.171367]  fl_hw_destroy_filter+0x94/0xc0 [cls_flower]
> [  197.171367]  __fl_delete+0x16a/0x180 [cls_flower]
> [  197.171367]  fl_destroy+0xb9/0x140 [cls_flower]
> [  197.171367]  tcf_proto_destroy+0x1d/0xa0
> [  197.171367]  tc_del_tfilter+0x3c9/0x7b0
> [  197.171367]  ? tc_dump_tfilter+0x310/0x310
> [  197.171367]  rtnetlink_rcv_msg+0x2bf/0x370
> [  197.171367]  ? preempt_count_add+0x68/0xa0
> [  197.171367]  ? _raw_spin_lock_irqsave+0x19/0x40
> [  197.171367]  ? _raw_spin_unlock_irqrestore+0x1f/0x31
> [  197.171367]  ? rtnl_calcit.isra.0+0x130/0x130
> [  197.171367]  netlink_rcv_skb+0x4e/0x100
> [  197.171367]  netlink_unicast+0x18e/0x230
> [  197.171367]  netlink_sendmsg+0x245/0x480
> [  197.171367]  sock_sendmsg+0x5b/0x60
> [  197.171367]  ____sys_sendmsg+0x20b/0x280
> [  197.171367]  ? copy_msghdr_from_user+0x5c/0x90
> [  197.171367]  ___sys_sendmsg+0x7c/0xc0
> [  197.171367]  ? folio_add_lru+0x52/0x80
> [  197.171367]  ? __sys_sendto+0xee/0x160
> [  197.171367]  __sys_sendmsg+0x59/0xa0
> [  197.171367]  do_syscall_64+0x40/0x90
> [  197.171367]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  197.171367] RIP: 0033:0x7fa7b0d64397
> [  197.171367] Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> [  197.171367] RSP: 002b:00007ffdd88b58e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [  197.171367] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa7b0d64397
> [  197.171367] RDX: 0000000000000000 RSI: 00007ffdd88b5960 RDI: 0000000000000003
> [  197.171367] RBP: 0000000061b05c21 R08: 0000000000000001 R09: 0000564584e47890
> [  197.171367] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> [  197.171367] R13: 00007ffdd88b9a80 R14: 00000000bfff0000 R15: 0000564584e3e420
> [  197.171367]  </TASK>
> [  197.171367] Modules linked in: cls_flower sch_mqprio sch_ingress dwmac_intel(E) stmmac(E) pcs_xpcs phylink marvell marvell10g libphy 8021q bnep bluetooth ecryptfs nfsd sch_fq_codel uio uhid snd_soc_dmic snd_sof_pci_intel_tgl x86_pkg_temp_thermal snd_sof_intel_hda_common kvm_intel iTCO_wdt iTCO_vendor_support soundwire_intel mei_hdcp kvm soundwire_generic_allocation soundwire_cadence soundwire_bus irqbypass snd_sof_xtensa_dsp ax88179_178a snd_soc_acpi_intel_match intel_rapl_msr pcspkr usbnet snd_soc_acpi mii snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec i2c_i801 snd_hda_core intel_ish_ipc tpm_crb 8250_lpss intel_ishtp tpm_tis i915 mei_me i2c_smbus mei tpm_tis_core dw_dmac_core tpm spi_dw_pci parport_pc intel_pmc_core spi_dw thermal parport ttm fuse configfs snd_sof_pci snd_sof snd_soc_core snd_compress ac97_bus ledtrig_audio snd_pcm snd_timer snd soundcore [last unloaded: libphy]
> [  197.171367] CR2: 0000000000000000
> [  197.171367] ---[ end trace 8b8d1c617c39093d ]---
>
> This patch reimplements the tc flower rx frame steering for VLAN priority
> by keeping a record of flow_cls_offload added. The implementation also
> makes way to support EtherType based RX frame steering later.
>
> Fixes: 0e039f5cf86c ("net: stmmac: add RX frame steering based on VLAN priority in tc flower")
> Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

You submitted this patch to net as well. I guess, it should be merged to
net. After net is merged into net-next we can proceed with the EtherType
steering?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJSBAEBCgA8FiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGzHR0eHGt1cnQua2Fu
emVuYmFjaEBsaW51dHJvbml4LmRlAAoJEHkqW4HLmPCmO1QQALW0VY0C8Q0MJsuS
BaGQOE35anf51Mv5icU/3iJOemihglf2VXRwXAzPnlV5OP6roG5ExGORhB0DQMPy
M0JnvRtEoR0RP+8wJB2fhExlEW8balruDDhOJxRtBENROll6ER4AIGK35cBvj6zb
5EkvQLAX5ZCYJARfZmaBidNmFN14mzvJVLYBXEnvnRZAA0NIM0zB8yiaC3pbIDRz
/eP8nIux8fSM/NIWbiVrvtQzDwpaFe0WDCZzYqXsUeXjNWMQZiXq4/wAFBJF4HqR
Uy9qGKIHyL7gabhe4SZM199iMTVxFLQpRXHh/H8WHXCbS5UTMayZTvEEsakfzG+4
IPjUUpsoWz1Op3v/yz8mrLa+whF6jZYzjvx0WEWGAxNqpeVKQjNEWM0FDjFCqK5h
B9ShT/Q1vkiOtTtqwpSGsnqO4dbDwAIeVTEmVLBHlzdtkJaJmDdC/wSfFvokWIs1
fhq+J1xYH6JCEPINykHWF2BF7AEWG7ft4BR9BpvhAExgnEedHI/JCLVEhMAS+uaS
RkongEd0ScivdYMYm0ZnjzlQ2ABnjyTGGzkv9afg1nTXNs2OTRp4b1ZWH/HgoC47
0Gqp03WaLOgvXKxjySYWiMrfuG2S41oqI7PsN0PEmXBHe8UeciglSCncQr/KwaKD
i4HQl3F3hCjcYcfYERrDuO8cebmv
=Jyh0
-----END PGP SIGNATURE-----
--=-=-=--
