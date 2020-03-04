Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5F61798A3
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387881AbgCDTIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:08:19 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28825 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729557AbgCDTIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 14:08:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583348897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9EDXoQq4R6l+0FmkujJv/4v71dbejsKVNKvhBqG1Z9o=;
        b=ZgSOfamI3aC8gVfr1L79652UNofuF89e30gfPplsJSHX4JLPYZ8ap5X7cRQ7C/7Q7us+7t
        Ivyyi2jUKqrV5f1ux7cfUd6CUI2r0Uz1o+8hylV3A++gF8KAuy275vNz5+0hHjA5S3fvNh
        3IuWmcwjagW6iDoYE+PXfC7ojVOGuE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-RNwvfwFkPgeVK9u8l_wNVQ-1; Wed, 04 Mar 2020 14:08:13 -0500
X-MC-Unique: RNwvfwFkPgeVK9u8l_wNVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A946800D4E;
        Wed,  4 Mar 2020 19:08:12 +0000 (UTC)
Received: from krava (ovpn-205-10.brq.redhat.com [10.40.205.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BDF25C219;
        Wed,  4 Mar 2020 19:08:09 +0000 (UTC)
Date:   Wed, 4 Mar 2020 20:08:07 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, quentin@isovalent.com,
        kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        arnaldo.melo@gmail.com, jolsa@kernel.org
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Message-ID: <20200304190807.GA168640@krava>
References: <20200304180710.2677695-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304180710.2677695-1-songliubraving@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 10:07:06AM -0800, Song Liu wrote:
> This set introduces bpftool prog profile command, which uses hardware
> counters to profile BPF programs.
> 
> This command attaches fentry/fexit programs to a target program. These two
> programs read hardware counters before and after the target program and
> calculate the difference.
> 
> Changes v3 => v4:
> 1. Simplify err handling in profile_open_perf_events() (Quentin);
> 2. Remove redundant p_err() (Quentin);
> 3. Replace tab with space in bash-completion; (Quentin);
> 4. Fix typo _bpftool_get_map_names => _bpftool_get_prog_names (Quentin).

hum, I'm getting:

	[jolsa@dell-r440-01 bpftool]$ pwd
	/home/jolsa/linux-perf/tools/bpf/bpftool
	[jolsa@dell-r440-01 bpftool]$ make
	...
	make[1]: Leaving directory '/home/jolsa/linux-perf/tools/lib/bpf'
	  LINK     _bpftool
	make: *** No rule to make target 'skeleton/profiler.bpf.c', needed by 'skeleton/profiler.bpf.o'.  Stop.

jirka

> 
> Changes v2 => v3:
> 1. Change order of arguments (Quentin), as:
>      bpftool prog profile PROG [duration DURATION] METRICs
> 2. Add bash-completion for bpftool prog profile (Quentin);
> 3. Fix build of selftests (Yonghong);
> 4. Better handling of bpf_map_lookup_elem() returns (Yonghong);
> 5. Improve clean up logic of do_profile() (Yonghong);
> 6. Other smaller fixes/cleanups.
> 
> Changes RFC => v2:
> 1. Use new bpf_program__set_attach_target() API;
> 2. Update output format to be perf-stat like (Alexei);
> 3. Incorporate skeleton generation into Makefile;
> 4. Make DURATION optional and Allow Ctrl-C (Alexei);
> 5. Add calcated values "insn per cycle" and "LLC misses per million isns".
> 
> Song Liu (4):
>   bpftool: introduce "prog profile" command
>   bpftool: Documentation for bpftool prog profile
>   bpftool: bash completion for "bpftool prog profile"
>   bpftool: fix typo in bash-completion
> 
>  .../bpftool/Documentation/bpftool-prog.rst    |  19 +
>  tools/bpf/bpftool/Makefile                    |  18 +
>  tools/bpf/bpftool/bash-completion/bpftool     |  47 +-
>  tools/bpf/bpftool/prog.c                      | 425 +++++++++++++++++-
>  tools/bpf/bpftool/skeleton/profiler.bpf.c     | 171 +++++++
>  tools/bpf/bpftool/skeleton/profiler.h         |  47 ++
>  tools/scripts/Makefile.include                |   1 +
>  7 files changed, 725 insertions(+), 3 deletions(-)
>  create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
>  create mode 100644 tools/bpf/bpftool/skeleton/profiler.h
> 
> --
> 2.17.1
> 

