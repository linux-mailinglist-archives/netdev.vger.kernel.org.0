Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C0A39B7D1
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 13:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFDL0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 07:26:38 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50314 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhFDL0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 07:26:37 -0400
Received: from relay2.suse.de (unknown [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D49701FD4A;
        Fri,  4 Jun 2021 11:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622805890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KvwB2iX6N3U8dsxrAx26cUnRKNUIXsfqg7dJXyh1/xw=;
        b=Elr/q18VQyxMG3puKM9hQ+T3j1ary++HsU/d7mhZKuxqIFQghvq5v3+F99PdaG4V5A+iZh
        wV9wiZXLHH1zuNsDghOGMjTGoZADJn3Gf127cr7aYOMmKfjYfgKNaT8rnGaE5nETiKJkso
        LKS0JB/cF9sQSHvTYbZDtgAPtuuFhqk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622805890;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KvwB2iX6N3U8dsxrAx26cUnRKNUIXsfqg7dJXyh1/xw=;
        b=hRjuEO3z/fNzEImuCtuiEspWJS/eNAtsrn+T27rb5r1F/u9dmAvmpN/Xhn/2s26CZd/3jv
        x7lEfGpRASQRRuDA==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        by relay2.suse.de (Postfix) with ESMTP id 98516A3B85;
        Fri,  4 Jun 2021 11:24:50 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     bpf@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: [PATCH bpf-next] libbpf: fix pr_warn type warnings on 32bit
Date:   Fri,  4 Jun 2021 13:24:48 +0200
Message-Id: <20210604112448.32297-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CAEf4BzbgJPgVmdS32nnzd8mBj3L=mib7D8JyP09Gq4bGdYpTyg@mail.gmail.com>
References: <CAEf4BzbgJPgVmdS32nnzd8mBj3L=mib7D8JyP09Gq4bGdYpTyg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The printed value is ptrdiff_t and is formatted wiht %ld. This works on
64bit but produces a warning on 32bit. Fix the format specifier to %td.

Fixes: 67234743736a ("libbpf: Generate loader program out of BPF ELF file.")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 tools/lib/bpf/libbpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ef6600688f10..5e13c9d8d3f5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4584,7 +4584,7 @@ static int init_map_slots(struct bpf_object *obj, struct bpf_map *map)
 		targ_map = map->init_slots[i];
 		fd = bpf_map__fd(targ_map);
 		if (obj->gen_loader) {
-			pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
+			pr_warn("// TODO map_update_elem: idx %td key %d value==map_idx %td\n",
 				map - obj->maps, i, targ_map - obj->maps);
 			return -ENOTSUP;
 		} else {
@@ -6208,7 +6208,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		return -EINVAL;
 
 	if (prog->obj->gen_loader) {
-		pr_warn("// TODO core_relo: prog %ld insn[%d] %s %s kind %d\n",
+		pr_warn("// TODO core_relo: prog %td insn[%d] %s %s kind %d\n",
 			prog - prog->obj->programs, relo->insn_off / 8,
 			local_name, spec_str, relo->kind);
 		return -ENOTSUP;
-- 
2.26.2

