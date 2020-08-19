Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5D5249412
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 06:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHSE2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 00:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgHSE2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 00:28:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BEBC061342;
        Tue, 18 Aug 2020 21:28:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m71so11039415pfd.1;
        Tue, 18 Aug 2020 21:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JFWnK1l68gu4JKThmFYDNlPjfM/pp6QHfQPee1THnF4=;
        b=dvO69J1uTRj0I1iZjo1YBaOnJeLIhVIeNJ1+HCWMMh9TOT92IF+Lu3/MX/q73nwx8+
         m1awN6OtO99gbn193wc5ybtpxLwgayR5fJehYi35824QVBjc6gATxQ8yGFx/J4evjTzH
         nYD9bEFF8AMh9iBsgzp1Sy9gCJsT9cKlj9+mMuoyHM9i9dwqqkSdJir2Rh3WiawQ59uK
         NUyvUAEa8iu/GtfLtpLHqDamPMHLqs0TUoktbquUEK87Dm6mxJT0Oo5p0yQi0b4WRNdq
         KZSNv38Vg+R/2mmDxV3QUy1EHfT2lCjMJ/he/56UzSzp9h64vaSPY3WnVUrqhOj+ehpd
         FqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JFWnK1l68gu4JKThmFYDNlPjfM/pp6QHfQPee1THnF4=;
        b=QUL+x2GEWVody4slnocSEWtZXsytrvyBlkrTbHpXpnQdSSYSg5yOkRG8ms5Go0Ybhk
         KZ7Jf6TaFKTro4479OM/8+1P2O5+mGOrnrqbXdvr0+OmUXXVOb4bubBlCZAUwMcehYnL
         m0BNCMU2+vZbF2YGomr3VvWaA/0TjKrxeruO7gPa6LNTa5QjpEtv34QpLPt+JfsGPnV4
         iBYxd1BXyhJcJh0IPqOwF7pfAGdhA9v2nZgfDgd6A5viricimW+Mb1Icq6AwncrHFMhk
         kwh44G62q7x/8lKdB9xX8B7moQYEwO7re952LMHQUsOlSy3mxpIzFP9YkUOCAhn+CDVp
         PnJg==
X-Gm-Message-State: AOAM532XJhoWovbnwfYbafrVutybIZnzVl61XsvLl3xFT0SiuhEDPl14
        CsKb+XxfFGjPJUbH8alYz2Q=
X-Google-Smtp-Source: ABdhPJykXTWG3KdrX68yBFvWtPpp2+9d9dpnzK+qt/oJ55pDBvEC6kFWL6+Lf0cB2A4LOviGZEobRg==
X-Received: by 2002:a62:aa07:: with SMTP id e7mr17260272pff.71.1597811283347;
        Tue, 18 Aug 2020 21:28:03 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id f6sm24132023pga.9.2020.08.18.21.28.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2020 21:28:02 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v6 bpf-next 1/4] bpf: Factor out bpf_link_by_id() helper.
Date:   Tue, 18 Aug 2020 21:27:56 -0700
Message-Id: <20200819042759.51280-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200819042759.51280-1-alexei.starovoitov@gmail.com>
References: <20200819042759.51280-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Refactor the code a bit to extract bpf_link_by_id() helper.
It's similar to existing bpf_prog_by_id().

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h  |  1 +
 kernel/bpf/syscall.c | 46 +++++++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 55f694b63164..a9b7185a6b37 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1358,6 +1358,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 			 struct btf *btf, const struct btf_type *t);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
+struct bpf_link *bpf_link_by_id(u32 id);
 
 const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_id);
 #else /* !CONFIG_BPF_SYSCALL */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 86299a292214..689d736b6904 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4014,40 +4014,50 @@ static int link_detach(union bpf_attr *attr)
 	return ret;
 }
 
-static int bpf_link_inc_not_zero(struct bpf_link *link)
+static struct bpf_link *bpf_link_inc_not_zero(struct bpf_link *link)
 {
-	return atomic64_fetch_add_unless(&link->refcnt, 1, 0) ? 0 : -ENOENT;
+	return atomic64_fetch_add_unless(&link->refcnt, 1, 0) ? link : ERR_PTR(-ENOENT);
 }
 
-#define BPF_LINK_GET_FD_BY_ID_LAST_FIELD link_id
-
-static int bpf_link_get_fd_by_id(const union bpf_attr *attr)
+struct bpf_link *bpf_link_by_id(u32 id)
 {
 	struct bpf_link *link;
-	u32 id = attr->link_id;
-	int fd, err;
 
-	if (CHECK_ATTR(BPF_LINK_GET_FD_BY_ID))
-		return -EINVAL;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	if (!id)
+		return ERR_PTR(-ENOENT);
 
 	spin_lock_bh(&link_idr_lock);
-	link = idr_find(&link_idr, id);
 	/* before link is "settled", ID is 0, pretend it doesn't exist yet */
+	link = idr_find(&link_idr, id);
 	if (link) {
 		if (link->id)
-			err = bpf_link_inc_not_zero(link);
+			link = bpf_link_inc_not_zero(link);
 		else
-			err = -EAGAIN;
+			link = ERR_PTR(-EAGAIN);
 	} else {
-		err = -ENOENT;
+		link = ERR_PTR(-ENOENT);
 	}
 	spin_unlock_bh(&link_idr_lock);
+	return link;
+}
 
-	if (err)
-		return err;
+#define BPF_LINK_GET_FD_BY_ID_LAST_FIELD link_id
+
+static int bpf_link_get_fd_by_id(const union bpf_attr *attr)
+{
+	struct bpf_link *link;
+	u32 id = attr->link_id;
+	int fd;
+
+	if (CHECK_ATTR(BPF_LINK_GET_FD_BY_ID))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	link = bpf_link_by_id(id);
+	if (IS_ERR(link))
+		return PTR_ERR(link);
 
 	fd = bpf_link_new_fd(link);
 	if (fd < 0)
-- 
2.23.0

