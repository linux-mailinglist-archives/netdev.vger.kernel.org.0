Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A043C21B6
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhGIJno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:43:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhGIJnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 05:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625823660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5527mjflLnN2mLn4IpQbwVLl4rkvXLkqkbz3xhAqkT8=;
        b=ibE2V5Twxo7vgpcnjwiR3CfGZsRHMOi5q9W4KtsgWg08ZKcDlyzskp2G36uP4yjf1XG5Cf
        MjBu232zDZGuvXGUOQXjUbtAkMjhFyjBk8aAcCUA5weObj2P52+Y+mLcsWihw9uWw1aZew
        R5rX8d+9ACqFGCBL4Q37DJAqrnjoCgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-YhigzxPFNB2xtkYXcJmwDQ-1; Fri, 09 Jul 2021 05:40:58 -0400
X-MC-Unique: YhigzxPFNB2xtkYXcJmwDQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F19E4100C661;
        Fri,  9 Jul 2021 09:40:57 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-68.ams2.redhat.com [10.36.113.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F0D2369A;
        Fri,  9 Jul 2021 09:40:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, toke@redhat.com
Subject: [RFC PATCH 2/3] veth: make queues nr configurable via kernel module params
Date:   Fri,  9 Jul 2021 11:39:49 +0200
Message-Id: <480e7a960c26c9ab84efe59ed706f1a1a459d38c.1625823139.git.pabeni@redhat.com>
In-Reply-To: <cover.1625823139.git.pabeni@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows configuring the number of tx and rx queues at
module load time. A single module parameter controls
both the default number of RX and TX queues created
at device registration time.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 10360228a06a..787b4ad2cc87 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -27,6 +27,11 @@
 #include <linux/bpf_trace.h>
 #include <linux/net_tstamp.h>
 
+static int queues_nr	= 1;
+
+module_param(queues_nr, int, 0644);
+MODULE_PARM_DESC(queues_nr, "Max number of RX and TX queues (default = 1)");
+
 #define DRV_NAME	"veth"
 #define DRV_VERSION	"1.0"
 
@@ -1662,6 +1667,18 @@ static struct net *veth_get_link_net(const struct net_device *dev)
 	return peer ? dev_net(peer) : dev_net(dev);
 }
 
+unsigned int veth_get_num_tx_queues(void)
+{
+	/* enforce the same queue limit as rtnl_create_link */
+	int queues = queues_nr;
+
+	if (queues < 1)
+		queues = 1;
+	if (queues > 4096)
+		queues = 4096;
+	return queues;
+}
+
 static struct rtnl_link_ops veth_link_ops = {
 	.kind		= DRV_NAME,
 	.priv_size	= sizeof(struct veth_priv),
@@ -1672,6 +1689,10 @@ static struct rtnl_link_ops veth_link_ops = {
 	.policy		= veth_policy,
 	.maxtype	= VETH_INFO_MAX,
 	.get_link_net	= veth_get_link_net,
+	.get_num_tx_queues	= veth_get_num_tx_queues,
+	.get_num_rx_queues	= veth_get_num_tx_queues, /* Use the same number
+							   * as for TX queues
+							   */
 };
 
 /*
-- 
2.26.3

