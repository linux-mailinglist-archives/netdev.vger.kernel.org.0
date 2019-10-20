Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF137DDC1D
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfJTDUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:10 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33909 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfJTDUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:10 -0400
Received: by mail-qt1-f196.google.com with SMTP id 3so15295542qta.1;
        Sat, 19 Oct 2019 20:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1fcpE/05mFjdeOSWH1fYTkKpdxpp4wtvZEoFQwIMUx4=;
        b=E1yac6Afza7+qa5Gb75xG0MbQtnqh1GGlpayudcaYU3w2qbVdkKARYG1KIqLTeT3jT
         k0BIUdytud0TSFnHnEHO5qR/h7nTKKQU+0bpK8y7e9yx0hs0XtudotWj2oFzHmyTC93P
         //jvCxECLb6rM2bM5VcwzTOkkrqwXEBhl7uleuzxiYaKzIYDMoRnNjJmA0gMEdbkW0sk
         WaUhaHT/FyBYzhRaBTbcIXDkiP99/JA28p8YKs2d1Z+WpUu2Ax/0WRjWyim1EF/ZvfLf
         Jw5QsH9qsnfzA8cdWpvjlF7hvQ7ohSL7bhpO2JfLbgi/PTBwsjVurPpxZ4OGl4htMQHE
         eHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1fcpE/05mFjdeOSWH1fYTkKpdxpp4wtvZEoFQwIMUx4=;
        b=cCjYgROHQGtiP6U4wLHcmhMPmjtBZEaLCUp9WpxtDbd8HAm8KWvDUZsw8hgAQN5sg9
         Uec4eVAyPvHHNOsjqFMx0pwg6kGc7jQdkQ8PXnXB2pubKJNfJ769XYwCAwE4c38HZwdt
         pnKF5BJtOo5QQQ6aoJASgtZlMNMMno97KmNIhL1ffvoD4JMUKLYVIZZoo9xQUb3ZHy91
         hGSG3r2d+uZrcqESidUV2PZosNZ3n81j0jvzKnMhPRzNa2RvlOEquN+/dQSl8fd1heKX
         n4nqwsZ7FDLARh3nGvjJDOsGy9LAyZyHr4xde9yVNQRCBBxtIh2eddPWlPh826VU3+q+
         NbVg==
X-Gm-Message-State: APjAAAWkTcqeI7lc4SDdXd3wsWZ5fTE9OIbaoOgO8PoG2Bb5z0X9mqYh
        iWO1ZvtQkccOsRZxeXr2uQY=
X-Google-Smtp-Source: APXvYqw9+Y5cVVZrYlP9h3m2RsO9LKAC8MKCJ4xQgIqNBz7f03FOjbw43pdrUsvWbm3jHc776sdq3Q==
X-Received: by 2002:a0c:fd91:: with SMTP id p17mr5161048qvr.28.1571541607150;
        Sat, 19 Oct 2019 20:20:07 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y10sm5291694qkb.55.2019.10.19.20.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:06 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/16] net: dsa: turn arrays of ports into a list
Date:   Sat, 19 Oct 2019 23:19:25 -0400
Message-Id: <20191020031941.3805884-1-vivien.didelot@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c       |  87 ++++----
 drivers/net/dsa/qca8k.c                |   7 +-
 drivers/net/dsa/realtek-smi-core.c     |   5 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  37 ++--
 drivers/net/dsa/vitesse-vsc73xx-core.c |   5 +-
 include/net/dsa.h                      |  26 ++-
 net/dsa/dsa.c                          |   8 +-
 net/dsa/dsa2.c                         | 282 +++++++++++++------------
 net/dsa/dsa_priv.h                     |  23 +-
 net/dsa/switch.c                       |   4 +-
 net/dsa/tag_8021q.c                    |   6 +-
 20 files changed, 297 insertions(+), 257 deletions(-)

-- 
2.23.0

