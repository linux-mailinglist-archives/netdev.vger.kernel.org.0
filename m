Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C477E61D4B
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfGHKzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:55:50 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36614 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfGHKzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 06:55:50 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so14142507edq.3
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 03:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=+LpqApi2TdeE1/jiEDrVs1oZ7bMKBdwgsGKfFn1LBb4=;
        b=Tap1TN4IGqH0pJKkoR6JmrX/cS6tGedxd361SspbrZSMIVnVfLIcwcvFEjFRYstY75
         WFXn8IwVA+c6TaKpcOzRIV9zwY5iVD8piOojGkpRbS5M5JBndL+EmaRq9VUmjSMTcVhu
         JYZfwYbz9i4ungxEmN8Fu1s2b/z5cPxoLpEY1RcHzjI7B9eJF3iQowzEmh/M8/VjRIv3
         2cLy1gdta46Ir+Cnq15pr6nh5fcZyRLKBYU6X7zB2HjPv/O2NQoZ8kbsSUfq5dj/qFm4
         xsVB6hfMypPO5kV1KlAY5/uQKCysrHbJlA5inpZ3YCNdWjzUQ5EoAz0V9xYrZI/1EFTj
         Gd0g==
X-Gm-Message-State: APjAAAWv3+wiuowjueIhqB5rb6Xu3yTL5r9uUZ5nx5UP5BV8H1py0x8V
        CLCdwj26w665lP52wv8QNlMYGA==
X-Google-Smtp-Source: APXvYqwbV97S5IxKmyXQKSpcr341hpekAr3dVO9rnk8CEOvhSuUS+qv4x+tC8d9BItyOmkwyGeHy+Q==
X-Received: by 2002:a17:907:2114:: with SMTP id qn20mr15949720ejb.138.1562583348817;
        Mon, 08 Jul 2019 03:55:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id x11sm2599918eda.80.2019.07.08.03.55.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 03:55:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 33148181CE6; Mon,  8 Jul 2019 12:55:47 +0200 (CEST)
Subject: [PATCH bpf-next v3 0/6] xdp: Add devmap_hash map type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Mon, 08 Jul 2019 12:55:47 +0200
Message-ID: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
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
 kernel/bpf/devmap.c                             |  327 +++++++++++++++++++----
 kernel/bpf/verifier.c                           |    2 
 net/core/filter.c                               |    9 -
 tools/bpf/bpftool/Documentation/bpftool-map.rst |    2 
 tools/bpf/bpftool/bash-completion/bpftool       |    4 
 tools/bpf/bpftool/map.c                         |    3 
 tools/include/uapi/linux/bpf.h                  |    1 
 tools/lib/bpf/libbpf_probes.c                   |    1 
 tools/testing/selftests/bpf/test_maps.c         |   16 +
 13 files changed, 316 insertions(+), 65 deletions(-)

