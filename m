Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DA611E980
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfLMRvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:51:42 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38737 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbfLMRvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:51:41 -0500
Received: by mail-pj1-f65.google.com with SMTP id l4so35472pjt.5;
        Fri, 13 Dec 2019 09:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VHG+7/0OsvypkAR87gPaixZ3qwv7aiw+7jk5qghMhho=;
        b=qOdL4dHVEi1y29qzSsZC4qMJFfbMtpLGgvi41fRwxYqQCmTin42P1lHE+O32dVfWV6
         T9EyIaXHBp5Sm7bs7hEJrAKbQ4VCDAPQuWgjOSfKr4lNb8YXFQBw7tLvZqYmNM9Lppvs
         +OvZJV4vgpUToi4ueMi3CEGrMKe52w//yK8L+LcMwkbtAllMNbAfZnImPBeHiedOEcY0
         UhdQkQzvYMhVTbxu/xREcXhxNjzbVc14pQ5oEO4c38Uv7JRk2jpLoMaOhbFYangsyUWh
         HyphasJgbTgCEW3l3ki4WSS4dtftAMx7CmgMZSIf4kTaU6N3JbPAnAISfi3PqlzOuPfI
         Tj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VHG+7/0OsvypkAR87gPaixZ3qwv7aiw+7jk5qghMhho=;
        b=TdA8bzZEu++DnjF3b852EpBiMKC3k05YQD8M1czgLmaIMBVsjCZZm0gTqJKeYOooIx
         j3AuoFBOEEBERY9QvwrrZ8pJa71LKBPa4juPH4Q24vMjar2OJkNZuU35UI9IxdyKxyt7
         qQ3+aVrOPMpG7tKQMwkVjKLNYxVkPhVsO7RumXeRjwr3cgaTdL+ql+eLdVPxc/jcjVnc
         ChwQbMBqPz5zpcwU3M2VNmtUXJDg8Eg3Yobjfu/rBl1yjRu14o147RfueZf5koZOwQE+
         iaRbj1iK/0GaxKpxIrL4kygHs8I/6mECl5Mydu1ku2/YlNuINldP7u3CFZC92h+oo/V2
         57ow==
X-Gm-Message-State: APjAAAU2WXDeqgjZN95ismHnQuQVxY0oas8oIBH8jLbmOHy3CmPOSE2b
        tDA156yGjw9WzrhX6JODl4JPAOUXysS82Q==
X-Google-Smtp-Source: APXvYqxOweIWf00QF2PDhgvoMhHAElMQt3LprLL8wK0T4zO8bqGiwB1T2EcqOs2lpZQHiXaRbUyjBg==
X-Received: by 2002:a17:90a:c390:: with SMTP id h16mr589983pjt.131.1576259500839;
        Fri, 13 Dec 2019 09:51:40 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id q12sm12166366pfh.158.2019.12.13.09.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 09:51:40 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v5 4/6] bpf: start using the BPF dispatcher in BPF_TEST_RUN
Date:   Fri, 13 Dec 2019 18:51:10 +0100
Message-Id: <20191213175112.30208-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213175112.30208-1-bjorn.topel@gmail.com>
References: <20191213175112.30208-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

In order to properly exercise the BPF dispatcher, this commit adds BPF
dispatcher usage to BPF_TEST_RUN when executing XDP programs.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/bpf/test_run.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 85c8cbbada92..5016c538d3ce 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -15,7 +15,7 @@
 #include <trace/events/bpf_test_run.h>
 
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
-			u32 *retval, u32 *time)
+			u32 *retval, u32 *time, bool xdp)
 {
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
 	enum bpf_cgroup_storage_type stype;
@@ -41,7 +41,11 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	time_start = ktime_get_ns();
 	for (i = 0; i < repeat; i++) {
 		bpf_cgroup_storage_set(storage);
-		*retval = BPF_PROG_RUN(prog, ctx);
+
+		if (xdp)
+			*retval = bpf_prog_run_xdp(prog, ctx);
+		else
+			*retval = BPF_PROG_RUN(prog, ctx);
 
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -356,7 +360,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	ret = convert___skb_to_skb(skb, ctx);
 	if (ret)
 		goto out;
-	ret = bpf_test_run(prog, skb, repeat, &retval, &duration);
+	ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false);
 	if (ret)
 		goto out;
 	if (!is_l2) {
@@ -413,8 +417,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
 	xdp.rxq = &rxqueue->xdp_rxq;
-
-	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration);
+	bpf_prog_change_xdp(NULL, prog);
+	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	if (ret)
 		goto out;
 	if (xdp.data != data + XDP_PACKET_HEADROOM + NET_IP_ALIGN ||
@@ -422,6 +426,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		size = xdp.data_end - xdp.data;
 	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
 out:
+	bpf_prog_change_xdp(prog, NULL);
 	kfree(data);
 	return ret;
 }
-- 
2.20.1

