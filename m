Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250B11DDEB1
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 06:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgEVEXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 00:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgEVEXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 00:23:54 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AADC061A0E;
        Thu, 21 May 2020 21:23:54 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z64so101792pfb.1;
        Thu, 21 May 2020 21:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=VFVkn5SIewi4W+JsI73heYNt2jx78NTkR31h8FiEoto=;
        b=HvrQslqsbzT2BI7n+5FmF8haiLpDnBHvcocd5U76z2052+4l+sgns3zNPDPmW7QbBh
         /Eon2KOT575zS9VVV8VgkhaO5t+UnvYZ2S4Ks4r+J3zs5pZw5g6cb9K9RUj/yxta6wSn
         sE/Wn6lWY0J5jegkqu+NG826+KiFeQLSEK7ojGb+53YYMIFhfiTBeke8GBl/eayv5vRS
         OlUmkW7eBUt17ZDXcVyk81yWqo4FZ/LQNss/0RTcWuaICyTbPaQwYItdpxFcAvgkkkho
         NpIg6E0nV0gY7LfNcfUnlp/Tc/mEIgQ2BB3ALml49auk99X2Gq7XKxJTw2gv4pjbzDdP
         4oMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=VFVkn5SIewi4W+JsI73heYNt2jx78NTkR31h8FiEoto=;
        b=aLR5MDi/3l2wZCySGIBik+ZbXKkSPvs9GJJT/ttI6SzaYyDdlfOt7z3whJ+TWx/Ukp
         zKp7Zfb5Eieni5Ao7gN4aa76tHht4OrUzGA6M8gJ/xMC8TA1SHN65wu+5pLqztgVRqpG
         FtRxGhB0dsLKHJHAT76F14Aje5BpuxBsQdcJ8efEQVZDgVlzyOKpo+f+vZZ3OUp2HZVW
         To+pT+O6soyzF60nBW0v4wGS9VvtTQGNrVmy+BZi8ZXBJq4HQfEkFblbXehcUnVnOXmP
         P6Ws7xTyXXy/C+MV5r6VcLT9gQPIEg2Gm1w+GWrQn+HmsQNXtc1lr86ax2xtkXkMd50i
         Mx9g==
X-Gm-Message-State: AOAM5314oevt0OYYQKA9YOM0qDhJKe6DKNO/v3gZbBF4tw9wvdufUf5+
        TD0aEawLWP9886HRLarLO8o=
X-Google-Smtp-Source: ABdhPJwtseKCyiM7l7G7kYvcZRzieHe/oIuA7SOVPJur7ytHW6SmKW0LGn1r3VUAAQ9hez9LsXzGsQ==
X-Received: by 2002:a17:90a:6c96:: with SMTP id y22mr2305845pjj.74.1590121433551;
        Thu, 21 May 2020 21:23:53 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m14sm4949978pgk.56.2020.05.21.21.23.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 21:23:52 -0700 (PDT)
Subject: [bpf-next PATCH v4 0/5] bpf: Add sk_msg and networking helpers
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, jakub@cloudflare.com, lmb@cloudflare.com
Date:   Thu, 21 May 2020 21:23:36 -0700
Message-ID: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
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

v3->v4:
 patch4, remove macros and put code inline, add test cleanup, remove
 version in bpf program.
 patch5, use ctask returned from task_under_cgroup so that we avoid
 any potential compiler warnings, add test cleanup, use BTF style
 maps.
 
v2->v3:
 Pulled header update of tools sk_msg_md{} structure into patch3 for
 easier review. ACKs from Yonghong pushed into v3

v1->v2:
 Pulled generic helpers *current_task* and probe_* into the
 base func helper so they can be used more widely in networking scope.
 BPF capabilities patch is now in bpf-next so use perfmon_capable() check
 instead of CAP_SYS_ADMIN.

 Drop old probe helpers, probe_read() and probe_read_str()

 Added tests.

 Thanks to Daniel, Yonghong, and Andrii for review and feedback.

---

John Fastabend (5):
      bpf: sk_msg add some generic helpers that may be useful from sk_msg
      bpf: extend bpf_base_func_proto helpers with probe_* and *current_task*
      bpf: sk_msg add get socket storage helpers
      bpf: selftests, add sk_msg helpers load and attach test
      bpf: selftests, test probe_* helpers from SCHED_CLS


 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 +++++++++++++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   35 +++++++++++++++
 .../testing/selftests/bpf/progs/test_skb_helpers.c |   33 ++++++++++++++
 .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   47 ++++++++++++++++++++
 4 files changed, 145 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c

--
Signature
