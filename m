Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E594621176
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbiKHMxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbiKHMxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:53:11 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AB563A7;
        Tue,  8 Nov 2022 04:53:11 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id v28so13707573pfi.12;
        Tue, 08 Nov 2022 04:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mNtuOEXDefEJXOGS36uoL5ZWOWYNWQBLQOQ1lh+QjkM=;
        b=jZv8R9YfnkF1S82Q0owrujyqmGBwB0NmQzOz+VxZdLY9mXaCSJ2214E/QOUcufWa3a
         fsqmr0nvYjFUf6cUykcGxU9NaXPJjMcWc13aBgH5Bg2ZFW4/bTmEnEdWrTWGgBu/YteR
         ui/qliXaZAKl4SlWM/S9GOoZ1DU12WdMLCMrWshhYfHy2isUgyblc9K6ItKkUSRX/EYG
         nQ5eUX46Ff9A8K45uI9ltjVUTrEU6jDwi3SKTt7crsXUxlL3Z5BOAARz7eAswEQoMvYl
         8jg1DHdSjbrjqM40wwLob+jvzHZwMqNH9YnHJOqxcjiXwsMVG+q8W1+QjiVeoE8moqYp
         Ooqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mNtuOEXDefEJXOGS36uoL5ZWOWYNWQBLQOQ1lh+QjkM=;
        b=55YT6MK9HErREe2EIYigzQlMCnsM1m5IHSeO5/p1ygWxFfRcpUVz0sf/G7VoJkdMx+
         qKb9+x+2zeUFZKJ1Kq87zGBEU6b3a3tOncljSQLnmZiFpJE4NoAcES5ZTnSCTeeEkbDV
         W3fDXTM+S6GM8g7bgOKdAdJwMUxtxWhHQOywsdGSJRjghOU3cVhJ4a0SyqkANWa7eFWD
         Ajzj+Zm7rD8I6u807dWstO9rHap4pfJegJyfMjJ4aadO3MyNzEvETUtjiQ0Nuif3M7CJ
         TBvsJNWkxytCpF5Erp0fe+IFOdL03nt3CvYDcLRq899sN/4eXtqXvTADuKgPx4mYyKwY
         K6tA==
X-Gm-Message-State: ACrzQf2eg3e8RmVfLIv7u0hEgXvRglV+fjx4aOL/jU0w0beGYlUlmSew
        nsARGDEOkk3maTqDyzIq5r8=
X-Google-Smtp-Source: AMsMyM42RmFxcbXDc61L1wAkixEu/D629iYcC1T4PwgihkXvFVkP1Q9O1ThSdcTTYacO2yFJ3Bb/Ww==
X-Received: by 2002:a05:6a00:2285:b0:56d:5d42:3aa8 with SMTP id f5-20020a056a00228500b0056d5d423aa8mr48146805pfe.79.1667911990653;
        Tue, 08 Nov 2022 04:53:10 -0800 (PST)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902b68100b00186a2444a43sm6807845pls.27.2022.11.08.04.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 04:53:10 -0800 (PST)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] net: macvlan: Use built-in RCU list checking
Date:   Tue,  8 Nov 2022 20:52:54 +0800
Message-Id: <20221108125254.688234-1-nashuiliang@gmail.com>
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

Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
---
v0 -> v1:
- fix typo

 drivers/net/macvlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c58fea63be7d..deb7929004a7 100644
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
@@ -1645,7 +1645,7 @@ static int macvlan_fill_info_macaddr(struct sk_buff *skb,
 	struct hlist_head *h = &vlan->port->vlan_source_hash[i];
 	struct macvlan_source_entry *entry;
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (entry->vlan != vlan)
 			continue;
 		if (nla_put(skb, IFLA_MACVLAN_MACADDR, ETH_ALEN, entry->addr))
-- 
2.37.2

