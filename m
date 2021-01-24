Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B3D301F24
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 23:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAXWQb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 24 Jan 2021 17:16:31 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:52250 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726398AbhAXWQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 17:16:28 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-wweoBMndMXO6teUtfC_nqQ-1; Sun, 24 Jan 2021 17:15:33 -0500
X-MC-Unique: wweoBMndMXO6teUtfC_nqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60875192FDA1;
        Sun, 24 Jan 2021 22:15:31 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90B991346F;
        Sun, 24 Jan 2021 22:15:20 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     dwarves@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: [PATCHv4 0/2] libbpf: Add support to use optional extended section index table
Date:   Sun, 24 Jan 2021 23:15:17 +0100
Message-Id: <20210124221519.219750-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
kpatch guys hit an issue with pahole over their vmlinux, which
contains many (over 100000) sections, pahole crashes.

With so many sections, ELF is using extended section index table,
which is used to hold values for some of the indexes and extra
code is needed to retrieve them.

This patchset adds the support for pahole to properly read string
table index and symbol's section index, which are used in btf_encoder.

This patchset also adds support for libbpf to properly parse .BTF
section on such object.

This patchset is based on previously posted fix [1].

v4 changes:
  - use size_t instead of Elf32_Word [Andrii]
  - move elf_symtab__for_each_symbol_index and elf_sym__get
    elf_symtab.h [Andrii]
  - added ack for patch 1 [Andrii]
  - changed elf_sym__get to be simpler [Andrii]
  - changed elf_symtab__for_each_symbol_index to skip bad symbols
  - use zalloc for struct elf_symtab allocation to get zero
    initialized members

v3 changes:
  - directly bail out for !str in elf_section_by_name [Andrii]
  - use symbol index in collect_function [Andrii] 
  - use symbol index in collect_percpu_var
  - change elf_symtab__for_each_symbol_index, move elf_sym__get
    to for's condition part
  - libbpf patch got merged

v2 changes:
  - many variables renames [Andrii]
  - use elf_getshdrstrndx() unconditionally [Andrii]
  - add elf_symtab__for_each_symbol_index macro [Andrii]
  - add more comments [Andrii]
  - verify that extended symtab section type is SHT_SYMTAB_SHNDX [Andrii]
  - fix Joe's crash in dwarves build, wrong sym.st_shndx assignment

thanks,
jirka


[1] https://lore.kernel.org/bpf/20210113102509.1338601-1-jolsa@kernel.org/
---
Jiri Olsa (2):
      elf_symtab: Add support for SHN_XINDEX index to elf_section_by_name
      bpf_encoder: Translate SHN_XINDEX in symbol's st_shndx values

 btf_encoder.c | 33 +++++++++++++++++----------------
 dutil.c       |  8 +++++++-
 elf_symtab.c  | 41 +++++++++++++++++++++++++++++++++++++++--
 elf_symtab.h  | 29 +++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 19 deletions(-)

