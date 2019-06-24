Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C5551943
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbfFXRFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:05:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732171AbfFXRFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 13:05:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 957502F8BEC;
        Mon, 24 Jun 2019 17:05:33 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C573A600C0;
        Mon, 24 Jun 2019 17:05:32 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 3/3] ip address: do not set mngtmpaddr option for IPv4 addresses
Date:   Mon, 24 Jun 2019 19:05:55 +0200
Message-Id: <190b07fb798eb1da4051af7671df7c61ceaaba02.1561394228.git.aclaudi@redhat.com>
In-Reply-To: <cover.1561394228.git.aclaudi@redhat.com>
References: <cover.1561394228.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 24 Jun 2019 17:05:33 +0000 (UTC)
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
index 0f59e0a40468c..06a9f904201c0 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2258,7 +2258,10 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 			else
 				invarg("nodad option can be set only for IPv6 addresses\n", *argv);
 		} else if (strcmp(*argv, "mngtmpaddr") == 0) {
-			ifa_flags |= IFA_F_MANAGETEMPADDR;
+			if (req.ifa.ifa_family == AF_INET6)
+				ifa_flags |= IFA_F_MANAGETEMPADDR;
+			else
+				invarg("mngtmpaddr option can be set only for IPv6 addresses\n", *argv);
 		} else if (strcmp(*argv, "noprefixroute") == 0) {
 			ifa_flags |= IFA_F_NOPREFIXROUTE;
 		} else if (strcmp(*argv, "autojoin") == 0) {
-- 
2.20.1

