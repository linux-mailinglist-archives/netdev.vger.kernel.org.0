Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A6A10829C
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 10:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKXJ1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 04:27:24 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42166 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfKXJ1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 04:27:24 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so5789837pfh.9
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 01:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q7vdXV4n0ktxWxJtufDS5ySOCM7dHpn/QVf9/bdP/fA=;
        b=Dt5+WCPLohQkxCE7riv9mVow7xf0+lh6gXXNKcWcYMVPc4fL6W6wJCCzMVLIrkhX8G
         6XwyyT60FA769RCg8y/uw1y4UBn6C8LLtoF/8WFOhOPE6Hf93WuxR1Mg7PYg34IsUu8D
         ij83iARFGT2Ul4zHCOa75FnxQI1FpwWnDwHzmnATVjtagTjKd2474EKvGeIjS1eggP2X
         oxfIqvbFtY/mRmqF1bb+5pEpCUCmoqZdP7r5Cjdpn+FetgTzMcEMw7G4yEqt0ZQWluAd
         /vKfkKF6eU7st6BPtWkvuSn8rmWKjIjw3RRpE3f2yUhael9NUT8V/JnHV4Vx2QHVQUVr
         3lOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q7vdXV4n0ktxWxJtufDS5ySOCM7dHpn/QVf9/bdP/fA=;
        b=VQtD/i8stuUnlZdCcDJeE2xbuVDkvPOt3y77HEdzjclxFUXorBghbOrQZmkrIyWOrD
         VzRKvQONyi6lvxILYOZwtpe/DdZ2znnDVLDCrek12biBJRjalmxDrygofvhLk/2Te/zx
         OsUUn953gUgIcQAc4sKeYCyisNC9zu26CTeA/qlfi2O+auN/LWwP18470XsYkH55zgmd
         OXn0qbka9XlrUevtLolvUy8zPlbruDwWUrvl3A634Mt3pT0xgFg1lqgBp7pd1GYZJzm9
         lUi1UdYpVSc0AIvaQjwiEOem3jj+1J3lC1clBcxCK6i7BF2wBdmKW3DwYjbzD1/k9y0k
         bDog==
X-Gm-Message-State: APjAAAUY17qW9M9Gv40FQsYpyIxtLD7iRiUf+ak/kw+xveNjAMpv6o2r
        x4d36opgze47ylH92mq9xrE=
X-Google-Smtp-Source: APXvYqztG3MEI7EJCGgK9ZrB7hr6lAorVAwDIDMWsppv6u/Eq6LWdMQuHWkb2NqunIhfvtj2INkFdw==
X-Received: by 2002:a63:5d10:: with SMTP id r16mr26153619pgb.41.1574587643223;
        Sun, 24 Nov 2019 01:27:23 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id z10sm4133264pgg.39.2019.11.24.01.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 01:27:22 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH] net: port < inet_prot_sock(net) --> inet_port_requires_bind_service(net, port)
Date:   Sun, 24 Nov 2019 01:27:15 -0800
Message-Id: <20191124092715.252532-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
In-Reply-To: <CANP3RGfi3vwAjYu45xRG7HqMw-CGEr4uxES8Cd7vHs+q4W4wLQ@mail.gmail.com>
References: <CANP3RGfi3vwAjYu45xRG7HqMw-CGEr4uxES8Cd7vHs+q4W4wLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Note that the sysctl write accessor functions guarantee that:
  net->ipv4.sysctl_ip_prot_sock <= net->ipv4.ip_local_ports.range[0]
invariant is maintained, and as such the max() in selinux hooks is actually spurious.

