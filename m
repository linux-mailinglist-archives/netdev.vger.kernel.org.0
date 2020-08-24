Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE7F2504F3
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHXRJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgHXQiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB77723107;
        Mon, 24 Aug 2020 16:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287055;
        bh=EDyuBxscEBFo0q5+evBlw6QehaWe6cJ8leEWjHk1kgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRrVVEwUpHMvD1R8Hk3iG5y58A0y8RAuo92bQSo/4tGlXQdtszOMdbwAreRTZJq+/
         oHFNqC1k7S/jJrGbtcgplwRfQYWyKpIk1JNBcuc6lY93MtmTV7t/nMLMyMbA9wX4cD
         QwWqvyvUlCgQ4FOjlQVsejZvrh8s3ijXkpQCgt/0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 44/54] macvlan: validate setting of multiple remote source MAC addresses
Date:   Mon, 24 Aug 2020 12:36:23 -0400
Message-Id: <20200824163634.606093-44-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit 8b61fba503904acae24aeb2bd5569b4d6544d48f ]

Remote source MAC addresses can be set on a 'source mode' macvlan
interface via the IFLA_MACVLAN_MACADDR_DATA attribute. This commit
tightens the validation of these MAC addresses to match the validation
already performed when setting or adding a single MAC address via the
IFLA_MACVLAN_MACADDR attribute.

iproute2 uses IFLA_MACVLAN_MACADDR_DATA for its 'macvlan macaddr set'
command, and IFLA_MACVLAN_MACADDR for its 'macvlan macaddr add' command,
which demonstrates the inconsistent behaviour that this commit
addresses:

 # ip link add link eth0 name macvlan0 type macvlan mode source
 # ip link set link dev macvlan0 type macvlan macaddr add 01:00:00:00:00:00
 RTNETLINK answers: Cannot assign requested address
 # ip link set link dev macvlan0 type macvlan macaddr set 01:00:00:00:00:00
 # ip -d link show macvlan0
 5: macvlan0@eth0: <BROADCAST,MULTICAST,DYNAMIC,UP,LOWER_UP> mtu 1500 ...
     link/ether 2e:ac:fd:2d:69:f8 brd ff:ff:ff:ff:ff:ff promiscuity 0
     macvlan mode source remotes (1) 01:00:00:00:00:00 numtxqueues 1 ...

With this change, the 'set' command will (rightly) fail in the same way
as the 'add' command.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index e900ebb94499d..b0c34906cad47 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1259,6 +1259,9 @@ static void macvlan_port_destroy(struct net_device *dev)
 static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 			    struct netlink_ext_ack *extack)
 {
+	struct nlattr *nla, *head;
+	int rem, len;
+
 	if (tb[IFLA_ADDRESS]) {
 		if (nla_len(tb[IFLA_ADDRESS]) != ETH_ALEN)
 			return -EINVAL;
@@ -1306,6 +1309,20 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 			return -EADDRNOTAVAIL;
 	}
 
+	if (data[IFLA_MACVLAN_MACADDR_DATA]) {
+		head = nla_data(data[IFLA_MACVLAN_MACADDR_DATA]);
+		len = nla_len(data[IFLA_MACVLAN_MACADDR_DATA]);
+
+		nla_for_each_attr(nla, head, len, rem) {
+			if (nla_type(nla) != IFLA_MACVLAN_MACADDR ||
+			    nla_len(nla) != ETH_ALEN)
+				return -EINVAL;
+
+			if (!is_valid_ether_addr(nla_data(nla)))
+				return -EADDRNOTAVAIL;
+		}
+	}
+
 	if (data[IFLA_MACVLAN_MACADDR_COUNT])
 		return -EINVAL;
 
@@ -1362,10 +1379,6 @@ static int macvlan_changelink_sources(struct macvlan_dev *vlan, u32 mode,
 		len = nla_len(data[IFLA_MACVLAN_MACADDR_DATA]);
 
 		nla_for_each_attr(nla, head, len, rem) {
-			if (nla_type(nla) != IFLA_MACVLAN_MACADDR ||
-			    nla_len(nla) != ETH_ALEN)
-				continue;
-
 			addr = nla_data(nla);
 			ret = macvlan_hash_add_source(vlan, addr);
 			if (ret)
-- 
2.25.1

