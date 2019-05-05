Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6996714019
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 16:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfEEONC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 10:13:02 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38339 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726965AbfEEONC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 10:13:02 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A0E1820EB0;
        Sun,  5 May 2019 10:13:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 05 May 2019 10:13:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WG0/d3GOaBcpCO2xB
        UGXgu3XyBD/3FCJFZwhkkWD36M=; b=cwgCVYOg01pZOQV9rZE8As0sTXycrcKOR
        4BHT0imOtigeE4mKjWoEW3dplSvvTiQMRta6pJ2yEwR7LfvJRvJcnRY08HHRDgUg
        KgTlndXJgWCsZ/v+7iNOom1MRNCGU2lB/VSG2KfnvAQuB7EGARTUFLklgqh38E7m
        xfs1oFJlKNwneM7ZgW7m4GKLl4PCGbHKPL2LqUYPgZp34ZSGkKqQuuJy+TKbHel0
        2zpw1gYTACEuLRq7kV4Y96v534wHsV5jIg+gMdFFkFz3IwCz6Q6Q2ZtipbFCSyZY
        V4tOG6aqEQYSSoSQ3pRw7s0Mj5H/uCE65I8wNQZulimteKRhs6gDg==
X-ME-Sender: <xms:be_OXON4ZewRH2MjWmI4YnMQw6IAziD2wGsayR7gbCrRIIY5ka9igw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeehgdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:be_OXEQ72v57psFGqCfImVVBvhnt2Q3yux0uSlFu-j4Zw3xZqCFXig>
    <xmx:be_OXJ8QignlZ5MjRv1KU58EX8nm-mGwhzIBzbvNI7FC2vWNP8RdSQ>
    <xmx:be_OXHvc62Ql69s_hc4t4WAJx1rY7hIOhjndA01BCHFcxwzfXg9OAg>
    <xmx:be_OXDATCtwZ2HBfUmXYDxve81LXosqx6o2nVPpbzaBPa7T8l7yjzQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0B98103C8;
        Sun,  5 May 2019 10:12:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-master] devlink: Fix monitor command
Date:   Sun,  5 May 2019 17:12:43 +0300
Message-Id: <20190505141243.9768-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The command is supposed to allow users to filter events related to
certain objects, but returns an error when an object is specified:

# devlink mon dev
Command "dev" not found

Fix this by allowing the command to process the specified objects.

Example:

# devlink/devlink mon dev &
# echo "10 1" > /sys/bus/netdevsim/new_device
[dev,new] netdevsim/netdevsim10

# devlink/devlink mon port &
# echo "11 1" > /sys/bus/netdevsim/new_device
[port,new] netdevsim/netdevsim11/0: type notset flavour physical
[port,new] netdevsim/netdevsim11/0: type eth netdev eth1 flavour physical

# devlink/devlink mon &
# echo "12 1" > /sys/bus/netdevsim/new_device
[dev,new] netdevsim/netdevsim12
[port,new] netdevsim/netdevsim12/0: type notset flavour physical
[port,new] netdevsim/netdevsim12/0: type eth netdev eth2 flavour physical

Fixes: a3c4b484a1ed ("add devlink tool")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 devlink/devlink.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index dc6e73fec20c..6a4ce58b9ee9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3858,12 +3858,8 @@ static int cmd_mon(struct dl *dl)
 	if (dl_argv_match(dl, "help")) {
 		cmd_mon_help();
 		return 0;
-	} else if (dl_no_arg(dl)) {
-		dl_arg_inc(dl);
-		return cmd_mon_show(dl);
 	}
-	pr_err("Command \"%s\" not found\n", dl_argv(dl));
-	return -ENOENT;
+	return cmd_mon_show(dl);
 }
 
 struct dpipe_field {
-- 
2.20.1

