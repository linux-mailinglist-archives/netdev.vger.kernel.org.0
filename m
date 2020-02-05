Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A530715353C
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 17:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgBEQaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 11:30:30 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35989 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgBEQa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 11:30:29 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so3526309wru.3
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 08:30:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oMMjmM9JNv+iSoKlV8oBvlm3EYZ0c09OhSnv+DgMgdw=;
        b=PMgFFGyVdEekbAjPLm5bl3tRgpDb0tkz6IVu5WrgxZDGEMoYGir9piXauXsrKaVT8I
         h6Ee6wSRCUYuJomaAbZemlQrz7fUGqzRLYNAy38RiyCzToYC2ldHoYZDKJZz64W57e7Y
         HuncgLz9Pq3QE+KR4iOaqWaczLiD9sv1t1+kVPCDFNTgdVMxrhMgz6m+UpS7l2K6ZK73
         fookx7YST2Ca+nMqwiFf2VHiBsC3mBBR7mdN5GGnM10qgQv4nbzB9uTXVYmlZtGAgN/9
         naXME3Tr08I0KedGiNQ6FwdPImvnw+OE9FqI8AF8AhLQPlfX9tQLURRofROpWBbHOZey
         H+zA==
X-Gm-Message-State: APjAAAXGKpevhm5SaS9xnKvbJMQTlgRDvgJm/csm+FvU2d4aPia6njld
        k3ngSaFysBv57JBzWkWBfzp/n+fefng=
X-Google-Smtp-Source: APXvYqykJVPAOZ4kHBLDoI5JK6vDQdzOYiqJHY9ty+NMfga4hzjT/A3CIVhnRASt7T5ZIsaocWwafQ==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr29025841wru.294.1580920227111;
        Wed, 05 Feb 2020 08:30:27 -0800 (PST)
Received: from dontpanic.criteois.lan ([91.199.242.236])
        by smtp.gmail.com with ESMTPSA id b10sm413610wrw.61.2020.02.05.08.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 08:30:25 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        William Dauchy <w.dauchy@criteo.com>
Subject: [PATCH v2 2/2] net, ip6_tunnel: enhance tunnel locate with type check
Date:   Wed,  5 Feb 2020 17:29:34 +0100
Message-Id: <20200205162934.220154-3-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
References: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it is done in ip_tunnel, compare dev->type when trying to locate an
existing tunnel.
This is therefore adding a new type parameter to `ip6_tnl_locate`.

Signed-off-by: William Dauchy <w.dauchy@criteo.com>
---
 net/ipv6/ip6_tunnel.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 053f44691cc6..94419b6479fd 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -339,7 +339,7 @@ static struct ip6_tnl *ip6_tnl_create(struct net *net, struct __ip6_tnl_parm *p)
  **/
 
 static struct ip6_tnl *ip6_tnl_locate(struct net *net,
-		struct __ip6_tnl_parm *p, int create)
+		struct __ip6_tnl_parm *p, int create, int type)
 {
 	const struct in6_addr *remote = &p->raddr;
 	const struct in6_addr *local = &p->laddr;
@@ -352,7 +352,8 @@ static struct ip6_tnl *ip6_tnl_locate(struct net *net,
 	     tp = &t->next) {
 		if (ipv6_addr_equal(local, &t->parms.laddr) &&
 		    ipv6_addr_equal(remote, &t->parms.raddr) &&
-		    p->link == t->parms.link) {
+		    p->link == t->parms.link &&
+		    type == t->dev->type) {
 			if (create)
 				return ERR_PTR(-EEXIST);
 
@@ -1601,7 +1602,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				break;
 			}
 			ip6_tnl_parm_from_user(&p1, &p);
-			t = ip6_tnl_locate(net, &p1, 0);
+			t = ip6_tnl_locate(net, &p1, 0, ip6n->fb_tnl_dev->type);
 			if (IS_ERR(t))
 				t = netdev_priv(dev);
 		} else {
@@ -1625,7 +1626,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		    p.proto != 0)
 			break;
 		ip6_tnl_parm_from_user(&p1, &p);
-		t = ip6_tnl_locate(net, &p1, cmd == SIOCADDTUNNEL);
+		t = ip6_tnl_locate(net, &p1, cmd == SIOCADDTUNNEL, dev->type);
 		if (cmd == SIOCCHGTUNNEL) {
 			if (!IS_ERR(t)) {
 				if (t->dev != dev) {
@@ -1660,7 +1661,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				break;
 			err = -ENOENT;
 			ip6_tnl_parm_from_user(&p1, &p);
-			t = ip6_tnl_locate(net, &p1, 0);
+			t = ip6_tnl_locate(net, &p1, 0, ip6n->fb_tnl_dev->type);
 			if (IS_ERR(t))
 				break;
 			err = -EPERM;
@@ -2016,7 +2017,7 @@ static int ip6_tnl_newlink(struct net *src_net, struct net_device *dev,
 		if (rtnl_dereference(ip6n->collect_md_tun))
 			return -EEXIST;
 	} else {
-		t = ip6_tnl_locate(net, &nt->parms, 0);
+		t = ip6_tnl_locate(net, &nt->parms, 0, dev->type);
 		if (!IS_ERR(t))
 			return -EEXIST;
 	}
@@ -2051,7 +2052,7 @@ static int ip6_tnl_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (p.collect_md)
 		return -EINVAL;
 
-	t = ip6_tnl_locate(net, &p, 0);
+	t = ip6_tnl_locate(net, &p, 0, dev->type);
 	if (!IS_ERR(t)) {
 		if (t->dev != dev)
 			return -EEXIST;
-- 
2.24.1

