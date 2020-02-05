Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6EB153383
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 15:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgBEO6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 09:58:13 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35951 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgBEO6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 09:58:13 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so3126681wru.3
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 06:58:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6cHhEWAiPyN755GX3Sgkf+E9KBCFYaJmkXprDXnuFAE=;
        b=lDGtLOMGGBm8sjRliC5O5EwHsvKFwrPhrmZa0NRSMtjq6cH+lW0omQ0Ul2U9WZTmbX
         /aXNg0JOq4JqtPhmRgzcq/Hp+ujIvcaujrJVy6wp0PwQwWikKxeBO3/GQqhbo+UjlCB5
         pi1LWpj+IveTLdQxn87y6ozL5b0ufpH5tUwmeDnDZccQRPI9s4NcsyW4D/RkgKqtYDw8
         LIluUgoDMlDF5aYZfWPEFAV/FIfVjWInyHWHcTfSIiL6P39kRXD8dSclg/ass1DD5FZw
         M2RDDoJWki7syrXKnK203ZinnKqj0IZBQNDLdFLBmS1zqRSKxY0ZGDKnRjip80uoF/+8
         ogmA==
X-Gm-Message-State: APjAAAUPyO8U7qUbDkk1E1zngvm3H5OsbifzhmaXwLi5mjGFFx8En7o+
        1UQDBZGG7FV6wfdxsb2we7SeOvG/a3Q=
X-Google-Smtp-Source: APXvYqyplueimfjY+nVr5yr7OMp9nalv1Hk7AR4uUCpnO2jtaHa5FVh/Mo4daoNH1Uu9HdGIJ3sM7A==
X-Received: by 2002:adf:f491:: with SMTP id l17mr31673749wro.149.1580914690841;
        Wed, 05 Feb 2020 06:58:10 -0800 (PST)
Received: from dontpanic.criteois.lan ([91.199.242.236])
        by smtp.gmail.com with ESMTPSA id 5sm79692wrc.75.2020.02.05.06.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 06:58:09 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        William Dauchy <w.dauchy@criteo.com>
Subject: [PATCH] net, ip6_tunnel: enhance tunnel locate with link/type check
Date:   Wed,  5 Feb 2020 15:57:25 +0100
Message-Id: <20200205145725.19449-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.24.1
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

Take this opportunity to also compare dev->type value as it is done in
ip_tunnel. This is therefore adding a new type parameter to
`ip6_tnl_locate`.

Signed-off-by: William Dauchy <w.dauchy@criteo.com>
---
 net/ipv6/ip6_tunnel.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index b5dd20c4599b..0df3b3ca7608 100644
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
@@ -351,7 +351,9 @@ static struct ip6_tnl *ip6_tnl_locate(struct net *net,
 	     (t = rtnl_dereference(*tp)) != NULL;
 	     tp = &t->next) {
 		if (ipv6_addr_equal(local, &t->parms.laddr) &&
-		    ipv6_addr_equal(remote, &t->parms.raddr)) {
+		    ipv6_addr_equal(remote, &t->parms.raddr) &&
+		    p->link == t->parms.link &&
+		    type == t->dev->type) {
 			if (create)
 				return ERR_PTR(-EEXIST);
 
@@ -1600,7 +1602,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				break;
 			}
 			ip6_tnl_parm_from_user(&p1, &p);
-			t = ip6_tnl_locate(net, &p1, 0);
+			t = ip6_tnl_locate(net, &p1, 0, dev->type);
 			if (IS_ERR(t))
 				t = netdev_priv(dev);
 		} else {
@@ -1624,7 +1626,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		    p.proto != 0)
 			break;
 		ip6_tnl_parm_from_user(&p1, &p);
-		t = ip6_tnl_locate(net, &p1, cmd == SIOCADDTUNNEL);
+		t = ip6_tnl_locate(net, &p1, cmd == SIOCADDTUNNEL, dev->type);
 		if (cmd == SIOCCHGTUNNEL) {
 			if (!IS_ERR(t)) {
 				if (t->dev != dev) {
@@ -1659,7 +1661,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				break;
 			err = -ENOENT;
 			ip6_tnl_parm_from_user(&p1, &p);
-			t = ip6_tnl_locate(net, &p1, 0);
+			t = ip6_tnl_locate(net, &p1, 0, dev->type);
 			if (IS_ERR(t))
 				break;
 			err = -EPERM;
@@ -2015,7 +2017,7 @@ static int ip6_tnl_newlink(struct net *src_net, struct net_device *dev,
 		if (rtnl_dereference(ip6n->collect_md_tun))
 			return -EEXIST;
 	} else {
-		t = ip6_tnl_locate(net, &nt->parms, 0);
+		t = ip6_tnl_locate(net, &nt->parms, 0, dev->type);
 		if (!IS_ERR(t))
 			return -EEXIST;
 	}
@@ -2050,7 +2052,7 @@ static int ip6_tnl_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (p.collect_md)
 		return -EINVAL;
 
-	t = ip6_tnl_locate(net, &p, 0);
+	t = ip6_tnl_locate(net, &p, 0, dev->type);
 	if (!IS_ERR(t)) {
 		if (t->dev != dev)
 			return -EEXIST;
-- 
2.24.1

