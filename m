Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809FB315BDB
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhBJBFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbhBJBD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 20:03:29 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53F3C061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 17:02:49 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id f26so147914oog.5
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 17:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aLjCR3MesTbJXULP8QiH9ymxmePv+9qhwh64ZKch+gs=;
        b=YV5xcLH4bwd/QFaV747zFaelgs0g0lUin94rwv2RVT2INwy/CBKQ4JuT8h3esOyUlV
         ilHo+CSbjGQsg0bsoS/B9Ga6tw9WKVWTRO4CYkKpsd5M85zCLRIRzQM082hpviBmh+WE
         aYIScXEtou257zBuLA8l2yVZdxKxHmYBoYlGgDJrvNXfLFH4/sWlCvwEk1gPsAS6LP8L
         thhis1FgYsf3CzWf2+uw0PG++Q0tgZwuP/DBm4cegSAYfyfCmwqXa2YCdksRPRw+Qg7r
         BsXmGh8ozBbo8lQKCM6tU/TfLxebfp7/01/1MBi45bk6W1WzwXWYz0oHjYx3xyOyzccG
         V22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aLjCR3MesTbJXULP8QiH9ymxmePv+9qhwh64ZKch+gs=;
        b=lBR06MoAoOX+muZ/K6fIdZIAYsFeCcbt5YlOefPtc0LOwNOK/SXyhFjj/wjI4VAiKD
         Hy6VHcXaINt/ElYLNrDlppb50BmORhRKtoDbmAm7qcnGaD2FqAuMhFfJuHAdY/Tw4gur
         fBgFNjT4jfSQJBXSEZZLhw6kmG+oTnLUuyAUizS89ot+8ba9Evveu8DRJQA+48f/8DsN
         d3e0WHTxcTs/7PwO2yDfy93FdhELZqy5zUU3TWQy50xOTbZtNTzWyz6+Xn+5cxt9kQZd
         0ibecYVVs3GObhGvbmku/2PwTulOi9CjLBeUnu2eI83EXY5WX49iGiTIj+OnuJj+iRhi
         +9XA==
X-Gm-Message-State: AOAM530m8WJYWIX4zCkOQHZYlRq41zWLTxlkU+3kaUiLlAzKEuvtYidv
        8MLnKk0PmAD1Txcjom5pYExAIMUWNr89LNs=
X-Google-Smtp-Source: ABdhPJyFG2md+EFYrCMquprQcOG0doe8n3Xi7/61J0CJeAccUDpUspXe4kTEEZ3cDMKpqPdSUtyyVw==
X-Received: by 2002:a4a:aa8b:: with SMTP id d11mr445467oon.36.1612918969220;
        Tue, 09 Feb 2021 17:02:49 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id i9sm101811oii.34.2021.02.09.17.02.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 17:02:48 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v3 0/4] add HSR offloading support for DSA switches
Date:   Tue,  9 Feb 2021 19:02:09 -0600
Message-Id: <20210210010213.27553-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading HSR/PRP (IEC 62439-3) tag insertion, tag
removal, forwarding and duplication on DSA switches.
This series adds offloading to the xrs700x DSA driver.

Changes since RFC:
 * Split hsr and dsa patches. (Florian Fainelli)

Changes since v1:
 * Fixed some typos/wording. (Vladimir Oltean)
 * eliminate IFF_HSR and use is_hsr_master instead. (Vladimir Oltean)
 * Make hsr_handle_sup_frame handle skb_std as well (required when offloading)
 * Don't add hsr tag for HSR v0 supervisory frames.
 * Fixed tag insertion offloading for PRP.

Changes since v2:
 * Return -EOPNOTSUPP instead of 0 in dsa_switch_hsr_join and
   dsa_switch_hsr_leave. (Vladimir Oltean)
 * Only allow ports 1 and 2 to be HSR/PRP redundant ports. (Tobias Waldekranz)
 * Set and remove HSR features for both redundant ports. (Vladimir Oltean)
 * Change port_hsr_leave() to return int instead of void.
 * Remove hsr_init_skb() proto argument. (Vladimir Oltean)

George McCollister (4):
  net: hsr: generate supervision frame without HSR/PRP tag
  net: hsr: add offloading support
  net: dsa: add support for offloading HSR
  net: dsa: xrs700x: add HSR offloading support

 Documentation/networking/netdev-features.rst |  21 +++++
 drivers/net/dsa/xrs700x/xrs700x.c            | 121 +++++++++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h        |   5 ++
 include/linux/if_hsr.h                       |  27 ++++++
 include/linux/netdev_features.h              |   9 ++
 include/net/dsa.h                            |  13 +++
 net/dsa/dsa_priv.h                           |  11 +++
 net/dsa/port.c                               |  34 ++++++++
 net/dsa/slave.c                              |  14 ++++
 net/dsa/switch.c                             |  24 ++++++
 net/dsa/tag_xrs700x.c                        |   7 +-
 net/ethtool/common.c                         |   4 +
 net/hsr/hsr_device.c                         |  53 +++---------
 net/hsr/hsr_device.h                         |   1 -
 net/hsr/hsr_forward.c                        |  35 +++++++-
 net/hsr/hsr_forward.h                        |   1 +
 net/hsr/hsr_framereg.c                       |   2 +
 net/hsr/hsr_main.c                           |  11 +++
 net/hsr/hsr_main.h                           |   8 +-
 net/hsr/hsr_slave.c                          |  10 ++-
 20 files changed, 351 insertions(+), 60 deletions(-)
 create mode 100644 include/linux/if_hsr.h

-- 
2.11.0

