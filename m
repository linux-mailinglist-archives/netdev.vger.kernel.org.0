Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971552D53E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfE2F6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:58:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33334 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfE2F6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 01:58:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id h17so695452pgv.0;
        Tue, 28 May 2019 22:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=orJ8ZO7tYb0c4h/BjgkxaEoMgsYs4zgzsSwG/Ejhacg=;
        b=V3ltzRXEI6Je/vbiwfHCq0y+tNk1CaP38GKlpXuoIjtb3ZFD2kQ5+JlNgeTz96mvt0
         DrHC15TE9UyEguGJYE2PN0FYeaNTfBVa+Z/8RQPwmEcS+oyEvKVmywE+vS0erBnCZvB/
         cr14QL+j7iVzZCJrhHxgHNxqE4VXJ+6IzXR9FN6ZgXTYEGQoidQGOQlmWMfsqfUyVgq3
         PK0uYguS0hu4OSdQ2FGg1MQq/ttXgXCqAtXx1FSrG17p0uei0vNsOEz9At6Z0RemB7jQ
         Grc/bs8s9rN8Geq43lAHAPmn6NzKwLwVLU04w+2lf+zV6MhhO6O0AhcZbaX7NWsZ1Bgb
         qd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=orJ8ZO7tYb0c4h/BjgkxaEoMgsYs4zgzsSwG/Ejhacg=;
        b=PMrqzeHFy0N4we6WKFIBOdVbtm+qTmNU4YPDv78ajkZSP/yhu/osQe0zBIdiJnbK4H
         faArfQ/ZmbJEeMgsHROlyR540I32fTuQ72C2GfBSud7cynrfuJfKRbmkRtNNCqd/8F1f
         BuYu7yCPLZr46t+4+FlnfiTTxJxa0aUd6zi6EifOeeK7jSTYLQHL+I6K/L33XHKxH71R
         ZG1NnP5tA1o5tCJ4JLJ1/HlVJEgI8YL1eK69KezR5wVGTQEkUCMD1wbl11W86/FAmoaY
         GVEUSCKR2TN5yOY+jejteY0XYHaZaVd+RByEye7ANBQfCa/zSeJ3VG0zZZz8Uj2CrzqQ
         aQ1Q==
X-Gm-Message-State: APjAAAXhg0YL7VyiARpPs1zZ+pGjkNOs9oUmvuBS6E4jJv0xvAC9lYA+
        9Ca9SBZalabaMtAnXXZAgfWKqwYa
X-Google-Smtp-Source: APXvYqznLFwDTHXxzdN8Q28ZLMLCKplUIo6BI1HkjcbnDrlkI+LA4XVVAeGRWtzsG/pwZIhs4uiMzA==
X-Received: by 2002:a63:1c19:: with SMTP id c25mr12394440pgc.183.1559109489952;
        Tue, 28 May 2019 22:58:09 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id w1sm19093127pfg.51.2019.05.28.22.58.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 22:58:09 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH V4 net-next 0/6] Peer to Peer One-Step time stamping
Date:   Tue, 28 May 2019 22:58:01 -0700
Message-Id: <cover.1559109076.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for PTP (IEEE 1588) P2P one-step time
stamping along with a driver for a hardware device that supports this.

If the hardware supports p2p one-step, it subtracts the ingress time
stamp value from the Pdelay_Request correction field.  The user space
software stack then simply copies the correction field into the
Pdelay_Response, and on transmission the hardware adds the egress time
stamp into the correction field.

This new functionality extends CONFIG_NETWORK_PHY_TIMESTAMPING to
cover MII snooping devices, but it still depends on phylib, just as
that option does.  Expanding beyond phylib is not within the scope of
the this series.

User space support is available in the current linuxptp master branch.

- Patch 1 adds the new option.
- Patches 2-5 add support for MII time stamping in non-PHY devices.
- Patch 6 adds a driver implementing the new option.

Thanks,
Richard

Changed in v4:
~~~~~~~~~~~~~~

- Correct error paths and PTR_ERR return values in the framework.
- Expanded KernelDoc comments WRT PHY locking.
- Pick up Andrew's review tag.

Changed in v3:
~~~~~~~~~~~~~~

- Simplify the device tree binding and document the time stamping
  phandle by itself.

Changed in v2:
~~~~~~~~~~~~~~

- Per the v1 review, changed the modeling of MII time stamping
  devices.  They are no longer a kind of mdio device.


Richard Cochran (6):
  net: Introduce peer to peer one step PTP time stamping.
  net: Introduce a new MII time stamping interface.
  net: Add a layer for non-PHY MII time stamping drivers.
  dt-bindings: ptp: Introduce MII time stamping devices.
  net: mdio: of: Register discovered MII time stampers.
  ptp: Add a driver for InES time stamping IP core.

 Documentation/devicetree/bindings/ptp/ptp-ines.txt |  35 +
 .../devicetree/bindings/ptp/timestamper.txt        |  41 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   1 +
 drivers/net/phy/Makefile                           |   2 +
 drivers/net/phy/dp83640.c                          |  47 +-
 drivers/net/phy/mii_timestamper.c                  | 121 +++
 drivers/net/phy/phy.c                              |   4 +-
 drivers/net/phy/phy_device.c                       |   5 +
 drivers/of/of_mdio.c                               |  30 +-
 drivers/ptp/Kconfig                                |  10 +
 drivers/ptp/Makefile                               |   1 +
 drivers/ptp/ptp_ines.c                             | 859 +++++++++++++++++++++
 include/linux/mii_timestamper.h                    | 120 +++
 include/linux/phy.h                                |  25 +-
 include/uapi/linux/net_tstamp.h                    |   8 +
 net/8021q/vlan_dev.c                               |   4 +-
 net/Kconfig                                        |   7 +-
 net/core/dev_ioctl.c                               |   1 +
 net/core/ethtool.c                                 |   4 +-
 net/core/timestamping.c                            |  20 +-
 20 files changed, 1287 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
 create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
 create mode 100644 drivers/net/phy/mii_timestamper.c
 create mode 100644 drivers/ptp/ptp_ines.c
 create mode 100644 include/linux/mii_timestamper.h

-- 
2.11.0

