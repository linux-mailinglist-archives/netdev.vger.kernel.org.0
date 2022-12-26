Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E374D656241
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 12:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiLZLsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 06:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiLZLsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 06:48:43 -0500
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE94E61;
        Mon, 26 Dec 2022 03:48:39 -0800 (PST)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id 22BFD5FCE1;
        Mon, 26 Dec 2022 14:48:37 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:1::1:f])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id SmMqpV0Q0uQ1-KPMWOc5D;
        Mon, 26 Dec 2022 14:48:36 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1672055316; bh=2cSwUgQKvrM1OCeQvc5FcSZd3aC0IduE7mqVyoJSC3s=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=kP2Payl5WYd12M9eEYS264cCskOuIq92rciciJSEKkK46l+F7MwEo7ZE8H/m80gzu
         hxS9QdUDWRntMsd5gRpod45FUKigKKvC669oO7mKoHNeoIMpZiA/+JQBeXx+BvGMfc
         ltgZ8wJcStL8MB+LSrOmCbOZhXm8JQiBY2u2MtvU=
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
Subject: [PATCH net v2 0/3] net/ethtool/ioctl: split ethtool_get_phy_stats into multiple helpers
Date:   Mon, 26 Dec 2022 14:48:22 +0300
Message-Id: <20221226114825.1937189-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
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

This series fixes a potential NULL dereference in ethtool_get_phy_stats
while also attempting to refactor/split said function into multiple
helpers so that it's easier to reason about what's going on.

I've taken Andrew Lunn's suggestions on the previous version of this
patch and added a bit of my own.

Changes since v1:
- Remove an extra newline in the first patch
- Move WARN_ON_ONCE into the if check as it already returns the
  result of the comparison 
- Actually split ethtool_get_phy_stats instead of attempting to
  refactor it

Daniil Tatianin (3):
  net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats
  net/ethtool/ioctl: remove if n_stats checks from ethtool_get_phy_stats
  net/ethtool/ioctl: split ethtool_get_phy_stats into multiple helpers

 net/ethtool/ioctl.c | 107 +++++++++++++++++++++++++++++---------------
 1 file changed, 70 insertions(+), 37 deletions(-)

-- 
2.25.1

