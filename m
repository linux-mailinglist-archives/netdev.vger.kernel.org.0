Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF909E0C64
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbfJVTSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:18:06 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40244 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVTSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:18:05 -0400
Received: by mail-qt1-f193.google.com with SMTP id o49so20654499qta.7;
        Tue, 22 Oct 2019 12:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D1ytiAYmn9h5F7QxtAsY15k4zNam0DY6WDr6JaJh09s=;
        b=Vb5oh6ovm41hhifK4ItXZkK5ImxEynoxhhEEutWkB803v+qDNZpnOHDHkBY3uKlGyb
         2kG0cEB+WQBEzFHaEfMzWbC6JitU7BQcFoC5lwdDhqnXIlrtFkIFJ3pY69slli/9gD+I
         H8x2SHm6waFuyIRK01YPP6HeMWJH84hbCacLypp/wHeDS1bRy3w1AR0LgqTZ81ys7bFu
         L2JZCI6asMeA1+q/+iRKkWjQaasH6kGvVB6x7HJA2BueEvXrGZBgjW+mnfI6y9W6gN6d
         WQWuq2JC2nL3FdipjdTkaicYl3KhjY8bGcogTYZlcKc9PHelre0DJu50xtAKyohKme36
         /eHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D1ytiAYmn9h5F7QxtAsY15k4zNam0DY6WDr6JaJh09s=;
        b=VjqmmMaJ0LX6hMkKC7K9KIg3toewCCHIbZuCiPsU/sJ2ZhjeApIUvFgMAw6peVz4Ex
         e+iGXjJ9x2FZYDIbgDXiGGUjZlKYsYTVw0PMbejcKoFQAb9rFW9J27RyQHOKWbw/VUCL
         3du+wnhi6U9pmzl1OfTH8wUAIdBRuRjT1vP3ZMYl6q2i8QEc3P02sgtcMOMgvGzr7ft+
         3xMwPLYgRrgubWiGrCNVy+z9CenJLwgdpLaHFAq80pyhCVVLwOo8plHvzqx8+9EJ6YE0
         vIqfxDhDVXFuxKTnyGCY7pzK0C5nvJ1/qXxyG18iER8I56tp7T6Af4eQEFrESOtNIQXp
         3muA==
X-Gm-Message-State: APjAAAXuomLXBBxOe8/FV9a4ohnnrqtkY04BoiKxpbgUt6UC8mCVmuSO
        Z48Pt8V67NP6wUpnSk9nLdLhbBX4Rk7zoNrH
X-Google-Smtp-Source: APXvYqwcyaH/6M5xW6LgsKNRUF6gE3PUQ5r4tu8ZIbt7Y8Pn7a5pLyt45D50Vj8bttGH8Q5sLnr6sg==
X-Received: by 2002:ac8:529a:: with SMTP id s26mr5045083qtn.322.1571771883114;
        Tue, 22 Oct 2019 12:18:03 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id r36sm8015969qta.27.2019.10.22.12.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 12:18:02 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v15 0/5] BPF: New helper to obtain namespace data from current task
Date:   Tue, 22 Oct 2019 16:17:46 -0300
Message-Id: <20191022191751.3780-1-cneirabustos@gmail.com>
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

Changes from V14:

- refactored selftests
- refactored ebpf helper

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

Carlos Neira (5):
  fs/nsfs.c: added ns_match
  bpf: added new helper bpf_get_ns_current_pid_tgid
  tools: Added bpf_get_ns_current_pid_tgid helper
  tools/testing/selftests/bpf: Add self-tests for new  helper.
  bpf_helpers_doc.py: Add struct bpf_pidns_info to known types

 fs/nsfs.c                                     | 14 +++
 include/linux/bpf.h                           |  1 +
 include/linux/proc_ns.h                       |  2 +
 include/uapi/linux/bpf.h                      | 20 ++++-
 kernel/bpf/core.c                             |  1 +
 kernel/bpf/helpers.c                          | 45 ++++++++++
 kernel/trace/bpf_trace.c                      |  2 +
 scripts/bpf_helpers_doc.py                    |  1 +
 tools/include/uapi/linux/bpf.h                | 20 ++++-
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 87 +++++++++++++++++++
 .../bpf/progs/test_ns_current_pid_tgid.c      | 37 ++++++++
 11 files changed, 228 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c

-- 
2.20.1

