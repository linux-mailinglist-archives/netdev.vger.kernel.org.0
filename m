Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841908C103
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbfHMSsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:48:05 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:37424 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfHMSsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:48:05 -0400
Received: by mail-vs1-f66.google.com with SMTP id v6so72922838vsq.4;
        Tue, 13 Aug 2019 11:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lXm1VYLlCi38Amhu4Ar+PnZOOlGXBtti8ocNTNH5bF4=;
        b=TA6KaZqtBUyWx8CGlZ5EPEMtH/1z13y7WbduU5jNiWCyS3LX59V6GvVmloLhrHH/hC
         8EZkLmJH2fRNjCeBRHgPptn0v9g4LkOcV1EsMaUe8a+giS26jfSzei9J0ZSLi44Qc/fF
         iRU6fiFM3SK27OHAB5B2O1kTZRRhMLyMyENS+oKBfiqvHorqWRHRlm5RIzB3Cq4Chmbq
         Qw2rNcsxJrnTDFociZWGbpAWPTLMTkG1Fi6A4gKZXSXipNbs+M2VhB1KLTpcArG5CUG7
         WmgOdquCKqAQvP5b6uC6MKR+7NrfO9prmupLm0Ta/Yw8lZijXkRrQex2tKKQ/JguBCmj
         5YUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lXm1VYLlCi38Amhu4Ar+PnZOOlGXBtti8ocNTNH5bF4=;
        b=pulLqQRLzGyhERPQEIOH75S/BlVpNnGUZKCl6oXM7c9qaVkUOilcP8stpX/1Fe1STa
         O4nZg8XoS7lWJxVaL1bMj8irKzLAM5rbiazuswPLNnR6GbacneBdqBZ7Fq7v4wC79L7a
         Luj2d5P7sbWLlWqlZMOF2ZPzBChqCUnnIambIB12oUQFP+LrZaookem3JQXb57h/njf8
         osEVgY6fNxobUQgY+DBDevVsl8OxmCQ67NXLg6dVasyZq1rnoX+Wm57qZMCLM7h3Yqk8
         x3X1XqXdPQrsdwmNWh4VP1km0MSLqsvDDGFYCIOaMhFhftPOhOQvGTBVwl4AC8Q9jgcg
         eA4w==
X-Gm-Message-State: APjAAAX8x/AA7DM5q264VO964CEOssee7JgLguwGwtdodW6w8D82Tbkg
        zV4N9xC51PtApcrph3m3lhT1N4NSwUYRLw==
X-Google-Smtp-Source: APXvYqwFCO+H/ow3Va8gi4+OobbCOQJNDrmmDnDePBXyJur3riQrygBXXfo/k9G3GQHoPLTbWEGTLw==
X-Received: by 2002:a67:e2d8:: with SMTP id i24mr9608405vsm.11.1565722083790;
        Tue, 13 Aug 2019 11:48:03 -0700 (PDT)
Received: from localhost.localdomain ([190.162.109.53])
        by smtp.googlemail.com with ESMTPSA id o9sm71767069vkd.27.2019.08.13.11.48.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 11:48:03 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        cneirabustos@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next V9 0/3] BPF: New helper to obtain namespace data  from current task
Date:   Tue, 13 Aug 2019 11:47:44 -0700
Message-Id: <20190813184747.12225-1-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper obtains the active namespace from current and returns pid, tgid,
device and namespace id as seen from that namespace, allowing to instrument
a process inside a container.
Device is read from /proc/self/ns/pid, as in the future it's possible that
different pid_ns files may belong to different devices, according
to the discussion between Eric Biederman and Yonghong in 2017 linux plumbers
conference.
Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
scripts but this helper returns the pid as seen by the root namespace which is
fine when a bcc script is not executed inside a container.
When the process of interest is inside a container, pid filtering will not work
if bpf_get_current_pid_tgid() is used. This helper addresses this limitation
returning the pid as it's seen by the current namespace where the script is
executing.

This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
used to do pid filtering even inside a container.

For example a bcc script using bpf_get_current_pid_tgid() (tools/funccount.py):

        u32 pid = bpf_get_current_pid_tgid() >> 32;
        if (pid != <pid_arg_passed_in>)
                return 0;
Could be modified to use bpf_get_current_pidns_info() as follows:

        struct bpf_pidns pidns;
        bpf_get_current_pidns_info(&pidns, sizeof(struct bpf_pidns));
        u32 pid = pidns.tgid;
        u32 nsid = pidns.nsid;
        if ((pid != <pid_arg_passed_in>) && (nsid != <nsid_arg_passed_in>))
                return 0;

To find out the name PID namespace id of a process, you could use this command:

$ ps -h -o pidns -p <pid_of_interest>

Or this other command:

$ ls -Li /proc/<pid_of_interest>/ns/pid

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

Carlos Neira (3):
  bpf: new helper to obtain namespace data from current task
  samples/bpf: added sample code for bpf_get_current_pidns_info.
  tools/testing/selftests/bpf: Add self-tests for new helper.

 fs/internal.h                                      |   2 -
 fs/namei.c                                         |   1 -
 include/linux/bpf.h                                |   1 +
 include/linux/namei.h                              |   4 +
 include/uapi/linux/bpf.h                           |  31 ++++-
 kernel/bpf/core.c                                  |   1 +
 kernel/bpf/helpers.c                               |  64 ++++++++++
 kernel/trace/bpf_trace.c                           |   2 +
 samples/bpf/Makefile                               |   3 +
 samples/bpf/trace_ns_info_user.c                   |  35 ++++++
 samples/bpf/trace_ns_info_user_kern.c              |  44 +++++++
 tools/include/uapi/linux/bpf.h                     |  31 ++++-
 tools/testing/selftests/bpf/Makefile               |   2 +-
 tools/testing/selftests/bpf/bpf_helpers.h          |   3 +
 .../testing/selftests/bpf/progs/test_pidns_kern.c  |  51 ++++++++
 tools/testing/selftests/bpf/test_pidns.c           | 138 +++++++++++++++++++++
 16 files changed, 407 insertions(+), 6 deletions(-)
 create mode 100644 samples/bpf/trace_ns_info_user.c
 create mode 100644 samples/bpf/trace_ns_info_user_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_pidns.c

-- 
2.11.0

