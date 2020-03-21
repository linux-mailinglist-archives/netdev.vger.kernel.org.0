Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7564E18DF4D
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 11:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgCUKEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 06:04:45 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:52843 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgCUKEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 06:04:44 -0400
Received: by mail-pj1-f50.google.com with SMTP id ng8so3622525pjb.2;
        Sat, 21 Mar 2020 03:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n/6MPAQkaaC5d36+EjYYXIZ7yx1Ile+yTZuc6NoCprM=;
        b=c+s0RhMjRuShT/IFXaYCyUnyH4Z24ecTRdBDdqQacoEvdyo58hEj5+fely8i3s+pLW
         H0oIuzdQBD2NxD5W0lxl9AVkS+j2B4nT8w+zSPfi+Xmn7EARJmqpRIi0H1ltwTgsDwoG
         wxaPoLzGDft7ZU9C/HnsFt9b2p8zyoVTG9su24U5RbemGhzebOON8rahPeGHBF0ja9Zj
         XmyLTkhScx1Cx5VwTHkndkh1xIoZUnHj8au9KNefJylOTmYmnqw/J/Ina7/AUULL8MUH
         ejS2aOKzl+aeJ3DJRxUTCvP3gEWt3BMT7yVSYAcgoi4KhMkdUGBeVr/eQj9+Qn9xFNQO
         q/eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n/6MPAQkaaC5d36+EjYYXIZ7yx1Ile+yTZuc6NoCprM=;
        b=nhNCUmt9QfH+l/IhHaJtKoHrfmC3z/4D3mgOYXx/eAaL0yYi5rG9/M0gJB0FlN1fCh
         facvMwsfEFjEJDNaGCnh3/T/dmgiNTOb1fSnIN0dJ6KX5rIfprKhX1enkWfNzIv1e+ZK
         lKw8e2LQs6+wR3Byzval6kMoLWTsZOSAreQSbkZdJiuIXqTsXSavGdYCc096s9QEorLK
         km6jNDYBIy/LoKE7NWTUQy5WluxMpqfqL1MD18gGDbCoqSRSNZI6oiG83Ytwy5Hfb971
         cdpq5yVNywD6WAmYvvfA42yk8/ZPxJhUatUodBedQPLXEE37Ps8f/irEgPaeX5vllVl7
         KVKw==
X-Gm-Message-State: ANhLgQ3NNxxPAm9cd7un1ZF8YQ6DVLpf6dRHJttWVOUmOVSVX0AaN1tM
        HhcUOSJDKh7ZlJYqPkoSBQ==
X-Google-Smtp-Source: ADFU+vuiSRHJiJrmBBldgDBGgkOZvujTspuoJpWu2JXU2V3gvWBFY09Fbn7+KOFNR5kkKwKq6gPt8w==
X-Received: by 2002:a17:90a:1c8:: with SMTP id 8mr14748626pjd.132.1584785081687;
        Sat, 21 Mar 2020 03:04:41 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id f22sm3811384pgl.20.2020.03.21.03.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 03:04:41 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v5 0/2] Refactor perf_event sample user program with libbpf bpf_link
Date:   Sat, 21 Mar 2020 19:04:22 +0900
Message-Id: <20200321100424.1593964-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, some samples are using ioctl for enabling perf_event and
attaching BPF programs to this event. However, the bpf_program__attach
of libbpf(using bpf_link) is much more intuitive than the previous
method using ioctl.

bpf_program__attach_perf_event manages the enable of perf_event and
attach of BPF programs to it, so there's no neeed to do this
directly with ioctl.

In addition, bpf_link provides consistency in the use of API because it
allows disable (detach, destroy) for multiple events to be treated as
one bpf_link__destroy.

To refactor samples with using this libbpf API, the bpf_load in the
samples were removed and migrated to libbbpf. Because read_trace_pipe
is used in bpf_load, multiple samples cannot be migrated to libbpf,
this function was moved to trace_helpers.

Changes in v2:
 - check memory allocation is successful
 - clean up allocated memory on error

Changes in v3:
 - Improve pointer error check (IS_ERR())
 - change to calloc for easier destroy of bpf_link
 - remove perf_event fd list since bpf_link handles fd
 - use newer bpf_object__{open/load} API instead of bpf_prog_load
 - perf_event for _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF
 - sample specific chagnes...

Changes in v4:
 - bpf_link *, bpf_object * set NULL on init & err for easier destroy
 - close bpf object with bpf_object__close()

Changes in v5:
 - on error, return error code with exit

Daniel T. Lee (2):
  samples: bpf: move read_trace_pipe to trace_helpers
  samples: bpf: refactor perf_event user program with libbpf bpf_link

 samples/bpf/Makefile                        |   8 +-
 samples/bpf/bpf_load.c                      |  20 ---
 samples/bpf/bpf_load.h                      |   1 -
 samples/bpf/sampleip_user.c                 |  98 +++++++++-----
 samples/bpf/trace_event_user.c              | 139 +++++++++++++-------
 samples/bpf/tracex1_user.c                  |   1 +
 samples/bpf/tracex5_user.c                  |   1 +
 tools/testing/selftests/bpf/trace_helpers.c |  23 ++++
 tools/testing/selftests/bpf/trace_helpers.h |   1 +
 9 files changed, 187 insertions(+), 105 deletions(-)

-- 
2.25.1

