Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443852B4672
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgKPOzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:55:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730398AbgKPOzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 09:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605538504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qYYmGZ075mq9dw9VbvycdbVYIQWW/WaQw4d0jouDdDk=;
        b=I+gobN5d1atCVr1BOciNWINrcQXB998Q5brf3DXKKjw6dkXs/+qIFDPSl8ONrHbrRtLBm2
        EwpLzoznYwO/B0t0TrSr9w27+L201mMKWxx4hVdmPQKZ6g7IEIvE47Tp5aJXIHhKLYRhUZ
        KIHwAen6bCxki1BVpQxqwsk44mIRkEQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-RZLpqM__PpaeVBuHT4Sbjg-1; Mon, 16 Nov 2020 09:54:59 -0500
X-MC-Unique: RZLpqM__PpaeVBuHT4Sbjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9094B80B727;
        Mon, 16 Nov 2020 14:54:57 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E34B5D9CC;
        Mon, 16 Nov 2020 14:54:47 +0000 (UTC)
Date:   Mon, 16 Nov 2020 15:54:46 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, brouer@redhat.com
Subject: Re: [PATCHv5 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201116155446.16fe46cf@carbon>
In-Reply-To: <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
References: <20201109070802.3638167-1-haliu@redhat.com>
        <20201116065305.1010651-1-haliu@redhat.com>
        <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 23:19:26 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Sun, Nov 15, 2020 at 10:56 PM Hangbin Liu <haliu@redhat.com> wrote:
> >
> > This series converts iproute2 to use libbpf for loading and attaching
> > BPF programs when it is available. This means that iproute2 will
> > correctly process BTF information and support the new-style BTF-defined
> > maps, while keeping compatibility with the old internal map definition
> > syntax.
> >
> > This is achieved by checking for libbpf at './configure' time, and using
> > it if available. By default the system libbpf will be used, but static
> > linking against a custom libbpf version can be achieved by passing
> > LIBBPF_DIR to configure. LIBBPF_FORCE can be set to on to force configure
> > abort if no suitable libbpf is found (useful for automatic packaging
> > that wants to enforce the dependency), or set off to disable libbpf check
> > and build iproute2 with legacy bpf.
> >
> > The old iproute2 bpf code is kept and will be used if no suitable libbpf
> > is available. When using libbpf, wrapper code ensures that iproute2 will
> > still understand the old map definition format, including populating
> > map-in-map and tail call maps before load.
> >
> > The examples in bpf/examples are kept, and a separate set of examples
> > are added with BTF-based map definitions for those examples where this
> > is possible (libbpf doesn't currently support declaratively populating
> > tail call maps).
> >
> > At last, Thanks a lot for Toke's help on this patch set.
> >
> > v5:
> > a) Fix LIBBPF_DIR typo and description, use libbpf DESTDIR as LIBBPF_DIR
> >    dest.
> > b) Fix bpf_prog_load_dev typo.
> > c) rebase to latest iproute2-next.  
> 
> For the reasons explained multiple times earlier:
> Nacked-by: Alexei Starovoitov <ast@kernel.org>

We really need to get another BPF-ELF loaded into iproute2.  I have
done a number of practical projects with TC-BPF and it sucks that
iproute2 have this out-dated (compiled in) BPF-loader.  Examples
jumping through hoops to get XDP + TC to collaborate[1], and dealing
with iproute2 map-elf layout[2].

Thus, IMHO we MUST move forward and get started with converting
iproute2 to libbpf, and start on the work to deprecate the build in
BPF-ELF-loader.  I would prefer ripping out the BPF-ELF-loader and
replace it with libbpf that handle the older binary elf-map layout, but
I do understand if you want to keep this around. (at least for the next
couple of releases).

Maybe we can get a little closer to what Alexei wants?

When compiled against dynamic libbpf, then I would use 'ldd' command to
see what libbpf lib version is used.  When compiled/linked statically
against a custom libbpf version (already supported via LIBBPF_DIR) then
*I* think is difficult to figure out that version of libbpf I'm using.
Could we add the libbpf version info in 'tc -V', as then it would
remove one of my concerns with static linking.

I actually fear that it will be a bad user experience, when we start to
have multiple userspace tools that load BPF, but each is compiled and
statically linked with it own version of libbpf (with git submodule an
increasing number of tools will have more variations!).  Small
variations in supported features can cause strange and difficult
troubleshooting. A practical example is xdp-cpumap-tc[1] where I had to
instruct the customer to load XDP-program *BEFORE* TC-program to have map
(that is shared between TC and XDP) being created correctly, for
userspace tool written in libbpf to have proper map-access and info.


I actually thinks it makes sense to have iproute2 require a specific
libbpf version, and also to move this version requirement forward, as
the kernel evolves features that gets added into libbpf.  I know this
is kind of controversial, and an attempt to pressure distro vendors to
update libbpf.  Maybe it will actually backfire, as the person
generating the DEB/RPM software package will/can choose to compile
iproute2 without ELF-BPF/libbpf support.


[1] https://github.com/xdp-project/xdp-cpumap-tc
[2] https://github.com/netoptimizer/bpf-examples/blob/71db45b28ec/traffic-pacing-edt/edt_pacer02.c#L33-L35
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

(p.s. I actually like dynamic libs, as I can do evil tricks like
LD_PRELOAD, e.g. if system had too old libbpf when I could have my own
and have iproute2 load it via LD_PRELOAD. I know we shouldn't encourage
tricks like this, but I've used these kind of trick with success before).

