Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC92708B2
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbfGVSdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:44 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:53829 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729509AbfGVSdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4FD7A2550;
        Mon, 22 Jul 2019 14:33:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=qwgR+scDnJATWSXcYgU2OooPt/pSoXGSnqNiu8kTyaY=; b=L5ExkIcr
        VGKKw3rkVffs9QkzsubidAXUtvbyR2XF6PySSW2Cof65F8GerMJpG+2fPNl3vBkO
        Lw6AXhixpyYgtSaUIQ1FGjLEfK494GfH0EgubUrM6Xj1uhyQpzAzw5GOKyLfvMqk
        0il3yJQ+GrBkKljC4ii/176JBh8vFGbRRsKJSdXqa8JHs7wh978quXyWV0eaFu4c
        6RWrwaZsKFyVg0quDYPkYLZS2w3uliimk9Vv8/yv2BTc9pLamXm97Mo69fb5afHt
        /Ml47BicMeMM/tEr3OykIfCHsleRl8BAea8XNhyWLFi5N2LQmtNjB39czwgg0dX5
        TEmFZC1XagCNdg==
X-ME-Sender: <xms:hQE2XTlrceGgiSfa7x045jq6ggPGM8q2KkVpuKsjpjNqAmlv6xfuqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeek
X-ME-Proxy: <xmx:hQE2XWEV4k5LrEi__Hhi5GoXlCccaCzaMpO2b2gJxhTTlR4J93-w7A>
    <xmx:hQE2Xcc0Q6MXybqJV06Nsb9fdYpCQ8HxKSwzcbLz9svD0S76Yr_nuA>
    <xmx:hQE2XTEaTpvS2TLW_FWPntkzDvsskaJh15n5ztM_Pbh9niHTl9Tgzw>
    <xmx:hQE2XQTYcMIuh2Ke0LXIp-zsq8NMi3hCktqPIa3WfWbHAG6kxEgBaQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2D4C80059;
        Mon, 22 Jul 2019 14:33:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 09/12] drop_monitor: Require CAP_NET_ADMIN for drop monitor configuration
Date:   Mon, 22 Jul 2019 21:31:31 +0300
Message-Id: <20190722183134.14516-10-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190722183134.14516-1-idosch@idosch.org>
References: <20190722183134.14516-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, the configure command does not do anything but return an
error. Subsequent patches will enable the command to change various
configuration options such as alert mode and packet truncation.

Similar to other netlink-based configuration channels, make sure only
users with the CAP_NET_ADMIN capability set can execute this command.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 2f56a61c43c6..f441fb653567 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -416,6 +416,7 @@ static const struct genl_ops dropmon_ops[] = {
 		.cmd = NET_DM_CMD_CONFIG,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = net_dm_cmd_config,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NET_DM_CMD_START,
-- 
2.21.0

