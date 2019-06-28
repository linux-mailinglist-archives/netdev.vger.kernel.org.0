Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970DC59700
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfF1JMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 05:12:43 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44587 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfF1JMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 05:12:37 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so9990876edr.11
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 02:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=7QTqQ080VkHANvzxiC8cpbwovfaOI5/GUzu5dpQFPW4=;
        b=i0eCECIJU+gW3WyB7GXs/VYHV+m2mluVp+Dbee4aBHKgZHhFYFJEEcAaMDH5AiZIMh
         B6e/v03Phwe9q+aPEKW9JB8N9ueB8pzyr59U+MGLiKyuLob96eg4DV0mLdtzqZwLn5Cl
         ZfvmV8p4G9alCsLxoXNvL3lYxGKvbyCT7FlJAtNWqTcUgqiN94Zv4QjkKDlyaDgPWYny
         R1oR+n4N9NN7JLlIYHXSG8Cpx1oUE42XLOy0eLu0uNEjqztTEBxoSQV44PvZrjOHrDia
         JZyEkL46sIlQtbJ148IDa5H7TzYx+k0ueBgH/Iz2512VU9MfUdgZx3felRu+/SPEFcZF
         NqbA==
X-Gm-Message-State: APjAAAUqNzLk1J4/pzbKIZygkyOwkPiV2is3iE75cn3JaCU0GaWkaW5c
        KOnJrd1pZWr/6wgPXF7T2LVEPY+BbqI=
X-Google-Smtp-Source: APXvYqyl1NztNMqAIXwAKGjRUfQ6dNy8XP/5FvlkxLEXgqo89t8T5zlQXlkX0JpJ3WAN7Q/H1WM3Lw==
X-Received: by 2002:a17:906:2e59:: with SMTP id r25mr7430309eji.293.1561713156428;
        Fri, 28 Jun 2019 02:12:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id by12sm338754ejb.37.2019.06.28.02.12.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:12:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BABEF181CA7; Fri, 28 Jun 2019 11:12:34 +0200 (CEST)
Subject: [PATCH bpf-next v6 0/5] xdp: Allow lookup into devmaps before
 redirect
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Fri, 28 Jun 2019 11:12:34 +0200
Message-ID: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
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

v6:
  - Factor out list handling in maps to a helper in list.h (new patch 1)
  - Rename variables in struct bpf_redirect_info (new patch 3 + patch 4)
  - Explain why we are clearing out the map in the info struct on lookup failure
  - Remove unneeded check for forwarding target in tracepoint macro

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

Toke Høiland-Jørgensen (5):
      xskmap: Move non-standard list manipulation to helper
      devmap/cpumap: Use flush list instead of bitmap
      devmap: Rename ifindex member in bpf_redirect_info
      bpf_xdp_redirect_map: Perform map lookup in eBPF helper
      devmap: Allow map lookups from eBPF


 include/linux/filter.h     |    3 +
 include/linux/list.h       |   14 ++++++
 include/trace/events/xdp.h |    5 +-
 include/uapi/linux/bpf.h   |    7 ++-
 kernel/bpf/cpumap.c        |  105 +++++++++++++++++++----------------------
 kernel/bpf/devmap.c        |  112 ++++++++++++++++++++------------------------
 kernel/bpf/verifier.c      |    7 +--
 kernel/bpf/xskmap.c        |    3 -
 net/core/filter.c          |   60 ++++++++++++------------
 9 files changed, 157 insertions(+), 159 deletions(-)

