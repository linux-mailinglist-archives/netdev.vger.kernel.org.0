Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358BBD139C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbfJIQJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:09:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41922 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731666AbfJIQJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:09:17 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iIEWW-00034Q-P7; Wed, 09 Oct 2019 16:09:12 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 0/3] bpf: switch to new usercopy helpers
Date:   Wed,  9 Oct 2019 18:09:04 +0200
Message-Id: <20191009160907.10981-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

In v5.4-rc2 we added two new helpers check_zeroed_user() and
copy_struct_from_user() including selftests (cf. [1]). It is a generic
interface designed to copy a struct from userspace. The helpers will be
especially useful for structs versioned by size of which we have quite a
few.

The most obvious benefit is that this helper lets us get rid of
duplicate code. We've already switched over sched_setattr(), perf_event_open(),
and clone3(). More importantly it will also help to ensure that users
implementing versioning-by-size end up with the same core semantics.

This point is especially crucial since we have at least one case where
versioning-by-size is used but with slighly different semantics:
sched_setattr(), perf_event_open(), and clone3() all do do similar
checks to copy_struct_from_user() while rt_sigprocmask(2) always rejects
differently-sized struct arguments.

This little series switches over bpf codepaths that have hand-rolled
implementations of these helpers.

Thanks!
Christian

/* Reference */
[1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")

Christian Brauner (3):
  bpf: use check_zeroed_user() in bpf_check_uarg_tail_zero()
  bpf: use copy_struct_from_user() in bpf_prog_get_info_by_fd()
  bpf: use copy_struct_from_user() in bpf() syscall

 kernel/bpf/syscall.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

-- 
2.23.0

