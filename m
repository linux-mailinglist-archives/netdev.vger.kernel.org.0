Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDFF44CDA9
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 00:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhKJXN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 18:13:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:1725 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhKJXN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 18:13:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="232656626"
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="232656626"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 15:10:39 -0800
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="492321714"
Received: from wson-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.125.254])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 15:10:39 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH net v2] bpf: Fix build when CONFIG_BPF_SYSCALL is disabled
In-Reply-To: <20211110212553.e2xnltq3dqduhjnj@apollo.localdomain>
References: <20211110205418.332403-1-vinicius.gomes@intel.com>
 <20211110212553.e2xnltq3dqduhjnj@apollo.localdomain>
Date:   Wed, 10 Nov 2021 15:10:38 -0800
Message-ID: <87o86rbo9d.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Thu, Nov 11, 2021 at 02:24:18AM IST, Vinicius Costa Gomes wrote:
>> When CONFIG_DEBUG_INFO_BTF is enabled and CONFIG_BPF_SYSCALL is
>> disabled, the following compilation error can be seen:
>>
>>   GEN     .version
>>   CHK     include/generated/compile.h
>>   UPD     include/generated/compile.h
>>   CC      init/version.o
>>   AR      init/built-in.a
>>   LD      vmlinux.o
>>   MODPOST vmlinux.symvers
>>   MODINFO modules.builtin.modinfo
>>   GEN     modules.builtin
>>   LD      .tmp_vmlinux.btf
>> ld: net/ipv4/tcp_cubic.o: in function `cubictcp_unregister':
>> net/ipv4/tcp_cubic.c:545: undefined reference to `bpf_tcp_ca_kfunc_list'
>> ld: net/ipv4/tcp_cubic.c:545: undefined reference to `unregister_kfunc_btf_id_set'
>> ld: net/ipv4/tcp_cubic.o: in function `cubictcp_register':
>> net/ipv4/tcp_cubic.c:539: undefined reference to `bpf_tcp_ca_kfunc_list'
>> ld: net/ipv4/tcp_cubic.c:539: undefined reference to `register_kfunc_btf_id_set'
>>   BTF     .btf.vmlinux.bin.o
>> pahole: .tmp_vmlinux.btf: No such file or directory
>>   LD      .tmp_vmlinux.kallsyms1
>> .btf.vmlinux.bin.o: file not recognized: file format not recognized
>> make: *** [Makefile:1187: vmlinux] Error 1
>>
>> 'bpf_tcp_ca_kfunc_list', 'register_kfunc_btf_id_set()' and
>> 'unregister_kfunc_btf_id_set()' are only defined when
>> CONFIG_BPF_SYSCALL is enabled.
>>
>> Fix that by moving those definitions somewhere that doesn't depend on
>> the bpf() syscall.
>>
>> Fixes: 14f267d95fe4 ("bpf: btf: Introduce helpers for dynamic BTF set registration")
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>
> Thanks for the fix.
>
> But instead of moving this to core.c, you can probably make the btf.h
> declaration conditional on CONFIG_BPF_SYSCALL, since this is not useful in
> isolation (only used by verifier for module kfunc support). For the case of
> kfunc_btf_id_list variables, just define it as an empty struct and static
> variables, since the definition is still inside btf.c. So it becomes a noop for
> !CONFIG_BPF_SYSCALL.
>
> I am also not sure whether BTF is useful without BPF support, but maybe I'm
> missing some usecase.

From my side, you are not missing anything, it was just random chance
that I had a 'x86_64_defconfig + debug + BTF' .config laying around and
the build broke with it. I don't have any real usecases for this
combination.


Cheers,
-- 
Vinicius
