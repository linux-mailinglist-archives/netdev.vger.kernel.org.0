Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524A557773E
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiGQQMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiGQQMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:12:45 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C8014D13
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:39 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e132so8638680pgc.5
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T7jJfuQoI/zAs+0wTsZFpJFNNINBRQJRY9aIrhVtCac=;
        b=akt6HxozCgjfyAgu/p+8ik9KDNkB+3K97ozFzd5aNi1E3r6Ty8njezemcTJLa1nzEc
         k+2PBGD5YiM2DVWVDhq+BcEunNnoaMJ6qZduzEMrHBhVZZTMvNa0jsFyrUtfgUuNyEnT
         SmbNdH24UN9NFQJKrcTx7PTu5J7grLQgc8GxAE1+gVdIIDnOcbHI/FEeZJCRvQdgV5Wg
         HUqO96u47wUzT4SNo3kT8NACPt7JJ6uD8K3Wo5yDRT6+PR1BvQzRcdq0gLulFo7rs+KJ
         bs9L18tczH2O+jUitLk982RSQmzhbcxcaspXnHItjh6CzvxlBJKHrCVWwm2ZoturAvnx
         HWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T7jJfuQoI/zAs+0wTsZFpJFNNINBRQJRY9aIrhVtCac=;
        b=d75k9h7C/m2LAaDvBLlbojM+QKkcrOlJJEkBsIei6nvKqMCDPw+n8kX/LerwAyukLP
         o0ZwhMGZjqOwJnO8QVpLQ83s77PvjXI0ZWOTQrIx5MAALElNf7Q2aQphIe3Uy7+idKaU
         j34g5HPphr5khGtzJ5X7j2AIDkWI4ftqIqfahr+dzIc8Ka1z7eY0KbwgxZUriqHN4bbV
         1cWH8q84xkTNd/iwVPh+Z5NUyUBpIh20VSjljA/NWIUkwkeWNew2BzzA+vO2CJgIzsIb
         eEJoDwR6O0kkQXeSHmE3KsJuwT9Yf83LjnIkdC3x8M4To18TGK0aUy8koHzGkWsC4sdd
         Qthw==
X-Gm-Message-State: AJIora93B+R3H+IfaaWHf5lj7S/TIw63LtHAESb/jK+pMaktipriuEaA
        3y/0P9xCtQT2fUOYqoVPrdA=
X-Google-Smtp-Source: AGRyM1t2H7baGcHobhouoTtgXtBKwZtOvH+xCUWHKzN67FOcuzy78y8ZdLI21U843sEHJooWj7My6g==
X-Received: by 2002:a63:b44a:0:b0:40b:8ebd:524 with SMTP id n10-20020a63b44a000000b0040b8ebd0524mr20330114pgu.207.1658074359210;
        Sun, 17 Jul 2022 09:12:39 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm7443026plg.171.2022.07.17.09.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:12:38 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 8/8] amt: do not use amt->nr_tunnels outside of lock
Date:   Sun, 17 Jul 2022 16:09:10 +0000
Message-Id: <20220717160910.19156-9-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220717160910.19156-1-ap420073@gmail.com>
References: <20220717160910.19156-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

amt->nr_tunnels is protected by amt->lock.
But, amt_request_handler() has been using this variable without the
amt->lock.
So, it expands context of amt->lock in the amt_request_handler() to
protect amt->nr_tunnels variable.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - No changes.

 drivers/net/amt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index ecd2de22bdfc..0f2983f1897e 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2679,7 +2679,9 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 		if (tunnel->ip4 == iph->saddr)
 			goto send;
 
+	spin_lock_bh(&amt->lock);
 	if (amt->nr_tunnels >= amt->max_tunnels) {
+		spin_unlock_bh(&amt->lock);
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
 		return true;
 	}
@@ -2687,8 +2689,10 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 	tunnel = kzalloc(sizeof(*tunnel) +
 			 (sizeof(struct hlist_head) * amt->hash_buckets),
 			 GFP_ATOMIC);
-	if (!tunnel)
+	if (!tunnel) {
+		spin_unlock_bh(&amt->lock);
 		return true;
+	}
 
 	tunnel->source_port = udph->source;
 	tunnel->ip4 = iph->saddr;
@@ -2701,10 +2705,9 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 
 	INIT_DELAYED_WORK(&tunnel->gc_wq, amt_tunnel_expire);
 
-	spin_lock_bh(&amt->lock);
 	list_add_tail_rcu(&tunnel->list, &amt->tunnel_list);
 	tunnel->key = amt->key;
-	amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_REQUEST, true);
+	__amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_REQUEST, true);
 	amt->nr_tunnels++;
 	mod_delayed_work(amt_wq, &tunnel->gc_wq,
 			 msecs_to_jiffies(amt_gmi(amt)));
-- 
2.17.1

