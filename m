Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793992F1268
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbhAKMjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbhAKMjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:39:47 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFF0C061795;
        Mon, 11 Jan 2021 04:39:06 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t22so10887854pfl.3;
        Mon, 11 Jan 2021 04:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=PaokGmO6qWSPL+k2UjYk5nu0nOURlCVutGfozluGv3E=;
        b=hn0P4l59kgByZoOhcADJpAIuYWHE2y78X1nZpCRdYokx1zPBqINoeknlh3fg24jE8A
         yYH0xxcXTbwkkoHO+fWFRHrGSW+eh8xJb+ASjbkvK2nhqxQOgVYboDpoKJhSkmrIfUR/
         O6VCmSqQcx4ptym26pHVxfDei+skWS1wknxYPXMXVQ0l9WUCmAippKzPons1w8z4wsx2
         RUHvTytwjVSBhH+Gm5BjfFOWsGDXaFaDcMvZfhk1cDGn9x64zqQICqMRdJKYK9J2R+KJ
         682pez2rGAeknLj4lbBLcxwTcHF4D8Clad1TSZVg7qtYTIik/Sv088JY+Tht9r+iVwD8
         wiMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=PaokGmO6qWSPL+k2UjYk5nu0nOURlCVutGfozluGv3E=;
        b=ADJGJHF081gD638T2SrHAqI6roacjRCG7LLSOkCDwOT/CGO5PqfPSrmJs5ZbrbWf01
         lNZIXHi6I0QLTZuHfgpKuV6LiOIECvDqb/ZF95e6MvIdUp27NYnMFwbNWtUTZEUYzKvA
         jyLRSMvcVJdfEtBFkY8nnRfuyOjQ0AxIu/gcRmovyboMdcS6BnBCyp2k4kYeZdfzPkpD
         23XTO+feWoo0+xxzsAcy4xhYutqZ1E6qX9Xopn6lx57kjnmG1lOpr8Z4sTRUvIacjnsi
         pRLqG9mX7uUzwdQ3vELGQmGV/CC/YSzwOP8H96X11n+pBXsLwZFTW3X/CxZO195uniDu
         iYcw==
X-Gm-Message-State: AOAM533HsuVTUNxN481cRJnNYbXecGrPkfzQeeUT2tgTucBu07FhT9Xq
        2nDnHkT4mlILENsnXLVSzdQtQEBjdr1PGw==
X-Google-Smtp-Source: ABdhPJxIyQpQgepMNy/4W5snHEA4X9URyV3ZWBidbRcHgHhrl9x8eD22ONbppprRR3RVrRJqdlKy8A==
X-Received: by 2002:a65:6409:: with SMTP id a9mr19357839pgv.171.1610368746325;
        Mon, 11 Jan 2021 04:39:06 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c3sm19945209pfi.135.2021.01.11.04.39.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 04:39:05 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next 1/2] udp: call udp_encap_enable for v6 sockets when enabling encap
Date:   Mon, 11 Jan 2021 20:38:48 +0800
Message-Id: <8636d49cb2d5deb966ba1112b6d0907f2f595526.1610368263.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1610368263.git.lucien.xin@gmail.com>
References: <cover.1610368263.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610368263.git.lucien.xin@gmail.com>
References: <cover.1610368263.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When enabling encap for a ipv6 socket without udp_encap_needed_key
increased, UDP GRO won't work for v4 mapped v6 address packets as
sk will be NULL in udp4_gro_receive().

This patch is to enable it by increasing udp_encap_needed_key for
v6 sockets in udp_tunnel_encap_enable(), and correspondingly
decrease udp_encap_needed_key in udpv6_destroy_sock().

Reported-by: Chen Yi <yiche@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/udp_tunnel.h | 3 +--
 net/ipv6/udp.c           | 4 +++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 282d10e..afc7ce7 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -181,9 +181,8 @@ static inline void udp_tunnel_encap_enable(struct socket *sock)
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sock->sk->sk_family == PF_INET6)
 		ipv6_stub->udpv6_encap_enable();
-	else
 #endif
-		udp_encap_enable();
+	udp_encap_enable();
 }
 
 #define UDP_TUNNEL_NIC_MAX_TABLES	4
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index b9f3dfd..265b6a0 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1608,8 +1608,10 @@ void udpv6_destroy_sock(struct sock *sk)
 			if (encap_destroy)
 				encap_destroy(sk);
 		}
-		if (up->encap_enabled)
+		if (up->encap_enabled) {
 			static_branch_dec(&udpv6_encap_needed_key);
+			static_branch_dec(&udp_encap_needed_key);
+		}
 	}
 
 	inet6_destroy_sock(sk);
-- 
2.1.0

