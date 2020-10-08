Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751922871E0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgJHJtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJHJtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:49:19 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86D8C061755;
        Thu,  8 Oct 2020 02:49:18 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id i2so3827767pgh.7;
        Thu, 08 Oct 2020 02:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=mddk0RPj5RANjKGN0DxBgjaZKh24JdfVj6LOwAP3f/8=;
        b=utkY8ialYs+Jg+Y4IAjQh1kf4rgs2Qt95jgn9oNj64cnRBIu/YHEJHUSjXBoUuD0v1
         WDNvQwrELZ+1v8y8lp5g3ZrIVVwZyAEGnXF4GfebKwGsuVR76OUdnck4AZ55Gw8TQ+uE
         Z0aj9K1IuQnH0RMIg1W8PsXZkDGiVftSIf8R1aIj2j6pvjf/ZXssxrvJm5e1CxsaKqu/
         b0chr3yHf4eVGQxLQEzsFnySqb9hq6JSDdwTJDo6CP/jTVktS+RIREjfnmcZpLaSimpG
         H01CgMA7gpltencYuGdfnKOba46I4ZK57xNgZDAqqs0//gydH8edcQaRmXhgBOU9FUns
         7oiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=mddk0RPj5RANjKGN0DxBgjaZKh24JdfVj6LOwAP3f/8=;
        b=XUTpwAynxuvfgL8+BJha8FMotHGc4X2tYAeiSvcvlXZ5pYFZzFppkeV0G4XboziSAu
         xWZT7ttTWzsxE24WqrL3t+UFGnSiZhB3OfGEhpXH0dQ78A/avhh9UPsjV1gtiuBYGULF
         oZ3D8z1F9WEmEaowF3kPY0zIUewiHKSiYdu9wzGibQwF/97AbfaPm/w9fgwf/pyGSLGB
         pzMcOoBUyiuoZgWlKaKiayreTvv5qxZr9AO3lP5jOrjN8hPgR9mpX3Irxx4vIgh3/vun
         mPhfj3ZqxRfq40uSuz4+bIAbbEaEg5DZEpfBISp3cVa0IO2fypu7NwiM5i/TwUrzYE60
         tAjg==
X-Gm-Message-State: AOAM530YLIRk1u9RuYrjkuZK/QWUZkrLvKZZLDqtwWyfP9ruFjZEMxtg
        laAsKakHGywoB/bKNAVbcJNWlQoor10=
X-Google-Smtp-Source: ABdhPJxeIADFgemI74gkbG0I1tnN8WXSvrSkVVka0KyOiqx03LiVL94gPml1pQGX9QoJzqBvAI5Fsg==
X-Received: by 2002:a17:90a:804a:: with SMTP id e10mr7151805pjw.218.1602150558158;
        Thu, 08 Oct 2020 02:49:18 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 206sm6480605pgh.26.2020.10.08.02.49.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:49:17 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 07/17] sctp: add encap_err_lookup for udp encap socks
Date:   Thu,  8 Oct 2020 17:48:03 +0800
Message-Id: <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
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
index 49b5d75..dd2d9c4 100644
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

