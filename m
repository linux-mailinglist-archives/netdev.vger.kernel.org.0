Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53A08902B
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfHKHgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:36:54 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:45407 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfHKHgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:36:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id AC1CF1981;
        Sun, 11 Aug 2019 03:36:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=El/5ibEBtUiLwoqMCofoR2WpOLUD4g6iXLUj0CzXzDs=; b=flIm34tF
        DlGqo4vyjEN2I0oPTbXk6nd6gkMWEwo2ee116M48n6YvdH6F8uGjFnku7Q//TnG+
        WiBCCIH4yHlMr7G6c3wMs2UjaksguAz85uXEhHE7h6/gVjgT550T4V7aLEMwXnaA
        6QF221JSogta39px0bQd6oJsiLbVbkTPGKc4G8MsOMkJ7O8MVUUjgoYZ0Ly51ETc
        LeAEezV3CUYlB8BcVDF0FQSZl+FkjnO14kxg76s9R3EpfhdRbwUL3oPXIicKbohf
        qvnHPircQmNDrUg6IBA5gNHTX5s7MLVPmLax/IOiQaoQn6cnlQAVYZXo/JhgLryW
        Wsojex0Xx4E5DA==
X-ME-Sender: <xms:lcVPXczgww2S1WlwX3PS2aGutCmYRINJTNtKvn_7AlulMwMFPrnQmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:lcVPXZEMKHsvMFYUm41OqwfJkOMnN8IpkkDI2BrADsheDRbuM02d0w>
    <xmx:lcVPXfpQ1Vx6FX9Ns1NqzjsaIvW4W9nZW42rnejdI4tD-Q5yzWVI1A>
    <xmx:lcVPXfwaOzuZ6-zeSFGVrnmiDcujAtyLyQ54cQD5YqOjY3YtQDKNTg>
    <xmx:lcVPXWtVfzlMyPRpCwWgDinVMtX-W_-kYtyof2gTavFBlJA2S0mWrw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 192318005B;
        Sun, 11 Aug 2019 03:36:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 04/10] drop_monitor: Require CAP_NET_ADMIN for drop monitor configuration
Date:   Sun, 11 Aug 2019 10:35:49 +0300
Message-Id: <20190811073555.27068-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190811073555.27068-1-idosch@idosch.org>
References: <20190811073555.27068-1-idosch@idosch.org>
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

