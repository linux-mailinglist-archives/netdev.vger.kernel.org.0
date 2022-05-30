Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28169538186
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbiE3OUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241891AbiE3OSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:18:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7551B9CCA4;
        Mon, 30 May 2022 06:48:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AED860FD7;
        Mon, 30 May 2022 13:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E33C36AEB;
        Mon, 30 May 2022 13:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918494;
        bh=srE8cZV7uZ5jo1lc4JV2ZCVGuEAjbdgMCcMiaUhLJPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1En3f7tL3gB6XNxEaVoVwO2Q6VWwZLA5R7UIiTcKnOp8YwYqwTmnD6POfCSVmg8d
         K43yZIbfAcjDI5z5pI/DjCwrBkW2UIN1xIB6wEn7jvxmrtMdb5Vubkl7HPxxrhuzIA
         Ma2J6/1RX2nNJoa7qY29VFIIgN8uCa7qQP/U7lfRnvtl29XKehVd4QuAA0QTK0bZIT
         k0TmJJVEHIE5fZh4E5Dn0m9Q4UWu2S1BrS4Lmm7Is73IZVGfrrPi3NDnNYATIstOmL
         OA2OWo5iUHYjDe7Ej+7PODNC00FD/QSz+fKv7+oo9mjDdSmBVP9Dij5weIV+z47GFe
         Dhcyp5mpzjGLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     jianghaoran <jianghaoran@kylinos.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/55] ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL
Date:   Mon, 30 May 2022 09:46:33 -0400
Message-Id: <20220530134701.1935933-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jianghaoran <jianghaoran@kylinos.cn>

[ Upstream commit b52e1cce31ca721e937d517411179f9196ee6135 ]

ARPHRD_TUNNEL interface can't process rs packets
and will generate TX errors

ex:
ip tunnel add ethn mode ipip local 192.168.1.1 remote 192.168.1.2
ifconfig ethn x.x.x.x

ethn: flags=209<UP,POINTOPOINT,RUNNING,NOARP>  mtu 1480
	inet x.x.x.x  netmask 255.255.255.255  destination x.x.x.x
	inet6 fe80::5efe:ac1e:3cdb  prefixlen 64  scopeid 0x20<link>
	tunnel   txqueuelen 1000  (IPIP Tunnel)
	RX packets 0  bytes 0 (0.0 B)
	RX errors 0  dropped 0  overruns 0  frame 0
	TX packets 0  bytes 0 (0.0 B)
	TX errors 3  dropped 0 overruns 0  carrier 0  collisions 0

Signed-off-by: jianghaoran <jianghaoran@kylinos.cn>
Link: https://lore.kernel.org/r/20220429053802.246681-1-jianghaoran@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index efea88fb3cd5..e29553e4f4ee 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4202,7 +4202,8 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 	send_rs = send_mld &&
 		  ipv6_accept_ra(ifp->idev) &&
 		  ifp->idev->cnf.rtr_solicits != 0 &&
-		  (dev->flags&IFF_LOOPBACK) == 0;
+		  (dev->flags & IFF_LOOPBACK) == 0 &&
+		  (dev->type != ARPHRD_TUNNEL);
 	read_unlock_bh(&ifp->idev->lock);
 
 	/* While dad is in progress mld report's source address is in6_addrany.
-- 
2.35.1

