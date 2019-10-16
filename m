Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B910D86ED
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387808AbfJPDpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:45:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55611 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfJPDot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:44:49 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iKaEw-0000Wg-GC; Wed, 16 Oct 2019 03:44:46 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     christian.brauner@ubuntu.com
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: [PATCH v3 0/3] bpf: switch to new usercopy helpers
Date:   Wed, 16 Oct 2019 05:44:29 +0200
Message-Id: <20191016034432.4418-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016004138.24845-1-christian.brauner@ubuntu.com>
References: <20191016004138.24845-1-christian.brauner@ubuntu.com>
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

This series can also be pulled:

The following changes since commit 5bc60de50dfea235634fdf38cbc992fb968d113b:

  selftests: bpf: Don't try to read files without read permission (2019-10-15 16:27:25 -0700)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/brauner/linux tags/bpf-copy-struct-from-user

for you to fetch changes up to 31a197d406cc01451e98312665d116c2dbb08202:

  bpf: use copy_struct_from_user() in bpf() syscall (2019-10-16 05:32:38 +0200)

----------------------------------------------------------------
bpf-copy-struct-from-user

----------------------------------------------------------------
Christian Brauner (3):
      bpf: use check_zeroed_user() in bpf_check_uarg_tail_zero()
      bpf: use copy_struct_from_user() in bpf_prog_get_info_by_fd()
      bpf: use copy_struct_from_user() in bpf() syscall

 kernel/bpf/syscall.c | 45 ++++++++++++++++-----------------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

Thanks!
Christian

/* v1 */
Link: https://lore.kernel.org/r/20191009160907.10981-1-christian.brauner@ubuntu.com

/* v2 */
Link: https://lore.kernel.org/r/20191016004138.24845-1-christian.brauner@ubuntu.com
- rebase onto bpf-next

/* Reference */
[1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")

Christian Brauner (3):
  bpf: use check_zeroed_user() in bpf_check_uarg_tail_zero()
  bpf: use copy_struct_from_user() in bpf_prog_get_info_by_fd()
  bpf: use copy_struct_from_user() in bpf() syscall

 kernel/bpf/syscall.c | 45 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

-- 
2.23.0

