Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6C41E4B70
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbgE0RIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729874AbgE0RIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:08:43 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADB5C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:43 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g9so20853803edr.8
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BvxUJDbNOsAZlToM2jJEfVIYO7mDxGmh77dG3uN0sj0=;
        b=GxzhBElsUI5no+0JQySSTVbHZ1ZtbrCWEzKaty+lfHH72HvhCOIh9WDNCqkYNYU5bh
         KSAdNIvOCRXBeYC2kgaxmUnMAP5Rt+F8Bdtte7dfCs4CjTmLtXQOlGjO0gmDTryaGEpA
         bNVmdOe30DpIo7RjudTxeDy4bk5T8efy2XSsg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BvxUJDbNOsAZlToM2jJEfVIYO7mDxGmh77dG3uN0sj0=;
        b=bGWXmhJN5K3FRDEyQ2Obx7ZVN+WZb+mkGkKKgHyCscXByp8vu2WHyB5t0wkzAId0fP
         xLXSs+gH/eywSE0o/GRTR5faG+gUHBZ1kA/hHNhcKwY66JwYMsVI7YZfxGK/VOrCWC7L
         eNL0S5sLHeCQC9BZScZW9W3WQeoLEpeKEU2ahB5Md1puEVsgHBX8AlfXG8P2gFtAFE1Q
         2azTcl+sQe+Ho21AD3U4c3VizlknS8Rxdjn9TrFzqEAqbKvMEErT9ng8IxTaAf6ndYqc
         fjhXxyILDacJeLe02uZStNtRoN9RHkWzKCD565Y9b9VdJMOb4FqA0GWIXx/vGbeHWKiK
         Kl5w==
X-Gm-Message-State: AOAM530Qi6weQ2gkii6v1uEJ7L3zq/y4ebVYBueTH+dRXWZgunq0+68s
        OP6i0T0jNd+pZeiGsGqALuat0Q==
X-Google-Smtp-Source: ABdhPJxdf4iHoxKAQLLiFs6Co3wVOPISk7z4AW/K3qjwBUsrfp/GfehQh5Mw2+4G6jNdkutSdb0OEw==
X-Received: by 2002:a05:6402:1d2d:: with SMTP id dh13mr23929481edb.169.1590599321745;
        Wed, 27 May 2020 10:08:41 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h19sm3166920ejb.66.2020.05.27.10.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 10:08:41 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next 0/8] Link-based program attachment to network namespaces
Date:   Wed, 27 May 2020 19:08:32 +0200
Message-Id: <20200527170840.1768178-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the pieces of feedback from recent review of BPF hooks for socket
lookup [0] was that new program types should use bpf_link-based attachment.

Unlike with cgroups-attached programs, there is no existing infrastructure
for using bpf_links with network namespaces. It is also not as simple as
updating a single bpf_prog pointer, like in case of direct program
attachment.

Due to that I've split out this work into its own series.

Series is organized as so:

Patches 1-4 prepare a space in struct net to keep state for attached BPF
programs, and massage the code in flow_dissector to make it attach type
agnostic to finally move under kernel/bpf/.

Patch 5, the most important one, introduces new bpf_link link type for
attaching to network namespace. As opposed to cgroups, we can't hold a
ref count on struct net from a bpf_link, so we get by with just RCU
protection.

I'd be grateful if someone more experienced using RCU could give this
patch a look. It is not exactly the textbook application of it.

Patches 6-8 make libbpf and bpftool aware of the new link type and add
tests to check that link create/update/query API works as intended.

Thanks to Lorenz and Marek for early feedback & reviews.

-jkbs

Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Marek Majkowski <marek@cloudflare.com>
Cc: Stanislav Fomichev <sdf@google.com>

[0] https://lore.kernel.org/bpf/20200511185218.1422406-1-jakub@cloudflare.com/

Jakub Sitnicki (8):
  flow_dissector: Don't grab update-side lock on prog detach from
    pre_exit
  flow_dissector: Pull locking up from prog attach callback
  net: Introduce netns_bpf for BPF programs attached to netns
  flow_dissector: Move out netns_bpf prog callbacks
  bpf: Add link-based BPF program attachment to network namespace
  libbpf: Add support for bpf_link-based netns attachment
  bpftool: Support link show for netns-attached links
  selftests/bpf: Add tests for attaching bpf_link to netns

 include/linux/bpf-netns.h                     |  64 +++
 include/linux/skbuff.h                        |  26 -
 include/net/flow_dissector.h                  |   6 +
 include/net/net_namespace.h                   |   4 +-
 include/net/netns/bpf.h                       |  18 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/net_namespace.c                    | 387 ++++++++++++++
 kernel/bpf/syscall.c                          |  10 +-
 net/core/filter.c                             |   1 +
 net/core/flow_dissector.c                     | 124 +----
 tools/bpf/bpftool/link.c                      |  19 +
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/lib/bpf/libbpf.c                        |  20 +-
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../bpf/prog_tests/flow_dissector_reattach.c  | 500 +++++++++++++++++-
 17 files changed, 1026 insertions(+), 167 deletions(-)
 create mode 100644 include/linux/bpf-netns.h
 create mode 100644 include/net/netns/bpf.h
 create mode 100644 kernel/bpf/net_namespace.c

-- 
2.25.4