ie. even though
  if (snum < max(inet_prot_sock(sock_net(sk)), low) || snum > high) {
per logic is the same as
  if ((snum < inet_prot_sock(sock_net(sk)) && snum < low) || snum > high) {
it is actually functionally equivalent to:
  if (snum < low || snum > high) {
which is equivalent to:
  if (snum < inet_prot_sock(sock_net(sk)) || snum < low || snum > high) {
even though the first clause is spurious.

But we want to hold on to it in case we ever want to change what what
inet_port_requires_bind_service() means (for example by changing
it from a, by default, [0..1024) range to some sort of set).

Test: builds, git 'grep inet_prot_sock' finds no other references
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/ip.h               | 8 ++++----
 net/ipv4/af_inet.c             | 2 +-
 net/ipv6/af_inet6.c            | 2 +-
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 net/sctp/socket.c              | 4 ++--
 security/selinux/hooks.c       | 4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index cebf3e10def1..a92f157bb115 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -351,9 +351,9 @@ static inline bool sysctl_dev_name_is_allowed(const char *name)
 	return strcmp(name, "default") != 0  && strcmp(name, "all") != 0;
 }
 
-static inline int inet_prot_sock(struct net *net)
+static inline bool inet_port_requires_bind_service(struct net *net, int port)
 {
-	return net->ipv4.sysctl_ip_prot_sock;
+	return port < net->ipv4.sysctl_ip_prot_sock;
 }
 
 #else
@@ -362,9 +362,9 @@ static inline bool inet_is_local_reserved_port(struct net *net, int port)
 	return false;
 }
 
-static inline int inet_prot_sock(struct net *net)
+static inline bool inet_port_requires_bind_service(struct net *net, int port)
 {
-	return PROT_SOCK;
+	return port < PROT_SOCK;
 }
 #endif
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 53de8e00990e..2fe295432c24 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -495,7 +495,7 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 
 	snum = ntohs(addr->sin_port);
 	err = -EACCES;
-	if (snum && snum < inet_prot_sock(net) &&
+	if (snum && inet_port_requires_bind_service(net, snum) &&
 	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
 		goto out;
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index ef37e0574f54..60e2ff91a5b3 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -292,7 +292,7 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		return -EINVAL;
 
 	snum = ntohs(addr->sin6_port);
-	if (snum && snum < inet_prot_sock(net) &&
+	if (snum && inet_port_requires_bind_service(net, snum) &&
 	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
 		return -EACCES;
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 3be7398901e0..8d14a1acbc37 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -423,7 +423,7 @@ ip_vs_service_find(struct netns_ipvs *ipvs, int af, __u32 fwmark, __u16 protocol
 
 	if (!svc && protocol == IPPROTO_TCP &&
 	    atomic_read(&ipvs->ftpsvc_counter) &&
-	    (vport == FTPDATA || ntohs(vport) >= inet_prot_sock(ipvs->net))) {
+	    (vport == FTPDATA || !inet_port_requires_bind_service(ipvs->net, ntohs(vport)))) {
 		/*
 		 * Check if ftp service entry exists, the packet
 		 * might belong to FTP data connections.
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 83e4ca1fabda..8797a38baf00 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -384,7 +384,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 		}
 	}
 
-	if (snum && snum < inet_prot_sock(net) &&
+	if (snum && inet_port_requires_bind_service(net, snum) &&
 	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
 		return -EACCES;
 
@@ -1061,7 +1061,7 @@ static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 		if (sctp_autobind(sk))
 			return -EAGAIN;
 	} else {
-		if (ep->base.bind_addr.port < inet_prot_sock(net) &&
+		if (inet_port_requires_bind_service(net, ep->base.bind_addr.port) &&
 		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
 			return -EACCES;
 	}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9625b99e677f..753b327f4806 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4623,8 +4623,8 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 
 			inet_get_local_port_range(sock_net(sk), &low, &high);
 
-			if (snum < max(inet_prot_sock(sock_net(sk)), low) ||
-			    snum > high) {
+			if (inet_port_requires_bind_service(sock_net(sk), snum) ||
+			    snum < low || snum > high) {
 				err = sel_netport_sid(sk->sk_protocol,
 						      snum, &sid);
 				if (err)
-- 
2.24.0.432.g9d3f5f5b63-goog

