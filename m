Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931C221E132
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgGMUM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:12:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27243 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbgGMUMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594671144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1RwxXsjn0kMFv31yMlNBtF+bPKg72+QxQSNd3tyZBvg=;
        b=EcXfdTi7yWU3DSBqG4U0PZ/5V+d6ca6My6R0D/ZxMXyOWpUEKED3JioESmxusIlDgGbwxm
        eKEM2VQVCkbMs/J50e6DXuGBH9I+TmZzeA1i1/+/usNxNrtQhaZY+exdjIrn2nSCpqBygO
        589MHBTW4aQhDCELMA2UsAE+z7cDz0c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-RA7vMnb6Nb-jcMiO3Uu5eA-1; Mon, 13 Jul 2020 16:12:22 -0400
X-MC-Unique: RA7vMnb6Nb-jcMiO3Uu5eA-1
Received: by mail-wm1-f69.google.com with SMTP id u68so742146wmu.3
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 13:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=1RwxXsjn0kMFv31yMlNBtF+bPKg72+QxQSNd3tyZBvg=;
        b=uTw1OR+fgE0YQkUh/vMEdmvoa95wPir4eObnE0aB9pr8g1QZzVM6R/SSNUOrn/skQd
         AJiTUljlf+4o2Y5wiED0YayZ69xlNhQvKvpUXn9a+Ar6OG0RR5CcWZPRCBahe1DytJya
         39c523vx8o7LDDo+LxAgFcF31X2u9GUYdL/Bc0Hh5X7etx+uuVg2kmFZnDhufW/mTOPX
         5KqScXV9waMaZUHJGU04Q7GnErWGB5W1qsWZGoFWL0is5j0iXQae9gE+oT/wOg59FpHB
         dsT9kWZc6Ha5J7IlQf38hZJY1iyUtCh5ExGGCDOxAzc/Ufosr3JzLC1ejrJ/OXX5UMQX
         iPFQ==
X-Gm-Message-State: AOAM532nYuGsWC+rxdhL+ik/YF1bPb/EhwcNYN8KS3FOQRG4sac6Qo+b
        L3TRHkBvruCP5UqMhQ7KmDWKj8ku5upx0mta11ckoN09ZISPgzO8YqmA4HUgtCz9zknotbt7dDV
        j5hRqHcgG/tZoQ8ZN
X-Received: by 2002:a05:600c:2907:: with SMTP id i7mr1045914wmd.40.1594671141347;
        Mon, 13 Jul 2020 13:12:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2ztAxwKgUe7vMX5wdsGVpmT5wGPKkXgBtHfkIyaFywOLDCLk7OsSNFSQNk3aeQaCdLS4+JA==
X-Received: by 2002:a05:600c:2907:: with SMTP id i7mr1045901wmd.40.1594671141112;
        Mon, 13 Jul 2020 13:12:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u17sm24472248wrp.70.2020.07.13.13.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:12:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C76131804F0; Mon, 13 Jul 2020 22:12:19 +0200 (CEST)
Subject: [PATCH bpf-next 0/6] bpf: Support multi-attach for freplace programs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 13 Jul 2020 22:12:19 +0200
Message-ID: <159467113970.370286.17656404860101110795.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support attaching freplace BPF programs to multiple targets.
This is needed to support incremental attachment of multiple XDP programs using
the libxdp dispatcher model.

The first two patches are refactoring patches: The first one is a trivial change
to the logging in the verifier, split out to make the subsequent refactor easier
to read. Patch 2 refactors check_attach_btf_id() so that the checks on program
and target compatibility can be reused when attaching to a secondary location.

Patch 3 contains the change that actually allows attaching freplace programs in
multiple places. Patches 4-6 are the usual tools header updates, libbpf support
and selftest.

See the individual patches for details.

---

Toke Høiland-Jørgensen (6):
      bpf: change logging calls from verbose() to bpf_log() and use log pointer
      bpf: verifier: refactor check_attach_btf_id()
      bpf: support attaching freplace programs to multiple attach points
      tools: add new members to bpf_attr.raw_tracepoint in bpf.h
      libbpf: add support for supplying target to bpf_raw_tracepoint_open()
      selftests: add test for multiple attachments of freplace program


 include/linux/bpf.h                           |  23 ++-
 include/linux/bpf_verifier.h                  |   9 +
 include/uapi/linux/bpf.h                      |   9 +-
 kernel/bpf/core.c                             |   1 -
 kernel/bpf/syscall.c                          |  96 +++++++++-
 kernel/bpf/trampoline.c                       |  36 +++-
 kernel/bpf/verifier.c                         | 169 +++++++++--------
 tools/include/uapi/linux/bpf.h                |   9 +-
 tools/lib/bpf/bpf.c                           |  33 +++-
 tools/lib/bpf/bpf.h                           |  12 ++
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 174 +++++++++++++++---
 .../bpf/progs/freplace_get_constant.c         |  15 ++
 13 files changed, 460 insertions(+), 127 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c

