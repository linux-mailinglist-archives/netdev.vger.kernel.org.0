Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796B765623F
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 12:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiLZLso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 06:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLZLsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 06:48:43 -0500
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A3D2FB;
        Mon, 26 Dec 2022 03:48:42 -0800 (PST)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id CEFD85FCE7;
        Mon, 26 Dec 2022 14:48:40 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:1::1:f])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id SmMqpV0Q0uQ1-IbutsOwc;
        Mon, 26 Dec 2022 14:48:40 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1672055320; bh=Wl46n9GzEekweDAs/Z8zerV+l+QIWCUnBlczJiEGt0c=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=q0UggCoPnCZNu0GuMmnwmxZbLUamlM5m0fItS/NudL461zYOxkjVZNcZKAWq2o0qs
         Xle0rtoLgw3/FbSBJfmjoWfGUOfmnanmGbllRKf5m5E98WOn7E47L7RCIZLanO5lon
         MU8y+Yp6UgZbTIDelR6lxq2J/kHiUFhW1xydSGQs=
Authentication-Results: vla1-81430ab5870b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/3] net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats
Date:   Mon, 26 Dec 2022 14:48:23 +0300
Message-Id: <20221226114825.1937189-2-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221226114825.1937189-1-d-tatianin@yandex-team.ru>
References: <20221226114825.1937189-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not very useful to copy back an empty ethtool_stats struct and
return 0 if we didn't actually have any stats. This also allows for
further simplification of this function in the future commits.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 57e7238a4136..e8a294b38b7b 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2093,7 +2093,8 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 		return n_stats;
 	if (n_stats > S32_MAX / sizeof(u64))
 		return -ENOMEM;
-	WARN_ON_ONCE(!n_stats);
+	if (WARN_ON_ONCE(!n_stats))
+		return -EOPNOTSUPP;
 
 	if (copy_from_user(&stats, useraddr, sizeof(stats)))
 		return -EFAULT;
-- 
2.25.1

