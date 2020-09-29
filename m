Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4098D27CFDE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgI2NuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgI2NuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:50:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92F8C061755;
        Tue, 29 Sep 2020 06:50:20 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so4589141pfn.9;
        Tue, 29 Sep 2020 06:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=uHR6RpGEci8H9pvKA0+VLzTG3pu14wk/3lPhWqq+6lU=;
        b=CzZoL9k2GKbCZn1o+6xKhGbOgzumuSAWyF+xiN3HK3bjrmVmM8zcmG4LsFtp37YZqi
         absJMp6WU10nBc+k7pJddk7/fjTsx/8yg2OH/dRiygqXVwFlMi39yJI2sud6ELS46hUa
         eJ1vBHi1XJ5zizY/RVZC2a90LpbZTLIY7p/wQbsP2BVl5GcjnhkkIiyx48VjGW2wk16m
         iOMx/f9St5dEf7sUIIOsgGwlWKnJgHs4I9YhdYe9lsZjTU2/V42QNp9FeHGzH7m1X/V0
         1PF7ibTGsBNEbxq1XBxvyST7Qh39OK1U9lCIhPAAJrTmmSd2y5vM5kz/t7K3MWg2Iivs
         Tc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=uHR6RpGEci8H9pvKA0+VLzTG3pu14wk/3lPhWqq+6lU=;
        b=l+j19ShJR5oazYKLEakV+SradI4ZeeHCBvs20oEXhMBngkJlR1aL/jhBCa8J2q5RFj
         M9pcvN4+MBmiruTZaKPsd7iKuafbwXl4nCMB/BOqn3k65TJcZqkyKUGrzsmH+VxrkyWQ
         rVL76iXhtYQhEeWotATFXW1JUbJNmMcZNoOj4QrZyXxRhk8zj0xtX+W8lDca4S0mPiuT
         7qp5uz9Lj0sYZDGHPWBcdDu1wxXZVTyZ561YAYL62gs+b9wVzfwXtiekBPEe4KB8rwLF
         Pu1b3PAXtm5kt8tt8MqAaMGPY3ixc64Le2DQVn9SSgjboDKAYaEsJCJxM7s06fstllkC
         LO/A==
X-Gm-Message-State: AOAM533LYtpFhOzPOw5/D3ecXlym+Jgi91hh7bYqqFstzJP5XUyY8YmB
        /rbBQNs5rQomKqs5UsB83Zab7V0NM2c=
X-Google-Smtp-Source: ABdhPJyJiB5M+osJ5R/yh3m2UIuWG9HDou9vasZlGbJG7j2O1udgqenwLgqqiVmqmo2o45VuxdmRrg==
X-Received: by 2002:a17:902:aa95:b029:d2:19f4:ff56 with SMTP id d21-20020a170902aa95b02900d219f4ff56mr4811599plr.78.1601387419548;
        Tue, 29 Sep 2020 06:50:19 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v8sm5395306pgg.58.2020.09.29.06.50.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:50:18 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 07/15] sctp: add encap_err_lookup for udp encap socks
Date:   Tue, 29 Sep 2020 21:48:59 +0800
Message-Id: <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As says in rfc6951#section-5.5:

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
do here is check if the corresponding asoc and transport exists.

Note that icmp packet process for sctp over udp is done by udp sock
.encap_err_lookup(), and it means for now we can't do as much as
sctp_v4/6_err() does. Also we can't do the two mappings mentioned
in rfc6951#section-5.5.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 0aaa24d..953891b 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -847,6 +847,23 @@ static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
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
@@ -863,6 +880,7 @@ int sctp_udp_sock_start(struct net *net)
 
 	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
+	tuncfg.encap_err_lookup = sctp_udp_err_lookup;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp4_sock = sock->sk;
 
@@ -882,6 +900,7 @@ int sctp_udp_sock_start(struct net *net)
 
 	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
+	tuncfg.encap_err_lookup = sctp_udp_err_lookup;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp6_sock = sock->sk;
 
-- 
2.1.0

