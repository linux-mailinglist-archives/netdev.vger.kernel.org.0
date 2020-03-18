Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B1F189D8F
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 15:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgCROGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 10:06:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:56303 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726738AbgCROGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 10:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584540389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7hngLHjvJQH18pXVNtvhQIhSbo94lmhbQP/T7HQ3TDk=;
        b=PmLN5H0U0fuooW0Ub3Lp7aAajWxYgFssKdUyb4HieIO4fKfVPluHieYWnqDlFvkdgKqdyZ
        EN9rX1+ZrIChpgjdfZvXtxeV3epeY20EsyVDW7XYcaQhEpIXgRlXzDGt34xxf641KVDkgi
        yrSVBXLeBDdrkRD1kLI24Z37GLYo6JM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-bHqky28iMf6qoNliq6lNgg-1; Wed, 18 Mar 2020 10:06:27 -0400
X-MC-Unique: bHqky28iMf6qoNliq6lNgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C008A8014D1;
        Wed, 18 Mar 2020 14:06:26 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 799255C1D8;
        Wed, 18 Mar 2020 14:06:23 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Moshe Levi <moshele@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH net] ipv6: don't auto-add link-local address to lag ports
Date:   Wed, 18 Mar 2020 10:06:05 -0400
Message-Id: <20200318140605.45273-1-jarod@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bonding slave and team port devices should not have link-local addresses
automatically added to them, as it can interfere with openvswitch being
able to properly add tc ingress.

Reported-by: Moshe Levi <moshele@mellanox.com>
CC: Marcelo Ricardo Leitner <mleitner@redhat.com>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 net/ipv6/addrconf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 46d614b611db..aed891695084 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3296,6 +3296,10 @@ static void addrconf_addr_gen(struct inet6_dev *id=
ev, bool prefix_route)
 	if (netif_is_l3_master(idev->dev))
 		return;
=20
+	/* no link local addresses on bond slave or team port devices */
+	if (netif_is_lag_port(idev->dev))
+		return;
+
 	ipv6_addr_set(&addr, htonl(0xFE800000), 0, 0, 0);
=20
 	switch (idev->cnf.addr_gen_mode) {
--=20
2.20.1

