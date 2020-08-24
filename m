Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B5625001C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 16:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHXOsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 10:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgHXOsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 10:48:17 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D09C061573;
        Mon, 24 Aug 2020 07:48:16 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4BZw3J3FGBzQlFd;
        Mon, 24 Aug 2020 16:48:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aixah.de; s=MBO0001;
        t=1598280490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkhd792qXanXZZ0T3bLwPCM0WFIBZuaDtJyXb3YHYPU=;
        b=CDlOMZpFWNq2ShPX4xQLmG8Y3xNdoG+ioOp9PxMqiXV3o88OidTyi+f/BTUc4/ksx798/x
        PNgUhNiii//SENwwnEfrb2IOhsU3AS/mFeIKdzIuBu7bwDVWj7+Q3/Y332cylmGZwRcTcc
        gX8NS1l/SmttZc/aXun3rl4gxc9pcFjcNZPlQb8n56b6/MNc3pKnfQwhuobU/6IV04LiJi
        KgQWFRAG0rplRzhckUu/ir0BGW8es3c+j2dR+0nfs174fxMknAegnpZDBAzklLNZM65dfF
        LLVleFl/QoaGsNdRVo4VeErnMh+OTI8Osw+0Ox/ATKBPlwOcOzLgEMjRL3uTyA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id CGbXwHlVLfDj; Mon, 24 Aug 2020 16:48:09 +0200 (CEST)
From:   Mira Ressel <aranea@aixah.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Mira Ressel <aranea@aixah.de>
Subject: [PATCH 2/2] vlan: Initialize dev->perm_addr
Date:   Mon, 24 Aug 2020 14:47:47 +0000
Message-Id: <20200824144747.7037-1-aranea@aixah.de>
In-Reply-To: <20200824143828.5964-1-aranea@aixah.de>
References: <20200824143828.5964-1-aranea@aixah.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.43 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4016A1796
X-Rspamd-UID: ae5221
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the perm_addr of vlan devices to that of their parent device.
Otherwise, it remains all zero, with the consequence that
ipv6_generate_stable_address() (which is used if the sysctl
net.ipv6.conf.DEV.addr_gen_mode is set to 2 or 3) assigns every vlan
interface on a host the same link-local address.

This has the added benefit of giving vlan devices the same link-local
address as their parent device, which is common practice, and indeed
precisely what happens automatically if the default eui64-based address
generation is used.

Signed-off-by: Mira Ressel <aranea@aixah.de>
---
 net/8021q/vlan_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 0db85aeb119b..8c60d92b7717 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -182,6 +182,8 @@ static int vlan_newlink(struct net *src_net, struct net_device *dev,
 	else if (dev->mtu > max_mtu)
 		return -EINVAL;
 
+	memcpy(dev->perm_addr, real_dev->perm_addr, real_dev->addr_len);
+
 	err = vlan_changelink(dev, tb, data, extack);
 	if (!err)
 		err = register_vlan_dev(dev, extack);
-- 
2.25.4

