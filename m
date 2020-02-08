Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCFD15651A
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 16:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgBHPmX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Feb 2020 10:42:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24972 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727303AbgBHPmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 10:42:23 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-Jck_Fx8gPgiAxy-kwpy1sw-1; Sat, 08 Feb 2020 10:42:16 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BA47800D6C;
        Sat,  8 Feb 2020 15:42:14 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-79.brq.redhat.com [10.40.204.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A0EB5C21B;
        Sat,  8 Feb 2020 15:42:10 +0000 (UTC)
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
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH 00/14] bpf: Add trampoline and dispatcher to /proc/kallsyms
Date:   Sat,  8 Feb 2020 16:41:55 +0100
Message-Id: <20200208154209.1797988-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Jck_Fx8gPgiAxy-kwpy1sw-1
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

thanks,
jirka


---
Björn Töpel (1):
      bpf: Add bpf_trampoline_ name prefix for DECLARE_BPF_DISPATCHER

Jiri Olsa (13):
      x86/mm: Rename is_kernel_text to __is_kernel_text
      bpf: Add struct bpf_ksym
      bpf: Add name to struct bpf_ksym
      bpf: Add lnode list node to struct bpf_ksym
      bpf: Add bpf_kallsyms_tree tree
      bpf: Move bpf_tree add/del from bpf_prog_ksym_node_add/del
      bpf: Separate kallsyms add/del functions
      bpf: Add bpf_ksym_add/del functions
      bpf: Re-initialize lnode in bpf_ksym_del
      bpf: Rename bpf_tree to bpf_progs_tree
      bpf: Add trampolines to kallsyms
      bpf: Add dispatchers to kallsyms
      bpf: Sort bpf kallsyms symbols

 arch/x86/mm/init_32.c   |  14 ++++++----
 include/linux/bpf.h     |  54 ++++++++++++++++++++++++++------------
 include/linux/filter.h  |  13 +++-------
 kernel/bpf/core.c       | 182 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------
 kernel/bpf/dispatcher.c |   6 +++++
 kernel/bpf/trampoline.c |  23 ++++++++++++++++
 kernel/events/core.c    |   4 +--
 net/core/filter.c       |   5 ++--
 8 files changed, 219 insertions(+), 82 deletions(-)

