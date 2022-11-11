Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AC4624FC1
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbiKKBly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbiKKBlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:41:52 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C69B627F0;
        Thu, 10 Nov 2022 17:41:48 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so3477118pjk.1;
        Thu, 10 Nov 2022 17:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=orhM7Rfdk0osFddng1SzY4yb/5vhA8/Z7hW4tdCc1iE=;
        b=IEJbJI0+sK5kz21pv/o/x5DX8Zvj+a3eJTIdDF/2KjrmEUj8QJyZmFFqy4pFcqp2Ua
         EKzAKeTjbanuXIOVAbip8YSN9ZoMKSo9RfjhOFAsxT9cLvjE/pd7EHAynMdywegNHndp
         OtC8rb8GO9CORgzHKHpmEIo3vj4Rr3vfEsUNjyaJZnDXQJcm4y1wr6yyqxWG8GfKJeOw
         Sz4a1VIe9DE2hHcG/hNXvh7d3QivXdNRPtsSCYzCPsyl+ikrY4S25jhzX6axRVOAExvA
         Z1tnVLSAJllppeZVF3drVGMJ00yHjZp7PlFuWBpFabvKZz63KNpV4zraF2rUWrUTRWNY
         fdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=orhM7Rfdk0osFddng1SzY4yb/5vhA8/Z7hW4tdCc1iE=;
        b=YkV5/Jnd4F8+avJoj6wRYMDvvR82aKwOoTRw/huD7fGKlYcR5grGbhCZpyR+Mo/mOK
         YZTVlK6n7TijamQu3/fr4MPDz8/2UCMn621w2dndfXDJlp5gUi9VDiNHKndSQ2Bn+Bli
         7ytDdet80KgBBbwaYWH6khyptv0Q3K0vBXkJv0CZQngpXa//1Mj8JbybDyOy9LGJfguc
         pXIsQBr4O/NSjbATPo9NMHOIl8n9pqXbeLF46ZrapjJ2EL78PeJdurx1HQBfcfnh4kMS
         tZ0DV+mKRx5dW97wsDDCfeHu9mxglG/vHd3bKMWMj4ECd6oMpXb26DoVhudGppuCLa0V
         jKyA==
X-Gm-Message-State: ANoB5pmabIhArErzVs7fOU6KmzPOi152ke3XDw2q51Jv9WMZ/qo8wwfq
        6iWxrapxD2PqV18ffwS9u5I=
X-Google-Smtp-Source: AA0mqf76XwJ1wkQbrkUg+nQZtVFsq+fUytf76VzVz9Ni4T/Rrniz/Ng647bIIecQkvQtmK1YsobUIg==
X-Received: by 2002:a17:902:9a01:b0:186:9c43:5969 with SMTP id v1-20020a1709029a0100b001869c435969mr105570plp.32.1668130907524;
        Thu, 10 Nov 2022 17:41:47 -0800 (PST)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id y10-20020aa793ca000000b00562cfc80864sm317578pff.36.2022.11.10.17.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 17:41:47 -0800 (PST)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Braun <michael-dev@fami-braun.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: macvlan: Use built-in RCU list checking
Date:   Fri, 11 Nov 2022 09:41:30 +0800
Message-Id: <20221111014131.693854-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hlist_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to hlist_for_each_entry_rcu() to silence false
lockdep warning when CONFIG_PROVE_RCU_LIST is enabled.

Execute as follow:

 ip link add link eth0 type macvlan mode source macaddr add <MAC-ADDR>

The rtnl_lock is held when macvlan_hash_lookup_source() or
macvlan_fill_info_macaddr() are called in the non-RCU read side section.
So, pass lockdep_rtnl_is_held() to silence false lockdep warning.

Fixes: 79cf79abce71 ("macvlan: add source mode")
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
---
v1 -> v2:
- fix the patch Subject, add a Fixed tag

v0 -> v1:
- fix typo

 drivers/net/macvlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 578897aaada0..b8cc55b2d721 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -141,7 +141,7 @@ static struct macvlan_source_entry *macvlan_hash_lookup_source(
 	u32 idx = macvlan_eth_hash(addr);
 	struct hlist_head *h = &vlan->port->vlan_source_hash[idx];
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (ether_addr_equal_64bits(entry->addr, addr) &&
 		    entry->vlan == vlan)
 			return entry;
@@ -1647,7 +1647,7 @@ static int macvlan_fill_info_macaddr(struct sk_buff *skb,
 	struct hlist_head *h = &vlan->port->vlan_source_hash[i];
 	struct macvlan_source_entry *entry;
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (entry->vlan != vlan)
 			continue;
 		if (nla_put(skb, IFLA_MACVLAN_MACADDR, ETH_ALEN, entry->addr))
-- 
2.37.2

