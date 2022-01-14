Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC3748EE6E
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243505AbiANQko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243494AbiANQkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:40:43 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB40C061574;
        Fri, 14 Jan 2022 08:40:43 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id p37so3205106pfh.4;
        Fri, 14 Jan 2022 08:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mzvRZKPPi+O4Z5nNliFs9pnbJZxkwJwBOoO6asYIWtU=;
        b=PQsp63yUpO9tk8uGbr2JH266Bv4UYn0Y/0SREgVI3RoBQcPkcPRIKQ+cnKdYnzkFgU
         tR0HdV6PK5mI9oEaalEPpLgXeJcFcJa9Nkeof+4WIfRbH18lqZnTYlAk2hhLPf1ev90F
         +KY9GcNSzsx+8NIdScUIcgOe0ShDfaS94RUWhJriTcCkYYO3DGICCpt/6gNU7xM0oZBh
         Trz24y0P1x++kuzk2N4BXGu1vdzkQYkxxxSXTyGL2CmMJpMPVKBwJMrvolDqdtjI1U8f
         ERt7dlWzeXy3EhsPEJ1rXu+fljiwfcT1lwsAiFh9QV+HM7BYDc7qyS0KZ/9tl65sj0ge
         MPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mzvRZKPPi+O4Z5nNliFs9pnbJZxkwJwBOoO6asYIWtU=;
        b=yCgrXG7K4O7xQH6XEFvhxKlobbc8xwIjTuM4fA91NFi+RwEznnZ/mNTw2EkdHfYErW
         qXQwLY65QV6I/VAyWaUxwKHyc6dN5OkYoSQV27hBEZuVLd7WAmONvzsyZH2m6l6me0Mq
         ry7ThnHYnqdnGSK/ULtS/ODViFDaLglHCU+PSc3Wd0OCMmKuhlddu7flapWeZCkwJJYf
         V5wJ3pzBtnU3iMmtoZol/10Qq9IsNHF+odihnv8VerchMO66cOuw5oswNr4OKDuE1Qp0
         uO8jgk6iFZtE/7D/r503l4yzBA1vo1L+vVhOumFCeLLZCxqI51oyhM0SjI+nnLpBX9E6
         YvEg==
X-Gm-Message-State: AOAM531k4AN36IEnXFQ/MPjtIXojF5cmdBerKzmKpPK0sPIQSYvDP78J
        rSVLhOSSfzpGfR7okYhkmNJz8iRhjOQajQ==
X-Google-Smtp-Source: ABdhPJwzkZ7LSbuGcoxvlNtgfAvVZTpvx7LnhxPup3p1kgI7x7hRnmsucg4JXpsRU4VQRi6sSeWX+A==
X-Received: by 2002:a05:6a00:21ca:b0:4c1:eb90:1267 with SMTP id t10-20020a056a0021ca00b004c1eb901267mr7730428pfj.23.1642178442480;
        Fri, 14 Jan 2022 08:40:42 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id b25sm5161543pgs.56.2022.01.14.08.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:40:42 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v8 01/10] bpf: Fix UAF due to race between btf_try_get_module and load_module
Date:   Fri, 14 Jan 2022 22:09:44 +0530
Message-Id: <20220114163953.1455836-2-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114163953.1455836-1-memxor@gmail.com>
References: <20220114163953.1455836-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5792; h=from:subject; bh=FAX5enVSiuTRv8dFs2JqHzzpMfEKAf8m/iCPJxEYOoQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh4acUhSOO01rS7iHg4WP0GNEmBdSbx9T3OtXKWJ9u TKFYcIiJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYeGnFAAKCRBM4MiGSL8RymXrEA CT3fsTIJ0yJ1t6aTsql95XiMCJYN4iFHh0W+cjB/DMffZ6borOS1fBzpvS3IUTJxkvA491FCKLG3V9 Qc0qENtlP1nKkLuz1SPFK9tm/W8wDHfC3qrhGQiEQihaqXNqbKBDE0QP/dp4xX0vubOnl8l4zzecy9 1Q1zcBnGLgEcofuikP/ue/odH3juJDsYbBH2Jh2Zrhy+r3Mra8AaPbAAyUKZYrOVrg65gkLM3EpzzH /lcuAn56fKcf/+q/SshUkw9h1rgyl+4z3IMpChUkHWuzXNl4EtKyg2Dcxu4VK5vT21XYsRIIkxFs6t hVnsn9EzlfwuSoQUpE5hcwCiWer/SCgHsOUxMWfevFfdyChxT9sbiOkGJ9UnjR4h7XS0O0c2V+ael7 R9NwRfGODcf9e50AeeFyJMqRw+HP8cs7J2ODiKR5QsOgZD9o0SrwiYOwHmvwXNrIARS2xtA/L8dzXu m27RWwFj7vcS62wypCwwaEo8ykaPvc/rglIk43UhhvQ6RyVApmkhdpcUBtK3CjiuQQ/T2plIB+nfrH XEeIwvzhdNDInzw18Uj3xD1CyesQUS7dFvn2Ac5xus6/It9Nig8VOFbK+jlQ+cE6d3FE6J/gppoPHX o8NMOwmRdUxlYQB6wINmwyvvVXDAA5kN1vv4jKcBuHTCYhG2cTpwipZut/JA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While working on code to populate kfunc BTF ID sets for module BTF from
its initcall, I noticed that by the time the initcall is invoked, the
module BTF can already be seen by userspace (and the BPF verifier). The
existing btf_try_get_module calls try_module_get which only fails if
mod->state == MODULE_STATE_GOING, i.e. it can increment module reference
when module initcall is happening in parallel.

