Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446F82AA7F1
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgKGUsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGUsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:48:20 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E94C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:48:20 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c17so4805673wrc.11
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=B8uI3ib+ND1jWJ9Vi+AOa576ZDPXSgB4pgJH3bG+/sA=;
        b=dFGiGENB8xjIgJjYbC6FXqkzDs/gQ4N8cNUMLJdCGqTIJ83/Os/XwDLFblGezOnkHH
         ND+nGjkGHhzw/ry0Y0gADRSczNt++LkTmgJdIJP9WYimw9mPJ47STOFygWAwitDwLBZt
         uUaipIz314tT0+cgsmSlOz7AzRd1tf5uM0fgVG1qXbLW2gNEOMChThJOmgFHAzlawxOE
         CEjH106Kg3p8KLepzkprIy18AfE//xB/S9TYodexOlTFObFhZxfkUheipXSbi9+Wr7NR
         Ddkb00j0xmAfUOb+NZv6pko4K2agJ7FhfPY7dF121lt5aXI3WPvb4uAK7c41eZENJFX9
         HN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=B8uI3ib+ND1jWJ9Vi+AOa576ZDPXSgB4pgJH3bG+/sA=;
        b=EiQokKPcCquZ5+v786PBpmixtrtFQpRsdgYDBzm0ctntnXS0Eef7RX/NNts17nf5pl
         Ad3tRNJQ0vgbJN961D+bA9CAUaLCSVF9aFvrjxmTr2fclV4eY4OqNs/PjTlfIr0os4qw
         c0JcQjoJlFSGnbyUyLmpww8+frMobwyeb4u3OeLXwhypddD9Unh8T8OKC9QiwXqQfgyi
         inyx/LTpBON1ESNu5gYMpZEikkKY7mz7d9Oudp154E3XnV2mhPkhSX7PWMKiIMepOwwd
         qyeCix32I4gLvSdhG5192H28VLr4eivRcXAgfTcJWoJP6VQCW4iHebHqw94VmjaVbxoH
         +WBQ==
X-Gm-Message-State: AOAM532W7AFBtsVRLFtGPcR7LCabyVkeVAJXJi8K4w3VduQOJiaSJiX2
        mp+c7gsENonw05Xz4ARgW4gLoasHtsLSwQ==
X-Google-Smtp-Source: ABdhPJxQRIASrUDnVmJ4/YlnJY9R1ijNwNhlwQ9sKCsI/bMFlpH9zvDMMWsE3RFv0AWYqQC7sqv8Og==
X-Received: by 2002:a5d:6689:: with SMTP id l9mr3723656wru.134.1604782098173;
        Sat, 07 Nov 2020 12:48:18 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id n15sm2157030wrq.48.2020.11.07.12.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:48:17 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v3 00/10] net: add and use dev_get_tstats64
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
Message-ID: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Date:   Sat, 7 Nov 2020 21:48:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

v3:
- add atomic_long_t member rx_frame_errors in patch 3 for making
  counter updates atomic

Heiner Kallweit (10):
  net: core: add dev_get_tstats64 as a ndo_get_stats64 implementation
  net: dsa: use net core stats64 handling
  tun: switch to net core provided statistics counters
  ip6_tunnel: use ip_tunnel_get_stats64 as ndo_get_stats64 callback
  net: switch to dev_get_tstats64
  gtp: switch to dev_get_tstats64
  wireguard: switch to dev_get_tstats64
  vti: switch to dev_get_tstats64
  ipv4/ipv6: switch to dev_get_tstats64
  net: remove ip_tunnel_get_stats64

 drivers/net/bareudp.c          |   2 +-
 drivers/net/geneve.c           |   2 +-
 drivers/net/gtp.c              |   2 +-
 drivers/net/tun.c              | 121 +++++++++------------------------
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
 20 files changed, 75 insertions(+), 175 deletions(-)

-- 
2.29.2

