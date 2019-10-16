Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15FBD8507
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbfJPAsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:48:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53490 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfJPAsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:48:13 -0400
Received: from [213.220.153.21] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iKXU2-0006Y2-T7; Wed, 16 Oct 2019 00:48:10 +0000
Date:   Wed, 16 Oct 2019 02:48:10 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH v2 0/3] bpf: switch to new usercopy helpers
Message-ID: <20191016004809.tgw6zznr6ukppplp@wittgenstein>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
 <20191016004138.24845-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191016004138.24845-1-christian.brauner@ubuntu.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 02:41:35AM +0200, Christian Brauner wrote:
> Hey everyone,
> 
> In v5.4-rc2 we added two new helpers check_zeroed_user() and
> copy_struct_from_user() including selftests (cf. [1]). It is a generic
> interface designed to copy a struct from userspace. The helpers will be
> especially useful for structs versioned by size of which we have quite a
> few.
> 
> The most obvious benefit is that this helper lets us get rid of
> duplicate code. We've already switched over sched_setattr(), perf_event_open(),
> and clone3(). More importantly it will also help to ensure that users
> implementing versioning-by-size end up with the same core semantics.
> 
> This point is especially crucial since we have at least one case where
> versioning-by-size is used but with slighly different semantics:
> sched_setattr(), perf_event_open(), and clone3() all do do similar
> checks to copy_struct_from_user() while rt_sigprocmask(2) always rejects
> differently-sized struct arguments.
> 
> This little series switches over bpf codepaths that have hand-rolled
> implementations of these helpers.
> 
> Thanks!
> Christian
> 
> /* v1 */
> Link: https://lore.kernel.org/r/20191009160907.10981-1-christian.brauner@ubuntu.com
> 
> /* v2 */
> - rebase onto bpf-next
> 
> /* Reference */
> [1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")

Alexei, instead of applying the series you can also just pull from me:

The following changes since commit 5bc60de50dfea235634fdf38cbc992fb968d113b:

  selftests: bpf: Don't try to read files without read permission (2019-10-15 16:27:25 -0700)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/brauner/linux tags/bpf-copy-struct-from-user

for you to fetch changes up to da1699b959d182bb161be3ffc17eab063b2aedd2:

  bpf: use copy_struct_from_user() in bpf() syscall (2019-10-16 02:35:11 +0200)

----------------------------------------------------------------
bpf-copy-struct-from-user

----------------------------------------------------------------
Christian Brauner (3):
      bpf: use check_zeroed_user() in bpf_check_uarg_tail_zero()
      bpf: use copy_struct_from_user() in bpf_prog_get_info_by_fd()
      bpf: use copy_struct_from_user() in bpf() syscall

 kernel/bpf/syscall.c | 46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)