Currently, BTF parsing happens from MODULE_STATE_COMING notifier
callback. At this point, the module initcalls have not been invoked.
The notifier callback parses and prepares the module BTF, allocates an
ID, which publishes it to userspace, and then adds it to the btf_modules
list allowing the kernel to invoke btf_try_get_module for the BTF.

However, at this point, the module has not been fully initialized (i.e.
its initcalls have not finished). The code in module.c can still fail
and free the module, without caring for other users. However, nothing
stops btf_try_get_module from succeeding between the state transition
from MODULE_STATE_COMING to MODULE_STATE_LIVE.

This leads to a use-after-free issue when BPF program loads
successfully in the state transition, load_module's do_init_module call
fails and frees the module, and BPF program fd on close calls module_put
for the freed module. Future patch has test case to verify we don't
regress in this area in future.

There are multiple points after prepare_coming_module (in load_module)
where failure can occur and module loading can return error. We
illustrate and test for the race using the last point where it can
practically occur (in module __init function).

An illustration of the race:

CPU 0                           CPU 1
			  load_module
			    notifier_call(MODULE_STATE_COMING)
			      btf_parse_module
			      btf_alloc_id	// Published to userspace
			      list_add(&btf_mod->list, btf_modules)
			    mod->init(...)
...				^
bpf_check		        |
check_pseudo_btf_id             |
  btf_try_get_module            |
    returns true                |  ...
...                             |  module __init in progress
return prog_fd                  |  ...
...                             V
			    if (ret < 0)
			      free_module(mod)
			    ...
close(prog_fd)
 ...
 bpf_prog_free_deferred
  module_put(used_btf.mod) // use-after-free

We fix this issue by setting a flag BTF_MODULE_F_LIVE, from the notifier
callback when MODULE_STATE_LIVE state is reached for the module, so that
we return NULL from btf_try_get_module for modules that are not fully
formed. Since try_module_get already checks that module is not in
MODULE_STATE_GOING state, and that is the only transition a live module
can make before being removed from btf_modules list, this is enough to
close the race and prevent the bug.

A later selftest patch crafts the race condition artifically to verify
that it has been fixed, and that verifier fails to load program (with
ENXIO).

Lastly, a couple of comments:

 1. Even if this race didn't exist, it seems more appropriate to only
    access resources (ksyms and kfuncs) of a fully formed module which
    has been initialized completely.

 2. This patch was born out of need for synchronization against module
    initcall for the next patch, so it is needed for correctness even
    without the aforementioned race condition. The BTF resources
    initialized by module initcall are set up once and then only looked
    up, so just waiting until the initcall has finished ensures correct
    behavior.

Fixes: 541c3bad8dc5 ("bpf: Support BPF ksym variables in kernel modules")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/btf.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 33bb8ae4a804..f25bca59909d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6200,12 +6200,17 @@ bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
 	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
 }
 
+enum {
+	BTF_MODULE_F_LIVE = (1 << 0),
+};
+
 #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 struct btf_module {
 	struct list_head list;
 	struct module *module;
 	struct btf *btf;
 	struct bin_attribute *sysfs_attr;
+	int flags;
 };
 
 static LIST_HEAD(btf_modules);
@@ -6233,7 +6238,8 @@ static int btf_module_notify(struct notifier_block *nb, unsigned long op,
 	int err = 0;
 
 	if (mod->btf_data_size == 0 ||
-	    (op != MODULE_STATE_COMING && op != MODULE_STATE_GOING))
+	    (op != MODULE_STATE_COMING && op != MODULE_STATE_LIVE &&
+	     op != MODULE_STATE_GOING))
 		goto out;
 
 	switch (op) {
@@ -6291,6 +6297,17 @@ static int btf_module_notify(struct notifier_block *nb, unsigned long op,
 			btf_mod->sysfs_attr = attr;
 		}
 
+		break;
+	case MODULE_STATE_LIVE:
+		mutex_lock(&btf_module_mutex);
+		list_for_each_entry_safe(btf_mod, tmp, &btf_modules, list) {
+			if (btf_mod->module != module)
+				continue;
+
+			btf_mod->flags |= BTF_MODULE_F_LIVE;
+			break;
+		}
+		mutex_unlock(&btf_module_mutex);
 		break;
 	case MODULE_STATE_GOING:
 		mutex_lock(&btf_module_mutex);
@@ -6338,7 +6355,12 @@ struct module *btf_try_get_module(const struct btf *btf)
 		if (btf_mod->btf != btf)
 			continue;
 
-		if (try_module_get(btf_mod->module))
+		/* We must only consider module whose __init routine has
+		 * finished, hence we must check for BTF_MODULE_F_LIVE flag,
+		 * which is set from the notifier callback for
+		 * MODULE_STATE_LIVE.
+		 */
+		if ((btf_mod->flags & BTF_MODULE_F_LIVE) && try_module_get(btf_mod->module))
 			res = btf_mod->module;
 
 		break;
-- 
2.34.1

