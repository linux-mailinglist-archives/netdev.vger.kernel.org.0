Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403E755719E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiFWEko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245056AbiFWEe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:34:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1050830F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:34:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o199-20020a25d7d0000000b00668ab46306bso15570583ybg.6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wwSFzfJ2SWCyUmQ5lfdkSc585bMTz54WWciPG1drR9k=;
        b=lODiJuaPbRG2t6Tlrk+7EudZx62eCyBbEZMr06Gs+Kqhpw1vn1/b9yi7zmn/Z5RvpN
         mgMgp1cAoCTnIeKSnSaK8fW1qT0oLsApG6UpPqbbnjAJ3CJ6iXuYMMjKLsfYNUvbyXfc
         Og5a7p82ZD5b3N3O8pBcFC86yX760A+82oBVtoD8iMz/U0klgFOIR1U5zIgAteS4P97q
         272BPCH9WK2KzDgtKET77r29U3b6QVa6jye0UKIsGPcvKJRWucNLLdHKppELhLWcRy7B
         swC2mbDHGHOPkgw3C1ohyHkAiHbPC3J5fuphtVvop1GGbkrT3p0FaoqwsmRI7jsgBmus
         fPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wwSFzfJ2SWCyUmQ5lfdkSc585bMTz54WWciPG1drR9k=;
        b=CUYQq4l95Lj0rZLhf4ddFicp1JW04nn8EeRgHWNdbDdccw/XPhOnlexhGTs2qBTRUe
         jUhZ3FSBugHk7WfuNqxhB8TOURk9IgQCRXxqiQ1hWGd+6RIjWrMBIdhhyoxg2ra7TxSI
         iPgcXR7n/WrUaS42iAD7lX9e5FnwTHtRkc5Il2qbwJKQf93lDBK8xEN7DmTFZnaf5quN
         spJpJANH5D6d5ZW/VpKpBUzphSyLYyJcmw9S+zzAANx7XqUVqajBrMqVpiIoFoTvVqQ6
         m8CIfXdlrYvpwqKW8v/e3hocBDS5Uz2+AFEFkymI5jglZ32KqIuCUhTUvjyaxZouylox
         25QA==
X-Gm-Message-State: AJIora/UGoXhNqEfpNKVzYo5EIgRCE4Mxch2++4CdYHejWquWRbBJk/F
        mU7gMwFlWwXQ3wtFlxGgSrLKCRMSsXeEEg==
X-Google-Smtp-Source: AGRyM1us6DUZYvkSErwnmkBJTpD5Z8il+EDnU5VL1pLSPfvCGFLtqJ6qOWxmFxaHKy525K41e1J8yx1aHzFhrQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:3ac5:0:b0:317:8cb0:99b0 with SMTP id
 h188-20020a813ac5000000b003178cb099b0mr8502286ywa.71.1655958898321; Wed, 22
 Jun 2022 21:34:58 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:31 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-2-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 01/19] ip6mr: do not get a device reference in pim6_rcv()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pim6_rcv() is called under rcu_read_lock(), there is
no need to use dev_hold()/dev_put() pair.

IPv4 side was handled in commit 55747a0a73ea
("ipmr: __pim_rcv() is called under rcu_read_lock")

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index d4aad41c9849f977e395e9e07a4442dbfec07b1b..aa66c032ba979e7a14e5e296b68c55bc73d98398 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -554,7 +554,6 @@ static int pim6_rcv(struct sk_buff *skb)
 	read_lock(&mrt_lock);
 	if (reg_vif_num >= 0)
 		reg_dev = mrt->vif_table[reg_vif_num].dev;
-	dev_hold(reg_dev);
 	read_unlock(&mrt_lock);
 
 	if (!reg_dev)
@@ -570,7 +569,6 @@ static int pim6_rcv(struct sk_buff *skb)
 
 	netif_rx(skb);
 
-	dev_put(reg_dev);
 	return 0;
  drop:
 	kfree_skb(skb);
-- 
2.37.0.rc0.104.g0611611a94-goog

