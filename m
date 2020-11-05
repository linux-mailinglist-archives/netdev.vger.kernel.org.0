Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6F02A8381
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731560AbgKEQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:27:08 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:42163 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgKEQ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 11:27:07 -0500
Date:   Thu, 05 Nov 2020 16:26:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604593625; bh=wWkNAI1Z1OaM+ZJ+K4dO4VThjwMCnYu1qVLQHIn0wWs=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=Jwb1FMO45jI45B5GrPFDa6vMScyppgwnPJuMnMEqeMYkgjZRzsZSb5cpP9R/uOJmJ
         HsYcwAnoToosWY1mxiouNhegBJPsjxAeAsxN5a/T50Zg/H3a5Ozk7xiTLVgVx2n4cg
         fPMfu4lwX5faxcSQ14c287tyxxdERNZ/zG8C/CK898ktA+ePzamVJTVllTO401Hqxc
         SM75mEAEU8DwLFLw2XsNTEi8sTTsVRC72+AAl6vGoQ5kfpW3Vd2pUkelimmryWfZ1+
         ba0cozxn6I9O8/UrAx6LFBl1gIh9czUeHqMg1CAM0iHe/yzsFUOPmqpp5wR6RhZKho
         Ddh62QLj8EsfQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net] ethtool: netlink: add missing netdev_features_change() call
Message-ID: <AlZXQ2o5uuTVHCfNGOiGgJ8vJ3KgO5YIWAnQjH0cDE@cp3-web-009.plabs.ch>
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

Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET reques=
t")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ethtool/features.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 8ee4cdbd6b82..38f526f2125d 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -279,8 +279,9 @@ int ethnl_set_features(struct sk_buff *skb, struct genl=
_info *info)
 =09=09=09=09=09  wanted_diff_mask, new_active,
 =09=09=09=09=09  active_diff_mask, compact);
 =09}
+
 =09if (mod)
-=09=09ethtool_notify(dev, ETHTOOL_MSG_FEATURES_NTF, NULL);
+=09=09netdev_features_change(dev);
=20
 out_rtnl:
 =09rtnl_unlock();
--=20
2.29.2


