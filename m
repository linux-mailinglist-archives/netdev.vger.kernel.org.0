Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3198B509474
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383449AbiDUAli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383442AbiDUAlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:41:36 -0400
Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814CE1FCE1
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:38:48 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:38:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501526;
        bh=4GTttWDfJYdIyN4JnjdzUqDEPsjVASx62ghec4ZucVs=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:Feedback-ID:From:To:
         Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID;
        b=qL5dFXPhkh57Vcc1BrM9Ufz2NB2toIFkmiwNvdOBmQsiUPPnyoYvsxUXix28fbFrn
         7fKeW20kIYi4WGviDH1bM4V3gw6Y/Hpitp/AyzKDGg5yVoR9LpBj9/2uqsGfF9gws8
         +ZDJ2I+Pn0fXdvyj/UU/fko/SQyA4tUjagb+pGCOCxU5E52oa9q9OcNcOIEanXAXuO
         3WoHGAE1Gw8qH37qvBFyhyhBk/GLO1+baJZ1P24XxTukwvBnF5oB74vqh+UDBHDca5
         iq5jbD1qeYj1Nd6cMoPDz2YwQzO/iSP/OQL6XO0MIl66HhkyPKu9CWfSnW7eeE30W9
         PrjYR3TxdJs5A==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 bpf 00/11] bpf: random unpopular userspace fixes (32 bit et al)
Message-ID: <20220421003152.339542-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This mostly issues the cross build (1) errors for 32 bit (2)
MIPS (3) with minimal configuration (4) on Musl (5). The majority
of them aren't yesterday's, so it is a "who does need it outside
of x86_64 or ARM64?" moment again.
Trivial stuff in general, not counting the first three (they are
50/50).

From v1[0]:
 - use *___local struct definitions for BPF programs instead of
   BTF_TYPE_EMIT() and ifdef-play (Andrii);
 - cast uin64_t to unsigned long long to *really* fix the format
   literal warnings (Song, David, Andrii);
 - collect Acked-bys for the rest (Maciej, Kumar, Song);
 - adjust the subjects to match their usual look (Andrii);
 - expand the commit messages a bit for 0008
   (-Wshift-count-overflow) and 0010 (-Wsequence-point) a bit to
   mention they actually mitigate the third-party issues (Andrii);
 - rebase and send to bpf instead of bpf-next (hope the first three
   are okay for it).

[0] https://lore.kernel.org/bpf/20220414223704.341028-1-alobakin@pm.me

Alexander Lobakin (11):
  bpftool: use a local copy of perf_event to fix accessing ::bpf_cookie
  bpftool: define a local bpf_perf_link to fix accessing its fields
  bpftool: use a local bpf_perf_event_value to fix accessing its fields
  bpftool: fix fcntl.h include
  samples/bpf: add 'asm/mach-generic' include path for every MIPS
  samples/bpf: use host bpftool to generate vmlinux.h, not target
  samples/bpf: fix uin64_t format literals
  samples/bpf: fix false-positive right-shift underflow warnings
  samples/bpf: fix include order for non-Glibc environments
  samples/bpf: fix -Wsequence-point
  samples/bpf: xdpsock: fix -Wmaybe-uninitialized

 samples/bpf/Makefile                      |  7 +++---
 samples/bpf/cookie_uid_helper_example.c   | 12 +++++-----
 samples/bpf/lathist_kern.c                |  2 +-
 samples/bpf/lwt_len_hist_kern.c           |  2 +-
 samples/bpf/lwt_len_hist_user.c           |  7 +++---
 samples/bpf/task_fd_query_user.c          |  2 +-
 samples/bpf/test_lru_dist.c               |  3 ++-
 samples/bpf/tracex2_kern.c                |  2 +-
 samples/bpf/xdpsock_user.c                |  5 +++--
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 15 ++++++++++---
 tools/bpf/bpftool/skeleton/profiler.bpf.c | 27 ++++++++++++++---------
 tools/bpf/bpftool/tracelog.c              |  2 +-
 12 files changed, 53 insertions(+), 33 deletions(-)

--
2.36.0


