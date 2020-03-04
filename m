Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E019C179A51
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbgCDUmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:42:49 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34771 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbgCDUmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:42:49 -0500
Received: by mail-qk1-f194.google.com with SMTP id f3so3071938qkh.1;
        Wed, 04 Mar 2020 12:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9ecW3xZbekPnjtIaMnbSXTNbQAWf8HFfzOkMqz2Jfc8=;
        b=Ut3gRuqdS2JCJNE1E6UuYGi4lqyLPcoNot2zl0CnrykHE9NCbCFxhjlFPrMkNAllHu
         pmcC5bZC20sUzTm2z/We4d0Yx/rfWk3pY+IkGEZjEimaCCqb9L5z5xPjzNCTUaH/f03D
         AahxR3EAD5bAN+waKZNCVM71L33mmX3+iZektNkvwMJKmz740uaIuGXGYuAo/HpkhXu7
         hH33Jgxptgtr/0OJt2mW4tl3WIIk5jdambJofp/ore/g71z0dLgoSGRihKUdhnejcquS
         pS1jaxnaOlp8Bd24dWnmn9YM0DE05n0LP5B+05dUgdpmO7J13afoLSVNuFCjpVpDPtgB
         X+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9ecW3xZbekPnjtIaMnbSXTNbQAWf8HFfzOkMqz2Jfc8=;
        b=fE3f/X87/KLyLHYfgeRarWuLn3dvUIKwXJuTsD8LogavNSqmyaHH2u89pEOP3+Orqo
         dCx1jYSdAGF+O40f32F4+mA1IhXUTeA1e7xFc4TXtkg4zimPhtCXeQ/ag0/QfBZcAtie
         n7Gl+raw2GP13KPBDlfFQpyH//DI+zQIEm4OOt0XwtQz018/c5d93TnB0gQSky7sxlJP
         mAOU/ioisahjJ4HjYZ0GWvMLgoqZDdr6spSwtBPVJaCQ/HFFyIisP+u+k637KHZe60Gg
         4ev4z1QK9wT/637YMXX/EmIU1CcxK6XsK2gFvQDG1fGvWf1lOoAcbpoZdcEAQvneVr8A
         Zd3g==
X-Gm-Message-State: ANhLgQ1+vq5auS/j4QsMrlqzIakLOUtynURMet92Pd1O0qeHNG/wM/I0
        uZS1gg7sQcYs23OTG6GgdlVqDVGdYhU=
X-Google-Smtp-Source: ADFU+vseeKIhPVAcGEBtFVkoEdoH5O3m5lVPm+D2zwuiZSODnGI9tozAsAw6ivt7nVdF7Dklumrczw==
X-Received: by 2002:a05:620a:136b:: with SMTP id d11mr4910875qkl.11.1583354566618;
        Wed, 04 Mar 2020 12:42:46 -0800 (PST)
Received: from localhost.localdomain (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id 82sm1750232qko.91.2020.03.04.12.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 12:42:45 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v17 0/3] BPF: New helper to obtain namespace data from current task
Date:   Wed,  4 Mar 2020 17:41:54 -0300
Message-Id: <20200304204157.58695-1-cneirabustos@gmail.com>
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



Carlos Neira (3):
  fs/nsfs.c: added ns_match
  bpf: added new helper bpf_get_ns_current_pid_tgid
  tools/testing/selftests/bpf: Add self-tests for new helper
    bpf_get_ns_current_pid_tgid.

 fs/nsfs.c                                     |  14 ++
 include/linux/bpf.h                           |   1 +
 include/linux/proc_ns.h                       |   2 +
 include/uapi/linux/bpf.h                      |  20 ++-
 kernel/bpf/core.c                             |   1 +
 kernel/bpf/helpers.c                          |  45 +++++
 kernel/trace/bpf_trace.c                      |   2 +
 scripts/bpf_helpers_doc.py                    |   1 +
 tools/include/uapi/linux/bpf.h                |  20 ++-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/prog_tests/ns_current_pid_tgid.c      |  88 ++++++++++
 .../bpf/progs/test_ns_current_pid_tgid.c      |  37 ++++
 .../bpf/test_current_pid_tgid_new_ns.c        | 159 ++++++++++++++++++
 13 files changed, 390 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c

-- 
2.20.1

