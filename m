Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF59249290
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgHSBy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgHSBy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:54:28 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAEEC061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 18:54:27 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id DDC7D8066C;
        Wed, 19 Aug 2020 13:54:16 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1597802056;
        bh=2rKnZql4flhpEt10yMfhTzp98YOwJSxB9qrMi1Zc3Iw=;
        h=From:To:Cc:Subject:Date;
        b=kO+vFEQFH58owRXzi+DxDztvIFnOmcuenV15O5gBLvZt7nqLy3FCrjSSwOjSUWfvc
         l6XWYYGUGCiQGDayt3AS5pGgQvDA268MA3cjck6k1EEcLzEeCfPCtSuPID903SaNBX
         uOva/AuFHn0uOzO823Mprmz6V291helgv29Y1/bQgH08mSQruwuahY98x2EEEhf2fx
         Uf6VeWdOIpvis7s9veouMczrivs5n68iOnEWM/eXnwJU4W49uAmnYbLD3s1qerGo/a
         GrkODzBP/t1T4r2tr2zqhiN+rFVkq4aI7dfTGwoQSGiQQ9poYOIOYAUwQL4umfAEJP
         yZHX818QJMtRg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f3c86470000>; Wed, 19 Aug 2020 13:54:15 +1200
Received: from markto-dl.ws.atlnz.lc (markto-dl.ws.atlnz.lc [10.33.23.25])
        by smtp (Postfix) with ESMTP id 7D6A513ED33;
        Wed, 19 Aug 2020 13:54:16 +1200 (NZST)
Received: by markto-dl.ws.atlnz.lc (Postfix, from userid 1155)
        id AF68A34110F; Wed, 19 Aug 2020 13:54:16 +1200 (NZST)
From:   Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH] gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY
Date:   Wed, 19 Aug 2020 13:53:58 +1200
Message-Id: <20200819015358.18559-1-mark.tomlinson@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving an IPv4 packet inside an IPv6 GRE packet, and the
IP6_TNL_F_RCV_DSCP_COPY flag is set on the tunnel, the IPv4 header would
get corrupted. This is due to the common ip6_tnl_rcv() function assuming
that the inner header is always IPv6. This patch checks the tunnel
protocol for IPv4 inner packets, but still defaults to IPv6.

Fixes: 308edfdf1563 ("gre6: Cleanup GREv6 receive path, call common GRE f=
unctions")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
---
 net/ipv6/ip6_tunnel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index f635914f42ec..a0217e5bf3bc 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -915,7 +915,15 @@ int ip6_tnl_rcv(struct ip6_tnl *t, struct sk_buff *s=
kb,
 		struct metadata_dst *tun_dst,
 		bool log_ecn_err)
 {
-	return __ip6_tnl_rcv(t, skb, tpi, tun_dst, ip6ip6_dscp_ecn_decapsulate,
+	int (*dscp_ecn_decapsulate)(const struct ip6_tnl *t,
+				    const struct ipv6hdr *ipv6h,
+				    struct sk_buff *skb);
+
+	dscp_ecn_decapsulate =3D ip6ip6_dscp_ecn_decapsulate;
+	if (tpi->proto =3D=3D htons(ETH_P_IP))
+		dscp_ecn_decapsulate =3D ip4ip6_dscp_ecn_decapsulate;
+
+	return __ip6_tnl_rcv(t, skb, tpi, tun_dst, dscp_ecn_decapsulate,
 			     log_ecn_err);
 }
 EXPORT_SYMBOL(ip6_tnl_rcv);
--=20
2.28.0

