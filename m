Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D884848B531
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345290AbiAKSGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350277AbiAKSFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:05:11 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5486C06175D;
        Tue, 11 Jan 2022 10:04:59 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id pf13so321121pjb.0;
        Tue, 11 Jan 2022 10:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mzvRZKPPi+O4Z5nNliFs9pnbJZxkwJwBOoO6asYIWtU=;
        b=V0culqn/B2uQY2ol/WHitRf/cd6MGb8HMvxXrVzhTgiZTDMeEBMIImW/mtohLvu5Uz
         cgA1Me87BbqgOxtq1CCcbrBchWlQqxVtZXTgqxbgOdlHIDwjjWSPUyeUyRovKMXZqkMW
         j8Dlic2KCzYDJCvq+nVnLGRzoRo8+PdLY4nOkrRr1jlbjtGk8bamHLDqJmoE8y+UdOTs
         Eye/c2rLMWrEacBPbY47j/aZHVMlwRvOFbxWFin4xQOTA2x7MGtJtKUSfgNSVl+C5qzA
         CT4NR5qkxhc3YAXhvNWOcGs+YIq8ufw5uULI20Hh11EnjX9xYecajXPU4vbBjFcvAugw
         NXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mzvRZKPPi+O4Z5nNliFs9pnbJZxkwJwBOoO6asYIWtU=;
        b=GFBTWOF/hdkE9zKy8h/opVIsd5RXZr53uBUjGsTGjdDSD+VPi/3X7CMrZU7CoDImPz
         CCDHdxmksAgwzUa4qarbXFsVX+vtm4uXlybjegsOBeZxw8dABMS/b/iMqHHKFuhGi43N
         gxfdDMDFm74Hx4XuqU7Thmsr/jUJGlqMahpRB+2OQkgDUH5ihAkRaG65RKBTFq8UzeAX
         QNv7I3DpEanW4HhAp74t3G2dprKcZZm61S1hGBg3fRRj//TBJozuv8uYeyDh69mijfNb
         qKpbQjJUO2Oedui6asUU1qyt2/Uqj2g1dF77X9pujaA6aOxjsB+LqLrPBW9deJcJHQ1u
         RD5w==
X-Gm-Message-State: AOAM533ek1V70lv4yTxqS6df/I0zRW9hZKM2IFTQoW28m/8W+t1CR6kT
        FQc5qNHJXEZdUGrPsCH6XAqyVcQRSIar+A==
X-Google-Smtp-Source: ABdhPJwvzXzIdxaeFGhrJX/kbfP0UE1Wj6/S19acS+KFtP4WlPA9ZMJGqW9Sd+fB4Qufr2hVcgtwTw==
X-Received: by 2002:a17:902:a404:b0:148:c0e0:423f with SMTP id p4-20020a170902a40400b00148c0e0423fmr5778226plq.90.1641924299019;
        Tue, 11 Jan 2022 10:04:59 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id t21sm3081474pjs.37.2022.01.11.10.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:04:58 -0800 (PST)
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
Subject: [PATCH bpf-next v7 01/10] bpf: Fix UAF due to race between btf_try_get_module and load_module
Date:   Tue, 11 Jan 2022 23:34:19 +0530
Message-Id: <20220111180428.931466-2-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111180428.931466-1-memxor@gmail.com>
References: <20220111180428.931466-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5792; h=from:subject; bh=FAX5enVSiuTRv8dFs2JqHzzpMfEKAf8m/iCPJxEYOoQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh3cajhSOO01rS7iHg4WP0GNEmBdSbx9T3OtXKWJ9u TKFYcIiJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYd3GowAKCRBM4MiGSL8RykdBD/ 9Fx8MINwyFirrx3B59Kuk4pCxHtJThth09kknw2CzW78gc+x98boBqPMSz5z9q9TgOmSk5xPyAu9gG AtzdShU0oQSIV6XHUvJ4wrXprxE0mQlKIPKTt/CWHNQQfgaytPMrEprptF4M/rWwxXK6ZeAIvCM6l0 0MgragZCFQxgkG/tUKbTB2LqWCcBuBAb2Gj80wAkhAcT0+Gvq+4GqdtCeMgjq03e0eLybdUNYOey7L edWsPalC1iEzz6xfciPpuCwcH32TJmhhE487VHxsWs3Hpp5q5SXBQVSCMi7a2/PLGQEMCJIhPYtny0 XOsNZxQ77c3+cdRzYFROzfvZKyIoMFQs4xD8sa/k0Isfm/I0eVAZKc+1/BQwBBx6EE/se6dSfevOLG mHUxgtsfufIeoGQ0k4PBuMz0upshWmqvoyaaZD6Gl1QiwBEGf3B2OcnFKIA3sqb3XMZ9qfTQQ/TBzq khhwZl5cbzFUGqoqDOLoXDTXzwh9dxzR4UCRGjvJ7oNM94jXHDFqpZ3aHvLwISWtG9hC0j01HF88B9 /O3aC+fBFquG/MbSAgVoD5lIwixzpRE9oBmYRHeXuaNx0Qj/5y8slv+Q8GUYLWUal5jNBL39AAaoFR 4ugIGTeUyxWMjzyWFbRv2QflA0TFiUz5bD63Ggjo6l7HTkmjyNGt72+/a4gA==
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

