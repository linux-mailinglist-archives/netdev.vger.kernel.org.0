Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131F35D3FF
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGBQOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:14:07 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:54931 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfGBQOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:14:07 -0400
Received: by mail-pl1-f201.google.com with SMTP id u10so589655plq.21
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=L7R6X5tBrXMAw/vqdDRcSek4d528xe4FlyccGeilGP0=;
        b=mwLFPqLX7ST60ZfFh/0Y8wbnEMeWChsbibeeBdoQ9NH+WQRI1vo3mpn5jPx/pKupZF
         Jq215vvfIPad7QfoJJsPMz9ge8XXJwe/7OYAJR6pu0D7Z+B7t7rxiG4Ar0FaDNPDL6xh
         NVPv8nQxKAFXK31Fn/abWT5oLEFCHGJ78jlBfHeKiYmskN9A3p54JzxWsctMHad+Bj6l
         kOvRY3TmrMDcQxgcMV/31q/ZmS8dvrDunyYTGzzHqp6BAyflX9FgJn4CDrOVTgcOZ+Dv
         tlJY8jVN2JNhqPIki5slnULOppvljyg+tvWfWy+qiFXmlSCtpjYlYQGi5sNXiWxygmyx
         WktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=L7R6X5tBrXMAw/vqdDRcSek4d528xe4FlyccGeilGP0=;
        b=rggWB76eJwAN5FUg8RuYOnkCpspUr8/SHuh61llY5Zzp5/h3muoPwxyxVSazVBX+SV
         d+2cy8/lMUWLWFN111bvbL9hhOZj52w2xdECcR2GQsU7IaYoi5Ah3TDtRnUPOoBy4FNL
         5SDxBT4EXDZU+p5uapfWYiqZAP23JHpUV1xGQQuiQudj4Q0WDi4ODj/+/mtGVoUPEFjl
         TYuG3E4exfNT1tQ1IgPctVcCkLjcKQdn6zHXd63IYwkmioBJAKYaTUQCWNIT6duuW106
         RKM1Kkm4Tr8dx6uNHfWeuoD5A0iOSEFw3f08NTVQ/61U7xfAS5Nwp2azdo6ollCqoxOK
         BFpw==
X-Gm-Message-State: APjAAAVw1+lPj/iisTp3dtcrjnYtnnaTV/3kKA0/TEEOnEXDJ/kz2DS2
        6CuBFX2fxK0mWnFQCB+U2YaD0MOdPMgO0clgkWwpKeI1FuW+inMO7X/aZ374UF9y85nyN+zXxD3
        CvW4edtzMqeE2LiR+kCFtF4+bsjcB7pPrLmvAoJIJDbYzInLB4rB9HQ==
X-Google-Smtp-Source: APXvYqzOVh8vd2O1G0sykUuAWlF3Z9Viyb0b064Q8G/QLbx1kSTot/UUVYf+9vDApvmYEyy5BUmcDRA=
X-Received: by 2002:a63:6155:: with SMTP id v82mr31007318pgb.304.1562084045619;
 Tue, 02 Jul 2019 09:14:05 -0700 (PDT)
Date:   Tue,  2 Jul 2019 09:13:55 -0700
Message-Id: <20190702161403.191066-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 0/8] bpf: TCP RTT sock_ops bpf callback
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

v2:
* add a comment about second accept() in selftest (Yonghong Song)
* refer to tcp_bpf.readme in sample program (Yonghong Song)

Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Priyaranjan Jha <priyarjha@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>

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
 samples/bpf/tcp_dumpstats_kern.c            |  68 ++++++
 tools/include/uapi/linux/bpf.h              |  12 +-
 tools/testing/selftests/bpf/Makefile        |   3 +-
 tools/testing/selftests/bpf/progs/tcp_rtt.c |  61 +++++
 tools/testing/selftests/bpf/test_tcp_rtt.c  | 254 ++++++++++++++++++++
 11 files changed, 574 insertions(+), 58 deletions(-)
 create mode 100644 samples/bpf/tcp_dumpstats_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c

-- 
2.22.0.410.gd8fdbe21b5-goog
