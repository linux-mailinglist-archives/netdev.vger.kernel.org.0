Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C465525A6B
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 00:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfEUWr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 18:47:26 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35805 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfEUWr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 18:47:26 -0400
Received: by mail-pl1-f194.google.com with SMTP id p1so59854plo.2;
        Tue, 21 May 2019 15:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CotgpyzHvMKFTZ/K9lN0mdRgMD7feyc9SXYeONncL/o=;
        b=o4a5cYRy18GFiA/2I/gKRgwNPhCgij27hCMQ5jVz+doF8MVtQfcd5wXj/lCZS6OiX9
         CfHvWZRy57PtzaQmKFzYqM4yL4sil1cuGmxYoApTxCfkRbf3oD/iUaB0nbNs6UI5ZwIx
         DyERHNaf3QhF1nOhPMXSsLk80+5syIjibTz7R5FXrBAqk9owxBEFFMcq2hcY6sr5YI9X
         DnXCdJ17rwv1nOC849Mu1+dMXO19I3M0zmoUXyo69U4LHV+0ZKMjsguQ/uJbaGJYGwoo
         y9ViikeRvDX3UMMb1Ws5+ieWinHLUXEntALlsjHVeuST6wofF298Fk6oCW8tJWM+Q0dS
         8esg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CotgpyzHvMKFTZ/K9lN0mdRgMD7feyc9SXYeONncL/o=;
        b=oKaZVNA13cqA8vf7fP7hM6nL5aa50SG5Zj/6QvMGPZquRgsJ8teGfJSmPoWWaBHulI
         vMNHmLuwPKWM/iA+A6GSi1hbX7ApyG/WUikFwQt2roLoa4eI95XUWcc5Uk2Q7D6r4TyJ
         x486f781oZcksLzmnTK9Op4BABCmuMXVjIvzVMcGBIWp8ZD3kQE0xNxE2AV0D5A6hzWC
         PP0Opa3pUrU+Qe1ZtM/XGoe4PB/pMJqAjzONzHXpzcf0i25tvXz4L8l7K3VhDeb+bS6Y
         fbR9I8A9doegZm4qHmu6r7sPdJ7klKTrGh8FWP6oOk2966Hhs/2lPNYG6XY4EZ4UUiuh
         Ct3Q==
X-Gm-Message-State: APjAAAWdEkToErfqv9OwZHS7Std558ieqZUXLSKW1KB50nl2y4mO6Mdi
        pITVpYZB73wafjcR3PX6i5YAxF9j
X-Google-Smtp-Source: APXvYqwIXd0Rr3JbWRcSCnSpFyYAJ4zlDzmi4QaXNGllka+plJyS/cN3mblpxlsf3gDGP2EA90Xb1Q==
X-Received: by 2002:a17:902:4481:: with SMTP id l1mr73044372pld.121.1558478845497;
        Tue, 21 May 2019 15:47:25 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id r29sm34122419pgn.14.2019.05.21.15.47.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 15:47:24 -0700 (PDT)
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
Subject: [PATCH V3 net-next 0/6] Peer to Peer One-Step time stamping
Date:   Tue, 21 May 2019 15:47:17 -0700
Message-Id: <20190521224723.6116-1-richardcochran@gmail.com>
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
 drivers/of/of_mdio.c                               |  24 +
 drivers/ptp/Kconfig                                |  10 +
 drivers/ptp/Makefile                               |   1 +
 drivers/ptp/ptp_ines.c                             | 870 +++++++++++++++++++++
 include/linux/mii_timestamper.h                    | 116 +++
 include/linux/phy.h                                |  25 +-
 include/uapi/linux/net_tstamp.h                    |   8 +
 net/8021q/vlan_dev.c                               |   4 +-
 net/Kconfig                                        |   7 +-
 net/core/dev_ioctl.c                               |   1 +
 net/core/ethtool.c                                 |   4 +-
 net/core/timestamping.c                            |  20 +-
 20 files changed, 1289 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
 create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
 create mode 100644 drivers/net/phy/mii_timestamper.c
 create mode 100644 drivers/ptp/ptp_ines.c
 create mode 100644 include/linux/mii_timestamper.h

-- 
2.11.0

