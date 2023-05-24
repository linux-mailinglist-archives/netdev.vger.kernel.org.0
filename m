Return-Path: <netdev+bounces-5138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13AAB70FC33
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 533E3281373
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895A519E7B;
	Wed, 24 May 2023 17:08:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AC31B8E2;
	Wed, 24 May 2023 17:08:50 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F190912B;
	Wed, 24 May 2023 10:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=D4cj4ZZdyOT5S3r7/Z3040XTriwjqTJ7Iz/MbCrv6KY=; b=kEyS4GQ5EB02BilRFh5sYkfo9G
	nUc+0/nkt8AGMdZxzRFR+Hh9aBSvcgaXWNmcRH3Soxef4Bmsee5/5Kwb/iNpaSRuUnBgjKYHShW6o
	I1VIosvWffSCs9DCVqd5bF5Kpco9jEnQs/9QhZ0maKM4AlRx+oeBbcqPCO1qK7tubLXGguHTeJXiA
	tZdkBSbcSK8uu4lVeL+RETTro/mJSwLrZ+plYr1E70HRWMCsm7pNixgofJHkkNcQOsaT/PB9Zokur
	jFt+NAHswMcMty9qb6tcFPt3ccwj6SsIA+uTbKitB3E5TeSEG389URJfZO3/9GyHgFl3N5P/pW4eP
	zpqlnWkg==;
Received: from 28.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.28] helo=localhost)
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q1rya-000D5M-Ei; Wed, 24 May 2023 19:08:40 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
To: davem@davemloft.net
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	daniel@iogearbox.net,
	ast@kernel.org,
	andrii@kernel.org,
	martin.lau@linux.dev,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: pull-request: bpf 2023-05-24
Date: Wed, 24 May 2023 19:08:39 +0200
Message-Id: <20230524170839.13905-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26917/Wed May 24 09:28:43 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 19 non-merge commits during the last 10 day(s) which contain
a total of 20 files changed, 738 insertions(+), 448 deletions(-).

The main changes are:

1) Batch of BPF sockmap fixes found when running against NGINX TCP tests, from John Fastabend.

2) Fix a memleak in the LRU{,_PERCPU} hash map when bucket locking fails, from Anton Protopopov.

3) Init the BPF offload table earlier than just late_initcall, from Jakub Kicinski.

4) Fix ctx access mask generation for 32-bit narrow loads of 64-bit fields, from Will Deacon.

5) Remove a now unsupported __fallthrough in BPF samples, from Andrii Nakryiko.

6) Fix a typo in pkg-config call for building sign-file, from Jeremy Sowden.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Jakub Sitnicki, Roberto Sassu, Stanislav Fomichev, William Findlay, 
Yonghong Song

----------------------------------------------------------------

The following changes since commit b41caaded077aa8e7617c15e87d0503df8e7739e:

  Merge branch 'hns3-fixes' (2023-05-13 17:12:24 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to f726e03564ef4e754dd93beb54303e2e1671049e:

  bpf, sockmap: Test progs verifier error with latest clang (2023-05-23 16:11:27 +0200)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Andrii Nakryiko (1):
      samples/bpf: Drop unnecessary fallthrough

Anton Protopopov (1):
      bpf: fix a memory leak in the LRU and LRU_PERCPU hash maps

Jakub Kicinski (1):
      bpf: netdev: init the offload table earlier

Jeremy Sowden (1):
      selftests/bpf: Fix pkg-config call building sign-file

John Fastabend (14):
      bpf, sockmap: Pass skb ownership through read_skb
      bpf, sockmap: Convert schedule_work into delayed_work
      bpf, sockmap: Reschedule is now done through backlog
      bpf, sockmap: Improved check for empty queue
      bpf, sockmap: Handle fin correctly
      bpf, sockmap: TCP data stall on recv before accept
      bpf, sockmap: Wake up polling after data copy
      bpf, sockmap: Incorrectly handling copied_seq
      bpf, sockmap: Pull socket helpers out of listen test for general use
      bpf, sockmap: Build helper to create connected socket pair
      bpf, sockmap: Test shutdown() correctly exits epoll and recv()=0
      bpf, sockmap: Test FIONREAD returns correct bytes in rx buffer
      bpf, sockmap: Test FIONREAD returns correct bytes in rx buffer with drops
      bpf, sockmap: Test progs verifier error with latest clang

Will Deacon (1):
      bpf: Fix mask generation for 32-bit narrow loads of 64-bit fields

 include/linux/skmsg.h                              |   3 +-
 include/net/tcp.h                                  |  10 +
 kernel/bpf/hashtab.c                               |   6 +-
 kernel/bpf/offload.c                               |   2 +-
 kernel/bpf/verifier.c                              |   2 +-
 net/core/skmsg.c                                   |  81 ++---
 net/core/sock_map.c                                |   3 +-
 net/ipv4/tcp.c                                     |  11 +-
 net/ipv4/tcp_bpf.c                                 |  79 ++++-
 net/ipv4/udp.c                                     |   7 +-
 net/unix/af_unix.c                                 |   7 +-
 net/vmw_vsock/virtio_transport_common.c            |   5 +-
 samples/bpf/hbm.c                                  |   1 -
 tools/testing/selftests/bpf/Makefile               |   2 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       | 131 +++++++
 .../selftests/bpf/prog_tests/sockmap_helpers.h     | 390 +++++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 370 +------------------
 .../selftests/bpf/progs/test_sockmap_drop_prog.c   |  32 ++
 .../selftests/bpf/progs/test_sockmap_kern.h        |  12 +-
 .../selftests/bpf/progs/test_sockmap_pass_prog.c   |  32 ++
 20 files changed, 738 insertions(+), 448 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

