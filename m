Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1738E2AA8A3
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 01:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgKHAqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 19:46:31 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:27764 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgKHAqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 19:46:30 -0500
Date:   Sun, 08 Nov 2020 00:46:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604796387; bh=LOZ/q4BZZQQmIvWoLo/yfk47gGQwkc69xB7RkRHk/ec=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=S/4EhYGcNNYt2yG69lFK6vHdOBSC+NOFAY591UUI35bXN1bd+ObM2YWGtnhVWci1w
         d/SrVoBqm2nyFK7Eglixioax8rehkINydYq/tpBT/0vpvGBjMvM5zlOOh69VV2s+Lh
         NCa5Shm9CbzIks5qNN8CbLNQHw6R76hiZA0ploy7GTRga9Ud2d1C+6eQouwdtOfC9m
         jB1karvaB0DPBnm4/OT0ZW99V15w3Vlv/lUa5suc9BqedsnqRUnvLtoTOUok7iolSe
         Y9yefGqIwcRfizC9Cvz796byD1E0o8YMGplw+jBPr4YdWO4fwc7DR2XPYQCV/j6wG7
         t7wHEHcWTXu2w==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net] ethtool: netlink: add missing netdev_features_change() call
Message-ID: <ahA2YWXYICz5rbUSQqNG4roJ8OlJzzYQX7PTiG80@cp4-web-028.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After updating userspace Ethtool from 5.7 to 5.9, I noticed that
NETDEV_FEAT_CHANGE is no more raised when changing netdev features
through Ethtool.
That's because the old Ethtool ioctl interface always calls
netdev_features_change() at the end of user request processing to
inform the kernel that our netdevice has some features changed, but
the new Netlink interface does not. Instead, it just notifies itself
with ETHTOOL_MSG_FEATURES_NTF.
Replace this ethtool_notify() call with netdev_features_change(), so
the kernel will be aware of any features changes, just like in case
with the ioctl interface. This does not omit Ethtool notifications,
as Ethtool itself listens to NETDEV_FEAT_CHANGE and drops
ETHTOOL_MSG_FEATURES_NTF on it
(net/ethtool/netlink.c:ethnl_netdev_event()).

From v1 [1]:
- dropped extra new line as advised by Jakub;
- no functional changes.

[1] https://lore.kernel.org/netdev/AlZXQ2o5uuTVHCfNGOiGgJ8vJ3KgO5YIWAnQjH0c=
DE@cp3-web-009.plabs.ch

Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET reques=
t")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ethtool/features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 8ee4cdbd6b82..1c9f4df273bd 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -280,7 +280,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl=
_info *info)
 =09=09=09=09=09  active_diff_mask, compact);
 =09}
 =09if (mod)
-=09=09ethtool_notify(dev, ETHTOOL_MSG_FEATURES_NTF, NULL);
+=09=09netdev_features_change(dev);
=20
 out_rtnl:
 =09rtnl_unlock();
--=20
2.29.2


