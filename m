Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A72A11412A
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 14:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbfLENEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 08:04:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:59854 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbfLENEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 08:04:14 -0500
Received: from 29.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.29] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1icqni-0007Pf-Bq; Thu, 05 Dec 2019 14:04:11 +0100
Date:   Thu, 5 Dec 2019 14:04:09 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     Paul Burton <paul.burton@mips.com>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: MIPS eBPF JIT support on pre-32R2
Message-ID: <20191205130409.GC29780@localhost.localdomain>
References: <09d713a59665d745e21d021deeaebe0a@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09d713a59665d745e21d021deeaebe0a@dlink.ru>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25654/Thu Dec  5 10:46:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 03:45:27PM +0300, Alexander Lobakin wrote:
> Hey all,
> 
> I'm writing about lines arch/mips/net/ebpf_jit.c:1806-1807:
> 
> 	if (!prog->jit_requested || MIPS_ISA_REV < 2)
> 		return prog;
> 
> Do pre-32R2 architectures (32R1, maybe even R3000-like) actually support
> this eBPF JIT code? If they do, then the condition 'MIPS_ISA_REV < 2'
> should be removed as it is always true for them and tells CC to remove
> JIT completely.
> 
> If they don't support instructions from this JIT, then the line
> arch/mips/Kconfig:50:
> 
> 	select HAVE_EBPF_JIT if (!CPU_MICROMIPS)
> 
> should be changed to something like:
> 
> 	select HAVE_EBPF_JIT if !CPU_MICROMIPS && TARGET_ISA_REV >= 2
> 
> (and then the mentioned 'if' condition would become redundant)
> 
> At the moment it is possible to build a kernel without both JIT and
> interpreter, but with CONFIG_BPF_SYSCALL=y (what should not be allowed
> I suppose?) within the following configuration:

Cannot comment on the MIPS ISA question above, but it would definiely be
a bug to build a kernel with neither JIT nor interpreter. If a JIT is not
available, then there /must/ be the interpreter as fallback to be able to
run BPF programs.

> - select any pre-32R2 CPU (e.g. CONFIG_CPU_MIPS32_R1);
> - enable CONFIG_BPF_JIT (CONFIG_MIPS_EBPF_JIT will be autoselected);
> - enable CONFIG_BPF_JIT_ALWAYS_ON (this removes BPF interpreter from
>   the system).
> 
> I may prepare a proper patch by myself if needed (after clarification).
> Thanks.
> 
> Regards,
> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
