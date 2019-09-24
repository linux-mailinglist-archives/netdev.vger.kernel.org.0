Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AF2BCB08
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732217AbfIXPUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:20:25 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40573 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730625AbfIXPUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:20:24 -0400
Received: by mail-qt1-f194.google.com with SMTP id x5so2589217qtr.7;
        Tue, 24 Sep 2019 08:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4U97q1bgjdbURb8h+PgZk5MdNvAp2ndyyMyBYTipIow=;
        b=E89Qo7f7HT0oo9JNq+WFjU8B7cfZ+SqrwKYdGG6QyzLD5j6LSPFvevqy1742DNWwDW
         dCePoG0hqAypLxPQDKIpLrAmxnj781NfEUAIcSvXyomSh4OQFbmS3x+4OeQsTKOCxaLC
         poFKk3zvvM8fDzmVmIpTDCuWT3DYhpW1XsdcqI7RIn0z1fLiVN7zvP36snyAqW6I9zlV
         CFpeSbKzsF4eTLTPzQ5qwcIbqyoow9/nbkNE/eIz+Y8v0TKyTr3NhRZbjJOphHmkgQpc
         U78bDRipYsCnSnNGVntaBSiG3ulBC4hgf/L1TMHfuhA4W5a+/+JJOO5+mUaimBy0+bel
         1WKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4U97q1bgjdbURb8h+PgZk5MdNvAp2ndyyMyBYTipIow=;
        b=rF5ttMC1mnA3VMw4a63AdK18/QV5DPXz1xt3as559HwXvlCjk05XzGSnV5ju1Bkn/3
         slSxWCLx0FSdEQUF8qM2bkw7cCYwP/cyCCt9Y3LY80iZQvNfP5+/mvC8HO8u/5gu69CX
         r4wEVTGIi/M94GGPxhEoupSDYDZlAvDMhF6fK26B+6SZgMIaCg6XU9ibHUAyf1ysk4H6
         174XeaJgEeq2hM19zV6+rtDfH9Rvr16/Enl6UGmnNZX/AL9wz9tPRU33eMqxwqg5moAA
         UZuU4GXxSXaQ+lFASDMjNPZAW6NtbwIQyRuz9+/hWnjbKKU7HMjd9LAi1P8xjZzPYpsv
         7q6g==
X-Gm-Message-State: APjAAAXGJCjxbl3Uea/1tn2JgJhVPaajgvfreAkZ0V05fJpMnSL3KsyP
        aukeUXtpSInx6wzvyTd/kzLalz0TY84=
X-Google-Smtp-Source: APXvYqyanrUeAZ9+FfQLaPgYTsPYcGvqiZuQERjbGdr4vvZQc9KZgKPMl7jLUqFStBebQLK/cfGO6w==
X-Received: by 2002:a0c:cc14:: with SMTP id r20mr2946453qvk.61.1569338423299;
        Tue, 24 Sep 2019 08:20:23 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id h68sm1073533qkd.35.2019.09.24.08.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 08:20:22 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH V11 0/4] BPF: New helper to obtain namespace data from current task 
Date:   Tue, 24 Sep 2019 12:20:01 -0300
Message-Id: <20190924152005.4659-1-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
scripts but this helper returns the pid as seen by the root namespace which is
fine when a bcc script is not executed inside a container.
When the process of interest is inside a container, pid filtering will not work
if bpf_get_current_pid_tgid() is used.
This helper addresses this limitation returning the pid as it's seen by the current
namespace where the script is executing.

In the future different pid_ns files may belong to different devices, according to the
discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
used to do pid filtering even inside a container.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

Carlos Neira (4):
  fs/nsfs.c: added ns_match
  bpf: added new helper bpf_get_ns_current_pid_tgid
  tools: Added bpf_get_ns_current_pid_tgid helper
  tools/testing/selftests/bpf: Add self-tests for new helper. self tests
    added for new helper

 fs/nsfs.c                                     |   8 +
 include/linux/bpf.h                           |   1 +
 include/linux/proc_ns.h                       |   2 +
 include/uapi/linux/bpf.h                      |  18 ++-
 kernel/bpf/core.c                             |   1 +
 kernel/bpf/helpers.c                          |  32 ++++
 kernel/trace/bpf_trace.c                      |   2 +
 tools/include/uapi/linux/bpf.h                |  18 ++-
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
 .../selftests/bpf/progs/test_pidns_kern.c     |  71 ++++++++
 tools/testing/selftests/bpf/test_pidns.c      | 152 ++++++++++++++++++
 12 files changed, 307 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_pidns.c

-- 
2.20.1

