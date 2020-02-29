Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D3717475B
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgB2ObU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:31:20 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:33685 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgB2ObU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:31:20 -0500
Received: by mail-wm1-f52.google.com with SMTP id m10so11496434wmc.0
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 06:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=birOYA5mZ6WtyXrjoCANU+tLyQEi6ZhfVHubCFb/MOw=;
        b=RkK0TeVPvZrjJnWN19fIAhaXFE4ArgoiCCQIpWsZoyYXx4hybATKUKTN0s1fxRX0is
         +miKSCeaHf4+va/APoiGrJUr228bFL4iTjY38m/jqfNEy6CFuSXHV+C8V8yyckgE9Jrr
         V6ucfV/VUKsoauaTotnTVzkk8IN22Ob1ZlpWjWmaYkDRU440fjgXJ6tZm09ES5JD0JfK
         JkpdNvHSkrbJRdiddzfq/bLhtb2//DgG3G7H6Kf9JmBpbgjJ9/ywbwEfYAJs1YKId6OK
         7zxEU+1//CqTIQkQIaUVV0ao3mV2N91yOe4F0kLcCUscXr07/sdNQuEKMIBeMCwtISU1
         T7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=birOYA5mZ6WtyXrjoCANU+tLyQEi6ZhfVHubCFb/MOw=;
        b=RE7+KJ5ywqFdda27Le2NLYzzPUiXNuiQAku2ag87AQVKR41c70bhwbxrKaIeg1Dvxh
         kEkEb0S9VqkqsAnvaJUIQeYzDd5FWxr0jMzEcBVf+lFeSV3teP5+6wAqWKq41h5g2VKq
         QKty2E3g6ueTYTqX9z0rzdmVFcO6qRzZmSyd6uF6/wStxYs4Cht91B519pOsRfgGvRP3
         iKd5AOYTp93zGIL/ZPTLl25DCJ/s3Sk464qV5h9NKfr8t+aAMNeOq/kgOOhGsEN+iCAU
         ZANqdKOY+xKaJF2eeIbnWTGBfiv39BfqWzA+l5UYa10GoNieAEKSwOHLbx5AEcTYCpqR
         xsHA==
X-Gm-Message-State: APjAAAXUrw7Hu2iX0n6KDibI5SQ/EnKfa/Cr+vR9FyiDVuVBULBgEKyE
        LAQTIOKxowTEgogL18cEl6k=
X-Google-Smtp-Source: APXvYqzEffnNbjfMwnJ5a33IpTw4Z0eloNXMXCOuP5n0uUBMgQWBwhZ4ArZ03oaMEcWs6ItkHSE8hA==
X-Received: by 2002:a1c:4043:: with SMTP id n64mr4113934wma.169.1582986678447;
        Sat, 29 Feb 2020 06:31:18 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id d7sm7573528wmc.6.2020.02.29.06.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:31:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH v2 net-next 00/10] Wire up Ocelot tc-flower to Felix DSA
Date:   Sat, 29 Feb 2020 16:31:04 +0200
Message-Id: <20200229143114.10656-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series is a proposal on how to wire up the tc-flower callbacks into
DSA. The example taken is the Microchip Felix switch, whose core
implementation is actually located in drivers/net/ethernet/mscc/.

The proposal is largely a compromise solution. The DSA middle layer
handles just enough to get to the interesting stuff (FLOW_CLS_REPLACE,
FLOW_CLS_DESTROY, FLOW_CLS_STATS), but also thin enough to let drivers
decide what filter keys and actions they support without worrying that
the DSA middle layer will grow exponentially. I am far from being an
expert, so I am asking reviewers to please voice your opinion if you
think it can be done differently, with better results.

The bulk of the work was actually refactoring the ocelot driver enough
to allow the VCAP (Versatile Content-Aware Processor) code for vsc7514
and the vsc9959 switch cores to live together.

Flow block offloads have not been tested yet, only filters attached to a
single port. It might be as simple as replacing ocelot_ace_rule_create
with something smarter, it might be more complicated, I haven't tried
yet.

I should point out that the tc-matchall filter offload is not
implemented in the same manner in current mainline. Florian has already
went all the way down into exposing actual per-action callbacks,
starting with port mirroring. Because currently only mirred is supported
by this DSA mid layer, everything else will return -EOPNOTSUPP. So even
though ocelot supports matchall (aka port-based) policers, we don't have
a call path to call into them.  Personally I think that this is not
going to scale for tc-matchall (there may be policers, traps, drops,
VLAN retagging, etc etc), and that we should consider whether further
matchall filter/action combinations should be just passed on to drivers
with no interpretation instead.
As for the existing mirroring callbacks in DSA, they can either be kept
as-is, or replaced with simple accessors to TC_CLSMATCHALL_REPLACE and
TC_CLSMATCHALL_DESTROY, just like for flower, and drivers which
currently implement the port mirroring callbacks will need to have some
extra "if" conditions now, in order for them to call their port
mirroring implementations.

Vladimir Oltean (9):
  net: mscc: ocelot: simplify tc-flower offload structures
  net: mscc: ocelot: replace "rule" and "ocelot_rule" variable names
    with "ace"
  net: mscc: ocelot: return directly in
    ocelot_cls_flower_{replace,destroy}
  net: mscc: ocelot: spell out full "ocelot" name instead of "oc"
  net: mscc: ocelot: don't rely on preprocessor for vcap key/action
    packing
  net: mscc: ocelot: remove port_pcs_init indirection for VSC7514
  net: mscc: ocelot: parameterize the vcap_is2 properties
  net: dsa: Add bypass operations for the flower classifier-action
    filter
  net: dsa: felix: Wire up the ocelot cls_flower methods

Yangbo Lu (1):
  net: mscc: ocelot: make ocelot_ace_rule support multiple ports

 drivers/net/dsa/ocelot/felix.c            |  31 ++
 drivers/net/dsa/ocelot/felix.h            |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c    | 131 +++++
 drivers/net/ethernet/mscc/ocelot.c        |  20 +-
 drivers/net/ethernet/mscc/ocelot_ace.c    | 561 ++++++++++++----------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  26 +-
 drivers/net/ethernet/mscc/ocelot_board.c  | 156 +++++-
 drivers/net/ethernet/mscc/ocelot_flower.c | 256 +++-------
 drivers/net/ethernet/mscc/ocelot_tc.c     |  22 +-
 drivers/net/ethernet/mscc/ocelot_vcap.h   | 403 ----------------
 include/net/dsa.h                         |   6 +
 include/soc/mscc/ocelot.h                 |  20 +-
 include/soc/mscc/ocelot_vcap.h            | 205 ++++++++
 net/dsa/slave.c                           |  60 +++
 14 files changed, 983 insertions(+), 917 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_vcap.h
 create mode 100644 include/soc/mscc/ocelot_vcap.h

-- 
2.17.1

