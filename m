Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12945273425
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 22:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgIUUwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 16:52:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:46180 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgIUUwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 16:52:45 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kKSni-00013z-Sc; Mon, 21 Sep 2020 22:52:42 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kKSni-000Gxg-Mw; Mon, 21 Sep 2020 22:52:42 +0200
Subject: Re: [PATCH bpf v1 0/3] fix BTF usage on embedded systems
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <cover.1600417359.git.Tony.Ambardar@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <898b6212-0521-6a37-c982-7bb2ef31264f@iogearbox.net>
Date:   Mon, 21 Sep 2020 22:52:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <cover.1600417359.git.Tony.Ambardar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25934/Mon Sep 21 15:52:04 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/20 7:01 AM, Tony Ambardar wrote:
> Hello,
> 
> I've been experimenting with BPF and BTF on small, emebedded platforms
> requiring cross-compilation to varying archs, word-sizes, and endianness.
> These environments are not the most common for the majority of eBPF users,
> and have exposed multiple problems with basic functionality. This patch
> series addresses some of these issues.
> 
> Enabling BTF support in the kernel can sometimes result in sysfs export
> of /sys/kernel/btf/vmlinux as a zero-length file, which is still readable
> and seen to leak non-zero kernel data. Patch #1 adds a sanity-check to
> avoid this situation.
> 
> Small systems commonly enable LD_DEAD_CODE_DATA_ELIMINATION, which causes
> the .BTF section data to be incorrectly removed and can trigger the problem
> above. Patch #2 preserves the BTF data.
> 
> Even if BTF data is generated and embedded in the kernel, it may be encoded
> as non-native endianness due to another bug [1] currently being worked on.
> Patch #3 lets bpftool recognize the wrong BTF endianness rather than output
> a confusing/misleading ELF header error message.
> 
> Patches #1 and #2 were first developed for Linux 5.4.x and should be
> backported if possible. Feedback and suggestions for improvement are
> welcome!
> 
> Thanks,
> Tony
> 
> [1] https://lore.kernel.org/bpf/CAPGftE8ipAacAnm9xMHFabXCL-XrCXGmOsX-Nsjvz9wnh3Zx-w@mail.gmail.com/
> 
> Tony Ambardar (3):
>    bpf: fix sysfs export of empty BTF section
>    bpf: prevent .BTF section elimination
>    libbpf: fix native endian assumption when parsing BTF
> 
>   include/asm-generic/vmlinux.lds.h | 2 +-
>   kernel/bpf/sysfs_btf.c            | 6 +++---
>   tools/lib/bpf/btf.c               | 6 ++++++
>   3 files changed, 10 insertions(+), 4 deletions(-)
> 

Applied, thanks!
