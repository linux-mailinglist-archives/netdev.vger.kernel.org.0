Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6472F4F980
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 04:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfFWCRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 22:17:45 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35198 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFWCRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 22:17:45 -0400
Received: by mail-ed1-f68.google.com with SMTP id w20so8330876edd.2
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 19:17:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=NNtFMLGHiuriWHXqfSMY9r9K3HxEvrcxR5a19LHyCmg=;
        b=DZj1GB9rK1rrH9OQCfirfh6knXkz2vbVBbRtTSf91fCoVIvOKLxUwed6jK0num6JMk
         amlgx4Q4Ff/rHtEYk68WABMREGD1LXZDuL6hcE5dfoYNb/3MN9npdY2PX/luFl9HoX9h
         Ui0A+uBs3CqoNfR8IK9Hl5HsvbRnjjWqiCzYy2znTGbuFD+IlTF5iSfrvJM/K1rMJPli
         6mpmxO3z9qj+AAczN7yMfUnwdGpUQUHMkwRnnFhYITFQx33PW6m+n4AgYMH/Y9xbXKPB
         rsOEJ3NYGgkvVFV/c8+SlLneRkGkGzJdqBVRqULI6IS82FuQF/SgDqXtFInAsr0vAyKr
         vvuA==
X-Gm-Message-State: APjAAAVbZ7Oqf5ZuExPshap0SR1uZ3EepkJf1hgXMKzUI3B9ovOzR5ok
        7Me0m3eo6sqdl2RRrfbsgN3LxA==
X-Google-Smtp-Source: APXvYqxV4i5i/UkTtjNNKXjydSLcbD2u4eF+Kw9XJkCAXMmv8EyDXTmauvWtYxuo1wASJy+T0jzaSg==
X-Received: by 2002:a50:ae8c:: with SMTP id e12mr19593559edd.8.1561256263635;
        Sat, 22 Jun 2019 19:17:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d4sm2350678edb.4.2019.06.22.19.17.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 22 Jun 2019 19:17:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2C7C91804B6; Sat, 22 Jun 2019 22:17:41 -0400 (EDT)
Subject: [PATCH bpf-next v5 0/3] xdp: Allow lookup into devmaps before
 redirect
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Sat, 22 Jun 2019 22:17:41 -0400
Message-ID: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using the bpf_redirect_map() helper to redirect packets from XDP, the eBPF
program cannot currently know whether the redirect will succeed, which makes it
impossible to gracefully handle errors. To properly fix this will probably
require deeper changes to the way TX resources are allocated, but one thing that
is fairly straight forward to fix is to allow lookups into devmaps, so programs
can at least know when a redirect is *guaranteed* to fail because there is no
entry in the map. Currently, programs work around this by keeping a shadow map
of another type which indicates whether a map index is valid.

This series contains two changes that are complementary ways to fix this issue:

- Moving the map lookup into the bpf_redirect_map() helper (and caching the
  result), so the helper can return an error if no value is found in the map.
  This includes a refactoring of the devmap and cpumap code to not care about
  the index on enqueue.

- Allowing regular lookups into devmaps from eBPF programs, using the read-only
  flag to make sure they don't change the values.

The performance impact of the series is negligible, in the sense that I cannot
measure it because the variance between test runs is higher than the difference
pre/post series.

Changelog:

v5:
  - Rebase on latest bpf-next.
  - Update documentation for bpf_redirect_map() with the new meaning of flags.

v4:
  - Fix a few nits from Andrii
  - Lose the #defines in bpf.h and just compare the flags argument directly to
    XDP_TX in bpf_xdp_redirect_map().

v3:
  - Adopt Jonathan's idea of using the lower two bits of the flag value as the
    return code.
  - Always do the lookup, and cache the result for use in xdp_do_redirect(); to
    achieve this, refactor the devmap and cpumap code to get rid the bitmap for
    selecting which devices to flush.

v2:
  - For patch 1, make it clear that the change works for any map type.
  - For patch 2, just use the new BPF_F_RDONLY_PROG flag to make the return
    value read-only.

---

Toke Høiland-Jørgensen (3):
      devmap/cpumap: Use flush list instead of bitmap
      bpf_xdp_redirect_map: Perform map lookup in eBPF helper
      devmap: Allow map lookups from eBPF


 include/linux/filter.h   |    1 
 include/uapi/linux/bpf.h |    7 ++-
 kernel/bpf/cpumap.c      |  106 ++++++++++++++++++++-----------------------
 kernel/bpf/devmap.c      |  113 ++++++++++++++++++++++------------------------
 kernel/bpf/verifier.c    |    7 +--
 net/core/filter.c        |   29 +++++-------
 6 files changed, 123 insertions(+), 140 deletions(-)

