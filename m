Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBCDDB095
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406585AbfJQPAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:00:43 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36502 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731768AbfJQPAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:00:43 -0400
Received: by mail-qk1-f193.google.com with SMTP id y189so2165043qkc.3;
        Thu, 17 Oct 2019 08:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=heVi2Qj355umYo2Unt4YEmLK1YU/Q3Xwqu6CCf0fXm8=;
        b=bYz2Ub8IlZdHEXWYe0HgLPqfIUHPUr6I2fhOLWb9skXibIuSJCzY6RoPvXwl21FVya
         VCQ/TkJhpOMxq31cOL1CF99XamUONeASRdkD5P3eQXsk0RqnD38QyJ8tPR/nbw1vszWg
         mSB+Ryn1APcZ5VxdH6neLfbDsfdxC93MLDuZMJOCGaH0AQD2+GMzryn9upWksXeJ+7PG
         z98fRHmLbbIEolTcYhEKFZQ6+tOqQk994OW0y/lQ1hN5AqTsg67J76wDUcaeSsuEaxxS
         DNbdfvQyvnmcq5t1310R1FqUPIuWf4zeEKIkNL3O+jrOEOS1zDm1SqSU5J+XYICYjqTI
         yqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=heVi2Qj355umYo2Unt4YEmLK1YU/Q3Xwqu6CCf0fXm8=;
        b=NE0vzaSVfv3yKC3Qd8Jez3BhPZTcQjhWjiFeESob40FGOQxwZoQzdQ217t+FzZ0TmZ
         s9LHNQ1uRParS2REiRXgNzhaRmjCmuUaKo0OHbIc65RkePPq+vNQSuu/RAl601hyL6is
         A6eEsP3mI6S72C7tzGejQ+SyeQrMMCZOMZKJDyWgF90D2YNFAG8Jqcjz309pC7fHT5kJ
         f69ZO5MErmKGOP4UzxJYVqFuw+qrIXiCt4EEr2NX9CSVg631xcMu2TX+rTIZavFc/97Z
         uu4C3s7hzJYQDvPsFoAW5lQUsXFkcQF7LOrmODQ7/Of4onsXTE5mychFUJEMne6CZ/go
         pQcw==
X-Gm-Message-State: APjAAAV8bpio4ba4IMNLjbnR5c20mIfcxEuw2trmKaautHrpxw+fMDpU
        Zw1s8Wze40VkEH/YKyqDYQ5LIxtB8C4=
X-Google-Smtp-Source: APXvYqyQLmVrWa1BUcSIg2lsXk6cI9QgNuz5mjhBM4uG/2bLQGYRyIbhNfLafcLvVjpZ38UwY6hGnQ==
X-Received: by 2002:a37:6f06:: with SMTP id k6mr3732662qkc.143.1571324441880;
        Thu, 17 Oct 2019 08:00:41 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id z20sm1550859qtu.91.2019.10.17.08.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 08:00:41 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v14 0/5] BPF: New helper to obtain namespace data from current task
Date:   Thu, 17 Oct 2019 12:00:27 -0300
Message-Id: <20191017150032.14359-1-cneirabustos@gmail.com>
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

Changes from V13:

- refactored selftests
- refactored ebpf helper

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>


Carlos Neira (5):
  fs/nsfs.c: added ns_match
  bpf: added new helper bpf_get_ns_current_pid_tgid
  tools: Added bpf_get_ns_current_pid_tgid helper
  tools/testing/selftests/bpf: Add self-tests for new  helper.
  bpf_helpers_doc.py: Add struct bpf_pidns_info to known types

 fs/nsfs.c                                     |  8 ++
 include/linux/bpf.h                           |  1 +
 include/linux/proc_ns.h                       |  2 +
 include/uapi/linux/bpf.h                      | 20 +++-
 kernel/bpf/core.c                             |  1 +
 kernel/bpf/helpers.c                          | 45 +++++++++
 kernel/trace/bpf_trace.c                      |  2 +
 scripts/bpf_helpers_doc.py                    |  1 +
 tools/include/uapi/linux/bpf.h                | 20 +++-
 .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 96 +++++++++++++++++++
 .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 53 ++++++++++
 11 files changed, 247 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c

-- 
2.20.1

