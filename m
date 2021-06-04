Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B2739B2AC
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhFDGf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:35:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33522 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhFDGf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:35:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id i5so7098983pgm.0;
        Thu, 03 Jun 2021 23:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sn1U8j/eLxlDeXD6fYRtDUEvHPfFPBFLZR8pCtvm3Pw=;
        b=IWWMpBHn4D+EWS1/2620P0mnvkYyKRr4MqS6kNexaZr8R4Frw5wCMOm3xAOsO+g0v/
         wyoAmTnbd9tTN73KlfIgV5tGz69bbvk0yCor3si9KnLPc373Fkv4FJl+1SvBrh4vSr/S
         yRZI+OMUkc3rpruW9H1c2FShFPJyaITByHJJLn91FgveW15rK8aeAJPrNoLfDy7OPWPV
         v3cFdQscy0N0MM3Coysnk0/h+U1k4b7cv+13sIe+NVCrM5aVqrudnus2iErwToSzFsx8
         4sasM5KJHPFwq7jfsOT8vrrDF4Eho8XL8Si0CT8zpesSjq3mf9S1uLGWURdAh0lPs3Ot
         7HVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sn1U8j/eLxlDeXD6fYRtDUEvHPfFPBFLZR8pCtvm3Pw=;
        b=Z48AWjjgeRV9J0BR8VpbmKZDFC4+WnYll4yEFRlDabbXfFgUgXJXvk9iDBydyP9hyc
         3nirrAz9J8QhNjsrmq4eilxIzAJsqDwQmx/9NlCWFrC9MIgPBco0NpXFklXHXW2ypDLi
         qcnuS5mA92gJmDE02HHRa2anLMMiD9HTbXGeZ7OVNY4aQTb8bV6SbVQBNFmLPbkDJvcC
         rvK+fyUln2PnQQQ6vQNpNepM7Jm+Zk8XU1Ma/7+ltQynEu4PxQCgq7o14XPxjayQeYET
         qM+JNWFRtyC6L6z8KrR+bY7FGcuudq5VmzLCwAP5so5t0f03dCWEh2pht4Yq+T0iNYrF
         RJBA==
X-Gm-Message-State: AOAM530g7fJ3M83jDjuPTeHiUvptlbUBy9hCtTrjN6jbULNI9DN6+6EO
        ZyCNhJiPeJhKjNh2RgPFfn6ZYEL1LCE=
X-Google-Smtp-Source: ABdhPJxY5TotAjSCJzPVPvxFSI2kAUA5hrykxLIWKQ2tfO4uCFWcJUzU1SXVlYBB2m2zQ8nnXbQgKA==
X-Received: by 2002:aa7:8c4e:0:b029:2df:9b70:44e with SMTP id e14-20020aa78c4e0000b02902df9b70044emr3186003pfd.49.1622788346461;
        Thu, 03 Jun 2021 23:32:26 -0700 (PDT)
Received: from localhost ([2402:3a80:11cb:b599:c759:2079:3ef5:1764])
        by smtp.gmail.com with ESMTPSA id f2sm952882pgl.67.2021.06.03.23.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:32:26 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 1/7] net: sched: refactor cls_bpf creation code
Date:   Fri,  4 Jun 2021 12:01:10 +0530
Message-Id: <20210604063116.234316-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604063116.234316-1-memxor@gmail.com>
References: <20210604063116.234316-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move parts of the code that are independent and need to be reused into
their own helpers. These will be needed for adding a bpf_link creation
path in a subsequent patch.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 net/sched/cls_bpf.c | 84 ++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 6e3e63db0e01..360b97ab8646 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -455,6 +455,57 @@ static int cls_bpf_set_parms(struct net *net, struct tcf_proto *tp,
 	return 0;
 }
 
+static int __cls_bpf_alloc_idr(struct cls_bpf_head *head, u32 handle,
+			       struct cls_bpf_prog *prog,
+			       struct cls_bpf_prog *oldprog)
+{
+	int ret = 0;
+
+	if (oldprog) {
+		if (handle && oldprog->handle != handle)
+			return -EINVAL;
+	}
+
+	if (handle == 0) {
+		handle = 1;
+		ret = idr_alloc_u32(&head->handle_idr, prog, &handle, INT_MAX,
+				    GFP_KERNEL);
+	} else if (!oldprog) {
+		ret = idr_alloc_u32(&head->handle_idr, prog, &handle, handle,
+				    GFP_KERNEL);
+	}
+
+	prog->handle = handle;
+	return ret;
+}
+
+static int __cls_bpf_change(struct cls_bpf_head *head, struct tcf_proto *tp,
+			    struct cls_bpf_prog *prog,
+			    struct cls_bpf_prog *oldprog,
+			    struct netlink_ext_ack *extack)
+{
+	int ret;
+
+	ret = cls_bpf_offload(tp, prog, oldprog, extack);
+	if (ret)
+		return ret;
+
+	if (!tc_in_hw(prog->gen_flags))
+		prog->gen_flags |= TCA_CLS_FLAGS_NOT_IN_HW;
+
+	if (oldprog) {
+		idr_replace(&head->handle_idr, prog, prog->handle);
+		list_replace_rcu(&oldprog->link, &prog->link);
+		tcf_unbind_filter(tp, &oldprog->res);
+		tcf_exts_get_net(&oldprog->exts);
+		tcf_queue_work(&oldprog->rwork, cls_bpf_delete_prog_work);
+	} else {
+		list_add_rcu(&prog->link, &head->plist);
+	}
+
+	return 0;
+}
+
 static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 			  struct tcf_proto *tp, unsigned long base,
 			  u32 handle, struct nlattr **tca,
@@ -483,48 +534,19 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 	if (ret < 0)
 		goto errout;
 
-	if (oldprog) {
-		if (handle && oldprog->handle != handle) {
-			ret = -EINVAL;
-			goto errout;
-		}
-	}
-
-	if (handle == 0) {
-		handle = 1;
-		ret = idr_alloc_u32(&head->handle_idr, prog, &handle,
-				    INT_MAX, GFP_KERNEL);
-	} else if (!oldprog) {
-		ret = idr_alloc_u32(&head->handle_idr, prog, &handle,
-				    handle, GFP_KERNEL);
-	}
-
+	ret = __cls_bpf_alloc_idr(head, handle, prog, oldprog);
 	if (ret)
 		goto errout;
-	prog->handle = handle;
 
 	ret = cls_bpf_set_parms(net, tp, prog, base, tb, tca[TCA_RATE], ovr,
 				extack);
 	if (ret < 0)
 		goto errout_idr;
 
-	ret = cls_bpf_offload(tp, prog, oldprog, extack);
+	ret = __cls_bpf_change(head, tp, prog, oldprog, extack);
 	if (ret)
 		goto errout_parms;
 
-	if (!tc_in_hw(prog->gen_flags))
-		prog->gen_flags |= TCA_CLS_FLAGS_NOT_IN_HW;
-
-	if (oldprog) {
-		idr_replace(&head->handle_idr, prog, handle);
-		list_replace_rcu(&oldprog->link, &prog->link);
-		tcf_unbind_filter(tp, &oldprog->res);
-		tcf_exts_get_net(&oldprog->exts);
-		tcf_queue_work(&oldprog->rwork, cls_bpf_delete_prog_work);
-	} else {
-		list_add_rcu(&prog->link, &head->plist);
-	}
-
 	*arg = prog;
 	return 0;
 
-- 
2.31.1

