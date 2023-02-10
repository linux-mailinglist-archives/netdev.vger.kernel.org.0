Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C34691908
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 08:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjBJHRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 02:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjBJHRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 02:17:41 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC07A38EAE;
        Thu,  9 Feb 2023 23:17:40 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id gj9-20020a17090b108900b0023114156d36so8455241pjb.4;
        Thu, 09 Feb 2023 23:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676013460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x8ziFCwcKLLgygAWKbNwFQ9zSNQ7NfVya7SSGjz6xHM=;
        b=CgOtCZRKUEnzDVbt0Of8QdPPYuFKQssFheSCwwZq2BzvI1j7rRsYMlWSPnxfzAQmSL
         GxrTXzyJh+T1t8hwnBNePHbNWAvyEIEJVGscNhCd7ox+Txl4YS5ASAd2Q2rlBqiYVzl4
         HOwkmNqiCn4+OypTBo+LwX2uj9GnuTeD31yESW6Eau75mcYBKhYUp/Rd47Brm+ieb7Hz
         amlVmJZdMKwGAHgOURiR5pzmLJeTpZhqAWm7WDLhyemNEHeiU7JLIzOZNevCxAhYT6c4
         Q0q3v61qBvKMp0Tsv+7mZNAeFO6FZpFKn94PtJgUAb38N/MR/OZrBUdeeZRB9WajbQUs
         XMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676013460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x8ziFCwcKLLgygAWKbNwFQ9zSNQ7NfVya7SSGjz6xHM=;
        b=euP3b9SPAFJfvGQ5FwcQwzMPCsN5uB/R+wv5/pgi/9cUSZ2Ek9MUDOizIk981zvJc+
         61Q37BQBjOVdFjYzCRwZEp2kOrsNcDwIwjBPV8aOYhKtRqEyY1aqlVfVEc/pXruKRobo
         M6PesY0UnY0uhvsyJiHY/HUPKnXHRepRoQS6aIJ8p9Itveji8oH0dKyWJ1xGxrT6e82P
         5MElCVQsA4OpK2DhYIws4dSi1Hr1luZqNd/ETvd+GcrpvoKCa1wuYMEEa66f2i6kuhf8
         66i7s5KGms8UVoyhTsMJBdvciTu0mbS1W6aptuOTqny1Nu5RHwpN8XMPnbJMZsusYtKz
         f7HA==
X-Gm-Message-State: AO0yUKX6RW2vAMP/ahhG2Qo5e/iOZtZ3k4uL9A6uzDiuNgEC1gcUZSib
        gDEfUt0wyyIF9QrapnxGQEY=
X-Google-Smtp-Source: AK7set+Lr4c23g9gc6mlIlsPVaWfA+xOrN2cWnX14DjlF5n4rzO57Qrv9VmpsdHa7QUghzE9eypo5Q==
X-Received: by 2002:a17:902:f685:b0:199:190c:3c0c with SMTP id l5-20020a170902f68500b00199190c3c0cmr15736665plg.2.1676013460458;
        Thu, 09 Feb 2023 23:17:40 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902728200b00194ab9a4febsm2703645pll.74.2023.02.09.23.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 23:17:39 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: netfilter: fix possible refcount leak in ctnetlink_create_conntrack()
Date:   Fri, 10 Feb 2023 15:17:30 +0800
Message-Id: <20230210071730.21525-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nf_ct_put() needs to be called to put the refcount got by
nf_conntrack_find_get() to avoid refcount leak when
nf_conntrack_hash_check_insert() fails.

Fixes: 7d367e06688d ("netfilter: ctnetlink: fix soft lockup when netlink adds new entries (v2)")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1286ae7d4609..ca4d5bb1ea52 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2375,12 +2375,15 @@ ctnetlink_create_conntrack(struct net *net,
 
 	err = nf_conntrack_hash_check_insert(ct);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	rcu_read_unlock();
 
 	return ct;
 
+err3:
+	if (ct->master)
+		nf_ct_put(ct->master);
 err2:
 	rcu_read_unlock();
 err1:
-- 
2.34.1

