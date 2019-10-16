Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B8FD8F37
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392737AbfJPLTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:19:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40229 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392704AbfJPLTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 07:19:20 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iKhKo-0003tb-0H; Wed, 16 Oct 2019 11:19:18 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     christian.brauner@ubuntu.com
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: [PATCH bpf-next v4 0/3] bpf: switch to new usercopy helpers
Date:   Wed, 16 Oct 2019 13:18:07 +0200
Message-Id: <20191016111810.1799-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016034432.4418-1-christian.brauner@ubuntu.com>
References: <20191016034432.4418-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

This is v4. If you still feel that I should leave this code alone then
simply ignore it. I won't send another version. Relevant tests pass and
I've verified that other failures were already present without this
patch series applied.

The misplaced min check has been moved after copy_struct_from_user() so
no non-zero bytes can be missed by copy_struct_from_user().

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

/* v1 */
Link: https://lore.kernel.org/r/20191009160907.10981-1-christian.brauner@ubuntu.com

/* v2 */
Link: https://lore.kernel.org/r/20191016004138.24845-1-christian.brauner@ubuntu.com
- rebase onto bpf-next

/* v3 */
Link: https://lore.kernel.org/r/20191016034432.4418-1-christian.brauner@ubuntu.com

/* Reference */
[1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")

Christian Brauner (3):
  bpf: use check_zeroed_user() in bpf_check_uarg_tail_zero()
  bpf: use copy_struct_from_user() in bpf_prog_get_info_by_fd()
  bpf: use copy_struct_from_user() in bpf() syscall

 kernel/bpf/syscall.c | 39 ++++++++++++---------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

-- 
2.23.0

