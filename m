Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133B53AF295
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhFURza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232152AbhFURyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB73E61206;
        Mon, 21 Jun 2021 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297955;
        bh=BaNvhATeEufCxlq19nIJTaVOVFK2DRAYVIjsRxIn9Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fd+hvYBr+0b3ffb91YDQmZBoigYaI92Jby2vB5s91efGf8bch/wexAehmMLJlVqZC
         tc3t+/JTC0a8Mp0Pmj4pClOpJvaXb3ZVDQDlEWcvz/dAXWweIxfWSr76ajpyrijfob
         us5pvffeODJnaz7ZoZnMiqsQvb5qCl5RN1Wnws9a+Jd8acS9mZtMeudT1A2Z0+IQZe
         frLewLubvql9fiO1htEJe3jBREKcNI0xuTAHVBcZxG9nzYRy+hOnlMZQ/0MHlDGRo7
         lJtogKOq92hGucv6xy0q9FqABTV2rwBq8emSrGoaCP94yqpFN6HhPFoQ1sN+yVa0bt
         ZIA+a7H1AgOUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f303e045423e617d2cad@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 23/39] net: caif: fix memory leak in ldisc_open
Date:   Mon, 21 Jun 2021 13:51:39 -0400
Message-Id: <20210621175156.735062-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 58af3d3d54e87bfc1f936e16c04ade3369d34011 ]

Syzbot reported memory leak in tty_init_dev().
The problem was in unputted tty in ldisc_open()

static int ldisc_open(struct tty_struct *tty)
{
...
	ser->tty = tty_kref_get(tty);
...
	result = register_netdevice(dev);
	if (result) {
		rtnl_unlock();
		free_netdev(dev);
		return -ENODEV;
	}
...
}

Ser pointer is netdev private_data, so after free_netdev()
this pointer goes away with unputted tty reference. So, fix
it by adding tty_kref_put() before freeing netdev.

Reported-and-tested-by: syzbot+f303e045423e617d2cad@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_serial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 9f30748da4ab..8c38f224becb 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -350,6 +350,7 @@ static int ldisc_open(struct tty_struct *tty)
 	rtnl_lock();
 	result = register_netdevice(dev);
 	if (result) {
+		tty_kref_put(tty);
 		rtnl_unlock();
 		free_netdev(dev);
 		return -ENODEV;
-- 
2.30.2

