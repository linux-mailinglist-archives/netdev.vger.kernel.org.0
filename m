Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8106C7361
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 23:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCWWx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 18:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjCWWxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 18:53:09 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F2044B8;
        Thu, 23 Mar 2023 15:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=ZqWjU9RRGCADg83xb00T5V8XSGTOh7Deav1BbmgnMts=; b=MGY2wq6woKecTx1gDnmy3MU9Mk
        pJcNgQGYWXfQ3EeyTl/UY8vmmTPwSNBhvXrA922Ph3jUJEqnT05ChB4ZGzHZQNpnDyz99HZ6LGHEX
        SPus77m1b0mnXbllrf/TxspLJiPU/Rr7Nbf31waETA8m65ggBztIsrDZi5691AOvxLrZ5Fe/WlcIN
        lES2jYj/zRufZVUznjCj0tFOuMlxULcnH4ls8AUwofVXS5QT8XhDM1lDnmUkL0YRe5EQIGC4xAlRQ
        BqVkTQKvbmLAo75Zl4eM3W3v+oUhOzq8GpTGMkPSXvgdbqfnnpArsyxZqP/Am+/5XE7vSgrwzajis
        XfEOMfyA==;
Received: from mob-194-230-145-58.cgn.sunrise.net ([194.230.145.58] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pfTnC-00053F-Lm; Thu, 23 Mar 2023 23:52:23 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2023-03-23
Date:   Thu, 23 Mar 2023 23:52:21 +0100
Message-Id: <20230323225221.6082-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26852/Thu Mar 23 08:22:35 2023)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 8 non-merge commits during the last 13 day(s) which contain
a total of 21 files changed, 238 insertions(+), 161 deletions(-).

The main changes are:

1) Fix verification issues in some BPF programs due to their stack usage
   patterns, from Eduard Zingerman.

2) Fix to add missing overflow checks in xdp_umem_reg and return an error
   in such case, from Kal Conley.

3) Fix and undo poisoning of strlcpy in libbpf given it broke builds for
   libcs which provided the former like uClibc-ng, from Jesus Sanchez-Palencia.

4) Fix insufficient bpf_jit_limit default to avoid users running into hard
   to debug seccomp BPF errors, from Daniel Borkmann.

5) Fix driver return code when they don't support a bpf_xdp_metadata kfunc
   to make it unambiguous from other errors, from Jesper Dangaard Brouer.

6) Two BPF selftest fixes to address compilation errors from recent changes
   in kernel structures, from Alexei Starovoitov.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Kuniyuki Iwashima, Lefteris Alexakis, Magnus Karlsson, 
Stanislav Fomichev, Stephen Haynes, Tariq Toukan, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit bced3f7db95ff2e6ca29dc4d1c9751ab5e736a09:

  tcp: tcp_make_synack() can be called from process context (2023-03-09 23:12:00 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to 915efd8a446b74442039d31689d5d863caf82517:

  xdp: bpf_xdp_metadata use EOPNOTSUPP for no driver support (2023-03-22 09:11:09 -0700)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (4):
      Merge branch 'bpf: Allow reads from uninit stack'
      selftests/bpf: Fix progs/find_vma_fail1.c build error.
      selftests/bpf: Fix progs/test_deny_namespace.c issues.
      Merge branch 'bpf: Allow reads from uninit stack'

Daniel Borkmann (1):
      bpf: Adjust insufficient default bpf_jit_limit

Eduard Zingerman (2):
      bpf: Allow reads from uninit stack
      selftests/bpf: Tests for uninitialized stack reads

Jesper Dangaard Brouer (1):
      xdp: bpf_xdp_metadata use EOPNOTSUPP for no driver support

Jesus Sanchez-Palencia (1):
      libbpf: Revert poisoning of strlcpy

Kal Conley (1):
      xsk: Add missing overflow check in xdp_umem_reg

 Documentation/networking/xdp-rx-metadata.rst       |   7 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   4 +-
 drivers/net/veth.c                                 |   4 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/verifier.c                              |  11 ++-
 net/core/xdp.c                                     |  10 +-
 net/xdp/xdp_umem.c                                 |  13 +--
 tools/lib/bpf/libbpf_internal.h                    |   4 +-
 .../selftests/bpf/prog_tests/uninit_stack.c        |   9 ++
 tools/testing/selftests/bpf/progs/find_vma_fail1.c |   1 +
 .../selftests/bpf/progs/test_deny_namespace.c      |  10 +-
 .../selftests/bpf/progs/test_global_func10.c       |   8 +-
 tools/testing/selftests/bpf/progs/uninit_stack.c   |  87 +++++++++++++++++
 tools/testing/selftests/bpf/verifier/calls.c       |  13 ++-
 .../selftests/bpf/verifier/helper_access_var_len.c | 104 ++++++++++++++-------
 tools/testing/selftests/bpf/verifier/int_ptr.c     |   9 +-
 .../selftests/bpf/verifier/search_pruning.c        |  13 ++-
 tools/testing/selftests/bpf/verifier/sock.c        |  27 ------
 tools/testing/selftests/bpf/verifier/spill_fill.c  |   7 +-
 tools/testing/selftests/bpf/verifier/var_off.c     |  52 -----------
 21 files changed, 238 insertions(+), 161 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uninit_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/uninit_stack.c
