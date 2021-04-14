Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C606F35FBE5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349356AbhDNTwX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 15:52:23 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:30073 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349315AbhDNTwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:52:22 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-6NTSzC4ENvSCcuLet0KdcA-1; Wed, 14 Apr 2021 15:51:55 -0400
X-MC-Unique: 6NTSzC4ENvSCcuLet0KdcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 377EB1854E20;
        Wed, 14 Apr 2021 19:51:54 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 396DF197F9;
        Wed, 14 Apr 2021 19:51:48 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCHv5 bpf-next 0/7] bpf: Tracing and lsm programs re-attach
Date:   Wed, 14 Apr 2021 21:51:40 +0200
Message-Id: <20210414195147.1624932-1-jolsa@kernel.org>
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
while adding test for pinning the module while there's
trampoline attach to it, I noticed that we don't allow
link detach and following re-attach for trampolines.
Adding that for tracing and lsm programs.

You need to have patch [1] from bpf tree for test module
attach test to pass.

v5 changes:
  - fixed missing hlist_del_init change
  - fixed several ASSERT calls
  - added extra patch for missing ';'
  - added ASSERT macros to lsm test
  - added acks

thanks,
jirka


[1] https://lore.kernel.org/bpf/20210326105900.151466-1-jolsa@kernel.org/
---
Jiri Olsa (7):
      bpf: Allow trampoline re-attach for tracing and lsm programs
      selftests/bpf: Add missing semicolon
      selftests/bpf: Add re-attach test to fentry_test
      selftests/bpf: Add re-attach test to fexit_test
      selftests/bpf: Add re-attach test to lsm test
      selftests/bpf: Test that module can't be unloaded with attached trampoline
      selftests/bpf: Use ASSERT macros in lsm test

 kernel/bpf/syscall.c                                   | 23 +++++++++++++++++------
 kernel/bpf/trampoline.c                                |  4 ++--
 tools/testing/selftests/bpf/prog_tests/fentry_test.c   | 52 +++++++++++++++++++++++++++++++++++++---------------
 tools/testing/selftests/bpf/prog_tests/fexit_test.c    | 52 +++++++++++++++++++++++++++++++++++++---------------
 tools/testing/selftests/bpf/prog_tests/module_attach.c | 23 +++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/test_lsm.c      | 61 +++++++++++++++++++++++++++++++++++++++++--------------------
 tools/testing/selftests/bpf/test_progs.h               |  2 +-
 7 files changed, 158 insertions(+), 59 deletions(-)

