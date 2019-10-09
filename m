Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 266D1D1267
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbfJIP0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:26:46 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36103 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbfJIP0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:26:45 -0400
Received: by mail-qt1-f196.google.com with SMTP id o12so4011427qtf.3;
        Wed, 09 Oct 2019 08:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kDwcl4Lkv9JkHR9gMfp83O8Dx8hy5uoIlzYh+nEtcG8=;
        b=IqbeX11uxCsObiw72IgyRkpU6Qf0HLRpPVzCKjZ09Af8sEJDWiYKuuBHp01KN4OmAJ
         h+JubKXcnRM2BtqBoCIGyrXHwzLeMrhJ0nv2SDsuifUtmLmt5S7n3r+1ZBsKUdcjt659
         HKezz4Qt1607eulUmkk1Sbe+NJXMOxh25DS6d2LvDlbV0+MgI1zBcx0jOpsYsSAPLZCP
         wIi+jJVFLaJLAkS6X9M68S2Q6cCbQ7rNY/Q4Ni7Pz1x/uhXxXfQ4ZLXdrNHWFm/u7SJZ
         3zzM5N9fliCul6uUgpNe8RUCq1RwxAIScNrjpUi40DGfC/c80lNRglysoQOgPclByPju
         cTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kDwcl4Lkv9JkHR9gMfp83O8Dx8hy5uoIlzYh+nEtcG8=;
        b=WcnL/2/Ax02sZccPuL7KSwimsFL07BXXbX4eSdBwAsIYivxvkbAugl6VqsKc4qkPUG
         ZR2fpjPtT1UCwOaX+zURHhUI7abEkxVsVhFIEybvhXsjhirLJvX6Ceh9k2l4DDO6Q3gk
         Bggu+Pd7jdqTfsOxqytiVUIRU9j/ojhoqPsWynt/ZmKft3n/xT29DGuok3zvKkXRTWBW
         hiCznrofFV305GFWmYTcxNTZCaJoj9eC7TGfuOs2okLa+RV/ZUaEnJOPNX0xjjlu1QVl
         +wcvCxPKOTJJSvuu58txg5knECHo/GBzIL9x3gBbVQGyYzt0ylCtDaXMNFYfW60Nnx6W
         GEdQ==
X-Gm-Message-State: APjAAAWUJsJe2SU+T/451oUYq38cefGKqOgr14Po+Lt3bvene/O3m/M3
        wpzhZp+jeS3FLp/nSYb1i4JzDsippjs=
X-Google-Smtp-Source: APXvYqwo3pFNJ7u9MOXB+SmDTHcMGtGcHfp10ZN6mv+GKul2UZYzQ9h1DRt4h7P5zwmHme7CrsOCOw==
X-Received: by 2002:ac8:71d7:: with SMTP id i23mr4177379qtp.195.1570634802913;
        Wed, 09 Oct 2019 08:26:42 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id l189sm1049895qke.69.2019.10.09.08.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 08:26:42 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v13 0/4] BPF: New helper to obtain namespace data from current task
Date:   Wed,  9 Oct 2019 12:26:28 -0300
Message-Id: <20191009152632.14218-1-cneirabustos@gmail.com>
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
  tools/testing/selftests/bpf: Add self-tests for new helper.

 fs/nsfs.c                                     |  8 ++
 include/linux/bpf.h                           |  1 +
 include/linux/proc_ns.h                       |  2 +
 include/uapi/linux/bpf.h                      | 22 ++++-
 kernel/bpf/core.c                             |  1 +
 kernel/bpf/helpers.c                          | 43 ++++++++++
 kernel/trace/bpf_trace.c                      |  2 +
 tools/include/uapi/linux/bpf.h                | 22 ++++-
 tools/testing/selftests/bpf/bpf_helpers.h     |  4 +
 .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 85 +++++++++++++++++++
 .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 53 ++++++++++++
 11 files changed, 241 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c

-- 
2.20.1

