Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5C11F74E3
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 09:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgFLH4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 03:56:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60550 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726396AbgFLH4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 03:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591948591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LNbUY1q6FIZ97hLXxGpuj36BUNMuCI5VduaUjfayv64=;
        b=ekA31TMRK/QcX/JPG6giBDTMkshPZnoP76i6uOl/QkXpQGsihcWDlzW20SGX14z5nKsjFS
        B3zPJfBMZsmL8YVc2aOtb/UEGq1mExGq9pR6AEygQf/WYquWvolr5BkF8Vs51cwDsZby+8
        vtfzD/eO7KKOZk/gYln3E1m+Mx7fKXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-cab5DlpeObi7zj79e2LdIQ-1; Fri, 12 Jun 2020 03:56:23 -0400
X-MC-Unique: cab5DlpeObi7zj79e2LdIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 796D7872FE2;
        Fri, 12 Jun 2020 07:56:21 +0000 (UTC)
Received: from krava (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 461295C1B2;
        Fri, 12 Jun 2020 07:56:15 +0000 (UTC)
Date:   Fri, 12 Jun 2020 09:56:14 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
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
Subject: Re: [RFC] .BTF section data alignment issue on s390
Message-ID: <20200612075614.GA1885974@krava>
References: <20200611205040.GA1853644@krava>
 <e1823b9409720aadb14691fbc4e136ad36c5264c.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1823b9409720aadb14691fbc4e136ad36c5264c.camel@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 12:46:13AM +0200, Ilya Leoshkevich wrote:
> On Thu, 2020-06-11 at 22:50 +0200, Jiri Olsa wrote:
> > hi,
> > we're hitting a problem on s390 with BTF data alignment.
> > 
> > When running simple test, we're getting this message from
> > verifier and console:
> > 
> >   bpf_common.c:91: BROK: Failed verification: in-kernel BTF is
> > malformed
> >   [   41.545572] BPF:Total section length too long
> > 
> > 
> > AFAICS it happens when .BTF section data size is not an even number
> > ;-)
> > 
> > DISCLAIMER I'm quite ignorant of s390x arch details, so most likely
> > I'm
> > totally wrong and perhaps missing something important and there's
> > simple
> > explanation.. but here's what got me here:
> > 
> > 
> > ... so BTF data is placed in .BTF section via linker script:
> > 
> >         .BTF : AT(ADDR(.BTF) - LOAD_OFFSET)
> > {                           \
> >                 __start_BTF =
> > .;                                        \
> >                 *(.BTF)                                              
> >    \
> >                 __stop_BTF =
> > .;                                         \
> >         }
> > 
> > 
> > and the .BTF data size in btf_parse_vmlinux is computed as:
> > 
> >         btf->data_size = __stop_BTF - __start_BTF;
> > 
> > 
> > this computation is compiled as:
> > 
> >         00000000002aeb20 <btf_parse_vmlinux>:
> >         ...
> >           2aeb8a:  larl    %r1,cda3ac <__start_BTF+0x2084a8>    #
> > loads r1 with end
> >           2aeb90:  larl    %r2,ad1f04 <__start_BTF>             #
> > loads r2 with start
> >           2aeb96:  sgr     %r1,%r2                              #
> > substract r1 - r2 
> > 
> > 
> > having following values for start/stop_BTF symbols:
> > 
> >         # nm ./vmlinux | grep __start_BTF
> >         0000000000ad1f04 R __start_BTF
> >         # nm ./vmlinux | grep __stop_BTF
> >         0000000000cda3ad R __stop_BTF
> > 
> >         -> the BTF data size is 0x2084a9
> > 
> > 
> > but as you can see the instruction that loads the 'end' symbol:
> > 
> >         larl    %r1,cda3ac <__start_BTF+0x2084a8>
> > 
> > 
> > is loading '__start_BTF + 0x2084a8', which is '__stop_BTF - 1'
> > 
> > 
> > From spec it seems that larl instruction's argument must be even
> > number ([1] page 7-214):
> > 
> >         2.   For  LOAD  RELATIVE  LONG,  the  second  oper-and must
> > be aligned
> >         on an integral boundary cor-responding to the operand’s
> > size. 
> > 
> > 
> > I also found an older bug complaining about this issue [2]:
> > 
> >         ...
> >         larl instruction can only load even values - instructions on
> > s390 are 2-byte
> >         aligned and the instruction encodes offset to the target in
> > 2-byte units.
> >         ...
> >         The GNU BFD linker for s390 doesn't bother to check if
> > relocations fit or are
> >         properly aligned. 
> >         ...
> > 
> > 
> > I tried to fix that aligning the end to even number, but then
> > btf_check_sec_info logic needs to be adjusted as well, and
> > probably other places as well.. so I decided to share this
> > first.. because it all seems wrong ;-)
> > 
> > thoughts? thanks,
> > jirka
> > 
> > 
> > [1] http://publibfi.boulder.ibm.com/epubs/pdf/dz9zr008.pdf
> > [2] https://sourceware.org/bugzilla/show_bug.cgi?id=18960
> > 
> Hi Jiri,
> 
> Actually I recently ran into it myself on Debian, and I believe your
> analysis is correct :-) The only thing to add to it is that the
> compiler emits the correct instruction (if you look at the .o file),
> it's linker that messes things up.
> 
> The linker bug in question is [1].
> 
> I opened [2] to Debian folks, and I believe that other important
> distros (RH, SUSE, Ubuntu) have this fixed already.
> 
> Which distro are you using?

I'm on RHEL ;-) I wonder why that fix was missed,
I'll follow up on that with our binutils guys

thanks a lot for the info,
jirka

> 
> Best regards,
> Ilya
> 
> [1] 
> https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=e6213e09ed0e
> [2] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=961736
> 

