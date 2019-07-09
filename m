Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220746369B
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfGINQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:16:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43460 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfGINQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 09:16:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 26CDD2F8BE1;
        Tue,  9 Jul 2019 13:16:06 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5768D87031;
        Tue,  9 Jul 2019 13:16:04 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 1/2] Revert "ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds"
Date:   Tue,  9 Jul 2019 15:16:50 +0200
Message-Id: <5caaac096e5bbbf88ad3aedcc50ff2451f94105c.1562667648.git.aclaudi@redhat.com>
In-Reply-To: <cover.1562667648.git.aclaudi@redhat.com>
References: <cover.1562667648.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 09 Jul 2019 13:16:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit ba126dcad20e6d0e472586541d78bdd1ac4f1123.
It breaks tunnel creation when using 'dev' parameter:

$ ip link add type dummy
$ ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2 local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev dummy0
add tunnel "ip6tnl0" failed: File exists

dev parameter must be used to specify the device to which
the tunnel is binded, and not the tunnel itself.

Reported-by: Jianwen Ji <jiji@redhat.com>
Reviewed-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ip6tunnel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
index 56fd3466ed062..999408ed801b1 100644
--- a/ip/ip6tunnel.c
+++ b/ip/ip6tunnel.c
@@ -298,8 +298,6 @@ static int parse_args(int argc, char **argv, int cmd, struct ip6_tnl_parm2 *p)
 		p->link = ll_name_to_index(medium);
 		if (!p->link)
 			return nodev(medium);
-		else
-			strlcpy(p->name, medium, sizeof(p->name));
 	}
 	return 0;
 }
-- 
2.20.1

