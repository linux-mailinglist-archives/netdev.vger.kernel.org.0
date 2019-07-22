Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2A56FF01
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 13:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfGVLww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 07:52:52 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36943 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfGVLww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 07:52:52 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so40374250eds.4
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 04:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=SSeJKiBXs1prbl3iMUNc9cdeAxg1DMsRb/B+5UUqxZs=;
        b=mhQs3tPrYBppy9P/uFAB0asli4o8J8cwJnJ9QOXlJG8h+H/vuCLQisz12aRKOLecm2
         0tp3qjR4SFkS1AM6NI+GITtqMG+A25j1UmzlntIPEABG+lzMUsusOiAYybqy388qXt4c
         43uXXcHFHm3fKGI87FHTYbJeNbY3NOZEJdxPmhqCRtCUL0W26YHBhskj/8M3fCfuw5O1
         63WI4Nk4UzTtZFSg99C7bAKxZfYLjq0DlINXQRJxor+excrofG5lDSBU1dr+XjysVaa9
         kKw2kW1NWvOUxiYyDlF/1p8sqphj3/kgoGT47ogaJOTE84itAOxl2d4ZoxS7l/uN4jB7
         mWpQ==
X-Gm-Message-State: APjAAAVhJwMBKUD15QfpAvsS7gy3se2LKJobTJIEexHUWJWRn/gFyz07
        xmvwnxgSOSWE1W6m5veRW3vzog==
X-Google-Smtp-Source: APXvYqwqIU+ELulMGcnORbsPxnuTVFsRyhwUvSSiRrGCZXSEHQvxBitqbYUIL/tnAFFYnlCfo7eECg==
X-Received: by 2002:a50:a5ec:: with SMTP id b41mr58256800edc.52.1563796370389;
        Mon, 22 Jul 2019 04:52:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b25sm11018078eda.38.2019.07.22.04.52.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 04:52:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 515EB181CE7; Mon, 22 Jul 2019 13:52:48 +0200 (CEST)
Subject: [PATCH bpf-next v4 0/6] xdp: Add devmap_hash map type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Mon, 22 Jul 2019 13:52:48 +0200
Message-ID: <156379636786.12332.17776973951938230698.stgit@alrua-x1>
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
 kernel/bpf/devmap.c                             |  326 +++++++++++++++++++----
 kernel/bpf/verifier.c                           |    2 
 net/core/filter.c                               |    9 -
 tools/bpf/bpftool/Documentation/bpftool-map.rst |    2 
 tools/bpf/bpftool/bash-completion/bpftool       |    4 
 tools/bpf/bpftool/map.c                         |    3 
 tools/include/uapi/linux/bpf.h                  |    1 
 tools/lib/bpf/libbpf_probes.c                   |    1 
 tools/testing/selftests/bpf/test_maps.c         |   16 +
 13 files changed, 315 insertions(+), 65 deletions(-)

