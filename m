Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0261DCFE1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgEUOer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbgEUOeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 10:34:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F60C061A0E;
        Thu, 21 May 2020 07:34:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ci21so3169502pjb.3;
        Thu, 21 May 2020 07:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=5ZpUv7MfgCNh7zyXR9h36N09eqf77f6DqEeSGESFofw=;
        b=SNdOaQZsJdosjS1dbuBenXGQmIHlq7418v3x6QF72J4m105M55yLtSQa1RBY2A0GBP
         RXzZMJruQMmU9FrSMvoa+c6IfO1ERSeuRgDJXBmo8AJzPPE1bFZJH6Ab3HXQHkmdJkJT
         /inwRDRjHKiFZNF/EqIbdvtUpnjJfw1TP0bdfQ80GnwMmG0qoTfrpvuRorn2ZO8xKGmF
         1h1+pzSc+GibEn29WVmKVp+21alFYF/GoAp7I8EwG3vTRuyH4DKjNOGENOjIuf79vw2q
         CJwn+ccn/mfG4UycmXd+h8fsdlIVi/Ee1MlV6eFazE8ckAdbMmNBUKx62tOsrLLd2xsJ
         53iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=5ZpUv7MfgCNh7zyXR9h36N09eqf77f6DqEeSGESFofw=;
        b=B7nq5VxGAEv7arXzJyZgo1SA4tJkmMt2YNyPO08owkP5nz/d1283U2jMwdhpWCBD/A
         zkOrK21Rmc/PSjB9N1zy4IjpqSVDdV5LaGolic+hiEr54Ui+41YdKRDTZ0KAaIhc6i//
         63Yx2g/ENHu1B+bWT+iZuzESLGkp5cMvh+QuXQzMVa2SyjdEI3OlAiYaqnWYRCso+qid
         PjAmNThJVUWssK31Tny6SxS7oR6Bq4umORB526hZP3R8cdQNpFRgVz1LvDSiTbsE9IRS
         MScOJEFe84jrgPV5yordjgb0Ymz8H+2hMZBrYjk41/chmEKcu2kZF0WAVZroQxjnMiCU
         6xtg==
X-Gm-Message-State: AOAM533DnIUN4BH3cm30iYkxw7ArKhNHpXI7UCNdbdepoCBRefVCGG+r
        rAjhaXkNSdxUYS7gnuxe5Vs9eXxw
X-Google-Smtp-Source: ABdhPJx37f4lFlw8coJXQwpef46Rqz7QbO1CKwxPl5CX46PCoCyhK9kHvRUYyOzPftTvBxnJPMQGPQ==
X-Received: by 2002:a17:90a:950d:: with SMTP id t13mr12412566pjo.102.1590071686369;
        Thu, 21 May 2020 07:34:46 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c63sm4619724pfc.2.2020.05.21.07.34.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 07:34:45 -0700 (PDT)
Subject: [bpf-next PATCH v3 0/5] bpf: Add sk_msg and networking helpers
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Thu, 21 May 2020 07:34:30 -0700
Message-ID: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds helpers for sk_msg program type and based on feedback
from v1 adds *_task_* helpers and probe_* helpers to all networking
programs with perfmon_capable() capabilities.

The list of helpers breaks down as follows,

Networking with perfmon_capable() guard (patch2):

 BPF_FUNC_get_current_task
 BPF_FUNC_current_task_under_cgroup
 BPF_FUNC_probe_read_user
 BPF_FUNC_probe_read_kernel
 BPF_FUNC_probe_read_user_str
 BPF_FUNC_probe_read_kernel_str

Added to sk_msg program types (patch1,3):

 BPF_FUNC_perf_event_output
 BPF_FUNC_get_current_uid_gid
 BPF_FUNC_get_current_pid_tgid
 BPF_FUNC_get_current_cgroup_id
 BPF_FUNC_get_current_ancestor_cgroup_id
 BPF_FUNC_get_cgroup_classid

 BPF_FUNC_sk_storage_get
 BPF_FUNC_sk_storage_delete

For testing we create two tests. One specifically for the sk_msg
program types which encodes a common pattern we use to test verifier
logic now and as the verifier evolves.

Next we have skb classifier test. This uses the test run infra to
run a test which uses the get_current_task, current_task_under_cgroup,
probe_read_kernel, and probe_reak_kernel_str.

Note we dropped the old probe_read variants probe_read() and
probe_read_str() in v2.

v2->v3:
 Pulled header update of tools sk_msg_md{} structure into patch3 for
 easier review. ACKs from Yonghong pushed into v3

v1->v2:
 Pulled generic helpers *current_task* and probe_* into the
 base func helper so they can be used more widely in netowrking scope.

 BPF capabilities patch is now in bpf-next so use perfmon_capable() check
 instead of CAP_SYS_ADMIN.

 Drop old probe helpers, probe_read() and probe_read_str()

 Added tests.

 Thanks to Daniel and Yonghong for review and feedback.

---

John Fastabend (5):
      bpf: sk_msg add some generic helpers that may be useful from sk_msg
      bpf: extend bpf_base_func_proto helpers with probe_* and *current_task*
      bpf: sk_msg add get socket storage helpers
      bpf: selftests, add sk_msg helpers load and attach test
      bpf: selftests, test probe_* helpers from SCHED_CLS


 include/uapi/linux/bpf.h                           |    2 +
 kernel/bpf/helpers.c                               |   27 +++++++++
 kernel/trace/bpf_trace.c                           |   16 +++---
 net/core/filter.c                                  |   31 +++++++++++
 tools/include/uapi/linux/bpf.h                     |    2 +
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 +++++++++++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   57 ++++++++++++++++++++
 .../testing/selftests/bpf/progs/test_skb_helpers.c |   33 ++++++++++++
 .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   48 +++++++++++++++++
 9 files changed, 238 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c

--
Signature
