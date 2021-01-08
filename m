Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEEE2EF6F2
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbhAHSEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbhAHSEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:04:15 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6DBC061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:03:35 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id q13so7126228pfn.18
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=uy999xqJw7BL3WhrZT3LQFvPsdD4ZByTDVZmgN/UR4M=;
        b=hnS6XTf4SbwUDmsws7ObNGr/AOqNQXZkpvnD5Q57hierrmM6HvHGF9b7MHzgQ8fNkl
         rtbofw4YLVMAwAPVUlx5QRFjqGqk8uKnS2FNNT0fuEkRgnGROZg1oNIU4lvifHltqzqh
         niYP6C2fSb8mWGiTUc2sVnIrm8EtAU8q9rMPiX0681pmUpHzo1A+9JMsAkqdFUD/59Jn
         77P2UCbmmPl5xowxko+sbZZp5PhFRc2dByFqDdclokcssbQvMycKC5h3K9wioNrNYqD/
         5ZeusityobxBlEgyiVg5pwVDJuvpTCfLNpKhdrg0y3lFFwgW47lqntIBH3nbwuY0lzc3
         NMSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=uy999xqJw7BL3WhrZT3LQFvPsdD4ZByTDVZmgN/UR4M=;
        b=m19uOmWwODNnJWlG8PtHuoy8ZFFVPRfsqXfL2G2buPzIaZ5qxBN+tf2kP+i/mW8AFo
         VhAS+pt+YJhAuniyePaLHYGC0omCGM/N3+0jQD8AMcBsOr7iGAfsa2JqyXaeoBjgtqOy
         sS1XK5/o0rfd/1jvwNZsYDqr6hpnUEwbPBRGIJV30OzML7inGHxx4shXU3eu04jz9jL2
         fJHENGIBGVA1r3az4RuWNysKTEmq7UNLG1HhwkrKSx7siBk/g6jddMjKGZpQxdiz1ns3
         lmTBFJS7QcywfFAsHkSGWx4ReOG0IfBdn3IYOlBDShV+3CvTk/JsQkknpQi7uFNbrhdo
         tWjQ==
X-Gm-Message-State: AOAM533HbX/DyTEEAAwsJM677lgSpNju44qx/yW4qcQHtZdYlMfBIPzq
        B/gt4mKI7pL+mDvQ86jIpbfWfFzHs3FmD1a5F0KgviiJSbWkxgJP5NzZI42kNlWliizuInV8VRF
        FgEzFRCjdAPTHAdF67iNwmxOt9yReRWpAQE8anhcrGoFMX+dYjZlvCw==
X-Google-Smtp-Source: ABdhPJytp7ezHR/hUJtuQDUkct+MRHLjGX+cIlGTvGpFK8YLlJvPoHnqoaBE4OrQl+1Qq3TPMsiOj30=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a63:2265:: with SMTP id t37mr8045351pgm.336.1610129015278;
 Fri, 08 Jan 2021 10:03:35 -0800 (PST)
Date:   Fri,  8 Jan 2021 10:03:30 -0800
Message-Id: <20210108180333.180906-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next v5 0/3] bpf: misc performance improvements for cgroup hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch adds custom getsockopt for TCP_ZEROCOPY_RECEIVE
to remove kmalloc and lock_sock overhead from the dat path.

Second patch removes kzalloc/kfree from getsockopt for the common cases.

Third patch switches cgroup_bpf_enabled to be per-attach to
to add only overhead for the cgroup attach types used on the system.

No visible user-side changes.

v5:
- reorder patches to reduce the churn (Martin KaFai Lau)

v4:
- update performance numbers
- bypass_bpf_getsockopt (Martin KaFai Lau)

v3:
- remove extra newline, add comment about sizeof tcp_zerocopy_receive
  (Martin KaFai Lau)
- add another patch to remove lock_sock overhead from
  TCP_ZEROCOPY_RECEIVE; technically, this makes patch #1 obsolete,
  but I'd still prefer to keep it to help with other socket
  options

v2:
- perf numbers for getsockopt kmalloc reduction (Song Liu)
- (sk) in BPF_CGROUP_PRE_CONNECT_ENABLED (Song Liu)
- 128 -> 64 buffer size, BUILD_BUG_ON (Martin KaFai Lau)

Stanislav Fomichev (3):
  bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
  bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
  bpf: split cgroup_bpf_enabled per attach type

 include/linux/bpf-cgroup.h                    |  61 ++++++----
 include/linux/filter.h                        |   5 +
 include/net/sock.h                            |   2 +
 include/net/tcp.h                             |   1 +
 kernel/bpf/cgroup.c                           | 104 +++++++++++++++---
 net/ipv4/af_inet.c                            |   9 +-
 net/ipv4/tcp.c                                |  14 +++
 net/ipv4/tcp_ipv4.c                           |   1 +
 net/ipv4/udp.c                                |   7 +-
 net/ipv6/af_inet6.c                           |   9 +-
 net/ipv6/tcp_ipv6.c                           |   1 +
 net/ipv6/udp.c                                |   7 +-
 .../selftests/bpf/prog_tests/sockopt_sk.c     |  22 ++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  15 +++
 14 files changed, 206 insertions(+), 52 deletions(-)

-- 
2.29.2.729.g45daf8777d-goog

