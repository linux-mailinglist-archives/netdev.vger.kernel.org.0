Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93413B2217
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFWU5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:57:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:36430 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhFWU5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 16:57:01 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lw9tR-000AgR-Ht; Wed, 23 Jun 2021 22:54:41 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-06-23
Date:   Wed, 23 Jun 2021 22:54:41 +0200
Message-Id: <20210623205441.29571-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26210/Wed Jun 23 13:10:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 14 non-merge commits during the last 6 day(s) which contain
a total of 13 files changed, 137 insertions(+), 64 deletions(-).

Note that when you merge net into net-next, there is a small merge conflict
between 9f2470fbc4cb ("skmsg: Improve udp_bpf_recvmsg() accuracy") from bpf
with c49661aa6f70 ("skmsg: Remove unused parameters of sk_msg_wait_data()")
from net-next. Resolution is to: i) net/ipv4/udp_bpf.c: take udp_msg_wait_data()
and remove err parameter from the function, ii) net/ipv4/tcp_bpf.c: take
tcp_msg_wait_data() and remove err parameter from the function, iii) for
net/core/skmsg.c and include/linux/skmsg.h: remove the sk_msg_wait_data()
implementation and its prototype in header.

The main changes are:

1) Fix BPF poke descriptor adjustments after insn rewrite, from John Fastabend.

2) Fix regression when using BPF_OBJ_GET with non-O_RDWR flags, from Maciej Żenczykowski.

3) Various bug and error handling fixes for UDP-related sock_map, from Cong Wang.

4) Fix patching of vmlinux BTF IDs with correct endianness, from Tony Ambardar.

5) Two fixes for TX descriptor validation in AF_XDP, from Magnus Karlsson.

6) Fix overflow in size calculation for bpf_map_area_alloc(), from Bui Quang Minh.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Björn Töpel, Daniel Borkmann, Greg Kroah-Hartman, Jakub Sitnicki, Jiang 
Wang, Jiri Olsa, John Fastabend, Jussi Maki, Lorenz Bauer, Xuan Zhuo

----------------------------------------------------------------

The following changes since commit 1c200f832e14420fa770193f9871f4ce2df00d07:

  net: qed: Fix memcpy() overflow of qed_dcbx_params() (2021-06-17 12:14:51 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 7506d211b932870155bcb39e3dd9e39fab45a7c7:

  bpf: Fix null ptr deref with mixed tail calls and subprogs (2021-06-22 14:46:39 -0700)

----------------------------------------------------------------
Bui Quang Minh (1):
      bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc

Cong Wang (8):
      skmsg: Improve udp_bpf_recvmsg() accuracy
      selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
      udp: Fix a memory leak in udp_read_sock()
      skmsg: Clear skb redirect pointer before dropping it
      skmsg: Fix a memory leak in sk_psock_verdict_apply()
      skmsg: Teach sk_psock_verdict_apply() to return errors
      skmsg: Pass source psock to sk_psock_skb_redirect()
      skmsg: Increase sk->sk_drops when dropping packets

John Fastabend (1):
      bpf: Fix null ptr deref with mixed tail calls and subprogs

Maciej Żenczykowski (1):
      bpf: Fix regression on BPF_OBJ_GET with non-O_RDWR flags

Magnus Karlsson (2):
      xsk: Fix missing validation for skb and unaligned mode
      xsk: Fix broken Tx ring validation

Tony Ambardar (1):
      bpf: Fix libelf endian handling in resolv_btfids

 include/linux/skmsg.h                              |  2 -
 include/net/xsk_buff_pool.h                        |  9 ++-
 kernel/bpf/devmap.c                                |  4 +-
 kernel/bpf/inode.c                                 |  2 +-
 kernel/bpf/verifier.c                              |  6 +-
 net/core/skmsg.c                                   | 82 ++++++++++------------
 net/core/sock_map.c                                |  2 +-
 net/ipv4/tcp_bpf.c                                 | 24 ++++++-
 net/ipv4/udp.c                                     |  2 +
 net/ipv4/udp_bpf.c                                 | 47 +++++++++++--
 net/xdp/xsk_queue.h                                | 11 +--
 tools/bpf/resolve_btfids/main.c                    |  3 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  7 +-
 13 files changed, 137 insertions(+), 64 deletions(-)
