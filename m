Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A293DEDB2
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 02:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfD3A3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 20:29:11 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:43783 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729214AbfD3A3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 20:29:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 74E0313C4E;
        Mon, 29 Apr 2019 20:29:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Apr 2019 20:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=6RglNrH0/a9U7I4Q6WAgYckH6cMAteemMXizx6xHHpY=; b=SHroRKDH
        LZLn1RVZCpLrXRnKxIRmBLcHDJXmIAoogkdfoofa6F5x6sK+datdqXscsi3xlKLZ
        nU5xNa4XTXwlBFz6eJUEsRRtEouBNjILDcXcX6i3u0mvJkYGx2MvoANPR+8yhz1f
        S4zuqEFMBgJGM31MeIYXL42UvyrAMyhacsdpJFUOImbPkGkKAb9oRRkZsWN3UqaB
        aCPr8nwIjPxbyBRnqu/oRIJnAZnMOdHt3QjYLgyHc9HrBjZGYw3AWBJ4xJUqlcHV
        0zHyKR2KIdgoP35g3TWZchBqTTvsiOTHkep0n4ST02Mut8n9TWfTslHFzgLiBTLz
        K5rl03w2KEWX9w==
X-ME-Sender: <xms:1ZbHXEXA9DbOUj5ziVVZ7Vyw3BKXADyXaAjEnkDZqZ74ubdQ-mj18w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieefgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvfedtrddukeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:1ZbHXGuFgQQRK_gaVo2bO3XWUkMCGvn6bDyxF7l-Kux8E-p1Rba9sQ>
    <xmx:1ZbHXC9In8lQU7KIa6BV8M4LwiitjvcUHG9D5Ch4BHg1AzRAJcXmJg>
    <xmx:1ZbHXH0MpMr28vhxZM-lvRDaMQiFIPbtYOOXB7G8DjXLaQCuMGP76Q>
    <xmx:1ZbHXB__gjz1IJA56bzVXECpftQLtrVMhyp-5i3ILde-hs3IPNHUng>
Received: from eros.localdomain (ppp121-44-230-188.bras2.syd2.internode.on.net [121.44.230.188])
        by mail.messagingengine.com (Postfix) with ESMTPA id A6DE5103CC;
        Mon, 29 Apr 2019 20:29:04 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] bridge: Fix error path for kobject_init_and_add()
Date:   Tue, 30 Apr 2019 10:28:15 +1000
Message-Id: <20190430002817.10785-2-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430002817.10785-1-tobin@kernel.org>
References: <20190430002817.10785-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently error return from kobject_init_and_add() is not followed by a
call to kobject_put().  This means there is a memory leak.

Add call to kobject_put() in error path of kobject_init_and_add().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 net/bridge/br_if.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 41f0a696a65f..e5c8c9941c51 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -607,8 +607,10 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 
 	err = kobject_init_and_add(&p->kobj, &brport_ktype, &(dev->dev.kobj),
 				   SYSFS_BRIDGE_PORT_ATTR);
-	if (err)
+	if (err) {
+		kobject_put(&p->kobj);
 		goto err1;
+	}
 
 	err = br_sysfs_addif(p);
 	if (err)
-- 
2.21.0

