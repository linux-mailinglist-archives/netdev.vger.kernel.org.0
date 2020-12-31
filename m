Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3912E7DE2
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 04:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgLaDlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 22:41:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbgLaDlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 22:41:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E99820773;
        Thu, 31 Dec 2020 03:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609386033;
        bh=rgLBSFOZ1V8q8FCtNhvufsd7KyiqZ5p5BhvOa5LjUqY=;
        h=From:To:Cc:Subject:Date:From;
        b=I8D4zLuq8ympERpQxZPccy/0KWALwBQq4GK8IKcD+BmWuuO0V6qKyzE0or0QoJ/YQ
         X6ig7EylpqXTQRD3J1dW2lRmIIa2oi9x30n1pGI9em79Q5u7R3jn1H6j1LYyxtnFkG
         KvLeeoEUEhcIMSd0eQ0kpEVESD9DEviQwrD898B376gGASU0am+vyI4h7zt0ujen+X
         287+5FihAdYHkHWWjFF7edrPUi3vn+/QEe75n9ishYfTpvyqnjVYjjJvHw/tTOcFDe
         HNZgdxxBMidp44gJovq4A4S3YLXHOJyCJa+LAYQn3mttD3rU6OXR12QU8/s0dTtEFm
         yR3R1ZlqWnffQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        jouni.hogander@unikie.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: vlan: avoid leaks on register_vlan_dev() failures
Date:   Wed, 30 Dec 2020 19:40:27 -0800
Message-Id: <20201231034027.1570026-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLAN checks for NETREG_UNINITIALIZED to distinguish between
registration failure and unregistration in progress.

Since commit cb626bf566eb ("net-sysfs: Fix reference count leak")
registration failure may, however, result in NETREG_UNREGISTERED
as well as NETREG_UNINITIALIZED.

This fix is similer to cebb69754f37 ("rtnetlink: Fix
memory(net_device) leak when ->newlink fails")

Fixes: cb626bf566eb ("net-sysfs: Fix reference count leak")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Found by code inspection and compile-tested only.

 net/8021q/vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index f292e0267bb9..15bbfaf943fd 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -284,7 +284,8 @@ static int register_vlan_device(struct net_device *real_dev, u16 vlan_id)
 	return 0;
 
 out_free_newdev:
-	if (new_dev->reg_state == NETREG_UNINITIALIZED)
+	if (new_dev->reg_state == NETREG_UNINITIALIZED ||
+	    new_dev->reg_state == NETREG_UNREGISTERED)
 		free_netdev(new_dev);
 	return err;
 }
-- 
2.26.2

