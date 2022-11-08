Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E2862113E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiKHMqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbiKHMqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:46:32 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FD152893;
        Tue,  8 Nov 2022 04:46:29 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b11so13696222pjp.2;
        Tue, 08 Nov 2022 04:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YNc/G0OgX6mRUqDaT1FnoUWK1fg7o1iEbVRmjeCcsXw=;
        b=aKOpFVM0RW2BSTVFW5ZukFkv25qGW/AYoM5Oiakp+KCW2IZ/+/Bf+DT/AO+9xHwY/N
         DVPMyT9n9wlAMt2Hgks5Sf83LKIg5jobwZmEz+7UMkfOi+Y5EQKfyhc73Xyg59/llCCE
         6+l4sLnPjPUuW9udf60k8UDuxlPIXDi/RDuvu10xdrshgV7OQYt84yrUCcQ1yYq0ZaC3
         fk6L2Nz0IO5A0LBYhrNpCqeBCeUfcSL+cfcYS2+K7+rgerczG+tBCoJsrZCMUUzsnipa
         2CRFBuMvr+aSgLk0c+BD3maXsoC+RG79n98srSo4Fv1WhokV0oOpKkLUhjzPqCQrTcjn
         6Jdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YNc/G0OgX6mRUqDaT1FnoUWK1fg7o1iEbVRmjeCcsXw=;
        b=dJd/+TfeRlDiW5jz7QuemO2/5hv2HbWZvKfgQgyn5jUDA3FTazBPXjcLE10J6GyMxu
         LOsC1KEqqTb+1kVxodGx0FcV8VclBwO/Fc3d5PacqGn6VDSGdGp8Fp5j55tGO0k+IGxx
         So8M1aCynabj3mUFdcxtwcaDL1dUTVeX6arB9tM30sNL3zuLON/YLQ4nTOxg1R/CtD6a
         SSm7celjXOiJXqwq6Ee2endUT3ihImq6H87Qo8FYfDGPG/Bz293Go5pYRnvcb/lvRl3z
         Iy+DNp81wGOtD/1XDTP1GpP05PCDDHmDPmn7t8UPPY2R+prEMu9J5n+Jq3Tlfq3VPjku
         sQWA==
X-Gm-Message-State: ACrzQf0Kp1m7d2Sx/suLRzl5PKURKi5U+Tw4kYSkKjc/aFK9QgSK+1Iu
        1Wdk8NAoj2+TuN7Caawttx5zicgrBqI=
X-Google-Smtp-Source: AMsMyM7fsdFYP6lMCtHpgoBPRf6wcV9Mx9DwIEFuQ81G4M6+B21tgAyHZJEG3Eq4YEE5i6X+lS0U7Q==
X-Received: by 2002:a17:902:ea04:b0:187:4923:56f4 with SMTP id s4-20020a170902ea0400b00187492356f4mr33978874plg.97.1667911589396;
        Tue, 08 Nov 2022 04:46:29 -0800 (PST)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090341c600b0015e8d4eb26esm6785185ple.184.2022.11.08.04.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 04:46:28 -0800 (PST)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: macvlan: Use built-in RCU list checking
Date:   Tue,  8 Nov 2022 20:46:11 +0800
Message-Id: <20221108124611.688031-1-nashuiliang@gmail.com>
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

list_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence false lockdep
warning when CONFIG_PROVE_RCU_LIST is enabled.

Execute as follow:

 ip link add link eth0 type macvlan mode source macaddr add <MAC-ADDR>

The rtnl_lock is held when macvlan_hash_lookup_source() or
macvlan_fill_info_macaddr() are called in the non-RCU read side section.
So, pass lockdep_rtnl_is_held() to silence false lockdep warning.

Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
---
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

