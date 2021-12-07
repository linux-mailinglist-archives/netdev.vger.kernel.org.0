Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CC646AF6E
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378791AbhLGAzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378742AbhLGAzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:32 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677B7C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:03 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id np3so9031032pjb.4
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/d8nwCdhAWoeqFwhelhs0ajxIL9Dr7l9LAWxv+OUSP4=;
        b=oa+1fme953nX69A5u7mCAggq3t8kuFqiOfOOb+FOXPJojAZ8TaTCY8VSPNsKTi3gyw
         7FmIpfHrEiJZouWSv7z4k9yr++vL2+nrgTKib1diyo877Cp/l7xuBLvpBY26Wjjs/qk3
         9GIZ9bDy5yMUoGbnowxzTqqKWShtBzdC4lMV7OLYNRRnwETWS3syMgT/fABtn2CV9A4V
         wrEsVK4ukj/RLHSS2ylSZVt1CFO1UbP63GcN+ekk9I03+fTmRGZVd5m7PBnDrUxarmuw
         w/AZPJ7uvBAoCvgMCujO2n+1nu6N1fx+54I9dNdhh0T6uzkl2RfobOioRG9LsQYe0w91
         PTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/d8nwCdhAWoeqFwhelhs0ajxIL9Dr7l9LAWxv+OUSP4=;
        b=uK0M3jH6/BZ+ZoBhOsXmWp0HGL5qhmZjM+DGM8u7f8pLG6zTUeVyqmPy/UhbvIOWX1
         ie6PBZcQYCA+isYtqE9ifACwxPxYm+89AR7meedVcT7U80unIelk7v5CltJ590UiSAI3
         NaTx0EC/61lM24qugsmYJl1wEYmAybX4pw9ay0QZQqWJtdSk0xyzI0zaH6XCCiPMDU4n
         wMsQydsr3xzGzdnurCY+DIqz2QirK42SuKipaZaTnUZO9q/v3XPGLGCam+SBiEB76b+b
         Vr55/EqKrRCdjREzNlkpxwdNPt/WWWhyQ42M4wAnm4zvl7F3LBCToWsybXhzoGNGIPR1
         VAwQ==
X-Gm-Message-State: AOAM530jB+M8XlIsw1KX1ZzZHTSnTlMZDiOqV+ml/t2qLR8d7IVurJPJ
        WolLvhDy6BDjAih2abuT9ck=
X-Google-Smtp-Source: ABdhPJwaYFLsdZDULH9fxCHZfE/TLbs1qmVhSjJeNrhU3OpDPAHnh2Hkqc4YHyp44c0d2kwxPxWKZg==
X-Received: by 2002:a17:90b:1a87:: with SMTP id ng7mr2590278pjb.230.1638838323018;
        Mon, 06 Dec 2021 16:52:03 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:02 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 08/17] netfilter: nf_nat_masquerade: add netns refcount tracker to masq_dev_work
Date:   Mon,  6 Dec 2021 16:51:33 -0800
Message-Id: <20211207005142.1688204-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_nat_masquerade.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index acd73f717a0883d791fc351851a98bac4144705f..e32fac374608576d6237f80b1bff558e9453585a 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -12,6 +12,7 @@
 struct masq_dev_work {
 	struct work_struct work;
 	struct net *net;
+	netns_tracker ns_tracker;
 	union nf_inet_addr addr;
 	int ifindex;
 	int (*iter)(struct nf_conn *i, void *data);
@@ -82,7 +83,7 @@ static void iterate_cleanup_work(struct work_struct *work)
 
 	nf_ct_iterate_cleanup_net(w->net, w->iter, (void *)w, 0, 0);
 
-	put_net(w->net);
+	put_net_track(w->net, &w->ns_tracker);
 	kfree(w);
 	atomic_dec(&masq_worker_count);
 	module_put(THIS_MODULE);
@@ -119,6 +120,7 @@ static void nf_nat_masq_schedule(struct net *net, union nf_inet_addr *addr,
 		INIT_WORK(&w->work, iterate_cleanup_work);
 		w->ifindex = ifindex;
 		w->net = net;
+		netns_tracker_alloc(net, &w->ns_tracker, gfp_flags);
 		w->iter = iter;
 		if (addr)
 			w->addr = *addr;
-- 
2.34.1.400.ga245620fadb-goog

