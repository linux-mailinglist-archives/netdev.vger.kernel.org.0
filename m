Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2815C5C474
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfGAUsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:48:25 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:51524 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfGAUsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:48:24 -0400
Received: by mail-pf1-f201.google.com with SMTP id 145so9476816pfv.18
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 13:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1fU963y6n1uxxX6uDB4NB2bxwMtwWhsu0C0kXZ5bPNs=;
        b=uYPfOoRzpRH2tNIG+V1pCcb3F8KuEAEGi1QUvV7SXtbjm8NtGlrD8o61XKC+or3AUP
         qF60O5//VaUaNFarLQpFL6+cXTUa8sXmJoX6V4k7VIiSO4fC+c/g9aTzBOE4dsHmwKvu
         biaebexH6ZOKqahilR9mMajrGMEhmRKL5S3Vdtt3ojL/4fNJeorBuwov/C+MVGbxqVv6
         bXxEKIgm0hfUls4UbgyxrBHi7EoAL4mOVP2TnKE2+YwTGX9widmgL52uYfyIKfZl0wUz
         5OkA+YOzxSAhyGXoHXZ3cgbUD5UkOyxfm9b+fe5jCqXADjN/GvdsZvICbL1lZV/PVknI
         di6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1fU963y6n1uxxX6uDB4NB2bxwMtwWhsu0C0kXZ5bPNs=;
        b=CJTvjKx6hui4PiBEIn+rNz4DhzYAFv6wrGJbAhrwn0T2mYmmCH6ahki7Ie3qzwaNFC
         jmgvKIbD58Jj5tWscN7/rKU6eDDR3107zGUcc7+GheFLct0rShZitSmU3ItHWPiydLLG
         YbbQbeoGp2T20CkhZ8ejTzPGPewUpMF880mhInZ2Z4EkabaRS30qVvSL7YFLOkR29TDf
         BJzykDH6Bx+nKSDno69CNK3uvM4vUITxmW5Q7zvQgQ23WEGojdn7g6NyM3T5LrGC6A50
         eXKTJlcJ2VjYlAnXY9XXuMpZnA0mI862TLW7GOm8O/Y7DgYQWgR4HBTLN95v73czhOBK
         3wRQ==
X-Gm-Message-State: APjAAAU/GmxlTBL2x6lREqxJuGKfrEobH4e4WBXwFDqDLs/+kWjbs+Hf
        EFG79JTnWzNa399b1oxYWb93U9hgsGkOIujJToL1gn2WkCC97Wsp7YsK8WsqEJRzcZITg8PZRIf
        /izA58QKFk7Ai/tbcrB6DVL1HLbQgAznnO7ZfX27pREvYmJzk3zkR0Q==
X-Google-Smtp-Source: APXvYqzReUwAMT6ii0T6l1Fk7MOoclkoZ6uMqHZ9izzIcx70OdGnNHKpKUKWKc65dXxph9wz6m+NnWg=
X-Received: by 2002:a63:3d0f:: with SMTP id k15mr26848612pga.343.1562014103653;
 Mon, 01 Jul 2019 13:48:23 -0700 (PDT)
Date:   Mon,  1 Jul 2019 13:48:13 -0700
Message-Id: <20190701204821.44230-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next 0/8] bpf: TCP RTT sock_ops bpf callback
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Congestion control team would like to have a periodic callback to
track some TCP statistics. Let's add a sock_ops callback that can be
selectively enabled on a socket by socket basis and is executed for
every RTT. BPF program frequency can be further controlled by calling
bpf_ktime_get_ns and bailing out early.

I run neper tcp_stream and tcp_rr tests with the sample program
from the last patch and didn't observe any noticeable performance
difference.

Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Priyaranjan Jha <priyarjha@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>

Stanislav Fomichev (8):
  bpf: add BPF_CGROUP_SOCK_OPS callback that is executed on every RTT
  bpf: split shared bpf_tcp_sock and bpf_sock_ops implementation
  bpf: add dsack_dups/delivered{,_ce} to bpf_tcp_sock
  bpf: add icsk_retransmits to bpf_tcp_sock
  bpf/tools: sync bpf.h
  selftests/bpf: test BPF_SOCK_OPS_RTT_CB
  samples/bpf: add sample program that periodically dumps TCP stats
  samples/bpf: fix tcp_bpf.readme detach command

 include/net/tcp.h                           |   8 +
 include/uapi/linux/bpf.h                    |  12 +-
 net/core/filter.c                           | 207 +++++++++++-----
 net/ipv4/tcp_input.c                        |   4 +
 samples/bpf/Makefile                        |   1 +
 samples/bpf/tcp_bpf.readme                  |   2 +-
 samples/bpf/tcp_dumpstats_kern.c            |  65 +++++
 tools/include/uapi/linux/bpf.h              |  12 +-
 tools/testing/selftests/bpf/Makefile        |   3 +-
 tools/testing/selftests/bpf/progs/tcp_rtt.c |  61 +++++
 tools/testing/selftests/bpf/test_tcp_rtt.c  | 253 ++++++++++++++++++++
 11 files changed, 570 insertions(+), 58 deletions(-)
 create mode 100644 samples/bpf/tcp_dumpstats_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c

-- 
2.22.0.410.gd8fdbe21b5-goog
