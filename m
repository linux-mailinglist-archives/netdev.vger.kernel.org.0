Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A330164449
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 13:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbgBSMad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 07:30:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38050 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726788AbgBSMac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 07:30:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582115430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FlQCARZ1FbwRbU2uJuzeHmBQSyIgJVmrLI3UOgbvB+8=;
        b=QDp5sC3rmNx8RQcPsOP68t+WeC9RkcsbljuXBTgMGWK55HNWSP5IkUoEL9PZaNObq/N6rE
        mfvj//PZk7hKtNTjnocwQLFQajk12Bnun5uOySwxYUm5OrrJCt/8YHT9PC0Xwr+1xAyGHd
        djNGH3gYWbULIxbQJQXKjrtsegL6irY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-Q4_uj_NHPDK7p6ZkD_KXvA-1; Wed, 19 Feb 2020 07:30:24 -0500
X-MC-Unique: Q4_uj_NHPDK7p6ZkD_KXvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB191107ACCC;
        Wed, 19 Feb 2020 12:30:22 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B7E819E9C;
        Wed, 19 Feb 2020 12:30:13 +0000 (UTC)
Date:   Wed, 19 Feb 2020 13:30:12 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     brouer@redhat.com, Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Message-ID: <20200219133012.7cb6ac9e@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,

Downloaded tarball for kernel release 5.5.4, and I cannot compile
tools/testing/selftests/bpf/ with latest LLVM release version 9.

Looking closer at the build error messages, I can see that this is
caused by using LLVM features that (I assume) will be avail in release
10. I find it very strange that we can release a kernel that have build
dependencies on a unreleased version of LLVM.

I'm willing to help out, such that we can do either version or feature
detection, to either skip compiling specific test programs or at least
give users a proper warning of they are using a too "old" LLVM version.


I love the new LLVM BTF features, but we cannot break users/CI-systems
that wants to run the BPF-selftests.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

http://releases.llvm.org/download.html

Compile error message:
 unknown builtin '__builtin_preserve_field_info'

Full:

make -C /home/jbrouer/build/linux-5.5.4/tools/lib/bpf OUTPUT=/home/jbrouer/build/linux-5.5.4/tools/testing/selftests/bpf/
make[1]: Entering directory '/home/jbrouer/build/linux-5.5.4/tools/lib/bpf'
make[1]: Leaving directory '/home/jbrouer/build/linux-5.5.4/tools/lib/bpf'
(clang  -I. -I/home/jbrouer/build/linux-5.5.4/tools/testing/selftests/bpf -g -D__TARGET_ARCH_x86 -mlittle-endian -I. -I./include/uapi -I/home/jbrouer/build/linux-5.5.4/tools/include/uapi -I/home/jbrouer/build/linux-5.5.4/tools/lib/bpf -I/home/jbrouer/build/linux-5.5.4/tools/testing/selftests/usr/include -idirafter /usr/local/include -idirafter /usr/lib64/clang/9.0.0/include -idirafter /usr/include -Wno-compare-distinct-pointer-types -O2 -target bpf -emit-llvm -c progs/test_core_reloc_bitfields_probed.c -o - || echo "BPF obj compilation failed") | llc -mattr=dwarfris -march=bpf -mcpu=probe  -mattr=+alu32 -filetype=obj -o /home/jbrouer/build/linux-5.5.4/tools/testing/selftests/bpf/test_core_reloc_bitfields_probed.o
progs/test_core_reloc_bitfields_probed.c:47:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
        out->ub1 = BPF_CORE_READ_BITFIELD_PROBED(in, ub1);
                   ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:52:2: note: expanded from macro 'BPF_CORE_READ_BITFIELD_PROBED'
        __CORE_BITFIELD_PROBE_READ(&val, s, field);                           \
        ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:28:10: note: expanded from macro '__CORE_BITFIELD_PROBE_READ'
                       __CORE_RELO(src, fld, BYTE_SIZE),                      \
                       ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:23:2: note: expanded from macro '__CORE_RELO'
        __builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
        ^
