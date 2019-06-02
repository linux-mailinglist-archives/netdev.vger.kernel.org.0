Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC8C324E3
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfFBVMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:12:35 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:43049 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFBVMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:12:34 -0400
Received: by mail-wr1-f45.google.com with SMTP id r18so960586wrm.10
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=y7JiB1NAqmAXWxeZ8o9UbU3XCS6x4jRQ8efK0jFMA6c=;
        b=cY+WhuGnjf2/92GY4Zx1qIw0vShRJQJ7kbZ/LE5zH+cY2lD/3o/3sC0QwfYL/M7OtM
         t20VV/dIYlNah0aSFEK+layO/WDEfSJPJoohRCXQlnvAia64jLFXLs98DeITT7pTw2hb
         1YRzB1gACagiuu2+bnqGF8i/AlDyTOEizF8pJ5NFSu2uYOoSEOjnRK2DryOlbdpMZTgt
         ez8PJTHKcKC9QlyroXwOlI9HJJCwGtzakWYFW3LGG7VoqSvceeuHIUyHiCdPY0xjTgNM
         4ok2X1CqyANIz09nhGSH0arqDpdLifF+FhxYqoZKUdtNbjxjGlVeAdwwrOZbrVIwRQJW
         X2cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=y7JiB1NAqmAXWxeZ8o9UbU3XCS6x4jRQ8efK0jFMA6c=;
        b=JVsJn1UYinfu9/XOFU5otSIOZz1TdO0PEn6/G/4oL7HpTu9AMfsCYFmCHQ/leW10r9
         iephB9K71h3ANWtRIp05XD3q0nfwSo4M0DbjSK2TtQ3EK+Nrjy6UgvRfeGmTiXMm53H7
         tBu0w9xT/op+pZTK3VLMTTADnYFQpzuFTiMkZnyZBLUpklqHf0npFmEU1ToDiQJ4DzGY
         vZblkonyKbyMvBbLw0cqXnb67DBR4UAne49JfRqc2jWho/0QCFVRLhEPFZHecRp+cRz2
         abjqpbczH0PgZ/zhKDNOdyEnhm2BFT6uu4SeFlqGk0mi0mq6Oo3sUx6dEShlCb25/vmK
         GxXg==
X-Gm-Message-State: APjAAAW44v/Q1/IH5m+E1+LBb/pxca+0xiUWtkNgDWhsyNWicbUf6NTV
        J/nGwZS4AVjbPF2nJHt22CfxBqcp
X-Google-Smtp-Source: APXvYqxuL+bMdW58Imc1GukvX4Wyt2Ctsq+AQpv2xAmZcDB7iUsiXUG9D36OnmTUtd8Njck0/mJ7+Q==
X-Received: by 2002:a5d:4b49:: with SMTP id w9mr50192wrs.113.1559509952715;
        Sun, 02 Jun 2019 14:12:32 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id q11sm9548193wmc.15.2019.06.02.14.12.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:12:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 00/11] FDB updates for SJA1105 DSA driver
Date:   Mon,  3 Jun 2019 00:11:52 +0300
Message-Id: <20190602211203.17773-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds:

- FDB switchdev support for the second generation of switches (P/Q/R/S).
  I could test/code these now that I got a board with a SJA1105Q.

- Management route support for SJA1105 P/Q/R/S. This is needed to send
  PTP/STP/management frames over the CPU port.

- Logic to hide private DSA VLANs from the 'bridge fdb' commands.

The new FDB code was also tested and still works on SJA1105T.

Vladimir Oltean (11):
  net: dsa: sja1105: Shim declaration of struct sja1105_dyn_cmd
  net: dsa: sja1105: Fix bit offsets of index field from L2 lookup
    entries
  net: dsa: sja1105: Add missing L2 Forwarding Table definitions for
    P/Q/R/S
  net: dsa: sja1105: Plug in support for TCAM searches via the dynamic
    interface
  net: dsa: sja1105: Make room for P/Q/R/S FDB operations
  net: dsa: sja1105: Add P/Q/R/S support for dynamic L2 lookup
    operations
  net: dsa: sja1105: Make dynamic_config_read return -ENOENT if not
    found
  net: dsa: sja1105: Add P/Q/R/S management route support via dynamic
    interface
  net: dsa: sja1105: Add FDB operations for P/Q/R/S series
  net: dsa: sja1105: Unset port from forwarding mask unconditionally on
    fdb_del
  net: dsa: sja1105: Hide the dsa_8021q VLANs from the bridge fdb
    command

 drivers/net/dsa/sja1105/sja1105.h             |  20 +-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 144 +++++++++++++-
 .../net/dsa/sja1105/sja1105_dynamic_config.h  |  11 +-
 drivers/net/dsa/sja1105/sja1105_main.c        | 186 ++++++++++++++++--
 drivers/net/dsa/sja1105/sja1105_spi.c         |  12 ++
 .../net/dsa/sja1105/sja1105_static_config.c   |  18 +-
 .../net/dsa/sja1105/sja1105_static_config.h   |  26 +++
 7 files changed, 379 insertions(+), 38 deletions(-)

-- 
2.17.1

