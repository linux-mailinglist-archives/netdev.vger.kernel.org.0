Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F351F27FB15
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgJAIIJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:08:09 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:39884 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725921AbgJAIII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:08:08 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-qL86IzwWOeWS1scDCNaT0g-1; Thu, 01 Oct 2020 04:00:34 -0400
X-MC-Unique: qL86IzwWOeWS1scDCNaT0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38413801AB3;
        Thu,  1 Oct 2020 08:00:33 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F0CF5C1CF;
        Thu,  1 Oct 2020 08:00:32 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 01/12] ipvlan: add get_link_net
Date:   Thu,  1 Oct 2020 09:59:25 +0200
Message-Id: <b920e279472824d78949401e3bc837713d1f54ea.1600770261.git.sd@queasysnail.net>
In-Reply-To: <cover.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ipvlan devices don't advertise a link-netnsid. We can get
it from the lower device, like macvlan does.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/ipvlan/ipvlan_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 5bca94c99006..a81bb68a5713 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -678,6 +678,14 @@ void ipvlan_link_setup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(ipvlan_link_setup);
 
+static struct net *ipvlan_get_link_net(const struct net_device *dev)
+{
+	struct ipvl_dev *ipvlan = netdev_priv(dev);
+	struct net_device *phy_dev = ipvlan->phy_dev;
+
+	return dev_net(phy_dev);
+}
+
 static const struct nla_policy ipvlan_nl_policy[IFLA_IPVLAN_MAX + 1] =
 {
 	[IFLA_IPVLAN_MODE] = { .type = NLA_U16 },
@@ -691,6 +699,7 @@ static struct rtnl_link_ops ipvlan_link_ops = {
 	.setup		= ipvlan_link_setup,
 	.newlink	= ipvlan_link_new,
 	.dellink	= ipvlan_link_delete,
+	.get_link_net	= ipvlan_get_link_net,
 };
 
 int ipvlan_link_register(struct rtnl_link_ops *ops)
-- 
2.28.0

