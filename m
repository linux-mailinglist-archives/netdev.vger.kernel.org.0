Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88BF165FE1
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgBTOme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:42:34 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32824 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgBTOme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 09:42:34 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so3321802lfl.0
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 06:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8I2Ckh1/aNcXhJ3210lqnk0SfH0fw3CnaZjaknZpTPA=;
        b=BLQRZuw9L3sWNNd48DfsWXnL/ozKuJcyl9t6piN1NCaB3hWS7hhMquQwnjnVjqcWZY
         ep6cW4at6y4i2C4i+p46NKW9GI8l3sb1nk4BVNNGdTqszR8G+/DWGhWE16FrtrWwAJyW
         OAUNSx3QHhOrDtc5OHViIeF3MHVt2JTuQF8ko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8I2Ckh1/aNcXhJ3210lqnk0SfH0fw3CnaZjaknZpTPA=;
        b=NfsPABp0UI8l08RDRRMTw+RY7+lUl7g8An7dxFvFTubC5Cpa0qXtTMh6xDsDiPHcmm
         vRJ9HDXDvTo1DRan0WyGTUjVvwjcj4dCH3ZELEyxEJbI1go4jRMigPDn+RbSIOkEVXpy
         S8yKqZ7scH+C9zPKz43gLvY8/MHfgC1qcARmoJjRnyTJZd8cXbHd0qBprxcvj5su8Bb2
         IiZcubdECxLxPyQEqmLamqawG6upLfmOouhSTGTlARYjyf4oG9IBC4eJIiaiPMXrhjvf
         zsbCab8RFEqOJaeAWRSDhu//rv4p8RDqF6vVFLi80lDAysAbUaeXceR8xfIYeygPyEjg
         FTYA==
X-Gm-Message-State: APjAAAVanTlm+zM4lTkEsKX0VlcaZE0BDyBSYH7pjyU3aJGJptj2gId+
        YsPe8PLFgafWsBkmfXNlx5BR/aq3rDA=
X-Google-Smtp-Source: APXvYqxF2Tcx0TF8IHIwmhAnhBNmbl2ks5h46TZyxyWpij7CwVjHwqftAb2zUyPsbFlYAvoF1SBw/A==
X-Received: by 2002:ac2:5f59:: with SMTP id 25mr16609285lfz.193.1582209750275;
        Thu, 20 Feb 2020 06:42:30 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u16sm1895392ljo.22.2020.02.20.06.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 06:42:29 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Richard Guy Briggs <rgb@redhat.com>,
        "Erhard F ." <erhard_f@mailbox.org>
Subject: [PATCH net] net: netlink: cap max groups which will be considered in netlink_bind()
Date:   Thu, 20 Feb 2020 16:42:13 +0200
Message-Id: <20200220144213.860206-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since nl_groups is a u32 we can't bind more groups via ->bind
(netlink_bind) call, but netlink has supported more groups via
setsockopt() for a long time and thus nlk->ngroups could be over 32.
Recently I added support for per-vlan notifications and increased the
groups to 33 for NETLINK_ROUTE which exposed an old bug in the
netlink_bind() code causing out-of-bounds access on archs where unsigned
long is 32 bits via test_bit() on a local variable. Fix this by capping the
maximum groups in netlink_bind() to BITS_PER_TYPE(u32), effectively
capping them at 32 which is the minimum of allocated groups and the
maximum groups which can be bound via netlink_bind().

CC: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Richard Guy Briggs <rgb@redhat.com>
Fixes: 4f520900522f ("netlink: have netlink per-protocol bind function return an error code.")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
Dave it is not necessary to queue this fix for stable releases since
NETLINK_ROUTE is the first to reach more groups after I added the vlan
notification changes and I don't think we'll ever backport new groups. :)
Up to you of course.

In fact looking at netlink_kernel_create nlk->groups can't be less than 32
so we can add a NETLINK_MIN_GROUPS == NETLINK_MAX_LEGACY_BIND_GRPS == 32
in net-next to replace the raw value.

 net/netlink/af_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4e31721e7293..edf3e285e242 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1014,7 +1014,8 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 	if (nlk->netlink_bind && groups) {
 		int group;
 
-		for (group = 0; group < nlk->ngroups; group++) {
+		/* nl_groups is a u32, so cap the maximum groups we can bind */
+		for (group = 0; group < BITS_PER_TYPE(u32); group++) {
 			if (!test_bit(group, &groups))
 				continue;
 			err = nlk->netlink_bind(net, group + 1);
@@ -1033,7 +1034,7 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 			netlink_insert(sk, nladdr->nl_pid) :
 			netlink_autobind(sock);
 		if (err) {
-			netlink_undo_bind(nlk->ngroups, groups, sk);
+			netlink_undo_bind(BITS_PER_TYPE(u32), groups, sk);
 			goto unlock;
 		}
 	}
-- 
2.24.1

