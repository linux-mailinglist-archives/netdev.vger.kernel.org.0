Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C159D18B2EB
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 13:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgCSMEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 08:04:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:47298 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgCSMEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 08:04:51 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEtum-0005Mt-Qx; Thu, 19 Mar 2020 13:04:44 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEtum-0004Xo-D4; Thu, 19 Mar 2020 13:04:44 +0100
Subject: Re: [PATCH bpf-next v6] bpf: Support llvm-objcopy for vmlinux BTF
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Fangrui Song <maskray@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
References: <20200318222746.173648-1-maskray@google.com>
 <87tv2kd4hn.fsf@mpe.ellerman.id.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b5d153ad-23fe-a367-100b-ea9f19ae6958@iogearbox.net>
Date:   Thu, 19 Mar 2020 13:04:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87tv2kd4hn.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25755/Wed Mar 18 14:14:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 11:27 AM, Michael Ellerman wrote:
> Fangrui Song <maskray@google.com> writes:
>> Simplify gen_btf logic to make it work with llvm-objcopy. The existing
>> 'file format' and 'architecture' parsing logic is brittle and does not
>> work with llvm-objcopy/llvm-objdump.
>> 'file format' output of llvm-objdump>=11 will match GNU objdump, but
>> 'architecture' (bfdarch) may not.
>>
>> .BTF in .tmp_vmlinux.btf is non-SHF_ALLOC. Add the SHF_ALLOC flag
>> because it is part of vmlinux image used for introspection. C code can
>> reference the section via linker script defined __start_BTF and
>> __stop_BTF. This fixes a small problem that previous .BTF had the
>> SHF_WRITE flag (objcopy -I binary -O elf* synthesized .data).
>>
>> Additionally, `objcopy -I binary` synthesized symbols
>> _binary__btf_vmlinux_bin_start and _binary__btf_vmlinux_bin_stop (not
>> used elsewhere) are replaced with more commonplace __start_BTF and
>> __stop_BTF.
>>
>> Add 2>/dev/null because GNU objcopy (but not llvm-objcopy) warns
>> "empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"
>>
>> We use a dd command to change the e_type field in the ELF header from
>> ET_EXEC to ET_REL so that lld will accept .btf.vmlinux.bin.o.  Accepting
>> ET_EXEC as an input file is an extremely rare GNU ld feature that lld
>> does not intend to support, because this is error-prone.
>>
>> The output section description .BTF in include/asm-generic/vmlinux.lds.h
>> avoids potential subtle orphan section placement issues and suppresses
>> --orphan-handling=warn warnings.
>>
>> v6:
>> - drop llvm-objdump from the title. We don't run objdump now
>> - delete unused local variables: bin_arch, bin_format and bin_file
>> - mention in the comment that lld does not allow an ET_EXEC input
>> - rename BTF back to .BTF . The section name is assumed by bpftool
>> - add output section description to include/asm-generic/vmlinux.lds.h
>> - mention cb0cc635c7a9 ("powerpc: Include .BTF section")
>>
>> v5:
>> - rebase on top of bpf-next/master
>> - rename .BTF to BTF
>>
>> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
>> Fixes: cb0cc635c7a9 ("powerpc: Include .BTF section")
>> Link: https://github.com/ClangBuiltLinux/linux/issues/871
>> Signed-off-by: Fangrui Song <maskray@google.com>
>> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
>> Reviewed-by: Stanislav Fomichev <sdf@google.com>
>> Tested-by: Stanislav Fomichev <sdf@google.com>
>> Cc: Alexei Starovoitov <ast@kernel.org>
>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>> Cc: Nick Desaulniers <ndesaulniers@google.com>
>> Cc: clang-built-linux@googlegroups.com

Applied, thanks everyone!
