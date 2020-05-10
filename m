Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4E41CCC41
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgEJQhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgEJQhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:37:55 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29149C061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 09:37:55 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so7909988wra.7
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 09:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MVChMKvN3cReFb28B+2P0aZuJ9VZT33oCre6sgR9g3Q=;
        b=XAnmqeFWBzKMtsHC9lJwkzOK1eEURRHb47M2yDEVeG0x8k+Zewppp4VSIyv0elKlDE
         +XqKLVEs5cU+dZtWdwUhjUGCLD24S4WSJGtvl8Egmfllb+Tm3xqmRBc4AjOXXRbO/W5b
         Mk0BNeRoOypGCqyErzg2su4Sn52rY+x8WPywuD0xfjnv3Xx2huTlmB6kaviLMQ9KALdN
         FyEY6fzeGeThA1SIENl0Z9hCvk+TkCnoEKeqKrgof6Sp5EwiyRPCkrOEzyeXMsnsWNaQ
         md0AfWOFNtUSSCU5f52Zo+xdsEmVwPcDFs7IL7PIWEmK77FGBiatvGJqwUE2PcDTUKZG
         X+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MVChMKvN3cReFb28B+2P0aZuJ9VZT33oCre6sgR9g3Q=;
        b=X+xQkiaq1Y6OIdbPIR+V8iBxZqJ2WHBSJgZtow68j/mjJHrfeBle9ZCsgc5lXvwxRT
         oLwyXsJJl9pnkJOZDsyvSBdsmh6lmtMqNCj6croz+n9ZvBWrY+45SATe2kLDZsmf1xjg
         /jUKJ0hmsHCZH+hCgVYgfjphBwqV3Mec4HTG9+fGGjb9Rw+RKbMDPEbqwBKNR7Xob6xV
         CfKvZSET9/hApUre+cNgByYPRdJ4RnfWKnz8UKPYf1V+RX0e9IizCnR1mDW/kaax4Ntl
         N1MHsfDn1XGCe8/YK0oYSYk6F8axcp+rJXjzD+RhJmk7ljOJyawKZelYNGzyFQy6fdwl
         ztbA==
X-Gm-Message-State: AGi0PuaPhnz/4RBY1hefCXQb94r4k4u0zcnqg2tzVv6pjEV4K7ttqkMJ
        NduRkxooAOpQaBTVuRm+qQI=
X-Google-Smtp-Source: APiQypJdSfytK3SwuNT8TmRJBQYTss+a7QTgt7qSmhGdOWAmTMNukwwKk6ZfG0aN7LyvBlaL27uz0Q==
X-Received: by 2002:a05:6000:1106:: with SMTP id z6mr7467974wrw.336.1589128673756;
        Sun, 10 May 2020 09:37:53 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id d133sm25472394wmc.27.2020.05.10.09.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:37:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com
Subject: [PATCH v4 resend net-next 0/4] Cross-chip bridging for disjoint DSA trees
Date:   Sun, 10 May 2020 19:37:39 +0300
Message-Id: <20200510163743.18032-1-olteanv@gmail.com>
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

This is a direct resend of v3, which was deferred due to lack of review.
In the meantime Florian has reviewed and tested some of them.

v1 was submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200429161952.17769-1-olteanv@gmail.com/

v2 was submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200430202542.11797-1-olteanv@gmail.com/

v3 was submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200503221228.10928-1-olteanv@gmail.com/

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

