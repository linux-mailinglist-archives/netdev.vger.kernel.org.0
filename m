Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9071F35CFDF
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243428AbhDLR5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:57:11 -0400
Received: from mtel-bg02.venev.name ([77.70.28.44]:35290 "EHLO
        mtel-bg02.venev.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238145AbhDLR5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 13:57:09 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Apr 2021 13:57:09 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=venev.name;
         s=default; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R7Bbo0cpd1egW2wTpFjQ+HSc37ti0i2e9bmH7ABdh/E=; b=CZvNVRRHDodJ5CRSIH40ShJkKz
        Re6qsswZZHGRPCIlkhN6IAOV1en8uv6Mt+wZwCe4xl+p1zeEcBKC1pYWfz6x+BpavSEEP8Fr/TQE/
        9Jb8L2NXEpacl8ZiZP+S0NGHdfR8Eogyvbi+q1epb5pa/ko+DmX7edVnn6df83z/rwmbnctPfemES
        4AwtvxAGoX+02xYVKbt2HIWDECWf4dzoyj12N2u/9KTs94y1u2J6jE9lTVTpF96StF/hKTMR3wo/V
        sfR79F845fQxPnyVo7nXrbkboDLiuwTbmBbG8uET6h10r9XNMohs2WZDFCIho/r8NdhTqeijIU5Of
        nlnWeq/QhrtJ2r7jlnJhWuzgNyRxfiOG/sivBNZ9c8UlKNyAb1/kVBrwvsnVkbx4G+nNGMRAy6YTT
        SFMiBeHIjbkObhRLSVdbQvs4SYOEw1wPCB/mACQjdiQeUgUudP4wT/DjLnJhg769ZDCKiZPYKgW/W
        IbU337BzTWgkOgzN0WACYGcs7bdnRbIBH79H5PO0NhTCnsKqVlEqt0XBY7bnqQnUFMI9cEsfOhsIn
        SPjzUZiwklrFMYny15mpwPdNA45VpdQeP19ptpS0nzvve70nJkBsNYh3uAjR/FatRys+98EB0Jhz/
        BOYUI5d/O5M0bOpVjmrXLQGUukwdqFd8tJjzxRMVs=;
X-Check-Malware: ok
Received: from mtel-bg02.venev.name ([77.70.28.44] helo=pmx1.venev.name)
        by mtel-bg02.venev.name with esmtps
        id 1lW0Z4-001FxJ-Ba
        (TLS1.3:TLS_AES_256_GCM_SHA384:256)
        (envelope-from <hristo@venev.name>); Mon, 12 Apr 2021 17:41:34 +0000
Received: from venev.name ([77.70.28.44])
        by pmx1.venev.name with ESMTPSA
        id CWMtFU6GdGCNkgQAdB6GMg
        (envelope-from <hristo@venev.name>); Mon, 12 Apr 2021 17:41:34 +0000
From:   Hristo Venev <hristo@venev.name>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Hristo Venev <hristo@venev.name>
Subject: [PATCH 1/2] net: sit: Unregister catch-all devices
Date:   Mon, 12 Apr 2021 20:41:16 +0300
Message-Id: <20210412174117.299570-1-hristo@venev.name>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sit interface created without a local or a remote address is linked
into the `sit_net::tunnels_wc` list of its original namespace. When
deleting a network namespace, delete the devices that have been moved.

The following script triggers a null pointer dereference if devices
linked in a deleted `sit_net` remain:

    for i in `seq 1 30`; do
        ip netns add ns-test
        ip netns exec ns-test ip link add dev veth0 type veth peer veth1
        ip netns exec ns-test ip link add dev sit$i type sit dev veth0
        ip netns exec ns-test ip link set dev sit$i netns $$
        ip netns del ns-test
    done
    for i in `seq 1 30`; do
        ip link del dev sit$i
    done

Fixes: 5e6700b3bf98f ("sit: add support of x-netns")
Signed-off-by: Hristo Venev <hristo@venev.name>
---
 net/ipv6/sit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 63ccd9f2dccc..9fdccf0718b5 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1867,9 +1867,9 @@ static void __net_exit sit_destroy_tunnels(struct net *net,
 		if (dev->rtnl_link_ops == &sit_link_ops)
 			unregister_netdevice_queue(dev, head);
 
-	for (prio = 1; prio < 4; prio++) {
+	for (prio = 0; prio < 4; prio++) {
 		int h;
-		for (h = 0; h < IP6_SIT_HASH_SIZE; h++) {
+		for (h = 0; h < (prio ? IP6_SIT_HASH_SIZE : 1); h++) {
 			struct ip_tunnel *t;
 
 			t = rtnl_dereference(sitn->tunnels[prio][h]);
-- 
2.30.2

