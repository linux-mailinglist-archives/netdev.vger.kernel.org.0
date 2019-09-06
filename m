Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECCEABBD3
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfIFPKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:10:21 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:35228 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfIFPKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:10:20 -0400
Received: by mail-vs1-f68.google.com with SMTP id b11so4297105vsq.2;
        Fri, 06 Sep 2019 08:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=j1+lClJ6d8F+YNdDNXRwm8Dq6oGT8kFe2Xr4BcbGRn8=;
        b=Az1Z6p9rHHu2pKUbbTInepV3asBU4LkhmdjC6twvncaGJGCTB8EyOgFDyq8qG8QPPn
         IdL8M+NkGbdsBqXpynWEM48hgx6DQqwjcD+OzKX8ZS6f3jePABZLcGNrjw65H2/nXd0U
         8lVKdJVsuldJKt5CxWeix0pmA+sRJAYY81DnIaQxnMdeXtoQX5lYpy7RtH9GVPeV+2xX
         uPzcE4IW7HJmvKDiulfEEQEvn99ZWqMDOZ1t0k5CMRKhdwqsO8gXMS76N1uT+5d2UcAz
         p77tL2svfjMz//FoccUF+qK22os1oj+6TNsRvD/kFBGaPaVB8KZbOCtFPqi8FJ3j9KaB
         7ZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j1+lClJ6d8F+YNdDNXRwm8Dq6oGT8kFe2Xr4BcbGRn8=;
        b=tbLFeHNjrUEvJlbz+qNRa1pZ5x6aUqep/eZqxzwH+qjF8IZ8oJJeSmljakCvJaLmad
         qPAiDIHn1QkEpv64yOsXjYB7BxCqdemDvzXqRBKPAzj/8qe0hUmEzSov3M31MDibpgew
         UTVLG2G2Y4kR4nsjzAgwQsYJWckdCGslJ1OIcOK2gXw5Sl6wUsA1ILYq9B/2iEMVBRf4
         oqo+SZP2Orq33O3nNrhndQLerdWw8h6ZnSHRxRvnAax10QZ38B5yO58sdC/yvnR4Bttm
         wN5UFHiN198y7UZxcPX7hu+4UEngNU+j702yaYhv17CCdcj2XVz+I64U+ORI361SRBlm
         lcyw==
X-Gm-Message-State: APjAAAWfM42H2EBebu2QX3TOoL0c+6wb1Jr0bDxhb118WJwzp8JcC8GR
        O0fzK6TyZcuJemm3Sga9I54eUv42QyU=
X-Google-Smtp-Source: APXvYqyr9h/V6S3oBULItwMsxPmZ4X4wwTt2yyOHw729+jNLCbJGoRERzdUDX0ICkpD/vZsxHYoXhQ==
X-Received: by 2002:a67:2e96:: with SMTP id u144mr5314743vsu.46.1567782618935;
        Fri, 06 Sep 2019 08:10:18 -0700 (PDT)
Received: from localhost.localdomain ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id o15sm4833822vkc.38.2019.09.06.08.10.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:10:18 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        cneirabustos@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v10 0/4] BPF: New helper to obtain namespace data  from current task
Date:   Fri,  6 Sep 2019 11:09:48 -0400
Message-Id: <20190906150952.23066-1-cneirabustos@gmail.com>
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

Changes from v9 :
Removed samples/bpf in favor of tools/testing/selftests/bpf
Fixed bug when bpf helper is called in an interrupt context.
Code style fixes.
Added more comments on bpf helper struct member.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

Carlos Neira (4):
  fs/namei.c: make available filename_lookup() for bpf helpers.
  bpf: new helper to obtain namespace data from  current task New bpf
    helper bpf_get_current_pidns_info.
  tools: Added bpf_get_current_pidns_info  helper.
  tools/testing/selftests/bpf: Add self-tests  for helper
    bpf_get_pidns_info.

 fs/internal.h                                      |   2 -
 fs/namei.c                                         |   1 -
 include/linux/bpf.h                                |   1 +
 include/linux/namei.h                              |   4 +
 include/uapi/linux/bpf.h                           |  35 ++++-
 kernel/bpf/core.c                                  |   1 +
 kernel/bpf/helpers.c                               |  86 ++++++++++++
 kernel/trace/bpf_trace.c                           |   2 +
 tools/include/uapi/linux/bpf.h                     |  35 ++++-
 tools/testing/selftests/bpf/Makefile               |   2 +-
 tools/testing/selftests/bpf/bpf_helpers.h          |   3 +
 .../testing/selftests/bpf/progs/test_pidns_kern.c  |  52 ++++++++
 .../selftests/bpf/progs/test_pidns_nmi_kern.c      |  52 ++++++++
 tools/testing/selftests/bpf/test_pidns.c           | 146 +++++++++++++++++++++
 tools/testing/selftests/bpf/test_pidns_nmi.c       | 139 ++++++++++++++++++++
 15 files changed, 555 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_nmi_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_pidns.c
 create mode 100644 tools/testing/selftests/bpf/test_pidns_nmi.c

-- 
2.11.0

