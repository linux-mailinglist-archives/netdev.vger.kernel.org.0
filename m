Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07042791A2
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfG2Q7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:59:31 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:41406 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfG2Q7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:59:31 -0400
Received: by mail-pg1-f170.google.com with SMTP id x15so18214042pgg.8;
        Mon, 29 Jul 2019 09:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HwQca4G8mndpvQA6ds1RjHCaohNFPGEGRkLsQ9Pc2OQ=;
        b=Rp2By3sVd1OhM+wvUrxrzoGEJt9DA2Jbz/5kowB42lJ/ZeafAfvVvNENzDQNuLyrl7
         1lT5huO4Ej7lhabCg6aqFGROBks70co5mk0gLYALT1Q5dNa9pPPaC0CDAUgdzAhXp/K/
         QusJLual8AFwSfVr9b98PyS9wfyDLSDo7IVjVPfwZSgZ5r6ueDsjg+H9FKLe9Bk41JpI
         7XHv8Y+ihI97s4SU6Bq3C3YRVQYdDxtwi9WzM6BylzfQd88UB7ZmGhL2Dj5rlu6qFCS1
         9nBEkNzUrEy6RGWhwQVYAWl6r23ej/7oFQUzVF4ILNn/7q8/iI32zEyUNSZtN5oydmn8
         3TQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HwQca4G8mndpvQA6ds1RjHCaohNFPGEGRkLsQ9Pc2OQ=;
        b=YS1EO4BlHPgr7pjvCM7ft9wh+0qglvj/TN0EmVmP+Qc2zdNIhdJN6W+wFks+4hIo6Q
         xj2kvHgCOfb1X5wY4S6sCk7GWdIY+QKxGyGaGqmIQLuMrWYTjDcVrqHQ41RitzuGKukG
         IoufnnwbVHktT6Pmy4aYxWtwJTgnFl1uY805v7uBXo1z2XCJRWdYdS6EDVOXFgRwsf36
         JCiC3hFXFNKnrqfzQ86Itai6dgSvMsQj8TJgfWe++1lzHOwsIHdE0CcbAxLeLaK+g0n2
         AG15ch6bo+m8mfyqLvY8xGd+EnyBMHCeb/TjYKV6M7GMZ+S8vxcVSuOwY+E+oYhmWTWf
         QAcQ==
X-Gm-Message-State: APjAAAVxfXrEubhKuE9U3uMn96cU6GvjO/DGI5wR//5Wzpq0mRDozSl7
        wPpOCfjVCIZ8GjXb10VZtIfRAyMj
X-Google-Smtp-Source: APXvYqxOVe6JKJAQiFRvwwUpEtd3hJr3/b8/MKK+fk+YLW7RyVdm4p4/2aOiFCy+UINpaBPw0ImU/A==
X-Received: by 2002:aa7:8b10:: with SMTP id f16mr38140955pfd.44.1564419570775;
        Mon, 29 Jul 2019 09:59:30 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id i198sm60784651pgd.44.2019.07.29.09.59.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:59:30 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        toke@redhat.com, Petar Penkov <ppenkov@google.com>
Subject: [bpf-next,v2 0/6] Introduce a BPF helper to generate SYN cookies
Date:   Mon, 29 Jul 2019 09:59:12 -0700
Message-Id: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

This patch series introduces a BPF helper function that allows generating SYN
cookies from BPF. Currently, this helper is enabled at both the TC hook and the
XDP hook.

The first two patches in the series add/modify several TCP helper functions to
allow for SKB-less operation, as is the case at the XDP hook.

The third patch introduces the bpf_tcp_gen_syncookie helper function which
generates a SYN cookie for either XDP or TC programs. The return value of
this function contains both the MSS value, encoded in the cookie, and the
cookie itself.

The last three patches sync tools/ and add a test. 

Performance evaluation:
I sent 10Mpps to a fixed port on a host with 2 10G bonded Mellanox 4 NICs from
random IPv6 source addresses. Without XDP I observed 7.2Mpps (syn-acks) being
sent out if the IPv6 packets carry 20 bytes of TCP options or 7.6Mpps if they
carry no options. If I attached a simple program that checks if a packet is
IPv6/TCP/SYN, looks up the socket, issues a cookie, and sends it back out after
swapping src/dest, recomputing the checksum, and setting the ACK flag, I
observed 10Mpps being sent back out.

Changes since v1:
1/ Added performance numbers to the cover letter
2/ Patch 2: Refactored a bit to fix compilation issues
3/ Patch 3: Changed ENOTSUPP to EOPNOTSUPP at Toke's suggestion

Changes since RFC:
1/ Cookie is returned in host order at Alexei's suggestion
2/ If cookies are not enabled via a sysctl, the helper function returns
   -ENOENT instead of -EINVAL at Lorenz's suggestion
3/ Fixed documentation to properly reflect that MSS is 16 bits at
   Lorenz's suggestion
4/ BPF helper requires TCP length to match ->doff field, rather than to simply
   be no more than 20 bytes at Eric and Alexei's suggestion
5/ Packet type is looked up from the packet version field, rather than from the
   socket. v4 packets are rejected on v6-only sockets but should work with
   dual stack listeners at Eric's suggestion
6/ Removed unnecessary `net` argument from helper function in patch 2 at
   Lorenz's suggestion 
7/ Changed test to only pass MSS option so we can convince the verifier that the
   memory access is not out of bounds

Note that 7/ below illustrates the verifier might need to be extended to allow
passing a variable tcph->doff to the helper function like below:

__u32 thlen = tcph->doff * 4;
if (thlen < sizeof(*tcph))
	return;
__s64 cookie = bpf_tcp_gen_syncookie(sk, ipv4h, 20, tcph, thlen);

Petar Penkov (6):
  tcp: tcp_syn_flood_action read port from socket
  tcp: add skb-less helpers to retrieve SYN cookie
  bpf: add bpf_tcp_gen_syncookie helper
  bpf: sync bpf.h to tools/
  selftests/bpf: bpf_tcp_gen_syncookie->bpf_helpers
  selftests/bpf: add test for bpf_tcp_gen_syncookie

 include/net/tcp.h                             | 10 +++
 include/uapi/linux/bpf.h                      | 30 ++++++-
 net/core/filter.c                             | 73 +++++++++++++++++
 net/ipv4/tcp_input.c                          | 81 +++++++++++++++++--
 net/ipv4/tcp_ipv4.c                           | 15 ++++
 net/ipv6/tcp_ipv6.c                           | 15 ++++
 tools/include/uapi/linux/bpf.h                | 37 ++++++++-
 tools/testing/selftests/bpf/bpf_helpers.h     |  3 +
 .../bpf/progs/test_tcp_check_syncookie_kern.c | 48 +++++++++--
 .../selftests/bpf/test_tcp_check_syncookie.sh |  3 +
 .../bpf/test_tcp_check_syncookie_user.c       | 61 ++++++++++++--
 11 files changed, 354 insertions(+), 22 deletions(-)

-- 
2.22.0.709.g102302147b-goog

