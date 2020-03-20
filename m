Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1B718CAA6
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCTJsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgCTJsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 05:48:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3552120722;
        Fri, 20 Mar 2020 09:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584697696;
        bh=CfioL5SgWVxnMWSZEYwxxiCuwgFHpHsY1vWlT//2mOg=;
        h=Date:From:To:Cc:Subject:From;
        b=UooNi+ytRvi/e+67VIo7Tl5Xwm1Su706JYHFNuSsA/I6bYceFPxJ3ngvGOu/t2KdB
         pWNEXe36lZwD0sereY3Hwq3aONMdiovgegCvF1oy8CTO6LvIk51arxlAC4HQkm/chT
         ni9qcc87pdpOgBNabveKUGSodr5q4K/nKgHVjaJY=
Date:   Fri, 20 Mar 2020 10:48:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
Subject: [PATCH] bpf: explicitly memset the bpf_attr structure
Message-ID: <20200320094813.GA421650@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the bpf syscall, we are relying on the compiler to properly zero out
the bpf_attr union that we copy userspace data into.  Unfortunately that
doesn't always work properly, padding and other oddities might not be
correctly zeroed, and in some tests odd things have been found when the
stack is pre-initialized to other values.

Fix this by explicitly memsetting the structure to 0 before using it.

Reported-by: Maciej Żenczykowski <maze@google.com>
Reported-by: John Stultz <john.stultz@linaro.org>
Reported-by: Alexander Potapenko <glider@google.com>
Reported-by: Alistair Delva <adelva@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://android-review.googlesource.com/c/kernel/common/+/1235490
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a91ad518c050..a4b1de8ea409 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3354,7 +3354,7 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
-	union bpf_attr attr = {};
+	union bpf_attr attr;
 	int err;
 
 	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
@@ -3366,6 +3366,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	size = min_t(u32, size, sizeof(attr));
 
 	/* copy attributes from user space, may be less than sizeof(bpf_attr) */
+	memset(&attr, 0, sizeof(attr));
 	if (copy_from_user(&attr, uattr, size) != 0)
 		return -EFAULT;
 

base-commit: 6c90b86a745a446717fdf408c4a8a4631a5e8ee3
-- 
2.25.2

