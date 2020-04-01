Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B10819AA78
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732356AbgDALJV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Apr 2020 07:09:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22496 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732234AbgDALJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 07:09:21 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-ff90X8cOP66KmspAlL1Mdg-1; Wed, 01 Apr 2020 07:09:14 -0400
X-MC-Unique: ff90X8cOP66KmspAlL1Mdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E631213FD;
        Wed,  1 Apr 2020 11:09:11 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8818110027AF;
        Wed,  1 Apr 2020 11:09:08 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC 0/3] bpf: Add d_path helper
Date:   Wed,  1 Apr 2020 13:09:04 +0200
Message-Id: <20200401110907.2669564-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding d_path helper to return full path for 'path' object.

I originally added and used 'file_path' helper, which did the same,
but used 'struct file' object. Then realized that file_path is just
a wrapper for d_path, so we'd cover more calling sites if we add
d_path helper and allowed resolving BTF object within another object,
so we could call d_path also with file pointer, like:

  bpf_d_path(&file->f_path, buf, size);

This feature is mainly to be able to add dpath (filepath originally)
function to bpftrace, which seems to work nicely now, like:

  # bpftrace -e 'kretfunc:fget { printf("%s\n", dpath(args->ret->f_path));  }' 

I'm not completely sure this is all safe and bullet proof and there's
no other way to do this, hence RFC post.

I'd be happy also with file_path function, but I thought it'd be
a shame not to try to add d_path with the verifier change.
I'm open to any suggestions ;-)

thanks,
jirka


---
Jiri Olsa (3):
      bpf: Add support to check if BTF object is nested in another object
      bpf: Add d_path helper
      selftests/bpf: Add test for d_path helper

 include/linux/bpf.h                             |   3 ++
 include/uapi/linux/bpf.h                        |  14 ++++++-
 kernel/bpf/btf.c                                |  69 +++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c                           |  18 ++++++++-
 kernel/trace/bpf_trace.c                        |  31 +++++++++++++++
 scripts/bpf_helpers_doc.py                      |   2 +
 tools/include/uapi/linux/bpf.h                  |  14 ++++++-
 tools/testing/selftests/bpf/prog_tests/d_path.c | 196 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_d_path.c |  71 ++++++++++++++++++++++++++++++++++
 9 files changed, 414 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c

