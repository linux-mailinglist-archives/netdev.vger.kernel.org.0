Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E177D5C194
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbfGARCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:02:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39040 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729374AbfGARCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:02:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so14652846wrt.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 10:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BitDIcqhWgHEgMJLtZLbAJSwkoBiueOjWJvTMdME7eM=;
        b=ApVIUozcHoAHBeBdsNij3PcN5jvyKkaV39rdwb7YTGmhWtYjlSJLAKGRvcq/VFWGg0
         fWIrggUq8E4uVeKQUSFZ6OSP0zMfQCvqpgMoX50P+jD6vX0rJHyQgmNkgHnKbMBeexyC
         VqqkDEofzJ64gGo0YpCiBRMv1ZJdLoZx9BDpi2LSYc+cHlaUBBVQitMj8vnfoQJKG1Xm
         4EN11/slVG9etgyXnf1Dcsc7GcCREAE6p7Jn9hQR4La+Q89nJcNTTD7gDU2r+lI6cEl/
         yu2YpeqJAPUVopBCJoeD9uf+I3QxXq9YibUISBR2jmS4iDbXgONFkUjIlQZYqiQAF8fO
         1IeA==
X-Gm-Message-State: APjAAAU5r5013lqz7Y3uDW+q6Riavh35oCzFuuR+tXa7NkVF/vfF5lvI
        aAnUTmqJB4u3Fmdq2OWit7G72b0u/cU=
X-Google-Smtp-Source: APXvYqzdjKhn5cL0AZCHMwwfaVQOBDJ9MfI7VOZ8/Kd+4+q4hHSgVhw+dtUPdP46hDZYDoj92QS0+g==
X-Received: by 2002:adf:f101:: with SMTP id r1mr20277421wro.170.1562000518600;
        Mon, 01 Jul 2019 10:01:58 -0700 (PDT)
Received: from raver.teknoraver.net (net-188-216-18-190.cust.vodafonedsl.it. [188.216.18.190])
        by smtp.gmail.com with ESMTPSA id f12sm24948938wrg.5.2019.07.01.10.01.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 10:01:57 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net v2] ipv4: don't set IPv6 only flags to IPv4 addresses
Date:   Mon,  1 Jul 2019 19:01:55 +0200
Message-Id: <20190701170155.1967-1-mcroce@redhat.com>
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
index c6bd0f7a020a..c5ebfa199794 100644
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
 
+	/* Don't set IPv6 only flags to IPv4 addresses */
+	ifa->ifa_flags &= ~IPV6ONLY_FLAGS;
+
 	for (ifap = &in_dev->ifa_list; (ifa1 = *ifap) != NULL;
 	     ifap = &ifa1->ifa_next) {
 		if (!(ifa1->ifa_flags & IFA_F_SECONDARY) &&
-- 
2.21.0

