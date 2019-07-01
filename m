Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A785C0E2
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbfGAQIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:08:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33608 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfGAQIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:08:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so14527436wru.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g8EI9dR5wqlWCjkgzqhV+VwB49xCmjs0uCx9m3RSdtw=;
        b=p2g7hgY5BaLm58Jcxzfq1gk88DPFjgHzR4cySvu+/gz0HLVDkNLFpbGFcMMZKN0mR/
         wqXrzkCQ+72mmYlpxPL91yhAtjOzKKYjvsWlX4hYhLE1Jh2CSbcpPVgMVokD1PLsmigJ
         Nw9ZmDnVPWMmexoUiX3z+wURmKe27KUBa63JbWi266hiiEOtByIfUkekF3Hz2AGxXf/K
         IVdu8aSdcJ3OekZU/MYuQ2FGWZDhlRR4kowrJlWBMTZog3iookBZUk+WZ396qcHry8B3
         xdb3j1yT2UlrZ94Ka9Xrl8zYVC3pwq8lU/srFEdUiFLg18Pt+ATyjzz95AJEozc7YLZf
         4EJg==
X-Gm-Message-State: APjAAAX23N40E0QigZmFMeVtkL5+gQbTtyWzAxLKjpQf5HUXFQ1sqBfe
        4nNI4FXlz0xTsFSTV+K6Mom3AyG+Hag=
X-Google-Smtp-Source: APXvYqxUbiZ/v4dVNuVEoMvePPb3H+nzNZQ0LQC4vMLL5TD+V2lvaiwA+uC+fPxFaAPiV08eAmkzQg==
X-Received: by 2002:adf:dc81:: with SMTP id r1mr19455477wrj.298.1561997289437;
        Mon, 01 Jul 2019 09:08:09 -0700 (PDT)
Received: from raver.teknoraver.net (net-188-216-18-190.cust.vodafonedsl.it. [188.216.18.190])
        by smtp.gmail.com with ESMTPSA id q193sm38329wme.8.2019.07.01.09.08.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 09:08:08 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net] ipv4: don't set IPv6 only flags to IPv4 addresses
Date:   Mon,  1 Jul 2019 18:08:05 +0200
Message-Id: <20190701160805.32404-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid the situation where an IPV6 only flag is applied to an IPv4 address:

    # ip addr add 192.0.2.1/24 dev dummy0 nodad home mngtmpaddr noprefixroute
    # ip -4 addr show dev dummy0
    2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
        inet 192.0.2.1/24 scope global noprefixroute dummy0
           valid_lft forever preferred_lft forever

Or worse, by sending a malicious netlink command:

    # ip -4 addr show dev dummy0
    2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
        inet 192.0.2.1/24 scope global nodad optimistic dadfailed home tentative mngtmpaddr noprefixroute stable-privacy dummy0
           valid_lft forever preferred_lft forever

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/ipv4/devinet.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index c6bd0f7a020a..f40ccdcf4cfe 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -62,6 +62,11 @@
 #include <net/net_namespace.h>
 #include <net/addrconf.h>
 
+#define IPV6ONLY_FLAGS	\
+		(IFA_F_NODAD | IFA_F_OPTIMISTIC | IFA_F_DADFAILED | \
+		 IFA_F_HOMEADDRESS | IFA_F_TENTATIVE | \
+		 IFA_F_MANAGETEMPADDR | IFA_F_STABLE_PRIVACY)
+
 static struct ipv4_devconf ipv4_devconf = {
 	.data = {
 		[IPV4_DEVCONF_ACCEPT_REDIRECTS - 1] = 1,
@@ -468,6 +473,9 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
 	ifa->ifa_flags &= ~IFA_F_SECONDARY;
 	last_primary = &in_dev->ifa_list;
 
+	/* Don't set IPv6 only flags to IPv6 addresses */
+	ifa->ifa_flags &= ~IPV6ONLY_FLAGS;
+
 	for (ifap = &in_dev->ifa_list; (ifa1 = *ifap) != NULL;
 	     ifap = &ifa1->ifa_next) {
 		if (!(ifa1->ifa_flags & IFA_F_SECONDARY) &&
-- 
2.21.0

