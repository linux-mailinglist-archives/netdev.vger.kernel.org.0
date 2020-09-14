Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611D7268ADC
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 14:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgINM0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 08:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgINMY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 08:24:56 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9392220E;
        Mon, 14 Sep 2020 12:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600086050;
        bh=YriLuLaFHzLfRAoXWiSCNiRverNlmw+ZAkR2pmdisCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lAyrt8Msk+qgwcGynhjL1jG4JJFYSkJICoVwEG5X9Ki7q5+u+PiE6K8WMcPcy+ceH
         U+kw1F/b3sDTAl7If26HeT3jr9hABXjuKmlYEJWe5CIisAHxCp/aTHbi1ce6fuL/AR
         RengwapvOITAcODLACP75ilW4+B3IOrCJUaO4k+g=
Date:   Mon, 14 Sep 2020 13:20:43 +0100
From:   Will Deacon <will@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     bpf@vger.kernel.org, ardb@kernel.org, naresh.kamboju@linaro.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200914122042.GA24441@willie-the-truck>
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:36:21AM +0300, Ilias Apalodimas wrote:
> Running the eBPF test_verifier leads to random errors looking like this:
> 
> [ 6525.735488] Unexpected kernel BRK exception at EL1
> [ 6525.735502] Internal error: ptrace BRK handler: f2000100 [#1] SMP
> [ 6525.741609] Modules linked in: nls_utf8 cifs libdes libarc4 dns_resolver fscache binfmt_misc nls_ascii nls_cp437 vfat fat aes_ce_blk crypto_simd cryptd aes_ce_cipher ghash_ce gf128mul efi_pstore sha2_ce sha256_arm64 sha1_ce evdev efivars efivarfs ip_tables x_tables autofs4 btrfs blake2b_generic xor xor_neon zstd_compress raid6_pq libcrc32c crc32c_generic ahci xhci_pci libahci xhci_hcd igb libata i2c_algo_bit nvme realtek usbcore nvme_core scsi_mod t10_pi netsec mdio_devres of_mdio gpio_keys fixed_phy libphy gpio_mb86s7x
> [ 6525.787760] CPU: 3 PID: 7881 Comm: test_verifier Tainted: G        W         5.9.0-rc1+ #47
> [ 6525.796111] Hardware name: Socionext SynQuacer E-series DeveloperBox, BIOS build #1 Jun  6 2020
> [ 6525.804812] pstate: 20000005 (nzCv daif -PAN -UAO BTYPE=--)
> [ 6525.810390] pc : bpf_prog_c3d01833289b6311_F+0xc8/0x9f4
> [ 6525.815613] lr : bpf_prog_d53bb52e3f4483f9_F+0x38/0xc8c
> [ 6525.820832] sp : ffff8000130cbb80
> [ 6525.824141] x29: ffff8000130cbbb0 x28: 0000000000000000
> [ 6525.829451] x27: 000005ef6fcbf39b x26: 0000000000000000
> [ 6525.834759] x25: ffff8000130cbb80 x24: ffff800011dc7038
> [ 6525.840067] x23: ffff8000130cbd00 x22: ffff0008f624d080
> [ 6525.845375] x21: 0000000000000001 x20: ffff800011dc7000
> [ 6525.850682] x19: 0000000000000000 x18: 0000000000000000
> [ 6525.855990] x17: 0000000000000000 x16: 0000000000000000
> [ 6525.861298] x15: 0000000000000000 x14: 0000000000000000
> [ 6525.866606] x13: 0000000000000000 x12: 0000000000000000
> [ 6525.871913] x11: 0000000000000001 x10: ffff8000000a660c
> [ 6525.877220] x9 : ffff800010951810 x8 : ffff8000130cbc38
> [ 6525.882528] x7 : 0000000000000000 x6 : 0000009864cfa881
> [ 6525.887836] x5 : 00ffffffffffffff x4 : 002880ba1a0b3e9f
> [ 6525.893144] x3 : 0000000000000018 x2 : ffff8000000a4374
> [ 6525.898452] x1 : 000000000000000a x0 : 0000000000000009
> [ 6525.903760] Call trace:
> [ 6525.906202]  bpf_prog_c3d01833289b6311_F+0xc8/0x9f4
> [ 6525.911076]  bpf_prog_d53bb52e3f4483f9_F+0x38/0xc8c
> [ 6525.915957]  bpf_dispatcher_xdp_func+0x14/0x20
> [ 6525.920398]  bpf_test_run+0x70/0x1b0
> [ 6525.923969]  bpf_prog_test_run_xdp+0xec/0x190
> [ 6525.928326]  __do_sys_bpf+0xc88/0x1b28
> [ 6525.932072]  __arm64_sys_bpf+0x24/0x30
> [ 6525.935820]  el0_svc_common.constprop.0+0x70/0x168
> [ 6525.940607]  do_el0_svc+0x28/0x88
> [ 6525.943920]  el0_sync_handler+0x88/0x190
> [ 6525.947838]  el0_sync+0x140/0x180
> [ 6525.951154] Code: d4202000 d4202000 d4202000 d4202000 (d4202000)
> [ 6525.957249] ---[ end trace cecc3f93b14927e2 ]---
> 
> The reason seems to be the offset[] creation and usage ctx->offset[]

"seems to be"? Are you unsure?

> while building the eBPF body.  The code currently omits the first 
> instruction, since build_insn() will increase our ctx->idx before saving 
> it.  When "taken loop with back jump to 1st insn" test runs it will
> eventually call bpf2a64_offset(-1, 2, ctx). Since negative indexing is
> permitted, the current outcome depends on the value stored in
> ctx->offset[-1], which has nothing to do with our array.
> If the value happens to be 0 the tests will work. If not this error
> triggers.
> 
> So let's fix it by creating the ctx->offset[] correctly in the first
> place and account for the extra instruction while calculating the arm
> instruction offsets.

No Fixes: tag?

> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>

Non-author signoffs here. What's going on?

Will
