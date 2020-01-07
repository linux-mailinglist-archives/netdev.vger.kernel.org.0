Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F755133474
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgAGU7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 15:59:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgAGU7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B19A2087F;
        Tue,  7 Jan 2020 20:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430744;
        bh=+8/l5PDbTPjHpcojaSQlovgVrTLf3sxj8sgQ4f4RTCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xd/I2THQfD9fwWq2l0VueCBWyySIJ5qh/674ou4KpZKnl0eqCh0l0rN8zZu9VSU10
         vZEvBNSSNzj6o+sdQX2b+AKBJWqap/Rnxx66DrQXxVo7ryRTHPz31xMmeCTZ0joGxd
         AUBFhLLs1JULdhrj7F6+95Z1UohgxF8nOkJUpZpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@dlink.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 5.4 077/191] MIPS: BPF: eBPF JIT: check for MIPS ISA compliance in Kconfig
Date:   Tue,  7 Jan 2020 21:53:17 +0100
Message-Id: <20200107205337.103399328@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

commit f596cf0d8062cb5d0a4513a8b3afca318c13be10 upstream.

It is completely wrong to check for compile-time MIPS ISA revision in
the body of bpf_int_jit_compile() as it may lead to get MIPS JIT fully
omitted by the CC while the rest system will think that the JIT is
actually present and works [1].
We can check if the selected CPU really supports MIPS eBPF JIT at
configure time and avoid such situations when kernel can be built
without both JIT and interpreter, but with CONFIG_BPF_SYSCALL=y.

[1] https://lore.kernel.org/linux-mips/09d713a59665d745e21d021deeaebe0a@dlink.ru/

Fixes: 716850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32 architecture.")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Hassan Naveed <hnaveed@wavecomp.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/Kconfig        |    2 +-
 arch/mips/net/ebpf_jit.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -46,7 +46,7 @@ config MIPS
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES
 	select HAVE_ASM_MODVERSIONS
-	select HAVE_EBPF_JIT if (64BIT && !CPU_MICROMIPS)
+	select HAVE_EBPF_JIT if 64BIT && !CPU_MICROMIPS && TARGET_ISA_REV >= 2
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1803,7 +1803,7 @@ struct bpf_prog *bpf_int_jit_compile(str
 	unsigned int image_size;
 	u8 *image_ptr;
 
-	if (!prog->jit_requested || MIPS_ISA_REV < 2)
+	if (!prog->jit_requested)
 		return prog;
 
 	tmp = bpf_jit_blind_constants(prog);


