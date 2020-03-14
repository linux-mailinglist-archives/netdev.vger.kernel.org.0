Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121E818545F
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 04:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCNDpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 23:45:05 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:40587 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbgCNDpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 23:45:04 -0400
Received: by mail-pj1-f48.google.com with SMTP id bo3so3966357pjb.5;
        Fri, 13 Mar 2020 20:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pum9fXrSBpmShGY9Xd4dg9L1I2jPO6NseNNXX4dsJi8=;
        b=Ulcx30KFm1twSJgb62acPjdaO7u++dhWXjeDMnaAYyU/Z+xsFo8B2F+xr44xt4C5zl
         Bo5ra95gP/YQah6QjQ/GvFDjtHllRup4R7+of8oYDOs/uFqoyDWJXfa5Xnz2o4XsTWjU
         SuisW23bm1+h/UIiduF1/gISrAZT8Rjbpl2f9w3r5IQ8e5U/eVDoFhlQ2qk5PU7oHfhh
         JTYe9pQYHwJ4qIVzbwc9mOA8rvJFJXNbZXDBgHRsnTWjEtKZWVK+k3q3xTNIqV+feRKG
         rNe9Q67Nh83CRgCm1M9LaaDYha9zSaho0iAehdgGTkMkG6zzcVQhKYyvRHuc5BFKa0lw
         b2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pum9fXrSBpmShGY9Xd4dg9L1I2jPO6NseNNXX4dsJi8=;
        b=niN9+FeujJuI03vG12IoqeEkXrmysDYVNedLAGrGLTdyN+iNTNHcKAnMUaJb7Z/v8j
         2kCYEY7H3B6lRIiZ3p7UwB2O4JDyI+DDFyRHDlyw1qQPMpZCzTlH/hatNQu9AujJz6Ip
         DsA0hpMLjaH/GZYrNMBgMvZ2+clpPHQj4U8IzGje5KCEctj6dn13OPqRfZerS+RJIvvF
         3W4XdUQg/6PPcFy5U7Afvs27W/htCFYSgN9BgA1+dtXxPnHOQ8cDtwDETLPWfb/CCzJ4
         bPRu1TCfAXg2Kem7RcAlo0jJGwl/IQhWXuBtP+WIBjbZpMz5QrM3h/1SWFKo4AB+i46L
         58Ig==
X-Gm-Message-State: ANhLgQ1jhamokpwzDY77c+JEEla0gEBy77RxPwqq4lqcgZMp+UTWDyDf
        vQdYYCZWXVZtFHDri728kg==
X-Google-Smtp-Source: ADFU+vt1MJKS4ZfbqEa51IbRRz1GBnKJVJDUgTeTKl9p95AZ9CmBO4LV1Z9dlFvnIYZweLDslCIfcg==
X-Received: by 2002:a17:90a:bf0b:: with SMTP id c11mr13531798pjs.28.1584157502801;
        Fri, 13 Mar 2020 20:45:02 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id i21sm13526822pgn.5.2020.03.13.20.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 20:45:02 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 0/2] Refactor perf_event sample user program with libbpf bpf_link
Date:   Sat, 14 Mar 2020 12:44:54 +0900
Message-Id: <20200314034456.26847-1-danieltimlee@gmail.com>
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

Daniel T. Lee (2):
  samples: bpf: move read_trace_pipe to trace_helpers
  samples: bpf: refactor perf_event user program with libbpf bpf_link

 samples/bpf/Makefile                        |   8 +-
 samples/bpf/bpf_load.c                      |  20 ----
 samples/bpf/bpf_load.h                      |   1 -
 samples/bpf/sampleip_user.c                 |  98 +++++++++++------
 samples/bpf/trace_event_user.c              | 112 ++++++++++++++------
 samples/bpf/tracex1_user.c                  |   1 +
 samples/bpf/tracex5_user.c                  |   1 +
 tools/testing/selftests/bpf/trace_helpers.c |  23 ++++
 tools/testing/selftests/bpf/trace_helpers.h |   1 +
 9 files changed, 171 insertions(+), 94 deletions(-)

-- 
2.25.1

