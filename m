Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7410F13D07F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgAOXEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:04:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:33576 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgAOXEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 18:04:45 -0500
Received: from 11.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.11] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1irriI-0005tU-4Z; Thu, 16 Jan 2020 00:04:38 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-01-15
Date:   Thu, 16 Jan 2020 00:04:37 +0100
Message-Id: <20200115230437.25033-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25696/Wed Jan 15 14:34:23 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 12 non-merge commits during the last 9 day(s) which contain
a total of 13 files changed, 95 insertions(+), 43 deletions(-).

The main changes are:

1) Fix refcount leak for TCP time wait and request sockets for socket lookup
   related BPF helpers, from Lorenz Bauer.

2) Fix wrong verification of ARSH instruction under ALU32, from Daniel Borkmann.

3) Batch of several sockmap and related TLS fixes found while operating
   more complex BPF programs with Cilium and OpenSSL, from John Fastabend.

4) Fix sockmap to read psock's ingress_msg queue before regular sk_receive_queue()
   to avoid purging data upon teardown, from Lingpeng Chen.

5) Fix printing incorrect pointer in bpftool's btf_dump_ptr() in order to properly
   dump a BPF map's value with BTF, from Martin KaFai Lau.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Anatoly Trosinenko, Arika Chen, Jakub Sitnicki, Jonathan Lemon, Martin 
KaFai Lau, Quentin Monnet, Song Liu, Yonghong Song

----------------------------------------------------------------

The following changes since commit da29f2d84bd10234df570b7f07cbd0166e738230:

  net: stmmac: Fixed link does not need MDIO Bus (2020-01-07 13:40:29 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 85ddd9c3173102930c16b0cfe8dbb771af434532:

  Merge branch 'bpf-sockmap-tls-fixes' (2020-01-15 23:26:23 +0100)

----------------------------------------------------------------
Daniel Borkmann (2):
      bpf: Fix incorrect verifier simulation of ARSH under ALU32
      Merge branch 'bpf-sockmap-tls-fixes'

John Fastabend (8):
      bpf: Sockmap/tls, during free we may call tcp_bpf_unhash() in loop
      bpf: Sockmap, ensure sock lock held during tear down
      bpf: Sockmap/tls, push write_space updates through ulp updates
      bpf: Sockmap, skmsg helper overestimates push, pull, and pop bounds
      bpf: Sockmap/tls, msg_push_data may leave end mark in place
      bpf: Sockmap/tls, tls_sw can create a plaintext buf > encrypt buf
      bpf: Sockmap/tls, skmsg can have wrapped skmsg that needs extra chaining
      bpf: Sockmap/tls, fix pop data with SK_DROP return code

Lingpeng Chen (1):
      bpf/sockmap: Read psock ingress_msg before sk_receive_queue

Lorenz Bauer (1):
      net: bpf: Don't leak time wait and request sockets

Martin KaFai Lau (1):
      bpftool: Fix printing incorrect pointer in btf_dump_ptr

 include/linux/skmsg.h          | 13 +++++++++----
 include/linux/tnum.h           |  2 +-
 include/net/tcp.h              |  6 ++++--
 kernel/bpf/tnum.c              |  9 +++++++--
 kernel/bpf/verifier.c          | 13 ++++++++++---
 net/core/filter.c              | 20 ++++++++++----------
 net/core/skmsg.c               |  2 ++
 net/core/sock_map.c            |  7 ++++++-
 net/ipv4/tcp_bpf.c             | 17 +++++++----------
 net/ipv4/tcp_ulp.c             |  6 ++++--
 net/tls/tls_main.c             | 10 +++++++---
 net/tls/tls_sw.c               | 31 +++++++++++++++++++++++++++----
 tools/bpf/bpftool/btf_dumper.c |  2 +-
 13 files changed, 95 insertions(+), 43 deletions(-)
