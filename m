Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C345E51942
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbfFXRFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:05:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfFXRFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 13:05:31 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EBCE4623E;
        Mon, 24 Jun 2019 17:05:31 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A10F7600C1;
        Mon, 24 Jun 2019 17:05:30 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 1/3] ip address: do not set nodad option for IPv4 addresses
Date:   Mon, 24 Jun 2019 19:05:53 +0200
Message-Id: <8ceb5d97c00eb4bec860df69e3066be7df1239cc.1561394228.git.aclaudi@redhat.com>
In-Reply-To: <cover.1561394228.git.aclaudi@redhat.com>
References: <cover.1561394228.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 24 Jun 2019 17:05:31 +0000 (UTC)
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
index 47e5be7462fe7..38356cc929e7b 100644
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
+				invarg("nodad option can be set only for IPv6 addresses\n", *argv);
 		} else if (strcmp(*argv, "mngtmpaddr") == 0) {
 			ifa_flags |= IFA_F_MANAGETEMPADDR;
 		} else if (strcmp(*argv, "noprefixroute") == 0) {
-- 
2.20.1

