Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC372FC321
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbhASWNm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Jan 2021 17:13:42 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:41409 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388912AbhASWNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:13:32 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-JceK2w91Pa22KtoG8Tv88g-1; Tue, 19 Jan 2021 17:12:32 -0500
X-MC-Unique: JceK2w91Pa22KtoG8Tv88g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D894806661;
        Tue, 19 Jan 2021 22:12:30 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 526F7722C1;
        Tue, 19 Jan 2021 22:12:21 +0000 (UTC)
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
Subject: [PATCH 0/3] dwarves,libbpf: Add support to use optional extended section index table
Date:   Tue, 19 Jan 2021 23:12:17 +0100
Message-Id: <20210119221220.1745061-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

This patchset based on previously posted fix [1].

thanks,
jirka


[1] https://lore.kernel.org/bpf/20210113102509.1338601-1-jolsa@kernel.org/
---
dwarves:

Jiri Olsa (2):
      elf_symtab: Add support for SHN_XINDEX index to elf_section_by_name
      bpf_encoder: Translate SHN_XINDEX in symbol's st_shndx values

 btf_encoder.c | 18 ++++++++++++++++++
 dutil.c       |  8 ++++++--
 elf_symtab.c  | 31 ++++++++++++++++++++++++++++++-
 elf_symtab.h  |  1 +
 4 files changed, 55 insertions(+), 3 deletions(-)


libbpf:

Jiri Olsa (1):
      libbpf: Use string table index from index table if needed

 tools/lib/bpf/btf.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

