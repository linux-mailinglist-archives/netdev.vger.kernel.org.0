Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E49D184637
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 12:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgCMLwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 07:52:46 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:53139 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgCMLwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 07:52:46 -0400
Received: by mail-pj1-f52.google.com with SMTP id f15so4042996pjq.2;
        Fri, 13 Mar 2020 04:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TUCicgYIc2oMmv7M1SM03HejGtN5KLm5jOrCLhI2rPI=;
        b=oOqQQl8xLk5TSxVixPC6dfmu2PYHJeQC7eYgkucmi90Rb9mi34pSuZl2GJQ/3auOfe
         qE6SRTdP+9Tu4Ydu+O3sWHjFGWhuxtCC6ss57rkH5S7KLd0sZvvL2ThA5+9NcKCRhT7r
         /Di8fZFPsK5GA+54GQVZufVFUKcwdTx1wORjO6FN8fbeaGMOEyRBP8aTxwApvPfM31dc
         PidbKybhKaFRBNAB0fdplTyW81ic2I/d+mK70r+cBfy94LVKvE6TLFwO3U2KfM8mnTd2
         8OxEDSggCcs7U1S/HeSOyrIMy3d2SGf5ccg5IE1ZiAsKr6XHxShZizulMZpYvAHSEBFo
         DILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TUCicgYIc2oMmv7M1SM03HejGtN5KLm5jOrCLhI2rPI=;
        b=TUAegqBmiLqg7a2WeqxaBaZyn+DRDv4IsOx527nHkY+T03pxUZR4JYqZgKpq6qcKMc
         WRi1j2zAXRqnZWIVn6YMlBbTguBujGp2y54/1/zmqKSSEFa4PgVH93IIiQGJRzFPMBar
         2TRhJ/tqymsmtO04SCyV/50UtqIyJ9e3usyiixXVJeL0LTCvq2aBF56xDST+YBAnv20L
         jRIjY412J/qn2JoNOLUAv3xPAxVxAbUvoSlkzuNL89DFsyeeKr7lPwEni6agUD6/acdf
         Im6o+JoRDyRlP8+sloytSupM0G6A8DNdiw9QMWJzoGlUmgSitsMOSkBFjpmLWi7jkN0r
         nnyQ==
X-Gm-Message-State: ANhLgQ3tLJFBzN57rseMwSt/pJdylXKEsp0ERZk3+joIeSou3oMepUj1
        L205+dA5NqA8szzQ5a43WQ==
X-Google-Smtp-Source: ADFU+vsdESDqQP02qqUCDMIW1a6K8iiz1h0UqgA1i8gZkeh6NRkqU5XfR7pVUMkawZNMr4ny3630vg==
X-Received: by 2002:a17:902:8502:: with SMTP id bj2mr10390887plb.72.1584100364827;
        Fri, 13 Mar 2020 04:52:44 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id r14sm2095151pjj.48.2020.03.13.04.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 04:52:44 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 0/2] Refactor perf_event sample user program with libbpf bpf_link
Date:   Fri, 13 Mar 2020 20:52:18 +0900
Message-Id: <20200313115220.29073-1-danieltimlee@gmail.com>
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

Daniel T. Lee (2):
  samples: bpf: move read_trace_pipe to trace_helpers
  samples: bpf: refactor perf_event user program with libbpf bpf_link

 samples/bpf/Makefile                        |   8 +-
 samples/bpf/bpf_load.c                      |  20 ----
 samples/bpf/bpf_load.h                      |   1 -
 samples/bpf/sampleip_user.c                 | 100 +++++++++++++-------
 samples/bpf/trace_event_user.c              |  89 ++++++++++++-----
 samples/bpf/tracex1_user.c                  |   1 +
 samples/bpf/tracex5_user.c                  |   1 +
 tools/testing/selftests/bpf/trace_helpers.c |  23 +++++
 tools/testing/selftests/bpf/trace_helpers.h |   1 +
 9 files changed, 159 insertions(+), 85 deletions(-)

-- 
2.25.1

