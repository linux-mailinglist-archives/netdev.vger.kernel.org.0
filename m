Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C97F2F43
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389100AbfKGN2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:28:10 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34770 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389053AbfKGN2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:28:07 -0500
Received: by mail-lf1-f67.google.com with SMTP id f5so1621383lfp.1
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wRJUigE76AyzxKPdwIXmFrxCAtwRa7ubQV/YC/3pAas=;
        b=eHPgKGH9xEN9hvukhqJLmmua/oS1+CUUAE74DWq5vPa7giYMlc+U3F+6XIkpMpMJVj
         yin0QkebMhmVmf+VmXaYUXtv1lH9PwEf7IXHiothg1gQpqQ6/sqRR6yPdH/GXhXfWHqj
         gd+Wi3sPvg6Rg2+d+nOcd8qxtDwZC76OERewVj7MtTcFXQoKPag2+MX55GLfjLA39hQn
         TrIW0RqReLaUcqK2gJQlX4pL+XSiUd5UWzqvpYJS/YpixQ2tjA3Nj7AJiVKNNAHmrx2F
         2UzWWOmR2J3UfXttJ46kdPIIMd26uPHCpD1zyhsLDgwAbOg8PqTlCAUpiiR86l37VagS
         8ojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wRJUigE76AyzxKPdwIXmFrxCAtwRa7ubQV/YC/3pAas=;
        b=ER03UV76NGMlwEXzWLvKddVSIWVLTlIuhr1rXdbcpCI1IaB0es+HY4fMGtbByxCJ73
         Oq8RPnEnHGpHTgD3lArYxGiFgWP/yuYXi30LSROYt8YWwvwtJDDRdfkT+LfdQEfLzmYC
         QaqR89nMiSkXR8uaoU4NvPl/uM9oEOzo78zSmL5gKr1TXgUDUCW/QlumQZtjcqXDHRfE
         Mk8ayiCw1pqKrNZG8R3G8m5QseVIjw3Ir5fj5IzlpYZW2REFg1ftD2tF5gIm7P9YXsNm
         m43RuW8M5fT7RqZ/LVWnx3ExQz7Ym0WDisHGAj43Oci9UJkgXI61cCArkvPuFW/WM78x
         s3Bw==
X-Gm-Message-State: APjAAAV3NGIIa8HbYO+WUJJzU8ex5PYL95L3yIiKuMhDFFSnejr0LqIA
        3wIBl/K7wSALWtfUAyubzavsEQ==
X-Google-Smtp-Source: APXvYqxbU3kzG4ljeyOS1yo2AT52ALE36CZwu3aUQA9YevpCoCrU7SNcyrErntjJvYRlXZD3N4YuPQ==
X-Received: by 2002:ac2:5deb:: with SMTP id z11mr2563233lfq.35.1573133285907;
        Thu, 07 Nov 2019 05:28:05 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id y20sm3151507ljd.99.2019.11.07.05.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:28:05 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v3 6/6] net: ipv6: allow setting address on interface outside current namespace
Date:   Thu,  7 Nov 2019 14:27:55 +0100
Message-Id: <20191107132755.8517-7-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107132755.8517-1-jonas@norrbonn.se>
References: <20191107132755.8517-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows an interface outside of the current namespace to be
selected when setting a new IPv6 address for a device.  This uses the
IFA_TARGET_NETNSID attribute to select the namespace in which to search
for the interface to act upon.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 net/ipv6/addrconf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 34ccef18b40e..06a49670fe62 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4721,6 +4721,7 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		  struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	struct net *tgt_net;
 	struct ifaddrmsg *ifm;
 	struct nlattr *tb[IFA_MAX+1];
 	struct in6_addr *peer_pfx;
@@ -4758,6 +4759,18 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		cfg.preferred_lft = ci->ifa_prefered;
 	}
 
+	if (tb[IFA_TARGET_NETNSID]) {
+		s32 netnsid = nla_get_s32(tb[IFA_TARGET_NETNSID]);
+
+		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
+		if (IS_ERR(tgt_net)) {
+			NL_SET_ERR_MSG(extack,
+				"ipv6: Invalid target network namespace id");
+			return PTR_ERR(tgt_net);
+		}
+		net = tgt_net;
+	}
+
 	dev =  __dev_get_by_index(net, ifm->ifa_index);
 	if (!dev)
 		return -ENODEV;
-- 
2.20.1

