Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E7026DA6D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 13:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIQLiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 07:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgIQLis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 07:38:48 -0400
Received: from localhost.localdomain (unknown [31.124.44.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E674F208DB;
        Thu, 17 Sep 2020 11:38:42 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>, bpf@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, ardb@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, KP Singh <kpsingh@chromium.org>,
        Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org,
        naresh.kamboju@linaro.org, luke.r.nels@gmail.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>, xi.wang@gmail.com,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, Zi Shen Lim <zlim.lnx@gmail.com>
Subject: Re: [PATCH v3] arm64: bpf: Fix branch offset in JIT
Date:   Thu, 17 Sep 2020 12:38:41 +0100
Message-Id: <160034270905.31412.2297717371363448460.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200917084925.177348-1-ilias.apalodimas@linaro.org>
References: <20200917084925.177348-1-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 11:49:25 +0300, Ilias Apalodimas wrote:
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
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: bpf: Fix branch offset in JIT
      https://git.kernel.org/arm64/c/32f6865c7aa3

-- 
Catalin

