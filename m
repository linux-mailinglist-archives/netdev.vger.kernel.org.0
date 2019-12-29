Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307AA12C2B6
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 15:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfL2Ohu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 29 Dec 2019 09:37:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31023 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726597AbfL2Ohu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 09:37:50 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-mANVrxyyOtiOAkQRJfTEHQ-1; Sun, 29 Dec 2019 09:37:46 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27DF110054E3;
        Sun, 29 Dec 2019 14:37:44 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-25.brq.redhat.com [10.40.204.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B7015DA2C;
        Sun, 29 Dec 2019 14:37:41 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: [RFC 0/5] bpf: Add trampoline helpers
Date:   Sun, 29 Dec 2019 15:37:35 +0100
Message-Id: <20191229143740.29143-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: mANVrxyyOtiOAkQRJfTEHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
I understand trampolines are brand new stuff and you guys
might be already working on this.

However, I was checking on the trampoline probes and could
get some really nice speedup for few bcc progs.

Here's output of perf bench while running klockstat.py:

    Without:
            $ perf bench sched messaging -l 50000
            ...
                 Total time: 18.571 [sec]

    With current kprobe tracing:
            $ perf bench sched messaging -l 50000
            ...
                 Total time: 183.395 [sec]

    With kfunc tracing:
            $ perf bench sched messaging -l 50000
            ...
                 Total time: 39.773 [sec]


I needed to add few perf_event_output, stack retrieval
helpers and trampoline lookup during orc unwinding.

It's also available in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git bpf/kfunc


Apart from these helpers, several other patches (like perf
and ftrace ring buffer renames) are needed to make it all work,
it's pushed in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git bpf/kfunc_all

You can check on current bcc changes in here:
  https://github.com/olsajiri/bcc/tree/kfunc

thanks,
jirka


---
Jiri Olsa (5):
      bpf: Allow non struct type for btf ctx access
      bpf: Add bpf_perf_event_output_kfunc
      bpf: Add bpf_get_stackid_kfunc
      bpf: Add bpf_get_stack_kfunc
      bpf: Allow to resolve bpf trampoline in unwind

 include/linux/bpf.h      |   6 ++++++
 kernel/bpf/btf.c         |   6 ------
 kernel/bpf/core.c        |   2 ++
 kernel/bpf/trampoline.c  |  35 +++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 166 insertions(+), 6 deletions(-)

