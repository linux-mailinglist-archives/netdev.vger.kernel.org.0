Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA26FDF709
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfJUUvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:51:37 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41000 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730356AbfJUUvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id c17so20323014qtn.8;
        Mon, 21 Oct 2019 13:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BDuJ0uQ27lt9bnsFQnkkjG+9f/2jgITVP1aLz5xfLE=;
        b=t/iYIIPVOwk+TvC7sS8FeASOyOZxep3HKStIwFwIMBfpzUwskbpwdK89u2kjzphx5z
         9m5QO/YUaNmpD387W/20yD8l44ucyeJaf8oU7vCF1pzypOsnFFOmjwmz2Y1po1zvjPjQ
         KyhySGJp/Jw9+zINnlzYdzUThAboS1XTBYMLn6n6Gxpe4e5ZjE8//5AtOzy1XmSpnIo6
         /36nE8/E7KGqBREWxe7FECmDbhfNwGOf3/ANgAr21cI3j+mxaLXSeq1YNz0CvdjvxXBI
         FW9GB9MIw1foZkdS+HuuZTgHswMCUCxeBS39j3YHweX0I2I+klh210DIOfbg3W6FLFtu
         2YCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BDuJ0uQ27lt9bnsFQnkkjG+9f/2jgITVP1aLz5xfLE=;
        b=IeP9waBETQ6zac7qXSbF38+W/nTelNgNPwUDMPv+NnKTuxDkIea3UJzHKuHBvERtD5
         qKpsQvPe2dkwGaTQ6FtCPuCGkzt2zWDe1+Fz7+uHYVhJ7OtpCxJNsQuqLBeDwwBDi73p
         bDF7B0elk9YzGLjkOGGbvPo5N3isZp0EBEKauT0RKtraguMKbcr1BrKjN9JbwmZIbCR1
         oSTKqZT4NbQQIEXMMswzRHHxAW84dShYNhGVyhFfQxQUdByS9wKFwvsdOyj7fgMmwnel
         ZZIRB+w+ovRl7tB+nvKWxAGAeFZiw+heczQ/B9rqpRpPDlBeo1HVQaqxfIfWKwuJ76Zw
         NE3g==
X-Gm-Message-State: APjAAAU61mOnPoT4fli1e+97KftY2wFksVGANmsAVimjk2OSVAlWVxZc
        cPi1f+C+Q6VWFGEpSYZJpW3R3obr
X-Google-Smtp-Source: APXvYqz6oNX82y4ztDEXnfHf2RiUMn+lpD77/ySnf7jrm/FUdmtNN5+gLp4ENzKnZqoOmvR1YGyjqQ==
X-Received: by 2002:ac8:237b:: with SMTP id b56mr27645010qtb.264.1571691095204;
        Mon, 21 Oct 2019 13:51:35 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 64sm8447903qkk.63.2019.10.21.13.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:34 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 00/16] net: dsa: turn arrays of ports into a list
Date:   Mon, 21 Oct 2019 16:51:14 -0400
Message-Id: <20191021205130.304149-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa_switch structure represents the physical switch device itself,
and is allocated by the driver. The dsa_switch_tree and dsa_port structures
represent the logical switch fabric (eventually composed of multiple switch
devices) and its ports, and are allocated by the DSA core.

This branch lists the logical ports directly in the fabric which simplifies
the iteration over all ports when assigning the default CPU port or configuring
the D in DSA in drivers like mv88e6xxx.

This also removes the unique dst->cpu_dp pointer and is a first step towards
supporting multiple CPU ports and dropping the DSA_MAX_PORTS limitation.

Because the dsa_port structures are not tight to the dsa_switch structure
anymore, we do not need to provide an helper for the drivers to allocate a
switch structure. Like in many other subsystems, drivers can now embed their
dsa_switch structure as they wish into their private structure. This will
be particularly interesting for the Broadcom drivers which were currently
limited by the dynamically allocated array of DSA ports.

The series implements the list of dsa_port structures, makes use of it,
then drops dst->cpu_dp and the dsa_switch_alloc helper.

Changes in v2:
  - use list_add_tail instead of list_add to respect ports order
  - use a single return statement for dsa_to_port
  - remove pr_info messages
  - put comments under appropriate branches
  - add Git tags from reviewers


Vivien Didelot (16):
  net: dsa: use dsa_to_port helper everywhere
  net: dsa: add ports list in the switch fabric
  net: dsa: use ports list in dsa_to_port
  net: dsa: use ports list to find slave
  net: dsa: use ports list to setup switches
  net: dsa: use ports list for routing table setup
  net: dsa: use ports list to find a port by node
  net: dsa: use ports list to setup multiple master devices
  net: dsa: use ports list to find first CPU port
  net: dsa: use ports list to setup default CPU port
  net: dsa: mv88e6xxx: silently skip PVT ops
  net: dsa: mv88e6xxx: use ports list to map port VLAN
  net: dsa: mv88e6xxx: use ports list to map bridge
  net: dsa: sja1105: register switch before assigning port private data
  net: dsa: allocate ports on touch
  net: dsa: remove dsa_switch_alloc helper

 drivers/net/dsa/b53/b53_common.c       |  11 +-
 drivers/net/dsa/bcm_sf2.c              |   8 +-
 drivers/net/dsa/bcm_sf2_cfp.c          |   6 +-
 drivers/net/dsa/dsa_loop.c             |   5 +-
 drivers/net/dsa/lan9303-core.c         |   4 +-
 drivers/net/dsa/lantiq_gswip.c         |   4 +-
 drivers/net/dsa/microchip/ksz_common.c |   5 +-
 drivers/net/dsa/mt7530.c               |  17 +-
 drivers/net/dsa/mv88e6060.c            |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c       |  90 ++++----
 drivers/net/dsa/qca8k.c                |   7 +-
 drivers/net/dsa/realtek-smi-core.c     |   5 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  37 ++--
 drivers/net/dsa/vitesse-vsc73xx-core.c |   5 +-
 include/net/dsa.h                      |  26 ++-
 net/dsa/dsa.c                          |   8 +-
 net/dsa/dsa2.c                         | 274 +++++++++++++------------
 net/dsa/dsa_priv.h                     |  23 +--
 net/dsa/switch.c                       |   4 +-
 net/dsa/tag_8021q.c                    |   6 +-
 20 files changed, 292 insertions(+), 257 deletions(-)

-- 
2.23.0

