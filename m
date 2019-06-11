Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B853D131
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391789AbfFKPoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:44:06 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44380 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391769AbfFKPoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:44:05 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so20750660edr.11
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 08:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=SaPHF+kttDjLmOsLV+nbh1VVacxkA06qdBNc25PzWOA=;
        b=asQosJTWtJHv1omnWP45Sa06X4QOgYxZheOhDGGPqdHMYpZJQPu/ugNyu9ZuQKQGay
         fMf2kNdO5JfyPt1qykY39nYRw9BSI9uUE6TJbtN1kubWDuyCoWw2OhHXhEcs8SWdUMt+
         dI82Ku4ptxI1JhnqQtNTx74ReuAcRuAa9MsAClP4bxgqGoarIecjS/xuSjGq7302aEEe
         rChe4ENU1Gn0GUOX01oJFL7XcUN/ZOnzl9kyIHDYEBKltcUEdM+uzeY6AQw0/RHh255O
         +q1YAWGUluvNS19/2z+3t80sQPQb1QwXMWqBiJQ85SoqNnpj6ZMjKXRP0UpXsrJWHchX
         4IHA==
X-Gm-Message-State: APjAAAVfQLBqia0WXdRz3yTf78JusUpJWpEsy2f+g9XOnjcS8n1SUPyt
        gcBTdmSlLmkw5Ndu3SR7W9IIYQ==
X-Google-Smtp-Source: APXvYqx3wnoJpjviwCjcMVdRfUX5n3Fi9rWRwifL8OQIblUiseK/HXIHrjQA8ZWUO/l7BXvaemOIyw==
X-Received: by 2002:a50:85c4:: with SMTP id q4mr77183965edh.125.1560267843271;
        Tue, 11 Jun 2019 08:44:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id k51sm2679825edb.7.2019.06.11.08.44.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 08:44:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0ED5418037E; Tue, 11 Jun 2019 17:44:00 +0200 (CEST)
Subject: [PATCH bpf-next v3 0/3] xdp: Allow lookup into devmaps before
 redirect
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Tue, 11 Jun 2019 17:44:00 +0200
Message-ID: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
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
 include/uapi/linux/bpf.h |    8 ++++
 kernel/bpf/cpumap.c      |   97 +++++++++++++++++++++-------------------------
 kernel/bpf/devmap.c      |   98 ++++++++++++++++++++++------------------------
 kernel/bpf/verifier.c    |    7 +--
 net/core/filter.c        |   28 ++++++-------
 6 files changed, 115 insertions(+), 124 deletions(-)

