Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579D81839ED
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgCLT4W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 15:56:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48065 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726558AbgCLT4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:56:22 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-VBfo_sYGNJaTpY-o8thzFg-1; Thu, 12 Mar 2020 15:56:17 -0400
X-MC-Unique: VBfo_sYGNJaTpY-o8thzFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CB64DB62;
        Thu, 12 Mar 2020 19:56:15 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32AA05D9C5;
        Thu, 12 Mar 2020 19:56:10 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCHv5 00/15] bpf: Add trampoline and dispatcher to /proc/kallsyms
Date:   Thu, 12 Mar 2020 20:55:55 +0100
Message-Id: <20200312195610.346362-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
this patchset adds trampoline and dispatcher objects
to be visible in /proc/kallsyms. The last patch also
adds sorting for all bpf objects in /proc/kallsyms.

  $ sudo cat /proc/kallsyms | tail -20
  ...
  ffffffffa050f000 t bpf_prog_5a2b06eab81b8f51    [bpf]
  ffffffffa0511000 t bpf_prog_6deef7357e7b4530    [bpf]
  ffffffffa0542000 t bpf_trampoline_13832 [bpf]
  ffffffffa0548000 t bpf_prog_96f1b5bf4e4cc6dc_mutex_lock [bpf]
  ffffffffa0572000 t bpf_prog_d1c63e29ad82c4ab_bpf_prog1  [bpf]
  ffffffffa0585000 t bpf_prog_e314084d332a5338__dissect   [bpf]
  ffffffffa0587000 t bpf_prog_59785a79eac7e5d2_mutex_unlock       [bpf]
  ffffffffa0589000 t bpf_prog_d0db6e0cac050163_mutex_lock [bpf]
  ffffffffa058d000 t bpf_prog_d8f047721e4d8321_bpf_prog2  [bpf]
  ffffffffa05df000 t bpf_trampoline_25637 [bpf]
  ffffffffa05e3000 t bpf_prog_d8f047721e4d8321_bpf_prog2  [bpf]
  ffffffffa05e5000 t bpf_prog_3b185187f1855c4c    [bpf]
  ffffffffa05e7000 t bpf_prog_d8f047721e4d8321_bpf_prog2  [bpf]
  ffffffffa05eb000 t bpf_prog_93cebb259dd5c4b2_do_sys_open        [bpf]
  ffffffffa0677000 t bpf_dispatcher_xdp   [bpf]

v5 changes:
  - keeping just 1 bpf_tree for all the objects and adding flag
    to recognize bpf_objects when searching for exception tables [Alexei]
  - no need for is_bpf_image_address call in kernel_text_address [Alexei]
  - removed the bpf_image tree, because it's no longer needed

v4 changes:
  - add trampoline and dispatcher to kallsyms once the it's allocated [Alexei]
  - omit the symbols sorting for kallsyms [Alexei]
  - small title change in one patch [Song]
  - some function renames:
     bpf_get_prog_name to bpf_prog_ksym_set_name
     bpf_get_prog_addr_region to bpf_prog_ksym_set_addr
  - added acks to changelogs
  - I checked and there'll be conflict on perftool side with
    upcoming changes from Adrian Hunter (text poke events),
    so I think it's better if Arnaldo takes the perf changes
    via perf tree and we will solve all conflicts there

v3 changes:
  - use container_of directly in bpf_get_ksym_start  [Daniel]
  - add more changelog explanations for ksym addresses [Daniel]

v2 changes:
  - omit extra condition in __bpf_ksym_add for sorting code (Andrii)
  - rename bpf_kallsyms_tree_ops to bpf_ksym_tree (Andrii)
  - expose only executable code in kallsyms (Andrii)
  - use full trampoline key as its kallsyms id (Andrii)
  - explained the BPF_TRAMP_REPLACE case (Andrii)
  - small format changes in bpf_trampoline_link_prog/bpf_trampoline_unlink_prog (Andrii)
  - propagate error value in bpf_dispatcher_update and update kallsym if it's successful (Andrii)
  - get rid of __always_inline for bpf_ksym_tree callbacks (Andrii)
  - added KSYMBOL notification for bpf_image add/removal
  - added perf tools changes to properly display trampoline/dispatcher


For perf tool to properly display trampoline/dispatcher you need
also Arnaldo's perf/urgent branch changes. I merged everything
into following branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git bpf/kallsyms

thanks,
jirka


---
Björn Töpel (1):
      bpf: Add bpf_trampoline_ name prefix for DECLARE_BPF_DISPATCHER

Jiri Olsa (14):
      x86/mm: Rename is_kernel_text to __is_kernel_text
      bpf: Add struct bpf_ksym
      bpf: Add name to struct bpf_ksym
      bpf: Move lnode list node to struct bpf_ksym
      bpf: Move ksym_tnode to bpf_ksym
      bpf: Add bpf_ksym_find function
      bpf: Add prog flag to struct bpf_ksym object
      bpf: Add bpf_ksym_add/del functions
      bpf: Add trampolines to kallsyms
      bpf: Add dispatchers to kallsyms
      bpf: Remove bpf_image tree
      perf tools: Synthesize bpf_trampoline/dispatcher ksymbol event
      perf tools: Set ksymbol dso as loaded on arrival
      perf annotate: Add base support for bpf_image

 arch/x86/mm/init_32.c       |  14 +++++++++-----
 include/linux/bpf.h         |  65 ++++++++++++++++++++++++++++++++++++++++-------------------------
 include/linux/filter.h      |  15 ++++-----------
 kernel/bpf/core.c           | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------
 kernel/bpf/dispatcher.c     |   5 +++--
 kernel/bpf/trampoline.c     |  85 +++++++++++++++++++++++++------------------------------------------------------------
 kernel/events/core.c        |   9 ++++-----
 kernel/extable.c            |   2 --
 net/core/filter.c           |   5 ++---
 tools/perf/util/annotate.c  |  20 ++++++++++++++++++++
 tools/perf/util/bpf-event.c |  92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/dso.c       |   1 +
 tools/perf/util/dso.h       |   1 +
 tools/perf/util/machine.c   |  12 ++++++++++++
 tools/perf/util/symbol.c    |   1 +
 15 files changed, 278 insertions(+), 169 deletions(-)

