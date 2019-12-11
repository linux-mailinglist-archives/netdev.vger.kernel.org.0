Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B5711AAD1
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfLKMau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:30:50 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40990 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728991AbfLKMau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 07:30:50 -0500
Received: by mail-pj1-f65.google.com with SMTP id ca19so8893557pjb.8;
        Wed, 11 Dec 2019 04:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K/y2oIRRhF2GBW1wRD/KjpZ9zXuv6w7I3mWnKh9t2ZU=;
        b=vJRwHGqvy59IPawj6bQpV8FyCfmBzY+E7ub7kIeETvxV6o+pYC0qX2JYA8i0uOAvji
         VgQP1bIocyKfUzrpOwKTkClea1Ih0fWdWnBxzJbtydG4ONHC1fESVECF+ZViXLjKP8zQ
         Fgk+/iELZFHG5E89H6qkFOahJcVM7Pc4qfTpLZBRda05zkocT/yOPZdJS53a7L06RBdW
         Upi7DNxDYeibjs1JDUtrClQxv69rlYYMG1v+Alh/AQVzVoERgA+/rD5r6Bdz8mhNFIKx
         vbEMC5W6AY2O0LjuG7n0MLLrTWMC6ibwfDx9dIrTRcychLeLW0/mlKf4verubKrGb/xV
         4H8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K/y2oIRRhF2GBW1wRD/KjpZ9zXuv6w7I3mWnKh9t2ZU=;
        b=dEsx0ouG1aGLvQR15uF+ZA+/UHME2N7bVkyoyFNQ78ws+i9eGZGUvAH7b89eRO280v
         gWrCrIwEv9lerkEzWhkPWSqz/PUYPe2eJxjMRQ48Tt0C144Z+Kk8a26YbhqYPLz2oQJb
         K+11qIxTzKZU6Ykkrwr5leUf5xQNnWJx9xay6sewinTqivHTX/bkQI9gtbK/HllDhKJw
         twkcaNkq6StWvM4rkmUFwJFAEQA+zqR0IFdauYQNG1dBjd5VyE57oVXqEf7Kyq7Q4wbn
         QMfyBRAnyMZeFB7BFRs/5WSV/pX/ASxAxSQw/61SfuYN0hL8TlivsLay6ESwkFTyiXTv
         Z0uA==
X-Gm-Message-State: APjAAAV1EJN5BHCJNi0kUDd6Sd/P+8TMQ2C3NVW6/w08OtNAIpytOyts
        cDI6XuPI4uMfGfsWkU/qRBK68fYdi2uCIQ==
X-Google-Smtp-Source: APXvYqxxtnCWE8cu/NEUexUt5k5pkDM1hI2TX3gzZRXJSHtKxg5Rm+SV3wlzxKYNPn335lNPyuBT7g==
X-Received: by 2002:a17:902:6a82:: with SMTP id n2mr3011967plk.5.1576067448975;
        Wed, 11 Dec 2019 04:30:48 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id 24sm3097132pfn.101.2019.12.11.04.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 04:30:48 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v4 4/6] bpf: start using the BPF dispatcher in BPF_TEST_RUN
Date:   Wed, 11 Dec 2019 13:30:15 +0100
Message-Id: <20191211123017.13212-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211123017.13212-1-bjorn.topel@gmail.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
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

