Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE3237515
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfFFNYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:24:20 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33618 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfFFNYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:24:18 -0400
Received: by mail-ed1-f68.google.com with SMTP id h9so3356586edr.0
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 06:24:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=YV7Ic9CmerTuNazvUQHvroca4vmYybTMbGy+KW1TALk=;
        b=CDoFyy2pngPESbXooo8oaAyBjFOWOnVIOgTJ29VaDxjtNvf/U1zuUi5cxz2X+TCzqJ
         2586XS9jozOwyQOeVWJUlzaOOrsUCb/7DpAvPrzSJ4fTmvFoYHE2lPBLTzbQtBsv0xvX
         3bMbtCO6R5i1PGnoEuqPR1NnN2OGCZzrOum4veyAxSpQckWRp/OCj7jY27wLc1pV54Hy
         GGyTUqeMjDFHG973JLGlxhBGfVGVm1MOu6jb6gSOqIv0sS+jOs40XU558jMqemZ4mOLz
         z9IlfQc8wu2GVo3O8hP9dJHsg+zbCyVVDlJX0JnLkK1+YaQSwUZOPSakqakXJgRCKLzP
         UHdw==
X-Gm-Message-State: APjAAAU2jmLkfWclH+tcVLRRJFCOPRKoc6SrDbpuHvoIfmzBWgP3hsyv
        HWa6qxQskKoTEsLKzTzljeROfg==
X-Google-Smtp-Source: APXvYqyY8jqcxPCrbLY4i0NK07H7UMqkBXdhZYUxO7dGjjRxan3ckVuhenUo6SkUF7aP434qF9ZIFQ==
X-Received: by 2002:a50:996e:: with SMTP id l43mr24988066edb.187.1559827456895;
        Thu, 06 Jun 2019 06:24:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id l15sm331607ejp.34.2019.06.06.06.24.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 06:24:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 95EC2181CC1; Thu,  6 Jun 2019 15:24:14 +0200 (CEST)
Subject: [PATCH net-next v2 0/2] xdp: Allow lookup into devmaps before
 redirect
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Date:   Thu, 06 Jun 2019 15:24:14 +0200
Message-ID: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
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

This series contains two changes that are complementary ways to fix this issue.
The first patch adds a flag to make the bpf_redirect_map() helper itself do a
lookup in the map and return XDP_PASS if the map index is unset, while the
second patch allows regular lookups into devmaps from eBPF programs.

The performance impact of both patches is negligible, in the sense that I cannot
measure it because the variance between test runs is higher than the difference
pre/post patch.

Changelog:

v2:
  - For patch 1, make it clear that the change works for any map type.
  - For patch 2, just use the new BPF_F_RDONLY_PROG flag to make the return
    value read-only.

---

Toke Høiland-Jørgensen (2):
      bpf_xdp_redirect_map: Add flag to return XDP_PASS on map lookup failure
      devmap: Allow map lookups from eBPF


 include/uapi/linux/bpf.h |    8 ++++++++
 kernel/bpf/devmap.c      |    5 +++++
 kernel/bpf/verifier.c    |    7 ++-----
 net/core/filter.c        |   10 +++++++++-
 4 files changed, 24 insertions(+), 6 deletions(-)

