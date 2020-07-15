Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D39220DB2
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbgGONJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:09:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59945 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729900AbgGONJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594818544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KxvBS+x/c3n7X+53Golhdx75/yWdayPMXF8ZysL3UmE=;
        b=GNxa9z+IqJI6PDy9MS1riWBd9yrw2olrNNJgT98kPpAInLevnJY814Lv5t5x7G/f+y9Dim
        nXVzOcAuN/Eyml2jkOGg1ZxsBO8OT1QhB8lElZqY3P7OTNwj092QFytYYoMFfQy0hjnMj4
        jmLQYAL6krHuIYpq6lN3H11FYKSbGp0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-oZVZRcHcMPiLNDMXHOGeHw-1; Wed, 15 Jul 2020 09:09:02 -0400
X-MC-Unique: oZVZRcHcMPiLNDMXHOGeHw-1
Received: by mail-qt1-f199.google.com with SMTP id r25so1321867qtj.11
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 06:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=KxvBS+x/c3n7X+53Golhdx75/yWdayPMXF8ZysL3UmE=;
        b=edQu4EiJgKt0ZItrP2zZMfVCGH3wBem7onraNa8NCaW0886FD/gM1wEuxq9bDez9m8
         DD8dom5eCU3gnuyW346HP//QoMQQnlYvLgaSXUyZNqm8P48NeReeDZ/lXG9xPKNG9tXP
         6cMVHh7r4Y1Aj12qoKnIa5rZK3oKwCaFYKXIw1YH8DGmJRweAPNVPzfUkb0HjWX5nbyQ
         xpzz/CI5llvfmoNiqjbMGDuCw0QY82ipHeV7FuxpE25vWp+IoavhbAUTHJZ/Klnib1NC
         Lq0wR1L9w8EZlDQYZPpMZr5BjISwIrqxjCiIHjmpaIsVzhfJapkiy5757K8yxuDJsVIQ
         GrLg==
X-Gm-Message-State: AOAM532ISz2MkX+sXmAhN0vxFOrS1QANe6esldtqKZki5JE6wj6oOXbF
        JFBeKOurF0yBtW7qJh81WE4s4y6J2M48SuKgBObsZL92rhTfWt9eWIzkVtrCGRfIVnlERvlggNZ
        Ru1eQimkriLHkLj0n
X-Received: by 2002:ae9:e809:: with SMTP id a9mr9419631qkg.315.1594818541896;
        Wed, 15 Jul 2020 06:09:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/O4D7cXIrjdto3G7rXonIZsapZnjMx7Q5d91zuxkwI9PQExlMBvCP55gmTwYS7bHOch6p8w==
X-Received: by 2002:ae9:e809:: with SMTP id a9mr9419591qkg.315.1594818541518;
        Wed, 15 Jul 2020 06:09:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u68sm2583882qkd.59.2020.07.15.06.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:09:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 52A6A1804F0; Wed, 15 Jul 2020 15:08:59 +0200 (CEST)
Subject: [PATCH bpf-next v2 0/6] bpf: Support multi-attach for freplace
 programs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Wed, 15 Jul 2020 15:08:59 +0200
Message-ID: <159481853923.454654.12184603524310603480.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support attaching freplace BPF programs to multiple targets.
This is needed to support incremental attachment of multiple XDP programs using
the libxdp dispatcher model.

The first two patches are refactoring patches: The first one is a trivial change
to the logging in the verifier, split out to make the subsequent refactor easier
to read. Patch 2 refactors check_attach_btf_id() so that the checks on program
and target compatibility can be reused when attaching to a secondary location.

Patch 3 contains the change that actually allows attaching freplace programs in
multiple places. Patches 4-6 are the usual tools header updates, libbpf support
and selftest.

See the individual patches for details.

Changelog:

v2:
  - Drop the log arguments from bpf_raw_tracepoint_open
  - Fix kbot errors
  - Rebase to latest bpf-next

---

Toke Høiland-Jørgensen (6):
      bpf: change logging calls from verbose() to bpf_log() and use log pointer
      bpf: verifier: refactor check_attach_btf_id()
      bpf: support attaching freplace programs to multiple attach points
      tools: add new members to bpf_attr.raw_tracepoint in bpf.h
      libbpf: add support for supplying target to bpf_raw_tracepoint_open()
      selftests: add test for multiple attachments of freplace program


 include/linux/bpf.h                           |  23 ++-
 include/linux/bpf_verifier.h                  |   9 +
 include/uapi/linux/bpf.h                      |   6 +-
 kernel/bpf/core.c                             |   1 -
 kernel/bpf/syscall.c                          |  78 +++++++-
 kernel/bpf/trampoline.c                       |  36 +++-
 kernel/bpf/verifier.c                         | 171 ++++++++++--------
 tools/include/uapi/linux/bpf.h                |   6 +-
 tools/lib/bpf/bpf.c                           |  13 +-
 tools/lib/bpf/bpf.h                           |   9 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 164 ++++++++++++++---
 .../bpf/progs/freplace_get_constant.c         |  15 ++
 13 files changed, 404 insertions(+), 128 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c

