Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C602E1CCC53
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgEJQnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728892AbgEJQnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:31 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03542C061A0C;
        Sun, 10 May 2020 09:43:29 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id 50so7383395wrc.11;
        Sun, 10 May 2020 09:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zETV6gnvzZId8Tc8BRS7p7fuaZqP/IoCPwQ1fFgbMkI=;
        b=luAuSehgD3yodopjX3KtDzbeUiSap+JaRInf2d3/EZyt1ckLN4LJnmb32cSNaCQEgh
         H6icq2soUeIlPOqUxlvoSD+rQ5HC/QWXBzVI2rNS6AxRkaf79M1w654BABiHr00cdXmx
         XxHHBS9JFTe1dm8Uo8aIEllhoLSnPJvRzBLa/nnPh2I2GiPJQd17s4YVEhDvukrlMjrK
         ypCoZgtei65YMlSBQTLS5x5lgL8+d2FYnvAO191ZGYn+sDCuVqdZKgyYHRceOVIHbHzM
         lhj4lstCnljJhuuLYPXOKBTAXdHLMsnvV2QyNYhqeKjmQ1P96MBZ+XAoEzJnSLE+uF07
         ZEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zETV6gnvzZId8Tc8BRS7p7fuaZqP/IoCPwQ1fFgbMkI=;
        b=WpUH0X09kufdcswhlwFLRi+gQYK6EtcyYm9bTyq2IJOb7QmNLeHT9w14uHVhvdJUWd
         i2215DtfIvTMeNN32L090kCz2r9KJrNjDWbv/NVyTtXdr5bszOt2TGADBGsN9k37olVm
         MydXKIJoLr6cb8vRYZ/qIzdUAbkR9NuFaM3s2nQy/XPlIYhfg3vJ/FYOyfSXZgcpzP4Z
         hZNUNSOsNjvJ/iqBFOXBGgR+gLfzLV9KDL1h3+eE6XdtRkgVBEU69o5cOHVEWaIAySCM
         0vniSev63f1LvCko15N8Ek8pcmQxAGWrs2QLum6jqF8a52XNbAGuALE2FEEV9iPYXwXh
         bugg==
X-Gm-Message-State: AGi0PuY6lLpLtVdoiJ3SkW+meLTdRSUZeJDtxSdkIbTM9jfGgJEHGlZ7
        6tOXaG3h4lF3aXdwCaIWcPY=
X-Google-Smtp-Source: APiQypK+b4KrVQRFHRYUcfS0rNYAc/URwtB0XBJLrw24iO6gy5nSEFOfook3NGgdvm2U5Q96b4eVNA==
X-Received: by 2002:a5d:408b:: with SMTP id o11mr13362438wrp.97.1589129008577;
        Sun, 10 May 2020 09:43:28 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/15] Traffic support for dsa_8021q in vlan_filtering=1 mode
Date:   Sun, 10 May 2020 19:42:40 +0300
Message-Id: <20200510164255.19322-1-olteanv@gmail.com>
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

This series depends on "[v4,resend,net-next,0/4] Cross-chip bridging for
disjoint DSA trees", submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200510163743.18032-1-olteanv@gmail.com/

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
 Documentation/networking/dsa/sja1105.rst      |  211 +++-
 drivers/net/dsa/sja1105/sja1105.h             |   29 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   33 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 1072 +++++++++++++++--
 drivers/net/dsa/sja1105/sja1105_spi.c         |    6 +
 .../net/dsa/sja1105/sja1105_static_config.c   |   62 +-
 .../net/dsa/sja1105/sja1105_static_config.h   |   16 +
 drivers/net/dsa/sja1105/sja1105_vl.c          |   20 +-
 include/linux/dsa/8021q.h                     |   42 +-
 include/linux/dsa/sja1105.h                   |    5 +
 include/net/dsa.h                             |    1 +
 net/dsa/slave.c                               |   12 +-
 net/dsa/tag_8021q.c                           |  108 +-
 net/dsa/tag_sja1105.c                         |   38 +-
 15 files changed, 1443 insertions(+), 239 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-sja1105.txt

-- 
2.17.1

