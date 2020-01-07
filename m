Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C31D51322BE
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgAGJmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:42:37 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:43021 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgAGJmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:42:36 -0500
Received: by mail-pg1-f201.google.com with SMTP id d9so33560313pgd.10
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 01:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CLIBKjgvw5FZQYLS1sTnwqOYDl3CHzRkKryQzb0Nn1M=;
        b=nbKzQs+NAX5QGy6+qwpRHYqKovYNruvPgMS6ClY+tKgVXv/1/FJaYYVySr312e3x0j
         rmb0D5KbxAj7QU+YYC5TAov7g4nGLcVeYUo6ePG97tIQfMXWvRafQKf0bcTOk9+uE3QR
         GxydDXFFPreA3o0frTIUacqWkYtusRqpLONmBhNaKSr5lqkuBYxLmkDYZzRNF6sNt4dO
         6JFdD/FCjE0nGoj9AKv19e1/X6w2x19vNd+V5IyUua7gL4xO/KbHqdy1Zp3SOskYB91m
         UY/CvzKIRIpVigL6l6NEDpxAKuTjQGLIKzTeK2WMrvJlwKvfd+QYYyvnDN9fPaYG2tSU
         mg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CLIBKjgvw5FZQYLS1sTnwqOYDl3CHzRkKryQzb0Nn1M=;
        b=m0iRHLic1XdCeDWOWiNf6NXbpIwslM4zVMPktU6xc2ILhkBi2MGAVqlthrI1AKa4TI
         KLY7rumC6FpmMH3AeUsJkmGqKIYl2dUYTQV/4AIixWR866a8ULKIZtsGx2pJJUMre0DA
         IE33mQ5cD/m1tFLwEuy8uHtuC/nLZbghJe0vY2gW64dWhm2iWtKcW1XpnQ9QWYh7Kag9
         eMZL/U4PZjdUbwNI0gl3IxGzhfixvNn9Jdu4efioOVxojPe3KAQGeMxtdbY5bhp+bWox
         y7JgWDvzQBhmzYH5o6ci0TEZP3iEtPHmMybigI8qKjq/b5esPM07/9nXuE/b7ZdG8WBA
         QpIg==
X-Gm-Message-State: APjAAAXq4aQ1b2nzjDK0N6yB+pL1/Rh01J5Q5A2eyESAhTqfb7Yz7OVQ
        9A/R4faQ+Cp6XOS5O7U2vbi4y3RL9+pZxg==
X-Google-Smtp-Source: APXvYqxU37rqPPL5P1vnqknnXrufBXXsvRrpkLRiMxONNCxF+Zwennvrfv3Uf1XJ4agR5rXUxJUy9YA4DaQBDg==
X-Received: by 2002:a65:4501:: with SMTP id n1mr112943668pgq.336.1578390156313;
 Tue, 07 Jan 2020 01:42:36 -0800 (PST)
Date:   Tue,  7 Jan 2020 01:42:25 -0800
In-Reply-To: <20200107094225.21243-1-edumazet@google.com>
Message-Id: <20200107094225.21243-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200107094225.21243-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net 2/2] vlan: vlan_changelink() should propagate errors
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both vlan_dev_change_flags() and vlan_dev_set_egress_priority()
can return an error. vlan_changelink() should not ignore them.

Fixes: 07b5b17e157b ("[VLAN]: Use rtnl_link API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/8021q/vlan_netlink.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index b2a4b8b5a0cdffd41e785948f4d092dedd07a5b0..0db85aeb119b88fae1abaf7d0a10019ba4044915 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -108,11 +108,13 @@ static int vlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	struct ifla_vlan_flags *flags;
 	struct ifla_vlan_qos_mapping *m;
 	struct nlattr *attr;
-	int rem;
+	int rem, err;
 
 	if (data[IFLA_VLAN_FLAGS]) {
 		flags = nla_data(data[IFLA_VLAN_FLAGS]);
-		vlan_dev_change_flags(dev, flags->flags, flags->mask);
+		err = vlan_dev_change_flags(dev, flags->flags, flags->mask);
+		if (err)
+			return err;
 	}
 	if (data[IFLA_VLAN_INGRESS_QOS]) {
 		nla_for_each_nested(attr, data[IFLA_VLAN_INGRESS_QOS], rem) {
@@ -123,7 +125,9 @@ static int vlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (data[IFLA_VLAN_EGRESS_QOS]) {
 		nla_for_each_nested(attr, data[IFLA_VLAN_EGRESS_QOS], rem) {
 			m = nla_data(attr);
-			vlan_dev_set_egress_priority(dev, m->from, m->to);
+			err = vlan_dev_set_egress_priority(dev, m->from, m->to);
+			if (err)
+				return err;
 		}
 	}
 	return 0;
-- 
2.24.1.735.g03f4e72817-goog

