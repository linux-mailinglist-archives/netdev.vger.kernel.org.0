Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D066D24996E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgHSJhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgHSJhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:37:45 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13720C061342
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:45 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r2so20826779wrs.8
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=trT56ug3tFTbYmD6Zav9ULw7qjw+yiWbjGkC3+1prJQ=;
        b=QnChpO8CyQ7DfhzJj/0sAcJ5EcEIouiDQuvMPRLsRMMPsoIQz+sUk8Yj1uwxtXvUlb
         4VHI6MBxP4CIEZm+7nQEaq61lQuM4Zt+V20SBz20sRiIv8Oyy/z6d9m2kW/bi0+7n2Me
         DEvFZC05tTJvseObbyuk2A7mHqOC0RmmpLUHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=trT56ug3tFTbYmD6Zav9ULw7qjw+yiWbjGkC3+1prJQ=;
        b=ROq3xIIMJoRi99dCl8WDZwboFy8wgUKzaX5C4nde6XtnXdh87EfM6MiPqe6XotDmsM
         gn363hZY8JMxTdVJrSNykQBmzwA5i+de3RpI36mbq2/i1JS5t1YHGmma1v3ACzHUEe9W
         4Y7PJr8MIKEBq4zKOT2v0HWi4A8adTaHtu2ko3fK94fYYSSdZbYM8Hj81Osznur0ypCq
         kuTsck9Oe/oH7UKHr96WmuFqp/GaIZzr8IXallhCwkmCYITiCPagiWo4AEJjc/baQQ2m
         z1MnAjcH+Y8CkTl3MKnmfsbp5zwfXSx+8UajRwJDb79MbFIJt382PgG+rRb9q4q0+Z9b
         USLg==
X-Gm-Message-State: AOAM530+RrjsmxJoxUluNVdX47BBvH7NwaHCOTII9SgGlD/ftL0MjaCZ
        +j/SoYvvD00/sW/2YDsBDdTz6A==
X-Google-Smtp-Source: ABdhPJxu8EDw9AhuzCpqnoLvDOUsQJXZ8cMHswQeGDq7gOGf99IaBQk99hLKYMwCzOkCZWP4sUu0yQ==
X-Received: by 2002:a5d:4281:: with SMTP id k1mr3246276wrq.30.1597829863602;
        Wed, 19 Aug 2020 02:37:43 -0700 (PDT)
Received: from antares.lan (c.d.0.4.4.2.3.3.e.9.1.6.6.d.0.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:60d6:619e:3324:40dc])
        by smtp.gmail.com with ESMTPSA id 3sm4204565wms.36.2020.08.19.02.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 02:37:43 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/6] Allow updating sockmap / sockhash from BPF
Date:   Wed, 19 Aug 2020 10:24:30 +0100
Message-Id: <20200819092436.58232-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're currently building a control plane for our BPF socket dispatch
work. As part of that, we have a need to create a copy of an existing
sockhash, to allow us to change the keys. I previously proposed allowing
privileged userspace to look up sockets, which doesn't work due to
security concerns (see [1]).

In follow up discussions during BPF office hours we identified bpf_iter
as a possible solution: instead of accessing sockets from user space
we can iterate the source sockhash, and insert the values into a new
map. Enabling this requires two pieces: the ability to iterate
sockmap and sockhash, as well as being able to call map_update_elem
from BPF.

This patch set implements the latter: it's now possible to update
sockmap from BPF context. As a next step, we can implement bpf_iter
for sockmap.

The patches are organised as follows:
* Patches 1-3 are cleanups and simplifications, to make reasoning
  about the subsequent patches easier.
* Patch 4 makes map_update_elem return a PTR_TO_SOCKET_OR_NULL for
  sockmap / sockhash lookups.
* Patch 5 enables map_update_elem from BPF. There is some locking
  here that I'm not entirely sure about. Feedback much appreciated.
* Patch 6 adds a selftest.

1: https://lore.kernel.org/bpf/20200310174711.7490-1-lmb@cloudflare.com/

Lorenz Bauer (6):
  net: sk_msg: simplify sk_psock initialization
  bpf: sockmap: merge sockmap and sockhash update functions
  bpf: sockmap: call sock_map_update_elem directly
  bpf: override the meaning of ARG_PTR_TO_MAP_VALUE for sockmap and
    sockhash
  bpf: sockmap: allow update from BPF
  selftests: bpf: test sockmap update from BPF

 include/linux/bpf.h                           |   7 +
 include/linux/skmsg.h                         |  17 ---
 kernel/bpf/syscall.c                          |   5 +-
 kernel/bpf/verifier.c                         |  46 +++++-
 net/core/skmsg.c                              |  34 ++++-
 net/core/sock_map.c                           | 137 ++++++++----------
 net/ipv4/tcp_bpf.c                            |  13 +-
 net/ipv4/udp_bpf.c                            |   9 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c  |  76 ++++++++++
 .../selftests/bpf/progs/test_sockmap_copy.c   |  48 ++++++
 10 files changed, 274 insertions(+), 118 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_copy.c

-- 
2.25.1

