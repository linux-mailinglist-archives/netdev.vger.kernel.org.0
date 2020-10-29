Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B7929E45D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgJ2HiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbgJ2HYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43994C08EA70;
        Thu, 29 Oct 2020 00:06:11 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t6so843950plq.11;
        Thu, 29 Oct 2020 00:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Sv9CFe0MpUrtrIxlHMuiPEsfPm/oLc/qkaCuXjiMpk4=;
        b=C8f0/w5BsOrQQMevk5iH0d/3W+FNL8dXSbN3c5EA9Mk4yxIZRXGCfPBmLSQdPc9xcP
         sxszDta7dHc2Pqda1RP+724FS72JVHNFVUhfM4Hv8J9JCJ/LcXr996bubfVL5YBOekQR
         XRCQyNKLH//cYHq7/0NpyOzL5c6qAuiZu8o9e80kw0F+aeyuDOOKRYe/8XcUa1ed+0as
         Lx89ifXcIitmhsRJcsaU2G99mQ1pHBwlPsYZZHCl00M+DzJtEk/e7cmutIYcarPFTNsV
         M3lhaojalnkwM6Ac8xgGdMlg/0/WJhX/o5o73oi8WKHqoiFyzF2dLOjkEgeViqhurjX8
         i6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Sv9CFe0MpUrtrIxlHMuiPEsfPm/oLc/qkaCuXjiMpk4=;
        b=D01gkORj3OMzF1Tl4kOGWc/j2dy4O9dkA1wHqMlibJGLch9RU8INmHQ5yFxQVrBWeO
         5fMdhrxw/c9yAToknveBgSpODdZvW/GLJzlTieGMyCYSUbz7+oMljT1V851z/J1w+qf0
         rzRjRlguhnWSYbZsR9GeH5De0tIB6oJG3H14WZWDWs1+ui6Siw1X6w/Gj9hLsYgSC/Cz
         IxmmCkt97Gl1ICE6KWrzoDQiFoINvxHw1Y5G5l7U8rTpiDDpilP7mgvup2Z9aidTJfxX
         XwFuyD77Dv745x46YCvm3f+jaTsWoZ3onqrzPoW6ewSH5eME8h2swH4oTsfhweVf1YLQ
         yugg==
X-Gm-Message-State: AOAM533VyYPDdfsJ8FtDepAlHpgYABDLpz/j+C4CySOEYCLFL3CNvF8e
        eZfs6uqhjhwWnq1s3hzu6ng76o86kyg=
X-Google-Smtp-Source: ABdhPJwPYp3HteQT+4wPlLPvow8MQWmZUqrBc2W0ZWNCIJBwQUvgRPwHyAxOVs+I8B9m+7P3YSbAnA==
X-Received: by 2002:a17:902:7c14:b029:d4:d894:7eed with SMTP id x20-20020a1709027c14b02900d4d8947eedmr2731123pll.81.1603955170490;
        Thu, 29 Oct 2020 00:06:10 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g22sm1741640pfh.147.2020.10.29.00.06.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:06:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 06/16] sctp: add encap_err_lookup for udp encap socks
Date:   Thu, 29 Oct 2020 15:05:00 +0800
Message-Id: <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
 <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it says in rfc6951#section-5.5:

  "When receiving ICMP or ICMPv6 response packets, there might not be
   enough bytes in the payload to identify the SCTP association that the
   SCTP packet triggering the ICMP or ICMPv6 packet belongs to.  If a
   received ICMP or ICMPv6 packet cannot be related to a specific SCTP
   association or the verification tag cannot be verified, it MUST be
   discarded silently.  In particular, this means that the SCTP stack
   MUST NOT rely on receiving ICMP or ICMPv6 messages.  Implementation
   constraints could prevent processing received ICMP or ICMPv6
   messages."

ICMP or ICMPv6 packets need to be handled, and this is implemented by
udp encap sock .encap_err_lookup function.

The .encap_err_lookup function is called in __udp(6)_lib_err_encap()
to confirm this path does need to be updated. For sctp, what we can
do here is check if the corresponding asoc and transport exist.

Note that icmp packet process for sctp over udp is done by udp sock
.encap_err_lookup(), and it means for now we can't do as much as
sctp_v4/6_err() does. Also we can't do the two mappings mentioned
in rfc6951#section-5.5.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 8410c9a..4d12a0c 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -848,6 +848,23 @@ static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static int sctp_udp_err_lookup(struct sock *sk, struct sk_buff *skb)
+{
+	struct sctp_association *asoc;
+	struct sctp_transport *t;
+	int family;
+
+	skb->transport_header += sizeof(struct udphdr);
+	family = (ip_hdr(skb)->version == 4) ? AF_INET : AF_INET6;
+	sk = sctp_err_lookup(dev_net(skb->dev), family, skb, sctp_hdr(skb),
+			     &asoc, &t);
+	if (!sk)
+		return -ENOENT;
+
+	sctp_err_finish(sk, t);
+	return 0;
+}
+
 int sctp_udp_sock_start(struct net *net)
 {
 	struct udp_tunnel_sock_cfg tuncfg = {NULL};
@@ -866,6 +883,7 @@ int sctp_udp_sock_start(struct net *net)
 
 	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
+	tuncfg.encap_err_lookup = sctp_udp_err_lookup;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp4_sock = sock->sk;
 
@@ -887,6 +905,7 @@ int sctp_udp_sock_start(struct net *net)
 
 	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
+	tuncfg.encap_err_lookup = sctp_udp_err_lookup;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp6_sock = sock->sk;
 #endif
-- 
2.1.0

