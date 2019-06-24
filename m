Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943D751944
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732199AbfFXRFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:05:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732171AbfFXRFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 13:05:32 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81BFC30BC57A;
        Mon, 24 Jun 2019 17:05:32 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2D1F600C0;
        Mon, 24 Jun 2019 17:05:31 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 2/3] ip address: do not set home option for IPv4 addresses
Date:   Mon, 24 Jun 2019 19:05:54 +0200
Message-Id: <54410e6543be9fb164aa255b906b26db0c196a17.1561394228.git.aclaudi@redhat.com>
In-Reply-To: <cover.1561394228.git.aclaudi@redhat.com>
References: <cover.1561394228.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 24 Jun 2019 17:05:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'home' option designates a IPv6 address as "home address" as
defined in RFC 6275. This option should be available only for
IPv6 addresses, as correctly stated in the manpage.

However it is possible to set home on IPv4 addresses, too:

$ ip link add dummy0 type dummy
$ ip -4 addr add 192.168.1.1 dev dummy0 home
$ ip a
1: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
   link/ether 1a:6d:c6:96:ca:f8 brd ff:ff:ff:ff:ff:ff
   inet 192.168.1.1/32 scope global home dummy0
      valid_lft forever preferred_lft forever

Fix this adding a check on the protocol family before setting
IFA_F_HOMEADDRESS flag.

Fixes: bac735c53a36d ("enabled to manipulate the flags of IFA_F_HOMEADDRESS or IFA_F_NODAD from ip.")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipaddress.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 38356cc929e7b..0f59e0a40468c 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2248,7 +2248,10 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 			if (set_lifetime(&preferred_lft, *argv))
 				invarg("preferred_lft value", *argv);
 		} else if (strcmp(*argv, "home") == 0) {
-			ifa_flags |= IFA_F_HOMEADDRESS;
+			if (req.ifa.ifa_family == AF_INET6)
+				ifa_flags |= IFA_F_HOMEADDRESS;
+			else
+				invarg("home option can be set only for IPv6 addresses\n", *argv);
 		} else if (strcmp(*argv, "nodad") == 0) {
 			if (req.ifa.ifa_family == AF_INET6)
 				ifa_flags |= IFA_F_NODAD;
-- 
2.20.1

