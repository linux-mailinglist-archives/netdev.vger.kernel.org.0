Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD062CFA63
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 09:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgLEIAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 03:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgLEIAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 03:00:45 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8F8C061A4F;
        Fri,  4 Dec 2020 23:59:58 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id h3so9084738oie.8;
        Fri, 04 Dec 2020 23:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n+gjpL22PdwtnyjizZfGUEUvMA1yz9k8zAS+MKH6L4Y=;
        b=nYRPcxXsDIPIZoYjLQk+CPzMFmlYAfwELkMGwNZcWQlwaGC1RFmp2D37noyudNSFDG
         IGlAn2SfdcVQ9V2Tlycn7v5xX4Mc08IG613LXaE6BXFbC3b1gVRbft6ds8z49lO0BJq7
         yFW0PlhCkm8/qc4ER3LIHLO/rvqiMbymUk8nZ38RFTA9O6YQ/061Mne2Dmp4PdVksRms
         lRV/sJHyBaD/VB1GeLebpr9e9xb/RpR1xXX5uvoK7aIpMMZUlRbWn/JQjmF4fbj32GVe
         RYBOJxE4jG0jRCGApmlLhy5zeWqrQewvJIPM1UvC67iU36SdJUaFjCOqA+BEmeXJNMGa
         R/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n+gjpL22PdwtnyjizZfGUEUvMA1yz9k8zAS+MKH6L4Y=;
        b=Ek59clszTbiY1n+AU3maKNeZ74iTyHiPM3xXYawvTwtb2O+1b0Lw2ZYSieSa7GFvXS
         ELXhFA9yMQr5nPzQIIgjZRpMfED68n73NJ0MhX4+43kJEedmbAc26216RgOqikjOiR7j
         iuOR1S2ucpncLiopHHlZTnYnhu72b/zQ++IISwi/B4elAqkYx3hf0qXXIdYJFqG3ssPP
         muImS4EC5xonOdd4jKKfQA6gFcKMKKSzDKaaFS6Nx4WNh47XRDXo75R3FHWbnLJendnu
         cLsJ5xhivQtF41s4Scz8s5AofVSBGNfv8j/WxXEv69P9esqSBu4sqZKeoZhjhQo7zq8t
         XLxA==
X-Gm-Message-State: AOAM531P339GZ2am1sxMNGFQKbB2vk58lExvc1jPTOyCYRSfsjRVcWbT
        fPbO8EAEmyv0Wbwj++CC0bPpU08q7g2Dyw==
X-Google-Smtp-Source: ABdhPJzr3IpP5GgHCaUoKqWAC/Ql6v11RLOi4wnPq0hTFkn5s9bfbfoZ2is3+xyx2Xgm5m0Z3adicg==
X-Received: by 2002:aca:811:: with SMTP id 17mr6040186oii.109.1607155198112;
        Fri, 04 Dec 2020 23:59:58 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:2482:49a9:7a40:f76b])
        by smtp.gmail.com with ESMTPSA id i82sm1263305oif.33.2020.12.04.23.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 23:59:57 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [Patch net v2 2/2] lwt_bpf: replace preempt_disable() with migrate_disable()
Date:   Fri,  4 Dec 2020 23:59:46 -0800
Message-Id: <20201205075946.497763-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201205075946.497763-1-xiyou.wangcong@gmail.com>
References: <20201205075946.497763-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

migrate_disable() is just a wrapper for preempt_disable() in
non-RT kernel. It is safe to replace it, and RT kernel will
benefit.

Note that it is introduced since Feb 2020.

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/lwt_bpf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 4f3cb7c15ddf..2f7940bcf715 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -39,10 +39,10 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
 {
 	int ret;
 
-	/* Preempt disable and BH disable are needed to protect per-cpu
+	/* Migration disable and BH disable are needed to protect per-cpu
 	 * redirect_info between BPF prog and skb_do_redirect().
 	 */
-	preempt_disable();
+	migrate_disable();
 	local_bh_disable();
 	bpf_compute_data_pointers(skb);
 	ret = bpf_prog_run_save_cb(lwt->prog, skb);
@@ -78,7 +78,7 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
 	}
 
 	local_bh_enable();
-	preempt_enable();
+	migrate_enable();
 
 	return ret;
 }
-- 
2.25.1