progs/test_core_reloc_bitfields_probed.c:48:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
        out->ub2 = BPF_CORE_READ_BITFIELD_PROBED(in, ub2);
                   ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:52:2: note: expanded from macro 'BPF_CORE_READ_BITFIELD_PROBED'
        __CORE_BITFIELD_PROBE_READ(&val, s, field);                           \
        ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:28:10: note: expanded from macro '__CORE_BITFIELD_PROBE_READ'
                       __CORE_RELO(src, fld, BYTE_SIZE),                      \
                       ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:23:2: note: expanded from macro '__CORE_RELO'
        __builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
        ^
progs/test_core_reloc_bitfields_probed.c:49:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
        out->ub7 = BPF_CORE_READ_BITFIELD_PROBED(in, ub7);
                   ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:52:2: note: expanded from macro 'BPF_CORE_READ_BITFIELD_PROBED'
        __CORE_BITFIELD_PROBE_READ(&val, s, field);                           \
        ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:28:10: note: expanded from macro '__CORE_BITFIELD_PROBE_READ'
                       __CORE_RELO(src, fld, BYTE_SIZE),                      \
                       ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:23:2: note: expanded from macro '__CORE_RELO'
        __builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
        ^
progs/test_core_reloc_bitfields_probed.c:50:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
        out->sb4 = BPF_CORE_READ_BITFIELD_PROBED(in, sb4);
                   ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:52:2: note: expanded from macro 'BPF_CORE_READ_BITFIELD_PROBED'
        __CORE_BITFIELD_PROBE_READ(&val, s, field);                           \
        ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:28:10: note: expanded from macro '__CORE_BITFIELD_PROBE_READ'
                       __CORE_RELO(src, fld, BYTE_SIZE),                      \
                       ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:23:2: note: expanded from macro '__CORE_RELO'
        __builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
        ^
progs/test_core_reloc_bitfields_probed.c:51:14: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
        out->sb20 = BPF_CORE_READ_BITFIELD_PROBED(in, sb20);
                    ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:52:2: note: expanded from macro 'BPF_CORE_READ_BITFIELD_PROBED'
        __CORE_BITFIELD_PROBE_READ(&val, s, field);                           \
        ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:28:10: note: expanded from macro '__CORE_BITFIELD_PROBE_READ'
                       __CORE_RELO(src, fld, BYTE_SIZE),                      \
                       ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:23:2: note: expanded from macro '__CORE_RELO'
        __builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
        ^
progs/test_core_reloc_bitfields_probed.c:52:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
        out->u32 = BPF_CORE_READ_BITFIELD_PROBED(in, u32);
                   ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:52:2: note: expanded from macro 'BPF_CORE_READ_BITFIELD_PROBED'
        __CORE_BITFIELD_PROBE_READ(&val, s, field);                           \
        ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:28:10: note: expanded from macro '__CORE_BITFIELD_PROBE_READ'
                       __CORE_RELO(src, fld, BYTE_SIZE),                      \
                       ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:23:2: note: expanded from macro '__CORE_RELO'
        __builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
        ^
progs/test_core_reloc_bitfields_probed.c:53:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
        out->s32 = BPF_CORE_READ_BITFIELD_PROBED(in, s32);
                   ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:52:2: note: expanded from macro 'BPF_CORE_READ_BITFIELD_PROBED'
        __CORE_BITFIELD_PROBE_READ(&val, s, field);                           \
        ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:28:10: note: expanded from macro '__CORE_BITFIELD_PROBE_READ'
                       __CORE_RELO(src, fld, BYTE_SIZE),                      \
                       ^
/home/jbrouer/build/linux-5.5.4/tools/lib/bpf/bpf_core_read.h:23:2: note: expanded from macro '__CORE_RELO'
        __builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
        ^
7 errors generated.
llc: error: llc: <stdin>:1:1: error: expected top-level entity
BPF obj compilation failed
^
make: *** [Makefile:281: /home/jbrouer/build/linux-5.5.4/tools/testing/selftests/bpf/test_core_reloc_bitfields_probed.o] Error 1

