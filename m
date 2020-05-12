Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C727A1CF785
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgELOns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgELOns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:43:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F97C061A0C;
        Tue, 12 May 2020 07:43:48 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f15so5473151plr.3;
        Tue, 12 May 2020 07:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h5SOPt162A+vSGY3/tPfI416v2PY2Wt7PMq/wfI5rjA=;
        b=RzaynAwckzN9abfqahTRAGy4L4CETcw7nLgi/1y/IUe7M0TrapFRkgfnTGiIviIDYX
         cy+/hDjju1eAHIweqWo52znovPyCWDqqseLAkwajgVY06SPjv7fcwYkiNNsBhvsE/KO0
         l3VmKKRDAAk0rq+aiCpbbostG7Smo0ytcZJeMlTwXH4aBlspn34BGpcPRUiex8YnNphZ
         1F1CNR/gHwtes13nRQnjWfMu5o7VcaEM0/ma4vwH9r2P1g9dXu7y5qNpNJHPCvF+CypC
         Z94zQZQS664KjhU7epqJ3ukPZq6oCFTWOEMFjcu0rJRN/K9twIBlh2vx39U4OMfk0KKD
         zYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h5SOPt162A+vSGY3/tPfI416v2PY2Wt7PMq/wfI5rjA=;
        b=Wq18vK+Y6rK+5frjQhulLSZeb/N4Pf8xHOqfysiVnRyozdbRYHg0EyIskH71SCw9mq
         0F0yWQM2IyLySthAtgDBQXMbcHpysDnXopDOSYlV0UQOQsdpkcWBWQzW4oPqqxz1yP+8
         hRSoIe52tcyT3lSd6zicAbsN3muzISDR1JH0sCEM5DBNAl90xkKF+f90oaEAwtqVE2v5
         csSRTIXMvFx4TY9zOa5VMsJuSm0ioTmXY9zcs5cFWnER3UJuCCVMWNGUJwre9kXmuaY5
         B3MDFQTZ6XqSf8VGztiYgzafW+UA3vohviP5KmO9FHkXgVuQFo9NpVvLEoSqzrQQVz+4
         PMJg==
X-Gm-Message-State: AGi0PuYBm8ivFyFV+2VjiHTkrSwYvxdp35bpkRhFB143P4P34ZWkhcF7
        /c1YDOfW4z9RiLKF9V3JBw==
X-Google-Smtp-Source: APiQypKYvo4gr77rCx+YdTxOCKR7BLNd9eKk3KpoP7jFWzsCVja13o+reFioMaTyrxC/m6hK58LnXg==
X-Received: by 2002:a17:90a:280c:: with SMTP id e12mr30069508pjd.52.1589294627527;
        Tue, 12 May 2020 07:43:47 -0700 (PDT)
Received: from localhost.localdomain ([219.255.158.173])
        by smtp.gmail.com with ESMTPSA id w11sm10786581pgj.4.2020.05.12.07.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 07:43:47 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next 0/3] samples: bpf: refactor kprobe tracing progs with libbpf
Date:   Tue, 12 May 2020 23:43:36 +0900
Message-Id: <20200512144339.1617069-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the kprobe BPF program attachment method for bpf_load is
pretty outdated. The implementation of bpf_load "directly" controls and
manages(create, delete) the kprobe events of DEBUGFS. On the other hand,
using using the libbpf automatically manages the kprobe event.
(under bpf_link interface)

This patchset refactors kprobe tracing programs with using libbpf API
for loading bpf program instead of previous bpf_load implementation.

Daniel T. Lee (3):
  samples: bpf: refactor kprobe tracing user progs with libbpf
  samples: bpf: refactor tail call user progs with libbpf
  samples: bpf: refactor kprobe, tail call kern progs map definition

 samples/bpf/Makefile           | 16 ++++----
 samples/bpf/sampleip_kern.c    | 12 +++---
 samples/bpf/sockex3_kern.c     | 36 ++++++++---------
 samples/bpf/sockex3_user.c     | 66 ++++++++++++++++++++++----------
 samples/bpf/trace_event_kern.c | 24 ++++++------
 samples/bpf/tracex1_user.c     | 41 ++++++++++++++++----
 samples/bpf/tracex2_kern.c     | 32 +++++++++-------
 samples/bpf/tracex2_user.c     | 55 +++++++++++++++++++++-----
 samples/bpf/tracex3_kern.c     | 24 ++++++------
 samples/bpf/tracex3_user.c     | 65 +++++++++++++++++++++++--------
 samples/bpf/tracex4_kern.c     | 12 +++---
 samples/bpf/tracex4_user.c     | 55 ++++++++++++++++++++------
 samples/bpf/tracex5_kern.c     | 14 +++----
 samples/bpf/tracex5_user.c     | 70 ++++++++++++++++++++++++++++++----
 samples/bpf/tracex6_kern.c     | 38 +++++++++---------
 samples/bpf/tracex6_user.c     | 53 ++++++++++++++++++++++---
 samples/bpf/tracex7_user.c     | 43 +++++++++++++++++----
 17 files changed, 471 insertions(+), 185 deletions(-)

-- 
2.25.1

