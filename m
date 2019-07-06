Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9777060F87
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 10:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfGFIrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 04:47:21 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40958 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfGFIrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 04:47:20 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so9810311eds.7
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 01:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=tVcTHWwkehFtY12jKvvhAX790Pux5QRK5dhbyH0IWsk=;
        b=SHJacOJaibV4wlwtCef04juaBNlltFI+uaMYG1lqZP+nEDUmG0+f8TGSi8n/ZX3YNi
         KapJ5wHMGY8NKIG4CC+ogxiQ03g+luO+uHVKNOohRJQmbE5QCN+grqGVzz1M+0pVCEOm
         k0D4nPqoTYs87/uy3CoFBanXxr30TPiz4sCIejc78cT1EHmN50hSQ4tUnKKYqiO77R3G
         +YhRypOdw0LmS6d9FlvAcP1p9aRSS4JxvSlD+QA7XSc1QjFt72b2L1Crn0rHpDBvMDfu
         5QQKBm5jrTeZWgL/KcbC5yACwABdah2Euk8nVAzmKgXy195GjcnVKhIsZ8t6W+xRMBV+
         cadw==
X-Gm-Message-State: APjAAAVE5Po9dnw9JMA0+8FORBDNjPWwHlfIOMvCi9B2EnIJX4AtWKlP
        RTl2GEntCSTFiGyEDm7Md5m4Ww==
X-Google-Smtp-Source: APXvYqzEY6a18Nl51SwUTt229zyGK8S7hLImXojgqd13N3zsbeCMOJlhFTg3U6eHa2zrIvd44A/N8Q==
X-Received: by 2002:a17:906:474a:: with SMTP id j10mr7338893ejs.104.1562402838780;
        Sat, 06 Jul 2019 01:47:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id h15sm1543653ejj.49.2019.07.06.01.47.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 01:47:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B0E4B1800C5; Sat,  6 Jul 2019 10:47:15 +0200 (CEST)
Subject: [PATCH bpf-next v2 0/6] xdp: Add devmap_hash map type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 06 Jul 2019 10:47:15 +0200
Message-ID: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
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
      uapi/bpf: Add new devmap_hash type
      xdp: Add devmap_hash map type for looking up devices by hashed index
      tools/libbpf_probes: Add new devmap_hash type
      tools: Add definitions for devmap_hash map type


 include/linux/bpf.h                     |   11 -
 include/linux/bpf_types.h               |    1 
 include/trace/events/xdp.h              |    3 
 include/uapi/linux/bpf.h                |    1 
 kernel/bpf/devmap.c                     |  325 ++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c                   |    2 
 net/core/filter.c                       |    9 +
 tools/bpf/bpftool/map.c                 |    1 
 tools/include/uapi/linux/bpf.h          |    1 
 tools/lib/bpf/libbpf_probes.c           |    1 
 tools/testing/selftests/bpf/test_maps.c |   16 ++
 11 files changed, 310 insertions(+), 61 deletions(-)

