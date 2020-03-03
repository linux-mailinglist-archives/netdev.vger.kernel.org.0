Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8D3176F8D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 07:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgCCGh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 01:37:57 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34144 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgCCGhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 01:37:55 -0500
Received: by mail-qk1-f195.google.com with SMTP id 11so2399349qkd.1
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 22:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DNW58QEhjuhJ0t5EVBJck3NErLLvOeKeyMir7BmVrus=;
        b=NZfbMnZvCfGnq2axAPtGZDnoSgKPTmQgXg/s5HeHLMjLPJBnQxfn/v4LONPSadvDXj
         aegx6tPPZW4U2M1cq7ub5ncvJWHc+kpMCcc+lsCPIYb8hTjRcZJBNIuZcKplbDggcfIe
         wCWwGUt1od5VdL0WWbhxcT10OEUPiXrh9vtWBeJSoO0pVx6048LJGLmOeCCgdmS3XaaV
         sjBUKFNlZnJexqtNpvLgFD6UTf11pD6cHGelPRdsef2sf3VaWkaCvJS1L1QPixmMnpLA
         WhG92Q6SmUrWp/jRsCZhlsTidL/cymQQZDT9CBVD01uhLP/XnyRqwG6MDpMbVPMYTUeC
         2C8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DNW58QEhjuhJ0t5EVBJck3NErLLvOeKeyMir7BmVrus=;
        b=MIj9Pvsar3Lc356w3novnoX3KlMvDZw/vJo2pwHPfhwxgxer5R9WcIZ+IKugZ4zgbO
         ra/6Uyem6i/1cec40vjVwoj7GQzAS3ZHhMI+SAdBwe0f/XpYVhF5v3VRg2X+7X+cSqOL
         Vo2Pygf+ryeJ4SGzCDLYzqdRYzDKvNejyGdxwVVrAtoWJHyMSFAV2pvn66RP22Zq9aDT
         Yd7rP/AWAXfVJ6/ljB3b3xrXodnET/DpXsYSiTKUaX2J8XdKRPSP1QqJVLAybqqpIUH9
         tJrOUDn0KphqmHNVPxRgGSQR7wExdxOybqOXFC2zRXSqTguH+08YC4JMzq85QDTikZQS
         y+ng==
X-Gm-Message-State: ANhLgQ0+iprax6iYPnaquB0jPvMK1bgMTXFmVtbTC0m7U11SN1CAOGR1
        d+GGAd09QiGfMpitY81Dfx8DukBwOeQ=
X-Google-Smtp-Source: ADFU+vv4gptDpPSDkZZASQPqarZjnshjI6WfOG2S/PQSpR7HP2h10TZjAcuB21SalAARte+5PXiB7Q==
X-Received: by 2002:a37:27c2:: with SMTP id n185mr2741944qkn.423.1583217474420;
        Mon, 02 Mar 2020 22:37:54 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm3599929qto.56.2020.03.02.22.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 22:37:54 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/3] net/ipv6: remove the old peer route if change it to a new one
Date:   Tue,  3 Mar 2020 14:37:35 +0800
Message-Id: <20200303063736.4904-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200303063736.4904-1-liuhangbin@gmail.com>
References: <20200303063736.4904-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we modify the peer route and changed it to a new one, we should
remove the old route first. Before the fix:

+ ip addr add dev dummy1 2001:db8::1 peer 2001:db8::2
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 256 pref medium
2001:db8::2 proto kernel metric 256 pref medium
+ ip addr change dev dummy1 2001:db8::1 peer 2001:db8::3
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 256 pref medium
2001:db8::2 proto kernel metric 256 pref medium

After the fix:
+ ip addr change dev dummy1 2001:db8::1 peer 2001:db8::3
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 256 pref medium
2001:db8::3 proto kernel metric 256 pref medium

This patch depend on the previous patch "net/ipv6: need update peer route
when modify metric" to update new peer route after delete old one.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4fb72028ca45..e6e1290ea06f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1226,11 +1226,13 @@ check_cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long *expires)
 }
 
 static void
-cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires, bool del_rt)
+cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires,
+		     bool del_rt, bool del_peer)
 {
 	struct fib6_info *f6i;
 
-	f6i = addrconf_get_prefix_route(&ifp->addr, ifp->prefix_len,
+	f6i = addrconf_get_prefix_route(del_peer ? &ifp->peer_addr : &ifp->addr,
+					ifp->prefix_len,
 					ifp->idev->dev, 0, RTF_DEFAULT, true);
 	if (f6i) {
 		if (del_rt)
@@ -1293,7 +1295,7 @@ static void ipv6_del_addr(struct inet6_ifaddr *ifp)
 
 	if (action != CLEANUP_PREFIX_RT_NOP) {
 		cleanup_prefix_route(ifp, expires,
-			action == CLEANUP_PREFIX_RT_DEL);
+			action == CLEANUP_PREFIX_RT_DEL, false);
 	}
 
 	/* clean up prefsrc entries */
@@ -4627,6 +4629,7 @@ static int inet6_addr_modify(struct inet6_ifaddr *ifp, struct ifa6_config *cfg)
 	unsigned long timeout;
 	bool was_managetempaddr;
 	bool had_prefixroute;
+	bool new_peer = false;
 
 	ASSERT_RTNL();
 
@@ -4658,6 +4661,13 @@ static int inet6_addr_modify(struct inet6_ifaddr *ifp, struct ifa6_config *cfg)
 		cfg->preferred_lft = timeout;
 	}
 
+	if (cfg->peer_pfx &&
+	    memcmp(&ifp->peer_addr, cfg->peer_pfx, sizeof(struct in6_addr))) {
+		if (!ipv6_addr_any(&ifp->peer_addr))
+			cleanup_prefix_route(ifp, expires, true, true);
+		new_peer = true;
+	}
+
 	spin_lock_bh(&ifp->lock);
 	was_managetempaddr = ifp->flags & IFA_F_MANAGETEMPADDR;
 	had_prefixroute = ifp->flags & IFA_F_PERMANENT &&
@@ -4673,6 +4683,9 @@ static int inet6_addr_modify(struct inet6_ifaddr *ifp, struct ifa6_config *cfg)
 	if (cfg->rt_priority && cfg->rt_priority != ifp->rt_priority)
 		ifp->rt_priority = cfg->rt_priority;
 
+	if (new_peer)
+		ifp->peer_addr = *cfg->peer_pfx;
+
 	spin_unlock_bh(&ifp->lock);
 	if (!(ifp->flags&IFA_F_TENTATIVE))
 		ipv6_ifa_notify(0, ifp);
@@ -4708,7 +4721,7 @@ static int inet6_addr_modify(struct inet6_ifaddr *ifp, struct ifa6_config *cfg)
 
 		if (action != CLEANUP_PREFIX_RT_NOP) {
 			cleanup_prefix_route(ifp, rt_expires,
-				action == CLEANUP_PREFIX_RT_DEL);
+				action == CLEANUP_PREFIX_RT_DEL, false);
 		}
 	}
 
-- 
2.19.2

