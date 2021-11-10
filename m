Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA0944CE09
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 00:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhKJXyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 18:54:43 -0500
Received: from mga18.intel.com ([134.134.136.126]:29709 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232016AbhKJXyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 18:54:43 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="219708967"
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="219708967"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 15:51:55 -0800
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="582978551"
Received: from wson-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.125.254])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 15:51:54 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net v2] bpf: Fix build when CONFIG_BPF_SYSCALL is disabled
In-Reply-To: <CAADnVQKqjLM1P7X+iTfnH-QFw5=z5L_w8MLsWtcNWbh5QR7VVg@mail.gmail.com>
References: <20211110205418.332403-1-vinicius.gomes@intel.com>
 <20211110212553.e2xnltq3dqduhjnj@apollo.localdomain>
 <CAADnVQKqjLM1P7X+iTfnH-QFw5=z5L_w8MLsWtcNWbh5QR7VVg@mail.gmail.com>
Date:   Wed, 10 Nov 2021 15:51:53 -0800
Message-ID: <878rxvbmcm.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

>> Thanks for the fix.
>>
>> But instead of moving this to core.c, you can probably make the btf.h
>> declaration conditional on CONFIG_BPF_SYSCALL, since this is not useful in
>> isolation (only used by verifier for module kfunc support). For the case of
>> kfunc_btf_id_list variables, just define it as an empty struct and static
>> variables, since the definition is still inside btf.c. So it becomes a noop for
>> !CONFIG_BPF_SYSCALL.
>>
>> I am also not sure whether BTF is useful without BPF support, but maybe I'm
>> missing some usecase.
>
> Unlikely. I would just disallow such config instead of sprinkling
> the code with ifdefs.

Is something like this what you have in mind?

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6fdbf9613aec..eae860c86e26 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -316,6 +316,7 @@ config DEBUG_INFO_BTF
 	bool "Generate BTF typeinfo"
 	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
 	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
+	depends on BPF_SYSCALL
 	help
 	  Generate deduplicated BTF type information from DWARF debug info.
 	  Turning this on expects presence of pahole tool, which will convert


Cheers,
-- 
Vinicius
