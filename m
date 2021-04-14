Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3822635F949
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhDNQyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbhDNQxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:53:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13626C061574;
        Wed, 14 Apr 2021 09:53:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cu16so8571092pjb.4;
        Wed, 14 Apr 2021 09:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LA3Hvk3FicZ+MjdfGJJpEK7ZTKeROc3LH/SX5NslzB4=;
        b=c0bppo/gSuPVIyLbuL8goqiY1mzxeds09ylJcziR5iVVPPb1izfi5YhU/qK7KzjXWA
         hz+8WbtMG3NrMmvoQ5CBPx+cvmrhTMYAup+bLdlEwGE9eZ+5Won6nX/7sxBToLQRgn5e
         eRWyaM3vavLdRlXtjNS+Ic7nG8GVqLoDLanPHETMr5tNmzLsyJNe7KuITLi5rbyV1KdV
         xVF4ZtIMbPAeJU2gv28fcRoKwQ7krfOU2bQ0/seJxTJoFmvs7gu1ezB1SgTsBwkSjsBe
         KNBT6gmiW6Um+Bi+Jsslb/vgb6vu1aleI39MWYFgw2PO/W67mfXts4jY8FkM0geJElSG
         Fd3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LA3Hvk3FicZ+MjdfGJJpEK7ZTKeROc3LH/SX5NslzB4=;
        b=myJinZ6RZ++wIdGWSF5YvjQgdcwUF1AAfeMRmjL21KW6ra2n5ManXcbPLRliKOKwzF
         rA9bFQNB1iiAirsfnnLJI+IZlzWKDEF8bjVY+UA/EyWftlbriBXe5IBrFmC5DXshkroI
         +HQFO3u6nuqFJx7e/8PiAA0Jg1I95JSRc8XsIzPAMTXZNCefa3pHw3N+vKqgpt6ekzY/
         K8EIyTQCFzG/FjU0Be9WTA3ShhDl7FnNYLa3gMxA8EpDWy4aw9u3iM75ZR8VMo/TGgRb
         xQxlgT+Ihcu9xGJjuT6k2hMUTjdLt3MS/lsQxN/OTJJkYgG/EqEHqz3pf3oJWmBv+jUs
         XGIQ==
X-Gm-Message-State: AOAM5330TBnofmI7ymUsr1TId6BspRJjJqKT5vXUXsZjekClWt09OPzn
        rrQdvX0Ke8hrUbGG9aTH7mM=
X-Google-Smtp-Source: ABdhPJwgvrSU05LL7g0Hdq14kZRnmHFAcLOtv4CTrR/Pz1Fz1siUxhwo3oiPmL1LrEylAhAD3QHq1A==
X-Received: by 2002:a17:90b:1118:: with SMTP id gi24mr4504148pjb.30.1618419204613;
        Wed, 14 Apr 2021 09:53:24 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t65sm31427pfd.5.2021.04.14.09.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 09:53:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH resend net-next 0/2] Pass the BR_FDB_LOCAL information to switchdev drivers
Date:   Wed, 14 Apr 2021 19:52:54 +0300
Message-Id: <20210414165256.1837753-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Bridge FDB entries with the is_local flag are entries which are
terminated locally and not forwarded. Switchdev drivers might want to be
notified of these addresses so they can trap them. If they don't program
these entries to hardware, there is no guarantee that they will do the
right thing with these entries, and they won't be, let's say, flooded.

Ideally none of the switchdev drivers should ignore these entries, but
having access to the is_local bit is the bare minimum change that should
be done in the bridge layer, before this is even possible.

These 2 changes are extracted from the larger "RX filtering in DSA"
series:
https://patchwork.kernel.org/project/netdevbpf/patch/20210224114350.2791260-8-olteanv@gmail.com/
https://patchwork.kernel.org/project/netdevbpf/patch/20210224114350.2791260-9-olteanv@gmail.com/
and submitted separately, because they touch all switchdev drivers,
while the rest is mostly specific to DSA.

This change is not a functional one, in the sense that everybody still
ignores the local FDB entries, but this will be changed by further
patches at least for DSA.

Tobias Waldekranz (1):
  net: bridge: switchdev: refactor br_switchdev_fdb_notify

Vladimir Oltean (1):
  net: bridge: switchdev: include local flag in FDB notifications

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  4 +-
 .../marvell/prestera/prestera_switchdev.c     |  2 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  5 ++-
 drivers/net/ethernet/rocker/rocker_main.c     |  4 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  4 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  4 +-
 include/net/switchdev.h                       |  1 +
 net/bridge/br_switchdev.c                     | 44 +++++--------------
 net/dsa/slave.c                               |  2 +-
 9 files changed, 26 insertions(+), 44 deletions(-)

-- 
2.25.1

