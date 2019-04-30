Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACF7EDB7
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 02:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfD3A3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 20:29:22 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:48353 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729214AbfD3A3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 20:29:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 78DE64113;
        Mon, 29 Apr 2019 20:29:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Apr 2019 20:29:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=s7mszwv9bEcj1/j0Ken9h1TuXoSRYZGHb7Hqwq/CGpw=; b=5MjxaFQb
        NJL49V0S3XUIlTTGODJFyfPtUwxqhsR9yOK94mwekQt9cLdlAvXTNuLbmfbikWdA
        iLtGUYeB/iME4dJIPPPmHzaJUwCabV7CJhJg7OHanNhk/uCBAP2gOfaEKxmJDMhx
        QOaARTRbKYPTDj05YxKDsulPbLc4715IvHdLVejfozCQl3+y7Ta6AXM7ci7N3jPj
        +XJXnHO3mKT1V3PPPsHhPLmNBQ4WXZ6p70vPyYUVjAUAuqgGqrUpT78xLonVXr1f
        qdnsnC6qNpEbbjMXGLrbNju1i5sej4kOHN9eyJWSrIU+I9w4tupR+foi6/TY/28F
        T8rNTvswE9jujA==
X-ME-Sender: <xms:35bHXDBwD4DQ6Gemg-WDoyvxPmqokBbv-5oakFlebFNPcPwqY7MMdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieefgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvfedtrddukeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:35bHXHxXCSdwpUygfQWZaQ3gSHhmLBp-5R7hbU59UTUxf1tXbabCpg>
    <xmx:35bHXIsr0Dii1Y-4WYrzK0fyFl_0l7vIadBfAj6cIgDC6e1hmfHG1A>
    <xmx:35bHXCLHx7UnYf1W13aWlo69XvfKy8187lm5wQnOYhKs7fMwlUnDQQ>
    <xmx:35bHXHxr1lB28mcPr6lR9724dj1RWvT2z4QoaZOkrgFKNG3TwFdGPg>
Received: from eros.localdomain (ppp121-44-230-188.bras2.syd2.internode.on.net [121.44.230.188])
        by mail.messagingengine.com (Postfix) with ESMTPA id A521D103CA;
        Mon, 29 Apr 2019 20:29:14 -0400 (EDT)
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
Subject: [PATCH 3/3] net-sysfs: Fix error path for kobject_init_and_add()
Date:   Tue, 30 Apr 2019 10:28:17 +1000
Message-Id: <20190430002817.10785-4-tobin@kernel.org>
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
 net/core/net-sysfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 8f8b7b6c2945..9d4e3f47b789 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -925,8 +925,10 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
 				     "rx-%u", index);
-	if (error)
+	if (error) {
+		kobject_put(kobj);
 		return error;
+	}
 
 	dev_hold(queue->dev);
 
@@ -1462,8 +1464,10 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 				     "tx-%u", index);
-	if (error)
+	if (error) {
+		kobject_put(kobj);
 		return error;
+	}
 
 	dev_hold(queue->dev);
 
-- 
2.21.0

