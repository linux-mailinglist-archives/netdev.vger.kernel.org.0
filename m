Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF29E52981
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbfFYK35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732027AbfFYK3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 06:29:52 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C679530B96FD;
        Tue, 25 Jun 2019 10:29:51 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 067C25C22F;
        Tue, 25 Jun 2019 10:29:50 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 v2 1/3] ip address: do not set nodad option for IPv4 addresses
Date:   Tue, 25 Jun 2019 12:29:55 +0200
Message-Id: <9f2200051e3d8bcdfc33ecdfb14f0d975be9d6df.1561457597.git.aclaudi@redhat.com>
In-Reply-To: <cover.1561457597.git.aclaudi@redhat.com>
References: <cover.1561457597.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 25 Jun 2019 10:29:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Duplicate Address Detection (RFC 4862) is available only for IPv6
addresses. As a consequence, 'nodad' option, turning it off, should
be available only for IPv6, and is defined like that in the man page.

However it is possible to set nodad on IPv4 addresses, too:

$ ip link add dummy0 type dummy
$ ip -4 addr add 192.168.1.1 dev dummy0 nodad
$ ip a
1: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
   link/ether 1a:6d:c6:96:ca:f8 brd ff:ff:ff:ff:ff:ff
   inet 192.168.1.1/32 scope global nodad dummy0
      valid_lft forever preferred_lft forever

Fix this adding a check on the protocol family before setting
IFA_F_NODAD flag.

Fixes: bac735c53a36d ("enabled to manipulate the flags of IFA_F_HOMEADDRESS or IFA_F_NODAD from ip.")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipaddress.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 47e5be7462fe7..d157f72784a21 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2250,7 +2250,10 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 		} else if (strcmp(*argv, "home") == 0) {
 			ifa_flags |= IFA_F_HOMEADDRESS;
 		} else if (strcmp(*argv, "nodad") == 0) {
-			ifa_flags |= IFA_F_NODAD;
+			if (req.ifa.ifa_family == AF_INET6)
+				ifa_flags |= IFA_F_NODAD;
+			else
+				fprintf(stderr, "Warning: nodad option can be set only for IPv6 addresses\n");
 		} else if (strcmp(*argv, "mngtmpaddr") == 0) {
 			ifa_flags |= IFA_F_MANAGETEMPADDR;
 		} else if (strcmp(*argv, "noprefixroute") == 0) {
-- 
2.20.1

