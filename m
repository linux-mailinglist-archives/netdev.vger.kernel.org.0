Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A056369D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfGINQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:16:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfGINQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 09:16:12 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38466A3B5D;
        Tue,  9 Jul 2019 13:16:08 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 696B587031;
        Tue,  9 Jul 2019 13:16:06 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 2/2] ip tunnel: warn when changing IPv6 tunnel without tunnel name
Date:   Tue,  9 Jul 2019 15:16:51 +0200
Message-Id: <dfb76d0e40b0158cf6a87ae9558b256915d73f6f.1562667648.git.aclaudi@redhat.com>
In-Reply-To: <cover.1562667648.git.aclaudi@redhat.com>
References: <cover.1562667648.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 09 Jul 2019 13:16:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tunnel change fails if a tunnel name is not specified while using
'ip -6 tunnel change'. However, no warning message is printed and
no error code is returned.

$ ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote fd::2 tos inherit ttl 127 encaplimit none dev dummy0
$ ip -6 tunnel change dev dummy0 local 2001:1234::1 remote 2001:1234::2
$ ip -6 tunnel show ip6tnl1
ip6tnl1: gre/ipv6 remote fd::2 local fd::1 dev dummy0 encaplimit none hoplimit 127 tclass inherit flowlabel 0x00000 (flowinfo 0x00000000)

This commit checks if tunnel interface name is equal to an empty
string: in this case, it prints a warning message to the user.
It intentionally avoids to return an error to not break existing
script setup.

This is the output after this commit:
$ ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote fd::2 tos inherit ttl 127 encaplimit none dev dummy0
$ ip -6 tunnel change dev dummy0 local 2001:1234::1 remote 2001:1234::2
Tunnel interface name not specified
$ ip -6 tunnel show ip6tnl1
ip6tnl1: gre/ipv6 remote fd::2 local fd::1 dev dummy0 encaplimit none hoplimit 127 tclass inherit flowlabel 0x00000 (flowinfo 0x00000000)

Reviewed-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ip6tunnel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
index 999408ed801b1..e3da11eb4518e 100644
--- a/ip/ip6tunnel.c
+++ b/ip/ip6tunnel.c
@@ -386,6 +386,9 @@ static int do_add(int cmd, int argc, char **argv)
 	if (parse_args(argc, argv, cmd, &p) < 0)
 		return -1;
 
+	if (!*p.name)
+		fprintf(stderr, "Tunnel interface name not specified\n");
+
 	if (p.proto == IPPROTO_GRE)
 		basedev = "ip6gre0";
 	else if (p.i_flags & VTI_ISVTI)
-- 
2.20.1

