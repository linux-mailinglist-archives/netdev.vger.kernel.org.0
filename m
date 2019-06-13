Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A5343B83
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfFMP3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:29:54 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36749 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbfFMLR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 07:17:26 -0400
Received: by mail-ed1-f65.google.com with SMTP id k21so27301972edq.3
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 04:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Py/RfLiR57GPcY12mJh69w03VHwJbFQfV62LrL2d9DE=;
        b=de4rbraXtR2pQUpjyqp5gsg0gD1WbhpQF3vkjCIaPgngJnaARzrHDY1xh4tbdRGMNs
         3LJIK8pRiRCMTXVQawvXxaJ/ywPCoR85UaRobiY8l76KIw8ELBMG4MEjZ8dCDmRyfnrx
         iNCqZP2BAiJv1GRDwmI4Edehu/s/IKIhGv6MkwOV75tCclv+yms4ROwriSIl2Ip9m0/v
         t9hRJodkXtuzMzhoUo6x+oQ8k+Grryqzqtrd5jTb0vrc2xEZz52yFhtGj88TUiUc5bCq
         RSL0q4z2ttcYHpKe/bxRK8j0q7Vd6YpOI7OVA1MvjDbeVl+CElz2M2dlEjBNy5kfuT20
         zgmg==
X-Gm-Message-State: APjAAAU7kyEhobZFDg0CFFOEhj/zXthyG6wWLmQL+MndTPdxt2Gzq+Vk
        Zang7iQ/FAhUNERxxP59rXkYgA==
X-Google-Smtp-Source: APXvYqwC+c0WeG0Zof7Yg+uMhnQR6gFqSuU7NBIdfeW5jKl1lvXy+KlBAhPLiJUWIk8Z7Jjsjuoizw==
X-Received: by 2002:a17:906:4995:: with SMTP id p21mr76162530eju.140.1560424644844;
        Thu, 13 Jun 2019 04:17:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p3sm834439eda.43.2019.06.13.04.17.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 04:17:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7887A1804AF; Thu, 13 Jun 2019 13:17:21 +0200 (CEST)
Subject: [PATCH bpf-next v4 0/3] xdp: Allow lookup into devmaps before
 redirect
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Thu, 13 Jun 2019 13:17:21 +0200
Message-ID: <156042464138.25684.15061870566905680617.stgit@alrua-x1>
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


 include/linux/filter.h |    1 
 kernel/bpf/cpumap.c    |  106 +++++++++++++++++++++------------------------
 kernel/bpf/devmap.c    |  112 +++++++++++++++++++++++-------------------------
 kernel/bpf/verifier.c  |    7 +--
 net/core/filter.c      |   29 ++++++------
 5 files changed, 118 insertions(+), 137 deletions(-)

