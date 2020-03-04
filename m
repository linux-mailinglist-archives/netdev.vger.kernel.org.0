Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B144179330
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgCDPVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:21:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:37718 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCDPVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 10:21:36 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9Vq1-0006ZB-Sb; Wed, 04 Mar 2020 16:21:34 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9Vq1-000ReH-JH; Wed, 04 Mar 2020 16:21:33 +0100
Subject: Re: [PATCH v3 bpf-next 0/3] Convert BPF UAPI constants into enum
 values
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200303003233.3496043-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <47bbaa27-a112-b4a5-6251-d8aad31937a5@iogearbox.net>
Date:   Wed, 4 Mar 2020 16:21:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200303003233.3496043-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25741/Wed Mar  4 15:15:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 1:32 AM, Andrii Nakryiko wrote:
> Convert BPF-related UAPI constants, currently defined as #define macro, into
> anonymous enums. This has no difference in terms of usage of such constants in
> C code (they are still could be used in all the compile-time contexts that
> `#define`s can), but they are recorded as part of DWARF type info, and
> subsequently get recorded as part of kernel's BTF type info. This allows those
> constants to be emitted as part of vmlinux.h auto-generated header file and be
> used from BPF programs. Which is especially convenient for all kinds of BPF
> helper flags and makes CO-RE BPF programs nicer to write.
> 
> libbpf's btf_dump logic currently assumes enum values are signed 32-bit
> values, but that doesn't match a typical case, so switch it to emit unsigned
> values. Once BTF encoding of BTF_KIND_ENUM is extended to capture signedness
> properly, this will be made more flexible.
> 
> As an immediate validation of the approach, runqslower's copy of
> BPF_F_CURRENT_CPU #define is dropped in favor of its enum variant from
> vmlinux.h.
> 
> v2->v3:
> - convert only constants usable from BPF programs (BPF helper flags, map
>    create flags, etc) (Alexei);
> 
> v1->v2:
> - fix up btf_dump test to use max 32-bit unsigned value instead of negative one.
> 
> 
> Andrii Nakryiko (3):
>    bpf: switch BPF UAPI #define constants used from BPF program side to
>      enums
>    libbpf: assume unsigned values for BTF_KIND_ENUM
>    tools/runqslower: drop copy/pasted BPF_F_CURRENT_CPU definiton
> 
>   include/uapi/linux/bpf.h                      | 175 ++++++++++-------
>   tools/bpf/runqslower/runqslower.bpf.c         |   3 -
>   tools/include/uapi/linux/bpf.h                | 177 +++++++++++-------
>   tools/lib/bpf/btf_dump.c                      |   8 +-
>   .../bpf/progs/btf_dump_test_case_syntax.c     |   2 +-
>   5 files changed, 224 insertions(+), 141 deletions(-)
> 

Applied, thanks!
