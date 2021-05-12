Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A681E37ED0E
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385082AbhELUG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:06:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:50852 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376530AbhELSzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 14:55:00 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lgtzF-0005go-Cu; Wed, 12 May 2021 20:53:37 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lgtzF-000E9J-6j; Wed, 12 May 2021 20:53:37 +0200
Subject: Re: linux-next: Tree for May 12 (arch/x86/net/bpf_jit_comp32.o)
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20210512175623.2687ac6f@canb.auug.org.au>
 <08f677a5-7634-b5d2-a532-ea6d3f35200c@infradead.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <daf46ee7-1a18-9d5a-c3b3-7fc55ec23b30@iogearbox.net>
Date:   Wed, 12 May 2021 20:53:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <08f677a5-7634-b5d2-a532-ea6d3f35200c@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26168/Wed May 12 13:07:33 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On 5/12/21 8:01 PM, Randy Dunlap wrote:
> On 5/12/21 12:56 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20210511:
>>
> 
> on i386:
> 
> ld: arch/x86/net/bpf_jit_comp32.o: in function `do_jit':
> bpf_jit_comp32.c:(.text+0x28c9): undefined reference to `__bpf_call_base'
> ld: arch/x86/net/bpf_jit_comp32.o: in function `bpf_int_jit_compile':
> bpf_jit_comp32.c:(.text+0x3694): undefined reference to `bpf_jit_blind_constants'
> ld: bpf_jit_comp32.c:(.text+0x3719): undefined reference to `bpf_jit_binary_free'
> ld: bpf_jit_comp32.c:(.text+0x3745): undefined reference to `bpf_jit_binary_alloc'
> ld: bpf_jit_comp32.c:(.text+0x37d3): undefined reference to `bpf_jit_prog_release_other'
> ld: kernel/extable.o: in function `search_exception_tables':
> extable.c:(.text+0x42): undefined reference to `search_bpf_extables'
> ld: kernel/extable.o: in function `kernel_text_address':
> extable.c:(.text+0xee): undefined reference to `is_bpf_text_address'
> ld: kernel/kallsyms.o: in function `kallsyms_lookup_size_offset':
> kallsyms.c:(.text+0x254): undefined reference to `__bpf_address_lookup'
> ld: kernel/kallsyms.o: in function `kallsyms_lookup_buildid':
> kallsyms.c:(.text+0x2ee): undefined reference to `__bpf_address_lookup'

Thanks for reporting, could you double check the following diff:

diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index 26b591e23f16..bd04f4a44c01 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -37,6 +37,7 @@ config BPF_SYSCALL

  config BPF_JIT
  	bool "Enable BPF Just In Time compiler"
+	depends on BPF
  	depends on HAVE_CBPF_JIT || HAVE_EBPF_JIT
  	depends on MODULES
  	help
