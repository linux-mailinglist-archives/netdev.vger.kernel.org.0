Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770A051F5E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfFXX50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:57:26 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:55157 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbfFXX5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:57:25 -0400
Received: by mail-pg1-f202.google.com with SMTP id t2so10331084pgs.21
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 16:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aQiVt1v1ZspQwRYs4b3nRqt7OstkFgTd68CV7/bkhBE=;
        b=txqvv/NrWF2r2ZYnikxukD/ZTGTxdxrEpeeOGHmXwj72GqxK2ht2VzPh7WQDvUOEvx
         fveeS03789E660Df7NgYySiBMq0CKfnt0FGrf+j0Ccn2Q8q1SUPKjPckd0zwOvi2S8Lm
         fTMZHhPZ2Rt4so+75FNenrstI74oZ231YwcoLAzFNzkScr9l99sN5uLzDadIRInd/sy2
         zSq3KdMgHT8SZI65hzgk0sGSFKdjTir5r+KZ4MDS5SoytMFRCAKJvHNZ7XT6h/cp2iDF
         HHPsjszn23XpCFmfrSA9dnk+MoClS1XLMfyLf3IfmKNR0qOJoAYvyKcGSTMGcqqvcYiJ
         pHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aQiVt1v1ZspQwRYs4b3nRqt7OstkFgTd68CV7/bkhBE=;
        b=Rs4mPpXlZ3JU+6ZiqZCqwKo/C3lVjFK/bE1FISGYDFq8NpDxf+Vm6ZvmIh4qGqgN4B
         CjnJ1FyuT1MAK3AMVqz9lyLyzcmdhgMSTlWUEkjbxfVShxyclhC2y02QZLXBb2kOoLKe
         R5k6QwYb3uXMQzx3W3G31rPLz6nJAZoyR1VxKyiy7mPZwkYNrgVFz3TnVF1sJogd1Yil
         htdQ114w/dba6oj0WvP+8lgnv84dX4jijg7h57P7yPWWrc5ER7l4hK79X2WEKKxsshHz
         RYIIacWBGOklGxQM/T3tqqJI45JD9X0osOp9PXK125MwWtb6jRkjN/WYOipcF0JODq6I
         U3AQ==
X-Gm-Message-State: APjAAAWcYcTcdwQiw+rqjddjEGU17hRimpUVdU4ukDvo0QGmgXZ/ov6K
        vBweDaupHrsvYLI9iQEXf//vdB/2uFHuhyE0
X-Google-Smtp-Source: APXvYqyVAz/J7JuE9xSQrMGwuqiw5jvMqJF2PJiivFk2FjhFS9d/dVj1l146q2/pkut1R0tC6xATSgINoHjQjykI
X-Received: by 2002:a65:560f:: with SMTP id l15mr12290186pgs.94.1561420645035;
 Mon, 24 Jun 2019 16:57:25 -0700 (PDT)
Date:   Mon, 24 Jun 2019 16:57:18 -0700
Message-Id: <20190624235720.167067-1-allanzhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v3 0/2] bpf: Allow bpf_skb_event_output for more prog types
From:   allanzhang <allanzhang@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Software event output is only enabled by a few prog types right now (TC,
LWT out, XDP, sockops). Many other skb based prog types need
bpf_skb_event_output to produce software event.

Added socket_filter, cg_skb, sk_skb prog types to generate sw event.

*** BLURB HERE ***

allanzhang (2):
  bpf: Allow bpf_skb_event_output for a few prog types
  bpf: Add selftests for bpf_perf_event_output

 net/core/filter.c                             |  6 ++
 tools/testing/selftests/bpf/test_verifier.c   | 33 ++++++-
 .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
 3 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c

-- 
2.22.0.410.gd8fdbe21b5-goog

