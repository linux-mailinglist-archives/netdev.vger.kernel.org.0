Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424111140F8
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 13:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbfLEMph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 07:45:37 -0500
Received: from fd.dlink.ru ([178.170.168.18]:34278 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbfLEMph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 07:45:37 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id BA9151B2120E; Thu,  5 Dec 2019 15:45:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru BA9151B2120E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1575549934; bh=/HwG0dFNg/hWKid+bfXzTVGWal/DPp90hVFX4aHbrbc=;
        h=Date:From:To:Cc:Subject;
        b=h0qVKVkg/afttyYI0TPqWQxoWE7CX/0o+OlWKNMDa38VoiEfPQIwqQ9gEzuxu3AuI
         I+1TS9e8R/GXiVI+s2UXnwl76b7/Mugj7pyWAuMN3pdNxAtt2GEPvco0nwCjyd9T6v
         EEL3gg/GLINRC37K0Zf5KkF1sgD13+VgW4Zzf0Vs=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 31A891B20153;
        Thu,  5 Dec 2019 15:45:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 31A891B20153
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id CB0771B217D8;
        Thu,  5 Dec 2019 15:45:27 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Thu,  5 Dec 2019 15:45:27 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 05 Dec 2019 15:45:27 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Paul Burton <paul.burton@mips.com>
Cc:     Hassan Naveed <hnaveed@wavecomp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: MIPS eBPF JIT support on pre-32R2
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <09d713a59665d745e21d021deeaebe0a@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,

I'm writing about lines arch/mips/net/ebpf_jit.c:1806-1807:

	if (!prog->jit_requested || MIPS_ISA_REV < 2)
		return prog;

Do pre-32R2 architectures (32R1, maybe even R3000-like) actually support
this eBPF JIT code? If they do, then the condition 'MIPS_ISA_REV < 2'
should be removed as it is always true for them and tells CC to remove
JIT completely.

If they don't support instructions from this JIT, then the line
arch/mips/Kconfig:50:

	select HAVE_EBPF_JIT if (!CPU_MICROMIPS)

should be changed to something like:

	select HAVE_EBPF_JIT if !CPU_MICROMIPS && TARGET_ISA_REV >= 2

(and then the mentioned 'if' condition would become redundant)

At the moment it is possible to build a kernel without both JIT and
interpreter, but with CONFIG_BPF_SYSCALL=y (what should not be allowed
I suppose?) within the following configuration:

- select any pre-32R2 CPU (e.g. CONFIG_CPU_MIPS32_R1);
- enable CONFIG_BPF_JIT (CONFIG_MIPS_EBPF_JIT will be autoselected);
- enable CONFIG_BPF_JIT_ALWAYS_ON (this removes BPF interpreter from
   the system).

I may prepare a proper patch by myself if needed (after clarification).
Thanks.

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
