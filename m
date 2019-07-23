Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4E970E05
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 02:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbfGWAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 20:20:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39654 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfGWAUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 20:20:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so18446126pgi.6;
        Mon, 22 Jul 2019 17:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0xhjJk9JutdUe9pYSoLFbl1Osw7dur0qzvQ5sDJY9E=;
        b=DLw6Mr/rVhxhfjdUvim9O+CgBQPm2Zb8z5OHKhHLv4s4LP0jmuvHg5yyyCmWk3Az0v
         m0yM2AJ44Ekw5fxspoyipnty6u15RDCGS5Jx71dL3osafHWYZGbEzXF6L484EuJs9VCH
         bkvtf4crd/h4MUS6XxU3aanpEc0HxymY6zK5Y12axdhgJLPyW9J+W2R1AczAYVnRXtXo
         p0AVhVpujD8ixvozmV8dTKnkDJNv4f7RaZpyIdE0Mh4H2UMF2M224qAhZANR4hNjM3OJ
         Nb2S2mRrwdzeI7/Jb9WILe38IsJnjPHtqj9UI/hqx4GkDOVyizuoelwRTBYYwXxP3uzx
         LgfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0xhjJk9JutdUe9pYSoLFbl1Osw7dur0qzvQ5sDJY9E=;
        b=mJT8BNHkGFkT3ebjBGtdlJUtbzom6mJ1rF3LXvrveqmuV+S0e0A4yNxx12vvyS004H
         fFK31axMYNp4B2ztO3RW6adsCOz5duTtw34b3ecul+hvQGQwmKTE6zXku/SLnlCIIdKC
         xk7Wp3D7nlouxeRsO3A3JI7CGFirpZ3rp8u4SC0GgeGmCBykZwWVDx3TsRx2ASnQFiM5
         hcCItziw07reFy9Fk4lvu3uS1DcKGCjToy03iAqYFeDEliOrQ5TgImlXTQ+9ieTqnNgw
         l2vVpigHzBuJ0d5l1l2B/AEnQUF0wHprqLZoWnRG7swrcqnNcN+dL2PGbt2S6r7GCUIi
         J6Hg==
X-Gm-Message-State: APjAAAUqHenDfOidW4rT8tFW2Yhz1BRLvCuWMRYcMnpS1ZU872nB4AvK
        WE1m+lOoi4WJ//ACl+XjhrSvtt33
X-Google-Smtp-Source: APXvYqyDX2Xf+QLL0q3tlKsB+3S+otlBbmEDZ3HZgEKBCRjcW5/c1//v6EuO5z0zMMxOHf8iCbLygQ==
X-Received: by 2002:a63:df06:: with SMTP id u6mr20822616pgg.96.1563841248110;
        Mon, 22 Jul 2019 17:20:48 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id k64sm21718423pge.65.2019.07.22.17.20.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 17:20:47 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next 0/6] Introduce a BPF helper to generate SYN cookies
Date:   Mon, 22 Jul 2019 17:20:36 -0700
Message-Id: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
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

 include/net/tcp.h                             | 11 +++
 include/uapi/linux/bpf.h                      | 30 ++++++-
 net/core/filter.c                             | 73 ++++++++++++++++
 net/ipv4/tcp_input.c                          | 84 +++++++++++++++++--
 net/ipv4/tcp_ipv4.c                           |  8 ++
 net/ipv6/tcp_ipv6.c                           |  8 ++
 tools/include/uapi/linux/bpf.h                | 37 +++++++-
 tools/testing/selftests/bpf/bpf_helpers.h     |  3 +
 .../bpf/progs/test_tcp_check_syncookie_kern.c | 48 +++++++++--
 .../selftests/bpf/test_tcp_check_syncookie.sh |  3 +
 .../bpf/test_tcp_check_syncookie_user.c       | 61 ++++++++++++--
 11 files changed, 344 insertions(+), 22 deletions(-)

-- 
2.22.0.657.g960e92d24f-goog

