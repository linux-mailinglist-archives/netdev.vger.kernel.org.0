Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971EA2EF9DA
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbhAHVDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbhAHVDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 16:03:06 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C62C061786
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 13:02:26 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id b24so4272579qtt.22
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 13:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=kdX+hsqYU8mLAc9/cZ91DQUtrf0mogVuzeFKIjUzm60=;
        b=sWvtUQVI5ueh7kfYW0SNi4IptnyLFbREdkUhAyICTnA7eDDX0PC543EAX/OmP0b+Lk
         cZuDaRZXDOKJXnbobCm7yVK+TA2xWW3i+rma6rjVEwlZb/pd2Qx0F2GPHJpzlyuzLWSy
         n3xOZ8aACYcWlmNimaSpu/ago0GFzDwt2Lknow43ZSyHZNgxqEouaPikNrnuvS4uqeur
         KAPwhwd7Gr+/YVq1tQ7r5hAaQ3dWucl2T3u2kvEBXYJZ5OhLgeVXeEgHxtvIvqxmRrUS
         WWgyan8R4+vqhRhrZdyO3k8zBqlrXd9oVyqlQdDgEKlyPTy5YbxYrhSOjF7w94zZ3qY5
         EIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=kdX+hsqYU8mLAc9/cZ91DQUtrf0mogVuzeFKIjUzm60=;
        b=SfhkAqSQOPPLIiDHGpRtpF1b7+fdBOk8aDYrMp0sfcOhiZ6HO0K0rowFIBGM643Mdz
         mzI/ApYqcWnCzqyqhWwkO1giwPm61JEjW7W87+ep0pEGPjqAuH645Ddlah83LMLmBx+m
         r6ziZXFD/bQhVYguNqHFZzuvFizW7lIbUFb6nhYwDQbiVUbK0K0kumxtfflDA16HcwPd
         K+zeplcJg2y/FQ5CdJ3szfm8yE4e09whv/ImtjpbgoXKjLybK1GhlDo5wbyTRRvgp7ya
         F/qMnSLNpYrY/g+ETQm+3wb9TffenFT5pendvCHj5MI6+XCJQuT8QRYTbTfx1TVmbHaJ
         MFxg==
X-Gm-Message-State: AOAM531Hz6Nkde4Q6tK0OT+h3hGHbC6UbDou+uYf9oDN56NWx6dpsCxU
        i62Z+SXnPN3IQW2P6h6N/hCef/s5FHSDsbN6mnBN4QBNHF85qzd7X31uScjIttqGZ9kjaZPOdyo
        uSWb2ppRP7q24bNFSB6nIaiptdcIMZnT6DVNZLWyHwpHQVs7uYaYOuQ==
X-Google-Smtp-Source: ABdhPJyAFyXv5KtwdxCrRxBywS1rqGGoJQkI9z8fndQuXMtvVu5iMCqWJOSQPdG4lKBeMam+DC9Dm7A=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a05:6214:1801:: with SMTP id
 o1mr5406564qvw.26.1610139745452; Fri, 08 Jan 2021 13:02:25 -0800 (PST)
Date:   Fri,  8 Jan 2021 13:02:20 -0800
Message-Id: <20210108210223.972802-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next v6 0/3] bpf: misc performance improvements for cgroup hooks
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

v6:
- avoid indirect cost for new bpf_bypass_getsockopt (Eric Dumazet)

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

 include/linux/bpf-cgroup.h                    |  63 +++++++----
 include/linux/filter.h                        |   5 +
 include/linux/indirect_call_wrapper.h         |   6 +
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
 net/socket.c                                  |   3 +
 .../selftests/bpf/prog_tests/sockopt_sk.c     |  22 ++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  15 +++
 16 files changed, 217 insertions(+), 52 deletions(-)

-- 
2.30.0.284.gd98b1dd5eaa7-goog

