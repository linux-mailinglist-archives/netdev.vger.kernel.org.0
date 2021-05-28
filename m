Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640013947A5
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhE1UCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhE1UC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:02:29 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78850C061761;
        Fri, 28 May 2021 13:00:54 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y15so92216pfl.4;
        Fri, 28 May 2021 13:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vgj4iJjcx0a8O07oEEtY4GsTppAnUSLJjQ5LrQ/8SmM=;
        b=CA441Lqw686NSV5Uk3mo396ERANWMVViaCv6DzmEJdzfaJuQI9sbI6++cBSMsVgF6T
         LiszpWARDffePC68aK54ZTazQ1/d4R/vIlGOJLt8z0/cJlp93g6uc3MHTmRnppRsfkZG
         FVRTDV3VY4E2CxtnEv4jGIJXn42zuJGYGi1vvHHWjeSzDy3yMp/BnVWrQMYGcE3TkYYb
         pd/ewE2Dep8t5rs5/Fx9RcVXbTUMxQDZ2lA/1hl8GuU9ALTUbp6L1ARcyOejtULvS/JH
         uHoUcUiUZxwTFBbv0mts4vJyvyIbR5/3aEgh8T3h+T+E1Ll5P22smzVad0sXVv6aD9sm
         9qWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vgj4iJjcx0a8O07oEEtY4GsTppAnUSLJjQ5LrQ/8SmM=;
        b=fbPoRvI3DbH1jZ2nNRRzytp4Pwt+S55b6PQw3kfGYAeJDJsInPaAPDfh4M/9cI2tXe
         8Rm+twrex9Xx5EmJOmZGpXg+nPXL4pP3ojAZzm2o6tE11WZkFpSr+esB+1dtGNP4rngI
         hwNQUf+SGwweTYxBq8is0ceCfwhpplgpslYYhK4upTZaY+SFmg+lDZepFPqDin05o8Cc
         kOTmQlJegM5qUmH8vPUDSAgPVJmlVwg87n9dQNVviYBdOXz8HJ/XAe8826FUvYekL/6j
         4kb+C6hrhTySCaXzUQh82T/xWSq5mxTPcYvUWuHQDNZ17qM3gykQoPbq+N41gZVZyh+J
         PhcA==
X-Gm-Message-State: AOAM533t/KYikPowmiJ7dN+NfH5C6tKuAq4ukcOWPXSWleKnM6SrwrJJ
        XRyoxqifJzKQMVtf66WP3xp0XuNv8+U=
X-Google-Smtp-Source: ABdhPJxPPNfJuNE4+HkPX2/4E5HNmUBPafZ4R1ndFXbdnLLLcswW5tsaaXXlWk1mdbv4j1drVgLfNQ==
X-Received: by 2002:a05:6a00:1c6b:b029:2e2:caff:13fa with SMTP id s43-20020a056a001c6bb02902e2caff13famr5355937pfw.59.1622232053780;
        Fri, 28 May 2021 13:00:53 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id 126sm5078463pfv.82.2021.05.28.13.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 13:00:53 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 4/7] net: sched: add lightweight update path for cls_bpf
Date:   Sat, 29 May 2021 01:29:43 +0530
Message-Id: <20210528195946.2375109-5-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528195946.2375109-1-memxor@gmail.com>
References: <20210528195946.2375109-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is used by BPF_LINK_UPDATE to replace the attach SCHED_CLS bpf prog
effectively changing the classifier implementation for a given filter
owned by a bpf_link.

Note that READ_ONCE suffices in this case as the ordering for loads from
the filter are implicitly provided by the data dependency on BPF prog
pointer.

On the writer side we can just use a relaxed WRITE_ONCE store to make
sure one or the other value is visible to a reader in cls_bpf_classify.
Lifetime is managed using RCU so bpf_prog_put path should wait until
readers are done for old_prog.

All other parties accessing the BPF prog are under RTNL protection, so
need no changes.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 net/sched/cls_bpf.c | 55 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 57d6dedb389a..459a139bcfbe 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -9,6 +9,7 @@
  * (C) 2013 Daniel Borkmann <dborkman@redhat.com>
  */
 
+#include <linux/atomic.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/skbuff.h>
@@ -104,11 +105,11 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 			/* It is safe to push/pull even if skb_shared() */
 			__skb_push(skb, skb->mac_len);
 			bpf_compute_data_pointers(skb);
-			filter_res = BPF_PROG_RUN(prog->filter, skb);
+			filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
 			__skb_pull(skb, skb->mac_len);
 		} else {
 			bpf_compute_data_pointers(skb);
-			filter_res = BPF_PROG_RUN(prog->filter, skb);
+			filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
 		}
 
 		if (prog->exts_integrated) {
@@ -775,6 +776,55 @@ static int cls_bpf_link_detach(struct bpf_link *link)
 	return 0;
 }
 
+static int cls_bpf_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
+			       struct bpf_prog *old_prog)
+{
+	struct cls_bpf_link *cls_link;
+	struct cls_bpf_prog cls_prog;
+	struct cls_bpf_prog *prog;
+	int ret;
+
+	rtnl_lock();
+
+	cls_link = container_of(link, struct cls_bpf_link, link);
+	if (!cls_link->prog) {
+		ret = -ENOLINK;
+		goto out;
+	}
+
+	prog = cls_link->prog;
+
+	/* BPF_F_REPLACEing? */
+	if (old_prog && prog->filter != old_prog) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	old_prog = prog->filter;
+
+	if (new_prog == old_prog) {
+		ret = 0;
+		goto out;
+	}
+
+	cls_prog = *prog;
+	cls_prog.filter = new_prog;
+
+	ret = cls_bpf_offload(prog->tp, &cls_prog, prog, NULL);
+	if (ret < 0)
+		goto out;
+
+	WRITE_ONCE(prog->filter, new_prog);
+
+	bpf_prog_inc(new_prog);
+	/* release our reference */
+	bpf_prog_put(old_prog);
+
+out:
+	rtnl_unlock();
+	return ret;
+}
+
 static void __bpf_fill_link_info(struct cls_bpf_link *link,
 				 struct bpf_link_info *info)
 {
@@ -859,6 +909,7 @@ static const struct bpf_link_ops cls_bpf_link_ops = {
 	.show_fdinfo = cls_bpf_link_show_fdinfo,
 #endif
 	.fill_link_info = cls_bpf_link_fill_link_info,
+	.update_prog = cls_bpf_link_update,
 };
 
 static inline char *cls_bpf_link_name(u32 prog_id, const char *name)
-- 
2.31.1

