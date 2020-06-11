Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5A61F6F07
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 22:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgFKUvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 16:51:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56320 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726153AbgFKUvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 16:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591908668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2wJauOrh2sJagAyvMb41d/GChNhkUUFu5LwDnqBhpp8=;
        b=aztPZ0ONQIEqcv0gDpiB8BjbPPiw3v4IoRnxaanTCvbBXNP/p/jAps9puKKEM40dNUFwPB
        RmSXTXGw/e7WvASDClkeQNVQ/6qr+ofwmT06tOJ+85DVr1TgbX5qLvfhkr+lVGs6S3o1is
        jvn++36LrSV7wOvdpkAnSmIrq1a4zAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-hDqKBRRbMhWozcETuMPi-Q-1; Thu, 11 Jun 2020 16:50:49 -0400
X-MC-Unique: hDqKBRRbMhWozcETuMPi-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB9858018A2;
        Thu, 11 Jun 2020 20:50:47 +0000 (UTC)
Received: from krava (unknown [10.40.194.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 593E4579A3;
        Thu, 11 Jun 2020 20:50:41 +0000 (UTC)
Date:   Thu, 11 Jun 2020 22:50:40 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Frantisek Hrbata <fhrbata@redhat.com>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Subject: [RFC] .BTF section data alignment issue on s390
Message-ID: <20200611205040.GA1853644@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
we're hitting a problem on s390 with BTF data alignment.

When running simple test, we're getting this message from
verifier and console:

  bpf_common.c:91: BROK: Failed verification: in-kernel BTF is malformed
  [   41.545572] BPF:Total section length too long


AFAICS it happens when .BTF section data size is not an even number ;-)

DISCLAIMER I'm quite ignorant of s390x arch details, so most likely I'm
totally wrong and perhaps missing something important and there's simple
explanation.. but here's what got me here:


... so BTF data is placed in .BTF section via linker script:

        .BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {                           \
                __start_BTF = .;                                        \
                *(.BTF)                                                 \
                __stop_BTF = .;                                         \
        }


and the .BTF data size in btf_parse_vmlinux is computed as:

        btf->data_size = __stop_BTF - __start_BTF;


this computation is compiled as:

        00000000002aeb20 <btf_parse_vmlinux>:
        ...
          2aeb8a:  larl    %r1,cda3ac <__start_BTF+0x2084a8>    # loads r1 with end
          2aeb90:  larl    %r2,ad1f04 <__start_BTF>             # loads r2 with start
          2aeb96:  sgr     %r1,%r2                              # substract r1 - r2 


having following values for start/stop_BTF symbols:

        # nm ./vmlinux | grep __start_BTF
        0000000000ad1f04 R __start_BTF
        # nm ./vmlinux | grep __stop_BTF
        0000000000cda3ad R __stop_BTF

        -> the BTF data size is 0x2084a9


but as you can see the instruction that loads the 'end' symbol:

        larl    %r1,cda3ac <__start_BTF+0x2084a8>


is loading '__start_BTF + 0x2084a8', which is '__stop_BTF - 1'


From spec it seems that larl instruction's argument must be even
number ([1] page 7-214):

        2.   For  LOAD  RELATIVE  LONG,  the  second  oper-and must be aligned
        on an integral boundary cor-responding to the operand’s size. 


I also found an older bug complaining about this issue [2]:

        ...
        larl instruction can only load even values - instructions on s390 are 2-byte
        aligned and the instruction encodes offset to the target in 2-byte units.
        ...
        The GNU BFD linker for s390 doesn't bother to check if relocations fit or are
        properly aligned. 
        ...


I tried to fix that aligning the end to even number, but then
btf_check_sec_info logic needs to be adjusted as well, and
probably other places as well.. so I decided to share this
first.. because it all seems wrong ;-)

thoughts? thanks,
jirka


[1] http://publibfi.boulder.ibm.com/epubs/pdf/dz9zr008.pdf
[2] https://sourceware.org/bugzilla/show_bug.cgi?id=18960

