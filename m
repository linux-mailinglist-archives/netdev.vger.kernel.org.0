Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621398D921
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbfHNRF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:05:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33506 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729532AbfHNRFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:05:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id p77so3744094wme.0
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WcjxfoHTef+rzVi2MznJlfR9cVOKNUDGmg2Wkh7C8H8=;
        b=aMZOTqjFEavo6WPifywwRIJrPPe1WZX4xx3+bjlMEdi+8KJ88po4OEWhR1jbmw1yI9
         QiR2W+zsmB9wnNlgSS4I4/hZGQIQQ4kFz/Ex7+J3ShBwekpi96BchKQmKjmF/K21+VaT
         Q52As3vdHUgGZxCwC2oybv9WQWRLg7m3SmE7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WcjxfoHTef+rzVi2MznJlfR9cVOKNUDGmg2Wkh7C8H8=;
        b=HKMxigqvsDTm0lwJg659YcL9AdWY8xgTTl3GP5waNfStPblrpziKKisfgPqkX31KNj
         68S3GVFas6dpqlQUXGF0Lnto6lWFtsuMPpp3+z/ehRYG1XSvC78OcoAj2oTj5psKc25z
         gHtumD5OGkmfxl9SLBM45wjt+0h14saxc2zH0FPleX2HVE9KVk5Rhz/wHcZjoXQ0fcTp
         dQqvVDJE7rz6Lya8sBR1Kkp5HQX+5fxZsW0vjLKnSioL+grGiV0ektsJ0S72JAeXEq6u
         1PRssXuPzSfhNcwUO/NiYMUcI7fDn7FGdblTKP6JkFaST3G5qU/b8G7GLPWXCba928bn
         zStQ==
X-Gm-Message-State: APjAAAV5Ls3f3xrb2K3Jh+2b6eCda/xCUr9BFwDNK7I3bT2XaqPf8+T6
        xBMoi0ZOj+9Kr6DUh3AF5bHA9tDWacg=
X-Google-Smtp-Source: APXvYqxN7SN4VLG4UwRJzQ5v4TpkQEpmUeQhwswv17F3nN5g+77vMOGfeVSowVbBznvMpTgQ2jU5nw==
X-Received: by 2002:a1c:6087:: with SMTP id u129mr150000wmb.108.1565802352849;
        Wed, 14 Aug 2019 10:05:52 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.174.40])
        by smtp.gmail.com with ESMTPSA id c6sm332311wma.25.2019.08.14.10.05.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 10:05:52 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 3/4] net: bridge: mdb: dump host-joined entries as well
Date:   Wed, 14 Aug 2019 20:05:00 +0300
Message-Id: <20190814170501.1808-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814170501.1808-1-nikolay@cumulusnetworks.com>
References: <81258876-5f03-002c-5aa8-2d6d00e6d99e@cumulusnetworks.com>
 <20190814170501.1808-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we dump only the port mdb entries but we can have host-joined
entries on the bridge itself and they should be treated as normal temp
mdbs, they're already notified:
$ bridge monitor all
[MDB]dev br0 port br0 grp ff02::8 temp

The group will not be shown in the bridge mdb output, but it takes 1 slot
and it's timing out. If it's only host-joined then the mdb show output
can even be empty.

After this patch we show the host-joined groups:
$ bridge mdb show
dev br0 port br0 grp ff02::8 temp

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 77730983097e..985273425117 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -78,22 +78,35 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
 }
 
 static int __mdb_fill_info(struct sk_buff *skb,
+			   struct net_bridge_mdb_entry *mp,
 			   struct net_bridge_port_group *p)
 {
+	struct timer_list *mtimer;
 	struct nlattr *nest_ent;
 	struct br_mdb_entry e;
+	u8 flags = 0;
+	int ifindex;
 
 	memset(&e, 0, sizeof(e));
-	__mdb_entry_fill_flags(&e, p->flags);
-	e.ifindex = p->port->dev->ifindex;
-	e.vid = p->addr.vid;
-	if (p->addr.proto == htons(ETH_P_IP))
-		e.addr.u.ip4 = p->addr.u.ip4;
+	if (p) {
+		ifindex = p->port->dev->ifindex;
+		mtimer = &p->timer;
+		flags = p->flags;
+	} else {
+		ifindex = mp->br->dev->ifindex;
+		mtimer = &mp->timer;
+	}
+
+	__mdb_entry_fill_flags(&e, flags);
+	e.ifindex = ifindex;
+	e.vid = mp->addr.vid;
+	if (mp->addr.proto == htons(ETH_P_IP))
+		e.addr.u.ip4 = mp->addr.u.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
-	if (p->addr.proto == htons(ETH_P_IPV6))
-		e.addr.u.ip6 = p->addr.u.ip6;
+	if (mp->addr.proto == htons(ETH_P_IPV6))
+		e.addr.u.ip6 = mp->addr.u.ip6;
 #endif
-	e.addr.proto = p->addr.proto;
+	e.addr.proto = mp->addr.proto;
 	nest_ent = nla_nest_start_noflag(skb,
 					 MDBA_MDB_ENTRY_INFO);
 	if (!nest_ent)
@@ -102,7 +115,7 @@ static int __mdb_fill_info(struct sk_buff *skb,
 	if (nla_put_nohdr(skb, sizeof(e), &e) ||
 	    nla_put_u32(skb,
 			MDBA_MDB_EATTR_TIMER,
-			br_timer_value(&p->timer))) {
+			br_timer_value(mtimer))) {
 		nla_nest_cancel(skb, nest_ent);
 		return -EMSGSIZE;
 	}
@@ -139,12 +152,20 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			break;
 		}
 
+		if (mp->host_joined) {
+			err = __mdb_fill_info(skb, mp, NULL);
+			if (err) {
+				nla_nest_cancel(skb, nest2);
+				break;
+			}
+		}
+
 		for (pp = &mp->ports; (p = rcu_dereference(*pp)) != NULL;
 		      pp = &p->next) {
 			if (!p->port)
 				continue;
 
-			err = __mdb_fill_info(skb, p);
+			err = __mdb_fill_info(skb, mp, p);
 			if (err) {
 				nla_nest_cancel(skb, nest2);
 				goto out;
-- 
2.21.0

