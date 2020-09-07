Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047C926048C
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgIGS3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729950AbgIGS3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 14:29:25 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5BBC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 11:29:24 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id q21so13622696edv.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 11:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ajjEJdu0DRg7G3E9AJXqp6bScFxyxnUvzjL4ajiboe8=;
        b=LD1mbtRHPmxGxhar3/6YKQ9lkf2zRcUEVvsH2fk++b/DB+THtyIaPmwOC29ApMUQgm
         nEE1vJCgGT+EVC5Jw/j9GIvDpqQ+LDNYMc9jNKAJXb6z9d02vvssmkldu5mzHHd+iZAz
         geektJyBdenAbMSPU2m7sf8NhHjCH1ps9mOsBAkZHAy6EElDo7S6H/0zW8RrHhekOHxi
         WyMJmvbYUoz6WL2FsmRPp1iMlk6MKi4xgdFrLxnrpgdui/SuO/JQsYVb1edvSx//awhJ
         DkeHCJYKdGsL/7JWwD+p5jL+crmddY2DQgnhwbf2B6IK/2K6KVZzEg1jrA8xIQX5hJEg
         nFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ajjEJdu0DRg7G3E9AJXqp6bScFxyxnUvzjL4ajiboe8=;
        b=Nbav7UEUCXpyRu4G6gmvSj8rdatQvmVTiN2AWKUO9eli4S+mc8nHPJpcWb3kE6swlS
         iVFgCvCdxg/aZm/2gU6IKUX4k6e9ef8lPrByS/1VecXWWpEqAGXZ5QDjaOHNZZxvSYLH
         sx7s7CgFK1HIzK3ZiWFLEkzaSlsRrp7ygwnmvOTr8MM24H4aMNUDOcsrSx0x/ZBHdS0I
         Q9AZ8pjm3/zFiVor3sE+P1+ii88ZVMxAyMqWRCbQd+iTCA4EWik4mlwxODrb4ilbXxiw
         MB/FKhJCt8c/MlkDLrygkq+0EL3HArU/oyGxlwj0TwCK+oT5gkMGNI+jYykvv6s1pTot
         hkqA==
X-Gm-Message-State: AOAM533PQVeTehLASnEXqFdSKxPKXBfPAJqyIxf2T6yPwX0Xe1PAmpiz
        pHOippEsw840EqJ716jxRG0=
X-Google-Smtp-Source: ABdhPJyKmp9sii99EUYB6gTRZ79Xnof8Ojajj37o4Iho0d4qF0ONCFhwV5YemwNQ9II+XOR9480feQ==
X-Received: by 2002:aa7:c256:: with SMTP id y22mr3164786edo.16.1599503363243;
        Mon, 07 Sep 2020 11:29:23 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g24sm11746816edy.51.2020.09.07.11.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 11:29:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] Some VLAN handling cleanup in DSA
Date:   Mon,  7 Sep 2020 21:29:06 +0300
Message-Id: <20200907182910.1285496-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This small series tries to consolidate the VLAN handling in DSA a little
bit.

First, tag_8021q is reworked to be minimally invasive to the
dsa_switch_ops structure. This makes the rest of the code a bit easier
to follow.

Then, the configure_vlan_while_not_filtering flag is enabled by default,
so new drivers won't use the legacy behavior by mistake. This was done
after the recent conversation with Kurt Kanzenbach on the Hirschmann
Hellcreek review patches.

Vladimir Oltean (4):
  net: dsa: tag_8021q: include missing refcount.h
  net: dsa: tag_8021q: add a context structure
  Revert "net: dsa: Add more convenient functions for installing port
    VLANs"
  net: dsa: set configure_vlan_while_not_filtering to true by default

 drivers/net/dsa/b53/b53_common.c       |   1 +
 drivers/net/dsa/bcm_sf2.c              |   1 +
 drivers/net/dsa/dsa_loop.c             |   1 -
 drivers/net/dsa/lantiq_gswip.c         |   3 +
 drivers/net/dsa/microchip/ksz8795.c    |   2 +
 drivers/net/dsa/microchip/ksz9477.c    |   2 +
 drivers/net/dsa/mt7530.c               |   1 -
 drivers/net/dsa/mv88e6xxx/chip.c       |   1 +
 drivers/net/dsa/ocelot/felix.c         |   1 -
 drivers/net/dsa/qca/ar9331.c           |   2 +
 drivers/net/dsa/qca8k.c                |   1 -
 drivers/net/dsa/rtl8366rb.c            |   2 +
 drivers/net/dsa/sja1105/sja1105.h      |   3 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 246 +++++++++++++++----------
 include/linux/dsa/8021q.h              |  49 ++---
 net/dsa/dsa2.c                         |   2 +
 net/dsa/dsa_priv.h                     |   2 -
 net/dsa/port.c                         |  33 ----
 net/dsa/slave.c                        |  63 ++++++-
 net/dsa/tag_8021q.c                    | 138 ++++++++------
 20 files changed, 319 insertions(+), 235 deletions(-)

-- 
2.25.1

