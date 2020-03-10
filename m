Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C346F17F03C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 06:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgCJFwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 01:52:07 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:46060 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJFwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 01:52:07 -0400
Received: by mail-pf1-f171.google.com with SMTP id 2so5953674pfg.12;
        Mon, 09 Mar 2020 22:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HNOG8CrlKL3slTLrSPZnUR+cDqJrNnsigdC65Wb4CVI=;
        b=fTnAIgcfivbWfRMxXEnvd7CBNdG+Mof0LLG7vmI2Eq0y+28YurIiddeDncYiVlLGR7
         t32NieyiSMoFF0aHVKqn5WA+ohpE/uLYfIH7AmwhEhaa3sJZmD13/5ORd5D0AJHsFC6s
         FyuuQGqEelf4+9ErkB9hAIWkuRRzJhUznPETxtvs4I87m9GcD01LBupv3qhi02+qzUz5
         isia/orp1XX2bBvc4b0Q1dyi1bQvaEXf5P2CA4UZXGuYdThOg20Cwp0r8oXuDPsGYHll
         dGLeGK86Z+uFCmKIWCtZ+g3FWd4a706ZbYImd/qo0t29aPKqB92pcwlFetCrLPuKJ3wL
         tc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HNOG8CrlKL3slTLrSPZnUR+cDqJrNnsigdC65Wb4CVI=;
        b=nl7klxL2bCN0FMCUh8UMTbTl+XkXA42wliu12CyFXjOXqbcxmAV9b4L6E+Uk3NxvqM
         lo+xIJLv6KTjbQuvZVVy2ddfH9ZpVAp2BXdx3JAIpxdn6y47SeAgc0fiThNHDfOZ30xU
         3Sc64TEdhUGgC58+8YQhjiVXFma4jaCLfKEj1b+ZrPmgCMmwXcJAQa4x1tIRVeFkf8YN
         OaG0vjwPOI+jPP02RJm8hhVgiAyXBazK7TLkd5lw3EmfLKe7ePRpP2Y0GKda1TdgljFX
         tbcIfP+soO3iM0u0d/dKCKemzCj+fxJHc4yF1eUPAnBG9rhtco8WEgnnHNVkN+SIDIbO
         M2uA==
X-Gm-Message-State: ANhLgQ3IHUcUfrgptVTinW64EoE6WKKmjUTYFioh1XuMdK8zdKjmwMie
        lTfQ+r+Gw8sgkKV/XtDeeg==
X-Google-Smtp-Source: ADFU+vuQzYNfI7kU8bd+27wNqICyC2qunS2YQoMbGNcbOfrvxVFP2hQDQozzgBcvam6s0bpglLL3EA==
X-Received: by 2002:a63:2447:: with SMTP id k68mr19205448pgk.368.1583819525828;
        Mon, 09 Mar 2020 22:52:05 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id c17sm5018980pfn.187.2020.03.09.22.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 22:52:05 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/2] samples: bpf: refactor perf_event user program with libbpf bpf_link
Date:   Tue, 10 Mar 2020 14:51:45 +0900
Message-Id: <20200310055147.26678-1-danieltimlee@gmail.com>
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

Daniel T. Lee (2):
  samples: bpf: move read_trace_pipe to trace_helpers
  samples: bpf: refactor perf_event user program with libbpf bpf_link

 samples/bpf/Makefile                        |  8 +--
 samples/bpf/bpf_load.c                      | 20 -------
 samples/bpf/bpf_load.h                      |  1 -
 samples/bpf/sampleip_user.c                 | 58 +++++++++++++--------
 samples/bpf/trace_event_user.c              | 57 +++++++++++++-------
 samples/bpf/tracex1_user.c                  |  1 +
 samples/bpf/tracex5_user.c                  |  1 +
 tools/testing/selftests/bpf/trace_helpers.c | 23 ++++++++
 tools/testing/selftests/bpf/trace_helpers.h |  1 +
 9 files changed, 106 insertions(+), 64 deletions(-)

-- 
2.25.1

