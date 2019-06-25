Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1195297F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbfFYK34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732030AbfFYK3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 06:29:54 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F06F4300182B;
        Tue, 25 Jun 2019 10:29:53 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C1685C22F;
        Tue, 25 Jun 2019 10:29:53 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 v2 3/3] ip address: do not set mngtmpaddr option for IPv4 addresses
Date:   Tue, 25 Jun 2019 12:29:57 +0200
Message-Id: <1d7f2e5614e7f667fb7778aa344ea94320de6602.1561457597.git.aclaudi@redhat.com>
In-Reply-To: <cover.1561457597.git.aclaudi@redhat.com>
References: <cover.1561457597.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 25 Jun 2019 10:29:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'mngtmpaddr' option make the kernel manage temporary addresses
created from the specified one as template on behalf of Privacy
Extensions (RFC3041). This option should be available only for
IPv6 addresses, as correctly stated in the manpage.

However it is possible to set mngtmpaddr on IPv4 addresses, too:

$ ip link add dummy0 type dummy
$ ip -4 addr add 192.168.1.1 dev dummy0 mngtmpaddr
$ ip a
1: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
   link/ether 1a:6d:c6:96:ca:f8 brd ff:ff:ff:ff:ff:ff
   inet 192.168.1.1/32 scope global mngtmpaddr dummy0
      valid_lft forever preferred_lft forever

Fix this adding a check on the protocol family before setting
IFA_F_MANAGETEMPADDR flag.

Fixes: 5b7e21c417bea ("add support for IFA_F_MANAGETEMPADDR")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipaddress.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index e1b0e2224a768..8d5f4f9e51ffc 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2258,7 +2258,10 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 			else
 				fprintf(stderr, "Warning: nodad option can be set only for IPv6 addresses\n");
 		} else if (strcmp(*argv, "mngtmpaddr") == 0) {
-			ifa_flags |= IFA_F_MANAGETEMPADDR;
+			if (req.ifa.ifa_family == AF_INET6)
+				ifa_flags |= IFA_F_MANAGETEMPADDR;
+			else
+				fprintf(stderr, "Warning: mngtmpaddr option can be set only for IPv6 addresses\n");
 		} else if (strcmp(*argv, "noprefixroute") == 0) {
 			ifa_flags |= IFA_F_NOPREFIXROUTE;
 		} else if (strcmp(*argv, "autojoin") == 0) {
-- 
2.20.1

