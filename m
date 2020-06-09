Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862A81F2CB6
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbgFIA1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730299AbgFHXQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B4E20801;
        Mon,  8 Jun 2020 23:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658199;
        bh=Ual6lbXI0lU8uEP87cPxtPd6hIy/Thh6CONhXh0FcVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/Vk6Eu/DbLcSDqTTG1dIbst8Y06tTemsBwzfZ12Jb7oheOUf673UazrognfdZ6cU
         ZuigTomTvZnxsprgajThLq24tZ+pEk+mPcpBu5UC1qok0j4zyl+VNaXLbObyNn6Y2i
         o3GtprFWFjMtkloXOZcUks2o0UOc2xDe+XAUiN7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Worley <sworley@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 219/606] net: nlmsg_cancel() if put fails for nhmsg
Date:   Mon,  8 Jun 2020 19:05:44 -0400
Message-Id: <20200608231211.3363633-219-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Worley <sworley@cumulusnetworks.com>

[ Upstream commit d69100b8eee27c2d60ee52df76e0b80a8d492d34 ]

Fixes data remnant seen when we fail to reserve space for a
nexthop group during a larger dump.

If we fail the reservation, we goto nla_put_failure and
cancel the message.

Reproduce with the following iproute2 commands:
=====================
ip link add dummy1 type dummy
ip link add dummy2 type dummy
ip link add dummy3 type dummy
ip link add dummy4 type dummy
ip link add dummy5 type dummy
ip link add dummy6 type dummy
ip link add dummy7 type dummy
ip link add dummy8 type dummy
ip link add dummy9 type dummy
ip link add dummy10 type dummy
ip link add dummy11 type dummy
ip link add dummy12 type dummy
ip link add dummy13 type dummy
ip link add dummy14 type dummy
ip link add dummy15 type dummy
ip link add dummy16 type dummy
ip link add dummy17 type dummy
ip link add dummy18 type dummy
ip link add dummy19 type dummy
ip link add dummy20 type dummy
ip link add dummy21 type dummy
ip link add dummy22 type dummy
ip link add dummy23 type dummy
ip link add dummy24 type dummy
ip link add dummy25 type dummy
ip link add dummy26 type dummy
ip link add dummy27 type dummy
ip link add dummy28 type dummy
ip link add dummy29 type dummy
ip link add dummy30 type dummy
ip link add dummy31 type dummy
ip link add dummy32 type dummy

ip link set dummy1 up
ip link set dummy2 up
ip link set dummy3 up
ip link set dummy4 up
ip link set dummy5 up
ip link set dummy6 up
ip link set dummy7 up
ip link set dummy8 up
ip link set dummy9 up
ip link set dummy10 up
ip link set dummy11 up
ip link set dummy12 up
ip link set dummy13 up
ip link set dummy14 up
ip link set dummy15 up
ip link set dummy16 up
ip link set dummy17 up
ip link set dummy18 up
ip link set dummy19 up
ip link set dummy20 up
ip link set dummy21 up
ip link set dummy22 up
ip link set dummy23 up
ip link set dummy24 up
ip link set dummy25 up
ip link set dummy26 up
ip link set dummy27 up
ip link set dummy28 up
ip link set dummy29 up
ip link set dummy30 up
ip link set dummy31 up
ip link set dummy32 up

ip link set dummy33 up
ip link set dummy34 up

ip link set vrf-red up
ip link set vrf-blue up

ip link set dummyVRFred up
ip link set dummyVRFblue up

