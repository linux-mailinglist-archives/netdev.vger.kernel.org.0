Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EEF31F6D1
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhBSJxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhBSJxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:53:09 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD89C061756
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 01:52:13 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v14so7285936wro.7
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 01:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tFX8aTWhVTIHjfxR53xhrBobFiM0bUDGhWKmsxZ7XHw=;
        b=ZATd1pytikLgXuZ/FsyZ2A8JTf5NObvV8YL5Z2kmrTMVkTR+TNopFPYw9AjyGbLZCB
         WGFQQA0+cBeaZRfW7CsMVWlmILb82WvGfc4gVLKe9yQwCzimkK7AxG9qetRH5b/ppMdi
         bmeMTgPEjcgsDl9dRjhkLP24W3vqu9Fg6YCxA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tFX8aTWhVTIHjfxR53xhrBobFiM0bUDGhWKmsxZ7XHw=;
        b=R2C+yN6YuUKc+WsNCHbuuOlDS95WtUqK+LbGwgRqlsvRJo/W/cR3R4CeVd8XZaoUFq
         6fW+iHo2q5IFg7Zzcq8GkdtB0LNUVmVQm8nU3Te26kTqcNMz9Df8Hayxx8bDfCDLgfjd
         4/LZPuAOm59b5w0r3W5OIDDbNQKZqUlC5/YTzIZpE4Bnj43dO5G/4zGr4q8F+Aak94ZJ
         Jx0VztcJeDRDYtTQUQ21WMP+T6EtgJ6IwMXmBeCagbi3B3LMvSidFwYhZn1mLjVfMa4c
         89L9pAb2lYPKO8YCRCQ3gY4MeNl10P8JpMyQTlN9hVdfNrsiNxW3bfzPYEY4C5/rG7Sg
         F51w==
X-Gm-Message-State: AOAM532ni6vkx4++l1/TAe4r60IPUuH9ZRKp5YVOwFAOSmKsyJOpsp+X
        DLqeBbrJxmLjkZWGj1AuF+sCzA==
X-Google-Smtp-Source: ABdhPJwaCsjpdUqeufz7LPA/OBZLTbXFaJC5Fz2YFIOLy+dhMtsxy52sIUvhSH6mADYDMwLyYiR/oQ==
X-Received: by 2002:a05:6000:1379:: with SMTP id q25mr8008613wrz.89.1613728332670;
        Fri, 19 Feb 2021 01:52:12 -0800 (PST)
Received: from antares.lan (b.3.5.8.9.a.e.c.e.a.6.2.c.1.9.b.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:b91c:26ae:cea9:853b])
        by smtp.gmail.com with ESMTPSA id a21sm13174910wmb.5.2021.02.19.01.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 01:52:12 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 0/4] Expose network namespace cookies to user space
Date:   Fri, 19 Feb 2021 09:51:45 +0000
Message-Id: <20210219095149.50346-1-lmb@cloudflare.com>
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

1: https://www.kernel.org/doc/html/latest/bpf/prog_sk_lookup.html

Changes in v2:
- Rebase on top of Eric Dumazet's netns cookie simplification

Lorenz Bauer (4):
  net: add SO_NETNS_COOKIE socket option
  nsfs: add an ioctl to discover the network namespace cookie
  tools/testing: add test for NS_GET_COOKIE
  tools/testing: add a selftest for SO_NETNS_COOKIE

 arch/alpha/include/uapi/asm/socket.h          |  2 +
 arch/mips/include/uapi/asm/socket.h           |  2 +
 arch/parisc/include/uapi/asm/socket.h         |  2 +
 arch/sparc/include/uapi/asm/socket.h          |  2 +
 fs/nsfs.c                                     |  8 +++
 include/uapi/asm-generic/socket.h             |  2 +
 include/uapi/linux/nsfs.h                     |  2 +
 net/core/sock.c                               | 11 ++++
 tools/testing/selftests/net/.gitignore        |  1 +
 tools/testing/selftests/net/Makefile          |  2 +-
 tools/testing/selftests/net/config            |  1 +
 tools/testing/selftests/net/so_netns_cookie.c | 61 +++++++++++++++++++
 tools/testing/selftests/nsfs/.gitignore       |  1 +
 tools/testing/selftests/nsfs/Makefile         |  2 +-
 tools/testing/selftests/nsfs/config           |  1 +
 tools/testing/selftests/nsfs/netns.c          | 57 +++++++++++++++++
 16 files changed, 155 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/net/so_netns_cookie.c
 create mode 100644 tools/testing/selftests/nsfs/netns.c

-- 
2.27.0

