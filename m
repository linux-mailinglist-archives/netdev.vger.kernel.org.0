Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5719A116E43
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfLINzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:55:51 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33113 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfLINzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 08:55:50 -0500
Received: by mail-pf1-f196.google.com with SMTP id y206so7293856pfb.0;
        Mon, 09 Dec 2019 05:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K/y2oIRRhF2GBW1wRD/KjpZ9zXuv6w7I3mWnKh9t2ZU=;
        b=N4uLEqhceVWIOsYa6jqLUmMGMLd0PNDIA8XXFChrheDpNCASM+9b2Ecf4M8NUW6y/4
         OEWFuumb3G+DyQUXZgbVZGqw/NOMN2kh0xITUWvscq41Av1pKqd/YevhAOv2BDCcth1g
         m2upDs3kkWKfej0xDIB/pPzTvQi7vK8BQXijtEpjB4g45IsmA1CiZn9qksaA5lZjftzP
         mj4i1yXITqFRaixq0JXUxsSII/ehQBgYU+FndVecTQRnX4HyK6wZd8g+TzL/A3sde3eH
         uWfHgQwrdX9HE/5ZhxkETNReN25xg9M6XEHsvWaG68E+7rHfUEaiv5NIcSg2w/iM2zXa
         hrPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K/y2oIRRhF2GBW1wRD/KjpZ9zXuv6w7I3mWnKh9t2ZU=;
        b=txUsm8caLsGnAMsA4x2n1qm2p5FWsSKkwUem0R8ILLSCIvlI4CFWJLKAAsh/VVizHg
         aZWXclUfYRR9BTee1KOFs5wlhZoFGqQzteDXIRTCbyTgm4rUgUVN0RGHqt+frPbLLNxV
         QUOblVL/9gcvNr2APIpZ2c6VVtF/NHosTMHRl/s3WJu+l3PJZsiwanv/UyLBuUr4Vbjl
         H4H871dt1e3xiryQI6FUsx6UMC6IITmJiwPaJoGhPabIF7Quf/c1SFHeU83IfcWO+tY0
         Q3RSW9+iNz7UEE8biQB6QBoA43aUqbvStZ98aMwXFiia4UM/OSfpxOmt3wJhoeh4UnCe
         +7rQ==
X-Gm-Message-State: APjAAAUOGHIAB8vMlWYStNA81oRAMZ5J2fDXWVIo6cJmy5dSYnCdkPv3
        w3x6zFMF9/H+PqPnpMK/DZWomfhHr1PE1Q==
X-Google-Smtp-Source: APXvYqzUB2wkCRa+BT9bP1Leh28n8OzUP0cwqRfbGHnCllCFoJ2UmVo+JNF7pqa90F+2xhcMCe6Qjw==
X-Received: by 2002:a63:a34b:: with SMTP id v11mr18203857pgn.229.1575899748914;
        Mon, 09 Dec 2019 05:55:48 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id h26sm19543403pfr.9.2019.12.09.05.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 05:55:48 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v3 4/6] bpf: start using the BPF dispatcher in BPF_TEST_RUN
Date:   Mon,  9 Dec 2019 14:55:20 +0100
Message-Id: <20191209135522.16576-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209135522.16576-1-bjorn.topel@gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
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
index 915c2d6f7fb9..400f473c2541 100644
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
@@ -359,7 +363,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	ret = convert___skb_to_skb(skb, ctx);
 	if (ret)
 		goto out;
-	ret = bpf_test_run(prog, skb, repeat, &retval, &duration);
+	ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false);
 	if (ret)
 		goto out;
 	if (!is_l2) {
@@ -416,8 +420,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
 	xdp.rxq = &rxqueue->xdp_rxq;
-
-	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration);
+	bpf_prog_change_xdp(NULL, prog);
+	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	if (ret)
 		goto out;
 	if (xdp.data != data + XDP_PACKET_HEADROOM + NET_IP_ALIGN ||
@@ -425,6 +429,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		size = xdp.data_end - xdp.data;
 	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
 out:
+	bpf_prog_change_xdp(prog, NULL);
 	kfree(data);
 	return ret;
 }
-- 
2.20.1

