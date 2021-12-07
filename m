Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0BE46AF6A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378743AbhLGAzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378742AbhLGAzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:25 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132D4C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:51:56 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q16so12074861pgq.10
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tywiGhRxZ+CAj26AzF1n0UBYubicZtdRU8HSzaFGn/c=;
        b=ntCvzCtib317ku61TNl7/Jzx0BJFnLNolv+oLxtEbydwW6m6LP7jGaRulCNbdF1igq
         1Cn72hK+LAkgamZgGO9s/cF8/N9QcG6ptJ5iM6n7g+FWgdbw5Wt/lJOegbl0AqcaUN5M
         RuVIVHHT7+vAjaxtshWmK9vHufAlrnbsmWF/aIKpaNBzdj/jLa8JdaCOvsh/x9mkSy46
         U9IVLU4TffwSHbEL4FH4YcyWTXMgnwpLyLe5/f+ogizyXgIpsZFDkCwIrCvtKypYofRp
         /21wLxaDCFO4PxPGMS9I5r14rBWz3djbO3RWc9yDHCyJYGFcxItV/1C3ZzXQ8bWWYXne
         PC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tywiGhRxZ+CAj26AzF1n0UBYubicZtdRU8HSzaFGn/c=;
        b=EdGEr/jAlMXo2FH4ZkudWjf/TWvFewBJHDhYKkhNvrlxqW8DpyeXmCp9HqfWeJpwOe
         sQCUgqKnShT0KARuvJLsjO//V2Q4n2xWgOxWix/KIZEKE01jNCmZoT3WT4LiZlG50rjZ
         8oPg57klzMedv3AlsgDH9nlRGKocfpO4YayWhyBrIGg2esekarpxuwGwgTS9z+FSz3zR
         IwJWs6TGevAgflMGxIKzHTnu6w346FxhAhrPJNwAEsITf1qUpu4mIsAy8uJxIWLIL+XB
         BvdvmxFAg/eDIw80lYi88WY9SXIrEjfPAwsR15JB8wzSkZn/yWSyDbg4fhQLrpp8tfah
         Lmew==
X-Gm-Message-State: AOAM531eevxeqSis9nD1g3c2gPPObMsRlr4QJfB2gdmQwYdE5vOYMTd8
        iir1Vyx8lGtDqGRZ54BeH+Q=
X-Google-Smtp-Source: ABdhPJw5nw4orHOPA4p7HKvyyXLnc54qUbZsNhFQ01lXMCnJy04/kOlpcAMVmzFC+5hezcqpXBMbkw==
X-Received: by 2002:a63:f410:: with SMTP id g16mr21121410pgi.423.1638838315652;
        Mon, 06 Dec 2021 16:51:55 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:51:55 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 04/17] net: sched: add netns refcount tracker to struct tcf_exts
Date:   Mon,  6 Dec 2021 16:51:29 -0800
Message-Id: <20211207005142.1688204-5-eric.dumazet@gmail.com>
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
 include/net/pkt_cls.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 193f88ebf629bd5a66c2d155346b40695e259a13..cebc1bd713b68e9c9c7b7656f569e749c0dc9297 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -202,7 +202,8 @@ struct tcf_exts {
 	__u32	type; /* for backward compat(TCA_OLD_COMPAT) */
 	int nr_actions;
 	struct tc_action **actions;
-	struct net *net;
+	struct net	*net;
+	netns_tracker	ns_tracker;
 #endif
 	/* Map to export classifier specific extension TLV types to the
 	 * generic extensions API. Unsupported extensions must be set to 0.
@@ -218,6 +219,7 @@ static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
 	exts->type = 0;
 	exts->nr_actions = 0;
 	exts->net = net;
+	netns_tracker_alloc(net, &exts->ns_tracker, GFP_KERNEL);
 	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
 				GFP_KERNEL);
 	if (!exts->actions)
@@ -236,6 +238,8 @@ static inline bool tcf_exts_get_net(struct tcf_exts *exts)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	exts->net = maybe_get_net(exts->net);
+	if (exts->net)
+		netns_tracker_alloc(exts->net, &exts->ns_tracker, GFP_KERNEL);
 	return exts->net != NULL;
 #else
 	return true;
@@ -246,7 +250,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	if (exts->net)
-		put_net(exts->net);
+		put_net_track(exts->net, &exts->ns_tracker);
 #endif
 }
 
-- 
2.34.1.400.ga245620fadb-goog

