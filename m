Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3B635B46F
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 15:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbhDKNAp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Apr 2021 09:00:45 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:46540 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235095AbhDKNAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 09:00:42 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-giCDps9eNZWOx9H2k5bC9w-1; Sun, 11 Apr 2021 09:00:21 -0400
X-MC-Unique: giCDps9eNZWOx9H2k5bC9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CBC0802B62;
        Sun, 11 Apr 2021 13:00:19 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6807F101E24A;
        Sun, 11 Apr 2021 13:00:11 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCHv3 bpf-next 0/5] bpf: Tracing and lsm programs re-attach
Date:   Sun, 11 Apr 2021 15:00:05 +0200
Message-Id: <20210411130010.1337650-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

v3 changes:
  - used ASSERT* macros apart from lsm test, which is using
    CHECKs all over the place [Andrii]
  - added acks

thanks,
jirka


[1] https://lore.kernel.org/bpf/20210326105900.151466-1-jolsa@kernel.org/
---
Jiri Olsa (5):
      bpf: Allow trampoline re-attach for tracing and lsm programs
      selftests/bpf: Add re-attach test to fentry_test
      selftests/bpf: Add re-attach test to fexit_test
      selftests/bpf: Add re-attach test to lsm test
      selftests/bpf: Test that module can't be unloaded with attached trampoline

 kernel/bpf/syscall.c                                   | 23 +++++++++++++++++------
 kernel/bpf/trampoline.c                                |  2 +-
 tools/testing/selftests/bpf/prog_tests/fentry_test.c   | 51 ++++++++++++++++++++++++++++++++++++---------------
 tools/testing/selftests/bpf/prog_tests/fexit_test.c    | 51 ++++++++++++++++++++++++++++++++++++---------------
 tools/testing/selftests/bpf/prog_tests/module_attach.c | 23 +++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/test_lsm.c      | 48 ++++++++++++++++++++++++++++++++++++++----------
 tools/testing/selftests/bpf/test_progs.h               |  2 +-
 7 files changed, 152 insertions(+), 48 deletions(-)

