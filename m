Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D071CDC13
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbgEKNxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730272AbgEKNxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:53:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB79C061A0C;
        Mon, 11 May 2020 06:53:46 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id v12so11037247wrp.12;
        Mon, 11 May 2020 06:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DWt/wZ7mmPAQXQOu5mlkf9aGiZr82IVGoApLaprsibc=;
        b=s4FYq0euNJOaf10ErT8ojnM/K0FKxONCHXk+61YMwdnHmsDwa3VdU+CnYo7AO/EeO5
         Pf/u2B4mUOPqYO4tRNpy6pev2G/BZv7sMqQB1/FnqCL36uz5LSblfF+e+g+xk1sWJlEx
         eDFayl8lLeBn759hTo3A8v5z0RNDnKF/5dkPu5bwV+WwPixLRio1dv8t6t0el/l4FDEV
         tGoa09orA1M9iYpw+kiOm/jUpQmAUo+ue2/PXCjqp6f5apgBji689YI7Zjc755P+5F5H
         CdZDmNEnTsy/xaDeHTHnhe/JTC+diCoTbldCnjRggSAjdk2EY0im+MATjRfJ8qEVPAlM
         gVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DWt/wZ7mmPAQXQOu5mlkf9aGiZr82IVGoApLaprsibc=;
        b=X6dTXmS+vUi3gpiGc2Hq9/aP8XSNxCgyPj3ZbzQqxDfyMMAoFf7/D4VJg2gKaYYCPd
         nyC+k+4z6/OiOJruCZfB41BPX4h1miBdrkURoUE+jnNgcJp8EDvRwzj0xFpSmmVUP7Pz
         iFWx1r6WsR1t7IKjpQeEPtqbmNN1spwHP78Dal1IngwLwea80E5qMPK0vydLhatmyS9I
         2uSgJYi6jcii1/1mWrPwy3YeAOVsymXEsDZV8oB9j/OYLQuUUKy48M6S/VM2mcyxnBJQ
         xRrQ8v2HuNb6sxc9XSFG9tRuyHpJkvk3D0fWnOa28NuKE59NNxXQyyHlg4qgBm5iZKNW
         fHLQ==
X-Gm-Message-State: AGi0PuaokFKQWaaf+IilxejX+CMbN+kd90sVUZ1Wfu5HbxB6yfON7Wak
        QSGsCr/D9AIik4vwSIIB4Ho=
X-Google-Smtp-Source: APiQypLtlc6SYID6KBCDA++125iB+xlVDhcNY23F6cYVHOZmHqJXbZtklEkadlytqGgK5OKneceJ7A==
X-Received: by 2002:a5d:56c6:: with SMTP id m6mr18873848wrw.78.1589205224786;
        Mon, 11 May 2020 06:53:44 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 2sm17596413wre.25.2020.05.11.06.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:53:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 00/15] Traffic support for dsa_8021q in vlan_filtering=1 mode
Date:   Mon, 11 May 2020 16:53:23 +0300
Message-Id: <20200511135338.20263-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series is an attempt to support as much as possible in terms of
traffic I/O from the network stack with the only dsa_8021q user thus
far, sja1105.

The hardware doesn't support pushing a second VLAN tag to packets that
are already tagged, so our only option is to combine the dsa_8021q with
the user tag into a single tag and decode that on the CPU.

The assumption is that there is a type of use cases for which 7 VLANs
per port are more than sufficient, and that there's another type of use
cases where the full 4096 entries are barely enough. Those use cases are
very different from one another, so I prefer trying to give both the
best experience by creating this best_effort_vlan_filtering knob to
select the mode in which they want to operate in.

v1 was submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200510164255.19322-1-olteanv@gmail.com/

Changes in v2:
Patch 01/15:
- Rename variable from vlan_bridge_vtu to configure_vlans_while_disabled.
Patch 03/15:
- Be much more thorough, and make sure that things like virtual links
  and FDB operations still work properly.
Patch 05/15:
- Free the vlan lists on teardown.
- Simplify sja1105_classify_vlan: only look at priv->expect_dsa_8021q.
- Keep vid 1 in the list of dsa_8021q VLANs, to make sure that untagged
  packets transmitted from the stack, like PTP, continue to work in
  VLAN-unaware mode.
Patch 06/15:
- Adapt to vlan_bridge_vtu variable name change.
Patch 11/15:
- In sja1105_best_effort_vlan_filtering_set, get the vlan_filtering
  value of each port instead of just one time for port 0. Normally this
  shouldn't matter, but it avoids issues when port 0 is disabled in
  device tree.
Patch 14/14:
- Only do anything in sja1105_build_subvlans and in
  sja1105_build_crosschip_subvlans when operating in
  SJA1105_VLAN_BEST_EFFORT state. This avoids installing VLAN retagging
  rules in unaware mode, which would cost us a penalty in terms of
  usable frame memory.

Russell King (1):
  net: dsa: provide an option for drivers to always receive bridge VLANs

Vladimir Oltean (14):
  net: dsa: tag_8021q: introduce a vid_is_dsa_8021q helper
  net: dsa: sja1105: keep the VLAN awareness state in a driver variable
  net: dsa: sja1105: deny alterations of dsa_8021q VLANs from the bridge
  net: dsa: sja1105: save/restore VLANs using a delta commit method
  net: dsa: sja1105: allow VLAN configuration from the bridge in all
    states
  net: dsa: sja1105: exit sja1105_vlan_filtering when called multiple
    times
  net: dsa: sja1105: prepare tagger for handling DSA tags and VLAN
    simultaneously
  net: dsa: tag_8021q: support up to 8 VLANs per port using sub-VLANs
  net: dsa: tag_sja1105: implement sub-VLAN decoding
  net: dsa: sja1105: add a new best_effort_vlan_filtering devlink
    parameter
  net: dsa: sja1105: add packing ops for the Retagging Table
  net: dsa: sja1105: implement a common frame memory partitioning
    function
  net: dsa: sja1105: implement VLAN retagging for dsa_8021q sub-VLANs
  docs: net: dsa: sja1105: document the best_effort_vlan_filtering
    option

 .../networking/devlink-params-sja1105.txt     |   27 +
 Documentation/networking/dsa/sja1105.rst      |  211 ++-
 drivers/net/dsa/sja1105/sja1105.h             |   29 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   33 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 1128 +++++++++++++++--
 drivers/net/dsa/sja1105/sja1105_spi.c         |    6 +
 .../net/dsa/sja1105/sja1105_static_config.c   |   62 +-
 .../net/dsa/sja1105/sja1105_static_config.h   |   16 +
 drivers/net/dsa/sja1105/sja1105_vl.c          |   44 +-
 include/linux/dsa/8021q.h                     |   42 +-
 include/linux/dsa/sja1105.h                   |    5 +
 include/net/dsa.h                             |    7 +
 net/dsa/slave.c                               |   12 +-
 net/dsa/tag_8021q.c                           |  108 +-
 net/dsa/tag_sja1105.c                         |   38 +-
 15 files changed, 1508 insertions(+), 260 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-sja1105.txt

-- 
2.17.1

