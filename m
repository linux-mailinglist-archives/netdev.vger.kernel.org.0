Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2802A6649
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgKDOXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgKDOXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:23:15 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC16FC0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:23:14 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k18so2477631wmj.5
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sAFLjN4ixxy17kgbFWahJMbPyXmphyBag2SqscTf81U=;
        b=QtgT+zS0egP5DPQ1l06MHd/ZoaweA4XkqKLQqOOODh89FNmYsrIHcKFLRCmzXZmo/x
         w8keMj7G8YEk8ozSzHRY5ZrDz9iFAZRAbhq59u/2olT7o9cI17KTWT37hpZqns9q4X8Z
         eyd2KlVHieVzZgNP9lec3P3A5BHXwVoJW+c1YX2Ci5dzfxEpBRl5+HdaZtna3a1Eh/LU
         ENjQU0oXHIwZYqdYLcyaD6Uyw4S8E4QZgjWL4PHKo6ZBg0Ql3KCnA5IGJ86/ELFRMPXT
         mnCz6vwUq/zD2sVs8DmUDnZM2lL05HRU2RpO003y7vQCU+PTqL20DkYSeYNw0yXkzzzj
         E73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sAFLjN4ixxy17kgbFWahJMbPyXmphyBag2SqscTf81U=;
        b=IArJ7Gth68fnCyWii8K0RGFBNyA3khGDH9mNigfBdy6QDJGThd01NTJ+6Q6ixCx26H
         XIuaY178p/zhk6R+KAOI9kTSJCceskpHnc+AWFfgF56CV+FnRiea6H4U/qm9qgxdj3KY
         ZTomaYX8F1GVkN88djqqVzFmuE2vOINjFebXzTTo6nKL5B24ip4KHlOgQv9ZaNocs0YQ
         ihsgjGF6n9mlM16+gE7Eur/P5T9XKDTFVeKanYP4gz45XDGsob/FNS0u4GpnUfuAqboL
         L9l+qa6y3V9R20ZteXd5JUdrbeRS5gc7+HINL9QoM/fAuynvaPwIuox1BHTRNXpw8ksd
         PqzA==
X-Gm-Message-State: AOAM5334g+NCbwBe03c8JkfQMDqkHGqdodvHZL6EDH/xYZGG7isnSnmx
        hrPLpXZAH2G4ezBC9EZO5PY=
X-Google-Smtp-Source: ABdhPJyIXiEIUfwfazgmJaWSHB/oz7V51EN1FrvzBr4dTC9NTfkCsHD2QEpvmenUDs3pPo9PQGaEow==
X-Received: by 2002:a1c:3502:: with SMTP id c2mr5022741wma.79.1604499793388;
        Wed, 04 Nov 2020 06:23:13 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:d177:63da:d01d:cf70? (p200300ea8f232800d17763dad01dcf70.dip0.t-ipconnect.de. [2003:ea:8f23:2800:d177:63da:d01d:cf70])
        by smtp.googlemail.com with ESMTPSA id m126sm2356252wmm.0.2020.11.04.06.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:23:12 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 00/10] net: add and use dev_get_tstats64
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, wireguard@lists.zx2c4.com,
        Steffen Klassert <steffen.klassert@secunet.com>
Message-ID: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
Date:   Wed, 4 Nov 2020 15:23:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a frequent pattern to use netdev->stats for the less frequently
accessed counters and per-cpu counters for the frequently accessed
counters (rx/tx bytes/packets). Add a default ndo_get_stats64()
implementation for this use case. Subsequently switch more drivers
to use this pattern.

v2:
- add patches for replacing ip_tunnel_get_stats64
  Requested additional migrations will come in a separate series.

Heiner Kallweit (10):
  net: core: add dev_get_tstats64 as a ndo_get_stats64 implementation
  net: dsa: use net core stats64 handling
  tun: switch to net core provided statistics counters
  ip6_tunnel: switch to dev_get_tstats64
  net: switch to dev_get_tstats64
  gtp: switch to dev_get_tstats64
  wireguard: switch to dev_get_tstats64
  vti: switch to dev_get_tstats64
  ipv4/ipv6: switch to dev_get_tstats64
  net: remove ip_tunnel_get_stats64

 drivers/net/bareudp.c          |   2 +-
 drivers/net/geneve.c           |   2 +-
 drivers/net/gtp.c              |   2 +-
 drivers/net/tun.c              | 127 ++++++++-------------------------
 drivers/net/vxlan.c            |   4 +-
 drivers/net/wireguard/device.c |   2 +-
 include/linux/netdevice.h      |   1 +
 include/net/ip_tunnels.h       |   2 -
 net/core/dev.c                 |  15 ++++
 net/dsa/dsa.c                  |   7 +-
 net/dsa/dsa_priv.h             |   2 -
 net/dsa/slave.c                |  29 ++------
 net/ipv4/ip_gre.c              |   6 +-
 net/ipv4/ip_tunnel_core.c      |   9 ---
 net/ipv4/ip_vti.c              |   2 +-
 net/ipv4/ipip.c                |   2 +-
 net/ipv6/ip6_gre.c             |   6 +-
 net/ipv6/ip6_tunnel.c          |  32 +--------
 net/ipv6/ip6_vti.c             |   2 +-
 net/ipv6/sit.c                 |   2 +-
 20 files changed, 72 insertions(+), 184 deletions(-)

-- 
2.29.2

