Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C900316A6F4
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgBXNJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:09:18 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:34559 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgBXNJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:09:17 -0500
Received: by mail-wr1-f50.google.com with SMTP id z15so1982767wrl.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bhuIl+17VUgpf2ATNHegtuFbFe3Mjz5cWKUzembtYZo=;
        b=XbX5fPz0rNuefkbQVxYpCHvhLgvv478H9PFSdoSBWYFscVmwPVVbWGxA7cez96baqW
         IeO9mwzAQZWOlIz2NPrjlaaovkoon+AqPi7Jkb+NtS8tdzbWWov0jgjD2yuNJEgrajFd
         nt7jdoYsqNO4hsjVovXjhUKemE3RCrs+ZxgzdAp7qX/yMNiFk71suO7t01kGrwsq99Ht
         yPlh68dXl1wS9Q822tSbh0FcPpkske+ZtfC+henbCRGhDfbVslBduYN+XEh84yxA5PvC
         IciTUGK2n7OTcnnaRk/fG3VsSJtDPksdiRi9teYnTr1CwklicqaPOggsdUoWDybwoTnD
         kcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bhuIl+17VUgpf2ATNHegtuFbFe3Mjz5cWKUzembtYZo=;
        b=H/uSbhevaETCHhs4oxe2uQLXQ2WSbEOoNXmU5EB6lrZ+yVbUmJXCwkqKuhXPJIFfxR
         Q+LKsD2Zsu+52YeR11XN4dyN8y3WQcDx6Y8A2iQjAUZ7m8wwGZWH0GvBT/1zlydwKEgC
         1juyjoOJytMva1qDMUYWN8FSyekgJQU8vEIcZkEO0BY79jjLgorp/vtADUromIMX5GFw
         uqJ8t1EjrHcECBT1oiJSad63o7mwBA4R1ymz9YrBFBMnr8B/FsDT3j5jGkr2N8XnUUbQ
         iO5/3So0FH4r+M4AOQXUs5fSfpfYy7KVMwZBwMw+6jUL55Zwg4XP0Bqek86wa+oci1EC
         WtHg==
X-Gm-Message-State: APjAAAWZMUTv4d+N0S4QlPXOsucjg86rzSubex4+iNSoH1R/Iu5DFkZf
        XjaoiFABy8UqdNvgcQXCNnC28VeeKmQ=
X-Google-Smtp-Source: APXvYqyEc0gF9poSRsAH9K8daLlZa2NXScJDcwxY8SZOI1b3DqF9ISsh4Il87/4LWgMEGLofmqB2tg==
X-Received: by 2002:adf:e686:: with SMTP id r6mr67644470wrm.177.1582549755807;
        Mon, 24 Feb 2020 05:09:15 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i204sm18089298wma.44.2020.02.24.05.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:09:14 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH net-next 00/10] Wire up Ocelot tc-flower to Felix DSA
Date:   Mon, 24 Feb 2020 15:08:21 +0200
Message-Id: <20200224130831.25347-1-olteanv@gmail.com>
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
VLAN retagging, etc etc), and that we should consider replacing the port
mirroring callbacks in DSA with simple accessors to
TC_CLSMATCHALL_REPLACE and TC_CLSMATCHALL_DESTROY, just like for flower.
That means that drivers which currently implement the port mirroring
callbacks will need to have some extra "if" conditions now, in order for
them to call their port mirroring implementations.

Vladimir Oltean (9):
  net: mscc: ocelot: simplify tc-flower offload structures
  net: mscc: ocelot: replace "rule" and "ocelot_rule" variable names
    with "ace"
  net: mscc: ocelot: return directly in
    ocelot_cls_flower_{replace,destroy}
  net: mscc: ocelot: don't rely on preprocessor for vcap key/action
    packing
  net: mscc: ocelot: remove port_pcs_init indirection for VSC7514
  net: mscc: ocelot: parameterize the vcap_is2 properties
  net: dsa: Refactor matchall mirred action to separate function
  net: dsa: Add bypass operations for the flower classifier-action
    filter
  net: dsa: felix: Wire up the ocelot cls_flower methods

Yangbo Lu (1):
  net: mscc: ocelot: make ocelot_ace_rule support multiple ports

 drivers/net/dsa/ocelot/felix.c            |  31 ++
 drivers/net/dsa/ocelot/felix.h            |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c    | 126 ++++++
 drivers/net/ethernet/mscc/ocelot.c        |  20 +-
 drivers/net/ethernet/mscc/ocelot_ace.c    | 472 +++++++++++-----------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  26 +-
 drivers/net/ethernet/mscc/ocelot_board.c  | 151 +++++--
 drivers/net/ethernet/mscc/ocelot_flower.c | 256 ++++--------
 drivers/net/ethernet/mscc/ocelot_tc.c     |  22 +-
 drivers/net/ethernet/mscc/ocelot_vcap.h   | 403 ------------------
 include/net/dsa.h                         |   6 +
 include/soc/mscc/ocelot.h                 |  20 +-
 include/soc/mscc/ocelot_vcap.h            | 205 ++++++++++
 net/dsa/slave.c                           | 128 ++++--
 14 files changed, 954 insertions(+), 915 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_vcap.h
 create mode 100644 include/soc/mscc/ocelot_vcap.h

-- 
2.17.1

