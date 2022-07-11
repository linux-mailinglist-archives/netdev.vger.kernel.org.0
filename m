Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD48556FBB9
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiGKJeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbiGKJdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:33:24 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083FDF5B8;
        Mon, 11 Jul 2022 02:18:01 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26B7hBTZ008991;
        Mon, 11 Jul 2022 11:17:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=8g/uTcIAzTh4F+oOWO2jbWoQcmsDGPi5/QdwJ/wTyXs=;
 b=hXyqhjbUqp0fR+9r5ufmuhS1eEO4v3iVdQIF1GskddwzrrmBcsxR6DtkaAC0sOIYAQQI
 DVFXy9zs59FU1GX2SqjCUYyKYYhHBb6FBReXwN81MEo6q44o1opNVBD47IuPs9KpPS6I
 tkL3o2e+LQtBMzgFNJDJ/hsq8pp4ERXlCPTJxYxs33vQ3WGcZyWDY6lJJTYAgA740TTk
 E9R0K3ToE06AqJqWumKrip1OdSxon/d6lo4U9fUBu8J89o17Z6YPrQi3/gD9e488rw3v
 8sobRXpwvtEt13so+CEjh5onbUn3rJ+M5HgIOLUlVa80qXM4Q2QV/6eZPBObRIeM1g4r Lw== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h6wp61x7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 11:17:38 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Mon, 11 Jul 2022 11:17:37 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH 0/4 net-next] Allow to inherit from VLAN encapsulated IP
Date:   Mon, 11 Jul 2022 11:17:18 +0200
Message-ID: <20220711091722.14485-1-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: f5g1IzTxWOd1BjY1RPm1U3GZ2z3yR969
X-Proofpoint-GUID: f5g1IzTxWOd1BjY1RPm1U3GZ2z3yR969
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently IPv4 and IPv6 tunnels are able to inherit IP header fields
like TOS, TTL or the DF from their payload, when the payload is IPv4
or IPv6. Some types of tunnels, like GRETAP or VXLAN are able to carry
VLANs. The visible skb->protocol shows in this case as protocol
ETH_P_8021Q or ETH_P_8021AD. However all the relevant structures for IP
payload are correct and just need to be used.

Patch 1 allows tunnels with IPv4 as outer header to inherit from VLAN
encapsulated payload.
Patch 2 fixes a bug, where the DSCP for tunnels with IPv6 as outer header
is never set.
Patch 3 allows tunnels with IPv6 as outer header to inherit the TTL from
VLAN encapsulated payload.
Patch 4 allows IP6GRETAP tunnels with IPv6 as outer header to inherit the
TOS from VLAN encapsulated payload.

Matthias May (4):
  ip_tunnel: allow to inherit from VLAN encapsulated IP
  ip6_gre: set DSCP for non-IP
  ip6_gre: use actual protocol to select xmit
  ip6_tunnel: allow to inherit from VLAN encapsulated IP

 net/ipv4/ip_tunnel.c  | 17 +++++++++--------
 net/ipv6/ip6_gre.c    | 43 +++++++++++++++++++++++++++++++++++--------
 net/ipv6/ip6_tunnel.c | 11 +++++++----
 3 files changed, 51 insertions(+), 20 deletions(-)

-- 
2.35.1

