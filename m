Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1D576E80
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfGZQGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:06:55 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40477 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfGZQGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:06:55 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so53707083eds.7
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 09:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=9CAU24lteoB4qbD+vKulgQyzZoi3AiHA0EAVVtQQ58M=;
        b=VNJF9f73GxB8LfIgmqAYj81+8pN3nUTnVvkj5vifCSHBkFRmRhr6rpo6lREWOVwNBe
         4wMeMr4NW87H2SO79l61UO8IksU7aK9c/JczGWFDhgeGEP8FJLvxRhVEiQYf6NopTn1s
         63+ICOfhJdDSRHitidrrGJdJlo9KvhndNeuo4ZP5iPeAM6pDjL5o2Q83cJC3w+0n17vt
         0hTjkw2/1ZIw1fC9wCRtKxS8BjWzDzi0LvJLGUQxTY2m6IAXQvF0IdsKomBRZJ1X9Hjd
         6U07zRG0JzCFdUnJj0N/M7pTm1DbD4TqXh9eN/mu1n2C8uDwC5Mi9hqu1Rvm3EQT+Cwe
         ovBA==
X-Gm-Message-State: APjAAAWy7ILYx+OhGwIECnAECpomAHWla4QYSxkBxpgC6u42s+vDj9sh
        poQ3VfjJZ92B0px12yTgzBWXcQ==
X-Google-Smtp-Source: APXvYqyMhPBc8CmRLIfKZKHbnd/Qlxvzf/AEo1q+KxRFxEcQ26PsE6tZS8I9GSq3759yeVXeiRTbQA==
X-Received: by 2002:a17:906:95d0:: with SMTP id n16mr73560471ejy.116.1564157213527;
        Fri, 26 Jul 2019 09:06:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id q14sm10231666eju.47.2019.07.26.09.06.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 09:06:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 574E41800C5; Fri, 26 Jul 2019 18:06:51 +0200 (CEST)
Subject: [PATCH bpf-next v5 0/6] xdp: Add devmap_hash map type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Fri, 26 Jul 2019 18:06:51 +0200
Message-ID: <156415721066.13581.737309854787645225.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a new map type, devmap_hash, that works like the existing
devmap type, but using a hash-based indexing scheme. This is useful for the use
case where a devmap is indexed by ifindex (for instance for use with the routing
table lookup helper). For this use case, the regular devmap needs to be sized
after the maximum ifindex number, not the number of devices in it. A hash-based
indexing scheme makes it possible to size the map after the number of devices it
should contain instead.

This was previously part of my patch series that also turned the regular
bpf_redirect() helper into a map-based one; for this series I just pulled out
the patches that introduced the new map type.

Changelog:

v5:

- Dynamically set the number of hash buckets by rounding up max_entries to the
  nearest power of two (mirroring the regular hashmap), as suggested by Jesper.

v4:

- Remove check_memlock parameter that was left over from an earlier patch
  series.
- Reorder struct members to avoid holes.

v3:

- Rework the split into different patches
- Use spin_lock_irqsave()
- Also add documentation and bash completion definitions for bpftool

v2:

- Split commit adding the new map type so uapi and tools changes are separate.

Changes to these patches since the previous series:

- Rebase on top of the other devmap changes (makes this one simpler!)
- Don't enforce key==val, but allow arbitrary indexes.
- Rename the type to devmap_hash to reflect the fact that it's just a hashmap now.

---

Toke Høiland-Jørgensen (6):
      include/bpf.h: Remove map_insert_ctx() stubs
      xdp: Refactor devmap allocation code for reuse
      xdp: Add devmap_hash map type for looking up devices by hashed index
      tools/include/uapi: Add devmap_hash BPF map type
      tools/libbpf_probes: Add new devmap_hash type
      tools: Add definitions for devmap_hash map type


 include/linux/bpf.h                             |   11 -
 include/linux/bpf_types.h                       |    1 
 include/trace/events/xdp.h                      |    3 
 include/uapi/linux/bpf.h                        |    1 
 kernel/bpf/devmap.c                             |  332 +++++++++++++++++++----
 kernel/bpf/verifier.c                           |    2 
 net/core/filter.c                               |    9 -
 tools/bpf/bpftool/Documentation/bpftool-map.rst |    2 
 tools/bpf/bpftool/bash-completion/bpftool       |    4 
 tools/bpf/bpftool/map.c                         |    3 
 tools/include/uapi/linux/bpf.h                  |    1 
 tools/lib/bpf/libbpf_probes.c                   |    1 
 tools/testing/selftests/bpf/test_maps.c         |   16 +
 13 files changed, 321 insertions(+), 65 deletions(-)

