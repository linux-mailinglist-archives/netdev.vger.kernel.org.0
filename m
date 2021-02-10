Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9966316643
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhBJMNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhBJMKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:10:30 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4145C061224
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:04:37 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id t142so1622095wmt.1
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+9PeUG6v1r8aFGi6ORK3pCJUjeurz7TuWVSE9CMni0c=;
        b=vefKpoHHE9JY7wsXqdCVcvzKivbYRTXzF+0dgJaRh4tzwGHJlFAPcT6iyCPjtVk/QO
         2nbSc5689PqMRWiH0mYBu5uUXuBmmxhvZbfVsxAu4AYbT9KkUXLQ8GUARAWnmp4QnaYC
         qrzOL4EoDzuwTZWyGC0rpjwwcObKmnDgs1a7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+9PeUG6v1r8aFGi6ORK3pCJUjeurz7TuWVSE9CMni0c=;
        b=NYXRq1+Oxci1hXdoL+BJLL+3kDqpTXYLJvITewAjNx6clhoY81Okj6+wtMbdqS36BW
         8rvWF0qRgfKs8kSJGf2dlv1ON4A75avVIP9IZ6pH93Nb2UmmOI//wOw1ssjVymzEEgbu
         xidpcdcasfv4AenTe7qZVhR395kxIZ3eKEggvtOtz92cFMqV/2UDkWvQUpDvQMmUGBPT
         wAmOVhb4zD+snlXOfkA5D8xZfURrY4gLsSkdvRexb8BtnVkqFwVfrsGSqpa5cxmVr/d2
         8Yw9I+a0HpcY3yao7VT0Tb0yEV/W7TVNbC6OuR8xbFjPxmcww0IBd+SGP0TzZPHpZgX0
         gnRg==
X-Gm-Message-State: AOAM531MUILYl1hiZ596Z8rIJ3awdq6TpDeERMG5mR6TfvPHM3Z6dNEd
        LRNBDrr/FphujfBf7L8qI1eatQ==
X-Google-Smtp-Source: ABdhPJwpmZw+y59+QzJHB79z4KhJzeSBdFZ5h0S1sHnxAqBTLAPp1GIONJS8JzIW2wEz2gPnFzl8PA==
X-Received: by 2002:a1c:9851:: with SMTP id a78mr2600203wme.66.1612958676276;
        Wed, 10 Feb 2021 04:04:36 -0800 (PST)
Received: from antares.lan (c.3.c.9.d.d.c.e.0.a.6.8.a.9.e.c.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:ce9a:86a0:ecdd:9c3c])
        by smtp.gmail.com with ESMTPSA id j7sm2837854wrp.72.2021.02.10.04.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 04:04:35 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        bpf@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: [PATCH bpf 0/4] Expose network namespace cookies to user space
Date:   Wed, 10 Feb 2021 12:04:21 +0000
Message-Id: <20210210120425.53438-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're working on a user space control plane for the BPF sk_lookup
hook [1]. The hook attaches to a network namespace and allows
control over which socket receives a new connection / packet.

Roughly, applications can give a socket to our user space component
to participate in custom bind semantics. This creates an edge case
where  an application can provide us with a socket that lives in
a different network namespace than our BPF sk_lookup program.
We'd like to return an error in this case.

Additionally, we have some user space state that is tied to the
network namespace. We currently use the inode of the nsfs entry
in a directory name, but this is suffers from inode reuse.

I'm proposing to fix both of these issues by adding a new
SO_NETNS_COOKIE socket option as well as a NS_GET_COOKIE ioctl.
Using these we get a stable, unique identifier for a network
namespace and check whether a socket belongs to the "correct"
namespace.

NS_GET_COOKIE could be renamed to NS_GET_NET_COOKIE. I kept the
name generic because it seems like other namespace types could
benefit from a cookie as well.

I'm trying to land this via the bpf tree since this is where the
netns cookie originated, please let me know if this isn't
appropriate.

1: https://www.kernel.org/doc/html/latest/bpf/prog_sk_lookup.html

Cc: bpf@vger.kernel.org
Cc: linux-alpha@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: sparclinux@vger.kernel.org

Lorenz Bauer (4):
  net: add SO_NETNS_COOKIE socket option
  nsfs: add an ioctl to discover the network namespace cookie
  tools/testing: add test for NS_GET_COOKIE
  tools/testing: add a selftest for SO_NETNS_COOKIE

 arch/alpha/include/uapi/asm/socket.h          |  2 +
 arch/mips/include/uapi/asm/socket.h           |  2 +
 arch/parisc/include/uapi/asm/socket.h         |  2 +
 arch/sparc/include/uapi/asm/socket.h          |  2 +
 fs/nsfs.c                                     |  9 +++
 include/linux/sock_diag.h                     | 20 ++++++
 include/net/net_namespace.h                   | 11 ++++
 include/uapi/asm-generic/socket.h             |  2 +
 include/uapi/linux/nsfs.h                     |  2 +
 net/core/filter.c                             |  9 ++-
 net/core/sock.c                               |  7 +++
 tools/testing/selftests/net/.gitignore        |  1 +
 tools/testing/selftests/net/Makefile          |  2 +-
 tools/testing/selftests/net/so_netns_cookie.c | 61 +++++++++++++++++++
 tools/testing/selftests/nsfs/.gitignore       |  1 +
 tools/testing/selftests/nsfs/Makefile         |  2 +-
 tools/testing/selftests/nsfs/netns.c          | 57 +++++++++++++++++
 17 files changed, 185 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/net/so_netns_cookie.c
 create mode 100644 tools/testing/selftests/nsfs/netns.c

-- 
2.27.0

