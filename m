Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF3127FB11
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbgJAIHF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:05 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:38546 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbgJAIHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:04 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2020 04:07:04 EDT
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-c0rJb9JYMwi4j-kEEH-aOA-1; Thu, 01 Oct 2020 04:00:35 -0400
X-MC-Unique: c0rJb9JYMwi4j-kEEH-aOA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A64C10BBEE2;
        Thu,  1 Oct 2020 08:00:34 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 918485C1CF;
        Thu,  1 Oct 2020 08:00:33 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 02/12] geneve: add get_link_net
Date:   Thu,  1 Oct 2020 09:59:26 +0200
Message-Id: <84bc21ebf2a9f5898cd81d68e00b72fd6f43ba6b.1600770261.git.sd@queasysnail.net>
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

Currently, geneve devices don't advertise a link netns. Similarly to
VXLAN, we can get it from geneve_dev->net.

Fixes: 2d07dc79fe04 ("geneve: add initial netdev driver for GENEVE tunnels")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/geneve.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 974a244f45ba..cd47940bfcbe 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1791,6 +1791,13 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	return -EMSGSIZE;
 }
 
+static struct net *geneve_get_link_net(const struct net_device *dev)
+{
+	struct geneve_dev *geneve = netdev_priv(dev);
+
+	return geneve->net;
+}
+
 static struct rtnl_link_ops geneve_link_ops __read_mostly = {
 	.kind		= "geneve",
 	.maxtype	= IFLA_GENEVE_MAX,
@@ -1803,6 +1810,7 @@ static struct rtnl_link_ops geneve_link_ops __read_mostly = {
 	.dellink	= geneve_dellink,
 	.get_size	= geneve_get_size,
 	.fill_info	= geneve_fill_info,
+	.get_link_net	= geneve_get_link_net,
 };
 
 struct net_device *geneve_dev_create_fb(struct net *net, const char *name,
-- 
2.28.0

