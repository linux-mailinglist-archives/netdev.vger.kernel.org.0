Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2290B187839
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgCQDhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:37:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33644 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgCQDhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:37:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay11so8996530plb.0
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 20:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yA+sOfTo6eaYV72YV9c/n33EKYaKnOg8YUVIhA7CJQI=;
        b=EDZKf/O34udiLq1SZ/JDBsIZu7fsrG3yfDZtdfRETtZlvWDR8aqv/ocHujvNoLy4O7
         1LxcH6YOwIl4KnqCMUUDftFDHiK1kroFyEtNeC0oB9U5rFxv06U3b/PrJ5tRS01wD+mA
         CCO4fQDswsA94BOBSWW9LSvjjOOwhsMdzJ2KsQ4dERBA4efIOL2EuhqEqGnUwbsbMLTA
         MzqsEvsSeNNw7nqRMmiM/flHXt9QmKxZO3zdJbu0OMyDiZIMqmAEdmqbZUkoB3X56CE+
         R/wnZSuEZOHo3DV/LvmEEyuNNxKOOUWLCr8UNcUKjp1O0eQAGw1k1i1LC6Q58SRkroMm
         XTTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yA+sOfTo6eaYV72YV9c/n33EKYaKnOg8YUVIhA7CJQI=;
        b=ginrsY6v/vUcZZRCWEjNCED+pUeivKxfhXy/Y9zwz8NjaqWHMVf/TXi6xmuNMhpYMD
         vgAu4/aXLU1Gk3GgDqGmfoM5Y2buuy3Vf10MNBW1nKM+uai+uSErKa89bPLtFDi6f8Z/
         6c9NYQ0mCffJrQcr/o+vvLCSlBwc950BiDyAWvIjBC8sGh9JsJL47OJbXex6i/0fvhYn
         HWsUs68vSFrfAl20hGwJfYflvv36WOPKzuvCoIC5ANrk//1cvDQNsPUtaCDf7/S8fd4v
         nEpvAEubIwtBacUyDXsvrladH/3YkhtZWxgJEJ1HfY96GK2EIDOVABHmhFrlSi6PwlDj
         5Eqw==
X-Gm-Message-State: ANhLgQ0MrZAMEjfJDPQBXbsANiqyuGUxsU8LyjwMRjKmvk4AKDfqmATy
        G5S6GJQCQ6z/iWaSIRg3JmyHvYQ9hJpMgstF
X-Google-Smtp-Source: ADFU+vuQ5CWrM9J6J5lg5FcbFr+PPIdgoQYEnR+D+/vygODN6kN4W7RxWVUZ1wX2JFblVNoR8Pbi3w==
X-Received: by 2002:a17:90a:d156:: with SMTP id t22mr2914076pjw.138.1584416225394;
        Mon, 16 Mar 2020 20:37:05 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:9efe:9f1:9267:2b27])
        by smtp.gmail.com with ESMTPSA id c1sm1008492pje.24.2020.03.16.20.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 20:37:04 -0700 (PDT)
Date:   Mon, 16 Mar 2020 20:37:01 -0700
From:   Fangrui Song <maskray@google.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf v2] bpf: Support llvm-objcopy and llvm-objdump for
 vmlinux BTF
Message-ID: <20200317033701.w7jwos7mvfnde2t2@google.com>
References: <20200317011654.zkx5r7so53skowlc@google.com>
 <CAEf4BzYTJqWU++QnQupxFBWGSMPfGt6r-5u9jbeLnEF2ipw+Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4BzYTJqWU++QnQupxFBWGSMPfGt6r-5u9jbeLnEF2ipw+Mw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-16, Andrii Nakryiko wrote:
>On Mon, Mar 16, 2020 at 6:17 PM Fangrui Song <maskray@google.com> wrote:
>>
>> Simplify gen_btf logic to make it work with llvm-objcopy and
>> llvm-objdump.  We just need to retain one section .BTF. To do so, we can
>> use a simple objcopy --only-section=.BTF instead of jumping all the
>> hoops via an architecture-less binary file.
>>
>> We use a dd comment to change the e_type field in the ELF header from
>> ET_EXEC to ET_REL so that .btf.vmlinux.bin.o will be accepted by lld.
>>
>> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
>> Cc: Stanislav Fomichev <sdf@google.com>
>> Cc: Nick Desaulniers <ndesaulniers@google.com>
>> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
>> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
>> Link: https://github.com/ClangBuiltLinux/linux/issues/871
>> Signed-off-by: Fangrui Song <maskray@google.com>
>> ---
>>  scripts/link-vmlinux.sh | 13 ++-----------
>>  1 file changed, 2 insertions(+), 11 deletions(-)
>>
>> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
>> index dd484e92752e..84be8d7c361d 100755
>> --- a/scripts/link-vmlinux.sh
>> +++ b/scripts/link-vmlinux.sh
>> @@ -120,18 +120,9 @@ gen_btf()
>>
>>         info "BTF" ${2}
>>         vmlinux_link ${1}
>> -       LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
>
>Is it really tested? Seems like you just dropped .BTF generation step
>completely...

Sorry, dropped the whole line:/
I don't know how to test .BTF . I can only check readelf -S...

Attached the new patch.


 From 02afb9417d4f0f8d2175c94fc3797a94a95cc248 Mon Sep 17 00:00:00 2001
From: Fangrui Song <maskray@google.com>
Date: Mon, 16 Mar 2020 18:02:31 -0700
Subject: [PATCH bpf v2] bpf: Support llvm-objcopy and llvm-objdump for
  vmlinux BTF

Simplify gen_btf logic to make it work with llvm-objcopy and llvm-objdump.
We use a dd comment to change the e_type field in the ELF header from
ET_EXEC to ET_REL so that .btf.vmlinux.bin.o can be accepted by lld.

Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/871
Signed-off-by: Fangrui Song <maskray@google.com>
---
  scripts/link-vmlinux.sh | 14 +++-----------
  1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index dd484e92752e..b23313944c89 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -120,18 +120,10 @@ gen_btf()
  
  	info "BTF" ${2}
  	vmlinux_link ${1}
-	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
+	${PAHOLE} -J ${1}
  
-	# dump .BTF section into raw binary file to link with final vmlinux
-	bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
-		cut -d, -f1 | cut -d' ' -f2)
-	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
-		awk '{print $4}')
-	${OBJCOPY} --change-section-address .BTF=0 \
-		--set-section-flags .BTF=alloc -O binary \
-		--only-section=.BTF ${1} .btf.vmlinux.bin
-	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
-		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
+	# Extract .BTF section, change e_type to ET_REL, to link with final vmlinux
+	${OBJCOPY} --only-section=.BTF ${1} ${2} && printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16
  }
  
  # Create ${2} .o file with all symbols from the ${1} object file
-- 
2.25.1.481.gfbce0eb801-goog

