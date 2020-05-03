Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280581C2FE4
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgECWMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726825AbgECWMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:12:41 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1312C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:12:40 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r26so6719645wmh.0
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VmNpOmznFJB5fNHoGuXz2g46cZXaJSJp2hNsGdZY+A4=;
        b=ioY5BzXegI18boeR49hr497FP3u/B5YFba8dUD1rT7JE/N3IGFT9tPZnxeTIUIyaIE
         fs7MTPMUYyMV0KC8RreG8NX1Iq/gXXg++TugLf9Bi8WNOUSq/SIwsBwLgtr1pcMYdFLB
         R3JoWj+Z4LIUuLWK4OhcJAfnwkFRZSB0/psTKIIiLWf4ejDOO5dOmnrRGHg/2nddWwYp
         Uj+nr+UfMp/7FFYKlfxWSVGhMt63Wewm4Og0XT0tlMpWBndewIjCcqzOE+4w5nBI4zY5
         mvTtUnnsbs5Lyx7fY3tLqJRkuknk8plMCK27bRh6CE5qhzPqj/rFcMplIiKnaWI3PGRP
         3A5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VmNpOmznFJB5fNHoGuXz2g46cZXaJSJp2hNsGdZY+A4=;
        b=SJrybVyzlxltJr/kSkSA5mJaBwrr2YyGKEisbKFYviki+tU1heRQiBnmTBIgV+NzXc
         fBGWnmGh+xgIQXDrapjV8U2K7wZ6H2HdKuNnhqSy0WBJ4VE0hEyLaCQ//g4Dd+yfEbb2
         E1uoWtjHnVr9oPLujIrVM1HxOEBPtjGSUjHRE277vwyE+GNTqXk9IY/dVN1TZISSeh9n
         WeO7LGm5kpDg09ZrMzmo2LdytiYQ9Vl8qB6b5aZZWqvmS1eCOooLPM+vJ8Rg8K6pk4V2
         Hdb5tU4l8JJlBqAqsE74OrIFiMpFVnph66XVuv5rk4TNh27BIdxQPwlaMtsFYHpDb3H+
         xADg==
X-Gm-Message-State: AGi0PuZEae+O1+/VmsOdrsPxR9KYKoNHgUJLKC8pFJQKEJBHOmZRKfOu
        aRRgboLz574BFDqVlZSm4VA=
X-Google-Smtp-Source: APiQypLA0c1pKHQKKHGjtPI2O3prAHZWiKuXE6dfnNDwg778rBzs1oB1LAi1ndLQtN2DGsVHAthgeg==
X-Received: by 2002:a1c:1b58:: with SMTP id b85mr10639551wmb.112.1588543955719;
        Sun, 03 May 2020 15:12:35 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id q143sm10692188wme.31.2020.05.03.15.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 15:12:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, mingkai.hu@nxp.com
Subject: [PATCH v3 net-next 0/4] Cross-chip bridging for disjoint DSA trees
Date:   Mon,  4 May 2020 01:12:24 +0300
Message-Id: <20200503221228.10928-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds support for boards where DSA switches of multiple types
are cascaded together. Actually this type of setup was brought up before
on netdev, and it looks like utilizing disjoint trees is the way to go:

https://lkml.org/lkml/2019/7/7/225

The trouble with disjoint trees (prior to this patch series) is that only
bridging of ports within the same hardware switch can be offloaded.
After scratching my head for a while, it looks like the easiest way to
support hardware bridging between different DSA trees is to bridge their
DSA masters and extend the crosschip bridging operations.

I have given some thought to bridging the DSA masters with the slaves
themselves, but given the hardware topology described in the commit
message of patch 4/4, virtually any number (and combination) of bridges
(forwarding domains) can be created on top of those 3x4-port front-panel
switches. So it becomes a lot less obvious, when the front-panel ports
are enslaved to more than 1 bridge, which bridge should the DSA masters
be enslaved to.

So the least awkward approach was to just create a completely separate
bridge for the DSA masters, whose entire purpose is to permit hardware
forwarding between the discrete switches beneath it.

v1 was submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200429161952.17769-1-olteanv@gmail.com/

v2 was submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200430202542.11797-1-olteanv@gmail.com/

Vladimir Oltean (4):
  net: bridge: allow enslaving some DSA master network devices
  net: dsa: permit cross-chip bridging between all trees in the system
  net: dsa: introduce a dsa_switch_find function
  net: dsa: sja1105: implement cross-chip bridging operations

 drivers/net/dsa/mv88e6xxx/chip.c       |  16 ++-
 drivers/net/dsa/sja1105/sja1105.h      |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c |  90 +++++++++++++++
 include/linux/dsa/8021q.h              |  45 ++++++++
 include/net/dsa.h                      |  13 ++-
 net/bridge/br_if.c                     |  32 ++++--
 net/bridge/br_input.c                  |  23 +++-
 net/bridge/br_private.h                |   6 +-
 net/dsa/dsa2.c                         |  21 ++++
 net/dsa/dsa_priv.h                     |   1 +
 net/dsa/port.c                         |  23 +++-
 net/dsa/switch.c                       |  21 +++-
 net/dsa/tag_8021q.c                    | 151 +++++++++++++++++++++++++
 13 files changed, 414 insertions(+), 30 deletions(-)

-- 
2.17.1

