Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1353944CF72
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhKKCH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:07:27 -0500
Received: from mga06.intel.com ([134.134.136.31]:57468 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233156AbhKKCH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 21:07:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="293657960"
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="293657960"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 18:04:39 -0800
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="470622106"
Received: from wson-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.125.254])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 18:04:38 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net v2] bpf: Fix build when CONFIG_BPF_SYSCALL is disabled
In-Reply-To: <20211111001359.3v2yjha5nxkdtoju@apollo.localdomain>
References: <20211110205418.332403-1-vinicius.gomes@intel.com>
 <20211110212553.e2xnltq3dqduhjnj@apollo.localdomain>
 <CAADnVQKqjLM1P7X+iTfnH-QFw5=z5L_w8MLsWtcNWbh5QR7VVg@mail.gmail.com>
 <878rxvbmcm.fsf@intel.com>
 <20211111001359.3v2yjha5nxkdtoju@apollo.localdomain>
Date:   Wed, 10 Nov 2021 18:04:38 -0800
Message-ID: <87v90za1mx.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kartikeya,

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Thu, Nov 11, 2021 at 05:21:53AM IST, Vinicius Costa Gomes wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> >> Thanks for the fix.
>> >>
>> >> But instead of moving this to core.c, you can probably make the btf.h
>> >> declaration conditional on CONFIG_BPF_SYSCALL, since this is not useful in
>> >> isolation (only used by verifier for module kfunc support). For the case of
>> >> kfunc_btf_id_list variables, just define it as an empty struct and static
>> >> variables, since the definition is still inside btf.c. So it becomes a noop for
>> >> !CONFIG_BPF_SYSCALL.
>> >>
>> >> I am also not sure whether BTF is useful without BPF support, but maybe I'm
>> >> missing some usecase.
>> >
>> > Unlikely. I would just disallow such config instead of sprinkling
>> > the code with ifdefs.
>>
>> Is something like this what you have in mind?
>>
>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>> index 6fdbf9613aec..eae860c86e26 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -316,6 +316,7 @@ config DEBUG_INFO_BTF
>>  	bool "Generate BTF typeinfo"
>>  	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
>>  	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
>> +	depends on BPF_SYSCALL
>>  	help
>>  	  Generate deduplicated BTF type information from DWARF debug info.
>>  	  Turning this on expects presence of pahole tool, which will convert
>>
>>
>
> BTW, you will need a little more than that, I suspect the compiler optimizes out
> the register/unregister call so we don't see a build failure, but adding a side
> effect gives me errors, so something like this should resolve the problem (since
> kfunc_btf_id_list variable definition is behind CONFIG_BPF_SYSCALL).
>
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 203eef993d76..e9881ef9e9aa 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -254,6 +254,8 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
>                                  struct kfunc_btf_id_set *s);
>  bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
>                               struct module *owner);
> +extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
> +extern struct kfunc_btf_id_list prog_test_kfunc_list;
>  #else
>  static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
>                                              struct kfunc_btf_id_set *s)
> @@ -268,13 +270,13 @@ static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
>  {
>         return false;
>  }
> +struct kfunc_btf_id_list {};
> +static struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list __maybe_unused;
> +static struct kfunc_btf_id_list prog_test_kfunc_list __maybe_unused;
> +
>  #endif
>
>  #define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
>         struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
>                                          THIS_MODULE }
> -
> -extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
> -extern struct kfunc_btf_id_list prog_test_kfunc_list;
> -
>  #endif
>

I could not reproduce the build failure here even when adding some side
effects, but I didn't try very hard.

As you are more familiar with the code, I would be glad if you could
take it from here and propose a patch.


Cheers,
-- 
Vinicius
