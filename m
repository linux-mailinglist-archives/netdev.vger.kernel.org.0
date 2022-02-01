Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95CE4A549E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 02:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiBABVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 20:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiBABVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 20:21:10 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860AAC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 17:21:10 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h12so15611092pjq.3
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 17:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iz/7Dv8FSkb0GUygh9Iq2RxofgC1S/b0i9CCe4tSEFM=;
        b=BformxepPXenAjG5nig2zwUdYlumF1hXMaX8La7tVtbEDMYe5gyhegpWGLwKjgUVxn
         g0Ad8AI6YMgHTO+adi4zY3UoxxnDvBXaeL1iqwQaAxXs8+PL0xZDjX4aqKuoa1t2z2+X
         y3l117oDazWtMUzxpBUNBXiEKtNxEYLAmyx8gUSOPzAqpebOrvBnMekQMvDarfpfl0hr
         COCHRPTWrBZihYU3P949y1VQndk/1Z653ge8ydkcnpWiVJsWAPmGXux3h38mxO/mVI/y
         dr/WTbTeUO7GpIbaajcZkMsKpwDHFI7lvCewssAgUbTqbTC2Up+gN9JuW/1023a05gzS
         zh/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iz/7Dv8FSkb0GUygh9Iq2RxofgC1S/b0i9CCe4tSEFM=;
        b=nuwxxcdvhXVUxryrk00fdHZ5avsfso+51ph2yx2zE5F+32LWrYvrbS3rLyK/IC6HZP
         n8IRu5omzH74UIW1hqfWx0e34Q3sIeGjYuF+zjbDcx9apMd9crcnkumuAFzEvJdpZqLS
         Jn8Vebp175mhRsi0mO9anndmRcgP7UvZxg7kC4J87l58/g4dhyi/xiDZsnE2yx019Pyi
         n5jgNGjkvfAPi7rlPBmldnQ9pJuY0JXCW6QA9awceAUhLkUFeawAKpO4g/bAr4tOsMQQ
         toxQoMfExq5LUPvhQ2K8D41cmTVUewz/jn4aZoc1DlP1WxXOTh+DA9su/CfGLaZE7wZB
         gSNQ==
X-Gm-Message-State: AOAM530Nojz0fjHUxKxUBiEcxGkEFaegYpv9d5BMYyaMWfQvrG8g0TxO
        T4oAfHmd2J1JHIHPR6PitrSGmKW46ZA=
X-Google-Smtp-Source: ABdhPJzSXtwkh1hfQcgEuPJCkDhx+b9LY8ifAWiP9AUnPcxpnfZBxxL8VHeryRB2V9qY031Fmafanw==
X-Received: by 2002:a17:90b:1b48:: with SMTP id nv8mr27487616pjb.195.1643678470050;
        Mon, 31 Jan 2022 17:21:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4c2d:864b:dd30:3c5e])
        by smtp.gmail.com with ESMTPSA id o5sm20102573pfk.172.2022.01.31.17.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 17:21:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net] rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
Date:   Mon, 31 Jan 2022 17:21:06 -0800
Message-Id: <20220201012106.216495-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While looking at one unrelated syzbot bug, I found the replay logic
in __rtnl_newlink() to potentially trigger use-after-free.

It is better to clear master_dev and m_ops inside the loop,
in case we have to replay it.

Fixes: ba7d49b1f0f8 ("rtnetlink: provide api for getting and setting slave info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@nvidia.com>
---
 net/core/rtnetlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e476403231f00053e1a261f31a8760325c75c941..710da8a36729d6a9293b610b029bd33aa38d6514 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3275,8 +3275,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *slave_attr[RTNL_SLAVE_MAX_TYPE + 1];
 	unsigned char name_assign_type = NET_NAME_USER;
 	struct nlattr *linkinfo[IFLA_INFO_MAX + 1];
-	const struct rtnl_link_ops *m_ops = NULL;
-	struct net_device *master_dev = NULL;
+	const struct rtnl_link_ops *m_ops;
+	struct net_device *master_dev;
 	struct net *net = sock_net(skb->sk);
 	const struct rtnl_link_ops *ops;
 	struct nlattr *tb[IFLA_MAX + 1];
@@ -3314,6 +3314,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		dev = NULL;
 
+	master_dev = NULL;
+	m_ops = NULL;
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
 		if (master_dev)
-- 
2.35.0.rc2.247.g8bbb082509-goog

