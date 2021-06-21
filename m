Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551A23AF42C
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhFUSHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233775AbhFUSEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:04:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3600C61351;
        Mon, 21 Jun 2021 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298154;
        bh=I+GWBZ/4lDqFfHc3Y8W5fLceRDT6D7V3Ua+AYQ2cNYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfC1oHjSuCoglmg9Hk9Z+Wb4ZQ9Do5qNbEW7fdEY4vn93LN6hzhqFxztjaF+IIC0s
         iJ1xTdtO/NrEr/QEPEgHHJvbIIter+moPZBZfGifSGeGn8pH2FoVbj1gaI6XptKW8P
         Le8+yhy9Mh28Wtpz/ODH7wVe1yRt4azUltsee9bidxJH1FFn/yYZYrUnPvkYdcxMG9
         SgPpvFpa9S5qU1uTk3YjPvMMviBwOKJJHJ7szl3k02KDL6xkw+ImFpO2qIwu9RIxgn
         HWzTpQfH++ezTVyUB/u/6UlsQs/uMOAy+EMqvV/9EhYuKN4p4UrDTldFk/fo6JJs5W
         Pi8/hp8QK+kGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f303e045423e617d2cad@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/13] net: caif: fix memory leak in ldisc_open
Date:   Mon, 21 Jun 2021 13:55:36 -0400
Message-Id: <20210621175544.736421-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175544.736421-1-sashal@kernel.org>
References: <20210621175544.736421-1-sashal@kernel.org>
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
index 32834dad0b83..1243c2e5a86a 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -362,6 +362,7 @@ static int ldisc_open(struct tty_struct *tty)
 	rtnl_lock();
 	result = register_netdevice(dev);
 	if (result) {
+		tty_kref_put(tty);
 		rtnl_unlock();
 		free_netdev(dev);
 		return -ENODEV;
-- 
2.30.2

