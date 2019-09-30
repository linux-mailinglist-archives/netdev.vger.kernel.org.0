Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB6DC1E66
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbfI3Jsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:48:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37907 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730510AbfI3Js3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 05:48:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id w12so10482169wro.5
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 02:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gxvzvtT03T0WvhcJir7QusBE8+zB7am8NrJM53Unvcw=;
        b=zn36BJ577y0828ycAW264kYrxMOsNupRD/vhQyL47bcWhxzMI/hSTrMDQaBqD0qj+h
         uqSjXV+ChMxYTkDkYf1XWu30jFWP0qYdNv34Hy6ZJ0uM5YzgCNMGzg3ZLjF842yDpGC8
         eucllTC1jLffZyi8E0g4rWvRiFskJJqYkJzWfR136rgN12t07+vW67nRRkIUNFbicWld
         jPyKQPF6tegoxCq1vdSnXpI8gx4EGB2JYBGOIPIzzE1+QWFDeH8M+UYADmHUTkD9F2iW
         afgHsG2wrlxRwbswpoQBay/KwHyzI3y86wVXu8YlS/t8CxnsxUa0vO0zuZKJGCpXXGoL
         cFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gxvzvtT03T0WvhcJir7QusBE8+zB7am8NrJM53Unvcw=;
        b=WzJRDa7mKi3ZbVyBiv7At95uNeOMkqlGJh379W31V98tKeuSGHiK4TH+DZzG0NPYO8
         mmjsiWV0ve4WxD71k/O1Z82zoMdoQfoXpHLLvVfu4ybDkvYeK3uSgt4Z9vXRo5Lm7S6K
         sUSIzQx3CaU3JYxo87Sn+KnO5Ugg4JbRwudY+zd/7Zu+6oFQpQN/GXDVOHrZgjMCTNRF
         P1IqRG5i4iexriiSAH6zd8bc8UMhAp8pwhK/xEQBh2nwggbRw4dnp+BwUuqrU2MjlOxh
         ly6ne4Q1F5VDs+SY9lJOUDRsVuuvzQib5qnivuyprAL3CNU1CaL2Hjkf/rGQOv19D/RJ
         dzNg==
X-Gm-Message-State: APjAAAUNyKd2tXlj9Anc0AXTCCmYG7oFrvlfXN1iKV0LstfzL+Rwg7de
        NBn/lbmNXeYJrnBWfiQDboyl9TcDdZ0=
X-Google-Smtp-Source: APXvYqyc6MBbfhTTeo2wfqa6lUmUUROFJu3zTDu/46kRV5gaPI0tmOT9RRitpn4KOwc4tdApwSJo4g==
X-Received: by 2002:a5d:40c4:: with SMTP id b4mr12217428wrq.214.1569836907163;
        Mon, 30 Sep 2019 02:48:27 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id b16sm14761502wrh.5.2019.09.30.02.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:48:26 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch net-next 5/7] net: rtnetlink: unify the code in __rtnl_newlink get dev with the rest
Date:   Mon, 30 Sep 2019 11:48:18 +0200
Message-Id: <20190930094820.11281-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930094820.11281-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

__rtnl_newlink() code flow is a bit different around tb[IFLA_IFNAME]
processing comparing to the other places. Change that to be unified with
the rest.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/rtnetlink.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c38917371b84..a0017737442f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3080,12 +3080,10 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	else {
-		if (ifname[0])
-			dev = __dev_get_by_name(net, ifname);
-		else
-			dev = NULL;
-	}
+	else if (tb[IFLA_IFNAME])
+		dev = __dev_get_by_name(net, ifname);
+	else
+		dev = NULL;
 
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
-- 
2.21.0

