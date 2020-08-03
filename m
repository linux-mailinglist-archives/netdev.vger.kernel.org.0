Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F006023AE7A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgHCUxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:53:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38365 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728511AbgHCUxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:53:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596488033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7SD0WXY0jqRGNzPWtp9U3hMo8dmyLNdgO6OcR+iDx6M=;
        b=hwh0Baa8jQzGiMMk2nAIu8AMKcOq3BGPPStq7+OJ7hLF+pumNEIH8Tk7LuzD7/M7fuIrNx
        N7Ccb09qhEUT6F3uDyAPLQnlEM5DCXAC4IZvAgLCIeU2AaftaG9kMHgUSIMhUx2l//bIHB
        QMrvKAdoHULEImvvC+YtucaJzA+e4CE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-pZZ5xXL9PLSUgLxJEuE-LA-1; Mon, 03 Aug 2020 16:53:50 -0400
X-MC-Unique: pZZ5xXL9PLSUgLxJEuE-LA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AB4C8064DD;
        Mon,  3 Aug 2020 20:53:48 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A186B10013C1;
        Mon,  3 Aug 2020 20:53:44 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/6] ipv4: route: Ignore output interface in FIB lookup for PMTU route
Date:   Mon,  3 Aug 2020 22:52:09 +0200
Message-Id: <86a082ace1356cebc4430ea38256069e6e2966c3.1596487323.git.sbrivio@redhat.com>
In-Reply-To: <cover.1596487323.git.sbrivio@redhat.com>
References: <cover.1596487323.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, processes sending traffic to a local bridge with an
encapsulation device as a port don't get ICMP errors if they exceed
the PMTU of the encapsulated link.

David Ahern suggested this as a hack, but it actually looks like
the correct solution: when we update the PMTU for a given destination
by means of updating or creating a route exception, the encapsulation
might trigger this because of PMTU discovery happening either on the
encapsulation device itself, or its lower layer.

The output interface shouldn't matter, because we already have a
valid destination. Drop the output interface restriction from the
associated route lookup.

For UDP tunnels, we will now have a route exception created for the
encapsulation itself, with a MTU value reflecting its headroom, which
allows a bridge forwarding IP packets originated locally to deliver
errors back to the sending socket.

The behaviour is now consistent with IPv6 and verified with selftests
pmtu_ipv{4,6}_br_{geneve,vxlan}{4,6}_exception introduced later in
this series.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/ipv4/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a01efa062f6b..c14fd8124f57 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1050,6 +1050,7 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 	struct flowi4 fl4;
 
 	ip_rt_build_flow_key(&fl4, sk, skb);
+	fl4.flowi4_oif = 0;	/* Don't make lookup fail for encapsulations */
 	__ip_rt_update_pmtu(rt, &fl4, mtu);
 }
 
-- 
2.27.0

