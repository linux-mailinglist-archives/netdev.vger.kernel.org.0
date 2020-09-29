Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D26C27B923
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgI2A5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgI2A5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 20:57:20 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA2C207C4;
        Tue, 29 Sep 2020 00:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601341040;
        bh=U/iePW0NAwDYXNrYdGoLVqVliWfgDja1rnHmeuDRvJM=;
        h=From:To:Cc:Subject:Date:From;
        b=h9xawMvZTMsCOuq2XJgB4ke2RXH5jG4CV9y3ie0T3X/T8bwzoGkutAx7l8e7wiVTT
         rRhhh/QS5JQ0cuudKTkbHm/vCqWq7UFMHabLNSVyfWY7X2CjcpvUqsNZ5WS7fOjyFL
         CY4Mh/ayiuUYxb9HQhHT5EuuuBkNtYiEBO4WG43c=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ethtool: mark netlink policy as __ro_after_init
Date:   Mon, 28 Sep 2020 17:57:18 -0700
Message-Id: <20200929005718.3640588-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like all genl families ethtool_genl_family needs to not
be a straight up constant, because it's modified/initialized
by genl_register_family(). After init, however, it's only
passed to genlmsg_put() & co. therefore we can mark it
as __ro_after_init.

Since genl_family structure contains function pointers
mark this as a fix.

Fixes: 2b4a8990b7df ("ethtool: introduce ethtool netlink interface")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5c2072765be7..0c3f54baec4e 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -866,7 +866,7 @@ static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
 	[ETHNL_MCGRP_MONITOR] = { .name = ETHTOOL_MCGRP_MONITOR_NAME },
 };
 
-static struct genl_family ethtool_genl_family = {
+static struct genl_family ethtool_genl_family __ro_after_init = {
 	.name		= ETHTOOL_GENL_NAME,
 	.version	= ETHTOOL_GENL_VERSION,
 	.netnsok	= true,
-- 
2.26.2

