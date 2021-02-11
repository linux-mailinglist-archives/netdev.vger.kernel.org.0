Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77A23187D3
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhBKKLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:11:04 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8188 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhBKKIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:08:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602502060000>; Thu, 11 Feb 2021 02:08:06 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 11 Feb
 2021 10:08:05 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 11 Feb 2021 10:08:04 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] net: fib_notifier: don't return positive values on fib registration
Date:   Thu, 11 Feb 2021 12:07:59 +0200
Message-ID: <20210211100759.1156998-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613038086; bh=bswOYCJSB83lpQeMEFwEvw0S8gg442L/3HokMUzqxUU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=awTBYpKV4mkp1xPyt6zZ1MI7y5tj972/qZ3Uf+8RlljI9RDFZx14dWotL9OYERbtK
         8zPACMu0EL9D0OKms7vz7szwC5ns4HStLOagT1yThTiFTsnLwHuAe3/Dr9wZplkN8x
         BPrQmPDyQz96qyQ36+iim5L3K+WBN0/SsDQcIWmU8jAO1fgT4Z2PN7/JIcS7B6nf9m
         IPVkQW8/g7L/gKCCag00KZMOOuAfwFurFrvLkGdx/DVG0MWFtBQzDOFcOmIz/RLppR
         8Tlnj8nv0NQ+Jc5PB/6KTdD9sK6ICtWUZpfWuekMQr04GBN+RTeEtD8mQiM1I/lE6b
         y/MvSVJFL9vGg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function fib6_walk_continue() cannot return a positive value when
called from register_fib_notifier(), but ignoring causes static analyzer to
generate warnings in users of register_fib_notifier() that try to convert
returned error code to pointer with ERR_PTR(). Handle such case by
explicitly checking for positive error values and converting them to
-EINVAL in fib6_tables_dump().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/ipv6/ip6_fib.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index f43e27555725..ef9d022e693f 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -499,7 +499,7 @@ int fib6_tables_dump(struct net *net, struct notifier_b=
lock *nb,
=20
 		hlist_for_each_entry_rcu(tb, head, tb6_hlist) {
 			err =3D fib6_table_dump(net, tb, w);
-			if (err < 0)
+			if (err)
 				goto out;
 		}
 	}
@@ -507,7 +507,8 @@ int fib6_tables_dump(struct net *net, struct notifier_b=
lock *nb,
 out:
 	kfree(w);
=20
-	return err;
+	/* The tree traversal function should never return a positive value. */
+	return err > 0 ? -EINVAL : err;
 }
=20
 static int fib6_dump_node(struct fib6_walker *w)
--=20
2.29.2

