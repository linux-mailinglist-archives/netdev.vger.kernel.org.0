Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA6A15353B
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 17:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgBEQaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 11:30:30 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38990 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgBEQa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 11:30:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id c84so3565151wme.4
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 08:30:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GUzhYerOzheX7/r6gogzfTcTH19p3TR+sI+PVEKjonE=;
        b=oSKdIyaTy4bAjCHHPQqQBjka+xOW/5DIGAp7boG21kgsE2ueFqBNg8CpFKJYvsyoh6
         EvMTA81fx81/oVgDER9Av0lUkeR9eGb5dUOtrXk/2jkMbeUYxJtkNEhWp9tNuex/xNG4
         JQiQLqjL9K2apPzrV4aSJvP3A1BkSIIWBmPTkvgWcfybrZKYu7pPV+/San/yVqZr8rtg
         tXE7fMHViL9/u5ggwZnKc4AWgLsVYZzls0YFOE5mKH0CKWSIGNdV+F22jf9J+oFI85i/
         CHvzeteyrqdKZA/7hAc5FXzjhPui8uA2EOsjR4BSlRDcav33eA7q7wYMpnOfECO8NfWD
         XZoQ==
X-Gm-Message-State: APjAAAU9u3iPNgzYiSOlyyxGoX1PnjqOloiEu1w9p0hTNfUudo8NI3E1
        YYkrnX/FxBKS6VRs+LO4/as7Pq5hu/Q=
X-Google-Smtp-Source: APXvYqxIcBJTNMbIjZ64NoI/V4o41cY5o1Wh/C36n+T1Vsw2sQ0rcj7ZZNZtyERzVdy4zgyFJ0oI8g==
X-Received: by 2002:a7b:cb49:: with SMTP id v9mr6883886wmj.160.1580920225304;
        Wed, 05 Feb 2020 08:30:25 -0800 (PST)
Received: from dontpanic.criteois.lan ([91.199.242.236])
        by smtp.gmail.com with ESMTPSA id b10sm413610wrw.61.2020.02.05.08.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 08:30:23 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        William Dauchy <w.dauchy@criteo.com>
Subject: [PATCH v2 1/2] net, ip6_tunnel: enhance tunnel locate with link check
Date:   Wed,  5 Feb 2020 17:29:33 +0100
Message-Id: <20200205162934.220154-2-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
References: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With ipip, it is possible to create an extra interface explicitly
attached to a given physical interface:

  # ip link show tunl0
  4: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
  # ip link add tunl1 type ipip dev eth0
  # ip link show tunl1
  6: tunl1@eth0: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0

But it is not possible with ip6tnl:

  # ip link show ip6tnl0
  5: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/tunnel6 :: brd ::
  # ip link add ip6tnl1 type ip6tnl dev eth0
  RTNETLINK answers: File exists

This patch aims to make it possible by adding the comparaison of the
link device while trying to locate an existing tunnel.
This later permits to make use of x-netns communication by moving the
newly created tunnel in a given netns.

Signed-off-by: William Dauchy <w.dauchy@criteo.com>
---
 net/ipv6/ip6_tunnel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index b5dd20c4599b..053f44691cc6 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -351,7 +351,8 @@ static struct ip6_tnl *ip6_tnl_locate(struct net *net,
 	     (t = rtnl_dereference(*tp)) != NULL;
 	     tp = &t->next) {
 		if (ipv6_addr_equal(local, &t->parms.laddr) &&
-		    ipv6_addr_equal(remote, &t->parms.raddr)) {
+		    ipv6_addr_equal(remote, &t->parms.raddr) &&
+		    p->link == t->parms.link) {
 			if (create)
 				return ERR_PTR(-EEXIST);
 
-- 
2.24.1

