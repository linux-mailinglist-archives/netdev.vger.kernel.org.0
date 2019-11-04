Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84ACEDBC0
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 10:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfKDJjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 04:39:14 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43432 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfKDJjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 04:39:14 -0500
Received: by mail-lj1-f194.google.com with SMTP id y23so5875725ljh.10
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 01:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v8Gz0yBJbcEetAytEO+LJhBLsryOETzERFWEDqpIaYA=;
        b=J9m3BFkT/c4/OPNj2U8/1uXY+0HZVycZgcisapW4ewfYvgjZ/381Eb64uTLmxHqdZr
         qD4AEdZxP1YrGYSewoKY0dCnupT3gPfVK5gQRjguvp35X8t9jnEPz5igTfvSdyjc09vu
         3G7l9IekdCcC0v3Ug+IF/Ei5E7buX/seM0nA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v8Gz0yBJbcEetAytEO+LJhBLsryOETzERFWEDqpIaYA=;
        b=IAfFSzzJxwPLu3xBCboengl1NOgsQAxUr1ye4R4YnwGwqbNKV/D0U1AUPXx5vSO5c5
         c4G8bnfHuo9Fs4Zgf1pm23FpjI5sN1CLnoPKeRRURDPlInJ3ePKMVYev+0nKhu62Sv4k
         mpoBfF+bBj9msokoP5Lc3vD7r9QNb/DOsRWqyTmH1Y6KqBg6J4fVA3IPTfpTfhBiLuOs
         /gorgvadhysVVyZS+p+tfMujYlLMR+ejq7HKRnM37eMqpYOJZV0qRqLSUEatZGRVSWIW
         LmvlmPuWAVGs8jkDMcRH5ByqeOG4VcOT9nZ8DL/sxbUsxjM+UdzPZITBum1DtPxnJ0qA
         I+Kg==
X-Gm-Message-State: APjAAAWg8CixgI3Z75BbxPmYIfdDxHmdUuh9fznbqIX6vy1A4JF93NP1
        A93GxjEHAoZvTtfd/15/7K+T878xFf0=
X-Google-Smtp-Source: APXvYqxm2PJvcn9n/1/R6pvkpbCIHaWFh0d6PHZv57dlvpr4UZ6N5D3CXFlVChUwbaWPgxXcmNko5g==
X-Received: by 2002:a2e:86da:: with SMTP id n26mr17891872ljj.256.1572860352399;
        Mon, 04 Nov 2019 01:39:12 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v21sm6322576lfi.74.2019.11.04.01.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 01:39:11 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next] net: bridge: fdb: eliminate extra port state tests from fast-path
Date:   Mon,  4 Nov 2019 11:36:51 +0200
Message-Id: <20191104093651.16754-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When commit df1c0b8468b3 ("[BRIDGE]: Packets leaking out of
disabled/blocked ports.") introduced the port state tests in
br_fdb_update() it was to avoid learning/refreshing from STP BPDUs, it was
also used to avoid learning/refreshing from user-space with NTF_USE. Those
two tests are done for every packet entering the bridge if it's learning,
but for the fast-path we already have them checked in br_handle_frame() and
is unnecessary to do it again. Thus push the checks to the unlikely cases
and drop them from br_fdb_update(), the new nbp_state_should_learn() helper
is used to determine if the port state allows br_fdb_update() to be called.
The two places which need to do it manually are:
 - user-space add call with NTF_USE set
 - link-local packet learning done in __br_handle_local_finish()

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_fdb.c     | 8 +++-----
 net/bridge/br_input.c   | 1 +
 net/bridge/br_private.h | 5 +++++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 284b3662d234..4877a0db16c6 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -566,11 +566,6 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 	if (hold_time(br) == 0)
 		return;
 
-	/* ignore packets unless we are using this port */
-	if (!(source->state == BR_STATE_LEARNING ||
-	      source->state == BR_STATE_FORWARDING))
-		return;
-
 	fdb = fdb_find_rcu(&br->fdb_hash_tbl, addr, vid);
 	if (likely(fdb)) {
 		/* attempt to update an entry for a local interface */
@@ -886,6 +881,9 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 				br->dev->name);
 			return -EINVAL;
 		}
+		if (!nbp_state_should_learn(p))
+			return 0;
+
 		local_bh_disable();
 		rcu_read_lock();
 		br_fdb_update(br, p, addr, vid, BIT(BR_FDB_ADDED_BY_USER));
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index f37b05090f45..8944ceb47fe9 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -182,6 +182,7 @@ static void __br_handle_local_finish(struct sk_buff *skb)
 
 	/* check if vlan is allowed, to avoid spoofing */
 	if ((p->flags & BR_LEARNING) &&
+	    nbp_state_should_learn(p) &&
 	    !br_opt_get(p->br, BROPT_NO_LL_LEARN) &&
 	    br_should_learn(p, skb, &vid))
 		br_fdb_update(p->br, p, eth_hdr(skb)->h_source, vid, 0);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 08742bff9bf0..36b0367ca1e0 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -500,6 +500,11 @@ static inline bool br_vlan_should_use(const struct net_bridge_vlan *v)
 	return true;
 }
 
+static inline bool nbp_state_should_learn(const struct net_bridge_port *p)
+{
+	return p->state == BR_STATE_LEARNING || p->state == BR_STATE_FORWARDING;
+}
+
 static inline int br_opt_get(const struct net_bridge *br,
 			     enum net_bridge_opts opt)
 {
-- 
2.21.0

