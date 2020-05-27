Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EE91E4B77
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbgE0RIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgE0RIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:08:46 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124BCC03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:46 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x1so28949265ejd.8
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4aNYzFZ3HQztQJxIHCfXbNBHtKfIZ7aoRnKs0QLw/oE=;
        b=UbtuMdTdaVEj1t1nuIVBixpqHZcjOrac9qGZFczd4DtMvVa+hiueDk/NSOW5GT8KRZ
         YqwyEP2w42/7XndFUvr6Cn4+/LAKTrUD/GMxTlcMgoxZ4I4VQCtBAjZrJzl8VCUmISrP
         rhm+Cu02/+iztj1R2eXop3lJwrDBagqKqUKpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4aNYzFZ3HQztQJxIHCfXbNBHtKfIZ7aoRnKs0QLw/oE=;
        b=bXAP+ElFEHfcCpUjan/mz1ZVheYZiww13NdB5aTGdwhLdqHu4Am/XrsPRpLtRH5YkG
         Vov+NUwpcsShaLh6L2LAVqImZLXmR61ttY0zt0oWdE3FPFY5+LUm4uTZu8KphUuUBHTO
         +24XCblrXStevTNrd4fuX/125G2Tafsh2aGu3cg19CviwbtjArTJJ1QKLoUihUM4pVxe
         Wx9OF4y52FrxvfBueSev/UrASpycSJpLsEvBq2kS/EMjETxQ/cKXz1QKy2QxoZPPawco
         yjYeoV6iT66uzBUQkkYZSiKunskIm9RoyTdZ6P9f+UOnniPbNY1tHRPfpnWssh/dTa/C
         /vug==
X-Gm-Message-State: AOAM533X96wBVUFJr89UHzpUEJ6nnUZ1ivLlOeZ8m4Cxi7za8TgXlfMD
        a30fj1xfdgxbuzEcYVqWckWAZS/6FSg=
X-Google-Smtp-Source: ABdhPJxM1aq2ausULE8+zhL4DTIGQiqUBoIXA++dwmTCA8sckm6c+YMf2xtAt2Xwf/NVatKH5l7TYg==
X-Received: by 2002:a17:906:eda5:: with SMTP id sa5mr6871910ejb.289.1590599324729;
        Wed, 27 May 2020 10:08:44 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e9sm2716447edl.25.2020.05.27.10.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 10:08:44 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 2/8] flow_dissector: Pull locking up from prog attach callback
Date:   Wed, 27 May 2020 19:08:34 +0200
Message-Id: <20200527170840.1768178-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200527170840.1768178-1-jakub@cloudflare.com>
References: <20200527170840.1768178-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split out the part of attach callback that happens with attach/detach lock
acquired. This structures the prog attach callback similar to prog detach,
and opens up doors for moving the locking out of flow_dissector and into
generic callbacks for attaching/detaching progs to netns in subsequent
patches.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/flow_dissector.c | 40 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 73cc085dc2b7..4f73f6c51602 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -109,15 +109,10 @@ int skb_flow_dissector_prog_query(const union bpf_attr *attr,
 	return 0;
 }
 
-int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
-				       struct bpf_prog *prog)
+static int flow_dissector_bpf_prog_attach(struct net *net,
+					  struct bpf_prog *prog)
 {
 	struct bpf_prog *attached;
-	struct net *net;
-	int ret = 0;
-
-	net = current->nsproxy->net_ns;
-	mutex_lock(&flow_dissector_mutex);
 
 	if (net == &init_net) {
 		/* BPF flow dissector in the root namespace overrides
@@ -130,33 +125,38 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
 		for_each_net(ns) {
 			if (ns == &init_net)
 				continue;
-			if (rcu_access_pointer(ns->flow_dissector_prog)) {
-				ret = -EEXIST;
-				goto out;
-			}
+			if (rcu_access_pointer(ns->flow_dissector_prog))
+				return -EEXIST;
 		}
 	} else {
 		/* Make sure root flow dissector is not attached
 		 * when attaching to the non-root namespace.
 		 */
-		if (rcu_access_pointer(init_net.flow_dissector_prog)) {
-			ret = -EEXIST;
-			goto out;
-		}
+		if (rcu_access_pointer(init_net.flow_dissector_prog))
+			return -EEXIST;
 	}
 
 	attached = rcu_dereference_protected(net->flow_dissector_prog,
 					     lockdep_is_held(&flow_dissector_mutex));
-	if (attached == prog) {
+	if (attached == prog)
 		/* The same program cannot be attached twice */
-		ret = -EINVAL;
-		goto out;
-	}
+		return -EINVAL;
+
 	rcu_assign_pointer(net->flow_dissector_prog, prog);
 	if (attached)
 		bpf_prog_put(attached);
-out:
+	return 0;
+}
+
+int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
+				       struct bpf_prog *prog)
+{
+	int ret;
+
+	mutex_lock(&flow_dissector_mutex);
+	ret = flow_dissector_bpf_prog_attach(current->nsproxy->net_ns, prog);
 	mutex_unlock(&flow_dissector_mutex);
+
 	return ret;
 }
 
-- 
2.25.4

