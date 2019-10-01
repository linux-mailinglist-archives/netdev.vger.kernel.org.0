Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9093FC42D7
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfJAVl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:41:56 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38575 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfJAVl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:41:56 -0400
Received: by mail-qt1-f193.google.com with SMTP id j31so23645409qta.5;
        Tue, 01 Oct 2019 14:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dCGK32JDvXA2yj00yZHhKu501jn4soQW983UquahcWs=;
        b=EaAVSHgUIGh2Mk7dZnRNzfu+HlQryucOTaF2TcBEI8nr64mFjzpjHgIiHDyDSaVpJE
         0yVhW1PTAW7AoY312AqE2q2RjYlX4xWT4gy9uPIQWzSe3VVcq/a7mcsNzT8/DKz1S1Ph
         BQFWue6663UjLERt4Wl0a6cwD44AmJj5cJfLLLZEn5pTVsO1qYSdaY0W2UpbchZfHsxL
         K+OYgFd23p1U0jsTZbrjH8JM+UaLXWsP8aLNm/6JnV8u6g0lAHxw9uFRlEeWJGC5LgWK
         0Bvgse12vKm4XkRWCzaOWCyvWpL+ajFw9N8grDCjZngERiXt8NVlT9j4gQmX3EmgW4a8
         qISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dCGK32JDvXA2yj00yZHhKu501jn4soQW983UquahcWs=;
        b=NhDi2X/icYh23pnMawhBZaR1xwZnmf9pOBv42fcany6vtXW1HtunRJi2jiaUyGQOdM
         pzUl7t7FHfYZUjuTXJXNQPxu6FXDDxiJyfkp6GZR/vcrBad9tBxDOG1zl/1qAKlpYqjK
         eNjUh+pdyLFEcH2gWZ9rAzVQicdGJJaxcyVU47hFmSbok8ssO2CiZEYOxVsv0aNOPcLr
         YxjFPsXejWhKO9LzpZa6uXDJ6sRIjf4onPhvB+qnBTcHQGbbfRmIB3PJ3SbyC8xFCMQK
         4b/fdW4Hh35hHKYJXWXNVf3hsUPfS+W18FWHA2F/NHwhdGEP9xUkGT4lxOhY2MG6Cu5I
         DJ8g==
X-Gm-Message-State: APjAAAXg4lsc3Imp8sWlMOSHmf1LVmvNOSvIQs3vKb2q+w4GMJPUwBv4
        4b1MwJAXMqRig5nTll3HYbcprb5KlzY=
X-Google-Smtp-Source: APXvYqzOalIG3aemcA/pxsyEgX2V5YzGcFA39kbvsRze7kjU2d6wGj/KEqGE1w2ZilgwOk4GTFiPbw==
X-Received: by 2002:ac8:41c1:: with SMTP id o1mr491952qtm.341.1569966115146;
        Tue, 01 Oct 2019 14:41:55 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id v13sm8559352qtp.61.2019.10.01.14.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 14:41:54 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH V12 0/4] BPF: New helper to obtain namespace data from current task 
Date:   Tue,  1 Oct 2019 18:41:37 -0300
Message-Id: <20191001214141.6294-1-cneirabustos@gmail.com>
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

Changes from V11:

- helper: Input changed dev from u32 to u64.
- Moved self-test to test_progs.
- Remove unneeded maps in self-test.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

Carlos Neira (4):
  fs/nsfs.c: added ns_match
  bpf: added new helper bpf_get_ns_current_pid_tgid
  tools: Added bpf_get_ns_current_pid_tgid helper
  tools/testing/selftests/bpf: Add self-tests for new helper.

 fs/nsfs.c                                     |  8 ++
 include/linux/bpf.h                           |  1 +
 include/linux/proc_ns.h                       |  2 +
 include/uapi/linux/bpf.h                      | 18 +++-
 kernel/bpf/core.c                             |  1 +
 kernel/bpf/helpers.c                          | 36 ++++++++
 kernel/trace/bpf_trace.c                      |  2 +
 tools/include/uapi/linux/bpf.h                | 18 +++-
 tools/testing/selftests/bpf/bpf_helpers.h     |  3 +
 .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 85 +++++++++++++++++++
 .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 47 ++++++++++
 11 files changed, 219 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c

-- 
2.20.1

