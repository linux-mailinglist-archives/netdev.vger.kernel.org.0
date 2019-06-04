Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F5634C20
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfFDPYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:24:15 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34809 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727996AbfFDPYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:24:14 -0400
Received: by mail-ed1-f68.google.com with SMTP id c26so1031434edt.1
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 08:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=H4oaEke6UxxX3PrzfkA4zDo8qWTGw8PnqMPc8hOgOl0=;
        b=T14CwKcdjkpTbp7onpAae4/v4ZE2oRiDOoSfSY+9Fc3ihz2F9a7fjPyBR8H8GlZ+Po
         cAmeXwXjmlmfcZoWT9ujwJz07m0POWnsWU+t61J/z/xMf4MjmZGjvlZpnGpclex5laYe
         EsLQAFC95bRbIg8hcKN67nRAAOhlYvn3OhBwtbrud7CcoR+s1LCR4e6TERBJYO33B6Yr
         +V0ij7x1ZIrbhWNsvRaD4mj1mvO+6ICStUUHKgCWVixsM1N1H1HehaPabYk0JUfjflKu
         hPxprlTT2A5bG6pZYgXMM25imDC0sFvRcvU6Ey3Q8vxtsIF0SjFtbVumL5YCmlLh4RMj
         1fTw==
X-Gm-Message-State: APjAAAUXpm1ATKthLHmlFnaxGA9XxnzxhJrU3lTi9zwsXUgTWdnRX9io
        TLDfRLlvSqHSexAQtnMa3dnAFg==
X-Google-Smtp-Source: APXvYqwBWf6pC4ZeNNuBT6IqmKJ6/dBxMh1Oi9FhKlwpdd5M+hCiX9yzKNvMTF1pw/smU+2638dy4w==
X-Received: by 2002:a05:6402:285:: with SMTP id l5mr37341347edv.240.1559661852364;
        Tue, 04 Jun 2019 08:24:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id g59sm4888771ede.55.2019.06.04.08.24.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 08:24:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B0E231800F7; Tue,  4 Jun 2019 17:24:10 +0200 (CEST)
Subject: [PATCH net-next 0/2] xdp: Allow lookup into devmaps before redirect
From:   Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Date:   Tue, 04 Jun 2019 17:24:10 +0200
Message-ID: <155966185058.9084.14076895203527880808.stgit@alrua-x1>
User-Agent: StGit/unknown-version
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

---

Toke Høiland-Jørgensen (2):
      bpf_xdp_redirect_map: Add flag to return XDP_PASS on map lookup failure
      devmap: Allow map lookups from eBPF


 include/uapi/linux/bpf.h |    8 ++++++++
 kernel/bpf/devmap.c      |    8 +++++++-
 kernel/bpf/verifier.c    |    7 ++-----
 net/core/filter.c        |   10 +++++++++-
 4 files changed, 26 insertions(+), 7 deletions(-)