ip ro add 1.1.1.1/32 dev dummy1
ip ro add 1.1.1.2/32 dev dummy2
ip ro add 1.1.1.3/32 dev dummy3
ip ro add 1.1.1.4/32 dev dummy4
ip ro add 1.1.1.5/32 dev dummy5
ip ro add 1.1.1.6/32 dev dummy6
ip ro add 1.1.1.7/32 dev dummy7
ip ro add 1.1.1.8/32 dev dummy8
ip ro add 1.1.1.9/32 dev dummy9
ip ro add 1.1.1.10/32 dev dummy10
ip ro add 1.1.1.11/32 dev dummy11
ip ro add 1.1.1.12/32 dev dummy12
ip ro add 1.1.1.13/32 dev dummy13
ip ro add 1.1.1.14/32 dev dummy14
ip ro add 1.1.1.15/32 dev dummy15
ip ro add 1.1.1.16/32 dev dummy16
ip ro add 1.1.1.17/32 dev dummy17
ip ro add 1.1.1.18/32 dev dummy18
ip ro add 1.1.1.19/32 dev dummy19
ip ro add 1.1.1.20/32 dev dummy20
ip ro add 1.1.1.21/32 dev dummy21
ip ro add 1.1.1.22/32 dev dummy22
ip ro add 1.1.1.23/32 dev dummy23
ip ro add 1.1.1.24/32 dev dummy24
ip ro add 1.1.1.25/32 dev dummy25
ip ro add 1.1.1.26/32 dev dummy26
ip ro add 1.1.1.27/32 dev dummy27
ip ro add 1.1.1.28/32 dev dummy28
ip ro add 1.1.1.29/32 dev dummy29
ip ro add 1.1.1.30/32 dev dummy30
ip ro add 1.1.1.31/32 dev dummy31
ip ro add 1.1.1.32/32 dev dummy32

ip next add id 1 via 1.1.1.1 dev dummy1
ip next add id 2 via 1.1.1.2 dev dummy2
ip next add id 3 via 1.1.1.3 dev dummy3
ip next add id 4 via 1.1.1.4 dev dummy4
ip next add id 5 via 1.1.1.5 dev dummy5
ip next add id 6 via 1.1.1.6 dev dummy6
ip next add id 7 via 1.1.1.7 dev dummy7
ip next add id 8 via 1.1.1.8 dev dummy8
ip next add id 9 via 1.1.1.9 dev dummy9
ip next add id 10 via 1.1.1.10 dev dummy10
ip next add id 11 via 1.1.1.11 dev dummy11
ip next add id 12 via 1.1.1.12 dev dummy12
ip next add id 13 via 1.1.1.13 dev dummy13
ip next add id 14 via 1.1.1.14 dev dummy14
ip next add id 15 via 1.1.1.15 dev dummy15
ip next add id 16 via 1.1.1.16 dev dummy16
ip next add id 17 via 1.1.1.17 dev dummy17
ip next add id 18 via 1.1.1.18 dev dummy18
ip next add id 19 via 1.1.1.19 dev dummy19
ip next add id 20 via 1.1.1.20 dev dummy20
ip next add id 21 via 1.1.1.21 dev dummy21
ip next add id 22 via 1.1.1.22 dev dummy22
ip next add id 23 via 1.1.1.23 dev dummy23
ip next add id 24 via 1.1.1.24 dev dummy24
ip next add id 25 via 1.1.1.25 dev dummy25
ip next add id 26 via 1.1.1.26 dev dummy26
ip next add id 27 via 1.1.1.27 dev dummy27
ip next add id 28 via 1.1.1.28 dev dummy28
ip next add id 29 via 1.1.1.29 dev dummy29
ip next add id 30 via 1.1.1.30 dev dummy30
ip next add id 31 via 1.1.1.31 dev dummy31
ip next add id 32 via 1.1.1.32 dev dummy32

i=100

while [ $i -le 200 ]
do
ip next add id $i group 1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19

	echo $i

	((i++))

done

ip next add id 999 group 1/2/3/4/5/6

ip next ls

========================

Fixes: ab84be7e54fc ("net: Initial nexthop code")
Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index d072c326dd64..489c27f894d7 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -276,6 +276,7 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 	return 0;
 
 nla_put_failure:
+	nlmsg_cancel(skb, nlh);
 	return -EMSGSIZE;
 }
 
-- 
2.25.1

