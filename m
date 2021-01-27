Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4761305BC8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343687AbhA0Mmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 07:42:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343696AbhA0Mki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 07:40:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611751151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FNuG7JoCfAH9Jm56wLn/gL9lO+Td4zBW5kowrH1kfJM=;
        b=SZGUaUmHL5I3hLNmXv20ZUUHxDSnU0kLcHdW7csFNbcrC+IWfzpOx1qWi1zq/NYSxz4FoW
        GY+XnhOmbcmbUQKN4oFfayQOzHcvG4TJi8yXwUCxaSrCcBrTHOaxU6Hs4CMO+0YO3XLJM7
        N3KQKInucgNeuW5F8HLVEC62NYgZGRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-hInXWJ-1P1GHGlv-IPrlGg-1; Wed, 27 Jan 2021 07:39:07 -0500
X-MC-Unique: hInXWJ-1P1GHGlv-IPrlGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1A5510054FF;
        Wed, 27 Jan 2021 12:39:05 +0000 (UTC)
Received: from [10.10.112.133] (ovpn-112-133.rdu2.redhat.com [10.10.112.133])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4814C27C23;
        Wed, 27 Jan 2021 12:38:57 +0000 (UTC)
Subject: Re: [PATCHv4 0/2] libbpf: Add support to use optional extended
 section index table
To:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     dwarves@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Mark Wielaard <mjw@redhat.com>
References: <20210124221519.219750-1-jolsa@kernel.org>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <b1469725-d462-9a6d-3329-f77c9eb6b43f@redhat.com>
Date:   Wed, 27 Jan 2021 07:38:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210124221519.219750-1-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/21 5:15 PM, Jiri Olsa wrote:
> hi,
> kpatch guys hit an issue with pahole over their vmlinux, which
> contains many (over 100000) sections, pahole crashes.
> 
> With so many sections, ELF is using extended section index table,
> which is used to hold values for some of the indexes and extra
> code is needed to retrieve them.
> 
> This patchset adds the support for pahole to properly read string
> table index and symbol's section index, which are used in btf_encoder.
> 
> This patchset also adds support for libbpf to properly parse .BTF
> section on such object.
> 
> This patchset is based on previously posted fix [1].
> 
> v4 changes:
>    - use size_t instead of Elf32_Word [Andrii]
>    - move elf_symtab__for_each_symbol_index and elf_sym__get
>      elf_symtab.h [Andrii]
>    - added ack for patch 1 [Andrii]
>    - changed elf_sym__get to be simpler [Andrii]
>    - changed elf_symtab__for_each_symbol_index to skip bad symbols
>    - use zalloc for struct elf_symtab allocation to get zero
>      initialized members
> 
> v3 changes:
>    - directly bail out for !str in elf_section_by_name [Andrii]
>    - use symbol index in collect_function [Andrii]
>    - use symbol index in collect_percpu_var
>    - change elf_symtab__for_each_symbol_index, move elf_sym__get
>      to for's condition part
>    - libbpf patch got merged
> 
> v2 changes:
>    - many variables renames [Andrii]
>    - use elf_getshdrstrndx() unconditionally [Andrii]
>    - add elf_symtab__for_each_symbol_index macro [Andrii]
>    - add more comments [Andrii]
>    - verify that extended symtab section type is SHT_SYMTAB_SHNDX [Andrii]
>    - fix Joe's crash in dwarves build, wrong sym.st_shndx assignment
> 
> thanks,
> jirka
> 
> 
> [1] https://lore.kernel.org/bpf/20210113102509.1338601-1-jolsa@kernel.org/
> ---
> Jiri Olsa (2):
>        elf_symtab: Add support for SHN_XINDEX index to elf_section_by_name
>        bpf_encoder: Translate SHN_XINDEX in symbol's st_shndx values
> 
>   btf_encoder.c | 33 +++++++++++++++++----------------
>   dutil.c       |  8 +++++++-
>   elf_symtab.c  | 41 +++++++++++++++++++++++++++++++++++++++--
>   elf_symtab.h  | 29 +++++++++++++++++++++++++++++
>   4 files changed, 92 insertions(+), 19 deletions(-)
> 

For v4 patchset:

Tested-by: Joe Lawrence <joe.lawrence@redhat.com>

Thanks Jiri!

-- Joe

