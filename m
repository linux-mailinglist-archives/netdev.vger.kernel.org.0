Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9954684987
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfHGKbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:31:47 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:60965 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729071AbfHGKbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 06:31:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7375514B3;
        Wed,  7 Aug 2019 06:31:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 07 Aug 2019 06:31:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=El/5ibEBtUiLwoqMCofoR2WpOLUD4g6iXLUj0CzXzDs=; b=fSHdhchS
        nzQiywA5Ismg9udl2KLcSV6J3HUXh7gZTvwORif7rBehTrlNYaEv94sANJPgnr8+
        yrrSX0EBY8X0ZAhUrAXGeTp2ROLYvfqyWnxNKDPtxWhtKSg5ONU/GLuc3HpEXFsw
        48LBGATYBmTuPZZO9KxQm53GRDD1ifwWQmOdMk3+daYBQVJIEhzhaVlGZJz59pm/
        JSsAXifY8YE1Tve8EPsnLvdKxYG6SQPpm2FuHWMIB75JXGp6XhtHohgEstUpCLFN
        y9Y6SjtEPoEQIx/kiIRRbBg7o2aX98e5O9l4x+Fp/ZnxRQQaTuvQJj65unJ6Rsfc
        4n1XRJah0fo6fg==
X-ME-Sender: <xms:kqhKXUymsbZbLtCEPzUrBwmydFWxSku_zuezULYpB19WtN79hmSoDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:kqhKXcgLQTxklKaIghyNSAI8M3NACo4cMN-B3GF8VOdek1-NFtGZ6A>
    <xmx:kqhKXRWhUiYhHNE5clgW5QxH8jVilq3xl_4vtzbvl8zqn7sbqyNcWA>
    <xmx:kqhKXW19QlL-ctXXb0S-r2EhVI44_YISsWGm5U_kVT858IH1S7VExQ>
    <xmx:kqhKXaIz4I4Ws1VXWYFdktQtn589sYYpg26g9vHROk-wbMiaw5pgwQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C004F380091;
        Wed,  7 Aug 2019 06:31:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/10] drop_monitor: Require CAP_NET_ADMIN for drop monitor configuration
Date:   Wed,  7 Aug 2019 13:30:53 +0300
Message-Id: <20190807103059.15270-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190807103059.15270-1-idosch@idosch.org>
References: <20190807103059.15270-1-idosch@idosch.org>
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
index 1cf4988de591..cd2f3069f34e 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -409,6 +409,7 @@ static const struct genl_ops dropmon_ops[] = {
 		.cmd = NET_DM_CMD_CONFIG,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = net_dm_cmd_config,
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NET_DM_CMD_START,
-- 
2.21.0

