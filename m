Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CEF60B3C
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfGER4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:56:51 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40274 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGER4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:56:51 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so8572436eds.7
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 10:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=mWwgjuUS/InLXe2Ye/QfTmduUG0OmtIUaSlXdXRafgY=;
        b=ZkLIoWKcDWcnRZz8gmUv7RzBxtr3acjYFtx2tL23/ckGNlyRdT70tEEIbsQw/Pddt8
         8qtNs7MDT1hY9j9Cchlw1nVcdotkpRgdagfGUNMjNTCviKa9xFbw5vOQ0PvMGqLE7FRa
         0li2CSpzqoteLL3xyQ+eDzv8TH6FUL/O0OX54P9xAJ1Uuc4baC0Nrg/IhyC+xJ7oZvMu
         ciaxLTDHFfbuPdPdVQKj0ePSUFIVJEWSDHVxXyUsSw+0EA1MGiBsEryWyNTrOrZhUEVB
         oXt7kMxi5F8viIrK/+CkDJ3Z1x9m+WENjYyKOMKu8T1iOx9pvOvo4EgjGyqYw5pqcqWZ
         yC/A==
X-Gm-Message-State: APjAAAVbor3FA/TYdC/AlWEh3JTswV9k8frfqs1znWRUANyD4t0zhr/s
        WEDpy6YPP3n8LGarrcYAm1Dr9Q==
X-Google-Smtp-Source: APXvYqxtKtFRxu4b1fAtLVzusVjHSD4fFRCpQsJJKvgKT4MpF2v0t8s46wNxbg0/l6l5po2E7Y6dsw==
X-Received: by 2002:a17:906:7f16:: with SMTP id d22mr4710036ejr.17.1562349409439;
        Fri, 05 Jul 2019 10:56:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id a6sm2741900eds.19.2019.07.05.10.56.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 10:56:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 45020181CE6; Fri,  5 Jul 2019 19:56:48 +0200 (CEST)
Subject: [PATCH bpf-next 0/3] xdp: Add devmap_hash map type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 05 Jul 2019 19:56:48 +0200
Message-ID: <156234940798.2378.9008707939063611210.stgit@alrua-x1>
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

Changes to these patches since the previous series:

- Rebase on top of the other devmap changes (makes this one simpler!)
- Don't enforce key==val, but allow arbitrary indexes.
- Rename the type to devmap_hash to reflect the fact that it's just a hashmap now.

---

Toke Høiland-Jørgensen (3):
      include/bpf.h: Remove map_insert_ctx() stubs
      xdp: Refactor devmap allocation code for reuse
      xdp: Add devmap_hash map type for looking up devices by hashed index


 include/linux/bpf.h                     |   11 -
 include/linux/bpf_types.h               |    1 
 include/trace/events/xdp.h              |    3 
 include/uapi/linux/bpf.h                |    7 -
 kernel/bpf/devmap.c                     |  325 ++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c                   |    2 
 net/core/filter.c                       |    9 +
 tools/bpf/bpftool/map.c                 |    1 
 tools/include/uapi/linux/bpf.h          |    7 -
 tools/lib/bpf/libbpf_probes.c           |    1 
 tools/testing/selftests/bpf/test_maps.c |   16 ++
 11 files changed, 316 insertions(+), 67 deletions(-)

