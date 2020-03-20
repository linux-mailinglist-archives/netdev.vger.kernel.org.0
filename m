Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715D818D448
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCTQXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbgCTQXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 12:23:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FEC620724;
        Fri, 20 Mar 2020 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584721380;
        bh=lv5dc5lyvfZeoMUgtuTZ8bzmyZe5g6+qYJhcqv6T9H4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XfRCgcWXuedy3Bn5EMaQ6y0SROMPmy3X3wmAmPLiGGByiiErxDcrSTbAmY3zZa11u
         AoJUJiP98hoo7XRqTS+oFm9IM31dcUfEOuACdITsJtOgO78KwrFbOefVfDdS8U7vpt
         OVJ91PgYCMQ9i+zWola632ATrMbJXHzucMJMPBuc=
Date:   Fri, 20 Mar 2020 17:22:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
Subject: [PATCH] bpf: explicitly memset some bpf info structures declared on
 the stack
Message-ID: <20200320162258.GA794295@kroah.com>
References: <20200320094813.GA421650@kroah.com>
 <3bcf52da-0930-a27f-60f9-28a40e639949@iogearbox.net>
 <20200320154518.GA765793@kroah.com>
 <d55983b3-0f94-cc7f-2055-a0b4ab8075ed@iogearbox.net>
 <20200320161515.GA778529@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320161515.GA778529@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trying to initialize a structure with "= {};" will not always clean out
all padding locations in a structure.  So be explicit and call memset to
initialize everything for a number of bpf information structures that
are then copied from userspace, sometimes from smaller memory locations
than the size of the structure.

Reported-by: Daniel Borkmann <daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Note, this is separate from my previous patch, both are needed.

 kernel/bpf/btf.c     | 3 ++-
 kernel/bpf/syscall.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 787140095e58..2fc945fcf952 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4564,7 +4564,7 @@ int btf_get_info_by_fd(const struct btf *btf,
 		       union bpf_attr __user *uattr)
 {
 	struct bpf_btf_info __user *uinfo;
-	struct bpf_btf_info info = {};
+	struct bpf_btf_info info;
 	u32 info_copy, btf_copy;
 	void __user *ubtf;
 	u32 uinfo_len;
@@ -4573,6 +4573,7 @@ int btf_get_info_by_fd(const struct btf *btf,
 	uinfo_len = attr->info.info_len;
 
 	info_copy = min_t(u32, uinfo_len, sizeof(info));
+	memset(&info, 0, sizeof(info));
 	if (copy_from_user(&info, uinfo, info_copy))
 		return -EFAULT;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a4b1de8ea409..84213cc5d016 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2787,7 +2787,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 				   union bpf_attr __user *uattr)
 {
 	struct bpf_prog_info __user *uinfo = u64_to_user_ptr(attr->info.info);
-	struct bpf_prog_info info = {};
+	struct bpf_prog_info info;
 	u32 info_len = attr->info.info_len;
 	struct bpf_prog_stats stats;
 	char __user *uinsns;
@@ -2799,6 +2799,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
 
+	memset(&info, 0, sizeof(info));
 	if (copy_from_user(&info, uinfo, info_len))
 		return -EFAULT;
 
@@ -3062,7 +3063,7 @@ static int bpf_map_get_info_by_fd(struct bpf_map *map,
 				  union bpf_attr __user *uattr)
 {
 	struct bpf_map_info __user *uinfo = u64_to_user_ptr(attr->info.info);
-	struct bpf_map_info info = {};
+	struct bpf_map_info info;
 	u32 info_len = attr->info.info_len;
 	int err;
 
@@ -3071,6 +3072,7 @@ static int bpf_map_get_info_by_fd(struct bpf_map *map,
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
 
+	memset(&info, 0, sizeof(info));
 	info.type = map->map_type;
 	info.id = map->id;
 	info.key_size = map->key_size;
-- 
2.25.2

