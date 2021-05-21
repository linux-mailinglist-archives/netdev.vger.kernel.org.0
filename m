Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EEB38CAE1
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 18:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhEUQWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 12:22:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:33934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhEUQWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 12:22:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621614043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=0jku9GTWoW2j4X3kuE24CEPxpjUZoyrELhmnmA6WIRM=;
        b=scjoFZhQZOqwY7sQY14JVQERLQBiMsK0kCCiGWKiJttOhvO/OQxVNvL4uwOX8bp+CKqz9y
        8JaI2kf/FBenZkKbrJiUithygyIER063lsg/dBEMEc1hKvhl8ZlcS2Dc3KxOtsGWH05aUC
        zxSH0PiYv5cn4zSwbXpWYKh+7PA5TN8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621614043;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=0jku9GTWoW2j4X3kuE24CEPxpjUZoyrELhmnmA6WIRM=;
        b=Cb/Xe+DuudH9GdoksCM+G2Xj+HmhTE8s9kWt8imNLJhlk4vrDY76mWzrICfPArvovzbNcl
        T+PLZwyQePX3lxCg==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 063F4ABD0;
        Fri, 21 May 2021 16:20:43 +0000 (UTC)
Date:   Fri, 21 May 2021 18:20:41 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: BTF: build failure on 32bit on linux-next
Message-ID: <20210521162041.GH8544@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

looks like the TODO prints added in 67234743736a6 are not 32bit clean.

Do you plan to implement this functionality or should they be fixed?

Thanks

Michal

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 69cd1a835ebd..70a26af8d01f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4565,7 +4565,7 @@ static int init_map_slots(struct bpf_object *obj, struct bpf_map *map)
 		targ_map = map->init_slots[i];
 		fd = bpf_map__fd(targ_map);
 		if (obj->gen_loader) {
-			pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
+			pr_warn("// TODO map_update_elem: idx %td key %d value==map_idx %td\n",
 				map - obj->maps, i, targ_map - obj->maps);
 			return -ENOTSUP;
 		} else {
@@ -6189,7 +6189,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		return -EINVAL;
 
 	if (prog->obj->gen_loader) {
-		pr_warn("// TODO core_relo: prog %ld insn[%d] %s %s kind %d\n",
+		pr_warn("// TODO core_relo: prog %td insn[%d] %s %s kind %d\n",
 			prog - prog->obj->programs, relo->insn_off / 8,
 			local_name, spec_str, relo->kind);
 		return -ENOTSUP;
